1 pragma solidity ^0.4.15;
2 
3 /* @dev ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
4 */
5 contract ERC20 {
6     //Use original ERC20 totalSupply function instead of public variable since
7     //we are mapping the functions for upgradeability
8     uint256 public totalSupply;
9     function balanceOf(address _owner) public constant returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 // Licensed under the MIT License
18 // Copyright (c) 2017 Curvegrid Inc.
19 
20 
21 /// @title OfflineSecret
22 /// @dev The OfflineSecret contract provide functionality to verify and ensure a caller
23 /// provides a valid secret that was exchanged offline. It offers an additional level of verification
24 /// for sensitive contract operations.
25 contract OfflineSecret {
26 
27     /// @dev Modifier that requires a provided plaintext match a previously stored hash
28     modifier validSecret(address to, string secret, bytes32 hashed) {
29         require(checkSecret(to, secret, hashed));
30         _;
31     }
32 
33     /// @dev Generate a hash from the provided plaintext. A pure function so can (should) be
34     /// run off-chain.
35     /// @param to address The recipient address, as a salt.
36     /// @param secret string The secret to hash.
37     function generateHash(address to, string secret) public pure returns(bytes32 hashed) {
38         return keccak256(to, secret);
39     }
40 
41     /// @dev Check whether a provided plaintext secret hashes to a provided hash. A pure 
42     /// function so can (should) be run off-chain.
43     /// @param to address The recipient address, as a salt.
44     /// @param secret string The secret to hash.
45     /// @param hashed string The hash to check the secret against.
46     function checkSecret(address to, string secret, bytes32 hashed) public pure returns(bool valid) {
47         if (hashed == keccak256(to, secret)) {
48             return true;
49         }
50 
51         return false;
52     }
53 }
54 // Licensed under the MIT License
55 // Copyright (c) 2017 Curvegrid Inc.
56 
57 
58 
59 /// @title Ownable
60 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
61 /// and the implementation of "user permissions".
62 contract OwnableWithFoundation is OfflineSecret {
63     address public owner;
64     address public newOwnerCandidate;
65     address public foundation;
66     address public newFoundationCandidate;
67 
68     bytes32 public ownerHashed;
69     bytes32 public foundationHashed;
70 
71     event OwnershipRequested(address indexed by, address indexed to, bytes32 hashed);
72     event OwnershipTransferred(address indexed from, address indexed to);
73     event FoundationRequested(address indexed by, address indexed to, bytes32 hashed);
74     event FoundationTransferred(address indexed from, address indexed to);
75 
76     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender
77     /// account.
78     function OwnableWithFoundation(address _owner) public {
79         foundation = msg.sender;
80         owner = _owner;
81     }
82 
83     /// @dev Reverts if called by any account other than the owner.
84     modifier onlyOwner() {
85         if (msg.sender != owner) {
86             revert();
87         }
88 
89         _;
90     }
91 
92     modifier onlyOwnerCandidate() {
93         if (msg.sender != newOwnerCandidate) {
94             revert();
95         }
96 
97         _;
98     }
99 
100     /// @dev Reverts if called by any account other than the foundation.
101     modifier onlyFoundation() {
102         if (msg.sender != foundation) {
103             revert();
104         }
105 
106         _;
107     }
108 
109     modifier onlyFoundationCandidate() {
110         if (msg.sender != newFoundationCandidate) {
111             revert();
112         }
113 
114         _;
115     }
116 
117     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
118     /// @param _newOwnerCandidate address The address to transfer ownership to.
119     /// @param _ownerHashed string The hashed secret to use as protection.
120     function requestOwnershipTransfer(
121         address _newOwnerCandidate, 
122         bytes32 _ownerHashed) 
123         external 
124         onlyFoundation
125     {
126         require(_newOwnerCandidate != address(0));
127         require(_newOwnerCandidate != owner);
128 
129         newOwnerCandidate = _newOwnerCandidate;
130         ownerHashed = _ownerHashed;
131 
132         OwnershipRequested(msg.sender, newOwnerCandidate, ownerHashed);
133     }
134 
135     /// @dev Accept ownership transfer. This method needs to be called by the previously proposed owner.
136     /// @param _ownerSecret string The secret to check against the hash.
137     function acceptOwnership(
138         string _ownerSecret) 
139         external 
140         onlyOwnerCandidate 
141         validSecret(newOwnerCandidate, _ownerSecret, ownerHashed)
142     {
143         address previousOwner = owner;
144 
145         owner = newOwnerCandidate;
146         newOwnerCandidate = address(0);
147 
148         OwnershipTransferred(previousOwner, owner);
149     }
150 
151     /// @dev Proposes to transfer control of the contract to a newFoundationCandidate.
152     /// @param _newFoundationCandidate address The address to transfer oversight to.
153     /// @param _foundationHashed string The hashed secret to use as protection.
154     function requestFoundationTransfer(
155         address _newFoundationCandidate, 
156         bytes32 _foundationHashed) 
157         external 
158         onlyFoundation 
159     {
160         require(_newFoundationCandidate != address(0));
161         require(_newFoundationCandidate != foundation);
162 
163         newFoundationCandidate = _newFoundationCandidate;
164         foundationHashed = _foundationHashed;
165 
166         FoundationRequested(msg.sender, newFoundationCandidate, foundationHashed);
167     }
168 
169     /// @dev Accept foundation transfer. This method needs to be called by the previously proposed foundation.
170     /// @param _foundationSecret string The secret to check against the hash.
171     function acceptFoundation(
172         string _foundationSecret) 
173         external 
174         onlyFoundationCandidate 
175         validSecret(newFoundationCandidate, _foundationSecret, foundationHashed)
176     {
177         address previousFoundation = foundation;
178 
179         foundation = newFoundationCandidate;
180         newFoundationCandidate = address(0);
181 
182         FoundationTransferred(previousFoundation, foundation);
183     }
184 }
185 
186 /* @dev Math operations with safety checks
187 */
188 library SafeMath {
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a * b;
191         assert(a == 0 || c / a == b);
192         return c;
193     }
194 
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         // assert(b > 0); // Solidity automatically throws when dividing by 0
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199         return c;
200     }
201 
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         assert(b <= a);
204         return a - b;
205     }
206 
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         assert(c >= a);
210         return c;
211     }
212 
213     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
214         return a >= b ? a : b;
215     }
216 
217     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
218         return a < b ? a : b;
219     }
220 
221     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a >= b ? a : b;
223     }
224 
225     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a < b ? a : b;
227     }
228 }
229 // Licensed under the MIT License
230 // Copyright (c) 2017 Curvegrid Inc.
231 
232 
233 
234 /**
235  * @title Pausable
236  * @dev Base contract which allows children to implement an emergency stop mechanism.
237  */
238 contract Pausable is OwnableWithFoundation {
239   event Pause();
240   event Unpause();
241 
242   bool public paused = false;
243 
244   function Pausable(address _owner) public OwnableWithFoundation(_owner) {
245   }
246 
247   /**
248    * @dev Modifier to make a function callable only when the contract is not paused.
249    */
250   modifier whenNotPaused() {
251     require(!paused);
252     _;
253   }
254 
255   /**
256    * @dev Modifier to make a function callable only when the contract is paused.
257    */
258   modifier whenPaused() {
259     require(paused);
260     _;
261   }
262 
263   /**
264    * @dev called by the owner to pause, triggers stopped state
265    */
266   function pause() onlyOwner whenNotPaused public {
267     paused = true;
268     Pause();
269   }
270 
271   /**
272    * @dev called by the owner to unpause, returns to normal state
273    */
274   function unpause() onlyOwner whenPaused public {
275     paused = false;
276     Unpause();
277   }
278 }
279 
280 
281 /// @title Basic ERC20 token contract implementation.
282 /* @dev Kin's BasicToken based on OpenZeppelin's StandardToken.
283 */
284 
285 contract BasicToken is ERC20 {
286     using SafeMath for uint256;
287 
288     uint256 public totalSupply;
289     mapping (address => mapping (address => uint256)) allowed;
290     mapping (address => uint256) balances;
291 
292     event Approval(address indexed owner, address indexed spender, uint256 value);
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
296     /// @param _spender address The address which will spend the funds.
297     /// @param _value uint256 The amount of tokens to be spent.
298     function approve(address _spender, uint256 _value) public returns (bool) {
299         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
301             revert();
302         }
303 
304         allowed[msg.sender][_spender] = _value;
305 
306         Approval(msg.sender, _spender, _value);
307 
308         return true;
309     }
310 
311     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
312     /// @param _owner address The address which owns the funds.
313     /// @param _spender address The address which will spend the funds.
314     /// @return uint256 specifying the amount of tokens still available for the spender.
315     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
316         return allowed[_owner][_spender];
317     }
318 
319 
320     /// @dev Gets the balance of the specified address.
321     /// @param _owner address The address to query the the balance of.
322     /// @return uint256 representing the amount owned by the passed address.
323     function balanceOf(address _owner) public constant returns (uint256 balance) {
324         return balances[_owner];
325     }
326 
327     /// @dev transfer token to a specified address.
328     /// @param _to address The address to transfer to.
329     /// @param _value uint256 The amount to be transferred.
330     function transfer(address _to, uint256 _value) public returns (bool) {
331         balances[msg.sender] = balances[msg.sender].sub(_value);
332         balances[_to] = balances[_to].add(_value);
333 
334         Transfer(msg.sender, _to, _value);
335 
336         return true;
337     }
338 
339     /// @dev Transfer tokens from one address to another.
340     /// @param _from address The address which you want to send tokens from.
341     /// @param _to address The address which you want to transfer to.
342     /// @param _value uint256 the amount of tokens to be transferred.
343     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
344         uint256 _allowance = allowed[_from][msg.sender];
345 
346         balances[_from] = balances[_from].sub(_value);
347         balances[_to] = balances[_to].add(_value);
348 
349         allowed[_from][msg.sender] = _allowance.sub(_value);
350 
351         Transfer(_from, _to, _value);
352 
353         return true;
354     }
355 }
356 // Licensed under the MIT License
357 // Copyright (c) 2017 Curvegrid Inc.
358 
359 
360 
361 /**
362  * @dev ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
363  *      D1Coin is the main contract for the D1 platform.
364  */
365 contract D1Coin is BasicToken, Pausable {
366     using SafeMath for uint256;
367 
368     string public constant name = "D1 Coin";
369     string public constant symbol = "D1";
370 
371     // Thousands of a token represent the minimum usable unit of token based on
372     // its expected value
373     uint8 public constant decimals = 3;
374 
375     address theCoin = address(this);
376 
377     // Hashed secrets required to unlock coins transferred from one address to another address
378     struct ProtectedBalanceStruct {
379         uint256 balance;
380         bytes32 hashed;
381     }
382     mapping (address => mapping (address => ProtectedBalanceStruct)) protectedBalances;
383     uint256 public protectedSupply;
384 
385     // constructor passes owner (Mint) down to Pausable() => OwnableWithFoundation()
386     function D1Coin(address _owner) public Pausable(_owner) {
387     }
388 
389     event Mint(address indexed minter, address indexed receiver, uint256 value);
390     event ProtectedTransfer(address indexed from, address indexed to, uint256 value, bytes32 hashed);
391     event ProtectedUnlock(address indexed from, address indexed to, uint256 value);
392     event ProtectedReclaim(address indexed from, address indexed to, uint256 value);
393     event Burn(address indexed burner, uint256 value);
394 
395     /// @dev Transfer token to this contract, which is shorthand for the owner (Mint). 
396     /// Avoids race conditions in cases where the owner has changed just before a 
397     /// transfer is called.
398     /// @param _value uint256 The amount to be transferred.
399     function transferToMint(uint256 _value) external whenNotPaused returns (bool) {
400         return transfer(theCoin, _value);
401     }
402 
403     /// @dev Approve this contract, proxy for owner (Mint), to spend the specified amount of tokens 
404     /// on behalf of msg.sender. Avoids race conditions in cases where the owner has changed 
405     /// just before an approve is called.
406     /// @param _value uint256 The amount of tokens to be spent.
407     function approveToMint(uint256 _value) external whenNotPaused returns (bool) {
408         return approve(theCoin, _value);
409     }
410 
411     /// @dev Protected transfer tokens to this contract, which is shorthand for the owner (Mint). 
412     /// Avoids race conditions in cases where the owner has changed just before a 
413     /// transfer is called.
414     /// @param _value uint256 The amount to be transferred.
415     /// @param _hashed string The hashed secret to use as protection.
416     function protectedTransferToMint(uint256 _value, bytes32 _hashed) external whenNotPaused returns (bool) {
417         return protectedTransfer(theCoin, _value, _hashed);
418     }
419 
420     /// @dev Transfer tokens from an address to this contract, a proxy for the owner (Mint).
421     /// Subject to pre-approval from the address. Avoids race conditions in cases where the owner has changed 
422     /// just before an approve is called.
423     /// @param _from address The address which you want to send tokens from.
424     /// @param _value uint256 the amount of tokens to be transferred.
425     function withdrawByMint(address _from, uint256 _value) external onlyOwner whenNotPaused returns (bool) {
426         // retrieve allowance
427         uint256 _allowance = allowed[_from][theCoin];
428 
429         // adjust balances
430         balances[_from] = balances[_from].sub(_value);
431         balances[theCoin] = balances[theCoin].add(_value);
432 
433         // adjust allowance
434         allowed[_from][theCoin] = _allowance.sub(_value);
435 
436         Transfer(_from, theCoin, _value);
437 
438         return true;
439     }
440 
441     /// @dev Creates a specific amount of tokens and credits them to the Mint.
442     /// @param _amount uint256 Amount tokens to mint.
443     function mint(uint256 _amount) external onlyOwner whenNotPaused {
444         require(_amount > 0);
445 
446         totalSupply = totalSupply.add(_amount);
447         balances[theCoin] = balances[theCoin].add(_amount);
448 
449         Mint(msg.sender, theCoin, _amount);
450 
451         // optional in ERC-20 standard, but required by Etherscan
452         Transfer(address(0), theCoin, _amount);
453     }
454 
455     /// @dev Retrieve the protected balance and hashed passphrase for a pending protected transfer.
456     /// @param _from address The address transferred from.
457     /// @param _to address The address transferred to.
458     function protectedBalance(address _from, address _to) public constant returns (uint256 balance, bytes32 hashed) {
459         return(protectedBalances[_from][_to].balance, protectedBalances[_from][_to].hashed);
460     }
461 
462     /// @dev Transfer tokens to a specified address protected by a secret.
463     /// @param _to address The address to transfer to.
464     /// @param _value uint256 The amount to be transferred.
465     /// @param _hashed string The hashed secret to use as protection.
466     function protectedTransfer(address _to, uint256 _value, bytes32 _hashed) public whenNotPaused returns (bool) {
467         require(_value > 0);
468 
469         // "transfers" to address(0) should only be by the burn() function
470         require(_to != address(0));
471 
472         // explicitly disallow tranfer to the owner, as it's automatically translated into the coin
473         // in protectedUnlock() and protectedReclaim()
474         require(_to != owner);
475 
476         address from = msg.sender;
477 
478         // special case: msg.sender is the owner (Mint)
479         if (msg.sender == owner) {
480             from = theCoin;
481 
482             // ensure Mint is actually holding this supply; not required below because of revert in .sub()
483             require(balances[theCoin].sub(protectedSupply) >= _value);
484         } else {
485             // otherwise, adjust the balances: transfer the tokens to the Mint to have them held in escrow
486             balances[from] = balances[from].sub(_value);
487             balances[theCoin] = balances[theCoin].add(_value);
488         }
489 
490         // protected balance must be zero (unlocked or reclaimed in its entirety)
491         // avoid a situation similar to: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
492         if (protectedBalances[from][_to].balance != 0) {
493             revert();
494         }
495 
496         // disallow reusing the previous secret
497         // (not intended to prevent reuse of an N-x, x > 1 secret)
498         require(protectedBalances[from][_to].hashed != _hashed);
499 
500         // set the protected balance and hashed value
501         protectedBalances[from][_to].balance = _value;
502         protectedBalances[from][_to].hashed = _hashed;
503 
504         // adjust the protected supply
505         protectedSupply = protectedSupply.add(_value);
506 
507         ProtectedTransfer(from, _to, _value, _hashed);
508 
509         return true;
510     }
511 
512     /// @dev Unlock protected tokens from an address.
513     /// @param _from address The address to transfer from.
514     /// @param _value uint256 The amount to be transferred.
515     /// @param _secret string The secret phrase protecting the tokens.
516     function protectedUnlock(address _from, uint256 _value, string _secret) external whenNotPaused returns (bool) {
517         address to = msg.sender;
518 
519         // special case: msg.sender is the owner (Mint)
520         if (msg.sender == owner) {
521             to = theCoin;
522         }
523 
524         // validate secret against hash
525         require(checkSecret(to, _secret, protectedBalances[_from][to].hashed));
526 
527         // must transfer all protected tokens at once as secret will have been leaked on the blockchain
528         require(protectedBalances[_from][to].balance == _value);
529 
530         // adjust the balances: the Mint is holding the tokens in escrow
531         balances[theCoin] = balances[theCoin].sub(_value);
532         balances[to] = balances[to].add(_value);
533         
534         // adjust the protected balances and protected supply
535         protectedBalances[_from][to].balance = 0;
536         protectedSupply = protectedSupply.sub(_value);
537 
538         ProtectedUnlock(_from, to, _value);
539         Transfer(_from, to, _value);
540 
541         return true;
542     }
543 
544     /// @dev Reclaim protected tokens granted to a specified address.
545     /// @param _to address The address to the tokens were granted to.
546     /// @param _value uint256 The amount to be transferred.
547     function protectedReclaim(address _to, uint256 _value) external whenNotPaused returns (bool) {
548         address from = msg.sender;
549 
550         // special case: msg.sender is the owner (Mint)
551         if (msg.sender == owner) {
552             from = theCoin;
553         } else {
554             // otherwise, adjust the balances: transfer the tokens to the sender from the Mint, which was holding them in escrow
555             balances[theCoin] = balances[theCoin].sub(_value);
556             balances[from] = balances[from].add(_value);
557         }
558 
559         // must transfer all protected tokens at once
560         require(protectedBalances[from][_to].balance == _value);
561         
562         // adjust the protected balances and protected supply
563         protectedBalances[from][_to].balance = 0;
564         protectedSupply = protectedSupply.sub(_value);
565 
566         ProtectedReclaim(from, _to, _value);
567 
568         return true;
569     }
570 
571     /// @dev Destroys (removes from supply) a specific amount of tokens.
572     /// @param _amount uint256 The amount of tokens to be burned.
573     function burn(uint256 _amount) external onlyOwner whenNotPaused {
574         // The Mint is the owner of this contract. In this implementation, the
575         // address of this contract (proxy for owner's account)  is used to control 
576         // the money supply. Avoids the problem of having to transfer balances on owner change.
577         require(_amount > 0);
578         require(_amount <= balances[theCoin].sub(protectedSupply)); // account for protected balances
579 
580         // adjust the balances and supply
581         balances[theCoin] = balances[theCoin].sub(_amount);
582         totalSupply = totalSupply.sub(_amount);
583 
584         // not part of the ERC-20 standard, but required by Etherscan
585         Transfer(theCoin, address(0), _amount);
586 
587         Burn(theCoin, _amount);
588     }
589 
590     /// @dev ERC20 behaviour but revert if paused
591     /// @param _spender address The address which will spend the funds.
592     /// @param _value uint256 The amount of tokens to be spent.
593     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
594         return super.approve(_spender, _value);
595     }
596 
597     /// @dev ERC20 behaviour but revert if paused
598     /// @param _owner address The address which owns the funds.
599     /// @param _spender address The address which will spend the funds.
600     /// @return uint256 specifying the amount of tokens still available for the spender.
601     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
602         return super.allowance(_owner, _spender);
603     }
604 
605     /// @dev ERC20 behaviour but revert if paused
606     /// @param _to address The address to transfer to.
607     /// @param _value uint256 The amount to be transferred.
608     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
609         // "transfers" to address(0) should only be by the burn() function
610         require(_to != address(0));
611 
612         return super.transfer(_to, _value);
613     }
614 
615     /// @dev ERC20 behaviour but revert if paused
616     /// @param _from address The address which you want to send tokens from.
617     /// @param _to address The address which you want to transfer to.
618     /// @param _value uint256 the amount of tokens to be transferred.
619     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
620         // "transfers" to address(0) should only be by the burn() function
621         require(_to != address(0));
622 
623         // special case: _from is the Mint
624         // note: within the current D1 Coin design, should never encounter this case
625         if (_from == theCoin) {
626             // ensure Mint is not exceeding its balance less protected supply
627             require(_value <= balances[theCoin].sub(protectedSupply));
628         }
629 
630         return super.transferFrom(_from, _to, _value);
631     }
632 }