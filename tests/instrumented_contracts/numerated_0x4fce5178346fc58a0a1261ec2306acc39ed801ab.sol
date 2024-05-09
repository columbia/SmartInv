1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68 * @dev This is a library based implementation of the ERC20 token standard.
69 * This library allows all values to be set by interface logic. This includes
70 * the ability to set msg.sender. This allows two distinct advantages:
71 *  - Access control logic may be layered without the need to change the
72 *    core logic of the ERC20 system in any way.
73 *  - Tokens that require administrative action, under some conditions,
74 *    may take administrative action on an account, without having to
75 *    create fragile backdoors into the transfer logic of the token. This
76 *    system makes such administrative priveledge clear, apparent, and
77 *    more easily auditable to ensure reasonable limitations of power.
78 */
79 library ERC20Lib {
80 
81 
82   ////////////////////////////////////////////////////////////////////////////
83   //Imports
84 
85   /**
86   * @dev Prevents underflow and overflow attacks..
87   */
88   using SafeMath for uint256;
89   ///////////////////////////////////////////////////////////////////////////
90 
91 
92   ////////////////////////////////////////////////////////////////////////////
93   //Events
94 
95   /**
96   * @dev Transfer event emitted in 3 cases; transfers, minting, and burning.
97   * for transfers, all fields set as normal
98   * for minting from is set to address(0)
99   * for burning is set to address(0)
100   */
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 
103   /**
104   * @dev Specifies an approval being granted from an owner to a spender
105   * for the amount specified.
106   */
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108   ////////////////////////////////////////////////////////////////////////////
109 
110   ////////////////////////////////////////////////////////////////////////////
111   //Declarations
112 
113   /**
114   * @dev Struct like representation of ERC20 state vairiables.
115   * this allows the ERC20 logic to become a library under using for syntax
116   */
117   struct Token{
118     mapping (address => uint256) _balances;
119     mapping (address => mapping (address => uint256)) _allowed;
120     uint256 _totalSupply;
121   }
122   ////////////////////////////////////////////////////////////////////////////
123 
124 
125   ////////////////////////////////////////////////////////////////////////////
126   //Logic
127 
128   /**
129   * @dev Returns the total supply of the token.
130   */
131   function totalSupply(Token storage self)
132   internal
133   view
134   returns (uint256) {
135     return self._totalSupply;
136   }
137 
138   /**
139   * @dev Returns the balance of an account.
140   */
141   function balances(Token storage self, address account)
142   internal
143   view
144   returns (uint256) {
145     return self._balances[account];
146   }
147 
148   /**
149   * @dev Returns the total allowance from the account to the spender..
150   */
151   function allowance(Token storage self, address account, address spender)
152   internal
153   view
154   returns (uint256) {
155     return self._allowed[account][spender];
156   }
157 
158   /**
159   * @dev Issues an allowance from an account to another.
160   */
161   function approve(Token storage self, address sender, address spender, uint256 value)
162   internal {
163     require(spender != address(0));
164     self._allowed[sender][spender] = value;
165     emit Approval(sender, spender, value);
166   }
167 
168   /**
169   * @dev Cause a transfer to occur based on an existing allowance.
170   */
171   function transferFrom(Token storage self, address sender, address from, address to, uint256 value)
172   internal {
173     require(value <= self._allowed[from][sender]);
174     self._allowed[from][sender] = self._allowed[from][sender].sub(value);
175     transfer(self,from, to, value);
176   }
177 
178   /**
179   * @dev Increase the allowance from one account to another. Prevents
180   * change allowance attack.
181   */
182   function increaseAllowance(Token storage self, address sender, address spender, uint256 addedValue)
183   internal {
184     require(spender != address(0));
185     self._allowed[sender][spender] = self._allowed[sender][spender].add(addedValue);
186     emit Approval(sender, spender, self._allowed[sender][spender]);
187   }
188 
189   /**
190   * @dev Decrease the allowance from one account to another. Prevents
191   * the change allowance attack.
192   */
193   function decreaseAllowance(Token storage self, address sender, address spender, uint256 subtractedValue)
194   internal {
195     require(spender != address(0));
196     self._allowed[sender][spender] = self._allowed[sender][spender].sub(subtractedValue);
197     emit Approval(sender, spender, self._allowed[sender][spender]);
198   }
199 
200   /**
201   * @dev Transfer tokens from one account to another.
202   */
203   function transfer(Token storage self, address sender, address to, uint256 value)
204   internal {
205     require(value <= self._balances[sender]);
206     require(to != address(0));
207     self._balances[sender] = self._balances[sender].sub(value);
208     self._balances[to] = self._balances[to].add(value);
209     emit Transfer(sender, to, value);
210   }
211 
212   /**
213   * @dev Mint new tokens to an account.
214   */
215   function mint(Token storage self, address account, uint256 value)
216   internal {
217     require(account != 0);
218     self._totalSupply = self._totalSupply.add(value);
219     self._balances[account] = self._balances[account].add(value);
220     emit Transfer(address(0), account, value);
221   }
222 
223   /**
224   * @dev Burn tokens from an account.
225   */
226   function burn(Token storage self, address account, uint256 value)
227   internal {
228     require(account != 0);
229     require(value <= self._balances[account]);
230     self._totalSupply = self._totalSupply.sub(value);
231     self._balances[account] = self._balances[account].sub(value);
232     emit Transfer(account, address(0), value);
233   }
234   ////////////////////////////////////////////////////////////////////////////
235 
236 }
237 
238 
239 
240 contract HubCulture{
241 
242   ////////////////////////////////////////////////////////////////////////////
243   //Imports
244   using ERC20Lib for ERC20Lib.Token;
245   using SafeMath for uint256;
246   ///////////////////////////////////////////////////////////////////////////
247 
248   ///////////////////////////////////////////////////////////////////////////
249   //Events
250   event Pending(address indexed account, uint256 indexed value, uint256 indexed nonce);
251   event Deposit(address indexed account, uint256 indexed value, uint256 indexed nonce);
252   event Withdraw(address indexed account, uint256 indexed value, uint256 indexed nonce);
253   event Decline(address indexed account, uint256 indexed value, uint256 indexed nonce);
254   event Registration(address indexed account, bytes32 indexed uuid, uint256 indexed nonce);
255   event Unregistered(address indexed account, uint256 indexed nonce);
256   ////////////////////////////////////////////////////////////////////////////
257 
258   ////////////////////////////////////////////////////////////////////////////
259   //Declarations
260   mapping(address=>bool) authorities;
261   mapping(address=>bool) registered;
262   mapping(address=>bool) vaults;
263   ERC20Lib.Token token;
264   ERC20Lib.Token pending;
265   uint256 eventNonce;
266   address failsafe;
267   address owner;
268   bool paused;
269   ////////////////////////////////////////////////////////////////////////////
270 
271   ////////////////////////////////////////////////////////////////////////////
272   //Constructor
273   constructor(address _owner,address _failsafe)
274   public {
275     failsafe = _failsafe;
276     owner = _owner;
277   }
278   ////////////////////////////////////////////////////////////////////////////
279 
280   ////////////////////////////////////////////////////////////////////////////
281   //Modifiers
282   modifier onlyFailsafe(){
283     require(msg.sender == failsafe);
284     _;
285   }
286 
287   modifier onlyAdmin(){
288     require(msg.sender == owner || msg.sender == failsafe);
289     _;
290   }
291 
292   modifier onlyAuthority(){
293     require(authorities[msg.sender]);
294     _;
295   }
296 
297   modifier onlyVault(){
298     require(vaults[msg.sender]);
299     _;
300   }
301 
302   modifier notPaused(){
303     require(!paused);
304     _;
305   }
306   ////////////////////////////////////////////////////////////////////////////
307 
308   ////////////////////////////////////////////////////////////////////////////
309   //Failsafe Logic
310   function isFailsafe(address _failsafe)
311   public
312   view
313   returns (bool){
314     return (failsafe == _failsafe);
315   }
316 
317   function setFailsafe(address _failsafe)
318   public
319   onlyFailsafe{
320     failsafe = _failsafe;
321   }
322   ////////////////////////////////////////////////////////////////////////////
323 
324   ////////////////////////////////////////////////////////////////////////////
325   //Owner Logic
326   function isOwner(address _owner)
327   public
328   view
329   returns (bool){
330     return (owner == _owner);
331   }
332 
333   function setOwner(address _owner)
334   public
335   onlyAdmin{
336     owner = _owner;
337   }
338   ////////////////////////////////////////////////////////////////////////////
339 
340   ////////////////////////////////////////////////////////////////////////////
341   //Vault Logic
342   function isVault(address vault)
343   public
344   view
345   returns (bool) {
346     return vaults[vault];
347   }
348 
349   function addVault(address vault)
350   public
351   onlyAdmin
352   notPaused
353   returns (bool) {
354     vaults[vault] = true;
355     return true;
356   }
357 
358   function removeVault(address vault)
359   public
360   onlyAdmin
361   returns (bool) {
362     vaults[vault] = false;
363     return true;
364   }
365   ////////////////////////////////////////////////////////////////////////////
366 
367   ////////////////////////////////////////////////////////////////////////////
368   //Authority Logic
369   function isAuthority(address authority)
370   public
371   view
372   returns (bool) {
373     return authorities[authority];
374   }
375 
376   function addAuthority(address authority)
377   public
378   onlyAdmin
379   notPaused
380   returns (bool) {
381     authorities[authority] = true;
382     return true;
383   }
384 
385   function removeAuthority(address authority)
386   public
387   onlyAdmin
388   returns (bool) {
389     authorities[authority] = false;
390     return true;
391   }
392   ////////////////////////////////////////////////////////////////////////////
393 
394   ////////////////////////////////////////////////////////////////////////////
395   //Pause Logic
396 
397   /**
398   * @dev Administrative lockdown check.
399   **/
400   function isPaused()
401   public
402   view
403   returns (bool) {
404     return paused;
405   }
406 
407   /**
408   * @dev Locks down all actions except administrative actions. Should be used
409   * to address security flaws. If this contract has a critical bug, This method
410   * should be called to allow for a hault of operations and a migration to occur
411   * If this method is called due to a loss of server keys, it will hault
412   * operation until root cause may be found.
413   **/
414   function pause()
415   public
416   onlyAdmin
417   notPaused
418   returns (bool) {
419     paused = true;
420     return true;
421   }
422 
423   /**
424   * @dev Releases system from administrative lockdown. Requires retrieval of
425   * failsafe coldwallet.
426   **/
427   function unpause()
428   public
429   onlyFailsafe
430   returns (bool) {
431     paused = false;
432     return true;
433   }
434 
435   /**
436   * @dev Locks down all actions FOREVER! This should only be used in
437   * manual contract migration due to critical bug. This will halt all
438   *operations and allow a new contract to be built by transfering all balances.
439   **/
440   function lockForever()
441   public
442   onlyFailsafe
443   returns (bool) {
444     pause();
445     setOwner(address(this));
446     setFailsafe(address(this));
447     return true;
448   }
449   ////////////////////////////////////////////////////////////////////////////
450 
451   ////////////////////////////////////////////////////////////////////////////
452   //Panic Logic
453 
454   /**
455   * @dev Lets everyone know if something catastrophic has occured. The owner,
456   * and failsafe should not ever be the same entity. This combined with a paused
457   * state indicates that panic has most likely been called or this contract has
458   * been permanently locked for migration.
459   */
460   function isBadDay()
461   public
462   view
463   returns (bool) {
464     return (isPaused() && (owner == failsafe));
465   }
466   ////////////////////////////////////////////////////////////////////////////
467 
468   ////////////////////////////////////////////////////////////////////////////
469   //ERC20Lib Wrappers
470 
471   /**
472   * @dev These methods act as transparent wrappers around the ERC20Lib. The
473   * only changes in logic are as follows:
474   *  - The msg.sender must be explicitly set by the wrapper
475   *  - The totalSupply has been broken up into 3 functions as totalSupply
476   *    pendingSupply, and activeSupply.
477   * Pending supply is the supply that has been deposited but not released
478   * Active supply is the released deposited supply
479   * Total supply is the sum of active and pending.
480   */
481   function totalSupply()
482   public
483   view
484   returns (uint256) {
485     uint256 supply = 0;
486     supply = supply.add(pending.totalSupply());
487     supply = supply.add(token.totalSupply());
488     return supply;
489   }
490 
491   function pendingSupply()
492   public
493   view
494   returns (uint256) {
495     return pending.totalSupply();
496   }
497 
498   function availableSupply()
499   public
500   view
501   returns (uint256) {
502     return token.totalSupply();
503   }
504 
505   function balanceOf(address account)
506   public
507   view
508   returns (uint256) {
509     return token.balances(account);
510   }
511 
512   function allowance(address account, address spender)
513   public
514   view
515   returns (uint256) {
516     return token.allowance(account,spender);
517   }
518 
519   function transfer(address to, uint256 value)
520   public
521   notPaused
522   returns (bool) {
523     token.transfer(msg.sender, to, value);
524     return true;
525   }
526 
527   function approve(address spender, uint256 value)
528   public
529   notPaused
530   returns (bool) {
531     token.approve(msg.sender,spender,value);
532     return true;
533   }
534 
535   function transferFrom(address from, address to, uint256 value)
536   public
537   notPaused
538   returns (bool) {
539     token.transferFrom(msg.sender,from,to,value);
540     return true;
541   }
542 
543   function increaseAllowance(address spender, uint256 addedValue)
544   public
545   notPaused
546   returns (bool) {
547     token.increaseAllowance(msg.sender,spender,addedValue);
548     return true;
549   }
550 
551   function decreaseAllowance(address spender, uint256 subtractedValue)
552   public
553   notPaused
554   returns (bool) {
555     token.decreaseAllowance(msg.sender,spender,subtractedValue);
556     return true;
557   }
558   ////////////////////////////////////////////////////////////////////////////
559 
560   ////////////////////////////////////////////////////////////////////////////
561   //Deposit Logic
562 
563   /**
564   * @dev This logic allows for a delay between a deposit
565   * and the release of funds. This is accomplished by maintaining
566   * two independant ERC20 contracts in this one contract by using
567   * the ERC20Lib library.
568   * The first is the token contract that is used to transfer value
569   * as is normally expected of an ERC20. The second is the system
570   * that allows Ven to be dposited and withdrawn from the
571   * blockchain such that no extra priveledge is given to HubCulture
572   * for on blockchain actions. This system also allows for the time
573   * delay based approval of deposits. Further, the entity that
574   * creates a deposit request is an authority, but only a vault
575   * may release the deposit into the active balances of the ERC20
576   * token.
577   */
578 
579 
580   /**
581   * @dev Deposit value from HubCulture into ERC20
582   * This is a pending deposit that must be released.
583   * Only an authority may request a deposit.
584   */
585   function deposit(address account, uint256 value)
586   public
587   notPaused
588   onlyAuthority
589   returns (bool) {
590     pending.mint(account,value);
591     eventNonce+=1;
592     emit Pending(account,value,eventNonce);
593     return true;
594   }
595 
596   /**
597   * @dev Release a deposit from pending state and credit
598   * account with the balance due.
599   */
600   function releaseDeposit(address account, uint256 value)
601   public
602   notPaused
603   onlyVault
604   returns (bool) {
605     pending.burn(account,value);
606     token.mint(account,value);
607     eventNonce+=1;
608     emit Deposit(account,value,eventNonce);
609     return true;
610   }
611 
612   /**
613   * @dev Cancel a deposit. This prevents the deposit from
614   * being released.
615   */
616   function revokeDeposit(address account, uint256 value)
617   public
618   notPaused
619   onlyVault
620   returns (bool) {
621     pending.burn(account,value);
622     eventNonce+=1;
623     emit Decline(account,value,eventNonce);
624     return true;
625   }
626   ////////////////////////////////////////////////////////////////////////////
627 
628   ////////////////////////////////////////////////////////////////////////////
629   //Withdraw Logic
630 
631   /**
632   * @dev Withdraw tokens by burning the balance and emitting the event.
633   * In order to withdraw the account must be a registered wallet. This is
634   * to prevent loss of funds.
635   */
636   function withdraw(uint256 value)
637   public
638   notPaused
639   returns (bool) {
640     require(registered[msg.sender]);
641     token.burn(msg.sender,value);
642     eventNonce+=1;
643     emit Withdraw(msg.sender,value,eventNonce);
644     return true;
645   }
646   ////////////////////////////////////////////////////////////////////////////
647 
648   ////////////////////////////////////////////////////////////////////////////
649   //Wallet Registration Logic
650 
651   /**
652   * @dev Allows the registration state of a wallet to be queried.
653   */
654   function isRegistered(address wallet)
655   public
656   view
657   returns (bool) {
658     return registered[wallet];
659   }
660 
661   /**
662   * @dev Allows a HubCulture user to claim thier wallet. This system works
663   * as follows:
664   *  - User must enter the address they wish to claim on HubCulture
665   *  - The user will be provided with a UUID that will be a randomly
666   *      generated value (salt) hashed with the user ID for this user.
667   *  -  The keccak256 of the uuid and account address will then be
668   *      signed by an authority to ensure authenticity.
669   *  -  The user must submit a transaction, from the claimed account, with
670   *      the uuid, proof, and signature from the authority as arguments to
671   *      this method.
672   * If all checks pass, the account registration event should be emitted,
673   * and this account may now withdraw Ven to HubCulture.
674   */
675   function register(bytes32 uuid, uint8 v, bytes32 r, bytes32 s)
676   public
677   notPaused
678   returns (bool) {
679     require(authorities[ecrecover(keccak256(abi.encodePacked(msg.sender,uuid)),v,r,s)]);
680     registered[msg.sender]=true;
681     eventNonce+=1;
682     emit Registration(msg.sender, uuid, eventNonce);
683     return true;
684   }
685 
686   /**
687   * @dev Allows an authority to unregister an account. This will prevent
688   * a withdraw comand from being issued by this account unless it is
689   * re-registered. This is not a security feature. This is a cleanup
690   * function to ensure that closed accounts become zeroed out to minimize
691   * chain bloat.
692   */
693   function unregister(address wallet)
694   public
695   notPaused
696   onlyAuthority
697   returns (bool) {
698     registered[wallet] = false;
699     eventNonce+=1;
700     emit Unregistered(wallet, eventNonce);
701     return true;
702   }
703   ////////////////////////////////////////////////////////////////////////////
704 
705 }