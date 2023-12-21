module car::car_admin {

    use sui::object::{Self, UID};
    use sui::tx_context::{Self,TxContext};

    //defien what admin can do 
    struct AdminCap has key {
        id: UID
    }

    use sui::transfer;

      fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx))
    }

     struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8
    }

     fun new(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx),
            speed,
            acceleration,
            handling
        }
    }

    public entry fun create(_: &AdminCap, speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext) {
        let car = new(speed, acceleration, handling, ctx);
        transfer::transfer(car, tx_context::sender(ctx));
    }




}