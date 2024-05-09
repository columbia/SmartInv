1 pragma solidity ^0.4.21;
2 
3 
4 
5 // File: contracts/library/SafeMath.sol
6 
7 /**
8  * @title Safe Math
9  *
10  * @dev Library for safe mathematical operations.
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16 
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a / b;
22 
23         return c;
24     }
25 
26     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function plus(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35 
36         return c;
37     }
38 }
39 
40 // File: contracts/token/ERC20Token.sol
41 
42 /**
43  * @dev The standard ERC20 Token contract base.
44  */
45 contract ERC20Token {
46     uint256 public totalSupply;  /* shorthand for public function and a property */
47 
48     function balanceOf(address _owner) public view returns (uint256 balance);
49     function transfer(address _to, uint256 _value) public returns (bool success);
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
51     function approve(address _spender, uint256 _value) public returns (bool success);
52     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 }
57 
58 
59 
60 // File: contracts/component/TokenSafe.sol
61 
62 /**
63  * @title TokenSafe
64  *
65  * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group
66  *      has it's own release time and multiple accounts with locked tokens.
67  */
68 contract TokenSafe {
69     using SafeMath for uint;
70 
71     // The ERC20 token contract.
72     ERC20Token token;
73 
74     struct Group {
75         // The release date for the locked tokens
76         // Note: Unix timestamp fits in uint32, however block.timestamp is uint256
77         uint256 releaseTimestamp;
78         // The total remaining tokens in the group.
79         uint256 remaining;
80         // The individual account token balances in the group.
81         mapping (address => uint) balances;
82     }
83 
84     // The groups of locked tokens
85     mapping (uint8 => Group) public groups;
86 
87     /**
88      * @dev The constructor.
89      *
90      * @param _token The address of the  contract.
91      */
92     constructor(address _token) public {
93         token = ERC20Token(_token);
94     }
95 
96     /**
97      * @dev The function initializes a group with a release date.
98      *
99      * @param _id Group identifying number.
100      * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released
101      */
102     function init(uint8 _id, uint _releaseTimestamp) internal {
103         require(_releaseTimestamp > 0);
104 
105         Group storage group = groups[_id];
106         group.releaseTimestamp = _releaseTimestamp;
107     }
108 
109     /**
110      * @dev Add new account with locked token balance to the specified group id.
111      *
112      * @param _id Group identifying number.
113      * @param _account The address of the account to be added.
114      * @param _balance The number of tokens to be locked.
115      */
116     function add(uint8 _id, address _account, uint _balance) internal {
117         Group storage group = groups[_id];
118         group.balances[_account] = group.balances[_account].plus(_balance);
119         group.remaining = group.remaining.plus(_balance);
120     }
121 
122     /**
123      * @dev Allows an account to be released if it meets the time constraints of the group.
124      *
125      * @param _id Group identifying number.
126      * @param _account The address of the account to be released.
127      */
128     function release(uint8 _id, address _account) public {
129         Group storage group = groups[_id];
130         require(now >= group.releaseTimestamp);
131 
132         uint tokens = group.balances[_account];
133         require(tokens > 0);
134 
135         group.balances[_account] = 0;
136         group.remaining = group.remaining.minus(tokens);
137 
138         if (!token.transfer(_account, tokens)) {
139             revert();
140         }
141     }
142 }
143 
144 
145 
146 
147 
148 
149 // File: contracts/token/StandardToken.sol
150 
151 /**
152  * @title Standard Token
153  *
154  * @dev The standard abstract implementation of the ERC20 interface.
155  */
156 contract StandardToken is ERC20Token {
157     using SafeMath for uint256;
158 
159     string public name;
160     string public symbol;
161     uint8 public decimals;
162 
163     mapping (address => uint256) balances;
164     mapping (address => mapping (address => uint256)) internal allowed;
165 
166     /**
167      * @dev The constructor assigns the token name, symbols and decimals.
168      */
169     constructor(string _name, string _symbol, uint8 _decimals) internal {
170         name = _name;
171         symbol = _symbol;
172         decimals = _decimals;
173     }
174 
175     /**
176      * @dev Get the balance of an address.
177      *
178      * @param _address The address which's balance will be checked.
179      *
180      * @return The current balance of the address.
181      */
182     function balanceOf(address _address) public view returns (uint256 balance) {
183         return balances[_address];
184     }
185 
186     /**
187      * @dev Checks the amount of tokens that an owner allowed to a spender.
188      *
189      * @param _owner The address which owns the funds allowed for spending by a third-party.
190      * @param _spender The third-party address that is allowed to spend the tokens.
191      *
192      * @return The number of tokens available to `_spender` to be spent.
193      */
194     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
195         return allowed[_owner][_spender];
196     }
197 
198     /**
199      * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.
200      * E.g. You place a buy or sell order on an exchange and in that example, the
201      * `_spender` address is the address of the contract the exchange created to add your token to their
202      * website and you are `msg.sender`.
203      *
204      * @param _spender The address which will spend the funds.
205      * @param _value The amount of tokens to be spent.
206      *
207      * @return Whether the approval process was successful or not.
208      */
209     function approve(address _spender, uint256 _value) public returns (bool) {
210         allowed[msg.sender][_spender] = _value;
211 
212         emit Approval(msg.sender, _spender, _value);
213 
214         return true;
215     }
216 
217     /**
218      * @dev Transfers `_value` number of tokens to the `_to` address.
219      *
220      * @param _to The address of the recipient.
221      * @param _value The number of tokens to be transferred.
222      */
223     function transfer(address _to, uint256 _value) public returns (bool) {
224         executeTransfer(msg.sender, _to, _value);
225 
226         return true;
227     }
228 
229     /**
230      * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.
231      *
232      * @param _from The address which approved you to spend tokens on their behalf.
233      * @param _to The address where you want to send tokens.
234      * @param _value The number of tokens to be sent.
235      *
236      * @return Whether the transfer was successful or not.
237      */
238     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
239         require(_value <= allowed[_from][msg.sender]);
240 
241         allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
242         executeTransfer(_from, _to, _value);
243 
244         return true;
245     }
246 
247     /**
248      * @dev Internal function that this reused by the transfer functions
249      */
250     function executeTransfer(address _from, address _to, uint256 _value) internal {
251         require(_to != address(0));
252         require(_value != 0 && _value <= balances[_from]);
253 
254         balances[_from] = balances[_from].minus(_value);
255         balances[_to] = balances[_to].plus(_value);
256 
257         emit Transfer(_from, _to, _value);
258     }
259 }
260 
261 
262 
263 
264 
265 
266 // File: contracts/token/MintableToken.sol
267 
268 /**
269  * @title Mintable Token
270  *
271  * @dev Allows the creation of new tokens.
272  */
273 contract MintableToken is StandardToken {
274     /// @dev The only address allowed to mint coins
275     address public minter;
276 
277     /// @dev Indicates whether the token is still mintable.
278     bool public mintingDisabled = false;
279 
280     /**
281      * @dev Event fired when minting is no longer allowed.
282      */
283     event MintingDisabled();
284 
285     /**
286      * @dev Allows a function to be executed only if minting is still allowed.
287      */
288     modifier canMint() {
289         require(!mintingDisabled);
290         _;
291     }
292 
293     /**
294      * @dev Allows a function to be called only by the minter
295      */
296     modifier onlyMinter() {
297         require(msg.sender == minter);
298         _;
299     }
300 
301     /**
302      * @dev The constructor assigns the minter which is allowed to mind and disable minting
303      */
304     constructor(address _minter) internal {
305         minter = _minter;
306     }
307 
308     /**
309     * @dev Creates new `_value` number of tokens and sends them to the `_to` address.
310     *
311     * @param _to The address which will receive the freshly minted tokens.
312     * @param _value The number of tokens that will be created.
313     */
314     function mint(address _to, uint256 _value) public onlyMinter canMint {
315         totalSupply = totalSupply.plus(_value);
316         balances[_to] = balances[_to].plus(_value);
317 
318         emit Transfer(0x0, _to, _value);
319     }
320 
321     /**
322     * @dev Disable the minting of new tokens. Cannot be reversed.
323     *
324     * @return Whether or not the process was successful.
325     */
326     function disableMinting() public onlyMinter canMint {
327         mintingDisabled = true;
328 
329         emit MintingDisabled();
330     }
331 }
332 
333 // File: contracts/token/BurnableToken.sol
334 
335 /**
336  * @title Burnable Token
337  *
338  * @dev Allows tokens to be destroyed.
339  */
340 contract BurnableToken is StandardToken {
341     /**
342      * @dev Event fired when tokens are burned.
343      *
344      * @param _from The address from which tokens will be removed.
345      * @param _value The number of tokens to be destroyed.
346      */
347     event Burn(address indexed _from, uint256 _value);
348 
349     /**
350      * @dev Burnes `_value` number of tokens.
351      *
352      * @param _value The number of tokens that will be burned.
353      */
354     function burn(uint256 _value) public {
355         require(_value != 0);
356 
357         address burner = msg.sender;
358         require(_value <= balances[burner]);
359 
360         balances[burner] = balances[burner].minus(_value);
361         totalSupply = totalSupply.minus(_value);
362 
363         emit Burn(burner, _value);
364         emit Transfer(burner, address(0), _value);
365     }
366 }
367 
368 // File: contracts/trait/HasOwner.sol
369 
370 /**
371  * @title HasOwner
372  *
373  * @dev Allows for exclusive access to certain functionality.
374  */
375 contract HasOwner {
376     // The current owner.
377     address public owner;
378 
379     // Conditionally the new owner.
380     address public newOwner;
381 
382     /**
383      * @dev The constructor.
384      *
385      * @param _owner The address of the owner.
386      */
387     constructor(address _owner) public {
388         owner = _owner;
389     }
390 
391     /**
392      * @dev Access control modifier that allows only the current owner to call the function.
393      */
394     modifier onlyOwner {
395         require(msg.sender == owner);
396         _;
397     }
398 
399     /**
400      * @dev The event is fired when the current owner is changed.
401      *
402      * @param _oldOwner The address of the previous owner.
403      * @param _newOwner The address of the new owner.
404      */
405     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
406 
407     /**
408      * @dev Transfering the ownership is a two-step process, as we prepare
409      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
410      * the transfer. This prevents accidental lock-out if something goes wrong
411      * when passing the `newOwner` address.
412      *
413      * @param _newOwner The address of the proposed new owner.
414      */
415     function transferOwnership(address _newOwner) public onlyOwner {
416         newOwner = _newOwner;
417     }
418 
419     /**
420      * @dev The `newOwner` finishes the ownership transfer process by accepting the
421      * ownership.
422      */
423     function acceptOwnership() public {
424         require(msg.sender == newOwner);
425 
426         emit OwnershipTransfer(owner, newOwner);
427 
428         owner = newOwner;
429     }
430 }
431 
432 // File: contracts/token/PausableToken.sol
433 
434 /**
435  * @title Pausable Token
436  *
437  * @dev Allows you to pause/unpause transfers of your token.
438  **/
439 contract PausableToken is StandardToken, HasOwner {
440 
441     /// Indicates whether the token contract is paused or not.
442     bool public paused = false;
443 
444     /**
445      * @dev Event fired when the token contracts gets paused.
446      */
447     event Pause();
448 
449     /**
450      * @dev Event fired when the token contracts gets unpaused.
451      */
452     event Unpause();
453 
454     /**
455      * @dev Allows a function to be called only when the token contract is not paused.
456      */
457     modifier whenNotPaused() {
458         require(!paused);
459         _;
460     }
461 
462     /**
463      * @dev Pauses the token contract.
464      */
465     function pause() public onlyOwner whenNotPaused {
466         paused = true;
467         emit Pause();
468     }
469 
470     /**
471      * @dev Unpauses the token contract.
472      */
473     function unpause() public onlyOwner {
474         require(paused);
475 
476         paused = false;
477         emit Unpause();
478     }
479 
480     /// Overrides of the standard token's functions to add the paused/unpaused functionality.
481 
482     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
483         return super.transfer(_to, _value);
484     }
485 
486     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
487         return super.approve(_spender, _value);
488     }
489 
490     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
491         return super.transferFrom(_from, _to, _value);
492     }
493 }
494 
495 
496 
497 
498 
499 
500 
501 
502 
503 // File: contracts/token/StandardMintableToken.sol
504 
505 contract StandardMintableToken is MintableToken {
506     constructor(address _minter, string _name, string _symbol, uint8 _decimals)
507         StandardToken(_name, _symbol, _decimals)
508         MintableToken(_minter)
509         public
510     {
511     }
512 }
513 
514 
515 
516 
517 
518 
519 
520 
521 
522 
523 
524 
525 /**
526  * @title CoinwareToken
527  */
528 
529 contract CoinwareToken is MintableToken, BurnableToken, PausableToken {
530     constructor(address _owner, address _minter)
531         StandardToken(
532             "CoinwareToken",   // Token name
533             "CWT", // Token symbol
534             18  // Token decimals
535         )
536         HasOwner(_owner)
537         MintableToken(_minter)
538         public
539     {
540     }
541 }