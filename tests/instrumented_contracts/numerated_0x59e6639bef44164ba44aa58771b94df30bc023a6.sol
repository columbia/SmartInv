1 pragma solidity = 0.5.16;
2 
3 contract Ownable {
4 
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev Initializes the contract setting the deployer as the initial owner.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), msg.sender);
15     }
16 
17     /**
18      * @dev Returns the address of the current owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(_owner == msg.sender, "YouSwap: CALLER_IS_NOT_THE_OWNER");
29         _;
30     }
31 
32     /**
33      * @dev Leaves the contract without owner. It will not be possible to call
34      * `onlyOwner` functions anymore. Can only be called by the current owner.
35      *
36      * NOTE: Renouncing ownership will leave the contract without an owner,
37      * thereby removing any functionality that is only available to the owner.
38      */
39     function renounceOwnership() public onlyOwner {
40         emit OwnershipTransferred(_owner, address(0));
41         _owner = address(0);
42     }
43 
44     /**
45      * @dev Transfers ownership of the contract to a new account (`newOwner`).
46      * Can only be called by the current owner.
47      */
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0), "YouSwap: NEW_OWNER_IS_THE_ZERO_ADDRESS");
50         emit OwnershipTransferred(_owner, newOwner);
51         _owner = newOwner;
52     }
53 }
54 
55 library SafeMath {
56     /**
57      * @dev Returns the addition of two unsigned integers, reverting on
58      * overflow.
59      *
60      * Counterpart to Solidity's `+` operator.
61      *
62      * Requirements:
63      *
64      * - Addition cannot overflow.
65      */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      *
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the multiplication of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `*` operator.
109      *
110      * Requirements:
111      *
112      * - Multiplication cannot overflow.
113      */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         return mod(a, b, "SafeMath: modulo by zero");
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * Reverts with custom message when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b != 0, errorMessage);
194         return a % b;
195     }
196 }
197 
198 contract IDO is Ownable {
199     using SafeMath for uint256;
200 
201     //Private offering
202     mapping(address => uint256) private _ordersOfPriIDO;
203     uint256 public startHeightOfPriIDO;
204     uint256 public endHeightOfPriIDO;
205     uint256 public totalUsdtAmountOfPriIDO = 0;
206     uint256 public constant supplyYouForPriIDO = 5 * 10 ** 11;//50万YOU
207     uint256 public reservedYouOfPriIDO = 0;
208     uint256 public constant upperLimitUsdtOfPriIDO = 500 * 10 ** 6;//500USDT
209     bool private _priOfferingFinished = false;
210     bool private _priIDOWithdrawFinished = false;
211 
212     event PrivateOffering(address indexed participant, uint256 amountOfYou, uint256 amountOfUsdt);
213     event PrivateOfferingClaimed(address indexed participant, uint256 amountOfYou);
214 
215     //Public offering
216     mapping(address => uint256) private _ordersOfPubIDO;
217     uint256 public constant targetUsdtAmountOfPubIDO = 5 * 10 ** 10;//5万USDT
218     uint256 public constant targetYouAmountOfPubIDO = 5 * 10 ** 11;//50万YOU
219     uint256 public totalUsdtAmountOfPubIDO = 0;
220     uint256 public startHeightOfPubIDO;
221     uint256 public endHeightOfPubIDO;
222     uint256 public constant bottomLimitUsdtOfPubIDO = 100 * 10 ** 6; //100USDT
223     bool private _pubIDOWithdrawFinished = false;
224 
225     event PublicOffering(address indexed participant, uint256 amountOfUsdt);
226     event PublicOfferingClaimed(address indexed participant, uint256 amountOfYou);
227     event PublicOfferingRefund(address indexed participant, uint256 amountOfUsdt);
228 
229     mapping(address => uint8) private _whiteList;
230 
231     address private constant _usdtToken = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
232     address private _youToken;
233 
234     uint256 public constant initialLiquidYou = 3 * 10 ** 12;//3 000 000YOU For initial Liquid
235     address private constant _vault = 0x6B5C21a770dA1621BB28C9a2b6F282E5FC9154d5;
236 
237     uint private unlocked = 1;
238     constructor(address youToken) public {
239         _youToken = youToken;
240 
241         startHeightOfPriIDO = 12047150;
242         endHeightOfPriIDO = 12048590;
243 
244         startHeightOfPubIDO = 0;
245         endHeightOfPubIDO = 0;
246     }
247 
248     modifier lock() {
249         require(unlocked == 1, 'YouSwap: LOCKED');
250         unlocked = 0;
251         _;
252         unlocked = 1;
253     }
254 
255     function initPubIDO(uint256 startHOfPubIDO, uint256 endHOfPubIDO) onlyOwner public {
256         require(startHeightOfPubIDO == 0 && startHOfPubIDO > block.number && endHOfPubIDO > startHOfPubIDO, 'YouSwap:NOT_ALLOWED');
257 
258         startHeightOfPubIDO = startHOfPubIDO;
259         endHeightOfPubIDO = endHOfPubIDO;
260     }
261 
262     modifier inWhiteList() {
263         require(_whiteList[msg.sender] == 1, "YouSwap: NOT_IN_WHITE_LIST");
264         _;
265     }
266 
267     function isInWhiteList(address account) external view returns (bool) {
268         return _whiteList[account] == 1;
269     }
270 
271     function addToWhiteList(address account) external onlyOwner {
272         _whiteList[account] = 1;
273     }
274 
275     function addBatchToWhiteList(address[] calldata accounts) external onlyOwner {
276         for (uint i = 0; i < accounts.length; i++) {
277             _whiteList[accounts[i]] = 1;
278         }
279     }
280 
281     function removeFromWhiteList(address account) external onlyOwner {
282         _whiteList[account] = 0;
283     }
284 
285     function claim() inWhiteList external lock {
286         require((block.number >= endHeightOfPriIDO && _ordersOfPriIDO[msg.sender] > 0)
287             || (block.number >= endHeightOfPubIDO && _ordersOfPubIDO[msg.sender] > 0), 'YouSwap: FORBIDDEN');
288 
289         uint256 reservedYouFromPriIDO = _ordersOfPriIDO[msg.sender];
290         if (block.number >= endHeightOfPriIDO && reservedYouFromPriIDO > 0) {
291             _ordersOfPriIDO[msg.sender] = 0;
292             _mintYou(_youToken, msg.sender, reservedYouFromPriIDO);
293             emit PrivateOfferingClaimed(msg.sender, reservedYouFromPriIDO);
294         }
295 
296         uint256 amountOfUsdtPayed = _ordersOfPubIDO[msg.sender];
297         if (block.number >= endHeightOfPubIDO && amountOfUsdtPayed > 0) {
298             uint256 reservedYouFromPubIDO = 0;
299             if (totalUsdtAmountOfPubIDO > targetUsdtAmountOfPubIDO) {
300                 uint256 availableAmountOfUsdt = amountOfUsdtPayed.mul(targetUsdtAmountOfPubIDO).div(totalUsdtAmountOfPubIDO);
301                 reservedYouFromPubIDO = availableAmountOfUsdt.mul(10);
302                 uint256 usdtAmountToRefund = amountOfUsdtPayed.sub(availableAmountOfUsdt).sub(10);
303 
304                 if (usdtAmountToRefund > 0) {
305                     _transfer(_usdtToken, msg.sender, usdtAmountToRefund);
306                     emit PublicOfferingRefund(msg.sender, usdtAmountToRefund);
307                 }
308             }
309             else {
310                 reservedYouFromPubIDO = amountOfUsdtPayed.mul(10);
311             }
312 
313             _ordersOfPubIDO[msg.sender] = 0;
314             _mintYou(_youToken, msg.sender, reservedYouFromPubIDO);
315             emit PublicOfferingClaimed(msg.sender, reservedYouFromPubIDO);
316         }
317     }
318 
319     function withdrawPriIDO() onlyOwner external {
320         require(block.number > endHeightOfPriIDO, 'YouSwap: BLOCK_HEIGHT_NOT_REACHED');
321         require(!_priIDOWithdrawFinished, 'YouSwap: PRI_IDO_WITHDRAWN_ALREADY');
322 
323         _transfer(_usdtToken, _vault, totalUsdtAmountOfPriIDO);
324 
325         _priIDOWithdrawFinished = true;
326     }
327 
328     function withdrawPubIDO() onlyOwner external {
329         require(block.number > endHeightOfPubIDO, 'YouSwap: BLOCK_HEIGHT_NOT_REACHED');
330         require(!_pubIDOWithdrawFinished, 'YouSwap: PUB_IDO_WITHDRAWN_ALREADY');
331 
332         uint256 amountToWithdraw = totalUsdtAmountOfPubIDO;
333         if (totalUsdtAmountOfPubIDO > targetUsdtAmountOfPubIDO) {
334             amountToWithdraw = targetUsdtAmountOfPubIDO;
335         }
336 
337         _transfer(_usdtToken, _vault, amountToWithdraw);
338         _mintYou(_youToken, _vault, initialLiquidYou);
339 
340         _pubIDOWithdrawFinished = true;
341     }
342 
343     function privateOffering(uint256 amountOfUsdt) inWhiteList external lock returns (bool)  {
344         require(block.number >= startHeightOfPriIDO, 'YouSwap:NOT_STARTED_YET');
345         require(!_priOfferingFinished && block.number <= endHeightOfPriIDO, 'YouSwap:PRIVATE_OFFERING_ALREADY_FINISHED');
346         require(_ordersOfPriIDO[msg.sender] == 0, 'YouSwap: ENROLLED_ALREADY');
347         require(amountOfUsdt <= upperLimitUsdtOfPriIDO, 'YouSwap: EXCEEDS_THE_UPPER_LIMIT');
348         require(amountOfUsdt > 0, "YouSwap: INVALID_AMOUNT");
349 
350         require(reservedYouOfPriIDO < supplyYouForPriIDO, 'YouSwap:INSUFFICIENT_YOU');
351         uint256 amountOfYou = amountOfUsdt.mul(10);
352         //0.1USDT/YOU
353         if (reservedYouOfPriIDO.add(amountOfYou) >= supplyYouForPriIDO) {
354             amountOfYou = supplyYouForPriIDO.sub(reservedYouOfPriIDO);
355             amountOfUsdt = amountOfYou.div(10);
356 
357             _priOfferingFinished = true;
358         }
359         _transferFrom(_usdtToken, amountOfUsdt);
360 
361         _ordersOfPriIDO[msg.sender] = amountOfYou;
362         reservedYouOfPriIDO = reservedYouOfPriIDO.add(amountOfYou);
363         totalUsdtAmountOfPriIDO = totalUsdtAmountOfPriIDO.add(amountOfUsdt);
364         emit PrivateOffering(msg.sender, amountOfYou, amountOfUsdt);
365 
366         return true;
367     }
368 
369     function priOfferingFinished() public view returns (bool) {
370         return block.number > endHeightOfPriIDO || _priOfferingFinished;
371     }
372 
373     function pubOfferingFinished() public view returns (bool) {
374         return block.number > endHeightOfPubIDO;
375     }
376 
377     function publicOffering(uint256 amountOfUsdt) external lock returns (bool)  {
378         require(block.number >= startHeightOfPubIDO, 'YouSwap:PUBLIC_OFFERING_NOT_STARTED_YET');
379         require(block.number <= endHeightOfPubIDO, 'YouSwap:PUBLIC_OFFERING_ALREADY_FINISHED');
380         require(amountOfUsdt >= bottomLimitUsdtOfPubIDO, 'YouSwap: 100USDT_AT_LEAST');
381 
382         _transferFrom(_usdtToken, amountOfUsdt);
383 
384         _ordersOfPubIDO[msg.sender] = _ordersOfPubIDO[msg.sender].add(amountOfUsdt);
385         totalUsdtAmountOfPubIDO = totalUsdtAmountOfPubIDO.add(amountOfUsdt);
386 
387         emit PublicOffering(msg.sender, amountOfUsdt);
388 
389         _whiteList[msg.sender] = 1;
390 
391         return true;
392     }
393 
394     function _transferFrom(address token, uint256 amount) private {
395         bytes4 methodId = bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
396 
397         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(methodId, msg.sender, address(this), amount));
398         require(success && (data.length == 0 || abi.decode(data, (bool))), 'YouSwap: TRANSFER_FAILED');
399     }
400 
401     function _mintYou(address token, address recipient, uint256 amount) private {
402         bytes4 methodId = bytes4(keccak256(bytes('mint(address,uint256)')));
403 
404         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(methodId, recipient, amount));
405         require(success && (data.length == 0 || abi.decode(data, (bool))), 'YouSwap: TRANSFER_FAILED');
406     }
407 
408     function _transfer(address token, address recipient, uint amount) private {
409         bytes4 methodId = bytes4(keccak256(bytes('transfer(address,uint256)')));
410 
411         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(methodId, recipient, amount));
412         require(success && (data.length == 0 || abi.decode(data, (bool))), 'YouSwap: TRANSFER_FAILED');
413     }
414 }