1 pragma solidity ^0.4.2;
2 
3 /// @title GNT Allocation - Time-locked vault of tokens allocated
4 /// to developers and Golem Factory
5 contract GNTAllocation {
6     // Total number of allocations to distribute additional tokens among
7     // developers and the Golem Factory. The Golem Factory has right to 20000
8     // allocations, developers to 10000 allocations, divides among individual
9     // developers by numbers specified in  `allocations` table.
10     uint256 constant totalAllocations = 30000;
11 
12     // Addresses of developer and the Golem Factory to allocations mapping.
13     mapping (address => uint256) allocations;
14 
15     GolemNetworkToken gnt;
16     uint256 unlockedAt;
17 
18     uint256 tokensCreated = 0;
19 
20     function GNTAllocation(address _golemFactory) internal {
21         gnt = GolemNetworkToken(msg.sender);
22         unlockedAt = now + 30 minutes;
23 
24         // For the Golem Factory:
25         allocations[_golemFactory] = 20000; // 12/18 pp of 30000 allocations.
26 
27         // For developers:
28         allocations[0x3F4e79023273E82EfcD8B204fF1778e09df1a597] = 2500; // 25.0% of developers' allocations (10000).
29         allocations[0x1A5218B6E5C49c290745552481bb0335be2fB0F4] =  730; //  7.3% of developers' allocations.
30         allocations[0x00eA32D8DAe74c01eBe293C74921DB27a6398D57] =  730;
31         allocations[0xde03] =  730;
32         allocations[0xde04] =  730;
33         allocations[0xde05] =  730;
34         allocations[0xde06] =  630; //  6.3% of developers' allocations.
35         allocations[0xde07] =  630;
36         allocations[0xde08] =  630;
37         allocations[0xde09] =  630;
38         allocations[0xde10] =  310; //  3.1% of developers' allocations.
39         allocations[0xde11] =  153; //  1.53% of developers' allocations.
40         allocations[0xde12] =  150; //  1.5% of developers' allocations.
41         allocations[0xde13] =  100; //  1.0% of developers' allocations.
42         allocations[0xde14] =  100;
43         allocations[0xde15] =  100;
44         allocations[0xde16] =   70; //  0.7% of developers' allocations.
45         allocations[0xde17] =   70;
46         allocations[0xde18] =   70;
47         allocations[0xde19] =   70;
48         allocations[0xde20] =   70;
49         allocations[0xde21] =   42; //  0.42% of developers' allocations.
50         allocations[0xde22] =   25; //  0.25% of developers' allocations.
51     }
52 
53     /// @notice Allow developer to unlock allocated tokens by transferring them
54     /// from GNTAllocation to developer's address.
55     function unlock() external {
56         if (now < unlockedAt) throw;
57 
58         // During first unlock attempt fetch total number of locked tokens.
59         if (tokensCreated == 0)
60             tokensCreated = gnt.balanceOf(this);
61 
62         var allocation = allocations[msg.sender];
63         allocations[msg.sender] = 0;
64         var toTransfer = tokensCreated * allocation / totalAllocations;
65 
66         // Will fail if allocation (and therefore toTransfer) is 0.
67         if (!gnt.transfer(msg.sender, toTransfer)) throw;
68     }
69 }
70 
71 /// @title Migration Agent interface
72 contract MigrationAgent {
73     function migrateFrom(address _from, uint256 _value);
74 }
75 
76 /// @title Golem Network Token (GNT) - crowdfunding code for Golem Project
77 contract GolemNetworkToken {
78     string public constant name = "Test Network Token";
79     string public constant symbol = "TNT";
80     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
81 
82     uint256 public constant tokenCreationRate = 1000;
83 
84     // The funding cap in weis.
85     uint256 public constant tokenCreationCap = 3 ether * tokenCreationRate;
86     uint256 public constant tokenCreationMin = 1 ether * tokenCreationRate;
87 
88     uint256 public fundingStartBlock;
89     uint256 public fundingEndBlock;
90 
91     // The flag indicates if the GNT contract is in Funding state.
92     bool public funding = true;
93 
94     // Receives ETH and its own GNT endowment.
95     address public golemFactory;
96 
97     // Has control over token migration to next version of token.
98     address public migrationMaster;
99 
100     GNTAllocation lockedAllocation;
101 
102     // The current total token supply.
103     uint256 totalTokens;
104 
105     mapping (address => uint256) balances;
106 
107     address public migrationAgent;
108     uint256 public totalMigrated;
109 
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Migrate(address indexed _from, address indexed _to, uint256 _value);
112     event Refund(address indexed _from, uint256 _value);
113 
114     function GolemNetworkToken(address _golemFactory,
115                                address _migrationMaster,
116                                uint256 _fundingStartBlock,
117                                uint256 _fundingEndBlock) {
118 
119         if (_golemFactory == 0) throw;
120         if (_migrationMaster == 0) throw;
121         if (_fundingStartBlock <= block.number) throw;
122         if (_fundingEndBlock   <= _fundingStartBlock) throw;
123 
124         lockedAllocation = new GNTAllocation(_golemFactory);
125         migrationMaster = _migrationMaster;
126         golemFactory = _golemFactory;
127         fundingStartBlock = _fundingStartBlock;
128         fundingEndBlock = _fundingEndBlock;
129     }
130 
131     /// @notice Transfer `_value` GNT tokens from sender's account
132     /// `msg.sender` to provided account address `_to`.
133     /// @notice This function is disabled during the funding.
134     /// @dev Required state: Operational
135     /// @param _to The address of the tokens recipient
136     /// @param _value The amount of token to be transferred
137     /// @return Whether the transfer was successful or not
138     function transfer(address _to, uint256 _value) returns (bool) {
139         // Abort if not in Operational state.
140         if (funding) throw;
141 
142         var senderBalance = balances[msg.sender];
143         if (senderBalance >= _value && _value > 0) {
144             senderBalance -= _value;
145             balances[msg.sender] = senderBalance;
146             balances[_to] += _value;
147             Transfer(msg.sender, _to, _value);
148             return true;
149         }
150         return false;
151     }
152 
153     function totalSupply() external constant returns (uint256) {
154         return totalTokens;
155     }
156 
157     function balanceOf(address _owner) external constant returns (uint256) {
158         return balances[_owner];
159     }
160 
161     // Token migration support:
162 
163     /// @notice Migrate tokens to the new token contract.
164     /// @dev Required state: Operational Migration
165     /// @param _value The amount of token to be migrated
166     function migrate(uint256 _value) external {
167         // Abort if not in Operational Migration state.
168         if (funding) throw;
169         if (migrationAgent == 0) throw;
170 
171         // Validate input value.
172         if (_value == 0) throw;
173         if (_value > balances[msg.sender]) throw;
174 
175         balances[msg.sender] -= _value;
176         totalTokens -= _value;
177         totalMigrated += _value;
178         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
179         Migrate(msg.sender, migrationAgent, _value);
180     }
181 
182     /// @notice Set address of migration target contract and enable migration
183 	/// process.
184     /// @dev Required state: Operational Normal
185     /// @dev State transition: -> Operational Migration
186     /// @param _agent The address of the MigrationAgent contract
187     function setMigrationAgent(address _agent) external {
188         // Abort if not in Operational Normal state.
189         if (funding) throw;
190         if (migrationAgent != 0) throw;
191         if (msg.sender != migrationMaster) throw;
192         migrationAgent = _agent;
193     }
194 
195     function setMigrationMaster(address _master) external {
196         if (msg.sender != migrationMaster) throw;
197         if (_master == 0) throw;
198         migrationMaster = _master;
199     }
200 
201     // Crowdfunding:
202 
203     /// @notice Create tokens when funding is active.
204     /// @dev Required state: Funding Active
205     /// @dev State transition: -> Funding Success (only if cap reached)
206     function create() payable external {
207         // Abort if not in Funding Active state.
208         // The checks are split (instead of using or operator) because it is
209         // cheaper this way.
210         if (!funding) throw;
211         if (block.number < fundingStartBlock) throw;
212         if (block.number > fundingEndBlock) throw;
213 
214         // Do not allow creating 0 or more than the cap tokens.
215         if (msg.value == 0) throw;
216         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
217             throw;
218 
219         var numTokens = msg.value * tokenCreationRate;
220         totalTokens += numTokens;
221 
222         // Assign new tokens to the sender
223         balances[msg.sender] += numTokens;
224 
225         // Log token creation event
226         Transfer(0, msg.sender, numTokens);
227     }
228 
229     /// @notice Finalize crowdfunding
230     /// @dev If cap was reached or crowdfunding has ended then:
231     /// create GNT for the Golem Factory and developer,
232     /// transfer ETH to the Golem Factory address.
233     /// @dev Required state: Funding Success
234     /// @dev State transition: -> Operational Normal
235     function finalize() external {
236         // Abort if not in Funding Success state.
237         if (!funding) throw;
238         if ((block.number <= fundingEndBlock ||
239              totalTokens < tokenCreationMin) &&
240             totalTokens < tokenCreationCap) throw;
241 
242         // Switch to Operational state. This is the only place this can happen.
243         funding = false;
244 
245         // Create additional GNT for the Golem Factory and developers as
246         // the 18% of total number of tokens.
247         // All additional tokens are transfered to the account controller by
248         // GNTAllocation contract which will not allow using them for 6 months.
249         uint256 percentOfTotal = 18;
250         uint256 additionalTokens =
251             totalTokens * percentOfTotal / (100 - percentOfTotal);
252         totalTokens += additionalTokens;
253         balances[lockedAllocation] += additionalTokens;
254         Transfer(0, lockedAllocation, additionalTokens);
255 
256         // Transfer ETH to the Golem Factory address.
257         if (!golemFactory.send(this.balance)) throw;
258     }
259 
260     /// @notice Get back the ether sent during the funding in case the funding
261     /// has not reached the minimum level.
262     /// @dev Required state: Funding Failure
263     function refund() external {
264         // Abort if not in Funding Failure state.
265         if (!funding) throw;
266         if (block.number <= fundingEndBlock) throw;
267         if (totalTokens >= tokenCreationMin) throw;
268 
269         var gntValue = balances[msg.sender];
270         if (gntValue == 0) throw;
271         balances[msg.sender] = 0;
272         totalTokens -= gntValue;
273 
274         var ethValue = gntValue / tokenCreationRate;
275         Refund(msg.sender, ethValue);
276         if (!msg.sender.send(ethValue)) throw;
277     }
278 }