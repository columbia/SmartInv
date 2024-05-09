1 pragma solidity ^0.4.15;
2 
3 // ERC20 token interface
4 
5 contract InRiddimCrowdsale {
6 
7     // InRiddim Crowdsale
8 
9     function InRiddimCrowdsale(address _tokenManager, address _escrow) public {
10         tokenManager = _tokenManager;
11         escrow = _escrow;
12         balanceOf[escrow] += 49000000000000000000000000; // Initialize Supply 49000000
13         totalSupply += 49000000000000000000000000;
14     }
15 
16     /*/
17      *  Constants
18     /*/
19 
20     string public name = "InRiddim";
21     string public  symbol = "IRDM";
22     uint   public decimals = 18;
23 
24     uint public constant PRICE = 400; // 400 IRDM per ETH
25     
26     //  price
27     // Cap is 127500 ETH
28     // 1 ETH = 400 IRDM tokens
29 
30     uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 250000 * (1 ether / 1 wei);
31     // CAP 100000000
32     
33     /*/
34      *  Token State
35     /*/
36 
37     enum Phase {
38         Created,
39         Running,
40         Paused,
41         Migrating,
42         Migrated
43     }
44 
45     Phase public currentPhase = Phase.Created;
46     uint public totalSupply = 0; // amount of tokens already sold
47 
48     // Token manager has exclusive priveleges to call administrative
49     // functions on this contract.
50     address public tokenManager;
51 
52     // Gathered funds can be withdrawn only to escrow's address.
53     address public escrow;
54 
55     // Crowdsale manager has exclusive priveleges to burn tokens.
56     address public crowdsaleManager;
57 
58     // This creates an array with all balances
59     mapping (address => uint256) public balanceOf;
60     mapping (address => bool) public isSaler;
61 
62     modifier onlyTokenManager() { 
63         require(msg.sender == tokenManager); 
64         _; 
65     }
66     modifier onlyCrowdsaleManager() {
67         require(msg.sender == crowdsaleManager); 
68         _; 
69     }
70 
71     modifier onlyEscrow() {
72         require(msg.sender == escrow);
73         _;
74     }
75 
76     /*/
77      *  Contract Events
78     /*/
79 
80     event LogBuy(address indexed owner, uint value);
81     event LogBurn(address indexed owner, uint value);
82     event LogPhaseSwitch(Phase newPhase);
83     // This generates a public event on the blockchain that will notify clients
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /*/
87      *  Public functions
88     /*/
89 
90     /**
91      * Internal transfer, only can be called by this contract
92      */
93     function _transfer(address _from, address _to, uint _value) internal {
94         require(_to != 0x0);
95         require(_value > 0);
96         require(balanceOf[_from] > _value);
97         require(balanceOf[_to] + _value > balanceOf[_to]);
98         require(balanceOf[msg.sender] - _value < balanceOf[msg.sender]);
99         balanceOf[_from] -= _value;
100         balanceOf[_to] += _value;
101         Transfer(_from, _to, _value);
102     }
103    // Transfer the balance from owner's account to another account
104     // only escrow can send token (to send token private sale)
105     function transfer(address _to, uint256 _value) public
106         onlyEscrow
107     {
108         _transfer(msg.sender, _to, _value);
109     }
110 
111 
112     function() payable public {
113         buy(msg.sender);
114     }
115     
116     function buy(address _buyer) payable public {
117         // Available only if presale is running.
118         require(currentPhase == Phase.Running);
119         require(msg.value != 0);
120         uint newTokens = msg.value * PRICE;
121         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
122         balanceOf[_buyer] += newTokens;
123         totalSupply += newTokens;
124         LogBuy(_buyer, newTokens);
125     }
126     
127     function buyTokens(address _saler) payable public {
128         // Available only if presale is running.
129         require(isSaler[_saler] == true);
130         require(currentPhase == Phase.Running);
131 
132         require(msg.value != 0);
133         uint newTokens = msg.value * PRICE;
134         uint tokenForSaler = newTokens / 20;
135         
136         require(totalSupply + newTokens + tokenForSaler <= TOKEN_SUPPLY_LIMIT);
137         
138         balanceOf[_saler] += tokenForSaler;
139         balanceOf[msg.sender] += newTokens;
140 
141         totalSupply += newTokens;
142         totalSupply += tokenForSaler;
143         
144         LogBuy(msg.sender, newTokens);
145     }
146 
147 
148     /// @dev Returns number of tokens owned by given address.
149     /// @param _owner Address of token owner.
150     function burnTokens(address _owner) public
151         onlyCrowdsaleManager
152     {
153         // Available only during migration phase
154         require(currentPhase == Phase.Migrating);
155 
156         uint tokens = balanceOf[_owner];
157         require(tokens != 0);
158         balanceOf[_owner] = 0;
159         totalSupply -= tokens;
160         LogBurn(_owner, tokens);
161 
162         // Automatically switch phase when migration is done.
163         if (totalSupply == 0) {
164             currentPhase = Phase.Migrated;
165             LogPhaseSwitch(Phase.Migrated);
166         }
167     }
168 
169 
170     /*/
171      *  Administrative functions
172     /*/
173     function setPresalePhase(Phase _nextPhase) public
174         onlyTokenManager
175     {
176         bool canSwitchPhase
177             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
178             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
179                 // switch to migration phase only if crowdsale manager is set
180             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
181                 && _nextPhase == Phase.Migrating
182                 && crowdsaleManager != 0x0)
183             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
184                 // switch to migrated only if everyting is migrated
185             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
186                 && totalSupply == 0);
187 
188         require(canSwitchPhase);
189         currentPhase = _nextPhase;
190         LogPhaseSwitch(_nextPhase);
191     }
192 
193 
194     function withdrawEther() public
195         onlyTokenManager
196     {
197         require(escrow != 0x0);
198         // Available at any phase.
199         if (this.balance > 0) {
200             escrow.transfer(this.balance);
201         }
202     }
203 
204 
205     function setCrowdsaleManager(address _mgr) public
206         onlyTokenManager
207     {
208         // You can't change crowdsale contract when migration is in progress.
209         require(currentPhase != Phase.Migrating);
210         crowdsaleManager = _mgr;
211     }
212 
213     function addSaler(address _mgr) public
214         onlyTokenManager
215     {
216         require(currentPhase != Phase.Migrating);
217         isSaler[_mgr] = true;
218     }
219 
220     function removeSaler(address _mgr) public
221         onlyTokenManager
222     {
223         require(currentPhase != Phase.Migrating);
224         isSaler[_mgr] = false;
225     }
226 }