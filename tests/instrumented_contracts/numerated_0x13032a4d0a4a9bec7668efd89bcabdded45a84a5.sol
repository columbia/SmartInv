1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
96 
97 pragma solidity ^0.5.0;
98 
99 /**
100  * @title Elliptic curve signature operations
101  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
102  * TODO Remove this library once solidity supports passing a signature to ecrecover.
103  * See https://github.com/ethereum/solidity/issues/864
104  */
105 
106 library ECDSA {
107     /**
108      * @dev Recover signer address from a message by using their signature
109      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
110      * @param signature bytes signature, the signature is generated using web3.eth.sign()
111      */
112     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
113         bytes32 r;
114         bytes32 s;
115         uint8 v;
116 
117         // Check the signature length
118         if (signature.length != 65) {
119             return (address(0));
120         }
121 
122         // Divide the signature in r, s and v variables
123         // ecrecover takes the signature parameters, and the only way to get them
124         // currently is to use assembly.
125         // solhint-disable-next-line no-inline-assembly
126         assembly {
127             r := mload(add(signature, 0x20))
128             s := mload(add(signature, 0x40))
129             v := byte(0, mload(add(signature, 0x60)))
130         }
131 
132         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
133         if (v < 27) {
134             v += 27;
135         }
136 
137         // If the version is correct return the signer address
138         if (v != 27 && v != 28) {
139             return (address(0));
140         } else {
141             return ecrecover(hash, v, r, s);
142         }
143     }
144 
145     /**
146      * toEthSignedMessageHash
147      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
148      * and hash the result
149      */
150     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
151         // 32 is the length in bytes of hash,
152         // enforced by the type signature above
153         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
154     }
155 }
156 
157 // File: contracts/IndexedMerkleProof.sol
158 
159 pragma solidity ^0.5.5;
160 
161 
162 library IndexedMerkleProof {
163     function compute(bytes memory proof, uint160 leaf) internal pure returns (uint160 root, uint256 index) {
164         uint160 computedHash = leaf;
165 
166         for (uint256 i = 0; i < proof.length / 20; i++) {
167             uint160 proofElement;
168             // solium-disable-next-line security/no-inline-assembly
169             assembly {
170                 proofElement := div(mload(add(proof, add(32, mul(i, 20)))), 0x1000000000000000000000000)
171             }
172 
173             if (computedHash < proofElement) {
174                 // Hash(current computed hash + current element of the proof)
175                 computedHash = uint160(uint256(keccak256(abi.encodePacked(computedHash, proofElement))));
176                 index += (1 << i);
177             } else {
178                 // Hash(current element of the proof + current computed hash)
179                 computedHash = uint160(uint256(keccak256(abi.encodePacked(proofElement, computedHash))));
180             }
181         }
182 
183         return (computedHash, index);
184     }
185 }
186 
187 // File: contracts/InstaLend.sol
188 
189 pragma solidity ^0.5.5;
190 
191 
192 
193 
194 contract InstaLend {
195     using SafeMath for uint;
196 
197     address private _feesReceiver;
198     uint256 private _feesPercent;
199     bool private _inLendingMode;
200 
201     modifier notInLendingMode {
202         require(!_inLendingMode);
203         _;
204     }
205 
206     constructor(address receiver, uint256 percent) public {
207         _feesReceiver = receiver;
208         _feesPercent = percent;
209     }
210 
211     function feesReceiver() public view returns(address) {
212         return _feesReceiver;
213     }
214 
215     function feesPercent() public view returns(uint256) {
216         return _feesPercent;
217     }
218 
219     function lend(
220         IERC20[] memory tokens,
221         uint256[] memory amounts,
222         address target,
223         bytes memory data
224     )
225         public
226         notInLendingMode
227     {
228         _inLendingMode = true;
229 
230         // Backup original balances and lend tokens
231         uint256[] memory prevAmounts = new uint256[](tokens.length);
232         for (uint i = 0; i < tokens.length; i++) {
233             prevAmounts[i] = tokens[i].balanceOf(address(this));
234             require(tokens[i].transfer(target, amounts[i]));
235         }
236 
237         // Perform arbitrary call
238         (bool res,) = target.call(data);    // solium-disable-line security/no-low-level-calls
239         require(res, "Invalid arbitrary call");
240 
241         // Ensure original balances were restored
242         for (uint i = 0; i < tokens.length; i++) {
243             uint256 expectedFees = amounts[i].mul(_feesPercent).div(100);
244             require(tokens[i].balanceOf(address(this)) >= prevAmounts[i].add(expectedFees));
245             if (_feesReceiver != address(this)) {
246                 require(tokens[i].transfer(_feesReceiver, expectedFees));
247             }
248         }
249 
250         _inLendingMode = false;
251     }
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
255 
256 pragma solidity ^0.5.0;
257 
258 
259 
260 /**
261  * @title Standard ERC20 token
262  *
263  * @dev Implementation of the basic standard token.
264  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
265  * Originally based on code by FirstBlood:
266  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
267  *
268  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
269  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
270  * compliant implementations may not do it.
271  */
272 contract ERC20 is IERC20 {
273     using SafeMath for uint256;
274 
275     mapping (address => uint256) private _balances;
276 
277     mapping (address => mapping (address => uint256)) private _allowed;
278 
279     uint256 private _totalSupply;
280 
281     /**
282     * @dev Total number of tokens in existence
283     */
284     function totalSupply() public view returns (uint256) {
285         return _totalSupply;
286     }
287 
288     /**
289     * @dev Gets the balance of the specified address.
290     * @param owner The address to query the balance of.
291     * @return An uint256 representing the amount owned by the passed address.
292     */
293     function balanceOf(address owner) public view returns (uint256) {
294         return _balances[owner];
295     }
296 
297     /**
298      * @dev Function to check the amount of tokens that an owner allowed to a spender.
299      * @param owner address The address which owns the funds.
300      * @param spender address The address which will spend the funds.
301      * @return A uint256 specifying the amount of tokens still available for the spender.
302      */
303     function allowance(address owner, address spender) public view returns (uint256) {
304         return _allowed[owner][spender];
305     }
306 
307     /**
308     * @dev Transfer token for a specified address
309     * @param to The address to transfer to.
310     * @param value The amount to be transferred.
311     */
312     function transfer(address to, uint256 value) public returns (bool) {
313         _transfer(msg.sender, to, value);
314         return true;
315     }
316 
317     /**
318      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
319      * Beware that changing an allowance with this method brings the risk that someone may use both the old
320      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
321      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
322      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323      * @param spender The address which will spend the funds.
324      * @param value The amount of tokens to be spent.
325      */
326     function approve(address spender, uint256 value) public returns (bool) {
327         require(spender != address(0));
328 
329         _allowed[msg.sender][spender] = value;
330         emit Approval(msg.sender, spender, value);
331         return true;
332     }
333 
334     /**
335      * @dev Transfer tokens from one address to another.
336      * Note that while this function emits an Approval event, this is not required as per the specification,
337      * and other compliant implementations may not emit the event.
338      * @param from address The address which you want to send tokens from
339      * @param to address The address which you want to transfer to
340      * @param value uint256 the amount of tokens to be transferred
341      */
342     function transferFrom(address from, address to, uint256 value) public returns (bool) {
343         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
344         _transfer(from, to, value);
345         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
346         return true;
347     }
348 
349     /**
350      * @dev Increase the amount of tokens that an owner allowed to a spender.
351      * approve should be called when allowed_[_spender] == 0. To increment
352      * allowed value is better to use this function to avoid 2 calls (and wait until
353      * the first transaction is mined)
354      * From MonolithDAO Token.sol
355      * Emits an Approval event.
356      * @param spender The address which will spend the funds.
357      * @param addedValue The amount of tokens to increase the allowance by.
358      */
359     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
360         require(spender != address(0));
361 
362         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
363         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
364         return true;
365     }
366 
367     /**
368      * @dev Decrease the amount of tokens that an owner allowed to a spender.
369      * approve should be called when allowed_[_spender] == 0. To decrement
370      * allowed value is better to use this function to avoid 2 calls (and wait until
371      * the first transaction is mined)
372      * From MonolithDAO Token.sol
373      * Emits an Approval event.
374      * @param spender The address which will spend the funds.
375      * @param subtractedValue The amount of tokens to decrease the allowance by.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
378         require(spender != address(0));
379 
380         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
381         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
382         return true;
383     }
384 
385     /**
386     * @dev Transfer token for a specified addresses
387     * @param from The address to transfer from.
388     * @param to The address to transfer to.
389     * @param value The amount to be transferred.
390     */
391     function _transfer(address from, address to, uint256 value) internal {
392         require(to != address(0));
393 
394         _balances[from] = _balances[from].sub(value);
395         _balances[to] = _balances[to].add(value);
396         emit Transfer(from, to, value);
397     }
398 
399     /**
400      * @dev Internal function that mints an amount of the token and assigns it to
401      * an account. This encapsulates the modification of balances such that the
402      * proper events are emitted.
403      * @param account The account that will receive the created tokens.
404      * @param value The amount that will be created.
405      */
406     function _mint(address account, uint256 value) internal {
407         require(account != address(0));
408 
409         _totalSupply = _totalSupply.add(value);
410         _balances[account] = _balances[account].add(value);
411         emit Transfer(address(0), account, value);
412     }
413 
414     /**
415      * @dev Internal function that burns an amount of the token of a given
416      * account.
417      * @param account The account whose tokens will be burnt.
418      * @param value The amount that will be burnt.
419      */
420     function _burn(address account, uint256 value) internal {
421         require(account != address(0));
422 
423         _totalSupply = _totalSupply.sub(value);
424         _balances[account] = _balances[account].sub(value);
425         emit Transfer(account, address(0), value);
426     }
427 
428     /**
429      * @dev Internal function that burns an amount of the token of a given
430      * account, deducting from the sender's allowance for said account. Uses the
431      * internal burn function.
432      * Emits an Approval event (reflecting the reduced allowance).
433      * @param account The account whose tokens will be burnt.
434      * @param value The amount that will be burnt.
435      */
436     function _burnFrom(address account, uint256 value) internal {
437         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
438         _burn(account, value);
439         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
440     }
441 }
442 
443 // File: contracts/CheckedERC20.sol
444 
445 pragma solidity ^0.5.0;
446 
447 
448 
449 
450 library CheckedERC20 {
451     using SafeMath for uint;
452 
453     function isContract(IERC20 addr) internal view returns(bool result) {
454         // solium-disable-next-line security/no-inline-assembly
455         assembly {
456             result := gt(extcodesize(addr), 0)
457         }
458     }
459 
460     function handleReturnBool() internal pure returns(bool result) {
461         // solium-disable-next-line security/no-inline-assembly
462         assembly {
463             switch returndatasize()
464             case 0 { // not a std erc20
465                 result := 1
466             }
467             case 32 { // std erc20
468                 returndatacopy(0, 0, 32)
469                 result := mload(0)
470             }
471             default { // anything else, should revert for safety
472                 revert(0, 0)
473             }
474         }
475     }
476 
477     function handleReturnBytes32() internal pure returns(bytes32 result) {
478         // solium-disable-next-line security/no-inline-assembly
479         assembly {
480             switch eq(returndatasize(), 32) // not a std erc20
481             case 1 {
482                 returndatacopy(0, 0, 32)
483                 result := mload(0)
484             }
485 
486             switch gt(returndatasize(), 32) // std erc20
487             case 1 {
488                 returndatacopy(0, 64, 32)
489                 result := mload(0)
490             }
491 
492             switch lt(returndatasize(), 32) // anything else, should revert for safety
493             case 1 {
494                 revert(0, 0)
495             }
496         }
497     }
498 
499     function asmTransfer(IERC20 token, address to, uint256 value) internal returns(bool) {
500         require(isContract(token));
501         // solium-disable-next-line security/no-low-level-calls
502         (bool res,) = address(token).call(abi.encodeWithSignature("transfer(address,uint256)", to, value));
503         require(res);
504         return handleReturnBool();
505     }
506 
507     function asmTransferFrom(IERC20 token, address from, address to, uint256 value) internal returns(bool) {
508         require(isContract(token));
509         // solium-disable-next-line security/no-low-level-calls
510         (bool res,) = address(token).call(abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, value));
511         require(res);
512         return handleReturnBool();
513     }
514 
515     function asmApprove(IERC20 token, address spender, uint256 value) internal returns(bool) {
516         require(isContract(token));
517         // solium-disable-next-line security/no-low-level-calls
518         (bool res,) = address(token).call(abi.encodeWithSignature("approve(address,uint256)", spender, value));
519         require(res);
520         return handleReturnBool();
521     }
522 
523     //
524 
525     function checkedTransfer(IERC20 token, address to, uint256 value) internal {
526         if (value > 0) {
527             uint256 balance = token.balanceOf(address(this));
528             asmTransfer(token, to, value);
529             require(token.balanceOf(address(this)) == balance.sub(value), "checkedTransfer: Final balance didn't match");
530         }
531     }
532 
533     function checkedTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
534         if (value > 0) {
535             uint256 toBalance = token.balanceOf(to);
536             asmTransferFrom(token, from, to, value);
537             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
538         }
539     }
540 }
541 
542 // File: contracts/QRToken.sol
543 
544 pragma solidity ^0.5.5;
545 
546 
547 
548 
549 
550 
551 
552 
553 contract QRToken is InstaLend {
554     using SafeMath for uint;
555     using ECDSA for bytes;
556     using IndexedMerkleProof for bytes;
557     using CheckedERC20 for IERC20;
558 
559     uint256 constant public MAX_CODES_COUNT = 1024;
560     uint256 constant public MAX_WORDS_COUNT = (MAX_CODES_COUNT + 31) / 32;
561 
562     struct Distribution {
563         IERC20 token;
564         uint256 sumAmount;
565         uint256 codesCount;
566         uint256 deadline;
567         address sponsor;
568         uint256[32] bitMask; // MAX_WORDS_COUNT
569     }
570 
571     mapping(uint160 => Distribution) public distributions;
572 
573     event Created();
574     event Redeemed(uint160 root, uint256 index, address receiver);
575 
576     constructor()
577         public
578         InstaLend(msg.sender, 1)
579     {
580     }
581 
582     function create(
583         IERC20 token,
584         uint256 sumTokenAmount,
585         uint256 codesCount,
586         uint160 root,
587         uint256 deadline
588     )
589         external
590         notInLendingMode
591     {
592         require(0 < sumTokenAmount);
593         require(0 < codesCount && codesCount <= MAX_CODES_COUNT);
594         require(deadline > now);
595 
596         token.checkedTransferFrom(msg.sender, address(this), sumTokenAmount);
597         Distribution storage distribution = distributions[root];
598         distribution.token = token;
599         distribution.sumAmount = sumTokenAmount;
600         distribution.codesCount = codesCount;
601         distribution.deadline = deadline;
602         distribution.sponsor = msg.sender;
603     }
604 
605     function redeemed(uint160 root, uint index) public view returns(bool) {
606         Distribution storage distribution = distributions[root];
607         return distribution.bitMask[index / 32] & (1 << (index % 32)) != 0;
608     }
609 
610     function redeem(
611         bytes calldata signature,
612         bytes calldata merkleProof
613     )
614         external
615         notInLendingMode
616     {
617         bytes32 messageHash = keccak256(abi.encodePacked(msg.sender));
618         address signer = ECDSA.recover(messageHash, signature);
619         (uint160 root, uint256 index) = merkleProof.compute(uint160(signer));
620         Distribution storage distribution = distributions[root];
621         require(distribution.bitMask[index / 32] & (1 << (index % 32)) == 0);
622 
623         distribution.bitMask[index / 32] = distribution.bitMask[index / 32] | (1 << (index % 32));
624         distribution.token.checkedTransfer(msg.sender, distribution.sumAmount.div(distribution.codesCount));
625         emit Redeemed(root, index, msg.sender);
626     }
627 
628     // function redeemWithFee(
629     //     address receiver,
630     //     uint256 feePrecent,
631     //     bytes calldata signature,
632     //     bytes calldata merkleProof
633     // )
634     //     external
635     //     notInLendingMode
636     // {
637     //     bytes32 messageHash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(receiver, feePrecent)));
638     //     address signer = ECDSA.recover(messageHash, signature);
639     //     (uint160 root, uint256 index) = merkleProof.compute(uint160(signer));
640     //     Distribution storage distribution = distributions[root];
641     //     require(distribution.bitMask[index / 32] & (1 << (index % 32)) == 0);
642 
643     //     distribution.bitMask[index / 32] = distribution.bitMask[index / 32] | (1 << (index % 32));
644     //     uint256 reward = distribution.sumAmount.div(distribution.codesCount);
645     //     uint256 fee = reward.mul(feePrecent).div(100);
646     //     distribution.token.checkedTransfer(receiver, reward);
647     //     distribution.token.checkedTransfer(msg.sender, fee);
648     //     emit Redeemed(root, index, receiver);
649     // }
650 
651     function abort(uint160 root)
652         public
653         notInLendingMode
654     {
655         Distribution storage distribution = distributions[root];
656         require(now > distribution.deadline);
657 
658         uint256 count = 0;
659         for (uint i = 0; i < 1024; i++) {
660             if (distribution.bitMask[i / 32] & (1 << (i % 32)) != 0) {
661                 count += distribution.sumAmount / distribution.codesCount;
662             }
663         }
664         distribution.token.checkedTransfer(distribution.sponsor, distribution.sumAmount.sub(count));
665         delete distributions[root];
666     }
667 }