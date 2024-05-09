1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-28
3 */
4 
5 
6 pragma solidity 0.4.25;
7 pragma experimental "v0.5.0";
8 
9 
10 contract ERC20Token {
11 
12     string public name;
13     string public symbol;
14     uint8 public decimals;
15     uint public totalSupply;
16 
17     mapping(address => uint) public balanceOf;
18     mapping(address => mapping(address => uint)) public allowance;
19 
20     function approve(address spender, uint quantity) public returns (bool);
21     function transfer(address to, uint quantity) public returns (bool);
22     function transferFrom(address from, address to, uint quantity) public returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint quantity);
25     event Approval(address indexed owner, address indexed spender, uint quantity);
26 
27 }
28 
29 
30 contract Owned {
31     address public owner;
32     address public nominatedOwner;
33 
34     /**
35      * @dev Owned Constructor
36      * @param _owner The initial owner of the contract.
37      */
38     constructor(address _owner)
39         public
40     {
41         require(_owner != address(0), "Null owner address.");
42         owner = _owner;
43         emit OwnerChanged(address(0), _owner);
44     }
45 
46     /**
47      * @notice Nominate a new owner of this contract.
48      * @dev Only the current owner may nominate a new owner.
49      * @param _owner The new owner to be nominated.
50      */
51     function nominateNewOwner(address _owner)
52         public
53         onlyOwner
54     {
55         nominatedOwner = _owner;
56         emit OwnerNominated(_owner);
57     }
58 
59     /**
60      * @notice Accept the nomination to be owner.
61      */
62     function acceptOwnership()
63         external
64     {
65         require(msg.sender == nominatedOwner, "Not nominated.");
66         emit OwnerChanged(owner, nominatedOwner);
67         owner = nominatedOwner;
68         nominatedOwner = address(0);
69     }
70 
71     modifier onlyOwner
72     {
73         require(msg.sender == owner, "Not owner.");
74         _;
75     }
76 
77     event OwnerNominated(address newOwner);
78     event OwnerChanged(address oldOwner, address newOwner);
79 }
80 
81 
82 
83 
84 /**
85  * @title A pausable contract.
86  * @dev The inheriting contract must itself inherit from Owned, and initialise it.
87  */
88 contract Pausable is Owned {
89 
90     bool public paused;
91     
92     /**
93      * @dev Internal `pause()` with no owner-only constraint.
94      */
95     function _pause()
96         internal
97     {
98         if (!paused) {
99             paused = true;
100             emit Paused();
101         }
102     }
103 
104     /**
105      * @notice Pause operations of the contract.
106      * @dev Functions modified with `onlyUnpaused` will cease to operate,
107      *      while functions with `onlyPaused` will start operating.
108      *      If this is called while the contract is paused, nothing will happen. 
109      */
110     function pause() 
111         public
112         onlyOwner
113     {
114         _pause();
115     }
116 
117     /**
118      * @dev Internal `unpause()` with no owner-only constraint.
119      */
120     function _unpause()
121         internal
122     {
123         if (paused) {
124             paused = false;
125             emit Unpaused();
126         }
127     }
128 
129     /**
130      * @notice Unpause operations of the contract.
131      * @dev Functions modified with `onlyPaused` will cease to operate,
132      *      while functions with `onlyUnpaused` will start operating.
133      *      If this is called while the contract is unpaused, nothing will happen. 
134      */
135     function unpause()
136         public
137         onlyOwner
138     {
139         _unpause();
140     }
141 
142     modifier onlyPaused {
143         require(paused, "Contract must be paused.");
144         _;
145     }
146 
147     modifier pausable {
148         require(!paused, "Contract must not be paused.");
149         _;
150     }
151 
152     event Paused();
153     event Unpaused();
154 
155 }
156 
157 
158 
159 /**
160  * @title This contract can be destroyed by its owner after a delay elapses.
161  * @dev The inheriting contract must itself inherit from Owned, and initialise it.
162  */
163 contract SelfDestructible is Owned {
164 
165     uint public selfDestructInitiationTime;
166     bool public selfDestructInitiated;
167     address public selfDestructBeneficiary;
168     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
169 
170     /**
171      * @dev Constructor
172      * @param _beneficiary The account which will receive ether upon self-destruct.
173      */
174     constructor(address _beneficiary)
175         public
176     {
177         selfDestructBeneficiary = _beneficiary;
178         emit SelfDestructBeneficiaryUpdated(_beneficiary);
179     }
180 
181     /**
182      * @notice Set the beneficiary address of this contract.
183      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
184      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
185      */
186     function setSelfDestructBeneficiary(address _beneficiary)
187         external
188         onlyOwner
189     {
190         require(_beneficiary != address(0), "Beneficiary must not be the zero address.");
191         selfDestructBeneficiary = _beneficiary;
192         emit SelfDestructBeneficiaryUpdated(_beneficiary);
193     }
194 
195     /**
196      * @notice Begin the self-destruction counter of this contract.
197      * Once the delay has elapsed, the contract may be self-destructed.
198      * @dev Only the contract owner may call this, and only if self-destruct has not been initiated.
199      */
200     function initiateSelfDestruct()
201         external
202         onlyOwner
203     {
204         require(!selfDestructInitiated, "Self-destruct already initiated.");
205         selfDestructInitiationTime = now;
206         selfDestructInitiated = true;
207         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
208     }
209 
210     /**
211      * @notice Terminate and reset the self-destruction timer.
212      * @dev Only the contract owner may call this, and only during self-destruction.
213      */
214     function terminateSelfDestruct()
215         external
216         onlyOwner
217     {
218         require(selfDestructInitiated, "Self-destruct not yet initiated.");
219         selfDestructInitiationTime = 0;
220         selfDestructInitiated = false;
221         emit SelfDestructTerminated();
222     }
223 
224     /**
225      * @notice If the self-destruction delay has elapsed, destroy this contract and
226      * remit any ether it owns to the beneficiary address.
227      * @dev Only the contract owner may call this.
228      */
229     function selfDestruct()
230         external
231         onlyOwner
232     {
233         require(selfDestructInitiated, "Self-destruct not yet initiated.");
234         require(selfDestructInitiationTime + SELFDESTRUCT_DELAY < now, "Self-destruct delay has not yet elapsed.");
235         address beneficiary = selfDestructBeneficiary;
236         emit SelfDestructed(beneficiary);
237         selfdestruct(beneficiary);
238     }
239 
240     event SelfDestructTerminated();
241     event SelfDestructed(address beneficiary);
242     event SelfDestructInitiated(uint selfDestructDelay);
243     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
244 }
245 
246 
247 contract CROWN is ERC20Token, Owned, Pausable, SelfDestructible {
248 
249     /**
250      * @param _totalSupply The initial supply of tokens, which will be given to
251      *                     the initial owner of the contract. This quantity is
252      *                     a fixed-point integer with 18 decimal places (wei).
253      * @param _owner The initial owner of the contract, who must unpause the contract
254      *               before it can be used, but may use the `initBatchTransfer` to disburse
255      *               funds to initial token holders before unpausing it.
256      */
257     constructor(uint _totalSupply, address _owner)
258         Owned(_owner)
259         Pausable()
260         SelfDestructible(_owner)
261         public
262     {
263         _pause();
264         name = "CROWNFINANCE";
265         symbol = "CRWN";
266         decimals = 8;
267         totalSupply = _totalSupply;
268         balanceOf[this] = totalSupply;
269         emit Transfer(address(0), this, totalSupply);
270     }
271 
272 
273     modifier requireSameLength(uint a, uint b) {
274         require(a == b, "Input array lengths differ.");
275         _;
276     }
277 
278     /* Although we could have merged SelfDestructible and Pausable, this
279      * modifier keeps those contracts decoupled. */
280     modifier pausableIfNotSelfDestructing {
281         require(!paused || selfDestructInitiated, "Contract must not be paused.");
282         _;
283     }
284 
285     /**
286      * @dev Returns the difference of the given arguments. Will throw an exception iff `x < y`.
287      * @return `y` subtracted from `x`.
288      */
289     function safeSub(uint x, uint y)
290         pure
291         internal
292         returns (uint)
293     {
294         require(y <= x, "Safe sub failed.");
295         return x - y;
296     }
297 
298 
299     /**
300      * @notice Transfers `quantity` tokens from `from` to `to`.
301      * @dev Throws an exception if the balance owned by the `from` address is less than `quantity`, or if
302      *      the transfer is to the 0x0 address, in case it was the result of an omitted argument.
303      * @param from The spender.
304      * @param to The recipient.
305      * @param quantity The quantity to transfer, in wei.
306      * @return Always returns true if no exception was thrown.
307      */
308     function _transfer(address from, address to, uint quantity)
309         internal
310         returns (bool)
311     {
312         require(to != address(0), "Transfers to 0x0 disallowed.");
313         balanceOf[from] = safeSub(balanceOf[from], quantity); // safeSub handles insufficient balance.
314         balanceOf[to] += quantity;
315         emit Transfer(from, to, quantity);
316         return true;
317 
318         /* Since balances are only manipulated here, and the sum of all
319          * balances is preserved, no balance is greater than
320          * totalSupply; the safeSub implies that balanceOf[to] + quantity is
321          * no greater than totalSupply.
322          * Thus a safeAdd is unnecessary, since overflow is impossible. */
323     }
324 
325     /**
326       * @notice ERC20 transfer function; transfers `quantity` tokens from the message sender to `to`.
327       * @param to The recipient.
328       * @param quantity The quantity to transfer, in wei.
329       * @dev Exceptional conditions:
330       *          * The contract is paused if it is not self-destructing.
331       *          * The sender's balance is less than the transfer quantity.
332       *          * The `to` parameter is 0x0.
333       * @return Always returns true if no exception was thrown.
334       */
335     function transfer(address to, uint quantity)
336         public
337         pausableIfNotSelfDestructing
338         returns (bool)
339     {
340         return _transfer(msg.sender, to, quantity);
341     }
342 
343 
344     function approve(address spender, uint quantity)
345         public
346         pausableIfNotSelfDestructing
347         returns (bool)
348     {
349         require(spender != address(0), "Approvals for 0x0 disallowed.");
350         allowance[msg.sender][spender] = quantity;
351         emit Approval(msg.sender, spender, quantity);
352         return true;
353     }
354 
355     /**
356       * @notice ERC20 transferFrom function; transfers `quantity` tokens from
357       *         `from` to `to` if the sender is approved.
358       * @param from The spender; balance is deducted from this account.
359       * @param to The recipient.
360       * @param quantity The quantity to transfer, in wei.
361       * @dev Exceptional conditions:
362       *          * The contract is paused if it is not self-destructing.
363       *          * The `from` account has approved the sender to spend less than the transfer quantity.
364       *          * The `from` account's balance is less than the transfer quantity.
365       *          * The `to` parameter is 0x0.
366       * @return Always returns true if no exception was thrown.
367       */
368     function transferFrom(address from, address to, uint quantity)
369         public
370         pausableIfNotSelfDestructing
371         returns (bool)
372     {
373         // safeSub handles insufficient allowance.
374         allowance[from][msg.sender] = safeSub(allowance[from][msg.sender], quantity);
375         return _transfer(from, to, quantity);
376     }
377 
378 
379     /**
380       * @notice Performs ERC20 transfers in batches; for each `i`,
381       *         transfers `quantity[i]` tokens from the message sender to `to[i]`.
382       * @param recipients An array of recipients.
383       * @param quantities A corresponding array of transfer quantities, in wei.
384       * @dev Exceptional conditions:
385       *          * The `recipients` and `quantities` arrays differ in length.
386       *          * The sender's balance is less than the transfer quantity.
387       *          * Any recipient is 0x0.
388       * @return Always returns true if no exception was thrown.
389       */
390     function _batchTransfer(address sender, address[] recipients, uint[] quantities)
391         internal
392         requireSameLength(recipients.length, quantities.length)
393         returns (bool)
394     {
395         uint length = recipients.length;
396         for (uint i = 0; i < length; i++) {
397             _transfer(sender, recipients[i], quantities[i]);
398         }
399         return true;
400     }
401 
402     /**
403       * @notice Performs ERC20 transfers in batches; for each `i`,
404       *         transfers `quantities[i]` tokens from the message sender to `recipients[i]`.
405       * @param recipients An array of recipients.
406       * @param quantities A corresponding array of transfer quantities, in wei.
407       * @dev Exceptional conditions:
408       *          * The contract is paused if it is not self-destructing.
409       *          * The `recipients` and `quantities` arrays differ in length.
410       *          * The sender's balance is less than the transfer quantity.
411       *          * Any recipient is 0x0.
412       * @return Always returns true if no exception was thrown.
413       */
414     function batchTransfer(address[] recipients, uint[] quantities)
415         external
416         pausableIfNotSelfDestructing
417         returns (bool)
418     {
419         return _batchTransfer(msg.sender, recipients, quantities);
420     }
421 
422     /**
423       * @notice Performs ERC20 approvals in batches; for each `i`,
424       *         approves `quantities[i]` tokens to be spent by `spenders[i]`
425       *         on behalf of the message sender.
426       * @param spenders An array of spenders.
427       * @param quantities A corresponding array of approval quantities, in wei.
428       * @dev Exceptional conditions:
429       *          * The contract is paused if it is not self-destructing.
430       *          * The `spenders` and `quantities` arrays differ in length.
431       *          * Any spender is 0x0.
432       * @return Always returns true if no exception was thrown.
433       */
434     function batchApprove(address[] spenders, uint[] quantities)
435         external
436         pausableIfNotSelfDestructing
437         requireSameLength(spenders.length, quantities.length)
438         returns (bool)
439     {
440         uint length = spenders.length;
441         for (uint i = 0; i < length; i++) {
442             approve(spenders[i], quantities[i]);
443         }
444         return true;
445     }
446 
447     /**
448       * @notice Performs ERC20 transferFroms in batches; for each `i`,
449       *         transfers `quantities[i]` tokens from `spenders[i]` to `recipients[i]`
450       *         if the sender is approved.
451       * @param spenders An array of spenders.
452       * @param recipients An array of recipients.
453       * @param quantities A corresponding array of transfer quantities, in wei.
454       * @dev For the common use cases of transferring from many spenders to one recipient or vice versa,
455       *      the sole spender or recipient must be duplicated in the input array.
456       *      Exceptional conditions:
457       *          * The contract is paused if it is not self-destructing.
458       *          * Any of the `spenders`, `recipients`, or `quantities` arrays differ in length.
459       *          * Any spender account has approved the sender to spend less than the transfer quantity.
460       *          * Any spender account's balance is less than its corresponding transfer quantity.
461       *          * Any recipient is 0x0.
462       * @return Always returns true if no exception was thrown.
463       */
464     function batchTransferFrom(address[] spenders, address[] recipients, uint[] quantities)
465         external
466         pausableIfNotSelfDestructing
467         requireSameLength(spenders.length, recipients.length)
468         requireSameLength(recipients.length, quantities.length)
469         returns (bool)
470     {
471         uint length = spenders.length;
472         for (uint i = 0; i < length; i++) {
473             transferFrom(spenders[i], recipients[i], quantities[i]);
474         }
475         return true;
476     }
477 
478 
479 
480     function contractBatchTransfer(address[] recipients, uint[] quantities)
481         external
482         onlyOwner
483         returns (bool)
484     {
485         return _batchTransfer(this, recipients, quantities);
486     }
487 
488 }