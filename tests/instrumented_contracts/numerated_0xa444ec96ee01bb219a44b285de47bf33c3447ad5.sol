1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 contract ERC20 {
6     
7     //stores current balances
8     mapping(address => uint256) private _balances;
9     //stores current approvals
10     mapping(address => mapping(address => uint256)) private _allowances;
11     //current total supply of token
12     uint256 private _totalSupply;
13     //current token metadata:
14     string private _name;
15     string private _symbol;
16     uint8 private _decimals;
17     //the owner address of this contract, i.e. who can mint more tokens
18     address private _owner;
19     // For each account, a mapping of its account operators.
20     mapping(address => mapping(address => bool)) private _accountOperators;
21     // The absolute maximum supply that can be reached by minting. 
22     uint256 private _maximumSupply;
23     // Allow remint of tokens which have been burned.
24     bool private _allowRemint;
25     // Stores the accumulated burned total
26     uint256 private _burnAccumulatedTotal;
27         
28     /**
29      * @dev Emitted when `amount` tokens are moved from one account (`payerId`) to another (`payeeId`).
30      *
31      * Note that `amount` may be zero.
32      */
33     event Transfer(address indexed payerId, address indexed payeeId, uint256 amount);
34 
35     /**
36      * @dev Emitted when the allowance of a `payeeId` for an `payerId` is set by
37      * a call to {approve}. `amount` is the new allowance.
38      */
39     event Approval(address indexed payerId, address indexed payeeId, uint256 amount);
40 
41     /**
42      * @dev Emitted when tokens are minted or burned.
43      */
44     event MetaData(string indexed functionName, bytes data);
45 
46     /**
47      * @dev Emitted when contract owner is changed from `oldContractOwnerId` to `newContractOwnerId`.
48      */
49     event OwnerChanged(address indexed oldContractOwnerId, address indexed newContractOwnerId);
50 
51     /**
52      * @dev Emitted when `additionalOwnerAccountId` is authorised by `ownerAccountId`.
53      */
54     event AuthorizedOperator(address indexed additionalOwnerAccountId, address indexed ownerAccountId);
55 
56     /**
57      * @dev Emitted when `additionalOwnerAccountId` is revoked by `ownerAccountId`.
58      */
59     event RevokedOperator(address indexed additionalOwnerAccountId, address indexed ownerAccountId);
60 
61     /**
62      * @dev Emitted when the batched transactions failed for address `failedAddress` for function `functionName`.
63      */
64     event BatchFailure(string indexed functionName, address indexed failedAddress);
65 
66     /**
67      * @dev Sets the values for {_name}, {_symbol}, {_decimals}, {_totalSupply}.
68      * Additionally, all of the supply is initially given to the address corresponding to {giveSupplyTo_}
69      */
70     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 supply_, address giveSupplyTo_, address owner_, uint256 maximumSupply_, bool allowRemint_) {
71         require(supply_<=maximumSupply_, "Current supply must be less than or equal to max supply");
72         _name = name_;
73         _symbol = symbol_;
74         _decimals = decimals_;
75         _totalSupply = supply_;
76         _balances[giveSupplyTo_] = supply_;
77         _owner = owner_;
78         _maximumSupply = maximumSupply_;
79         _allowRemint = allowRemint_;
80 
81         emit Transfer(address(0), giveSupplyTo_, supply_);
82     }
83 
84     /**
85      * @dev Functions using this modifier restrict the caller to only be the contract owner address (or the account operator of the owner)
86      */
87    modifier onlyOwner {
88         require(isOperatorFor(msg.sender, owner()), "Caller is not the account's operator");
89       _;
90    }
91 
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `payeeId`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      *
99      * Requirements
100      *
101      * -  the caller must have at least `amount` tokens.
102      * - `payeeId` cannot be the zero address.
103      */
104     function transfer(address payeeId, uint256 amount) external returns (bool) {
105         _transfer(msg.sender, payeeId, amount);
106         return true;
107     }
108 
109     /**
110      * @dev Moves `amount` tokens from `payerId` to `payeeId`. The caller must
111      * be an account operator of `payerId`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      *
117      * Requirements
118      *
119      * - `payerId` cannot be the zero address.
120      * - `payerId` must have at least `amount` tokens.
121      * -  the caller must be an account operator for `payerId`.
122      * - `payeeId` cannot be the zero address.
123      */
124     function operatorTransfer(
125         address payerId,
126         address payeeId,
127         uint256 amount
128     ) external returns (bool) {
129         require(isOperatorFor(msg.sender, payerId), "Caller not an operator for payerId");
130         _transfer(payerId, payeeId, amount);
131         return true;
132     }
133 
134     /**
135      * @dev Sets `amount` as the allowance of `payeeId` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits an {Approval} event.
140      *
141      * The if statement makes sure that this contract's approval system is not 
142      * vulnerable to teh race condition (where a payee spends the previous
143      * and new allowance)
144      *
145      * Requirements
146      *
147      * - the caller must have at least `amount` tokens.
148      * - `payeeId` cannot be the zero address.
149      */
150     function approve(address payeeId, uint256 amount) external returns (bool) {
151         if (_allowances[msg.sender][payeeId] > 0){
152             require(amount == 0, "Must set approval to zero before setting new approval"); //otherwise approve call would be vulnerable to race condition. Need to set approval to zero first             
153         }
154         _approve(msg.sender, payeeId, amount);
155         return true;
156     }
157 
158     /**
159      * @dev Approves `amount` tokens from `payerId` to `payeeId`. The caller must
160      * be an account operator of `payerId`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * The if statement makes sure that this contract's approval system is not 
165      * vulnerable to the race condition (where a payee spends the previous
166      * and new allowance)
167      *
168      * Emits a {Approval} event.
169      *
170      * Requirements
171      *
172      * - `payerId` cannot be the zero address.
173      * - `payerId` must have at least `amount` tokens.
174      * - the caller must be an account operator for `payerId`.
175      * - `payeeId` cannot be the zero address.
176      */
177     function operatorApprove(
178         address payerId,
179         address payeeId,
180         uint256 amount
181     ) external returns (bool) {
182         require(isOperatorFor(msg.sender, payerId), "Caller is not an account operator for payerId");
183         if (_allowances[payerId][payeeId] > 0){
184             require(amount == 0, "Must cancel previous approval"); //otherwise approve call would be vulnerable to race condition. Need to set approval to zero first     
185         }
186         _approve(payerId, payeeId, amount);
187         return true;
188     }
189 
190     /**
191      * @dev Moves `amount` tokens from `payerId` to `payeeId` using the
192      * allowance mechanism. `amount` is then deducted from the caller's
193      * allowance.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a {Transfer} event.
198      *
199      * Requirements
200      *
201      * - `payerId` cannot be the zero address.
202      * - the caller must have at least `amount` tokens approved tokens from `payeeId`.
203      * - `payeeId` cannot be the zero address.
204      */
205     function transferFrom(address payerId, address payeeId, uint256 amount) external returns (bool) {
206         _spendAllowance(payerId, msg.sender, amount);  // Decrease the msg.sender's approved spend amount
207         _transfer(payerId, payeeId, amount);    // Transfer funds from the payerId to the payeeId as specified by the approved msg.sender
208         return true;
209     }
210 
211     /**
212      * @dev Moves `amount` tokens from `payerId` to `payeeId` using the
213      * allowance mechanism. `amount` is then deducted from the 'payerId'
214      * allowance.
215      *
216      * Emits a {Transfer} event.
217      *
218      * Requirements
219      *
220      * - `payerId` cannot be the zero address.
221      * - `payeeId` must have at least `amount` approved tokens from `payeeId`.
222      * -  the caller must be an account operator for `payeeId`.
223      * - `payeeId` cannot be the zero address.
224      */
225     function operatorTransferFrom(
226         address payerId,
227         address payeeId,
228         uint256 amount
229     ) external {
230         require(isOperatorFor(msg.sender, payeeId), "Caller not an operator for payeeId");
231         _spendAllowance(payerId, payeeId, amount);
232         _transfer(payerId, payeeId, amount);
233     }
234 
235 
236     /** @dev Creates `amount` tokens and assigns them to `beneficiaryAccountId`, increasing
237      * the total supply. Metadata can be assigned to this mint via the 'message' 
238      * parameter if required.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event with `from` set to the zero address.
243      * Emits a {MetaData} event.
244      *
245      * Requirements:
246      *
247      * - `beneficiaryAccountId` cannot be the zero address.
248      * - `msg.sender` must be the contract's owner address.
249      */
250     function mint(address beneficiaryAccountId, uint256 amount, bytes calldata data) external onlyOwner() returns (bool) {
251         require(beneficiaryAccountId != address(0), "Zero address used");
252         require((_allowRemint && _maximumSupply >= (_totalSupply + amount)) ||
253                 (!_allowRemint && (_maximumSupply >= (_totalSupply + amount + _burnAccumulatedTotal))) , "Minting would exceed the configured maximum supply.");
254 
255         _totalSupply += amount;
256         _balances[beneficiaryAccountId] += amount;
257         
258         emit Transfer(address(0), beneficiaryAccountId, amount);
259         emit MetaData("mint", data);
260 
261         return true;
262     }
263 
264     /**
265      * @dev Destroys `amount` tokens from the sender's address, reducing the
266      * total supply. Metadata can be assigned to this burn via the 'data' 
267      * parameter if required.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event with `to` set to the zero address.
272      * Emits a {MetaData} event.
273      *
274      * Requirements:
275      *
276      * - the caller's account must have at least `amount` tokens.
277      */
278     function burn(uint256 amount, bytes calldata data) external returns (bool) {
279         _burn(msg.sender, amount, data);
280         return true;
281     }
282 
283     /**
284      * @dev Destroys `amount` tokens from `payerId`, reducing the total supply.
285      * Metadata can be assigned to this burn via the 'data' parameter if required.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event with `to` set to the zero address.
290      * Emits a {MetaData} event.
291      *
292      * Requirements
293      *
294      * - `payerId` cannot be the zero address.
295      * - `payerId` must have at least `amount` tokens.
296      * - the caller must be an account operator for `payerId`.
297      */
298     function operatorBurn(address payerId, uint256 amount, bytes calldata data) external returns (bool) {
299         require(isOperatorFor(msg.sender, payerId), "Caller not an operator for payerId");
300         _burn(payerId, amount, data);
301         return true;
302     }
303 
304     /**
305      * @dev Changes the contract owner to 'newContractOwnerId', i.e. who can mint new tokens
306      *
307      * Returns a boolean value indicating whether the operation succeeded.
308      *
309      * Requirements:
310      *
311      * - caller must have the owner role.
312      */
313     function changeOwner(address newContractOwnerId) external onlyOwner() returns (bool) {
314         require(newContractOwnerId != address(0x0), "Zero address used");
315         address oldOwner = _owner;
316         _owner = newContractOwnerId;
317         emit OwnerChanged(oldOwner, newContractOwnerId);
318         return true;
319     }
320 
321 
322     /**
323      * @dev Make `AdditionalOwnerAccountId` an account operator of caller.
324      *
325      * Emits an {AuthorizedOperator} event.
326      *
327      * Requirements:
328      *
329      * - `AdditionalOwnerAccountId` must not equal the caller.
330      */
331     function authorizeOperator(address additionalOwnerAccountId) external {
332         require(msg.sender != additionalOwnerAccountId, "Authorizing self as operator");
333 
334         _accountOperators[msg.sender][additionalOwnerAccountId] = true;
335 
336         emit AuthorizedOperator(additionalOwnerAccountId, msg.sender);
337     }
338 
339     /**
340      * @dev Revoke `additionalOwnerAccountId`'s account operator status for caller.
341      *
342      * Emits a {RevokedOperator} event.
343      *
344      * Requirements:
345      *
346      * - `additionalOwnerAccountId` must not equal the caller.
347      */
348     function revokeOperator(address additionalOwnerAccountId) external {
349 
350         delete _accountOperators[msg.sender][additionalOwnerAccountId];
351 
352         emit RevokedOperator(additionalOwnerAccountId, msg.sender);
353     }
354 
355 
356     /**
357      * @dev Same logic as calling the transfer function multiple times.
358      * where payeeIds[x] receives amounts[x] tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      * If the operation failed, the payeeId causing the first failure will be returned;
362      *
363      * Emits a {Transfer} event for every transfer.
364      *
365      * Requirements:
366      *
367      * - `payerId` cannot be the zero address.
368      * - `payerId` must have a balance of at least the total of the `amounts` array.
369      * -  the caller must be `payerId` or an account operator for `payerId`.
370      * -  Each `payeeIds[x]` cannot be the zero address.
371      */
372     function transferBatch(address payerId, address[] calldata payeeIds, uint256[] calldata amounts) external returns (bool, address) {
373         require(isOperatorFor(msg.sender, payerId), "Caller not an operator for payerId");
374         uint count;
375         uint size = payeeIds.length;
376         while (count < size){
377             if (balanceOf(payerId) < amounts[count]){
378                 emit BatchFailure("transfer", payeeIds[count]); //alerts the listener to the address that failed the batch
379                 return (false, payeeIds[count]);
380             }
381             _transfer(payerId, payeeIds[count], amounts[count]);
382             count++;
383         }
384         return (true, address(0x0));
385     }
386 
387 
388     /**
389      * @dev Same logic as calling the transferFrom function multiple times.
390      * where payeeId attempts to debit amounts[X] tokens from payerIds[X].
391      * If a particular debit did is not possible (as the allowance is not high enough
392      * for this particular payerIds[X]), the batch continues. 
393      *
394      * Returns firstly a boolean value indicating whether the batch transfer succeeded for every given payerId (true)
395      * or if the batch transfer failed for some payerIds (false). If false, then the payerIds that could not
396      * perform the transfer are also returned;
397      *
398      * Emits a {Transfer} event for every transfer
399      *
400      * Requirements
401      *
402      * -  Each `payerIds[x]` cannot be the zero address.
403      * - `payeeId` must have at least `amount[x]` approved tokens from each `payerIds[x]`.
404      * -  the caller must be `payeeId` or an account operator for `payeeId`.
405      * -  `payeeId` cannot be the zero address.
406      */
407     function transferFromBatch(address payeeId, address[] calldata payerIds, uint256[] calldata amounts) external returns (bool) {
408         require(isOperatorFor(msg.sender, payeeId), "Caller not an operator for payeeId");
409         require(payerIds.length == amounts.length, "Length of 'payerIds' and 'amounts' arrays are not equal");
410 
411         uint count;
412         uint size = payerIds.length;
413         bool success = true;
414 
415         while (count < size){
416             //
417             if ((balanceOf(payerIds[count]) < amounts[count]) || (amounts[count] > allowance(payerIds[count], payeeId))){
418                 success = false;
419                 emit BatchFailure("transferFrom", payerIds[count]);
420             } else {
421                 //only perform the transfer from if it will succeed
422                 _spendAllowance(payerIds[count], payeeId, amounts[count]);  // Decrease the payeeId's approved spend amount
423                 _transfer(payerIds[count], payeeId, amounts[count]);    // Transfer funds from the payerId to the payeeId as specified by the approved msg.sender
424             }
425             count++;
426         }
427         return success;
428     }
429 
430 
431     /**
432      * @dev Moves `amount` of tokens from `payerId` to `payeeId`.
433      *
434      * This internal function is equivalent to {transfer}
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `payerId` cannot be the zero address.
441      * - `payeeId` cannot be the zero address.
442      * - `payerId` must have a balance of at least `amount`.
443      */
444     function _transfer(address payerId, address payeeId, uint256 amount) private {
445         require(payerId != address(0), "Zero address used");
446         require(payeeId != address(0), "Zero address used");
447         require(payeeId != address(this), "Contract address used");
448 
449         uint256 senderBalance = _balances[payerId];
450         require(senderBalance >= amount, "Amount exceeds balance");
451         unchecked {
452             _balances[payerId] = senderBalance - amount;
453         }
454         _balances[payeeId] += amount;
455 
456         emit Transfer(payerId, payeeId, amount);
457 
458     }
459 
460     /**
461      * @dev Burns (deletes) `amount` of tokens from `payerId`, with optional metadata `data`.
462      *
463      * Emits a {Transfer} event.
464      * Emits a {MetaData} event.
465      *
466      * Requirements:
467      *
468      * - `payerId` cannot be the zero address.
469      * - `payerId` must have a balance of at least `amount`.
470      */
471     function _burn(address payerId, uint256 amount, bytes calldata data) private {
472 
473         require(payerId != address(0), "Zero address used");
474 
475         uint256 accountBalance = _balances[payerId];
476         require(accountBalance >= amount, "Amount exceeds balance");
477         unchecked {
478             _balances[payerId] = accountBalance - amount;
479         }
480         _totalSupply -= amount;        
481         _burnAccumulatedTotal += amount;
482 
483         emit Transfer(payerId, address(0), amount);
484         emit MetaData("burn", data);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `payeeId` over the `payerId` s tokens.
489      *
490      * This internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an {Approval} event.
494      *
495      * Requirements:
496      *
497      * - `payerId` cannot be the zero address.
498      * - `payeeId` cannot be the zero address.
499      */
500     function _approve(address payerId, address payeeId, uint256 amount) private {
501         require(payerId != address(0), "Zero address used");
502         require(payeeId != address(0), "Zero address used");
503 
504         _allowances[payerId][payeeId] = amount;
505         emit Approval(payerId, payeeId, amount);
506     }
507 
508     /**
509      * @dev Reduces the allowance `amount` of tokens approved by the `payerId` to the spender
510      * In the case of max approval the allowance will not reduce unless the user sets the approval directly
511      */
512     function _spendAllowance(address payerId, address spender, uint256 amount) private {
513         uint256 currentAllowance = allowance(payerId, spender);
514         if (currentAllowance != type(uint256).max) {
515             require(currentAllowance >= amount, "Amount exceeds allowance");
516             unchecked {
517                 _approve(payerId, spender, currentAllowance - amount);
518             }
519         }
520     }
521 
522     /**
523      * @dev Returns the name of the token.
524      */
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev Returns the symbol of the token, usually a shorter version of the
531      * name.
532      */
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     /**
538      * @dev Returns the number of decimals used to get its user representation.
539      * For example, if `decimals` equals `2`, a balance of `505` tokens should
540      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
541      *
542      * Tokens usually opt for a value of 18, imitating the relationship between
543      * Ether and Wei.
544      *
545      * NOTE: This information is only used for display purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * {balanceOf} and {transfer}.
548      */
549     function decimals() public view returns (uint8) {
550         return _decimals;
551     }
552 
553      /**
554      * @dev Returns the amount of tokens in existence.
555      *
556      * This value changes when {mint} and {burn} are called.
557      */
558     function totalSupply() public view returns (uint256) {
559         return _totalSupply;
560     }
561 
562     /**
563      * @dev Returns the address with the owner role of this token contract, 
564      * i.e. what address can mint new tokens.
565      * if a multi-sig account operator is required, this address should 
566      * point to a smart contract implementing this multi-sig.
567      */
568     function owner() public view returns (address) {
569         return _owner;
570     }
571 
572     /**
573      * @dev Returns the amount of tokens owned by `accountId`.
574      *
575      * This value changes when {transfer} and {transferFrom} are called.
576      */
577     function balanceOf(address accountId) public view returns (uint256) {
578         return _balances[accountId];
579     }
580 
581     /**
582      *
583      * Returns the maximum supply that can be reached by minting new tokens. A maximumSupply of zero means the supply is unlimited. 
584      *
585     */
586     function maximumSupply() public view returns(uint256) {
587         return _maximumSupply;
588     }
589 
590     /**
591      *
592      * Returns the running total of the number of tokens burned
593      *
594     */
595     function burnAccumulatedTotal() public view returns(uint256) {
596         return _burnAccumulatedTotal;
597     }
598 
599     /**
600      * @dev Returns the remaining number of tokens that `payeeId` will be
601      * allowed to spend on behalf of `payerId` through {transferFrom}. This is
602      * zero by default.
603      *
604      * This value changes when {approve} or {transferFrom} are called.
605      */
606     function allowance(address payerId, address payeeId) public view returns (uint256) {
607         return _allowances[payerId][payeeId];
608     }
609 
610     /**
611      * @dev Returns true if `AdditionalOwnerAccountId` is an account operator of `OwnerAccountId`.
612      * Account operators can send and burn tokens for an authorised account. All
613      * accounts are their own account operator.
614      */
615     function isOperatorFor(address AdditionalOwnerAccountId, address OwnerAccountId) public view returns (bool) {
616         return
617             AdditionalOwnerAccountId == OwnerAccountId ||
618             _accountOperators[OwnerAccountId][AdditionalOwnerAccountId];
619     }
620 
621 
622 }