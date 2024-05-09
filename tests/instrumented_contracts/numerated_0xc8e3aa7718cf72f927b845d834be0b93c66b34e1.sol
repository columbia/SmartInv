1 pragma solidity ^0.4.4;
2 
3 
4 // ERC20 token interface is implemented only partially.
5 // Token transfer is prohibited due to spec (see PRESALE-SPEC.md),
6 // hence some functions are left undefined:
7 //  - transfer, transferFrom,
8 //  - approve, allowance.
9 
10 contract PresaleToken {
11 
12     /// @dev Constructor
13     /// @param _tokenManager Token manager address.
14     function PresaleToken(address _tokenManager, address _escrow) {
15         tokenManager = _tokenManager;
16         escrow = _escrow;
17     }
18 
19 
20     /*/
21      *  Constants
22     /*/
23 
24     string public constant name = "SONM Presale Token";
25     string public constant symbol = "SPT";
26     uint   public constant decimals = 18;
27 
28     uint public constant PRICE = 606; // 606 SPT per Ether
29 
30     //  price
31     // Cup is 10 000 ETH
32     // 1 eth = 606 presale tokens
33     // ETH price ~50$ for 28.03.2017
34     // Cup in $ is ~ 500 000$
35 
36     uint public constant TOKEN_SUPPLY_LIMIT = 606 * 10000 * (1 ether / 1 wei);
37 
38 
39 
40     /*/
41      *  Token state
42     /*/
43 
44     enum Phase {
45         Created,
46         Running,
47         Paused,
48         Migrating,
49         Migrated
50     }
51 
52     Phase public currentPhase = Phase.Created;
53     uint public totalSupply = 0; // amount of tokens already sold
54 
55     // Token manager has exclusive priveleges to call administrative
56     // functions on this contract.
57     address public tokenManager;
58 
59     // Gathered funds can be withdrawn only to escrow's address.
60     address public escrow;
61 
62     // Crowdsale manager has exclusive priveleges to burn presale tokens.
63     address public crowdsaleManager;
64 
65     mapping (address => uint256) private balance;
66 
67 
68     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
69     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
70 
71 
72     /*/
73      *  Events
74     /*/
75 
76     event LogBuy(address indexed owner, uint value);
77     event LogBurn(address indexed owner, uint value);
78     event LogPhaseSwitch(Phase newPhase);
79 
80 
81     /*/
82      *  Public functions
83     /*/
84 
85     function() payable {
86         buyTokens(msg.sender);
87     }
88 
89     /// @dev Lets buy you some tokens.
90     function buyTokens(address _buyer) public payable {
91         // Available only if presale is running.
92         if(currentPhase != Phase.Running) throw;
93 
94         if(msg.value == 0) throw;
95         uint newTokens = msg.value * PRICE;
96         if (totalSupply + newTokens > TOKEN_SUPPLY_LIMIT) throw;
97         balance[_buyer] += newTokens;
98         totalSupply += newTokens;
99         LogBuy(_buyer, newTokens);
100     }
101 
102 
103     /// @dev Returns number of tokens owned by given address.
104     /// @param _owner Address of token owner.
105     function burnTokens(address _owner) public
106         onlyCrowdsaleManager
107     {
108         // Available only during migration phase
109         if(currentPhase != Phase.Migrating) throw;
110 
111         uint tokens = balance[_owner];
112         if(tokens == 0) throw;
113         balance[_owner] = 0;
114         totalSupply -= tokens;
115         LogBurn(_owner, tokens);
116 
117         // Automatically switch phase when migration is done.
118         if(totalSupply == 0) {
119             currentPhase = Phase.Migrated;
120             LogPhaseSwitch(Phase.Migrated);
121         }
122     }
123 
124 
125     /// @dev Returns number of tokens owned by given address.
126     /// @param _owner Address of token owner.
127     function balanceOf(address _owner) constant returns (uint256) {
128         return balance[_owner];
129     }
130 
131 
132     /*/
133      *  Administrative functions
134     /*/
135 
136     function setPresalePhase(Phase _nextPhase) public
137         onlyTokenManager
138     {
139         bool canSwitchPhase
140             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
141             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
142                 // switch to migration phase only if crowdsale manager is set
143             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
144                 && _nextPhase == Phase.Migrating
145                 && crowdsaleManager != 0x0)
146             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
147                 // switch to migrated only if everyting is migrated
148             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
149                 && totalSupply == 0);
150 
151         if(!canSwitchPhase) throw;
152         currentPhase = _nextPhase;
153         LogPhaseSwitch(_nextPhase);
154     }
155 
156 
157     function withdrawEther() public
158         onlyTokenManager
159     {
160         // Available at any phase.
161         if(this.balance > 0) {
162             if(!escrow.send(this.balance)) throw;
163         }
164     }
165 
166 
167     function setCrowdsaleManager(address _mgr) public
168         onlyTokenManager
169     {
170         // You can't change crowdsale contract when migration is in progress.
171         if(currentPhase == Phase.Migrating) throw;
172         crowdsaleManager = _mgr;
173     }
174 }