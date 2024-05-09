1 pragma solidity ^0.4.24;
2 
3 /*
4   Super Simple Token Subscriptions - https://tokensubscription.com
5 
6   //// Breakin’ Through @ University of Wyoming ////
7 
8   Austin Thomas Griffith - https://austingriffith.com
9 
10   Building on previous works:
11     https://github.com/austintgriffith/token-subscription
12     https://gist.github.com/androolloyd/0a62ef48887be00a5eff5c17f2be849a
13     https://media.consensys.net/subscription-services-on-the-blockchain-erc-948-6ef64b083a36
14     https://medium.com/gitcoin/technical-deep-dive-architecture-choices-for-subscriptions-on-the-blockchain-erc948-5fae89cabc7a
15     https://github.com/ethereum/EIPs/pull/1337
16     https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1077.md
17     https://github.com/gnosis/safe-contracts
18 
19   Earlier Meta Transaction Demo:
20     https://github.com/austintgriffith/bouncer-proxy
21 
22   Huge thanks, as always, to OpenZeppelin for the rad contracts:
23  */
24 
25 
26 
27 /**
28  * @title Elliptic curve signature operations
29  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
30  * TODO Remove this library once solidity supports passing a signature to ecrecover.
31  * See https://github.com/ethereum/solidity/issues/864
32  */
33 
34 library ECDSA {
35 
36   /**
37    * @dev Recover signer address from a message by using their signature
38    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
39    * @param signature bytes signature, the signature is generated using web3.eth.sign()
40    */
41   function recover(bytes32 hash, bytes signature)
42     internal
43     pure
44     returns (address)
45   {
46     bytes32 r;
47     bytes32 s;
48     uint8 v;
49 
50     // Check the signature length
51     if (signature.length != 65) {
52       return (address(0));
53     }
54 
55     // Divide the signature in r, s and v variables
56     // ecrecover takes the signature parameters, and the only way to get them
57     // currently is to use assembly.
58     // solium-disable-next-line security/no-inline-assembly
59     assembly {
60       r := mload(add(signature, 32))
61       s := mload(add(signature, 64))
62       v := byte(0, mload(add(signature, 96)))
63     }
64 
65     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
66     if (v < 27) {
67       v += 27;
68     }
69 
70     // If the version is correct return the signer address
71     if (v != 27 && v != 28) {
72       return (address(0));
73     } else {
74       // solium-disable-next-line arg-overflow
75       return ecrecover(hash, v, r, s);
76     }
77   }
78 
79   /**
80    * toEthSignedMessageHash
81    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
82    * and hash the result
83    */
84   function toEthSignedMessageHash(bytes32 hash)
85     internal
86     pure
87     returns (bytes32)
88   {
89     // 32 is the length in bytes of hash,
90     // enforced by the type signature above
91     return keccak256(
92       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
93     );
94   }
95 }
96 
97 
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that revert on error
102  */
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, reverts on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110     // benefit is lost if 'b' is also tested.
111     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112     if (a == 0) {
113       return 0;
114     }
115 
116     uint256 c = a * b;
117     require(c / a == b);
118 
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
124   */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     require(b > 0); // Solidity only automatically asserts when dividing by 0
127     uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129 
130     return c;
131   }
132 
133   /**
134   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
135   */
136   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b <= a);
138     uint256 c = a - b;
139 
140     return c;
141   }
142 
143   /**
144   * @dev Adds two numbers, reverts on overflow.
145   */
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     require(c >= a);
149 
150     return c;
151   }
152 
153   /**
154   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
155   * reverts when dividing by zero.
156   */
157   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b != 0);
159     return a % b;
160   }
161 }
162 
163 
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 interface IERC20 {
171   function totalSupply() external view returns (uint256);
172 
173   function balanceOf(address who) external view returns (uint256);
174 
175   function allowance(address owner, address spender)
176     external view returns (uint256);
177 
178   function transfer(address to, uint256 value) external returns (bool);
179 
180   function approve(address spender, uint256 value)
181     external returns (bool);
182 
183   function transferFrom(address from, address to, uint256 value)
184     external returns (bool);
185 
186   event Transfer(
187     address indexed from,
188     address indexed to,
189     uint256 value
190   );
191 
192   event Approval(
193     address indexed owner,
194     address indexed spender,
195     uint256 value
196   );
197 }
198 
199 
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
206  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract ERC20 is IERC20 {
209   using SafeMath for uint256;
210 
211   mapping (address => uint256) private _balances;
212 
213   mapping (address => mapping (address => uint256)) private _allowed;
214 
215   uint256 private _totalSupply;
216 
217   /**
218   * @dev Total number of tokens in existence
219   */
220   function totalSupply() public view returns (uint256) {
221     return _totalSupply;
222   }
223 
224   /**
225   * @dev Gets the balance of the specified address.
226   * @param owner The address to query the the balance of.
227   * @return An uint256 representing the amount owned by the passed address.
228   */
229   function balanceOf(address owner) public view returns (uint256) {
230     return _balances[owner];
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param owner address The address which owns the funds.
236    * @param spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(
240     address owner,
241     address spender
242    )
243     public
244     view
245     returns (uint256)
246   {
247     return _allowed[owner][spender];
248   }
249 
250   /**
251   * @dev Transfer token for a specified address
252   * @param to The address to transfer to.
253   * @param value The amount to be transferred.
254   */
255   function transfer(address to, uint256 value) public returns (bool) {
256     require(value <= _balances[msg.sender]);
257     require(to != address(0));
258 
259     _balances[msg.sender] = _balances[msg.sender].sub(value);
260     _balances[to] = _balances[to].add(value);
261     emit Transfer(msg.sender, to, value);
262     return true;
263   }
264 
265   /**
266    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267    * Beware that changing an allowance with this method brings the risk that someone may use both the old
268    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
269    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
270    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271    * @param spender The address which will spend the funds.
272    * @param value The amount of tokens to be spent.
273    */
274   function approve(address spender, uint256 value) public returns (bool) {
275     require(spender != address(0));
276 
277     _allowed[msg.sender][spender] = value;
278     emit Approval(msg.sender, spender, value);
279     return true;
280   }
281 
282   /**
283    * @dev Transfer tokens from one address to another
284    * @param from address The address which you want to send tokens from
285    * @param to address The address which you want to transfer to
286    * @param value uint256 the amount of tokens to be transferred
287    */
288   function transferFrom(
289     address from,
290     address to,
291     uint256 value
292   )
293     public
294     returns (bool)
295   {
296     require(value <= _balances[from]);
297     require(value <= _allowed[from][msg.sender]);
298     require(to != address(0));
299 
300     _balances[from] = _balances[from].sub(value);
301     _balances[to] = _balances[to].add(value);
302     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
303     emit Transfer(from, to, value);
304     return true;
305   }
306 
307   /**
308    * @dev Increase the amount of tokens that an owner allowed to a spender.
309    * approve should be called when allowed_[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param spender The address which will spend the funds.
314    * @param addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseAllowance(
317     address spender,
318     uint256 addedValue
319   )
320     public
321     returns (bool)
322   {
323     require(spender != address(0));
324 
325     _allowed[msg.sender][spender] = (
326       _allowed[msg.sender][spender].add(addedValue));
327     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
328     return true;
329   }
330 
331   /**
332    * @dev Decrease the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed_[_spender] == 0. To decrement
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param spender The address which will spend the funds.
338    * @param subtractedValue The amount of tokens to decrease the allowance by.
339    */
340   function decreaseAllowance(
341     address spender,
342     uint256 subtractedValue
343   )
344     public
345     returns (bool)
346   {
347     require(spender != address(0));
348 
349     _allowed[msg.sender][spender] = (
350       _allowed[msg.sender][spender].sub(subtractedValue));
351     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
352     return true;
353   }
354 
355   /**
356    * @dev Internal function that mints an amount of the token and assigns it to
357    * an account. This encapsulates the modification of balances such that the
358    * proper events are emitted.
359    * @param account The account that will receive the created tokens.
360    * @param amount The amount that will be created.
361    */
362   function _mint(address account, uint256 amount) internal {
363     require(account != 0);
364     _totalSupply = _totalSupply.add(amount);
365     _balances[account] = _balances[account].add(amount);
366     emit Transfer(address(0), account, amount);
367   }
368 
369   /**
370    * @dev Internal function that burns an amount of the token of a given
371    * account.
372    * @param account The account whose tokens will be burnt.
373    * @param amount The amount that will be burnt.
374    */
375   function _burn(address account, uint256 amount) internal {
376     require(account != 0);
377     require(amount <= _balances[account]);
378 
379     _totalSupply = _totalSupply.sub(amount);
380     _balances[account] = _balances[account].sub(amount);
381     emit Transfer(account, address(0), amount);
382   }
383 
384   /**
385    * @dev Internal function that burns an amount of the token of a given
386    * account, deducting from the sender's allowance for said account. Uses the
387    * internal burn function.
388    * @param account The account whose tokens will be burnt.
389    * @param amount The amount that will be burnt.
390    */
391   function _burnFrom(address account, uint256 amount) internal {
392     require(amount <= _allowed[account][msg.sender]);
393 
394     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
395     // this function needs to emit an event with the updated approval.
396     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
397       amount);
398     _burn(account, amount);
399   }
400 }
401 
402 
403 
404 contract Subscription {
405     using ECDSA for bytes32;
406     using SafeMath for uint256;
407 
408     //who deploys the contract
409     address public author;
410 
411     // the publisher may optionally deploy requirements for the subscription
412     // so only meta transactions that match the requirements can be relayed
413     address public requiredToAddress;
414     address public requiredTokenAddress;
415     uint256 public requiredTokenAmount;
416     uint256 public requiredPeriodSeconds;
417     uint256 public requiredGasPrice;
418 
419     // similar to a nonce that avoids replay attacks this allows a single execution
420     // every x seconds for a given subscription
421     // subscriptionHash  => next valid block number
422     mapping(bytes32 => uint256) public nextValidTimestamp;
423 
424     //we'll use a nonce for each from but because transactions can go through
425     //multiple times, we allow anything but users can use this as a signal for
426     //uniqueness
427     mapping(address => uint256) public extraNonce;
428 
429     event ExecuteSubscription(
430         address indexed from, //the subscriber
431         address indexed to, //the publisher
432         address tokenAddress, //the token address paid to the publisher
433         uint256 tokenAmount, //the token amount paid to the publisher
434         uint256 periodSeconds, //the period in seconds between payments
435         uint256 gasPrice, //the amount of tokens to pay relayer (0 for free)
436         uint256 nonce // to allow multiple subscriptions with the same parameters
437     );
438 
439     constructor(
440         address _toAddress,
441         address _tokenAddress,
442         uint256 _tokenAmount,
443         uint256 _periodSeconds,
444         uint256 _gasPrice
445     ) public {
446         requiredToAddress=_toAddress;
447         requiredTokenAddress=_tokenAddress;
448         requiredTokenAmount=_tokenAmount;
449         requiredPeriodSeconds=_periodSeconds;
450         requiredGasPrice=_gasPrice;
451         author=msg.sender;
452     }
453 
454     // this is used by external smart contracts to verify on-chain that a
455     // particular subscription is "paid" and "active"
456     // there must be a small grace period added to allow the publisher
457     // or desktop miner to execute
458     function isSubscriptionActive(
459         bytes32 subscriptionHash,
460         uint256 gracePeriodSeconds
461     )
462         external
463         view
464         returns (bool)
465     {
466         return (block.timestamp <=
467                 nextValidTimestamp[subscriptionHash].add(gracePeriodSeconds)
468         );
469     }
470 
471     // given the subscription details, generate a hash and try to kind of follow
472     // the eip-191 standard and eip-1077 standard from my dude @avsa
473     function getSubscriptionHash(
474         address from, //the subscriber
475         address to, //the publisher
476         address tokenAddress, //the token address paid to the publisher
477         uint256 tokenAmount, //the token amount paid to the publisher
478         uint256 periodSeconds, //the period in seconds between payments
479         uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
480         uint256 nonce // to allow multiple subscriptions with the same parameters
481     )
482         public
483         view
484         returns (bytes32)
485     {
486         return keccak256(
487             abi.encodePacked(
488                 byte(0x19),
489                 byte(0),
490                 address(this),
491                 from,
492                 to,
493                 tokenAddress,
494                 tokenAmount,
495                 periodSeconds,
496                 gasPrice,
497                 nonce
498         ));
499     }
500 
501     //ecrecover the signer from hash and the signature
502     function getSubscriptionSigner(
503         bytes32 subscriptionHash, //hash of subscription
504         bytes signature //proof the subscriber signed the meta trasaction
505     )
506         public
507         pure
508         returns (address)
509     {
510         return subscriptionHash.toEthSignedMessageHash().recover(signature);
511     }
512 
513     //check if a subscription is signed correctly and the timestamp is ready for
514     // the next execution to happen
515     function isSubscriptionReady(
516         address from, //the subscriber
517         address to, //the publisher
518         address tokenAddress, //the token address paid to the publisher
519         uint256 tokenAmount, //the token amount paid to the publisher
520         uint256 periodSeconds, //the period in seconds between payments
521         uint256 gasPrice, //the amount of the token to incentivize the relay network
522         uint256 nonce,// to allow multiple subscriptions with the same parameters
523         bytes signature //proof the subscriber signed the meta trasaction
524     )
525         external
526         view
527         returns (bool)
528     {
529         bytes32 subscriptionHash = getSubscriptionHash(
530             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce
531         );
532         address signer = getSubscriptionSigner(subscriptionHash, signature);
533         uint256 allowance = ERC20(tokenAddress).allowance(from, address(this));
534         uint256 balance = ERC20(tokenAddress).balanceOf(from);
535         return (
536             signer == from &&
537             from != to &&
538             block.timestamp >= nextValidTimestamp[subscriptionHash] &&
539             allowance >= tokenAmount.add(gasPrice) &&
540             balance >= tokenAmount.add(gasPrice)
541         );
542     }
543 
544     // you don't really need this if you are using the approve/transferFrom method
545     // because you control the flow of tokens by approving this contract address,
546     // but to make the contract an extensible example for later user I'll add this
547     function cancelSubscription(
548         address from, //the subscriber
549         address to, //the publisher
550         address tokenAddress, //the token address paid to the publisher
551         uint256 tokenAmount, //the token amount paid to the publisher
552         uint256 periodSeconds, //the period in seconds between payments
553         uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
554         uint256 nonce, //to allow multiple subscriptions with the same parameters
555         bytes signature //proof the subscriber signed the meta trasaction
556     )
557         external
558         returns (bool success)
559     {
560         bytes32 subscriptionHash = getSubscriptionHash(
561             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce
562         );
563         address signer = getSubscriptionSigner(subscriptionHash, signature);
564 
565         //the signature must be valid
566         require(signer == from, "Invalid Signature for subscription cancellation");
567 
568         //nextValidTimestamp should be a timestamp that will never
569         //be reached during the brief window human existence
570         nextValidTimestamp[subscriptionHash]=uint256(-1);
571 
572         return true;
573     }
574 
575     // execute the transferFrom to pay the publisher from the subscriber
576     // the subscriber has full control by approving this contract an allowance
577     function executeSubscription(
578         address from, //the subscriber
579         address to, //the publisher
580         address tokenAddress, //the token address paid to the publisher
581         uint256 tokenAmount, //the token amount paid to the publisher
582         uint256 periodSeconds, //the period in seconds between payments
583         uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
584         uint256 nonce, // to allow multiple subscriptions with the same parameters
585         bytes signature //proof the subscriber signed the meta trasaction
586     )
587         public
588         returns (bool success)
589     {
590         // make sure the subscription is valid and ready
591         // pulled this out so I have the hash, should be exact code as "isSubscriptionReady"
592         bytes32 subscriptionHash = getSubscriptionHash(
593             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce
594         );
595         address signer = getSubscriptionSigner(subscriptionHash, signature);
596 
597         //make sure they aren't sending to themselves
598         require(to != from, "Can not send to the from address");
599         //the signature must be valid
600         require(signer == from, "Invalid Signature");
601         //timestamp must be equal to or past the next period
602         require(
603             block.timestamp >= nextValidTimestamp[subscriptionHash],
604             "Subscription is not ready"
605         );
606 
607         // if there are requirements from the deployer, let's make sure
608         // those are met exactly
609         require( requiredToAddress == address(0) || to == requiredToAddress );
610         require( requiredTokenAddress == address(0) || tokenAddress == requiredTokenAddress );
611         require( requiredTokenAmount == 0 || tokenAmount == requiredTokenAmount );
612         require( requiredPeriodSeconds == 0 || periodSeconds == requiredPeriodSeconds );
613         require( requiredGasPrice == 0 || gasPrice == requiredGasPrice );
614 
615         //increment the timestamp by the period so it wont be valid until then
616         nextValidTimestamp[subscriptionHash] = block.timestamp.add(periodSeconds);
617 
618         //check to see if this nonce is larger than the current count and we'll set that for this 'from'
619         if(nonce > extraNonce[from]){
620           extraNonce[from] = nonce;
621         }
622 
623         // now, let make the transfer from the subscriber to the publisher
624         ERC20(tokenAddress).transferFrom(from,to,tokenAmount);
625         require(
626             checkSuccess(),
627             "Subscription::executeSubscription TransferFrom failed"
628         );
629 
630         emit ExecuteSubscription(
631             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce
632         );
633 
634         // it is possible for the subscription execution to be run by a third party
635         // incentivized in the terms of the subscription with a gasPrice of the tokens
636         //  - pay that out now...
637         if (gasPrice > 0) {
638             //the relayer is incentivized by a little of the same token from
639             // the subscriber ... as far as the subscriber knows, they are
640             // just sending X tokens to the publisher, but the publisher can
641             // choose to send Y of those X to a relayer to run their transactions
642             // the publisher will receive X - Y tokens
643             // this must all be setup in the constructor
644             // if not, the subscriber chooses all the params including what goes
645             // to the publisher and what goes to the relayer
646             ERC20(tokenAddress).transferFrom(from, msg.sender, gasPrice);
647             require(
648                 checkSuccess(),
649                 "Subscription::executeSubscription Failed to pay gas as from account"
650             );
651         }
652 
653         return true;
654     }
655 
656     // because of issues with non-standard erc20s the transferFrom can always return false
657     // to fix this we run it and then check the return of the previous function:
658     //    https://github.com/ethereum/solidity/issues/4116
659     /**
660      * Checks the return value of the previous function. Returns true if the previous function
661      * function returned 32 non-zero bytes or returned zero bytes.
662      */
663     function checkSuccess(
664     )
665         private
666         pure
667         returns (bool)
668     {
669         uint256 returnValue = 0;
670 
671         /* solium-disable-next-line security/no-inline-assembly */
672         assembly {
673             // check number of bytes returned from last function call
674             switch returndatasize
675 
676             // no bytes returned: assume success
677             case 0x0 {
678                 returnValue := 1
679             }
680 
681             // 32 bytes returned: check if non-zero
682             case 0x20 {
683                 // copy 32 bytes into scratch space
684                 returndatacopy(0x0, 0x0, 0x20)
685 
686                 // load those bytes into returnValue
687                 returnValue := mload(0x0)
688             }
689 
690             // not sure what was returned: dont mark as success
691             default { }
692         }
693 
694         return returnValue != 0;
695     }
696 }