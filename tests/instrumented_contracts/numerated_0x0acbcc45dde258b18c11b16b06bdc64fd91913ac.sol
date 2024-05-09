1 pragma solidity ^0.4.13;
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
13 
14     uint private bitlocks = 0;
15     modifier noReentrancy(uint m) {
16         var _locks = bitlocks;
17         require(_locks & m <= 0);
18         bitlocks |= m;
19         _;
20         bitlocks = _locks;
21     }
22 
23     modifier noAnyReentrancy {
24         var _locks = bitlocks;
25         require(_locks <= 0);
26         bitlocks = uint(-1);
27         _;
28         bitlocks = _locks;
29     }
30 
31     modifier reentrant { _; }
32 }
33 
34 contract Owned {
35     address public owner;
36     address public newOwner;
37     
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function Owned() public {
44         owner = msg.sender;
45     }
46 
47     function transferOwnership(address _newOwner) onlyOwner public {
48         newOwner = _newOwner;
49     }
50 
51     function acceptOwnership() onlyOwner public {
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 }
58 
59 contract Crowdsale is Base, Owned {
60     using SafeMath for uint256;
61 
62     enum State { INIT, ICO, CLOSED, PAUSE }
63 
64     uint public constant DECIMALS = 10**18;
65     uint public constant WEI_DECIMALS = 10**18;
66     uint public constant MAX_SUPPLY = 3400000000 * DECIMALS;
67 
68     mapping (address => bool) investors;
69     State public currentState = State.INIT;
70     IToken public token;
71 
72     uint public totalSupply = 0;
73 
74     uint public totalFunds = 0;
75     uint public currentPrice = WEI_DECIMALS / 166;
76     address public beneficiary;
77     uint public countMembers = 0;
78 
79     event Transfer(address indexed _to, uint256 _value);
80 
81     modifier inState(State _state){
82         require(currentState == _state);
83         _;
84     }
85 
86     modifier salesRunning(){
87         require(currentState == State.ICO);
88         _;
89     }
90 
91     modifier notClosed(){
92         require(currentState != State.CLOSED);
93         _;
94     }
95 
96     function Crowdsale(address _beneficiary) public {
97         beneficiary = _beneficiary;
98     }
99 
100     function ()
101         public
102         payable
103         salesRunning
104     {
105         _receiveFunds();
106     }
107 
108     function initialize(address _token)
109         public
110         onlyOwner
111         inState(State.INIT)
112     {
113         require(_token != address(0));
114         token = IToken(_token);
115     }
116 
117     function setTokenPrice(uint _tokenPrice) public
118         onlyOwner
119         notClosed
120     {
121         currentPrice = _tokenPrice;
122     }
123 
124     function setTokenPriceAsRatio(uint _tokenCount) public
125         onlyOwner
126         notClosed
127     {
128         currentPrice = WEI_DECIMALS / _tokenCount;
129     }
130 
131     function setState(State _newState)
132         public
133         onlyOwner
134     {
135         require(currentState != State.CLOSED);
136         require(
137             (currentState == State.INIT && _newState == State.ICO ||
138              currentState == State.ICO && _newState == State.CLOSED ||
139             currentState == State.ICO && _newState == State.PAUSE ||
140             currentState == State.PAUSE && _newState == State.ICO)
141         );
142 
143         if(_newState == State.CLOSED){
144             _finish();
145         }
146         currentState = _newState;
147     }
148 
149 
150     function withdraw(uint _amount)
151         public
152         noAnyReentrancy
153         onlyOwner
154     {
155         require(_amount > 0 && _amount <= this.balance);
156         beneficiary.transfer(_amount);
157     }
158 
159     function sendToken(address _to, uint _amount)
160         public
161         onlyOwner
162         salesRunning
163     {
164         uint amount = _amount.mul(DECIMALS);
165         _checkMaxSaleSupply(amount);
166         _mint(_to, amount);
167     }
168 
169 
170     function getCountMembers()
171         public
172         constant
173         returns(uint)
174     {
175         return countMembers;
176     }
177 
178 
179     //==================== Internal Methods =================
180     function _mint(address _to, uint _amount)
181         noAnyReentrancy
182         internal
183     {
184         _increaseSupply(_amount);
185         IToken(token).mint(_to, _amount);
186         Transfer(_to, _amount);
187     }
188 
189     function _finish()
190         noAnyReentrancy
191         internal
192     {
193         IToken(token).start();
194     }
195 
196     function _receiveFunds()
197         internal
198     {
199         require(msg.value != 0);
200         uint weiAmount = msg.value;
201         uint transferTokens = weiAmount.mul(DECIMALS).div(currentPrice);
202 
203         _checkMaxSaleSupply(transferTokens);
204 
205         if(!investors[msg.sender]){
206             countMembers = countMembers.add(1);
207             investors[msg.sender] = true;
208         }
209         totalFunds = totalFunds.add(weiAmount);
210         _mint(msg.sender, transferTokens);
211     }
212 
213     function _checkMaxSaleSupply(uint transferTokens)
214         internal
215     {
216         require(totalSupply.add(transferTokens) <= MAX_SUPPLY);
217     }
218 
219     function _increaseSupply(uint _amount)
220         internal
221     {
222         totalSupply = totalSupply.add(_amount);
223     }
224 
225 }
226 
227 library SafeMath {
228     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
229         uint256 c = a * b;
230         assert(a == 0 || c / a == b);
231         return c;
232     }
233 
234     function div(uint256 a, uint256 b) internal constant returns (uint256) {
235         // assert(b > 0); // Solidity automatically throws when dividing by 0
236         uint256 c = a / b;
237         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238         return c;
239     }
240 
241     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
242         assert(b <= a);
243         return a - b;
244     }
245 
246     function add(uint256 a, uint256 b) internal constant returns (uint256) {
247         uint256 c = a + b;
248         assert(c >= a);
249         return c;
250     }
251 }
252 
253 contract IToken {
254   uint256 public totalSupply;
255   function mint(address _to, uint _amount) public returns(bool);
256   function start() public;
257   function balanceOf(address who) public constant returns (uint256);
258   function transfer(address to, uint256 value) public returns (bool);
259 }
260 
261 contract TokenTimelock {
262   IToken public token;
263   address public beneficiary;
264   uint64 public releaseTime;
265 
266   function TokenTimelock(address _token, address _beneficiary, uint64 _releaseTime) public {
267     require(_releaseTime > now);
268     token = IToken(_token);
269     beneficiary = _beneficiary;
270     releaseTime = _releaseTime;
271   }
272 
273   function release() public {
274     require(now >= releaseTime);
275 
276     uint256 amount = token.balanceOf(this);
277     require(amount > 0);
278 
279     token.transfer(beneficiary, amount);
280   }
281 }