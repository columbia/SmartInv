1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 
92 contract CryptoRoboticsToken {
93     uint256 public totalSupply;
94     function balanceOf(address who) public view returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101     function burn(uint256 value) public;
102 }
103 
104 
105 contract RefundVault is Ownable {
106     using SafeMath for uint256;
107 
108     enum State { Active, Refunding, Closed }
109 
110     mapping (address => uint256) public deposited;
111     address public wallet;
112     State public state;
113 
114     event Closed();
115     event RefundsEnabled();
116     event Refunded(address indexed beneficiary, uint256 weiAmount);
117 
118     /**
119      * @param _wallet Vault address
120      */
121     function RefundVault(address _wallet) public {
122         require(_wallet != address(0));
123         wallet = _wallet;
124         state = State.Active;
125     }
126 
127     /**
128      * @param investor Investor address
129      */
130     function deposit(address investor) onlyOwner public payable {
131         require(state == State.Active);
132         deposited[investor] = deposited[investor].add(msg.value);
133     }
134 
135     function close() onlyOwner public {
136         require(state == State.Active);
137         state = State.Closed;
138         emit Closed();
139         wallet.transfer(address(this).balance);
140     }
141 
142     function enableRefunds() onlyOwner public {
143         require(state == State.Active);
144         state = State.Refunding;
145         emit RefundsEnabled();
146     }
147 
148     /**
149      * @param investor Investor address
150      */
151     function refund(address investor) public {
152         require(state == State.Refunding);
153         uint256 depositedValue = deposited[investor];
154         deposited[investor] = 0;
155         investor.transfer(depositedValue);
156         emit Refunded(investor, depositedValue);
157     }
158 }
159 
160 
161 contract Crowdsale is Ownable {
162     using SafeMath for uint256;
163 
164     // The token being sold
165     CryptoRoboticsToken public token;
166     //MAKE APPROVAL TO Crowdsale
167     address public reserve_fund = 0x7C88C296B9042946f821F5456bd00EA92a13B3BB;
168     address preico;
169 
170     // Address where funds are collected
171     address public wallet;
172 
173     // Amount of wei raised
174     uint256 public weiRaised;
175 
176     uint256 public openingTime;
177     uint256 public closingTime;
178 
179     bool public isFinalized = false;
180 
181     uint public currentStage = 0;
182 
183     uint256 public goal = 1000 ether;
184     uint256 public cap  = 6840  ether;
185 
186     RefundVault public vault;
187 
188 
189 
190     //price in wei for stage
191     uint[4] public stagePrices = [
192     127500000000000 wei,     //0.000085 - ICO Stage 1
193     135 szabo,     //0.000090 - ICO Stage 2
194     142500000000000 wei,     //0.000095 - ICO Stage 3
195     150 szabo     //0.0001 - ICO Stage 4
196     ];
197 
198     //limit in wei for stage 612 + 1296 + 2052 + 2880
199     uint[4] internal stageLimits = [
200     612 ether,    //4800000 tokens 10% of ICO tokens (ICO token 40% of all (48 000 000) )
201     1296 ether,    //9600000 tokens 20% of ICO tokens
202     2052 ether,   //14400000 tokens 30% of ICO tokens
203     2880 ether    //19200000 tokens 40% of ICO tokens
204     ];
205 
206     mapping(address => bool) public referrals;
207     mapping(address => uint) public reservedTokens;
208     mapping(address => uint) public reservedRefsTokens;
209     uint public amountReservedTokens;
210     uint public amountReservedRefsTokens;
211 
212     event Finalized();
213     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
214     event TokenReserved(address indexed beneficiary, uint256 value, uint256 amount, address referral);
215 
216 
217     modifier onlyWhileOpen {
218         require(now >= openingTime && now <= closingTime);
219         _;
220     }
221 
222 
223     modifier onlyPreIco {
224         require(msg.sender == preico);
225         _;
226     }
227 
228 
229     function Crowdsale(CryptoRoboticsToken _token) public
230     {
231         require(_token != address(0));
232 
233         wallet = 0x3eb945fd746fbdf641f1063731d91a6fb381ea0f;
234         token = _token;
235         openingTime = 1526774400;
236         closingTime = 1532044800;
237         vault = new RefundVault(wallet);
238     }
239 
240 
241     function () external payable {
242         buyTokens(msg.sender, address(0));
243     }
244 
245 
246     function buyTokens(address _beneficiary, address _ref) public payable {
247         uint256 weiAmount = msg.value;
248         _preValidatePurchase(_beneficiary, weiAmount);
249         _getTokenAmount(weiAmount,true,_beneficiary,_ref);
250     }
251 
252 
253     function reserveTokens(address _ref) public payable {
254         uint256 weiAmount = msg.value;
255         _preValidateReserve(msg.sender, weiAmount, _ref);
256         _getTokenAmount(weiAmount, false,msg.sender,_ref);
257     }
258 
259 
260     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {
261         require(weiRaised.add(_weiAmount) <= cap);
262         require(_weiAmount >= stagePrices[currentStage]);
263         require(_beneficiary != address(0));
264 
265     }
266 
267     function _preValidateReserve(address _beneficiary, uint256 _weiAmount, address _ref) internal view {
268         require(now < openingTime);
269         require(referrals[_ref]);
270         require(weiRaised.add(_weiAmount) <= cap);
271         require(_weiAmount >= stagePrices[currentStage]);
272         require(_beneficiary != address(0));
273     }
274 
275 
276     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
277         token.transfer(_beneficiary, _tokenAmount);
278     }
279 
280 
281     function _processPurchase(address _beneficiary, uint256 _tokenAmount, address _ref) internal {
282         _tokenAmount = _tokenAmount * 1 ether;
283         _deliverTokens(_beneficiary, _tokenAmount);
284         if (referrals[_ref]) {
285             uint _refTokens = valueFromPercent(_tokenAmount,10);
286             token.transferFrom(reserve_fund, _ref, _refTokens);
287         }
288     }
289 
290 
291     function _processReserve(address _beneficiary, uint256 _tokenAmount, address _ref) internal {
292         _tokenAmount = _tokenAmount * 1 ether;
293         _reserveTokens(_beneficiary, _tokenAmount);
294         uint _refTokens = valueFromPercent(_tokenAmount,10);
295         _reserveRefTokens(_ref, _refTokens);
296     }
297 
298 
299     function _reserveTokens(address _beneficiary, uint256 _tokenAmount) internal {
300         reservedTokens[_beneficiary] = reservedTokens[_beneficiary].add(_tokenAmount);
301         amountReservedTokens = amountReservedTokens.add(_tokenAmount);
302     }
303 
304 
305     function _reserveRefTokens(address _beneficiary, uint256 _tokenAmount) internal {
306         reservedRefsTokens[_beneficiary] = reservedRefsTokens[_beneficiary].add(_tokenAmount);
307         amountReservedRefsTokens = amountReservedRefsTokens.add(_tokenAmount);
308     }
309 
310 
311     function getReservedTokens() public {
312         require(now >= openingTime);
313         require(reservedTokens[msg.sender] > 0);
314         amountReservedTokens = amountReservedTokens.sub(reservedTokens[msg.sender]);
315         reservedTokens[msg.sender] = 0;
316         token.transfer(msg.sender, reservedTokens[msg.sender]);
317     }
318 
319 
320     function getRefReservedTokens() public {
321         require(now >= openingTime);
322         require(reservedRefsTokens[msg.sender] > 0);
323         amountReservedRefsTokens = amountReservedRefsTokens.sub(reservedRefsTokens[msg.sender]);
324         reservedRefsTokens[msg.sender] = 0;
325         token.transferFrom(reserve_fund, msg.sender, reservedRefsTokens[msg.sender]);
326     }
327 
328 
329     function valueFromPercent(uint _value, uint _percent) internal pure returns(uint amount)    {
330         uint _amount = _value.mul(_percent).div(100);
331         return (_amount);
332     }
333 
334 
335     function _getTokenAmount(uint256 _weiAmount, bool _buy, address _beneficiary, address _ref) internal {
336         uint256 weiAmount = _weiAmount;
337         uint _tokens = 0;
338         uint _tokens_price = 0;
339         uint _current_tokens = 0;
340 
341         for (uint p = currentStage; p < 4 && _weiAmount >= stagePrices[p]; p++) {
342             if (stageLimits[p] > 0 ) {
343                 //если лимит больше чем _weiAmount, тогда считаем все из расчета что вписываемся в лимит
344                 //и выходим из цикла
345                 if (stageLimits[p] > _weiAmount) {
346                     //количество токенов по текущему прайсу (останется остаток если прислали  больше чем на точное количество монет)
347                     _current_tokens = _weiAmount.div(stagePrices[p]);
348                     //цена всех монет, чтобы определить остаток неизрасходованных wei
349                     _tokens_price = _current_tokens.mul(stagePrices[p]);
350                     //получаем остаток
351                     _weiAmount = _weiAmount.sub(_tokens_price);
352                     //добавляем токены текущего стэйджа к общему количеству
353                     _tokens = _tokens.add(_current_tokens);
354                     //обновляем лимиты
355                     stageLimits[p] = stageLimits[p].sub(_tokens_price);
356                     break;
357                 } else { //лимит меньше чем количество wei
358                     //получаем все оставшиеся токены в стейдже
359                     _current_tokens = stageLimits[p].div(stagePrices[p]);
360                     _weiAmount = _weiAmount.sub(stageLimits[p]);
361                     _tokens = _tokens.add(_current_tokens);
362                     stageLimits[p] = 0;
363                     _updateStage();
364                 }
365 
366             }
367         }
368 
369         weiAmount = weiAmount.sub(_weiAmount);
370         weiRaised = weiRaised.add(weiAmount);
371 
372         if (_buy) {
373             _processPurchase(_beneficiary, _tokens, _ref);
374             emit TokenPurchase(msg.sender, _beneficiary, weiAmount, _tokens);
375         } else {
376             _processReserve(msg.sender, _tokens, _ref);
377             emit TokenReserved(msg.sender, weiAmount, _tokens, _ref);
378         }
379 
380         //отправляем обратно неизрасходованный остаток
381         if (_weiAmount > 0) {
382             msg.sender.transfer(_weiAmount);
383         }
384 
385         // update state
386 
387 
388         _forwardFunds(weiAmount);
389     }
390 
391 
392     function _updateStage() internal {
393         if ((stageLimits[currentStage] == 0) && currentStage < 3) {
394             currentStage++;
395         }
396     }
397 
398 
399     function _forwardFunds(uint _weiAmount) internal {
400         vault.deposit.value(_weiAmount)(msg.sender);
401     }
402 
403 
404     function hasClosed() public view returns (bool) {
405         return now > closingTime;
406     }
407 
408 
409     function capReached() public view returns (bool) {
410         return weiRaised >= cap;
411     }
412 
413 
414     function goalReached() public view returns (bool) {
415         return weiRaised >= goal;
416     }
417 
418 
419     function finalize() onlyOwner public {
420         require(!isFinalized);
421         require(hasClosed() || capReached());
422 
423         finalization();
424         emit Finalized();
425 
426         isFinalized = true;
427     }
428 
429 
430     function finalization() internal {
431         if (goalReached()) {
432             vault.close();
433         } else {
434             vault.enableRefunds();
435         }
436 
437         uint token_balace = token.balanceOf(this);
438         token_balace = token_balace.sub(amountReservedTokens);//
439         token.burn(token_balace);
440     }
441 
442 
443     function addReferral(address _ref) external onlyOwner {
444         referrals[_ref] = true;
445     }
446 
447 
448     function removeReferral(address _ref) external onlyOwner {
449         referrals[_ref] = false;
450     }
451 
452 
453     function setPreIco(address _preico) onlyOwner public {
454         preico = _preico;
455     }
456 
457 
458     function setTokenCountFromPreIco(uint _value) onlyPreIco public{
459         _value = _value.div(1 ether);
460         uint weis = _value.mul(stagePrices[3]);
461         stageLimits[3] = stageLimits[3].add(weis);
462         cap = cap.add(weis);
463 
464     }
465 
466 
467     function claimRefund() public {
468         require(isFinalized);
469         require(!goalReached());
470 
471         vault.refund(msg.sender);
472     }
473 
474 }