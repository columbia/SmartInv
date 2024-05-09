1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract TokenTimeLock {
30     IToken public token;
31 
32     address public beneficiary;
33 
34     uint public releaseTimeFirst;
35     uint public amountFirst;
36 
37     uint public releaseTimeSecond;
38     uint public amountSecond;
39 
40 
41     function TokenTimeLock(IToken _token, address _beneficiary, uint _releaseTimeFirst, uint _amountFirst, uint _releaseTimeSecond, uint _amountSecond)
42     public
43     {
44         require(_releaseTimeFirst > now && _releaseTimeSecond > now);
45         token = _token;
46         beneficiary = _beneficiary;
47 
48         releaseTimeFirst = _releaseTimeFirst;
49         releaseTimeSecond  = _releaseTimeSecond;
50         amountFirst = _amountFirst;
51         amountSecond = _amountSecond;
52     }
53 
54     function releaseFirst() public {
55         require(now >= releaseTimeFirst);
56 
57         uint amount = token.balanceOf(this);
58         require(amount > 0 && amount >= amountFirst);
59 
60         token.transfer(beneficiary, amountFirst);
61     }
62 
63     function releaseSecond() public {
64         require(now >= releaseTimeSecond);
65 
66         uint amount = token.balanceOf(this);
67         require(amount > 0 && amount >= amountSecond);
68 
69         token.transfer(beneficiary, amountSecond);
70     }
71 }
72 
73 contract Base {
74     modifier only(address allowed) {
75         require(msg.sender == allowed);
76         _;
77     }
78 
79     // *************************************************
80     // *          reentrancy handling                  *
81     // *************************************************
82 
83     uint constant internal L00 = 2 ** 0;
84     uint constant internal L01 = 2 ** 1;
85     uint constant internal L02 = 2 ** 2;
86     uint constant internal L03 = 2 ** 3;
87     uint constant internal L04 = 2 ** 4;
88     uint constant internal L05 = 2 ** 5;
89 
90     uint private bitlocks = 0;
91 
92     modifier noAnyReentrancy {
93         var _locks = bitlocks;
94         require(_locks == 0);
95         bitlocks = uint(-1);
96         _;
97         bitlocks = _locks;
98     }
99 
100 }
101 
102 contract Owned is Base {
103 
104     address public owner;
105     address newOwner;
106 
107     function Owned() {
108         owner = msg.sender;
109     }
110 
111     function transferOwnership(address _newOwner) only(owner) {
112         newOwner = _newOwner;
113     }
114 
115     function acceptOwnership() only(newOwner) {
116         OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119 
120     event OwnershipTransferred(address indexed _from, address indexed _to);
121 
122 }
123 
124 contract IToken {
125     function mint(address _to, uint _amount);
126     function start();
127     function getTotalSupply() returns(uint);
128     function balanceOf(address _owner) returns(uint);
129     function transfer(address _to, uint _amount) returns (bool success);
130     function transferFrom(address _from, address _to, uint _value) returns (bool success);
131 }
132 
133 contract Crowdsale is Owned {
134     using SafeMath for uint;
135 
136     enum State { INIT, PRESALE, PREICO, PREICO_FINISHED, ICO, CLOSED, EMERGENCY_STOP}
137     uint public constant MAX_SALE_SUPPLY = 26 * (10**24);
138 
139     State public currentState = State.INIT;
140     IToken public token;
141     uint public totalSaleSupply = 0;
142     uint public totalFunds = 0;
143     uint public tokenPrice = 1000000000000000000; //wei
144     uint public bonus = 5000; //50%
145     uint public currentPrice;
146     address public beneficiary;
147     mapping(address => uint) balances;
148     mapping(address => TokenTimeLock) lockBalances;
149     mapping(address => uint) prices;
150 
151     uint private bonusBase = 10000; //100%;
152 
153     address confirmOwner = 0x40e72D1052A1bd4c40E5850DAC46C8B44e366a59;
154     
155     event Transfer(address indexed _to, uint _value);
156 
157     modifier onlyConfirmOwner(){
158         require(msg.sender == confirmOwner);
159         _;
160     }
161     
162     modifier inState(State _state){
163         require(currentState == _state);
164         _;
165     }
166 
167     modifier salesRunning(){
168         require(currentState == State.PREICO || currentState == State.ICO);
169         _;
170     }
171 
172     function Crowdsale(address _beneficiary){
173         beneficiary = _beneficiary;
174     }
175 
176     function initialize(IToken _token)
177     public
178     only(owner)
179     inState(State.INIT)
180     {
181         require(_token != address(0));
182 
183         token = _token;
184         currentPrice = tokenPrice.mul(bonus).div(bonusBase);
185     }
186 
187     function setBonus(uint _bonus) public
188     only(owner)
189     {
190         bonus = _bonus;
191         currentPrice = tokenPrice.mul(bonus).div(bonusBase);
192     }
193 
194     function setPrice(uint _tokenPrice)
195     public
196     only(owner)
197     {
198         tokenPrice = _tokenPrice;
199         currentPrice = tokenPrice.mul(bonus).div(bonusBase);
200     }
201 
202     function setState(State _newState)
203     public
204     only(owner)
205     {
206         require(
207         currentState == State.INIT && _newState == State.PRESALE
208         || currentState == State.PRESALE && _newState == State.PREICO
209         || currentState == State.PREICO && _newState == State.PREICO_FINISHED
210         || currentState == State.PREICO_FINISHED && _newState == State.ICO
211         || currentState == State.ICO && _newState == State.CLOSED
212         || _newState == State.EMERGENCY_STOP
213         );
214 
215         currentState = _newState;
216 
217         if(_newState == State.CLOSED){
218             _finish();
219         }
220     }
221 
222     function mintPresaleWithBlock(address _to, uint _firstStake, uint _firstUnblockDate, uint _secondStake, uint _secondUnblockDate)
223     public
224     only(owner)
225     inState(State.PRESALE)
226     {
227         uint totalAmount = _firstStake.add(_secondStake);
228         require(totalSaleSupply.add(totalAmount) <= MAX_SALE_SUPPLY);
229 
230         totalSaleSupply = totalSaleSupply.add(totalAmount);
231 
232         TokenTimeLock tokenTimeLock = new TokenTimeLock(token, _to, _firstUnblockDate, _firstStake, _secondUnblockDate, _secondStake);
233         lockBalances[_to] = tokenTimeLock;
234         _mint(address(tokenTimeLock), totalAmount);
235     }
236 
237     function unblockFirstStake()
238     public
239     inState(State.CLOSED)
240     {
241         require(address(lockBalances[msg.sender]) != 0);
242 
243         lockBalances[msg.sender].releaseFirst();
244     }
245 
246     function unblockSecondStake()
247     public
248     inState(State.CLOSED)
249     {
250         require(address(lockBalances[msg.sender]) != 0);
251 
252         lockBalances[msg.sender].releaseSecond();
253     }
254 
255     function mintPresale(address _to, uint _amount)
256     public
257     only(owner)
258     inState(State.PRESALE)
259     {
260         require(totalSaleSupply.add(_amount) <= MAX_SALE_SUPPLY);
261 
262         totalSaleSupply = totalSaleSupply.add(_amount);
263 
264         _mint(_to, _amount);
265     }
266 
267     function ()
268     public
269     payable
270     salesRunning
271     {
272         _receiveFunds();
273     }
274 
275     function setTokenPrice(address _token, uint _price)
276     only(owner)
277     {
278         prices[_token] = _price;
279     }
280 
281     function mint(uint _amount, address _erc20OrEth)
282     public
283     payable
284     salesRunning
285     {
286         uint transferTokens;
287 
288         if(_erc20OrEth == address(0)){
289             require(msg.value != 0);
290             uint weiAmount = msg.value;
291             transferTokens = weiAmount.div(currentPrice);
292             require(totalSaleSupply.add(transferTokens) <= MAX_SALE_SUPPLY);
293 
294             totalSaleSupply = totalSaleSupply.add(transferTokens);
295             balances[msg.sender] = balances[msg.sender].add(weiAmount);
296             totalFunds = totalFunds.add(weiAmount);
297 
298             _mint(msg.sender, transferTokens);
299             beneficiary.transfer(weiAmount);
300             Transfer(msg.sender, transferTokens);
301         } else {
302             uint price = prices[_erc20OrEth];
303 
304             require(price > 0 && _amount > 0);
305 
306             transferTokens = _amount.div(price);
307             require(totalSaleSupply.add(transferTokens) <= MAX_SALE_SUPPLY);
308 
309             totalSaleSupply = totalSaleSupply.add(transferTokens);
310             balances[msg.sender] = balances[msg.sender].add(weiAmount);
311             totalFunds = totalFunds.add(weiAmount);
312 
313             IToken(_erc20OrEth).transferFrom(msg.sender, beneficiary, transferTokens);
314             Transfer(msg.sender, transferTokens);
315         }
316     }
317 
318     function refundBalance(address _owner)
319     public
320     constant
321     returns(uint)
322     {
323         return balances[_owner];
324     }
325     
326     function investDirect(address _to, uint _amount)
327     public
328     salesRunning
329     onlyConfirmOwner
330     {
331 
332         require(totalSaleSupply.add(_amount) <= MAX_SALE_SUPPLY);
333 
334         totalSaleSupply = totalSaleSupply.add(_amount);
335 
336         _mint(_to, _amount);
337         Transfer(_to, _amount);
338         
339     }
340     //==================== Internal Methods =================
341     function _receiveFunds()
342     internal
343     {
344         require(msg.value != 0);
345         uint transferTokens = msg.value.div(currentPrice);
346         require(totalSaleSupply.add(transferTokens) <= MAX_SALE_SUPPLY);
347 
348         totalSaleSupply = totalSaleSupply.add(transferTokens);
349         balances[msg.sender] = balances[msg.sender].add(msg.value);
350         totalFunds = totalFunds.add(msg.value);
351 
352         _mint(msg.sender, transferTokens);
353         beneficiary.transfer(msg.value);
354         Transfer(msg.sender, transferTokens);
355     }
356     function _mint(address _to, uint _amount)
357     noAnyReentrancy
358     internal
359     {
360         token.mint(_to, _amount);
361     }
362 
363     function _finish()
364     noAnyReentrancy
365     internal
366     {
367         token.start();
368     }
369 }