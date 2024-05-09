1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: contracts/interfaces/IERC20Sumswap.sol
99 
100 pragma solidity >=0.5.0;
101 
102 interface IERC20Sumswap{
103     event Approval(address indexed owner, address indexed spender, uint value);
104     event Transfer(address indexed from, address indexed to, uint value);
105 
106     function name() external view returns (string memory);
107     function symbol() external view returns (string memory);
108     function decimals() external view returns (uint8);
109     function totalSupply() external view returns (uint);
110     function balanceOf(address owner) external view returns (uint);
111     function allowance(address owner, address spender) external view returns (uint);
112 
113     function approve(address spender, uint value) external returns (bool);
114     function transfer(address to, uint value) external returns (bool);
115     function transferFrom(address from, address to, uint value) external returns (bool);
116 }
117 
118 // File: @openzeppelin/contracts/math/SafeMath.sol
119 
120 
121 
122 pragma solidity >=0.6.0 <0.8.0;
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      *
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return div(a, b, "SafeMath: division by zero");
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b > 0, errorMessage);
240         uint256 c = a / b;
241         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b != 0, errorMessage);
276         return a % b;
277     }
278 }
279 
280 // File: contracts/interfaces/IAccessControl.sol
281 
282 pragma solidity ^0.6.0;
283 
284 interface IAccessControl {
285     function hasRole(bytes32 role, address account) external view returns (bool);
286 }
287 
288 // File: contracts/TokenIssue.sol
289 
290 pragma solidity ^0.6.0;
291 
292 
293 
294 
295 
296 interface ISumma {
297     function issue(address addr, uint256 amount) external;
298 }
299 
300 contract TokenIssue is Ownable {
301 
302     using SafeMath for uint256;
303 
304     uint256 public constant INIT_MINE_SUPPLY = 32000000 * 10 ** 18;
305 
306     uint256 public issuedAmount = INIT_MINE_SUPPLY;
307 
308     uint256 public surplusAmount = 2.88 * 10 ** 8 * 10 ** 18;
309 
310     uint256 public TOTAL_AMOUNT = 3.2 * 10 ** 8 * 10 ** 18;
311 
312     uint256 public constant MONTH_SECONDS = 225 * 24 * 30;
313 
314     bytes32 public constant TRANS_ROLE = keccak256("TRANS_ROLE");
315 
316     // utc 2021-05-01
317     //    uint256 public startIssueTime = 0;
318     uint256 public startIssueTime = 0;
319 
320     address public summa;
321 
322     address public summaPri;
323 
324     uint256[] public issueInfo;
325 
326     constructor(address _summa,address _summaPri) public {
327         summa = _summa;
328         summaPri = _summaPri;
329         initialize();
330     }
331 
332     function initialize() private {
333         issueInfo.push(1920000 * 10 ** 18);
334         issueInfo.push(2035200 * 10 ** 18);
335         issueInfo.push(2157312.0000000005 * 10 ** 18);
336         issueInfo.push(2286750.72 * 10 ** 18);
337         issueInfo.push(2423955.763200001 * 10 ** 18);
338         issueInfo.push(2569393.108992 * 10 ** 18);
339         issueInfo.push(2723556.6955315205 * 10 ** 18);
340         issueInfo.push(2886970.0972634126 * 10 ** 18);
341         issueInfo.push(3060188.303099217 * 10 ** 18);
342         issueInfo.push(3243799.6012851703 * 10 ** 18);
343         issueInfo.push(3438427.577362281 * 10 ** 18);
344         issueInfo.push(3644733.232004018 * 10 ** 18);
345         issueInfo.push(2575611.4839495043 * 10 ** 18);
346         issueInfo.push(2678635.943307485 * 10 ** 18);
347         issueInfo.push(2785781.3810397848 * 10 ** 18);
348         issueInfo.push(2897212.636281376 * 10 ** 18);
349         issueInfo.push(3013101.141732631 * 10 ** 18);
350         issueInfo.push(3133625.187401936 * 10 ** 18);
351         issueInfo.push(3258970.1948980135 * 10 ** 18);
352         issueInfo.push(3389329.0026939344 * 10 ** 18);
353         issueInfo.push(3524902.1628016927 * 10 ** 18);
354         issueInfo.push(3665898.24931376 * 10 ** 18);
355         issueInfo.push(3812534.17928631 * 10 ** 18);
356         issueInfo.push(3965035.546457763 * 10 ** 18);
357         issueInfo.push(2061818.484158036 * 10 ** 18);
358         issueInfo.push(2103054.8538411967 * 10 ** 18);
359         issueInfo.push(2145115.9509180207 * 10 ** 18);
360         issueInfo.push(2188018.269936382 * 10 ** 18);
361         issueInfo.push(2231778.6353351087 * 10 ** 18);
362         issueInfo.push(2276414.208041811 * 10 ** 18);
363         issueInfo.push(2321942.4922026475 * 10 ** 18);
364         issueInfo.push(2368381.3420467 * 10 ** 18);
365         issueInfo.push(2415748.9688876346 * 10 ** 18);
366         issueInfo.push(2464063.948265387 * 10 ** 18);
367         issueInfo.push(2513345.227230695 * 10 ** 18);
368         issueInfo.push(2563612.131775309 * 10 ** 18);
369         issueInfo.push(2614884.3744108155 * 10 ** 18);
370         issueInfo.push(2667182.061899032 * 10 ** 18);
371         issueInfo.push(2720525.703137012 * 10 ** 18);
372         issueInfo.push(2774936.2171997526 * 10 ** 18);
373         issueInfo.push(2830434.941543747 * 10 ** 18);
374         issueInfo.push(2887043.6403746223 * 10 ** 18);
375         issueInfo.push(2944784.513182115 * 10 ** 18);
376         issueInfo.push(3003680.2034457573 * 10 ** 18);
377         issueInfo.push(3063753.807514673 * 10 ** 18);
378         issueInfo.push(3125028.883664966 * 10 ** 18);
379         issueInfo.push(3187529.461338266 * 10 ** 18);
380         issueInfo.push(3251280.0505650314 * 10 ** 18);
381         issueInfo.push(1658152.825788165 * 10 ** 18);
382         issueInfo.push(1674734.3540460467 * 10 ** 18);
383         issueInfo.push(1691481.6975865073 * 10 ** 18);
384         issueInfo.push(1708396.5145623726 * 10 ** 18);
385         issueInfo.push(1725480.479707996 * 10 ** 18);
386         issueInfo.push(1742735.2845050762 * 10 ** 18);
387         issueInfo.push(1760162.6373501269 * 10 ** 18);
388         issueInfo.push(1777764.263723628 * 10 ** 18);
389         issueInfo.push(1795541.9063608644 * 10 ** 18);
390         issueInfo.push(1813497.3254244728 * 10 ** 18);
391         issueInfo.push(1831632.2986787176 * 10 ** 18);
392         issueInfo.push(1849948.621665505 * 10 ** 18);
393         issueInfo.push(1868448.10788216 * 10 ** 18);
394         issueInfo.push(1887132.5889609817 * 10 ** 18);
395         issueInfo.push(1906003.9148505912 * 10 ** 18);
396         issueInfo.push(1925063.9539990975 * 10 ** 18);
397         issueInfo.push(1944314.5935390887 * 10 ** 18);
398         issueInfo.push(1963757.7394744793 * 10 ** 18);
399         issueInfo.push(1983395.316869224 * 10 ** 18);
400         issueInfo.push(2003229.2700379163 * 10 ** 18);
401         issueInfo.push(2023261.5627382956 * 10 ** 18);
402         issueInfo.push(2043494.1783656788 * 10 ** 18);
403         issueInfo.push(2063929.1201493354 * 10 ** 18);
404         issueInfo.push(2084568.4113508288 * 10 ** 18);
405         issueInfo.push(2105414.0954643367 * 10 ** 18);
406         issueInfo.push(2126468.23641898 * 10 ** 18);
407         issueInfo.push(2147732.91878317 * 10 ** 18);
408         issueInfo.push(2169210.247971002 * 10 ** 18);
409         issueInfo.push(2190902.350450712 * 10 ** 18);
410         issueInfo.push(2212811.373955219 * 10 ** 18);
411         issueInfo.push(2234939.4876947715 * 10 ** 18);
412         issueInfo.push(2257288.882571719 * 10 ** 18);
413         issueInfo.push(2279861.7713974365 * 10 ** 18);
414         issueInfo.push(2302660.389111411 * 10 ** 18);
415         issueInfo.push(2325686.9930025246 * 10 ** 18);
416         issueInfo.push(2348943.8629325503 * 10 ** 18);
417         issueInfo.push(1897946.6412495002 * 10 ** 18);
418         issueInfo.push(1913130.2143794964 * 10 ** 18);
419         issueInfo.push(1928435.2560945326 * 10 ** 18);
420         issueInfo.push(1943862.7381432885 * 10 ** 18);
421         issueInfo.push(1959413.6400484347 * 10 ** 18);
422         issueInfo.push(1975088.9491688225 * 10 ** 18);
423         issueInfo.push(1990889.6607621727 * 10 ** 18);
424         issueInfo.push(2006816.7780482706 * 10 ** 18);
425         issueInfo.push(2022871.3122726567 * 10 ** 18);
426         issueInfo.push(2039054.282770838 * 10 ** 18);
427         issueInfo.push(2055366.7170330046 * 10 ** 18);
428         issueInfo.push(2071809.6507692689 * 10 ** 18);
429         issueInfo.push(2088384.1279754227 * 10 ** 18);
430         issueInfo.push(2105091.200999226 * 10 ** 18);
431         issueInfo.push(2121931.93060722 * 10 ** 18);
432         issueInfo.push(2138907.386052078 * 10 ** 18);
433         issueInfo.push(2156018.645140494 * 10 ** 18);
434         issueInfo.push(2173266.794301619 * 10 ** 18);
435         issueInfo.push(2190652.928656032 * 10 ** 18);
436         issueInfo.push(2208178.15208528 * 10 ** 18);
437         issueInfo.push(2225843.5773019614 * 10 ** 18);
438         issueInfo.push(2243650.3259203774 * 10 ** 18);
439         issueInfo.push(2261599.528527741 * 10 ** 18);
440         issueInfo.push(2279692.324755963 * 10 ** 18);
441         issueInfo.push(2297929.86335401 * 10 ** 18);
442         issueInfo.push(2316313.302260842 * 10 ** 18);
443         issueInfo.push(2334843.8086789288 * 10 ** 18);
444         issueInfo.push(2353522.559148361 * 10 ** 18);
445         issueInfo.push(2372350.7396215475 * 10 ** 18);
446         issueInfo.push(2391329.54553852 * 10 ** 18);
447         issueInfo.push(2410460.1819028277 * 10 ** 18);
448         issueInfo.push(2429743.8633580506 * 10 ** 18);
449         issueInfo.push(2449181.8142649154 * 10 ** 18);
450         issueInfo.push(2468775.2687790347 * 10 ** 18);
451         issueInfo.push(2488525.470929267 * 10 ** 18);
452         issueInfo.push(2508433.674696701 * 10 ** 18);
453         issueInfo.push(2528501.1440942744 * 10 ** 18);
454         issueInfo.push(2548729.153247029 * 10 ** 18);
455     }
456 
457     function issueInfoLength() external view returns (uint256) {
458         return issueInfo.length;
459     }
460 
461     function currentCanIssueAmount() public view returns (uint256){
462         uint256 currentTime = block.number;
463         if (currentTime <= startIssueTime || startIssueTime <= 0) {
464             return INIT_MINE_SUPPLY.sub(issuedAmount);
465         }
466         uint256 timeInterval = currentTime - startIssueTime;
467         uint256 monthIndex = timeInterval.div(MONTH_SECONDS);
468         if (monthIndex < 1) {
469             return issueInfo[monthIndex].div(MONTH_SECONDS).mul(timeInterval).add(INIT_MINE_SUPPLY).sub(issuedAmount);
470         } else if (monthIndex < issueInfo.length) {
471             uint256 tempTotal = INIT_MINE_SUPPLY;
472             for (uint256 j = 0; j < monthIndex; j++) {
473                 tempTotal = tempTotal.add(issueInfo[j]);
474             }
475             uint256 calcAmount = timeInterval.sub(monthIndex.mul(MONTH_SECONDS)).mul(issueInfo[monthIndex].div(MONTH_SECONDS)).add(tempTotal);
476             if (calcAmount > TOTAL_AMOUNT) {
477                 return TOTAL_AMOUNT.sub(issuedAmount);
478             }
479             return calcAmount.sub(issuedAmount);
480         } else {
481             return TOTAL_AMOUNT.sub(issuedAmount);
482         }
483     }
484 
485     function currentBlockCanIssueAmount() public view returns (uint256){
486         uint256 currentTime = block.number;
487         if (currentTime <= startIssueTime || startIssueTime <= 0) {
488             return 0;
489         }
490         uint256 timeInterval = currentTime - startIssueTime;
491         uint256 monthIndex = timeInterval.div(MONTH_SECONDS);
492         if (monthIndex < 1) {
493             return issueInfo[monthIndex].div(MONTH_SECONDS);
494         } else if (monthIndex < issueInfo.length) {
495             uint256 tempTotal = INIT_MINE_SUPPLY;
496             for (uint256 j = 0; j < monthIndex; j++) {
497                 tempTotal = tempTotal.add(issueInfo[j]);
498             }
499             uint256 actualBlockIssue = issueInfo[monthIndex].div(MONTH_SECONDS);
500             uint256 calcAmount = timeInterval.sub(monthIndex.mul(MONTH_SECONDS)).mul(issueInfo[monthIndex].div(MONTH_SECONDS)).add(tempTotal);
501             if (calcAmount > TOTAL_AMOUNT) {
502                 if (calcAmount.sub(TOTAL_AMOUNT) <= actualBlockIssue) {
503                     return actualBlockIssue.sub(calcAmount.sub(TOTAL_AMOUNT));
504                 }
505                 return 0;
506             }
507             return actualBlockIssue;
508         } else {
509             return 0;
510         }
511 
512     }
513 
514     function issueAnyOne() public {
515         uint256 currentCanIssue = currentCanIssueAmount();
516         if (currentCanIssue > 0) {
517             issuedAmount = issuedAmount.add(currentCanIssue);
518             surplusAmount = surplusAmount.sub(currentCanIssue);
519             ISumma(summa).issue(address(this), currentCanIssue);
520         }
521     }
522 
523     function withdrawETH() public onlyOwner {
524         msg.sender.transfer(address(this).balance);
525     }
526 
527     function setStart() public onlyOwner {
528         if (startIssueTime <= 0) {
529             startIssueTime = block.number;
530         }
531     }
532 
533     function transByContract(address to,uint256 amount) public{
534         require(IAccessControl(summaPri).hasRole(TRANS_ROLE, _msgSender()), "Caller is not a transfer role");
535         if(amount > IERC20Sumswap(summa).balanceOf(address(this))){
536             issueAnyOne();
537         }
538         require(amount <= IERC20Sumswap(summa).balanceOf(address(this)),"not enough,please check code");
539         IERC20Sumswap(summa).transfer(to,amount);
540     }
541 
542     function withdrawToken(address addr) public onlyOwner {
543         IERC20Sumswap(addr).transfer(_msgSender(), IERC20Sumswap(addr).balanceOf(address(this)));
544     }
545 
546     receive() external payable {
547     }
548 }