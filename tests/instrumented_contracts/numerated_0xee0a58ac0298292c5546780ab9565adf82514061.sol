1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @ethereansos\swissknife\contracts\lib\GeneralUtilities.sol
86 
87 // SPDX_License_Identifier: MIT
88 pragma solidity >=0.7.0;
89 
90 
91 library BehaviorUtilities {
92 
93     function randomKey(uint256 i) internal view returns (bytes32) {
94         return keccak256(abi.encode(i, block.timestamp, block.number, tx.origin, tx.gasprice, block.coinbase, block.difficulty, msg.sender, blockhash(block.number - 5)));
95     }
96 
97     function calculateProjectedArraySizeAndLoopUpperBound(uint256 arraySize, uint256 start, uint256 offset) internal pure returns(uint256 projectedArraySize, uint256 projectedArrayLoopUpperBound) {
98         if(arraySize != 0 && start < arraySize && offset != 0) {
99             uint256 length = start + offset;
100             if(start < (length = length > arraySize ? arraySize : length)) {
101                 projectedArraySize = (projectedArrayLoopUpperBound = length) - start;
102             }
103         }
104     }
105 }
106 
107 library ReflectionUtilities {
108 
109     function read(address subject, bytes memory inputData) internal view returns(bytes memory returnData) {
110         bool result;
111         (result, returnData) = subject.staticcall(inputData);
112         if(!result) {
113             assembly {
114                 revert(add(returnData, 0x20), mload(returnData))
115             }
116         }
117     }
118 
119     function submit(address subject, uint256 value, bytes memory inputData) internal returns(bytes memory returnData) {
120         bool result;
121         (result, returnData) = subject.call{value : value}(inputData);
122         if(!result) {
123             assembly {
124                 revert(add(returnData, 0x20), mload(returnData))
125             }
126         }
127     }
128 
129     function isContract(address subject) internal view returns (bool) {
130         if(subject == address(0)) {
131             return false;
132         }
133         uint256 codeLength;
134         assembly {
135             codeLength := extcodesize(subject)
136         }
137         return codeLength > 0;
138     }
139 
140     function clone(address originalContract) internal returns(address copyContract) {
141         assembly {
142             mstore(
143                 0,
144                 or(
145                     0x5880730000000000000000000000000000000000000000803b80938091923cF3,
146                     mul(originalContract, 0x1000000000000000000)
147                 )
148             )
149             copyContract := create(0, 0, 32)
150             switch extcodesize(copyContract)
151                 case 0 {
152                     invalid()
153                 }
154         }
155     }
156 }
157 
158 library BytesUtilities {
159 
160     bytes private constant ALPHABET = "0123456789abcdef";
161 
162     function asAddress(bytes memory b) internal pure returns(address) {
163         if(b.length == 0) {
164             return address(0);
165         }
166         if(b.length == 20) {
167             address addr;
168             assembly {
169                 addr := mload(add(b, 20))
170             }
171             return addr;
172         }
173         return abi.decode(b, (address));
174     }
175 
176     function asAddressArray(bytes memory b) internal pure returns(address[] memory callResult) {
177         if(b.length > 0) {
178             return abi.decode(b, (address[]));
179         }
180     }
181 
182     function asBool(bytes memory bs) internal pure returns(bool) {
183         return asUint256(bs) != 0;
184     }
185 
186     function asBoolArray(bytes memory b) internal pure returns(bool[] memory callResult) {
187         if(b.length > 0) {
188             return abi.decode(b, (bool[]));
189         }
190     }
191 
192     function asBytesArray(bytes memory b) internal pure returns(bytes[] memory callResult) {
193         if(b.length > 0) {
194             return abi.decode(b, (bytes[]));
195         }
196     }
197 
198     function asString(bytes memory b) internal pure returns(string memory callResult) {
199         if(b.length > 0) {
200             return abi.decode(b, (string));
201         }
202     }
203 
204     function asStringArray(bytes memory b) internal pure returns(string[] memory callResult) {
205         if(b.length > 0) {
206             return abi.decode(b, (string[]));
207         }
208     }
209 
210     function asUint256(bytes memory bs) internal pure returns(uint256 x) {
211         if (bs.length >= 32) {
212             assembly {
213                 x := mload(add(bs, add(0x20, 0)))
214             }
215         }
216     }
217 
218     function asUint256Array(bytes memory b) internal pure returns(uint256[] memory callResult) {
219         if(b.length > 0) {
220             return abi.decode(b, (uint256[]));
221         }
222     }
223 
224     function toString(bytes memory data) internal pure returns(string memory) {
225         bytes memory str = new bytes(2 + data.length * 2);
226         str[0] = "0";
227         str[1] = "x";
228         for (uint i = 0; i < data.length; i++) {
229             str[2+i*2] = ALPHABET[uint(uint8(data[i] >> 4))];
230             str[3+i*2] = ALPHABET[uint(uint8(data[i] & 0x0f))];
231         }
232         return string(str);
233     }
234 
235     function asSingletonArray(bytes memory a) internal pure returns(bytes[] memory array) {
236         array = new bytes[](1);
237         array[0] = a;
238     }
239 }
240 
241 library StringUtilities {
242 
243     bytes1 private constant CHAR_0 = bytes1('0');
244     bytes1 private constant CHAR_A = bytes1('A');
245     bytes1 private constant CHAR_a = bytes1('a');
246     bytes1 private constant CHAR_f = bytes1('f');
247 
248     function isEmpty(string memory test) internal pure returns (bool) {
249         return equals(test, "");
250     }
251 
252     function equals(string memory a, string memory b) internal pure returns(bool) {
253         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
254     }
255 
256     function toLowerCase(string memory str) internal pure returns(string memory) {
257         bytes memory bStr = bytes(str);
258         for (uint i = 0; i < bStr.length; i++) {
259             bStr[i] = bStr[i] >= 0x41 && bStr[i] <= 0x5A ? bytes1(uint8(bStr[i]) + 0x20) : bStr[i];
260         }
261         return string(bStr);
262     }
263 
264     function asBytes(string calldata str) internal pure returns(bytes memory toDecode) {
265         bytes memory data = abi.encodePacked(str);
266         if(data.length == 0 || data[0] != "0" || (data[1] != "x" && data[1] != "X")) {
267             return "";
268         }
269         uint256 start = 2;
270         toDecode = new bytes((data.length - 2) / 2);
271 
272         for(uint256 i = 0; i < toDecode.length; i++) {
273             toDecode[i] = bytes1(_fromHexChar(uint8(data[start++])) + _fromHexChar(uint8(data[start++])) * 16);
274         }
275     }
276 
277     function _fromHexChar(uint8 c) private pure returns (uint8) {
278         bytes1 charc = bytes1(c);
279         return charc < CHAR_0 || charc > CHAR_f ? 0 : (charc < CHAR_A ? 0 : 10) + c - uint8(charc < CHAR_A ? CHAR_0 : charc < CHAR_a ? CHAR_A : CHAR_a);
280     }
281 }
282 
283 library Uint256Utilities {
284     function asSingletonArray(uint256 n) internal pure returns(uint256[] memory array) {
285         array = new uint256[](1);
286         array[0] = n;
287     }
288 
289     function toString(uint256 _i) internal pure returns (string memory) {
290         return BytesUtilities.toString(abi.encodePacked(_i));
291     }
292 
293     function sum(uint256[] memory arr) internal pure returns (uint256 result) {
294         for(uint256 i = 0; i < arr.length; i++) {
295             result += arr[i];
296         }
297     }
298 }
299 
300 library AddressUtilities {
301     function asSingletonArray(address a) internal pure returns(address[] memory array) {
302         array = new address[](1);
303         array[0] = a;
304     }
305 
306     function toString(address _addr) internal pure returns (string memory) {
307         return _addr == address(0) ? "0x0000000000000000000000000000000000000000" : BytesUtilities.toString(abi.encodePacked(_addr));
308     }
309 }
310 
311 library Bytes32Utilities {
312 
313     function asSingletonArray(bytes32 a) internal pure returns(bytes32[] memory array) {
314         array = new bytes32[](1);
315         array[0] = a;
316     }
317 
318     function toString(bytes32 bt) internal pure returns (string memory) {
319         return bt == bytes32(0) ?  "0x0000000000000000000000000000000000000000000000000000000000000000" : BytesUtilities.toString(abi.encodePacked(bt));
320     }
321 }
322 
323 library TransferUtilities {
324     using ReflectionUtilities for address;
325 
326     function balanceOf(address erc20TokenAddress, address account) internal view returns(uint256) {
327         if(erc20TokenAddress == address(0)) {
328             return account.balance;
329         }
330         return abi.decode(erc20TokenAddress.read(abi.encodeWithSelector(IERC20(erc20TokenAddress).balanceOf.selector, account)), (uint256));
331     }
332 
333     function allowance(address erc20TokenAddress, address account, address spender) internal view returns(uint256) {
334         if(erc20TokenAddress == address(0)) {
335             return 0;
336         }
337         return abi.decode(erc20TokenAddress.read(abi.encodeWithSelector(IERC20(erc20TokenAddress).allowance.selector, account, spender)), (uint256));
338     }
339 
340     function safeApprove(address erc20TokenAddress, address spender, uint256 value) internal {
341         bytes memory returnData = erc20TokenAddress.submit(0, abi.encodeWithSelector(IERC20(erc20TokenAddress).approve.selector, spender, value));
342         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'APPROVE_FAILED');
343     }
344 
345     function safeTransfer(address erc20TokenAddress, address to, uint256 value) internal {
346         if(value == 0) {
347             return;
348         }
349         if(erc20TokenAddress == address(0)) {
350             to.submit(value, "");
351             return;
352         }
353         bytes memory returnData = erc20TokenAddress.submit(0, abi.encodeWithSelector(IERC20(erc20TokenAddress).transfer.selector, to, value));
354         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFER_FAILED');
355     }
356 
357     function safeTransferFrom(address erc20TokenAddress, address from, address to, uint256 value) internal {
358         if(value == 0) {
359             return;
360         }
361         if(erc20TokenAddress == address(0)) {
362             to.submit(value, "");
363             return;
364         }
365         bytes memory returnData = erc20TokenAddress.submit(0, abi.encodeWithSelector(IERC20(erc20TokenAddress).transferFrom.selector, from, to, value));
366         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFERFROM_FAILED');
367     }
368 }
369 
370 // File: contracts\claimer\OldOSClaimer.sol
371 
372 //SPDX_License_Identifier: MIT
373 
374 pragma solidity >=0.7.0;
375 
376 
377 contract OldOSClaimer {
378     using TransferUtilities for address;
379 
380     event Claimed(address indexed subject, address indexed token, address indexed receiver, uint256 amount);
381 
382     address public host;
383 
384     bool public claimable;
385 
386     mapping(address => mapping(address => uint256)) public amount;
387 
388     mapping(address => bool) public claimed;
389 
390     address[] private _tokens;
391 
392     mapping(address => bool) public testAddress;
393 
394     constructor(address _host, address[] memory tokensArray, address[] memory testAddresses) {
395         host = _host;
396         _tokens = tokensArray;
397         for(uint256 i = 0; i < testAddresses.length; i++) {
398             require(testAddresses[i] != address(0), "zero address");
399             testAddress[testAddresses[i]] = true;
400         }
401     }
402 
403     function tokens() external view returns(address[] memory) {
404         return _tokens;
405     }
406 
407     modifier hostOnly {
408         require(msg.sender == host, "unauthorized");
409         _;
410     }
411 
412     receive() external payable {
413     }
414 
415     function makeClaimable() external hostOnly {
416         claimable = true;
417         host = address(0);
418     }
419 
420     function flushToWallet(address receiver) external hostOnly {
421         require(receiver != address(0), "zero address");
422         uint256[] memory amounts = getBalances();
423         for(uint256 i = 0; i < amounts.length; i++) {
424             _tokens[i].safeTransfer(receiver, amounts[i]);
425         }
426     }
427 
428     function getBalances() public view returns(uint256[] memory amounts) {
429         amounts = new uint256[](_tokens.length);
430         for(uint256 i = 0; i < amounts.length; i++) {
431             amounts[i] = _tokens[i].balanceOf(address(this));
432         }
433     }
434 
435     function setup(address[] calldata owners, uint256[][] calldata amounts) external hostOnly {
436         require(!claimable, "claimable");
437         require(owners.length == amounts.length, "input");
438         address[] memory tks = _tokens;
439         for(uint256 z = 0; z < owners.length; z++) {
440             address owner = owners[z];
441             uint256[] memory ownerAmounts = amounts[z];
442             require(ownerAmounts.length == tks.length, "length");
443             for(uint256 i = 0; i < tks.length; i++) {
444                 address tokenAddress = tks[i];
445                 amount[owner][tokenAddress] = ownerAmounts[i];
446             }
447         }
448     }
449 
450     function claim(address receiver) external {
451         require(claimable || testAddress[msg.sender], "not claimable");
452         require(!claimed[msg.sender], "claimed");
453         claimed[msg.sender] = true;
454         address realReceiver = receiver == address(0) ? msg.sender : receiver;
455         address[] memory tks = _tokens;
456         for(uint256 i = 0; i < tks.length; i++) {
457             address tokenAddress = tks[i];
458             uint256 tokenAmount = amount[msg.sender][tokenAddress];
459             if(tokenAmount != 0) {
460                 tokenAddress.safeTransfer(realReceiver, tokenAmount);
461             }
462             emit Claimed(msg.sender, tokenAddress, realReceiver, tokenAmount);
463         }
464     }
465 }