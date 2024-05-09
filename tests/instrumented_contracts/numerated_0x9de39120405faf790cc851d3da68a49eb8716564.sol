1 pragma solidity ^0.4.4;
2 
3 
4 // ERC20 token interface is implemented only partially.
5 
6 //  some functions are not implemented undefined:
7 //  - transfer, transferFrom,
8 //  - approve, allowance.
9 // hence  an economical incentive to increase the value of the token, and investors protection from the risk of immediate token dumping following ICO
10 
11 contract PresaleToken {
12 
13     
14     function PresaleToken(address _tokenManager) {
15         tokenManager = _tokenManager;
16     }
17 
18     string public name = "DOBI Presale Token";
19     string public symbol = "DOBI";
20     uint   public decimals = 18;
21 
22     //Presale Cup is ~ 1 800 ETH
23     ///During Presale Phase : 1 eth = 17 presale tokens
24     //Presale Cup in $ is ~ 75 600$
25 
26     uint public PRICE = 17; 
27 
28     uint public TOKEN_SUPPLY_LIMIT = 30000 * (1 ether / 1 wei);
29 
30     enum Phase {
31         Created,
32         Running,
33         Paused,
34         Migrating,
35         Migrated
36     }
37 
38     Phase public currentPhase = Phase.Created;
39 
40     // amount of tokens already sold
41     uint public totalSupply = 0; 
42 
43     // Token manager has exclusive priveleges to call administrative
44     // functions on this contract.
45     address public tokenManager;
46     // Crowdsale manager has exclusive priveleges to burn presale tokens.
47     address public crowdsaleManager;
48 
49     mapping (address => uint256) private balance;
50 
51     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
52     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
53     
54 
55     event LogBuy(address indexed owner, uint value);
56     event LogBurn(address indexed owner, uint value);
57     event LogPhaseSwitch(Phase newPhase);
58     
59 
60     function() payable {
61         buyTokens(msg.sender);
62     }
63 
64    
65     function buyTokens(address _buyer) public payable {
66         // Available only if presale is in progress.
67         if(currentPhase != Phase.Running) throw;
68 
69         if(msg.value == 0) throw;
70         uint newTokens = msg.value * PRICE;
71         if (totalSupply + newTokens > TOKEN_SUPPLY_LIMIT) throw;
72         balance[_buyer] += newTokens;
73         totalSupply += newTokens;
74         LogBuy(_buyer, newTokens);
75     }
76 
77 
78    
79     function burnTokens(address _owner) public
80         onlyCrowdsaleManager
81     {
82         // Available only during migration phase
83         if(currentPhase != Phase.Migrating) throw;
84 
85         uint tokens = balance[_owner];
86         if(tokens == 0) throw;
87         balance[_owner] = 0;
88         totalSupply -= tokens;
89         LogBurn(_owner, tokens);
90 
91         // Automatically switch phase when migration is done.
92         if(totalSupply == 0) {
93             currentPhase = Phase.Migrated;
94             LogPhaseSwitch(Phase.Migrated);
95         }
96     }
97 
98 
99    
100     function balanceOf(address _owner) constant returns (uint256) {
101         return balance[_owner];
102     }
103 
104 
105     
106 
107     function setPresalePhase(Phase _nextPhase) public
108         onlyTokenManager
109     {
110         bool canSwitchPhase
111             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
112             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
113                 // switch to migration phase only if crowdsale manager is set
114             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
115                 && _nextPhase == Phase.Migrating
116                 && crowdsaleManager != 0x0)
117             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
118                 // switch to migrated only if everyting is migrated
119             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
120                 && totalSupply == 0);
121 
122         if(!canSwitchPhase) throw;
123         currentPhase = _nextPhase;
124         LogPhaseSwitch(_nextPhase);
125     }
126 
127 
128     function withdrawEther() public
129         onlyTokenManager
130     {
131         // Available at any phase.
132         if(this.balance > 0) {
133             if(!tokenManager.send(this.balance)) throw;
134         }
135     }
136 
137 
138     function setCrowdsaleManager(address _mgr) public
139         onlyTokenManager
140     {
141         // You can't change crowdsale contract when migration is in progress.
142         if(currentPhase == Phase.Migrating) throw;
143         crowdsaleManager = _mgr;
144     }
145 }