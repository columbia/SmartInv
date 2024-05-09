1 pragma solidity ^0.4.21;
2 
3 // File: contracts/auth/AuthorizedList.sol
4 
5 /*
6  * Created by: alexo (Big Deeper Advisors, Inc)
7  * For: Input Strategic Partners (ISP) and Intimate.io
8  *
9  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
10  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
11  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
12  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
13  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
14  */
15 
16 pragma solidity ^0.4.21;
17 
18 contract AuthorizedList {
19 
20     bytes32 constant APHRODITE = keccak256("Goddess of Love!");
21     bytes32 constant CUPID = keccak256("Aphrodite's Little Helper.");
22     bytes32 constant BULKTRANSFER = keccak256("Bulk Transfer User.");
23     mapping (address => mapping(bytes32 => bool)) internal authorized;
24     mapping (bytes32 => bool) internal contractPermissions;
25 
26 }
27 
28 // File: contracts/auth/Authorized.sol
29 
30 /*
31  * Created by: alexo (Big Deeper Advisors, Inc)
32  * For: Input Strategic Partners (ISP) and Intimate.io
33  *
34  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
35  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
36  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
37  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
38  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
39  */
40 
41 pragma solidity ^0.4.21;
42 
43 
44 contract Authorized is AuthorizedList {
45 
46     function Authorized() public {
47         /// Set the initial permission for msg.sender (contract creator), it can then add permissions for others
48         authorized[msg.sender][APHRODITE] = true;
49     }
50 
51     /// Check if _address is authorized to access functionality with _authorization level
52     modifier ifAuthorized(address _address, bytes32 _authorization) {
53         require(authorized[_address][_authorization] || authorized[_address][APHRODITE]);
54         _;
55     }
56 
57     /// @dev Check if _address is authorized for _authorization
58     function isAuthorized(address _address, bytes32 _authorization) public view returns (bool) {
59         return authorized[_address][_authorization];
60     }
61 
62     /// @dev Change authorization for _address 
63     /// @param _address Address whose permission is to be changed
64     /// @param _authorization Authority to be changed
65     function toggleAuthorization(address _address, bytes32 _authorization) public ifAuthorized(msg.sender, APHRODITE) {
66 
67         /// Prevent inadvertent self locking out, cannot change own authority
68         require(_address != msg.sender);
69 
70         /// No need for lower level authorization to linger
71         if (_authorization == APHRODITE && !authorized[_address][APHRODITE]) {
72             authorized[_address][CUPID] = false;
73         }
74 
75         authorized[_address][_authorization] = !authorized[_address][_authorization];
76     }
77 }
78 
79 // File: contracts/managed/Pausable.sol
80 
81 /*
82  * Created by: alexo (Big Deeper Advisors, Inc)
83  * For: Input Strategic Partners (ISP) and Intimate.io
84  *
85  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
86  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
87  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
88  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
89  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
90  */
91 
92 pragma solidity ^0.4.21;
93 
94 
95 contract Pausable is AuthorizedList, Authorized {
96 
97     event Pause();
98     event Unpause();
99 
100 
101     /// @dev We deploy in UNpaused state, should it be paused?
102     bool public paused = false;
103 
104     /// Make sure access control is initialized
105     function Pausable() public AuthorizedList() Authorized() { }
106 
107 
108     /// @dev modifier to allow actions only when the contract IS NOT paused
109     modifier whenNotPaused {
110         require(!paused);
111         _;
112     }
113 
114 
115     /// @dev modifier to allow actions only when the contract is paused
116     modifier whenPaused {
117         require(paused);
118         _;
119     }
120 
121 
122     /// @dev called by an authorized msg.sender to pause, triggers stopped state
123     /// Multiple addresses may be authorized to call this method
124     function pause() public whenNotPaused ifAuthorized(msg.sender, CUPID) returns (bool) {
125         emit Pause();
126         paused = true;
127 
128         return true;
129     }
130 
131 
132     /// @dev called by an authorized msg.sender to unpause, returns to normal state
133     /// Multiple addresses may be authorized to call this method
134     function unpause() public whenPaused ifAuthorized(msg.sender, CUPID) returns (bool) {
135         emit Unpause();
136         paused = false;
137     
138         return true;
139     }
140 }
141 
142 // File: contracts/math/SafeMath.sol
143 
144 library SafeMath {
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a * b;
147         require(a == 0 || c / a == b);
148         return c;
149     }
150 
151     /* Not needed
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         // require(b > 0); // Solidity automatically throws when dividing by 0
154         uint256 c = a / b;
155         // require(a == b * c + a % b); // There is no case in which this doesn't hold
156         return c;
157     }
158     */
159 
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b <= a);
162         return a - b;
163     }
164 
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a);
168         return c;
169     }
170 }
171 
172 // File: contracts/token/IERC20Basic.sol
173 
174 /*
175  * Created by: alexo (Big Deeper Advisors, Inc)
176  * For: Input Strategic Partners (ISP) and Intimate.io
177  *
178  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
179  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
180  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
181  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
182  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
183  */
184 
185 pragma solidity ^0.4.21;
186 
187 contract IERC20Basic {
188 
189     function totalSupply() public view returns (uint256);
190     function balanceOf(address _who) public view returns (uint256);
191     function transfer(address _to, uint256 _value) public returns (bool);
192     event Transfer(address indexed _from, address indexed _to, uint256 _value);
193 
194 }
195 
196 // File: contracts/token/IERC20.sol
197 
198 /*
199  * Created by: alexo (Big Deeper Advisors, Inc)
200  * For: Input Strategic Partners (ISP) and Intimate.io
201  *
202  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
203  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
204  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
205  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
206  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
207  */
208 
209 pragma solidity ^0.4.21;
210 
211 
212 contract IERC20 is IERC20Basic {
213 
214     function allowance(address _tokenholder, address _tokenspender) view public returns (uint256);
215     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
216     function approve(address _tokenspender, uint256 _value) public returns (bool);
217     event Approval(address indexed _tokenholder, address indexed _tokenspender, uint256 _value);
218 
219 }
220 
221 // File: contracts/token/RecoverCurrency.sol
222 
223 /*
224  * Created by: alexo (Big Deeper Advisors, Inc)
225  * For: Input Strategic Partners (ISP) and Intimate.io
226  *
227  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
228  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
229  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
230  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
231  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
232  */
233 
234 pragma solidity ^0.4.21;
235 
236 
237 
238 /// @title Authorized account can reclaim ERC20Basic tokens.
239 contract RecoverCurrency is AuthorizedList, Authorized {
240 
241     event EtherRecovered(address indexed _to, uint256 _value);
242 
243     function recoverEther() external ifAuthorized(msg.sender, APHRODITE) {
244         msg.sender.transfer(address(this).balance);
245         emit EtherRecovered(msg.sender, address(this).balance);
246     }
247 
248     /// @dev Reclaim all ERC20Basic compatible tokens
249     /// @param _address The address of the token contract
250     function recoverToken(address _address) external ifAuthorized(msg.sender, APHRODITE) {
251         require(_address != address(0));
252         IERC20Basic token = IERC20Basic(_address);
253         uint256 balance = token.balanceOf(address(this));
254         token.transfer(msg.sender, balance);
255     }
256 }
257 
258 // File: contracts/managed/Freezable.sol
259 
260 /*
261  * Created by Input Strategic Partners (ISP) and Intimate.io
262  *
263  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
264  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
265  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
266  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
267  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
268  */
269 
270 pragma solidity ^0.4.21;
271 
272 
273 /**
274  * @title Freezable
275  * @dev allows authorized accounts to add/remove other accounts to the list of fozen accounts.
276  * Accounts in the list cannot transfer and approve and their balances and allowances cannot be retrieved.
277  */
278 contract Freezable is AuthorizedList, Authorized {
279 
280     event Frozen(address indexed _account);
281     event Unfrozen(address indexed _account);
282     
283     mapping (address => bool) public frozenAccounts;
284 
285     /// Make sure access control is initialized
286     function Freezable() public AuthorizedList() Authorized() { }
287 
288     /**
289     * @dev Throws if called by any account that's frozen.
290     */
291     modifier notFrozen {
292         require(!frozenAccounts[msg.sender]);
293         _;
294     }
295 
296     /**
297     * @dev check if an account is frozen
298     * @param account address to check
299     * @return true iff the address is in the list of frozen accounts and hasn't been unfrozen
300     */
301     function isFrozen(address account) public view returns (bool) {
302         return frozenAccounts[account];
303     }
304 
305     /**
306     * @dev add an address to the list of frozen accounts
307     * @param account address to freeze
308     * @return true if the address was added to the list of frozen accounts, false if the address was already in the list 
309     */
310     function freezeAccount(address account) public ifAuthorized(msg.sender, APHRODITE) returns (bool success) {
311         if (!frozenAccounts[account]) {
312             frozenAccounts[account] = true;
313             emit Frozen(account);
314             success = true; 
315         }
316     }
317 
318     /**
319     * @dev remove an address from the list of frozen accounts
320     * @param account address to unfreeze
321     * @return true if the address was removed from the list of frozen accounts, 
322     * false if the address wasn't in the list in the first place 
323     */
324     function unfreezeAccount(address account) public ifAuthorized(msg.sender, APHRODITE) returns (bool success) {
325         if (frozenAccounts[account]) {
326             frozenAccounts[account] = false;
327             emit Unfrozen(account);
328             success = true;
329         }
330     }
331 }
332 
333 // File: contracts/storage/AllowancesLedger.sol
334 
335 /*
336  * Created by: alexo (Big Deeper Advisors, Inc)
337  * For: Input Strategic Partners (ISP) and intimate.io
338  *
339  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
340  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, 
341  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE 
342  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, 
343  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
344  */
345 
346 pragma solidity ^0.4.21;
347 
348 contract AllowancesLedger {
349 
350     mapping (address => mapping (address => uint256)) public allowances;
351 
352 }
353 
354 // File: contracts/storage/TokenLedger.sol
355 
356 /*
357  * Created by: alexo (Big Deeper Advisors, Inc)
358  * For: Input Strategic Partners (ISP) and Intimate.io
359  *
360  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
361  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
362  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
363  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
364  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
365  */
366 
367 pragma solidity ^0.4.21;
368 
369 
370 contract TokenLedger is AuthorizedList, Authorized {
371 
372     mapping(address => uint256) public balances;
373     uint256 public totalsupply;
374 
375     struct SeenAddressRecord {
376         bool seen;
377         uint256 accountArrayIndex;
378     }
379 
380     // Iterable accounts
381     address[] internal accounts;
382     mapping(address => SeenAddressRecord) internal seenBefore;
383 
384     /// @dev Keeping track of addresses in an array is useful as mappings are not iterable
385     /// @return Number of addresses holding this token
386     function numberAccounts() public view ifAuthorized(msg.sender, APHRODITE) returns (uint256) {
387         return accounts.length;
388     }
389 
390     /// @dev Keeping track of addresses in an array is useful as mappings are not iterable
391     function returnAccounts() public view ifAuthorized(msg.sender, APHRODITE) returns (address[] holders) {
392         return accounts;
393     }
394 
395     function balanceOf(uint256 _id) public view ifAuthorized(msg.sender, CUPID) returns (uint256 balance) {
396         require (_id < accounts.length);
397         return balances[accounts[_id]];
398     }
399 }
400 
401 // File: contracts/storage/TokenSettings.sol
402 
403 /*
404  * Created by: alexo (Big Deeper Advisors, Inc)
405  * For: Input Strategic Partners (ISP) and Intimate.io
406  *
407  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
408  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
409  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
410  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
411  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
412  */
413 
414 pragma solidity ^0.4.21;
415 
416 
417 contract TokenSettings is AuthorizedList, Authorized {
418 
419     /// These strings should be set temporarily for testing on Rinkeby/Ropsten/Kovan to somethin else
420     /// to avoid people squatting on names
421     /// Change back to "intimate" and "ITM" for mainnet deployment
422 
423     string public name = "intimate";
424     string public symbol = "ITM";
425 
426     uint256 public INITIAL_SUPPLY = 100000000 * 10**18;  // 100 million of subdivisible tokens
427     uint8 public constant decimals = 18;
428 
429 
430     /// @dev Change token name
431     /// @param _name string
432     function setName(string _name) public ifAuthorized(msg.sender, APHRODITE) {
433         name = _name;
434     }
435 
436     /// @dev Change token symbol
437     /// @param _symbol string
438     function setSymbol(string _symbol) public ifAuthorized(msg.sender, APHRODITE) {
439         symbol = _symbol;
440     }
441 }
442 
443 // File: contracts/storage/BasicTokenStorage.sol
444 
445 /*
446  * Created by: alexo (Big Deeper Advisors, Inc)
447  * For: Input Strategic Partners (ISP) and Intimate.io
448  *
449  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
450  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
451  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
452  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
453  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
454  */
455 
456 pragma solidity ^0.4.21;
457 
458 
459 
460 
461 
462 /// Collect all the state variables for the token's functions into a single contract
463 contract BasicTokenStorage is AuthorizedList, Authorized, TokenSettings, AllowancesLedger, TokenLedger {
464 
465     /// @dev Ensure that authorization is set
466     function BasicTokenStorage() public Authorized() TokenSettings() AllowancesLedger() TokenLedger() { }
467 
468     /// @dev Keep track of addresses seen before, push new ones into accounts list
469     /// @param _tokenholder address to check for "newness"
470     function trackAddresses(address _tokenholder) internal {
471         if (!seenBefore[_tokenholder].seen) {
472             seenBefore[_tokenholder].seen = true;
473             accounts.push(_tokenholder);
474             seenBefore[_tokenholder].accountArrayIndex = accounts.length - 1;
475         }
476     }
477 
478     /// @dev remove address from seenBefore and accounts
479     /// @param _tokenholder address to remove
480     function removeSeenAddress(address _tokenholder) internal {
481         uint index = seenBefore[_tokenholder].accountArrayIndex;
482         require(index < accounts.length);
483 
484         if (index != accounts.length - 1) {
485             accounts[index] = accounts[accounts.length - 1];
486         } 
487         accounts.length--;
488         delete seenBefore[_tokenholder];
489     }
490 }
491 
492 // File: contracts/token/BasicToken.sol
493 
494 /*
495  * Created by: alexo (Big Deeper Advisors, Inc)
496  * For: Input Strategic Partners (ISP) and Intimate.io
497  *
498  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
499  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
500  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
501  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
502  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
503  */
504 
505 pragma solidity ^0.4.21;
506 
507 
508 
509 
510 
511 
512 
513 contract BasicToken is IERC20Basic, BasicTokenStorage, Pausable, Freezable {
514 
515     using SafeMath for uint256;
516 
517     event Transfer(address indexed _tokenholder, address indexed _tokenrecipient, uint256 _value);
518     event BulkTransfer(address indexed _tokenholder, uint256 _howmany);
519 
520     /// @dev Return the total token supply
521     function totalSupply() public view whenNotPaused returns (uint256) {
522         return totalsupply;
523     }
524 
525     /// @dev transfer token for a specified address
526     /// @param _to The address to transfer to.
527     /// @param _value The amount to be transferred.
528     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen returns (bool) {
529 
530         /// No transfers to 0x0 address, use burn instead, if implemented
531         require(_to != address(0));
532 
533         /// No useless operations
534         require(msg.sender != _to);
535 
536         /// This will revert if not enough funds
537         balances[msg.sender] = balances[msg.sender].sub(_value);
538 
539         if (balances[msg.sender] == 0) {
540             removeSeenAddress(msg.sender);
541         }
542 
543         /// _to might be a completely new address, so check and store if so
544         trackAddresses(_to);
545 
546         /// This will revert on overflow
547         balances[_to] = balances[_to].add(_value);
548 
549         /// Emit the Transfer event
550         emit Transfer(msg.sender, _to, _value);
551 
552         return true;
553     }
554 
555     /// @dev bulkTransfer tokens to a list of specified addresses, not an ERC20 function
556     /// @param _tos The list of addresses to transfer to.
557     /// @param _values The list of amounts to be transferred.
558     function bulkTransfer(address[] _tos, uint256[] _values) public whenNotPaused notFrozen ifAuthorized(msg.sender, BULKTRANSFER) returns (bool) {
559 
560         require (_tos.length == _values.length);
561 
562         uint256 sourceBalance = balances[msg.sender];
563 
564         /// Temporarily set balance to 0 to mitigate the possibility of re-entrancy attacks
565         balances[msg.sender] = 0;
566 
567         for (uint256 i = 0; i < _tos.length; i++) {
568             uint256 currentValue = _values[i];
569             address _to = _tos[i];
570             require(_to != address(0));
571             require(currentValue <= sourceBalance);
572             require(msg.sender != _to);
573 
574             sourceBalance = sourceBalance.sub(currentValue);
575             balances[_to] = balances[_to].add(currentValue);
576 
577             trackAddresses(_to);
578 
579             emit Transfer(msg.sender, _tos[i], currentValue);
580         }
581 
582         /// Set to the remaining balance
583         balances[msg.sender] = sourceBalance;
584 
585         emit BulkTransfer(msg.sender, _tos.length);
586 
587         if (balances[msg.sender] == 0) {
588             removeSeenAddress(msg.sender);
589         }
590 
591         return true;
592     }
593 
594 
595     /// @dev Gets balance of the specified account.
596     /// @param _tokenholder Address of interest
597     /// @return Balance for the passed address
598     function balanceOf(address _tokenholder) public view whenNotPaused returns (uint256 balance) {
599         require(!isFrozen(_tokenholder));
600         return balances[_tokenholder];
601     }
602 }
603 
604 // File: contracts/token/StandardToken.sol
605 
606 /*
607  * Created by: alexo (Big Deeper Advisors, Inc)
608  * For: Input Strategic Partners (ISP) and Intimate.io
609  *
610  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
611  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
612  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
613  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
614  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
615  */
616 
617 pragma solidity ^0.4.21;
618 
619 
620 
621 
622 
623 
624 
625 
626 contract StandardToken is IERC20Basic, BasicToken, IERC20 {
627 
628     using SafeMath for uint256;
629 
630     event Approval(address indexed _tokenholder, address indexed _tokenspender, uint256 _value);
631 
632     /// @dev Implements ERC20 transferFrom from one address to another
633     /// @param _from The source address  for tokens
634     /// @param _to The destination address for tokens
635     /// @param _value The number/amount to transfer
636     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen returns (bool) {
637 
638         // Don't send tokens to 0x0 address, use burn function that updates totalSupply
639         // and don't waste gas sending tokens to yourself
640         require(_to != address(0) && _from != _to);
641 
642         require(!isFrozen(_from) && !isFrozen(_to));
643 
644         /// This will revert if _value is larger than the allowance
645         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
646 
647         balances[_from] = balances[_from].sub(_value);
648 
649         /// _to might be a completely new address, so check and store if so
650         trackAddresses(_to);
651 
652         balances[_to] = balances[_to].add(_value);
653 
654         /// Emit the Transfer event
655         emit Transfer(_from, _to, _value);
656 
657         return true;
658     }
659 
660 
661     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
662     /// @param _tokenspender The address which will spend the funds.
663     /// @param _value The amount of tokens to be spent.
664     function approve(address _tokenspender, uint256 _value) public whenNotPaused notFrozen returns (bool) {
665 
666         require(_tokenspender != address(0) && msg.sender != _tokenspender);
667 
668         require(!isFrozen(_tokenspender));
669 
670         /// To mitigate reentrancy race condition, set allowance for _tokenspender to 0
671         /// first and then set the new value
672         /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
673         require((_value == 0) || (allowances[msg.sender][_tokenspender] == 0));
674 
675         /// Allow _tokenspender to transfer up to _value in tokens from msg.sender
676         allowances[msg.sender][_tokenspender] = _value;
677 
678         /// Emit the Approval event
679         emit Approval(msg.sender, _tokenspender, _value);
680 
681         return true;
682     }
683 
684 
685     /// @dev Function to check the amount of tokens that a spender can spend
686     /// @param _tokenholder Token owner account address
687     /// @param _tokenspender Account address authorized to transfer tokens
688     /// @return Amount of tokens still available to _tokenspender to transfer.
689     function allowance(address _tokenholder, address _tokenspender) public view whenNotPaused returns (uint256) {
690         require(!isFrozen(_tokenholder) && !isFrozen(_tokenspender));
691         return allowances[_tokenholder][_tokenspender];
692     }
693 }
694 
695 // File: contracts/sales/IntimateShoppe.sol
696 
697 /*
698  * Created by: alexo (Big Deeper Advisors, Inc)
699  * For: Input Strategic Partners (ISP) and Intimate.io
700  *
701  * Derived from some public sources and substantially extended/adapted for intimate's use.
702  *
703  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
704  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
705  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
706  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
707  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
708  */
709 
710 pragma solidity ^0.4.21;
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 contract IntimateShoppe is Pausable, RecoverCurrency {
721 
722     using SafeMath for uint256;
723 
724     /// List of contributors, i.e. msg.sender(s) who has sent in Ether
725     address[] internal contributors;
726 
727     /// List of contributions for each contributor
728     mapping (address => uint256[]) internal contributions;
729 
730     event Transfer(address indexed _from, address indexed _to, uint256 _value);
731 
732     /// @dev event for token purchase logging
733     /// @param _seller_wallet_address account that sends tokens
734     /// @param _buyer_address who got the tokens in exchange for ether
735     /// @param _value weis paid for purchase
736     /// @param _amount of tokens purchased
737     event ITMTokenPurchase(address indexed _seller_wallet_address, address indexed _buyer_address, uint256 _value, uint256 _amount);
738 
739     /// @dev Starting and ending times for sale period
740     event SetPeriod(uint256 _startTime, uint256 _endTime);
741 
742 
743     /// The ITM token object
744     StandardToken public token;
745 
746     /// address of the ITM token
747     address public token_address;
748 
749     /// start and end timestamps in between which investments are allowed (both inclusive)
750     uint256 public startTime;
751     uint256 public endTime;
752 
753     /// address where funds are collected, it could a simple address or multi-sig wallet contract
754     address public wallet_address;
755 
756     /// how many token units a buyer gets per wei
757     uint256 public rate = 600;
758 
759     /// upper limit for tokens to be sold in this public offering
760     /// NOTE: Since decimals are set at 1e18, if one sets a limit of one(1) ITM, this number should be
761     /// 1 * 1e18
762     uint256 public capTokens;
763 
764     /// Maxiumum acceptable Ether amount 
765     uint256 public maxValue = 100 ether;
766 
767     /// Minimum acceptable Ether amount, 1 ITM worth
768     uint256 public minValue = uint256(1 ether)/600;
769 
770     /// amount of raised money in wei
771     uint256 public weiRaised = 0;
772     uint256 public tokensSold = 0;
773 
774     /// High water line for contract balance
775     uint256 internal highWater = 1 ether;
776 
777     /// What round it is
778     uint8 public round = 0;
779 
780     /// @param _startTime is the absolute time from which to start accepting Ether
781     /// @param _duration is the period of time in seconds how long the sale would last, so if a sale lasts 1 month
782     /// then the _duration = 30(31)*24*60*60 seconds
783     function IntimateShoppe(
784         uint256 _startTime, 
785         uint256 _duration, 
786         uint256 _rate, 
787         address _wallet_address, 
788         address _token_address, 
789         uint256 _cap,
790         uint8 _round) public Authorized() {
791 
792         require(_startTime >= 0 && _duration > 0);
793         require(_rate > 0);
794         require(_wallet_address != address(0x0));
795         require(_token_address != address(0x0));
796         require(_cap > 0);
797 
798         round = _round;
799 
800         startTime = _startTime;
801         endTime = startTime + _duration;
802 
803         rate = _rate;
804         minValue = uint256(1 ether)/_rate;
805         capTokens = _cap;
806         wallet_address = _wallet_address;
807         token_address = _token_address;
808         token = StandardToken(token_address);
809     }
810 
811     /// @dev Log contributors and their contributions
812     /// @param _sender A Contributor's address
813     /// @param _value Amount of Ether said contributor sent
814     function trackContributions(address _sender, uint256 _value) internal {
815         if (contributions[_sender].length == 0) {
816             contributors.push(_sender);
817         }
818         contributions[_sender].push(_value);
819     }
820 
821     /// @dev Retrieve contributors
822     /// @return A list of contributors
823     function getContributors() external view ifAuthorized(msg.sender, APHRODITE) returns (address[]) {
824         return contributors;
825     }
826 
827     /// @dev Retrieve contributions by a single contributor 
828     /// @param _contributor The account associated with contributions
829     /// @return A list of ether amounts that _contributor sent in
830     /// Using the function above one can get a list first, and then get individual Ether payments
831     /// and aggregate them if needed
832     function getContributionsForAddress(address _contributor) external view ifAuthorized(msg.sender, APHRODITE) returns (uint256[]) {
833         return contributions[_contributor];
834     }
835 
836     /// @dev If a sale is done using multiple rounds, allowing for better pricing structure, depending on
837     /// on market demand and value of the ITM token. Is also set via the constructor
838     /// @param _round Round label/count
839     function setRound(uint8 _round) public ifAuthorized(msg.sender, APHRODITE) {
840         round = _round;
841     }
842 
843     /// @dev Sets the maximum Value in Ether to purchase tokens
844     /// @param _maxValue Amount in wei
845     function setMaxValue(uint256 _maxValue) public ifAuthorized(msg.sender, APHRODITE) {
846         /// Cannot be modified once sale is ongoing
847         require(now < startTime || now > endTime);
848         maxValue = _maxValue;
849     }
850 
851     /// @dev Sets the mininum Value in Ether to purchase tokens
852     /// @param _minValue Amount in wei
853     function setMinValue(uint256 _minValue) public ifAuthorized(msg.sender, APHRODITE) {
854         /// Cannot be modified once sale is ongoing
855         require(now < startTime || now > endTime);
856         minValue = _minValue;
857     }
858 
859 
860     /// @dev Reset the starting and ending times for the next round
861     /// @param _startTime Start of the sale round
862     /// @param _duration End of the sale round
863     function setTimes(uint256 _startTime, uint256 _duration) public ifAuthorized(msg.sender, APHRODITE) {
864         /// Can't reset times if sale ongoing already, make sure everything else is set before
865         require(now < startTime || now > endTime);
866 
867         require(_startTime >= 0 && _duration > 0);
868         startTime = _startTime;
869         endTime = startTime + _duration;
870         emit SetPeriod(startTime, endTime);
871     }
872 
873 
874     /// @dev Set the cap, i.e. how many token units  we will sell in this round
875     /// @param _capTokens How many token units are offered in a round
876     function setCap(uint256 _capTokens) public ifAuthorized(msg.sender, APHRODITE) {
877         /// Cannot be modified once sale is ongoing
878         require(now < startTime || now > endTime);
879         require(_capTokens > 0);
880         capTokens = _capTokens;
881     }
882 
883     /// @dev Set the rate, i.e. how many units per wei do we give
884     /// @param _rate How many token units are offered for 1 wei, 1 or more.
885     function setRate(uint256 _rate) public ifAuthorized(msg.sender, APHRODITE) {
886         require(_rate > 0);
887         rate = _rate;
888     }
889 
890     /// @dev Change the wallet address
891     /// @param _wallet_address replacement wallet address
892     function changeCompanyWallet(address _wallet_address) public ifAuthorized(msg.sender, APHRODITE) {
893         wallet_address = _wallet_address;
894     }
895 
896     /// @dev highWater determines at what contract balance Ether is forwarded to wallet_address
897     /// @return highWater
898     function getHighWater() public view ifAuthorized(msg.sender, APHRODITE) returns (uint256) {
899         return highWater;
900     }
901 
902     /// @dev Set the high water line/ceiling
903     /// @param _highWater Sets the threshold to shift Ether to another address
904     function setHighWater(uint256 _highWater) public ifAuthorized(msg.sender, APHRODITE) {
905         highWater = _highWater;
906     }
907 
908 
909     /// fallback function used to buy tokens
910     function () payable public {
911         /// Make certain msg.value sent is within permitted bounds
912         require(msg.value >= minValue && msg.value <= maxValue);
913         backTokenOwner();
914     }
915 
916     /// @dev Main purchase function
917     function backTokenOwner() whenNotPaused internal {
918 
919         // Within the current sale period
920         require(now >= startTime && now <= endTime);
921 
922         // Transfer Ether from this contract to the company's or foundation's wallet_address
923 
924         if (address(this).balance >= highWater) {
925             //wallet_address.transfer(msg.value);
926             wallet_address.transfer(address(this).balance);
927             emit Transfer(this, wallet_address, address(this).balance);
928         }
929 
930         /// Keep data about buyers's addresses and amounts
931         /// If this functionality is not wanted, comment out the next line
932         trackContributions(msg.sender, msg.value);
933 
934         uint256 tokens = msg.value.mul(rate);
935 
936         /// Transfer purchased tokens to the public buyer
937 
938         /// Note that the address authorized to control the token contract needs to set "wallet_address" allowance
939         /// using ERC20 approve function before this contract can transfer tokens.
940    
941         if (token.transferFrom(wallet_address, msg.sender, tokens)) {
942 
943             token.freezeAccount(msg.sender);
944 
945             weiRaised = weiRaised.add(msg.value);
946             tokensSold = tokensSold.add(tokens);
947             emit ITMTokenPurchase(wallet_address, msg.sender, msg.value, tokens);
948 
949             // Check the cap and revert if exceeded
950             require(tokensSold <= capTokens);
951         }
952     }
953 }