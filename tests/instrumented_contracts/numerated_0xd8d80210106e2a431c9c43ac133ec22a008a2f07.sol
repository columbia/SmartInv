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
12     string public constant name = "IMMLA Presale Token v.2";
13     string public constant symbol = "IML";
14     uint public constant decimals = 18;
15     uint public constant PRICE = 5200;  // per 1 Ether
16 
17     //  price
18     // Cap is 600 ETH
19     // 1 eth = 5200 presale IMMLA tokens
20     // 
21     // ETH price 320$ - 15.10.2017
22     uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 600 * (1 ether / 1 wei);
23 
24     enum State{
25        Init,
26        Running,
27        Paused,
28        Migrating,
29        Migrated
30     }
31 
32     State public currentState = State.Init;
33     uint public totalSupply = 0; // amount of tokens already sold
34 
35     // Gathered funds can be withdrawn only to escrow's address.
36     address public escrow = 0;
37 
38     // Token manager has exclusive priveleges to call administrative
39     // functions on this contract.
40     address public tokenManager = 0;
41 
42     // Crowdsale manager has exclusive priveleges to burn presale tokens.
43     address public crowdsaleManager = 0;
44 
45     mapping (address => uint256) private balance;
46 
47 /// Modifiers:
48     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
49     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
50     modifier onlyInState(State state){ if(state != currentState) throw; _; }
51 
52 /// Events:
53     event LogBuy(address indexed owner, uint value);
54     event LogBurn(address indexed owner, uint value);
55     event LogStateSwitch(State newState);
56 
57 /// Functions:
58     /// @dev Constructor
59     /// @param _tokenManager Token manager address.
60     function PresaleToken(address _tokenManager, address _escrow) 
61     {
62         if(_tokenManager==0) throw;
63         if(_escrow==0) throw;
64 
65         tokenManager = _tokenManager;
66         escrow = _escrow;
67     }
68 
69     function buyTokens(address _buyer) public payable onlyInState(State.Running)
70     {
71         if(msg.value == 0) throw;
72         uint newTokens = msg.value * PRICE;
73 
74         if (totalSupply + newTokens > TOKEN_SUPPLY_LIMIT) throw;
75 
76         balance[_buyer] += newTokens;
77         totalSupply += newTokens;
78 
79         LogBuy(_buyer, newTokens);
80     }
81 
82     /// @dev Returns number of tokens owned by given address.
83     /// @param _owner Address of token owner.
84     function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)
85     {
86         uint tokens = balance[_owner];
87         if(tokens == 0) throw;
88 
89         balance[_owner] = 0;
90         totalSupply -= tokens;
91 
92         LogBurn(_owner, tokens);
93 
94         // Automatically switch phase when migration is done.
95         if(totalSupply == 0) 
96         {
97             currentState = State.Migrated;
98             LogStateSwitch(State.Migrated);
99         }
100     }
101 
102     /// @dev Returns number of tokens owned by given address.
103     /// @param _owner Address of token owner.
104     function balanceOf(address _owner) constant returns (uint256) 
105     {
106         return balance[_owner];
107     }
108 
109     function setPresaleState(State _nextState) public onlyTokenManager
110     {
111         // Init -> Running
112         // Running -> Paused
113         // Running -> Migrating
114         // Paused -> Running
115         // Paused -> Migrating
116         // Migrating -> Migrated
117         bool canSwitchState
118              =  (currentState == State.Init && _nextState == State.Running)
119              || (currentState == State.Running && _nextState == State.Paused)
120              // switch to migration phase only if crowdsale manager is set
121              || ((currentState == State.Running || currentState == State.Paused)
122                  && _nextState == State.Migrating
123                  && crowdsaleManager != 0x0)
124              || (currentState == State.Paused && _nextState == State.Running)
125              // switch to migrated only if everyting is migrated
126              || (currentState == State.Migrating && _nextState == State.Migrated
127                  && totalSupply == 0);
128 
129         if(!canSwitchState) throw;
130 
131         currentState = _nextState;
132         LogStateSwitch(_nextState);
133     }
134 
135     function withdrawEther() public onlyTokenManager
136     {
137         if(this.balance > 0) 
138         {
139             if(!escrow.send(this.balance)) throw;
140         }
141     }
142 
143 /// Setters/getters
144     function setTokenManager(address _mgr) public onlyTokenManager
145     {
146         tokenManager = _mgr;
147     }
148 
149     function setCrowdsaleManager(address _mgr) public onlyTokenManager
150     {
151         // You can't change crowdsale contract when migration is in progress.
152         if(currentState == State.Migrating) throw;
153 
154         crowdsaleManager = _mgr;
155     }
156 
157     function getTokenManager()constant returns(address)
158     {
159         return tokenManager;
160     }
161 
162     function getCrowdsaleManager()constant returns(address)
163     {
164         return crowdsaleManager;
165     }
166 
167     function getCurrentState()constant returns(State)
168     {
169         return currentState;
170     }
171 
172     function getPrice()constant returns(uint)
173     {
174         return PRICE;
175     }
176 
177     function getTotalSupply()constant returns(uint)
178     {
179         return totalSupply;
180     }
181 
182 
183     // Default fallback function
184     function() payable 
185     {
186         buyTokens(msg.sender);
187     }
188 }