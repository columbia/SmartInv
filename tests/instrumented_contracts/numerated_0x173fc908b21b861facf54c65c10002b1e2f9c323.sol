1 pragma solidity ^0.4.4;
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
12     string public constant name = "WealthMan Private Presale Token";
13     string public constant symbol = "AWM";
14     uint public constant decimals = 18;
15     uint public constant PRICE = 2250;  // per 1 Ether
16 
17     //  price
18     // Cap is 2000 ETH
19     // 1 eth = 2250 presale WealthMan tokens
20     // ETH price ~300$ - 20.08.2017
21     uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 2000 * (1 ether / 1 wei);
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
46     struct Purchase {
47         address buyer;
48         uint amount;
49     }
50     Purchase[] purchases;
51     
52 /// Modifiers:
53     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
54     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
55     modifier onlyInState(State state){ if(state != currentState) throw; _; }
56 
57 /// Events:
58     event LogBuy(address indexed owner, uint value);
59     event LogBurn(address indexed owner, uint value);
60     event LogStateSwitch(State newState);
61 
62 /// Functions:
63     /// @dev Constructor
64     /// @param _tokenManager Token manager address.
65     function PresaleToken(address _tokenManager, address _escrow) 
66     {
67         if(_tokenManager==0) throw;
68         if(_escrow==0) throw;
69 
70         tokenManager = _tokenManager;
71         escrow = _escrow;
72     }
73     
74     function buyTokens(address _buyer) public payable onlyInState(State.Running)
75     {
76         if(msg.value == 0) throw;
77         uint newTokens = msg.value * PRICE;
78 
79         if (totalSupply + newTokens < totalSupply) throw;
80         if (totalSupply + newTokens > TOKEN_SUPPLY_LIMIT) throw;
81 
82         balance[_buyer] += newTokens;
83         totalSupply += newTokens;
84         
85         purchases[purchases.length++] = Purchase({buyer: _buyer, amount: newTokens});
86         
87         LogBuy(_buyer, newTokens);
88     }
89 
90     /// @dev Returns number of tokens owned by given address.
91     /// @param _owner Address of token owner.
92     function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)
93     {
94         uint tokens = balance[_owner];
95         if(tokens == 0) throw;
96 
97         balance[_owner] = 0;
98         totalSupply -= tokens;
99 
100         LogBurn(_owner, tokens);
101 
102         // Automatically switch phase when migration is done.
103         if(totalSupply == 0) 
104         {
105             currentState = State.Migrated;
106             LogStateSwitch(State.Migrated);
107         }
108     }
109 
110     /// @dev Returns number of tokens owned by given address.
111     /// @param _owner Address of token owner.
112     function balanceOf(address _owner) constant returns (uint256) 
113     {
114         return balance[_owner];
115     }
116 
117     function setPresaleState(State _nextState) public onlyTokenManager
118     {
119         // Init -> Running
120         // Running -> Paused
121         // Running -> Migrating
122         // Paused -> Running
123         // Paused -> Migrating
124         // Migrating -> Migrated
125         bool canSwitchState
126              =  (currentState == State.Init && _nextState == State.Running)
127              || (currentState == State.Running && _nextState == State.Paused)
128              // switch to migration phase only if crowdsale manager is set
129              || ((currentState == State.Running || currentState == State.Paused)
130                  && _nextState == State.Migrating
131                  && crowdsaleManager != 0x0)
132              || (currentState == State.Paused && _nextState == State.Running)
133              // switch to migrated only if everyting is migrated
134              || (currentState == State.Migrating && _nextState == State.Migrated
135                  && totalSupply == 0);
136 
137         if(!canSwitchState) throw;
138 
139         currentState = _nextState;
140         LogStateSwitch(_nextState);
141     }
142 
143     function withdrawEther() public onlyTokenManager
144     {
145         if(this.balance > 0) 
146         {
147             if(!escrow.send(this.balance)) throw;
148         }
149     }
150 
151 /// Setters/getters
152     function setTokenManager(address _mgr) public onlyTokenManager
153     {
154         tokenManager = _mgr;
155     }
156 
157     function setCrowdsaleManager(address _mgr) public onlyTokenManager
158     {
159         // You can't change crowdsale contract when migration is in progress.
160         if(currentState == State.Migrating) throw;
161 
162         crowdsaleManager = _mgr;
163     }
164 
165     function getTokenManager()constant returns(address)
166     {
167         return tokenManager;
168     }
169 
170     function getCrowdsaleManager()constant returns(address)
171     {
172         return crowdsaleManager;
173     }
174 
175     function getCurrentState()constant returns(State)
176     {
177         return currentState;
178     }
179 
180     function getPrice()constant returns(uint)
181     {
182         return PRICE;
183     }
184 
185     function getTotalSupply()constant returns(uint)
186     {
187         return totalSupply;
188     }
189     
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
201     
202     // Default fallback function
203     function() payable 
204     {
205         buyTokens(msg.sender);
206     }
207 }