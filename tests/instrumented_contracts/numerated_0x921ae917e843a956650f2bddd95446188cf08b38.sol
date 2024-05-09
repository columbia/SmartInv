1 pragma solidity ^0.4.4;
2 
3 /// @title Golem Network Token (GNT) - crowdfunding code for Golem Project
4 contract GolemNetworkToken {
5     string public constant name = "Token Network Token";
6     string public constant symbol = "TNT";
7     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
8 
9     uint256 public constant tokenCreationRate = 1000;
10 
11     // The funding cap in weis.
12     uint256 public constant tokenCreationCap = 2 ether * tokenCreationRate;
13     uint256 public constant tokenCreationMin = 1 ether * tokenCreationRate;
14 
15     uint256 public fundingStartBlock;
16     uint256 public fundingEndBlock;
17 
18     // The flag indicates if the GNT contract is in Funding state.
19     bool public funding = true;
20 
21     // Receives ETH and its own GNT endowment.
22     address public golemFactory;
23 
24     // Has control over token migration to next version of token.
25     address public migrationMaster;
26 
27     GNTAllocation lockedAllocation;
28 
29     // The current total token supply.
30     uint256 totalTokens;
31 
32     mapping (address => uint256) balances;
33 
34     address public migrationAgent;
35     uint256 public totalMigrated;
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Migrate(address indexed _from, address indexed _to, uint256 _value);
39     event Refund(address indexed _from, uint256 _value);
40 
41     function GolemNetworkToken(address _golemFactory,
42                                address _migrationMaster,
43                                uint256 _fundingStartBlock,
44                                uint256 _fundingEndBlock) {
45 
46         if (_golemFactory == 0) throw;
47         if (_migrationMaster == 0) throw;
48         if (_fundingStartBlock <= block.number) throw;
49         if (_fundingEndBlock   <= _fundingStartBlock) throw;
50 
51         lockedAllocation = new GNTAllocation(_golemFactory);
52         migrationMaster = _migrationMaster;
53         golemFactory = _golemFactory;
54         fundingStartBlock = _fundingStartBlock;
55         fundingEndBlock = _fundingEndBlock;
56     }
57 
58     /// @notice Transfer `_value` GNT tokens from sender's account
59     /// `msg.sender` to provided account address `_to`.
60     /// @notice This function is disabled during the funding.
61     /// @dev Required state: Operational
62     /// @param _to The address of the tokens recipient
63     /// @param _value The amount of token to be transferred
64     /// @return Whether the transfer was successful or not
65     function transfer(address _to, uint256 _value) returns (bool) {
66         // Abort if not in Operational state.
67         if (funding) throw;
68 
69         var senderBalance = balances[msg.sender];
70         if (senderBalance >= _value && _value > 0) {
71             senderBalance -= _value;
72             balances[msg.sender] = senderBalance;
73             balances[_to] += _value;
74             Transfer(msg.sender, _to, _value);
75             return true;
76         }
77         return false;
78     }
79 
80     function totalSupply() external constant returns (uint256) {
81         return totalTokens;
82     }
83 
84     function balanceOf(address _owner) external constant returns (uint256) {
85         return balances[_owner];
86     }
87 
88     // Token migration support:
89 
90     /// @notice Migrate tokens to the new token contract.
91     /// @dev Required state: Operational Migration
92     /// @param _value The amount of token to be migrated
93     function migrate(uint256 _value) external {
94         // Abort if not in Operational Migration state.
95         if (funding) throw;
96         if (migrationAgent == 0) throw;
97 
98         // Validate input value.
99         if (_value == 0) throw;
100         if (_value > balances[msg.sender]) throw;
101 
102         balances[msg.sender] -= _value;
103         totalTokens -= _value;
104         totalMigrated += _value;
105         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
106         Migrate(msg.sender, migrationAgent, _value);
107     }
108 
109     /// @notice Set address of migration target contract and enable migration
110 	/// process.
111     /// @dev Required state: Operational Normal
112     /// @dev State transition: -> Operational Migration
113     /// @param _agent The address of the MigrationAgent contract
114     function setMigrationAgent(address _agent) external {
115         // Abort if not in Operational Normal state.
116         if (funding) throw;
117         if (migrationAgent != 0) throw;
118         if (msg.sender != migrationMaster) throw;
119         migrationAgent = _agent;
120     }
121 
122     function setMigrationMaster(address _master) external {
123         if (msg.sender != migrationMaster) throw;
124         if (_master == 0) throw;
125         migrationMaster = _master;
126     }
127 
128     // Crowdfunding:
129 
130     /// @notice Create tokens when funding is active.
131     /// @dev Required state: Funding Active
132     /// @dev State transition: -> Funding Success (only if cap reached)
133     function create() payable external {
134         // Abort if not in Funding Active state.
135         // The checks are split (instead of using or operator) because it is
136         // cheaper this way.
137         if (!funding) throw;
138         if (block.number < fundingStartBlock) throw;
139         if (block.number > fundingEndBlock) throw;
140 
141         // Do not allow creating 0 or more than the cap tokens.
142         if (msg.value == 0) throw;
143         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
144             throw;
145 
146         var numTokens = msg.value * tokenCreationRate;
147         totalTokens += numTokens;
148 
149         // Assign new tokens to the sender
150         balances[msg.sender] += numTokens;
151 
152         // Log token creation event
153         Transfer(0, msg.sender, numTokens);
154     }
155 
156     /// @notice Finalize crowdfunding
157     /// @dev If cap was reached or crowdfunding has ended then:
158     /// create GNT for the Golem Factory and developer,
159     /// transfer ETH to the Golem Factory address.
160     /// @dev Required state: Funding Success
161     /// @dev State transition: -> Operational Normal
162     function finalize() external {
163         // Abort if not in Funding Success state.
164         if (!funding) throw;
165         if ((block.number <= fundingEndBlock ||
166              totalTokens < tokenCreationMin) &&
167             totalTokens < tokenCreationCap) throw;
168 
169         // Switch to Operational state. This is the only place this can happen.
170         funding = false;
171 
172         // Create additional GNT for the Golem Factory and developers as
173         // the 18% of total number of tokens.
174         // All additional tokens are transfered to the account controller by
175         // GNTAllocation contract which will not allow using them for 6 months.
176         uint256 percentOfTotal = 18;
177         uint256 additionalTokens =
178             totalTokens * percentOfTotal / (100 - percentOfTotal);
179         totalTokens += additionalTokens;
180         balances[lockedAllocation] += additionalTokens;
181         Transfer(0, lockedAllocation, additionalTokens);
182 
183         // Transfer ETH to the Golem Factory address.
184         if (!golemFactory.send(this.balance)) throw;
185     }
186 
187     /// @notice Get back the ether sent during the funding in case the funding
188     /// has not reached the minimum level.
189     /// @dev Required state: Funding Failure
190     function refund() external {
191         // Abort if not in Funding Failure state.
192         if (!funding) throw;
193         if (block.number <= fundingEndBlock) throw;
194         if (totalTokens >= tokenCreationMin) throw;
195 
196         var gntValue = balances[msg.sender];
197         if (gntValue == 0) throw;
198         balances[msg.sender] = 0;
199         totalTokens -= gntValue;
200 
201         var ethValue = gntValue / tokenCreationRate;
202         Refund(msg.sender, ethValue);
203         if (!msg.sender.send(ethValue)) throw;
204     }
205 }
206 
207 /// @title GNT Allocation - Time-locked vault of tokens allocated 
208 /// to developers and Golem Factory
209 contract GNTAllocation {
210     // Total number of allocations to distribute additional tokens among
211     // developers and the Golem Factory. The Golem Factory has right to 20000
212     // allocations, developers to 10000 allocations, divides among individual
213     // developers by numbers specified in  `allocations` table.
214     uint256 constant totalAllocations = 30000;
215 
216     // Addresses of developer and the Golem Factory to allocations mapping.
217     mapping (address => uint256) allocations;
218 
219     GolemNetworkToken gnt;
220     uint256 unlockedAt;
221 
222     uint256 tokensCreated = 0;
223 
224     function GNTAllocation(address _golemFactory) internal {
225         gnt = GolemNetworkToken(msg.sender);
226         unlockedAt = now + 6 * 30 days;
227 
228         // For the Golem Factory:
229         allocations[_golemFactory] = 20000; // 12/18 pp of 30000 allocations.
230 
231         // For developers:
232         allocations[0xde00] = 2500; // 25.0% of developers' allocations (10000).
233         allocations[0xde01] =  730; //  7.3% of developers' allocations.
234         allocations[0xde02] =  730;
235         allocations[0xde03] =  730;
236         allocations[0xde04] =  730;
237         allocations[0xde05] =  730;
238         allocations[0xde06] =  630; //  6.3% of developers' allocations.
239         allocations[0xde07] =  630;
240         allocations[0xde08] =  630;
241         allocations[0xde09] =  630;
242         allocations[0xde10] =  310; //  3.1% of developers' allocations.
243         allocations[0xde11] =  153; //  1.53% of developers' allocations.
244         allocations[0xde12] =  150; //  1.5% of developers' allocations.
245         allocations[0xde13] =  100; //  1.0% of developers' allocations.
246         allocations[0xde14] =  100;
247         allocations[0xde15] =  100;
248         allocations[0xde16] =   70; //  0.7% of developers' allocations.
249         allocations[0xde17] =   70;
250         allocations[0xde18] =   70;
251         allocations[0xde19] =   70;
252         allocations[0xde20] =   70;
253         allocations[0xde21] =   42; //  0.42% of developers' allocations.
254         allocations[0xde22] =   25; //  0.25% of developers' allocations.
255     }
256 
257     /// @notice Allow developer to unlock allocated tokens by transferring them 
258     /// from GNTAllocation to developer's address.
259     function unlock() external {
260         if (now < unlockedAt) throw;
261 
262         // During first unlock attempt fetch total number of locked tokens.
263         if (tokensCreated == 0)
264             tokensCreated = gnt.balanceOf(this);
265 
266         var allocation = allocations[msg.sender];
267         allocations[msg.sender] = 0;
268         var toTransfer = tokensCreated * allocation / totalAllocations;
269 
270         // Will fail if allocation (and therefore toTransfer) is 0.
271         if (!gnt.transfer(msg.sender, toTransfer)) throw;
272     }
273 }
274 
275 /// @title Migration Agent interface
276 contract MigrationAgent {
277     function migrateFrom(address _from, uint256 _value);
278 }