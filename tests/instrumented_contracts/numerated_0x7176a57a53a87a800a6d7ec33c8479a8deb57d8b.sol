1 pragma solidity ^0.4.11;
2 
3 // ERC20 token interface is implemented only partially.
4 
5 contract ARIToken {
6 
7     /// @dev Constructor
8     /// @param _tokenManager Token manager address.
9     function ARIToken(address _tokenManager, address _escrow) {
10         tokenManager = _tokenManager;
11         escrow = _escrow;
12     }
13 
14 
15     /*/
16      *  Constants
17     /*/
18 
19     string public constant name = "ARI Token";
20     string public constant symbol = "ARI";
21     uint   public constant decimals = 18;
22 
23     /*/
24      *  Token state
25     /*/
26 
27     enum Phase {
28         Created,
29         Running,
30         Paused,
31         Migrating,
32         Migrated
33     }
34 
35     Phase public currentPhase = Phase.Created;
36     uint public totalSupply = 0; // amount of tokens already sold
37 
38     uint public price = 2000;
39     uint public tokenSupplyLimit = 2000 * 10000 * (1 ether / 1 wei);
40 
41     bool public transferable = false;
42 
43     // Token manager has exclusive priveleges to call administrative
44     // functions on this contract.
45     address public tokenManager;
46 
47     // Gathered funds can be withdrawn only to escrow's address.
48     address public escrow;
49 
50     // Crowdsale manager has exclusive priveleges to burn presale tokens.
51     address public crowdsaleManager;
52 
53     mapping (address => uint256) private balance;
54 
55 
56     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
57     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
58 
59 
60     /*/
61      *  Events
62     /*/
63 
64     event LogBuy(address indexed owner, uint value);
65     event LogBurn(address indexed owner, uint value);
66     event LogPhaseSwitch(Phase newPhase);
67     /* This generates a public event on the blockchain that will notify clients */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70 
71     /*/
72      *  Public functions
73     /*/
74 
75     function() payable {
76         buyTokens(msg.sender);
77     }
78 
79     /// @dev Lets buy you some tokens.
80     function buyTokens(address _buyer) public payable {
81         // Available only if presale is running.
82         if(currentPhase != Phase.Running) throw;
83 
84         if(msg.value <= 0) throw;
85         uint newTokens = msg.value * price;
86         if (totalSupply + newTokens > tokenSupplyLimit) throw;
87         balance[_buyer] += newTokens;
88         totalSupply += newTokens;
89         LogBuy(_buyer, newTokens);
90     }
91 
92 
93     /// @dev Returns number of tokens owned by given address.
94     /// @param _owner Address of token owner.
95     function burnTokens(address _owner) public
96         onlyCrowdsaleManager
97     {
98         // Available only during migration phase
99         if(currentPhase != Phase.Migrating) throw;
100 
101         uint tokens = balance[_owner];
102         if(tokens == 0) throw;
103         balance[_owner] = 0;
104         totalSupply -= tokens;
105         LogBurn(_owner, tokens);
106 
107         // Automatically switch phase when migration is done.
108         if(totalSupply == 0) {
109             currentPhase = Phase.Migrated;
110             LogPhaseSwitch(Phase.Migrated);
111         }
112     }
113 
114 
115     /// @dev Returns number of tokens owned by given address.
116     /// @param _owner Address of token owner.
117     function balanceOf(address _owner) constant returns (uint256) {
118         return balance[_owner];
119     }
120 
121 
122     /*/
123      *  Administrative functions
124     /*/
125 
126     function setPresalePhase(Phase _nextPhase) public
127         onlyTokenManager
128     {
129         bool canSwitchPhase
130             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
131             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
132                 // switch to migration phase only if crowdsale manager is set
133             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
134                 && _nextPhase == Phase.Migrating
135                 && crowdsaleManager != 0x0)
136             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
137                 // switch to migrated only if everyting is migrated
138             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
139                 && totalSupply == 0);
140 
141         if(!canSwitchPhase) throw;
142         currentPhase = _nextPhase;
143         LogPhaseSwitch(_nextPhase);
144     }
145 
146 
147     function withdrawEther() public
148         onlyTokenManager
149     {
150         // Available at any phase.
151         if(this.balance > 0) {
152             if(!escrow.send(this.balance)) throw;
153         }
154     }
155 
156 
157     function setCrowdsaleManager(address _mgr) public
158         onlyTokenManager
159     {
160         // You can't change crowdsale contract when migration is in progress.
161         if(currentPhase == Phase.Migrating) throw;
162         crowdsaleManager = _mgr;
163     }
164     
165     /* Send coins */
166     function transfer(address _to, uint256 _value) {
167         if (!transferable) throw;
168         if (balance[msg.sender] < _value) throw;           // Check if the sender has enough
169         if (balance[_to] + _value < balance[_to]) throw; // Check for overflows
170         balance[msg.sender] -= _value;                     // Subtract from the sender
171         balance[_to] += _value;                            // Add the same to the recipient
172         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
173     }
174     
175     function setTransferable(bool _value) public
176         onlyTokenManager
177     {
178         transferable = _value;
179     }
180     
181     function setPrice(uint256 _price) public
182         onlyTokenManager
183     {
184         if(currentPhase != Phase.Paused) throw;
185         if(_price <= 0) throw;
186 
187         price = _price;
188     }
189 
190     function setTokenSupplyLimit(uint256 _value) public
191         onlyTokenManager
192     {
193         if(currentPhase != Phase.Paused) throw;
194         if(_value <= 0) throw;
195 
196         uint _tokenSupplyLimit;
197         _tokenSupplyLimit = _value * (1 ether / 1 wei);
198 
199         if(totalSupply > _tokenSupplyLimit) throw;
200 
201         tokenSupplyLimit = _tokenSupplyLimit;
202     }
203 }