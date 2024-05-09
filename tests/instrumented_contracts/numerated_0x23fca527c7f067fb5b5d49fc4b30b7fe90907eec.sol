1 pragma solidity ^0.4.15;
2 
3 
4 // ERC20 token interface is implemented only partially.
5 
6 contract PresaleToken {
7 
8     /// NAC Broker Presale Token
9     /// @dev Constructor
10     /// @param _tokenManager Token manager address.
11     function PresaleToken(address _tokenManager, address _escrow) public {
12         tokenManager = _tokenManager;
13         escrow = _escrow;
14         // send ~ 60tr NAC private sales
15         balanceOf[escrow] += 60329080000000000000000000; // 60 329 080 tr Nac
16         totalSupply += 60329080000000000000000000;
17     }
18 
19 
20     /*/
21      *  Constants
22     /*/
23 
24     string public name = "NAC Presales Token";
25     string public  symbol = "NAC";
26     uint   public decimals = 18;
27 
28     uint public constant PRICE = 3450; // 3450 NAC per Ether
29 
30     //  price
31     // Cup is 150000 ETH
32     // 1 eth = 3450 presale tokens
33 
34     uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 150000 * (1 ether / 1 wei);
35 
36     /*/
37      *  Token state
38     /*/
39 
40     enum Phase {
41         Created,
42         Running,
43         Paused,
44         Migrating,
45         Migrated
46     }
47 
48     Phase public currentPhase = Phase.Created;
49     uint public totalSupply = 0; // amount of tokens already sold
50 
51     // Token manager has exclusive priveleges to call administrative
52     // functions on this contract.
53     address public tokenManager;
54 
55     // Gathered funds can be withdrawn only to escrow's address.
56     address public escrow;
57 
58     // Crowdsale manager has exclusive priveleges to burn presale tokens.
59     address public crowdsaleManager;
60 
61     // This creates an array with all balances
62     mapping (address => uint256) public balanceOf;
63     mapping (address => bool) public isSaler;
64 
65     modifier onlyTokenManager() { 
66         require(msg.sender == tokenManager); 
67         _; 
68     }
69     modifier onlyCrowdsaleManager() {
70         require(msg.sender == crowdsaleManager); 
71         _; 
72     }
73 
74     modifier onlyEscrow() {
75         require(msg.sender == escrow);
76         _;
77     }
78 
79     /*/
80      *  Events
81     /*/
82 
83     event LogBuy(address indexed owner, uint value);
84     event LogBurn(address indexed owner, uint value);
85     event LogPhaseSwitch(Phase newPhase);
86     // This generates a public event on the blockchain that will notify clients
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /*/
90      *  Public functions
91     /*/
92 
93     /**
94      * Internal transfer, only can be called by this contract
95      */
96     function _transfer(address _from, address _to, uint _value) internal {
97         require(_to != 0x0);
98         require(_value > 0);
99         require(balanceOf[_from] > _value);
100         require(balanceOf[_to] + _value > balanceOf[_to]);
101         require(balanceOf[msg.sender] - _value < balanceOf[msg.sender]);
102         balanceOf[_from] -= _value;
103         balanceOf[_to] += _value;
104         Transfer(_from, _to, _value);
105     }
106 
107     // Transfer the balance from owner's account to another account
108     // only escrow can send token (to send token private sale)
109     function transfer(address _to, uint256 _value) public
110         onlyEscrow
111     {
112         _transfer(msg.sender, _to, _value);
113     }
114 
115     /*
116     *        >=3000 ETH: 1ETH = 6000 NAC
117     *        >=300 ETH: 1ETH = 4800 NAC
118     *        <300 ETH: 1ETH = 3450 NAC
119     */
120     function getBonus(uint value) internal returns (uint bonus) {
121         require(value != 0);
122         if (value >= (3000 * 10**18)) {
123             return value * 2550;
124         } else if (value >= (300 * 10**18)) {
125             return value * 1350;
126         }
127         return 0;
128     }
129 
130 
131     function() payable public {
132         buy(msg.sender);
133     }
134     
135     function buy(address _buyer) payable public {
136         // Available only if presale is running.
137         require(currentPhase == Phase.Running);
138         require(msg.value != 0);
139         uint newTokens = msg.value * PRICE + getBonus(msg.value);
140         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
141         balanceOf[_buyer] += newTokens;
142         totalSupply += newTokens;
143         LogBuy(_buyer, newTokens);
144     }
145     
146     function buyTokens(address _saler) payable public {
147         // Available only if presale is running.
148         require(isSaler[_saler] == true);
149         require(currentPhase == Phase.Running);
150 
151         require(msg.value != 0);
152         uint newTokens = msg.value * PRICE + getBonus(msg.value);
153         uint tokenForSaler = newTokens / 20;
154         
155         require(totalSupply + newTokens + tokenForSaler <= TOKEN_SUPPLY_LIMIT);
156         
157         balanceOf[_saler] += tokenForSaler;
158         balanceOf[msg.sender] += newTokens;
159 
160         totalSupply += newTokens;
161         totalSupply += tokenForSaler;
162         
163         LogBuy(msg.sender, newTokens);
164     }
165 
166 
167     /// @dev Returns number of tokens owned by given address.
168     /// @param _owner Address of token owner.
169     function burnTokens(address _owner) public
170         onlyCrowdsaleManager
171     {
172         // Available only during migration phase
173         require(currentPhase == Phase.Migrating);
174 
175         uint tokens = balanceOf[_owner];
176         require(tokens != 0);
177         balanceOf[_owner] = 0;
178         totalSupply -= tokens;
179         LogBurn(_owner, tokens);
180 
181         // Automatically switch phase when migration is done.
182         if (totalSupply == 0) {
183             currentPhase = Phase.Migrated;
184             LogPhaseSwitch(Phase.Migrated);
185         }
186     }
187 
188 
189     /*/
190      *  Administrative functions
191     /*/
192     function setPresalePhase(Phase _nextPhase) public
193         onlyTokenManager
194     {
195         bool canSwitchPhase
196             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
197             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
198                 // switch to migration phase only if crowdsale manager is set
199             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
200                 && _nextPhase == Phase.Migrating
201                 && crowdsaleManager != 0x0)
202             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
203                 // switch to migrated only if everyting is migrated
204             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
205                 && totalSupply == 0);
206 
207         require(canSwitchPhase);
208         currentPhase = _nextPhase;
209         LogPhaseSwitch(_nextPhase);
210     }
211 
212 
213     function withdrawEther() public
214         onlyTokenManager
215     {
216         require(escrow != 0x0);
217         // Available at any phase.
218         if (this.balance > 0) {
219             escrow.transfer(this.balance);
220         }
221     }
222 
223 
224     function setCrowdsaleManager(address _mgr) public
225         onlyTokenManager
226     {
227         // You can't change crowdsale contract when migration is in progress.
228         require(currentPhase != Phase.Migrating);
229         crowdsaleManager = _mgr;
230     }
231 
232     function addSaler(address _mgr) public
233         onlyTokenManager
234     {
235         require(currentPhase != Phase.Migrating);
236         isSaler[_mgr] = true;
237     }
238 
239     function removeSaler(address _mgr) public
240         onlyTokenManager
241     {
242         require(currentPhase != Phase.Migrating);
243         isSaler[_mgr] = false;
244     }
245 }