// This module contains tests for the `hello_world::messenger` module.
// It's marked with `#[test_only]` to indicate that it should only be compiled and run in test environments.
#[test_only]
module hello_world::messenger_test {

    // Importing necessary modules and structs from the `sui` and `hello_world::messenger` namespaces.
    use sui::test_scenario;
    use hello_world::messenger::{Self, Messenger, Admin};

    // A test function to verify the creation of a new messenger.
    // This is where the actual test scenario is defined and executed.
    #[test]
    fun test_create() {
        // Define addresses for the owner and two users participating in the test.
        let owner = @0xA;
        let user1 = @0xB;
        let user2 = @0xC;

        // Begin a new test scenario with the specified owner.
        // This sets up the initial state and context for the test.
        let scenario_val = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        // Start a new transaction in the test scenario as the owner.
        test_scenario::next_tx(scenario, owner);
        {
            // Initialize the messenger module for testing purposes.
            // This might set up necessary state, defaults, or mock data.
            messenger::init_for_testing(test_scenario::ctx(scenario));
        };

        // Start another transaction in the test scenario as the owner.
        test_scenario::next_tx(scenario, owner);
        {
            // Take the `Admin` resource from the sender's account.
            // This resource is necessary to perform admin-specific operations.
            let admin = test_scenario::take_from_sender<Admin>(scenario);

            // Create a new messenger instance with specified details.
            // This is the core action being tested.
            messenger::create_messenger(&admin, b"Simon", b"SuiRock", user2, user1, test_scenario::ctx(scenario));

            // Assert that the creation of the messenger did not produce any unexpected results.
            // In this case, checking that no `Messenger` resource was created for the sender.
            assert!(!test_scenario::has_most_recent_for_sender<Messenger>(scenario), 0);

            // Return the `Admin` resource back to the sender's account after the operation.
            test_scenario::return_to_sender(scenario, admin);
        };

        // Start a transaction as `user2` to verify the effects of the previous operations.
        test_scenario::next_tx(scenario, user2);
        {
            // Assert that a `Messenger` resource now exists for `user2`.
            // This checks the post-condition of the messenger creation.
            assert!(test_scenario::has_most_recent_for_sender<Messenger>(scenario), 0);
        };

        // End the test scenario and clean up.
        // This typically involves reverting any changes to the state to avoid affecting other tests.
        test_scenario::end(scenario_val);
    }
}
