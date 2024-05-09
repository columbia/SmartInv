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
79 // File: contracts/math/SafeMath.sol
80 
81 library SafeMath {
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a * b;
84         require(a == 0 || c / a == b);
85         return c;
86     }
87 
88     /* Not needed
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // require(b > 0); // Solidity automatically throws when dividing by 0
91         uint256 c = a / b;
92         // require(a == b * c + a % b); // There is no case in which this doesn't hold
93         return c;
94     }
95     */
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b <= a);
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a);
105         return c;
106     }
107 }
108 
109 // File: contracts/token/IERC20Basic.sol
110 
111 /*
112  * Created by: alexo (Big Deeper Advisors, Inc)
113  * For: Input Strategic Partners (ISP) and Intimate.io
114  *
115  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
116  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
117  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
118  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
119  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
120  */
121 
122 pragma solidity ^0.4.21;
123 
124 contract IERC20Basic {
125 
126     function totalSupply() public view returns (uint256);
127     function balanceOf(address _who) public view returns (uint256);
128     function transfer(address _to, uint256 _value) public returns (bool);
129     event Transfer(address indexed _from, address indexed _to, uint256 _value);
130 
131 }
132 
133 // File: contracts/token/RecoverCurrency.sol
134 
135 /*
136  * Created by: alexo (Big Deeper Advisors, Inc)
137  * For: Input Strategic Partners (ISP) and Intimate.io
138  *
139  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
140  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
141  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
142  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
143  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
144  */
145 
146 pragma solidity ^0.4.21;
147 
148 
149 
150 /// @title Authorized account can reclaim ERC20Basic tokens.
151 contract RecoverCurrency is AuthorizedList, Authorized {
152 
153     event EtherRecovered(address indexed _to, uint256 _value);
154 
155     function recoverEther() external ifAuthorized(msg.sender, APHRODITE) {
156         msg.sender.transfer(address(this).balance);
157         emit EtherRecovered(msg.sender, address(this).balance);
158     }
159 
160     /// @dev Reclaim all ERC20Basic compatible tokens
161     /// @param _address The address of the token contract
162     function recoverToken(address _address) external ifAuthorized(msg.sender, APHRODITE) {
163         require(_address != address(0));
164         IERC20Basic token = IERC20Basic(_address);
165         uint256 balance = token.balanceOf(address(this));
166         token.transfer(msg.sender, balance);
167     }
168 }
169 
170 // File: contracts/managed/Freezable.sol
171 
172 /*
173  * Created by Input Strategic Partners (ISP) and Intimate.io
174  *
175  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
176  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
177  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
178  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
179  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
180  */
181 
182 pragma solidity ^0.4.21;
183 
184 
185 /**
186  * @title Freezable
187  * @dev allows authorized accounts to add/remove other accounts to the list of fozen accounts.
188  * Accounts in the list cannot transfer and approve and their balances and allowances cannot be retrieved.
189  */
190 contract Freezable is AuthorizedList, Authorized {
191 
192     event Frozen(address indexed _account);
193     event Unfrozen(address indexed _account);
194     
195     mapping (address => bool) public frozenAccounts;
196 
197     /// Make sure access control is initialized
198     function Freezable() public AuthorizedList() Authorized() { }
199 
200     /**
201     * @dev Throws if called by any account that's frozen.
202     */
203     modifier notFrozen {
204         require(!frozenAccounts[msg.sender]);
205         _;
206     }
207 
208     /**
209     * @dev check if an account is frozen
210     * @param account address to check
211     * @return true iff the address is in the list of frozen accounts and hasn't been unfrozen
212     */
213     function isFrozen(address account) public view returns (bool) {
214         return frozenAccounts[account];
215     }
216 
217     /**
218     * @dev add an address to the list of frozen accounts
219     * @param account address to freeze
220     * @return true if the address was added to the list of frozen accounts, false if the address was already in the list 
221     */
222     function freezeAccount(address account) public ifAuthorized(msg.sender, APHRODITE) returns (bool success) {
223         if (!frozenAccounts[account]) {
224             frozenAccounts[account] = true;
225             emit Frozen(account);
226             success = true; 
227         }
228     }
229 
230     /**
231     * @dev remove an address from the list of frozen accounts
232     * @param account address to unfreeze
233     * @return true if the address was removed from the list of frozen accounts, 
234     * false if the address wasn't in the list in the first place 
235     */
236     function unfreezeAccount(address account) public ifAuthorized(msg.sender, APHRODITE) returns (bool success) {
237         if (frozenAccounts[account]) {
238             frozenAccounts[account] = false;
239             emit Unfrozen(account);
240             success = true;
241         }
242     }
243 }
244 
245 // File: contracts/managed/Pausable.sol
246 
247 /*
248  * Created by: alexo (Big Deeper Advisors, Inc)
249  * For: Input Strategic Partners (ISP) and Intimate.io
250  *
251  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
252  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
253  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
254  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
255  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
256  */
257 
258 pragma solidity ^0.4.21;
259 
260 
261 contract Pausable is AuthorizedList, Authorized {
262 
263     event Pause();
264     event Unpause();
265 
266 
267     /// @dev We deploy in UNpaused state, should it be paused?
268     bool public paused = false;
269 
270     /// Make sure access control is initialized
271     function Pausable() public AuthorizedList() Authorized() { }
272 
273 
274     /// @dev modifier to allow actions only when the contract IS NOT paused
275     modifier whenNotPaused {
276         require(!paused);
277         _;
278     }
279 
280 
281     /// @dev modifier to allow actions only when the contract is paused
282     modifier whenPaused {
283         require(paused);
284         _;
285     }
286 
287 
288     /// @dev called by an authorized msg.sender to pause, triggers stopped state
289     /// Multiple addresses may be authorized to call this method
290     function pause() public whenNotPaused ifAuthorized(msg.sender, CUPID) returns (bool) {
291         emit Pause();
292         paused = true;
293 
294         return true;
295     }
296 
297 
298     /// @dev called by an authorized msg.sender to unpause, returns to normal state
299     /// Multiple addresses may be authorized to call this method
300     function unpause() public whenPaused ifAuthorized(msg.sender, CUPID) returns (bool) {
301         emit Unpause();
302         paused = false;
303     
304         return true;
305     }
306 }
307 
308 // File: contracts/storage/AllowancesLedger.sol
309 
310 /*
311  * Created by: alexo (Big Deeper Advisors, Inc)
312  * For: Input Strategic Partners (ISP) and intimate.io
313  *
314  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
315  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, 
316  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE 
317  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, 
318  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
319  */
320 
321 pragma solidity ^0.4.21;
322 
323 contract AllowancesLedger {
324 
325     mapping (address => mapping (address => uint256)) public allowances;
326 
327 }
328 
329 // File: contracts/storage/TokenLedger.sol
330 
331 /*
332  * Created by: alexo (Big Deeper Advisors, Inc)
333  * For: Input Strategic Partners (ISP) and Intimate.io
334  *
335  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
336  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
337  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
338  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
339  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
340  */
341 
342 pragma solidity ^0.4.21;
343 
344 
345 contract TokenLedger is AuthorizedList, Authorized {
346 
347     mapping(address => uint256) public balances;
348     uint256 public totalsupply;
349 
350     struct SeenAddressRecord {
351         bool seen;
352         uint256 accountArrayIndex;
353     }
354 
355     // Iterable accounts
356     address[] internal accounts;
357     mapping(address => SeenAddressRecord) internal seenBefore;
358 
359     /// @dev Keeping track of addresses in an array is useful as mappings are not iterable
360     /// @return Number of addresses holding this token
361     function numberAccounts() public view ifAuthorized(msg.sender, APHRODITE) returns (uint256) {
362         return accounts.length;
363     }
364 
365     /// @dev Keeping track of addresses in an array is useful as mappings are not iterable
366     function returnAccounts() public view ifAuthorized(msg.sender, APHRODITE) returns (address[] holders) {
367         return accounts;
368     }
369 
370     function balanceOf(uint256 _id) public view ifAuthorized(msg.sender, CUPID) returns (uint256 balance) {
371         require (_id < accounts.length);
372         return balances[accounts[_id]];
373     }
374 }
375 
376 // File: contracts/storage/TokenSettings.sol
377 
378 /*
379  * Created by: alexo (Big Deeper Advisors, Inc)
380  * For: Input Strategic Partners (ISP) and Intimate.io
381  *
382  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
383  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
384  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
385  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
386  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
387  */
388 
389 pragma solidity ^0.4.21;
390 
391 
392 contract TokenSettings is AuthorizedList, Authorized {
393 
394     /// These strings should be set temporarily for testing on Rinkeby/Ropsten/Kovan to somethin else
395     /// to avoid people squatting on names
396     /// Change back to "intimate" and "ITM" for mainnet deployment
397 
398     string public name = "intimate";
399     string public symbol = "ITM";
400 
401     uint256 public INITIAL_SUPPLY = 100000000 * 10**18;  // 100 million of subdivisible tokens
402     uint8 public constant decimals = 18;
403 
404 
405     /// @dev Change token name
406     /// @param _name string
407     function setName(string _name) public ifAuthorized(msg.sender, APHRODITE) {
408         name = _name;
409     }
410 
411     /// @dev Change token symbol
412     /// @param _symbol string
413     function setSymbol(string _symbol) public ifAuthorized(msg.sender, APHRODITE) {
414         symbol = _symbol;
415     }
416 }
417 
418 // File: contracts/storage/BasicTokenStorage.sol
419 
420 /*
421  * Created by: alexo (Big Deeper Advisors, Inc)
422  * For: Input Strategic Partners (ISP) and Intimate.io
423  *
424  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
425  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
426  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
427  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
428  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
429  */
430 
431 pragma solidity ^0.4.21;
432 
433 
434 
435 
436 
437 /// Collect all the state variables for the token's functions into a single contract
438 contract BasicTokenStorage is AuthorizedList, Authorized, TokenSettings, AllowancesLedger, TokenLedger {
439 
440     /// @dev Ensure that authorization is set
441     function BasicTokenStorage() public Authorized() TokenSettings() AllowancesLedger() TokenLedger() { }
442 
443     /// @dev Keep track of addresses seen before, push new ones into accounts list
444     /// @param _tokenholder address to check for "newness"
445     function trackAddresses(address _tokenholder) internal {
446         if (!seenBefore[_tokenholder].seen) {
447             seenBefore[_tokenholder].seen = true;
448             accounts.push(_tokenholder);
449             seenBefore[_tokenholder].accountArrayIndex = accounts.length - 1;
450         }
451     }
452 
453     /// @dev remove address from seenBefore and accounts
454     /// @param _tokenholder address to remove
455     function removeSeenAddress(address _tokenholder) internal {
456         uint index = seenBefore[_tokenholder].accountArrayIndex;
457         require(index < accounts.length);
458 
459         if (index != accounts.length - 1) {
460             accounts[index] = accounts[accounts.length - 1];
461         } 
462         accounts.length--;
463         delete seenBefore[_tokenholder];
464     }
465 }
466 
467 // File: contracts/token/BasicToken.sol
468 
469 /*
470  * Created by: alexo (Big Deeper Advisors, Inc)
471  * For: Input Strategic Partners (ISP) and Intimate.io
472  *
473  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
474  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
475  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
476  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
477  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
478  */
479 
480 pragma solidity ^0.4.21;
481 
482 
483 
484 
485 
486 
487 
488 contract BasicToken is IERC20Basic, BasicTokenStorage, Pausable, Freezable {
489 
490     using SafeMath for uint256;
491 
492     event Transfer(address indexed _tokenholder, address indexed _tokenrecipient, uint256 _value);
493     event BulkTransfer(address indexed _tokenholder, uint256 _howmany);
494 
495     /// @dev Return the total token supply
496     function totalSupply() public view whenNotPaused returns (uint256) {
497         return totalsupply;
498     }
499 
500     /// @dev transfer token for a specified address
501     /// @param _to The address to transfer to.
502     /// @param _value The amount to be transferred.
503     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen returns (bool) {
504 
505         /// No transfers to 0x0 address, use burn instead, if implemented
506         require(_to != address(0));
507 
508         /// No useless operations
509         require(msg.sender != _to);
510 
511         /// This will revert if not enough funds
512         balances[msg.sender] = balances[msg.sender].sub(_value);
513 
514         if (balances[msg.sender] == 0) {
515             removeSeenAddress(msg.sender);
516         }
517 
518         /// _to might be a completely new address, so check and store if so
519         trackAddresses(_to);
520 
521         /// This will revert on overflow
522         balances[_to] = balances[_to].add(_value);
523 
524         /// Emit the Transfer event
525         emit Transfer(msg.sender, _to, _value);
526 
527         return true;
528     }
529 
530     /// @dev bulkTransfer tokens to a list of specified addresses, not an ERC20 function
531     /// @param _tos The list of addresses to transfer to.
532     /// @param _values The list of amounts to be transferred.
533     function bulkTransfer(address[] _tos, uint256[] _values) public whenNotPaused notFrozen ifAuthorized(msg.sender, BULKTRANSFER) returns (bool) {
534 
535         require (_tos.length == _values.length);
536 
537         uint256 sourceBalance = balances[msg.sender];
538 
539         /// Temporarily set balance to 0 to mitigate the possibility of re-entrancy attacks
540         balances[msg.sender] = 0;
541 
542         for (uint256 i = 0; i < _tos.length; i++) {
543             uint256 currentValue = _values[i];
544             address _to = _tos[i];
545             require(_to != address(0));
546             require(currentValue <= sourceBalance);
547             require(msg.sender != _to);
548 
549             sourceBalance = sourceBalance.sub(currentValue);
550             balances[_to] = balances[_to].add(currentValue);
551 
552             trackAddresses(_to);
553 
554             emit Transfer(msg.sender, _tos[i], currentValue);
555         }
556 
557         /// Set to the remaining balance
558         balances[msg.sender] = sourceBalance;
559 
560         emit BulkTransfer(msg.sender, _tos.length);
561 
562         if (balances[msg.sender] == 0) {
563             removeSeenAddress(msg.sender);
564         }
565 
566         return true;
567     }
568 
569 
570     /// @dev Gets balance of the specified account.
571     /// @param _tokenholder Address of interest
572     /// @return Balance for the passed address
573     function balanceOf(address _tokenholder) public view whenNotPaused returns (uint256 balance) {
574         require(!isFrozen(_tokenholder));
575         return balances[_tokenholder];
576     }
577 }
578 
579 // File: contracts/token/IERC20.sol
580 
581 /*
582  * Created by: alexo (Big Deeper Advisors, Inc)
583  * For: Input Strategic Partners (ISP) and Intimate.io
584  *
585  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
586  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
587  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
588  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
589  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
590  */
591 
592 pragma solidity ^0.4.21;
593 
594 
595 contract IERC20 is IERC20Basic {
596 
597     function allowance(address _tokenholder, address _tokenspender) view public returns (uint256);
598     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
599     function approve(address _tokenspender, uint256 _value) public returns (bool);
600     event Approval(address indexed _tokenholder, address indexed _tokenspender, uint256 _value);
601 
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
695 // File: contracts/token/Aphrodite.sol
696 
697 /*
698  * Created by: alexo (Big Deeper Advisors, Inc)
699  * For: Input Strategic Partners (ISP) and Intimate.io
700  *
701  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
702  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
703  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
704  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
705  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
706  */
707 
708 pragma solidity ^0.4.21;
709 
710 
711 
712 
713 
714 contract Aphrodite is AuthorizedList, Authorized, RecoverCurrency, StandardToken {
715 
716     event DonationAccepted(address indexed _from, uint256 _value);
717 
718     /// @dev Constructor that gives msg.sender/creator all of existing tokens.
719     function Aphrodite() Authorized()  public {
720     
721         /// We need to initialize totalsupply and creator's balance
722         totalsupply = INITIAL_SUPPLY;
723         balances[msg.sender] = INITIAL_SUPPLY;
724 
725         /// Record that the creator is a holder of this token
726         trackAddresses(msg.sender);
727     }
728 
729     /// @dev If one prefers to not accept Ether, comment out the next iine out or put revert(); inside
730     function () public payable { emit DonationAccepted(msg.sender, msg.value); }
731 
732 }