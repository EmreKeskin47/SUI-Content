### Causal history

Causal history is the relationship between an object in Sui and its direct predecessors and successors. This history is essential to the causal order Sui uses to process transactions. In contrast, other blockchains read the entire state of their world for each transaction, introducing latency.

### Causal order

Causal order is a representation of the relationship between transactions and the objects they produce, laid out as dependencies. Validators cannot execute a transaction dependent on objects created by a prior transaction that has not finished. Rather than total order, Sui uses causal order (a partial order).

### Certificate

A certificate is the mechanism proving a transaction was approved or certified. Validators vote on transactions, and aggregators collect a Byzantine-resistant-majority of these votes into a certificate and broadcasts it to all Sui validators, thereby ensuring finality.

### Epoch

Operation of the Sui network is temporally partitioned into non-overlapping, fixed-duration epochs. During a particular epoch, the set of validators participating in the network is fixed.

### Eventual consistency

Eventual consistency is the consensus model employed by Sui; if one honest validator certifies the transaction, all of the other honest validators will too eventually.

### Finality

Finality is the assurance a transaction will not be revoked. This stage is considered closure for an exchange or other blockchain transaction.

### Genesis

Genesis is the initial act of creating accounts and gas objects for a Sui network. Sui provides a `genesis` command that allows users to create and inspect the genesis object setting up the network for operation.

### Multi-writer objects

Multi-writer objects are objects that are owned by more than one address. Transactions affecting multi-writer objects require consensus in Sui. This contrasts with transactions affecting only single-writer objects, which require only a confirmation of the owner’s address contents.

### Object

The basic unit of storage in Sui is object. In contrast to many other blockchains, where storage is centered around address and each address contains a key-value store, Sui's storage is centered around objects. Sui objects have one of the following primary states:

-   _Immutable_ - the object cannot be modified.
-   _Mutable_ - the object can be changed.

Further, mutable objects are divided into these categories:

-   _Owned_ - the object can be modified only by its owner.
-   _Shared_ - the object can be modified by anyone.

Immutable objects do not need this distinction because they have no owner.

### Proof-of-stake

Proof-of-stake is a blockchain consensus mechanism where the voting weights of validators or validators is proportional to a bonded amount of the network's native currency (called their stake in the network). This mitigates [Sybil attacks](https://en.wikipedia.org/wiki/Sybil_attack) by forcing bad actors to gain a large stake in the blockchain first.

### Single-writer objects

Single-writer objects are owned by one address. In Sui, transactions affecting only single-writer objects owned by the same address may proceed with only a verification of the sender’s address, greatly speeding transaction times. These are _simple transactions_. See [Single-Writer Apps](https://docs.sui.io/learn/single-writer-apps) for example applications of this simple transaction model.

### Smart contract

A smart contract is an agreement based upon the protocol for conducting transactions in a blockchain. In Sui, smart contracts are written in the [Move](https://github.com/MystenLabs/awesome-move) programming language.

### Total order

Total order refers to the ordered presentation of the history of all transactions processed by a traditional blockchain up to a given time. This is maintained by many blockchain systems, as the only way to process transactions. In contrast, Sui uses a causal (partial) order wherever possible and safe.

For more information, see [Causal order vs total order](https://docs.sui.io/learn/sui-compared#causal-order-vs-total-order).

### Transaction

A transaction in Sui is a change to the blockchain. This may be a _simple transaction_ affecting only single-writer, single-address objects, such as minting an NFT or transferring an NFT or another token. These transactions may bypass the consensus protocol in Sui.

More _complex transactions_ affecting objects that are shared or owned by multiple addresses, such as asset management and other DeFi use cases, go through the [Narwhal and Bullshark](https://github.com/MystenLabs/sui/tree/main/narwhal) DAG-based mempool and efficient Byzantine Fault Tolerant (BFT) consensus.

### Transfer

A transfer is switching the owner address of a token to a new one via command in Sui. This is accomplished via the [Sui CLI client](https://docs.sui.io/build/cli-client) command line interface. It is one of the more common of many commands available in the CLI client.

For more information, see [Transferring objects](https://docs.sui.io/build/cli-client#transferring-objects).

### Validator

A validator in Sui plays a passive role analogous to the more active role of validators and minors in other blockchains. In Sui, validators do not continuously participate in the consensus protocol but are called into action only when receiving a transaction or certificate.
