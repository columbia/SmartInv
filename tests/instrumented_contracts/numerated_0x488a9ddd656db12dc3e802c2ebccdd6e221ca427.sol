1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 pragma experimental ABIEncoderV2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, with an overflow flag.
90      *
91      * _Available since v3.4._
92      */
93     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         uint256 c = a + b;
95         if (c < a) return (false, 0);
96         return (true, c);
97     }
98 
99     /**
100      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         if (b > a) return (false, 0);
106         return (true, a - b);
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) return (true, 0);
119         uint256 c = a * b;
120         if (c / a != b) return (false, 0);
121         return (true, c);
122     }
123 
124     /**
125      * @dev Returns the division of two unsigned integers, with a division by zero flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b == 0) return (false, 0);
131         return (true, a / b);
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         if (b == 0) return (false, 0);
141         return (true, a % b);
142     }
143 
144     /**
145      * @dev Returns the addition of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `+` operator.
149      *
150      * Requirements:
151      *
152      * - Addition cannot overflow.
153      */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a, "SafeMath: addition overflow");
157         return c;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         require(b <= a, "SafeMath: subtraction overflow");
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         if (a == 0) return 0;
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers, reverting on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         require(b > 0, "SafeMath: division by zero");
206         return a / b;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * reverting when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         require(b > 0, "SafeMath: modulo by zero");
223         return a % b;
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228      * overflow (when the result is negative).
229      *
230      * CAUTION: This function is deprecated because it requires allocating memory for the error
231      * message unnecessarily. For custom revert reasons use {trySub}.
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b <= a, errorMessage);
241         return a - b;
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {tryDiv}.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b > 0, errorMessage);
261         return a / b;
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * reverting with custom message when dividing by zero.
267      *
268      * CAUTION: This function is deprecated because it requires allocating memory for the error
269      * message unnecessarily. For custom revert reasons use {tryMod}.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b > 0, errorMessage);
281         return a % b;
282     }
283 }
284 
285 
286 library BytesLibrary {
287     function toString(bytes32 value) internal pure returns (string memory) {
288         bytes memory alphabet = "0123456789abcdef";
289         bytes memory str = new bytes(64);
290         for (uint256 i = 0; i < 32; i++) {
291             str[i*2] = alphabet[uint8(value[i] >> 4)];
292             str[1+i*2] = alphabet[uint8(value[i] & 0x0f)];
293         }
294         return string(str);
295     }
296 }
297 
298 library UintLibrary {
299     using SafeMath for uint;
300 
301     function toString(uint256 i) internal pure returns (string memory) {
302         if (i == 0) {
303             return "0";
304         }
305         uint j = i;
306         uint len;
307         while (j != 0) {
308             len++;
309             j /= 10;
310         }
311         bytes memory bstr = new bytes(len);
312         uint k = len - 1;
313         while (i != 0) {
314             bstr[k--] = byte(uint8(48 + i % 10));
315             i /= 10;
316         }
317         return string(bstr);
318     }
319 
320     function bp(uint value, uint bpValue) internal pure returns (uint) {
321         return value.mul(bpValue).div(10000);
322     }
323 }
324 
325 library StringLibrary {
326     using UintLibrary for uint256;
327 
328     function append(string memory a, string memory b) internal pure returns (string memory) {
329         bytes memory ba = bytes(a);
330         bytes memory bb = bytes(b);
331         bytes memory bab = new bytes(ba.length + bb.length);
332         uint k = 0;
333         for (uint i = 0; i < ba.length; i++) bab[k++] = ba[i];
334         for (uint i = 0; i < bb.length; i++) bab[k++] = bb[i];
335         return string(bab);
336     }
337 
338     function append(string memory a, string memory b, string memory c) internal pure returns (string memory) {
339         bytes memory ba = bytes(a);
340         bytes memory bb = bytes(b);
341         bytes memory bc = bytes(c);
342         bytes memory bbb = new bytes(ba.length + bb.length + bc.length);
343         uint k = 0;
344         for (uint i = 0; i < ba.length; i++) bbb[k++] = ba[i];
345         for (uint i = 0; i < bb.length; i++) bbb[k++] = bb[i];
346         for (uint i = 0; i < bc.length; i++) bbb[k++] = bc[i];
347         return string(bbb);
348     }
349 
350     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
351         bytes memory msgBytes = bytes(message);
352         bytes memory fullMessage = concat(
353             bytes("\x19Ethereum Signed Message:\n"),
354             bytes(msgBytes.length.toString()),
355             msgBytes,
356             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
357         );
358         return ecrecover(keccak256(fullMessage), v, r, s);
359     }
360 
361     function concat(bytes memory ba, bytes memory bb, bytes memory bc, bytes memory bd, bytes memory be, bytes memory bf, bytes memory bg) internal pure returns (bytes memory) {
362         bytes memory resultBytes = new bytes(ba.length + bb.length + bc.length + bd.length + be.length + bf.length + bg.length);
363         uint k = 0;
364         for (uint i = 0; i < ba.length; i++) resultBytes[k++] = ba[i];
365         for (uint i = 0; i < bb.length; i++) resultBytes[k++] = bb[i];
366         for (uint i = 0; i < bc.length; i++) resultBytes[k++] = bc[i];
367         for (uint i = 0; i < bd.length; i++) resultBytes[k++] = bd[i];
368         for (uint i = 0; i < be.length; i++) resultBytes[k++] = be[i];
369         for (uint i = 0; i < bf.length; i++) resultBytes[k++] = bf[i];
370         for (uint i = 0; i < bg.length; i++) resultBytes[k++] = bg[i];
371         return resultBytes;
372     }
373 }
374 
375 contract TransferOnigiri{
376     address owner;
377     address public transferToken;
378     mapping(uint256 => bool) usedNonces;
379     mapping(address => bool) public transferredUsers;
380     mapping(address=>uint256) public transferAmount;
381 
382     constructor(address _transferToken) payable {
383         owner = msg.sender;
384         transferToken = _transferToken;
385     }
386     using SafeMath for uint256;
387     using StringLibrary for string;
388     using BytesLibrary for bytes32;
389     
390 //////////////////////////////////////Verification Functions////////////////////////////////////////////////
391 
392     function _generateKey(uint256 amount,uint256 nonce,address receiver)internal pure returns(bytes32 key){
393         key = keccak256(abi.encode(amount,nonce,receiver));
394     }
395 
396     function generateKey(uint256 amount,uint256 nonce,address receiver )external pure returns(bytes32 key){
397         key = _generateKey(amount,nonce,receiver);
398     }
399 
400     function genMessage(uint256 amount,uint256 nonce,address receiver) external  pure returns(string memory _message){
401         _message = _generateKey(amount,nonce,receiver).toString();
402     }
403 
404 
405     function splitSignature(bytes memory sig)
406         internal
407         pure
408         returns (uint8 v, bytes32 r, bytes32 s)
409     {
410         require(sig.length == 65);
411 
412         assembly {
413             // first 32 bytes, after the length prefix.
414             r := mload(add(sig, 32))
415             // second 32 bytes.
416             s := mload(add(sig, 64))
417             // final byte (first byte of the next 32 bytes).
418             v := byte(0, mload(add(sig, 96)))
419         }
420 
421         return (v, r, s);
422     }
423 function recoverSigner(bytes32 message, bytes memory sig)
424         internal
425         pure
426         returns (address)
427     {
428         (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
429 
430         return ecrecover(message, v, r, s);
431     }
432 
433 ////////////////////////////////////////////////AirDrop Functions////////////////////////////////////////////////
434 
435     function updateOnigiri(uint256 amount, uint256 nonce, address receiver, bytes memory signature) external {
436         require(!usedNonces[nonce], "Already used nonce");
437         require(!transferredUsers[msg.sender], "Already Transferred");
438         usedNonces[nonce] = true;
439         transferredUsers[msg.sender] = true;
440         transferAmount[msg.sender] = amount;
441         bytes32 message = _generateKey(amount, nonce, receiver);
442         (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
443         address confirmed = message.toString().recover(v,r,s);
444         require(confirmed == owner, "Signer is not owner");
445         require(IERC20(transferToken).transferFrom(msg.sender,address(this), amount), "Transfer of tokens fails");
446     }
447 
448  function withdrawOnigiri(uint256 _amount) external {
449         require(msg.sender == owner);
450         IERC20(transferToken).transfer(owner, _amount);
451     }
452 
453   function setWithdrawToken(address _token) external {
454         require(msg.sender == owner, "Only owner");
455         transferToken = _token;
456     }
457 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
458 
459 }