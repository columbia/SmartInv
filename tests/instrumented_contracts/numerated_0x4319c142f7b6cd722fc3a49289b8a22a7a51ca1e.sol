1 pragma solidity ^0.4.4;
2 
3 /// @title Migration Agent interface
4 contract MigrationAgent {
5     function migrateFrom(address _from, uint256 _value);
6 }
7 
8 /// @title Golem Network Token (GNT) - crowdfunding code for Golem Project
9 contract GolemNetworkToken {
10     string public constant name = "Golem Network Token";
11     string public constant symbol = "GNT";
12     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
13 
14     uint256 public constant tokenCreationRate = 1000;
15 
16     // The funding cap in weis.
17     uint256 public constant tokenCreationCap = 820000 ether * tokenCreationRate;
18     uint256 public constant tokenCreationMin = 150000 ether * tokenCreationRate;
19 
20     uint256 public fundingStartBlock;
21     uint256 public fundingEndBlock;
22 
23     // The flag indicates if the GNT contract is in Funding state.
24     bool public funding = true;
25 
26     // Receives ETH and its own GNT endowment.
27     address public golemFactory;
28 
29     // Has control over token migration to next version of token.
30     address public migrationMaster;
31 
32     GNTAllocation lockedAllocation;
33 
34     // The current total token supply.
35     uint256 totalTokens;
36 
37     mapping (address => uint256) balances;
38 
39     address public migrationAgent;
40     uint256 public totalMigrated;
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Migrate(address indexed _from, address indexed _to, uint256 _value);
44     event Refund(address indexed _from, uint256 _value);
45 
46     function GolemNetworkToken(address _golemFactory,
47                                address _migrationMaster,
48                                uint256 _fundingStartBlock,
49                                uint256 _fundingEndBlock) {
50 
51         if (_golemFactory == 0) throw;
52         if (_migrationMaster == 0) throw;
53         if (_fundingStartBlock <= block.number) throw;
54         if (_fundingEndBlock   <= _fundingStartBlock) throw;
55 
56         lockedAllocation = new GNTAllocation(_golemFactory);
57         migrationMaster = _migrationMaster;
58         golemFactory = _golemFactory;
59         fundingStartBlock = _fundingStartBlock;
60         fundingEndBlock = _fundingEndBlock;
61     }
62 
63     /// @notice Transfer `_value` GNT tokens from sender's account
64     /// `msg.sender` to provided account address `_to`.
65     /// @notice This function is disabled during the funding.
66     /// @dev Required state: Operational
67     /// @param _to The address of the tokens recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transfer(address _to, uint256 _value) returns (bool) {
71         // Abort if not in Operational state.
72         if (funding) throw;
73 
74         var senderBalance = balances[msg.sender];
75         if (senderBalance >= _value && _value > 0) {
76             senderBalance -= _value;
77             balances[msg.sender] = senderBalance;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             return true;
81         }
82         return false;
83     }
84 
85     function totalSupply() external constant returns (uint256) {
86         return totalTokens;
87     }
88 
89     function balanceOf(address _owner) external constant returns (uint256) {
90         return balances[_owner];
91     }
92 
93     // Token migration support:
94 
95     /// @notice Migrate tokens to the new token contract.
96     /// @dev Required state: Operational Migration
97     /// @param _value The amount of token to be migrated
98     function migrate(uint256 _value) external {
99         // Abort if not in Operational Migration state.
100         if (funding) throw;
101         if (migrationAgent == 0) throw;
102 
103         // Validate input value.
104         if (_value == 0) throw;
105         if (_value > balances[msg.sender]) throw;
106 
107         balances[msg.sender] -= _value;
108         totalTokens -= _value;
109         totalMigrated += _value;
110         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
111         Migrate(msg.sender, migrationAgent, _value);
112     }
113 
114     /// @notice Set address of migration target contract and enable migration
115 	/// process.
116     /// @dev Required state: Operational Normal
117     /// @dev State transition: -> Operational Migration
118     /// @param _agent The address of the MigrationAgent contract
119     function setMigrationAgent(address _agent) external {
120         // Abort if not in Operational Normal state.
121         if (funding) throw;
122         if (migrationAgent != 0) throw;
123         if (msg.sender != migrationMaster) throw;
124         migrationAgent = _agent;
125     }
126 
127     function setMigrationMaster(address _master) external {
128         if (msg.sender != migrationMaster) throw;
129         if (_master == 0) throw;
130         migrationMaster = _master;
131     }
132 
133     // Crowdfunding:
134 
135     /// @notice Create tokens when funding is active.
136     /// @dev Required state: Funding Active
137     /// @dev State transition: -> Funding Success (only if cap reached)
138     function create() payable external {
139         // Abort if not in Funding Active state.
140         // The checks are split (instead of using or operator) because it is
141         // cheaper this way.
142         if (!funding) throw;
143         if (block.number < fundingStartBlock) throw;
144         if (block.number > fundingEndBlock) throw;
145 
146         // Do not allow creating 0 or more than the cap tokens.
147         if (msg.value == 0) throw;
148         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
149             throw;
150 
151         var numTokens = msg.value * tokenCreationRate;
152         totalTokens += numTokens;
153 
154         // Assign new tokens to the sender
155         balances[msg.sender] += numTokens;
156 
157         // Log token creation event
158         Transfer(0, msg.sender, numTokens);
159     }
160 
161     /// @notice Finalize crowdfunding
162     /// @dev If cap was reached or crowdfunding has ended then:
163     /// create GNT for the Golem Factory and developer,
164     /// transfer ETH to the Golem Factory address.
165     /// @dev Required state: Funding Success
166     /// @dev State transition: -> Operational Normal
167     function finalize() external {
168         // Abort if not in Funding Success state.
169         if (!funding) throw;
170         if ((block.number <= fundingEndBlock ||
171              totalTokens < tokenCreationMin) &&
172             totalTokens < tokenCreationCap) throw;
173 
174         // Switch to Operational state. This is the only place this can happen.
175         funding = false;
176 
177         // Create additional GNT for the Golem Factory and developers as
178         // the 18% of total number of tokens.
179         // All additional tokens are transfered to the account controller by
180         // GNTAllocation contract which will not allow using them for 6 months.
181         uint256 percentOfTotal = 18;
182         uint256 additionalTokens =
183             totalTokens * percentOfTotal / (100 - percentOfTotal);
184         totalTokens += additionalTokens;
185         balances[lockedAllocation] += additionalTokens;
186         Transfer(0, lockedAllocation, additionalTokens);
187 
188         // Transfer ETH to the Golem Factory address.
189         if (!golemFactory.send(this.balance)) throw;
190     }
191 
192     /// @notice Get back the ether sent during the funding in case the funding
193     /// has not reached the minimum level.
194     /// @dev Required state: Funding Failure
195     function refund() external {
196         // Abort if not in Funding Failure state.
197         if (!funding) throw;
198         if (block.number <= fundingEndBlock) throw;
199         if (totalTokens >= tokenCreationMin) throw;
200 
201         var gntValue = balances[msg.sender];
202         if (gntValue == 0) throw;
203         balances[msg.sender] = 0;
204         totalTokens -= gntValue;
205 
206         var ethValue = gntValue / tokenCreationRate;
207         Refund(msg.sender, ethValue);
208         if (!msg.sender.send(ethValue)) throw;
209     }
210 }
211 
212 /// @title GNT Allocation - Time-locked vault of tokens allocated
213 /// to developers and Golem Factory
214 contract GNTAllocation {
215     // Total number of allocations to distribute additional tokens among
216     // developers and the Golem Factory. The Golem Factory has right to 20000
217     // allocations, developers to 10000 allocations, divides among individual
218     // developers by numbers specified in  `allocations` table.
219     uint256 constant totalAllocations = 30000;
220 
221     // Addresses of developer and the Golem Factory to allocations mapping.
222     mapping (address => uint256) allocations;
223 
224     GolemNetworkToken gnt;
225     uint256 unlockedAt;
226 
227     uint256 tokensCreated = 0;
228 
229     function GNTAllocation(address _golemFactory) internal {
230         gnt = GolemNetworkToken(msg.sender);
231         unlockedAt = now + 6 * 30 days;
232 
233         // For the Golem Factory:
234         allocations[_golemFactory] = 20000; // 12/18 pp of 30000 allocations.
235 
236         // For developers:
237         allocations[0x9d3F257827B17161a098d380822fa2614FF540c8] = 2500; // 25.0% of developers' allocations (10000).
238         allocations[0xd7406E50b73972Fa4aa533a881af68B623Ba3F66] =  730; //  7.3% of developers' allocations.
239         allocations[0xd15356D05A7990dE7eC94304B0fD538e550c09C0] =  730;
240         allocations[0x3971D17B62b825b151760E2451F818BfB64489A7] =  730;
241         allocations[0x95e337d09f1bc67681b1cab7ed1125ea2bae5ca8] =  730;
242         allocations[0x0025C58dB686b8CEce05CB8c50C1858b63Aa396E] =  730;
243         allocations[0xB127FC62dE6ca30aAc9D551591daEDdeBB2eFD7A] =  630; //  6.3% of developers' allocations.
244         allocations[0x21AF2E2c240a71E9fB84e90d71c2B2AddE0D0e81] =  630;
245         allocations[0x682AA1C3b3E102ACB9c97B861d595F9fbfF0f1B8] =  630;
246         allocations[0x6edd429c77803606cBd6Bb501CC701a6CAD6be01] =  630;
247         allocations[0x5E455624372FE11b39464e93d41D1F6578c3D9f6] =  310; //  3.1% of developers' allocations.
248         allocations[0xB7c7EaD515Ca275d53e30B39D8EBEdb3F19dA244] =  138; //  1.38% of developers' allocations.
249         allocations[0xD513b1c3fe31F3Fe0b1E42aa8F55e903F19f1730] =  135; //  1.35% of developers' allocations.
250         allocations[0x70cac7f8E404EEFce6526823452e428b5Ab09b00] =  100; //  1.0% of developers' allocations.
251         allocations[0xe0d5861e7be0fac6c85ecde6e8bf76b046a96149] =  100;
252         allocations[0x17488694D2feE4377Ec718836bb9d4910E81D9Cf] =  100;
253         allocations[0xb481372086dEc3ca2FCCD3EB2f462c9C893Ef3C5] =  100;
254         allocations[0xFB6D91E69CD7990651f26a3aa9f8d5a89159fC92] =   70; //  0.7% of developers' allocations.
255         allocations[0xE2ABdAe2980a1447F445cb962f9c0bef1B63EE13] =   70;
256         allocations[0x729A5c0232712caAf365fDd03c39cb361Bd41b1C] =   70;
257         allocations[0x12FBD8fef4903f62e30dD79AC7F439F573E02697] =   70;
258         allocations[0x657013005e5cFAF76f75d03b465cE085d402469A] =   42; //  0.42% of developers' allocations.
259         allocations[0xD0AF9f75EA618163944585bF56aCA98204d0AB66] =   25; //  0.25% of developers' allocations.
260     }
261 
262     /// @notice Allow developer to unlock allocated tokens by transferring them
263     /// from GNTAllocation to developer's address.
264     function unlock() external {
265         if (now < unlockedAt) throw;
266 
267         // During first unlock attempt fetch total number of locked tokens.
268         if (tokensCreated == 0)
269             tokensCreated = gnt.balanceOf(this);
270 
271         var allocation = allocations[msg.sender];
272         allocations[msg.sender] = 0;
273         var toTransfer = tokensCreated * allocation / totalAllocations;
274 
275         // Will fail if allocation (and therefore toTransfer) is 0.
276         if (!gnt.transfer(msg.sender, toTransfer)) throw;
277     }
278 }