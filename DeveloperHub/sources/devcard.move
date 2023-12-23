module devhub::devcard {
    use std::option::{Self, Option};
    use std::string::{Self, String};

    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self, Url};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    const NOT_THE_OWNER: u64 = 0;
    const INSUFFICIENT_FUNDS: u64 = 1;
    const MIN_CARD_COST: u64 = 1;

    // This structure has the necessary information for a developer to has it in his card
    // Different fields show the ability of the developer
    // This is a Sui object since we have key and id.
    struct DevCard has key, store {
        id: UID,
        name: String,
        owner: address,
        title: String,
        img_url: Url,
        description: Option<String>,
        years_of_exp: u8,
        technologies: String,
        portfolio: String,
        contact: String,
        open_to_work: bool,
    }

    // This object has the owner of the contract.
    // We are going to send the tokens to this address of the user.
    // Here we also store the cards, and will make this object shared so anyone can manipulate the cards they own
    struct DevHub has key {
        id: UID,
        owner: address,
        counter: u64,
        cards: ObjectTable<u64, DevCard>,
    }

    // This is an event
    // This event will be emitted in the create_card function
    struct CardCreated has copy, drop {
        id: ID,
        name: String,
        owner: address,
        title: String,
        contact: String,
    }

    // This is an event
    // This event will be emitted in the update_card_description function
    struct DescriptionUpdated has copy, drop {
        name: String,
        owner: address,
        new_description: String
    }


    // We are initating our contract.
    // DevHub created a shared object so that users can modify or alter their cards
    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            DevHub {
                id: object::new(ctx),
                owner: tx_context::sender(ctx),
                counter: 0,
                cards: object_table::new(ctx),
            }
        );
    }

    // This function creates new card and adds it to the table
    public entry fun create_card(
        name: vector<u8>,
        title: vector<u8>,
        img_url: vector<u8>,
        years_of_exp: u8,
        technologies: vector<u8>,
        portfolio: vector<u8>,
        contact: vector<u8>,
        payment: Coin<SUI>,
        devhub: &mut DevHub,
        ctx: &mut TxContext
    ) {
        let value = coin::value(&payment); // get the tokens transferred with the transaction
        assert!(value == MIN_CARD_COST, INSUFFICIENT_FUNDS); // check if the sent amount is correct
        transfer::public_transfer(payment, devhub.owner); // tranfer the tokens

        // Here we increase the counter before adding the card to the table
        devhub.counter = devhub.counter + 1;

        // Create new id
        // Id is created here because we are going to use it with both devcard and the event
        let id = object::new(ctx);

        // Emit the event
        event::emit(
            CardCreated { 
                id: object::uid_to_inner(&id), 
                name: string::utf8(name), 
                owner: tx_context::sender(ctx), 
                title: string::utf8(title), 
                contact: string::utf8(contact) 
            }
        );

        // Creating the new DevCard
        let devcard = DevCard {
            id: id,
            name: string::utf8(name),
            owner: tx_context::sender(ctx),
            title: string::utf8(title),
            img_url: url::new_unsafe_from_bytes(img_url),
            description: option::none(),
            years_of_exp,
            technologies: string::utf8(technologies),
            portfolio: string::utf8(portfolio),
            contact: string::utf8(contact),
            open_to_work: true,
        };

        // Adding card to the table
        object_table::add(&mut devhub.cards, devhub.counter, devcard);
    }

    // With this function the user can change his/her card's description
    public entry fun update_card_description(devhub: &mut DevHub, new_description: vector<u8>, id: u64, ctx: &mut TxContext) {
        let user_card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(tx_context::sender(ctx) == user_card.owner, NOT_THE_OWNER);
        let old_value = option::swap_or_fill(&mut user_card.description, string::utf8(new_description));

        event::emit(DescriptionUpdated {
            name: user_card.name,
            owner: user_card.owner,
            new_description: string::utf8(new_description)
        });

        //old description isn't needed anymore, it can be  discarded
        _ = old_value;
    }

    // With this function user can deactivate his/her account by setting open_to_work field of his/her card to false
    public entry fun deactivate_card(devhub: &mut DevHub, id: u64, ctx: &mut TxContext) {
        let card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(card.owner == tx_context::sender(ctx), NOT_THE_OWNER);
        card.open_to_work = false;
    }

    // This function returns the card based on the id provided
    public fun get_card_info(devhub: &DevHub, id: u64): (
        String,
        address,
        String,
        Url,
        Option<String>,
        u8,
        String,
        String,
        String,
        bool,
    ) {
        let card = object_table::borrow(&devhub.cards, id);
        (
            card.name,
            card.owner,
            card.title,
            card.img_url,
            card.description,
            card.years_of_exp,
            card.technologies,
            card.portfolio,
            card.contact,
            card.open_to_work
        )
    }
}
