1 pragma solidity ^0.4.24;
2 
3 /*
4  * Creator: BAC Team
5  */
6 
7 /*
8  * Abstract Token Smart Contract
9  *
10  */
11 
12 
13 /*
14 * Safe Math Smart Contract.
15 * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
16 */
17 
18 contract SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 
49 
50 /**
51  * ERC-20 standard token interface, as defined
52  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
53  */
54 contract Token {
55 
56     function totalSupply() constant returns (uint256 supply);
57 
58     function balanceOf(address _owner) constant returns (uint256 balance);
59 
60     function transfer(address _to, uint256 _value) returns (bool success);
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
63 
64     function approve(address _spender, uint256 _value) returns (bool success);
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 
73 
74 /**
75  * Abstract Token Smart Contract that could be used as a base contract for
76  * ERC-20 token contracts.
77  */
78 contract AbstractToken is Token, SafeMath {
79     /**
80      * Create new Abstract Token contract.
81      */
82     constructor() {
83         // Do nothing
84     }
85 
86     /**
87      * Get number of tokens currently belonging to given owner.
88      *
89      * @param _owner address to get number of tokens currently belonging to the
90      *        owner of
91      * @return number of tokens currently belonging to the owner of given address
92      */
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return accounts [_owner];
95     }
96 
97     /**
98      * Transfer given number of tokens from message sender to given recipient.
99      *
100      * @param _to address to transfer tokens to the owner of
101      * @param _value number of tokens to transfer to the owner of given address
102      * @return true if tokens were transferred successfully, false otherwise
103      * accounts [_to] + _value > accounts [_to] for overflow check
104      * which is already in safeMath
105      */
106     function transfer(address _to, uint256 _value) returns (bool success) {
107         require(_to != address(0));
108         if (accounts [msg.sender] < _value) return false;
109         if (_value > 0 && msg.sender != _to) {
110             accounts [msg.sender] = safeSub(accounts [msg.sender], _value);
111             accounts [_to] = safeAdd(accounts [_to], _value);
112         }
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Transfer given number of tokens from given owner to given recipient.
119      *
120      * @param _from address to transfer tokens from the owner of
121      * @param _to address to transfer tokens to the owner of
122      * @param _value number of tokens to transfer from given owner to given
123      *        recipient
124      * @return true if tokens were transferred successfully, false otherwise
125      * accounts [_to] + _value > accounts [_to] for overflow check
126      * which is already in safeMath
127      */
128     function transferFrom(address _from, address _to, uint256 _value)
129     returns (bool success) {
130         require(_to != address(0));
131         if (allowances [_from][msg.sender] < _value) return false;
132         if (accounts [_from] < _value) return false;
133 
134         if (_value > 0 && _from != _to) {
135             allowances [_from][msg.sender] = safeSub(allowances [_from][msg.sender], _value);
136             accounts [_from] = safeSub(accounts [_from], _value);
137             accounts [_to] = safeAdd(accounts [_to], _value);
138         }
139         emit Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     /**
144      * Allow given spender to transfer given number of tokens from message sender.
145      * @param _spender address to allow the owner of to transfer tokens from message sender
146      * @param _value number of tokens to allow to transfer
147      * @return true if token transfer was successfully approved, false otherwise
148      */
149     function approve(address _spender, uint256 _value) returns (bool success) {
150         allowances [msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     /**
156      * Tell how many tokens given spender is currently allowed to transfer from
157      * given owner.
158      *
159      * @param _owner address to get number of tokens allowed to be transferred
160      *        from the owner of
161      * @param _spender address to get number of tokens allowed to be transferred
162      *        by the owner of
163      * @return number of tokens given spender is currently allowed to transfer
164      *         from given owner
165      */
166     function allowance(address _owner, address _spender) constant
167     returns (uint256 remaining) {
168         return allowances [_owner][_spender];
169     }
170 
171     /**
172      * Mapping from addresses of token holders to the numbers of tokens belonging
173      * to these token holders.
174      */
175     mapping(address => uint256) accounts;
176 
177     /**
178      * Mapping from addresses of token holders to the mapping of addresses of
179      * spenders to the allowances set by these token holders to these spenders.
180      */
181     mapping(address => mapping(address => uint256)) private allowances;
182 
183 }
184 
185 
186 /**
187  * CoinBAC smart contract.
188  */
189 contract CoinBAC is AbstractToken {
190     /**
191      * Maximum allowed number of tokens in circulation.
192      * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
193      */
194 
195 
196     uint256 constant MAX_TOKEN_COUNT = 1000000000 * (10 ** 8);
197 
198     /**
199      * Address of the owner of this smart contract.
200      */
201     address private owner;
202 
203     /**
204      * Frozen account list holder
205      */
206     mapping(address => bool) private frozenAccount;
207 
208     /**
209      * Burning account list holder
210      */
211 
212     mapping(address => bool) private burningAccount;
213 
214 
215     /**
216      * Current number of tokens in circulation.
217      */
218     uint256 tokenCount = 0;
219 
220 
221     /**
222      * True if tokens transfers are currently frozen, false otherwise.
223      */
224     bool public frozen = false;
225 
226     /**
227      * Can owner burn tokens
228      */
229     bool public enabledBurning = true;
230 
231     /**
232      * Can owner create new tokens
233      */
234     bool public enabledCreateTokens = true;
235 
236     /**
237      * Can owner freeze any account
238      */
239     bool public enabledFreezeAccounts = true;
240 
241     /**
242      * Can owner freeze transfers
243      */
244     bool public enabledFreezeTransfers = true;
245 
246     /**
247     * Address of new token if token was migrated.
248     */
249     address public migratedToAddress;
250 
251 
252     /**
253      * Create new token smart contract and make msg.sender the
254      * owner of this smart contract.
255      */
256     constructor() {
257         owner = msg.sender;
258     }
259 
260     /**
261      * Get total number of tokens in circulation.
262      *
263      * @return total number of tokens in circulation
264      */
265     function totalSupply() constant returns (uint256 supply) {
266         return tokenCount;
267     }
268 
269     string constant public name = "Coin BAC";
270     string constant public symbol = "BAC";
271     uint8 constant public decimals = 8;
272 
273     /**
274      * Transfer given number of tokens from message sender to given recipient.
275      * @param _to address to transfer tokens to the owner of
276      * @param _value number of tokens to transfer to the owner of given address
277      * @return true if tokens were transferred successfully, false otherwise
278      */
279     function transfer(address _to, uint256 _value) returns (bool success) {
280         require(!frozenAccount[msg.sender]);
281         if (frozen) return false;
282         else return AbstractToken.transfer(_to, _value);
283     }
284 
285     /**
286      * Transfer given number of tokens from given owner to given recipient.
287      *
288      * @param _from address to transfer tokens from the owner of
289      * @param _to address to transfer tokens to the owner of
290      * @param _value number of tokens to transfer from given owner to given
291      *        recipient
292      * @return true if tokens were transferred successfully, false otherwise
293      */
294     function transferFrom(address _from, address _to, uint256 _value)
295     returns (bool success) {
296         require(!frozenAccount[_from]);
297         if (frozen) return false;
298         else return AbstractToken.transferFrom(_from, _to, _value);
299     }
300 
301     /**
302     * Change how many tokens given spender is allowed to transfer from message
303     * spender.  In order to prevent double spending of allowance,
304     * To change the approve amount you first have to reduce the addresses`
305     * allowance to zero by calling `approve(_spender, 0)` if it is not
306     * already 0 to mitigate the race condition described here:
307     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308     * @param _spender address to allow the owner of to transfer tokens from
309     *        message sender
310     * @param _value number of tokens to allow to transfer
311     * @return true if token transfer was successfully approved, false otherwise
312     */
313     function approve(address _spender, uint256 _value)
314     returns (bool success) {
315         require(allowance(msg.sender, _spender) == 0 || _value == 0);
316         return AbstractToken.approve(_spender, _value);
317     }
318 
319     /**
320      * Create _value new tokens and give new created tokens to msg.sender.
321      * Only be called by smart contract owner.
322      *
323      * @param _value number of tokens to create
324      * @return true if tokens were created successfully, false otherwise
325      */
326     function createTokens(uint256 _value)
327     returns (bool success) {
328         require(msg.sender == owner);
329         require(enabledCreateTokens);
330 
331         if (_value > 0) {
332             if (_value > safeSub(MAX_TOKEN_COUNT, tokenCount)) return false;
333 
334             accounts[msg.sender] = safeAdd(accounts[msg.sender], _value);
335             tokenCount = safeAdd(tokenCount, _value);
336 
337             // adding transfer event and _from address as null address
338             emit Transfer(0x0, msg.sender, _value);
339 
340             return true;
341         }
342 
343         return false;
344 
345     }
346 
347 
348     /**
349       * Burning capable account
350       * Only be called by smart contract owner.
351       */
352     function burningCapableAccount(address[] _target) {
353         require(msg.sender == owner);
354         require(enabledBurning);
355 
356         for (uint i = 0; i < _target.length; i++) {
357             burningAccount[_target[i]] = true;
358         }
359     }
360 
361     /**
362      * Burn intended tokens.
363      * Only be called by by burnable addresses.
364      *
365      * @param _value number of tokens to burn
366      * @return true if burnt successfully, false otherwise
367      */
368 
369     function burn(uint256 _value) public returns (bool success) {
370         require(accounts[msg.sender] >= _value);
371         require(burningAccount[msg.sender]);
372         require(enabledBurning);
373 
374         accounts[msg.sender] = safeSub(accounts[msg.sender], _value);
375 
376         tokenCount = safeSub(tokenCount, _value);
377 
378         emit Burn(msg.sender, _value);
379 
380         return true;
381     }
382 
383 
384     /**
385      * Set new owner for the smart contract.
386      * Only be called by smart contract owner.
387      *
388      * @param _newOwner address of new owner of the smart contract
389      */
390     function setOwner(address _newOwner) {
391         require(msg.sender == owner);
392 
393         owner = _newOwner;
394     }
395 
396     /**
397      * Freeze ALL token transfers.
398      * Only be called by smart contract owner.
399      */
400     function freezeTransfers() {
401         require(msg.sender == owner);
402         require(enabledFreezeTransfers);
403 
404         if (!frozen) {
405             frozen = true;
406             emit Freeze();
407         }
408     }
409 
410     /**
411      * Unfreeze ALL token transfers.
412      * Only be called by smart contract owner.
413      */
414     function unfreezeTransfers() {
415         require(msg.sender == owner);
416         require(migratedToAddress == address(0x0));
417 
418         if (frozen) {
419             frozen = false;
420             emit Unfreeze();
421         }
422     }
423 
424     /*A user is able to unintentionally send tokens to a contract
425     * and if the contract is not prepared to refund them they will get stuck in the contract.
426     * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
427     * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
428     * so the below function is created
429     */
430 
431     function refundTokens(address _token, address _refund, uint256 _value) {
432         require(msg.sender == owner);
433         require(_token != address(this));
434         AbstractToken token = AbstractToken(_token);
435         token.transfer(_refund, _value);
436         emit RefundTokens(_token, _refund, _value);
437     }
438 
439     /**
440      * Freeze specific account.
441      * Only be called by smart contract owner.
442      */
443     function freezeAccount(address _target, bool freeze) {
444         require(msg.sender == owner);
445         require(msg.sender != _target);
446         require(enabledFreezeAccounts);
447         frozenAccount[_target] = freeze;
448         emit FrozenFunds(_target, freeze);
449     }
450 
451     /**
452      * Disable burning tokens feature forever.
453      * Only be called by smart contract owner.
454      */
455     function disableBurning() {
456         require(msg.sender == owner);
457         if (enabledBurning) {
458             enabledBurning = false;
459             emit DisabledBurning();
460         }
461     }
462 
463     /**
464      * Disable create tokens feature forever.
465      * Only be called by smart contract owner.
466      */
467     function disableCreateTokens() {
468         require(msg.sender == owner);
469         if (enabledCreateTokens) {
470             enabledCreateTokens = false;
471             emit DisabledCreateTokens();
472         }
473     }
474 
475     /**
476      * Disable freeze accounts feature forever.
477      * Only be called by smart contract owner.
478      */
479     function disableFreezeAccounts() {
480         require(msg.sender == owner);
481         if (enabledFreezeAccounts) {
482             enabledFreezeAccounts = false;
483             emit DisabledFreezeAccounts();
484         }
485     }
486 
487     /**
488      * Disable freeze transfers feature forever.
489      * Only be called by smart contract owner.
490      */
491     function disableFreezeTransfers() {
492         require(msg.sender == owner);
493         if (enabledFreezeTransfers) {
494             enabledFreezeTransfers = false;
495             emit DisabledFreezeTransfers();
496         }
497     }
498 
499     /**
500     * Mark this contract as migrated to the new one.
501     * It also freezes transafers.
502     */
503     function migrateTo(address token) {
504         require(msg.sender == owner);
505         require(migratedToAddress == address(0x0));
506         require(token != address(0x0));
507         
508         migratedToAddress = token;
509         frozen = true;
510     }
511 
512     /**
513      * Logged when token transfers were frozen.
514      */
515     event Freeze ();
516 
517     /**
518      * Logged when token transfers were unfrozen.
519      */
520     event Unfreeze ();
521 
522     /**
523      * Logged when a particular account is frozen.
524      */
525 
526     event FrozenFunds(address target, bool frozen);
527 
528     /**
529      * Logged when a token is burnt.
530      */
531 
532     event Burn(address target, uint256 _value);
533 
534     /**
535      * Logged once when burning feature was disabled.
536      */
537     event DisabledBurning ();
538 
539     /**
540      * Logged once when create tokens feature was disabled.
541      */
542     event DisabledCreateTokens ();
543 
544     /**
545      * Logged once when freeze accounts feature was disabled.
546      */
547     event DisabledFreezeAccounts ();
548 
549     /**
550      * Logged once when freeze transfers feature was disabled.
551      */
552     event DisabledFreezeTransfers ();
553 
554     /**
555      * when accidentally send other tokens are refunded
556      */
557     event RefundTokens(address _token, address _refund, uint256 _value);
558 }