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
19     // 1 RMC = 0,003125 ETH or 1 ETH = 320 RMC
20     // ETH price ~300$ - 13.10.2017
21     uint public constant HARDCAP_ETH_LIMIT = 1875;
22     uint public constant SOFTCAP_ETH_LIMIT = 500;
23     uint public constant TOKEN_SUPPLY_LIMIT = PRICE * HARDCAP_ETH_LIMIT * (1 ether / 1 wei);
24     uint public constant SOFTCAP_LIMIT = PRICE * SOFTCAP_ETH_LIMIT * (1 ether / 1 wei);
25     
26     // 25.11.2017 17:00 MSK
27     uint public icoDeadline = 1511618400;
28     
29     uint public constant BOUNTY_LIMIT = 350000 * (1 ether / 1 wei);
30 
31     enum State{
32        Init,
33        Running,
34        Paused,
35        Migrating,
36        Migrated
37     }
38 
39     State public currentState = State.Init;
40     uint public totalSupply = 0; // amount of tokens already sold
41     uint public bountySupply = 0; // amount of tokens already given as a reward
42 
43     // Gathered funds can be withdrawn only to escrow's address.
44     address public escrow = 0;
45 
46     // Token manager has exclusive priveleges to call administrative
47     // functions on this contract.
48     address public tokenManager = 0;
49 
50     // Crowdsale manager has exclusive priveleges to burn presale tokens.
51     address public crowdsaleManager = 0;
52 
53     mapping (address => uint256) public balances;
54     mapping (address => uint256) public ethBalances;
55 
56 /// Modifiers:
57     modifier onlyTokenManager()     { require(msg.sender == tokenManager); _;}
58     modifier onlyCrowdsaleManager() { require(msg.sender == crowdsaleManager); _;}
59     modifier onlyInState(State state){ require(state == currentState); _;}
60 
61 /// Events:
62     event LogBuy(address indexed owner, uint value);
63     event LogBurn(address indexed owner, uint value);
64     event LogStateSwitch(State newState);
65 
66 /// Functions:
67     /// @dev Constructor
68     /// @param _tokenManager Token manager address.
69     function PresaleToken(address _tokenManager, address _escrow) public
70     {
71         require(_tokenManager!=0);
72         require(_escrow!=0);
73 
74         tokenManager = _tokenManager;
75         escrow = _escrow;
76     }
77     
78     function reward(address _user, uint  _amount) public onlyTokenManager {
79         require(_user != 0x0);
80         
81         assert(bountySupply + _amount >= bountySupply);
82         assert(bountySupply + _amount <= BOUNTY_LIMIT);
83         bountySupply += _amount;
84         
85         assert(balances[_user] + _amount >= balances[_user]);
86         balances[_user] += _amount;
87         
88         addAddressToList(_user);
89     }
90     
91     function isIcoSuccessful() constant public returns(bool successful)  {
92         return totalSupply >= SOFTCAP_LIMIT;
93     }
94     
95     function isIcoOver() constant public returns(bool isOver) {
96         return now >= icoDeadline;
97     }
98 
99     function buyTokens(address _buyer) public payable onlyInState(State.Running)
100     {
101         assert(!isIcoOver());
102         require(msg.value != 0);
103         
104         uint ethValue = msg.value;
105         uint newTokens = msg.value * PRICE;
106        
107         require(!(totalSupply + newTokens > TOKEN_SUPPLY_LIMIT));
108         assert(ethBalances[_buyer] + ethValue >= ethBalances[_buyer]);
109         assert(balances[_buyer] + newTokens >= balances[_buyer]);
110         assert(totalSupply + newTokens >= totalSupply);
111         
112         ethBalances[_buyer] += ethValue;
113         balances[_buyer] += newTokens;
114         totalSupply += newTokens;
115         
116         addAddressToList(_buyer);
117 
118         LogBuy(_buyer, newTokens);
119     }
120     
121     address[] public addressList;
122     mapping (address => bool) isAddressInList;
123     function addAddressToList(address _address) private {
124         if (isAddressInList[_address]) {
125             return;
126         }
127         addressList.push(_address);
128         isAddressInList[_address] = true;
129     }
130 
131     /// @dev Returns number of tokens owned by given address.
132     /// @param _owner Address of token owner.
133     function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)
134     {
135         uint tokens = balances[_owner];
136         require(tokens != 0);
137 
138         balances[_owner] = 0;
139         totalSupply -= tokens;
140 
141         LogBurn(_owner, tokens);
142 
143         // Automatically switch phase when migration is done.
144         if(totalSupply == 0) 
145         {
146             currentState = State.Migrated;
147             LogStateSwitch(State.Migrated);
148         }
149     }
150 
151     /// @dev Returns number of tokens owned by given address.
152     /// @param _owner Address of token owner.
153     function balanceOf(address _owner) public constant returns (uint256) 
154     {
155         return balances[_owner];
156     }
157 
158     function setPresaleState(State _nextState) public onlyTokenManager
159     {
160         // Init -> Running
161         // Running -> Paused
162         // Running -> Migrating
163         // Paused -> Running
164         // Paused -> Migrating
165         // Migrating -> Migrated
166         bool canSwitchState
167              =  (currentState == State.Init && _nextState == State.Running)
168              || (currentState == State.Running && _nextState == State.Paused)
169              // switch to migration phase only if crowdsale manager is set
170              || ((currentState == State.Running || currentState == State.Paused)
171                  && _nextState == State.Migrating
172                  && crowdsaleManager != 0x0)
173              || (currentState == State.Paused && _nextState == State.Running)
174              // switch to migrated only if everyting is migrated
175              || (currentState == State.Migrating && _nextState == State.Migrated
176                  && totalSupply == 0);
177 
178         require(canSwitchState);
179 
180         currentState = _nextState;
181         LogStateSwitch(_nextState);
182     }
183 
184     uint public nextInListToReturn = 0;
185     uint private constant transfersPerIteration = 50;
186     function returnToFunders() private {
187         uint afterLast = nextInListToReturn + transfersPerIteration < addressList.length ? nextInListToReturn + transfersPerIteration : addressList.length; 
188         
189         for (uint i = nextInListToReturn; i < afterLast; i++) {
190             address currentUser = addressList[i];
191             if (ethBalances[currentUser] > 0) {
192                 currentUser.transfer(ethBalances[currentUser]);
193                 ethBalances[currentUser] = 0;
194             }
195         }
196         
197         nextInListToReturn = afterLast;
198     }
199     function withdrawEther() public
200     {
201         if (isIcoSuccessful()) {
202             if(msg.sender == tokenManager && this.balance > 0) 
203             {
204                 escrow.transfer(this.balance);
205             }
206         }
207         else {
208             if (isIcoOver()) {
209                 returnToFunders();
210             }
211         }
212     }
213     
214     function returnFunds() public {
215         returnFundsFor(msg.sender);
216     }
217     function returnFundsFor(address _user) public {
218         assert(isIcoOver() && !isIcoSuccessful());
219         assert(msg.sender == tokenManager || msg.sender == address(this));
220         
221         if (ethBalances[_user] > 0) {
222             _user.transfer(ethBalances[_user]);
223             ethBalances[_user] = 0;
224         }
225     }
226 
227 /// Setters
228     function setTokenManager(address _mgr) public onlyTokenManager
229     {
230         tokenManager = _mgr;
231     }
232 
233     function setCrowdsaleManager(address _mgr) public onlyTokenManager
234     {
235         // You can't change crowdsale contract when migration is in progress.
236         require(currentState != State.Migrating);
237 
238         crowdsaleManager = _mgr;
239     }
240 
241     // Default fallback function
242     function()  public payable 
243     {
244         buyTokens(msg.sender);
245     }
246 }