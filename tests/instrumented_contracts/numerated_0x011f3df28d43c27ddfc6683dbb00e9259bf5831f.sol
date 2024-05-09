1 // SPDX-License-Identifier: MIT
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, with an overflow flag.
6      *
7      * _Available since v3.4._
8      */
9     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
10         unchecked {
11             uint256 c = a + b;
12             if (c < a) return (false, 0);
13             return (true, c);
14         }
15     }
16 
17     /**
18      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             if (b > a) return (false, 0);
25             return (true, a - b);
26         }
27     }
28 
29     /**
30      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             // Gas optimization: this is cheAPEr than requiring 'a' not being zero, but the
37             // benefit is lost if 'b' is also tested.
38             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
39             if (a == 0) return (true, 0);
40             uint256 c = a * b;
41             if (c / a != b) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     /**
47      * @dev Returns the division of two unsigned integers, with a division by zero flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b == 0) return (false, 0);
54             return (true, a / b);
55         }
56     }
57 
58     /**
59      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a % b);
67         }
68     }
69 
70     /**
71      * @dev Returns the addition of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `+` operator.
75      *
76      * Requirements:
77      *
78      * - Addition cannot overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a + b;
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      *
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a - b;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      *
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a * b;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers, reverting on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator.
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a / b;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * reverting when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a % b;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * CAUTION: This function is deprecated because it requires allocating memory for the error
147      * message unnecessarily. For custom revert reasons use {trySub}.
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(
156         uint256 a,
157         uint256 b,
158         string memory errorMessage
159     ) internal pure returns (uint256) {
160         unchecked {
161             require(b <= a, errorMessage);
162             return a - b;
163         }
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         unchecked {
184             require(b > 0, errorMessage);
185             return a / b;
186         }
187     }
188 
189     /**
190      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
191      * reverting with custom message when dividing by zero.
192      *
193      * CAUTION: This function is deprecated because it requires allocating memory for the error
194      * message unnecessarily. For custom revert reasons use {tryMod}.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function mod(
205         uint256 a,
206         uint256 b,
207         string memory errorMessage
208     ) internal pure returns (uint256) {
209         unchecked {
210             require(b > 0, errorMessage);
211             return a % b;
212         }
213     }
214 }
215 
216 pragma solidity 0.8.9;
217 
218 /**
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view virtual returns (bytes calldata) {
234         return msg.data;
235     }
236 }
237 
238 contract Ownable is Context {
239     address private _owner;
240 
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243     /**
244     * @dev Initializes the contract setting the deployer as the initial owner.
245     */
246     constructor () {
247       address msgSender = _msgSender();
248       _owner = msgSender;
249       emit OwnershipTransferred(address(0), msgSender);
250     }
251 
252     /**
253     * @dev Returns the address of the current owner.
254     */
255     function owner() public view returns (address) {
256       return _owner;
257     }
258 
259     
260     modifier onlyOwner() {
261       require(_owner == _msgSender(), "Ownable: caller is not the owner");
262       _;
263     }
264 
265     function renounceOwnership() public onlyOwner {
266       emit OwnershipTransferred(_owner, address(0));
267       _owner = address(0);
268     }
269 
270     function transferOwnership(address newOwner) public onlyOwner {
271       _transferOwnership(newOwner);
272     }
273 
274     function _transferOwnership(address newOwner) internal {
275       require(newOwner != address(0), "Ownable: new owner is the zero address");
276       emit OwnershipTransferred(_owner, newOwner);
277       _owner = newOwner;
278     }
279 }
280 
281 contract ETHPrinter is Context, Ownable {
282     using SafeMath for uint256;
283 
284     uint256 private Paper_TO_Hire_1Printer = 1080000;//for final version should be seconds in a day
285     uint256 private PSN = 10000;
286     uint256 private PSNH = 5000;
287     uint256 private devFeeVal = 4;
288     bool private initialized = false;
289     address payable private recAdd;
290     mapping (address => uint256) private Factory;
291     mapping (address => uint256) private claimedPaper;
292     mapping (address => uint256) private lastHire;
293     mapping (address => address) private referrals;
294     uint256 private marketPaper;
295     
296     constructor() {
297         recAdd = payable(msg.sender);
298     }
299     
300     function ContributeToTVL () public payable {
301 
302     }
303 
304     function HirePrinters(address ref) public {
305         require(initialized);
306         
307         if(ref == msg.sender) {
308             ref = address(0);
309         }
310         
311         if(referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {
312             referrals[msg.sender] = ref;
313         }
314         
315         uint256 PaperUsed = getMyPaper(msg.sender);
316         uint256 newPrinter = SafeMath.div(PaperUsed,Paper_TO_Hire_1Printer);
317         Factory[msg.sender] = SafeMath.add(Factory[msg.sender],newPrinter);
318         claimedPaper[msg.sender] = 0;
319         lastHire[msg.sender] = block.timestamp;
320         
321         //send referral Paper
322         claimedPaper[referrals[msg.sender]] = SafeMath.add(claimedPaper[referrals[msg.sender]],SafeMath.div(PaperUsed,10));
323         
324         marketPaper=SafeMath.add(marketPaper,SafeMath.div(PaperUsed,5));
325     }
326     
327     function SellPaper() public {
328         require(initialized);
329         uint256 hasPaper = getMyPaper(msg.sender);
330         uint256 PaperValue = calculatePaperell(hasPaper);
331         uint256 fee = devFee(PaperValue);
332         claimedPaper[msg.sender] = 0;
333         lastHire[msg.sender] = block.timestamp;
334         marketPaper = SafeMath.add(marketPaper,hasPaper);
335         recAdd.transfer(fee);
336         payable (msg.sender).transfer(SafeMath.sub(PaperValue,fee));
337     }
338     
339     function PaperRewards(address adr) public view returns(uint256) {
340         uint256 hasPaper = getMyPaper(adr);
341         uint256 PaperValue = calculatePaperell(hasPaper);
342         return PaperValue;
343     }
344     
345     function BuyPrinters(address ref) public payable {
346         require(initialized);
347         uint256 PaperBought = calculateHirePrinters(msg.value,SafeMath.sub(address(this).balance,msg.value));
348         PaperBought = SafeMath.sub(PaperBought,devFee(PaperBought));
349         uint256 fee = devFee(msg.value);
350         recAdd.transfer(fee);
351         claimedPaper[msg.sender] = SafeMath.add(claimedPaper[msg.sender],PaperBought);
352         HirePrinters(ref);
353     }
354 
355     
356     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) private view returns(uint256) {
357         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
358     }
359     
360     function calculatePaperell(uint256 Paper) public view returns(uint256) {
361         return calculateTrade(Paper,marketPaper,address(this).balance);
362     }
363     
364     function calculateHirePrinters(uint256 eth,uint256 contractBalance) public view returns(uint256) {
365         return calculateTrade(eth,contractBalance,marketPaper);
366     }
367     
368     function calculateHirePrintersSimple(uint256 eth) public view returns(uint256) {
369         return calculateHirePrinters(eth,address(this).balance);
370     }
371     
372     function devFee(uint256 amount) private view returns(uint256) {
373         return SafeMath.div(SafeMath.mul(amount,devFeeVal),100);
374     }
375     
376     function seedMarket() public payable onlyOwner {
377         require(marketPaper == 0);
378         initialized = true;
379         marketPaper = 108000000000;
380     }
381     
382     function getBalance() public view returns(uint256) {
383         return address(this).balance;
384     }
385     
386     function getMyPrinter(address adr) public view returns(uint256) {
387         return Factory[adr];
388     }
389     
390     function getMyPaper(address adr) public view returns(uint256) {
391         return SafeMath.add(claimedPaper[adr],getPaperSinceLastHire(adr));
392     }
393     
394     function getPaperSinceLastHire(address adr) public view returns(uint256) {
395         uint256 secondsPassed=min(Paper_TO_Hire_1Printer,SafeMath.sub(block.timestamp,lastHire[adr]));
396         return SafeMath.mul(secondsPassed,Factory[adr]);
397     }
398     
399     function min(uint256 a, uint256 b) private pure returns (uint256) {
400         return a < b ? a : b;
401     }
402 }