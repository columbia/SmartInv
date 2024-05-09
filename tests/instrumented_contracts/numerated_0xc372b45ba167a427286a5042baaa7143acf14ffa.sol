1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-01-04
7 */
8 
9 pragma solidity 0.6.12;
10 
11     // SPDX-License-Identifier: No License
12 
13     /**
14     * @title SafeMath
15     * @dev Math operations with safety checks that throw on error
16     */
17     library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41     }
42 
43     /**
44     * @dev Library for managing
45     * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
46     * types.
47     *
48     * Sets have the following properties:
49     *
50     * - Elements are added, removed, and checked for existence in constant time
51     * (O(1)).
52     * - Elements are enumerated in O(n). No guarantees are made on the ordering.
53     *
54     * ```
55     * contract Example {
56     *     // Add the library methods
57     *     using EnumerableSet for EnumerableSet.AddressSet;
58     *
59     *     // Declare a set state variable
60     *     EnumerableSet.AddressSet private mySet;
61     * }
62     * ```
63     *
64     * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
65     * (`UintSet`) are supported.
66     */
67     library EnumerableSet {
68         
69 
70         struct Set {
71         
72             bytes32[] _values;
73     
74             mapping (bytes32 => uint256) _indexes;
75         }
76     
77         function _add(Set storage set, bytes32 value) private returns (bool) {
78             if (!_contains(set, value)) {
79                 set._values.push(value);
80                 
81                 set._indexes[value] = set._values.length;
82                 return true;
83             } else {
84                 return false;
85             }
86         }
87 
88         /**
89         * @dev Removes a value from a set. O(1).
90         *
91         * Returns true if the value was removed from the set, that is if it was
92         * present.
93         */
94         function _remove(Set storage set, bytes32 value) private returns (bool) {
95             // We read and store the value's index to prevent multiple reads from the same storage slot
96             uint256 valueIndex = set._indexes[value];
97 
98             if (valueIndex != 0) { // Equivalent to contains(set, value)
99                 
100 
101                 uint256 toDeleteIndex = valueIndex - 1;
102                 uint256 lastIndex = set._values.length - 1;
103 
104             
105                 bytes32 lastvalue = set._values[lastIndex];
106 
107                 set._values[toDeleteIndex] = lastvalue;
108                 set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
109 
110                 set._values.pop();
111 
112                 delete set._indexes[value];
113 
114                 return true;
115             } else {
116                 return false;
117             }
118         }
119 
120         
121         function _contains(Set storage set, bytes32 value) private view returns (bool) {
122             return set._indexes[value] != 0;
123         }
124 
125         
126         function _length(Set storage set) private view returns (uint256) {
127             return set._values.length;
128         }
129 
130     
131         function _at(Set storage set, uint256 index) private view returns (bytes32) {
132             require(set._values.length > index, "EnumerableSet: index out of bounds");
133             return set._values[index];
134         }
135 
136         
137 
138         struct AddressSet {
139             Set _inner;
140         }
141     
142         function add(AddressSet storage set, address value) internal returns (bool) {
143             return _add(set._inner, bytes32(uint256(value)));
144         }
145 
146     
147         function remove(AddressSet storage set, address value) internal returns (bool) {
148             return _remove(set._inner, bytes32(uint256(value)));
149         }
150 
151         
152         function contains(AddressSet storage set, address value) internal view returns (bool) {
153             return _contains(set._inner, bytes32(uint256(value)));
154         }
155 
156     
157         function length(AddressSet storage set) internal view returns (uint256) {
158             return _length(set._inner);
159         }
160     
161         function at(AddressSet storage set, uint256 index) internal view returns (address) {
162             return address(uint256(_at(set._inner, index)));
163         }
164 
165 
166     
167         struct UintSet {
168             Set _inner;
169         }
170 
171         
172         function add(UintSet storage set, uint256 value) internal returns (bool) {
173             return _add(set._inner, bytes32(value));
174         }
175 
176     
177         function remove(UintSet storage set, uint256 value) internal returns (bool) {
178             return _remove(set._inner, bytes32(value));
179         }
180 
181         
182         function contains(UintSet storage set, uint256 value) internal view returns (bool) {
183             return _contains(set._inner, bytes32(value));
184         }
185 
186         
187         function length(UintSet storage set) internal view returns (uint256) {
188             return _length(set._inner);
189         }
190 
191     
192         function at(UintSet storage set, uint256 index) internal view returns (uint256) {
193             return uint256(_at(set._inner, index));
194         }
195     }
196     
197     contract Ownable {
198     address public owner;
199 
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     
204     constructor() public {
205         owner = msg.sender;
206     }
207     
208     modifier onlyOwner() {
209         require(msg.sender == owner);
210         _;
211     }
212 
213     
214     function transferOwnership(address newOwner) onlyOwner public {
215         require(newOwner != address(0));
216         emit OwnershipTransferred(owner, newOwner);
217         owner = newOwner;
218     }
219     }
220 
221 
222     interface Token {
223         function transferFrom(address, address, uint) external returns (bool);
224         function transfer(address, uint) external returns (bool);
225     }
226 
227     contract PRDZpredictionV2 is Ownable {
228         using SafeMath for uint;
229         using EnumerableSet for EnumerableSet.AddressSet;
230         
231     
232         /*
233         participanta[i] = [
234             0 => user staked,
235             1 => amount staked,
236             2 => result time,
237             3 => prediction time,
238             4 => market pair,
239             5 => value predicted at,
240             6 => result value,
241             7 => prediction type  0 => Down, 1 => up ,
242             8 => result , 0 => Pending , 2 => Lost, 1 => Won, 3 => Withdrawn
243         ]
244         */
245 
246         // PRDZ token contract address
247         address public constant tokenAddress = 0x4e085036A1b732cBe4FfB1C12ddfDd87E7C3664d;
248         // Lost token contract address
249         address public constant lossPool = 0x639d0AFE157Fbb367084fc4b5c887725112148F9; 
250         
251     
252         
253         // mapping(address => uint[]) internal participants;
254         
255         struct Prediction {
256             address user;
257             uint betAmount;
258             uint resultTime;
259             uint betTime;
260             uint marketPair;
261             uint marketType;
262             uint valuePredictedAt;
263             uint valueResult;
264             uint predictionType;
265             uint result;       
266             bool exists;
267         }
268         
269 
270         mapping(uint => Prediction)  predictions;
271         
272         mapping (address => uint) public totalEarnedTokens;
273         mapping (address => uint) public totalClaimedTokens;
274         mapping (address => uint) public totalAvailableRewards;
275         mapping (address => uint) public totalPoints;
276         mapping (address => uint) public totalStaked;
277         event PredictionMade(address indexed user, uint matchid);
278         event PointsEarned(address indexed user, uint indexed time ,  uint score);
279     
280         event RewardsTransferred(address indexed user, uint amount);
281         event ResultDeclared(address indexed user, uint matchID);
282         
283         uint public payoutPercentage = 6500 ;
284         uint public expresultime = 24 hours;
285         uint public maximumToken = 5e18 ; 
286         uint public minimumToken = 1e17 ; 
287         uint public totalClaimedRewards = 0;
288         
289         uint public scorePrdzEq = 50 ;
290      
291         uint[] public matches;
292 
293     
294     function getallmatches() view public  returns (uint[] memory){
295         return matches;
296     }
297         
298         function predict(uint matchID , uint amountToPredict, uint resultTime, uint predictedtime, uint marketPair, uint valuePredictedAt, uint predictionType,uint marketType) public returns (uint)  {
299             require(amountToPredict >= minimumToken && amountToPredict <= maximumToken, "Cannot predict with 0 Tokens");
300             require(resultTime > predictedtime, "Cannot predict at the time of result");
301             require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToPredict), "Insufficient Token Allowance");
302             
303             require(predictions[matchID].exists !=  true  , "Match already Exists" );
304             
305             
306 
307             Prediction storage newprediction = predictions[matchID];
308             newprediction.user =  msg.sender;
309             newprediction.betAmount =  amountToPredict; 
310             newprediction.resultTime =  resultTime ;
311             newprediction.betTime =  predictedtime; 
312             newprediction.marketPair =  marketPair ;
313             newprediction.marketType =  marketType ;
314             newprediction.valuePredictedAt =  valuePredictedAt ;
315             newprediction.valueResult =  0 ;
316             newprediction.predictionType =  predictionType ;
317             newprediction.result =  0 ;
318             newprediction.exists =  true ;
319             matches.push(matchID) ;
320 
321             totalPoints[msg.sender] = totalPoints[msg.sender].add(amountToPredict.mul(scorePrdzEq).div(1e18));
322             emit PointsEarned(msg.sender, now , amountToPredict.mul(scorePrdzEq).div(1e18));
323 
324             totalStaked[msg.sender] =  totalStaked[msg.sender].add(amountToPredict) ;
325             emit PredictionMade(msg.sender, matchID);
326 
327         }
328         
329         function declareresult(uint curMarketValue , uint matchID  ) public  onlyOwner returns (bool)   {
330 
331 
332                     Prediction storage eachparticipant = predictions[matchID];
333 
334                         if(eachparticipant.resultTime <= now && eachparticipant.result == 0 && curMarketValue > 0 ){
335 
336                             /* When User Predicted Up && Result is Up */
337                                 if(eachparticipant.valuePredictedAt  < curMarketValue && eachparticipant.predictionType  == 1  ){
338                                     eachparticipant.result  = 1 ;
339                                     eachparticipant.valueResult  = curMarketValue ;
340                                     uint reward = eachparticipant.betAmount.mul(payoutPercentage).div(1e4);
341                                     totalEarnedTokens[eachparticipant.user] = totalEarnedTokens[eachparticipant.user].add(eachparticipant.betAmount).add(reward);
342                                     
343                                     totalAvailableRewards[eachparticipant.user] = totalAvailableRewards[eachparticipant.user].add(eachparticipant.betAmount).add(reward);
344                                 }
345 
346                             /* When User Predicted Up && Result is Down */
347                                 if(eachparticipant.valuePredictedAt  > curMarketValue && eachparticipant.predictionType  == 1  ){
348                                     eachparticipant.result  = 2 ;
349                                     eachparticipant.valueResult  = curMarketValue ;
350                                     Token(tokenAddress).transfer(lossPool, eachparticipant.betAmount);
351 
352                                 }
353 
354                             /* When User Predicted Down && Result is Up */
355                                 if(eachparticipant.valuePredictedAt  < curMarketValue && eachparticipant.predictionType  == 0  ){
356                                     eachparticipant.result  = 2 ;
357                                     eachparticipant.valueResult  = curMarketValue ;
358                                     Token(tokenAddress).transfer(lossPool, eachparticipant.betAmount);
359 
360                                 }
361 
362                             /* When User Predicted Down && Result is Down */
363                                 if(eachparticipant.valuePredictedAt  > curMarketValue && eachparticipant.predictionType  == 0  ){
364                                     eachparticipant.result  = 1 ;
365                                     eachparticipant.valueResult  = curMarketValue ;
366                                     uint reward = eachparticipant.betAmount.mul(payoutPercentage).div(1e4);
367                                     totalEarnedTokens[eachparticipant.user] = totalEarnedTokens[eachparticipant.user].add(eachparticipant.betAmount).add(reward);
368                                     totalAvailableRewards[eachparticipant.user] = totalAvailableRewards[eachparticipant.user].add(eachparticipant.betAmount).add(reward);
369 
370                                 }
371                         emit ResultDeclared(msg.sender, matchID);
372                     
373                 }
374                 
375             
376                 return true ;
377 
378             }
379 
380 
381             function getmatchBasic(uint  _matchID ) view public returns (address , uint , uint , uint , uint  ) {
382                         return (predictions[_matchID].user , predictions[_matchID].betAmount , predictions[_matchID].resultTime , predictions[_matchID].betTime , predictions[_matchID].marketPair  );
383             }
384 
385             function getmatchAdv(uint  _matchID ) view public returns (uint , uint , uint , uint , uint  , bool  ) {
386                         return (predictions[_matchID].marketType , predictions[_matchID].valuePredictedAt, predictions[_matchID].valueResult, predictions[_matchID].predictionType , predictions[_matchID].result  , predictions[_matchID].exists );
387             }
388 
389             
390     
391 
392         function withdrawNotExecutedResult(uint  _matchID) 
393             public 
394             
395             returns (bool) {
396             
397             if(predictions[_matchID].result == 0 && predictions[_matchID].user == msg.sender && now.sub(predictions[_matchID].resultTime) > expresultime){
398                 Prediction storage eachparticipant = predictions[_matchID];
399                 eachparticipant.result =  3 ;
400                 Token(tokenAddress).transfer(predictions[_matchID].user, predictions[_matchID].betAmount);
401             }
402             
403             return true ;
404         }
405 
406     function addContractBalance(uint amount) public {
407             require(Token(tokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
408             
409         }
410 
411          function addScore(uint  score, uint amount, address _holder) 
412             public 
413             onlyOwner
414             returns (bool) {
415              totalPoints[_holder] = totalPoints[_holder].add(score);
416               totalStaked[_holder] = totalStaked[_holder].add(amount);
417             
418             return true ;
419         }
420 
421         function updateMaximum(uint  amount) 
422             public 
423             onlyOwner
424             returns (bool) {
425             maximumToken = amount;
426             
427             return true ;
428         }
429 
430         function updateMinimum(uint  amount) 
431             public 
432             onlyOwner
433             returns (bool) {
434             minimumToken = amount;
435             
436             return true ;
437         }
438 
439         
440 
441         function updatePayout(uint  percentage) 
442             public 
443             onlyOwner
444             returns (bool) {
445             payoutPercentage = percentage;
446             
447             return true ;
448         }
449 
450     function updateScoreEq(uint  prdzeq) 
451             public 
452             onlyOwner
453             returns (bool) {
454             scorePrdzEq = prdzeq;
455             
456             return true ;
457         }
458 
459 
460     
461     
462 
463 
464         function updateAccount(address account) private {
465             uint pendingDivs = totalAvailableRewards[account];
466             if (pendingDivs > 0 ) {
467                 require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
468                 totalClaimedTokens[account] = totalClaimedTokens[account].add(pendingDivs);
469                 totalAvailableRewards[account] = 0 ;
470                 totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
471                 emit RewardsTransferred(account, pendingDivs);
472             }
473         
474             
475         }
476         
477             
478         function claimDivs() public {
479             updateAccount(msg.sender);
480         }
481         
482         
483         
484     
485 
486     }