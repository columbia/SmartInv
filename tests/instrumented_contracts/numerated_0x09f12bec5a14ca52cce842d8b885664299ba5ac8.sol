1 pragma solidity ^0.4.13;
2 
3 // ERC20 token interface is implemented only partially
4 // (no SafeMath is used because contract code is very simple)
5 // 
6 // Some functions left undefined:
7 //  - transfer, transferFrom,
8 //  - approve, allowance.
9 contract PresaleToken
10 {
11 /// Fields:
12     string public constant name = "Remechain Presale Token";
13     string public constant symbol = "RMC";
14     uint public constant decimals = 18;
15     uint public constant PRICE = 320;  // per 1 Ether
16 
17     //  price
18     // Cap is 1875 ETH
19     // 1 RMC = 0,0031eth
20     // ETH price ~290$ - 18.08.2017
21     uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 1875 * (1 ether / 1 wei);
22 
23     enum State{
24        Init,
25        Running,
26        Paused,
27        Migrating,
28        Migrated
29     }
30 
31     State public currentState = State.Init;
32     uint public totalSupply = 0; // amount of tokens already sold
33 
34     // Gathered funds can be withdrawn only to escrow's address.
35     address public escrow = 0;
36 
37     // Token manager has exclusive priveleges to call administrative
38     // functions on this contract.
39     address public tokenManager = 0;
40 
41     // Crowdsale manager has exclusive priveleges to burn presale tokens.
42     address public crowdsaleManager = 0;
43 
44     mapping (address => uint256) private balance;
45 
46 struct Purchase {
47       address buyer;
48       uint amount;
49     }
50    Purchase[] purchases;
51 /// Modifiers:
52     modifier onlyTokenManager()     { require(msg.sender == tokenManager); _;}
53     modifier onlyCrowdsaleManager() { require(msg.sender == crowdsaleManager); _;}
54     modifier onlyInState(State state){ require(state == currentState); _;}
55 
56 /// Events:
57     event LogBuy(address indexed owner, uint value);
58     event LogBurn(address indexed owner, uint value);
59     event LogStateSwitch(State newState);
60 
61 /// Functions:
62     /// @dev Constructor
63     /// @param _tokenManager Token manager address.
64     function PresaleToken(address _tokenManager, address _escrow) 
65     {
66         require(_tokenManager!=0);
67         require(_escrow!=0);
68 
69         tokenManager = _tokenManager;
70         escrow = _escrow;
71     }
72 
73     function buyTokens(address _buyer) public payable onlyInState(State.Running)
74     {
75        
76         require(msg.value != 0);
77         uint newTokens = msg.value * PRICE;
78        
79         require(!(totalSupply + newTokens < totalSupply));
80     
81         require(!(totalSupply + newTokens > TOKEN_SUPPLY_LIMIT));
82 
83         balance[_buyer] += newTokens;
84         totalSupply += newTokens;
85 
86         purchases[purchases.length++] = Purchase({buyer: _buyer, amount: newTokens});
87 
88         LogBuy(_buyer, newTokens);
89     }
90 
91     /// @dev Returns number of tokens owned by given address.
92     /// @param _owner Address of token owner.
93     function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)
94     {
95         uint tokens = balance[_owner];
96         require(tokens != 0);
97 
98         balance[_owner] = 0;
99         totalSupply -= tokens;
100 
101         LogBurn(_owner, tokens);
102 
103         // Automatically switch phase when migration is done.
104         if(totalSupply == 0) 
105         {
106             currentState = State.Migrated;
107             LogStateSwitch(State.Migrated);
108         }
109     }
110 
111     /// @dev Returns number of tokens owned by given address.
112     /// @param _owner Address of token owner.
113     function balanceOf(address _owner) constant returns (uint256) 
114     {
115         return balance[_owner];
116     }
117 
118     function setPresaleState(State _nextState) public onlyTokenManager
119     {
120         // Init -> Running
121         // Running -> Paused
122         // Running -> Migrating
123         // Paused -> Running
124         // Paused -> Migrating
125         // Migrating -> Migrated
126         bool canSwitchState
127              =  (currentState == State.Init && _nextState == State.Running)
128              || (currentState == State.Running && _nextState == State.Paused)
129              // switch to migration phase only if crowdsale manager is set
130              || ((currentState == State.Running || currentState == State.Paused)
131                  && _nextState == State.Migrating
132                  && crowdsaleManager != 0x0)
133              || (currentState == State.Paused && _nextState == State.Running)
134              // switch to migrated only if everyting is migrated
135              || (currentState == State.Migrating && _nextState == State.Migrated
136                  && totalSupply == 0);
137 
138         require(canSwitchState);
139 
140         currentState = _nextState;
141         LogStateSwitch(_nextState);
142     }
143 
144     function withdrawEther() public onlyTokenManager
145     {
146         if(this.balance > 0) 
147         {
148             require(escrow.send(this.balance));
149         }
150     }
151 
152 /// Setters/getters
153     function setTokenManager(address _mgr) public onlyTokenManager
154     {
155         tokenManager = _mgr;
156     }
157 
158     function setCrowdsaleManager(address _mgr) public onlyTokenManager
159     {
160         // You can't change crowdsale contract when migration is in progress.
161         require(currentState != State.Migrating);
162 
163         crowdsaleManager = _mgr;
164     }
165 
166     function getTokenManager()constant returns(address)
167     {
168         return tokenManager;
169     }
170 
171     function getCrowdsaleManager()constant returns(address)
172     {
173         return crowdsaleManager;
174     }
175 
176     function getCurrentState()constant returns(State)
177     {
178         return currentState;
179     }
180 
181     function getPrice()constant returns(uint)
182     {
183         return PRICE;
184     }
185 
186     function getTotalSupply()constant returns(uint)
187     {
188         return totalSupply;
189     }
190     function getNumberOfPurchases()constant returns(uint) {
191         return purchases.length;
192     }
193     
194     function getPurchaseAddress(uint index)constant returns(address) {
195         return purchases[index].buyer;
196     }
197     
198     function getPurchaseAmount(uint index)constant returns(uint) {
199         return purchases[index].amount;
200     }
201     // Default fallback function
202     function() payable 
203     {
204         buyTokens(msg.sender);
205     }
206 }