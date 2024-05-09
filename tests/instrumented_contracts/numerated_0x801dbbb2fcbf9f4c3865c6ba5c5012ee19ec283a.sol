1 pragma solidity ^0.5.6;
2 pragma experimental ABIEncoderV2;
3 
4 interface GeneralERC20 {
5 	function transfer(address to, uint256 value) external;
6 	function transferFrom(address from, address to, uint256 value) external;
7 	function approve(address spender, uint256 value) external;
8 	function balanceOf(address spender) external view returns (uint);
9 }
10 
11 library SafeERC20 {
12 	function checkSuccess()
13 		private
14 		pure
15 		returns (bool)
16 	{
17 		uint256 returnValue = 0;
18 
19 		assembly {
20 			// check number of bytes returned from last function call
21 			switch returndatasize
22 
23 			// no bytes returned: assume success
24 			case 0x0 {
25 				returnValue := 1
26 			}
27 
28 			// 32 bytes returned: check if non-zero
29 			case 0x20 {
30 				// copy 32 bytes into scratch space
31 				returndatacopy(0x0, 0x0, 0x20)
32 
33 				// load those bytes into returnValue
34 				returnValue := mload(0x0)
35 			}
36 
37 			// not sure what was returned: don't mark as success
38 			default { }
39 		}
40 
41 		return returnValue != 0;
42 	}
43 
44 	function transfer(address token, address to, uint256 amount) internal {
45 		GeneralERC20(token).transfer(to, amount);
46 		require(checkSuccess());
47 	}
48 
49 	function transferFrom(address token, address from, address to, uint256 amount) internal {
50 		GeneralERC20(token).transferFrom(from, to, amount);
51 		require(checkSuccess());
52 	}
53 
54 	function approve(address token, address spender, uint256 amount) internal {
55 		GeneralERC20(token).approve(spender, amount);
56 		require(checkSuccess());
57 	}
58 }
59 
60 library SafeMath {
61 
62     function mul(uint a, uint b) internal pure returns (uint) {
63         uint c = a * b;
64         require(a == 0 || c / a == b);
65         return c;
66     }
67 
68     function div(uint a, uint b) internal pure returns (uint) {
69         require(b > 0);
70         uint c = a / b;
71         require(a == b * c + a % b);
72         return c;
73     }
74 
75     function sub(uint a, uint b) internal pure returns (uint) {
76         require(b <= a);
77         return a - b;
78     }
79 
80     function add(uint a, uint b) internal pure returns (uint) {
81         uint c = a + b;
82         require(c >= a);
83         return c;
84     }
85 
86     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
87         return a >= b ? a : b;
88     }
89 
90     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
91         return a < b ? a : b;
92     }
93 
94     function max256(uint a, uint b) internal pure returns (uint) {
95         return a >= b ? a : b;
96     }
97 
98     function min256(uint a, uint b) internal pure returns (uint) {
99         return a < b ? a : b;
100     }
101 }
102 
103 library SignatureValidator {
104 	enum SignatureMode {
105 		NO_SIG,
106 		EIP712,
107 		GETH,
108 		TREZOR,
109 		ADEX
110 	}
111 
112 	function recoverAddr(bytes32 hash, bytes32[3] memory signature) internal pure returns (address) {
113 		SignatureMode mode = SignatureMode(uint8(signature[0][0]));
114 
115 		if (mode == SignatureMode.NO_SIG) {
116 			return address(0x0);
117 		}
118 
119 		uint8 v = uint8(signature[0][1]);
120 
121 		if (mode == SignatureMode.GETH) {
122 			hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
123 		} else if (mode == SignatureMode.TREZOR) {
124 			hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n\x20", hash));
125 		} else if (mode == SignatureMode.ADEX) {
126 			hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n108By signing this message, you acknowledge signing an AdEx bid with the hash:\n", hash));
127 		}
128 
129 		return ecrecover(hash, v, signature[1], signature[2]);
130 	}
131 
132 	/// @dev Validates that a hash was signed by a specified signer.
133 	/// @param hash Hash which was signed.
134 	/// @param signer Address of the signer.
135 	/// @param signature ECDSA signature along with the mode [{mode}{v}, {r}, {s}]
136 	/// @return Returns whether signature is from a specified user.
137 	function isValidSignature(bytes32 hash, address signer, bytes32[3] memory signature) internal pure returns (bool) {
138 		return recoverAddr(hash, signature) == signer;
139 	}
140 }
141 
142 
143 library ChannelLibrary {
144 	uint constant MAX_VALIDITY = 365 days;
145 
146 	// Both numbers are inclusive
147 	uint constant MIN_VALIDATOR_COUNT = 2;
148 	// This is an arbitrary number, but we impose this limit to restrict on-chain load; also to ensure the *3 operation is safe
149 	uint constant MAX_VALIDATOR_COUNT = 25;
150 
151 	enum State {
152 		Unknown,
153 		Active,
154 		Expired
155 	}
156 
157 	struct Channel {
158 		address creator;
159 
160 		address tokenAddr;
161 		uint tokenAmount;
162 
163 		uint validUntil;
164 
165 		address[] validators;
166 
167 		// finally, arbitrary bytes32 that allows to... @TODO document that this acts as a nonce
168 		bytes32 spec;
169 	}
170 
171 	function hash(Channel memory channel)
172 		internal
173 		view
174 		returns (bytes32)
175 	{
176 		// In this version of solidity, we can no longer keccak256() directly
177 		return keccak256(abi.encode(
178 			address(this),
179 			channel.creator,
180 			channel.tokenAddr,
181 			channel.tokenAmount,
182 			channel.validUntil,
183 			channel.validators,
184 			channel.spec
185 		));
186 	}
187 
188 	function isValid(Channel memory channel, uint currentTime)
189 		internal
190 		pure
191 		returns (bool)
192 	{
193 		// NOTE: validators[] can be sybil'd by passing the same addr a few times
194 		// this does not matter since you can sybil validators[] anyway, and that is mitigated off-chain
195 		if (channel.validators.length < MIN_VALIDATOR_COUNT) {
196 			return false;
197 		}
198 		if (channel.validators.length > MAX_VALIDATOR_COUNT) {
199 			return false;
200 		}
201 		if (channel.validUntil < currentTime) {
202 			return false;
203 		}
204 		if (channel.validUntil > (currentTime + MAX_VALIDITY)) {
205 			return false;
206 		}
207 
208 		return true;
209 	}
210 
211 	function isSignedBySupermajority(Channel memory channel, bytes32 toSign, bytes32[3][] memory signatures) 
212 		internal
213 		pure
214 		returns (bool)
215 	{
216 		// NOTE: each element of signatures[] must signed by the elem with the same index in validators[]
217 		// In case someone didn't sign, pass SignatureMode.NO_SIG
218 		if (signatures.length != channel.validators.length) {
219 			return false;
220 		}
221 
222 		uint signs = 0;
223 		uint sigLen = signatures.length;
224 		for (uint i=0; i<sigLen; i++) {
225 			// NOTE: if a validator has not signed, you can just use SignatureMode.NO_SIG
226 			if (SignatureValidator.isValidSignature(toSign, channel.validators[i], signatures[i])) {
227 				signs++;
228 			}
229 		}
230 		return signs*3 >= channel.validators.length*2;
231 	}
232 }
233 
234 contract ValidatorRegistry {
235 	// The contract will probably just use a mapping, but this is a generic interface
236 	function whitelisted(address) view external returns (bool);
237 }
238 
239 contract Identity {
240 	using SafeMath for uint;
241 
242 	// Storage
243 	// WARNING: be careful when modifying this
244 	// privileges and routineAuthorizations must always be 0th and 1th thing in storage
245 	mapping (address => uint8) public privileges;
246 	// Routine authorizations
247 	mapping (bytes32 => bool) public routineAuthorizations;
248 	// The next allowed nonce
249 	uint public nonce = 0;
250 	// Routine operations are authorized at once for a period, fee is paid once
251 	mapping (bytes32 => uint256) public routinePaidFees;
252 
253 	// Constants
254 	bytes4 private constant CHANNEL_WITHDRAW_SELECTOR = bytes4(keccak256('channelWithdraw((address,address,uint256,uint256,address[],bytes32),bytes32,bytes32[3][],bytes32[],uint256)'));
255 	bytes4 private constant CHANNEL_WITHDRAW_EXPIRED_SELECTOR = bytes4(keccak256('channelWithdrawExpired((address,address,uint256,uint256,address[],bytes32))'));
256 	bytes4 private constant CHANNEL_OPEN_SELECTOR = bytes4(keccak256('channelOpen((address,address,uint256,uint256,address[],bytes32))'));
257 	uint256 private constant CHANNEL_MAX_VALIDITY = 90 days;
258 
259 	enum PrivilegeLevel {
260 		None,
261 		Routines,
262 		Transactions,
263 		WithdrawTo
264 	}
265 	enum RoutineOp {
266 		ChannelWithdraw,
267 		ChannelWithdrawExpired,
268 		ChannelOpen,
269 		Withdraw
270 	}
271 
272 	// Events
273 	event LogPrivilegeChanged(address indexed addr, uint8 privLevel);
274 	event LogRoutineAuth(bytes32 hash, bool authorized);
275 
276 	// Transaction structure
277 	// Those can be executed by keys with >= PrivilegeLevel.Transactions
278 	// Even though the contract cannot receive ETH, we are able to send ETH (.value), cause ETH might've been sent to the contract address before it's deployed
279 	struct Transaction {
280 		// replay protection
281 		address identityContract;
282 		uint nonce;
283 		// tx fee, in tokens
284 		address feeTokenAddr;
285 		uint feeAmount;
286 		// all the regular txn data
287 		address to;
288 		uint value;
289 		bytes data;
290 	}
291 
292 	// RoutineAuthorizations allow the user to authorize (via keys >= PrivilegeLevel.Routines) a particular relayer to do any number of routines
293 	// those routines are safe: e.g. withdrawing channels to the identity, or from the identity to the pre-approved withdraw (>= PrivilegeLevel.Withdraw) address
294 	// while the fee will be paid only ONCE per auth, the authorization can be used until validUntil
295 	// while the routines are safe, there is some level of implied trust as the relayer may run executeRoutines without any routines to claim the fee
296 	struct RoutineAuthorization {
297 		address relayer;
298 		address outpace;
299 		address registry;
300 		uint validUntil;
301 		address feeTokenAddr;
302 		uint weeklyFeeAmount;
303 	}
304 	struct RoutineOperation {
305 		RoutineOp mode;
306 		bytes data;
307 	}
308 
309 	constructor(address[] memory addrs, uint8[] memory privLevels)
310 		public
311 	{
312 		uint len = privLevels.length;
313 		for (uint i=0; i<len; i++) {
314 			privileges[addrs[i]] = privLevels[i];
315 			emit LogPrivilegeChanged(addrs[i], privLevels[i]);
316 		}
317 	}
318 
319 	function setAddrPrivilege(address addr, uint8 privLevel)
320 		external
321 	{
322 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
323 		privileges[addr] = privLevel;
324 		emit LogPrivilegeChanged(addr, privLevel);
325 	}
326 
327 	function setRoutineAuth(bytes32 hash, bool authorized)
328 		external
329 	{
330 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
331 		routineAuthorizations[hash] = authorized;
332 		emit LogRoutineAuth(hash, authorized);
333 	}
334 
335 	function execute(Transaction[] memory txns, bytes32[3][] memory signatures)
336 		public
337 	{
338 		address feeTokenAddr = txns[0].feeTokenAddr;
339 		uint feeAmount = 0;
340 		uint len = txns.length;
341 		for (uint i=0; i<len; i++) {
342 			Transaction memory txn = txns[i];
343 			require(txn.identityContract == address(this), 'TRANSACTION_NOT_FOR_CONTRACT');
344 			require(txn.feeTokenAddr == feeTokenAddr, 'EXECUTE_NEEDS_SINGLE_TOKEN');
345 			require(txn.nonce == nonce, 'WRONG_NONCE');
346 
347 			// If we use the naive abi.encode(txn) and have a field of type `bytes`,
348 			// there is a discrepancy between ethereumjs-abi and solidity
349 			// if we enter every field individually, in order, there is no discrepancy
350 			//bytes32 hash = keccak256(abi.encode(txn));
351 			bytes32 hash = keccak256(abi.encode(txn.identityContract, txn.nonce, txn.feeTokenAddr, txn.feeAmount, txn.to, txn.value, txn.data));
352 			address signer = SignatureValidator.recoverAddr(hash, signatures[i]);
353 
354 			require(privileges[signer] >= uint8(PrivilegeLevel.Transactions), 'INSUFFICIENT_PRIVILEGE_TRANSACTION');
355 
356 			nonce = nonce.add(1);
357 			feeAmount = feeAmount.add(txn.feeAmount);
358 
359 			executeCall(txn.to, txn.value, txn.data);
360 			// The actual anti-bricking mechanism - do not allow a signer to drop his own priviledges
361 			require(privileges[signer] >= uint8(PrivilegeLevel.Transactions), 'PRIVILEGE_NOT_DOWNGRADED');
362 		}
363 		if (feeAmount > 0) {
364 			SafeERC20.transfer(feeTokenAddr, msg.sender, feeAmount);
365 		}
366 	}
367 
368 	function executeBySender(Transaction[] memory txns)
369 		public
370 	{
371 		require(privileges[msg.sender] >= uint8(PrivilegeLevel.Transactions), 'INSUFFICIENT_PRIVILEGE_SENDER');
372 		uint len = txns.length;
373 		for (uint i=0; i<len; i++) {
374 			Transaction memory txn = txns[i];
375 			require(txn.nonce == nonce, 'WRONG_NONCE');
376 
377 			nonce = nonce.add(1);
378 
379 			executeCall(txn.to, txn.value, txn.data);
380 		}
381 		// The actual anti-bricking mechanism - do not allow the sender to drop his own priviledges
382 		require(privileges[msg.sender] >= uint8(PrivilegeLevel.Transactions), 'PRIVILEGE_NOT_DOWNGRADED');
383 	}
384 
385 	function executeRoutines(RoutineAuthorization memory auth, RoutineOperation[] memory operations)
386 		public
387 	{
388 		require(auth.relayer == msg.sender, 'ONLY_RELAYER_CAN_CALL');
389 		require(auth.validUntil >= now, 'AUTHORIZATION_EXPIRED');
390 		bytes32 hash = keccak256(abi.encode(auth));
391 		require(routineAuthorizations[hash], 'NOT_AUTHORIZED');
392 		uint len = operations.length;
393 		for (uint i=0; i<len; i++) {
394 			RoutineOperation memory op = operations[i];
395 			if (op.mode == RoutineOp.ChannelWithdraw) {
396 				// Channel: Withdraw
397 				executeCall(auth.outpace, 0, abi.encodePacked(CHANNEL_WITHDRAW_SELECTOR, op.data));
398 			} else if (op.mode == RoutineOp.ChannelWithdrawExpired) {
399 				// Channel: Withdraw Expired
400 				executeCall(auth.outpace, 0, abi.encodePacked(CHANNEL_WITHDRAW_EXPIRED_SELECTOR, op.data));
401 			} else if (op.mode == RoutineOp.ChannelOpen) {
402 				// Channel: open
403 				(ChannelLibrary.Channel memory channel) = abi.decode(op.data, (ChannelLibrary.Channel));
404 				// Ensure validity is sane
405 				require(channel.validUntil <= (now + CHANNEL_MAX_VALIDITY), 'CHANNEL_EXCEEDED_MAX_VALID');
406 				// Ensure all validators are whitelisted
407 				uint validatorsLen = channel.validators.length;
408 				for (uint j=0; j<validatorsLen; j++) {
409 					require(
410 						ValidatorRegistry(auth.registry).whitelisted(channel.validators[j]),
411 						"VALIDATOR_NOT_WHITELISTED"
412 					);
413 				}
414 				SafeERC20.approve(channel.tokenAddr, auth.outpace, 0);
415 				SafeERC20.approve(channel.tokenAddr, auth.outpace, channel.tokenAmount);
416 				executeCall(auth.outpace, 0, abi.encodePacked(CHANNEL_OPEN_SELECTOR, op.data));
417 			} else if (op.mode == RoutineOp.Withdraw) {
418 				// Withdraw from identity
419 				(address tokenAddr, address to, uint amount) = abi.decode(op.data, (address, address, uint));
420 				require(privileges[to] >= uint8(PrivilegeLevel.WithdrawTo), 'INSUFFICIENT_PRIVILEGE_WITHDRAW');
421 				SafeERC20.transfer(tokenAddr, to, amount);
422 			} else {
423 				revert('INVALID_MODE');
424 			}
425 		}
426 		if (auth.weeklyFeeAmount > 0 && (now - routinePaidFees[hash]) >= 7 days) {
427 			routinePaidFees[hash] = now;
428 			SafeERC20.transfer(auth.feeTokenAddr, msg.sender, auth.weeklyFeeAmount);
429 		}
430 	}
431 
432 	// we shouldn't use address.call(), cause: https://github.com/ethereum/solidity/issues/2884
433 	// copied from https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol
434 	// there's also
435 	// https://github.com/gnosis/MultiSigWallet/commit/e1b25e8632ca28e9e9e09c81bd20bf33fdb405ce
436 	// https://github.com/austintgriffith/bouncer-proxy/blob/master/BouncerProxy/BouncerProxy.sol
437 	// https://github.com/gnosis/safe-contracts/blob/7e2eeb3328bb2ae85c36bc11ea6afc14baeb663c/contracts/base/Executor.sol
438 	function executeCall(address to, uint256 value, bytes memory data)
439 		internal
440 	{
441 		assembly {
442 			let result := call(gas, to, value, add(data, 0x20), mload(data), 0, 0)
443 
444 			switch result case 0 {
445 				let size := returndatasize
446 				let ptr := mload(0x40)
447 				returndatacopy(ptr, 0, size)
448 				revert(ptr, size)
449 			}
450 			default {}
451 		}
452 	}
453 }
454 
455 contract IdentityFactory {
456 	event LogDeployed(address addr, uint256 salt);
457 
458 	address public relayer;
459 	constructor(address relayerAddr) public {
460 		relayer = relayerAddr;
461 	}
462 
463 	function deploy(bytes memory code, uint256 salt) public {
464 		address addr;
465 		assembly { addr := create2(0, add(code, 0x20), mload(code), salt) }
466 		require(addr != address(0), "FAILED_DEPLOYING");
467 		emit LogDeployed(addr, salt);
468 	}
469 
470 	function deployAndFund(bytes memory code, uint256 salt, address tokenAddr, uint256 tokenAmount) public {
471 		require(msg.sender == relayer, "ONLY_RELAYER");
472 		address addr;
473 		assembly { addr := create2(0, add(code, 0x20), mload(code), salt) }
474 		require(addr != address(0), "FAILED_DEPLOYING");
475 		SafeERC20.transfer(tokenAddr, addr, tokenAmount);
476 		emit LogDeployed(addr, salt);
477 	}
478 
479 	function deployAndExecute(bytes memory code, uint256 salt, Identity.Transaction[] memory txns, bytes32[3][] memory signatures) public {
480 		address addr;
481 		assembly { addr := create2(0, add(code, 0x20), mload(code), salt) }
482 		require(addr != address(0), "FAILED_DEPLOYING");
483 		Identity(addr).execute(txns, signatures);
484 		emit LogDeployed(addr, salt);
485 	}
486 
487 	function withdraw(address tokenAddr, address to, uint256 tokenAmount) public {
488 		require(msg.sender == relayer, "ONLY_RELAYER");
489 		SafeERC20.transfer(tokenAddr, to, tokenAmount);
490 	}
491 }