1 pragma solidity 0.8.7;
2 
3 // @TODO: Formatting
4 library LibBytes {
5   // @TODO: see if we can just set .length = 
6   function trimToSize(bytes memory b, uint newLen)
7     internal
8     pure
9   {
10     require(b.length > newLen, "BytesLib: only shrinking");
11     assembly {
12       mstore(b, newLen)
13     }
14   }
15 
16 
17   /***********************************|
18   |        Read Bytes Functions       |
19   |__________________________________*/
20 
21   /**
22    * @dev Reads a bytes32 value from a position in a byte array.
23    * @param b Byte array containing a bytes32 value.
24    * @param index Index in byte array of bytes32 value.
25    * @return result bytes32 value from byte array.
26    */
27   function readBytes32(
28     bytes memory b,
29     uint256 index
30   )
31     internal
32     pure
33     returns (bytes32 result)
34   {
35     // Arrays are prefixed by a 256 bit length parameter
36     index += 32;
37 
38     require(b.length >= index, "BytesLib: length");
39 
40     // Read the bytes32 from array memory
41     assembly {
42       result := mload(add(b, index))
43     }
44     return result;
45   }
46 }
47 
48 
49 
50 interface IERC1271Wallet {
51 	function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4 magicValue);
52 }
53 
54 library SignatureValidator {
55 	using LibBytes for bytes;
56 
57 	enum SignatureMode {
58 		EIP712,
59 		EthSign,
60 		SmartWallet,
61 		Spoof
62 	}
63 
64 	// bytes4(keccak256("isValidSignature(bytes32,bytes)"))
65 	bytes4 constant internal ERC1271_MAGICVALUE_BYTES32 = 0x1626ba7e;
66 
67 	function recoverAddr(bytes32 hash, bytes memory sig) internal view returns (address) {
68 		return recoverAddrImpl(hash, sig, false);
69 	}
70 
71 	function recoverAddrImpl(bytes32 hash, bytes memory sig, bool allowSpoofing) internal view returns (address) {
72 		require(sig.length >= 1, "SV_SIGLEN");
73 		uint8 modeRaw;
74 		unchecked { modeRaw = uint8(sig[sig.length - 1]); }
75 		SignatureMode mode = SignatureMode(modeRaw);
76 
77 		// {r}{s}{v}{mode}
78 		if (mode == SignatureMode.EIP712 || mode == SignatureMode.EthSign) {
79 			require(sig.length == 66, "SV_LEN");
80 			bytes32 r = sig.readBytes32(0);
81 			bytes32 s = sig.readBytes32(32);
82 			uint8 v = uint8(sig[64]);
83 			// Hesitant about this check: seems like this is something that has no business being checked on-chain
84 			require(v == 27 || v == 28, "SV_INVALID_V");
85 			if (mode == SignatureMode.EthSign) hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
86 			address signer = ecrecover(hash, v, r, s);
87 			require(signer != address(0), "SV_ZERO_SIG");
88 			return signer;
89 		// {sig}{verifier}{mode}
90 		} else if (mode == SignatureMode.SmartWallet) {
91 			// 32 bytes for the addr, 1 byte for the type = 33
92 			require(sig.length > 33, "SV_LEN_WALLET");
93 			uint newLen;
94 			unchecked {
95 				newLen = sig.length - 33;
96 			}
97 			IERC1271Wallet wallet = IERC1271Wallet(address(uint160(uint256(sig.readBytes32(newLen)))));
98 			sig.trimToSize(newLen);
99 			require(ERC1271_MAGICVALUE_BYTES32 == wallet.isValidSignature(hash, sig), "SV_WALLET_INVALID");
100 			return address(wallet);
101 		// {address}{mode}; the spoof mode is used when simulating calls
102 		} else if (mode == SignatureMode.Spoof && allowSpoofing) {
103 			require(tx.origin == address(1), "SV_SPOOF_ORIGIN");
104 			require(sig.length == 33, "SV_SPOOF_LEN");
105 			sig.trimToSize(32);
106 			return abi.decode(sig, (address));
107 		} else revert("SV_SIGMODE");
108 	}
109 }
110 
111 
112 contract Identity {
113 	mapping (address => bytes32) public privileges;
114 	// The next allowed nonce
115 	uint public nonce;
116 
117 	// Events
118 	event LogPrivilegeChanged(address indexed addr, bytes32 priv);
119 	event LogErr(address indexed to, uint value, bytes data, bytes returnData); // only used in tryCatch
120 
121 	// Transaction structure
122 	// we handle replay protection separately by requiring (address(this), chainID, nonce) as part of the sig
123 	struct Transaction {
124 		address to;
125 		uint value;
126 		bytes data;
127 	}
128 
129 	constructor(address[] memory addrs) {
130 		uint len = addrs.length;
131 		for (uint i=0; i<len; i++) {
132 			// @TODO should we allow setting to any arb value here?
133 			privileges[addrs[i]] = bytes32(uint(1));
134 			emit LogPrivilegeChanged(addrs[i], bytes32(uint(1)));
135 		}
136 	}
137 
138 	// This contract can accept ETH without calldata
139 	receive() external payable {}
140 
141 	// This contract can accept ETH with calldata
142 	// However, to support EIP 721 and EIP 1155, we need to respond to those methods with their own method signature
143 	fallback() external payable {
144 		bytes4 method = msg.sig;
145 		if (
146 			method == 0x150b7a02 // bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
147 				|| method == 0xf23a6e61 // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
148 				|| method == 0xbc197c81 // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
149 		) {
150 			// Copy back the method
151 			// solhint-disable-next-line no-inline-assembly
152 			assembly {
153 				calldatacopy(0, 0, 0x04)
154 				return (0, 0x20)
155 			}
156 		}
157 	}
158 
159 	function setAddrPrivilege(address addr, bytes32 priv)
160 		external
161 	{
162 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
163 		// Anti-bricking measure: if the privileges slot is used for special data (not 0x01),
164 		// don't allow to set it to true
165 		if (uint(privileges[addr]) > 1) require(priv != bytes32(uint(1)), 'UNSETTING_SPECIAL_DATA');
166 		privileges[addr] = priv;
167 		emit LogPrivilegeChanged(addr, priv);
168 	}
169 
170 	function tipMiner(uint amount)
171 		external
172 	{
173 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
174 		// See https://docs.flashbots.net/flashbots-auction/searchers/advanced/coinbase-payment/#managing-payments-to-coinbaseaddress-when-it-is-a-contract
175 		// generally this contract is reentrancy proof cause of the nonce
176 		executeCall(block.coinbase, amount, new bytes(0));
177 	}
178 
179 	function tryCatch(address to, uint value, bytes calldata data)
180 		external
181 	{
182 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
183 		(bool success, bytes memory returnData) = to.call{value: value, gas: gasleft()}(data);
184 		if (!success) emit LogErr(to, value, data, returnData);
185 	}
186 
187 
188 	// WARNING: if the signature of this is changed, we have to change IdentityFactory
189 	function execute(Transaction[] calldata txns, bytes calldata signature)
190 		external
191 	{
192 		require(txns.length > 0, 'MUST_PASS_TX');
193 		uint currentNonce = nonce;
194 		// NOTE: abi.encode is safer than abi.encodePacked in terms of collision safety
195 		bytes32 hash = keccak256(abi.encode(address(this), block.chainid, currentNonce, txns));
196 		// We have to increment before execution cause it protects from reentrancies
197 		nonce = currentNonce + 1;
198 
199 		address signer = SignatureValidator.recoverAddrImpl(hash, signature, true);
200 		require(privileges[signer] != bytes32(0), 'INSUFFICIENT_PRIVILEGE');
201 		uint len = txns.length;
202 		for (uint i=0; i<len; i++) {
203 			Transaction memory txn = txns[i];
204 			executeCall(txn.to, txn.value, txn.data);
205 		}
206 		// The actual anti-bricking mechanism - do not allow a signer to drop their own priviledges
207 		require(privileges[signer] != bytes32(0), 'PRIVILEGE_NOT_DOWNGRADED');
208 	}
209 
210 	// no need for nonce management here cause we're not dealing with sigs
211 	function executeBySender(Transaction[] calldata txns) external {
212 		require(txns.length > 0, 'MUST_PASS_TX');
213 		require(privileges[msg.sender] != bytes32(0), 'INSUFFICIENT_PRIVILEGE');
214 		uint len = txns.length;
215 		for (uint i=0; i<len; i++) {
216 			Transaction memory txn = txns[i];
217 			executeCall(txn.to, txn.value, txn.data);
218 		}
219 		// again, anti-bricking
220 		require(privileges[msg.sender] != bytes32(0), 'PRIVILEGE_NOT_DOWNGRADED');
221 	}
222 
223 	function executeBySelf(Transaction[] calldata txns) external {
224 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
225 		require(txns.length > 0, 'MUST_PASS_TX');
226 		uint len = txns.length;
227 		for (uint i=0; i<len; i++) {
228 			Transaction memory txn = txns[i];
229 			executeCall(txn.to, txn.value, txn.data);
230 		}
231 	}
232 
233 	// we shouldn't use address.call(), cause: https://github.com/ethereum/solidity/issues/2884
234 	// copied from https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol
235 	// there's also
236 	// https://github.com/gnosis/MultiSigWallet/commit/e1b25e8632ca28e9e9e09c81bd20bf33fdb405ce
237 	// https://github.com/austintgriffith/bouncer-proxy/blob/master/BouncerProxy/BouncerProxy.sol
238 	// https://github.com/gnosis/safe-contracts/blob/7e2eeb3328bb2ae85c36bc11ea6afc14baeb663c/contracts/base/Executor.sol
239 	function executeCall(address to, uint256 value, bytes memory data)
240 		internal
241 	{
242 		assembly {
243 			let result := call(gas(), to, value, add(data, 0x20), mload(data), 0, 0)
244 
245 			switch result case 0 {
246 				let size := returndatasize()
247 				let ptr := mload(0x40)
248 				returndatacopy(ptr, 0, size)
249 				revert(ptr, size)
250 			}
251 			default {}
252 		}
253 		// A single call consumes around 477 more gas with the pure solidity version, for whatever reason
254 		// WARNING: do not use this, it corrupts the returnData string (returns it in a slightly different format)
255 		//(bool success, bytes memory returnData) = to.call{value: value, gas: gasleft()}(data);
256 		//if (!success) revert(string(data));
257 	}
258 
259 	// EIP 1271 implementation
260 	// see https://eips.ethereum.org/EIPS/eip-1271
261 	function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4) {
262 		if (privileges[SignatureValidator.recoverAddr(hash, signature)] != bytes32(0)) {
263 			// bytes4(keccak256("isValidSignature(bytes32,bytes)")
264 			return 0x1626ba7e;
265 		} else {
266 			return 0xffffffff;
267 		}
268 	}
269 
270 	// EIP 1155 implementation
271 	// we pretty much only need to signal that we support the interface for 165, but for 1155 we also need the fallback function
272 	function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
273 		return
274 			interfaceID == 0x01ffc9a7 ||    // ERC-165 support (i.e. `bytes4(keccak256('supportsInterface(bytes4)'))`).
275 			interfaceID == 0x4e2312e0;      // ERC-1155 `ERC1155TokenReceiver` support (i.e. `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) ^ bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`).
276 	}
277 }
278 
279 interface IERC20 {
280     function totalSupply() external view returns (uint256);
281     function balanceOf(address account) external view returns (uint256);
282     function transfer(address recipient, uint256 amount) external returns (bool);
283     function allowance(address owner, address spender) external view returns (uint256);
284     function approve(address spender, uint256 amount) external returns (bool);
285     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
286     event Transfer(address indexed from, address indexed to, uint256 value);
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 
291 contract QuickAccManager {
292 	// Note: nonces are scoped by identity rather than by accHash - the reason for this is that there's no reason to scope them by accHash,
293 	// we merely need them for replay protection
294 	mapping (address => uint) public nonces;
295 	mapping (bytes32 => uint) public scheduled;
296 
297 	bytes4 constant CANCEL_PREFIX = 0xc47c3100;
298 
299 	// Events
300 	// we only need those for timelocked stuff so we can show scheduled txns to the user; the oens that get executed immediately do not need logs
301 	event LogScheduled(bytes32 indexed txnHash, bytes32 indexed accHash, address indexed signer, uint nonce, uint time, Identity.Transaction[] txns);
302 	event LogCancelled(bytes32 indexed txnHash, bytes32 indexed accHash, address indexed signer, uint time);
303 	event LogExecScheduled(bytes32 indexed txnHash, bytes32 indexed accHash, uint time);
304 
305 	// EIP 2612
306 	/// @notice Chain Id at this contract's deployment.
307 	uint256 internal immutable DOMAIN_SEPARATOR_CHAIN_ID;
308 	/// @notice EIP-712 typehash for this contract's domain at deployment.
309 	bytes32 internal immutable _DOMAIN_SEPARATOR;
310 
311 	constructor() {
312 		DOMAIN_SEPARATOR_CHAIN_ID = block.chainid;
313 		_DOMAIN_SEPARATOR = calculateDomainSeparator();
314 	}
315 
316 	struct QuickAccount {
317 		uint timelock;
318 		address one;
319 		address two;
320 		// We decided to not allow certain options here such as ability to skip the second sig for send(), but leaving this a struct rather than a tuple
321 		// for clarity and to ensure it's future proof
322 	}
323 	struct DualSig {
324 		bool isBothSigned;
325 		bytes one;
326 		bytes two;
327 	}
328 
329 	// NOTE: a single accHash can control multiple identities, as long as those identities set it's hash in privileges[address(this)]
330 	// this is by design
331 
332 	// isBothSigned is hashed in so that we don't allow signatures from two-sig txns to be reused for single sig txns,
333 	// ...potentially frontrunning a normal two-sig transaction and making it wait
334 	// WARNING: if the signature of this is changed, we have to change IdentityFactory
335 	function send(Identity identity, QuickAccount calldata acc, DualSig calldata sigs, Identity.Transaction[] calldata txns) external {
336 		bytes32 accHash = keccak256(abi.encode(acc));
337 		require(identity.privileges(address(this)) == accHash, 'WRONG_ACC_OR_NO_PRIV');
338 		uint initialNonce = nonces[address(identity)]++;
339 		// Security: we must also hash in the hash of the QuickAccount, otherwise the sig of one key can be reused across multiple accs
340 		bytes32 hash = keccak256(abi.encode(
341 			address(this),
342 			block.chainid,
343 			address(identity),
344 			accHash,
345 			initialNonce,
346 			txns,
347 			sigs.isBothSigned
348 		));
349 		if (sigs.isBothSigned) {
350 			require(acc.one == SignatureValidator.recoverAddr(hash, sigs.one), 'SIG_ONE');
351 			require(acc.two == SignatureValidator.recoverAddr(hash, sigs.two), 'SIG_TWO');
352 			identity.executeBySender(txns);
353 		} else {
354 			address signer = SignatureValidator.recoverAddr(hash, sigs.one);
355 			require(acc.one == signer || acc.two == signer, 'SIG');
356 			// no need to check whether `scheduled[hash]` is already set here cause of the incrementing nonce
357 			scheduled[hash] = block.timestamp + acc.timelock;
358 			emit LogScheduled(hash, accHash, signer, initialNonce, block.timestamp, txns);
359 		}
360 	}
361 
362 	function cancel(Identity identity, QuickAccount calldata acc, uint nonce, bytes calldata sig, Identity.Transaction[] calldata txns) external {
363 		bytes32 accHash = keccak256(abi.encode(acc));
364 		require(identity.privileges(address(this)) == accHash, 'WRONG_ACC_OR_NO_PRIV');
365 
366 		bytes32 hash = keccak256(abi.encode(CANCEL_PREFIX, address(this), block.chainid, address(identity), accHash, nonce, txns, false));
367 		address signer = SignatureValidator.recoverAddr(hash, sig);
368 		require(signer == acc.one || signer == acc.two, 'INVALID_SIGNATURE');
369 
370 		// @NOTE: should we allow cancelling even when it's matured? probably not, otherwise there's a minor grief
371 		// opportunity: someone wants to cancel post-maturity, and you front them with execScheduled
372 		bytes32 hashTx = keccak256(abi.encode(address(this), block.chainid, accHash, nonce, txns, false));
373 		uint scheduledTime = scheduled[hashTx];
374 		require(scheduledTime != 0 && block.timestamp < scheduledTime, 'TOO_LATE');
375 		delete scheduled[hashTx];
376 
377 		emit LogCancelled(hashTx, accHash, signer, block.timestamp);
378 	}
379 
380 	function execScheduled(Identity identity, bytes32 accHash, uint nonce, Identity.Transaction[] calldata txns) external {
381 		require(identity.privileges(address(this)) == accHash, 'WRONG_ACC_OR_NO_PRIV');
382 
383 		bytes32 hash = keccak256(abi.encode(address(this), block.chainid, address(identity), accHash, nonce, txns, false));
384 		uint scheduledTime = scheduled[hash];
385 		require(scheduledTime != 0 && block.timestamp >= scheduledTime, 'NOT_TIME');
386 
387 		delete scheduled[hash];
388 		identity.executeBySender(txns);
389 
390 		emit LogExecScheduled(hash, accHash, block.timestamp);
391 	}
392 
393 	// EIP 1271 implementation
394 	// see https://eips.ethereum.org/EIPS/eip-1271
395 	// NOTE: this method is not intended to be called from off-chain eth_calls; technically it's not a clean EIP 1271
396 	// ...implementation, because EIP1271 assumes every smart wallet implements that method, while this contract is not a smart wallet
397 	function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4) {
398 		(uint timelock, bytes memory sig1, bytes memory sig2) = abi.decode(signature, (uint, bytes, bytes));
399 		bytes32 accHash = keccak256(abi.encode(QuickAccount({
400 			timelock: timelock,
401 			one: SignatureValidator.recoverAddr(hash, sig1),
402 			two: SignatureValidator.recoverAddr(hash, sig2)
403 		})));
404 		if (Identity(payable(address(msg.sender))).privileges(address(this)) == accHash) {
405 			// bytes4(keccak256("isValidSignature(bytes32,bytes)")
406 			return 0x1626ba7e;
407 		} else {
408 			return 0xffffffff;
409 		}
410 	}
411 
412 
413 	// EIP 712 methods
414 	// all of the following are 2/2 only
415 	struct DualSigAlwaysBoth {
416 		bytes one;
417 		bytes two;
418 	}
419 
420 	function calculateDomainSeparator() internal view returns (bytes32) {
421 		return keccak256(
422 			abi.encode(
423 				keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
424 				// @TODO: maybe we should use a more user friendly name here?
425 				keccak256(bytes('QuickAccManager')),
426 				keccak256(bytes('1')),
427 				block.chainid,
428 				address(this)
429 			)
430 		);
431 	}
432 
433 	/// @notice EIP-712 typehash for this contract's domain.
434 	function DOMAIN_SEPARATOR() public view returns (bytes32) {
435 		return block.chainid == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : calculateDomainSeparator();
436 	}
437 
438 	bytes32 private constant TRANSFER_TYPEHASH = keccak256('Transfer(address tokenAddr,address to,uint256 value,uint256 fee,address identity,uint256 nonce)');
439 	struct Transfer { address token; address to; uint amount; uint fee; }
440 	// WARNING: if the signature of this is changed, we have to change IdentityFactory
441 	function sendTransfer(Identity identity, QuickAccount calldata acc, DualSigAlwaysBoth calldata sigs, Transfer calldata t) external {
442 		require(identity.privileges(address(this)) == keccak256(abi.encode(acc)), 'WRONG_ACC_OR_NO_PRIV');
443 
444 		bytes32 hash = keccak256(abi.encodePacked(
445 			'\x19\x01',
446 			DOMAIN_SEPARATOR(),
447 			keccak256(abi.encode(TRANSFER_TYPEHASH, t.token, t.to, t.amount, t.fee, address(identity), nonces[address(identity)]++))
448 		));
449 		require(acc.one == SignatureValidator.recoverAddr(hash, sigs.one), 'SIG_ONE');
450 		require(acc.two == SignatureValidator.recoverAddr(hash, sigs.two), 'SIG_TWO');
451 		Identity.Transaction[] memory txns = new Identity.Transaction[](2);
452 		txns[0].to = t.token;
453 		txns[0].data = abi.encodeWithSelector(IERC20.transfer.selector, t.to, t.amount);
454 		txns[1].to = t.token;
455 		txns[1].data = abi.encodeWithSelector(IERC20.transfer.selector, msg.sender, t.fee);
456 		identity.executeBySender(txns);
457 	}
458 
459 	// Reference for arrays: https://github.com/sportx-bet/smart-contracts/blob/e36965a0c4748bf73ae15ed3cab5660c9cf722e1/contracts/impl/trading/EIP712FillHasher.sol
460 	// and https://eips.ethereum.org/EIPS/eip-712
461 	// and for signTypedData_v4: https://gist.github.com/danfinlay/750ce1e165a75e1c3387ec38cf452b71
462 	struct Txn { string description; address to; uint value; bytes data; }
463 	bytes32 private constant TXNS_TYPEHASH = keccak256('Txn(string description,address to,uint256 value,bytes data)');
464 	bytes32 private constant BUNDLE_TYPEHASH = keccak256('Bundle(address identity,uint256 nonce,Txn[] transactions)');
465 	// WARNING: if the signature of this is changed, we have to change IdentityFactory
466 	function sendTxns(Identity identity, QuickAccount calldata acc, DualSigAlwaysBoth calldata sigs, Txn[] calldata txns) external {
467 		require(identity.privileges(address(this)) == keccak256(abi.encode(acc)), 'WRONG_ACC_OR_NO_PRIV');
468 
469 		// hashing + prepping args
470 		bytes32[] memory txnBytes = new bytes32[](txns.length);
471 		Identity.Transaction[] memory identityTxns = new Identity.Transaction[](txns.length);
472 		uint txnLen = txns.length;
473 		for (uint256 i = 0; i < txnLen; i++) {
474 			txnBytes[i] = keccak256(abi.encode(TXNS_TYPEHASH, txns[i].description, txns[i].to, txns[i].value, txns[i].data));
475 			identityTxns[i].to = txns[i].to;
476 			identityTxns[i].value = txns[i].value;
477 			identityTxns[i].data = txns[i].data;
478 		}
479 		bytes32 txnsHash = keccak256(abi.encodePacked(txnBytes));
480 		bytes32 hash = keccak256(abi.encodePacked(
481 			'\x19\x01',
482 			DOMAIN_SEPARATOR(),
483 			keccak256(abi.encode(BUNDLE_TYPEHASH, address(identity), nonces[address(identity)]++, txnsHash))
484 		));
485 		require(acc.one == SignatureValidator.recoverAddr(hash, sigs.one), 'SIG_ONE');
486 		require(acc.two == SignatureValidator.recoverAddr(hash, sigs.two), 'SIG_TWO');
487 		identity.executeBySender(identityTxns);
488 	}
489 
490 }