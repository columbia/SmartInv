1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     if (a == 0) {
58       return 0;
59     }
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: contracts/InstantListing.sol
264 
265 contract InstantListing is Ownable {
266     using SafeMath for uint256;
267 
268     struct Proposal {
269         uint256 totalContributions;
270         mapping(address => uint256) contributions;
271 
272         address tokenAddress;
273         string projectName;
274         string websiteUrl;
275         string whitepaperUrl;
276         string legalDocumentUrl;
277         uint256 icoStartDate;
278         uint256 icoEndDate;
279         uint256 icoRate; // If 4000 COB = 1 ETH, then icoRate = 4000.
280         uint256 totalRaised;
281     }
282 
283     // Round number
284     uint256 public round;
285 
286     // Flag to mark if "listing-by-rank" is already executed
287     bool public ranked;
288 
289     // The address of beneficiary.
290     address public beneficiary;
291 
292     // The address of token used for payment (e.g. COB)
293     address public paymentTokenAddress;
294 
295     // Required amount of paymentToken to able to propose a listing.
296     uint256 public requiredDownPayment;
297 
298     // Proposals proposed by community.
299     mapping(uint256 => mapping(address => Proposal)) public proposals;
300 
301     // Contribution of each round.
302     mapping(uint256 => uint256) public roundContribution;
303 
304     // A mapping of the token listing status.
305     mapping(address => bool) public listed;
306 
307     // A mapping from token contract address to the last refundable unix
308     // timestamp, 0 means not refundable.
309     mapping(address => uint256) public refundable;
310 
311     // Candidates
312     address[] public candidates;
313 
314     // Configs.
315     uint256 public startTime;
316     uint256 public prevEndTime;
317     uint256 public softCap;
318     uint256 public hardCap;
319     uint256 public duration;
320     uint256 public numListed;
321 
322     // Events.
323     event SoftCapReached(uint256 indexed _round, address _tokenAddress);
324     event TokenProposed(uint256 indexed _round, address _tokenAddress, uint256 _refundEndTime);
325     event TokenListed(uint256 indexed _round, address _tokenAddress, uint256 _refundEndTime);
326     event Vote(uint256 indexed _round, address indexed _tokenAddress, address indexed voter, uint256 amount);
327     event RoundFinalized(uint256 _round);
328 
329     constructor() public {
330     }
331 
332     function getCurrentTimestamp() internal view returns (uint256) {
333         return now;
334     }
335 
336     function initialize(
337         address _beneficiary,
338         address _paymentTokenAddress)
339         onlyOwner public {
340 
341         beneficiary = _beneficiary;
342         paymentTokenAddress = _paymentTokenAddress;
343     }
344 
345     function reset(
346         uint256 _requiredDownPayment,
347         uint256 _startTime,
348         uint256 _duration,
349         uint256 _softCap,
350         uint256 _hardCap,
351         uint256 _numListed)
352         onlyOwner public {
353         require(getCurrentTimestamp() >= startTime + duration);
354 
355 
356         // List tokens in the leaderboard
357         if (!ranked) {
358             listTokenByRank();
359         }
360 
361         // Transfer all balance except for latest round,
362         // which is reserved for refund.
363         StandardToken paymentToken = StandardToken(paymentTokenAddress);
364         if (round != 0) {
365             prevEndTime = startTime + duration;
366             paymentToken.transfer(beneficiary,
367                 paymentToken.balanceOf(this) - roundContribution[round]);
368         }
369 
370         requiredDownPayment = _requiredDownPayment;
371         startTime = _startTime;
372         duration = _duration;
373         hardCap = _hardCap;
374         softCap = _softCap;
375         numListed = _numListed;
376         ranked = false;
377 
378         emit RoundFinalized(round);
379 
380         delete candidates;
381 
382         round += 1;
383     }
384 
385     function propose(
386         address _tokenAddress,
387         string _projectName,
388         string _websiteUrl,
389         string _whitepaperUrl,
390         string _legalDocumentUrl,
391         uint256 _icoStartDate,
392         uint256 _icoEndDate,
393         uint256 _icoRate,
394         uint256 _totalRaised) public {
395         require(proposals[round][_tokenAddress].totalContributions == 0);
396         require(getCurrentTimestamp() < startTime + duration);
397 
398         StandardToken paymentToken = StandardToken(paymentTokenAddress);
399         uint256 downPayment = paymentToken.allowance(msg.sender, this);
400 
401         if (downPayment < requiredDownPayment) {
402             revert();
403         }
404 
405         paymentToken.transferFrom(msg.sender, this, downPayment);
406 
407         proposals[round][_tokenAddress] = Proposal({
408             tokenAddress: _tokenAddress,
409             projectName: _projectName,
410             websiteUrl: _websiteUrl,
411             whitepaperUrl: _whitepaperUrl,
412             legalDocumentUrl: _legalDocumentUrl,
413             icoStartDate: _icoStartDate,
414             icoEndDate: _icoEndDate,
415             icoRate: _icoRate,
416             totalRaised: _totalRaised,
417             totalContributions: 0
418         });
419 
420         // Only allow refunding amount exceeding down payment.
421         proposals[round][_tokenAddress].contributions[msg.sender] =
422             downPayment - requiredDownPayment;
423         proposals[round][_tokenAddress].totalContributions = downPayment;
424         roundContribution[round] = roundContribution[round].add(
425             downPayment - requiredDownPayment);
426         listed[_tokenAddress] = false;
427 
428         if (downPayment >= softCap && downPayment < hardCap) {
429             candidates.push(_tokenAddress);
430             emit SoftCapReached(round, _tokenAddress);
431         }
432 
433         if (downPayment >= hardCap) {
434             listed[_tokenAddress] = true;
435             emit TokenListed(round, _tokenAddress, refundable[_tokenAddress]);
436         }
437 
438         refundable[_tokenAddress] = startTime + duration + 7 * 1 days;
439         emit TokenProposed(round, _tokenAddress, refundable[_tokenAddress]);
440     }
441 
442     function vote(address _tokenAddress) public {
443         require(getCurrentTimestamp() >= startTime &&
444                 getCurrentTimestamp() < startTime + duration);
445         require(proposals[round][_tokenAddress].totalContributions > 0);
446 
447         StandardToken paymentToken = StandardToken(paymentTokenAddress);
448         bool prevSoftCapReached =
449             proposals[round][_tokenAddress].totalContributions >= softCap;
450         uint256 allowedPayment = paymentToken.allowance(msg.sender, this);
451 
452         paymentToken.transferFrom(msg.sender, this, allowedPayment);
453         proposals[round][_tokenAddress].contributions[msg.sender] =
454             proposals[round][_tokenAddress].contributions[msg.sender].add(
455                 allowedPayment);
456         proposals[round][_tokenAddress].totalContributions =
457             proposals[round][_tokenAddress].totalContributions.add(
458                 allowedPayment);
459         roundContribution[round] = roundContribution[round].add(allowedPayment);
460 
461         if (!prevSoftCapReached &&
462             proposals[round][_tokenAddress].totalContributions >= softCap &&
463             proposals[round][_tokenAddress].totalContributions < hardCap) {
464             candidates.push(_tokenAddress);
465             emit SoftCapReached(round, _tokenAddress);
466         }
467 
468         if (proposals[round][_tokenAddress].totalContributions >= hardCap) {
469             listed[_tokenAddress] = true;
470             refundable[_tokenAddress] = 0;
471             emit TokenListed(round, _tokenAddress, refundable[_tokenAddress]);
472         }
473 
474         emit Vote(round, _tokenAddress, msg.sender, allowedPayment);
475     }
476 
477     function setRefundable(address _tokenAddress, uint256 endTime)
478         onlyOwner public {
479         refundable[_tokenAddress] = endTime;
480     }
481 
482     // For those claimed but not refund payment
483     function withdrawBalance() onlyOwner public {
484         require(getCurrentTimestamp() >= (prevEndTime + 7 * 1 days));
485 
486         StandardToken paymentToken = StandardToken(paymentTokenAddress);
487         paymentToken.transfer(beneficiary, paymentToken.balanceOf(this));
488     }
489 
490     function refund(address _tokenAddress) public {
491         require(refundable[_tokenAddress] > 0 &&
492                 prevEndTime > 0 &&
493                 getCurrentTimestamp() >= prevEndTime &&
494                 getCurrentTimestamp() < refundable[_tokenAddress]);
495 
496         StandardToken paymentToken = StandardToken(paymentTokenAddress);
497 
498         uint256 amount = proposals[round][_tokenAddress].contributions[msg.sender];
499         if (amount > 0) {
500             proposals[round][_tokenAddress].contributions[msg.sender] = 0;
501             proposals[round][_tokenAddress].totalContributions =
502                 proposals[round][_tokenAddress].totalContributions.sub(amount);
503             paymentToken.transfer(msg.sender, amount);
504         }
505     }
506 
507     function listTokenByRank() onlyOwner public {
508         require(getCurrentTimestamp() >= startTime + duration &&
509                 !ranked);
510 
511         quickSort(0, candidates.length);
512 
513         uint collected = 0;
514         for (uint i = 0; i < candidates.length && collected < numListed; i++) {
515             if (!listed[candidates[i]]) {
516                 listed[candidates[i]] = true;
517                 refundable[candidates[i]] = 0;
518                 emit TokenListed(round, candidates[i], refundable[candidates[i]]);
519                 collected++;
520             }
521         }
522 
523         ranked = true;
524     }
525 
526     function quickSort(uint beg, uint end) internal {
527         if (beg + 1 >= end)
528             return;
529 
530         uint pv = proposals[round][candidates[end - 1]].totalContributions;
531         uint partition = beg;
532 
533         for (uint i = beg; i < end; i++) {
534             if (proposals[round][candidates[i]].totalContributions > pv) {
535                 (candidates[partition], candidates[i]) =
536                     (candidates[i], candidates[partition]);
537                 partition++;
538             }
539         }
540         (candidates[partition], candidates[end - 1]) =
541            (candidates[end - 1], candidates[partition]);
542 
543         quickSort(beg, partition);
544         quickSort(partition + 1, end);
545     }
546 
547     function getContributions(
548         uint256 _round,
549         address _tokenAddress,
550         address contributor) view public returns (uint256) {
551         return proposals[_round][_tokenAddress].contributions[contributor];
552     }
553 
554     function numCandidates() view public returns (uint256) {
555         return candidates.length;
556     }
557 
558     function kill() public onlyOwner {
559         StandardToken paymentToken = StandardToken(paymentTokenAddress);
560         paymentToken.transfer(beneficiary, paymentToken.balanceOf(this));
561 
562         selfdestruct(beneficiary);
563     }
564 
565     // Default method, we do not accept ether atm.
566     function () public payable {
567         revert();
568     }
569 }