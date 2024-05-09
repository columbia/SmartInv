1 pragma solidity ^0.5.8;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      * @notice Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Unsigned math operations with safety checks that revert on error
79  */
80 library SafeMath
81 {
82 	/**
83 	* @dev Adds two unsigned integers, reverts on overflow.
84 	*/
85 	function add(uint256 a, uint256 b) internal pure returns (uint256)
86 	{
87 		uint256 c = a + b;
88 		require(c >= a);
89 		return c;
90 	}
91 
92 	/**
93 	* @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94 	*/
95 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
96 	{
97 		require(b <= a);
98 		uint256 c = a - b;
99 		return c;
100 	}
101 
102 	/**
103 	* @dev Multiplies two unsigned integers, reverts on overflow.
104 	*/
105 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
106 	{
107 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108 		// benefit is lost if 'b' is also tested.
109 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
110 		if (a == 0)
111 		{
112 			return 0;
113 		}
114 		uint256 c = a * b;
115 		require(c / a == b);
116 		return c;
117 	}
118 
119 	/**
120 	* @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
121 	*/
122 	function div(uint256 a, uint256 b) internal pure returns (uint256)
123 	{
124 			// Solidity only automatically asserts when dividing by 0
125 			require(b > 0);
126 			uint256 c = a / b;
127 			// assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 			return c;
129 	}
130 
131 	/**
132 	* @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
133 	* reverts when dividing by zero.
134 	*/
135 	function mod(uint256 a, uint256 b) internal pure returns (uint256)
136 	{
137 		require(b != 0);
138 		return a % b;
139 	}
140 
141 	/**
142 	* @dev Returns the largest of two numbers.
143 	*/
144 	function max(uint256 a, uint256 b) internal pure returns (uint256)
145 	{
146 		return a >= b ? a : b;
147 	}
148 
149 	/**
150 	* @dev Returns the smallest of two numbers.
151 	*/
152 	function min(uint256 a, uint256 b) internal pure returns (uint256)
153 	{
154 		return a < b ? a : b;
155 	}
156 
157 	/**
158 	* @dev Multiplies the a by the fraction b/c
159 	*/
160 	function mulByFraction(uint256 a, uint256 b, uint256 c) internal pure returns (uint256)
161 	{
162 		return div(mul(a, b), c);
163 	}
164 
165 	/**
166 	* @dev Return b percents of a (equivalent to a percents of b)
167 	*/
168 	function percentage(uint256 a, uint256 b) internal pure returns (uint256)
169 	{
170 		return mulByFraction(a, b, 100);
171 	}
172 
173 	/**
174 	* @dev Returns the base 2 log of x
175 	* @notice Source : https://ethereum.stackexchange.com/questions/8086/logarithm-math-operation-in-solidity
176 	*/
177 	function log(uint x) internal pure returns (uint y)
178 	{
179 		assembly
180 		{
181 			let arg := x
182 			x := sub(x,1)
183 			x := or(x, div(x, 0x02))
184 			x := or(x, div(x, 0x04))
185 			x := or(x, div(x, 0x10))
186 			x := or(x, div(x, 0x100))
187 			x := or(x, div(x, 0x10000))
188 			x := or(x, div(x, 0x100000000))
189 			x := or(x, div(x, 0x10000000000000000))
190 			x := or(x, div(x, 0x100000000000000000000000000000000))
191 			x := add(x, 1)
192 			let m := mload(0x40)
193 			mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
194 			mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
195 			mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
196 			mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
197 			mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
198 			mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
199 			mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
200 			mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
201 			mstore(0x40, add(m, 0x100))
202 			let magic := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
203 			let shift := 0x100000000000000000000000000000000000000000000000000000000000000
204 			let a := div(mul(x, magic), shift)
205 			y := div(mload(add(m,sub(255,a))), shift)
206 			y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
207 		}
208 	}
209 }
210 
211 /**
212  * @title ERC20 interface
213  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
214  */
215 interface IERC20
216 {
217 	function totalSupply()
218 		external view returns (uint256);
219 
220 	function balanceOf(address who)
221 		external view returns (uint256);
222 
223 	function allowance(address owner, address spender)
224 		external view returns (uint256);
225 
226 	function transfer(address to, uint256 value)
227 		external returns (bool);
228 
229 	function approve(address spender, uint256 value)
230 		external returns (bool);
231 
232 	function transferFrom(address from, address to, uint256 value)
233 		external returns (bool);
234 
235 	event Transfer(
236 		address indexed from,
237 		address indexed to,
238 		uint256 value
239 	);
240 
241 	event Approval(
242 		address indexed owner,
243 		address indexed spender,
244 		uint256 value
245 	);
246 }
247 
248 contract IERC734
249 {
250 	// 1: MANAGEMENT keys, which can manage the identity
251 	uint256 public constant MANAGEMENT_KEY = 1;
252 	// 2: ACTION keys, which perform actions in this identities name (signing, logins, transactions, etc.)
253 	uint256 public constant ACTION_KEY = 2;
254 	// 3: CLAIM signer keys, used to sign claims on other identities which need to be revokable.
255 	uint256 public constant CLAIM_SIGNER_KEY = 3;
256 	// 4: ENCRYPTION keys, used to encrypt data e.g. hold in claims.
257 	uint256 public constant ENCRYPTION_KEY = 4;
258 
259 	// KeyType
260 	uint256 public constant ECDSA_TYPE = 1;
261 	// https://medium.com/@alexberegszaszi/lets-bring-the-70s-to-ethereum-48daa16a4b51
262 	uint256 public constant RSA_TYPE = 2;
263 
264 	// Events
265 	event KeyAdded          (bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
266 	event KeyRemoved        (bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
267 	event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
268 	event Executed          (uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
269 	event ExecutionFailed   (uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
270 	event Approved          (uint256 indexed executionId, bool approved);
271 
272 	// Functions
273 	function getKey          (bytes32 _key                                     ) external view returns (uint256[] memory purposes, uint256 keyType, bytes32 key);
274 	function keyHasPurpose   (bytes32 _key, uint256 purpose                    ) external view returns (bool exists);
275 	function getKeysByPurpose(uint256 _purpose                                 ) external view returns (bytes32[] memory keys);
276 	function addKey          (bytes32 _key, uint256 _purpose, uint256 _keyType ) external      returns (bool success);
277 	function removeKey       (bytes32 _key, uint256 _purpose                   ) external      returns (bool success);
278 	function execute         (address _to, uint256 _value, bytes calldata _data) external      returns (uint256 executionId);
279 	function approve         (uint256 _id, bool _approve                       ) external      returns (bool success);
280 }
281 
282 contract IERC1271
283 {
284 	// bytes4(keccak256("isValidSignature(bytes,bytes)")
285 	bytes4 constant internal MAGICVALUE = 0x20c13b0b;
286 
287 	/**
288 	 * @dev Should return whether the signature provided is valid for the provided data
289 	 * @param _data Arbitrary length data signed on the behalf of address(this)
290 	 * @param _signature Signature byte array associated with _data
291 	 *
292 	 * MUST return the bytes4 magic value 0x20c13b0b when function passes.
293 	 * MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
294 	 * MUST allow external calls
295 	 */
296 	// function isValidSignature(
297 	// 	bytes memory _data,
298 	// 	bytes memory _signature)
299 	// 	public
300 	// 	view
301 	// 	returns (bytes4 magicValue);
302 
303 	// Newer version ? From 0x V2
304 	function isValidSignature(
305 		bytes32 _data,
306 		bytes memory _signature
307 	)
308 	public
309 	view
310 	returns (bool isValid);
311 }
312 
313 /**
314  * @title EIP1154 interface
315  * @dev see https://eips.ethereum.org/EIPS/eip-1154
316  */
317 interface IOracleConsumer
318 {
319 	function receiveResult(bytes32, bytes calldata)
320 		external;
321 }
322 
323 interface IOracle
324 {
325 	function resultFor(bytes32)
326 		external view returns (bytes memory);
327 }
328 
329 library IexecODBLibCore
330 {
331 	/**
332 	* Tools
333 	*/
334 	struct Account
335 	{
336 		uint256 stake;
337 		uint256 locked;
338 	}
339 	struct Category
340 	{
341 		string  name;
342 		string  description;
343 		uint256 workClockTimeRef;
344 	}
345 
346 	/**
347 	 * Clerk - Deals
348 	 */
349 	struct Resource
350 	{
351 		address pointer;
352 		address owner;
353 		uint256 price;
354 	}
355 	struct Deal
356 	{
357 		// Ressources
358 		Resource app;
359 		Resource dataset;
360 		Resource workerpool;
361 		uint256 trust;
362 		uint256 category;
363 		bytes32 tag;
364 		// execution details
365 		address requester;
366 		address beneficiary;
367 		address callback;
368 		string  params;
369 		// execution settings
370 		uint256 startTime;
371 		uint256 botFirst;
372 		uint256 botSize;
373 		// consistency
374 		uint256 workerStake;
375 		uint256 schedulerRewardRatio;
376 	}
377 
378 	/**
379 	 * Tasks
380 	 // TODO: rename Workorder → Task
381 	 */
382 	enum TaskStatusEnum
383 	{
384 		UNSET,     // Work order not yet initialized (invalid address)
385 		ACTIVE,    // Marketed → constributions are open
386 		REVEALING, // Starting consensus reveal
387 		COMPLETED, // Concensus achieved
388 		FAILLED    // Failled consensus
389 	}
390 	struct Task
391 	{
392 		TaskStatusEnum status;
393 		bytes32   dealid;
394 		uint256   idx;
395 		uint256   timeref;
396 		uint256   contributionDeadline;
397 		uint256   revealDeadline;
398 		uint256   finalDeadline;
399 		bytes32   consensusValue;
400 		uint256   revealCounter;
401 		uint256   winnerCounter;
402 		address[] contributors;
403 		bytes32   resultDigest;
404 		bytes     results;
405 	}
406 
407 	/**
408 	 * Consensus
409 	 */
410 	enum ContributionStatusEnum
411 	{
412 		UNSET,
413 		CONTRIBUTED,
414 		PROVED,
415 		REJECTED
416 	}
417 	struct Contribution
418 	{
419 		ContributionStatusEnum status;
420 		bytes32 resultHash;
421 		bytes32 resultSeal;
422 		address enclaveChallenge;
423 	}
424 
425 }
426 
427 library IexecODBLibOrders
428 {
429 	// bytes32 public constant    EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
430 	// bytes32 public constant        APPORDER_TYPEHASH = keccak256("AppOrder(address app,uint256 appprice,uint256 volume,bytes32 tag,address datasetrestrict,address workerpoolrestrict,address requesterrestrict,bytes32 salt)");
431 	// bytes32 public constant    DATASETORDER_TYPEHASH = keccak256("DatasetOrder(address dataset,uint256 datasetprice,uint256 volume,bytes32 tag,address apprestrict,address workerpoolrestrict,address requesterrestrict,bytes32 salt)");
432 	// bytes32 public constant WORKERPOOLORDER_TYPEHASH = keccak256("WorkerpoolOrder(address workerpool,uint256 workerpoolprice,uint256 volume,bytes32 tag,uint256 category,uint256 trust,address apprestrict,address datasetrestrict,address requesterrestrict,bytes32 salt)");
433 	// bytes32 public constant    REQUESTORDER_TYPEHASH = keccak256("RequestOrder(address app,uint256 appmaxprice,address dataset,uint256 datasetmaxprice,address workerpool,uint256 workerpoolmaxprice,address requester,uint256 volume,bytes32 tag,uint256 category,uint256 trust,address beneficiary,address callback,string params,bytes32 salt)");
434 	bytes32 public constant    EIP712DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
435 	bytes32 public constant        APPORDER_TYPEHASH = 0x60815a0eeec47dddf1615fe53b31d016c31444e01b9d796db365443a6445d008;
436 	bytes32 public constant    DATASETORDER_TYPEHASH = 0x6cfc932a5a3d22c4359295b9f433edff52b60703fa47690a04a83e40933dd47c;
437 	bytes32 public constant WORKERPOOLORDER_TYPEHASH = 0xaa3429fb281b34691803133d3d978a75bb77c617ed6bc9aa162b9b30920022bb;
438 	bytes32 public constant    REQUESTORDER_TYPEHASH = 0xf24e853034a3a450aba845a82914fbb564ad85accca6cf62be112a154520fae0;
439 
440 	struct EIP712Domain
441 	{
442 		string  name;
443 		string  version;
444 		uint256 chainId;
445 		address verifyingContract;
446 	}
447 	struct AppOrder
448 	{
449 		address app;
450 		uint256 appprice;
451 		uint256 volume;
452 		bytes32 tag;
453 		address datasetrestrict;
454 		address workerpoolrestrict;
455 		address requesterrestrict;
456 		bytes32 salt;
457 		bytes   sign;
458 	}
459 	struct DatasetOrder
460 	{
461 		address dataset;
462 		uint256 datasetprice;
463 		uint256 volume;
464 		bytes32 tag;
465 		address apprestrict;
466 		address workerpoolrestrict;
467 		address requesterrestrict;
468 		bytes32 salt;
469 		bytes   sign;
470 	}
471 	struct WorkerpoolOrder
472 	{
473 		address workerpool;
474 		uint256 workerpoolprice;
475 		uint256 volume;
476 		bytes32 tag;
477 		uint256 category;
478 		uint256 trust;
479 		address apprestrict;
480 		address datasetrestrict;
481 		address requesterrestrict;
482 		bytes32 salt;
483 		bytes   sign;
484 	}
485 	struct RequestOrder
486 	{
487 		address app;
488 		uint256 appmaxprice;
489 		address dataset;
490 		uint256 datasetmaxprice;
491 		address workerpool;
492 		uint256 workerpoolmaxprice;
493 		address requester;
494 		uint256 volume;
495 		bytes32 tag;
496 		uint256 category;
497 		uint256 trust;
498 		address beneficiary;
499 		address callback;
500 		string  params;
501 		bytes32 salt;
502 		bytes   sign;
503 	}
504 
505 	function hash(EIP712Domain memory _domain)
506 	public pure returns (bytes32 domainhash)
507 	{
508 		/**
509 		 * Readeable but expensive
510 		 */
511 		// return keccak256(abi.encode(
512 		// 	EIP712DOMAIN_TYPEHASH
513 		// , keccak256(bytes(_domain.name))
514 		// , keccak256(bytes(_domain.version))
515 		// , _domain.chainId
516 		// , _domain.verifyingContract
517 		// ));
518 
519 		// Compute sub-hashes
520 		bytes32 typeHash    = EIP712DOMAIN_TYPEHASH;
521 		bytes32 nameHash    = keccak256(bytes(_domain.name));
522 		bytes32 versionHash = keccak256(bytes(_domain.version));
523 		assembly {
524 			// Back up select memory
525 			let temp1 := mload(sub(_domain, 0x20))
526 			let temp2 := mload(add(_domain, 0x00))
527 			let temp3 := mload(add(_domain, 0x20))
528 			// Write typeHash and sub-hashes
529 			mstore(sub(_domain, 0x20),    typeHash)
530 			mstore(add(_domain, 0x00),    nameHash)
531 			mstore(add(_domain, 0x20), versionHash)
532 			// Compute hash
533 			domainhash := keccak256(sub(_domain, 0x20), 0xA0) // 160 = 32 + 128
534 			// Restore memory
535 			mstore(sub(_domain, 0x20), temp1)
536 			mstore(add(_domain, 0x00), temp2)
537 			mstore(add(_domain, 0x20), temp3)
538 		}
539 	}
540 	function hash(AppOrder memory _apporder)
541 	public pure returns (bytes32 apphash)
542 	{
543 		/**
544 		 * Readeable but expensive
545 		 */
546 		// return keccak256(abi.encode(
547 		// 	APPORDER_TYPEHASH
548 		// , _apporder.app
549 		// , _apporder.appprice
550 		// , _apporder.volume
551 		// , _apporder.tag
552 		// , _apporder.datasetrestrict
553 		// , _apporder.workerpoolrestrict
554 		// , _apporder.requesterrestrict
555 		// , _apporder.salt
556 		// ));
557 
558 		// Compute sub-hashes
559 		bytes32 typeHash = APPORDER_TYPEHASH;
560 		assembly {
561 			// Back up select memory
562 			let temp1 := mload(sub(_apporder, 0x20))
563 			// Write typeHash and sub-hashes
564 			mstore(sub(_apporder, 0x20), typeHash)
565 			// Compute hash
566 			apphash := keccak256(sub(_apporder, 0x20), 0x120) // 288 = 32 + 256
567 			// Restore memory
568 			mstore(sub(_apporder, 0x20), temp1)
569 		}
570 	}
571 	function hash(DatasetOrder memory _datasetorder)
572 	public pure returns (bytes32 datasethash)
573 	{
574 		/**
575 		 * Readeable but expensive
576 		 */
577 		// return keccak256(abi.encode(
578 		// 	DATASETORDER_TYPEHASH
579 		// , _datasetorder.dataset
580 		// , _datasetorder.datasetprice
581 		// , _datasetorder.volume
582 		// , _datasetorder.tag
583 		// , _datasetorder.apprestrict
584 		// , _datasetorder.workerpoolrestrict
585 		// , _datasetorder.requesterrestrict
586 		// , _datasetorder.salt
587 		// ));
588 
589 		// Compute sub-hashes
590 		bytes32 typeHash = DATASETORDER_TYPEHASH;
591 		assembly {
592 			// Back up select memory
593 			let temp1 := mload(sub(_datasetorder, 0x20))
594 			// Write typeHash and sub-hashes
595 			mstore(sub(_datasetorder, 0x20), typeHash)
596 			// Compute hash
597 			datasethash := keccak256(sub(_datasetorder, 0x20), 0x120) // 288 = 32 + 256
598 			// Restore memory
599 			mstore(sub(_datasetorder, 0x20), temp1)
600 		}
601 	}
602 	function hash(WorkerpoolOrder memory _workerpoolorder)
603 	public pure returns (bytes32 workerpoolhash)
604 	{
605 		/**
606 		 * Readeable but expensive
607 		 */
608 		// return keccak256(abi.encode(
609 		// 	WORKERPOOLORDER_TYPEHASH
610 		// , _workerpoolorder.workerpool
611 		// , _workerpoolorder.workerpoolprice
612 		// , _workerpoolorder.volume
613 		// , _workerpoolorder.tag
614 		// , _workerpoolorder.category
615 		// , _workerpoolorder.trust
616 		// , _workerpoolorder.apprestrict
617 		// , _workerpoolorder.datasetrestrict
618 		// , _workerpoolorder.requesterrestrict
619 		// , _workerpoolorder.salt
620 		// ));
621 
622 		// Compute sub-hashes
623 		bytes32 typeHash = WORKERPOOLORDER_TYPEHASH;
624 		assembly {
625 			// Back up select memory
626 			let temp1 := mload(sub(_workerpoolorder, 0x20))
627 			// Write typeHash and sub-hashes
628 			mstore(sub(_workerpoolorder, 0x20), typeHash)
629 			// Compute hash
630 			workerpoolhash := keccak256(sub(_workerpoolorder, 0x20), 0x160) // 352 = 32 + 320
631 			// Restore memory
632 			mstore(sub(_workerpoolorder, 0x20), temp1)
633 		}
634 	}
635 	function hash(RequestOrder memory _requestorder)
636 	public pure returns (bytes32 requesthash)
637 	{
638 		/**
639 		 * Readeable but expensive
640 		 */
641 		//return keccak256(abi.encodePacked(
642 		//	abi.encode(
643 		//		REQUESTORDER_TYPEHASH
644 		//	, _requestorder.app
645 		//	, _requestorder.appmaxprice
646 		//	, _requestorder.dataset
647 		//	, _requestorder.datasetmaxprice
648 		//	, _requestorder.workerpool
649 		//	, _requestorder.workerpoolmaxprice
650 		//	, _requestorder.requester
651 		//	, _requestorder.volume
652 		//	, _requestorder.tag
653 		//	, _requestorder.category
654 		//	, _requestorder.trust
655 		//	, _requestorder.beneficiary
656 		//	, _requestorder.callback
657 		//	, keccak256(bytes(_requestorder.params))
658 		//	, _requestorder.salt
659 		//	)
660 		//));
661 
662 		// Compute sub-hashes
663 		bytes32 typeHash = REQUESTORDER_TYPEHASH;
664 		bytes32 paramsHash = keccak256(bytes(_requestorder.params));
665 		assembly {
666 			// Back up select memory
667 			let temp1 := mload(sub(_requestorder, 0x020))
668 			let temp2 := mload(add(_requestorder, 0x1A0))
669 			// Write typeHash and sub-hashes
670 			mstore(sub(_requestorder, 0x020), typeHash)
671 			mstore(add(_requestorder, 0x1A0), paramsHash)
672 			// Compute hash
673 			requesthash := keccak256(sub(_requestorder, 0x20), 0x200) // 512 = 32 + 480
674 			// Restore memory
675 			mstore(sub(_requestorder, 0x020), temp1)
676 			mstore(add(_requestorder, 0x1A0), temp2)
677 		}
678 	}
679 
680 	function toEthTypedStructHash(bytes32 _structHash, bytes32 _domainHash)
681 	public pure returns (bytes32 typedStructHash)
682 	{
683 		return keccak256(abi.encodePacked("\x19\x01", _domainHash, _structHash));
684 	}
685 }
686 
687 
688 contract RegistryBase
689 {
690 
691 	using SafeMath for uint256;
692 
693 	/**
694 	 * Members
695 	 */
696 	mapping(address => bool                       ) m_registered;
697 	mapping(address => mapping(uint256 => address)) m_byOwnerByIndex;
698 	mapping(address => uint256                    ) m_countByOwner;
699 
700 	/**
701 	 * Constructor
702 	 */
703 	constructor()
704 	public
705 	{
706 	}
707 
708 	/**
709 	 * Accessors
710 	 */
711 	function isRegistered(address _entry)
712 	public view returns (bool)
713 	{
714 		return m_registered[_entry];
715 	}
716 
717 	function viewEntry(address _owner, uint256 _index)
718 	public view returns (address)
719 	{
720 		return m_byOwnerByIndex[_owner][_index];
721 	}
722 
723 	function viewCount(address _owner)
724 	public view returns (uint256)
725 	{
726 		return m_countByOwner[_owner];
727 	}
728 
729 	/**
730 	 * Internal
731 	 */
732 	function insert(
733 		address _entry,
734 		address _owner)
735 	internal returns (bool)
736 	{
737 		uint id = m_countByOwner[_owner].add(1);
738 		m_countByOwner  [_owner]     = id;
739 		m_byOwnerByIndex[_owner][id] = _entry;
740 		m_registered    [_entry]     = true;
741 		return true;
742 	}
743 }
744 
745 
746 contract App is Ownable
747 {
748 	/**
749 	 * Members
750 	 */
751 	string  public m_appName;
752 	string  public m_appType;
753 	bytes   public m_appMultiaddr;
754 	bytes32 public m_appChecksum;
755 	bytes   public m_appMREnclave;
756 
757 	/**
758 	 * Constructor
759 	 */
760 	constructor(
761 		address        _appOwner,
762 		string  memory _appName,
763 		string  memory _appType,
764 		bytes   memory _appMultiaddr,
765 		bytes32        _appChecksum,
766 		bytes   memory _appMREnclave)
767 	public
768 	{
769 		_transferOwnership(_appOwner);
770 		m_appName      = _appName;
771 		m_appType      = _appType;
772 		m_appMultiaddr = _appMultiaddr;
773 		m_appChecksum  = _appChecksum;
774 		m_appMREnclave = _appMREnclave;
775 	}
776 
777 	function transferOwnership(address) public { revert("disabled"); }
778 
779 }
780 
781 
782 contract AppRegistry is RegistryBase //, OwnableMutable // is Owned by IexecHub
783 {
784 	event CreateApp(address indexed appOwner, address app);
785 
786 	/**
787 	 * Constructor
788 	 */
789 	constructor()
790 	public
791 	{
792 	}
793 
794 	/**
795 	 * App creation
796 	 */
797 	function createApp(
798 		address          _appOwner,
799 		string  calldata _appName,
800 		string  calldata _appType,
801 		bytes   calldata _appMultiaddr,
802 		bytes32          _appChecksum,
803 		bytes   calldata _appMREnclave)
804 	external /* onlyOwner /*owner == IexecHub*/ returns (App)
805 	{
806 		App newApp = new App(
807 			_appOwner,
808 			_appName,
809 			_appType,
810 			_appMultiaddr,
811 			_appChecksum,
812 			_appMREnclave
813 		);
814 		require(insert(address(newApp), _appOwner));
815 		emit CreateApp(_appOwner, address(newApp));
816 		return newApp;
817 	}
818 
819 }
820 
821 
822 contract Dataset is Ownable
823 {
824 	/**
825 	 * Members
826 	 */
827 	string  public m_datasetName;
828 	bytes   public m_datasetMultiaddr;
829 	bytes32 public m_datasetChecksum;
830 
831 	/**
832 	 * Constructor
833 	 */
834 	constructor(
835 		address        _datasetOwner,
836 		string  memory _datasetName,
837 		bytes   memory _datasetMultiaddr,
838 		bytes32        _datasetChecksum)
839 	public
840 	{
841 		_transferOwnership(_datasetOwner);
842 		m_datasetName      = _datasetName;
843 		m_datasetMultiaddr = _datasetMultiaddr;
844 		m_datasetChecksum  = _datasetChecksum;
845 	}
846 
847 	function transferOwnership(address) public { revert("disabled"); }
848 
849 }
850 
851 
852 contract DatasetRegistry is RegistryBase //, OwnableMutable // is Owned by IexecHub
853 {
854 	event CreateDataset(address indexed datasetOwner, address dataset);
855 
856 	/**
857 	 * Constructor
858 	 */
859 	constructor()
860 	public
861 	{
862 	}
863 
864 	/**
865 	 * Dataset creation
866 	 */
867 	function createDataset(
868 		address          _datasetOwner,
869 		string  calldata _datasetName,
870 		bytes   calldata _datasetMultiaddr,
871 		bytes32          _datasetChecksum)
872 	external /* onlyOwner /*owner == IexecHub*/ returns (Dataset)
873 	{
874 		Dataset newDataset = new Dataset(
875 			_datasetOwner,
876 			_datasetName,
877 			_datasetMultiaddr,
878 			_datasetChecksum
879 		);
880 		require(insert(address(newDataset), _datasetOwner));
881 		emit CreateDataset(_datasetOwner, address(newDataset));
882 		return newDataset;
883 	}
884 }
885 
886 
887 contract Workerpool is Ownable
888 {
889 	/**
890 	 * Parameters
891 	 */
892 	string  public m_workerpoolDescription;
893 	uint256 public m_workerStakeRatioPolicy;     // % of reward to stake
894 	uint256 public m_schedulerRewardRatioPolicy; // % of reward given to scheduler
895 
896 	/**
897 	 * Events
898 	 */
899 	event PolicyUpdate(
900 		uint256 oldWorkerStakeRatioPolicy,     uint256 newWorkerStakeRatioPolicy,
901 		uint256 oldSchedulerRewardRatioPolicy, uint256 newSchedulerRewardRatioPolicy);
902 
903 	/**
904 	 * Constructor
905 	 */
906 	constructor(
907 		address        _workerpoolOwner,
908 		string  memory _workerpoolDescription)
909 	public
910 	{
911 		_transferOwnership(_workerpoolOwner);
912 		m_workerpoolDescription      = _workerpoolDescription;
913 		m_workerStakeRatioPolicy     = 30; // mutable
914 		m_schedulerRewardRatioPolicy = 1;  // mutable
915 	}
916 
917 	function changePolicy(
918 		uint256 _newWorkerStakeRatioPolicy,
919 		uint256 _newSchedulerRewardRatioPolicy)
920 	public onlyOwner
921 	{
922 		require(_newSchedulerRewardRatioPolicy <= 100);
923 
924 		emit PolicyUpdate(
925 			m_workerStakeRatioPolicy,     _newWorkerStakeRatioPolicy,
926 			m_schedulerRewardRatioPolicy, _newSchedulerRewardRatioPolicy
927 		);
928 
929 		m_workerStakeRatioPolicy     = _newWorkerStakeRatioPolicy;
930 		m_schedulerRewardRatioPolicy = _newSchedulerRewardRatioPolicy;
931 	}
932 
933 	function transferOwnership(address) public { revert("disabled"); }
934 
935 }
936 
937 
938 contract WorkerpoolRegistry is RegistryBase //, OwnableMutable // is Owned by IexecHub
939 {
940 	event CreateWorkerpool(address indexed workerpoolOwner, address indexed workerpool, string workerpoolDescription);
941 
942 	/**
943 	 * Constructor
944 	 */
945 	constructor()
946 	public
947 	{
948 	}
949 
950 	/**
951 	 * Pool creation
952 	 */
953 	function createWorkerpool(
954 		address          _workerpoolOwner,
955 		string  calldata _workerpoolDescription)
956 	external /* onlyOwner /*owner == IexecHub*/ returns (Workerpool)
957 	{
958 		Workerpool newWorkerpool = new Workerpool(
959 			_workerpoolOwner,
960 			_workerpoolDescription
961 		);
962 		require(insert(address(newWorkerpool), _workerpoolOwner));
963 		emit CreateWorkerpool(_workerpoolOwner, address(newWorkerpool), _workerpoolDescription);
964 		return newWorkerpool;
965 	}
966 }
967 
968 
969 
970 contract CategoryManager is Ownable
971 {
972 	/**
973 	 * Content
974 	 */
975 	IexecODBLibCore.Category[] m_categories;
976 
977 	/**
978 	 * Event
979 	 */
980 	event CreateCategory(
981 		uint256 catid,
982 		string  name,
983 		string  description,
984 		uint256 workClockTimeRef);
985 
986 	/**
987 	 * Constructor
988 	 */
989 	constructor()
990 	public
991 	{
992 	}
993 
994 	/**
995 	 * Accessors
996 	 */
997 	function viewCategory(uint256 _catid)
998 	external view returns (IexecODBLibCore.Category memory category)
999 	{
1000 		return m_categories[_catid];
1001 	}
1002 
1003 	function countCategory()
1004 	external view returns (uint256 count)
1005 	{
1006 		return m_categories.length;
1007 	}
1008 
1009 	/**
1010 	 * Methods
1011 	 */
1012 	function createCategory(
1013 		string  calldata name,
1014 		string  calldata description,
1015 		uint256          workClockTimeRef)
1016 	external onlyOwner returns (uint256)
1017 	{
1018 		uint256 catid = m_categories.push(IexecODBLibCore.Category(
1019 			name,
1020 			description,
1021 			workClockTimeRef
1022 		)) - 1;
1023 
1024 		emit CreateCategory(
1025 			catid,
1026 			name,
1027 			description,
1028 			workClockTimeRef
1029 		);
1030 		return catid;
1031 	}
1032 	/**
1033 	 * TODO: move to struct based initialization ?
1034 	 *
1035 	function createCategory(IexecODBLib.Category _category)
1036 	public onlyOwner returns (uint256)
1037 	{
1038 		uint256 catid = m_categories.push(_category);
1039 		emit CreateCategory(
1040 			catid,
1041 			_category.name,
1042 			_category.description,
1043 			_category.workClockTimeRef
1044 		);
1045 		return catid;
1046 	}
1047 	*/
1048 
1049 }
1050 
1051 
1052 
1053 contract Escrow
1054 {
1055 	using SafeMath for uint256;
1056 
1057 	/**
1058 	* token contract for transfers.
1059 	*/
1060 	IERC20 public token;
1061 
1062 	/**
1063 	 * Escrow content
1064 	 */
1065 	mapping(address => IexecODBLibCore.Account) m_accounts;
1066 
1067 	/**
1068 	 * Events
1069 	 */
1070 	event Deposit   (address owner, uint256 amount);
1071 	event DepositFor(address owner, uint256 amount, address target);
1072 	event Withdraw  (address owner, uint256 amount);
1073 	event Reward    (address user,  uint256 amount, bytes32 ref);
1074 	event Seize     (address user,  uint256 amount, bytes32 ref);
1075 	event Lock      (address user,  uint256 amount);
1076 	event Unlock    (address user,  uint256 amount);
1077 
1078 	/**
1079 	 * Constructor
1080 	 */
1081 	constructor(address _token)
1082 	public
1083 	{
1084 		token = IERC20(_token);
1085 	}
1086 
1087 	/**
1088 	 * Accessor
1089 	 */
1090 	function viewAccount(address _user)
1091 	external view returns (IexecODBLibCore.Account memory account)
1092 	{
1093 		return m_accounts[_user];
1094 	}
1095 
1096 	/**
1097 	 * Wallet methods: public
1098 	 */
1099 	function deposit(uint256 _amount)
1100 	external returns (bool)
1101 	{
1102 		require(token.transferFrom(msg.sender, address(this), _amount));
1103 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.add(_amount);
1104 		emit Deposit(msg.sender, _amount);
1105 		return true;
1106 	}
1107 
1108 	function depositFor(uint256 _amount, address _target)
1109 	public returns (bool)
1110 	{
1111 		require(_target != address(0));
1112 
1113 		require(token.transferFrom(msg.sender, address(this), _amount));
1114 		m_accounts[_target].stake = m_accounts[_target].stake.add(_amount);
1115 		emit DepositFor(msg.sender, _amount, _target);
1116 		return true;
1117 	}
1118 
1119 	function depositForArray(uint256[] calldata _amounts, address[] calldata _targets)
1120 	external returns (bool)
1121 	{
1122 		require(_amounts.length == _targets.length);
1123 		for (uint i = 0; i < _amounts.length; ++i)
1124 		{
1125 			depositFor(_amounts[i], _targets[i]);
1126 		}
1127 		return true;
1128 	}
1129 
1130 	function withdraw(uint256 _amount)
1131 	external returns (bool)
1132 	{
1133 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.sub(_amount);
1134 		require(token.transfer(msg.sender, _amount));
1135 		emit Withdraw(msg.sender, _amount);
1136 		return true;
1137 	}
1138 
1139 	/**
1140 	 * Wallet methods: Internal
1141 	 */
1142 	function reward(address _user, uint256 _amount, bytes32 _reference) internal /* returns (bool) */
1143 	{
1144 		m_accounts[_user].stake = m_accounts[_user].stake.add(_amount);
1145 		emit Reward(_user, _amount, _reference);
1146 		/* return true; */
1147 	}
1148 	function seize(address _user, uint256 _amount, bytes32 _reference) internal /* returns (bool) */
1149 	{
1150 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
1151 		emit Seize(_user, _amount, _reference);
1152 		/* return true; */
1153 	}
1154 	function lock(address _user, uint256 _amount) internal /* returns (bool) */
1155 	{
1156 		m_accounts[_user].stake  = m_accounts[_user].stake.sub(_amount);
1157 		m_accounts[_user].locked = m_accounts[_user].locked.add(_amount);
1158 		emit Lock(_user, _amount);
1159 		/* return true; */
1160 	}
1161 	function unlock(address _user, uint256 _amount) internal /* returns (bool) */
1162 	{
1163 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
1164 		m_accounts[_user].stake  = m_accounts[_user].stake.add(_amount);
1165 		emit Unlock(_user, _amount);
1166 		/* return true; */
1167 	}
1168 }
1169 
1170 
1171 contract Relay
1172 {
1173 	event BroadcastAppOrder       (IexecODBLibOrders.AppOrder        apporder       );
1174 	event BroadcastDatasetOrder   (IexecODBLibOrders.DatasetOrder    datasetorder   );
1175 	event BroadcastWorkerpoolOrder(IexecODBLibOrders.WorkerpoolOrder workerpoolorder);
1176 	event BroadcastRequestOrder   (IexecODBLibOrders.RequestOrder    requestorder   );
1177 
1178 	constructor() public {}
1179 
1180 	function broadcastAppOrder       (IexecODBLibOrders.AppOrder        memory _apporder       ) public { emit BroadcastAppOrder       (_apporder       ); }
1181 	function broadcastDatasetOrder   (IexecODBLibOrders.DatasetOrder    memory _datasetorder   ) public { emit BroadcastDatasetOrder   (_datasetorder   ); }
1182 	function broadcastWorkerpoolOrder(IexecODBLibOrders.WorkerpoolOrder memory _workerpoolorder) public { emit BroadcastWorkerpoolOrder(_workerpoolorder); }
1183 	function broadcastRequestOrder   (IexecODBLibOrders.RequestOrder    memory _requestorder   ) public { emit BroadcastRequestOrder   (_requestorder   ); }
1184 }
1185 
1186 
1187 contract SignatureVerifier
1188 {
1189 	function addrToKey(address _addr)
1190 	internal pure returns (bytes32)
1191 	{
1192 		return bytes32(uint256(_addr));
1193 	}
1194 
1195 	function checkIdentity(address _identity, address _candidate, uint256 _purpose)
1196 	internal view returns (bool valid)
1197 	{
1198 		return _identity == _candidate || IERC734(_identity).keyHasPurpose(addrToKey(_candidate), _purpose); // Simple address || ERC 734 identity contract
1199 	}
1200 
1201 	// internal ?
1202 	function verifySignature(
1203 		address      _identity,
1204 		bytes32      _hash,
1205 		bytes memory _signature)
1206 	public view returns (bool)
1207 	{
1208 		return recoverCheck(_identity, _hash, _signature) || IERC1271(_identity).isValidSignature(_hash, _signature);
1209 	}
1210 
1211 	// recoverCheck does not revert if signature has invalid format
1212 	function recoverCheck(address candidate, bytes32 hash, bytes memory sign)
1213 	internal pure returns (bool)
1214 	{
1215 		bytes32 r;
1216 		bytes32 s;
1217 		uint8   v;
1218 		if (sign.length != 65) return false;
1219 		assembly
1220 		{
1221 			r :=         mload(add(sign, 0x20))
1222 			s :=         mload(add(sign, 0x40))
1223 			v := byte(0, mload(add(sign, 0x60)))
1224 		}
1225 		if (v < 27) v += 27;
1226 		if (v != 27 && v != 28) return false;
1227 		return candidate == ecrecover(hash, v, r, s);
1228 	}
1229 
1230 	function toEthSignedMessageHash(bytes32 hash)
1231 	internal pure returns (bytes32)
1232 	{
1233 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1234 	}
1235 }
1236 
1237 interface IexecHubInterface
1238 {
1239 	function checkResources(address, address, address)
1240 	external view returns (bool);
1241 }
1242 
1243 
1244 contract IexecHubAccessor
1245 {
1246 	IexecHubInterface public iexechub;
1247 
1248 	modifier onlyIexecHub()
1249 	{
1250 		require(msg.sender == address(iexechub));
1251 		_;
1252 	}
1253 
1254 	constructor(address _iexechub)
1255 	public
1256 	{
1257 		require(_iexechub != address(0));
1258 		iexechub = IexecHubInterface(_iexechub);
1259 	}
1260 
1261 }
1262 
1263 contract IexecClerkABILegacy
1264 {
1265 	uint256 public constant POOL_STAKE_RATIO = 30;
1266 	uint256 public constant KITTY_RATIO      = 10;
1267 	uint256 public constant KITTY_MIN        = 1000000000; // TODO: 1RLC ?
1268 
1269 	bytes32 public /* immutable */ EIP712DOMAIN_SEPARATOR;
1270 
1271 	mapping(bytes32 => bytes32[]) public m_requestdeals;
1272 	mapping(bytes32 => uint256  ) public m_consumed;
1273 	mapping(bytes32 => bool     ) public m_presigned;
1274 
1275 	event OrdersMatched        (bytes32 dealid, bytes32 appHash, bytes32 datasetHash, bytes32 workerpoolHash, bytes32 requestHash, uint256 volume);
1276 	event ClosedAppOrder       (bytes32 appHash);
1277 	event ClosedDatasetOrder   (bytes32 datasetHash);
1278 	event ClosedWorkerpoolOrder(bytes32 workerpoolHash);
1279 	event ClosedRequestOrder   (bytes32 requestHash);
1280 	event SchedulerNotice      (address indexed workerpool, bytes32 dealid);
1281 
1282 	function viewRequestDeals(bytes32 _id)
1283 	external view returns (bytes32[] memory);
1284 
1285 	function viewConsumed(bytes32 _id)
1286 	external view returns (uint256);
1287 
1288 	function lockContribution(bytes32 _dealid, address _worker)
1289 	external;
1290 
1291 	function unlockContribution(bytes32 _dealid, address _worker)
1292 	external;
1293 
1294 	function unlockAndRewardForContribution(bytes32 _dealid, address _worker, uint256 _amount, bytes32 _taskid)
1295 	external;
1296 
1297 	function seizeContribution(bytes32 _dealid, address _worker, bytes32 _taskid)
1298 	external;
1299 
1300 	function rewardForScheduling(bytes32 _dealid, uint256 _amount, bytes32 _taskid)
1301 	external;
1302 
1303 	function successWork(bytes32 _dealid, bytes32 _taskid)
1304 	external;
1305 
1306 	function failedWork(bytes32 _dealid, bytes32 _taskid)
1307 	external;
1308 
1309 
1310 
1311 
1312 	function viewDealABILegacy_pt1(bytes32 _id)
1313 	external view returns
1314 	( address
1315 	, address
1316 	, uint256
1317 	, address
1318 	, address
1319 	, uint256
1320 	, address
1321 	, address
1322 	, uint256
1323 	);
1324 
1325 	function viewDealABILegacy_pt2(bytes32 _id)
1326 	external view returns
1327 	( uint256
1328 	, bytes32
1329 	, address
1330 	, address
1331 	, address
1332 	, string memory
1333 	);
1334 
1335 	function viewConfigABILegacy(bytes32 _id)
1336 	external view returns
1337 	( uint256
1338 	, uint256
1339 	, uint256
1340 	, uint256
1341 	, uint256
1342 	, uint256
1343 	);
1344 
1345 	function viewAccountABILegacy(address _user)
1346 	external view returns (uint256, uint256);
1347 }
1348 
1349 
1350 
1351 /**
1352  * /!\ TEMPORARY LEGACY /!\
1353  */
1354 
1355 contract IexecClerk is Escrow, Relay, IexecHubAccessor, SignatureVerifier, IexecClerkABILegacy
1356 {
1357 	using SafeMath          for uint256;
1358 	using IexecODBLibOrders for bytes32;
1359 	using IexecODBLibOrders for IexecODBLibOrders.EIP712Domain;
1360 	using IexecODBLibOrders for IexecODBLibOrders.AppOrder;
1361 	using IexecODBLibOrders for IexecODBLibOrders.DatasetOrder;
1362 	using IexecODBLibOrders for IexecODBLibOrders.WorkerpoolOrder;
1363 	using IexecODBLibOrders for IexecODBLibOrders.RequestOrder;
1364 
1365 	/***************************************************************************
1366 	 *                                Constants                                *
1367 	 ***************************************************************************/
1368 	uint256 public constant WORKERPOOL_STAKE_RATIO = 30;
1369 	uint256 public constant KITTY_RATIO            = 10;
1370 	uint256 public constant KITTY_MIN              = 1000000000; // TODO: 1RLC ?
1371 
1372 	// For authorizations
1373 	uint256 public constant GROUPMEMBER_PURPOSE    = 4;
1374 
1375 	/***************************************************************************
1376 	 *                            EIP712 signature                             *
1377 	 ***************************************************************************/
1378 	bytes32 public /* immutable */ EIP712DOMAIN_SEPARATOR;
1379 
1380 	/***************************************************************************
1381 	 *                               Clerk data                                *
1382 	 ***************************************************************************/
1383 	mapping(bytes32 => bytes32[]           ) m_requestdeals;
1384 	mapping(bytes32 => IexecODBLibCore.Deal) m_deals;
1385 	mapping(bytes32 => uint256             ) m_consumed;
1386 	mapping(bytes32 => bool                ) m_presigned;
1387 
1388 	/***************************************************************************
1389 	 *                                 Events                                  *
1390 	 ***************************************************************************/
1391 	event OrdersMatched        (bytes32 dealid, bytes32 appHash, bytes32 datasetHash, bytes32 workerpoolHash, bytes32 requestHash, uint256 volume);
1392 	event ClosedAppOrder       (bytes32 appHash);
1393 	event ClosedDatasetOrder   (bytes32 datasetHash);
1394 	event ClosedWorkerpoolOrder(bytes32 workerpoolHash);
1395 	event ClosedRequestOrder   (bytes32 requestHash);
1396 	event SchedulerNotice      (address indexed workerpool, bytes32 dealid);
1397 
1398 	/***************************************************************************
1399 	 *                               Constructor                               *
1400 	 ***************************************************************************/
1401 	constructor(
1402 		address _token,
1403 		address _iexechub,
1404 		uint256 _chainid)
1405 	public
1406 	Escrow(_token)
1407 	IexecHubAccessor(_iexechub)
1408 	{
1409 		EIP712DOMAIN_SEPARATOR = IexecODBLibOrders.EIP712Domain({
1410 			name:              "iExecODB"
1411 		, version:           "3.0-alpha"
1412 		, chainId:           _chainid
1413 		, verifyingContract: address(this)
1414 		}).hash();
1415 	}
1416 
1417 	/***************************************************************************
1418 	 *                                Accessor                                 *
1419 	 ***************************************************************************/
1420 	function viewRequestDeals(bytes32 _id)
1421 	external view returns (bytes32[] memory requestdeals)
1422 	{
1423 		return m_requestdeals[_id];
1424 	}
1425 
1426 	function viewDeal(bytes32 _id)
1427 	external view returns (IexecODBLibCore.Deal memory deal)
1428 	{
1429 		return m_deals[_id];
1430 	}
1431 
1432 	function viewConsumed(bytes32 _id)
1433 	external view returns (uint256 consumed)
1434 	{
1435 		return m_consumed[_id];
1436 	}
1437 
1438 	function viewPresigned(bytes32 _id)
1439 	external view returns (bool presigned)
1440 	{
1441 		return m_presigned[_id];
1442 	}
1443 
1444 	/***************************************************************************
1445 	 *                            pre-signing tools                            *
1446 	 ***************************************************************************/
1447 	// should be external
1448 	function signAppOrder(IexecODBLibOrders.AppOrder memory _apporder)
1449 	public returns (bool)
1450 	{
1451 		require(msg.sender == App(_apporder.app).owner());
1452 		m_presigned[_apporder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR)] = true;
1453 		return true;
1454 	}
1455 
1456 	// should be external
1457 	function signDatasetOrder(IexecODBLibOrders.DatasetOrder memory _datasetorder)
1458 	public returns (bool)
1459 	{
1460 		require(msg.sender == Dataset(_datasetorder.dataset).owner());
1461 		m_presigned[_datasetorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR)] = true;
1462 		return true;
1463 	}
1464 
1465 	// should be external
1466 	function signWorkerpoolOrder(IexecODBLibOrders.WorkerpoolOrder memory _workerpoolorder)
1467 	public returns (bool)
1468 	{
1469 		require(msg.sender == Workerpool(_workerpoolorder.workerpool).owner());
1470 		m_presigned[_workerpoolorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR)] = true;
1471 		return true;
1472 	}
1473 
1474 	// should be external
1475 	function signRequestOrder(IexecODBLibOrders.RequestOrder memory _requestorder)
1476 	public returns (bool)
1477 	{
1478 		require(msg.sender == _requestorder.requester);
1479 		m_presigned[_requestorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR)] = true;
1480 		return true;
1481 	}
1482 
1483 	/***************************************************************************
1484 	 *                              Clerk methods                              *
1485 	 ***************************************************************************/
1486 	struct Identities
1487 	{
1488 		bytes32 appHash;
1489 		address appOwner;
1490 		bytes32 datasetHash;
1491 		address datasetOwner;
1492 		bytes32 workerpoolHash;
1493 		address workerpoolOwner;
1494 		bytes32 requestHash;
1495 		bool    hasDataset;
1496 	}
1497 
1498 	// should be external
1499 	function matchOrders(
1500 		IexecODBLibOrders.AppOrder        memory _apporder,
1501 		IexecODBLibOrders.DatasetOrder    memory _datasetorder,
1502 		IexecODBLibOrders.WorkerpoolOrder memory _workerpoolorder,
1503 		IexecODBLibOrders.RequestOrder    memory _requestorder)
1504 	public returns (bytes32)
1505 	{
1506 		/**
1507 		 * Check orders compatibility
1508 		 */
1509 
1510 		// computation environment & allowed enough funds
1511 		require(_requestorder.category           == _workerpoolorder.category       );
1512 		require(_requestorder.trust              <= _workerpoolorder.trust          );
1513 		require(_requestorder.appmaxprice        >= _apporder.appprice              );
1514 		require(_requestorder.datasetmaxprice    >= _datasetorder.datasetprice      );
1515 		require(_requestorder.workerpoolmaxprice >= _workerpoolorder.workerpoolprice);
1516 		require((_apporder.tag | _datasetorder.tag | _requestorder.tag) & ~_workerpoolorder.tag == 0x0);
1517 
1518 		// Check matching and restrictions
1519 		require(_requestorder.app     == _apporder.app        );
1520 		require(_requestorder.dataset == _datasetorder.dataset);
1521 		require(_requestorder.workerpool           == address(0) || checkIdentity(_requestorder.workerpool,           _workerpoolorder.workerpool, GROUPMEMBER_PURPOSE)); // requestorder.workerpool is a restriction
1522 		require(_apporder.datasetrestrict          == address(0) || checkIdentity(_apporder.datasetrestrict,          _datasetorder.dataset,       GROUPMEMBER_PURPOSE));
1523 		require(_apporder.workerpoolrestrict       == address(0) || checkIdentity(_apporder.workerpoolrestrict,       _workerpoolorder.workerpool, GROUPMEMBER_PURPOSE));
1524 		require(_apporder.requesterrestrict        == address(0) || checkIdentity(_apporder.requesterrestrict,        _requestorder.requester,     GROUPMEMBER_PURPOSE));
1525 		require(_datasetorder.apprestrict          == address(0) || checkIdentity(_datasetorder.apprestrict,          _apporder.app,               GROUPMEMBER_PURPOSE));
1526 		require(_datasetorder.workerpoolrestrict   == address(0) || checkIdentity(_datasetorder.workerpoolrestrict,   _workerpoolorder.workerpool, GROUPMEMBER_PURPOSE));
1527 		require(_datasetorder.requesterrestrict    == address(0) || checkIdentity(_datasetorder.requesterrestrict,    _requestorder.requester,     GROUPMEMBER_PURPOSE));
1528 		require(_workerpoolorder.apprestrict       == address(0) || checkIdentity(_workerpoolorder.apprestrict,       _apporder.app,               GROUPMEMBER_PURPOSE));
1529 		require(_workerpoolorder.datasetrestrict   == address(0) || checkIdentity(_workerpoolorder.datasetrestrict,   _datasetorder.dataset,       GROUPMEMBER_PURPOSE));
1530 		require(_workerpoolorder.requesterrestrict == address(0) || checkIdentity(_workerpoolorder.requesterrestrict, _requestorder.requester,     GROUPMEMBER_PURPOSE));
1531 
1532 		require(iexechub.checkResources(_apporder.app, _datasetorder.dataset, _workerpoolorder.workerpool));
1533 
1534 		/**
1535 		 * Check orders authenticity
1536 		 */
1537 		Identities memory ids;
1538 		ids.hasDataset = _datasetorder.dataset != address(0);
1539 
1540 		// app
1541 		ids.appHash  = _apporder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1542 		ids.appOwner = App(_apporder.app).owner();
1543 		require(m_presigned[ids.appHash] || verifySignature(ids.appOwner, ids.appHash, _apporder.sign));
1544 
1545 		// dataset
1546 		if (ids.hasDataset) // only check if dataset is enabled
1547 		{
1548 			ids.datasetHash  = _datasetorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1549 			ids.datasetOwner = Dataset(_datasetorder.dataset).owner();
1550 			require(m_presigned[ids.datasetHash] || verifySignature(ids.datasetOwner, ids.datasetHash, _datasetorder.sign));
1551 		}
1552 
1553 		// workerpool
1554 		ids.workerpoolHash  = _workerpoolorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1555 		ids.workerpoolOwner = Workerpool(_workerpoolorder.workerpool).owner();
1556 		require(m_presigned[ids.workerpoolHash] || verifySignature(ids.workerpoolOwner, ids.workerpoolHash, _workerpoolorder.sign));
1557 
1558 		// request
1559 		ids.requestHash = _requestorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1560 		require(m_presigned[ids.requestHash] || verifySignature(_requestorder.requester, ids.requestHash, _requestorder.sign));
1561 
1562 		/**
1563 		 * Check availability
1564 		 */
1565 		uint256 volume;
1566 		volume =                             _apporder.volume.sub       (m_consumed[ids.appHash       ]);
1567 		volume = ids.hasDataset ? volume.min(_datasetorder.volume.sub   (m_consumed[ids.datasetHash   ])) : volume;
1568 		volume =                  volume.min(_workerpoolorder.volume.sub(m_consumed[ids.workerpoolHash]));
1569 		volume =                  volume.min(_requestorder.volume.sub   (m_consumed[ids.requestHash   ]));
1570 		require(volume > 0);
1571 
1572 		/**
1573 		 * Record
1574 		 */
1575 		bytes32 dealid = keccak256(abi.encodePacked(
1576 			ids.requestHash,            // requestHash
1577 			m_consumed[ids.requestHash] // idx of first subtask
1578 		));
1579 
1580 		IexecODBLibCore.Deal storage deal = m_deals[dealid];
1581 		deal.app.pointer          = _apporder.app;
1582 		deal.app.owner            = ids.appOwner;
1583 		deal.app.price            = _apporder.appprice;
1584 		deal.dataset.owner        = ids.datasetOwner;
1585 		deal.dataset.pointer      = _datasetorder.dataset;
1586 		deal.dataset.price        = ids.hasDataset ? _datasetorder.datasetprice : 0;
1587 		deal.workerpool.pointer   = _workerpoolorder.workerpool;
1588 		deal.workerpool.owner     = ids.workerpoolOwner;
1589 		deal.workerpool.price     = _workerpoolorder.workerpoolprice;
1590 		deal.trust                = _requestorder.trust.max(1);
1591 		deal.category             = _requestorder.category;
1592 		deal.tag                  = _apporder.tag | _datasetorder.tag | _requestorder.tag;
1593 		deal.requester            = _requestorder.requester;
1594 		deal.beneficiary          = _requestorder.beneficiary;
1595 		deal.callback             = _requestorder.callback;
1596 		deal.params               = _requestorder.params;
1597 		deal.startTime            = now;
1598 		deal.botFirst             = m_consumed[ids.requestHash];
1599 		deal.botSize              = volume;
1600 		deal.workerStake          = _workerpoolorder.workerpoolprice.percentage(Workerpool(_workerpoolorder.workerpool).m_workerStakeRatioPolicy());
1601 		deal.schedulerRewardRatio = Workerpool(_workerpoolorder.workerpool).m_schedulerRewardRatioPolicy();
1602 
1603 		m_requestdeals[ids.requestHash].push(dealid);
1604 
1605 		/**
1606 		 * Update consumed
1607 		 */
1608 		m_consumed[ids.appHash       ] = m_consumed[ids.appHash       ].add(                 volume    );
1609 		m_consumed[ids.datasetHash   ] = m_consumed[ids.datasetHash   ].add(ids.hasDataset ? volume : 0);
1610 		m_consumed[ids.workerpoolHash] = m_consumed[ids.workerpoolHash].add(                 volume    );
1611 		m_consumed[ids.requestHash   ] = m_consumed[ids.requestHash   ].add(                 volume    );
1612 
1613 		/**
1614 		 * Lock
1615 		 */
1616 		lock(
1617 			deal.requester,
1618 			deal.app.price
1619 			.add(deal.dataset.price)
1620 			.add(deal.workerpool.price)
1621 			.mul(volume)
1622 		);
1623 		lock(
1624 			deal.workerpool.owner,
1625 			deal.workerpool.price
1626 			.percentage(WORKERPOOL_STAKE_RATIO) // ORDER IS IMPORTANT HERE!
1627 			.mul(volume)                        // ORDER IS IMPORTANT HERE!
1628 		);
1629 
1630 		/**
1631 		 * Advertize deal
1632 		 */
1633 		emit SchedulerNotice(deal.workerpool.pointer, dealid);
1634 
1635 		/**
1636 		 * Advertize consumption
1637 		 */
1638 		emit OrdersMatched(
1639 			dealid,
1640 			ids.appHash,
1641 			ids.datasetHash,
1642 			ids.workerpoolHash,
1643 			ids.requestHash,
1644 			volume
1645 		);
1646 
1647 		return dealid;
1648 	}
1649 
1650 	// should be external
1651 	function cancelAppOrder(IexecODBLibOrders.AppOrder memory _apporder)
1652 	public returns (bool)
1653 	{
1654 		bytes32 dapporderHash = _apporder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1655 		require(msg.sender == App(_apporder.app).owner());
1656 		m_consumed[dapporderHash] = _apporder.volume;
1657 		emit ClosedAppOrder(dapporderHash);
1658 		return true;
1659 	}
1660 
1661 	// should be external
1662 	function cancelDatasetOrder(IexecODBLibOrders.DatasetOrder memory _datasetorder)
1663 	public returns (bool)
1664 	{
1665 		bytes32 dataorderHash = _datasetorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1666 		require(msg.sender == Dataset(_datasetorder.dataset).owner());
1667 		m_consumed[dataorderHash] = _datasetorder.volume;
1668 		emit ClosedDatasetOrder(dataorderHash);
1669 		return true;
1670 	}
1671 
1672 	// should be external
1673 	function cancelWorkerpoolOrder(IexecODBLibOrders.WorkerpoolOrder memory _workerpoolorder)
1674 	public returns (bool)
1675 	{
1676 		bytes32 poolorderHash = _workerpoolorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1677 		require(msg.sender == Workerpool(_workerpoolorder.workerpool).owner());
1678 		m_consumed[poolorderHash] = _workerpoolorder.volume;
1679 		emit ClosedWorkerpoolOrder(poolorderHash);
1680 		return true;
1681 	}
1682 
1683 	// should be external
1684 	function cancelRequestOrder(IexecODBLibOrders.RequestOrder memory _requestorder)
1685 	public returns (bool)
1686 	{
1687 		bytes32 requestorderHash = _requestorder.hash().toEthTypedStructHash(EIP712DOMAIN_SEPARATOR);
1688 		require(msg.sender == _requestorder.requester);
1689 		m_consumed[requestorderHash] = _requestorder.volume;
1690 		emit ClosedRequestOrder(requestorderHash);
1691 		return true;
1692 	}
1693 
1694 	/***************************************************************************
1695 	 *                    Escrow overhead for contribution                     *
1696 	 ***************************************************************************/
1697 	function lockContribution(bytes32 _dealid, address _worker)
1698 	external onlyIexecHub
1699 	{
1700 		lock(_worker, m_deals[_dealid].workerStake);
1701 	}
1702 
1703 	function unlockContribution(bytes32 _dealid, address _worker)
1704 	external onlyIexecHub
1705 	{
1706 		unlock(_worker, m_deals[_dealid].workerStake);
1707 	}
1708 
1709 	function unlockAndRewardForContribution(bytes32 _dealid, address _worker, uint256 _amount, bytes32 _taskid)
1710 	external onlyIexecHub
1711 	{
1712 		unlock(_worker, m_deals[_dealid].workerStake);
1713 		reward(_worker, _amount, _taskid);
1714 	}
1715 
1716 	function seizeContribution(bytes32 _dealid, address _worker, bytes32 _taskid)
1717 	external onlyIexecHub
1718 	{
1719 		seize(_worker, m_deals[_dealid].workerStake, _taskid);
1720 	}
1721 
1722 	function rewardForScheduling(bytes32 _dealid, uint256 _amount, bytes32 _taskid)
1723 	external onlyIexecHub
1724 	{
1725 		reward(m_deals[_dealid].workerpool.owner, _amount, _taskid);
1726 	}
1727 
1728 	function successWork(bytes32 _dealid, bytes32 _taskid)
1729 	external onlyIexecHub
1730 	{
1731 		IexecODBLibCore.Deal storage deal = m_deals[_dealid];
1732 
1733 		uint256 requesterstake = deal.app.price
1734 		                         .add(deal.dataset.price)
1735 		                         .add(deal.workerpool.price);
1736 		uint256 poolstake = deal.workerpool.price
1737 		                    .percentage(WORKERPOOL_STAKE_RATIO);
1738 
1739 		// seize requester funds
1740 		seize(deal.requester, requesterstake, _taskid);
1741 		// dapp reward
1742 		if (deal.app.price > 0)
1743 		{
1744 			reward(deal.app.owner, deal.app.price, _taskid);
1745 		}
1746 		// data reward
1747 		if (deal.dataset.price > 0 && deal.dataset.pointer != address(0))
1748 		{
1749 			reward(deal.dataset.owner, deal.dataset.price, _taskid);
1750 		}
1751 		// unlock pool stake
1752 		unlock(deal.workerpool.owner, poolstake);
1753 		// pool reward performed by consensus manager
1754 
1755 		/**
1756 		 * Retrieve part of the kitty
1757 		 * TODO: remove / keep ?
1758 		 */
1759 		uint256 kitty = m_accounts[address(0)].locked;
1760 		if (kitty > 0)
1761 		{
1762 			kitty = kitty
1763 			        .percentage(KITTY_RATIO) // fraction
1764 			        .max(KITTY_MIN)          // at least this
1765 			        .min(kitty);             // but not more than available
1766 			seize (address(0),            kitty, _taskid);
1767 			reward(deal.workerpool.owner, kitty, _taskid);
1768 		}
1769 	}
1770 
1771 	function failedWork(bytes32 _dealid, bytes32 _taskid)
1772 	external onlyIexecHub
1773 	{
1774 		IexecODBLibCore.Deal storage deal = m_deals[_dealid];
1775 
1776 		uint256 requesterstake = deal.app.price
1777 		                         .add(deal.dataset.price)
1778 		                         .add(deal.workerpool.price);
1779 		uint256 poolstake = deal.workerpool.price
1780 		                    .percentage(WORKERPOOL_STAKE_RATIO);
1781 
1782 		unlock(deal.requester,        requesterstake    );
1783 		seize (deal.workerpool.owner, poolstake, _taskid);
1784 		reward(address(0),            poolstake, _taskid); // → Kitty / Burn
1785 		lock  (address(0),            poolstake         ); // → Kitty / Burn
1786 	}
1787 
1788 
1789 
1790 
1791 
1792 
1793 
1794 
1795 
1796 
1797 
1798 
1799 
1800 
1801 
1802 
1803 
1804 
1805 	/**
1806 	 * /!\ TEMPORARY LEGACY /!\
1807 	 */
1808 
1809 	function viewDealABILegacy_pt1(bytes32 _id)
1810 	external view returns
1811 	( address
1812 	, address
1813 	, uint256
1814 	, address
1815 	, address
1816 	, uint256
1817 	, address
1818 	, address
1819 	, uint256
1820 	)
1821 	{
1822 		IexecODBLibCore.Deal memory deal = m_deals[_id];
1823 		return (
1824 			deal.app.pointer,
1825 			deal.app.owner,
1826 			deal.app.price,
1827 			deal.dataset.pointer,
1828 			deal.dataset.owner,
1829 			deal.dataset.price,
1830 			deal.workerpool.pointer,
1831 			deal.workerpool.owner,
1832 			deal.workerpool.price
1833 		);
1834 	}
1835 
1836 	function viewDealABILegacy_pt2(bytes32 _id)
1837 	external view returns
1838 	( uint256
1839 	, bytes32
1840 	, address
1841 	, address
1842 	, address
1843 	, string memory
1844 	)
1845 	{
1846 		IexecODBLibCore.Deal memory deal = m_deals[_id];
1847 		return (
1848 			deal.trust,
1849 			deal.tag,
1850 			deal.requester,
1851 			deal.beneficiary,
1852 			deal.callback,
1853 			deal.params
1854 		);
1855 	}
1856 
1857 	function viewConfigABILegacy(bytes32 _id)
1858 	external view returns
1859 	( uint256
1860 	, uint256
1861 	, uint256
1862 	, uint256
1863 	, uint256
1864 	, uint256
1865 	)
1866 	{
1867 		IexecODBLibCore.Deal memory deal = m_deals[_id];
1868 		return (
1869 			deal.category,
1870 			deal.startTime,
1871 			deal.botFirst,
1872 			deal.botSize,
1873 			deal.workerStake,
1874 			deal.schedulerRewardRatio
1875 		);
1876 	}
1877 
1878 	function viewAccountABILegacy(address _user)
1879 	external view returns (uint256, uint256)
1880 	{
1881 		IexecODBLibCore.Account memory account = m_accounts[_user];
1882 		return ( account.stake, account.locked );
1883 	}
1884 }
1885 
1886 
1887 
1888 contract IexecHubABILegacy
1889 {
1890 	uint256 public constant CONSENSUS_DURATION_RATIO = 10;
1891 	uint256 public constant REVEAL_DURATION_RATIO    = 2;
1892 
1893 	IexecClerk   public iexecclerk;
1894 	RegistryBase public appregistry;
1895 	RegistryBase public datasetregistry;
1896 	RegistryBase public workerpoolregistry;
1897 
1898 	event TaskInitialize(bytes32 indexed taskid, address indexed workerpool               );
1899 	event TaskContribute(bytes32 indexed taskid, address indexed worker, bytes32 hash     );
1900 	event TaskConsensus (bytes32 indexed taskid,                         bytes32 consensus);
1901 	event TaskReveal    (bytes32 indexed taskid, address indexed worker, bytes32 digest   );
1902 	event TaskReopen    (bytes32 indexed taskid                                           );
1903 	event TaskFinalize  (bytes32 indexed taskid,                         bytes   results  );
1904 	event TaskClaimed   (bytes32 indexed taskid                                           );
1905 
1906 	event AccurateContribution(address indexed worker, bytes32 indexed taskid);
1907 	event FaultyContribution  (address indexed worker, bytes32 indexed taskid);
1908 
1909 	function attachContracts(
1910 		address _iexecclerkAddress,
1911 		address _appregistryAddress,
1912 		address _datasetregistryAddress,
1913 		address _workerpoolregistryAddress)
1914 	external;
1915 
1916 	function viewScore(address _worker)
1917 	external view returns (uint256);
1918 
1919 	function checkResources(address aap, address dataset, address workerpool)
1920 	external view returns (bool);
1921 
1922 	function resultFor(bytes32 id)
1923 	external view returns (bytes memory);
1924 
1925 	function initialize(
1926 		bytes32 _dealid,
1927 		uint256 idx)
1928 	public returns (bytes32);
1929 
1930 	function contribute(
1931 		bytes32      _taskid,
1932 		bytes32      _resultHash,
1933 		bytes32      _resultSeal,
1934 		address      _enclaveChallenge,
1935 		bytes memory _enclaveSign,
1936 		bytes memory _workerpoolSign)
1937 	public;
1938 
1939 	function reveal(
1940 		bytes32 _taskid,
1941 		bytes32 _resultDigest)
1942 	external;
1943 
1944 	function reopen(
1945 		bytes32 _taskid)
1946 	external;
1947 
1948 	function finalize(
1949 		bytes32 _taskid,
1950 		bytes calldata  _results)
1951 	external;
1952 
1953 	function claim(
1954 		bytes32 _taskid)
1955 	public;
1956 
1957 	function initializeArray(
1958 		bytes32[] calldata _dealid,
1959 		uint256[] calldata _idx)
1960 	external returns (bool);
1961 
1962 	function claimArray(
1963 		bytes32[] calldata _taskid)
1964 	external returns (bool);
1965 
1966 	function initializeAndClaimArray(
1967 		bytes32[] calldata _dealid,
1968 		uint256[] calldata _idx)
1969 	external returns (bool);
1970 
1971 	function viewTaskABILegacy(bytes32 _taskid)
1972 	external view returns
1973 	( IexecODBLibCore.TaskStatusEnum
1974 	, bytes32
1975 	, uint256
1976 	, uint256
1977 	, uint256
1978 	, uint256
1979 	, uint256
1980 	, bytes32
1981 	, uint256
1982 	, uint256
1983 	, address[] memory
1984 	, bytes     memory
1985 	);
1986 
1987 	function viewContributionABILegacy(bytes32 _taskid, address _worker)
1988 	external view returns
1989 	( IexecODBLibCore.ContributionStatusEnum
1990 	, bytes32
1991 	, bytes32
1992 	, address
1993 	);
1994 
1995 	function viewCategoryABILegacy(uint256 _catid)
1996 	external view returns (string memory, string memory, uint256);
1997 }
1998 
1999 
2000 
2001 /**
2002  * /!\ TEMPORARY LEGACY /!\
2003  */
2004 
2005 contract IexecHub is CategoryManager, IOracle, SignatureVerifier, IexecHubABILegacy
2006 {
2007 	using SafeMath for uint256;
2008 
2009 	/***************************************************************************
2010 	 *                                Constants                                *
2011 	 ***************************************************************************/
2012 	uint256 public constant CONTRIBUTION_DEADLINE_RATIO = 7;
2013 	uint256 public constant       REVEAL_DEADLINE_RATIO = 2;
2014 	uint256 public constant        FINAL_DEADLINE_RATIO = 10;
2015 
2016 	/***************************************************************************
2017 	 *                             Other contracts                             *
2018 	 ***************************************************************************/
2019 	IexecClerk   public iexecclerk;
2020 	RegistryBase public appregistry;
2021 	RegistryBase public datasetregistry;
2022 	RegistryBase public workerpoolregistry;
2023 
2024 	/***************************************************************************
2025 	 *                          Consensuses & Workers                          *
2026 	 ***************************************************************************/
2027 	mapping(bytes32 =>                    IexecODBLibCore.Task         ) m_tasks;
2028 	mapping(bytes32 => mapping(address => IexecODBLibCore.Contribution)) m_contributions;
2029 	mapping(address =>                    uint256                      ) m_workerScores;
2030 
2031 	mapping(bytes32 => mapping(address => uint256                     )) m_logweight;
2032 	mapping(bytes32 => mapping(bytes32 => uint256                     )) m_groupweight;
2033 	mapping(bytes32 =>                    uint256                      ) m_totalweight;
2034 
2035 	/***************************************************************************
2036 	 *                                 Events                                  *
2037 	 ***************************************************************************/
2038 	event TaskInitialize(bytes32 indexed taskid, address indexed workerpool               );
2039 	event TaskContribute(bytes32 indexed taskid, address indexed worker, bytes32 hash     );
2040 	event TaskConsensus (bytes32 indexed taskid,                         bytes32 consensus);
2041 	event TaskReveal    (bytes32 indexed taskid, address indexed worker, bytes32 digest   );
2042 	event TaskReopen    (bytes32 indexed taskid                                           );
2043 	event TaskFinalize  (bytes32 indexed taskid,                         bytes results    );
2044 	event TaskClaimed   (bytes32 indexed taskid                                           );
2045 
2046 	event AccurateContribution(address indexed worker, bytes32 indexed taskid);
2047 	event FaultyContribution  (address indexed worker, bytes32 indexed taskid);
2048 
2049 	/***************************************************************************
2050 	 *                                Modifiers                                *
2051 	 ***************************************************************************/
2052 	modifier onlyScheduler(bytes32 _taskid)
2053 	{
2054 		require(msg.sender == iexecclerk.viewDeal(m_tasks[_taskid].dealid).workerpool.owner);
2055 		_;
2056 	}
2057 
2058 	/***************************************************************************
2059 	 *                               Constructor                               *
2060 	 ***************************************************************************/
2061 	constructor()
2062 	public
2063 	{
2064 	}
2065 
2066 	function attachContracts(
2067 		address _iexecclerkAddress,
2068 		address _appregistryAddress,
2069 		address _datasetregistryAddress,
2070 		address _workerpoolregistryAddress)
2071 	external onlyOwner
2072 	{
2073 		require(address(iexecclerk) == address(0));
2074 		iexecclerk         = IexecClerk  (_iexecclerkAddress  );
2075 		appregistry        = RegistryBase(_appregistryAddress);
2076 		datasetregistry    = RegistryBase(_datasetregistryAddress);
2077 		workerpoolregistry = RegistryBase(_workerpoolregistryAddress);
2078 	}
2079 
2080 	/***************************************************************************
2081 	 *                                Accessors                                *
2082 	 ***************************************************************************/
2083 	function viewTask(bytes32 _taskid)
2084 	external view returns (IexecODBLibCore.Task memory)
2085 	{
2086 		return m_tasks[_taskid];
2087 	}
2088 
2089 	function viewContribution(bytes32 _taskid, address _worker)
2090 	external view returns (IexecODBLibCore.Contribution memory)
2091 	{
2092 		return m_contributions[_taskid][_worker];
2093 	}
2094 
2095 	function viewScore(address _worker)
2096 	external view returns (uint256)
2097 	{
2098 		return m_workerScores[_worker];
2099 	}
2100 
2101 	function checkResources(address app, address dataset, address workerpool)
2102 	external view returns (bool)
2103 	{
2104 		require(                         appregistry.isRegistered(app));
2105 		require(dataset == address(0) || datasetregistry.isRegistered(dataset));
2106 		require(                         workerpoolregistry.isRegistered(workerpool));
2107 		return true;
2108 	}
2109 
2110 	/***************************************************************************
2111 	 *                         EIP 1154 PULL INTERFACE                         *
2112 	 ***************************************************************************/
2113 	function resultFor(bytes32 id)
2114 	external view returns (bytes memory)
2115 	{
2116 		IexecODBLibCore.Task storage task = m_tasks[id];
2117 		require(task.status == IexecODBLibCore.TaskStatusEnum.COMPLETED);
2118 		return task.results;
2119 	}
2120 
2121 	/***************************************************************************
2122 	 *                            Consensus methods                            *
2123 	 ***************************************************************************/
2124 	function initialize(bytes32 _dealid, uint256 idx)
2125 	public returns (bytes32)
2126 	{
2127 		IexecODBLibCore.Deal memory deal = iexecclerk.viewDeal(_dealid);
2128 
2129 		require(idx >= deal.botFirst                  );
2130 		require(idx <  deal.botFirst.add(deal.botSize));
2131 
2132 		bytes32 taskid  = keccak256(abi.encodePacked(_dealid, idx));
2133 		IexecODBLibCore.Task storage task = m_tasks[taskid];
2134 		require(task.status == IexecODBLibCore.TaskStatusEnum.UNSET);
2135 
2136 		task.status               = IexecODBLibCore.TaskStatusEnum.ACTIVE;
2137 		task.dealid               = _dealid;
2138 		task.idx                  = idx;
2139 		task.timeref              = m_categories[deal.category].workClockTimeRef;
2140 		task.contributionDeadline = task.timeref.mul(CONTRIBUTION_DEADLINE_RATIO).add(deal.startTime);
2141 		task.finalDeadline        = task.timeref.mul(       FINAL_DEADLINE_RATIO).add(deal.startTime);
2142 
2143 		// setup denominator
2144 		m_totalweight[taskid] = 1;
2145 
2146 		emit TaskInitialize(taskid, iexecclerk.viewDeal(_dealid).workerpool.pointer);
2147 
2148 		return taskid;
2149 	}
2150 
2151 	// TODO: make external w/ calldata
2152 	function contribute(
2153 		bytes32      _taskid,
2154 		bytes32      _resultHash,
2155 		bytes32      _resultSeal,
2156 		address      _enclaveChallenge,
2157 		bytes memory _enclaveSign,
2158 		bytes memory _workerpoolSign)
2159 	public
2160 	{
2161 		IexecODBLibCore.Task         storage task         = m_tasks[_taskid];
2162 		IexecODBLibCore.Contribution storage contribution = m_contributions[_taskid][msg.sender];
2163 		IexecODBLibCore.Deal         memory  deal         = iexecclerk.viewDeal(task.dealid);
2164 
2165 		require(task.status               == IexecODBLibCore.TaskStatusEnum.ACTIVE       );
2166 		require(task.contributionDeadline >  now                                         );
2167 		require(contribution.status       == IexecODBLibCore.ContributionStatusEnum.UNSET);
2168 
2169 		// Check that the worker + taskid + enclave combo is authorized to contribute (scheduler signature)
2170 		require(verifySignature(
2171 			deal.workerpool.owner,
2172 			toEthSignedMessageHash(
2173 				keccak256(abi.encodePacked(
2174 					msg.sender,
2175 					_taskid,
2176 					_enclaveChallenge
2177 				))
2178 			),
2179 			_workerpoolSign
2180 		));
2181 
2182 		// need enclave challenge if tag is set
2183 		require(_enclaveChallenge != address(0) || (deal.tag[31] & 0x01 == 0));
2184 
2185 		// Check enclave signature
2186 		require(_enclaveChallenge == address(0) || verifySignature(
2187 			_enclaveChallenge,
2188 			toEthSignedMessageHash(
2189 				keccak256(abi.encodePacked(
2190 					_resultHash,
2191 					_resultSeal
2192 				))
2193 			),
2194 			_enclaveSign
2195 		));
2196 
2197 		// Update contribution entry
2198 		contribution.status           = IexecODBLibCore.ContributionStatusEnum.CONTRIBUTED;
2199 		contribution.resultHash       = _resultHash;
2200 		contribution.resultSeal       = _resultSeal;
2201 		contribution.enclaveChallenge = _enclaveChallenge;
2202 		task.contributors.push(msg.sender);
2203 
2204 		iexecclerk.lockContribution(task.dealid, msg.sender);
2205 
2206 		emit TaskContribute(_taskid, msg.sender, _resultHash);
2207 
2208 		// Contribution done → updating and checking concensus
2209 
2210 		/*************************************************************************
2211 		 *                           SCORE POLICY 1/3                            *
2212 		 *                                                                       *
2213 		 *                          see documentation!                           *
2214 		 *************************************************************************/
2215 		// k = 3
2216 		uint256 weight = m_workerScores[msg.sender].div(3).max(3).sub(1);
2217 		uint256 group  = m_groupweight[_taskid][_resultHash];
2218 		uint256 delta  = group.max(1).mul(weight).sub(group);
2219 
2220 		m_logweight  [_taskid][msg.sender ] = weight.log();
2221 		m_groupweight[_taskid][_resultHash] = m_groupweight[_taskid][_resultHash].add(delta);
2222 		m_totalweight[_taskid]              = m_totalweight[_taskid].add(delta);
2223 
2224 		// Check consensus
2225 		checkConsensus(_taskid, _resultHash);
2226 	}
2227 	function checkConsensus(
2228 		bytes32 _taskid,
2229 		bytes32 _consensus)
2230 	private
2231 	{
2232 		uint256 trust = iexecclerk.viewDeal(m_tasks[_taskid].dealid).trust;
2233 		if (m_groupweight[_taskid][_consensus].mul(trust) > m_totalweight[_taskid].mul(trust.sub(1)))
2234 		{
2235 			// Preliminary checks done in "contribute()"
2236 
2237 			IexecODBLibCore.Task storage task = m_tasks[_taskid];
2238 			uint256 winnerCounter = 0;
2239 			for (uint256 i = 0; i < task.contributors.length; ++i)
2240 			{
2241 				address w = task.contributors[i];
2242 				if
2243 				(
2244 					m_contributions[_taskid][w].resultHash == _consensus
2245 					&&
2246 					m_contributions[_taskid][w].status == IexecODBLibCore.ContributionStatusEnum.CONTRIBUTED // REJECTED contribution must not be count
2247 				)
2248 				{
2249 					winnerCounter = winnerCounter.add(1);
2250 				}
2251 			}
2252 			// msg.sender is a contributor: no need to check
2253 			// require(winnerCounter > 0);
2254 			task.status         = IexecODBLibCore.TaskStatusEnum.REVEALING;
2255 			task.consensusValue = _consensus;
2256 			task.revealDeadline = task.timeref.mul(REVEAL_DEADLINE_RATIO).add(now);
2257 			task.revealCounter  = 0;
2258 			task.winnerCounter  = winnerCounter;
2259 
2260 			emit TaskConsensus(_taskid, _consensus);
2261 		}
2262 	}
2263 
2264 	function reveal(
2265 		bytes32 _taskid,
2266 		bytes32 _resultDigest)
2267 	external // worker
2268 	{
2269 		IexecODBLibCore.Task         storage task         = m_tasks[_taskid];
2270 		IexecODBLibCore.Contribution storage contribution = m_contributions[_taskid][msg.sender];
2271 		require(task.status             == IexecODBLibCore.TaskStatusEnum.REVEALING                       );
2272 		require(task.revealDeadline     >  now                                                            );
2273 		require(contribution.status     == IexecODBLibCore.ContributionStatusEnum.CONTRIBUTED             );
2274 		require(contribution.resultHash == task.consensusValue                                            );
2275 		require(contribution.resultHash == keccak256(abi.encodePacked(            _taskid, _resultDigest)));
2276 		require(contribution.resultSeal == keccak256(abi.encodePacked(msg.sender, _taskid, _resultDigest)));
2277 
2278 		contribution.status = IexecODBLibCore.ContributionStatusEnum.PROVED;
2279 		task.revealCounter  = task.revealCounter.add(1);
2280 		task.resultDigest   = _resultDigest;
2281 
2282 		emit TaskReveal(_taskid, msg.sender, _resultDigest);
2283 	}
2284 
2285 	function reopen(
2286 		bytes32 _taskid)
2287 	external onlyScheduler(_taskid)
2288 	{
2289 		IexecODBLibCore.Task storage task = m_tasks[_taskid];
2290 		require(task.status         == IexecODBLibCore.TaskStatusEnum.REVEALING);
2291 		require(task.finalDeadline  >  now                                     );
2292 		require(task.revealDeadline <= now
2293 		     && task.revealCounter  == 0                                       );
2294 
2295 		for (uint256 i = 0; i < task.contributors.length; ++i)
2296 		{
2297 			address worker = task.contributors[i];
2298 			if (m_contributions[_taskid][worker].resultHash == task.consensusValue)
2299 			{
2300 				m_contributions[_taskid][worker].status = IexecODBLibCore.ContributionStatusEnum.REJECTED;
2301 			}
2302 		}
2303 
2304 		m_totalweight[_taskid]                      = m_totalweight[_taskid].sub(m_groupweight[_taskid][task.consensusValue]);
2305 		m_groupweight[_taskid][task.consensusValue] = 0;
2306 
2307 		task.status         = IexecODBLibCore.TaskStatusEnum.ACTIVE;
2308 		task.consensusValue = 0x0;
2309 		task.revealDeadline = 0;
2310 		task.winnerCounter  = 0;
2311 
2312 		emit TaskReopen(_taskid);
2313 	}
2314 
2315 	function finalize(
2316 		bytes32          _taskid,
2317 		bytes   calldata _results)
2318 	external onlyScheduler(_taskid)
2319 	{
2320 		IexecODBLibCore.Task storage task = m_tasks[_taskid];
2321 		require(task.status        == IexecODBLibCore.TaskStatusEnum.REVEALING);
2322 		require(task.finalDeadline >  now                                     );
2323 		require(task.revealCounter == task.winnerCounter
2324 		    || (task.revealCounter >  0  && task.revealDeadline <= now)       );
2325 
2326 		task.status  = IexecODBLibCore.TaskStatusEnum.COMPLETED;
2327 		task.results = _results;
2328 
2329 		/**
2330 		 * Stake and reward management
2331 		 */
2332 		iexecclerk.successWork(task.dealid, _taskid);
2333 		distributeRewards(_taskid);
2334 
2335 		/**
2336 		 * Event
2337 		 */
2338 		emit TaskFinalize(_taskid, _results);
2339 
2340 		/**
2341 		 * Callback for smartcontracts using EIP1154
2342 		 */
2343 		address callbackTarget = iexecclerk.viewDeal(task.dealid).callback;
2344 		if (callbackTarget != address(0))
2345 		{
2346 			/**
2347 			 * Call does not revert if the target smart contract is incompatible or reverts
2348 			 *
2349 			 * ATTENTION!
2350 			 * This call is dangerous and target smart contract can charge the stack.
2351 			 * Assume invalid state after the call.
2352 			 * See: https://solidity.readthedocs.io/en/develop/types.html#members-of-addresses
2353 			 *
2354 			 * TODO: gas provided?
2355 			 */
2356 			require(gasleft() > 100000);
2357 			bool success;
2358 			(success,) = callbackTarget.call.gas(100000)(abi.encodeWithSignature(
2359 				"receiveResult(bytes32,bytes)",
2360 				_taskid,
2361 				_results
2362 			));
2363 		}
2364 	}
2365 
2366 	function distributeRewards(bytes32 _taskid)
2367 	private
2368 	{
2369 		IexecODBLibCore.Task storage task = m_tasks[_taskid];
2370 		IexecODBLibCore.Deal memory  deal = iexecclerk.viewDeal(task.dealid);
2371 
2372 		uint256 i;
2373 		address worker;
2374 
2375 		uint256 totalLogWeight = 0;
2376 		uint256 totalReward = iexecclerk.viewDeal(task.dealid).workerpool.price;
2377 
2378 		for (i = 0; i < task.contributors.length; ++i)
2379 		{
2380 			worker = task.contributors[i];
2381 			if (m_contributions[_taskid][worker].status == IexecODBLibCore.ContributionStatusEnum.PROVED)
2382 			{
2383 				totalLogWeight = totalLogWeight.add(m_logweight[_taskid][worker]);
2384 			}
2385 			else // ContributionStatusEnum.REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
2386 			{
2387 				totalReward = totalReward.add(deal.workerStake);
2388 			}
2389 		}
2390 		require(totalLogWeight > 0);
2391 
2392 		// compute how much is going to the workers
2393 		uint256 workersReward = totalReward.percentage(uint256(100).sub(deal.schedulerRewardRatio));
2394 
2395 		for (i = 0; i < task.contributors.length; ++i)
2396 		{
2397 			worker = task.contributors[i];
2398 			if (m_contributions[_taskid][worker].status == IexecODBLibCore.ContributionStatusEnum.PROVED)
2399 			{
2400 				uint256 workerReward = workersReward.mulByFraction(m_logweight[_taskid][worker], totalLogWeight);
2401 				totalReward          = totalReward.sub(workerReward);
2402 
2403 				iexecclerk.unlockAndRewardForContribution(task.dealid, worker, workerReward, _taskid);
2404 
2405 				// Only reward if replication happened
2406 				if (task.contributors.length > 1)
2407 				{
2408 					/*******************************************************************
2409 					 *                        SCORE POLICY 2/3                         *
2410 					 *                                                                 *
2411 					 *                       see documentation!                        *
2412 					 *******************************************************************/
2413 					m_workerScores[worker] = m_workerScores[worker].add(1);
2414 					emit AccurateContribution(worker, _taskid);
2415 				}
2416 			}
2417 			else // WorkStatusEnum.POCO_REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
2418 			{
2419 				// No Reward
2420 				iexecclerk.seizeContribution(task.dealid, worker, _taskid);
2421 
2422 				// Always punish bad contributors
2423 				{
2424 					/*******************************************************************
2425 					 *                        SCORE POLICY 3/3                         *
2426 					 *                                                                 *
2427 					 *                       see documentation!                        *
2428 					 *******************************************************************/
2429 					// k = 3
2430 					m_workerScores[worker] = m_workerScores[worker].mulByFraction(2,3);
2431 					emit FaultyContribution(worker, _taskid);
2432 				}
2433 			}
2434 		}
2435 		// totalReward now contains the scheduler share
2436 		iexecclerk.rewardForScheduling(task.dealid, totalReward, _taskid);
2437 	}
2438 
2439 	function claim(
2440 		bytes32 _taskid)
2441 	public
2442 	{
2443 		IexecODBLibCore.Task storage task = m_tasks[_taskid];
2444 		require(task.status == IexecODBLibCore.TaskStatusEnum.ACTIVE
2445 		     || task.status == IexecODBLibCore.TaskStatusEnum.REVEALING);
2446 		require(task.finalDeadline <= now);
2447 
2448 		task.status = IexecODBLibCore.TaskStatusEnum.FAILLED;
2449 
2450 		/**
2451 		 * Stake management
2452 		 */
2453 		iexecclerk.failedWork(task.dealid, _taskid);
2454 		for (uint256 i = 0; i < task.contributors.length; ++i)
2455 		{
2456 			address worker = task.contributors[i];
2457 			iexecclerk.unlockContribution(task.dealid, worker);
2458 		}
2459 
2460 		emit TaskClaimed(_taskid);
2461 	}
2462 
2463 	/***************************************************************************
2464 	 *                            Array operations                             *
2465 	 ***************************************************************************/
2466 	function initializeArray(
2467 		bytes32[] calldata _dealid,
2468 		uint256[] calldata _idx)
2469 	external returns (bool)
2470 	{
2471 		require(_dealid.length == _idx.length);
2472 		for (uint i = 0; i < _dealid.length; ++i)
2473 		{
2474 			initialize(_dealid[i], _idx[i]);
2475 		}
2476 		return true;
2477 	}
2478 
2479 	function claimArray(
2480 		bytes32[] calldata _taskid)
2481 	external returns (bool)
2482 	{
2483 		for (uint i = 0; i < _taskid.length; ++i)
2484 		{
2485 			claim(_taskid[i]);
2486 		}
2487 		return true;
2488 	}
2489 
2490 	function initializeAndClaimArray(
2491 		bytes32[] calldata _dealid,
2492 		uint256[] calldata _idx)
2493 	external returns (bool)
2494 	{
2495 		require(_dealid.length == _idx.length);
2496 		for (uint i = 0; i < _dealid.length; ++i)
2497 		{
2498 			claim(initialize(_dealid[i], _idx[i]));
2499 		}
2500 		return true;
2501 	}
2502 
2503 	/**
2504 	 * /!\ TEMPORARY LEGACY /!\
2505 	 */
2506 
2507 	function viewTaskABILegacy(bytes32 _taskid)
2508 	external view returns
2509 	( IexecODBLibCore.TaskStatusEnum
2510 	, bytes32
2511 	, uint256
2512 	, uint256
2513 	, uint256
2514 	, uint256
2515 	, uint256
2516 	, bytes32
2517 	, uint256
2518 	, uint256
2519 	, address[] memory
2520 	, bytes     memory
2521 	)
2522 	{
2523 		IexecODBLibCore.Task memory task = m_tasks[_taskid];
2524 		return (
2525 			task.status,
2526 			task.dealid,
2527 			task.idx,
2528 			task.timeref,
2529 			task.contributionDeadline,
2530 			task.revealDeadline,
2531 			task.finalDeadline,
2532 			task.consensusValue,
2533 			task.revealCounter,
2534 			task.winnerCounter,
2535 			task.contributors,
2536 			task.results
2537 		);
2538 	}
2539 
2540 	function viewContributionABILegacy(bytes32 _taskid, address _worker)
2541 	external view returns
2542 	( IexecODBLibCore.ContributionStatusEnum
2543 	, bytes32
2544 	, bytes32
2545 	, address
2546 	)
2547 	{
2548 		IexecODBLibCore.Contribution memory contribution = m_contributions[_taskid][_worker];
2549 		return (
2550 			contribution.status,
2551 			contribution.resultHash,
2552 			contribution.resultSeal,
2553 			contribution.enclaveChallenge
2554 		);
2555 	}
2556 
2557 	function viewCategoryABILegacy(uint256 _catid)
2558 	external view returns (string memory, string memory, uint256)
2559 	{
2560 		IexecODBLibCore.Category memory category = m_categories[_catid];
2561 		return ( category.name, category.description, category.workClockTimeRef );
2562 	}
2563 }