1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6 **/
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
37 **/
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   constructor() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner public {
64     require(newOwner != address(0));
65     emit OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 /**
72  * @dev Abstract contract for approveAndCall.
73 **/
74 contract ApproveAndCallFallBack {
75     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
76 }
77 
78 /**
79  * @title Game Tester Token
80  * @dev ERC20 contract utilizing ERC865-ish structure (based on the CoinvestTokenV2 contract)
81  * @dev to allow users to pay Ethereum fees in tokens.
82 **/
83 contract GameTesterToken is Ownable {
84     using SafeMathLib for uint256;
85     
86     string public constant symbol = "GTCOIN";
87     string public constant name = "Game Tester";
88     
89     uint8 public constant decimals = 18;
90     uint256 private _totalSupply = 100000000 * (10 ** 18);
91     
92     // Function sigs to be used within contract for signature recovery.
93     bytes4 internal constant transferSig = 0xa9059cbb;
94     bytes4 internal constant approveSig = 0x095ea7b3;
95     bytes4 internal constant increaseApprovalSig = 0xd73dd623;
96     bytes4 internal constant decreaseApprovalSig = 0x66188463;
97     bytes4 internal constant approveAndCallSig = 0xcae9ca51;
98     bytes4 internal constant revokeSignatureSig = 0xe40d89e5;
99 
100     // Balances for each account
101     mapping(address => uint256) balances;
102 
103     // Owner of account approves the transfer of an amount to another account
104     mapping(address => mapping (address => uint256)) allowed;
105     
106     // Keeps track of the last nonce sent from user. Used for delegated functions.
107     mapping (address => uint256) nonces;
108     
109     // Mapping of past used hashes: true if already used.
110     mapping (address => mapping (bytes => bool)) invalidSignatures;
111 
112     // Mapping of finalized ERC865 standard sigs => our function sigs for future-proofing
113     mapping (bytes4 => bytes4) public standardSigs;
114 
115     event Transfer(address indexed from, address indexed to, uint tokens);
116     event Approval(address indexed from, address indexed spender, uint tokens);
117     event SignatureRedeemed(bytes _sig, address indexed from);
118     
119     /**
120      * @dev Set owner and beginning balance.
121     **/
122     constructor()
123       public
124     {
125         balances[msg.sender] = _totalSupply;
126     }
127     
128     /**
129      * @dev This code allows us to redirect pre-signed calls with different function selectors to our own.
130     **/
131     function () 
132       public
133     {
134         bytes memory calldata = msg.data;
135         bytes4 new_selector = standardSigs[msg.sig];
136         require(new_selector != 0);
137         
138         assembly {
139            mstore(add(0x20, calldata), new_selector)
140         }
141         
142         require(address(this).delegatecall(calldata));
143         
144         assembly {
145             if iszero(eq(returndatasize, 0x20)) { revert(0, 0) }
146             returndatacopy(0, 0, returndatasize)
147             return(0, returndatasize)
148         }
149     }
150 
151 /** ******************************** ERC20 ********************************* **/
152 
153     /**
154      * @dev Transfers coins from one address to another.
155      * @param _to The recipient of the transfer amount.
156      * @param _amount The amount of tokens to transfer.
157     **/
158     function transfer(address _to, uint256 _amount) 
159       public
160     returns (bool success)
161     {
162         require(_transfer(msg.sender, _to, _amount));
163         return true;
164     }
165     
166     /**
167      * @dev An allowed address can transfer tokens from another's address.
168      * @param _from The owner of the tokens to be transferred.
169      * @param _to The address to which the tokens will be transferred.
170      * @param _amount The amount of tokens to be transferred.
171     **/
172     function transferFrom(address _from, address _to, uint _amount)
173       public
174     returns (bool success)
175     {
176         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
177 
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
179         require(_transfer(_from, _to, _amount));
180         return true;
181     }
182     
183     /**
184      * @dev Approves a wallet to transfer tokens on one's behalf.
185      * @param _spender The wallet approved to spend tokens.
186      * @param _amount The amount of tokens approved to spend.
187     **/
188     function approve(address _spender, uint256 _amount) 
189       public
190     returns (bool success)
191     {
192         require(_approve(msg.sender, _spender, _amount));
193         return true;
194     }
195     
196     /**
197      * @dev Increases the allowed amount for spender from msg.sender.
198      * @param _spender The address to increase allowed amount for.
199      * @param _amount The amount of tokens to increase allowed amount by.
200     **/
201     function increaseApproval(address _spender, uint256 _amount) 
202       public
203     returns (bool success)
204     {
205         require(_increaseApproval(msg.sender, _spender, _amount));
206         return true;
207     }
208     
209     /**
210      * @dev Decreases the allowed amount for spender from msg.sender.
211      * @param _spender The address to decrease allowed amount for.
212      * @param _amount The amount of tokens to decrease allowed amount by.
213     **/
214     function decreaseApproval(address _spender, uint256 _amount) 
215       public
216     returns (bool success)
217     {
218         require(_decreaseApproval(msg.sender, _spender, _amount));
219         return true;
220     }
221     
222     /**
223      * @dev Used to approve an address and call a function on it in the same transaction.
224      * @dev _spender The address to be approved to spend GTCOIN.
225      * @dev _amount The amount of GTCOIN to be approved to spend.
226      * @dev _data The data to send to the called contract.
227     **/
228     function approveAndCall(address _spender, uint256 _amount, bytes _data) 
229       public
230     returns (bool success) 
231     {
232         require(_approve(msg.sender, _spender, _amount));
233         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
234         return true;
235     }
236 
237 /** ****************************** Internal ******************************** **/
238     
239     /**
240      * @dev Internal transfer for all functions that transfer.
241      * @param _from The address that is transferring coins.
242      * @param _to The receiving address of the coins.
243      * @param _amount The amount of coins being transferred.
244     **/
245     function _transfer(address _from, address _to, uint256 _amount)
246       internal
247     returns (bool success)
248     {
249         require (_to != address(0));
250         require(balances[_from] >= _amount);
251         
252         balances[_from] = balances[_from].sub(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         
255         emit Transfer(_from, _to, _amount);
256         return true;
257     }
258     
259     /**
260      * @dev Internal approve for all functions that require an approve.
261      * @param _owner The owner who is allowing spender to use their balance.
262      * @param _spender The wallet approved to spend tokens.
263      * @param _amount The amount of tokens approved to spend.
264     **/
265     function _approve(address _owner, address _spender, uint256 _amount) 
266       internal
267     returns (bool success)
268     {
269         allowed[_owner][_spender] = _amount;
270         emit Approval(_owner, _spender, _amount);
271         return true;
272     }
273     
274     /**
275      * @dev Increases the allowed by "_amount" for "_spender" from "owner"
276      * @param _owner The address that tokens may be transferred from.
277      * @param _spender The address that may transfer these tokens.
278      * @param _amount The amount of tokens to transfer.
279     **/
280     function _increaseApproval(address _owner, address _spender, uint256 _amount)
281       internal
282     returns (bool success)
283     {
284         allowed[_owner][_spender] = allowed[_owner][_spender].add(_amount);
285         emit Approval(_owner, _spender, allowed[_owner][_spender]);
286         return true;
287     }
288     
289     /**
290      * @dev Decreases the allowed by "_amount" for "_spender" from "_owner"
291      * @param _owner The owner of the tokens to decrease allowed for.
292      * @param _spender The spender whose allowed will decrease.
293      * @param _amount The amount of tokens to decrease allowed by.
294     **/
295     function _decreaseApproval(address _owner, address _spender, uint256 _amount)
296       internal
297     returns (bool success)
298     {
299         if (allowed[_owner][_spender] <= _amount) allowed[_owner][_spender] = 0;
300         else allowed[_owner][_spender] = allowed[_owner][_spender].sub(_amount);
301         
302         emit Approval(_owner, _spender, allowed[_owner][_spender]);
303         return true;
304     }
305     
306 /** ************************ Delegated Functions *************************** **/
307 
308     /**
309      * @dev Called by delegate with a signed hash of the transaction data to allow a user
310      * @dev to transfer tokens without paying gas in Ether (they pay in GTCOIN instead).
311      * @param _signature Signed hash of data for this transfer.
312      * @param _to The address to transfer GTCOIN to.
313      * @param _value The amount of GTCOIN to transfer.
314      * @param _gasPrice Price (IN GTCOIN) that will be paid per unit of gas by user to "delegate".
315      * @param _nonce Nonce of the user's new transaction (to make signatures unique, not to be confused with address transaction nonce).
316     **/
317     function transferPreSigned(
318         bytes _signature,
319         address _to, 
320         uint256 _value, 
321         uint256 _gasPrice, 
322         uint256 _nonce) 
323       public
324       validPayload(292)
325     returns (bool) 
326     {
327         // Log starting gas left of transaction for later gas price calculations.
328         uint256 gas = gasleft();
329         
330         // Recover signer address from signature; ensure address is valid.
331         address from = recoverPreSigned(_signature, transferSig, _to, _value, "", _gasPrice, _nonce);
332         require(from != address(0));
333         
334         // Require the hash has not been used, declare it used, increment nonce.
335         require(!invalidSignatures[from][_signature]);
336         invalidSignatures[from][_signature] = true;
337         nonces[from]++;
338         
339         // Internal transfer.
340         require(_transfer(from, _to, _value));
341 
342         // If the delegate is charging, pay them for gas in GTCOIN.
343         if (_gasPrice > 0) {
344             
345             // 35000 because of base fee of 21000 and ~14000 for the fee transfer.
346             gas = 35000 + gas.sub(gasleft());
347             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
348         }
349         
350         emit SignatureRedeemed(_signature, from);
351         return true;
352     }
353     
354     /**
355      * @dev Called by a delegate with signed hash to approve a transaction for user.
356      * @dev All variables equivalent to transfer except _to:
357      * @param _to The address that will be approved to transfer GTCOIN from user's wallet.
358     **/
359     function approvePreSigned(
360         bytes _signature,
361         address _to, 
362         uint256 _value, 
363         uint256 _gasPrice, 
364         uint256 _nonce) 
365       public
366       validPayload(292)
367     returns (bool) 
368     {
369         uint256 gas = gasleft();
370         address from = recoverPreSigned(_signature, approveSig, _to, _value, "", _gasPrice, _nonce);
371         require(from != address(0));
372         require(!invalidSignatures[from][_signature]);
373         
374         invalidSignatures[from][_signature] = true;
375         nonces[from]++;
376         
377         require(_approve(from, _to, _value));
378 
379         if (_gasPrice > 0) {
380             gas = 35000 + gas.sub(gasleft());
381             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
382         }
383         
384         emit SignatureRedeemed(_signature, from);
385         return true;
386     }
387     
388     /**
389      * @dev Used to increase the amount allowed for "_to" to spend from "from"
390      * @dev A bare approve allows potentially nasty race conditions when using a delegate.
391     **/
392     function increaseApprovalPreSigned(
393         bytes _signature,
394         address _to, 
395         uint256 _value, 
396         uint256 _gasPrice, 
397         uint256 _nonce)
398       public
399       validPayload(292)
400     returns (bool) 
401     {
402         uint256 gas = gasleft();
403         address from = recoverPreSigned(_signature, increaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
404         require(from != address(0));
405         require(!invalidSignatures[from][_signature]);
406         
407         invalidSignatures[from][_signature] = true;
408         nonces[from]++;
409         
410         require(_increaseApproval(from, _to, _value));
411 
412         if (_gasPrice > 0) {
413             gas = 35000 + gas.sub(gasleft());
414             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
415         }
416         
417         emit SignatureRedeemed(_signature, from);
418         return true;
419     }
420     
421     /**
422      * @dev Added for the same reason as increaseApproval. Decreases to 0 if "_value" is greater than allowed.
423     **/
424     function decreaseApprovalPreSigned(
425         bytes _signature,
426         address _to, 
427         uint256 _value, 
428         uint256 _gasPrice, 
429         uint256 _nonce) 
430       public
431       validPayload(292)
432     returns (bool) 
433     {
434         uint256 gas = gasleft();
435         address from = recoverPreSigned(_signature, decreaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
436         require(from != address(0));
437         require(!invalidSignatures[from][_signature]);
438         
439         invalidSignatures[from][_signature] = true;
440         nonces[from]++;
441         
442         require(_decreaseApproval(from, _to, _value));
443 
444         if (_gasPrice > 0) {
445             gas = 35000 + gas.sub(gasleft());
446             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
447         }
448         
449         emit SignatureRedeemed(_signature, from);
450         return true;
451     }
452     
453     /**
454      * @dev approveAndCallPreSigned allows a user to approve a contract and call a function on it
455      * @dev in the same transaction. As with the other presigneds, a delegate calls this with signed data from user.
456      * @dev This function is the big reason we're using gas price and calculating gas use.
457      * @dev Using this with the contract can result in varying gas costs.
458      * @param _extraData The data to send to the contract.
459     **/
460     function approveAndCallPreSigned(
461         bytes _signature,
462         address _to, 
463         uint256 _value,
464         bytes _extraData,
465         uint256 _gasPrice, 
466         uint256 _nonce) 
467       public
468       validPayload(356)
469     returns (bool) 
470     {
471         uint256 gas = gasleft();
472         address from = recoverPreSigned(_signature, approveAndCallSig, _to, _value, _extraData, _gasPrice, _nonce);
473         require(from != address(0));
474         require(!invalidSignatures[from][_signature]);
475         
476         invalidSignatures[from][_signature] = true;
477         nonces[from]++;
478         
479         require(_approve(from, _to, _value));
480         ApproveAndCallFallBack(_to).receiveApproval(from, _value, address(this), _extraData);
481 
482         if (_gasPrice > 0) {
483             gas = 35000 + gas.sub(gasleft());
484             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
485         }
486         
487         emit SignatureRedeemed(_signature, from);
488         return true;
489     }
490 
491 /** *************************** Revoke PreSigned ************************** **/
492     
493     /**
494      * @dev Revoke signature without going through a delegate.
495      * @param _sigToRevoke The signature that you no longer want to be used.
496     **/
497     function revokeSignature(bytes _sigToRevoke)
498       public
499     returns (bool)
500     {
501         invalidSignatures[msg.sender][_sigToRevoke] = true;
502         
503         emit SignatureRedeemed(_sigToRevoke, msg.sender);
504         return true;
505     }
506     
507     /**
508      * @dev Revoke signature through a delegate.
509      * @param _signature The signature allowing this revocation.
510      * @param _sigToRevoke The signature that you would like revoked.
511      * @param _gasPrice The amount of token wei to be paid for each uint of gas.
512     **/
513     function revokeSignaturePreSigned(
514         bytes _signature,
515         bytes _sigToRevoke,
516         uint256 _gasPrice)
517       public
518       validPayload(356)
519     returns (bool)
520     {
521         uint256 gas = gasleft();
522         address from = recoverRevokeHash(_signature, _sigToRevoke, _gasPrice);
523         require(!invalidSignatures[from][_signature]);
524         invalidSignatures[from][_signature] = true;
525         
526         invalidSignatures[from][_sigToRevoke] = true;
527         
528         if (_gasPrice > 0) {
529             gas = 35000 + gas.sub(gasleft());
530             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
531         }
532         
533         emit SignatureRedeemed(_signature, from);
534         return true;
535     }
536     
537     /**
538      * @dev Get hash for a revocation.
539      * @param _sigToRevoke The signature to be revoked.
540      * @param _gasPrice The amount to be paid to delegate for sending this tx.
541     **/
542     function getRevokeHash(bytes _sigToRevoke, uint256 _gasPrice)
543       public
544       pure
545     returns (bytes32 txHash)
546     {
547         return keccak256(revokeSignatureSig, _sigToRevoke, _gasPrice);
548     }
549 
550     /**
551      * @dev Recover the address from a revocation signature.
552      * @param _sigToRevoke The signature to be revoked.
553      * @param _signature The signature allowing this revocation.
554      * @param _gasPrice The amount of token wei to be paid for each unit of gas.
555     **/
556     function recoverRevokeHash(bytes _signature, bytes _sigToRevoke, uint256 _gasPrice)
557       public
558       pure
559     returns (address from)
560     {
561         return ecrecoverFromSig(getSignHash(getRevokeHash(_sigToRevoke, _gasPrice)), _signature);
562     }
563     
564 /** ************************** PreSigned Constants ************************ **/
565 
566     /**
567      * @dev Used in frontend and contract to get hashed data of any given pre-signed transaction.
568      * @param _to The address to transfer GTCOIN to.
569      * @param _value The amount of GTCOIN to be transferred.
570      * @param _extraData Extra data of tx if needed. Transfers and approves will leave this null.
571      * @param _function Function signature of the pre-signed function being used.
572      * @param _gasPrice The agreed-upon amount of GTCOIN to be paid per unit of gas.
573      * @param _nonce The user's nonce of the new transaction.
574     **/
575     function getPreSignedHash(
576         bytes4 _function,
577         address _to, 
578         uint256 _value,
579         bytes _extraData,
580         uint256 _gasPrice,
581         uint256 _nonce)
582       public
583       view
584     returns (bytes32 txHash) 
585     {
586         return keccak256(address(this), _function, _to, _value, _extraData, _gasPrice, _nonce);
587     }
588     
589     /**
590      * @dev Recover an address from a signed pre-signed hash.
591      * @param _sig The signed hash.
592      * @param _function The function signature for function being called.
593      * @param _to The address to transfer/approve/transferFrom/etc. tokens to.
594      * @param _value The amont of tokens to transfer/approve/etc.
595      * @param _extraData The extra data included in the transaction, if any.
596      * @param _gasPrice The amount of token wei to be paid to the delegate for each unit of gas.
597      * @param _nonce The user's nonce for this transaction.
598     **/
599     function recoverPreSigned(
600         bytes _sig,
601         bytes4 _function,
602         address _to,
603         uint256 _value,
604         bytes _extraData,
605         uint256 _gasPrice,
606         uint256 _nonce) 
607       public
608       view
609     returns (address recovered)
610     {
611         return ecrecoverFromSig(getSignHash(getPreSignedHash(_function, _to, _value, _extraData, _gasPrice, _nonce)), _sig);
612     }
613     
614     /**
615      * @dev Add signature prefix to hash for recovery à la ERC191.
616      * @param _hash The hashed transaction to add signature prefix to.
617     **/
618     function getSignHash(bytes32 _hash)
619       public
620       pure
621     returns (bytes32 signHash)
622     {
623         return keccak256("\x19Ethereum Signed Message:\n32", _hash);
624     }
625 
626     /**
627      * @param hash The hash of signed data for the transaction.
628      * @param sig Contains r, s, and v for recovery of address from the hash.
629     **/
630     function ecrecoverFromSig(bytes32 hash, bytes sig) 
631       public 
632       pure 
633     returns (address recoveredAddress) 
634     {
635         bytes32 r;
636         bytes32 s;
637         uint8 v;
638         if (sig.length != 65) return address(0);
639         assembly {
640             r := mload(add(sig, 32))
641             s := mload(add(sig, 64))
642             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
643             // There is no 'mload8' to do this, but that would be nicer.
644             v := byte(0, mload(add(sig, 96)))
645         }
646         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
647         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
648         if (v < 27) {
649           v += 27;
650         }
651         if (v != 27 && v != 28) return address(0);
652         return ecrecover(hash, v, r, s);
653     }
654 
655     /**
656      * @dev Frontend queries to find the next nonce of the user so they can find the new nonce to send.
657      * @param _owner Address that will be sending the GTCOIN.
658     **/
659     function getNonce(address _owner)
660       external
661       view
662     returns (uint256 nonce)
663     {
664         return nonces[_owner];
665     }
666     
667 /** ****************************** Constants ******************************* **/
668     
669     /**
670      * @dev Return total supply of token.
671     **/
672     function totalSupply() 
673       external
674       view 
675      returns (uint256)
676     {
677         return _totalSupply;
678     }
679 
680     /**
681      * @dev Return balance of a certain address.
682      * @param _owner The address whose balance we want to check.
683     **/
684     function balanceOf(address _owner)
685       external
686       view 
687     returns (uint256) 
688     {
689         return balances[_owner];
690     }
691     
692     /**
693      * @dev Allowed amount for a user to spend of another's tokens.
694      * @param _owner The owner of the tokens approved to spend.
695      * @param _spender The address of the user allowed to spend the tokens.
696     **/
697     function allowance(address _owner, address _spender) 
698       external
699       view 
700     returns (uint256) 
701     {
702         return allowed[_owner][_spender];
703     }
704     
705 /** ****************************** onlyOwner ******************************* **/
706     
707     /**
708      * @dev Allow the owner to take ERC20 tokens off of this contract if they are accidentally sent.
709     **/
710     function token_escape(address _tokenContract)
711       external
712       onlyOwner
713     {
714         GameTesterToken lostToken = GameTesterToken(_tokenContract);
715         
716         uint256 stuckTokens = lostToken.balanceOf(address(this));
717         lostToken.transfer(owner, stuckTokens);
718     }
719     
720     /**
721      * @dev Owner may set the standard sig to redirect to one of our pre-signed functions.
722      * @dev Added in order to prepare for the ERC865 standard function names to be different from ours.
723      * @param _standardSig The function signature of the finalized standard function.
724      * @param _ourSig The function signature of our implemented function.
725     **/
726     function updateStandard(bytes4 _standardSig, bytes4 _ourSig)
727       external
728       onlyOwner
729     returns (bool success)
730     {
731         // These 6 are the signatures of our pre-signed functions.
732         require(_ourSig == 0x1296830d || _ourSig == 0x617b390b || _ourSig == 0xadb8249e ||
733             _ourSig == 0x8be52783 || _ourSig == 0xc8d4b389 || _ourSig == 0xe391a7c4);
734         standardSigs[_standardSig] = _ourSig;
735         return true;
736     }
737     
738 /** ***************************** Modifiers ******************************** **/
739     
740     modifier validPayload(uint _size) {
741         uint payload_size;
742         assembly {
743             payload_size := calldatasize
744         }
745         require(payload_size >= _size);
746         _;
747     }
748     
749 }