1 pragma solidity ^0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 
6 library SafeMath {
7 
8     function mul(uint a, uint b) internal pure returns (uint) {
9         uint c = a * b;
10         require(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint a, uint b) internal pure returns (uint) {
15         require(b > 0);
16         uint c = a / b;
17         require(a == b * c + a % b);
18         return c;
19     }
20 
21     function sub(uint a, uint b) internal pure returns (uint) {
22         require(b <= a);
23         return a - b;
24     }
25 
26     function add(uint a, uint b) internal pure returns (uint) {
27         uint c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a >= b ? a : b;
34     }
35 
36     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
37         return a < b ? a : b;
38     }
39 
40     function max256(uint a, uint b) internal pure returns (uint) {
41         return a >= b ? a : b;
42     }
43 
44     function min256(uint a, uint b) internal pure returns (uint) {
45         return a < b ? a : b;
46     }
47 }
48 
49 // NOTE: this interface lacks return values for transfer/transferFrom/approve on purpose,
50 // as we use the SafeERC20 library to check the return value
51 interface GeneralERC20 {
52 	function transfer(address to, uint256 amount) external;
53 	function transferFrom(address from, address to, uint256 amount) external;
54 	function approve(address spender, uint256 amount) external;
55 	function balanceOf(address spender) external view returns (uint);
56 	function allowance(address owner, address spender) external view returns (uint);
57 }
58 
59 library SafeERC20 {
60 	function checkSuccess()
61 		private
62 		pure
63 		returns (bool)
64 	{
65 		uint256 returnValue = 0;
66 
67 		assembly {
68 			// check number of bytes returned from last function call
69 			switch returndatasize()
70 
71 			// no bytes returned: assume success
72 			case 0x0 {
73 				returnValue := 1
74 			}
75 
76 			// 32 bytes returned: check if non-zero
77 			case 0x20 {
78 				// copy 32 bytes into scratch space
79 				returndatacopy(0x0, 0x0, 0x20)
80 
81 				// load those bytes into returnValue
82 				returnValue := mload(0x0)
83 			}
84 
85 			// not sure what was returned: don't mark as success
86 			default { }
87 		}
88 
89 		return returnValue != 0;
90 	}
91 
92 	function transfer(address token, address to, uint256 amount) internal {
93 		GeneralERC20(token).transfer(to, amount);
94 		require(checkSuccess());
95 	}
96 
97 	function transferFrom(address token, address from, address to, uint256 amount) internal {
98 		GeneralERC20(token).transferFrom(from, to, amount);
99 		require(checkSuccess());
100 	}
101 
102 	function approve(address token, address spender, uint256 amount) internal {
103 		GeneralERC20(token).approve(spender, amount);
104 		require(checkSuccess());
105 	}
106 }
107 
108 library SignatureValidator {
109 	enum SignatureMode {
110 		NO_SIG,
111 		EIP712,
112 		GETH,
113 		TREZOR,
114 		ADEX
115 	}
116 
117 	function recoverAddr(bytes32 hash, bytes32[3] memory signature) internal pure returns (address) {
118 		SignatureMode mode = SignatureMode(uint8(signature[0][0]));
119 
120 		if (mode == SignatureMode.NO_SIG) {
121 			return address(0x0);
122 		}
123 
124 		uint8 v = uint8(signature[0][1]);
125 
126 		if (mode == SignatureMode.GETH) {
127 			hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
128 		} else if (mode == SignatureMode.TREZOR) {
129 			hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n\x20", hash));
130 		} else if (mode == SignatureMode.ADEX) {
131 			hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n108By signing this message, you acknowledge signing an AdEx bid with the hash:\n", hash));
132 		}
133 
134 		return ecrecover(hash, v, signature[1], signature[2]);
135 	}
136 
137 	/// @dev Validates that a hash was signed by a specified signer.
138 	/// @param hash Hash which was signed.
139 	/// @param signer Address of the signer.
140 	/// @param signature ECDSA signature along with the mode [{mode}{v}, {r}, {s}]
141 	/// @return Returns whether signature is from a specified user.
142 	function isValidSignature(bytes32 hash, address signer, bytes32[3] memory signature) internal pure returns (bool) {
143 		return recoverAddr(hash, signature) == signer;
144 	}
145 }
146 
147 
148 library ChannelLibrary {
149 	uint constant MAX_VALIDITY = 365 days;
150 
151 	// Both numbers are inclusive
152 	uint constant MIN_VALIDATOR_COUNT = 2;
153 	// This is an arbitrary number, but we impose this limit to restrict on-chain load; also to ensure the *3 operation is safe
154 	uint constant MAX_VALIDATOR_COUNT = 25;
155 
156 	enum State {
157 		Unknown,
158 		Active,
159 		Expired
160 	}
161 
162 	struct Channel {
163 		address creator;
164 
165 		address tokenAddr;
166 		uint tokenAmount;
167 
168 		uint validUntil;
169 
170 		address[] validators;
171 
172 		// finally, arbitrary bytes32 that allows to... @TODO document that this acts as a nonce
173 		bytes32 spec;
174 	}
175 
176 	function hash(Channel memory channel)
177 		internal
178 		view
179 		returns (bytes32)
180 	{
181 		// In this version of solidity, we can no longer keccak256() directly
182 		return keccak256(abi.encode(
183 			address(this),
184 			channel.creator,
185 			channel.tokenAddr,
186 			channel.tokenAmount,
187 			channel.validUntil,
188 			channel.validators,
189 			channel.spec
190 		));
191 	}
192 
193 	function isValid(Channel memory channel, uint currentTime)
194 		internal
195 		pure
196 		returns (bool)
197 	{
198 		// NOTE: validators[] can be sybil'd by passing the same addr a few times
199 		// this does not matter since you can sybil validators[] anyway, and that is mitigated off-chain
200 		if (channel.validators.length < MIN_VALIDATOR_COUNT) {
201 			return false;
202 		}
203 		if (channel.validators.length > MAX_VALIDATOR_COUNT) {
204 			return false;
205 		}
206 		if (channel.validUntil < currentTime) {
207 			return false;
208 		}
209 		if (channel.validUntil > (currentTime + MAX_VALIDITY)) {
210 			return false;
211 		}
212 
213 		return true;
214 	}
215 
216 	function isSignedBySupermajority(Channel memory channel, bytes32 toSign, bytes32[3][] memory signatures) 
217 		internal
218 		pure
219 		returns (bool)
220 	{
221 		// NOTE: each element of signatures[] must signed by the elem with the same index in validators[]
222 		// In case someone didn't sign, pass SignatureMode.NO_SIG
223 		if (signatures.length != channel.validators.length) {
224 			return false;
225 		}
226 
227 		uint signs = 0;
228 		uint sigLen = signatures.length;
229 		for (uint i=0; i<sigLen; i++) {
230 			// NOTE: if a validator has not signed, you can just use SignatureMode.NO_SIG
231 			if (SignatureValidator.isValidSignature(toSign, channel.validators[i], signatures[i])) {
232 				signs++;
233 			} else if (i == 0) {
234 				// The 0th signature is always from the leading validator, so it doesn't make sense for other sigs to exist if this one does not
235 				return false;
236 			}
237 		}
238 		return signs*3 >= channel.validators.length*2;
239 	}
240 }
241 
242 library MerkleProof {
243 	function isContained(bytes32 valueHash, bytes32[] memory proof, bytes32 root) internal pure returns (bool) {
244 		bytes32 cursor = valueHash;
245 
246 		uint256 proofLen = proof.length;
247 		for (uint256 i = 0; i < proofLen; i++) {
248 			if (cursor < proof[i]) {
249 				cursor = keccak256(abi.encodePacked(cursor, proof[i]));
250 			} else {
251 				cursor = keccak256(abi.encodePacked(proof[i], cursor));
252 			}
253 		}
254 
255 		return cursor == root;
256 	}
257 }
258 
259 
260 // AUDIT: Things we should look for
261 // 1) every time we check the state, the function should either revert or change the state
262 // 2) state transition: channelOpen locks up tokens, then all of the tokens can be withdrawn on channelExpiredWithdraw, except how many were withdrawn using channelWithdraw
263 // 3) external calls (everything using SafeERC20) should be at the end
264 // 4) channel can always be 100% drained with Withdraw/ExpiredWithdraw
265 
266 contract AdExCore {
267 	using SafeMath for uint;
268 	using ChannelLibrary for ChannelLibrary.Channel;
269 
270  	// channelId => channelState
271 	mapping (bytes32 => ChannelLibrary.State) public states;
272 	
273 	// withdrawn per channel (channelId => uint)
274 	mapping (bytes32 => uint) public withdrawn;
275 	// withdrawn per channel user (channelId => (account => uint))
276 	mapping (bytes32 => mapping (address => uint)) public withdrawnPerUser;
277 
278 	// Events
279 	event LogChannelOpen(bytes32 indexed channelId);
280 	event LogChannelWithdrawExpired(bytes32 indexed channelId, uint amount);
281 	event LogChannelWithdraw(bytes32 indexed channelId, uint amount);
282 
283 	// All functions are public
284 	function channelOpen(ChannelLibrary.Channel memory channel)
285 		public
286 	{
287 		bytes32 channelId = channel.hash();
288 		require(states[channelId] == ChannelLibrary.State.Unknown, "INVALID_STATE");
289 		require(msg.sender == channel.creator, "INVALID_CREATOR");
290 		require(channel.isValid(now), "INVALID_CHANNEL");
291 		
292 		states[channelId] = ChannelLibrary.State.Active;
293 
294 		SafeERC20.transferFrom(channel.tokenAddr, msg.sender, address(this), channel.tokenAmount);
295 
296 		emit LogChannelOpen(channelId);
297 	}
298 
299 	function channelWithdrawExpired(ChannelLibrary.Channel memory channel)
300 		public
301 	{
302 		bytes32 channelId = channel.hash();
303 		require(states[channelId] == ChannelLibrary.State.Active, "INVALID_STATE");
304 		require(now > channel.validUntil, "NOT_EXPIRED");
305 		require(msg.sender == channel.creator, "INVALID_CREATOR");
306 		
307 		uint toWithdraw = channel.tokenAmount.sub(withdrawn[channelId]);
308 
309 		// NOTE: we will not update withdrawn, since a WithdrawExpired does not count towards normal withdrawals
310 		states[channelId] = ChannelLibrary.State.Expired;
311 		
312 		SafeERC20.transfer(channel.tokenAddr, msg.sender, toWithdraw);
313 
314 		emit LogChannelWithdrawExpired(channelId, toWithdraw);
315 	}
316 
317 	function channelWithdraw(ChannelLibrary.Channel memory channel, bytes32 stateRoot, bytes32[3][] memory signatures, bytes32[] memory proof, uint amountInTree)
318 		public
319 	{
320 		bytes32 channelId = channel.hash();
321 		require(states[channelId] == ChannelLibrary.State.Active, "INVALID_STATE");
322 		require(now <= channel.validUntil, "EXPIRED");
323 
324 		bytes32 hashToSign = keccak256(abi.encode(channelId, stateRoot));
325 		require(channel.isSignedBySupermajority(hashToSign, signatures), "NOT_SIGNED_BY_VALIDATORS");
326 
327 		bytes32 balanceLeaf = keccak256(abi.encode(msg.sender, amountInTree));
328 		require(MerkleProof.isContained(balanceLeaf, proof, stateRoot), "BALANCELEAF_NOT_FOUND");
329 
330 		// The user can withdraw their constantly increasing balance at any time (essentially prevent users from double spending)
331 		uint toWithdraw = amountInTree.sub(withdrawnPerUser[channelId][msg.sender]);
332 		withdrawnPerUser[channelId][msg.sender] = amountInTree;
333 
334 		// Ensure that it's not possible to withdraw more than the channel deposit (e.g. malicious validators sign such a state)
335 		withdrawn[channelId] = withdrawn[channelId].add(toWithdraw);
336 		require(withdrawn[channelId] <= channel.tokenAmount, "WITHDRAWING_MORE_THAN_CHANNEL");
337 
338 		SafeERC20.transfer(channel.tokenAddr, msg.sender, toWithdraw);
339 
340 		emit LogChannelWithdraw(channelId, toWithdraw);
341 	}
342 }
343 
344 contract Identity {
345 	using SafeMath for uint;
346 
347 	// Storage
348 	// WARNING: be careful when modifying this
349 	// privileges and routineAuthorizations must always be 0th and 1th thing in storage,
350 	// because of the proxies we generate that delegatecall into this contract (which assume storage slot 0 and 1)
351 	mapping (address => uint8) public privileges;
352 	// Routine authorizations
353 	mapping (bytes32 => bool) public routineAuthorizations;
354 	// The next allowed nonce
355 	uint public nonce = 0;
356 	// Routine operations are authorized at once for a period, fee is paid once
357 	mapping (bytes32 => uint256) public routinePaidFees;
358 
359 	// Constants
360 	bytes4 private constant CHANNEL_WITHDRAW_SELECTOR = bytes4(keccak256('channelWithdraw((address,address,uint256,uint256,address[],bytes32),bytes32,bytes32[3][],bytes32[],uint256)'));
361 	bytes4 private constant CHANNEL_WITHDRAW_EXPIRED_SELECTOR = bytes4(keccak256('channelWithdrawExpired((address,address,uint256,uint256,address[],bytes32))'));
362 
363 	enum PrivilegeLevel {
364 		None,
365 		Routines,
366 		Transactions
367 	}
368 	enum RoutineOp {
369 		ChannelWithdraw,
370 		ChannelWithdrawExpired
371 	}
372 
373 	// Events
374 	event LogPrivilegeChanged(address indexed addr, uint8 privLevel);
375 	event LogRoutineAuth(bytes32 hash, bool authorized);
376 
377 	// Transaction structure
378 	// Those can be executed by keys with >= PrivilegeLevel.Transactions
379 	// Even though the contract cannot receive ETH, we are able to send ETH (.value), cause ETH might've been sent to the contract address before it's deployed
380 	struct Transaction {
381 		// replay protection
382 		address identityContract;
383 		uint nonce;
384 		// tx fee, in tokens
385 		address feeTokenAddr;
386 		uint feeAmount;
387 		// all the regular txn data
388 		address to;
389 		uint value;
390 		bytes data;
391 	}
392 
393 	// RoutineAuthorizations allow the user to authorize (via keys >= PrivilegeLevel.Routines) a relayer to do any number of routines
394 	// those routines are safe: e.g. sweeping channels (withdrawing off-chain balances to the identity)
395 	// while the fee will be paid only ONCE per auth per period (1 week), the authorization can be used until validUntil
396 	// while the routines are safe, there is some level of implied trust as the relayer may run executeRoutines without any routines to claim the fee
397 	struct RoutineAuthorization {
398 		address relayer;
399 		address outpace;
400 		uint validUntil;
401 		address feeTokenAddr;
402 		uint weeklyFeeAmount;
403 	}
404 	struct RoutineOperation {
405 		RoutineOp mode;
406 		bytes data;
407 	}
408 
409 	constructor(address[] memory addrs, uint8[] memory privLevels)
410 		public
411 	{
412 		uint len = privLevels.length;
413 		for (uint i=0; i<len; i++) {
414 			privileges[addrs[i]] = privLevels[i];
415 			emit LogPrivilegeChanged(addrs[i], privLevels[i]);
416 		}
417 	}
418 
419 	function setAddrPrivilege(address addr, uint8 privLevel)
420 		external
421 	{
422 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
423 		privileges[addr] = privLevel;
424 		emit LogPrivilegeChanged(addr, privLevel);
425 	}
426 
427 	function setRoutineAuth(bytes32 hash, bool authorized)
428 		external
429 	{
430 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
431 		routineAuthorizations[hash] = authorized;
432 		emit LogRoutineAuth(hash, authorized);
433 	}
434 
435 	function channelOpen(address coreAddr, ChannelLibrary.Channel memory channel)
436 		public
437 	{
438 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
439 		if (GeneralERC20(channel.tokenAddr).allowance(address(this), coreAddr) > 0) {
440 			SafeERC20.approve(channel.tokenAddr, coreAddr, 0);
441 		}
442 		SafeERC20.approve(channel.tokenAddr, coreAddr, channel.tokenAmount);
443 		AdExCore(coreAddr).channelOpen(channel);
444 	}
445 
446 	function execute(Transaction[] memory txns, bytes32[3][] memory signatures)
447 		public
448 	{
449 		require(txns.length > 0, 'MUST_PASS_TX');
450 		address feeTokenAddr = txns[0].feeTokenAddr;
451 		uint feeAmount = 0;
452 		uint len = txns.length;
453 		for (uint i=0; i<len; i++) {
454 			Transaction memory txn = txns[i];
455 			require(txn.identityContract == address(this), 'TRANSACTION_NOT_FOR_CONTRACT');
456 			require(txn.feeTokenAddr == feeTokenAddr, 'EXECUTE_NEEDS_SINGLE_TOKEN');
457 			require(txn.nonce == nonce, 'WRONG_NONCE');
458 
459 			// If we use the naive abi.encode(txn) and have a field of type `bytes`,
460 			// there is a discrepancy between ethereumjs-abi and solidity
461 			// if we enter every field individually, in order, there is no discrepancy
462 			//bytes32 hash = keccak256(abi.encode(txn));
463 			bytes32 hash = keccak256(abi.encode(txn.identityContract, txn.nonce, txn.feeTokenAddr, txn.feeAmount, txn.to, txn.value, txn.data));
464 			address signer = SignatureValidator.recoverAddr(hash, signatures[i]);
465 
466 			require(privileges[signer] >= uint8(PrivilegeLevel.Transactions), 'INSUFFICIENT_PRIVILEGE_TRANSACTION');
467 
468 			nonce = nonce.add(1);
469 			feeAmount = feeAmount.add(txn.feeAmount);
470 
471 			executeCall(txn.to, txn.value, txn.data);
472 			// The actual anti-bricking mechanism - do not allow a signer to drop his own priviledges
473 			require(privileges[signer] >= uint8(PrivilegeLevel.Transactions), 'PRIVILEGE_NOT_DOWNGRADED');
474 		}
475 		if (feeAmount > 0) {
476 			SafeERC20.transfer(feeTokenAddr, msg.sender, feeAmount);
477 		}
478 	}
479 
480 	function executeBySender(Transaction[] memory txns)
481 		public
482 	{
483 		require(privileges[msg.sender] >= uint8(PrivilegeLevel.Transactions), 'INSUFFICIENT_PRIVILEGE_SENDER');
484 		uint len = txns.length;
485 		for (uint i=0; i<len; i++) {
486 			Transaction memory txn = txns[i];
487 			require(txn.nonce == nonce, 'WRONG_NONCE');
488 
489 			nonce = nonce.add(1);
490 
491 			executeCall(txn.to, txn.value, txn.data);
492 		}
493 		// The actual anti-bricking mechanism - do not allow the sender to drop his own priviledges
494 		require(privileges[msg.sender] >= uint8(PrivilegeLevel.Transactions), 'PRIVILEGE_NOT_DOWNGRADED');
495 	}
496 
497 	function executeRoutines(RoutineAuthorization memory auth, RoutineOperation[] memory operations)
498 		public
499 	{
500 		require(auth.validUntil >= now, 'AUTHORIZATION_EXPIRED');
501 		bytes32 hash = keccak256(abi.encode(auth));
502 		require(routineAuthorizations[hash], 'NO_AUTHORIZATION');
503 		uint len = operations.length;
504 		for (uint i=0; i<len; i++) {
505 			RoutineOperation memory op = operations[i];
506 			if (op.mode == RoutineOp.ChannelWithdraw) {
507 				// Channel: Withdraw
508 				executeCall(auth.outpace, 0, abi.encodePacked(CHANNEL_WITHDRAW_SELECTOR, op.data));
509 			} else if (op.mode == RoutineOp.ChannelWithdrawExpired) {
510 				// Channel: Withdraw Expired
511 				executeCall(auth.outpace, 0, abi.encodePacked(CHANNEL_WITHDRAW_EXPIRED_SELECTOR, op.data));
512 			} else {
513 				revert('INVALID_MODE');
514 			}
515 		}
516 		if (auth.weeklyFeeAmount > 0 && (now - routinePaidFees[hash]) >= 7 days) {
517 			routinePaidFees[hash] = now;
518 			SafeERC20.transfer(auth.feeTokenAddr, auth.relayer, auth.weeklyFeeAmount);
519 		}
520 	}
521 
522 	// we shouldn't use address.call(), cause: https://github.com/ethereum/solidity/issues/2884
523 	// copied from https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol
524 	// there's also
525 	// https://github.com/gnosis/MultiSigWallet/commit/e1b25e8632ca28e9e9e09c81bd20bf33fdb405ce
526 	// https://github.com/austintgriffith/bouncer-proxy/blob/master/BouncerProxy/BouncerProxy.sol
527 	// https://github.com/gnosis/safe-contracts/blob/7e2eeb3328bb2ae85c36bc11ea6afc14baeb663c/contracts/base/Executor.sol
528 	function executeCall(address to, uint256 value, bytes memory data)
529 		internal
530 	{
531 		assembly {
532 			let result := call(gas(), to, value, add(data, 0x20), mload(data), 0, 0)
533 
534 			switch result case 0 {
535 				let size := returndatasize()
536 				let ptr := mload(0x40)
537 				returndatacopy(ptr, 0, size)
538 				revert(ptr, size)
539 			}
540 			default {}
541 		}
542 	}
543 }
544 
545 
546 contract IdentityFactory {
547 	event LogDeployed(address addr, uint256 salt);
548 
549 	address public creator;
550 	constructor() public {
551 		creator = msg.sender;
552 	}
553 
554 	function deploy(bytes memory code, uint256 salt) public {
555 		deploySafe(code, salt);
556 	}
557 
558 	// When the relayer needs to act upon an /execute call, it'll either call execute on the Identity directly
559 	// if it's already deployed, or call `deployAndExecute` if the account is still counterfactual
560 	function deployAndExecute(
561 		bytes memory code, uint256 salt,
562 		Identity.Transaction[] memory txns, bytes32[3][] memory signatures
563 	) public {
564 		address addr = deploySafe(code, salt);
565 		Identity(addr).execute(txns, signatures);
566 	}
567 	function deployAndExecuteBySender(
568 		bytes memory code, uint256 salt,
569 		Identity.Transaction[] memory txns
570 	) public {
571 		address addr = deploySafe(code, salt);
572 		Identity(addr).executeBySender(txns);
573 	}
574 
575 
576 	// When the relayer needs to do routines, it'll either call executeRoutines on the Identity directly
577 	// if it's already deployed, or call `deployAndRoutines` if the account is still counterfactual
578 	function deployAndRoutines(
579 		bytes memory code, uint256 salt,
580 		Identity.RoutineAuthorization memory auth, Identity.RoutineOperation[] memory operations
581 	) public {
582 		address addr = deploySafe(code, salt);
583 		Identity(addr).executeRoutines(auth, operations);
584 	}
585 
586 	// Withdraw the earnings from various fees (deploy fees and execute fees earned cause of `deployAndExecute`)
587 	function withdraw(address tokenAddr, address to, uint256 tokenAmount) public {
588 		require(msg.sender == creator, 'ONLY_CREATOR');
589 		SafeERC20.transfer(tokenAddr, to, tokenAmount);
590 	}
591 
592 	// This is done to mitigate possible frontruns where, for example, deploying the same code/salt via deploy()
593 	// would make a pending deployAndExecute fail
594 	// The way we mitigate that is by checking if the contract is already deployed and if so, we continue execution
595 	function deploySafe(bytes memory code, uint256 salt) internal returns (address) {
596 		address expectedAddr = address(uint160(uint256(
597 			keccak256(abi.encodePacked(byte(0xff), address(this), salt, keccak256(code)))
598 		)));
599 		uint size;
600 		assembly { size := extcodesize(expectedAddr) }
601 		// If there is code at that address, we can assume it's the one we were about to deploy,
602 		// because of how CREATE2 and keccak256 works
603 		if (size == 0) {
604 			address addr;
605 			assembly { addr := create2(0, add(code, 0x20), mload(code), salt) }
606 			require(addr != address(0), 'FAILED_DEPLOYING');
607 			require(addr == expectedAddr, 'FAILED_MATCH');
608 			emit LogDeployed(addr, salt);
609 		}
610 		return expectedAddr;
611 	}
612 }