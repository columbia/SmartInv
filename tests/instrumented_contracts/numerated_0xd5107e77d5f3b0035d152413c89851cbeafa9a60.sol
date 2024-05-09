1 pragma solidity ^0.4.17;
2 
3 contract PresaleToken {
4     
5     /// Fields:
6     string public constant name = "ShiftCash Presale Token";
7     string public constant symbol = "SCASH";
8     uint public constant decimals = 18;
9     uint public constant PRICE = 598;  // per 1 Ether
10 
11     //  price
12     // Cap is 4000 ETH
13     // 1 eth = 598;  presale SCASH tokens
14     uint public constant TOKEN_SUPPLY_LIMIT = 2392000 * (1 ether / 1 wei);
15 
16     enum State{
17         Init,
18         Running,
19         Paused,
20         Migrating,
21         Migrated
22     }
23 
24     State public currentState = State.Init;
25     uint public totalSupply = 0; // amount of tokens already sold
26 
27     // Gathered funds can be withdrawn only to escrow's address.
28     address public escrow = 0;
29 
30     // Token manager has exclusive priveleges to call administrative
31     // functions on this contract.
32     address public tokenManager = 0;
33 
34     // Crowdsale manager has exclusive priveleges to burn presale tokens.
35     address public crowdsaleManager = 0;
36 
37     mapping (address => uint256) private balance;
38     mapping (address => bool) ownerAppended;
39     address[] public owners;
40 
41     /// Modifiers:
42     modifier onlyTokenManager()     { require(msg.sender == tokenManager); _; }
43     modifier onlyCrowdsaleManager() { require(msg.sender == crowdsaleManager); _; }
44     modifier onlyInState(State state){ require(state == currentState); _; }
45 
46     /// Events:
47     event LogBurn(address indexed owner, uint value);
48     event LogStateSwitch(State newState);
49 
50     // Triggered when tokens are transferred.
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52 
53 
54     /// Functions:
55     /// @dev Constructor
56     /// @param _tokenManager Token manager address.
57     function PresaleToken(address _tokenManager, address _escrow) public {
58         require(_tokenManager != 0);
59         require(_escrow != 0);
60 
61         tokenManager = _tokenManager;
62         escrow = _escrow;
63     }
64 
65     function buyTokens(address _buyer) public payable onlyInState(State.Running) {
66         require(msg.value != 0);
67         uint newTokens = msg.value * PRICE;
68 
69         require(totalSupply + newTokens <= TOKEN_SUPPLY_LIMIT);
70 
71         balance[_buyer] += newTokens;
72         totalSupply += newTokens;
73         
74         if(!ownerAppended[_buyer]) {
75             ownerAppended[_buyer] = true;
76             owners.push(_buyer);
77         }
78         
79         Transfer(msg.sender, _buyer, newTokens);
80 
81         if(this.balance > 0) {
82             require(escrow.send(this.balance));
83         }
84 
85     }
86 
87     /// @dev Returns number of tokens owned by given address.
88     /// @param _owner Address of token owner.
89     function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating) {
90         uint tokens = balance[_owner];
91         require(tokens != 0);
92 
93         balance[_owner] = 0;
94         totalSupply -= tokens;
95 
96         LogBurn(_owner, tokens);
97 
98         // Automatically switch phase when migration is done.
99         if(totalSupply == 0) {
100             currentState = State.Migrated;
101             LogStateSwitch(State.Migrated);
102         }
103     }
104 
105     /// @dev Returns number of tokens owned by given address.
106     /// @param _owner Address of token owner.
107     function balanceOf(address _owner) constant returns (uint256) {
108         return balance[_owner];
109     }
110 
111     function setPresaleState(State _nextState) public onlyTokenManager {
112         // Init -> Running
113         // Running -> Paused
114         // Running -> Migrating
115         // Paused -> Running
116         // Paused -> Migrating
117         // Migrating -> Migrated
118         bool canSwitchState
119         =  (currentState == State.Init && _nextState == State.Running)
120         || (currentState == State.Running && _nextState == State.Paused)
121         // switch to migration phase only if crowdsale manager is set
122         || ((currentState == State.Running || currentState == State.Paused)
123         && _nextState == State.Migrating
124         && crowdsaleManager != 0x0)
125         || (currentState == State.Paused && _nextState == State.Running)
126         // switch to migrated only if everyting is migrated
127         || (currentState == State.Migrating && _nextState == State.Migrated
128         && totalSupply == 0);
129 
130         require(canSwitchState);
131 
132         currentState = _nextState;
133         LogStateSwitch(_nextState);
134     }
135 
136     /// Setters/getters
137     function setTokenManager(address _mgr) public onlyTokenManager {
138         tokenManager = _mgr;
139     }
140 
141     function setCrowdsaleManager(address _mgr) public onlyTokenManager {
142         // You can't change crowdsale contract when migration is in progress.
143         require(currentState != State.Migrating);
144         crowdsaleManager = _mgr;
145     }
146 
147     function getTokenManager() constant returns(address) {
148         return tokenManager;
149     }
150 
151     function getCrowdsaleManager() constant returns(address) {
152         return crowdsaleManager;
153     }
154 
155     function getCurrentState() constant returns(State) {
156         return currentState;
157     }
158 
159     function getPrice() constant returns(uint) {
160         return PRICE;
161     }
162 
163     function totalSupply() constant returns (uint256) {
164         return totalSupply;
165     }
166 
167     function getOwner(uint index) constant returns (address, uint256) {
168         return (owners[index], balance[owners[index]]);
169     }
170 
171     function getOwnerCount() constant returns (uint) {
172         return owners.length;
173     }
174     
175 
176     // Default fallback function
177     function() payable {
178         buyTokens(msg.sender);
179     }
180 }