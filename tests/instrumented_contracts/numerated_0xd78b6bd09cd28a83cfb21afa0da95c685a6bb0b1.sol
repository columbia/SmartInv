1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeERC20
28  * @dev Wrappers around ERC20 operations that throw on failure.
29  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
30  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
31  */
32 library SafeERC20 {
33     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
34         assert(token.transfer(to, value));
35     }
36 
37     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
38         assert(token.transferFrom(from, to, value));
39     }
40 
41     function safeApprove(ERC20 token, address spender, uint256 value) internal {
42         assert(token.approve(spender, value));
43     }
44 }
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // assert(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87 
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   function Ownable() public {
96     owner = msg.sender;
97   }
98 
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) public onlyOwner {
114     require(newOwner != address(0));
115     OwnershipTransferred(owner, newOwner);
116     owner = newOwner;
117   }
118 
119 }
120 
121 /**
122  * @title TokenTimelock
123  * @dev TokenTimelock is a token holder contract that will allow a
124  * beneficiary to extract the tokens after a given release time
125  */
126 contract TokenTimelock {
127     using SafeERC20 for ERC20Basic;
128 
129     // ERC20 basic token contract being held
130     ERC20Basic public token;
131 
132     // beneficiary of tokens after they are released
133     address public beneficiary;
134 
135     // timestamp when token release is enabled
136     uint256 public releaseTime;
137 
138     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
139         require(_releaseTime > now);
140         token = _token;
141         beneficiary = _beneficiary;
142         releaseTime = _releaseTime;
143     }
144 
145     /**
146      * @notice Transfers tokens held by timelock to beneficiary.
147      */
148     function release() public {
149         require(now >= releaseTime);
150 
151         uint256 amount = token.balanceOf(this);
152         require(amount > 0);
153 
154         token.safeTransfer(beneficiary, amount);
155     }
156 }
157 
158 /**
159  * @title TokenVesting
160  * @dev A token holder contract that can release its token balance gradually like a
161  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
162  * owner.
163  */
164 contract TokenVesting is Ownable {
165   using SafeMath for uint256;
166   using SafeERC20 for ERC20Basic;
167 
168   event Released(uint256 amount);
169   event Revoked();
170 
171   // beneficiary of tokens after they are released
172   address public beneficiary;
173 
174   uint256 public cliff;
175   uint256 public start;
176   uint256 public duration;
177 
178   bool public revocable;
179 
180   mapping (address => uint256) public released;
181   mapping (address => bool) public revoked;
182 
183   /**
184    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
185    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
186    * of the balance will have vested.
187    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
188    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
189    * @param _duration duration in seconds of the period in which the tokens will vest
190    * @param _revocable whether the vesting is revocable or not
191    */
192   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
193     require(_beneficiary != address(0));
194     require(_cliff <= _duration);
195 
196     beneficiary = _beneficiary;
197     revocable = _revocable;
198     duration = _duration;
199     cliff = _start.add(_cliff);
200     start = _start;
201   }
202 
203   /**
204    * @notice Transfers vested tokens to beneficiary.
205    * @param token ERC20 token which is being vested
206    */
207   function release(ERC20Basic token) public {
208     uint256 unreleased = releasableAmount(token);
209 
210     require(unreleased > 0);
211 
212     released[token] = released[token].add(unreleased);
213 
214     token.safeTransfer(beneficiary, unreleased);
215 
216     Released(unreleased);
217   }
218 
219   /**
220    * @notice Allows the owner to revoke the vesting. Tokens already vested
221    * remain in the contract, the rest are returned to the owner.
222    * @param token ERC20 token which is being vested
223    */
224   function revoke(ERC20Basic token) public onlyOwner {
225     require(revocable);
226     require(!revoked[token]);
227 
228     uint256 balance = token.balanceOf(this);
229 
230     uint256 unreleased = releasableAmount(token);
231     uint256 refund = balance.sub(unreleased);
232 
233     revoked[token] = true;
234 
235     token.safeTransfer(owner, refund);
236 
237     Revoked();
238   }
239 
240   /**
241    * @dev Calculates the amount that has already vested but hasn't been released yet.
242    * @param token ERC20 token which is being vested
243    */
244   function releasableAmount(ERC20Basic token) public view returns (uint256) {
245     return vestedAmount(token).sub(released[token]);
246   }
247 
248   /**
249    * @dev Calculates the amount that has already vested.
250    * @param token ERC20 token which is being vested
251    */
252   function vestedAmount(ERC20Basic token) public view returns (uint256) {
253     uint256 currentBalance = token.balanceOf(this);
254     uint256 totalBalance = currentBalance.add(released[token]);
255 
256     if (now < cliff) {
257       return 0;
258     } else if (now >= start.add(duration) || revoked[token]) {
259       return totalBalance;
260     } else {
261       return totalBalance.mul(now.sub(start)).div(duration);
262     }
263   }
264 }
265 
266 contract ILivepeerToken is ERC20, Ownable {
267     function mint(address _to, uint256 _amount) public returns (bool);
268     function burn(uint256 _amount) public;
269 }
270 
271 contract GenesisManager is Ownable {
272     using SafeMath for uint256;
273 
274     // LivepeerToken contract
275     ILivepeerToken public token;
276 
277     // Address of the token distribution contract
278     address public tokenDistribution;
279     // Address of the Livepeer bank multisig
280     address public bankMultisig;
281     // Address of the Minter contract in the Livepeer protocol
282     address public minter;
283 
284     // Initial token supply issued
285     uint256 public initialSupply;
286     // Crowd's portion of the initial token supply
287     uint256 public crowdSupply;
288     // Company's portion of the initial token supply
289     uint256 public companySupply;
290     // Team's portion of the initial token supply
291     uint256 public teamSupply;
292     // Investors' portion of the initial token supply
293     uint256 public investorsSupply;
294     // Community's portion of the initial token supply
295     uint256 public communitySupply;
296 
297     // Token amount in grants for the team
298     uint256 public teamGrantsAmount;
299     // Token amount in grants for investors
300     uint256 public investorsGrantsAmount;
301     // Token amount in grants for the community
302     uint256 public communityGrantsAmount;
303 
304     // Timestamp at which vesting grants begin their vesting period
305     // and timelock grants release locked tokens
306     uint256 public grantsStartTimestamp;
307 
308     // Map receiver addresses => contracts holding receivers' vesting tokens
309     mapping (address => address) public vestingHolders;
310     // Map receiver addresses => contracts holding receivers' time locked tokens
311     mapping (address => address) public timeLockedHolders;
312 
313     enum Stages {
314         // Stage for setting the allocations of the initial token supply
315         GenesisAllocation,
316         // Stage for the creating token grants and the token distribution
317         GenesisStart,
318         // Stage for the end of genesis when ownership of the LivepeerToken contract
319         // is transferred to the protocol Minter
320         GenesisEnd
321     }
322 
323     // Current stage of genesis
324     Stages public stage;
325 
326     // Check if genesis is at a particular stage
327     modifier atStage(Stages _stage) {
328         require(stage == _stage);
329         _;
330     }
331 
332     /**
333      * @dev GenesisManager constructor
334      * @param _token Address of the Livepeer token contract
335      * @param _tokenDistribution Address of the token distribution contract
336      * @param _bankMultisig Address of the company bank multisig
337      * @param _minter Address of the protocol Minter
338      */
339     function GenesisManager(
340         address _token,
341         address _tokenDistribution,
342         address _bankMultisig,
343         address _minter,
344         uint256 _grantsStartTimestamp
345     )
346         public
347     {
348         token = ILivepeerToken(_token);
349         tokenDistribution = _tokenDistribution;
350         bankMultisig = _bankMultisig;
351         minter = _minter;
352         grantsStartTimestamp = _grantsStartTimestamp;
353 
354         stage = Stages.GenesisAllocation;
355     }
356 
357     /**
358      * @dev Set allocations for the initial token supply at genesis
359      * @param _initialSupply Initial token supply at genesis
360      * @param _crowdSupply Tokens allocated for the crowd at genesis
361      * @param _companySupply Tokens allocated for the company (for future distribution) at genesis
362      * @param _teamSupply Tokens allocated for the team at genesis
363      * @param _investorsSupply Tokens allocated for investors at genesis
364      * @param _communitySupply Tokens allocated for the community at genesis
365      */
366     function setAllocations(
367         uint256 _initialSupply,
368         uint256 _crowdSupply,
369         uint256 _companySupply,
370         uint256 _teamSupply,
371         uint256 _investorsSupply,
372         uint256 _communitySupply
373     )
374         external
375         onlyOwner
376         atStage(Stages.GenesisAllocation)
377     {
378         require(_crowdSupply.add(_companySupply).add(_teamSupply).add(_investorsSupply).add(_communitySupply) == _initialSupply);
379 
380         initialSupply = _initialSupply;
381         crowdSupply = _crowdSupply;
382         companySupply = _companySupply;
383         teamSupply = _teamSupply;
384         investorsSupply = _investorsSupply;
385         communitySupply = _communitySupply;
386     }
387 
388     /**
389      * @dev Start genesis
390      */
391     function start() external onlyOwner atStage(Stages.GenesisAllocation) {
392         // Mint the initial supply
393         token.mint(this, initialSupply);
394 
395         stage = Stages.GenesisStart;
396     }
397 
398     /**
399      * @dev Add a team grant for tokens with a vesting schedule
400      * @param _receiver Grant receiver
401      * @param _amount Amount of tokens included in the grant
402      * @param _timeToCliff Seconds until the vesting cliff
403      * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule
404      */
405     function addTeamGrant(
406         address _receiver,
407         uint256 _amount,
408         uint256 _timeToCliff,
409         uint256 _vestingDuration
410     )
411         external
412         onlyOwner
413         atStage(Stages.GenesisStart)
414     {
415         uint256 updatedGrantsAmount = teamGrantsAmount.add(_amount);
416         // Amount of tokens included in team grants cannot exceed the team supply during genesis
417         require(updatedGrantsAmount <= teamSupply);
418 
419         teamGrantsAmount = updatedGrantsAmount;
420 
421         addVestingGrant(_receiver, _amount, _timeToCliff, _vestingDuration);
422     }
423 
424     /**
425      * @dev Add an investor grant for tokens with a vesting schedule
426      * @param _receiver Grant receiver
427      * @param _amount Amount of tokens included in the grant
428      * @param _timeToCliff Seconds until the vesting cliff
429      * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule
430      */
431     function addInvestorGrant(
432         address _receiver,
433         uint256 _amount,
434         uint256 _timeToCliff,
435         uint256 _vestingDuration
436     )
437         external
438         onlyOwner
439         atStage(Stages.GenesisStart)
440     {
441         uint256 updatedGrantsAmount = investorsGrantsAmount.add(_amount);
442         // Amount of tokens included in investor grants cannot exceed the investor supply during genesis
443         require(updatedGrantsAmount <= investorsSupply);
444 
445         investorsGrantsAmount = updatedGrantsAmount;
446 
447         addVestingGrant(_receiver, _amount, _timeToCliff, _vestingDuration);
448     }
449 
450     /**
451      * @dev Add a grant for tokens with a vesting schedule. An internal helper function used by addTeamGrant and addInvestorGrant
452      * @param _receiver Grant receiver
453      * @param _amount Amount of tokens included in the grant
454      * @param _timeToCliff Seconds until the vesting cliff
455      * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule
456      */
457     function addVestingGrant(
458         address _receiver,
459         uint256 _amount,
460         uint256 _timeToCliff,
461         uint256 _vestingDuration
462     )
463         internal
464     {
465         // Receiver must not have already received a grant with a vesting schedule
466         require(vestingHolders[_receiver] == address(0));
467 
468         // Create a vesting holder contract to act as the holder of the grant's tokens
469         // Note: the vesting grant is revokable
470         TokenVesting holder = new TokenVesting(_receiver, grantsStartTimestamp, _timeToCliff, _vestingDuration, true);
471         vestingHolders[_receiver] = holder;
472 
473         // Transfer ownership of the vesting holder to the bank multisig
474         // giving the bank multisig the ability to revoke the grant
475         holder.transferOwnership(bankMultisig);
476 
477         token.transfer(holder, _amount);
478     }
479 
480     /**
481      * @dev Add a community grant for tokens that are locked until a predetermined time in the future
482      * @param _receiver Grant receiver address
483      * @param _amount Amount of tokens included in the grant
484      */
485     function addCommunityGrant(
486         address _receiver,
487         uint256 _amount
488     )
489         external
490         onlyOwner
491         atStage(Stages.GenesisStart)
492     {
493         uint256 updatedGrantsAmount = communityGrantsAmount.add(_amount);
494         // Amount of tokens included in investor grants cannot exceed the community supply during genesis
495         require(updatedGrantsAmount <= communitySupply);
496 
497         communityGrantsAmount = updatedGrantsAmount;
498 
499         // Receiver must not have already received a grant with timelocked tokens
500         require(timeLockedHolders[_receiver] == address(0));
501 
502         // Create a timelocked holder contract to act as the holder of the grant's tokens
503         TokenTimelock holder = new TokenTimelock(token, _receiver, grantsStartTimestamp);
504         timeLockedHolders[_receiver] = holder;
505 
506         token.transfer(holder, _amount);
507     }
508 
509     /**
510      * @dev End genesis
511      */
512     function end() external onlyOwner atStage(Stages.GenesisStart) {
513         // Transfer the crowd supply to the token distribution contract
514         token.transfer(tokenDistribution, crowdSupply);
515         // Transfer company supply to the bank multisig
516         token.transfer(bankMultisig, companySupply);
517         // Transfer ownership of the LivepeerToken contract to the protocol Minter
518         token.transferOwnership(minter);
519 
520         stage = Stages.GenesisEnd;
521     }
522 }