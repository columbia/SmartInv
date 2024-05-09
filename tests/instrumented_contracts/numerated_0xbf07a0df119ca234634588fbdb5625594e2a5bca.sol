1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.7;
3 
4 // @TODO: Formatting
5 library LibBytes {
6   // @TODO: see if we can just set .length = 
7   function trimToSize(bytes memory b, uint newLen)
8     internal
9     pure
10   {
11     require(b.length > newLen, "BytesLib: only shrinking");
12     assembly {
13       mstore(b, newLen)
14     }
15   }
16 
17 
18   /***********************************|
19   |        Read Bytes Functions       |
20   |__________________________________*/
21 
22   /**
23    * @dev Reads a bytes32 value from a position in a byte array.
24    * @param b Byte array containing a bytes32 value.
25    * @param index Index in byte array of bytes32 value.
26    * @return result bytes32 value from byte array.
27    */
28   function readBytes32(
29     bytes memory b,
30     uint256 index
31   )
32     internal
33     pure
34     returns (bytes32 result)
35   {
36     // Arrays are prefixed by a 256 bit length parameter
37     index += 32;
38 
39     require(b.length >= index, "BytesLib: length");
40 
41     // Read the bytes32 from array memory
42     assembly {
43       result := mload(add(b, index))
44     }
45     return result;
46   }
47 }
48 
49 
50 
51 interface IERC1271Wallet {
52 	function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4 magicValue);
53 }
54 
55 library SignatureValidator {
56 	using LibBytes for bytes;
57 
58 	enum SignatureMode {
59 		EIP712,
60 		EthSign,
61 		SmartWallet,
62 		Spoof
63 	}
64 
65 	// bytes4(keccak256("isValidSignature(bytes32,bytes)"))
66 	bytes4 constant internal ERC1271_MAGICVALUE_BYTES32 = 0x1626ba7e;
67 
68 	function recoverAddr(bytes32 hash, bytes memory sig) internal view returns (address) {
69 		return recoverAddrImpl(hash, sig, false);
70 	}
71 
72 	function recoverAddrImpl(bytes32 hash, bytes memory sig, bool allowSpoofing) internal view returns (address) {
73 		require(sig.length >= 1, "SV_SIGLEN");
74 		uint8 modeRaw;
75 		unchecked { modeRaw = uint8(sig[sig.length - 1]); }
76 		SignatureMode mode = SignatureMode(modeRaw);
77 
78 		// {r}{s}{v}{mode}
79 		if (mode == SignatureMode.EIP712 || mode == SignatureMode.EthSign) {
80 			require(sig.length == 66, "SV_LEN");
81 			bytes32 r = sig.readBytes32(0);
82 			bytes32 s = sig.readBytes32(32);
83 			uint8 v = uint8(sig[64]);
84 			// Hesitant about this check: seems like this is something that has no business being checked on-chain
85 			require(v == 27 || v == 28, "SV_INVALID_V");
86 			if (mode == SignatureMode.EthSign) hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
87 			address signer = ecrecover(hash, v, r, s);
88 			require(signer != address(0), "SV_ZERO_SIG");
89 			return signer;
90 		// {sig}{verifier}{mode}
91 		} else if (mode == SignatureMode.SmartWallet) {
92 			// 32 bytes for the addr, 1 byte for the type = 33
93 			require(sig.length > 33, "SV_LEN_WALLET");
94 			uint newLen;
95 			unchecked {
96 				newLen = sig.length - 33;
97 			}
98 			IERC1271Wallet wallet = IERC1271Wallet(address(uint160(uint256(sig.readBytes32(newLen)))));
99 			sig.trimToSize(newLen);
100 			require(ERC1271_MAGICVALUE_BYTES32 == wallet.isValidSignature(hash, sig), "SV_WALLET_INVALID");
101 			return address(wallet);
102 		// {address}{mode}; the spoof mode is used when simulating calls
103 		} else if (mode == SignatureMode.Spoof && allowSpoofing) {
104 			require(tx.origin == address(1), "SV_SPOOF_ORIGIN");
105 			require(sig.length == 33, "SV_SPOOF_LEN");
106 			sig.trimToSize(32);
107 			return abi.decode(sig, (address));
108 		} else revert("SV_SIGMODE");
109 	}
110 }
111 
112 
113 contract Identity {
114 	mapping (address => bytes32) public privileges;
115 	// The next allowed nonce
116 	uint public nonce;
117 
118 	// Events
119 	event LogPrivilegeChanged(address indexed addr, bytes32 priv);
120 	event LogErr(address indexed to, uint value, bytes data, bytes returnData); // only used in tryCatch
121 
122 	// Transaction structure
123 	// we handle replay protection separately by requiring (address(this), chainID, nonce) as part of the sig
124 	struct Transaction {
125 		address to;
126 		uint value;
127 		bytes data;
128 	}
129 
130 	constructor(address[] memory addrs) {
131 		uint len = addrs.length;
132 		for (uint i=0; i<len; i++) {
133 			// @TODO should we allow setting to any arb value here?
134 			privileges[addrs[i]] = bytes32(uint(1));
135 			emit LogPrivilegeChanged(addrs[i], bytes32(uint(1)));
136 		}
137 	}
138 
139 	// This contract can accept ETH without calldata
140 	receive() external payable {}
141 
142 	// This contract can accept ETH with calldata
143 	// However, to support EIP 721 and EIP 1155, we need to respond to those methods with their own method signature
144 	fallback() external payable {
145 		bytes4 method = msg.sig;
146 		if (
147 			method == 0x150b7a02 // bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
148 				|| method == 0xf23a6e61 // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
149 				|| method == 0xbc197c81 // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
150 		) {
151 			// Copy back the method
152 			// solhint-disable-next-line no-inline-assembly
153 			assembly {
154 				calldatacopy(0, 0, 0x04)
155 				return (0, 0x20)
156 			}
157 		}
158 	}
159 
160 	function setAddrPrivilege(address addr, bytes32 priv)
161 		external
162 	{
163 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
164 		// Anti-bricking measure: if the privileges slot is used for special data (not 0x01),
165 		// don't allow to set it to true
166 		if (uint(privileges[addr]) > 1) require(priv != bytes32(uint(1)), 'UNSETTING_SPECIAL_DATA');
167 		privileges[addr] = priv;
168 		emit LogPrivilegeChanged(addr, priv);
169 	}
170 
171 	function tipMiner(uint amount)
172 		external
173 	{
174 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
175 		// See https://docs.flashbots.net/flashbots-auction/searchers/advanced/coinbase-payment/#managing-payments-to-coinbaseaddress-when-it-is-a-contract
176 		// generally this contract is reentrancy proof cause of the nonce
177 		executeCall(block.coinbase, amount, new bytes(0));
178 	}
179 
180 	function tryCatch(address to, uint value, bytes calldata data)
181 		external
182 	{
183 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
184 		(bool success, bytes memory returnData) = to.call{value: value, gas: gasleft()}(data);
185 		if (!success) emit LogErr(to, value, data, returnData);
186 	}
187 
188 
189 	// WARNING: if the signature of this is changed, we have to change IdentityFactory
190 	function execute(Transaction[] calldata txns, bytes calldata signature)
191 		external
192 	{
193 		require(txns.length > 0, 'MUST_PASS_TX');
194 		uint currentNonce = nonce;
195 		// NOTE: abi.encode is safer than abi.encodePacked in terms of collision safety
196 		bytes32 hash = keccak256(abi.encode(address(this), block.chainid, currentNonce, txns));
197 		// We have to increment before execution cause it protects from reentrancies
198 		nonce = currentNonce + 1;
199 
200 		address signer = SignatureValidator.recoverAddrImpl(hash, signature, true);
201 		require(privileges[signer] != bytes32(0), 'INSUFFICIENT_PRIVILEGE');
202 		uint len = txns.length;
203 		for (uint i=0; i<len; i++) {
204 			Transaction memory txn = txns[i];
205 			executeCall(txn.to, txn.value, txn.data);
206 		}
207 		// The actual anti-bricking mechanism - do not allow a signer to drop their own priviledges
208 		require(privileges[signer] != bytes32(0), 'PRIVILEGE_NOT_DOWNGRADED');
209 	}
210 
211 	// no need for nonce management here cause we're not dealing with sigs
212 	function executeBySender(Transaction[] calldata txns) external {
213 		require(txns.length > 0, 'MUST_PASS_TX');
214 		require(privileges[msg.sender] != bytes32(0), 'INSUFFICIENT_PRIVILEGE');
215 		uint len = txns.length;
216 		for (uint i=0; i<len; i++) {
217 			Transaction memory txn = txns[i];
218 			executeCall(txn.to, txn.value, txn.data);
219 		}
220 		// again, anti-bricking
221 		require(privileges[msg.sender] != bytes32(0), 'PRIVILEGE_NOT_DOWNGRADED');
222 	}
223 
224 	function executeBySelf(Transaction[] calldata txns) external {
225 		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
226 		require(txns.length > 0, 'MUST_PASS_TX');
227 		uint len = txns.length;
228 		for (uint i=0; i<len; i++) {
229 			Transaction memory txn = txns[i];
230 			executeCall(txn.to, txn.value, txn.data);
231 		}
232 	}
233 
234 	// we shouldn't use address.call(), cause: https://github.com/ethereum/solidity/issues/2884
235 	// copied from https://github.com/uport-project/uport-identity/blob/develop/contracts/Proxy.sol
236 	// there's also
237 	// https://github.com/gnosis/MultiSigWallet/commit/e1b25e8632ca28e9e9e09c81bd20bf33fdb405ce
238 	// https://github.com/austintgriffith/bouncer-proxy/blob/master/BouncerProxy/BouncerProxy.sol
239 	// https://github.com/gnosis/safe-contracts/blob/7e2eeb3328bb2ae85c36bc11ea6afc14baeb663c/contracts/base/Executor.sol
240 	function executeCall(address to, uint256 value, bytes memory data)
241 		internal
242 	{
243 		assembly {
244 			let result := call(gas(), to, value, add(data, 0x20), mload(data), 0, 0)
245 
246 			switch result case 0 {
247 				let size := returndatasize()
248 				let ptr := mload(0x40)
249 				returndatacopy(ptr, 0, size)
250 				revert(ptr, size)
251 			}
252 			default {}
253 		}
254 		// A single call consumes around 477 more gas with the pure solidity version, for whatever reason
255 		// WARNING: do not use this, it corrupts the returnData string (returns it in a slightly different format)
256 		//(bool success, bytes memory returnData) = to.call{value: value, gas: gasleft()}(data);
257 		//if (!success) revert(string(data));
258 	}
259 
260 	// EIP 1271 implementation
261 	// see https://eips.ethereum.org/EIPS/eip-1271
262 	function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4) {
263 		if (privileges[SignatureValidator.recoverAddr(hash, signature)] != bytes32(0)) {
264 			// bytes4(keccak256("isValidSignature(bytes32,bytes)")
265 			return 0x1626ba7e;
266 		} else {
267 			return 0xffffffff;
268 		}
269 	}
270 
271 	// EIP 1155 implementation
272 	// we pretty much only need to signal that we support the interface for 165, but for 1155 we also need the fallback function
273 	function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
274 		return
275 			interfaceID == 0x01ffc9a7 ||    // ERC-165 support (i.e. `bytes4(keccak256('supportsInterface(bytes4)'))`).
276 			interfaceID == 0x4e2312e0;      // ERC-1155 `ERC1155TokenReceiver` support (i.e. `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) ^ bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`).
277 	}
278 }
279 
280 interface IERC20 {
281     function totalSupply() external view returns (uint256);
282     function balanceOf(address account) external view returns (uint256);
283     function transfer(address recipient, uint256 amount) external returns (bool);
284     function allowance(address owner, address spender) external view returns (uint256);
285     function approve(address spender, uint256 amount) external returns (bool);
286     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
287     event Transfer(address indexed from, address indexed to, uint256 value);
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 
292 contract IdentityFactory {
293 	event LogDeployed(address addr, uint256 salt);
294 
295 	address public immutable allowedToDrain;
296 	constructor(address allowed) {
297 		allowedToDrain = allowed;
298 	}
299 
300 	function deploy(bytes calldata code, uint256 salt) external {
301 		deploySafe(code, salt);
302 	}
303 
304 	// When the relayer needs to act upon an /identity/:addr/submit call, it'll either call execute on the Identity directly
305 	// if it's already deployed, or call `deployAndExecute` if the account is still counterfactual
306 	// we can't have deployAndExecuteBySender, because the sender will be the factory
307 	function deployAndExecute(
308 		bytes calldata code, uint256 salt,
309 		Identity.Transaction[] calldata txns, bytes calldata signature
310 	) external {
311 		address payable addr = payable(deploySafe(code, salt));
312 		Identity(addr).execute(txns, signature);
313 	}
314 	// but for the quick accounts we need this
315 	function deployAndCall(bytes calldata code, uint256 salt, address callee, bytes calldata data) external {
316 		deploySafe(code, salt);
317 		require(data.length > 4, 'DATA_LEN');
318 		bytes4 method;
319 		// solium-disable-next-line security/no-inline-assembly
320 		assembly {
321 			// can also do shl(224, shr(224, calldataload(0)))
322 			method := and(calldataload(data.offset), 0xffffffff00000000000000000000000000000000000000000000000000000000)
323 		}
324 		require(
325 			method == 0x6171d1c9 // execute((address,uint256,bytes)[],bytes)
326 			|| method == 0x534255ff // send(address,(uint256,address,address),(bool,bytes,bytes),(address,uint256,bytes)[])
327 			|| method == 0x4b776c6d // sendTransfer(address,(uint256,address,address),(bytes,bytes),(address,address,uint256,uint256))
328 			|| method == 0x63486689 // sendTxns(address,(uint256,address,address),(bytes,bytes),(string,address,uint256,bytes)[])
329 		, 'INVALID_METHOD');
330 
331 		assembly {
332 			let dataPtr := mload(0x40)
333 			calldatacopy(dataPtr, data.offset, data.length)
334 			let result := call(gas(), callee, 0, dataPtr, data.length, 0, 0)
335 
336 			switch result case 0 {
337 				let size := returndatasize()
338 				let ptr := mload(0x40)
339 				returndatacopy(ptr, 0, size)
340 				revert(ptr, size)
341 			}
342 			default {}
343 		}
344 	}
345 
346 
347 	// Withdraw the earnings from various fees (deploy fees and execute fees earned cause of `deployAndExecute`)
348 	// although we do not use this since we no longer receive fees on the factory, it's good to have this for safety
349 	// In practice, we (almost) never receive fees on the factory, but there's one exception: QuickAccManager EIP 712 methods (sendTransfer) + deployAndCall
350 	function withdraw(IERC20 token, address to, uint256 tokenAmount) external {
351 		require(msg.sender == allowedToDrain, 'ONLY_AUTHORIZED');
352 		token.transfer(to, tokenAmount);
353 	}
354 
355 	// This is done to mitigate possible frontruns where, for example, deploying the same code/salt via deploy()
356 	// would make a pending deployAndExecute fail
357 	// The way we mitigate that is by checking if the contract is already deployed and if so, we continue execution
358 	function deploySafe(bytes memory code, uint256 salt) internal returns (address) {
359 		address expectedAddr = address(uint160(uint256(
360 			keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(code)))
361 		)));
362 		uint size;
363 		assembly { size := extcodesize(expectedAddr) }
364 		// If there is code at that address, we can assume it's the one we were about to deploy,
365 		// because of how CREATE2 and keccak256 works
366 		if (size == 0) {
367 			address addr;
368 			assembly { addr := create2(0, add(code, 0x20), mload(code), salt) }
369 			require(addr != address(0), 'FAILED_DEPLOYING');
370 			require(addr == expectedAddr, 'FAILED_MATCH');
371 			emit LogDeployed(addr, salt);
372 		}
373 		return expectedAddr;
374 	}
375 }