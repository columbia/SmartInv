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