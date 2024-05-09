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
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40   address public coinvest;
41   mapping (address => bool) public admins;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51     coinvest = msg.sender;
52     admins[owner] = true;
53     admins[coinvest] = true;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   modifier onlyCoinvest() {
65       require(msg.sender == coinvest);
66       _;
67   }
68 
69   modifier onlyAdmin() {
70       require(admins[msg.sender]);
71       _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83   
84   /**
85    * @dev Changes the Coinvest wallet that will receive funds from investment contract.
86    * @param _newCoinvest The address of the new wallet.
87   **/
88   function transferCoinvest(address _newCoinvest) 
89     external
90     onlyCoinvest
91   {
92     require(_newCoinvest != address(0));
93     coinvest = _newCoinvest;
94   }
95 
96   /**
97    * @dev Used to add admins who are allowed to add funds to the investment contract.
98    * @param _user The address of the admin to add or remove.
99    * @param _status True to add the user, False to remove the user.
100   **/
101   function alterAdmin(address _user, bool _status)
102     external
103     onlyCoinvest
104   {
105     require(_user != address(0));
106     require(_user != coinvest);
107     admins[_user] = _status;
108   }
109 
110 }
111 
112 /**
113  * @dev Abstract contract for approveAndCall.
114 **/
115 contract ApproveAndCallFallBack {
116     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
117 }
118 
119 /**
120  * @title Coin Utility Token
121  * @dev ERC20 contract utilizing ERC865 structure (3esmit's implementation with alterations).
122  * @dev to allow users to pay Ethereum fees in tokens.
123  * @author Coin -- Robert M.C. Forster
124 **/
125 contract CoinToken is Ownable {
126     using SafeMathLib for uint256;
127     
128     string public constant symbol = "COIN";
129     string public constant name = "Coin Utility Token";
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
148     // Mapping of past used hashes: true if already used.
149     mapping(address => mapping (bytes32 => bool)) invalidHashes;
150 
151     event Transfer(address indexed from, address indexed to, uint tokens);
152     event Approval(address indexed from, address indexed spender, uint tokens);
153     event HashRedeemed(bytes32 indexed txHash, address indexed from);
154 
155     /**
156      * @dev Set owner and beginning balance.
157     **/
158     constructor()
159       public
160     {
161         balances[msg.sender] = _totalSupply;
162     }
163 
164     /**
165      * @dev approveAndCall reception used primarily to pay gas with other tokens.
166     **/
167     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) 
168       public
169     {
170         require(msg.sender != address(this));
171         require(address(this).delegatecall(_data));
172         _from; _amount; _token;
173     }
174 
175 /** ******************************** ERC20 ********************************* **/
176 
177     /**
178      * @dev Transfers coins from one address to another.
179      * @param _to The recipient of the transfer amount.
180      * @param _amount The amount of tokens to transfer.
181     **/
182     function transfer(address _to, uint256 _amount) 
183       public
184     returns (bool success)
185     {
186         require(_transfer(msg.sender, _to, _amount));
187         return true;
188     }
189     
190     /**
191      * @dev An allowed address can transfer tokens from another's address.
192      * @param _from The owner of the tokens to be transferred.
193      * @param _to The address to which the tokens will be transferred.
194      * @param _amount The amount of tokens to be transferred.
195     **/
196     function transferFrom(address _from, address _to, uint _amount)
197       public
198     returns (bool success)
199     {
200         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
201 
202         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
203         require(_transfer(_from, _to, _amount));
204         return true;
205     }
206     
207     /**
208      * @dev Approves a wallet to transfer tokens on one's behalf.
209      * @param _spender The wallet approved to spend tokens.
210      * @param _amount The amount of tokens approved to spend.
211     **/
212     function approve(address _spender, uint256 _amount) 
213       public
214     returns (bool success)
215     {
216         require(_approve(msg.sender, _spender, _amount));
217         return true;
218     }
219     
220     /**
221      * @dev Increases the allowed amount for spender from msg.sender.
222      * @param _spender The address to increase allowed amount for.
223      * @param _amount The amount of tokens to increase allowed amount by.
224     **/
225     function increaseApproval(address _spender, uint256 _amount) 
226       public
227     returns (bool success)
228     {
229         require(_increaseApproval(msg.sender, _spender, _amount));
230         return true;
231     }
232     
233     /**
234      * @dev Decreases the allowed amount for spender from msg.sender.
235      * @param _spender The address to decrease allowed amount for.
236      * @param _amount The amount of tokens to decrease allowed amount by.
237     **/
238     function decreaseApproval(address _spender, uint256 _amount) 
239       public
240     returns (bool success)
241     {
242         require(_decreaseApproval(msg.sender, _spender, _amount));
243         return true;
244     }
245     
246     /**
247      * @dev Used to approve an address and call a function on it in the same transaction.
248      * @dev _spender The address to be approved to spend COIN.
249      * @dev _amount The amount of COIN to be approved to spend.
250      * @dev _data The data to send to the called contract.
251     **/
252     function approveAndCall(address _spender, uint256 _amount, bytes _data) 
253       public
254     returns (bool success) 
255     {
256         require(_approve(msg.sender, _spender, _amount));
257         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
258         return true;
259     }
260 
261 /** ****************************** Internal ******************************** **/
262     
263     /**
264      * @dev Internal transfer for all functions that transfer.
265      * @param _from The address that is transferring coins.
266      * @param _to The receiving address of the coins.
267      * @param _amount The amount of coins being transferred.
268     **/
269     function _transfer(address _from, address _to, uint256 _amount)
270       internal
271     returns (bool success)
272     {
273         require (_to != address(0), "Invalid transfer recipient address.");
274         require(balances[_from] >= _amount, "Sender does not have enough balance.");
275         
276         balances[_from] = balances[_from].sub(_amount);
277         balances[_to] = balances[_to].add(_amount);
278         
279         emit Transfer(_from, _to, _amount);
280         return true;
281     }
282     
283     /**
284      * @dev Internal approve for all functions that require an approve.
285      * @param _owner The owner who is allowing spender to use their balance.
286      * @param _spender The wallet approved to spend tokens.
287      * @param _amount The amount of tokens approved to spend.
288     **/
289     function _approve(address _owner, address _spender, uint256 _amount) 
290       internal
291     returns (bool success)
292     {
293         allowed[_owner][_spender] = _amount;
294         emit Approval(_owner, _spender, _amount);
295         return true;
296     }
297     
298     /**
299      * @dev Increases the allowed by "_amount" for "_spender" from "owner"
300      * @param _owner The address that tokens may be transferred from.
301      * @param _spender The address that may transfer these tokens.
302      * @param _amount The amount of tokens to transfer.
303     **/
304     function _increaseApproval(address _owner, address _spender, uint256 _amount)
305       internal
306     returns (bool success)
307     {
308         allowed[_owner][_spender] = allowed[_owner][_spender].add(_amount);
309         emit Approval(_owner, _spender, allowed[_owner][_spender]);
310         return true;
311     }
312     
313     /**
314      * @dev Decreases the allowed by "_amount" for "_spender" from "_owner"
315      * @param _owner The owner of the tokens to decrease allowed for.
316      * @param _spender The spender whose allowed will decrease.
317      * @param _amount The amount of tokens to decrease allowed by.
318     **/
319     function _decreaseApproval(address _owner, address _spender, uint256 _amount)
320       internal
321     returns (bool success)
322     {
323         if (allowed[_owner][_spender] <= _amount) allowed[_owner][_spender] = 0;
324         else allowed[_owner][_spender] = allowed[_owner][_spender].sub(_amount);
325         
326         emit Approval(_owner, _spender, allowed[_owner][_spender]);
327         return true;
328     }
329     
330 /** ************************ Delegated Functions *************************** **/
331 
332     /**
333      * @dev Called by delegate with a signed hash of the transaction data to allow a user
334      * @dev to transfer tokens without paying gas in Ether (they pay in COIN instead).
335      * @param _signature Signed hash of data for this transfer.
336      * @param _to The address to transfer COIN to.
337      * @param _value The amount of COIN to transfer.
338      * @param _gasPrice Price (IN COIN) that will be paid per unit of gas by user to "delegate".
339      * @param _nonce Nonce of the user's new transaction.
340     **/
341     function transferPreSigned(
342         bytes _signature,
343         address _to, 
344         uint256 _value,
345         uint256 _gasPrice, 
346         uint256 _nonce) 
347       public
348     returns (bool) 
349     {
350         // Log starting gas left of transaction for later gas price calculations.
351         uint256 gas = gasleft();
352         
353         // Recover signer address from signature; ensure address is valid.
354         address from = recoverPreSigned(_signature, transferSig, _to, _value, "", _gasPrice, _nonce);
355         require(from != address(0), "Invalid signature provided.");
356         
357         // Require the hash has not been used, declare it used.
358         bytes32 txHash = getPreSignedHash(transferSig, _to, _value, "", _gasPrice, _nonce);
359         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
360         invalidHashes[from][txHash] = true;
361 
362         // Internal transfer.
363         require(_transfer(from, _to, _value));
364 
365         // If the delegate is charging, pay them for gas in COIN.
366         if (_gasPrice > 0) {
367             // 35000 because of base fee of 21000 and ~14000 for the fee transfer.
368             gas = 35000 + gas.sub(gasleft());
369             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
370         }
371         
372         emit HashRedeemed(txHash, from);
373         return true;
374     }
375     
376     /**
377      * @dev Called by a delegate with signed hash to approve a transaction for user.
378      * @dev All variables equivalent to transfer except _to:
379      * @param _to The address that will be approved to transfer COIN from user's wallet.
380     **/
381     function approvePreSigned(
382         bytes _signature,
383         address _to, 
384         uint256 _value,
385         uint256 _gasPrice, 
386         uint256 _nonce) 
387       public
388     returns (bool) 
389     {
390         uint256 gas = gasleft();
391         address from = recoverPreSigned(_signature, approveSig, _to, _value, "", _gasPrice, _nonce);
392         require(from != address(0), "Invalid signature provided.");
393 
394         bytes32 txHash = getPreSignedHash(approveSig, _to, _value, "", _gasPrice, _nonce);
395         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
396         invalidHashes[from][txHash] = true;
397 
398         require(_approve(from, _to, _value));
399 
400         if (_gasPrice > 0) {
401             gas = 35000 + gas.sub(gasleft());
402             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
403         }
404 
405         emit HashRedeemed(txHash, from);
406         return true;
407     }
408     
409     /**
410      * @dev Used to increase the amount allowed for "_to" to spend from "from"
411      * @dev A bare approve allows potentially nasty race conditions when using a delegate.
412     **/
413     function increaseApprovalPreSigned(
414         bytes _signature,
415         address _to, 
416         uint256 _value,
417         uint256 _gasPrice, 
418         uint256 _nonce)
419       public
420     returns (bool) 
421     {
422         uint256 gas = gasleft();
423         address from = recoverPreSigned(_signature, increaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
424         require(from != address(0), "Invalid signature provided.");
425 
426         bytes32 txHash = getPreSignedHash(increaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
427         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
428         invalidHashes[from][txHash] = true;
429 
430         require(_increaseApproval(from, _to, _value));
431 
432         if (_gasPrice > 0) {
433             gas = 35000 + gas.sub(gasleft());
434             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
435         }
436         
437         emit HashRedeemed(txHash, from);
438         return true;
439     }
440     
441     /**
442      * @dev Added for the same reason as increaseApproval. Decreases to 0 if "_value" is greater than allowed.
443     **/
444     function decreaseApprovalPreSigned(
445         bytes _signature,
446         address _to, 
447         uint256 _value, 
448         uint256 _gasPrice, 
449         uint256 _nonce) 
450       public
451     returns (bool) 
452     {
453         uint256 gas = gasleft();
454         address from = recoverPreSigned(_signature, decreaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
455         require(from != address(0), "Invalid signature provided.");
456 
457         bytes32 txHash = getPreSignedHash(decreaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
458         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
459         invalidHashes[from][txHash] = true;
460 
461         require(_decreaseApproval(from, _to, _value));
462 
463         if (_gasPrice > 0) {
464             gas = 35000 + gas.sub(gasleft());
465             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
466         }
467 
468         emit HashRedeemed(txHash, from);
469         return true;
470     }
471     
472     /**
473      * @dev approveAndCallPreSigned allows a user to approve a contract and call a function on it
474      * @dev in the same transaction. As with the other presigneds, a delegate calls this with signed data from user.
475      * @dev This function is the big reason we're using gas price and calculating gas use.
476      * @dev Using this with the investment contract can result in varying gas costs.
477      * @param _extraData The data to send to the contract.
478     **/
479     function approveAndCallPreSigned(
480         bytes _signature,
481         address _to, 
482         uint256 _value,
483         bytes _extraData,
484         uint256 _gasPrice,
485         uint256 _nonce) 
486       public
487     returns (bool) 
488     {
489         uint256 gas = gasleft();
490         address from = recoverPreSigned(_signature, approveAndCallSig, _to, _value, _extraData, _gasPrice, _nonce);
491         require(from != address(0), "Invalid signature provided.");
492 
493         bytes32 txHash = getPreSignedHash(approveAndCallSig, _to, _value, _extraData, _gasPrice, _nonce);
494         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
495         invalidHashes[from][txHash] = true;
496 
497         if (_value > 0) require(_approve(from, _to, _value));
498         ApproveAndCallFallBack(_to).receiveApproval(from, _value, address(this), _extraData);
499 
500         if (_gasPrice > 0) {
501             gas = 35000 + gas.sub(gasleft());
502             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
503         }
504         
505         emit HashRedeemed(txHash, from);
506         return true;
507     }
508 
509 /** *************************** Revoke PreSigned ************************** **/
510     
511     /**
512      * @dev Revoke hash without going through a delegate.
513      * @param _hashToRevoke The hash that you no longer want to be used.
514     **/
515     function revokeHash(bytes32 _hashToRevoke)
516       public
517     returns (bool)
518     {
519         invalidHashes[msg.sender][_hashToRevoke] = true;
520         return true;
521     }
522     
523     /**
524      * @dev Revoke hash through a delegate.
525      * @param _signature The signature allowing this revocation.
526      * @param _hashToRevoke The hash that you would like revoked.
527      * @param _gasPrice The amount of token wei to be paid for each uint of gas.
528     **/
529     function revokeHashPreSigned(
530         bytes _signature,
531         bytes32 _hashToRevoke,
532         uint256 _gasPrice)
533       public
534     returns (bool)
535     {
536         uint256 gas = gasleft();
537         address from = recoverRevokeHash(_signature, _hashToRevoke, _gasPrice);
538         require(from != address(0), "Invalid signature provided.");
539         
540         bytes32 txHash = getRevokeHash(_hashToRevoke, _gasPrice);
541         require(!invalidHashes[from][txHash], "Transaction has already been executed.");
542         invalidHashes[from][txHash] = true;
543 
544         invalidHashes[from][_hashToRevoke] = true;
545         
546         if (_gasPrice > 0) {
547             gas = 35000 + gas.sub(gasleft());
548             require(_transfer(from, tx.origin, _gasPrice.mul(gas)), "Gas cost could not be paid.");
549         }
550         
551         emit HashRedeemed(txHash, from);
552         return true;
553     }
554     
555     /**
556      * @dev Get hash for a revocation.
557      * @param _hashToRevoke The signature to be revoked.
558      * @param _gasPrice The amount to be paid to delegate for sending this tx.
559     **/
560     function getRevokeHash(bytes32 _hashToRevoke, uint256 _gasPrice)
561       public
562       view
563     returns (bytes32 txHash)
564     {
565         return keccak256(abi.encodePacked(address(this), revokeHashSig, _hashToRevoke, _gasPrice));
566     }
567 
568     /**
569      * @dev Recover the address from a revocation hash.
570      * @param _hashToRevoke The hash to be revoked.
571      * @param _signature The signature allowing this revocation.
572      * @param _gasPrice The amount of token wei to be paid for each unit of gas.
573     **/
574     function recoverRevokeHash(bytes _signature, bytes32 _hashToRevoke, uint256 _gasPrice)
575       public
576       view
577     returns (address from)
578     {
579         return ecrecoverFromSig(getSignHash(getRevokeHash(_hashToRevoke, _gasPrice)), _signature);
580     }
581     
582 /** ************************** PreSigned Constants ************************ **/
583 
584     /**
585      * @dev Used in frontend and contract to get hashed data of any given pre-signed transaction.
586      * @param _to The address to transfer COIN to.
587      * @param _value The amount of COIN to be transferred.
588      * @param _extraData Extra data of tx if needed. Transfers and approves will leave this null.
589      * @param _function Function signature of the pre-signed function being used.
590      * @param _gasPrice The agreed-upon amount of COIN to be paid per unit of gas.
591      * @param _nonce The user's nonce of the new transaction.
592     **/
593     function getPreSignedHash(
594         bytes4 _function,
595         address _to, 
596         uint256 _value,
597         bytes _extraData,
598         uint256 _gasPrice,
599         uint256 _nonce)
600       public
601       view
602     returns (bytes32 txHash) 
603     {
604         return keccak256(abi.encodePacked(address(this), _function, _to, _value, _extraData, _gasPrice, _nonce));
605     }
606     
607     /**
608      * @dev Recover an address from a signed pre-signed hash.
609      * @param _sig The signed hash.
610      * @param _function The function signature for function being called.
611      * @param _to The address to transfer/approve/transferFrom/etc. tokens to.
612      * @param _value The amont of tokens to transfer/approve/etc.
613      * @param _extraData The extra data included in the transaction, if any.
614      * @param _gasPrice The amount of token wei to be paid to the delegate for each unit of gas.
615      * @param _nonce The user's nonce for this transaction.
616     **/
617     function recoverPreSigned(
618         bytes _sig,
619         bytes4 _function,
620         address _to,
621         uint256 _value,
622         bytes _extraData,
623         uint256 _gasPrice,
624         uint256 _nonce) 
625       public
626       view
627     returns (address recovered)
628     {
629         return ecrecoverFromSig(getSignHash(getPreSignedHash(_function, _to, _value, _extraData, _gasPrice, _nonce)), _sig);
630     }
631     
632     /**
633      * @dev Add signature prefix to hash for recovery à la ERC191.
634      * @param _hash The hashed transaction to add signature prefix to.
635     **/
636     function getSignHash(bytes32 _hash)
637       public
638       pure
639     returns (bytes32 signHash)
640     {
641         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
642     }
643 
644     /**
645      * @dev Helps to reduce stack depth problems for delegations. Thank you to Bokky for this!
646      * @param hash The hash of signed data for the transaction.
647      * @param sig Contains r, s, and v for recovery of address from the hash.
648     **/
649     function ecrecoverFromSig(bytes32 hash, bytes sig) 
650       public 
651       pure 
652     returns (address recoveredAddress) 
653     {
654         bytes32 r;
655         bytes32 s;
656         uint8 v;
657         if (sig.length != 65) return address(0);
658         assembly {
659             r := mload(add(sig, 32))
660             s := mload(add(sig, 64))
661             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
662             // There is no 'mload8' to do this, but that would be nicer.
663             v := byte(0, mload(add(sig, 96)))
664         }
665         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
666         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
667         if (v < 27) v += 27;
668         if (v != 27 && v != 28) return address(0);
669         return ecrecover(hash, v, r, s);
670     }
671 
672 /** ****************************** Constants ******************************* **/
673     
674     /**
675      * @dev Return total supply of token.
676     **/
677     function totalSupply() 
678       external
679       view 
680      returns (uint256)
681     {
682         return _totalSupply;
683     }
684 
685     /**
686      * @dev Return balance of a certain address.
687      * @param _owner The address whose balance we want to check.
688     **/
689     function balanceOf(address _owner)
690       external
691       view 
692     returns (uint256) 
693     {
694         return balances[_owner];
695     }
696     
697     /**
698      * @dev Allowed amount for a user to spend of another's tokens.
699      * @param _owner The owner of the tokens approved to spend.
700      * @param _spender The address of the user allowed to spend the tokens.
701     **/
702     function allowance(address _owner, address _spender) 
703       external
704       view 
705     returns (uint256) 
706     {
707         return allowed[_owner][_spender];
708     }
709     
710 /** ****************************** onlyOwner ******************************* **/
711     
712     /**
713      * @dev Allow the owner to take ERC20 tokens off of this contract if they are accidentally sent.
714     **/
715     function tokenEscape(address _tokenContract)
716       external
717       onlyOwner
718     {
719         CoinToken lostToken = CoinToken(_tokenContract);
720         
721         uint256 stuckTokens = lostToken.balanceOf(address(this));
722         lostToken.transfer(owner, stuckTokens);
723     }
724     
725 }