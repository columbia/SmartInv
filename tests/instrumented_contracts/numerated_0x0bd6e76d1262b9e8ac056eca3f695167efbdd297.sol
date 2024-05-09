1 pragma solidity ^0.4.4;
2 
3 
4 // ERC20 token interface is implemented only partially.
5 
6 //  some functions are left undefined:
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
18 
19    
20 
21     string public name = "Dobi Presale Token";
22     string public symbol = "Dobi";
23     uint   public decimals = 18;
24 
25 
26 
27     //Presale Cup is ~ 1 800 ETH
28     ///During Presale Phase : 1 eth = 17 presale tokens
29     //Presale Cup in $ is ~ 75 600$
30 
31     uint public PRICE = 17; 
32 
33     uint public TOKEN_SUPPLY_LIMIT = 30000 * (1 ether / 1 wei);
34 
35 
36 
37     
38 
39     enum Phase {
40         Created,
41         Running,
42         Paused,
43         Migrating,
44         Migrated
45     }
46 
47     Phase public currentPhase = Phase.Created;
48 
49     // amount of tokens already sold
50     uint public totalSupply = 0; 
51 
52     // Token manager has exclusive priveleges to call administrative
53     // functions on this contract.
54     address public tokenManager;
55     // Crowdsale manager has exclusive priveleges to burn presale tokens.
56     address public crowdsaleManager;
57 
58     mapping (address => uint256) private balance;
59 
60 
61     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
62     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
63 
64 
65     
66 
67     event LogBuy(address indexed owner, uint value);
68     event LogBurn(address indexed owner, uint value);
69     event LogPhaseSwitch(Phase newPhase);
70 
71 
72     
73 
74     function() payable {
75         buyTokens(msg.sender);
76     }
77 
78    
79     function buyTokens(address _buyer) public payable {
80         // Available only if presale is in progress.
81         if(currentPhase != Phase.Running) throw;
82 
83         if(msg.value == 0) throw;
84         uint newTokens = msg.value * PRICE;
85         if (totalSupply + newTokens > TOKEN_SUPPLY_LIMIT) throw;
86         balance[_buyer] += newTokens;
87         totalSupply += newTokens;
88         LogBuy(_buyer, newTokens);
89     }
90 
91 
92    
93     function burnTokens(address _owner) public
94         onlyCrowdsaleManager
95     {
96         // Available only during migration phase
97         if(currentPhase != Phase.Migrating) throw;
98 
99         uint tokens = balance[_owner];
100         if(tokens == 0) throw;
101         balance[_owner] = 0;
102         totalSupply -= tokens;
103         LogBurn(_owner, tokens);
104 
105         // Automatically switch phase when migration is done.
106         if(totalSupply == 0) {
107             currentPhase = Phase.Migrated;
108             LogPhaseSwitch(Phase.Migrated);
109         }
110     }
111 
112 
113    
114     function balanceOf(address _owner) constant returns (uint256) {
115         return balance[_owner];
116     }
117 
118 
119     
120 
121     function setPresalePhase(Phase _nextPhase) public
122         onlyTokenManager
123     {
124         bool canSwitchPhase
125             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
126             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
127                 // switch to migration phase only if crowdsale manager is set
128             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
129                 && _nextPhase == Phase.Migrating
130                 && crowdsaleManager != 0x0)
131             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
132                 // switch to migrated only if everyting is migrated
133             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
134                 && totalSupply == 0);
135 
136         if(!canSwitchPhase) throw;
137         currentPhase = _nextPhase;
138         LogPhaseSwitch(_nextPhase);
139     }
140 
141 
142     function withdrawEther() public
143         onlyTokenManager
144     {
145         // Available at any phase.
146         if(this.balance > 0) {
147             if(!tokenManager.send(this.balance)) throw;
148         }
149     }
150 
151 
152     function setCrowdsaleManager(address _mgr) public
153         onlyTokenManager
154     {
155         // You can't change crowdsale contract when migration is in progress.
156         if(currentPhase == Phase.Migrating) throw;
157         crowdsaleManager = _mgr;
158     }
159 }