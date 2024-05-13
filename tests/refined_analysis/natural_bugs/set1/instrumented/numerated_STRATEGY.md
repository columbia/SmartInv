1 # Tree Strategy
2 
3 A modular way for our core capital pool (core) to deploy funds into multiple yield protocols.
4 
5 ![An example of a tree structure](https://cdn.programiz.com/sites/tutorial2program/files/nodes-edges_0.png)
6 
7 Every node is it's own smart contract, the edges are bi-directional references. A node at the bottom only has one edge to the node above. `4` has a parent reference to `2`, `2` has a child reference to `4`.
8 
9 The nodes at the bottom are the strategies, the smart contracts that interact with other protocols (e.g. Aave). Letters are used to indicate them in this document (e.g. `x`, `y`, `z`)
10 
11 The other nodes (not at the bottom) always have 1 parent and 2 childs (3 edges). These contracts are called splitters and numbers are used to indicate them in this document (e.g. `1`, `2`, `3`). The purpose of these contracts is to define rules how to deposit into and withdraw from the nodes below them.
12 
13 At the root of the tree there is the `MasterStrategy`, this unique node only has a single child. It's indicated by `m` in this document.
14 
15 ```
16      m
17      |
18      1
19      |
20     / \
21   2    x
22  /\
23 y  z
24 ```
25 
26 Example of a tree strategy in this document
27 
28 - A Strategy **MUST HAVE** zero childs
29 - A Strategy **SHOULD** hold funds
30 - A Strategy **MUST** return the current value it's holding using `balanceOf()`
31 - A Strategy **MUST** transfer tokens to core on withdraw
32 - A Splitter **MUST** have two childs
33 - A Splitter **SHOULD NOT** hold funds
34 - A Splitter **MUST** return the sum of the child `balanceOf()` values
35 - In the system the are `N` splitters, `N+1` strategies, `1` master and a total of `2N+2` nodes
36 
37 ## Implementation
38 
39 The code in a single contract is basically split into two parts.
40 
41 The first part takes care of the tree structure modularity, settings the references, allowing references to changes. This is all admin protected functionality.
42 
43 The second part is the operational logic, how does the USDC flow into different strategies, how is the USDC pulled from these strategies.
44 
45 ## Tree structure
46 
47 To mutate the tree stucture over time we expose the following functions. Keep in mind that the structure can not have any downtime while making these changes.
48 
49 - `replace()` Replace the current node with another node.
50 - `replaceAsChild(_node)` Replace the current node with `_node` and make a parent-->child relationship with `_node`-->`old`
51 - `remove()` This is **Strategy only**; remove a strategy (and it's parent) from the tree structure
52 
53 With these functions we are able to execute the following business logic
54 
55 ### Remove a strategy
56 
57 ```
58     m
59     |
60     1
61    / \
62   y   z
63 
64 
65     m
66     |
67     z
68 ```
69 
70 > changing 1 bidirectional relationship
71 
72 When `remove()` is called on strategy `y`, it will
73 
74 - Call `childRemoved()` on it's parent splitter `1`
75 - `1` will call `z` with `siblingRemoved()`
76   - `z` will update it's parent from `1` to `m` (z->m)
77 - `1` will call `m` with `updateChild(z)`
78   - `m` will update it's child from `1` to `z` (z<-m)
79 
80 Both `y` and `1` will be obsolete after this process (not active in the tree)
81 
82 ### Add a strategy
83 
84 ```
85     m
86     |
87     1
88    / \
89   y   z
90 
91 
92     m
93     |
94     1
95    / \
96   y   2
97      / \
98     z   x
99 ```
100 
101 > changing 3 bidirectional relationships
102 
103 - Deploy new splitter `2` with
104   - `z` as initial child (2->z)
105   - `1` as parent (2->1)
106 - Deploy new strategy `x` with `2` as parent (2<-x)
107 - Call `2` setChild(`x`) (2->x)
108 - Call `replaceAsChild()` on `z`
109   - Will call `updateChild(2)` on `1` (2<-1)
110   - Will make `2` it's parent (2<-z)
111 
112 No nodes will be obsolete after this process
113 
114 ### Replace a strategy
115 
116 ```
117     m
118     |
119     1
120    / \
121   y   z
122 
123     m
124     |
125     1
126    / \
127   y   x
128 ```
129 
130 > changing 1 bidirectional relationship
131 
132 - Deploy new strategy `x` with `1` as parent (1<-x)
133 - Call `replace(x)` on `z`
134   - Will call `updateChild(x)` on `1` (1->x)
135 
136 Node `z` will be obsolete after this process
137 
138 ### Replace a splitter
139 
140 ```
141     m
142     |
143     1
144    / \
145   y   z
146 
147 
148     m
149     |
150     2
151    / \
152   y   z
153 ```
154 
155 > changing 3 bidirectional relationships
156 
157 - Deploy new splitter `2` with
158   - `z` as initial child (2->z)
159   - `y` as initial child (2->y)
160   - `m` as parent (2->m)
161 - Call `replace(2)` on `1`
162   - Will `updateChild()` on `m` (2<-m)
163   - Will `updateParent()` on `z` (2<-z)
164   - Will `updateParent()` on `y` (2<-y)
165 
166 Node `1` will be obsolete after this process
167 
168 ## Current implementations
169 
170 There are currently 3 splitter implementations.
171 
172 - `AlphaBetaSplitter` Liquidate childOne first, deposit into child with lowest balance
173 - `AlphaBetaEqualDepositSplitter` Liquidate childOne first, deposit into
174   child with lowest balance but deposit in both child if the amount is at least `X`
175 - `AlphaBetaEqualDepositMaxSplitter` Liquidate childOne first, deposit into child with lowest balance but deposit in both child if the amount is at least `X` and have one child that can hold up to `Y` USDC
176 
177 We have 5 strategy implementations (USDC)
178 
179 - `AaveStrategy` - https://aave.com/
180 - `CompoundStrategy` - https://compound.finance/
181 - `EulerStrategy` - https://www.euler.finance/
182 - `MapleStrategy` - https://www.maple.finance/
183 - `TrueFiStrategy` - https://truefi.io/
184 
185 All of these 8 implementations inherit from the `Base` contracts, which gives the implementations the right functions to fit in the tree structure.
186 
187 There are 4 base contracts
188 
189 - `BaseNode` The base logic for any contract in the tree structure
190 - `BaseMaster` The base logic for the master (single child)
191 - `BaseSplitter` The base logic for any splitter
192 - `BaseStrategy` The base logic for any strategy
193 
194 ![Dependency graph](https://i.imgur.com/MHlbMXR.png)
195 
196 ### Pausable
197 
198 Splitters are **not** pausable
199 
200 Strategies are pausable, only depositing into the yield protocol will be paused.
201 
202 ## Tests
203 
204 **BaseTreeStrategy.js** - Unit testing all base tree structure related code (`/strategy/base`)
205 
206 **BaseTreeStrategyIntegration.js** - Integration testing of all the base tree structure related code (`/strategy/base`)
207 
208 **strategy/splitters.js** - Testing different splitter implementations
209 
210 ## Initial deployment setup
211 
212 ![Initial tree strategy](https://i.imgur.com/R4SdF14.png)
213 
214 Other resources
215 
216 - https://github.com/sherlock-protocol/sherlock-v2-core/issues/24
