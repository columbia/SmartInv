1 pragma solidity ^0.4.21;
2 
3 interface ExchangeInterface {
4 
5     event Subscribed(address indexed user);
6     event Unsubscribed(address indexed user);
7 
8     event Cancelled(bytes32 indexed hash);
9 
10     event Traded(
11         bytes32 indexed hash,
12         address makerToken,
13         uint makerTokenAmount,
14         address takerToken,
15         uint takerTokenAmount,
16         address maker,
17         address taker
18     );
19 
20     event Ordered(
21         address maker,
22         address makerToken,
23         address takerToken,
24         uint makerTokenAmount,
25         uint takerTokenAmount,
26         uint expires,
27         uint nonce
28     );
29 
30     function subscribe() external;
31     function unsubscribe() external;
32 
33     function trade(address[3] addresses, uint[4] values, bytes signature, uint maxFillAmount) external;
34     function cancel(address[3] addresses, uint[4] values) external;
35     function order(address[2] addresses, uint[4] values) external;
36 
37     function canTrade(address[3] addresses, uint[4] values, bytes signature)
38         external
39         view
40         returns (bool);
41 
42     function isSubscribed(address subscriber) external view returns (bool);
43     function availableAmount(address[3] addresses, uint[4] values) external view returns (uint);
44     function filled(bytes32 hash) external view returns (uint);
45     function isOrdered(address user, bytes32 hash) public view returns (bool);
46     function vault() public view returns (VaultInterface);
47 
48 }
49 
50 interface VaultInterface {
51 
52     event Deposited(address indexed user, address token, uint amount);
53     event Withdrawn(address indexed user, address token, uint amount);
54 
55     event Approved(address indexed user, address indexed spender);
56     event Unapproved(address indexed user, address indexed spender);
57 
58     event AddedSpender(address indexed spender);
59     event RemovedSpender(address indexed spender);
60 
61     function deposit(address token, uint amount) external payable;
62     function withdraw(address token, uint amount) external;
63     function transfer(address token, address from, address to, uint amount) external;
64     function approve(address spender) external;
65     function unapprove(address spender) external;
66     function isApproved(address user, address spender) external view returns (bool);
67     function addSpender(address spender) external;
68     function removeSpender(address spender) external;
69     function latestSpender() external view returns (address);
70     function isSpender(address spender) external view returns (bool);
71     function tokenFallback(address from, uint value, bytes data) public;
72     function balanceOf(address token, address user) public view returns (uint);
73 
74 }
75 
76 library SafeMath {
77 
78     function mul(uint a, uint b) internal pure returns (uint) {
79         uint c = a * b;
80         assert(a == 0 || c / a == b);
81         return c;
82     }
83 
84     function div(uint a, uint b) internal pure returns (uint) {
85         assert(b > 0);
86         uint c = a / b;
87         assert(a == b * c + a % b);
88         return c;
89     }
90 
91     function sub(uint a, uint b) internal pure returns (uint) {
92         assert(b <= a);
93         return a - b;
94     }
95 
96     function add(uint a, uint b) internal pure returns (uint) {
97         uint c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 
102     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
103         return a >= b ? a : b;
104     }
105 
106     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
107         return a < b ? a : b;
108     }
109 
110     function max256(uint a, uint b) internal pure returns (uint) {
111         return a >= b ? a : b;
112     }
113 
114     function min256(uint a, uint b) internal pure returns (uint) {
115         return a < b ? a : b;
116     }
117 }
118 
119 library SignatureValidator {
120 
121     enum SignatureMode {
122         EIP712,
123         GETH,
124         TREZOR
125     }
126 
127     /// @dev Validates that a hash was signed by a specified signer.
128     /// @param hash Hash which was signed.
129     /// @param signer Address of the signer.
130     /// @param signature ECDSA signature along with the mode (0 = EIP712, 1 = Geth, 2 = Trezor) {mode}{v}{r}{s}.
131     /// @return Returns whether signature is from a specified user.
132     function isValidSignature(bytes32 hash, address signer, bytes signature) internal pure returns (bool) {
133         require(signature.length == 66);
134         SignatureMode mode = SignatureMode(uint8(signature[0]));
135 
136         uint8 v = uint8(signature[1]);
137         bytes32 r;
138         bytes32 s;
139         assembly {
140             r := mload(add(signature, 34))
141             s := mload(add(signature, 66))
142         }
143 
144         if (mode == SignatureMode.GETH) {
145             hash = keccak256("\x19Ethereum Signed Message:\n32", hash);
146         } else if (mode == SignatureMode.TREZOR) {
147             hash = keccak256("\x19Ethereum Signed Message:\n\x20", hash);
148         }
149 
150         return ecrecover(hash, v, r, s) == signer;
151     }
152 }
153 
154 library OrderLibrary {
155 
156     bytes32 constant public HASH_SCHEME = keccak256(
157         "address Taker Token",
158         "uint Taker Token Amount",
159         "address Maker Token",
160         "uint Maker Token Amount",
161         "uint Expires",
162         "uint Nonce",
163         "address Maker",
164         "address Exchange"
165     );
166 
167     struct Order {
168         address maker;
169         address makerToken;
170         address takerToken;
171         uint makerTokenAmount;
172         uint takerTokenAmount;
173         uint expires;
174         uint nonce;
175     }
176 
177     /// @dev Hashes the order.
178     /// @param order Order to be hashed.
179     /// @return hash result
180     function hash(Order memory order) internal view returns (bytes32) {
181         return keccak256(
182             HASH_SCHEME,
183             keccak256(
184                 order.takerToken,
185                 order.takerTokenAmount,
186                 order.makerToken,
187                 order.makerTokenAmount,
188                 order.expires,
189                 order.nonce,
190                 order.maker,
191                 this
192             )
193         );
194     }
195 
196     /// @dev Creates order struct from value arrays.
197     /// @param addresses Array of trade's maker, makerToken and takerToken.
198     /// @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
199     /// @return Order struct
200     function createOrder(address[3] addresses, uint[4] values) internal pure returns (Order memory) {
201         return Order({
202             maker: addresses[0],
203             makerToken: addresses[1],
204             takerToken: addresses[2],
205             makerTokenAmount: values[0],
206             takerTokenAmount: values[1],
207             expires: values[2],
208             nonce: values[3]
209         });
210     }
211 }
212 
213 contract Ownable {
214 
215     address public owner;
216 
217     modifier onlyOwner {
218         require(isOwner(msg.sender));
219         _;
220     }
221 
222     function Ownable() public {
223         owner = msg.sender;
224     }
225 
226     function transferOwnership(address _newOwner) public onlyOwner {
227         owner = _newOwner;
228     }
229 
230     function isOwner(address _address) public view returns (bool) {
231         return owner == _address;
232     }
233 }
234 
235 interface ERC20 {
236 
237     function totalSupply() public view returns (uint);
238     function balanceOf(address owner) public view returns (uint);
239     function allowance(address owner, address spender) public view returns (uint);
240     function transfer(address to, uint value) public returns (bool);
241     function transferFrom(address from, address to, uint value) public returns (bool);
242     function approve(address spender, uint value) public returns (bool);
243 
244 }
245 
246 interface HookSubscriber {
247 
248     function tradeExecuted(address token, uint amount) external;
249 
250 }
251 
252 contract Exchange is Ownable, ExchangeInterface {
253 
254     using SafeMath for *;
255     using OrderLibrary for OrderLibrary.Order;
256 
257     address constant public ETH = 0x0;
258 
259     uint256 constant public MAX_FEE = 5000000000000000; // 0.5% ((0.5 / 100) * 10**18)
260     uint256 constant private MAX_ROUNDING_PERCENTAGE = 1000; // 0.1%
261     
262     uint256 constant private MAX_HOOK_GAS = 40000; // enough for a storage write and some accounting logic
263 
264     VaultInterface public vault;
265 
266     uint public takerFee = 0;
267     address public feeAccount;
268 
269     mapping (address => mapping (bytes32 => bool)) private orders;
270     mapping (bytes32 => uint) private fills;
271     mapping (bytes32 => bool) private cancelled;
272     mapping (address => bool) private subscribed;
273 
274     function Exchange(uint _takerFee, address _feeAccount, VaultInterface _vault) public {
275         require(address(_vault) != 0x0);
276         setFees(_takerFee);
277         setFeeAccount(_feeAccount);
278         vault = _vault;
279     }
280 
281     /// @dev Withdraws tokens accidentally sent to this contract.
282     /// @param token Address of the token to withdraw.
283     /// @param amount Amount of tokens to withdraw.
284     function withdraw(address token, uint amount) external onlyOwner {
285         if (token == ETH) {
286             msg.sender.transfer(amount);
287             return;
288         }
289 
290         ERC20(token).transfer(msg.sender, amount);
291     }
292 
293     /// @dev Subscribes user to trade hooks.
294     function subscribe() external {
295         require(!subscribed[msg.sender]);
296         subscribed[msg.sender] = true;
297         emit Subscribed(msg.sender);
298     }
299 
300     /// @dev Unsubscribes user from trade hooks.
301     function unsubscribe() external {
302         require(subscribed[msg.sender]);
303         subscribed[msg.sender] = false;
304         emit Unsubscribed(msg.sender);
305     }
306 
307     /// @dev Takes an order.
308     /// @param addresses Array of trade's maker, makerToken and takerToken.
309     /// @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
310     /// @param signature Signed order along with signature mode.
311     /// @param maxFillAmount Maximum amount of the order to be filled.
312     function trade(address[3] addresses, uint[4] values, bytes signature, uint maxFillAmount) external {
313         trade(OrderLibrary.createOrder(addresses, values), msg.sender, signature, maxFillAmount);
314     }
315 
316     /// @dev Cancels an order.
317     /// @param addresses Array of trade's maker, makerToken and takerToken.
318     /// @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
319     function cancel(address[3] addresses, uint[4] values) external {
320         OrderLibrary.Order memory order = OrderLibrary.createOrder(addresses, values);
321 
322         require(msg.sender == order.maker);
323         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0);
324 
325         bytes32 hash = order.hash();
326         require(fills[hash] < order.takerTokenAmount);
327         require(!cancelled[hash]);
328 
329         cancelled[hash] = true;
330         emit Cancelled(hash);
331     }
332 
333     /// @dev Creates an order which is then indexed in the orderbook.
334     /// @param addresses Array of trade's makerToken and takerToken.
335     /// @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
336     function order(address[2] addresses, uint[4] values) external {
337         OrderLibrary.Order memory order = OrderLibrary.createOrder(
338             [msg.sender, addresses[0], addresses[1]],
339             values
340         );
341 
342         require(vault.isApproved(order.maker, this));
343         require(vault.balanceOf(order.makerToken, order.maker) >= order.makerTokenAmount);
344         require(order.makerToken != order.takerToken);
345         require(order.makerTokenAmount > 0);
346         require(order.takerTokenAmount > 0);
347 
348         bytes32 hash = order.hash();
349 
350         require(!orders[msg.sender][hash]);
351         orders[msg.sender][hash] = true;
352 
353         emit Ordered(
354             order.maker,
355             order.makerToken,
356             order.takerToken,
357             order.makerTokenAmount,
358             order.takerTokenAmount,
359             order.expires,
360             order.nonce
361         );
362     }
363 
364     /// @dev Checks if a order can be traded.
365     /// @param addresses Array of trade's maker, makerToken and takerToken.
366     /// @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
367     /// @param signature Signed order along with signature mode.
368     /// @return Boolean if order can be traded
369     function canTrade(address[3] addresses, uint[4] values, bytes signature)
370         external
371         view
372         returns (bool)
373     {
374         OrderLibrary.Order memory order = OrderLibrary.createOrder(addresses, values);
375 
376         bytes32 hash = order.hash();
377 
378         return canTrade(order, signature, hash);
379     }
380 
381     /// @dev Returns if user has subscribed to trade hooks.
382     /// @param subscriber Address of the subscriber.
383     /// @return Boolean if user is subscribed.
384     function isSubscribed(address subscriber) external view returns (bool) {
385         return subscribed[subscriber];
386     }
387 
388     /// @dev Checks how much of an order can be filled.
389     /// @param addresses Array of trade's maker, makerToken and takerToken.
390     /// @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
391     /// @return Amount of the order which can be filled.
392     function availableAmount(address[3] addresses, uint[4] values) external view returns (uint) {
393         OrderLibrary.Order memory order = OrderLibrary.createOrder(addresses, values);
394         return availableAmount(order, order.hash());
395     }
396 
397     /// @dev Returns how much of an order was filled.
398     /// @param hash Hash of the order.
399     /// @return Amount which was filled.
400     function filled(bytes32 hash) external view returns (uint) {
401         return fills[hash];
402     }
403 
404     /// @dev Sets the taker fee.
405     /// @param _takerFee New taker fee.
406     function setFees(uint _takerFee) public onlyOwner {
407         require(_takerFee <= MAX_FEE);
408         takerFee = _takerFee;
409     }
410 
411     /// @dev Sets the account where fees will be transferred to.
412     /// @param _feeAccount Address for the account.
413     function setFeeAccount(address _feeAccount) public onlyOwner {
414         require(_feeAccount != 0x0);
415         feeAccount = _feeAccount;
416     }
417 
418     function vault() public view returns (VaultInterface) {
419         return vault;
420     }
421 
422     /// @dev Checks if an order was created on chain.
423     /// @param user User who created the order.
424     /// @param hash Hash of the order.
425     /// @return Boolean if the order was created on chain.
426     function isOrdered(address user, bytes32 hash) public view returns (bool) {
427         return orders[user][hash];
428     }
429 
430     /// @dev Executes the actual trade by transferring balances.
431     /// @param order Order to be traded.
432     /// @param taker Address of the taker.
433     /// @param signature Signed order along with signature mode.
434     /// @param maxFillAmount Maximum amount of the order to be filled.
435     function trade(OrderLibrary.Order memory order, address taker, bytes signature, uint maxFillAmount) internal {
436         require(taker != order.maker);
437         bytes32 hash = order.hash();
438 
439         require(order.makerToken != order.takerToken);
440         require(canTrade(order, signature, hash));
441 
442         uint fillAmount = SafeMath.min256(maxFillAmount, availableAmount(order, hash));
443 
444         require(roundingPercent(fillAmount, order.takerTokenAmount, order.makerTokenAmount) <= MAX_ROUNDING_PERCENTAGE);
445         require(vault.balanceOf(order.takerToken, taker) >= fillAmount);
446 
447         uint makeAmount = order.makerTokenAmount.mul(fillAmount).div(order.takerTokenAmount);
448         uint tradeTakerFee = makeAmount.mul(takerFee).div(1 ether);
449 
450         if (tradeTakerFee > 0) {
451             vault.transfer(order.makerToken, order.maker, feeAccount, tradeTakerFee);
452         }
453 
454         vault.transfer(order.takerToken, taker, order.maker, fillAmount);
455         vault.transfer(order.makerToken, order.maker, taker, makeAmount.sub(tradeTakerFee));
456 
457         fills[hash] = fills[hash].add(fillAmount);
458         assert(fills[hash] <= order.takerTokenAmount);
459 
460         if (subscribed[order.maker]) {
461             order.maker.call.gas(MAX_HOOK_GAS)(HookSubscriber(order.maker).tradeExecuted.selector, order.takerToken, fillAmount);
462         }
463 
464         emit Traded(
465             hash,
466             order.makerToken,
467             makeAmount,
468             order.takerToken,
469             fillAmount,
470             order.maker,
471             taker
472         );
473     }
474 
475     /// @dev Indicates whether or not an certain amount of an order can be traded.
476     /// @param order Order to be traded.
477     /// @param signature Signed order along with signature mode.
478     /// @param hash Hash of the order.
479     /// @return Boolean if order can be traded
480     function canTrade(OrderLibrary.Order memory order, bytes signature, bytes32 hash)
481         internal
482         view
483         returns (bool)
484     {
485         // if the order has never been traded against, we need to check the sig.
486         if (fills[hash] == 0) {
487             // ensures order was either created on chain, or signature is valid
488             if (!isOrdered(order.maker, hash) && !SignatureValidator.isValidSignature(hash, order.maker, signature)) {
489                 return false;
490             }
491         }
492 
493         if (cancelled[hash]) {
494             return false;
495         }
496 
497         if (!vault.isApproved(order.maker, this)) {
498             return false;
499         }
500 
501         if (order.takerTokenAmount == 0) {
502             return false;
503         }
504 
505         if (order.makerTokenAmount == 0) {
506             return false;
507         }
508 
509         // ensures that the order still has an available amount to be filled.
510         if (availableAmount(order, hash) == 0) {
511             return false;
512         }
513 
514         return order.expires > now;
515     }
516 
517     /// @dev Returns the maximum available amount that can be taken of an order.
518     /// @param order Order to check.
519     /// @param hash Hash of the order.
520     /// @return Amount of the order that can be filled.
521     function availableAmount(OrderLibrary.Order memory order, bytes32 hash) internal view returns (uint) {
522         return SafeMath.min256(
523             order.takerTokenAmount.sub(fills[hash]),
524             vault.balanceOf(order.makerToken, order.maker).mul(order.takerTokenAmount).div(order.makerTokenAmount)
525         );
526     }
527 
528     /// @dev Returns the percentage which was rounded when dividing.
529     /// @param numerator Numerator.
530     /// @param denominator Denominator.
531     /// @param target Value to multiply with.
532     /// @return Percentage rounded.
533     function roundingPercent(uint numerator, uint denominator, uint target) internal pure returns (uint) {
534         // Inspired by https://github.com/0xProject/contracts/blob/1.0.0/contracts/Exchange.sol#L472-L490
535         uint remainder = mulmod(target, numerator, denominator);
536         if (remainder == 0) {
537             return 0;
538         }
539 
540         return remainder.mul(1000000).div(numerator.mul(target));
541     }
542 }