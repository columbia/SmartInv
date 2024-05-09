1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title SafeERC20
19  * @dev Wrappers around ERC20 operations that throw on failure.
20  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
21  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
22  */
23 library SafeERC20 {
24   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
25     assert(token.transfer(to, value));
26   }
27 
28   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
29     assert(token.transferFrom(from, to, value));
30   }
31 
32   function safeApprove(ERC20 token, address spender, uint256 value) internal {
33     assert(token.approve(spender, value));
34   }
35 }
36 
37 contract Ownable {
38 
39     address public owner;
40 
41     modifier onlyOwner {
42         require(isOwner(msg.sender));
43         _;
44     }
45 
46     function Ownable() public {
47         owner = msg.sender;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         owner = _newOwner;
52     }
53 
54     function isOwner(address _address) public constant returns (bool) {
55         return owner == _address;
56     }
57 }
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64 
65   /**
66   * @dev Multiplies two numbers, throws on overflow.
67   */
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     if (a == 0) {
70       return 0;
71     }
72     uint256 c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     // assert(b > 0); // Solidity automatically throws when dividing by 0
82     uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84     return c;
85   }
86 
87   /**
88   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
89   */
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   /**
96   * @dev Adds two numbers, throws on overflow.
97   */
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 /**
106  * @title TokenVesting
107  * @dev A token holder contract that can release its token balance gradually like a
108  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
109  * owner.
110  */
111 contract TokenVesting is Ownable {
112   using SafeMath for uint256;
113   using SafeERC20 for ERC20Basic;
114 
115   event Released(uint256 amount);
116   event Revoked();
117 
118   // beneficiary of tokens after they are released
119   address public beneficiary;
120 
121   uint256 public cliff;
122   uint256 public start;
123   uint256 public duration;
124 
125   bool public revocable;
126 
127   mapping (address => uint256) public released;
128   mapping (address => bool) public revoked;
129 
130   /**
131    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
132    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
133    * of the balance will have vested.
134    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
135    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
136    * @param _duration duration in seconds of the period in which the tokens will vest
137    * @param _revocable whether the vesting is revocable or not
138    */
139   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
140     require(_beneficiary != address(0));
141     require(_cliff <= _duration);
142 
143     beneficiary = _beneficiary;
144     revocable = _revocable;
145     duration = _duration;
146     cliff = _start.add(_cliff);
147     start = _start;
148   }
149 
150   /**
151    * @notice Transfers vested tokens to beneficiary.
152    * @param token ERC20 token which is being vested
153    */
154   function release(ERC20Basic token) public {
155     uint256 unreleased = releasableAmount(token);
156 
157     require(unreleased > 0);
158 
159     released[token] = released[token].add(unreleased);
160 
161     token.safeTransfer(beneficiary, unreleased);
162 
163     Released(unreleased);
164   }
165 
166   /**
167    * @notice Allows the owner to revoke the vesting. Tokens already vested
168    * remain in the contract, the rest are returned to the owner.
169    * @param token ERC20 token which is being vested
170    */
171   function revoke(ERC20Basic token) public onlyOwner {
172     require(revocable);
173     require(!revoked[token]);
174 
175     uint256 balance = token.balanceOf(this);
176 
177     uint256 unreleased = releasableAmount(token);
178     uint256 refund = balance.sub(unreleased);
179 
180     revoked[token] = true;
181 
182     token.safeTransfer(owner, refund);
183 
184     Revoked();
185   }
186 
187   /**
188    * @dev Calculates the amount that has already vested but hasn't been released yet.
189    * @param token ERC20 token which is being vested
190    */
191   function releasableAmount(ERC20Basic token) public view returns (uint256) {
192     return vestedAmount(token).sub(released[token]);
193   }
194 
195   /**
196    * @dev Calculates the amount that has already vested.
197    * @param token ERC20 token which is being vested
198    */
199   function vestedAmount(ERC20Basic token) public view returns (uint256) {
200     uint256 currentBalance = token.balanceOf(this);
201     uint256 totalBalance = currentBalance.add(released[token]);
202 
203     if (now < cliff) {
204       return 0;
205     } else if (now >= start.add(duration) || revoked[token]) {
206       return totalBalance;
207     } else {
208       return totalBalance.mul(now.sub(start)).div(duration);
209     }
210   }
211 }
212 
213 contract FTT is Ownable {
214     using SafeMath for uint256;
215 
216     uint256 public totalSupply = 1000000000 * 10**uint256(decimals);
217     string public constant name = "FarmaTrust Token";
218     string public symbol = "FTT";
219     uint8 public constant decimals = 18;
220 
221     mapping(address => uint256) public balances;
222     mapping (address => mapping (address => uint256)) internal allowed;
223 
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225     event Transfer(address indexed from, address indexed to, uint256 value);
226     event FTTIssued(address indexed from, address indexed to, uint256 indexed amount, uint256 timestamp);
227     event TdeStarted(uint256 startTime);
228     event TdeStopped(uint256 stopTime);
229     event TdeFinalized(uint256 finalizeTime);
230 
231     // Amount of FTT available during tok0x2Ec9F52A5e4E7B5e20C031C1870Fd952e1F01b3Een distribution event.
232     uint256 public constant FT_TOKEN_SALE_CAP = 600000000 * 10**uint256(decimals);
233 
234     // Amount held for operational usage.
235     uint256 public FT_OPERATIONAL_FUND = totalSupply - FT_TOKEN_SALE_CAP;
236 
237     // Amount held for team usage.
238     uint256 public FT_TEAM_FUND = FT_OPERATIONAL_FUND / 10;
239 
240     // Amount of FTT issued.
241     uint256 public fttIssued = 0;
242 
243     address public tdeIssuer = 0x2Ec9F52A5e4E7B5e20C031C1870Fd952e1F01b3E;
244     address public teamVestingAddress;
245     address public unsoldVestingAddress;
246     address public operationalReserveAddress;
247 
248     bool public tdeActive;
249     bool public tdeStarted;
250     bool public isFinalized = false;
251     bool public capReached;
252     uint256 public tdeDuration = 60 days;
253     uint256 public tdeStartTime;
254 
255     function FTT() public {
256 
257     }
258 
259     modifier onlyTdeIssuer {
260         require(msg.sender == tdeIssuer);
261         _;
262     }
263 
264     modifier tdeRunning {
265         require(tdeActive && block.timestamp < tdeStartTime + tdeDuration);
266         _;
267     }
268 
269     modifier tdeEnded {
270         require(((!tdeActive && block.timestamp > tdeStartTime + tdeDuration) && tdeStarted) || capReached);
271         _;
272     }
273 
274     /**
275      * @dev Allows contract owner to start the TDE.
276      */
277     function startTde()
278         public
279         onlyOwner
280     {
281         require(!isFinalized);
282         tdeActive = true;
283         tdeStarted = true;
284         if (tdeStartTime == 0) {
285             tdeStartTime = block.timestamp;
286         }
287         TdeStarted(tdeStartTime);
288     }
289 
290     /**
291      * @dev Allows contract owner to stop and optionally restart the TDE.
292      * @param _restart Resets the tdeStartTime if true.
293      */
294     function stopTde(bool _restart)
295         external
296         onlyOwner
297     {
298       tdeActive = false;
299       if (_restart) {
300         tdeStartTime = 0;
301       }
302       TdeStopped(block.timestamp);
303     }
304 
305     /**
306      * @dev Allows contract owner to increase TDE period.
307      * @param _time amount of time to increase TDE period by.
308      */
309     function extendTde(uint256 _time)
310         external
311         onlyOwner
312     {
313       tdeDuration = tdeDuration.add(_time);
314     }
315 
316     /**
317      * @dev Allows contract owner to reduce TDE period.
318      * @param _time amount of time to reduce TDE period by.
319      */
320     function shortenTde(uint256 _time)
321         external
322         onlyOwner
323     {
324       tdeDuration = tdeDuration.sub(_time);
325     }
326 
327     /**
328      * @dev Allows contract owner to set the FTT issuing authority.
329      * @param _tdeIssuer address of FTT issuing authority.
330      */
331     function setTdeIssuer(address _tdeIssuer)
332         external
333         onlyOwner
334     {
335         tdeIssuer = _tdeIssuer;
336     }
337 
338     /**
339      * @dev Allows contract owner to set the beneficiary of the FT operational reserve amount of FTT.
340      * @param _operationalReserveAddress address of FT operational reserve beneficiary.
341      */
342     function setOperationalReserveAddress(address _operationalReserveAddress)
343         external
344         onlyOwner
345         tdeRunning
346     {
347         operationalReserveAddress = _operationalReserveAddress;
348     }
349 
350     /**
351      * @dev Issues FTT to entitled accounts.
352      * @param _user address to issue FTT to.
353      * @param _fttAmount amount of FTT to issue.
354      */
355     function issueFTT(address _user, uint256 _fttAmount)
356         public
357         onlyTdeIssuer
358         tdeRunning
359         returns(bool)
360     {
361         uint256 newAmountIssued = fttIssued.add(_fttAmount);
362         require(_user != address(0));
363         require(_fttAmount > 0);
364         require(newAmountIssued <= FT_TOKEN_SALE_CAP);
365 
366         balances[_user] = balances[_user].add(_fttAmount);
367         fttIssued = newAmountIssued;
368         FTTIssued(tdeIssuer, _user, _fttAmount, block.timestamp);
369 
370         if (fttIssued == FT_TOKEN_SALE_CAP) {
371             capReached = true;
372         }
373 
374         return true;
375     }
376 
377     /**
378      * @dev Returns amount of FTT issued.
379      */
380     function fttIssued()
381         external
382         view
383         returns (uint256)
384     {
385         return fttIssued;
386     }
387 
388     /**
389      * @dev Allows the contract owner to finalize the TDE.
390      */
391     function finalize()
392         external
393         tdeEnded
394         onlyOwner
395     {
396         require(!isFinalized);
397 
398         // Deposit team fund amount into team vesting contract.
399         uint256 teamVestingCliff = 15778476;  // 6 months
400         uint256 teamVestingDuration = 1 years;
401         TokenVesting teamVesting = new TokenVesting(owner, now, teamVestingCliff, teamVestingDuration, true);
402         teamVesting.transferOwnership(owner);
403         teamVestingAddress = address(teamVesting);
404         balances[teamVestingAddress] = FT_TEAM_FUND;
405 
406         if (!capReached) {
407             // Deposit unsold FTT into unsold vesting contract.
408             uint256 unsoldVestingCliff = 3 years;
409             uint256 unsoldVestingDuration = 10 years;
410             TokenVesting unsoldVesting = new TokenVesting(owner, now, unsoldVestingCliff, unsoldVestingDuration, true);
411             unsoldVesting.transferOwnership(owner);
412             unsoldVestingAddress = address(unsoldVesting);
413             balances[unsoldVestingAddress] = FT_TOKEN_SALE_CAP - fttIssued;
414         }
415 
416         // Allocate operational reserve of FTT.
417         balances[operationalReserveAddress] = FT_OPERATIONAL_FUND - FT_TEAM_FUND;
418 
419         isFinalized = true;
420         TdeFinalized(block.timestamp);
421     }
422 
423     /**
424      * @dev Transfer tokens from one address to another. Trading limited - requires the TDE to have ended.
425      * @param _from address The address which you want to send tokens from
426      * @param _to address The address which you want to transfer to
427      * @param _value uint256 the amount of tokens to be transferred
428      */
429     function transferFrom(address _from, address _to, uint256 _value)
430         public
431         returns (bool)
432     {
433         if (!isFinalized) return false;
434         require(_to != address(0));
435         require(_value <= balances[_from]);
436         require(_value <= allowed[_from][msg.sender]);
437 
438         balances[_from] = balances[_from].sub(_value);
439         balances[_to] = balances[_to].add(_value);
440         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
441         Transfer(_from, _to, _value);
442         return true;
443     }
444 
445      /**
446     * @dev Transfer token for a specified address.  Trading limited - requires the TDE to have ended.
447     * @param _to The address to transfer to.
448     * @param _value The amount to be transferred.
449     */
450     function transfer(address _to, uint256 _value)
451         public
452         returns (bool)
453     {
454         if (!isFinalized) return false;
455         require(_to != address(0));
456         require(_value <= balances[msg.sender]);
457 
458         balances[msg.sender] = balances[msg.sender].sub(_value);
459         balances[_to] = balances[_to].add(_value);
460         Transfer(msg.sender, _to, _value);
461         return true;
462     }
463 
464     /**
465      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
466      *
467      * Beware that changing an allowance with this method brings the risk that someone may use both the old
468      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
469      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
470      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
471      * @param _spender The address which will spend the funds.
472      * @param _value The amount of tokens to be spent.
473      */
474     function approve(address _spender, uint256 _value)
475         public
476         returns (bool)
477     {
478         require(_spender != address(0));
479         allowed[msg.sender][_spender] = _value;
480         Approval(msg.sender, _spender, _value);
481         return true;
482     }
483 
484     /**
485     * @dev Gets the balance of the specified address.
486     * @param _owner The address to query the the balance of.
487     * @return An uint256 representing the amount owned by the passed address.
488     */
489     function balanceOf(address _owner)
490         public
491         view
492         returns (uint256 balance)
493     {
494         return balances[_owner];
495     }
496 
497     /**
498      * @dev Function to check the amount of tokens that an owner allowed to a spender.
499      * @param _owner address The address which owns the funds.
500      * @param _spender address The address which will spend the funds.
501      * @return A uint256 specifying the amount of tokens still available for the spender.
502      */
503     function allowance(address _owner, address _spender)
504         public
505         view
506         returns (uint256)
507     {
508         return allowed[_owner][_spender];
509     }
510 
511     /**
512      * approve should be called when allowed[_spender] == 0. To increment
513      * allowed value, it is better to use this function to avoid 2 calls (and wait until
514      * the first transaction is mined)
515      */
516     function increaseApproval(address _spender, uint _addedValue)
517         public
518         returns (bool success)
519     {
520         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
521         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
522         return true;
523     }
524 
525     function decreaseApproval(address _spender, uint _subtractedValue)
526         public
527         returns (bool success)
528     {
529         uint oldValue = allowed[msg.sender][_spender];
530         if (_subtractedValue > oldValue) {
531             allowed[msg.sender][_spender] = 0;
532         } else {
533             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
534         }
535         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
536         return true;
537     }
538 }