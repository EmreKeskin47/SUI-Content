# Useful Commands

-   **Instantiates wallet key pair:** sui client

-   **Create project:** sui move new <PROJECT_NAME>

-   **Build:**: sui move build

-   **Test:**: sui move test

-   **Publish:**: sui client publish <PROJECT_NAME> --gas-budget 20000

| **Command**         | **Description**                                                                                                                                                                                                                               |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `active-address`    | Default address used for commands when none specified.                                                                                                                                                                                        |
| `active-env`        | Default environment used for commands when none specified.                                                                                                                                                                                    |
| `addresses`         | Obtain the Addresses managed by the client.                                                                                                                                                                                                   |
| `call`              | Call Move function.                                                                                                                                                                                                                           |
| `dynamic-field`     | Query a dynamic field by address.                                                                                                                                                                                                             |
| `envs`              | List all Sui environments.                                                                                                                                                                                                                    |
| `execute-signed-tx` | Execute a Signed Transaction. This is useful when the user prefers to sign elsewhere and use this command to execute.                                                                                                                         |
| `gas`               | Obtain all gas objects owned by the address.                                                                                                                                                                                                  |
| `help`              | Print this message or the help of the given subcommand(s).                                                                                                                                                                                    |
| `merge-coin`        | Merge two coin objects into one coin.                                                                                                                                                                                                         |
| `new-address`       | Generate new address and keypair with keypair scheme flag {ed25519 or secp256k1 or secp256r1} with optional derivation path, default to m/44'/784'/0'/0'/0' for ed25519 or m/54'/784'/0'/0/0 for secp256k1 or m/74'/784'/0'/0/0 for secp256r1 |
| `new-env`           | Add new Sui environment.                                                                                                                                                                                                                      |
| `object`            | Get object information.                                                                                                                                                                                                                       |
| `objects`           | Obtain all objects owned by the address.                                                                                                                                                                                                      |
| `pay`               | Pay SUI to recipients following specified amounts, with input coins. Length of recipients must be the same as that of amounts.                                                                                                                |
| `pay_all_sui`       | Pay all residual SUI coins to the recipient with input coins, after deducting the gas cost. The input coins also include the coin for gas payment, so no extra gas coin is required.                                                          |
| `pay_sui`           | Pay SUI coins to recipients following specified amounts, with input coins. Length of recipients must be the same as that of amounts. The input coins also include the coin for gas payment, so no extra gas coin is required.                 |
| `publish`           | Publish Move modules.                                                                                                                                                                                                                         |
| `split-coin`        | Split a coin object into multiple coins.                                                                                                                                                                                                      |
| `switch`            | Switch active address and network.                                                                                                                                                                                                            |
| `transfer`          | Transfer object.                                                                                                                                                                                                                              |
| `transfer-sui`      | Transfer SUI, and pay gas with the same SUI coin object. If amount is specified, transfers only the amount. If not specified, transfers the object.                                                                                           |
| `upgrade`           | Upgrade a Move module.                                                                                                                                                                                                                        |
| `verify-source`     | Verify local Move packages against on-chain packages, and optionally their dependencies.                                                                                                                                                      |
