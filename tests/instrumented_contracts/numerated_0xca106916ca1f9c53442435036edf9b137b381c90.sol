1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations.
10  *
11  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
12  * now has built in overflow checking.
13  */
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, with an overflow flag.
17      *
18      * _Available since v3.4._
19      */
20     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     /**
29      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48             // benefit is lost if 'b' is also tested.
49             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50             if (a == 0) return (true, 0);
51             uint256 c = a * b;
52             if (c / a != b) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b == 0) return (false, 0);
65             return (true, a / b);
66         }
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a % b);
78         }
79     }
80 
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a + b;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a - b;
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      *
117      * - Multiplication cannot overflow.
118      */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a * b;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator.
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a / b;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * reverting when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a % b;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * CAUTION: This function is deprecated because it requires allocating memory for the error
158      * message unnecessarily. For custom revert reasons use {trySub}.
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         unchecked {
172             require(b <= a, errorMessage);
173             return a - b;
174         }
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(
190         uint256 a,
191         uint256 b,
192         string memory errorMessage
193     ) internal pure returns (uint256) {
194         unchecked {
195             require(b > 0, errorMessage);
196             return a / b;
197         }
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * reverting with custom message when dividing by zero.
203      *
204      * CAUTION: This function is deprecated because it requires allocating memory for the error
205      * message unnecessarily. For custom revert reasons use {tryMod}.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(
216         uint256 a,
217         uint256 b,
218         string memory errorMessage
219     ) internal pure returns (uint256) {
220         unchecked {
221             require(b > 0, errorMessage);
222             return a % b;
223         }
224     }
225 }
226 
227 
228 library StringUtil {
229     
230     function equal(string memory a, string memory b) internal pure returns(bool){
231         return equal(bytes(a),bytes(b));
232     }
233 
234     function equal(bytes memory a, bytes memory b) internal pure returns(bool){
235         return keccak256(a) == keccak256(b);
236     }
237     
238     function notEmpty(string memory a) internal pure returns(bool){
239         return bytes(a).length > 0;
240     }
241 
242 }
243 
244 
245 /*
246  * @dev Provides information about the current execution context, including the
247  * sender of the transaction and its data. While these are generally available
248  * via msg.sender and msg.data, they should not be accessed in such a direct
249  * manner, since when dealing with meta-transactions the account sending and
250  * paying for execution may not be the actual sender (as far as an application
251  * is concerned).
252  *
253  * This contract is only required for intermediate, library-like contracts.
254  */
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view virtual returns (bytes calldata) {
261         return msg.data;
262     }
263 }
264 
265 
266 /**
267  * @dev Contract module which provides a basic access control mechanism, where
268  * there is an account (an owner) that can be granted exclusive access to
269  * specific functions.
270  *
271  * By default, the owner account will be the one that deploys the contract. This
272  * can later be changed with {transferOwnership}.
273  *
274  * This module is used through inheritance. It will make available the modifier
275  * `onlyOwner`, which can be applied to your functions to restrict their use to
276  * the owner.
277  */
278 abstract contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor() {
287         _setOwner(_msgSender());
288     }
289 
290     /**
291      * @dev Returns the address of the current owner.
292      */
293     function owner() public view virtual returns (address) {
294         return _owner;
295     }
296 
297     /**
298      * @dev Throws if called by any account other than the owner.
299      */
300     modifier onlyOwner() {
301         require(owner() == _msgSender(), "Ownable: caller is not the owner");
302         _;
303     }
304 
305     /**
306      * @dev Leaves the contract without owner. It will not be possible to call
307      * `onlyOwner` functions anymore. Can only be called by the current owner.
308      *
309      * NOTE: Renouncing ownership will leave the contract without an owner,
310      * thereby removing any functionality that is only available to the owner.
311      */
312     function renounceOwnership() public virtual onlyOwner {
313         _setOwner(address(0));
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321         require(newOwner != address(0), "Ownable: new owner is the zero address");
322         _setOwner(newOwner);
323     }
324 
325     function _setOwner(address newOwner) private {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 contract WhiteList is Ownable{
333 
334     mapping(address=>bool) public whiteList;
335 
336     event AddWhiteList(address account);
337     event RemoveWhiteList(address account);
338 
339     modifier onlyWhiteList(){
340         require(whiteList[_msgSender()] == true, "not in white list");
341         _;
342     }
343 
344     function addWhiteList(address account) public onlyOwner{
345         require(account != address(0), "address should not be 0");
346         whiteList[account] = true;
347         emit AddWhiteList(account);
348     }
349 
350     function removeWhiteList(address account) public onlyOwner{
351         whiteList[account] = false;
352         emit RemoveWhiteList(account);
353     }
354 
355 }
356 
357 contract FilChainStatOracle is WhiteList{
358     using StringUtil for string;
359     using SafeMath for uint256;
360 
361     // all FIL related value use attoFil
362     uint256 public sectorInitialPledge; // attoFil/TiB
363     mapping(string=>uint256) public minerAdjustedPower; // TiB
364     mapping(string=>uint256) public minerMiningEfficiency; // attoFil/GiB
365     mapping(string=>uint256) public minerSectorInitialPledge; // attoFil/TiB
366     
367     /**
368         TiB, 
369         the total adjusted power of all miners listed in the platform
370      */
371     uint256 public minerTotalAdjustedPower;
372     
373     /**
374         attoFil/GiB/24H,
375         the avg mining efficiency of all miners listed on this platform of last 24 hours
376      */
377     uint256 public avgMiningEfficiency;
378     
379     /**
380         attoFil/24H,
381         the total block rewards of last 24 hours of the the whole Filecoin network
382      */
383     uint256 public latest24hBlockReward;
384     
385     uint256 public rewardAttenuationFactor; // *10000
386     uint256 public networkStoragePower; // TiB
387     uint256 public dailyStoragePowerIncrease; //TiB
388 
389     event SectorInitialPledgeChanged(uint256 originalValue, uint256 newValue);
390     event MinerSectorInitialPledgeChanged(string minerId, uint256 originalValue, uint256 newValue);
391     event MinerAdjustedPowerChanged(string minerId, uint256 originalValue, uint256 newValue);
392     event MinerMiningEfficiencyChanged(string minerId, uint256 originalValue, uint256 newValue);
393     event AvgMiningEfficiencyChanged(uint256 originalValue, uint256 newValue);
394     event Latest24hBlockRewardChanged(uint256 originalValue, uint256 newValue);
395     event RewardAttenuationFactorChanged(uint256 originalValue, uint256 newValue);
396     event NetworkStoragePowerChanged(uint256 originalValue, uint256 newValue);
397     event DailyStoragePowerIncreaseChanged(uint256 originalValue, uint256 newValue);
398 
399     function setSectorInitialPledge(uint256 _sectorInitialPledge) public onlyWhiteList{
400         require(_sectorInitialPledge>0, "value should not be 0");
401         emit SectorInitialPledgeChanged(sectorInitialPledge, _sectorInitialPledge);
402         sectorInitialPledge = _sectorInitialPledge;
403     }
404 
405     function setMinerSectorInitialPledge(string memory _minerId, uint256 _minerSectorInitialPledge) public onlyWhiteList{
406         require(_minerSectorInitialPledge>0, "value should not be 0");
407         emit MinerSectorInitialPledgeChanged(_minerId, minerSectorInitialPledge[_minerId], _minerSectorInitialPledge);
408         minerSectorInitialPledge[_minerId] = _minerSectorInitialPledge;
409     }
410 
411     function setMinerSectorInitialPledgeBatch(string[] memory _minerIdList, uint256[] memory _minerSectorInitialPledgeList) public onlyWhiteList{
412         require(_minerIdList.length>0, "miner array should not be 0 length");
413         require(_minerSectorInitialPledgeList.length>0, "value array should not be 0 length");
414         require(_minerIdList.length == _minerSectorInitialPledgeList.length, "array length not equal");
415 
416         for(uint i=0; i<_minerIdList.length; i++){
417             require(_minerSectorInitialPledgeList[i]>0, "value should not be 0");
418             emit MinerSectorInitialPledgeChanged(_minerIdList[i], minerSectorInitialPledge[_minerIdList[i]], _minerSectorInitialPledgeList[i]);
419             minerSectorInitialPledge[_minerIdList[i]] = _minerSectorInitialPledgeList[i];
420         }
421     }
422 
423     function setMinerAdjustedPower(string memory _minerId, uint256 _minerAdjustedPower) public onlyWhiteList{
424         require(_minerId.notEmpty(), "miner id should not be empty");
425         require(_minerAdjustedPower>0, "value should not be 0");
426         minerTotalAdjustedPower = minerTotalAdjustedPower.sub(minerAdjustedPower[_minerId]).add(_minerAdjustedPower);
427         emit MinerAdjustedPowerChanged(_minerId, minerAdjustedPower[_minerId], _minerAdjustedPower);
428         minerAdjustedPower[_minerId] = _minerAdjustedPower;
429     }
430 
431     function setMinerAdjustedPowerBatch(string[] memory _minerIds, uint256[] memory _minerAdjustedPowers) public onlyWhiteList{
432         require(_minerIds.length == _minerAdjustedPowers.length, "minerId list count is not equal to power list");
433         for(uint i; i<_minerIds.length; i++){
434             require(_minerIds[i].notEmpty(), "miner id should not be empty");
435             require(_minerAdjustedPowers[i]>0, "value should not be 0");
436             minerTotalAdjustedPower = minerTotalAdjustedPower.sub(minerAdjustedPower[_minerIds[i]]).add(_minerAdjustedPowers[i]);
437             emit MinerAdjustedPowerChanged(_minerIds[i], minerAdjustedPower[_minerIds[i]], _minerAdjustedPowers[i]);
438             minerAdjustedPower[_minerIds[i]] = _minerAdjustedPowers[i];
439         }
440     }
441 
442     function removeMinerAdjustedPower(string memory _minerId) public onlyWhiteList{
443         uint256 adjustedPower = minerAdjustedPower[_minerId];
444         minerTotalAdjustedPower = minerTotalAdjustedPower.sub(adjustedPower);
445         delete minerAdjustedPower[_minerId];
446         emit MinerAdjustedPowerChanged(_minerId, adjustedPower, 0);
447     }
448 
449     function setMinerMiningEfficiency(string memory _minerId, uint256 _minerMiningEfficiency) public onlyWhiteList{
450         require(_minerId.notEmpty(), "miner id should not be empty");
451         require(_minerMiningEfficiency>0, "value should not be 0");
452         emit MinerMiningEfficiencyChanged(_minerId, minerMiningEfficiency[_minerId], _minerMiningEfficiency);
453         minerMiningEfficiency[_minerId] = _minerMiningEfficiency;
454     }
455 
456     function setMinerMiningEfficiencyBatch(string[] memory _minerIds, uint256[] memory _minerMiningEfficiencys) public onlyWhiteList{
457         require(_minerIds.length == _minerMiningEfficiencys.length, "minerId list count is not equal to power list");
458         for(uint i; i<_minerIds.length; i++){
459             require(_minerIds[i].notEmpty(), "miner id should not be empty");
460             require(_minerMiningEfficiencys[i]>0, "value should not be 0");
461             emit MinerMiningEfficiencyChanged(_minerIds[i], minerMiningEfficiency[_minerIds[i]], _minerMiningEfficiencys[i]);
462             minerMiningEfficiency[_minerIds[i]] = _minerMiningEfficiencys[i];
463         }
464     }
465 
466     function setAvgMiningEfficiency(uint256 _avgMiningEfficiency) public onlyWhiteList{
467         require(_avgMiningEfficiency>0, "value should not be 0");
468         emit AvgMiningEfficiencyChanged(avgMiningEfficiency, _avgMiningEfficiency);
469         avgMiningEfficiency = _avgMiningEfficiency;
470     }
471 
472     function setLatest24hBlockReward(uint256 _latest24hBlockReward) public onlyWhiteList{
473         require(_latest24hBlockReward>0, "value should not be 0");
474         emit Latest24hBlockRewardChanged(latest24hBlockReward, _latest24hBlockReward);
475         latest24hBlockReward = _latest24hBlockReward;
476     }
477 
478     function setRewardAttenuationFactor(uint256 _rewardAttenuationFactor) public onlyWhiteList{
479         require(_rewardAttenuationFactor>0, "value should not be 0");
480         emit RewardAttenuationFactorChanged(rewardAttenuationFactor, _rewardAttenuationFactor);
481         rewardAttenuationFactor = _rewardAttenuationFactor;
482     }
483 
484     function setNetworkStoragePower(uint256 _networkStoragePower) public onlyWhiteList{
485         require(_networkStoragePower>0, "value should not be 0");
486         emit NetworkStoragePowerChanged(networkStoragePower, _networkStoragePower);
487         networkStoragePower = _networkStoragePower;
488     }
489 
490     function setDailyStoragePowerIncrease(uint256 _dailyStoragePowerIncrease) public onlyWhiteList{
491         require(_dailyStoragePowerIncrease>0, "value should not be 0");
492         emit DailyStoragePowerIncreaseChanged(dailyStoragePowerIncrease, _dailyStoragePowerIncrease);
493         dailyStoragePowerIncrease = _dailyStoragePowerIncrease;
494     }
495 
496 }