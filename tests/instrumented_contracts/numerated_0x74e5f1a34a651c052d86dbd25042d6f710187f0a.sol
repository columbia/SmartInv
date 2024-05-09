1 pragma solidity ^0.4.8;
2 /// Prospectors obligation Token (OBG) - crowdfunding code for Prospectors game
3 contract ProspectorsObligationToken {
4     string public constant name = "Prospectors Obligation Token";
5     string public constant symbol = "OBG";
6     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
7 
8     uint256 public constant tokenCreationRate = 1000;
9 
10     // The funding cap in weis.
11     uint256 public constant tokenCreationCap = 1 ether * tokenCreationRate;
12     uint256 public constant tokenCreationMin = 0.5 ether * tokenCreationRate;
13 
14     uint256 public fundingStartBlock;
15     uint256 public fundingEndBlock;
16 
17     // The flag indicates if the OBG contract is in Funding state.
18     bool public funding = true;
19 
20     // Receives ETH and its own OBG endowment.
21     address public prospectors_team;
22 
23     // Has control over token migration to next version of token.
24     address public migrationMaster;
25 
26     OBGAllocation lockedAllocation;
27 
28     // The current total token supply.
29     uint256 totalTokens;
30 
31     mapping (address => uint256) balances;
32 
33     address public migrationAgent;
34     uint256 public totalMigrated;
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Migrate(address indexed _from, address indexed _to, uint256 _value);
38     event Refund(address indexed _from, uint256 _value);
39 
40     function ProspectorsObligationToken() {
41 
42         // if (_prospectors_team == 0) throw;
43         // if (_migrationMaster == 0) throw;
44         // if (_fundingStartBlock <= block.number) throw;
45         // if (_fundingEndBlock   <= _fundingStartBlock) throw;
46 
47         // lockedAllocation = new OBGAllocation(_prospectors_team);
48         // migrationMaster = _migrationMaster;
49         // prospectors_team = _prospectors_team;
50         // fundingStartBlock = _fundingStartBlock;
51         // fundingEndBlock = _fundingEndBlock;
52         
53         prospectors_team = 0xCCe6DA2086DD9348010a2813be49E58530852b46;
54         migrationMaster = 0xCCe6DA2086DD9348010a2813be49E58530852b46;
55         fundingStartBlock = block.number + 10;
56         fundingEndBlock = block.number + 30;
57         lockedAllocation = new OBGAllocation(prospectors_team);
58         
59     }
60 
61     /// @notice Transfer `_value` OBG tokens from sender's account
62     /// `msg.sender` to provided account address `_to`.
63     /// @notice This function is disabled during the funding.
64     /// @dev Required state: Operational
65     /// @param _to The address of the tokens recipient
66     /// @param _value The amount of token to be transferred
67     /// @return Whether the transfer was successful or not
68     function transfer(address _to, uint256 _value) returns (bool) {
69         // Abort if not in Operational state.
70         if (funding) throw;
71 
72         var senderBalance = balances[msg.sender];
73         if (senderBalance >= _value && _value > 0) {
74             senderBalance -= _value;
75             balances[msg.sender] = senderBalance;
76             balances[_to] += _value;
77             Transfer(msg.sender, _to, _value);
78             return true;
79         }
80         return false;
81     }
82 
83     function totalSupply() external constant returns (uint256) {
84         return totalTokens;
85     }
86 
87     function balanceOf(address _owner) external constant returns (uint256) {
88         return balances[_owner];
89     }
90 
91     // Token migration support:
92 
93     /// @notice Migrate tokens to the new token contract.
94     /// @dev Required state: Operational Migration
95     /// @param _value The amount of token to be migrated
96     function migrate(uint256 _value) external {
97         // Abort if not in Operational Migration state.
98         if (funding) throw;
99         if (migrationAgent == 0) throw;
100 
101         // Validate input value.
102         if (_value == 0) throw;
103         if (_value > balances[msg.sender]) throw;
104 
105         balances[msg.sender] -= _value;
106         totalTokens -= _value;
107         totalMigrated += _value;
108         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
109         Migrate(msg.sender, migrationAgent, _value);
110     }
111 
112     /// @notice Set address of migration target contract and enable migration
113 	/// process.
114     /// @dev Required state: Operational Normal
115     /// @dev State transition: -> Operational Migration
116     /// @param _agent The address of the MigrationAgent contract
117     function setMigrationAgent(address _agent) external {
118         // Abort if not in Operational Normal state.
119         if (funding) throw;
120         if (migrationAgent != 0) throw;
121         if (msg.sender != migrationMaster) throw;
122         migrationAgent = _agent;
123     }
124 
125     function setMigrationMaster(address _master) external {
126         if (msg.sender != migrationMaster) throw;
127         if (_master == 0) throw;
128         migrationMaster = _master;
129     }
130 
131     // Crowdfunding:
132 
133     /// @notice Create tokens when funding is active.
134     /// @dev Required state: Funding Active
135     /// @dev State transition: -> Funding Success (only if cap reached)
136     function () payable external {
137         // Abort if not in Funding Active state.
138         // The checks are split (instead of using or operator) because it is
139         // cheaper this way.
140         if (!funding) throw;
141         if (block.number < fundingStartBlock) throw;
142         if (block.number > fundingEndBlock) throw;
143 
144         // Do not allow creating 0 or more than the cap tokens.
145         if (msg.value == 0) throw;
146         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
147             throw;
148 
149         var numTokens = msg.value * tokenCreationRate;
150         totalTokens += numTokens;
151 
152         // Assign new tokens to the sender
153         balances[msg.sender] += numTokens;
154 
155         // Log token creation event
156         Transfer(0, msg.sender, numTokens);
157     }
158 
159     /// @notice Finalize crowdfunding
160     /// @dev If cap was reached or crowdfunding has ended then:
161     /// create OBG for the Prospectors Team and developer,
162     /// transfer ETH to the Prospectors Team address.
163     /// @dev Required state: Funding Success
164     /// @dev State transition: -> Operational Normal
165     function finalize() external {
166         // Abort if not in Funding Success state.
167         if (!funding) throw;
168         if ((block.number <= fundingEndBlock ||
169              totalTokens < tokenCreationMin) &&
170             totalTokens < tokenCreationCap) throw;
171 
172         // Switch to Operational state. This is the only place this can happen.
173         funding = false;
174 
175         // Create additional OBG for the Prospectors Team and developers as
176         // the 18% of total number of tokens.
177         // All additional tokens are transfered to the account controller by
178         // OBGAllocation contract which will not allow using them for 6 months.
179         uint256 percentOfTotal = 18;
180         uint256 additionalTokens =
181             totalTokens * percentOfTotal / (100 - percentOfTotal);
182         totalTokens += additionalTokens;
183         balances[lockedAllocation] += additionalTokens;
184         Transfer(0, lockedAllocation, additionalTokens);
185 
186         // Transfer ETH to the Prospectors Team address.
187         if (!prospectors_team.send(this.balance)) throw;
188     }
189 
190     /// @notice Get back the ether sent during the funding in case the funding
191     /// has not reached the minimum level.
192     /// @dev Required state: Funding Failure
193     function refund() external {
194         // Abort if not in Funding Failure state.
195         if (!funding) throw;
196         if (block.number <= fundingEndBlock) throw;
197         if (totalTokens >= tokenCreationMin) throw;
198 
199         var obgValue = balances[msg.sender];
200         if (obgValue == 0) throw;
201         balances[msg.sender] = 0;
202         totalTokens -= obgValue;
203 
204         var ethValue = obgValue / tokenCreationRate;
205         Refund(msg.sender, ethValue);
206         if (!msg.sender.send(ethValue)) throw;
207     }
208 	
209 	function kill()
210 	{
211 	    lockedAllocation.kill();
212 		suicide(prospectors_team);
213 	}
214 }
215 
216 
217 /// @title Migration Agent interface
218 contract MigrationAgent {
219     function migrateFrom(address _from, uint256 _value);
220 }
221 
222 
223 /// @title OBG Allocation - Time-locked vault of tokens allocated
224 /// to developers and Prospectors Team
225 contract OBGAllocation {
226     // Total number of allocations to distribute additional tokens among
227     // developers and the Prospectors Team. The Prospectors Team has right to 20000
228     // allocations, developers to 10000 allocations, divides among individual
229     // developers by numbers specified in  `allocations` table.
230     uint256 constant totalAllocations = 30000;
231 
232     // Addresses of developer and the Prospectors Team to allocations mapping.
233     mapping (address => uint256) allocations;
234 
235     ProspectorsObligationToken obg;
236     uint256 unlockedAt;
237 
238     uint256 tokensCreated = 0;
239 
240     function OBGAllocation(address _prospectors_team) internal {
241         obg = ProspectorsObligationToken(msg.sender);
242         unlockedAt = now + 6 * 30 days;
243 
244         // For the Prospectors Team:
245         allocations[_prospectors_team] = 30000; // 12/18 pp of 30000 allocations.
246     }
247 
248     /// @notice Allow developer to unlock allocated tokens by transferring them
249     /// from OBGAllocation to developer's address.
250     function unlock() external {
251         if (now < unlockedAt) throw;
252 
253         // During first unlock attempt fetch total number of locked tokens.
254         if (tokensCreated == 0)
255             tokensCreated = obg.balanceOf(this);
256 
257         var allocation = allocations[msg.sender];
258         allocations[msg.sender] = 0;
259         var toTransfer = tokensCreated * allocation / totalAllocations;
260 
261         // Will fail if allocation (and therefore toTransfer) is 0.
262         if (!obg.transfer(msg.sender, toTransfer)) throw;
263     }
264 	function kill()
265 	{
266 		suicide(0);
267 	}
268 }