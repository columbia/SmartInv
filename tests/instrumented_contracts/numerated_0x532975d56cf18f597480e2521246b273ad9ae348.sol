1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     if (a == 0) {
54       return 0;
55     }
56     c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     emit Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(address _owner, address _spender) public view returns (uint256) {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 /**
252  * @title Mintable token
253  * @dev Simple ERC20 Token example, with mintable token creation
254  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
255  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
256  */
257 contract MintableToken is StandardToken, Ownable {
258   event Mint(address indexed to, uint256 amount);
259   event MintFinished();
260 
261   bool public mintingFinished = false;
262 
263 
264   modifier canMint() {
265     require(!mintingFinished);
266     _;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     totalSupply_ = totalSupply_.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     emit Mint(_to, _amount);
279     emit Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     emit MintFinished();
290     return true;
291   }
292 }
293 
294 /**
295  * @title Burnable Token
296  * @dev Token that can be irreversibly burned (destroyed).
297  */
298 contract BurnableToken is BasicToken {
299 
300   event Burn(address indexed burner, uint256 value);
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param _value The amount of token to be burned.
305    */
306   function burn(uint256 _value) public {
307     _burn(msg.sender, _value);
308   }
309 
310   function _burn(address _who, uint256 _value) internal {
311     require(_value <= balances[_who]);
312     // no need to require value <= totalSupply, since that would imply the
313     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
314 
315     balances[_who] = balances[_who].sub(_value);
316     totalSupply_ = totalSupply_.sub(_value);
317     emit Burn(_who, _value);
318     emit Transfer(_who, address(0), _value);
319   }
320 }
321 
322 contract XRT is MintableToken, BurnableToken {
323     string public constant name     = "Robonomics Alpha";
324     string public constant symbol   = "XRT";
325     uint   public constant decimals = 9;
326 
327     uint256 public constant INITIAL_SUPPLY = 5 * (10 ** uint256(decimals));
328 
329     constructor() public {
330         totalSupply_ = INITIAL_SUPPLY;
331         balances[msg.sender] = INITIAL_SUPPLY;
332         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
333     }
334 }
335 
336 contract LightContract {
337     /**
338      * @dev Shared code smart contract 
339      */
340     address lib;
341 
342     constructor(address _library) public {
343         lib = _library;
344     }
345 
346     function() public {
347         require(lib.delegatecall(msg.data));
348     }
349 }
350 
351 contract LighthouseAPI {
352     address[] public members;
353     mapping(address => uint256) indexOf;
354 
355     mapping(address => uint256) public balances;
356 
357     uint256 public minimalFreeze;
358     uint256 public timeoutBlocks;
359 
360     LiabilityFactory public factory;
361     XRT              public xrt;
362 
363     uint256 public keepaliveBlock = 0;
364     uint256 public marker = 0;
365     uint256 public quota = 0;
366 
367     function quotaOf(address _member) public view returns (uint256)
368     { return balances[_member] / minimalFreeze; }
369 }
370 
371 contract Lighthouse is LighthouseAPI, LightContract {
372     constructor(
373         address _lib,
374         uint256 _minimalFreeze,
375         uint256 _timeoutBlocks
376     ) 
377         public
378         LightContract(_lib)
379     {
380         minimalFreeze = _minimalFreeze;
381         timeoutBlocks = _timeoutBlocks;
382         factory = LiabilityFactory(msg.sender);
383         xrt = factory.xrt();
384     }
385 }
386 
387 contract RobotLiabilityAPI {
388     bytes   public model;
389     bytes   public objective;
390     bytes   public result;
391 
392     XRT        public xrt;
393     ERC20   public token;
394 
395     uint256 public cost;
396     uint256 public lighthouseFee;
397     uint256 public validatorFee;
398 
399     bytes32 public askHash;
400     bytes32 public bidHash;
401 
402     address public promisor;
403     address public promisee;
404     address public validator;
405 
406     bool    public isConfirmed;
407     bool    public isFinalized;
408 
409     LiabilityFactory public factory;
410 }
411 
412 contract RobotLiability is RobotLiabilityAPI, LightContract {
413     constructor(address _lib) public LightContract(_lib)
414     { factory = LiabilityFactory(msg.sender); }
415 }
416 
417 interface ENS {
418 
419     // Logged when the owner of a node assigns a new owner to a subnode.
420     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
421 
422     // Logged when the owner of a node transfers ownership to a new account.
423     event Transfer(bytes32 indexed node, address owner);
424 
425     // Logged when the resolver for a node changes.
426     event NewResolver(bytes32 indexed node, address resolver);
427 
428     // Logged when the TTL of a node changes
429     event NewTTL(bytes32 indexed node, uint64 ttl);
430 
431 
432     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
433     function setResolver(bytes32 node, address resolver) public;
434     function setOwner(bytes32 node, address owner) public;
435     function setTTL(bytes32 node, uint64 ttl) public;
436     function owner(bytes32 node) public view returns (address);
437     function resolver(bytes32 node) public view returns (address);
438     function ttl(bytes32 node) public view returns (uint64);
439 
440 }
441 
442 /**
443  * A simple resolver anyone can use; only allows the owner of a node to set its
444  * address.
445  */
446 contract PublicResolver {
447 
448     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
449     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
450     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
451     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
452     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
453     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
454     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
455     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
456 
457     event AddrChanged(bytes32 indexed node, address a);
458     event ContentChanged(bytes32 indexed node, bytes32 hash);
459     event NameChanged(bytes32 indexed node, string name);
460     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
461     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
462     event TextChanged(bytes32 indexed node, string indexedKey, string key);
463     event MultihashChanged(bytes32 indexed node, bytes hash);
464 
465     struct PublicKey {
466         bytes32 x;
467         bytes32 y;
468     }
469 
470     struct Record {
471         address addr;
472         bytes32 content;
473         string name;
474         PublicKey pubkey;
475         mapping(string=>string) text;
476         mapping(uint256=>bytes) abis;
477         bytes multihash;
478     }
479 
480     ENS ens;
481 
482     mapping (bytes32 => Record) records;
483 
484     modifier only_owner(bytes32 node) {
485         require(ens.owner(node) == msg.sender);
486         _;
487     }
488 
489     /**
490      * Constructor.
491      * @param ensAddr The ENS registrar contract.
492      */
493     function PublicResolver(ENS ensAddr) public {
494         ens = ensAddr;
495     }
496 
497     /**
498      * Sets the address associated with an ENS node.
499      * May only be called by the owner of that node in the ENS registry.
500      * @param node The node to update.
501      * @param addr The address to set.
502      */
503     function setAddr(bytes32 node, address addr) public only_owner(node) {
504         records[node].addr = addr;
505         AddrChanged(node, addr);
506     }
507 
508     /**
509      * Sets the content hash associated with an ENS node.
510      * May only be called by the owner of that node in the ENS registry.
511      * Note that this resource type is not standardized, and will likely change
512      * in future to a resource type based on multihash.
513      * @param node The node to update.
514      * @param hash The content hash to set
515      */
516     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
517         records[node].content = hash;
518         ContentChanged(node, hash);
519     }
520 
521     /**
522      * Sets the multihash associated with an ENS node.
523      * May only be called by the owner of that node in the ENS registry.
524      * @param node The node to update.
525      * @param hash The multihash to set
526      */
527     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
528         records[node].multihash = hash;
529         MultihashChanged(node, hash);
530     }
531     
532     /**
533      * Sets the name associated with an ENS node, for reverse records.
534      * May only be called by the owner of that node in the ENS registry.
535      * @param node The node to update.
536      * @param name The name to set.
537      */
538     function setName(bytes32 node, string name) public only_owner(node) {
539         records[node].name = name;
540         NameChanged(node, name);
541     }
542 
543     /**
544      * Sets the ABI associated with an ENS node.
545      * Nodes may have one ABI of each content type. To remove an ABI, set it to
546      * the empty string.
547      * @param node The node to update.
548      * @param contentType The content type of the ABI
549      * @param data The ABI data.
550      */
551     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
552         // Content types must be powers of 2
553         require(((contentType - 1) & contentType) == 0);
554         
555         records[node].abis[contentType] = data;
556         ABIChanged(node, contentType);
557     }
558     
559     /**
560      * Sets the SECP256k1 public key associated with an ENS node.
561      * @param node The ENS node to query
562      * @param x the X coordinate of the curve point for the public key.
563      * @param y the Y coordinate of the curve point for the public key.
564      */
565     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
566         records[node].pubkey = PublicKey(x, y);
567         PubkeyChanged(node, x, y);
568     }
569 
570     /**
571      * Sets the text data associated with an ENS node and key.
572      * May only be called by the owner of that node in the ENS registry.
573      * @param node The node to update.
574      * @param key The key to set.
575      * @param value The text data value to set.
576      */
577     function setText(bytes32 node, string key, string value) public only_owner(node) {
578         records[node].text[key] = value;
579         TextChanged(node, key, key);
580     }
581 
582     /**
583      * Returns the text data associated with an ENS node and key.
584      * @param node The ENS node to query.
585      * @param key The text data key to query.
586      * @return The associated text data.
587      */
588     function text(bytes32 node, string key) public view returns (string) {
589         return records[node].text[key];
590     }
591 
592     /**
593      * Returns the SECP256k1 public key associated with an ENS node.
594      * Defined in EIP 619.
595      * @param node The ENS node to query
596      * @return x, y the X and Y coordinates of the curve point for the public key.
597      */
598     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
599         return (records[node].pubkey.x, records[node].pubkey.y);
600     }
601 
602     /**
603      * Returns the ABI associated with an ENS node.
604      * Defined in EIP205.
605      * @param node The ENS node to query
606      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
607      * @return contentType The content type of the return value
608      * @return data The ABI data
609      */
610     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
611         Record storage record = records[node];
612         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
613             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
614                 data = record.abis[contentType];
615                 return;
616             }
617         }
618         contentType = 0;
619     }
620 
621     /**
622      * Returns the name associated with an ENS node, for reverse records.
623      * Defined in EIP181.
624      * @param node The ENS node to query.
625      * @return The associated name.
626      */
627     function name(bytes32 node) public view returns (string) {
628         return records[node].name;
629     }
630 
631     /**
632      * Returns the content hash associated with an ENS node.
633      * Note that this resource type is not standardized, and will likely change
634      * in future to a resource type based on multihash.
635      * @param node The ENS node to query.
636      * @return The associated content hash.
637      */
638     function content(bytes32 node) public view returns (bytes32) {
639         return records[node].content;
640     }
641 
642     /**
643      * Returns the multihash associated with an ENS node.
644      * @param node The ENS node to query.
645      * @return The associated multihash.
646      */
647     function multihash(bytes32 node) public view returns (bytes) {
648         return records[node].multihash;
649     }
650 
651     /**
652      * Returns the address associated with an ENS node.
653      * @param node The ENS node to query.
654      * @return The associated address.
655      */
656     function addr(bytes32 node) public view returns (address) {
657         return records[node].addr;
658     }
659 
660     /**
661      * Returns true if the resolver implements the interface specified by the provided hash.
662      * @param interfaceID The ID of the interface to check for.
663      * @return True if the contract implements the requested interface.
664      */
665     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
666         return interfaceID == ADDR_INTERFACE_ID ||
667         interfaceID == CONTENT_INTERFACE_ID ||
668         interfaceID == NAME_INTERFACE_ID ||
669         interfaceID == ABI_INTERFACE_ID ||
670         interfaceID == PUBKEY_INTERFACE_ID ||
671         interfaceID == TEXT_INTERFACE_ID ||
672         interfaceID == MULTIHASH_INTERFACE_ID ||
673         interfaceID == INTERFACE_META_ID;
674     }
675 }
676 
677 contract LiabilityFactory {
678     constructor(
679         address _robot_liability_lib,
680         address _lighthouse_lib,
681         XRT _xrt
682     ) public {
683         robotLiabilityLib = _robot_liability_lib;
684         lighthouseLib = _lighthouse_lib;
685         xrt = _xrt;
686     }
687 
688     /**
689      * @dev New liability created 
690      */
691     event NewLiability(address indexed liability);
692 
693     /**
694      * @dev New lighthouse created
695      */
696     event NewLighthouse(address indexed lighthouse, string name);
697 
698     /**
699      * @dev Robonomics network protocol token
700      */
701     XRT public xrt;
702 
703     /**
704      * @dev Ethereum name system
705      */
706     ENS public ens;
707 
708     /**
709      * @dev Robonomics ENS resolver
710      */
711     PublicResolver public resolver;
712 
713     bytes32 constant lighthouseNode
714         // lighthouse.0.robonomics.eth
715         = 0x1e42a8e8e1e8cf36e83d096dcc74af801d0a194a14b897f9c8dfd403b4eebeda;
716 
717     /**
718      *  @dev Set ENS registry contract address
719      */
720     function setENS(ENS _ens) public {
721       require(address(ens) == 0);
722       ens = _ens;
723       resolver = PublicResolver(ens.resolver(lighthouseNode));
724     }
725 
726     /**
727      * @dev Total GAS utilized by Robonomics network
728      */
729     uint256 public totalGasUtilizing = 0;
730 
731     /**
732      * @dev GAS utilized by liability contracts
733      */
734     mapping(address => uint256) public gasUtilizing;
735 
736 
737     /**
738      * @dev Used market orders accounting
739      */
740     mapping(bytes32 => bool) public usedHash;
741 
742     /**
743      * @dev Lighthouse accounting
744      */
745     mapping(address => bool) public isLighthouse;
746 
747     /**
748      * @dev Robot liability shared code smart contract
749      */
750     address public robotLiabilityLib;
751 
752     /**
753      * @dev Lightouse shared code smart contract
754      */
755     address public lighthouseLib;
756 
757     /**
758      * @dev XRT emission value for utilized gas
759      */
760     function winnerFromGas(uint256 _gas) public view returns (uint256) {
761         // Basic equal formula
762         uint256 wn = _gas;
763 
764         /* Additional emission table
765         if (totalGasUtilizing < 347 * (10 ** 10)) {
766             wn *= 6;
767         } else if (totalGasUtilizing < 2 * 347 * (10 ** 10)) {
768             wn *= 4;
769         } else if (totalGasUtilizing < 3 * 347 * (10 ** 10)) {
770             wn = wn * 2667 / 1000;
771         } else if (totalGasUtilizing < 4 * 347 * (10 ** 10)) {
772             wn = wn * 1778 / 1000;
773         } else if (totalGasUtilizing < 5 * 347 * (10 ** 10)) {
774             wn = wn * 1185 / 1000;
775         } */
776 
777         return wn ;
778     }
779 
780     /**
781      * @dev Only lighthouse guard
782      */
783     modifier onlyLighthouse {
784         require(isLighthouse[msg.sender]);
785         _;
786     }
787 
788     /**
789      * @dev Parameter can be used only once
790      * @param _hash Single usage hash
791      */
792     function usedHashGuard(bytes32 _hash) internal {
793         require(!usedHash[_hash]);
794         usedHash[_hash] = true;
795     }
796 
797     /**
798      * @dev Create robot liability smart contract
799      * @param _ask ABI-encoded ASK order message 
800      * @param _bid ABI-encoded BID order message 
801      */
802     function createLiability(
803         bytes _ask,
804         bytes _bid
805     )
806         external 
807         onlyLighthouse
808         returns (RobotLiability liability)
809     {
810         // Store in memory available gas
811         uint256 gasinit = gasleft();
812 
813         // Create liability
814         liability = new RobotLiability(robotLiabilityLib);
815         emit NewLiability(liability);
816 
817         // Parse messages
818         require(liability.call(abi.encodePacked(bytes4(0x82fbaa25), _ask))); // liability.ask(...)
819         usedHashGuard(liability.askHash());
820 
821         require(liability.call(abi.encodePacked(bytes4(0x66193359), _bid))); // liability.bid(...)
822         usedHashGuard(liability.bidHash());
823 
824         // Transfer lighthouse fee to lighthouse worker directly
825         require(xrt.transferFrom(liability.promisor(),
826                                  tx.origin,
827                                  liability.lighthouseFee()));
828 
829         // Transfer liability security and hold on contract
830         ERC20 token = liability.token();
831         require(token.transferFrom(liability.promisee(),
832                                    liability,
833                                    liability.cost()));
834 
835         // Transfer validator fee and hold on contract
836         if (address(liability.validator()) != 0 && liability.validatorFee() > 0)
837             require(xrt.transferFrom(liability.promisee(),
838                                      liability,
839                                      liability.validatorFee()));
840 
841         // Accounting gas usage of transaction
842         uint256 gas = gasinit - gasleft() + 110525; // Including observation error
843         totalGasUtilizing       += gas;
844         gasUtilizing[liability] += gas;
845      }
846 
847     /**
848      * @dev Create lighthouse smart contract
849      * @param _minimalFreeze Minimal freeze value of XRT token
850      * @param _timeoutBlocks Max time of lighthouse silence in blocks
851      * @param _name Lighthouse subdomain,
852      *              example: for 'my-name' will created 'my-name.lighthouse.0.robonomics.eth' domain
853      */
854     function createLighthouse(
855         uint256 _minimalFreeze,
856         uint256 _timeoutBlocks,
857         string  _name
858     )
859         external
860         returns (address lighthouse)
861     {
862         // Name reservation check
863         bytes32 subnode = keccak256(abi.encodePacked(lighthouseNode, keccak256(_name)));
864         require(ens.resolver(subnode) == 0);
865 
866         // Create lighthouse
867         lighthouse = new Lighthouse(lighthouseLib, _minimalFreeze, _timeoutBlocks);
868         emit NewLighthouse(lighthouse, _name);
869         isLighthouse[lighthouse] = true;
870 
871         // Register subnode
872         ens.setSubnodeOwner(lighthouseNode, keccak256(_name), this);
873 
874         // Register lighthouse address
875         ens.setResolver(subnode, resolver);
876         resolver.setAddr(subnode, lighthouse);
877     }
878 
879     /**
880      * @dev Is called whan after liability finalization
881      * @param _gas Liability finalization gas expenses
882      */
883     function liabilityFinalized(
884         uint256 _gas
885     )
886         external
887         returns (bool)
888     {
889         require(gasUtilizing[msg.sender] > 0);
890 
891         uint256 gas = _gas - gasleft();
892         totalGasUtilizing        += gas;
893         gasUtilizing[msg.sender] += gas;
894         require(xrt.mint(tx.origin, winnerFromGas(gasUtilizing[msg.sender])));
895         return true;
896     }
897 }