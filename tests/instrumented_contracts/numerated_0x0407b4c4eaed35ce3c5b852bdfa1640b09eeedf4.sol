1 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 
3 pragma solidity 0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address _owner, address _spender)
26     public view returns (uint256);
27 
28   function transferFrom(address _from, address _to, uint256 _value)
29     public returns (bool);
30 
31   function approve(address _spender, uint256 _value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 // File: contracts\ERC865Basic.sol
40 
41 /**
42  * @title ERC865Basic
43  * @dev Simpler version of the ERC865 interface from https://github.com/adilharis2001/ERC865Demo
44  * @author jsdavis28
45  * @notice ERC865Token allows for users to pay gas costs to a delegate in an ERC20 token
46  * https://github.com/ethereum/EIPs/issues/865
47  */
48  contract ERC865Basic is ERC20 {
49      function _transferPreSigned(
50          bytes _signature,
51          address _from,
52          address _to,
53          uint256 _value,
54          uint256 _fee,
55          uint256 _nonce
56      )
57         internal;
58 
59      event TransferPreSigned(
60          address indexed delegate,
61          address indexed from,
62          address indexed to,
63          uint256 value);
64 }
65 
66 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
78     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (_a == 0) {
82       return 0;
83     }
84 
85     c = _a * _b;
86     assert(c / _a == _b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
94     // assert(_b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = _a / _b;
96     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
97     return _a / _b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
104     assert(_b <= _a);
105     return _a - _b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
112     c = _a + _b;
113     assert(c >= _a);
114     return c;
115   }
116 }
117 
118 // File: openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) internal balances;
128 
129   uint256 internal totalSupply_;
130 
131   /**
132   * @dev Total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev Transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_value <= balances[msg.sender]);
145     require(_to != address(0));
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 // File: openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * https://github.com/ethereum/EIPs/issues/20
171  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address _from,
186     address _to,
187     uint256 _value
188   )
189     public
190     returns (bool)
191   {
192     require(_value <= balances[_from]);
193     require(_value <= allowed[_from][msg.sender]);
194     require(_to != address(0));
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     emit Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     emit Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224   function allowance(
225     address _owner,
226     address _spender
227    )
228     public
229     view
230     returns (uint256)
231   {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(
245     address _spender,
246     uint256 _addedValue
247   )
248     public
249     returns (bool)
250   {
251     allowed[msg.sender][_spender] = (
252       allowed[msg.sender][_spender].add(_addedValue));
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(
267     address _spender,
268     uint256 _subtractedValue
269   )
270     public
271     returns (bool)
272   {
273     uint256 oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue >= oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 // File: contracts\ERC865BasicToken.sol
286 
287 /**
288  * @title ERC865BasicToken
289  * @dev Simpler version of the ERC865 token from https://github.com/adilharis2001/ERC865Demo
290  * @author jsdavis28
291  * @notice ERC865Token allows for users to pay gas costs to a delegate in an ERC20 token
292  * https://github.com/ethereum/EIPs/issues/865
293  */
294 
295  contract ERC865BasicToken is ERC865Basic, StandardToken {
296     /**
297      * @dev Sets internal variables for contract
298      */
299     address internal feeAccount;
300     mapping(bytes => bool) internal signatures;
301 
302     /**
303      * @dev Allows a delegate to submit a transaction on behalf of the token holder.
304      * @param _signature The signature, issued by the token holder.
305      * @param _to The recipient's address.
306      * @param _value The amount of tokens to be transferred.
307      * @param _fee The amount of tokens paid to the delegate for gas costs.
308      * @param _nonce The transaction number.
309      */
310     function _transferPreSigned(
311         bytes _signature,
312         address _from,
313         address _to,
314         uint256 _value,
315         uint256 _fee,
316         uint256 _nonce
317     )
318         internal
319     {
320         //Pre-validate transaction
321         require(_to != address(0));
322         require(signatures[_signature] == false);
323 
324         //Create a hash of the transaction details
325         bytes32 hashedTx = _transferPreSignedHashing(_to, _value, _fee, _nonce);
326 
327         //Obtain the token holder's address and check balance
328         address from = _recover(hashedTx, _signature);
329         require(from == _from);
330         uint256 total = _value.add(_fee);
331         require(total <= balances[from]);
332 
333         //Transfer tokens
334         balances[from] = balances[from].sub(_value).sub(_fee);
335         balances[_to] = balances[_to].add(_value);
336         balances[feeAccount] = balances[feeAccount].add(_fee);
337 
338         //Mark transaction as completed
339         signatures[_signature] = true;
340 
341         //TransferPreSigned ERC865 events
342         emit TransferPreSigned(msg.sender, from, _to, _value);
343         emit TransferPreSigned(msg.sender, from, feeAccount, _fee);
344         
345         //Transfer ERC20 events
346         emit Transfer(from, _to, _value);
347         emit Transfer(from, feeAccount, _fee);
348     }
349 
350     /**
351      * @dev Creates a hash of the transaction information passed to transferPresigned.
352      * @param _to address The address which you want to transfer to.
353      * @param _value uint256 The amount of tokens to be transferred.
354      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
355      * @param _nonce uint256 Presigned transaction number.
356      * @return A copy of the hashed message signed by the token holder, with prefix added.
357      */
358     function _transferPreSignedHashing(
359         address _to,
360         uint256 _value,
361         uint256 _fee,
362         uint256 _nonce
363     )
364         internal pure
365         returns (bytes32)
366     {
367         //Create a copy of the hashed message signed by the token holder
368         bytes32 hash = keccak256(abi.encodePacked(_to, _value, _fee,_nonce));
369 
370         //Add prefix to hash
371         return _prefix(hash);
372     }
373 
374     /**
375      * @dev Adds prefix to the hashed message signed by the token holder.
376      * @param _hash The hashed message (keccak256) to be prefixed.
377      * @return Prefixed hashed message to return from _transferPreSignedHashing.
378      */
379     function _prefix(bytes32 _hash) internal pure returns (bytes32) {
380         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
381     }
382 
383     /**
384      * @dev Validate the transaction information and recover the token holder's address.
385      * @param _hash A prefixed version of the hash used in the original signed message.
386      * @param _sig The signature submitted by the token holder.
387      * @return The token holder/transaction signer's address.
388      */
389     function _recover(bytes32 _hash, bytes _sig) internal pure returns (address) {
390         bytes32 r;
391         bytes32 s;
392         uint8 v;
393 
394         //Check the signature length
395         if (_sig.length != 65) {
396             return (address(0));
397         }
398 
399         //Split the signature into r, s and v variables
400         assembly {
401             r := mload(add(_sig, 32))
402             s := mload(add(_sig, 64))
403             v := byte(0, mload(add(_sig, 96)))
404         }
405 
406         //Version of signature should be 27 or 28, but 0 and 1 are also possible
407         if (v < 27) {
408             v += 27;
409         }
410 
411         //If the version is correct, return the signer address
412         if (v != 27 && v != 28) {
413             return (address(0));
414         } else {
415             return ecrecover(_hash, v, r, s);
416         }
417     }
418 }
419 
420 // File: contracts\TaxedToken.sol
421 
422 /**
423  * @title Taxed token
424  * @dev Version of BasicToken that allows for a fee on token transfers.
425  * See https://github.com/OpenZeppelin/openzeppelin-solidity/pull/788
426  * @author jsdavis28
427  */
428 contract TaxedToken is ERC865BasicToken {
429     /**
430      * @dev Sets taxRate fee as public
431      */
432     uint8 public taxRate;
433 
434     /**
435      * @dev Transfer tokens to a specified account after diverting a fee to a central account.
436      * @param _to The receiving address.
437      * @param _value The number of tokens to transfer.
438      */
439     function transfer(
440         address _to,
441         uint256 _value
442     )
443         public
444         returns (bool)
445     {
446         require(_to != address(0));
447         require(_value <= balances[msg.sender]);
448 
449         balances[msg.sender] = balances[msg.sender].sub(_value);
450         uint256 fee = _value.mul(taxRate).div(100);
451         uint256 taxedValue = _value.sub(fee);
452 
453         balances[_to] = balances[_to].add(taxedValue);
454         emit Transfer(msg.sender, _to, taxedValue);
455         balances[feeAccount] = balances[feeAccount].add(fee);
456         emit Transfer(msg.sender, feeAccount, fee);
457 
458         return true;
459     }
460 
461     /**
462      * @dev Provides a taxed transfer on StandardToken's transferFrom() function
463      * @param _from The address providing allowance to spend
464      * @param _to The receiving address.
465      * @param _value The number of tokens to transfer.
466      */
467     function transferFrom(
468         address _from,
469         address _to,
470         uint256 _value
471     )
472         public
473         returns (bool)
474     {
475         require(_to != address(0));
476         require(_value <= balances[_from]);
477         require(_value <= allowed[_from][msg.sender]);
478 
479         balances[_from] = balances[_from].sub(_value);
480         uint256 fee = _value.mul(taxRate).div(100);
481         uint256 taxedValue = _value.sub(fee);
482 
483         balances[_to] = balances[_to].add(taxedValue);
484         emit Transfer(_from, _to, taxedValue);
485         balances[feeAccount] = balances[feeAccount].add(fee);
486         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
487         emit Transfer(_from, feeAccount, fee);
488 
489         return true;
490     }
491 }
492 
493 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
494 
495 /**
496  * @title Ownable
497  * @dev The Ownable contract has an owner address, and provides basic authorization control
498  * functions, this simplifies the implementation of "user permissions".
499  */
500 contract Ownable {
501   address public owner;
502 
503 
504   event OwnershipRenounced(address indexed previousOwner);
505   event OwnershipTransferred(
506     address indexed previousOwner,
507     address indexed newOwner
508   );
509 
510 
511   /**
512    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
513    * account.
514    */
515   constructor() public {
516     owner = msg.sender;
517   }
518 
519   /**
520    * @dev Throws if called by any account other than the owner.
521    */
522   modifier onlyOwner() {
523     require(msg.sender == owner);
524     _;
525   }
526 
527   /**
528    * @dev Allows the current owner to relinquish control of the contract.
529    * @notice Renouncing to ownership will leave the contract without an owner.
530    * It will not be possible to call the functions with the `onlyOwner`
531    * modifier anymore.
532    */
533   function renounceOwnership() public onlyOwner {
534     emit OwnershipRenounced(owner);
535     owner = address(0);
536   }
537 
538   /**
539    * @dev Allows the current owner to transfer control of the contract to a newOwner.
540    * @param _newOwner The address to transfer ownership to.
541    */
542   function transferOwnership(address _newOwner) public onlyOwner {
543     _transferOwnership(_newOwner);
544   }
545 
546   /**
547    * @dev Transfers control of the contract to a newOwner.
548    * @param _newOwner The address to transfer ownership to.
549    */
550   function _transferOwnership(address _newOwner) internal {
551     require(_newOwner != address(0));
552     emit OwnershipTransferred(owner, _newOwner);
553     owner = _newOwner;
554   }
555 }
556 
557 // File: contracts\Authorizable.sol
558 
559 /**
560  * @title Authorizable
561  * @dev The Authorizable contract allows the owner to set a number of additional
562  *  acccounts with limited administrative privileges to simplify user permissions.
563  * Only the contract owner can add or remove authorized accounts.
564  * @author jsdavis28
565  */
566 contract Authorizable is Ownable {
567     using SafeMath for uint256;
568 
569     address[] public authorized;
570     mapping(address => bool) internal authorizedIndex;
571     uint8 public numAuthorized;
572 
573     /**
574      * @dev The Authorizable constructor sets the owner as authorized
575      */
576     constructor() public {
577         authorized.length = 2;
578         authorized[1] = msg.sender;
579         authorizedIndex[msg.sender] = true;
580         numAuthorized = 1;
581     }
582 
583     /**
584      * @dev Throws if called by any account other than an authorized account.
585      */
586     modifier onlyAuthorized {
587         require(isAuthorized(msg.sender));
588         _;
589     }
590 
591     /**
592      * @dev Allows the current owner to add an authorized account.
593      * @param _account The address being added as authorized.
594      */
595     function addAuthorized(address _account) public onlyOwner {
596         if (authorizedIndex[_account] == false) {
597         	authorizedIndex[_account] = true;
598         	authorized.length++;
599         	authorized[authorized.length.sub(1)] = _account;
600         	numAuthorized++;
601         }
602     }
603 
604     /**
605      * @dev Validates whether an account is authorized for enhanced permissions.
606      * @param _account The address being evaluated.
607      */
608     function isAuthorized(address _account) public constant returns (bool) {
609         if (authorizedIndex[_account] == true) {
610         	return true;
611         }
612 
613         return false;
614     }
615 
616     /**
617      * @dev Allows the current owner to remove an authorized account.
618      * @param _account The address to remove from authorized.
619      */
620     function removeAuthorized(address _account) public onlyOwner {
621         require(isAuthorized(_account)); 
622         authorizedIndex[_account] = false;
623         numAuthorized--;
624     }
625 }
626 
627 // File: contracts\BlockWRKToken.sol
628 
629 /**
630  * @title BlockWRKToken
631  * @dev BlockWRKToken contains administrative features that allow the BlockWRK
632  *  application to interface with the BlockWRK token, an ERC20-compliant token
633  *  that integrates taxed token and ERC865 functionality.
634  * @author jsdavis28
635  */
636 
637 contract BlockWRKToken is TaxedToken, Authorizable {
638     /**
639      * @dev Sets token information.
640      */
641     string public name = "BlockWRK";
642     string public symbol = "WRK";
643     uint8 public decimals = 4;
644     uint256 public INITIAL_SUPPLY;
645 
646     /**
647      * @dev Sets public variables for BlockWRK token.
648      */
649     address public distributionPoolWallet;
650     address public inAppPurchaseWallet;
651     address public reservedTokenWallet;
652     uint256 public premineDistributionPool;
653     uint256 public premineReserved;
654 
655     /**
656      * @dev Sets private variables for custom token functions.
657      */
658     uint256 internal decimalValue = 10000;
659 
660     constructor() public {
661         feeAccount = 0xeCced56A201d1A6D1Da31A060868F96ACdba99B3;
662         distributionPoolWallet = 0xAB3Edd46E9D52e1b3131757e1Ed87FA885f48019;
663         inAppPurchaseWallet = 0x97eae8151487e054112E27D8c2eE5f17B3C6A83c;
664         reservedTokenWallet = 0xd6E4E287a4aE2E9d8BF7f0323f440acC0d5AD301;
665         premineDistributionPool = decimalValue.mul(5600000000);
666         premineReserved = decimalValue.mul(2000000000);
667         INITIAL_SUPPLY = premineDistributionPool.add(premineReserved);
668         balances[distributionPoolWallet] = premineDistributionPool;
669         emit Transfer(address(this), distributionPoolWallet, premineDistributionPool);
670         balances[reservedTokenWallet] = premineReserved;
671         emit Transfer(address(this), reservedTokenWallet, premineReserved);
672         totalSupply_ = INITIAL_SUPPLY;
673         taxRate = 2;
674     }
675 
676     /**
677      * @dev Allows App to distribute WRK tokens to users.
678      * This function will be called by authorized from within the App.
679      * @param _to The recipient's BlockWRK address.
680      * @param _value The amount of WRK to transfer.
681      */
682     function inAppTokenDistribution(
683         address _to,
684         uint256 _value
685     )
686         public
687         onlyAuthorized
688     {
689         require(_value <= balances[distributionPoolWallet]);
690         require(_to != address(0));
691 
692         balances[distributionPoolWallet] = balances[distributionPoolWallet].sub(_value);
693         balances[_to] = balances[_to].add(_value);
694         emit Transfer(distributionPoolWallet, _to, _value);
695     }
696 
697     /**
698      * @dev Allows App to process fiat payments for WRK tokens, charging a fee in WRK.
699      * This function will be called by authorized from within the App.
700      * @param _to The buyer's BlockWRK address.
701      * @param _value The amount of WRK to transfer.
702      * @param _fee The fee charged in WRK for token purchase.
703      */
704     function inAppTokenPurchase(
705         address _to,
706         uint256 _value,
707         uint256 _fee
708     )
709         public
710         onlyAuthorized
711     {
712         require(_value <= balances[inAppPurchaseWallet]);
713         require(_to != address(0));
714 
715         balances[inAppPurchaseWallet] = balances[inAppPurchaseWallet].sub(_value);
716         uint256 netAmount = _value.sub(_fee);
717         balances[_to] = balances[_to].add(netAmount);
718         emit Transfer(inAppPurchaseWallet, _to, netAmount);
719         balances[feeAccount] = balances[feeAccount].add(_fee);
720         emit Transfer(inAppPurchaseWallet, feeAccount, _fee);
721     }
722 
723     /**
724      * @dev Allows owner to set the percentage fee charged by TaxedToken on external transfers.
725      * @param _newRate The amount to be set.
726      */
727     function setTaxRate(uint8 _newRate) public onlyOwner {
728         taxRate = _newRate;
729     }
730 
731     /**
732      * @dev Allows owner to set the fee account to receive transfer fees.
733      * @param _newAddress The address to be set.
734      */
735     function setFeeAccount(address _newAddress) public onlyOwner {
736         require(_newAddress != address(0));
737         feeAccount = _newAddress;
738     }
739 
740     /**
741      * @dev Allows owner to set the wallet that holds WRK for sale via in-app purchases with fiat.
742      * @param _newAddress The address to be set.
743      */
744     function setInAppPurchaseWallet(address _newAddress) public onlyOwner {
745         require(_newAddress != address(0));
746         inAppPurchaseWallet = _newAddress;
747     }
748 
749     /**
750      * @dev Allows authorized to act as a delegate to transfer a pre-signed transaction for ERC865
751      * @param _signature The pre-signed message.
752      * @param _from The token sender.
753      * @param _to The token recipient.
754      * @param _value The amount of WRK to send the recipient.
755      * @param _fee The fee to be paid in WRK (calculated by App off-chain).
756      * @param _nonce The transaction number (stored in App off-chain).
757      */
758     function transactionHandler(
759         bytes _signature,
760         address _from,
761         address _to,
762         uint256 _value,
763         uint256 _fee,
764         uint256 _nonce
765     )
766         public
767         onlyAuthorized
768     {
769         _transferPreSigned(_signature, _from, _to, _value, _fee, _nonce);
770     }
771 }
772 
773 // File: contracts\BlockWRKICO.sol
774 
775 /**
776  * @title BlockWRKICO
777  * @notice This contract manages the sale of WRK tokens for the BlockWRK ICO.
778  * @dev This contract incorporates elements of OpenZeppelin crowdsale contracts with some modifications.
779  * @author jsdavis28
780  */
781  contract BlockWRKICO is BlockWRKToken {
782     /**
783      * @dev Sets public variables for BlockWRK ICO
784      */
785     address public salesWallet;
786     uint256 public cap;
787     uint256 public closingTime;
788     uint256 public currentTierRate;
789     uint256 public openingTime;
790     uint256 public weiRaised;
791 
792     /**
793      * @dev Sets private variables for custom token functions.
794      */
795      uint256 internal availableInCurrentTier;
796      uint256 internal availableInSale;
797      uint256 internal totalPremineVolume;
798      uint256 internal totalSaleVolume;
799      uint256 internal totalTokenVolume;
800      uint256 internal tier1Rate;
801      uint256 internal tier2Rate;
802      uint256 internal tier3Rate;
803      uint256 internal tier4Rate;
804      uint256 internal tier5Rate;
805      uint256 internal tier6Rate;
806      uint256 internal tier7Rate;
807      uint256 internal tier8Rate;
808      uint256 internal tier9Rate;
809      uint256 internal tier10Rate;
810      uint256 internal tier1Volume;
811      uint256 internal tier2Volume;
812      uint256 internal tier3Volume;
813      uint256 internal tier4Volume;
814      uint256 internal tier5Volume;
815      uint256 internal tier6Volume;
816      uint256 internal tier7Volume;
817      uint256 internal tier8Volume;
818      uint256 internal tier9Volume;
819      uint256 internal tier10Volume;
820 
821      constructor() public {
822          cap = 9999999999999999999999999999999999999999999999;
823          salesWallet = 0xA0E021fC3538ed52F9a3D79249ff1D3A67f91C42;
824          openingTime = 1557856800;
825          closingTime = 1589479200;
826 
827          totalPremineVolume = 76000000000000;
828          totalSaleVolume = 43000000000000;
829          totalTokenVolume = 119000000000000;
830          availableInSale = totalSaleVolume;
831          tier1Rate = 100000;
832          tier2Rate = 10000;
833          tier3Rate = 2000;
834          tier4Rate = 1250;
835          tier5Rate = 625;
836          tier6Rate = 312;
837          tier7Rate = 156;
838          tier8Rate = 117;
839          tier9Rate = 104;
840          tier10Rate = 100;
841          tier1Volume = totalPremineVolume.add(1000000000000);
842          tier2Volume = tier1Volume.add(2000000000000);
843          tier3Volume = tier2Volume.add(5000000000000);
844          tier4Volume = tier3Volume.add(5000000000000);
845          tier5Volume = tier4Volume.add(5000000000000);
846          tier6Volume = tier5Volume.add(5000000000000);
847          tier7Volume = tier6Volume.add(5000000000000);
848          tier8Volume = tier7Volume.add(5000000000000);
849          tier9Volume = tier8Volume.add(5000000000000);
850          tier10Volume = tier9Volume.add(5000000000000);
851      }
852 
853     /**
854      * Event for token purchase logging
855      * @param purchaser who paid for the tokens
856      * @param beneficiary who got the tokens
857      * @param value weis paid for purchase
858      * @param amount amount of tokens purchased
859      */
860     event TokenPurchase(
861         address indexed purchaser,
862         address indexed beneficiary,
863         uint256 value,
864         uint256 amount
865     );
866 
867     /**
868      * Event marking the transfer of any remaining WRK to the distribution pool post-ICO
869      * @param wallet The address remaining sale tokens are delivered
870      * @param amount The remaining tokens after the sale has closed
871      */
872      event CloseoutSale(address indexed wallet, uint256 amount);
873 
874 
875 
876     // -----------------------------------------
877     // Crowdsale external interface
878     // -----------------------------------------
879 
880     /**
881      * @dev fallback function
882      */
883     function () external payable {
884       buyTokens(msg.sender);
885     }
886 
887     /**
888      * @dev Allows ICO participants to purchase WRK tokens
889      * @param _beneficiary The address of the ICO participant
890      */
891     function buyTokens(address _beneficiary) public payable {
892       uint256 weiAmount = msg.value;
893       _preValidatePurchase(_beneficiary, weiAmount);
894 
895       //Calculate number of tokens to issue
896       uint256 tokens = _calculateTokens(weiAmount);
897 
898       //Calculate new amount of Wei raised
899       weiRaised = weiRaised.add(weiAmount);
900 
901       //Process token purchase and forward funcds to salesWallet
902       _processPurchase(_beneficiary, tokens);
903       _forwardFunds();
904       emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
905     }
906 
907     /**
908      * @dev Checks whether the cap has been reached.
909      * @return Whether the cap was reached
910      */
911     function capReached() public view returns (bool) {
912       return weiRaised >= cap;
913     }
914 
915      /**
916       * @dev Checks whether the period in which the crowdsale is open has already elapsed.
917       * @return Whether crowdsale period has elapsed
918       */
919      function hasClosed() public view returns (bool) {
920          // solium-disable-next-line security/no-block-members
921          return block.timestamp > closingTime;
922      }
923 
924 
925 
926     // -----------------------------------------
927     // Internal interface (extensible)
928     // -----------------------------------------
929 
930     /**
931      * @dev Calculates total number of tokens to sell, accounting for varied rates per tier.
932      * @param _amountWei Total amount of Wei sent by ICO participant
933      * @return Total number of tokens to send to buyer
934      */
935     function _calculateTokens(uint256 _amountWei) internal returns (uint256) {
936         //Tokens pending in sale
937         uint256 tokenAmountPending;
938 
939         //Tokens to be sold
940         uint256 tokenAmountToIssue;
941 
942         //Note: tierCaps must take into account reserved and distribution pool tokens
943         //Determine tokens remaining in tier and set current token rate
944         uint256 tokensRemainingInTier = _getRemainingTokens(totalSupply_);
945 
946         //Calculate new tokens pending sale
947         uint256 newTokens = _getTokenAmount(_amountWei);
948 
949         //Check if _newTokens exceeds _tokensRemainingInTier
950         bool nextTier = true;
951         while (nextTier) {
952             if (newTokens > tokensRemainingInTier) {
953                 //Get tokens sold in current tier and add to pending total supply
954                 tokenAmountPending = tokensRemainingInTier;
955                 uint256 newTotal = totalSupply_.add(tokenAmountPending);
956 
957                 //Save number of tokens pending from current tier
958                 tokenAmountToIssue = tokenAmountToIssue.add(tokenAmountPending);
959 
960                 //Calculate Wei spent in current tier and set remaining Wei for next tier
961                 uint256 pendingAmountWei = tokenAmountPending.div(currentTierRate);
962                 uint256 remainingWei = _amountWei.sub(pendingAmountWei);
963 
964                 //Calculate number of tokens in next tier
965                 tokensRemainingInTier = _getRemainingTokens(newTotal);
966                 newTokens = _getTokenAmount(remainingWei);
967             } else {
968                 tokenAmountToIssue = tokenAmountToIssue.add(newTokens);
969                 nextTier = false;
970                 _setAvailableInCurrentTier(tokensRemainingInTier, newTokens);
971                 _setAvailableInSale(newTokens);
972             }
973         }
974 
975         //Return amount of tokens to be issued in this sale
976         return tokenAmountToIssue;
977     }
978 
979     /**
980      * @dev Source of tokens.
981      * @param _beneficiary Address performing the token purchase
982      * @param _tokenAmount Number of tokens to be emitted
983      */
984     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
985         totalSupply_ = totalSupply_.add(_tokenAmount);
986         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
987     }
988 
989     /**
990      * @dev Determines how ETH is stored/forwarded on purchases.
991      */
992     function _forwardFunds() internal {
993         salesWallet.transfer(msg.value);
994     }
995 
996     /**
997      * @dev Performs a binary search of the sale tiers to determine current sales volume and rate.
998      * @param _tokensSold The total number of tokens sold in the ICO prior to this tx
999      * @return The remaining number of tokens for sale in the current sale tier
1000      */
1001     function _getRemainingTokens(uint256 _tokensSold) internal returns (uint256) {
1002         //Deteremine the current sale tier, set current rate and find remaining tokens in tier
1003         uint256 remaining;
1004         if (_tokensSold < tier5Volume) {
1005             if (_tokensSold < tier3Volume) {
1006                 if (_tokensSold < tier1Volume) {
1007                     _setCurrentTierRate(tier1Rate);
1008                     remaining = tier1Volume.sub(_tokensSold);
1009                 } else if (_tokensSold < tier2Volume) {
1010                     _setCurrentTierRate(tier2Rate);
1011                     remaining = tier2Volume.sub(_tokensSold);
1012                 } else {
1013                     _setCurrentTierRate(tier3Rate);
1014                     remaining = tier3Volume.sub(_tokensSold);
1015                 }
1016             } else {
1017                 if (_tokensSold < tier4Volume) {
1018                     _setCurrentTierRate(tier4Rate);
1019                     remaining = tier4Volume.sub(_tokensSold);
1020                 } else {
1021                     _setCurrentTierRate(tier5Rate);
1022                     remaining = tier5Volume.sub(_tokensSold);
1023                 }
1024             }
1025         } else {
1026             if (_tokensSold < tier8Volume) {
1027                 if (_tokensSold < tier6Volume) {
1028                     _setCurrentTierRate(tier6Rate);
1029                     remaining = tier6Volume.sub(_tokensSold);
1030                 } else if (_tokensSold < tier7Volume) {
1031                     _setCurrentTierRate(tier7Rate);
1032                     remaining = tier7Volume.sub(_tokensSold);
1033                 } else {
1034                     _setCurrentTierRate(tier8Rate);
1035                     remaining = tier8Volume.sub(_tokensSold);
1036                 }
1037             } else {
1038                 if (_tokensSold < tier9Volume) {
1039                     _setCurrentTierRate(tier9Rate);
1040                     remaining = tier9Volume.sub(_tokensSold);
1041                 } else {
1042                     _setCurrentTierRate(tier10Rate);
1043                     remaining = tier10Volume.sub(_tokensSold);
1044                 }
1045             }
1046         }
1047 
1048         return remaining;
1049     }
1050 
1051     /**
1052      * @dev Override to extend the way in which ether is converted to tokens.
1053      * @param _weiAmount Value in wei to be converted into tokens
1054      * @return Number of tokens that can be purchased with the specified _weiAmount
1055      */
1056     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1057         return _weiAmount.mul(currentTierRate).mul(decimalValue).div(1 ether);
1058     }
1059 
1060     /**
1061      * @dev Validation of an incoming purchase.
1062      * @param _beneficiary Address performing the token purchase
1063      * @param _weiAmount Value in wei involved in the purchase
1064      */
1065     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
1066         require(_beneficiary != address(0));
1067         require(_weiAmount != 0);
1068         require(weiRaised.add(_weiAmount) <= cap);
1069         // solium-disable-next-line security/no-block-members
1070         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1071     }
1072 
1073     /**
1074      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1075      * @param _beneficiary Address receiving the tokens
1076      * @param _tokenAmount Number of tokens to be purchased
1077      */
1078     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1079         _deliverTokens(_beneficiary, _tokenAmount);
1080     }
1081 
1082     /**
1083      * @dev Calculates remaining tokens available in the current tier after a sale is processed
1084      * @param _tierPreviousRemaining Number of tokens remaining prior to sale
1085      * @param _newIssue Number of tokens to be purchased
1086      */
1087     function _setAvailableInCurrentTier(uint256 _tierPreviousRemaining, uint256 _newIssue) internal {
1088         availableInCurrentTier = _tierPreviousRemaining.sub(_newIssue);
1089     }
1090 
1091     /**
1092      * @dev Calculates remaining tokens available in the ICO after a sale is processed
1093      * @param _newIssue Number of tokens to be purchased
1094      */
1095     function _setAvailableInSale(uint256 _newIssue) internal {
1096         availableInSale = totalSaleVolume.sub(_newIssue);
1097     }
1098 
1099     /**
1100      * @dev Sets the current tier rate based on sale volume
1101      * @param _rate The new rate
1102      */
1103     function _setCurrentTierRate(uint256 _rate) internal {
1104         currentTierRate = _rate;
1105     }
1106 
1107     /**
1108      * @dev Returns the remaining number of tokens for sale
1109      * @return Total remaining tokens available for sale
1110      */
1111     function tokensRemainingInSale() public view returns (uint256) {
1112         return availableInSale;
1113     }
1114 
1115     /**
1116      * @dev Returns the remaining number of tokens for sale in the current tier
1117      * @return Total remaining tokens available for sale in the current tier
1118      */
1119     function tokensRemainingInTier() public view returns (uint256) {
1120         return availableInCurrentTier;
1121     }
1122 
1123     /**
1124      * @dev Allows the owner to transfer any remaining tokens not sold to a wallet
1125      * @return Total remaining tokens available for sale
1126      */
1127      function transferRemainingTokens() public onlyOwner {
1128          //require that sale is closed
1129          require(hasClosed());
1130 
1131          //require that tokens are still remaining after close
1132          require(availableInSale > 0);
1133 
1134          //send remaining tokens to distribution pool wallet
1135          balances[distributionPoolWallet] = balances[distributionPoolWallet].add(availableInSale);
1136          emit CloseoutSale(distributionPoolWallet, availableInSale);
1137      }
1138 }