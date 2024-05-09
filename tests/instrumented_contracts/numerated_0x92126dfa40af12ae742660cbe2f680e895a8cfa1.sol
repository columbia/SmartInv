1 pragma solidity ^0.5.0;
2 
3 
4 
5 contract Ownable {
6     address private _owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     constructor () internal {
15         _owner = msg.sender;
16         emit OwnershipTransferred(address(0), _owner);
17     }
18 
19     /**
20      * @return the address of the owner.
21      */
22     function owner() public view returns (address) {
23         return _owner;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(isOwner());
31         _;
32     }
33 
34     /**
35      * @return true if `msg.sender` is the owner of the contract.
36      */
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40 
41     /**
42      * @dev Allows the current owner to relinquish control of the contract.
43      * @notice Renouncing to ownership will leave the contract without an owner.
44      * It will not be possible to call the functions with the `onlyOwner`
45      * modifier anymore.
46      */
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipTransferred(_owner, address(0));
49         _owner = address(0);
50     }
51 
52     /**
53      * @dev Allows the current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      */
56     function transferOwnership(address newOwner) public onlyOwner {
57         _transferOwnership(newOwner);
58     }
59 
60     /**
61      * @dev Transfers control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function _transferOwnership(address newOwner) internal {
65         require(newOwner != address(0));
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83         return 0;
84         }
85         uint256 c = a * b;
86         assert(c / a == b);
87         return c;
88     }
89 
90     /**
91     * @dev Integer division of two numbers, truncating the quotient.
92     */
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         // assert(b > 0); // Solidity automatically throws when dividing by 0
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97         return c;
98     }
99 
100     /**
101     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102     */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         assert(b <= a);
105         return a - b;
106     }
107 
108     /**
109     * @dev Adds two numbers, throws on overflow.
110     */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         assert(c >= a);
114         return c;
115     }
116 }
117 
118 contract CommunityVesting is Ownable {
119     using SafeMath for uint256;
120 
121     mapping (address => Holding) public holdings;
122 
123     uint256 constant public MinimumHoldingPeriod = 90 days;
124     uint256 constant public Interval = 90 days;
125     uint256 constant public MaximumHoldingPeriod = 360 days;
126 
127     uint256 constant public CommunityCap = 14300000 ether; // 14.3 million tokens
128 
129     uint256 public totalCommunityTokensCommitted;
130 
131     struct Holding {
132         uint256 tokensCommitted;
133         uint256 tokensRemaining;
134         uint256 startTime;
135     }
136 
137     event CommunityVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
138     event CommunityVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
139 
140     function claimTokens(address beneficiary)
141         external
142         onlyOwner
143         returns (uint256 tokensToClaim)
144     {
145         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
146         uint256 startTime = holdings[beneficiary].startTime;
147         require(tokensRemaining > 0, "All tokens claimed");
148 
149         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
150 
151         if (now.sub(startTime) >= MaximumHoldingPeriod) {
152 
153             tokensToClaim = tokensRemaining;
154             delete holdings[beneficiary];
155 
156         } else {
157 
158             uint256 percentage = calculatePercentageToRelease(startTime);
159 
160             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
161             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
162             tokensRemaining = tokensNotToClaim;
163             holdings[beneficiary].tokensRemaining = tokensRemaining;
164 
165         }
166     }
167 
168     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
169         // how many 90 day periods have passed
170         uint periodsPassed = ((now.sub(_startTime)).div(Interval));
171         percentage = periodsPassed.mul(25); // 25% to be released every 90 days
172     }
173 
174     function initializeVesting(
175         address _beneficiary,
176         uint256 _tokens,
177         uint256 _startTime
178     )
179         external
180         onlyOwner
181     {
182         totalCommunityTokensCommitted = totalCommunityTokensCommitted.add(_tokens);
183         require(totalCommunityTokensCommitted <= CommunityCap);
184 
185         if (holdings[_beneficiary].tokensCommitted != 0) {
186             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
187             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
188 
189             emit CommunityVestingUpdated(
190                 _beneficiary,
191                 holdings[_beneficiary].tokensRemaining,
192                 holdings[_beneficiary].startTime
193             );
194 
195         } else {
196             holdings[_beneficiary] = Holding(
197                 _tokens,
198                 _tokens,
199                 _startTime
200             );
201 
202             emit CommunityVestingInitialized(_beneficiary, _tokens, _startTime);
203         }
204     }
205 }
206 
207 
208 
209 contract EcosystemVesting is Ownable {
210     using SafeMath for uint256;
211 
212     mapping (address => Holding) public holdings;
213 
214     uint256 constant public Interval = 90 days;
215     uint256 constant public MaximumHoldingPeriod = 630 days;
216 
217     uint256 constant public EcosystemCap = 54100000 ether; // 54.1 million tokens
218 
219     uint256 public totalEcosystemTokensCommitted;
220 
221     struct Holding {
222         uint256 tokensCommitted;
223         uint256 tokensRemaining;
224         uint256 startTime;
225     }
226 
227     event EcosystemVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
228     event EcosystemVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
229 
230     function claimTokens(address beneficiary)
231         external
232         onlyOwner
233         returns (uint256 tokensToClaim)
234     {
235         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
236         uint256 startTime = holdings[beneficiary].startTime;
237         require(tokensRemaining > 0, "All tokens claimed");
238 
239         if (now.sub(startTime) >= MaximumHoldingPeriod) {
240 
241             tokensToClaim = tokensRemaining;
242             delete holdings[beneficiary];
243 
244         } else {
245 
246             uint256 permill = calculatePermillToRelease(startTime);
247 
248             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(1000 - permill)).div(1000);
249             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
250             tokensRemaining = tokensNotToClaim;
251             holdings[beneficiary].tokensRemaining = tokensRemaining;
252 
253         }
254     }
255 
256     function calculatePermillToRelease(uint256 _startTime) internal view returns (uint256 permill) {
257         // how many 90 day periods have passed
258         uint periodsPassed = ((now.sub(_startTime)).div(Interval)).add(1);
259         permill = periodsPassed.mul(125); // 125 per thousand to be released every 90 days
260     }
261 
262     function initializeVesting(
263         address _beneficiary,
264         uint256 _tokens,
265         uint256 _startTime
266     )
267         external
268         onlyOwner
269     {
270         totalEcosystemTokensCommitted = totalEcosystemTokensCommitted.add(_tokens);
271         require(totalEcosystemTokensCommitted <= EcosystemCap);
272 
273         if (holdings[_beneficiary].tokensCommitted != 0) {
274             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
275             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
276 
277             emit EcosystemVestingUpdated(
278                 _beneficiary,
279                 holdings[_beneficiary].tokensRemaining,
280                 holdings[_beneficiary].startTime
281             );
282 
283         } else {
284             holdings[_beneficiary] = Holding(
285                 _tokens,
286                 _tokens,
287                 _startTime
288             );
289 
290             emit EcosystemVestingInitialized(_beneficiary, _tokens, _startTime);
291         }
292     }
293 }
294 
295 
296 
297 contract SeedPrivateAdvisorVesting is Ownable {
298     using SafeMath for uint256;
299 
300     enum User { Public, Seed, Private, Advisor }
301 
302     mapping (address => Holding) public holdings;
303 
304     uint256 constant public MinimumHoldingPeriod = 90 days;
305     uint256 constant public Interval = 30 days;
306     uint256 constant public MaximumHoldingPeriod = 180 days;
307 
308     uint256 constant public SeedCap = 28000000 ether; // 28 million tokens
309     uint256 constant public PrivateCap = 9000000 ether; // 9 million tokens
310     uint256 constant public AdvisorCap = 7400000 ether; // 7.4 million tokens
311 
312     uint256 public totalSeedTokensCommitted;
313     uint256 public totalPrivateTokensCommitted;
314     uint256 public totalAdvisorTokensCommitted;
315 
316     struct Holding {
317         uint256 tokensCommitted;
318         uint256 tokensRemaining;
319         uint256 startTime;
320         User user;
321     }
322 
323     event VestingInitialized(address _to, uint256 _tokens, uint256 _startTime, User user);
324     event VestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime, User user);
325 
326     function claimTokens(address beneficiary)
327         external
328         onlyOwner
329         returns (uint256 tokensToClaim)
330     {
331         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
332         uint256 startTime = holdings[beneficiary].startTime;
333         require(tokensRemaining > 0, "All tokens claimed");
334 
335         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
336 
337         if (now.sub(startTime) >= MaximumHoldingPeriod) {
338 
339             tokensToClaim = tokensRemaining;
340             delete holdings[beneficiary];
341 
342         } else {
343 
344             uint256 percentage = calculatePercentageToRelease(startTime);
345 
346             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
347             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
348             tokensRemaining = tokensNotToClaim;
349             holdings[beneficiary].tokensRemaining = tokensRemaining;
350 
351         }
352     }
353 
354     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
355         // how many 30 day periods have passed
356         uint periodsPassed = ((now.sub(_startTime.add(MinimumHoldingPeriod))).div(Interval)).add(1);
357         percentage = periodsPassed.mul(25); // 25% to be released every 30 days
358     }
359 
360     function initializeVesting(
361         address _beneficiary,
362         uint256 _tokens,
363         uint256 _startTime,
364         uint8 user
365     )
366         external
367         onlyOwner
368     {
369         User _user;
370         if (user == uint8(User.Seed)) {
371             _user = User.Seed;
372             totalSeedTokensCommitted = totalSeedTokensCommitted.add(_tokens);
373             require(totalSeedTokensCommitted <= SeedCap);
374         } else if (user == uint8(User.Private)) {
375             _user = User.Private;
376             totalPrivateTokensCommitted = totalPrivateTokensCommitted.add(_tokens);
377             require(totalPrivateTokensCommitted <= PrivateCap);
378         } else if (user == uint8(User.Advisor)) {
379             _user = User.Advisor;
380             totalAdvisorTokensCommitted = totalAdvisorTokensCommitted.add(_tokens);
381             require(totalAdvisorTokensCommitted <= AdvisorCap);
382         } else {
383             revert( "incorrect category, not eligible for vesting" );
384         }
385 
386         if (holdings[_beneficiary].tokensCommitted != 0) {
387             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
388             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
389 
390             emit VestingUpdated(
391                 _beneficiary,
392                 holdings[_beneficiary].tokensRemaining,
393                 holdings[_beneficiary].startTime,
394                 holdings[_beneficiary].user
395             );
396 
397         } else {
398             holdings[_beneficiary] = Holding(
399                 _tokens,
400                 _tokens,
401                 _startTime,
402                 _user
403             );
404 
405             emit VestingInitialized(_beneficiary, _tokens, _startTime, _user);
406         }
407     }
408 }
409 
410 
411 contract TeamVesting is Ownable {
412     using SafeMath for uint256;
413 
414     mapping (address => Holding) public holdings;
415 
416     uint256 constant public MinimumHoldingPeriod = 180 days;
417     uint256 constant public Interval = 180 days;
418     uint256 constant public MaximumHoldingPeriod = 720 days;
419 
420     uint256 constant public TeamCap = 12200000 ether; // 12.2 million tokens
421 
422     uint256 public totalTeamTokensCommitted;
423 
424     struct Holding {
425         uint256 tokensCommitted;
426         uint256 tokensRemaining;
427         uint256 startTime;
428     }
429 
430     event TeamVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
431     event TeamVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
432 
433     function claimTokens(address beneficiary)
434         external
435         onlyOwner
436         returns (uint256 tokensToClaim)
437     {
438         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
439         uint256 startTime = holdings[beneficiary].startTime;
440         require(tokensRemaining > 0, "All tokens claimed");
441 
442         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
443 
444         if (now.sub(startTime) >= MaximumHoldingPeriod) {
445 
446             tokensToClaim = tokensRemaining;
447             delete holdings[beneficiary];
448 
449         } else {
450 
451             uint256 percentage = calculatePercentageToRelease(startTime);
452 
453             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
454 
455             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
456             tokensRemaining = tokensNotToClaim;
457             holdings[beneficiary].tokensRemaining = tokensRemaining;
458 
459         }
460     }
461 
462     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
463         // how many 180 day periods have passed
464         uint periodsPassed = ((now.sub(_startTime)).div(Interval));
465         percentage = periodsPassed.mul(25); // 25% to be released every 180 days
466     }
467 
468     function initializeVesting(
469         address _beneficiary,
470         uint256 _tokens,
471         uint256 _startTime
472     )
473         external
474         onlyOwner
475     {
476         totalTeamTokensCommitted = totalTeamTokensCommitted.add(_tokens);
477         require(totalTeamTokensCommitted <= TeamCap);
478 
479         if (holdings[_beneficiary].tokensCommitted != 0) {
480             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
481             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
482 
483             emit TeamVestingUpdated(
484                 _beneficiary,
485                 holdings[_beneficiary].tokensRemaining,
486                 holdings[_beneficiary].startTime
487             );
488 
489         } else {
490             holdings[_beneficiary] = Holding(
491                 _tokens,
492                 _tokens,
493                 _startTime
494             );
495 
496             emit TeamVestingInitialized(_beneficiary, _tokens, _startTime);
497         }
498     }
499 }
500 
501 
502 
503 interface TokenInterface {
504     function totalSupply() external view returns (uint256);
505     function balanceOf(address _owner) external view returns (uint256 balance);
506     function transfer(address _to, uint256 _value) external returns (bool);
507     event Transfer(address indexed from, address indexed to, uint256 value);
508 }
509 
510 
511 contract Vesting is Ownable {
512     using SafeMath for uint256;
513 
514     enum VestingUser { Public, Seed, Private, Advisor, Team, Community, Ecosystem }
515 
516     TokenInterface public token;
517     CommunityVesting public communityVesting;
518     TeamVesting public teamVesting;
519     EcosystemVesting public ecosystemVesting;
520     SeedPrivateAdvisorVesting public seedPrivateAdvisorVesting;
521     mapping (address => VestingUser) public userCategory;
522     uint256 public totalAllocated;
523 
524     event TokensReleased(address _to, uint256 _tokensReleased, VestingUser user);
525 
526     constructor(address _token) public {
527         //require(_token != 0x0, "Invalid address");
528         token = TokenInterface(_token);
529         communityVesting = new CommunityVesting();
530         teamVesting = new TeamVesting();
531         ecosystemVesting = new EcosystemVesting();
532         seedPrivateAdvisorVesting = new SeedPrivateAdvisorVesting();
533     }
534 
535     function claimTokens() external {
536         uint8 category = uint8(userCategory[msg.sender]);
537 
538         uint256 tokensToClaim;
539 
540         if (category == 1 || category == 2 || category == 3) {
541             tokensToClaim = seedPrivateAdvisorVesting.claimTokens(msg.sender);
542         } else if (category == 4) {
543             tokensToClaim = teamVesting.claimTokens(msg.sender);
544         } else if (category == 5) {
545             tokensToClaim = communityVesting.claimTokens(msg.sender);
546         } else if (category == 6){
547             tokensToClaim = ecosystemVesting.claimTokens(msg.sender);
548         } else {
549             revert( "incorrect category, maybe unknown user" );
550         }
551 
552         totalAllocated = totalAllocated.sub(tokensToClaim);
553         require(token.transfer(msg.sender, tokensToClaim), "Insufficient balance in vesting contract");
554         emit TokensReleased(msg.sender, tokensToClaim, userCategory[msg.sender]);
555     }
556 
557     function initializeVesting(
558         address _beneficiary,
559         uint256 _tokens,
560         uint256 _startTime,
561         VestingUser user
562     )
563         external
564         onlyOwner
565     {
566         uint8 category = uint8(user);
567         require(category != 0, "Not eligible for vesting");
568 
569         require( uint8(userCategory[_beneficiary]) == 0 || userCategory[_beneficiary] == user, "cannot change user category" );
570         userCategory[_beneficiary] = user;
571         totalAllocated = totalAllocated.add(_tokens);
572 
573         if (category == 1 || category == 2 || category == 3) {
574             seedPrivateAdvisorVesting.initializeVesting(_beneficiary, _tokens, _startTime, category);
575         } else if (category == 4) {
576             teamVesting.initializeVesting(_beneficiary, _tokens, _startTime);
577         } else if (category == 5) {
578             communityVesting.initializeVesting(_beneficiary, _tokens, _startTime);
579         } else if (category == 6){
580             ecosystemVesting.initializeVesting(_beneficiary, _tokens, _startTime);
581         } else {
582             revert( "incorrect category, not eligible for vesting" );
583         }
584     }
585 
586     function claimUnallocated( address _sendTo) external onlyOwner{
587         uint256 allTokens = token.balanceOf(address(this));
588         uint256 tokensUnallocated = allTokens.sub(totalAllocated);
589         token.transfer(_sendTo, tokensUnallocated);
590     }
591 }