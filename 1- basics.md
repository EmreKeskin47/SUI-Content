# SUI Move Basics

## Strings

Move does not have a native type for strings, but it has a wrapper

```rust
    // Use this dependency to get a type wrapper for UTF-8 strings
    use std::string::{Self, String};

    struct Name {
        id: object::new(ctx),
        name: string::utf8(name_bytes)
    }
```

## Abilities

Abilities are keywords in Sui Move that define how types behave at the compiler level. Basic ones are:

-   **copy:** value can be copied (or cloned by value)
-   **drop:** value can be dropped by the end of the scope
-   **key:** value can be used as a key for global storage operations
-   **store:** value can be stored inside global storage

## Objects

An object is a piece of data with a unique identifier (UID) and an owner address. They can be mutable or immutable depending on the use case.

### Shared vs Owned Objects

#### Owned

-   intended to be written once and then may only be read or transferred afterward. They are immutable in terms of their state (beyond ownership transfers).

-   Transactions that use only owned objects benefit from very low latency to finality, because they do not need to go through consensus.

#### Shared

-   Shared objects in Sui are mutable and can be concurrently accessed by multiple transactions.

-   Transactions that access one or more shared objects require consensus to sequence reads and written to those objects. This comes at a slightly higher gas cost and increases latency.

-   **DeFi:** in a DeFi application, a shared object might represent a liquidity pool that many users interact with simultaneously.
-   **Gaming:** In a multiplayer online game built on Sui, shared objects could represent game assets or elements of the game world that players can interact with in real-time.

Shared object is an object that is shared using a **sui::transfer::share_object** function and is accessible to everyone.

```rust
        /// A shared object. `key` ability is required.
        struct DonutShop has key {
            id: UID,
            price: u64,
            balance: Balance<SUI>
        }

        // Share the object to make it accessible to everyone!
        transfer::share_object(DonutShop {
            id: object::new(ctx),
            price: 1000,
            balance: balance::zero()
        })
```

## Functions

implemented with **"fun"** keyword, and they are private by default. Meaning that, if we want to be able access the function from another module, we need to explicity use **"public"** keyword.

### Return Value

The return type of a function is specified in the function signature after the function parameters, separated by a colon.

```rust
    public fun addition (a: u8, b: u8): u8 {
        a + b
    }
```

### Entry Functions

An entry function visibility modifier allows a function to be called directly (eg in transaction). It is combinable with other visibility modifiers, such as public which allows calling from other modules - cannot return a value

### Transaction Context

Functions called directly through a transaction typically have an instance of TxContext as the last parameter. This is a special parameter set by the Sui Move VM and does not need to be specified by the user calling the function.

```rust
    public entry fun mint(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello World!")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
```

### Init Function

Init function is a special function that gets executed only once - when the associated module is published. It always has the same signature and only one argument:

```rust
    fun init(ctx: &mut TxContext) { /* ... */ }
```

## Transfer

To make an object freely transferable, use a combination of key and store abilities are required

```rust

    /// An object with `store` can be transferred in any
    /// module without a custom transfer implementation.
    struct Wrapper<T: store> has key, store {
        id: UID,
        contents: T
    }

    /// Profile information, not an object, can be wrapped
    /// into a transferable container
    struct ProfileInfo has store {
        name: String,
        url: Url
    }

    public fun create_profile(
        name: vector<u8>, url: vector<u8>, ctx: &mut TxContext
    ) {
        // create a new container and wrap ProfileInfo into it
        let container = wrapper::create(ProfileInfo {
            name: string::utf8(name),
            url: url::new_unsafe_from_bytes(url)
        }, ctx);

        // `Wrapper` type is freely transferable
        transfer::public_transfer(container, tx_context::sender(ctx))
    }

```

## Events

Events are the main way to track actions on chain. It allow clients, such as front-end applications, to receive real-time updates about changes or specific actions that have occurred on the blockchain.

```rust
    // This is the only dependency you need for events.
    use sui::event;

    /// Buy a donut.
    public entry fun buy_donut(
        shop: &mut DonutShop, payment: &mut Coin<SUI>, ctx: &mut TxContext
    ) {
        assert!(coin::value(payment) >= shop.price, ENotEnough);

        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, shop.price);
        let id = object::new(ctx);

        balance::join(&mut shop.balance, paid);

        // Emit the event using future object's ID.
        event::emit(DonutBought { id: object::uid_to_inner(&id) });

        transfer::transfer(Donut { id }, tx_context::sender(ctx))
    }


```

**Note:** without this wrapper, we would need to implement our own transfer function, which can be seen in [this](https://examples.sui.io/basics/custom-transfer.html) example

## Capability Pattern

Capability is a pattern that allows authorizing actions with an object. One of the most common capabilities is TreasuryCap (defined in sui::coin).

```rust
    /// Type that marks Capability to create new `Item`s.
    struct AdminCap has key { id: UID }

    /// The entry function can not be called if `AdminCap` is not passed as
    /// the first argument. Hence only owner of the `AdminCap` can perform
    /// this action.
    public entry fun create_and_send(
        _: &AdminCap, name: vector<u8>, to: address, ctx: &mut TxContext
    ) {
        transfer::transfer(Item {
            id: object::new(ctx),
            name: string::utf8(name)
        }, to)
    }
```

## Useful Links

-   https://examples.sui.io/basics/index.html
-   https://github.com/sui-foundation/sui-move-intro-course/tree/main
