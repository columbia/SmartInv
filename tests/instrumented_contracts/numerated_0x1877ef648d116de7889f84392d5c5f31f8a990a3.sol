1 pragma solidity ^0.5.0;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () internal {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(isOwner(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function isOwner() public view returns (bool) {
37         return _msgSender() == _owner;
38     }
39 
40     function renounceOwnership() public onlyOwner {
41         emit OwnershipTransferred(_owner, address(0));
42         _owner = address(0);
43     }
44 
45     function transferOwnership(address newOwner) public onlyOwner {
46         _transferOwnership(newOwner);
47     }
48 
49     function _transferOwnership(address newOwner) internal {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         emit OwnershipTransferred(_owner, newOwner);
52         _owner = newOwner;
53     }
54 }
55 
56 library Address {
57     function isContract(address account) internal view returns (bool) {
58         bytes32 codehash;
59         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
60         assembly { codehash := extcodehash(account) }
61         return (codehash != accountHash && codehash != 0x0);
62     }
63 
64     function toPayable(address account) internal pure returns (address payable) {
65         return address(uint160(account));
66     }
67 
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         (bool success, ) = recipient.call.value(amount)("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 }
75 
76 interface IERC20 {
77     function totalSupply() external view returns (uint256);
78 
79     function balanceOf(address account) external view returns (uint256);
80 
81     function transfer(address recipient, uint256 amount) external returns (bool);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 library SafeMath {
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b <= a, errorMessage);
108         uint256 c = a - b;
109 
110         return c;
111     }
112 
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117 
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120 
121         return c;
122     }
123 
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131 
132         return c;
133     }
134 
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 library SafeERC20 {
146     using SafeMath for uint256;
147     using Address for address;
148 
149     function safeTransfer(IERC20 token, address to, uint256 value) internal {
150         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
151     }
152 
153     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
154         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
155     }
156 
157     function safeApprove(IERC20 token, address spender, uint256 value) internal {
158         require((value == 0) || (token.allowance(address(this), spender) == 0),
159             "SafeERC20: approve from non-zero to non-zero allowance"
160         );
161         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
162     }
163 
164     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
165         uint256 newAllowance = token.allowance(address(this), spender).add(value);
166         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
167     }
168 
169     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
170         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
171         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
172     }
173 
174     function callOptionalReturn(IERC20 token, bytes memory data) private {
175         require(address(token).isContract(), "SafeERC20: call to non-contract");
176 
177         (bool success, bytes memory returndata) = address(token).call(data);
178         require(success, "SafeERC20: low-level call failed");
179 
180         if (returndata.length > 0) {
181             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
182         }
183     }
184 }
185 
186 contract ReentrancyGuard {
187     bool private _notEntered;
188 
189     constructor () internal {
190         _notEntered = true;
191     }
192 
193     modifier nonReentrant() {
194         require(_notEntered, "ReentrancyGuard: reentrant call");
195 
196         _notEntered = false;
197 
198         _;
199 
200         _notEntered = true;
201     }
202 }
203 
204 contract Crowdsale is Context, ReentrancyGuard {
205     using SafeMath for uint256;
206     using SafeERC20 for IERC20;
207 
208     IERC20 private _token;
209 
210     address payable private _wallet;
211 
212     uint256 private _rate;
213 
214     uint256 private _weiRaised;
215 
216     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
217 
218     constructor (uint256 rate, address payable wallet, IERC20 token) public {
219         require(rate > 0, "Crowdsale: rate is 0");
220         require(wallet != address(0), "Crowdsale: wallet is the zero address");
221         require(address(token) != address(0), "Crowdsale: token is the zero address");
222 
223         _rate = rate;
224         _wallet = wallet;
225         _token = token;
226     }
227 
228     function () external payable {
229         buyTokens(_msgSender());
230     }
231 
232     function token() public view returns (IERC20) {
233         return _token;
234     }
235 
236     function wallet() public view returns (address payable) {
237         return _wallet;
238     }
239 
240     function rate() public view returns (uint256) {
241         return _rate;
242     }
243 
244     function weiRaised() public view returns (uint256) {
245         return _weiRaised;
246     }
247 
248     function buyTokens(address beneficiary) public nonReentrant payable {
249         uint256 weiAmount = msg.value;
250         _preValidatePurchase(beneficiary, weiAmount);
251 
252         uint256 tokens = _getTokenAmount(weiAmount);
253 
254         _weiRaised = _weiRaised.add(weiAmount);
255 
256         _processPurchase(beneficiary, tokens);
257         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
258 
259         _updatePurchasingState(beneficiary, weiAmount);
260 
261         _forwardFunds();
262         _postValidatePurchase(beneficiary, weiAmount);
263     }
264 
265     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
266         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
267         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
268         this;
269     }
270 
271     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
272 
273     }
274 
275     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
276         _token.safeTransfer(beneficiary, tokenAmount);
277     }
278 
279     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
280         _deliverTokens(beneficiary, tokenAmount);
281     }
282 
283     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
284 
285     }
286 
287     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
288         return weiAmount.mul(_rate);
289     }
290 
291     function _forwardFunds() internal {
292         _wallet.transfer(msg.value);
293     }
294 }
295 
296 library Math {
297     function max(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a >= b ? a : b;
299     }
300 
301     function min(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a < b ? a : b;
303     }
304 
305     function average(uint256 a, uint256 b) internal pure returns (uint256) {
306         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
307     }
308 }
309 
310 contract AllowanceCrowdsale is Crowdsale {
311     using SafeMath for uint256;
312     using SafeERC20 for IERC20;
313 
314     address private _tokenWallet;
315 
316     constructor (address tokenWallet) public {
317         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
318         _tokenWallet = tokenWallet;
319     }
320 
321     function tokenWallet() public view returns (address) {
322         return _tokenWallet;
323     }
324 
325     function remainingTokens() public view returns (uint256) {
326         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
327     }
328 
329     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
330         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
331     }
332 }
333 
334 contract TimedCrowdsale is Crowdsale {
335     using SafeMath for uint256;
336 
337     uint256 private _openingTime;
338     uint256 private _closingTime;
339 
340     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
341 
342     modifier onlyWhileOpen {
343         require(isOpen(), "TimedCrowdsale: not open");
344         _;
345     }
346 
347     constructor (uint256 openingTime, uint256 closingTime) public {
348         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
349         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
350 
351         _openingTime = openingTime;
352         _closingTime = closingTime;
353     }
354 
355     function openingTime() public view returns (uint256) {
356         return _openingTime;
357     }
358 
359     function closingTime() public view returns (uint256) {
360         return _closingTime;
361     }
362 
363     function isOpen() public view returns (bool) {
364         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
365     }
366 
367     function hasClosed() public view returns (bool) {
368         return block.timestamp > _closingTime;
369     }
370 
371     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
372         super._preValidatePurchase(beneficiary, weiAmount);
373     }
374 
375     function _extendTime(uint256 newClosingTime) internal {
376         require(!hasClosed(), "TimedCrowdsale: already closed");
377         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
378 
379         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
380         _closingTime = newClosingTime;
381     }
382 }
383 
384 interface ISmartexOracle {
385   function currentETHPrice() external view returns (uint256);
386   function lastETHPriceUpdate() external view returns (uint256);
387 
388   function currentTokenPrice() external view returns (uint256);
389   function lastTokenPriceUpdate() external view returns (uint256);
390 
391   function setETHPrice(uint256 price) external;
392   function updateTokenPrice() external;
393 
394   event ETHPriceUpdated(uint256 price, uint256 timestamp);
395   event TokenPriceUpdated(uint256 price, uint256 timestamp);
396 }
397 
398 contract SmartexCrowdsale is Ownable, AllowanceCrowdsale, TimedCrowdsale {
399   using Address for address;
400 
401   address payable private _secondWallet;
402 
403   ISmartexOracle private _oracle;
404 
405   uint256 constant private _firstEdge = 50 ether;
406   uint256 constant private _secondEdge = 100 ether;
407 
408   constructor(address payable wallet, address payable secondWallet, IERC20 token)
409     public
410     AllowanceCrowdsale(_msgSender())
411     TimedCrowdsale(now, now + 3 days)
412     Crowdsale(8 * (10 ** 7), wallet, token)
413   {
414     _secondWallet = secondWallet;
415   }
416 
417   function secondWallet() public view returns (address payable) {
418     return _secondWallet;
419   }
420 
421   function setOracle(ISmartexOracle oracle) public onlyOwner {
422     _oracle = oracle;
423   }
424 
425   function oracle() public view returns (ISmartexOracle) {
426     return _oracle;
427   }
428 
429   function extendTime(uint256 newClosingTime) public onlyOwner {
430     super._extendTime(newClosingTime);
431   }
432 
433   function getWeiAmount(uint256 tokens) public view returns (uint256) {
434     return _getWeiAmount(tokens);
435   }
436 
437   function getTokenAmount(uint256 weiAmount) public view returns (uint256) {
438     return _getTokenAmount(weiAmount);
439   }
440 
441 
442   function _getWeiAmount(uint256 tokens) internal view returns (uint256) {
443     return tokens.mul(rate()).div(_oracle.currentETHPrice());
444   }
445 
446   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
447     return weiAmount.mul(_oracle.currentETHPrice()).div(rate());
448   }
449 
450   function _forwardFunds() internal {
451     (uint256 ownerPayment, uint256 walletsPayment) = _splitPayment();
452 
453     owner().toPayable().transfer(ownerPayment);
454 
455     if (walletsPayment > 0) {
456       uint256 firstWalletPayment = walletsPayment.div(2);
457       uint256 secondWalletPayment = walletsPayment.sub(firstWalletPayment);
458 
459       wallet().transfer(firstWalletPayment);
460       secondWallet().transfer(secondWalletPayment);
461     }
462   }
463 
464   function _splitPayment() internal returns (uint256, uint256) {
465     uint256 raised = weiRaised();
466     uint256 prevRaised = raised.sub(msg.value);
467 
468     if (raised <= _firstEdge) {
469       return (msg.value, 0);
470     }
471 
472     uint256 toSplit = msg.value;
473     uint256 diff = 0;
474     uint8 percent;
475     uint256 edge;
476 
477     if (raised > _firstEdge && raised <= _secondEdge) {
478       edge = _firstEdge;
479       percent = 80;
480     } else {
481       edge = _secondEdge;
482       percent = 70;
483     }
484 
485     if (prevRaised < edge) {
486       diff = edge.sub(prevRaised);
487       toSplit = toSplit.sub(diff);
488     }
489 
490     uint256 ownerPayment = toSplit.mul(percent).div(100);
491     uint256 walletsPayment = toSplit.sub(ownerPayment);
492 
493     return (ownerPayment.add(diff), walletsPayment);
494   }
495 }