1 pragma solidity ^0.4.4;
2 
3 
4 /// @title Golem Network Token (GNT) - crowdfunding code for Golem Project
5 contract GolemNetworkToken {
6     string public constant name = "BobbieCoin";
7     string public constant symbol = "BOBBIE";
8     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
9 
10     uint256 public constant tokenCreationRate = 1000000000;
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
48         if (_fundingEndBlock   <= _fundingStartBlock) throw;
49 
50         migrationMaster = _migrationMaster;
51         golemFactory = _golemFactory;
52         fundingStartBlock = _fundingStartBlock;
53         fundingEndBlock = _fundingEndBlock;
54                 // For the Golem Factory:
55         balances[_golemFactory] = 1000000000; // 12/18 pp of 30000 allocations.
56 
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
67 
68         var senderBalance = balances[msg.sender];
69         if (senderBalance >= _value && _value > 0) {
70             senderBalance -= _value;
71             balances[msg.sender] = senderBalance;
72             balances[_to] += _value;
73             Transfer(msg.sender, _to, _value);
74             return true;
75         }
76         return false;
77     }
78 
79     function totalSupply() external constant returns (uint256) {
80         return totalTokens;
81     }
82 
83     function balanceOf(address _owner) external constant returns (uint256) {
84         return balances[_owner];
85     }
86 
87     // Token migration support:
88 
89     /// @notice Migrate tokens to the new token contract.
90     /// @dev Required state: Operational Migration
91     /// @param _value The amount of token to be migrated
92     function migrate(uint256 _value) external {
93         // Abort if not in Operational Migration state.
94         if (funding) throw;
95         if (migrationAgent == 0) throw;
96 
97         // Validate input value.
98         if (_value == 0) throw;
99         if (_value > balances[msg.sender]) throw;
100 
101         balances[msg.sender] -= _value;
102         totalTokens -= _value;
103         totalMigrated += _value;
104         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
105         Migrate(msg.sender, migrationAgent, _value);
106     }
107 
108     /// @notice Set address of migration target contract and enable migration
109     /// process.
110     /// @dev Required state: Operational Normal
111     /// @dev State transition: -> Operational Migration
112     /// @param _agent The address of the MigrationAgent contract
113     function setMigrationAgent(address _agent) external {
114         // Abort if not in Operational Normal state.
115         if (funding) throw;
116         if (migrationAgent != 0) throw;
117         if (msg.sender != migrationMaster) throw;
118         migrationAgent = _agent;
119     }
120 
121     function setMigrationMaster(address _master) external {
122         if (msg.sender != migrationMaster) throw;
123         if (_master == 0) throw;
124         migrationMaster = _master;
125     }
126 
127     // Crowdfunding:
128 
129     /// @notice Create tokens when funding is active.
130     /// @dev Required state: Funding Active
131     /// @dev State transition: -> Funding Success (only if cap reached)
132     function () payable external {
133         // Abort if not in Funding Active state.
134         // The checks are split (instead of using or operator) because it is
135         // cheaper this way.
136         if (!funding) throw;
137         if (block.number < fundingStartBlock) throw;
138         if (block.number > fundingEndBlock) throw;
139 
140         // Do not allow creating 0 or more than the cap tokens.
141         if (msg.value == 0) throw;
142         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
143             throw;
144         if (!migrationMaster.send(msg.value)) throw;
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
171     }
172 
173     /// @notice Get back the ether sent during the funding in case the funding
174     /// has not reached the minimum level.
175     /// @dev Required state: Funding Failure
176     function refund() external {
177         // Abort if not in Funding Failure state.
178         if (!funding) throw;
179         if (block.number <= fundingEndBlock) throw;
180         if (totalTokens >= tokenCreationMin) throw;
181 
182         var gntValue = balances[msg.sender];
183         if (gntValue == 0) throw;
184         balances[msg.sender] = 0;
185         totalTokens -= gntValue;
186 
187         var ethValue = gntValue / tokenCreationRate;
188         Refund(msg.sender, ethValue);
189         if (!msg.sender.send(ethValue)) throw;
190     }
191 }
192 
193 
194 /// @title Migration Agent interface
195 contract MigrationAgent {
196     function migrateFrom(address _from, uint256 _value);
197 }