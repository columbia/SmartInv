1 pragma solidity ^0.4.15;
2 
3 contract Base {
4 
5     modifier only(address allowed) {
6         require(msg.sender == allowed);
7         _;
8     }
9 
10     // *************************************************
11     // *          reentrancy handling                  *
12     // *************************************************
13     uint private bitlocks = 0;
14 
15     modifier noAnyReentrancy {
16         var _locks = bitlocks;
17         require(_locks == 0);
18         bitlocks = uint(-1);
19         _;
20         bitlocks = _locks;
21     }
22 }
23 
24 contract IToken {
25     function mint(address _to, uint _amount) public;
26     function start() public;
27     function getTotalSupply()  public returns(uint);
28     function balanceOf(address _owner)  public returns(uint);
29     function transfer(address _to, uint _amount)  public returns (bool success);
30     function transferFrom(address _from, address _to, uint _value)  public returns (bool success);
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract Owned is Base {
62     address public owner;
63     address newOwner;
64 
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     function transferOwnership(address _newOwner) public only(owner) {
70         newOwner = _newOwner;
71     }
72 
73     function acceptOwnership() public only(newOwner) {
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 }
80 
81 contract Crowdsale is Base, Owned {
82     using SafeMath for uint256;
83 
84     enum State { INIT, BOUNTY, PREICO, PREICO_FINISHED, ICO, CLOSED, STOPPED }
85     enum SupplyType { BOUNTY, SALE }
86 
87     uint public constant DECIMALS = 10**18;
88     uint public constant MAX_PREICO_SUPPLY = 20000000 * DECIMALS;
89     uint public constant MAX_ICO_SUPPLY = 70000000 * DECIMALS;
90     uint public constant MAX_BOUNTY_SUPPLY = 10000000 * DECIMALS;
91 
92     State public currentState = State.INIT;
93     IToken public token;
94 
95     uint public totalPreICOSupply = 0;
96     uint public totalICOSupply = 0;
97     uint public totalBountySupply = 0;
98 
99     uint public totalFunds = 0;
100     uint public tokenPrice = 6000000000000; //wei
101     uint public bonus = 2000; //20%
102     uint public currentPrice;
103     address public beneficiary;
104     mapping(address => uint) balances;
105     uint public countMembers = 0;
106 
107     uint private bonusBase = 10000; //100%;
108 
109     event Transfer(address indexed _to, uint256 _value);
110 
111     modifier inState(State _state){
112         require(currentState == _state);
113         _;
114     }
115 
116     modifier salesRunning(){
117         require(currentState == State.PREICO || currentState == State.ICO);
118         _;
119     }
120 
121     modifier notStopped(){
122         require(currentState != State.STOPPED);
123         _;
124     }
125 
126     function Crowdsale(address _beneficiary) public {
127         beneficiary = _beneficiary;
128     }
129 
130     function ()
131         public
132         payable
133         salesRunning
134     {
135         _receiveFunds();
136     }
137 
138     function initialize(address _token)
139         public
140         only(owner)
141         inState(State.INIT)
142     {
143         require(_token != address(0));
144 
145         token = IToken(_token);
146         currentPrice = tokenPrice;
147     }
148 
149     function setBonus(uint _bonus) public
150         only(owner)
151         notStopped
152     {
153         bonus = _bonus;
154     }
155 
156     function getBonus()
157         public
158         constant
159         returns(uint)
160     {
161         return bonus.mul(100).div(bonusBase);
162     }
163 
164     function setTokenPrice(uint _tokenPrice) public
165         only(owner)
166         notStopped
167     {
168         currentPrice = _tokenPrice;
169     }
170 
171     function setState(State _newState)
172         public
173         only(owner)
174     {
175         require(
176             currentState != State.STOPPED && (_newState == State.STOPPED ||
177             (currentState == State.INIT && _newState == State.BOUNTY
178             || currentState == State.BOUNTY && _newState == State.PREICO
179             || currentState == State.PREICO && _newState == State.PREICO_FINISHED
180             || currentState == State.PREICO_FINISHED && _newState == State.ICO
181             || currentState == State.ICO && _newState == State.CLOSED))
182         );
183 
184         if(_newState == State.CLOSED){
185             _finish();
186         }
187 
188         currentState = _newState;
189     }
190 
191     function investDirect(address _to, uint _amount)
192         public
193         only(owner)
194         salesRunning
195     {
196         uint bonusTokens = _amount.mul(bonus).div(bonusBase);
197         _amount = _amount.add(bonusTokens);
198 
199         _checkMaxSaleSupply(_amount);
200 
201         _mint(_to, _amount);
202     }
203     
204     function investBounty(address _to, uint _amount)
205         public
206         only(owner)
207         inState(State.BOUNTY)
208     {
209         _mint(_to, _amount);
210     }
211 
212 
213     function getCountMembers()
214     public
215     constant
216     returns(uint)
217     {
218         return countMembers;
219     }
220 
221     //==================== Internal Methods =================
222     function _mint(address _to, uint _amount)
223         noAnyReentrancy
224         internal
225     {
226         _increaseSupply(_amount);
227         IToken(token).mint(_to, _amount);
228         Transfer(_to, _amount);
229     }
230 
231     function _finish()
232         noAnyReentrancy
233         internal
234     {
235         IToken(token).start();
236     }
237 
238     function _receiveFunds()
239         internal
240     {
241         require(msg.value != 0);
242         uint weiAmount = msg.value;
243         uint transferTokens = weiAmount.mul(DECIMALS).div(currentPrice);
244 
245         uint bonusTokens = transferTokens.mul(bonus).div(bonusBase);
246         transferTokens = transferTokens.add(bonusTokens);
247 
248         _checkMaxSaleSupply(transferTokens);
249 
250         if(balances[msg.sender] == 0){
251             countMembers = countMembers.add(1);
252         }
253 
254         balances[msg.sender] = balances[msg.sender].add(weiAmount);
255         totalFunds = totalFunds.add(weiAmount);
256 
257         _mint(msg.sender, transferTokens);
258         beneficiary.transfer(weiAmount);
259     }
260 
261     function _checkMaxSaleSupply(uint transferTokens)
262         internal
263     {
264         if(currentState == State.PREICO) {
265             require(totalPreICOSupply.add(transferTokens) <= MAX_PREICO_SUPPLY);
266         } else if(currentState == State.ICO) {
267             require(totalICOSupply.add(transferTokens) <= MAX_ICO_SUPPLY);
268         }
269     }
270     
271      function _increaseSupply(uint _amount)
272         internal
273     {
274         if(currentState == State.PREICO) {
275             totalPreICOSupply = totalPreICOSupply.add(_amount);
276         } else if(currentState == State.ICO) {
277             totalICOSupply = totalICOSupply.add(_amount);
278         }
279     }
280 }