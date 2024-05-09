1 /*
2 
3 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKOOXWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx;'..;o0WNKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK;.''...;l;',oXMMMMMMMMMN00XMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMNOx0WMMMMMMMMMMMMMMWNd..''.  .....xNWMMMMMWOc:;c0MMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMXl;c:oKMMMMMMMWX0xol:;,...'...'....';:lox00o:d0k,lNMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMx,oKOl:xNMMNOoc,..........................'cOXKO;:KMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMWd,oxOKxccdl;..........................  ..,kKxdx:;KMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMWd.':xXXKd, .......................... ..,dcckd:,.'kWMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMM0,,xkkKX0c'.  ....................... ,o;cOOOOx;...oXMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMWo',,l0Kdlxc. .......    ............ .cddk0Ox:. ...cXMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMKxdx00c.:k0KK0d. ......   ..  ............ .,ldxl,. .....oWMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMKc,;;;c;..:odl;. .....   .,:;'.    .........  ....  ..... ,KMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMNd,::cc,. . ..   ....   .';ccc:;'...   ................... ,KWX0kxdokNMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMKc,:,,;'  .......    ..,:cccccccc::;'...     ...........  .lkl:,'''',xWMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMM0:;c:,'.        ....,;:cccccccccccccc::;'.....        .....',',,''','cXMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMXc,ccc,.......',,;::ccccccccccccccccccccc:::;;,,'''''',,,,..,,'..',,':0MMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMWk;;cc;';:::::;,,'',:ccccccccccccccccccccc:;''.',:ccccc:;,,,'..',,,,';0MMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMNx;;:,':cccc,.;c.  .;ccccccccccccccccccc;..:;   'ccccc:;,,'.',,,,,,'cKMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMW0l,.,:cccc'       'ccccccccccccccccccc, .,'   .:cccc:,,'.',,,,,,',xWMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMNk;,:cccc;.     .;ccccccccccccccccccc:.     .;ccccc;,,,',,,,,,';xNMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMNo,:cccccc;,,,;ccccccccccccccccccccccc;,,,;:ccccc:;,,,,,,,',:dKWMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMWx,:cccccccccccccccccccccccccccccccccccccccccccc:;,,'',;:ldOXWMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMM0:;cccccccccccccccccccccccc;',',:cccccccccccccc:,,,.:OXNWMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMWd,;cccccccccccccccccccccc,',ox,':ccccccccccc:;,,,':0WMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMXo,:cccccccccccc:,,,,,,,'.'cdx;.:cccccccccc:;,,,':0WMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMXo,;ccccccccccc:;,,,,,,,'''',',:cccccccc::;,,''lKWMMMMMMMMMMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMMMMMNx:;:cccccccccccccccccccccccccccccccc::;,,,':xNMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMWKd:;:ccccccccccccccccccccccccccc::;;,,'':dXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxl;;;::ccccccccccccccccc::::;;,,'';lkXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKxoc;,,;;;:::::::::;;;;,,''',:okKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOxolc::;,,,,,,,,;::lodkKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKK000000KKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
44 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
45 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
46 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
47 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
48 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
49 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
50 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
51 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
52 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
53 
54 */
55 
56 //SPDX-License-Identifier: MIT
57 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
58 
59 pragma solidity >=0.5.0;
60 
61 interface ILayerZeroUserApplicationConfig {
62     // @notice set the configuration of the LayerZero messaging library of the specified version
63     // @param _version - messaging library version
64     // @param _chainId - the chainId for the pending config change
65     // @param _configType - type of configuration. every messaging library has its own convention.
66     // @param _config - configuration in the bytes. can encode arbitrary content.
67     function setConfig(
68         uint16 _version,
69         uint16 _chainId,
70         uint256 _configType,
71         bytes calldata _config
72     ) external;
73 
74     // @notice set the send() LayerZero messaging library version to _version
75     // @param _version - new messaging library version
76     function setSendVersion(uint16 _version) external;
77 
78     // @notice set the lzReceive() LayerZero messaging library version to _version
79     // @param _version - new messaging library version
80     function setReceiveVersion(uint16 _version) external;
81 
82     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
83     // @param _srcChainId - the chainId of the source chain
84     // @param _srcAddress - the contract address of the source contract at the source chain
85     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
86         external;
87 }
88 
89 // File: contracts/interfaces/ILayerZeroEndpoint.sol
90 
91 pragma solidity >=0.5.0;
92 
93 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
94     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
95     // @param _dstChainId - the destination chain identifier
96     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
97     // @param _payload - a custom bytes payload to send to the destination contract
98     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
99     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
100     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
101     function send(
102         uint16 _dstChainId,
103         bytes calldata _destination,
104         bytes calldata _payload,
105         address payable _refundAddress,
106         address _zroPaymentAddress,
107         bytes calldata _adapterParams
108     ) external payable;
109 
110     // @notice used by the messaging library to publish verified payload
111     // @param _srcChainId - the source chain identifier
112     // @param _srcAddress - the source contract (as bytes) at the source chain
113     // @param _dstAddress - the address on destination chain
114     // @param _nonce - the unbound message ordering nonce
115     // @param _gasLimit - the gas limit for external contract execution
116     // @param _payload - verified payload to send to the destination contract
117     function receivePayload(
118         uint16 _srcChainId,
119         bytes calldata _srcAddress,
120         address _dstAddress,
121         uint64 _nonce,
122         uint256 _gasLimit,
123         bytes calldata _payload
124     ) external;
125 
126     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
127     // @param _srcChainId - the source chain identifier
128     // @param _srcAddress - the source chain contract address
129     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
130         external
131         view
132         returns (uint64);
133 
134     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
135     // @param _srcAddress - the source chain contract address
136     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
137         external
138         view
139         returns (uint64);
140 
141     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
142     // @param _dstChainId - the destination chain identifier
143     // @param _userApplication - the user app address on this EVM chain
144     // @param _payload - the custom message to send over LayerZero
145     // @param _payInZRO - if false, user app pays the protocol fee in native token
146     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
147     function estimateFees(
148         uint16 _dstChainId,
149         address _userApplication,
150         bytes calldata _payload,
151         bool _payInZRO,
152         bytes calldata _adapterParam
153     ) external view returns (uint256 nativeFee, uint256 zroFee);
154 
155     // @notice get this Endpoint's immutable source identifier
156     function getChainId() external view returns (uint16);
157 
158     // @notice the interface to retry failed message on this Endpoint destination
159     // @param _srcChainId - the source chain identifier
160     // @param _srcAddress - the source chain contract address
161     // @param _payload - the payload to be retried
162     function retryPayload(
163         uint16 _srcChainId,
164         bytes calldata _srcAddress,
165         bytes calldata _payload
166     ) external;
167 
168     // @notice query if any STORED payload (message blocking) at the endpoint.
169     // @param _srcChainId - the source chain identifier
170     // @param _srcAddress - the source chain contract address
171     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
172         external
173         view
174         returns (bool);
175 
176     // @notice query if the _libraryAddress is valid for sending msgs.
177     // @param _userApplication - the user app address on this EVM chain
178     function getSendLibraryAddress(address _userApplication)
179         external
180         view
181         returns (address);
182 
183     // @notice query if the _libraryAddress is valid for receiving msgs.
184     // @param _userApplication - the user app address on this EVM chain
185     function getReceiveLibraryAddress(address _userApplication)
186         external
187         view
188         returns (address);
189 
190     // @notice query if the non-reentrancy guard for send() is on
191     // @return true if the guard is on. false otherwise
192     function isSendingPayload() external view returns (bool);
193 
194     // @notice query if the non-reentrancy guard for receive() is on
195     // @return true if the guard is on. false otherwise
196     function isReceivingPayload() external view returns (bool);
197 
198     // @notice get the configuration of the LayerZero messaging library of the specified version
199     // @param _version - messaging library version
200     // @param _chainId - the chainId for the pending config change
201     // @param _userApplication - the contract address of the user application
202     // @param _configType - type of configuration. every messaging library has its own convention.
203     function getConfig(
204         uint16 _version,
205         uint16 _chainId,
206         address _userApplication,
207         uint256 _configType
208     ) external view returns (bytes memory);
209 
210     // @notice get the send() LayerZero messaging library version
211     // @param _userApplication - the contract address of the user application
212     function getSendVersion(address _userApplication)
213         external
214         view
215         returns (uint16);
216 
217     // @notice get the lzReceive() LayerZero messaging library version
218     // @param _userApplication - the contract address of the user application
219     function getReceiveVersion(address _userApplication)
220         external
221         view
222         returns (uint16);
223 }
224 
225 // File: contracts/interfaces/ILayerZeroReceiver.sol
226 
227 pragma solidity >=0.5.0;
228 
229 interface ILayerZeroReceiver {
230     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
231     // @param _srcChainId - the source endpoint identifier
232     // @param _srcAddress - the source sending contract address from the source chain
233     // @param _nonce - the ordered message nonce
234     // @param _payload - the signed payload is the UA bytes has encoded to be sent
235     function lzReceive(
236         uint16 _srcChainId,
237         bytes calldata _srcAddress,
238         uint64 _nonce,
239         bytes calldata _payload
240     ) external;
241 }
242 // File: @openzeppelin/contracts/utils/Strings.sol
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev String operations.
250  */
251 library Strings {
252     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
256      */
257     function toString(uint256 value) internal pure returns (string memory) {
258         // Inspired by OraclizeAPI's implementation - MIT licence
259         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
260 
261         if (value == 0) {
262             return "0";
263         }
264         uint256 temp = value;
265         uint256 digits;
266         while (temp != 0) {
267             digits++;
268             temp /= 10;
269         }
270         bytes memory buffer = new bytes(digits);
271         while (value != 0) {
272             digits -= 1;
273             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
274             value /= 10;
275         }
276         return string(buffer);
277     }
278 
279     /**
280      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
281      */
282     function toHexString(uint256 value) internal pure returns (string memory) {
283         if (value == 0) {
284             return "0x00";
285         }
286         uint256 temp = value;
287         uint256 length = 0;
288         while (temp != 0) {
289             length++;
290             temp >>= 8;
291         }
292         return toHexString(value, length);
293     }
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
297      */
298     function toHexString(uint256 value, uint256 length)
299         internal
300         pure
301         returns (string memory)
302     {
303         bytes memory buffer = new bytes(2 * length + 2);
304         buffer[0] = "0";
305         buffer[1] = "x";
306         for (uint256 i = 2 * length + 1; i > 1; --i) {
307             buffer[i] = _HEX_SYMBOLS[value & 0xf];
308             value >>= 4;
309         }
310         require(value == 0, "Strings: hex length insufficient");
311         return string(buffer);
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/Context.sol
316 
317 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Provides information about the current execution context, including the
323  * sender of the transaction and its data. While these are generally available
324  * via msg.sender and msg.data, they should not be accessed in such a direct
325  * manner, since when dealing with meta-transactions the account sending and
326  * paying for execution may not be the actual sender (as far as an application
327  * is concerned).
328  *
329  * This contract is only required for intermediate, library-like contracts.
330  */
331 abstract contract Context {
332     function _msgSender() internal view virtual returns (address) {
333         return msg.sender;
334     }
335 
336     function _msgData() internal view virtual returns (bytes calldata) {
337         return msg.data;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/access/Ownable.sol
342 
343 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Contract module which provides a basic access control mechanism, where
349  * there is an account (an owner) that can be granted exclusive access to
350  * specific functions.
351  *
352  * By default, the owner account will be the one that deploys the contract. This
353  * can later be changed with {transferOwnership}.
354  *
355  * This module is used through inheritance. It will make available the modifier
356  * `onlyOwner`, which can be applied to your functions to restrict their use to
357  * the owner.
358  */
359 abstract contract Ownable is Context {
360     address private _owner;
361 
362     event OwnershipTransferred(
363         address indexed previousOwner,
364         address indexed newOwner
365     );
366 
367     /**
368      * @dev Initializes the contract setting the deployer as the initial owner.
369      */
370     constructor() {
371         _transferOwnership(_msgSender());
372     }
373 
374     /**
375      * @dev Returns the address of the current owner.
376      */
377     function owner() public view virtual returns (address) {
378         return _owner;
379     }
380 
381     /**
382      * @dev Throws if called by any account other than the owner.
383      */
384     modifier onlyOwner() {
385         require(owner() == _msgSender(), "Ownable: caller is not the owner");
386         _;
387     }
388 
389     /**
390      * @dev Leaves the contract without owner. It will not be possible to call
391      * `onlyOwner` functions anymore. Can only be called by the current owner.
392      *
393      * NOTE: Renouncing ownership will leave the contract without an owner,
394      * thereby removing any functionality that is only available to the owner.
395      */
396     function renounceOwnership() public virtual onlyOwner {
397         _transferOwnership(address(0));
398     }
399 
400     /**
401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
402      * Can only be called by the current owner.
403      */
404     function transferOwnership(address newOwner) public virtual onlyOwner {
405         require(
406             newOwner != address(0),
407             "Ownable: new owner is the zero address"
408         );
409         _transferOwnership(newOwner);
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Internal function without access restriction.
415      */
416     function _transferOwnership(address newOwner) internal virtual {
417         address oldOwner = _owner;
418         _owner = newOwner;
419         emit OwnershipTransferred(oldOwner, newOwner);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Address.sol
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Collection of functions related to the address type
431  */
432 library Address {
433     /**
434      * @dev Returns true if `account` is a contract.
435      *
436      * [IMPORTANT]
437      * ====
438      * It is unsafe to assume that an address for which this function returns
439      * false is an externally-owned account (EOA) and not a contract.
440      *
441      * Among others, `isContract` will return false for the following
442      * types of addresses:
443      *
444      *  - an externally-owned account
445      *  - a contract in construction
446      *  - an address where a contract will be created
447      *  - an address where a contract lived, but was destroyed
448      * ====
449      */
450     function isContract(address account) internal view returns (bool) {
451         // This method relies on extcodesize, which returns 0 for contracts in
452         // construction, since the code is only stored at the end of the
453         // constructor execution.
454 
455         uint256 size;
456         assembly {
457             size := extcodesize(account)
458         }
459         return size > 0;
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      */
478     function sendValue(address payable recipient, uint256 amount) internal {
479         require(
480             address(this).balance >= amount,
481             "Address: insufficient balance"
482         );
483 
484         (bool success, ) = recipient.call{value: amount}("");
485         require(
486             success,
487             "Address: unable to send value, recipient may have reverted"
488         );
489     }
490 
491     /**
492      * @dev Performs a Solidity function call using a low level `call`. A
493      * plain `call` is an unsafe replacement for a function call: use this
494      * function instead.
495      *
496      * If `target` reverts with a revert reason, it is bubbled up by this
497      * function (like regular Solidity function calls).
498      *
499      * Returns the raw returned data. To convert to the expected return value,
500      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
501      *
502      * Requirements:
503      *
504      * - `target` must be a contract.
505      * - calling `target` with `data` must not revert.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(address target, bytes memory data)
510         internal
511         returns (bytes memory)
512     {
513         return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
518      * `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, 0, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but also transferring `value` wei to `target`.
533      *
534      * Requirements:
535      *
536      * - the calling contract must have an ETH balance of at least `value`.
537      * - the called Solidity function must be `payable`.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value
545     ) internal returns (bytes memory) {
546         return
547             functionCallWithValue(
548                 target,
549                 data,
550                 value,
551                 "Address: low-level call with value failed"
552             );
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(
568             address(this).balance >= value,
569             "Address: insufficient balance for call"
570         );
571         require(isContract(target), "Address: call to non-contract");
572 
573         (bool success, bytes memory returndata) = target.call{value: value}(
574             data
575         );
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(address target, bytes memory data)
586         internal
587         view
588         returns (bytes memory)
589     {
590         return
591             functionStaticCall(
592                 target,
593                 data,
594                 "Address: low-level static call failed"
595             );
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a static call.
601      *
602      * _Available since v3.3._
603      */
604     function functionStaticCall(
605         address target,
606         bytes memory data,
607         string memory errorMessage
608     ) internal view returns (bytes memory) {
609         require(isContract(target), "Address: static call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.staticcall(data);
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(address target, bytes memory data)
622         internal
623         returns (bytes memory)
624     {
625         return
626             functionDelegateCall(
627                 target,
628                 data,
629                 "Address: low-level delegate call failed"
630             );
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a delegate call.
636      *
637      * _Available since v3.4._
638      */
639     function functionDelegateCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal returns (bytes memory) {
644         require(isContract(target), "Address: delegate call to non-contract");
645 
646         (bool success, bytes memory returndata) = target.delegatecall(data);
647         return verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
652      * revert reason using the provided one.
653      *
654      * _Available since v4.3._
655      */
656     function verifyCallResult(
657         bool success,
658         bytes memory returndata,
659         string memory errorMessage
660     ) internal pure returns (bytes memory) {
661         if (success) {
662             return returndata;
663         } else {
664             // Look for revert reason and bubble it up if present
665             if (returndata.length > 0) {
666                 // The easiest way to bubble the revert reason is using memory via assembly
667 
668                 assembly {
669                     let returndata_size := mload(returndata)
670                     revert(add(32, returndata), returndata_size)
671                 }
672             } else {
673                 revert(errorMessage);
674             }
675         }
676     }
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @title ERC721 token receiver interface
687  * @dev Interface for any contract that wants to support safeTransfers
688  * from ERC721 asset contracts.
689  */
690 interface IERC721Receiver {
691     /**
692      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
693      * by `operator` from `from`, this function is called.
694      *
695      * It must return its Solidity selector to confirm the token transfer.
696      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
697      *
698      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
699      */
700     function onERC721Received(
701         address operator,
702         address from,
703         uint256 tokenId,
704         bytes calldata data
705     ) external returns (bytes4);
706 }
707 
708 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @dev Interface of the ERC165 standard, as defined in the
716  * https://eips.ethereum.org/EIPS/eip-165[EIP].
717  *
718  * Implementers can declare support of contract interfaces, which can then be
719  * queried by others ({ERC165Checker}).
720  *
721  * For an implementation, see {ERC165}.
722  */
723 interface IERC165 {
724     /**
725      * @dev Returns true if this contract implements the interface defined by
726      * `interfaceId`. See the corresponding
727      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
728      * to learn more about how these ids are created.
729      *
730      * This function call must use less than 30 000 gas.
731      */
732     function supportsInterface(bytes4 interfaceId) external view returns (bool);
733 }
734 
735 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
736 
737 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev Implementation of the {IERC165} interface.
743  *
744  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
745  * for the additional interface id that will be supported. For example:
746  *
747  * ```solidity
748  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
750  * }
751  * ```
752  *
753  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
754  */
755 abstract contract ERC165 is IERC165 {
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId)
760         public
761         view
762         virtual
763         override
764         returns (bool)
765     {
766         return interfaceId == type(IERC165).interfaceId;
767     }
768 }
769 
770 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
771 
772 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @dev Required interface of an ERC721 compliant contract.
778  */
779 interface IERC721 is IERC165 {
780     /**
781      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
782      */
783     event Transfer(
784         address indexed from,
785         address indexed to,
786         uint256 indexed tokenId
787     );
788 
789     /**
790      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
791      */
792     event Approval(
793         address indexed owner,
794         address indexed approved,
795         uint256 indexed tokenId
796     );
797 
798     /**
799      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
800      */
801     event ApprovalForAll(
802         address indexed owner,
803         address indexed operator,
804         bool approved
805     );
806 
807     /**
808      * @dev Returns the number of tokens in ``owner``'s account.
809      */
810     function balanceOf(address owner) external view returns (uint256 balance);
811 
812     /**
813      * @dev Returns the owner of the `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function ownerOf(uint256 tokenId) external view returns (address owner);
820 
821     /**
822      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
823      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) external;
840 
841     /**
842      * @dev Transfers `tokenId` token from `from` to `to`.
843      *
844      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must be owned by `from`.
851      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
852      *
853      * Emits a {Transfer} event.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) external;
860 
861     /**
862      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
863      * The approval is cleared when the token is transferred.
864      *
865      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
866      *
867      * Requirements:
868      *
869      * - The caller must own the token or be an approved operator.
870      * - `tokenId` must exist.
871      *
872      * Emits an {Approval} event.
873      */
874     function approve(address to, uint256 tokenId) external;
875 
876     /**
877      * @dev Returns the account approved for `tokenId` token.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      */
883     function getApproved(uint256 tokenId)
884         external
885         view
886         returns (address operator);
887 
888     /**
889      * @dev Approve or remove `operator` as an operator for the caller.
890      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
891      *
892      * Requirements:
893      *
894      * - The `operator` cannot be the caller.
895      *
896      * Emits an {ApprovalForAll} event.
897      */
898     function setApprovalForAll(address operator, bool _approved) external;
899 
900     /**
901      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
902      *
903      * See {setApprovalForAll}
904      */
905     function isApprovedForAll(address owner, address operator)
906         external
907         view
908         returns (bool);
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes calldata data
928     ) external;
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
932 pragma solidity ^0.8.0;
933 /**
934  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
935  * @dev See https://eips.ethereum.org/EIPS/eip-721
936  */
937 interface IERC721Enumerable is IERC721 {
938     /**
939      * @dev Returns the total amount of tokens stored by the contract.
940      */
941     function totalSupply() external view returns (uint256);
942 
943     /**
944      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
945      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
946      */
947     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
948 
949     /**
950      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
951      * Use along with {totalSupply} to enumerate all tokens.
952      */
953     function tokenByIndex(uint256 index) external view returns (uint256);
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
957 
958 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
959 
960 pragma solidity ^0.8.0;
961 
962 /**
963  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
964  * @dev See https://eips.ethereum.org/EIPS/eip-721
965  */
966 interface IERC721Metadata is IERC721 {
967     /**
968      * @dev Returns the token collection name.
969      */
970     function name() external view returns (string memory);
971 
972     /**
973      * @dev Returns the token collection symbol.
974      */
975     function symbol() external view returns (string memory);
976 
977     /**
978      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
979      */
980     function tokenURI(uint256 tokenId) external view returns (string memory);
981 }
982 
983 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
984 
985 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
991  * the Metadata extension, but not including the Enumerable extension, which is available separately as
992  * {ERC721Enumerable}.
993  */
994 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
995     using Address for address;
996     using Strings for uint256;
997 
998     // Token name
999     string private _name;
1000 
1001     // Token symbol
1002     string private _symbol;
1003 
1004     // Mapping from token ID to owner address
1005     mapping(uint256 => address) private _owners;
1006 
1007     // Mapping owner address to token count
1008     mapping(address => uint256) private _balances;
1009 
1010     // Mapping from token ID to approved address
1011     mapping(uint256 => address) private _tokenApprovals;
1012 
1013     // Mapping from owner to operator approvals
1014     mapping(address => mapping(address => bool)) private _operatorApprovals;
1015 
1016     /**
1017      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1018      */
1019     constructor(string memory name_, string memory symbol_) {
1020         _name = name_;
1021         _symbol = symbol_;
1022     }
1023 
1024     /**
1025      * @dev See {IERC165-supportsInterface}.
1026      */
1027     function supportsInterface(bytes4 interfaceId)
1028         public
1029         view
1030         virtual
1031         override(ERC165, IERC165)
1032         returns (bool)
1033     {
1034         return
1035             interfaceId == type(IERC721).interfaceId ||
1036             interfaceId == type(IERC721Metadata).interfaceId ||
1037             super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-balanceOf}.
1042      */
1043     function balanceOf(address owner)
1044         public
1045         view
1046         virtual
1047         override
1048         returns (uint256)
1049     {
1050         require(
1051             owner != address(0),
1052             "ERC721: balance query for the zero address"
1053         );
1054         return _balances[owner];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-ownerOf}.
1059      */
1060     function ownerOf(uint256 tokenId)
1061         public
1062         view
1063         virtual
1064         override
1065         returns (address)
1066     {
1067         address owner = _owners[tokenId];
1068         require(
1069             owner != address(0),
1070             "ERC721: owner query for nonexistent token"
1071         );
1072         return owner;
1073     }
1074 
1075 
1076 
1077     /**
1078      * @dev See {IERC721Metadata-name}.
1079      */
1080     function name() public view virtual override returns (string memory) {
1081         return _name;
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Metadata-symbol}.
1086      */
1087     function symbol() public view virtual override returns (string memory) {
1088         return _symbol;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Metadata-tokenURI}.
1093      */
1094     function tokenURI(uint256 tokenId)
1095         public
1096         view
1097         virtual
1098         override
1099         returns (string memory)
1100     {
1101         require(
1102             _exists(tokenId),
1103             "ERC721Metadata: URI query for nonexistent token"
1104         );
1105 
1106         string memory baseURI = _baseURI();
1107         return
1108             bytes(baseURI).length > 0
1109                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1110                 : "";
1111     }
1112 
1113     /**
1114      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1115      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1116      * by default, can be overriden in child contracts.
1117      */
1118     function _baseURI() internal view virtual returns (string memory) {
1119         return "";
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-approve}.
1124      */
1125     function approve(address to, uint256 tokenId) public virtual override {
1126         address owner = ERC721.ownerOf(tokenId);
1127         require(to != owner, "ERC721: approval to current owner");
1128 
1129         require(
1130             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1131             "ERC721: approve caller is not owner nor approved for all"
1132         );
1133 
1134         _approve(to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-getApproved}.
1139      */
1140     function getApproved(uint256 tokenId)
1141         public
1142         view
1143         virtual
1144         override
1145         returns (address)
1146     {
1147         require(
1148             _exists(tokenId),
1149             "ERC721: approved query for nonexistent token"
1150         );
1151 
1152         return _tokenApprovals[tokenId];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-setApprovalForAll}.
1157      */
1158     function setApprovalForAll(address operator, bool approved)
1159         public
1160         virtual
1161         override
1162     {
1163         _setApprovalForAll(_msgSender(), operator, approved);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-isApprovedForAll}.
1168      */
1169     function isApprovedForAll(address owner, address operator)
1170         public
1171         view
1172         virtual
1173         override
1174         returns (bool)
1175     {
1176         return _operatorApprovals[owner][operator];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-transferFrom}.
1181      */
1182     function transferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) public virtual override {
1187         //solhint-disable-next-line max-line-length
1188         require(
1189             _isApprovedOrOwner(_msgSender(), tokenId),
1190             "ERC721: transfer caller is not owner nor approved"
1191         );
1192 
1193         _transfer(from, to, tokenId);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-safeTransferFrom}.
1198      */
1199     function safeTransferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) public virtual override {
1204         safeTransferFrom(from, to, tokenId, "");
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-safeTransferFrom}.
1209      */
1210     function safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId,
1214         bytes memory _data
1215     ) public virtual override {
1216         require(
1217             _isApprovedOrOwner(_msgSender(), tokenId),
1218             "ERC721: transfer caller is not owner nor approved"
1219         );
1220         _safeTransfer(from, to, tokenId, _data);
1221     }
1222 
1223     /**
1224      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1225      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1226      *
1227      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1228      *
1229      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1230      * implement alternative mechanisms to perform token transfer, such as signature-based.
1231      *
1232      * Requirements:
1233      *
1234      * - `from` cannot be the zero address.
1235      * - `to` cannot be the zero address.
1236      * - `tokenId` token must exist and be owned by `from`.
1237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _safeTransfer(
1242         address from,
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) internal virtual {
1247         _transfer(from, to, tokenId);
1248         require(
1249             _checkOnERC721Received(from, to, tokenId, _data),
1250             "ERC721: transfer to non ERC721Receiver implementer"
1251         );
1252     }
1253 
1254     /**
1255      * @dev Returns whether `tokenId` exists.
1256      *
1257      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1258      *
1259      * Tokens start existing when they are minted (`_mint`),
1260      * and stop existing when they are burned (`_burn`).
1261      */
1262     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1263         return _owners[tokenId] != address(0);
1264     }
1265 
1266     /**
1267      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      */
1273     function _isApprovedOrOwner(address spender, uint256 tokenId)
1274         internal
1275         view
1276         virtual
1277         returns (bool)
1278     {
1279         require(
1280             _exists(tokenId),
1281             "ERC721: operator query for nonexistent token"
1282         );
1283         address owner = ERC721.ownerOf(tokenId);
1284         return (spender == owner ||
1285             getApproved(tokenId) == spender ||
1286             isApprovedForAll(owner, spender));
1287     }
1288 
1289     /**
1290      * @dev Safely mints `tokenId` and transfers it to `to`.
1291      *
1292      * Requirements:
1293      *
1294      * - `tokenId` must not exist.
1295      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function _safeMint(address to, uint256 tokenId) internal virtual {
1300         _safeMint(to, tokenId, "");
1301     }
1302 
1303     /**
1304      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1305      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1306      */
1307     function _safeMint(
1308         address to,
1309         uint256 tokenId,
1310         bytes memory _data
1311     ) internal virtual {
1312         _mint(to, tokenId);
1313         require(
1314             _checkOnERC721Received(address(0), to, tokenId, _data),
1315             "ERC721: transfer to non ERC721Receiver implementer"
1316         );
1317     }
1318 
1319     /**
1320      * @dev Mints `tokenId` and transfers it to `to`.
1321      *
1322      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1323      *
1324      * Requirements:
1325      *
1326      * - `tokenId` must not exist.
1327      * - `to` cannot be the zero address.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _mint(address to, uint256 tokenId) internal virtual {
1332         require(to != address(0), "ERC721: mint to the zero address");
1333 
1334         _beforeTokenTransfer(address(0), to, tokenId);
1335 
1336         _balances[to] += 1;
1337         _owners[tokenId] = to;
1338 
1339         emit Transfer(address(0), to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev Destroys `tokenId`.
1344      * The approval is cleared when the token is burned.
1345      *
1346      * Requirements:
1347      *
1348      * - `tokenId` must exist.
1349      *
1350      * Emits a {Transfer} event.
1351      */
1352     function _burn(uint256 tokenId) internal virtual {
1353         address owner = ERC721.ownerOf(tokenId);
1354 
1355         _beforeTokenTransfer(owner, address(0), tokenId);
1356 
1357         // Clear approvals
1358         _approve(address(0), tokenId);
1359 
1360         _balances[owner] -= 1;
1361         delete _owners[tokenId];
1362 
1363         emit Transfer(owner, address(0), tokenId);
1364     }
1365 
1366     /**
1367      * @dev Transfers `tokenId` from `from` to `to`.
1368      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1369      *
1370      * Requirements:
1371      *
1372      * - `to` cannot be the zero address.
1373      * - `tokenId` token must be owned by `from`.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function _transfer(
1378         address from,
1379         address to,
1380         uint256 tokenId
1381     ) internal virtual {
1382         require(
1383             ERC721.ownerOf(tokenId) == from,
1384             "ERC721: transfer of token that is not own"
1385         );
1386         require(to != address(0), "ERC721: transfer to the zero address");
1387 
1388         _beforeTokenTransfer(from, to, tokenId);
1389 
1390         // Clear approvals from the previous owner
1391         _approve(address(0), tokenId);
1392 
1393         _balances[from] -= 1;
1394         _balances[to] += 1;
1395         _owners[tokenId] = to;
1396 
1397         emit Transfer(from, to, tokenId);
1398     }
1399 
1400     /**
1401      * @dev Approve `to` to operate on `tokenId`
1402      *
1403      * Emits a {Approval} event.
1404      */
1405     function _approve(address to, uint256 tokenId) internal virtual {
1406         _tokenApprovals[tokenId] = to;
1407         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1408     }
1409 
1410     /**
1411      * @dev Approve `operator` to operate on all of `owner` tokens
1412      *
1413      * Emits a {ApprovalForAll} event.
1414      */
1415     function _setApprovalForAll(
1416         address owner,
1417         address operator,
1418         bool approved
1419     ) internal virtual {
1420         require(owner != operator, "ERC721: approve to caller");
1421         _operatorApprovals[owner][operator] = approved;
1422         emit ApprovalForAll(owner, operator, approved);
1423     }
1424 
1425     /**
1426      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1427      * The call is not executed if the target address is not a contract.
1428      *
1429      * @param from address representing the previous owner of the given token ID
1430      * @param to target address that will receive the tokens
1431      * @param tokenId uint256 ID of the token to be transferred
1432      * @param _data bytes optional data to send along with the call
1433      * @return bool whether the call correctly returned the expected magic value
1434      */
1435     function _checkOnERC721Received(
1436         address from,
1437         address to,
1438         uint256 tokenId,
1439         bytes memory _data
1440     ) private returns (bool) {
1441         if (to.isContract()) {
1442             try
1443                 IERC721Receiver(to).onERC721Received(
1444                     _msgSender(),
1445                     from,
1446                     tokenId,
1447                     _data
1448                 )
1449             returns (bytes4 retval) {
1450                 return retval == IERC721Receiver.onERC721Received.selector;
1451             } catch (bytes memory reason) {
1452                 if (reason.length == 0) {
1453                     revert(
1454                         "ERC721: transfer to non ERC721Receiver implementer"
1455                     );
1456                 } else {
1457                     assembly {
1458                         revert(add(32, reason), mload(reason))
1459                     }
1460                 }
1461             }
1462         } else {
1463             return true;
1464         }
1465     }
1466 
1467     /**
1468      * @dev Hook that is called before any token transfer. This includes minting
1469      * and burning.
1470      *
1471      * Calling conditions:
1472      *
1473      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1474      * transferred to `to`.
1475      * - When `from` is zero, `tokenId` will be minted for `to`.
1476      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1477      * - `from` and `to` are never both zero.
1478      *
1479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1480      */
1481     function _beforeTokenTransfer(
1482         address from,
1483         address to,
1484         uint256 tokenId
1485     ) internal virtual {}
1486 }
1487 
1488 // File: contracts/NonblockingReceiver.sol
1489 
1490 pragma solidity ^0.8.6;
1491 
1492 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1493     ILayerZeroEndpoint internal endpoint;
1494 
1495     struct FailedMessages {
1496         uint256 payloadLength;
1497         bytes32 payloadHash;
1498     }
1499 
1500     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1501         public failedMessages;
1502     mapping(uint16 => bytes) public trustedRemoteLookup;
1503 
1504     event MessageFailed(
1505         uint16 _srcChainId,
1506         bytes _srcAddress,
1507         uint64 _nonce,
1508         bytes _payload
1509     );
1510 
1511     function lzReceive(
1512         uint16 _srcChainId,
1513         bytes memory _srcAddress,
1514         uint64 _nonce,
1515         bytes memory _payload
1516     ) external override {
1517         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1518         require(
1519             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1520                 keccak256(_srcAddress) ==
1521                 keccak256(trustedRemoteLookup[_srcChainId]),
1522             "NonblockingReceiver: invalid source sending contract"
1523         );
1524 
1525         // try-catch all errors/exceptions
1526         // having failed messages does not block messages passing
1527         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1528             // do nothing
1529         } catch {
1530             // error / exception
1531             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1532                 _payload.length,
1533                 keccak256(_payload)
1534             );
1535             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1536         }
1537     }
1538 
1539     function onLzReceive(
1540         uint16 _srcChainId,
1541         bytes memory _srcAddress,
1542         uint64 _nonce,
1543         bytes memory _payload
1544     ) public {
1545         // only internal transaction
1546         require(
1547             msg.sender == address(this),
1548             "NonblockingReceiver: caller must be Bridge."
1549         );
1550 
1551         // handle incoming message
1552         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1553     }
1554 
1555     // abstract function
1556     function _LzReceive(
1557         uint16 _srcChainId,
1558         bytes memory _srcAddress,
1559         uint64 _nonce,
1560         bytes memory _payload
1561     ) internal virtual;
1562 
1563     function _lzSend(
1564         uint16 _dstChainId,
1565         bytes memory _payload,
1566         address payable _refundAddress,
1567         address _zroPaymentAddress,
1568         bytes memory _txParam
1569     ) internal {
1570         endpoint.send{value: msg.value}(
1571             _dstChainId,
1572             trustedRemoteLookup[_dstChainId],
1573             _payload,
1574             _refundAddress,
1575             _zroPaymentAddress,
1576             _txParam
1577         );
1578     }
1579 
1580     function retryMessage(
1581         uint16 _srcChainId,
1582         bytes memory _srcAddress,
1583         uint64 _nonce,
1584         bytes calldata _payload
1585     ) external payable {
1586         // assert there is message to retry
1587         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1588             _srcAddress
1589         ][_nonce];
1590         require(
1591             failedMsg.payloadHash != bytes32(0),
1592             "NonblockingReceiver: no stored message"
1593         );
1594         require(
1595             _payload.length == failedMsg.payloadLength &&
1596                 keccak256(_payload) == failedMsg.payloadHash,
1597             "LayerZero: invalid payload"
1598         );
1599         // clear the stored message
1600         failedMsg.payloadLength = 0;
1601         failedMsg.payloadHash = bytes32(0);
1602         // execute the message. revert if it fails again
1603         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1604     }
1605 
1606     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1607         external
1608         onlyOwner
1609     {
1610         trustedRemoteLookup[_chainId] = _trustedRemote;
1611     }
1612 }
1613 
1614 // File: contracts/optimistic-oni-eth.sol
1615 
1616 pragma solidity ^0.8.7;
1617 
1618 contract oni is Ownable, ERC721, NonblockingReceiver {
1619     address public _owner;
1620     uint256 supply = 3000;
1621     string private baseURI;
1622     bool public isPaused = true;
1623     uint256 nextTokenId = 3666;
1624     uint256 MAX_MINT = 6666;
1625 
1626     uint256 gasForDestinationLzReceive = 350000;
1627 
1628     constructor(string memory baseURI_, address _layerZeroEndpoint)
1629         ERC721("0ni", "0ni")
1630     {
1631         _owner = msg.sender;
1632         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1633         baseURI = baseURI_;
1634     }
1635 
1636     // mint function
1637     // you can mint upto 2 nft's max. 1 per transaction
1638     // mint is free, but payments are accepted
1639     function mint(uint8 numTokens) external payable {
1640         require(!isPaused, "Minting is Paused yet");	
1641         require(numTokens < 2, "0ni: Max 1 NFTs per transaction");
1642         require(balanceOf(msg.sender)+numTokens < 3, "Max 2 Nft's per wallet");
1643         require(
1644             nextTokenId + numTokens <= MAX_MINT,
1645             "0ni: Mint exceeds supply"
1646         );
1647         _safeMint(msg.sender, ++nextTokenId);
1648         nextTokenId = nextTokenId;
1649 
1650         }
1651 
1652     function pause () external onlyOwner {	
1653         isPaused = true;	
1654     }
1655 
1656     function unPause () external onlyOwner {	
1657         isPaused = false;	
1658     }
1659 
1660     function mintForOwner(address owner, uint256 _mintAmount) public onlyOwner {
1661     require(_mintAmount > 0);
1662     require(nextTokenId <= MAX_MINT);
1663     require(_mintAmount <= MAX_MINT);
1664     require(supply + _mintAmount <= MAX_MINT);
1665     
1666     for (uint256 i = 1; i <= _mintAmount; i++) {
1667     _safeMint(owner,nextTokenId + i);
1668     }
1669 
1670     nextTokenId += _mintAmount;
1671 
1672 }
1673 
1674     // This function transfers the nft from your address on the
1675     // source chain to the same address on the destination chain
1676     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1677         require(
1678             msg.sender == ownerOf(tokenId),
1679             "You must own the token to traverse"
1680         );
1681         require(
1682             trustedRemoteLookup[_chainId].length > 0,
1683             "This chain is currently unavailable for travel"
1684         );
1685 
1686         // burn NFT, eliminating it from circulation on src chain
1687         _burn(tokenId);
1688 
1689         // abi.encode() the payload with the values to send
1690         bytes memory payload = abi.encode(msg.sender, tokenId);
1691 
1692         // encode adapterParams to specify more gas for the destination
1693         uint16 version = 1;
1694         bytes memory adapterParams = abi.encodePacked(
1695             version,
1696             gasForDestinationLzReceive
1697         );
1698 
1699         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1700         // you will be refunded for extra gas paid
1701         (uint256 messageFee, ) = endpoint.estimateFees(
1702             _chainId,
1703             address(this),
1704             payload,
1705             false,
1706             adapterParams
1707         );
1708 
1709         require(
1710             msg.value >= messageFee,
1711             "0ni: msg.value not enough to cover messageFee. Send gas for message fees"
1712         );
1713 
1714         endpoint.send{value: msg.value}(
1715             _chainId, // destination chainId
1716             trustedRemoteLookup[_chainId], // destination address of nft contract
1717             payload, // abi.encoded()'ed bytes
1718             payable(msg.sender), // refund address
1719             address(0x0), // 'zroPaymentAddress' unused for this
1720             adapterParams // txParameters
1721         );
1722     }
1723 
1724     function setBaseURI(string memory URI) external onlyOwner {
1725         baseURI = URI;
1726     }
1727 
1728     function donate() external payable {
1729         // thank you
1730     }
1731 
1732     // This allows the devs to receive kind donations
1733     function withdraw(uint256 amt) external onlyOwner {
1734         (bool sent, ) = payable(_owner).call{value: amt}("");
1735         require(sent, "0ni: Failed to withdraw Ether");
1736     }
1737 
1738     // just in case this fixed variable limits us from future integrations
1739     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1740         gasForDestinationLzReceive = newVal;
1741     }
1742 
1743     // ------------------
1744     // Internal Functions
1745     // ------------------
1746 
1747     function _LzReceive(
1748         uint16 _srcChainId,
1749         bytes memory _srcAddress,
1750         uint64 _nonce,
1751         bytes memory _payload
1752     ) internal override {
1753         // decode
1754         (address toAddr, uint256 tokenId) = abi.decode(
1755             _payload,
1756             (address, uint256)
1757         );
1758 
1759         // mint the tokens back into existence on destination chain
1760         _safeMint(toAddr, tokenId);
1761     }
1762 
1763     function _baseURI() internal view override returns (string memory) {
1764         return baseURI;
1765     }
1766 }