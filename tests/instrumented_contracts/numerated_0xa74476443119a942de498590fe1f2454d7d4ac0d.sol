1 pragma solidity ^0.4.4;
2 
3 
4 /// @title Golem Network Token (GNT) - crowdfunding code for Golem Project
5 contract GolemNetworkToken {
6     string public constant name = "Golem Network Token";
7     string public constant symbol = "GNT";
8     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
9 
10     uint256 public constant tokenCreationRate = 1000;
11 
12     // The funding cap in weis.
13     uint256 public constant tokenCreationCap = 820000 ether * tokenCreationRate;
14     uint256 public constant tokenCreationMin = 150000 ether * tokenCreationRate;
15 
16     uint256 public fundingStartBlock;
17     uint256 public fundingEndBlock;
18 
19     // The flag indicates if the GNT contract is in Funding state.
20     bool public funding = true;
21 
22     // Receives ETH and its own GNT endowment.
23     address public golemFactory;
24 
25     // Has control over token migration to next version of token.
26     address public migrationMaster;
27 
28     GNTAllocation lockedAllocation;
29 
30     // The current total token supply.
31     uint256 totalTokens;
32 
33     mapping (address => uint256) balances;
34 
35     address public migrationAgent;
36     uint256 public totalMigrated;
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Migrate(address indexed _from, address indexed _to, uint256 _value);
40     event Refund(address indexed _from, uint256 _value);
41 
42     function GolemNetworkToken(address _golemFactory,
43                                address _migrationMaster,
44                                uint256 _fundingStartBlock,
45                                uint256 _fundingEndBlock) {
46 
47         if (_golemFactory == 0) throw;
48         if (_migrationMaster == 0) throw;
49         if (_fundingStartBlock <= block.number) throw;
50         if (_fundingEndBlock   <= _fundingStartBlock) throw;
51 
52         lockedAllocation = new GNTAllocation(_golemFactory);
53         migrationMaster = _migrationMaster;
54         golemFactory = _golemFactory;
55         fundingStartBlock = _fundingStartBlock;
56         fundingEndBlock = _fundingEndBlock;
57     }
58 
59     /// @notice Transfer `_value` GNT tokens from sender's account
60     /// `msg.sender` to provided account address `_to`.
61     /// @notice This function is disabled during the funding.
62     /// @dev Required state: Operational
63     /// @param _to The address of the tokens recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transfer(address _to, uint256 _value) returns (bool) {
67         // Abort if not in Operational state.
68         if (funding) throw;
69 
70         var senderBalance = balances[msg.sender];
71         if (senderBalance >= _value && _value > 0) {
72             senderBalance -= _value;
73             balances[msg.sender] = senderBalance;
74             balances[_to] += _value;
75             Transfer(msg.sender, _to, _value);
76             return true;
77         }
78         return false;
79     }
80 
81     function totalSupply() external constant returns (uint256) {
82         return totalTokens;
83     }
84 
85     function balanceOf(address _owner) external constant returns (uint256) {
86         return balances[_owner];
87     }
88 
89     // Token migration support:
90 
91     /// @notice Migrate tokens to the new token contract.
92     /// @dev Required state: Operational Migration
93     /// @param _value The amount of token to be migrated
94     function migrate(uint256 _value) external {
95         // Abort if not in Operational Migration state.
96         if (funding) throw;
97         if (migrationAgent == 0) throw;
98 
99         // Validate input value.
100         if (_value == 0) throw;
101         if (_value > balances[msg.sender]) throw;
102 
103         balances[msg.sender] -= _value;
104         totalTokens -= _value;
105         totalMigrated += _value;
106         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
107         Migrate(msg.sender, migrationAgent, _value);
108     }
109 
110     /// @notice Set address of migration target contract and enable migration
111 	/// process.
112     /// @dev Required state: Operational Normal
113     /// @dev State transition: -> Operational Migration
114     /// @param _agent The address of the MigrationAgent contract
115     function setMigrationAgent(address _agent) external {
116         // Abort if not in Operational Normal state.
117         if (funding) throw;
118         if (migrationAgent != 0) throw;
119         if (msg.sender != migrationMaster) throw;
120         migrationAgent = _agent;
121     }
122 
123     function setMigrationMaster(address _master) external {
124         if (msg.sender != migrationMaster) throw;
125         if (_master == 0) throw;
126         migrationMaster = _master;
127     }
128 
129     // Crowdfunding:
130 
131     /// @notice Create tokens when funding is active.
132     /// @dev Required state: Funding Active
133     /// @dev State transition: -> Funding Success (only if cap reached)
134     function create() payable external {
135         // Abort if not in Funding Active state.
136         // The checks are split (instead of using or operator) because it is
137         // cheaper this way.
138         if (!funding) throw;
139         if (block.number < fundingStartBlock) throw;
140         if (block.number > fundingEndBlock) throw;
141 
142         // Do not allow creating 0 or more than the cap tokens.
143         if (msg.value == 0) throw;
144         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
145             throw;
146 
147         var numTokens = msg.value * tokenCreationRate;
148         totalTokens += numTokens;
149 
150         // Assign new tokens to the sender
151         balances[msg.sender] += numTokens;
152 
153         // Log token creation event
154         Transfer(0, msg.sender, numTokens);
155     }
156 
157     /// @notice Finalize crowdfunding
158     /// @dev If cap was reached or crowdfunding has ended then:
159     /// create GNT for the Golem Factory and developer,
160     /// transfer ETH to the Golem Factory address.
161     /// @dev Required state: Funding Success
162     /// @dev State transition: -> Operational Normal
163     function finalize() external {
164         // Abort if not in Funding Success state.
165         if (!funding) throw;
166         if ((block.number <= fundingEndBlock ||
167              totalTokens < tokenCreationMin) &&
168             totalTokens < tokenCreationCap) throw;
169 
170         // Switch to Operational state. This is the only place this can happen.
171         funding = false;
172 
173         // Create additional GNT for the Golem Factory and developers as
174         // the 18% of total number of tokens.
175         // All additional tokens are transfered to the account controller by
176         // GNTAllocation contract which will not allow using them for 6 months.
177         uint256 percentOfTotal = 18;
178         uint256 additionalTokens =
179             totalTokens * percentOfTotal / (100 - percentOfTotal);
180         totalTokens += additionalTokens;
181         balances[lockedAllocation] += additionalTokens;
182         Transfer(0, lockedAllocation, additionalTokens);
183 
184         // Transfer ETH to the Golem Factory address.
185         if (!golemFactory.send(this.balance)) throw;
186     }
187 
188     /// @notice Get back the ether sent during the funding in case the funding
189     /// has not reached the minimum level.
190     /// @dev Required state: Funding Failure
191     function refund() external {
192         // Abort if not in Funding Failure state.
193         if (!funding) throw;
194         if (block.number <= fundingEndBlock) throw;
195         if (totalTokens >= tokenCreationMin) throw;
196 
197         var gntValue = balances[msg.sender];
198         if (gntValue == 0) throw;
199         balances[msg.sender] = 0;
200         totalTokens -= gntValue;
201 
202         var ethValue = gntValue / tokenCreationRate;
203         Refund(msg.sender, ethValue);
204         if (!msg.sender.send(ethValue)) throw;
205     }
206 }
207 
208 
209 /// @title Migration Agent interface
210 contract MigrationAgent {
211     function migrateFrom(address _from, uint256 _value);
212 }
213 
214 
215 /// @title GNT Allocation - Time-locked vault of tokens allocated
216 /// to developers and Golem Factory
217 contract GNTAllocation {
218     // Total number of allocations to distribute additional tokens among
219     // developers and the Golem Factory. The Golem Factory has right to 20000
220     // allocations, developers to 10000 allocations, divides among individual
221     // developers by numbers specified in  `allocations` table.
222     uint256 constant totalAllocations = 30000;
223 
224     // Addresses of developer and the Golem Factory to allocations mapping.
225     mapping (address => uint256) allocations;
226 
227     GolemNetworkToken gnt;
228     uint256 unlockedAt;
229 
230     uint256 tokensCreated = 0;
231 
232     function GNTAllocation(address _golemFactory) internal {
233         gnt = GolemNetworkToken(msg.sender);
234         unlockedAt = now + 6 * 30 days;
235 
236         // For the Golem Factory:
237         allocations[_golemFactory] = 20000; // 12/18 pp of 30000 allocations.
238 
239         // For developers:
240         allocations[0x9d3F257827B17161a098d380822fa2614FF540c8] = 2500; // 25.0% of developers' allocations (10000).
241         allocations[0xd7406E50b73972Fa4aa533a881af68B623Ba3F66] =  730; //  7.3% of developers' allocations.
242         allocations[0xd15356D05A7990dE7eC94304B0fD538e550c09C0] =  730;
243         allocations[0x3971D17B62b825b151760E2451F818BfB64489A7] =  730;
244         allocations[0x95e337d09f1bc67681b1cab7ed1125ea2bae5ca8] =  730;
245         allocations[0x0025C58dB686b8CEce05CB8c50C1858b63Aa396E] =  730;
246         allocations[0xB127FC62dE6ca30aAc9D551591daEDdeBB2eFD7A] =  630; //  6.3% of developers' allocations.
247         allocations[0x21AF2E2c240a71E9fB84e90d71c2B2AddE0D0e81] =  630;
248         allocations[0x682AA1C3b3E102ACB9c97B861d595F9fbfF0f1B8] =  630;
249         allocations[0x6edd429c77803606cBd6Bb501CC701a6CAD6be01] =  630;
250         allocations[0x5E455624372FE11b39464e93d41D1F6578c3D9f6] =  310; //  3.1% of developers' allocations.
251         allocations[0xB7c7EaD515Ca275d53e30B39D8EBEdb3F19dA244] =  138; //  1.38% of developers' allocations.
252         allocations[0xD513b1c3fe31F3Fe0b1E42aa8F55e903F19f1730] =  135; //  1.35% of developers' allocations.
253         allocations[0x70cac7f8E404EEFce6526823452e428b5Ab09b00] =  100; //  1.0% of developers' allocations.
254         allocations[0xe0d5861e7be0fac6c85ecde6e8bf76b046a96149] =  100;
255         allocations[0x17488694D2feE4377Ec718836bb9d4910E81D9Cf] =  100;
256         allocations[0xb481372086dEc3ca2FCCD3EB2f462c9C893Ef3C5] =  100;
257         allocations[0xFB6D91E69CD7990651f26a3aa9f8d5a89159fC92] =   70; //  0.7% of developers' allocations.
258         allocations[0xE2ABdAe2980a1447F445cb962f9c0bef1B63EE13] =   70;
259         allocations[0x729A5c0232712caAf365fDd03c39cb361Bd41b1C] =   70;
260         allocations[0x12FBD8fef4903f62e30dD79AC7F439F573E02697] =   70;
261         allocations[0x657013005e5cFAF76f75d03b465cE085d402469A] =   42; //  0.42% of developers' allocations.
262         allocations[0xD0AF9f75EA618163944585bF56aCA98204d0AB66] =   25; //  0.25% of developers' allocations.
263     }
264 
265     /// @notice Allow developer to unlock allocated tokens by transferring them
266     /// from GNTAllocation to developer's address.
267     function unlock() external {
268         if (now < unlockedAt) throw;
269 
270         // During first unlock attempt fetch total number of locked tokens.
271         if (tokensCreated == 0)
272             tokensCreated = gnt.balanceOf(this);
273 
274         var allocation = allocations[msg.sender];
275         allocations[msg.sender] = 0;
276         var toTransfer = tokensCreated * allocation / totalAllocations;
277 
278         // Will fail if allocation (and therefore toTransfer) is 0.
279         if (!gnt.transfer(msg.sender, toTransfer)) throw;
280     }
281 }