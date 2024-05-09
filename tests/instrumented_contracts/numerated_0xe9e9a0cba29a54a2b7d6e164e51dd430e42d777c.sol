1 pragma solidity ^0.4.25;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * Nametag - Canonical Profile Manager for Zer0net
9  * 
10  *           Designed to support the needs of the growing Zeronet community.
11  *
12  * Version 19.3.21
13  *
14  * Web    : https://d14na.org
15  * Email  : support@d14na.org
16  */
17 
18 
19 /*******************************************************************************
20  *
21  * SafeMath
22  */
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function sub(uint a, uint b) internal pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32     function mul(uint a, uint b) internal pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36     function div(uint a, uint b) internal pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 
43 /*******************************************************************************
44  *
45  * ECRecovery
46  *
47  * Contract function to validate signature of pre-approved token transfers.
48  * (borrowed from LavaWallet)
49  */
50 contract ECRecovery {
51     function recover(bytes32 hash, bytes sig) public pure returns (address);
52 }
53 
54 
55 /*******************************************************************************
56  *
57  * ERC Token Standard #20 Interface
58  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
59  */
60 contract ERC20Interface {
61     function totalSupply() public constant returns (uint);
62     function balanceOf(address tokenOwner) public constant returns (uint balance);
63     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
64     function transfer(address to, uint tokens) public returns (bool success);
65     function approve(address spender, uint tokens) public returns (bool success);
66     function transferFrom(address from, address to, uint tokens) public returns (bool success);
67 
68     event Transfer(address indexed from, address indexed to, uint tokens);
69     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
70 }
71 
72 
73 /*******************************************************************************
74  *
75  * ApproveAndCallFallBack
76  *
77  * Contract function to receive approval and execute function in one call
78  * (borrowed from MiniMeToken)
79  */
80 contract ApproveAndCallFallBack {
81     function approveAndCall(address spender, uint tokens, bytes data) public;
82     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
83 }
84 
85 
86 /*******************************************************************************
87  *
88  * Owned contract
89  */
90 contract Owned {
91     address public owner;
92     address public newOwner;
93 
94     event OwnershipTransferred(address indexed _from, address indexed _to);
95 
96     constructor() public {
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     function transferOwnership(address _newOwner) public onlyOwner {
106         newOwner = _newOwner;
107     }
108 
109     function acceptOwnership() public {
110         require(msg.sender == newOwner);
111 
112         emit OwnershipTransferred(owner, newOwner);
113 
114         owner = newOwner;
115 
116         newOwner = address(0);
117     }
118 }
119 
120 
121 /*******************************************************************************
122  * 
123  * Zer0netDb Interface
124  */
125 contract Zer0netDbInterface {
126     /* Interface getters. */
127     function getAddress(bytes32 _key) external view returns (address);
128     function getBool(bytes32 _key)    external view returns (bool);
129     function getBytes(bytes32 _key)   external view returns (bytes);
130     function getInt(bytes32 _key)     external view returns (int);
131     function getString(bytes32 _key)  external view returns (string);
132     function getUint(bytes32 _key)    external view returns (uint);
133 
134     /* Interface setters. */
135     function setAddress(bytes32 _key, address _value) external;
136     function setBool(bytes32 _key, bool _value) external;
137     function setBytes(bytes32 _key, bytes _value) external;
138     function setInt(bytes32 _key, int _value) external;
139     function setString(bytes32 _key, string _value) external;
140     function setUint(bytes32 _key, uint _value) external;
141 
142     /* Interface deletes. */
143     function deleteAddress(bytes32 _key) external;
144     function deleteBool(bytes32 _key) external;
145     function deleteBytes(bytes32 _key) external;
146     function deleteInt(bytes32 _key) external;
147     function deleteString(bytes32 _key) external;
148     function deleteUint(bytes32 _key) external;
149 }
150 
151 
152 /*******************************************************************************
153  *
154  * ZeroCache Interface
155  */
156 contract ZeroCacheInterface {
157     function balanceOf(address _token, address _owner) public constant returns (uint balance);
158     function transfer(address _to, address _token, uint _tokens) external returns (bool success);
159     function transfer(address _token, address _from, address _to, uint _tokens, address _staekholder, uint _staek, uint _expires, uint _nonce, bytes _signature) external returns (bool success);
160 }
161 
162 
163 /*******************************************************************************
164  *
165  * @notice Nametag Manager.
166  *
167  * @dev Nametag is the canonical profile manager for Zer0net.
168  */
169 contract Nametag is Owned {
170     using SafeMath for uint;
171 
172     /* Initialize predecessor contract. */
173     address private _predecessor;
174 
175     /* Initialize successor contract. */
176     address private _successor;
177     
178     /* Initialize revision number. */
179     uint private _revision;
180 
181     /* Initialize Zer0net Db contract. */
182     Zer0netDbInterface private _zer0netDb;
183 
184     /**
185      * Set Namespace
186      * 
187      * Provides a "unique" name for generating "unique" data identifiers,
188      * most commonly used as database "key-value" keys.
189      * 
190      * NOTE: Use of `namespace` is REQUIRED when generating ANY & ALL
191      *       Zer0netDb keys; in order to prevent ANY accidental or
192      *       malicious SQL-injection vulnerabilities / attacks.
193      */
194     string private _namespace = 'nametag';
195 
196     event Update(
197         string indexed nametag,
198         string indexed field,
199         bytes data
200     );
201     
202     event Permissions(
203         address indexed owner,
204         address indexed delegate,
205         bytes permissions
206     );
207     
208     event Respect(
209         address indexed owner,
210         address indexed peer,
211         uint respect
212     );
213     
214     /***************************************************************************
215      *
216      * Constructor
217      */
218     constructor() public {
219         /* Initialize Zer0netDb (eternal) storage database contract. */
220         // NOTE We hard-code the address here, since it should never change.
221         _zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
222 
223         /* Initialize (aname) hash. */
224         bytes32 hash = keccak256(abi.encodePacked('aname.', _namespace));
225 
226         /* Set predecessor address. */
227         _predecessor = _zer0netDb.getAddress(hash);
228 
229         /* Verify predecessor address. */
230         if (_predecessor != 0x0) {
231             /* Retrieve the last revision number (if available). */
232             uint lastRevision = Nametag(_predecessor).getRevision();
233             
234             /* Set (current) revision number. */
235             _revision = lastRevision + 1;
236         }
237     }
238 
239     /**
240      * @dev Only allow access to an authorized Zer0net administrator.
241      */
242     modifier onlyAuthBy0Admin() {
243         /* Verify write access is only permitted to authorized accounts. */
244         require(_zer0netDb.getBool(keccak256(
245             abi.encodePacked(msg.sender, '.has.auth.for.', _namespace))) == true);
246 
247         _;      // function code is inserted here
248     }
249 
250     /**
251      * @dev Only allow access to "registered" nametag owner.
252      */
253     modifier onlyNametagOwner(
254         string _nametag
255     ) {
256         /* Calculate owner hash. */
257         bytes32 ownerHash = keccak256(abi.encodePacked(
258             _namespace, '.',
259             _nametag,
260             '.owner'
261         ));
262 
263         /* Retrieve nametag owner. */
264         address nametagOwner = _zer0netDb.getAddress(ownerHash);
265 
266         /* Validate nametag owner. */
267         require(msg.sender == nametagOwner);
268 
269         _;      // function code is inserted here
270     }
271 
272     /**
273      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
274      */
275     function () public payable {
276         /* Cancel this transaction. */
277         revert('Oops! Direct payments are NOT permitted here.');
278     }
279 
280 
281     /***************************************************************************
282      * 
283      * ACTIONS
284      * 
285      */
286 
287     /**
288      * Give Respect (To Another Peer)
289      */
290     function giveRespect(
291         address _peer,
292         uint _respect
293     ) public returns (bool success) {
294         /* Set respect. */
295         return _setRespect(msg.sender, _peer, _respect);
296     }
297 
298     /**
299      * Give Respect (To Another Peer by Relayer)
300      */
301     function giveRespect(
302         address _peer,
303         uint _respect,
304         uint _expires,
305         uint _nonce,
306         bytes _signature
307     ) external returns (bool success) {
308         /* Make sure the signature has not expired. */
309         if (block.number > _expires) {
310             revert('Oops! That signature has already EXPIRED.');
311         }
312 
313         /* Calculate encoded data hash. */
314         bytes32 hash = keccak256(abi.encodePacked(
315             address(this),
316             _peer,
317             _respect, 
318             _expires,
319             _nonce
320         ));
321 
322         bytes32 sigHash = keccak256(abi.encodePacked(
323             '\x19Ethereum Signed Message:\n32', hash));
324 
325         /* Retrieve the authorized signer. */
326         address signer = 
327             _ecRecovery().recover(sigHash, _signature);
328 
329         /* Set respect. */
330         return _setRespect(signer, _peer, _respect);
331     }
332 
333     /**
334      * Show Respect (For Another Peer)
335      */
336     function showRespectFor(
337         address _peer
338     ) external view returns (uint respect) {
339         /* Show respect (value). */
340         return _getRespect(msg.sender, _peer);
341     }
342 
343     /**
344      * Show Respect (Between Two Peers)
345      */
346     function showRespect(
347         address _owner,
348         address _peer
349     ) external view returns (
350         uint respect,
351         uint reciprocal
352     ) {
353         /* Retriieve respect (value). */
354         respect = _getRespect(_owner, _peer);
355 
356         /* Retriieve respect (value). */
357         reciprocal = _getRespect(_peer, _owner);
358     }
359 
360 
361     /***************************************************************************
362      * 
363      * GETTERS
364      * 
365      */
366 
367     /**
368      * Get Data
369      * 
370      * Retrieves the value for the given nametag id and data field.
371      */
372     function getData(
373         string _nametag, 
374         string _field
375     ) external view returns (bytes data) {
376         /* Calculate the data id. */
377         bytes32 dataId = keccak256(abi.encodePacked(
378             _namespace, '.', 
379             _nametag, '.', 
380             _field
381         ));
382         
383         /* Retrieve data. */
384         data = _zer0netDb.getBytes(dataId);
385     }
386 
387     /**
388      * Get Permissions
389      * 
390      * Owners can grant authority to delegated accounts with pre-determined
391      * abilities for managing the primary account.
392      * 
393      * This allows them to carry-out normal, everyday functions without 
394      * exposing the security of a more secure account.
395      */
396     function getPermissions(
397         string _nametag,
398         address _owner,
399         address _delegate
400     ) external view returns (bytes permissions) {
401         /* Set hash. */
402         bytes32 dataId = keccak256(abi.encodePacked(
403             _namespace, '.', 
404             _nametag, '.', 
405             _owner, '.', 
406             _delegate, 
407             '.permissions'
408         ));
409         
410         /* Save data to database. */
411         permissions = _zer0netDb.getBytes(dataId);
412     }
413     
414     /**
415      * Get Respect
416      */
417     function _getRespect(
418         address _owner,
419         address _peer
420     ) private view returns (uint respect) {
421         /* Calculate the data id. */
422         bytes32 dataId = keccak256(abi.encodePacked(
423             _namespace, '.', 
424             _owner, 
425             '.respect.for.', 
426             _peer
427         ));
428         
429         /* Retrieve data from database. */
430         respect = _zer0netDb.getUint(dataId);
431     }
432     /**
433      * Get Revision (Number)
434      */
435     function getRevision() public view returns (uint) {
436         return _revision;
437     }
438 
439     /**
440      * Get Predecessor (Address)
441      */
442     function getPredecessor() public view returns (address) {
443         return _predecessor;
444     }
445     
446     /**
447      * Get Successor (Address)
448      */
449     function getSuccessor() public view returns (address) {
450         return _successor;
451     }
452     
453 
454     /***************************************************************************
455      * 
456      * SETTERS
457      * 
458      */
459 
460     /**
461      * Set (Nametag) Data
462      * 
463      * NOTE: Nametags are NOT permanent, and WILL become vacated after an 
464      *       extended period of inactivity.
465      * 
466      *       *** LIMIT OF ONE AUTHORIZED ACCOUNT / ADDRESS PER NAMETAG ***
467      */
468     function setData(
469         string _nametag, 
470         string _field, 
471         bytes _data
472     ) external onlyNametagOwner(_nametag) returns (bool success) {
473         /* Set data. */
474         return _setData(
475             _nametag, 
476             _field, 
477             _data
478         );
479     }
480 
481     /**
482      * Set (Nametag) Data (by Relayer)
483      */
484     function setData(
485         string _nametag, 
486         string _field, 
487         bytes _data,
488         uint _expires,
489         uint _nonce,
490         bytes _signature
491     ) external returns (bool success) {
492         /* Make sure the signature has not expired. */
493         if (block.number > _expires) {
494             revert('Oops! That signature has already EXPIRED.');
495         }
496 
497         /* Calculate encoded data hash. */
498         bytes32 hash = keccak256(abi.encodePacked(
499             address(this),
500             _nametag, 
501             _field, 
502             _data, 
503             _expires,
504             _nonce
505         ));
506         
507         /* Validate signature. */
508         if (!_validateSignature(_nametag, hash, _signature)) {
509             revert('Oops! Your signature is INVALID.');
510         }
511 
512         /* Set data. */
513         return _setData(
514             _nametag, 
515             _field, 
516             _data
517         );
518     }
519 
520     /**
521      * @notice Set nametag info.
522      * 
523      * @dev Calculate the `_root` hash and use it to store a
524      *      definition string in the eternal database.
525      * 
526      *      NOTE: Markdown will be the default format for definitions.
527      */
528     function _setData(
529         string _nametag, 
530         string _field, 
531         bytes _data
532     ) private returns (bool success) {
533         /* Calculate the data id. */
534         bytes32 dataId = keccak256(abi.encodePacked(
535             _namespace, '.', 
536             _nametag, '.', 
537             _field
538         ));
539         
540         /* Save data to database. */
541         _zer0netDb.setBytes(dataId, _data);
542 
543         /* Broadcast event. */
544         emit Update(
545             _nametag,
546             _field,
547             _data
548         );
549 
550         /* Return success. */
551         return true;
552     }
553     
554     /**
555      * Set Permissions
556      */
557     function setPermissions(
558         string _nametag,
559         address _delegate,
560         bytes _permissions
561     ) external returns (bool success) {
562         /* Set permissions. */
563         return _setPermissions(
564             _nametag, 
565             msg.sender, 
566             _delegate, 
567             _permissions
568         );
569     }
570 
571     /**
572      * Set Permissions
573      */
574     function setPermissions(
575         string _nametag,
576         address _owner,
577         address _delegate,
578         bytes _permissions,
579         uint _expires,
580         uint _nonce,
581         bytes _signature
582     ) external returns (bool success) {
583         /* Make sure the signature has not expired. */
584         if (block.number > _expires) {
585             revert('Oops! That signature has already EXPIRED.');
586         }
587 
588         /* Calculate encoded data hash. */
589         bytes32 hash = keccak256(abi.encodePacked(
590             address(this),
591             _nametag,
592             _owner, 
593             _delegate, 
594             _permissions, 
595             _expires,
596             _nonce
597         ));
598 
599         /* Validate signature. */
600         if (!_validateSignature(_nametag, hash, _signature)) {
601             revert('Oops! Your signature is INVALID.');
602         }
603 
604         /* Set permissions. */
605         return _setPermissions(
606             _nametag, 
607             _owner, 
608             _delegate, 
609             _permissions
610         );
611     }
612 
613     /**
614      * Set Permissions
615      * 
616      * Allows owners to delegate another Ethereum account
617      * to proxy commands as if they are the primary account.
618      * 
619      * Permissions are encoded as TWO (2) bytes in a bytes array. ALL permissions
620      * are assumed to be false, unless explicitly specified in this bytes array.
621      * 
622      * Proposed Permissions List
623      * -------------------------
624      * 
625      * TODO Review Web3 JSON api for best (data access) structure.
626      *      (see https://web3js.readthedocs.io/en/1.0/web3.html)
627      * 
628      *     Profile Management (0x10__)
629      *         0x1001 => Modify Public Info
630      *         0x1002 => Modify Private Info
631      *         0x1003 => Modify Permissions
632      * 
633      *     HODL Management (0x20__)
634      *         0x2001 => Deposit Tokens
635      *         0x2002 => Withdraw Tokens
636      * 
637      *     SPEDN Management (0x30__)
638      *         0x3001 => Transfer ANY ERC
639      *         0x3002 => Transfer ERC-20
640      *         0x3003 => Transfer ERC-721
641      * 
642      *     STAEK Management (0x40__)
643      *         0x4001 => Increase Staek
644      *         0x4002 => Decrease Staek
645      *         0x4003 => Shift/Transfer Staek
646      * 
647      *     Exchange / Trade Execution (0x50__)
648      *         0x5001 => Place Order (Maker)
649      *         0x5002 => Place Order (Taker)
650      *         0x5003 => Margin Account
651      * 
652      *     Voting & Governance (0x60__)
653      *         0x6001 => Cast Vote
654      * 
655      * (this specification is in active development and subject to change)
656      * 
657      * NOTE: Permissions WILL NOT be transferred between owners.
658      */
659     function _setPermissions(
660         string _nametag,
661         address _owner,
662         address _delegate,
663         bytes _permissions
664     ) private returns (bool success) {
665         /* Set data id. */
666         bytes32 dataId = keccak256(abi.encodePacked(
667             _namespace, '.', 
668             _nametag, '.', 
669             _owner, '.', 
670             _delegate, 
671             '.permissions'
672         ));
673         
674         /* Save data to database. */
675         _zer0netDb.setBytes(dataId, _permissions);
676 
677         /* Broadcast event. */
678         emit Permissions(_owner, _delegate, _permissions);
679 
680         /* Return success. */
681         return true;
682     }
683     
684     /**
685      * Set Respect
686      */
687     function _setRespect(
688         address _owner,
689         address _peer,
690         uint _respect
691     ) private returns (bool success) {
692         /* Validate respect. */
693         if (_respect == 0) {
694             revert('Oops! Your respect is TOO LOW.');
695         }
696 
697         /* Validate respect. */
698         if (_respect > 5) {
699             revert('Oops! Your respect is TOO MUCH.');
700         }
701 
702         /* Calculate the data id. */
703         bytes32 dataId = keccak256(abi.encodePacked(
704             _namespace, '.', 
705             _owner, 
706             '.respect.for.', 
707             _peer
708         ));
709         
710         /* Save data to database. */
711         _zer0netDb.setUint(dataId, _respect);
712 
713         /* Broadcast event. */
714         emit Respect(
715             _owner,
716             _peer, 
717             _respect
718         );
719         
720         /* Return success. */
721         return true;
722     }
723     
724     /**
725      * Set Successor
726      * 
727      * This is the contract address that replaced this current instnace.
728      */
729     function setSuccessor(
730         address _newSuccessor
731     ) onlyAuthBy0Admin external returns (bool success) {
732         /* Set successor contract. */
733         _successor = _newSuccessor;
734         
735         /* Return success. */
736         return true;
737     }
738 
739 
740     /***************************************************************************
741      * 
742      * INTERFACES
743      * 
744      */
745 
746     /**
747      * Supports Interface (EIP-165)
748      * 
749      * (see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md)
750      * 
751      * NOTE: Must support the following conditions:
752      *       1. (true) when interfaceID is 0x01ffc9a7 (EIP165 interface)
753      *       2. (false) when interfaceID is 0xffffffff
754      *       3. (true) for any other interfaceID this contract implements
755      *       4. (false) for any other interfaceID
756      */
757     function supportsInterface(
758         bytes4 _interfaceID
759     ) external pure returns (bool) {
760         /* Initialize constants. */
761         bytes4 InvalidId = 0xffffffff;
762         bytes4 ERC165Id = 0x01ffc9a7;
763 
764         /* Validate condition #2. */
765         if (_interfaceID == InvalidId) {
766             return false;
767         }
768 
769         /* Validate condition #1. */
770         if (_interfaceID == ERC165Id) {
771             return true;
772         }
773         
774         // TODO Add additional interfaces here.
775         
776         /* Return false (for condition #4). */
777         return false;
778     }
779 
780     /**
781      * ECRecovery Interface
782      */
783     function _ecRecovery() private view returns (
784         ECRecovery ecrecovery
785     ) {
786         /* Initialize hash. */
787         bytes32 hash = keccak256('aname.ecrecovery');
788         
789         /* Retrieve value from Zer0net Db. */
790         address aname = _zer0netDb.getAddress(hash);
791         
792         /* Initialize interface. */
793         ecrecovery = ECRecovery(aname);
794     }
795 
796     /**
797      * ZeroCache Interface
798      *
799      * Retrieves the current ZeroCache interface,
800      * using the aname record from Zer0netDb.
801      */
802     function _zeroCache() private view returns (
803         ZeroCacheInterface zeroCache
804     ) {
805         /* Initialize hash. */
806         bytes32 hash = keccak256('aname.zerocache');
807 
808         /* Retrieve value from Zer0net Db. */
809         address aname = _zer0netDb.getAddress(hash);
810 
811         /* Initialize interface. */
812         zeroCache = ZeroCacheInterface(aname);
813     }
814 
815 
816     /***************************************************************************
817      * 
818      * UTILITIES
819      * 
820      */
821 
822     /**
823      * Validate Signature
824      */
825     function _validateSignature(
826         string _nametag,
827         bytes32 _sigHash,
828         bytes _signature
829     ) private view returns (bool authorized) {
830         /* Calculate owner hash. */
831         bytes32 ownerHash = keccak256(abi.encodePacked(
832             _namespace, '.',
833             _nametag,
834             '.owner'
835         ));
836 
837         /* Retrieve nametag owner. */
838         address nametagOwner = _zer0netDb.getAddress(ownerHash);
839 
840         /* Calculate signature hash. */
841         bytes32 sigHash = keccak256(abi.encodePacked(
842             '\x19Ethereum Signed Message:\n32', _sigHash));
843 
844         /* Retrieve the authorized signer. */
845         address signer = 
846             _ecRecovery().recover(sigHash, _signature);
847         
848         /* Validate signer. */
849         authorized = (signer == nametagOwner);
850     }
851 
852     /**
853      * Is (Owner) Contract
854      * 
855      * Tests if a specified account / address is a contract.
856      */
857     function _ownerIsContract(
858         address _owner
859     ) private view returns (bool isContract) {
860         /* Initialize code length. */
861         uint codeLength;
862 
863         /* Run assembly. */
864         assembly {
865             /* Retrieve the size of the code on target address. */
866             codeLength := extcodesize(_owner)
867         }
868         
869         /* Set test result. */
870         isContract = (codeLength > 0);
871     }
872 
873     /**
874      * Bytes-to-Address
875      * 
876      * Converts bytes into type address.
877      */
878     function _bytesToAddress(
879         bytes _address
880     ) private pure returns (address) {
881         uint160 m = 0;
882         uint160 b = 0;
883 
884         for (uint8 i = 0; i < 20; i++) {
885             m *= 256;
886             b = uint160(_address[i]);
887             m += (b);
888         }
889 
890         return address(m);
891     }
892 
893     /**
894      * Convert Bytes to Bytes32
895      */
896     function _bytesToBytes32(
897         bytes _data,
898         uint _offset
899     ) private pure returns (bytes32 result) {
900         /* Loop through each byte. */
901         for (uint i = 0; i < 32; i++) {
902             /* Shift bytes onto result. */
903             result |= bytes32(_data[i + _offset] & 0xFF) >> (i * 8);
904         }
905     }
906     
907     /**
908      * Convert Bytes32 to Bytes
909      * 
910      * NOTE: Since solidity v0.4.22, you can use `abi.encodePacked()` for this, 
911      *       which returns bytes. (https://ethereum.stackexchange.com/a/55963)
912      */
913     function _bytes32ToBytes(
914         bytes32 _data
915     ) private pure returns (bytes result) {
916         /* Pack the data. */
917         return abi.encodePacked(_data);
918     }
919 
920     /**
921      * Transfer Any ERC20 Token
922      *
923      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
924      *
925      * @dev Provides an ERC20 interface, which allows for the recover
926      *      of any accidentally sent ERC20 tokens.
927      */
928     function transferAnyERC20Token(
929         address _tokenAddress, 
930         uint _tokens
931     ) public onlyOwner returns (bool success) {
932         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
933     }
934 }