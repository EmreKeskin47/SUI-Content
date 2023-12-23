# Trusted Swap

## 1 - Define State

```rust
    struct Object has key, store {
        id: UID,
        scarcity: u8,
        style: u8,
    }

    struct ObjectWrapper has key {
        id: UID,
        original_owner: address,
        to_swap: Object,
        fee: Balance<SUI>,
    }
```

## 2 - Create Object

Users can create unique objects with specific characteristics (like scarcity and style) using the create_object function. These objects are then owned by the creator.

```rust
    public entry fun create_object(scarcity: u8, style: u8, ctx: &mut TxContext) {
        let object = Object {
            id: object::new(ctx),
            scarcity,
            style,
        };
        transfer::public_transfer(object, tx_context::sender(ctx))
    }
```

## 3 - Request Swap

Owners of these objects can request to swap them with others by calling request_swap. They wrap their object and a fee into an ObjectWrapper and send it to a service address (presumably controlled by the service provider or admin).

```rust
    /// Anyone owns an `Object` can request swapping their object. This object
    /// will be wrapped into `ObjectWrapper` and sent to `service_address`.
    public entry fun request_swap(object: Object, fee: Coin<SUI>, service_address: address, ctx: &mut TxContext) {
        assert!(coin::value(&fee) >= MIN_FEE, 0);
        let wrapper = ObjectWrapper {
            id: object::new(ctx),
            original_owner: tx_context::sender(ctx),
            to_swap: object,
            fee: coin::into_balance(fee),
        };
        transfer::transfer(wrapper, service_address);
    }
```

## 4 - Swap

The admin or service provider can pair up two suitable swap requests (where the objects have the same scarcity but different styles) and execute the swap using execute_swap. This function unwraps the objects, swaps them between the original owners, collects the fees, and sends the combined fee to the service provider.

```rust

   /// When the admin has two swap requests with objects that are trade-able,
    /// the admin can execute the swap and send them back to the opposite owner.
    public entry fun execute_swap(wrapper1: ObjectWrapper, wrapper2: ObjectWrapper, ctx: &mut TxContext) {
        // Only swap if their scarcity is the same and style is different.
        assert!(wrapper1.to_swap.scarcity == wrapper2.to_swap.scarcity, 0);
        assert!(wrapper1.to_swap.style != wrapper2.to_swap.style, 0);

        // Unpack both wrappers, cross send them to the other owner.
        let ObjectWrapper {
            id: id1,
            original_owner: original_owner1,
            to_swap: object1,
            fee: fee1,
        } = wrapper1;

        let ObjectWrapper {
            id: id2,
            original_owner: original_owner2,
            to_swap: object2,
            fee: fee2,
        } = wrapper2;

        // Perform the swap.
        transfer::transfer(object1, original_owner2);
        transfer::transfer(object2, original_owner1);

        // Service provider takes the fee.
        let service_address = tx_context::sender(ctx);
        balance::join(&mut fee1, fee2);
        transfer::public_transfer(coin::from_balance(fee1, ctx), service_address);

        // Effectively delete the wrapper objects.
        object::delete(id1);
        object::delete(id2);
    }
```

## Ownership Summary

-   **Before Swap Request:** The objects are owned by the users who created them.
-   **After Swap Request (Before Swap Execution):** The objects are held by the service in ObjectWrappers, with the service managing the swap process.
-   **After Swap Execution:** The objects are transferred to their new owners, completing the swap.
