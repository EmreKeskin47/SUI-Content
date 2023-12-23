module hello_world::messenger {
    use std::string::{Self, String};
    use sui::object::{Self,UID};

    struct Messenger has key, store {
        id: UID,
        name: String,
        message: String,
        from: address,
        to: address,
    }

    struct Admin has key {
        id: UID,
    }

    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    fun init(ctx: &mut TxContext){
        transfer::transfer(Admin {id: object::new(ctx)}, tx_context::sender(ctx));
    }

    //Admin creates message from (from address) to (to adddress)
    // _:&Admin, checks if the sender is admin
    public entry fun create_messenger(_:&Admin,name: vector<u8>, message:vector<u8>,to:address, from:address, ctx: &mut TxContext) {        
        let messenger = Messenger {
            id: object::new(ctx),
            name: string::utf8(name),
            message: string::utf8(message),
            from,
            to
        };
        transfer::transfer(messenger,to);
    }

    #[test_only]
    // Not public by default
    public fun init_for_testing(ctx: &mut TxContext){
        init(ctx);
    }

}