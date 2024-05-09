# Tree Strategy

A modular way for our core capital pool (core) to deploy funds into multiple yield protocols.

![An example of a tree structure](https://cdn.programiz.com/sites/tutorial2program/files/nodes-edges_0.png)

Every node is it's own smart contract, the edges are bi-directional references. A node at the bottom only has one edge to the node above. `4` has a parent reference to `2`, `2` has a child reference to `4`.

The nodes at the bottom are the strategies, the smart contracts that interact with other protocols (e.g. Aave). Letters are used to indicate them in this document (e.g. `x`, `y`, `z`)

The other nodes (not at the bottom) always have 1 parent and 2 childs (3 edges). These contracts are called splitters and numbers are used to indicate them in this document (e.g. `1`, `2`, `3`). The purpose of these contracts is to define rules how to deposit into and withdraw from the nodes below them.

At the root of the tree there is the `MasterStrategy`, this unique node only has a single child. It's indicated by `m` in this document.

```
     m
     |
     1
     |
    / \
  2    x
 /\
y  z
```

Example of a tree strategy in this document

- A Strategy **MUST HAVE** zero childs
- A Strategy **SHOULD** hold funds
- A Strategy **MUST** return the current value it's holding using `balanceOf()`
- A Strategy **MUST** transfer tokens to core on withdraw
- A Splitter **MUST** have two childs
- A Splitter **SHOULD NOT** hold funds
- A Splitter **MUST** return the sum of the child `balanceOf()` values
- In the system the are `N` splitters, `N+1` strategies, `1` master and a total of `2N+2` nodes

## Implementation

The code in a single contract is basically split into two parts.

The first part takes care of the tree structure modularity, settings the references, allowing references to changes. This is all admin protected functionality.

The second part is the operational logic, how does the USDC flow into different strategies, how is the USDC pulled from these strategies.

## Tree structure

To mutate the tree stucture over time we expose the following functions. Keep in mind that the structure can not have any downtime while making these changes.

- `replace()` Replace the current node with another node.
- `replaceAsChild(_node)` Replace the current node with `_node` and make a parent-->child relationship with `_node`-->`old`
- `remove()` This is **Strategy only**; remove a strategy (and it's parent) from the tree structure

With these functions we are able to execute the following business logic

### Remove a strategy

```
    m
    |
    1
   / \
  y   z


    m
    |
    z
```

> changing 1 bidirectional relationship

When `remove()` is called on strategy `y`, it will

- Call `childRemoved()` on it's parent splitter `1`
- `1` will call `z` with `siblingRemoved()`
  - `z` will update it's parent from `1` to `m` (z->m)
- `1` will call `m` with `updateChild(z)`
  - `m` will update it's child from `1` to `z` (z<-m)

Both `y` and `1` will be obsolete after this process (not active in the tree)

### Add a strategy

```
    m
    |
    1
   / \
  y   z


    m
    |
    1
   / \
  y   2
     / \
    z   x
```

> changing 3 bidirectional relationships

- Deploy new splitter `2` with
  - `z` as initial child (2->z)
  - `1` as parent (2->1)
- Deploy new strategy `x` with `2` as parent (2<-x)
- Call `2` setChild(`x`) (2->x)
- Call `replaceAsChild()` on `z`
  - Will call `updateChild(2)` on `1` (2<-1)
  - Will make `2` it's parent (2<-z)

No nodes will be obsolete after this process

### Replace a strategy

```
    m
    |
    1
   / \
  y   z

    m
    |
    1
   / \
  y   x
```

> changing 1 bidirectional relationship

- Deploy new strategy `x` with `1` as parent (1<-x)
- Call `replace(x)` on `z`
  - Will call `updateChild(x)` on `1` (1->x)

Node `z` will be obsolete after this process

### Replace a splitter

```
    m
    |
    1
   / \
  y   z


    m
    |
    2
   / \
  y   z
```

> changing 3 bidirectional relationships

- Deploy new splitter `2` with
  - `z` as initial child (2->z)
  - `y` as initial child (2->y)
  - `m` as parent (2->m)
- Call `replace(2)` on `1`
  - Will `updateChild()` on `m` (2<-m)
  - Will `updateParent()` on `z` (2<-z)
  - Will `updateParent()` on `y` (2<-y)

Node `1` will be obsolete after this process

## Current implementations

There are currently 3 splitter implementations.

- `AlphaBetaSplitter` Liquidate childOne first, deposit into child with lowest balance
- `AlphaBetaEqualDepositSplitter` Liquidate childOne first, deposit into
  child with lowest balance but deposit in both child if the amount is at least `X`
- `AlphaBetaEqualDepositMaxSplitter` Liquidate childOne first, deposit into child with lowest balance but deposit in both child if the amount is at least `X` and have one child that can hold up to `Y` USDC

We have 5 strategy implementations (USDC)

- `AaveStrategy` - https://aave.com/
- `CompoundStrategy` - https://compound.finance/
- `EulerStrategy` - https://www.euler.finance/
- `MapleStrategy` - https://www.maple.finance/
- `TrueFiStrategy` - https://truefi.io/

All of these 8 implementations inherit from the `Base` contracts, which gives the implementations the right functions to fit in the tree structure.

There are 4 base contracts

- `BaseNode` The base logic for any contract in the tree structure
- `BaseMaster` The base logic for the master (single child)
- `BaseSplitter` The base logic for any splitter
- `BaseStrategy` The base logic for any strategy

![Dependency graph](https://i.imgur.com/MHlbMXR.png)

### Pausable

Splitters are **not** pausable

Strategies are pausable, only depositing into the yield protocol will be paused.

## Tests

**BaseTreeStrategy.js** - Unit testing all base tree structure related code (`/strategy/base`)

**BaseTreeStrategyIntegration.js** - Integration testing of all the base tree structure related code (`/strategy/base`)

**strategy/splitters.js** - Testing different splitter implementations

## Initial deployment setup

![Initial tree strategy](https://i.imgur.com/R4SdF14.png)

Other resources

- https://github.com/sherlock-protocol/sherlock-v2-core/issues/24
