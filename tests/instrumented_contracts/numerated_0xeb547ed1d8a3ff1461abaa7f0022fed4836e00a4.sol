1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMathLib{
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25   
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41   address public coinvest;
42   mapping (address => bool) public admins;
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor() public {
51     owner = msg.sender;
52     coinvest = msg.sender;
53     admins[owner] = true;
54     admins[coinvest] = true;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   modifier onlyCoinvest() {
66       require(msg.sender == coinvest);
67       _;
68   }
69 
70   modifier onlyAdmin() {
71       require(admins[msg.sender]);
72       _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) onlyOwner public {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84   
85   /**
86    * @dev Changes the Coinvest wallet that will receive funds from investment contract.
87    * @param _newCoinvest The address of the new wallet.
88   **/
89   function transferCoinvest(address _newCoinvest) 
90     external
91     onlyCoinvest
92   {
93     require(_newCoinvest != address(0));
94     coinvest = _newCoinvest;
95   }
96 
97   /**
98    * @dev Used to add admins who are allowed to add funds to the investment contract.
99    * @param _user The address of the admin to add or remove.
100    * @param _status True to add the user, False to remove the user.
101   **/
102   function alterAdmin(address _user, bool _status)
103     external
104     onlyCoinvest
105   {
106     require(_user != address(0));
107     require(_user != coinvest);
108     admins[_user] = _status;
109   }
110 
111 }
112 
113 /**
114  * @dev Abstract contract for approveAndCall.
115 **/
116 contract ApproveAndCallFallBack {
117     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
118 }
119 
120 /**
121  * @title Coinvest COIN Token
122  * @dev ERC20 contract utilizing ERC865-ish structure (3esmit's implementation with alterations).
123  * @dev to allow users to pay Ethereum fees in tokens.
124 **/
125 contract CoinvestToken is Ownable {
126     using SafeMathLib for uint256;
127     
128     string public constant symbol = "COIN";
129     string public constant name = "Coinvest COIN V3 Token";
130     
131     uint8 public constant decimals = 18;
132     uint256 private _totalSupply = 107142857 * (10 ** 18);
133     
134     // Function sigs to be used within contract for signature recovery.
135     bytes4 internal constant transferSig = 0xa9059cbb;
136     bytes4 internal constant approveSig = 0x095ea7b3;
137     bytes4 internal constant increaseApprovalSig = 0xd73dd623;
138     bytes4 internal constant decreaseApprovalSig = 0x66188463;
139     bytes4 internal constant approveAndCallSig = 0xcae9ca51;
140     bytes4 internal constant revokeHashSig = 0x70de43f1;
141 
142     // Balances for each account
143     mapping(address => uint256) balances;
144 
145     // Owner of account approves the transfer of an amount to another account
146     mapping(address => mapping (address => uint256)) allowed;
147     
148     // Keeps track of the last nonce sent from user. Used for delegated functions.
149     mapping(address => uint256) nonces;
150     
151     // Mapping of past used hashes: true if already used.
152     mapping(address => mapping (bytes32 => bool)) invalidHashes;
153 
154     event Transfer(address indexed from, address indexed to, uint tokens);
155     event Approval(address indexed from, address indexed spender, uint tokens);
156     event HashRedeemed(bytes32 indexed txHash, address indexed from);
157 
158     /**
159      * @dev Set owner and beginning balance.
160     **/
161     constructor()
162       public
163     {
164         balances[msg.sender] = _totalSupply;
165     }
166 
167     /**
168      * @dev approveAndCall reception used primarily to pay gas with other tokens.
169     **/
170     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) 
171       public
172     {
173         require(address(this).delegatecall(_data));
174         _from; _amount; _token;
175     }
176 
177 /** ******************************** ERC20 ********************************* **/
178 
179     /**
180      * @dev Transfers coins from one address to another.
181      * @param _to The recipient of the transfer amount.
182      * @param _amount The amount of tokens to transfer.
183     **/
184     function transfer(address _to, uint256 _amount) 
185       public
186     returns (bool success)
187     {
188         require(_transfer(msg.sender, _to, _amount));
189         return true;
190     }
191     
192     /**
193      * @dev An allowed address can transfer tokens from another's address.
194      * @param _from The owner of the tokens to be transferred.
195      * @param _to The address to which the tokens will be transferred.
196      * @param _amount The amount of tokens to be transferred.
197     **/
198     function transferFrom(address _from, address _to, uint _amount)
199       public
200     returns (bool success)
201     {
202         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
203 
204         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
205         require(_transfer(_from, _to, _amount));
206         return true;
207     }
208     
209     /**
210      * @dev Approves a wallet to transfer tokens on one's behalf.
211      * @param _spender The wallet approved to spend tokens.
212      * @param _amount The amount of tokens approved to spend.
213     **/
214     function approve(address _spender, uint256 _amount) 
215       public
216     returns (bool success)
217     {
218         require(_approve(msg.sender, _spender, _amount));
219         return true;
220     }
221     
222     /**
223      * @dev Increases the allowed amount for spender from msg.sender.
224      * @param _spender The address to increase allowed amount for.
225      * @param _amount The amount of tokens to increase allowed amount by.
226     **/
227     function increaseApproval(address _spender, uint256 _amount) 
228       public
229     returns (bool success)
230     {
231         require(_increaseApproval(msg.sender, _spender, _amount));
232         return true;
233     }
234     
235     /**
236      * @dev Decreases the allowed amount for spender from msg.sender.
237      * @param _spender The address to decrease allowed amount for.
238      * @param _amount The amount of tokens to decrease allowed amount by.
239     **/
240     function decreaseApproval(address _spender, uint256 _amount) 
241       public
242     returns (bool success)
243     {
244         require(_decreaseApproval(msg.sender, _spender, _amount));
245         return true;
246     }
247     
248     /**
249      * @dev Used to approve an address and call a function on it in the same transaction.
250      * @dev _spender The address to be approved to spend COIN.
251      * @dev _amount The amount of COIN to be approved to spend.
252      * @dev _data The data to send to the called contract.
253     **/
254     function approveAndCall(address _spender, uint256 _amount, bytes _data) 
255       public
256     returns (bool success) 
257     {
258         require(_approve(msg.sender, _spender, _amount));
259         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
260         return true;
261     }
262 
263 /** ****************************** Internal ******************************** **/
264     
265     /**
266      * @dev Internal transfer for all functions that transfer.
267      * @param _from The address that is transferring coins.
268      * @param _to The receiving address of the coins.
269      * @param _amount The amount of coins being transferred.
270     **/
271     function _transfer(address _from, address _to, uint256 _amount)
272       internal
273     returns (bool success)
274     {
275         require (_to != address(0), "Invalid transfer recipient address.");
276         require(balances[_from] >= _amount, "Sender does not have enough balance.");
277         
278         balances[_from] = balances[_from].sub(_amount);
279         balances[_to] = balances[_to].add(_amount);
280         
281         emit Transfer(_from, _to, _amount);
282         return true;
283     }
284     
285     /**
286      * @dev Internal approve for all functions that require an approve.
287      * @param _owner The owner who is allowing spender to use their balance.
288      * @param _spender The wallet approved to spend tokens.
289      * @param _amount The amount of tokens approved to spend.
290     **/
291     function _approve(address _owner, address _spender, uint256 _amount) 
292       internal
293     returns (bool success)
294     {
295         allowed[_owner][_spender] = _amount;
296         emit Approval(_owner, _spender, _amount);
297         return true;
298     }
299     
300     /**
301      * @dev Increases the allowed by "_amount" for "_spender" from "owner"
302      * @param _owner The address that tokens may be transferred from.
303      * @param _spender The address that may transfer these tokens.
304      * @param _amount The amount of tokens to transfer.
305     **/
306     function _increaseApproval(address _owner, address _spender, uint256 _amount)
307       internal
308     returns (bool success)
309     {
310         allowed[_owner][_spender] = allowed[_owner][_spender].add(_amount);
311         emit Approval(_owner, _spender, allowed[_owner][_spender]);
312         return true;
313     }
314     
315     /**
316      * @dev Decreases the allowed by "_amount" for "_spender" from "_owner"
317      * @param _owner The owner of the tokens to decrease allowed for.
318      * @param _spender The spender whose allowed will decrease.
319      * @param _amount The amount of tokens to decrease allowed by.
320     **/
321     function _decreaseApproval(address _owner, address _spender, uint256 _amount)
322       internal
323     returns (bool success)
324     {
325         if (allowed[_owner][_spender] <= _amount) allowed[_owner][_spender] = 0;
326         else allowed[_owner][_spender] = allowed[_owner][_spender].sub(_amount);
327         
328         emit Approval(_owner, _spender, allowed[_owner][_spender]);
329         return true;
330     }
331     
332 /** ************************ Delegated Functions *************************** **/
333 
334     /**
335      * @dev Called by delegate with a signed hash of the transaction data to allow a user
336      * @dev to transfer tokens without paying gas in Ether (they pay in COIN instead).
337      * @param _signature Signed hash of data for this transfer.
338      * @param _to The address to transfer COIN to.
339      * @param _value The amount of COIN to transfer.
340      * @param _gasPrice Price (IN COIN) that will be paid per unit of gas by user to "delegate".
341      * @param _nonce Nonce of the user's new transaction.
342     **/
343     function transferPreSigned(
344         bytes _signature,
345         address _to, 
346         uint256 _value,
347         uint256 _gasPrice, 
348         uint256 _nonce) 
349       public
350     returns (bool) 
351     {
352         // Log starting gas left of transaction for later gas price calculations.
353         uint256 gas = gasleft();
354         
355         // Recover signer address from signature; ensure address is valid.
356         address from = recoverPreSigned(_signature, transferSig, _to, _value, "", _gasPrice, _nonce);
357         require(from != address(0), "Invalid signature provided.");
358         
359         // Require the hash has not been used, declare it used, increment nonce.
360         bytes32 txHash = getPreSignedHash(transferSig, _to, _value, "", _gasPrice, _nonce);
361         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
362         invalidHashes[from][txHash] = true;
363         nonces[from]++;
364         
365         // Internal transfer.
366         require(_transfer(from, _to, _value));
367 
368         // If the delegate is charging, pay them for gas in COIN.
369         if (_gasPrice > 0) {
370             // 35000 because of base fee of 21000 and ~14000 for the fee transfer.
371             gas = 35000 + gas.sub(gasleft());
372             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
373         }
374         
375         emit HashRedeemed(txHash, from);
376         return true;
377     }
378     
379     /**
380      * @dev Called by a delegate with signed hash to approve a transaction for user.
381      * @dev All variables equivalent to transfer except _to:
382      * @param _to The address that will be approved to transfer COIN from user's wallet.
383     **/
384     function approvePreSigned(
385         bytes _signature,
386         address _to, 
387         uint256 _value,
388         uint256 _gasPrice, 
389         uint256 _nonce) 
390       public
391     returns (bool) 
392     {
393         uint256 gas = gasleft();
394         address from = recoverPreSigned(_signature, approveSig, _to, _value, "", _gasPrice, _nonce);
395         require(from != address(0), "Invalid signature provided.");
396 
397         bytes32 txHash = getPreSignedHash(approveSig, _to, _value, "", _gasPrice, _nonce);
398         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
399         invalidHashes[from][txHash] = true;
400         nonces[from]++;
401         
402         require(_approve(from, _to, _value));
403 
404         if (_gasPrice > 0) {
405             gas = 35000 + gas.sub(gasleft());
406             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
407         }
408 
409         emit HashRedeemed(txHash, from);
410         return true;
411     }
412     
413     /**
414      * @dev Used to increase the amount allowed for "_to" to spend from "from"
415      * @dev A bare approve allows potentially nasty race conditions when using a delegate.
416     **/
417     function increaseApprovalPreSigned(
418         bytes _signature,
419         address _to, 
420         uint256 _value,
421         uint256 _gasPrice, 
422         uint256 _nonce)
423       public
424     returns (bool) 
425     {
426         uint256 gas = gasleft();
427         address from = recoverPreSigned(_signature, increaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
428         require(from != address(0), "Invalid signature provided.");
429 
430         bytes32 txHash = getPreSignedHash(increaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
431         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
432         invalidHashes[from][txHash] = true;
433         nonces[from]++;
434         
435         require(_increaseApproval(from, _to, _value));
436 
437         if (_gasPrice > 0) {
438             gas = 35000 + gas.sub(gasleft());
439             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
440         }
441         
442         emit HashRedeemed(txHash, from);
443         return true;
444     }
445     
446     /**
447      * @dev Added for the same reason as increaseApproval. Decreases to 0 if "_value" is greater than allowed.
448     **/
449     function decreaseApprovalPreSigned(
450         bytes _signature,
451         address _to, 
452         uint256 _value, 
453         uint256 _gasPrice, 
454         uint256 _nonce) 
455       public
456     returns (bool) 
457     {
458         uint256 gas = gasleft();
459         address from = recoverPreSigned(_signature, decreaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
460         require(from != address(0), "Invalid signature provided.");
461 
462         bytes32 txHash = getPreSignedHash(decreaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
463         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
464         invalidHashes[from][txHash] = true;
465         nonces[from]++;
466         
467         require(_decreaseApproval(from, _to, _value));
468 
469         if (_gasPrice > 0) {
470             gas = 35000 + gas.sub(gasleft());
471             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
472         }
473 
474         emit HashRedeemed(txHash, from);
475         return true;
476     }
477     
478     /**
479      * @dev approveAndCallPreSigned allows a user to approve a contract and call a function on it
480      * @dev in the same transaction. As with the other presigneds, a delegate calls this with signed data from user.
481      * @dev This function is the big reason we're using gas price and calculating gas use.
482      * @dev Using this with the investment contract can result in varying gas costs.
483      * @param _extraData The data to send to the contract.
484     **/
485     function approveAndCallPreSigned(
486         bytes _signature,
487         address _to, 
488         uint256 _value,
489         bytes _extraData,
490         uint256 _gasPrice,
491         uint256 _nonce) 
492       public
493     returns (bool) 
494     {
495         uint256 gas = gasleft();
496         address from = recoverPreSigned(_signature, approveAndCallSig, _to, _value, _extraData, _gasPrice, _nonce);
497         require(from != address(0), "Invalid signature provided.");
498 
499         bytes32 txHash = getPreSignedHash(approveAndCallSig, _to, _value, _extraData, _gasPrice, _nonce);
500         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
501         invalidHashes[from][txHash] = true;
502         nonces[from]++;
503         
504         if (_value > 0) require(_approve(from, _to, _value));
505         ApproveAndCallFallBack(_to).receiveApproval(from, _value, address(this), _extraData);
506 
507         if (_gasPrice > 0) {
508             gas = 35000 + gas.sub(gasleft());
509             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
510         }
511         
512         emit HashRedeemed(txHash, from);
513         return true;
514     }
515 
516 /** *************************** Revoke PreSigned ************************** **/
517     
518     /**
519      * @dev Revoke hash without going through a delegate.
520      * @param _hashToRevoke The hash that you no longer want to be used.
521     **/
522     function revokeHash(bytes32 _hashToRevoke)
523       public
524     returns (bool)
525     {
526         invalidHashes[msg.sender][_hashToRevoke] = true;
527         nonces[msg.sender]++;
528         return true;
529     }
530     
531     /**
532      * @dev Revoke hash through a delegate.
533      * @param _signature The signature allowing this revocation.
534      * @param _hashToRevoke The hash that you would like revoked.
535      * @param _gasPrice The amount of token wei to be paid for each uint of gas.
536     **/
537     function revokeHashPreSigned(
538         bytes _signature,
539         bytes32 _hashToRevoke,
540         uint256 _gasPrice)
541       public
542     returns (bool)
543     {
544         uint256 gas = gasleft();
545         address from = recoverRevokeHash(_signature, _hashToRevoke, _gasPrice);
546         require(from != address(0), "Invalid signature provided.");
547         
548         bytes32 txHash = getRevokeHash(_hashToRevoke, _gasPrice);
549         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
550         invalidHashes[from][txHash] = true;
551         nonces[from]++;
552         
553         invalidHashes[from][_hashToRevoke] = true;
554         
555         if (_gasPrice > 0) {
556             gas = 35000 + gas.sub(gasleft());
557             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
558         }
559         
560         emit HashRedeemed(txHash, from);
561         return true;
562     }
563     
564     /**
565      * @dev Get hash for a revocation.
566      * @param _hashToRevoke The signature to be revoked.
567      * @param _gasPrice The amount to be paid to delegate for sending this tx.
568     **/
569     function getRevokeHash(bytes32 _hashToRevoke, uint256 _gasPrice)
570       public
571       view
572     returns (bytes32 txHash)
573     {
574         return keccak256(abi.encodePacked(address(this), revokeHashSig, _hashToRevoke, _gasPrice));
575     }
576 
577     /**
578      * @dev Recover the address from a revocation hash.
579      * @param _hashToRevoke The hash to be revoked.
580      * @param _signature The signature allowing this revocation.
581      * @param _gasPrice The amount of token wei to be paid for each unit of gas.
582     **/
583     function recoverRevokeHash(bytes _signature, bytes32 _hashToRevoke, uint256 _gasPrice)
584       public
585       view
586     returns (address from)
587     {
588         return ecrecoverFromSig(getSignHash(getRevokeHash(_hashToRevoke, _gasPrice)), _signature);
589     }
590     
591 /** ************************** PreSigned Constants ************************ **/
592 
593     /**
594      * @dev Used in frontend and contract to get hashed data of any given pre-signed transaction.
595      * @param _to The address to transfer COIN to.
596      * @param _value The amount of COIN to be transferred.
597      * @param _extraData Extra data of tx if needed. Transfers and approves will leave this null.
598      * @param _function Function signature of the pre-signed function being used.
599      * @param _gasPrice The agreed-upon amount of COIN to be paid per unit of gas.
600      * @param _nonce The user's nonce of the new transaction.
601     **/
602     function getPreSignedHash(
603         bytes4 _function,
604         address _to, 
605         uint256 _value,
606         bytes _extraData,
607         uint256 _gasPrice,
608         uint256 _nonce)
609       public
610       view
611     returns (bytes32 txHash) 
612     {
613         return keccak256(abi.encodePacked(address(this), _function, _to, _value, _extraData, _gasPrice, _nonce));
614     }
615     
616     /**
617      * @dev Recover an address from a signed pre-signed hash.
618      * @param _sig The signed hash.
619      * @param _function The function signature for function being called.
620      * @param _to The address to transfer/approve/transferFrom/etc. tokens to.
621      * @param _value The amont of tokens to transfer/approve/etc.
622      * @param _extraData The extra data included in the transaction, if any.
623      * @param _gasPrice The amount of token wei to be paid to the delegate for each unit of gas.
624      * @param _nonce The user's nonce for this transaction.
625     **/
626     function recoverPreSigned(
627         bytes _sig,
628         bytes4 _function,
629         address _to,
630         uint256 _value,
631         bytes _extraData,
632         uint256 _gasPrice,
633         uint256 _nonce) 
634       public
635       view
636     returns (address recovered)
637     {
638         return ecrecoverFromSig(getSignHash(getPreSignedHash(_function, _to, _value, _extraData, _gasPrice, _nonce)), _sig);
639     }
640     
641     /**
642      * @dev Add signature prefix to hash for recovery à la ERC191.
643      * @param _hash The hashed transaction to add signature prefix to.
644     **/
645     function getSignHash(bytes32 _hash)
646       public
647       pure
648     returns (bytes32 signHash)
649     {
650         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
651     }
652 
653     /**
654      * @dev Helps to reduce stack depth problems for delegations. Thank you to Bokky for this!
655      * @param hash The hash of signed data for the transaction.
656      * @param sig Contains r, s, and v for recovery of address from the hash.
657     **/
658     function ecrecoverFromSig(bytes32 hash, bytes sig) 
659       public 
660       pure 
661     returns (address recoveredAddress) 
662     {
663         bytes32 r;
664         bytes32 s;
665         uint8 v;
666         if (sig.length != 65) return address(0);
667         assembly {
668             r := mload(add(sig, 32))
669             s := mload(add(sig, 64))
670             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
671             // There is no 'mload8' to do this, but that would be nicer.
672             v := byte(0, mload(add(sig, 96)))
673         }
674         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
675         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
676         if (v < 27) v += 27;
677         if (v != 27 && v != 28) return address(0);
678         return ecrecover(hash, v, r, s);
679     }
680 
681     /**
682      * @dev Frontend queries to find the next nonce of the user so they can find the new nonce to send.
683      * @param _owner Address that will be sending the COIN.
684     **/
685     function getNonce(address _owner)
686       external
687       view
688     returns (uint256 nonce)
689     {
690         return nonces[_owner];
691     }
692 
693 /** ****************************** Constants ******************************* **/
694     
695     /**
696      * @dev Return total supply of token.
697     **/
698     function totalSupply() 
699       external
700       view 
701      returns (uint256)
702     {
703         return _totalSupply;
704     }
705 
706     /**
707      * @dev Return balance of a certain address.
708      * @param _owner The address whose balance we want to check.
709     **/
710     function balanceOf(address _owner)
711       external
712       view 
713     returns (uint256) 
714     {
715         return balances[_owner];
716     }
717     
718     /**
719      * @dev Allowed amount for a user to spend of another's tokens.
720      * @param _owner The owner of the tokens approved to spend.
721      * @param _spender The address of the user allowed to spend the tokens.
722     **/
723     function allowance(address _owner, address _spender) 
724       external
725       view 
726     returns (uint256) 
727     {
728         return allowed[_owner][_spender];
729     }
730     
731 /** ****************************** onlyOwner ******************************* **/
732     
733     /**
734      * @dev Allow the owner to take ERC20 tokens off of this contract if they are accidentally sent.
735     **/
736     function tokenEscape(address _tokenContract)
737       external
738       onlyOwner
739     {
740         CoinvestToken lostToken = CoinvestToken(_tokenContract);
741         
742         uint256 stuckTokens = lostToken.balanceOf(address(this));
743         lostToken.transfer(owner, stuckTokens);
744     }
745     
746 }