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
47   function Ownable() public {
48     owner = 0x4e70812b550687692e18F53445C601458228aFfD;
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
72  * @dev Contract used to deploy COIN V2 and allow users to swap V1 for V2.
73 **/
74 contract TokenSwap {
75     
76     // Address of the old Coinvest COIN token.
77     address public constant OLD_TOKEN = 0x4306ce4a5d8b21ee158cb8396a4f6866f14d6ac8;
78     
79     // Address of the new COINVEST COIN V2 token (to be launched on construction).
80     CoinvestToken public newToken;
81 
82     constructor() 
83       public 
84     {
85         newToken = new CoinvestToken();
86     }
87 
88     /**
89      * @dev Only function. ERC223 transfer from old token to this contract calls this.
90      * @param _from The address that has transferred this contract tokens.
91      * @param _value The amount of tokens that have been transferred.
92      * @param _data The extra data sent with transfer (should be nothing).
93     **/
94     function tokenFallback(address _from, uint _value, bytes _data) 
95       external
96     {
97         require(msg.sender == OLD_TOKEN);          // Ensure caller is old token contract.
98         require(newToken.transfer(_from, _value)); // Transfer new tokens to sender.
99     }
100     
101 }
102     
103 /**
104  * @dev Abstract contract for approveAndCall.
105 **/
106 contract ApproveAndCallFallBack {
107     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
108 }
109 
110 /**
111  * @title Coinvest COIN Token
112  * @dev ERC20 contract utilizing ERC865-ish structure (3esmit's implementation with alterations).
113  * @dev to allow users to pay Ethereum fees in tokens.
114 **/
115 contract CoinvestToken is Ownable {
116     using SafeMathLib for uint256;
117     
118     string public constant symbol = "COIN";
119     string public constant name = "Coinvest COIN V2 Token";
120     
121     uint8 public constant decimals = 18;
122     uint256 private _totalSupply = 107142857 * (10 ** 18);
123     
124     // Function sigs to be used within contract for signature recovery.
125     bytes4 internal constant transferSig = 0xa9059cbb;
126     bytes4 internal constant approveSig = 0x095ea7b3;
127     bytes4 internal constant increaseApprovalSig = 0xd73dd623;
128     bytes4 internal constant decreaseApprovalSig = 0x66188463;
129     bytes4 internal constant approveAndCallSig = 0xcae9ca51;
130     bytes4 internal constant revokeSignatureSig = 0xe40d89e5;
131 
132     // Balances for each account
133     mapping(address => uint256) balances;
134 
135     // Owner of account approves the transfer of an amount to another account
136     mapping(address => mapping (address => uint256)) allowed;
137     
138     // Keeps track of the last nonce sent from user. Used for delegated functions.
139     mapping (address => uint256) nonces;
140     
141     // Mapping of past used hashes: true if already used.
142     mapping (address => mapping (bytes => bool)) invalidSignatures;
143 
144     // Mapping of finalized ERC865 standard sigs => our function sigs for future-proofing
145     mapping (bytes4 => bytes4) public standardSigs;
146 
147     event Transfer(address indexed from, address indexed to, uint tokens);
148     event Approval(address indexed from, address indexed spender, uint tokens);
149     event SignatureRedeemed(bytes _sig, address indexed from);
150     
151     /**
152      * @dev Set owner and beginning balance.
153     **/
154     constructor()
155       public
156     {
157         balances[msg.sender] = _totalSupply;
158     }
159     
160     /**
161      * @dev This code allows us to redirect pre-signed calls with different function selectors to our own.
162     **/
163     function () 
164       public
165     {
166         bytes memory calldata = msg.data;
167         bytes4 new_selector = standardSigs[msg.sig];
168         require(new_selector != 0);
169         
170         assembly {
171            mstore(add(0x20, calldata), new_selector)
172         }
173         
174         require(address(this).delegatecall(calldata));
175         
176         assembly {
177             if iszero(eq(returndatasize, 0x20)) { revert(0, 0) }
178             returndatacopy(0, 0, returndatasize)
179             return(0, returndatasize)
180         }
181     }
182 
183 /** ******************************** ERC20 ********************************* **/
184 
185     /**
186      * @dev Transfers coins from one address to another.
187      * @param _to The recipient of the transfer amount.
188      * @param _amount The amount of tokens to transfer.
189     **/
190     function transfer(address _to, uint256 _amount) 
191       public
192     returns (bool success)
193     {
194         require(_transfer(msg.sender, _to, _amount));
195         return true;
196     }
197     
198     /**
199      * @dev An allowed address can transfer tokens from another's address.
200      * @param _from The owner of the tokens to be transferred.
201      * @param _to The address to which the tokens will be transferred.
202      * @param _amount The amount of tokens to be transferred.
203     **/
204     function transferFrom(address _from, address _to, uint _amount)
205       public
206     returns (bool success)
207     {
208         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
209 
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
211         require(_transfer(_from, _to, _amount));
212         return true;
213     }
214     
215     /**
216      * @dev Approves a wallet to transfer tokens on one's behalf.
217      * @param _spender The wallet approved to spend tokens.
218      * @param _amount The amount of tokens approved to spend.
219     **/
220     function approve(address _spender, uint256 _amount) 
221       public
222     returns (bool success)
223     {
224         require(_approve(msg.sender, _spender, _amount));
225         return true;
226     }
227     
228     /**
229      * @dev Increases the allowed amount for spender from msg.sender.
230      * @param _spender The address to increase allowed amount for.
231      * @param _amount The amount of tokens to increase allowed amount by.
232     **/
233     function increaseApproval(address _spender, uint256 _amount) 
234       public
235     returns (bool success)
236     {
237         require(_increaseApproval(msg.sender, _spender, _amount));
238         return true;
239     }
240     
241     /**
242      * @dev Decreases the allowed amount for spender from msg.sender.
243      * @param _spender The address to decrease allowed amount for.
244      * @param _amount The amount of tokens to decrease allowed amount by.
245     **/
246     function decreaseApproval(address _spender, uint256 _amount) 
247       public
248     returns (bool success)
249     {
250         require(_decreaseApproval(msg.sender, _spender, _amount));
251         return true;
252     }
253     
254     /**
255      * @dev Used to approve an address and call a function on it in the same transaction.
256      * @dev _spender The address to be approved to spend COIN.
257      * @dev _amount The amount of COIN to be approved to spend.
258      * @dev _data The data to send to the called contract.
259     **/
260     function approveAndCall(address _spender, uint256 _amount, bytes _data) 
261       public
262     returns (bool success) 
263     {
264         require(_approve(msg.sender, _spender, _amount));
265         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
266         return true;
267     }
268 
269 /** ****************************** Internal ******************************** **/
270     
271     /**
272      * @dev Internal transfer for all functions that transfer.
273      * @param _from The address that is transferring coins.
274      * @param _to The receiving address of the coins.
275      * @param _amount The amount of coins being transferred.
276     **/
277     function _transfer(address _from, address _to, uint256 _amount)
278       internal
279     returns (bool success)
280     {
281         require (_to != address(0));
282         require(balances[_from] >= _amount);
283         
284         balances[_from] = balances[_from].sub(_amount);
285         balances[_to] = balances[_to].add(_amount);
286         
287         emit Transfer(_from, _to, _amount);
288         return true;
289     }
290     
291     /**
292      * @dev Internal approve for all functions that require an approve.
293      * @param _owner The owner who is allowing spender to use their balance.
294      * @param _spender The wallet approved to spend tokens.
295      * @param _amount The amount of tokens approved to spend.
296     **/
297     function _approve(address _owner, address _spender, uint256 _amount) 
298       internal
299     returns (bool success)
300     {
301         allowed[_owner][_spender] = _amount;
302         emit Approval(_owner, _spender, _amount);
303         return true;
304     }
305     
306     /**
307      * @dev Increases the allowed by "_amount" for "_spender" from "owner"
308      * @param _owner The address that tokens may be transferred from.
309      * @param _spender The address that may transfer these tokens.
310      * @param _amount The amount of tokens to transfer.
311     **/
312     function _increaseApproval(address _owner, address _spender, uint256 _amount)
313       internal
314     returns (bool success)
315     {
316         allowed[_owner][_spender] = allowed[_owner][_spender].add(_amount);
317         emit Approval(_owner, _spender, allowed[_owner][_spender]);
318         return true;
319     }
320     
321     /**
322      * @dev Decreases the allowed by "_amount" for "_spender" from "_owner"
323      * @param _owner The owner of the tokens to decrease allowed for.
324      * @param _spender The spender whose allowed will decrease.
325      * @param _amount The amount of tokens to decrease allowed by.
326     **/
327     function _decreaseApproval(address _owner, address _spender, uint256 _amount)
328       internal
329     returns (bool success)
330     {
331         if (allowed[_owner][_spender] <= _amount) allowed[_owner][_spender] = 0;
332         else allowed[_owner][_spender] = allowed[_owner][_spender].sub(_amount);
333         
334         emit Approval(_owner, _spender, allowed[_owner][_spender]);
335         return true;
336     }
337     
338 /** ************************ Delegated Functions *************************** **/
339 
340     /**
341      * @dev Called by delegate with a signed hash of the transaction data to allow a user
342      * @dev to transfer tokens without paying gas in Ether (they pay in COIN instead).
343      * @param _signature Signed hash of data for this transfer.
344      * @param _to The address to transfer COIN to.
345      * @param _value The amount of COIN to transfer.
346      * @param _gasPrice Price (IN COIN) that will be paid per unit of gas by user to "delegate".
347      * @param _nonce Nonce of the user's new transaction.
348     **/
349     function transferPreSigned(
350         bytes _signature,
351         address _to, 
352         uint256 _value, 
353         uint256 _gasPrice, 
354         uint256 _nonce) 
355       public
356       validPayload(292)
357     returns (bool) 
358     {
359         // Log starting gas left of transaction for later gas price calculations.
360         uint256 gas = gasleft();
361         
362         // Recover signer address from signature; ensure address is valid.
363         address from = recoverPreSigned(_signature, transferSig, _to, _value, "", _gasPrice, _nonce);
364         require(from != address(0));
365         
366         // Require the hash has not been used, declare it used, increment nonce.
367         require(!invalidSignatures[from][_signature]);
368         invalidSignatures[from][_signature] = true;
369         nonces[from]++;
370         
371         // Internal transfer.
372         require(_transfer(from, _to, _value));
373 
374         // If the delegate is charging, pay them for gas in COIN.
375         if (_gasPrice > 0) {
376             
377             // 35000 because of base fee of 21000 and ~14000 for the fee transfer.
378             gas = 35000 + gas.sub(gasleft());
379             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
380         }
381         
382         emit SignatureRedeemed(_signature, from);
383         return true;
384     }
385     
386     /**
387      * @dev Called by a delegate with signed hash to approve a transaction for user.
388      * @dev All variables equivalent to transfer except _to:
389      * @param _to The address that will be approved to transfer COIN from user's wallet.
390     **/
391     function approvePreSigned(
392         bytes _signature,
393         address _to, 
394         uint256 _value, 
395         uint256 _gasPrice, 
396         uint256 _nonce) 
397       public
398       validPayload(292)
399     returns (bool) 
400     {
401         uint256 gas = gasleft();
402         address from = recoverPreSigned(_signature, approveSig, _to, _value, "", _gasPrice, _nonce);
403         require(from != address(0));
404         require(!invalidSignatures[from][_signature]);
405         
406         invalidSignatures[from][_signature] = true;
407         nonces[from]++;
408         
409         require(_approve(from, _to, _value));
410 
411         if (_gasPrice > 0) {
412             gas = 35000 + gas.sub(gasleft());
413             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
414         }
415         
416         emit SignatureRedeemed(_signature, from);
417         return true;
418     }
419     
420     /**
421      * @dev Used to increase the amount allowed for "_to" to spend from "from"
422      * @dev A bare approve allows potentially nasty race conditions when using a delegate.
423     **/
424     function increaseApprovalPreSigned(
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
435         address from = recoverPreSigned(_signature, increaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
436         require(from != address(0));
437         require(!invalidSignatures[from][_signature]);
438         
439         invalidSignatures[from][_signature] = true;
440         nonces[from]++;
441         
442         require(_increaseApproval(from, _to, _value));
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
454      * @dev Added for the same reason as increaseApproval. Decreases to 0 if "_value" is greater than allowed.
455     **/
456     function decreaseApprovalPreSigned(
457         bytes _signature,
458         address _to, 
459         uint256 _value, 
460         uint256 _gasPrice, 
461         uint256 _nonce) 
462       public
463       validPayload(292)
464     returns (bool) 
465     {
466         uint256 gas = gasleft();
467         address from = recoverPreSigned(_signature, decreaseApprovalSig, _to, _value, "", _gasPrice, _nonce);
468         require(from != address(0));
469         require(!invalidSignatures[from][_signature]);
470         
471         invalidSignatures[from][_signature] = true;
472         nonces[from]++;
473         
474         require(_decreaseApproval(from, _to, _value));
475 
476         if (_gasPrice > 0) {
477             gas = 35000 + gas.sub(gasleft());
478             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
479         }
480         
481         emit SignatureRedeemed(_signature, from);
482         return true;
483     }
484     
485     /**
486      * @dev approveAndCallPreSigned allows a user to approve a contract and call a function on it
487      * @dev in the same transaction. As with the other presigneds, a delegate calls this with signed data from user.
488      * @dev This function is the big reason we're using gas price and calculating gas use.
489      * @dev Using this with the investment contract can result in varying gas costs.
490      * @param _extraData The data to send to the contract.
491     **/
492     function approveAndCallPreSigned(
493         bytes _signature,
494         address _to, 
495         uint256 _value,
496         bytes _extraData,
497         uint256 _gasPrice, 
498         uint256 _nonce) 
499       public
500       validPayload(356)
501     returns (bool) 
502     {
503         uint256 gas = gasleft();
504         address from = recoverPreSigned(_signature, approveAndCallSig, _to, _value, _extraData, _gasPrice, _nonce);
505         require(from != address(0));
506         require(!invalidSignatures[from][_signature]);
507         
508         invalidSignatures[from][_signature] = true;
509         nonces[from]++;
510         
511         require(_approve(from, _to, _value));
512         ApproveAndCallFallBack(_to).receiveApproval(from, _value, address(this), _extraData);
513 
514         if (_gasPrice > 0) {
515             gas = 35000 + gas.sub(gasleft());
516             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
517         }
518         
519         emit SignatureRedeemed(_signature, from);
520         return true;
521     }
522 
523 /** *************************** Revoke PreSigned ************************** **/
524     
525     /**
526      * @dev Revoke signature without going through a delegate.
527      * @param _sigToRevoke The signature that you no longer want to be used.
528     **/
529     function revokeSignature(bytes _sigToRevoke)
530       public
531     returns (bool)
532     {
533         invalidSignatures[msg.sender][_sigToRevoke] = true;
534         
535         emit SignatureRedeemed(_sigToRevoke, msg.sender);
536         return true;
537     }
538     
539     /**
540      * @dev Revoke signature through a delegate.
541      * @param _signature The signature allowing this revocation.
542      * @param _sigToRevoke The signature that you would like revoked.
543      * @param _gasPrice The amount of token wei to be paid for each uint of gas.
544     **/
545     function revokeSignaturePreSigned(
546         bytes _signature,
547         bytes _sigToRevoke,
548         uint256 _gasPrice)
549       public
550       validPayload(356)
551     returns (bool)
552     {
553         uint256 gas = gasleft();
554         address from = recoverRevokeHash(_signature, _sigToRevoke, _gasPrice);
555         require(!invalidSignatures[from][_signature]);
556         invalidSignatures[from][_signature] = true;
557         
558         invalidSignatures[from][_sigToRevoke] = true;
559         
560         if (_gasPrice > 0) {
561             gas = 35000 + gas.sub(gasleft());
562             require(_transfer(from, msg.sender, _gasPrice.mul(gas)));
563         }
564         
565         emit SignatureRedeemed(_signature, from);
566         return true;
567     }
568     
569     /**
570      * @dev Get hash for a revocation.
571      * @param _sigToRevoke The signature to be revoked.
572      * @param _gasPrice The amount to be paid to delegate for sending this tx.
573     **/
574     function getRevokeHash(bytes _sigToRevoke, uint256 _gasPrice)
575       public
576       pure
577     returns (bytes32 txHash)
578     {
579         return keccak256(revokeSignatureSig, _sigToRevoke, _gasPrice);
580     }
581 
582     /**
583      * @dev Recover the address from a revocation signature.
584      * @param _sigToRevoke The signature to be revoked.
585      * @param _signature The signature allowing this revocation.
586      * @param _gasPrice The amount of token wei to be paid for each unit of gas.
587     **/
588     function recoverRevokeHash(bytes _signature, bytes _sigToRevoke, uint256 _gasPrice)
589       public
590       pure
591     returns (address from)
592     {
593         return ecrecoverFromSig(getSignHash(getRevokeHash(_sigToRevoke, _gasPrice)), _signature);
594     }
595     
596 /** ************************** PreSigned Constants ************************ **/
597 
598     /**
599      * @dev Used in frontend and contract to get hashed data of any given pre-signed transaction.
600      * @param _to The address to transfer COIN to.
601      * @param _value The amount of COIN to be transferred.
602      * @param _extraData Extra data of tx if needed. Transfers and approves will leave this null.
603      * @param _function Function signature of the pre-signed function being used.
604      * @param _gasPrice The agreed-upon amount of COIN to be paid per unit of gas.
605      * @param _nonce The user's nonce of the new transaction.
606     **/
607     function getPreSignedHash(
608         bytes4 _function,
609         address _to, 
610         uint256 _value,
611         bytes _extraData,
612         uint256 _gasPrice,
613         uint256 _nonce)
614       public
615       view
616     returns (bytes32 txHash) 
617     {
618         return keccak256(address(this), _function, _to, _value, _extraData, _gasPrice, _nonce);
619     }
620     
621     /**
622      * @dev Recover an address from a signed pre-signed hash.
623      * @param _sig The signed hash.
624      * @param _function The function signature for function being called.
625      * @param _to The address to transfer/approve/transferFrom/etc. tokens to.
626      * @param _value The amont of tokens to transfer/approve/etc.
627      * @param _extraData The extra data included in the transaction, if any.
628      * @param _gasPrice The amount of token wei to be paid to the delegate for each unit of gas.
629      * @param _nonce The user's nonce for this transaction.
630     **/
631     function recoverPreSigned(
632         bytes _sig,
633         bytes4 _function,
634         address _to,
635         uint256 _value,
636         bytes _extraData,
637         uint256 _gasPrice,
638         uint256 _nonce) 
639       public
640       view
641     returns (address recovered)
642     {
643         return ecrecoverFromSig(getSignHash(getPreSignedHash(_function, _to, _value, _extraData, _gasPrice, _nonce)), _sig);
644     }
645     
646     /**
647      * @dev Add signature prefix to hash for recovery à la ERC191.
648      * @param _hash The hashed transaction to add signature prefix to.
649     **/
650     function getSignHash(bytes32 _hash)
651       public
652       pure
653     returns (bytes32 signHash)
654     {
655         return keccak256("\x19Ethereum Signed Message:\n32", _hash);
656     }
657 
658     /**
659      * @dev Helps to reduce stack depth problems for delegations. Thank you to Bokky for this!
660      * @param hash The hash of signed data for the transaction.
661      * @param sig Contains r, s, and v for recovery of address from the hash.
662     **/
663     function ecrecoverFromSig(bytes32 hash, bytes sig) 
664       public 
665       pure 
666     returns (address recoveredAddress) 
667     {
668         bytes32 r;
669         bytes32 s;
670         uint8 v;
671         if (sig.length != 65) return address(0);
672         assembly {
673             r := mload(add(sig, 32))
674             s := mload(add(sig, 64))
675             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
676             // There is no 'mload8' to do this, but that would be nicer.
677             v := byte(0, mload(add(sig, 96)))
678         }
679         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
680         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
681         /**
682          * @notice This used to be if (v < 27) { v += 27 } but that allowed delegates to duplicate signatures.
683          *         Any delegate that accepts signatures must now ensure that v == 0.
684         **/
685         v += 27;
686         if (v != 27 && v != 28) return address(0);
687         return ecrecover(hash, v, r, s);
688     }
689 
690     /**
691      * @dev Frontend queries to find the next nonce of the user so they can find the new nonce to send.
692      * @param _owner Address that will be sending the COIN.
693     **/
694     function getNonce(address _owner)
695       external
696       view
697     returns (uint256 nonce)
698     {
699         return nonces[_owner];
700     }
701     
702 /** ****************************** Constants ******************************* **/
703     
704     /**
705      * @dev Return total supply of token.
706     **/
707     function totalSupply() 
708       external
709       view 
710      returns (uint256)
711     {
712         return _totalSupply;
713     }
714 
715     /**
716      * @dev Return balance of a certain address.
717      * @param _owner The address whose balance we want to check.
718     **/
719     function balanceOf(address _owner)
720       external
721       view 
722     returns (uint256) 
723     {
724         return balances[_owner];
725     }
726     
727     /**
728      * @dev Allowed amount for a user to spend of another's tokens.
729      * @param _owner The owner of the tokens approved to spend.
730      * @param _spender The address of the user allowed to spend the tokens.
731     **/
732     function allowance(address _owner, address _spender) 
733       external
734       view 
735     returns (uint256) 
736     {
737         return allowed[_owner][_spender];
738     }
739     
740 /** ****************************** onlyOwner ******************************* **/
741     
742     /**
743      * @dev Allow the owner to take ERC20 tokens off of this contract if they are accidentally sent.
744     **/
745     function token_escape(address _tokenContract)
746       external
747       onlyOwner
748     {
749         CoinvestToken lostToken = CoinvestToken(_tokenContract);
750         
751         uint256 stuckTokens = lostToken.balanceOf(address(this));
752         lostToken.transfer(owner, stuckTokens);
753     }
754     
755     /**
756      * @dev Owner may set the standard sig to redirect to one of our pre-signed functions.
757      * @dev Added in order to prepare for the ERC865 standard function names to be different from ours.
758      * @param _standardSig The function signature of the finalized standard function.
759      * @param _ourSig The function signature of our implemented function.
760     **/
761     function updateStandard(bytes4 _standardSig, bytes4 _ourSig)
762       external
763       onlyOwner
764     returns (bool success)
765     {
766         // These 6 are the signatures of our pre-signed functions. Don't want the owner messin' around.
767         require(_ourSig == 0x1296830d || _ourSig == 0x617b390b || _ourSig == 0xadb8249e ||
768             _ourSig == 0x8be52783 || _ourSig == 0xc8d4b389 || _ourSig == 0xe391a7c4);
769         standardSigs[_standardSig] = _ourSig;
770         return true;
771     }
772     
773 /** ***************************** Modifiers ******************************** **/
774     
775     modifier validPayload(uint _size) {
776         uint payload_size;
777         assembly {
778             payload_size := calldatasize
779         }
780         require(payload_size >= _size);
781         _;
782     }
783     
784 }