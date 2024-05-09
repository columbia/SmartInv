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
165 /**
166  * @title Ownable
167  * @dev The Ownable contract has an owner address, and provides basic authorization control
168  * functions, this simplifies the implementation of "user permissions".
169  */
170 contract Ownable {
171   address private _owner;
172 
173 
174   event OwnershipRenounced(address indexed previousOwner);
175   event OwnershipTransferred(
176     address indexed previousOwner,
177     address indexed newOwner
178   );
179 
180 
181   /**
182    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
183    * account.
184    */
185   constructor() public {
186     _owner = msg.sender;
187   }
188 
189   /**
190    * @return the address of the owner.
191    */
192   function owner() public view returns(address) {
193     return _owner;
194   }
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(isOwner());
201     _;
202   }
203 
204   /**
205    * @return true if `msg.sender` is the owner of the contract.
206    */
207   function isOwner() public view returns(bool) {
208     return msg.sender == _owner;
209   }
210 
211   /**
212    * @dev Allows the current owner to relinquish control of the contract.
213    * @notice Renouncing to ownership will leave the contract without an owner.
214    * It will not be possible to call the functions with the `onlyOwner`
215    * modifier anymore.
216    */
217   function renounceOwnership() public onlyOwner {
218     emit OwnershipRenounced(_owner);
219     _owner = address(0);
220   }
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) public onlyOwner {
227     _transferOwnership(newOwner);
228   }
229 
230   /**
231    * @dev Transfers control of the contract to a newOwner.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function _transferOwnership(address newOwner) internal {
235     require(newOwner != address(0));
236     emit OwnershipTransferred(_owner, newOwner);
237     _owner = newOwner;
238   }
239 }
240 
241 
242 
243 
244 /**
245  * @title ERC20 interface
246  * @dev see https://github.com/ethereum/EIPs/issues/20
247  */
248 interface IERC20 {
249   function totalSupply() external view returns (uint256);
250 
251   function balanceOf(address who) external view returns (uint256);
252 
253   function allowance(address owner, address spender)
254     external view returns (uint256);
255 
256   function transfer(address to, uint256 value) external returns (bool);
257 
258   function approve(address spender, uint256 value)
259     external returns (bool);
260 
261   function transferFrom(address from, address to, uint256 value)
262     external returns (bool);
263 
264   event Transfer(
265     address indexed from,
266     address indexed to,
267     uint256 value
268   );
269 
270   event Approval(
271     address indexed owner,
272     address indexed spender,
273     uint256 value
274   );
275 }
276 
277 
278 
279 /**
280  * @title Standard ERC20 token
281  *
282  * @dev Implementation of the basic standard token.
283  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
284  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
285  */
286 contract ERC20 is IERC20 {
287   using SafeMath for uint256;
288 
289   mapping (address => uint256) private _balances;
290 
291   mapping (address => mapping (address => uint256)) private _allowed;
292 
293   uint256 private _totalSupply;
294 
295   /**
296   * @dev Total number of tokens in existence
297   */
298   function totalSupply() public view returns (uint256) {
299     return _totalSupply;
300   }
301 
302   /**
303   * @dev Gets the balance of the specified address.
304   * @param owner The address to query the the balance of.
305   * @return An uint256 representing the amount owned by the passed address.
306   */
307   function balanceOf(address owner) public view returns (uint256) {
308     return _balances[owner];
309   }
310 
311   /**
312    * @dev Function to check the amount of tokens that an owner allowed to a spender.
313    * @param owner address The address which owns the funds.
314    * @param spender address The address which will spend the funds.
315    * @return A uint256 specifying the amount of tokens still available for the spender.
316    */
317   function allowance(
318     address owner,
319     address spender
320    )
321     public
322     view
323     returns (uint256)
324   {
325     return _allowed[owner][spender];
326   }
327 
328   /**
329   * @dev Transfer token for a specified address
330   * @param to The address to transfer to.
331   * @param value The amount to be transferred.
332   */
333   function transfer(address to, uint256 value) public returns (bool) {
334     require(value <= _balances[msg.sender]);
335     require(to != address(0));
336 
337     _balances[msg.sender] = _balances[msg.sender].sub(value);
338     _balances[to] = _balances[to].add(value);
339     emit Transfer(msg.sender, to, value);
340     return true;
341   }
342 
343   /**
344    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
345    * Beware that changing an allowance with this method brings the risk that someone may use both the old
346    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
347    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
348    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349    * @param spender The address which will spend the funds.
350    * @param value The amount of tokens to be spent.
351    */
352   function approve(address spender, uint256 value) public returns (bool) {
353     require(spender != address(0));
354 
355     _allowed[msg.sender][spender] = value;
356     emit Approval(msg.sender, spender, value);
357     return true;
358   }
359 
360   /**
361    * @dev Transfer tokens from one address to another
362    * @param from address The address which you want to send tokens from
363    * @param to address The address which you want to transfer to
364    * @param value uint256 the amount of tokens to be transferred
365    */
366   function transferFrom(
367     address from,
368     address to,
369     uint256 value
370   )
371     public
372     returns (bool)
373   {
374     require(value <= _balances[from]);
375     require(value <= _allowed[from][msg.sender]);
376     require(to != address(0));
377 
378     _balances[from] = _balances[from].sub(value);
379     _balances[to] = _balances[to].add(value);
380     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
381     emit Transfer(from, to, value);
382     return true;
383   }
384 
385   /**
386    * @dev Increase the amount of tokens that an owner allowed to a spender.
387    * approve should be called when allowed_[_spender] == 0. To increment
388    * allowed value is better to use this function to avoid 2 calls (and wait until
389    * the first transaction is mined)
390    * From MonolithDAO Token.sol
391    * @param spender The address which will spend the funds.
392    * @param addedValue The amount of tokens to increase the allowance by.
393    */
394   function increaseAllowance(
395     address spender,
396     uint256 addedValue
397   )
398     public
399     returns (bool)
400   {
401     require(spender != address(0));
402 
403     _allowed[msg.sender][spender] = (
404       _allowed[msg.sender][spender].add(addedValue));
405     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
406     return true;
407   }
408 
409   /**
410    * @dev Decrease the amount of tokens that an owner allowed to a spender.
411    * approve should be called when allowed_[_spender] == 0. To decrement
412    * allowed value is better to use this function to avoid 2 calls (and wait until
413    * the first transaction is mined)
414    * From MonolithDAO Token.sol
415    * @param spender The address which will spend the funds.
416    * @param subtractedValue The amount of tokens to decrease the allowance by.
417    */
418   function decreaseAllowance(
419     address spender,
420     uint256 subtractedValue
421   )
422     public
423     returns (bool)
424   {
425     require(spender != address(0));
426 
427     _allowed[msg.sender][spender] = (
428       _allowed[msg.sender][spender].sub(subtractedValue));
429     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
430     return true;
431   }
432 
433   /**
434    * @dev Internal function that mints an amount of the token and assigns it to
435    * an account. This encapsulates the modification of balances such that the
436    * proper events are emitted.
437    * @param account The account that will receive the created tokens.
438    * @param amount The amount that will be created.
439    */
440   function _mint(address account, uint256 amount) internal {
441     require(account != 0);
442     _totalSupply = _totalSupply.add(amount);
443     _balances[account] = _balances[account].add(amount);
444     emit Transfer(address(0), account, amount);
445   }
446 
447   /**
448    * @dev Internal function that burns an amount of the token of a given
449    * account.
450    * @param account The account whose tokens will be burnt.
451    * @param amount The amount that will be burnt.
452    */
453   function _burn(address account, uint256 amount) internal {
454     require(account != 0);
455     require(amount <= _balances[account]);
456 
457     _totalSupply = _totalSupply.sub(amount);
458     _balances[account] = _balances[account].sub(amount);
459     emit Transfer(account, address(0), amount);
460   }
461 
462   /**
463    * @dev Internal function that burns an amount of the token of a given
464    * account, deducting from the sender's allowance for said account. Uses the
465    * internal burn function.
466    * @param account The account whose tokens will be burnt.
467    * @param amount The amount that will be burnt.
468    */
469   function _burnFrom(address account, uint256 amount) internal {
470     require(amount <= _allowed[account][msg.sender]);
471 
472     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
473     // this function needs to emit an event with the updated approval.
474     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
475       amount);
476     _burn(account, amount);
477   }
478 }
479 
480 
481 
482 contract Subscription is Ownable {
483     using ECDSA for bytes32;
484     using SafeMath for uint256;
485 
486     //who deploys the contract
487     address public author;
488 
489     // the publisher may optionally deploy requirements for the subscription
490     // so only meta transactions that match the requirements can be relayed
491     address public requiredToAddress;
492     address public requiredTokenAddress;
493     uint256 public requiredTokenAmount;
494     uint256 public requiredPeriodSeconds;
495     uint256 public requiredGasPrice;
496 
497     constructor(
498         address _toAddress,
499         address _tokenAddress,
500         uint256 _tokenAmount,
501         uint256 _periodSeconds,
502         uint256 _gasPrice
503     ) public {
504         requiredToAddress=_toAddress;
505         requiredTokenAddress=_tokenAddress;
506         requiredTokenAmount=_tokenAmount;
507         requiredPeriodSeconds=_periodSeconds;
508         requiredGasPrice=_gasPrice;
509         author=msg.sender;
510     }
511 
512     event ExecuteSubscription(
513         address indexed from, //the subscriber
514         address indexed to, //the publisher
515         address tokenAddress, //the token address paid to the publisher
516         uint256 tokenAmount, //the token amount paid to the publisher
517         uint256 periodSeconds, //the period in seconds between payments
518         uint256 gasPrice //the amount of tokens to pay relayer (0 for free)
519     );
520 
521     // similar to a nonce that avoids replay attacks this allows a single execution
522     // every x seconds for a given subscription
523     // subscriptionHash  => next valid block number
524     mapping(bytes32 => uint256) public nextValidTimestamp;
525 
526     // this is used by external smart contracts to verify on-chain that a
527     // particular subscription is "paid" and "active"
528     // there must be a small grace period added to allow the publisher
529     // or desktop miner to execute
530     function isSubscriptionActive(
531         bytes32 subscriptionHash,
532         uint256 gracePeriodSeconds
533     )
534         external
535         view
536         returns (bool)
537     {
538         return (block.timestamp <=
539                 nextValidTimestamp[subscriptionHash].add(gracePeriodSeconds)
540         );
541     }
542 
543     // given the subscription details, generate a hash and try to kind of follow
544     // the eip-191 standard and eip-1077 standard from my dude @avsa
545     function getSubscriptionHash(
546         address from, //the subscriber
547         address to, //the publisher
548         address tokenAddress, //the token address paid to the publisher
549         uint256 tokenAmount, //the token amount paid to the publisher
550         uint256 periodSeconds, //the period in seconds between payments
551         uint256 gasPrice //the amount of tokens or eth to pay relayer (0 for free)
552     )
553         public
554         view
555         returns (bytes32)
556     {
557         return keccak256(
558             abi.encodePacked(
559                 byte(0x19),
560                 byte(0),
561                 address(this),
562                 from,
563                 to,
564                 tokenAddress,
565                 tokenAmount,
566                 periodSeconds,
567                 gasPrice
568         ));
569     }
570 
571     //ecrecover the signer from hash and the signature
572     function getSubscriptionSigner(
573         bytes32 subscriptionHash, //hash of subscription
574         bytes signature //proof the subscriber signed the meta trasaction
575     )
576         public
577         pure
578         returns (address)
579     {
580         return subscriptionHash.toEthSignedMessageHash().recover(signature);
581     }
582 
583     //check if a subscription is signed correctly and the timestamp is ready for
584     // the next execution to happen
585     function isSubscriptionReady(
586         address from, //the subscriber
587         address to, //the publisher
588         address tokenAddress, //the token address paid to the publisher
589         uint256 tokenAmount, //the token amount paid to the publisher
590         uint256 periodSeconds, //the period in seconds between payments
591         uint256 gasPrice, //the amount of the token to incentivize the relay network
592         bytes signature //proof the subscriber signed the meta trasaction
593     )
594         public
595         view
596         returns (bool)
597     {
598         bytes32 subscriptionHash = getSubscriptionHash(
599             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice
600         );
601         address signer = getSubscriptionSigner(subscriptionHash, signature);
602         uint256 allowance = ERC20(tokenAddress).allowance(from, address(this));
603         uint256 balance = ERC20(tokenAddress).balanceOf(from);
604         return (
605             signer == from &&
606             from != to &&
607             block.timestamp >= nextValidTimestamp[subscriptionHash] &&
608             allowance >= tokenAmount.add(gasPrice) &&
609             balance >= tokenAmount.add(gasPrice)
610         );
611     }
612 
613     // you don't really need this if you are using the approve/transferFrom method
614     // because you control the flow of tokens by approving this contract address,
615     // but to make the contract an extensible example for later user I'll add this
616     function cancelSubscription(
617         address from, //the subscriber
618         address to, //the publisher
619         address tokenAddress, //the token address paid to the publisher
620         uint256 tokenAmount, //the token amount paid to the publisher
621         uint256 periodSeconds, //the period in seconds between payments
622         uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
623         bytes signature //proof the subscriber signed the meta trasaction
624     )
625         public
626         returns (bool success)
627     {
628         bytes32 subscriptionHash = getSubscriptionHash(
629             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice
630         );
631         address signer = subscriptionHash.toEthSignedMessageHash().recover(signature);
632 
633         //the signature must be valid
634         require(signer == from, "Invalid Signature for subscription cancellation");
635 
636         //nextValidTimestamp should be a timestamp that will never
637         //be reached during the brief window human existence
638         nextValidTimestamp[subscriptionHash]=uint256(-1);
639 
640         return true;
641     }
642 
643     // execute the transferFrom to pay the publisher from the subscriber
644     // the subscriber has full control by approving this contract an allowance
645     function executeSubscription(
646         address from, //the subscriber
647         address to, //the publisher
648         address tokenAddress, //the token address paid to the publisher
649         uint256 tokenAmount, //the token amount paid to the publisher
650         uint256 periodSeconds, //the period in seconds between payments
651         uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
652         bytes signature //proof the subscriber signed the meta trasaction
653     )
654         public
655         returns (bool success)
656     {
657         // make sure the subscription is valid and ready
658         // pulled this out so I have the hash, should be exact code as "isSubscriptionReady"
659         bytes32 subscriptionHash = getSubscriptionHash(
660             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice
661         );
662         address signer = getSubscriptionSigner(subscriptionHash, signature);
663 
664         //the signature must be valid
665         require(signer == from, "Invalid Signature");
666         //timestamp must be equal to or past the next period
667         require(
668             block.timestamp >= nextValidTimestamp[subscriptionHash],
669             "Subscription is not ready"
670         );
671 
672         // if there are requirements from the deployer, let's make sure
673         // those are met exactly
674         require( requiredToAddress == address(0) || to == requiredToAddress );
675         require( requiredTokenAddress == address(0) || tokenAddress == requiredTokenAddress );
676         require( requiredTokenAmount == 0 || tokenAmount == requiredTokenAmount );
677         require( requiredPeriodSeconds == 0 || periodSeconds == requiredPeriodSeconds );
678         require( requiredGasPrice == 0 || gasPrice == requiredGasPrice );
679 
680         //increment the timestamp by the period so it wont be valid until then
681         nextValidTimestamp[subscriptionHash] = block.timestamp.add(periodSeconds);
682 
683         // now, let make the transfer from the subscriber to the publisher
684         uint256 startingBalance = ERC20(tokenAddress).balanceOf(to);
685         require(
686           ERC20(tokenAddress).transferFrom(from,to,tokenAmount),
687           "Transfer Failed"
688         );
689         require(
690           (startingBalance+tokenAmount) == ERC20(tokenAddress).balanceOf(to),
691           "Crappy ERC20 is a bad kitty."
692         );
693 
694         emit ExecuteSubscription(
695             from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice
696         );
697 
698         // it is possible for the subscription execution to be run by a third party
699         // incentivized in the terms of the subscription with a gasPrice of the tokens
700         //  - pay that out now...
701         if (gasPrice > 0) {
702             //the relayer is incentivized by a little of the same token from
703             // the subscriber ... as far as the subscriber knows, they are
704             // just sending X tokens to the publisher, but the publisher can
705             // choose to send Y of those X to a relayer to run their transactions
706             // the publisher will receive X - Y tokens
707             // this must all be setup in the constructor
708             // if not, the subscriber chooses all the params including what goes
709             // to the publisher and what goes to the relayer
710 
711             require(
712                 ERC20(tokenAddress).transferFrom(from, msg.sender, gasPrice),
713                 "Failed to pay gas as from account"
714             );
715         }
716 
717         return true;
718     }
719 }