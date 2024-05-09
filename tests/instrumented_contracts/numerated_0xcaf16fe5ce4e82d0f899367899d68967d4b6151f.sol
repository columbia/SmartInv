1 /**
2 TG: https://t.me/RabbithereumETH
3 */
4 
5 // SPDX-License-Identifier: MIT
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, with an overflow flag.
9      *
10      * _Available since v3.4._
11      */
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         unchecked {
14             uint256 c = a + b;
15             if (c < a) return (false, 0);
16             return (true, c);
17         }
18     }
19 
20     /**
21      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             if (b > a) return (false, 0);
28             return (true, a - b);
29         }
30     }
31 
32     /**
33      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40             // benefit is lost if 'b' is also tested.
41             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
42             if (a == 0) return (true, 0);
43             uint256 c = a * b;
44             if (c / a != b) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     /**
50      * @dev Returns the division of two unsigned integers, with a division by zero flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b == 0) return (false, 0);
57             return (true, a / b);
58         }
59     }
60 
61     /**
62      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a % b);
70         }
71     }
72 
73     /**
74      * @dev Returns the addition of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `+` operator.
78      *
79      * Requirements:
80      *
81      * - Addition cannot overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a + b;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a - b;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      *
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a * b;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers, reverting on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator.
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a / b;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * reverting when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a % b;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * CAUTION: This function is deprecated because it requires allocating memory for the error
150      * message unnecessarily. For custom revert reasons use {trySub}.
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         unchecked {
164             require(b <= a, errorMessage);
165             return a - b;
166         }
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(
182         uint256 a,
183         uint256 b,
184         string memory errorMessage
185     ) internal pure returns (uint256) {
186         unchecked {
187             require(b > 0, errorMessage);
188             return a / b;
189         }
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * reverting with custom message when dividing by zero.
195      *
196      * CAUTION: This function is deprecated because it requires allocating memory for the error
197      * message unnecessarily. For custom revert reasons use {tryMod}.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a % b;
215         }
216     }
217 }
218 
219 pragma solidity 0.8.17;
220 
221 /**
222  * @dev Provides information about the current execution context, including the
223  * sender of the transaction and its data. While these are generally available
224  * via msg.sender and msg.data, they should not be accessed in such a direct
225  * manner, since when dealing with meta-transactions the account sending and
226  * paying for execution may not be the actual sender (as far as an application
227  * is concerned).
228  *
229  * This contract is only required for intermediate, library-like contracts.
230  */
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes calldata) {
237         return msg.data;
238     }
239 }
240 
241 contract Ownable is Context {
242     address private _owner;
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246     /**
247     * @dev Initializes the contract setting the deployer as the initial owner.
248     */
249     constructor () {
250       address msgSender = _msgSender();
251       _owner = msgSender;
252       emit OwnershipTransferred(address(0), msgSender);
253     }
254 
255     /**
256     * @dev Returns the address of the current owner.
257     */
258     function owner() public view returns (address) {
259       return _owner;
260     }
261 
262     
263     modifier onlyOwner() {
264       require(_owner == _msgSender(), "Ownable: caller is not the owner");
265       _;
266     }
267 
268     function renounceOwnership() public onlyOwner {
269       emit OwnershipTransferred(_owner, address(0));
270       _owner = address(0);
271     }
272 
273     function transferOwnership(address newOwner) public onlyOwner {
274       _transferOwnership(newOwner);
275     }
276 
277     function _transferOwnership(address newOwner) internal {
278       require(newOwner != address(0), "Ownable: new owner is the zero address");
279       emit OwnershipTransferred(_owner, newOwner);
280       _owner = newOwner;
281     }
282 }
283 
284 contract CARRETHMiNER is Context, Ownable {
285     using SafeMath for uint256;
286 
287     uint256 private CARRETHS_TO_HARVEST_1MINERS = 1080000;//for final version should be seconds in a day
288     uint256 private PSN = 10000;
289     uint256 private PSNH = 5000;
290     uint256 private devFeeVal = 4;
291     bool private initialized = false;
292     address payable private recAdd;
293     mapping (address => uint256) private harvestingMiners;
294     mapping (address => uint256) private claimedcarreths;
295     mapping (address => uint256) private lastHarvest;
296     mapping (address => address) private referrals;
297     uint256 private marketcarreths;
298     
299     constructor() {
300         recAdd = payable(msg.sender);
301     }
302     
303     function Harvestcarreths(address ref) public {
304         require(initialized);
305         
306         if(ref == msg.sender) {
307             ref = address(0);
308         }
309         
310         if(referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {
311             referrals[msg.sender] = ref;
312         }
313         
314         uint256 carrethsUsed = getMycarreths(msg.sender);
315         uint256 newMiners = SafeMath.div(carrethsUsed,CARRETHS_TO_HARVEST_1MINERS);
316         harvestingMiners[msg.sender] = SafeMath.add(harvestingMiners[msg.sender],newMiners);
317         claimedcarreths[msg.sender] = 0;
318         lastHarvest[msg.sender] = block.timestamp;
319         
320         //send referral carreths
321         claimedcarreths[referrals[msg.sender]] = SafeMath.add(claimedcarreths[referrals[msg.sender]],SafeMath.div(carrethsUsed,8));
322         
323         //boost market to nerf miners hoarding
324         marketcarreths=SafeMath.add(marketcarreths,SafeMath.div(carrethsUsed,5));
325     }
326     
327     function sellcarreths() public {
328         require(initialized);
329         uint256 hascarreths = getMycarreths(msg.sender);
330         uint256 carrethValue = calculatecarrethsell(hascarreths);
331         uint256 fee = devFee(carrethValue);
332         claimedcarreths[msg.sender] = 0;
333         lastHarvest[msg.sender] = block.timestamp;
334         marketcarreths = SafeMath.add(marketcarreths,hascarreths);
335         recAdd.transfer(fee);
336         payable (msg.sender).transfer(SafeMath.sub(carrethValue,fee));
337     }
338     
339     function ethRewards(address adr) public view returns(uint256) {
340         uint256 hascarreths = getMycarreths(adr);
341         uint256 carrethValue = calculatecarrethsell(hascarreths);
342         return carrethValue;
343     }
344     
345     function buycarreths(address ref) public payable {
346         require(initialized);
347         uint256 carrethsBought = calculatecarrethBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
348         carrethsBought = SafeMath.sub(carrethsBought,devFee(carrethsBought));
349         uint256 fee = devFee(msg.value);
350         recAdd.transfer(fee);
351         claimedcarreths[msg.sender] = SafeMath.add(claimedcarreths[msg.sender],carrethsBought);
352         Harvestcarreths(ref);
353     }
354     
355     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) private view returns(uint256) {
356         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
357     }
358     
359     function calculatecarrethsell(uint256 carreths) public view returns(uint256) {
360         return calculateTrade(carreths,marketcarreths,address(this).balance);
361     }
362     
363     function calculatecarrethBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
364         return calculateTrade(eth,contractBalance,marketcarreths);
365     }
366     
367     function calculatecarrethBuySimple(uint256 eth) public view returns(uint256) {
368         return calculatecarrethBuy(eth,address(this).balance);
369     }
370     
371     function devFee(uint256 amount) private view returns(uint256) {
372         return SafeMath.div(SafeMath.mul(amount,devFeeVal),100);
373     }
374     
375     function seedMarket() public payable onlyOwner {
376         require(marketcarreths == 0);
377         initialized = true;
378         marketcarreths = 108000000000;
379     }
380     
381     function getBalance() public view returns(uint256) {
382         return address(this).balance;
383     }
384     
385     function getMyMiners(address adr) public view returns(uint256) {
386         return harvestingMiners[adr];
387     }
388     
389     function getMycarreths(address adr) public view returns(uint256) {
390         return SafeMath.add(claimedcarreths[adr],getcarrethsSinceLastHarvest(adr));
391     }
392     
393     function getcarrethsSinceLastHarvest(address adr) public view returns(uint256) {
394         uint256 secondsPassed=min(CARRETHS_TO_HARVEST_1MINERS,SafeMath.sub(block.timestamp,lastHarvest[adr]));
395         return SafeMath.mul(secondsPassed,harvestingMiners[adr]);
396     }
397     
398     function min(uint256 a, uint256 b) private pure returns (uint256) {
399         return a < b ? a : b;
400     }
401 }