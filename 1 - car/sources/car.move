// module refers to smart contract 
module car::car {
// Same as Importing in rust, import object from sui std library
    use sui::object::{Self, UID};
    //import transaction context from sui std library
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    // has key annotation and id, therefore this is an object 
    struct Car has key, store {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8,
    }
    
    //function to instantiate a new car object, returns car
    // for instantiation an object, we need a mutable reference to the txContext
    // this will generate the id for this car object, under the hood
    // this is not a entry funct/ otherwise it cannot return new car
    fun new(speed: u8,acceleration: u8,handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx),
            speed,
            acceleration,
            handling
        }
    }

    //Car will be created and will be transferred to the the caller
      public entry fun init(speed: u8,acceleration: u8,handling: u8, ctx: &mut TxContext) {
      
      let car = new(speed,acceleration,handling, ctx);
      transfer::public_transfer(car, tx_context::sender(ctx));
      }

    //Regular transfer is not an entry function, therefore we should have a wrapper
      public entry fun transfer(car: Car, recipient: address) {
        transfer::transfer(car, recipient);
      }

    //only read only reference 
    public fun get_stats(self: &Car): (u8, u8, u8) {
        (self.speed, self.handling, self.acceleration)
    }

    //mutable reference to the car object 
    public entry fun upgrade_speed(self: &mut Car, amount: u8) {
        self.speed = self.speed + amount;
    }

    public entry fun upgrade_acceleration(self: &mut Car, amount: u8) {
        self.acceleration = self.acceleration + amount;
    }

    public entry fun upgrade_handling(self: &mut Car, amount: u8) {
        self.handling = self.handling + amount;
    }
}