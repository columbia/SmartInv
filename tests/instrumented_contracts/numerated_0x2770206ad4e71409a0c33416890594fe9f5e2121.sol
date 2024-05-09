1 pragma solidity ^0.4.24;
2 
3 // File: contracts/identity/ERC735.sol
4 
5 /**
6  * @title ERC735 Claim Holder
7  * @notice Implementation by Origin Protocol
8  * @dev https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ERC735.sol
9  */
10 contract ERC735 {
11 
12     event ClaimRequested(
13         uint256 indexed claimRequestId,
14         uint256 indexed topic,
15         uint256 scheme,
16         address indexed issuer,
17         bytes signature,
18         bytes data,
19         string uri
20     );
21     event ClaimAdded(
22         bytes32 indexed claimId,
23         uint256 indexed topic,
24         uint256 scheme,
25         address indexed issuer,
26         bytes signature,
27         bytes data,
28         string uri
29     );
30     event ClaimRemoved(
31         bytes32 indexed claimId,
32         uint256 indexed topic,
33         uint256 scheme,
34         address indexed issuer,
35         bytes signature,
36         bytes data,
37         string uri
38     );
39     event ClaimChanged(
40         bytes32 indexed claimId,
41         uint256 indexed topic,
42         uint256 scheme,
43         address indexed issuer,
44         bytes signature,
45         bytes data,
46         string uri
47     );
48 
49     struct Claim {
50         uint256 topic;
51         uint256 scheme;
52         address issuer; // msg.sender
53         bytes signature; // this.address + topic + data
54         bytes data;
55         string uri;
56     }
57 
58     function getClaim(bytes32 _claimId)
59         public view returns(uint256 topic, uint256 scheme, address issuer, bytes signature, bytes data, string uri);
60     function getClaimIdsByTopic(uint256 _topic)
61         public view returns(bytes32[] claimIds);
62     function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes _signature, bytes _data, string _uri)
63         public returns (bytes32 claimRequestId);
64     function removeClaim(bytes32 _claimId)
65         public returns (bool success);
66 }
67 
68 // File: contracts/identity/ERC725.sol
69 
70 /**
71  * @title ERC725 Proxy Identity
72  * @notice Implementation by Origin Protocol
73  * @dev https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ERC725.sol
74  */
75 contract ERC725 {
76 
77     uint256 constant MANAGEMENT_KEY = 1;
78     uint256 constant ACTION_KEY = 2;
79     uint256 constant CLAIM_SIGNER_KEY = 3;
80     uint256 constant ENCRYPTION_KEY = 4;
81 
82     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
83     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
84     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
85     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
86     event Approved(uint256 indexed executionId, bool approved);
87 
88     function getKey(bytes32 _key) public view returns(uint256[] purposes, uint256 keyType, bytes32 key);
89     function keyHasPurpose(bytes32 _key, uint256 _purpose) public view returns (bool exists);
90     function getKeysByPurpose(uint256 _purpose) public view returns(bytes32[] keys);
91     function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) public returns (bool success);
92     function removeKey(bytes32 _key, uint256 _purpose) public returns (bool success);
93     function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId);
94     function approve(uint256 _id, bool _approve) public returns (bool success);
95 }
96 
97 // File: contracts/identity/KeyHolderLibrary.sol
98 
99 /**
100  * @title Library for KeyHolder.
101  * @notice Fork of Origin Protocol's implementation at
102  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/KeyHolderLibrary.sol
103  * We want to add purpose to already existing key.
104  * We do not want to have purpose J if you have purpose I and I < J
105  * Exception: we want a key of purpose 1 to have all purposes.
106  * @author Talao, Polynomial.
107  */
108 library KeyHolderLibrary {
109     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
110     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
111     event PurposeAdded(bytes32 indexed key, uint256 indexed purpose);
112     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
113     event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
114     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
115     event Approved(uint256 indexed executionId, bool approved);
116 
117     struct Key {
118         uint256[] purposes; //e.g., MANAGEMENT_KEY = 1, ACTION_KEY = 2, etc.
119         uint256 keyType; // e.g. 1 = ECDSA, 2 = RSA, etc.
120         bytes32 key;
121     }
122 
123     struct KeyHolderData {
124         uint256 executionNonce;
125         mapping (bytes32 => Key) keys;
126         mapping (uint256 => bytes32[]) keysByPurpose;
127         mapping (uint256 => Execution) executions;
128     }
129 
130     struct Execution {
131         address to;
132         uint256 value;
133         bytes data;
134         bool approved;
135         bool executed;
136     }
137 
138     function init(KeyHolderData storage _keyHolderData)
139         public
140     {
141         bytes32 _key = keccak256(abi.encodePacked(msg.sender));
142         _keyHolderData.keys[_key].key = _key;
143         _keyHolderData.keys[_key].purposes.push(1);
144         _keyHolderData.keys[_key].keyType = 1;
145         _keyHolderData.keysByPurpose[1].push(_key);
146         emit KeyAdded(_key, 1, 1);
147     }
148 
149     function getKey(KeyHolderData storage _keyHolderData, bytes32 _key)
150         public
151         view
152         returns(uint256[] purposes, uint256 keyType, bytes32 key)
153     {
154         return (
155             _keyHolderData.keys[_key].purposes,
156             _keyHolderData.keys[_key].keyType,
157             _keyHolderData.keys[_key].key
158         );
159     }
160 
161     function getKeyPurposes(KeyHolderData storage _keyHolderData, bytes32 _key)
162         public
163         view
164         returns(uint256[] purposes)
165     {
166         return (_keyHolderData.keys[_key].purposes);
167     }
168 
169     function getKeysByPurpose(KeyHolderData storage _keyHolderData, uint256 _purpose)
170         public
171         view
172         returns(bytes32[] _keys)
173     {
174         return _keyHolderData.keysByPurpose[_purpose];
175     }
176 
177     function addKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose, uint256 _type)
178         public
179         returns (bool success)
180     {
181         require(_keyHolderData.keys[_key].key != _key, "Key already exists"); // Key should not already exist
182         if (msg.sender != address(this)) {
183             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
184         }
185 
186         _keyHolderData.keys[_key].key = _key;
187         _keyHolderData.keys[_key].purposes.push(_purpose);
188         _keyHolderData.keys[_key].keyType = _type;
189 
190         _keyHolderData.keysByPurpose[_purpose].push(_key);
191 
192         emit KeyAdded(_key, _purpose, _type);
193 
194         return true;
195     }
196 
197     // We want to be able to add purpose to an existing key.
198     function addPurpose(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
199         public
200         returns (bool)
201     {
202         require(_keyHolderData.keys[_key].key == _key, "Key does not exist"); // Key should already exist
203         if (msg.sender != address(this)) {
204             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
205         }
206 
207         _keyHolderData.keys[_key].purposes.push(_purpose);
208 
209         _keyHolderData.keysByPurpose[_purpose].push(_key);
210 
211         emit PurposeAdded(_key, _purpose);
212 
213         return true;
214     }
215 
216     function approve(KeyHolderData storage _keyHolderData, uint256 _id, bool _approve)
217         public
218         returns (bool success)
219     {
220         require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 2), "Sender does not have action key");
221         require(!_keyHolderData.executions[_id].executed, "Already executed");
222 
223         emit Approved(_id, _approve);
224 
225         if (_approve == true) {
226             _keyHolderData.executions[_id].approved = true;
227             success = _keyHolderData.executions[_id].to.call(_keyHolderData.executions[_id].data, 0);
228             if (success) {
229                 _keyHolderData.executions[_id].executed = true;
230                 emit Executed(
231                     _id,
232                     _keyHolderData.executions[_id].to,
233                     _keyHolderData.executions[_id].value,
234                     _keyHolderData.executions[_id].data
235                 );
236                 return;
237             } else {
238                 emit ExecutionFailed(
239                     _id,
240                     _keyHolderData.executions[_id].to,
241                     _keyHolderData.executions[_id].value,
242                     _keyHolderData.executions[_id].data
243                 );
244                 return;
245             }
246         } else {
247             _keyHolderData.executions[_id].approved = false;
248         }
249         return true;
250     }
251 
252     function execute(KeyHolderData storage _keyHolderData, address _to, uint256 _value, bytes _data)
253         public
254         returns (uint256 executionId)
255     {
256         require(!_keyHolderData.executions[_keyHolderData.executionNonce].executed, "Already executed");
257         _keyHolderData.executions[_keyHolderData.executionNonce].to = _to;
258         _keyHolderData.executions[_keyHolderData.executionNonce].value = _value;
259         _keyHolderData.executions[_keyHolderData.executionNonce].data = _data;
260 
261         emit ExecutionRequested(_keyHolderData.executionNonce, _to, _value, _data);
262 
263         if (
264             keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),1) ||
265             keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),2)
266         ) {
267             approve(_keyHolderData, _keyHolderData.executionNonce, true);
268         }
269 
270         _keyHolderData.executionNonce++;
271         return _keyHolderData.executionNonce-1;
272     }
273 
274     function removeKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
275         public
276         returns (bool success)
277     {
278         if (msg.sender != address(this)) {
279             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
280         }
281 
282         require(_keyHolderData.keys[_key].key == _key, "No such key");
283         emit KeyRemoved(_key, _purpose, _keyHolderData.keys[_key].keyType);
284 
285         // Remove purpose from key
286         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
287         for (uint i = 0; i < purposes.length; i++) {
288             if (purposes[i] == _purpose) {
289                 purposes[i] = purposes[purposes.length - 1];
290                 delete purposes[purposes.length - 1];
291                 purposes.length--;
292                 break;
293             }
294         }
295 
296         // If no more purposes, delete key
297         if (purposes.length == 0) {
298             delete _keyHolderData.keys[_key];
299         }
300 
301         // Remove key from keysByPurpose
302         bytes32[] storage keys = _keyHolderData.keysByPurpose[_purpose];
303         for (uint j = 0; j < keys.length; j++) {
304             if (keys[j] == _key) {
305                 keys[j] = keys[keys.length - 1];
306                 delete keys[keys.length - 1];
307                 keys.length--;
308                 break;
309             }
310         }
311 
312         return true;
313     }
314 
315     function keyHasPurpose(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
316         public
317         view
318         returns(bool isThere)
319     {
320         if (_keyHolderData.keys[_key].key == 0) {
321             isThere = false;
322         }
323 
324         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
325         for (uint i = 0; i < purposes.length; i++) {
326             // We do not want to have purpose J if you have purpose I and I < J
327             // Exception: we want purpose 1 to have all purposes.
328             if (purposes[i] == _purpose || purposes[i] == 1) {
329                 isThere = true;
330                 break;
331             }
332         }
333     }
334 }
335 
336 // File: contracts/identity/KeyHolder.sol
337 
338 /**
339  * @title Manages an ERC 725 identity keys.
340  * @notice Fork of Origin Protocol's implementation at
341  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/KeyHolder.sol
342  *
343  * We defined our own set of "sub-ACTION" keys:
344  * - 20001 = read private profile & documents (grants isReader()).
345  *  Usefull for contracts, for instance to add import contracts.
346  * - 20002 = write "Private profile" & Documents (except issueDocument)
347  * - 20003 = read Partnerships
348  * - 20004 = blacklist / unblacklist for identityboxSendtext/identityboxSendfile
349  * We also use:
350  * - 3 = CLAIM = to issueDocument
351  *
352  * Moreover we can add purpose to already existing key.
353  */
354 contract KeyHolder is ERC725 {
355     KeyHolderLibrary.KeyHolderData keyHolderData;
356 
357     constructor() public {
358         KeyHolderLibrary.init(keyHolderData);
359     }
360 
361     function getKey(bytes32 _key)
362         public
363         view
364         returns(uint256[] purposes, uint256 keyType, bytes32 key)
365     {
366         return KeyHolderLibrary.getKey(keyHolderData, _key);
367     }
368 
369     function getKeyPurposes(bytes32 _key)
370         public
371         view
372         returns(uint256[] purposes)
373     {
374         return KeyHolderLibrary.getKeyPurposes(keyHolderData, _key);
375     }
376 
377     function getKeysByPurpose(uint256 _purpose)
378         public
379         view
380         returns(bytes32[] _keys)
381     {
382         return KeyHolderLibrary.getKeysByPurpose(keyHolderData, _purpose);
383     }
384 
385     function addKey(bytes32 _key, uint256 _purpose, uint256 _type)
386         public
387         returns (bool success)
388     {
389         return KeyHolderLibrary.addKey(keyHolderData, _key, _purpose, _type);
390     }
391 
392     function addPurpose(bytes32 _key, uint256 _purpose)
393         public
394         returns (bool)
395     {
396         return KeyHolderLibrary.addPurpose(keyHolderData, _key, _purpose);
397     }
398 
399     function approve(uint256 _id, bool _approve)
400         public
401         returns (bool success)
402     {
403         return KeyHolderLibrary.approve(keyHolderData, _id, _approve);
404     }
405 
406     function execute(address _to, uint256 _value, bytes _data)
407         public
408         returns (uint256 executionId)
409     {
410         return KeyHolderLibrary.execute(keyHolderData, _to, _value, _data);
411     }
412 
413     function removeKey(bytes32 _key, uint256 _purpose)
414         public
415         returns (bool success)
416     {
417         return KeyHolderLibrary.removeKey(keyHolderData, _key, _purpose);
418     }
419 
420     function keyHasPurpose(bytes32 _key, uint256 _purpose)
421         public
422         view
423         returns(bool exists)
424     {
425         return KeyHolderLibrary.keyHasPurpose(keyHolderData, _key, _purpose);
426     }
427 
428 }
429 
430 // File: contracts/identity/ClaimHolderLibrary.sol
431 
432 /**
433  * @title Library for ClaimHolder.
434  * @notice Fork of Origin Protocol's implementation at
435  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ClaimHolderLibrary.sol
436  * @author Talao, Polynomial.
437  */
438 library ClaimHolderLibrary {
439     event ClaimAdded(
440         bytes32 indexed claimId,
441         uint256 indexed topic,
442         uint256 scheme,
443         address indexed issuer,
444         bytes signature,
445         bytes data,
446         string uri
447     );
448     event ClaimRemoved(
449         bytes32 indexed claimId,
450         uint256 indexed topic,
451         uint256 scheme,
452         address indexed issuer,
453         bytes signature,
454         bytes data,
455         string uri
456     );
457 
458     struct Claim {
459         uint256 topic;
460         uint256 scheme;
461         address issuer; // msg.sender
462         bytes signature; // this.address + topic + data
463         bytes data;
464         string uri;
465     }
466 
467     struct Claims {
468         mapping (bytes32 => Claim) byId;
469         mapping (uint256 => bytes32[]) byTopic;
470     }
471 
472     function addClaim(
473         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
474         Claims storage _claims,
475         uint256 _topic,
476         uint256 _scheme,
477         address _issuer,
478         bytes _signature,
479         bytes _data,
480         string _uri
481     )
482         public
483         returns (bytes32 claimRequestId)
484     {
485         if (msg.sender != address(this)) {
486             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 3), "Sender does not have claim signer key");
487         }
488 
489         bytes32 claimId = keccak256(abi.encodePacked(_issuer, _topic));
490 
491         if (_claims.byId[claimId].issuer != _issuer) {
492             _claims.byTopic[_topic].push(claimId);
493         }
494 
495         _claims.byId[claimId].topic = _topic;
496         _claims.byId[claimId].scheme = _scheme;
497         _claims.byId[claimId].issuer = _issuer;
498         _claims.byId[claimId].signature = _signature;
499         _claims.byId[claimId].data = _data;
500         _claims.byId[claimId].uri = _uri;
501 
502         emit ClaimAdded(
503             claimId,
504             _topic,
505             _scheme,
506             _issuer,
507             _signature,
508             _data,
509             _uri
510         );
511 
512         return claimId;
513     }
514 
515     /**
516      * @dev Slightly modified version of Origin Protocol's implementation.
517      * getBytes for signature was originally getBytes(_signature, (i * 65), 65)
518      * and now isgetBytes(_signature, (i * 32), 32)
519      * and if signature is empty, just return empty.
520      */
521     function addClaims(
522         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
523         Claims storage _claims,
524         uint256[] _topic,
525         address[] _issuer,
526         bytes _signature,
527         bytes _data,
528         uint256[] _offsets
529     )
530         public
531     {
532         uint offset = 0;
533         for (uint16 i = 0; i < _topic.length; i++) {
534             if (_signature.length > 0) {
535                 addClaim(
536                     _keyHolderData,
537                     _claims,
538                     _topic[i],
539                     1,
540                     _issuer[i],
541                     getBytes(_signature, (i * 32), 32),
542                     getBytes(_data, offset, _offsets[i]),
543                     ""
544                 );
545             } else {
546                 addClaim(
547                     _keyHolderData,
548                     _claims,
549                     _topic[i],
550                     1,
551                     _issuer[i],
552                     "",
553                     getBytes(_data, offset, _offsets[i]),
554                     ""
555                 );
556             }
557             offset += _offsets[i];
558         }
559     }
560 
561     function removeClaim(
562         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
563         Claims storage _claims,
564         bytes32 _claimId
565     )
566         public
567         returns (bool success)
568     {
569         if (msg.sender != address(this)) {
570             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key");
571         }
572 
573         emit ClaimRemoved(
574             _claimId,
575             _claims.byId[_claimId].topic,
576             _claims.byId[_claimId].scheme,
577             _claims.byId[_claimId].issuer,
578             _claims.byId[_claimId].signature,
579             _claims.byId[_claimId].data,
580             _claims.byId[_claimId].uri
581         );
582 
583         delete _claims.byId[_claimId];
584         return true;
585     }
586 
587     /**
588      * @dev "Update" self-claims.
589      */
590     function updateSelfClaims(
591         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
592         Claims storage _claims,
593         uint256[] _topic,
594         bytes _data,
595         uint256[] _offsets
596     )
597         public
598     {
599         uint offset = 0;
600         for (uint16 i = 0; i < _topic.length; i++) {
601             removeClaim(
602                 _keyHolderData,
603                 _claims,
604                 keccak256(abi.encodePacked(msg.sender, _topic[i]))
605             );
606             addClaim(
607                 _keyHolderData,
608                 _claims,
609                 _topic[i],
610                 1,
611                 msg.sender,
612                 "",
613                 getBytes(_data, offset, _offsets[i]),
614                 ""
615             );
616             offset += _offsets[i];
617         }
618     }
619 
620     function getClaim(Claims storage _claims, bytes32 _claimId)
621         public
622         view
623         returns(
624           uint256 topic,
625           uint256 scheme,
626           address issuer,
627           bytes signature,
628           bytes data,
629           string uri
630         )
631     {
632         return (
633             _claims.byId[_claimId].topic,
634             _claims.byId[_claimId].scheme,
635             _claims.byId[_claimId].issuer,
636             _claims.byId[_claimId].signature,
637             _claims.byId[_claimId].data,
638             _claims.byId[_claimId].uri
639         );
640     }
641 
642     function getBytes(bytes _str, uint256 _offset, uint256 _length)
643         internal
644         pure
645         returns (bytes)
646     {
647         bytes memory sig = new bytes(_length);
648         uint256 j = 0;
649         for (uint256 k = _offset; k < _offset + _length; k++) {
650             sig[j] = _str[k];
651             j++;
652         }
653         return sig;
654     }
655 }
656 
657 // File: contracts/identity/ClaimHolder.sol
658 
659 /**
660  * @title Manages ERC 735 claims.
661  * @notice Fork of Origin Protocol's implementation at
662  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ClaimHolder.sol
663  * @author Talao, Polynomial.
664  */
665 contract ClaimHolder is KeyHolder, ERC735 {
666 
667     ClaimHolderLibrary.Claims claims;
668 
669     function addClaim(
670         uint256 _topic,
671         uint256 _scheme,
672         address _issuer,
673         bytes _signature,
674         bytes _data,
675         string _uri
676     )
677         public
678         returns (bytes32 claimRequestId)
679     {
680         return ClaimHolderLibrary.addClaim(
681             keyHolderData,
682             claims,
683             _topic,
684             _scheme,
685             _issuer,
686             _signature,
687             _data,
688             _uri
689         );
690     }
691 
692     function addClaims(
693         uint256[] _topic,
694         address[] _issuer,
695         bytes _signature,
696         bytes _data,
697         uint256[] _offsets
698     )
699         public
700     {
701         ClaimHolderLibrary.addClaims(
702             keyHolderData,
703             claims,
704             _topic,
705             _issuer,
706             _signature,
707             _data,
708             _offsets
709         );
710     }
711 
712     function removeClaim(bytes32 _claimId) public returns (bool success) {
713         return ClaimHolderLibrary.removeClaim(keyHolderData, claims, _claimId);
714     }
715 
716     function updateSelfClaims(
717         uint256[] _topic,
718         bytes _data,
719         uint256[] _offsets
720     )
721         public
722     {
723         ClaimHolderLibrary.updateSelfClaims(
724             keyHolderData,
725             claims,
726             _topic,
727             _data,
728             _offsets
729         );
730     }
731 
732     function getClaim(bytes32 _claimId)
733         public
734         view
735         returns(
736             uint256 topic,
737             uint256 scheme,
738             address issuer,
739             bytes signature,
740             bytes data,
741             string uri
742         )
743     {
744         return ClaimHolderLibrary.getClaim(claims, _claimId);
745     }
746 
747     function getClaimIdsByTopic(uint256 _topic)
748         public
749         view
750         returns(bytes32[] claimIds)
751     {
752         return claims.byTopic[_topic];
753     }
754 }
755 
756 // File: contracts/ownership/OwnableUpdated.sol
757 
758 /**
759  * @title Ownable
760  * @notice Implementation by OpenZeppelin
761  * @dev The Ownable contract has an owner address, and provides basic authorization control
762  * functions, this simplifies the implementation of "user permissions".
763  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
764  */
765 contract OwnableUpdated {
766     address private _owner;
767 
768     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
769 
770     /**
771      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
772      * account.
773      */
774     constructor () internal {
775         _owner = msg.sender;
776         emit OwnershipTransferred(address(0), _owner);
777     }
778 
779     /**
780      * @return the address of the owner.
781      */
782     function owner() public view returns (address) {
783         return _owner;
784     }
785 
786     /**
787      * @dev Throws if called by any account other than the owner.
788      */
789     modifier onlyOwner() {
790         require(isOwner());
791         _;
792     }
793 
794     /**
795      * @return true if `msg.sender` is the owner of the contract.
796      */
797     function isOwner() public view returns (bool) {
798         return msg.sender == _owner;
799     }
800 
801     /**
802      * @dev Allows the current owner to relinquish control of the contract.
803      * @notice Renouncing to ownership will leave the contract without an owner.
804      * It will not be possible to call the functions with the `onlyOwner`
805      * modifier anymore.
806      */
807     function renounceOwnership() public onlyOwner {
808         emit OwnershipTransferred(_owner, address(0));
809         _owner = address(0);
810     }
811 
812     /**
813      * @dev Allows the current owner to transfer control of the contract to a newOwner.
814      * @param newOwner The address to transfer ownership to.
815      */
816     function transferOwnership(address newOwner) public onlyOwner {
817         _transferOwnership(newOwner);
818     }
819 
820     /**
821      * @dev Transfers control of the contract to a newOwner.
822      * @param newOwner The address to transfer ownership to.
823      */
824     function _transferOwnership(address newOwner) internal {
825         require(newOwner != address(0));
826         emit OwnershipTransferred(_owner, newOwner);
827         _owner = newOwner;
828     }
829 }
830 
831 // File: contracts/Foundation.sol
832 
833 /**
834  * @title Foundation contract.
835  * @author Talao, Polynomial.
836  */
837 contract Foundation is OwnableUpdated {
838 
839     // Registered foundation factories.
840     mapping(address => bool) public factories;
841 
842     // Owners (EOA) to contract addresses relationships.
843     mapping(address => address) public ownersToContracts;
844 
845     // Contract addresses to owners relationships.
846     mapping(address => address) public contractsToOwners;
847 
848     // Index of known contract addresses.
849     address[] private contractsIndex;
850 
851     // Members (EOA) to contract addresses relationships.
852     // In a Partnership.sol inherited contract, this allows us to create a
853     // modifier for most read functions in this contract that will authorize
854     // any account associated with an authorized Partnership contract.
855     mapping(address => address) public membersToContracts;
856 
857     // Index of known members for each contract.
858     // These are EOAs that were added once, even if removed now.
859     mapping(address => address[]) public contractsToKnownMembersIndexes;
860 
861     // Events for factories.
862     event FactoryAdded(address _factory);
863     event FactoryRemoved(address _factory);
864 
865     /**
866      * @dev Add a factory.
867      */
868     function addFactory(address _factory) external onlyOwner {
869         factories[_factory] = true;
870         emit FactoryAdded(_factory);
871     }
872 
873     /**
874      * @dev Remove a factory.
875      */
876     function removeFactory(address _factory) external onlyOwner {
877         factories[_factory] = false;
878         emit FactoryRemoved(_factory);
879     }
880 
881     /**
882      * @dev Modifier for factories.
883      */
884     modifier onlyFactory() {
885         require(
886             factories[msg.sender],
887             "You are not a factory"
888         );
889         _;
890     }
891 
892     /**
893      * @dev Set initial owner of a contract.
894      */
895     function setInitialOwnerInFoundation(
896         address _contract,
897         address _account
898     )
899         external
900         onlyFactory
901     {
902         require(
903             contractsToOwners[_contract] == address(0),
904             "Contract already has owner"
905         );
906         require(
907             ownersToContracts[_account] == address(0),
908             "Account already has contract"
909         );
910         contractsToOwners[_contract] = _account;
911         contractsIndex.push(_contract);
912         ownersToContracts[_account] = _contract;
913         membersToContracts[_account] = _contract;
914     }
915 
916     /**
917      * @dev Transfer a contract to another account.
918      */
919     function transferOwnershipInFoundation(
920         address _contract,
921         address _newAccount
922     )
923         external
924     {
925         require(
926             (
927                 ownersToContracts[msg.sender] == _contract &&
928                 contractsToOwners[_contract] == msg.sender
929             ),
930             "You are not the owner"
931         );
932         ownersToContracts[msg.sender] = address(0);
933         membersToContracts[msg.sender] = address(0);
934         ownersToContracts[_newAccount] = _contract;
935         membersToContracts[_newAccount] = _contract;
936         contractsToOwners[_contract] = _newAccount;
937         // Remark: we do not update the contracts members.
938         // It's the new owner's responsability to remove members, if needed.
939     }
940 
941     /**
942      * @dev Allows the current owner to relinquish control of the contract.
943      * This is called through the contract.
944      */
945     function renounceOwnershipInFoundation() external returns (bool success) {
946         // Remove members.
947         delete(contractsToKnownMembersIndexes[msg.sender]);
948         // Free the EOA, so he can become owner of a new contract.
949         delete(ownersToContracts[contractsToOwners[msg.sender]]);
950         // Assign the contract to no one.
951         delete(contractsToOwners[msg.sender]);
952         // Return.
953         success = true;
954     }
955 
956     /**
957      * @dev Add a member EOA to a contract.
958      */
959     function addMember(address _member) external {
960         require(
961             ownersToContracts[msg.sender] != address(0),
962             "You own no contract"
963         );
964         require(
965             membersToContracts[_member] == address(0),
966             "Address is already member of a contract"
967         );
968         membersToContracts[_member] = ownersToContracts[msg.sender];
969         contractsToKnownMembersIndexes[ownersToContracts[msg.sender]].push(_member);
970     }
971 
972     /**
973      * @dev Remove a member EOA to a contract.
974      */
975     function removeMember(address _member) external {
976         require(
977             ownersToContracts[msg.sender] != address(0),
978             "You own no contract"
979         );
980         require(
981             membersToContracts[_member] == ownersToContracts[msg.sender],
982             "Address is not member of this contract"
983         );
984         membersToContracts[_member] = address(0);
985         contractsToKnownMembersIndexes[ownersToContracts[msg.sender]].push(_member);
986     }
987 
988     /**
989      * @dev Getter for contractsIndex.
990      * The automatic getter can not return array.
991      */
992     function getContractsIndex()
993         external
994         onlyOwner
995         view
996         returns (address[])
997     {
998         return contractsIndex;
999     }
1000 
1001     /**
1002      * @dev Prevents accidental sending of ether.
1003      */
1004     function() public {
1005         revert("Prevent accidental sending of ether");
1006     }
1007 }
1008 
1009 // File: contracts/token/TalaoToken.sol
1010 
1011 /**
1012  * @title SafeMath
1013  * @dev Math operations with safety checks that throw on error
1014  */
1015 library SafeMath {
1016   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1017     if (a == 0) {
1018       return 0;
1019     }
1020     uint256 c = a * b;
1021     assert(c / a == b);
1022     return c;
1023   }
1024 
1025   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1026     uint256 c = a / b;
1027     return c;
1028   }
1029 
1030   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1031     assert(b <= a);
1032     return a - b;
1033   }
1034 
1035   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1036     uint256 c = a + b;
1037     assert(c >= a);
1038     return c;
1039   }
1040 }
1041 
1042 /**
1043  * @title Ownable
1044  * @dev The Ownable contract has an owner address, and provides basic authorization control
1045  * functions, this simplifies the implementation of "user permissions".
1046  */
1047 contract Ownable {
1048   address public owner;
1049 
1050 
1051   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1052 
1053 
1054   /**
1055    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1056    * account.
1057    */
1058   function Ownable() public {
1059     owner = msg.sender;
1060   }
1061 
1062 
1063   /**
1064    * @dev Throws if called by any account other than the owner.
1065    */
1066   modifier onlyOwner() {
1067     require(msg.sender == owner);
1068     _;
1069   }
1070 
1071 
1072   /**
1073    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1074    * @param newOwner The address to transfer ownership to.
1075    */
1076   function transferOwnership(address newOwner) public onlyOwner {
1077     require(newOwner != address(0));
1078     OwnershipTransferred(owner, newOwner);
1079     owner = newOwner;
1080   }
1081 
1082 }
1083 
1084 /**
1085  * @title TalaoMarketplace
1086  * @dev This contract is allowing users to buy or sell Talao tokens at a price set by the owner
1087  * @author Blockchain Partner
1088  */
1089 contract TalaoMarketplace is Ownable {
1090   using SafeMath for uint256;
1091 
1092   TalaoToken public token;
1093 
1094   struct MarketplaceData {
1095     uint buyPrice;
1096     uint sellPrice;
1097     uint unitPrice;
1098   }
1099 
1100   MarketplaceData public marketplace;
1101 
1102   event SellingPrice(uint sellingPrice);
1103   event TalaoBought(address buyer, uint amount, uint price, uint unitPrice);
1104   event TalaoSold(address seller, uint amount, uint price, uint unitPrice);
1105 
1106   /**
1107   * @dev Constructor of the marketplace pointing to the TALAO token address
1108   * @param talao the talao token address
1109   **/
1110   constructor(address talao)
1111       public
1112   {
1113       token = TalaoToken(talao);
1114   }
1115 
1116   /**
1117   * @dev Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
1118   * @param newSellPrice price the users can sell to the contract
1119   * @param newBuyPrice price users can buy from the contract
1120   * @param newUnitPrice to manage decimal issue 0,35 = 35 /100 (100 is unit)
1121   */
1122   function setPrices(uint256 newSellPrice, uint256 newBuyPrice, uint256 newUnitPrice)
1123       public
1124       onlyOwner
1125   {
1126       require (newSellPrice > 0 && newBuyPrice > 0 && newUnitPrice > 0, "wrong inputs");
1127       marketplace.sellPrice = newSellPrice;
1128       marketplace.buyPrice = newBuyPrice;
1129       marketplace.unitPrice = newUnitPrice;
1130   }
1131 
1132   /**
1133   * @dev Allow anyone to buy tokens against ether, depending on the buyPrice set by the contract owner.
1134   * @return amount the amount of tokens bought
1135   **/
1136   function buy()
1137       public
1138       payable
1139       returns (uint amount)
1140   {
1141       amount = msg.value.mul(marketplace.unitPrice).div(marketplace.buyPrice);
1142       token.transfer(msg.sender, amount);
1143       emit TalaoBought(msg.sender, amount, marketplace.buyPrice, marketplace.unitPrice);
1144       return amount;
1145   }
1146 
1147   /**
1148   * @dev Allow anyone to sell tokens for ether, depending on the sellPrice set by the contract owner.
1149   * @param amount the number of tokens to be sold
1150   * @return revenue ethers sent in return
1151   **/
1152   function sell(uint amount)
1153       public
1154       returns (uint revenue)
1155   {
1156       require(token.balanceOf(msg.sender) >= amount, "sender has not enough tokens");
1157       token.transferFrom(msg.sender, this, amount);
1158       revenue = amount.mul(marketplace.sellPrice).div(marketplace.unitPrice);
1159       msg.sender.transfer(revenue);
1160       emit TalaoSold(msg.sender, amount, marketplace.sellPrice, marketplace.unitPrice);
1161       return revenue;
1162   }
1163 
1164   /**
1165    * @dev Allows the owner to withdraw ethers from the contract.
1166    * @param ethers quantity of ethers to be withdrawn
1167    * @return true if withdrawal successful ; false otherwise
1168    */
1169   function withdrawEther(uint256 ethers)
1170       public
1171       onlyOwner
1172   {
1173       if (this.balance >= ethers) {
1174           msg.sender.transfer(ethers);
1175       }
1176   }
1177 
1178   /**
1179    * @dev Allow the owner to withdraw tokens from the contract.
1180    * @param tokens quantity of tokens to be withdrawn
1181    */
1182   function withdrawTalao(uint256 tokens)
1183       public
1184       onlyOwner
1185   {
1186       token.transfer(msg.sender, tokens);
1187   }
1188 
1189 
1190   /**
1191   * @dev Fallback function ; only owner can send ether.
1192   **/
1193   function ()
1194       public
1195       payable
1196       onlyOwner
1197   {
1198 
1199   }
1200 
1201 }
1202 
1203 /**
1204  * @title ERC20Basic
1205  * @dev Simpler version of ERC20 interface
1206  * @dev see https://github.com/ethereum/EIPs/issues/179
1207  */
1208 contract ERC20Basic {
1209   uint256 public totalSupply;
1210   function balanceOf(address who) public view returns (uint256);
1211   function transfer(address to, uint256 value) public returns (bool);
1212   event Transfer(address indexed from, address indexed to, uint256 value);
1213 }
1214 
1215 /**
1216  * @title ERC20 interface
1217  * @dev see https://github.com/ethereum/EIPs/issues/20
1218  */
1219 contract ERC20 is ERC20Basic {
1220   function allowance(address owner, address spender) public view returns (uint256);
1221   function transferFrom(address from, address to, uint256 value) public returns (bool);
1222   function approve(address spender, uint256 value) public returns (bool);
1223   event Approval(address indexed owner, address indexed spender, uint256 value);
1224 }
1225 
1226 /**
1227  * @title SafeERC20
1228  * @dev Wrappers around ERC20 operations that throw on failure.
1229  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1230  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1231  */
1232 library SafeERC20 {
1233   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1234     assert(token.transfer(to, value));
1235   }
1236 
1237   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1238     assert(token.transferFrom(from, to, value));
1239   }
1240 
1241   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1242     assert(token.approve(spender, value));
1243   }
1244 }
1245 
1246 
1247 /**
1248  * @title TokenTimelock
1249  * @dev TokenTimelock is a token holder contract that will allow a
1250  * beneficiary to extract the tokens after a given release time
1251  */
1252 contract TokenTimelock {
1253   using SafeERC20 for ERC20Basic;
1254 
1255   // ERC20 basic token contract being held
1256   ERC20Basic public token;
1257 
1258   // beneficiary of tokens after they are released
1259   address public beneficiary;
1260 
1261   // timestamp when token release is enabled
1262   uint256 public releaseTime;
1263 
1264   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
1265     require(_releaseTime > now);
1266     token = _token;
1267     beneficiary = _beneficiary;
1268     releaseTime = _releaseTime;
1269   }
1270 
1271   /**
1272    * @notice Transfers tokens held by timelock to beneficiary.
1273    * @dev Removed original require that amount released was > 0 ; releasing 0 is fine
1274    */
1275   function release() public {
1276     require(now >= releaseTime);
1277 
1278     uint256 amount = token.balanceOf(this);
1279 
1280     token.safeTransfer(beneficiary, amount);
1281   }
1282 }
1283 
1284 
1285 /**
1286  * @title TokenVesting
1287  * @dev A token holder contract that can release its token balance gradually like a
1288  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1289  * owner.
1290  * @notice Talao token transfer function cannot fail thus there's no need for revocation.
1291  */
1292 contract TokenVesting is Ownable {
1293   using SafeMath for uint256;
1294   using SafeERC20 for ERC20Basic;
1295 
1296   event Released(uint256 amount);
1297   event Revoked();
1298 
1299   // beneficiary of tokens after they are released
1300   address public beneficiary;
1301 
1302   uint256 public cliff;
1303   uint256 public start;
1304   uint256 public duration;
1305 
1306   bool public revocable;
1307 
1308   mapping (address => uint256) public released;
1309   mapping (address => bool) public revoked;
1310 
1311   /**
1312    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1313    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1314    * of the balance will have vested.
1315    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1316    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1317    * @param _duration duration in seconds of the period in which the tokens will vest
1318    * @param _revocable whether the vesting is revocable or not
1319    */
1320   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
1321     require(_beneficiary != address(0));
1322     require(_cliff <= _duration);
1323 
1324     beneficiary = _beneficiary;
1325     revocable = _revocable;
1326     duration = _duration;
1327     cliff = _start.add(_cliff);
1328     start = _start;
1329   }
1330 
1331   /**
1332    * @notice Transfers vested tokens to beneficiary.
1333    * @dev Removed original require that amount released was > 0 ; releasing 0 is fine
1334    * @param token ERC20 token which is being vested
1335    */
1336   function release(ERC20Basic token) public {
1337     uint256 unreleased = releasableAmount(token);
1338 
1339     released[token] = released[token].add(unreleased);
1340 
1341     token.safeTransfer(beneficiary, unreleased);
1342 
1343     Released(unreleased);
1344   }
1345 
1346   /**
1347    * @notice Allows the owner to revoke the vesting. Tokens already vested
1348    * remain in the contract, the rest are returned to the owner.
1349    * @param token ERC20 token which is being vested
1350    */
1351   function revoke(ERC20Basic token) public onlyOwner {
1352     require(revocable);
1353     require(!revoked[token]);
1354 
1355     uint256 balance = token.balanceOf(this);
1356 
1357     uint256 unreleased = releasableAmount(token);
1358     uint256 refund = balance.sub(unreleased);
1359 
1360     revoked[token] = true;
1361 
1362     token.safeTransfer(owner, refund);
1363 
1364     Revoked();
1365   }
1366 
1367   /**
1368    * @dev Calculates the amount that has already vested but hasn't been released yet.
1369    * @param token ERC20 token which is being vested
1370    */
1371   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1372     return vestedAmount(token).sub(released[token]);
1373   }
1374 
1375   /**
1376    * @dev Calculates the amount that has already vested.
1377    * @param token ERC20 token which is being vested
1378    */
1379   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1380     uint256 currentBalance = token.balanceOf(this);
1381     uint256 totalBalance = currentBalance.add(released[token]);
1382 
1383     if (now < cliff) {
1384       return 0;
1385     } else if (now >= start.add(duration) || revoked[token]) {
1386       return totalBalance;
1387     } else {
1388       return totalBalance.mul(now.sub(start)).div(duration);
1389     }
1390   }
1391 }
1392 
1393 /**
1394  * @title Crowdsale
1395  * @dev Crowdsale is a base contract for managing a token crowdsale.
1396  * Crowdsales have a start and end timestamps, where investors can make
1397  * token purchases and the crowdsale will assign them tokens based
1398  * on a token per ETH rate. Funds collected are forwarded to a wallet
1399  * as they arrive.
1400  */
1401 contract Crowdsale {
1402   using SafeMath for uint256;
1403 
1404   // The token being sold
1405   MintableToken public token;
1406 
1407   // start and end timestamps where investments are allowed (both inclusive)
1408   uint256 public startTime;
1409   uint256 public endTime;
1410 
1411   // address where funds are collected
1412   address public wallet;
1413 
1414   // how many token units a buyer gets per wei
1415   uint256 public rate;
1416 
1417   // amount of raised money in wei
1418   uint256 public weiRaised;
1419 
1420   /**
1421    * event for token purchase logging
1422    * @param purchaser who paid for the tokens
1423    * @param beneficiary who got the tokens
1424    * @param value weis paid for purchase
1425    * @param amount amount of tokens purchased
1426    */
1427   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1428 
1429   function Crowdsale(uint256 _rate, uint256 _startTime, uint256 _endTime, address _wallet) public {
1430     require(_rate > 0);
1431     require(_startTime >= now);
1432     require(_endTime >= _startTime);
1433     require(_wallet != address(0));
1434 
1435     token = createTokenContract();
1436     startTime = _startTime;
1437     endTime = _endTime;
1438     wallet = _wallet;
1439   }
1440 
1441   // creates the token to be sold.
1442   // override this method to have crowdsale of a specific mintable token.
1443   function createTokenContract() internal returns (MintableToken) {
1444     return new MintableToken();
1445   }
1446 
1447 
1448   // fallback function can be used to buy tokens
1449   function () external payable {
1450     buyTokens(msg.sender);
1451   }
1452 
1453   // low level token purchase function
1454   function buyTokens(address beneficiary) public payable {
1455     require(beneficiary != address(0));
1456     require(validPurchase());
1457 
1458     uint256 weiAmount = msg.value;
1459 
1460     // calculate token amount to be created
1461     uint256 tokens = weiAmount.mul(rate);
1462 
1463     // update state
1464     weiRaised = weiRaised.add(weiAmount);
1465 
1466     token.mint(beneficiary, tokens);
1467     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1468 
1469     forwardFunds();
1470   }
1471 
1472   // send ether to the fund collection wallet
1473   // override to create custom fund forwarding mechanisms
1474   function forwardFunds() internal {
1475     wallet.transfer(msg.value);
1476   }
1477 
1478   // @return true if the transaction can buy tokens
1479   // removed view to be overriden
1480   function validPurchase() internal returns (bool) {
1481     bool withinPeriod = now >= startTime && now <= endTime;
1482     bool nonZeroPurchase = msg.value != 0;
1483     return withinPeriod && nonZeroPurchase;
1484   }
1485 
1486   // @return true if crowdsale event has ended
1487   function hasEnded() public view returns (bool) {
1488     return now > endTime;
1489   }
1490 
1491 
1492 }
1493 
1494 
1495 /**
1496  * @title FinalizableCrowdsale
1497  * @dev Extension of Crowdsale where an owner can do extra work
1498  * after finishing.
1499  */
1500 contract FinalizableCrowdsale is Crowdsale, Ownable {
1501   using SafeMath for uint256;
1502 
1503   bool public isFinalized = false;
1504 
1505   event Finalized();
1506 
1507   /**
1508    * @dev Must be called after crowdsale ends, to do some extra finalization
1509    * work. Calls the contract's finalization function.
1510    */
1511   function finalize() public {
1512     require(!isFinalized);
1513     require(hasEnded());
1514 
1515     finalization();
1516     Finalized();
1517 
1518     isFinalized = true;
1519   }
1520 
1521   /**
1522    * @dev Can be overridden to add finalization logic. The overriding function
1523    * should call super.finalization() to ensure the chain of finalization is
1524    * executed entirely.
1525    */
1526   function finalization() internal {
1527   }
1528 }
1529 
1530 
1531 /**
1532  * @title RefundVault
1533  * @dev This contract is used for storing funds while a crowdsale
1534  * is in progress. Supports refunding the money if crowdsale fails,
1535  * and forwarding it if crowdsale is successful.
1536  */
1537 contract RefundVault is Ownable {
1538   using SafeMath for uint256;
1539 
1540   enum State { Active, Refunding, Closed }
1541 
1542   mapping (address => uint256) public deposited;
1543   address public wallet;
1544   State public state;
1545 
1546   event Closed();
1547   event RefundsEnabled();
1548   event Refunded(address indexed beneficiary, uint256 weiAmount);
1549 
1550   function RefundVault(address _wallet) public {
1551     require(_wallet != address(0));
1552     wallet = _wallet;
1553     state = State.Active;
1554   }
1555 
1556   function deposit(address investor) onlyOwner public payable {
1557     require(state == State.Active);
1558     deposited[investor] = deposited[investor].add(msg.value);
1559   }
1560 
1561   function close() onlyOwner public {
1562     require(state == State.Active);
1563     state = State.Closed;
1564     Closed();
1565     wallet.transfer(this.balance);
1566   }
1567 
1568   function enableRefunds() onlyOwner public {
1569     require(state == State.Active);
1570     state = State.Refunding;
1571     RefundsEnabled();
1572   }
1573 
1574   function refund(address investor) public {
1575     require(state == State.Refunding);
1576     uint256 depositedValue = deposited[investor];
1577     deposited[investor] = 0;
1578     investor.transfer(depositedValue);
1579     Refunded(investor, depositedValue);
1580   }
1581 }
1582 
1583 
1584 
1585 /**
1586  * @title RefundableCrowdsale
1587  * @dev Extension of Crowdsale contract that adds a funding goal, and
1588  * the possibility of users getting a refund if goal is not met.
1589  * Uses a RefundVault as the crowdsale's vault.
1590  */
1591 contract RefundableCrowdsale is FinalizableCrowdsale {
1592   using SafeMath for uint256;
1593 
1594   // minimum amount of funds to be raised in weis
1595   uint256 public goal;
1596 
1597   // refund vault used to hold funds while crowdsale is running
1598   RefundVault public vault;
1599 
1600   function RefundableCrowdsale(uint256 _goal) public {
1601     require(_goal > 0);
1602     vault = new RefundVault(wallet);
1603     goal = _goal;
1604   }
1605 
1606   // We're overriding the fund forwarding from Crowdsale.
1607   // In addition to sending the funds, we want to call
1608   // the RefundVault deposit function
1609   function forwardFunds() internal {
1610     vault.deposit.value(msg.value)(msg.sender);
1611   }
1612 
1613   // if crowdsale is unsuccessful, investors can claim refunds here
1614   function claimRefund() public {
1615     require(isFinalized);
1616     require(!goalReached());
1617 
1618     vault.refund(msg.sender);
1619   }
1620 
1621   // vault finalization task, called when owner calls finalize()
1622   function finalization() internal {
1623     if (goalReached()) {
1624       vault.close();
1625     } else {
1626       vault.enableRefunds();
1627     }
1628 
1629     super.finalization();
1630   }
1631 
1632   function goalReached() public view returns (bool) {
1633     return weiRaised >= goal;
1634   }
1635 
1636 }
1637 
1638 
1639 /**
1640  * @title CappedCrowdsale
1641  * @dev Extension of Crowdsale with a max amount of funds raised
1642  */
1643 contract CappedCrowdsale is Crowdsale {
1644   using SafeMath for uint256;
1645 
1646   uint256 public cap;
1647 
1648   function CappedCrowdsale(uint256 _cap) public {
1649     require(_cap > 0);
1650     cap = _cap;
1651   }
1652 
1653   // overriding Crowdsale#validPurchase to add extra cap logic
1654   // @return true if investors can buy at the moment
1655   // removed view to be overriden
1656   function validPurchase() internal returns (bool) {
1657     bool withinCap = weiRaised.add(msg.value) <= cap;
1658     return super.validPurchase() && withinCap;
1659   }
1660 
1661   // overriding Crowdsale#hasEnded to add cap logic
1662   // @return true if crowdsale event has ended
1663   function hasEnded() public view returns (bool) {
1664     bool capReached = weiRaised >= cap;
1665     return super.hasEnded() || capReached;
1666   }
1667 
1668 }
1669 
1670 /**
1671  * @title ProgressiveIndividualCappedCrowdsale
1672  * @dev Extension of Crowdsale with a progressive individual cap
1673  * @dev This contract is not made for crowdsale superior to 256 * TIME_PERIOD_IN_SEC
1674  * @author Request.network ; some modifications by Blockchain Partner
1675  */
1676 contract ProgressiveIndividualCappedCrowdsale is RefundableCrowdsale, CappedCrowdsale {
1677 
1678     uint public startGeneralSale;
1679     uint public constant TIME_PERIOD_IN_SEC = 1 days;
1680     uint public constant minimumParticipation = 10 finney;
1681     uint public constant GAS_LIMIT_IN_WEI = 5E10 wei; // limit gas price -50 Gwei wales stopper
1682     uint256 public baseEthCapPerAddress;
1683 
1684     mapping(address=>uint) public participated;
1685 
1686     function ProgressiveIndividualCappedCrowdsale(uint _baseEthCapPerAddress, uint _startGeneralSale)
1687         public
1688     {
1689         baseEthCapPerAddress = _baseEthCapPerAddress;
1690         startGeneralSale = _startGeneralSale;
1691     }
1692 
1693     /**
1694      * @dev setting cap before the general sale starts
1695      * @param _newBaseCap the new cap
1696      */
1697     function setBaseCap(uint _newBaseCap)
1698         public
1699         onlyOwner
1700     {
1701         require(now < startGeneralSale);
1702         baseEthCapPerAddress = _newBaseCap;
1703     }
1704 
1705     /**
1706      * @dev overriding CappedCrowdsale#validPurchase to add an individual cap
1707      * @return true if investors can buy at the moment
1708      */
1709     function validPurchase()
1710         internal
1711         returns(bool)
1712     {
1713         bool gasCheck = tx.gasprice <= GAS_LIMIT_IN_WEI;
1714         uint ethCapPerAddress = getCurrentEthCapPerAddress();
1715         participated[msg.sender] = participated[msg.sender].add(msg.value);
1716         bool enough = participated[msg.sender] >= minimumParticipation;
1717         return participated[msg.sender] <= ethCapPerAddress && enough && gasCheck;
1718     }
1719 
1720     /**
1721      * @dev Get the current individual cap.
1722      * @dev This amount increase everyday in an exponential way. Day 1: base cap, Day 2: 2 * base cap, Day 3: 4 * base cap ...
1723      * @return individual cap in wei
1724      */
1725     function getCurrentEthCapPerAddress()
1726         public
1727         constant
1728         returns(uint)
1729     {
1730         if (block.timestamp < startGeneralSale) return 0;
1731         uint timeSinceStartInSec = block.timestamp.sub(startGeneralSale);
1732         uint currentPeriod = timeSinceStartInSec.div(TIME_PERIOD_IN_SEC).add(1);
1733 
1734         // for currentPeriod > 256 will always return 0
1735         return (2 ** currentPeriod.sub(1)).mul(baseEthCapPerAddress);
1736     }
1737 }
1738 
1739 /**
1740  * @title Basic token
1741  * @dev Basic version of StandardToken, with no allowances.
1742  */
1743 contract BasicToken is ERC20Basic {
1744   using SafeMath for uint256;
1745 
1746   mapping(address => uint256) balances;
1747 
1748   /**
1749   * @dev transfer token for a specified address
1750   * @param _to The address to transfer to.
1751   * @param _value The amount to be transferred.
1752   */
1753   function transfer(address _to, uint256 _value) public returns (bool) {
1754     require(_to != address(0));
1755     require(_value <= balances[msg.sender]);
1756 
1757     // SafeMath.sub will throw if there is not enough balance.
1758     balances[msg.sender] = balances[msg.sender].sub(_value);
1759     balances[_to] = balances[_to].add(_value);
1760     Transfer(msg.sender, _to, _value);
1761     return true;
1762   }
1763 
1764   /**
1765   * @dev Gets the balance of the specified address.
1766   * @param _owner The address to query the the balance of.
1767   * @return An uint256 representing the amount owned by the passed address.
1768   */
1769   function balanceOf(address _owner) public view returns (uint256 balance) {
1770     return balances[_owner];
1771   }
1772 
1773 }
1774 
1775 
1776 /**
1777  * @title Standard ERC20 token
1778  *
1779  * @dev Implementation of the basic standard token.
1780  * @dev https://github.com/ethereum/EIPs/issues/20
1781  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1782  */
1783 contract StandardToken is ERC20, BasicToken {
1784 
1785   mapping (address => mapping (address => uint256)) internal allowed;
1786 
1787 
1788   /**
1789    * @dev Transfer tokens from one address to another
1790    * @param _from address The address which you want to send tokens from
1791    * @param _to address The address which you want to transfer to
1792    * @param _value uint256 the amount of tokens to be transferred
1793    */
1794   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1795     require(_to != address(0));
1796     require(_value <= balances[_from]);
1797     require(_value <= allowed[_from][msg.sender]);
1798 
1799     balances[_from] = balances[_from].sub(_value);
1800     balances[_to] = balances[_to].add(_value);
1801     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1802     Transfer(_from, _to, _value);
1803     return true;
1804   }
1805 
1806   /**
1807    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1808    *
1809    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1810    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1811    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1812    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1813    * @param _spender The address which will spend the funds.
1814    * @param _value The amount of tokens to be spent.
1815    */
1816   function approve(address _spender, uint256 _value) public returns (bool) {
1817     allowed[msg.sender][_spender] = _value;
1818     Approval(msg.sender, _spender, _value);
1819     return true;
1820   }
1821 
1822   /**
1823    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1824    * @param _owner address The address which owns the funds.
1825    * @param _spender address The address which will spend the funds.
1826    * @return A uint256 specifying the amount of tokens still available for the spender.
1827    */
1828   function allowance(address _owner, address _spender) public view returns (uint256) {
1829     return allowed[_owner][_spender];
1830   }
1831 
1832   /**
1833    * @dev Increase the amount of tokens that an owner allowed to a spender.
1834    *
1835    * approve should be called when allowed[_spender] == 0. To increment
1836    * allowed value is better to use this function to avoid 2 calls (and wait until
1837    * the first transaction is mined)
1838    * From MonolithDAO Token.sol
1839    * @param _spender The address which will spend the funds.
1840    * @param _addedValue The amount of tokens to increase the allowance by.
1841    */
1842   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1843     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1844     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1845     return true;
1846   }
1847 
1848   /**
1849    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1850    *
1851    * approve should be called when allowed[_spender] == 0. To decrement
1852    * allowed value is better to use this function to avoid 2 calls (and wait until
1853    * the first transaction is mined)
1854    * From MonolithDAO Token.sol
1855    * @param _spender The address which will spend the funds.
1856    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1857    */
1858   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1859     uint oldValue = allowed[msg.sender][_spender];
1860     if (_subtractedValue > oldValue) {
1861       allowed[msg.sender][_spender] = 0;
1862     } else {
1863       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1864     }
1865     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1866     return true;
1867   }
1868 
1869 }
1870 
1871 /**
1872  * @title Mintable token
1873  * @dev Simple ERC20 Token example, with mintable token creation
1874  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
1875  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1876  */
1877 
1878 contract MintableToken is StandardToken, Ownable {
1879   event Mint(address indexed to, uint256 amount);
1880   event MintFinished();
1881 
1882   bool public mintingFinished = false;
1883 
1884 
1885   modifier canMint() {
1886     require(!mintingFinished);
1887     _;
1888   }
1889 
1890   /**
1891    * @dev Function to mint tokens
1892    * @param _to The address that will receive the minted tokens.
1893    * @param _amount The amount of tokens to mint.
1894    * @return A boolean that indicates if the operation was successful.
1895    */
1896   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1897     totalSupply = totalSupply.add(_amount);
1898     balances[_to] = balances[_to].add(_amount);
1899     Mint(_to, _amount);
1900     Transfer(address(0), _to, _amount);
1901     return true;
1902   }
1903 
1904   /**
1905    * @dev Function to stop minting new tokens.
1906    * @return True if the operation was successful.
1907    */
1908   function finishMinting() onlyOwner canMint public returns (bool) {
1909     mintingFinished = true;
1910     MintFinished();
1911     return true;
1912   }
1913 }
1914 
1915 
1916 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
1917 
1918 /**
1919  * @title TalaoToken
1920  * @dev This contract details the TALAO token and allows freelancers to create/revoke vault access, appoint agents.
1921  * @author Blockchain Partner
1922  */
1923 contract TalaoToken is MintableToken {
1924   using SafeMath for uint256;
1925 
1926   // token details
1927   string public constant name = "Talao";
1928   string public constant symbol = "TALAO";
1929   uint8 public constant decimals = 18;
1930 
1931   // the talao marketplace address
1932   address public marketplace;
1933 
1934   // talao tokens needed to create a vault
1935   uint256 public vaultDeposit;
1936   // sum of all talao tokens desposited
1937   uint256 public totalDeposit;
1938 
1939   struct FreelanceData {
1940       // access price to the talent vault
1941       uint256 accessPrice;
1942       // address of appointed talent agent
1943       address appointedAgent;
1944       // how much the talent is sharing with its agent
1945       uint sharingPlan;
1946       // how much is the talent deposit
1947       uint256 userDeposit;
1948   }
1949 
1950   // structure that defines a client access to a vault
1951   struct ClientAccess {
1952       // is he allowed to access the vault
1953       bool clientAgreement;
1954       // the block number when access was granted
1955       uint clientDate;
1956   }
1957 
1958   // Vault allowance client x freelancer
1959   mapping (address => mapping (address => ClientAccess)) public accessAllowance;
1960 
1961   // Freelance data is public
1962   mapping (address=>FreelanceData) public data;
1963 
1964   enum VaultStatus {Closed, Created, PriceTooHigh, NotEnoughTokensDeposited, AgentRemoved, NewAgent, NewAccess, WrongAccessPrice}
1965 
1966   // Those event notifies UI about vaults action with vault status
1967   // Closed Vault access closed
1968   // Created Vault access created
1969   // PriceTooHigh Vault access price too high
1970   // NotEnoughTokensDeposited not enough tokens to pay deposit
1971   // AgentRemoved agent removed
1972   // NewAgent new agent appointed
1973   // NewAccess vault access granted to client
1974   // WrongAccessPrice client not enough token to pay vault access
1975   event Vault(address indexed client, address indexed freelance, VaultStatus status);
1976 
1977   modifier onlyMintingFinished()
1978   {
1979       require(mintingFinished == true, "minting has not finished");
1980       _;
1981   }
1982 
1983   /**
1984   * @dev Let the owner set the marketplace address once minting is over
1985   *      Possible to do it more than once to ensure maintainability
1986   * @param theMarketplace the marketplace address
1987   **/
1988   function setMarketplace(address theMarketplace)
1989       public
1990       onlyMintingFinished
1991       onlyOwner
1992   {
1993       marketplace = theMarketplace;
1994   }
1995 
1996   /**
1997   * @dev Same ERC20 behavior, but require the token to be unlocked
1998   * @param _spender address The address that will spend the funds.
1999   * @param _value uint256 The amount of tokens to be spent.
2000   **/
2001   function approve(address _spender, uint256 _value)
2002       public
2003       onlyMintingFinished
2004       returns (bool)
2005   {
2006       return super.approve(_spender, _value);
2007   }
2008 
2009   /**
2010   * @dev Same ERC20 behavior, but require the token to be unlocked and sells some tokens to refill ether balance up to minBalanceForAccounts
2011   * @param _to address The address to transfer to.
2012   * @param _value uint256 The amount to be transferred.
2013   **/
2014   function transfer(address _to, uint256 _value)
2015       public
2016       onlyMintingFinished
2017       returns (bool result)
2018   {
2019       return super.transfer(_to, _value);
2020   }
2021 
2022   /**
2023   * @dev Same ERC20 behavior, but require the token to be unlocked
2024   * @param _from address The address which you want to send tokens from.
2025   * @param _to address The address which you want to transfer to.
2026   * @param _value uint256 the amount of tokens to be transferred.
2027   **/
2028   function transferFrom(address _from, address _to, uint256 _value)
2029       public
2030       onlyMintingFinished
2031       returns (bool)
2032   {
2033       return super.transferFrom(_from, _to, _value);
2034   }
2035 
2036   /**
2037    * @dev Set allowance for other address and notify
2038    *      Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
2039    * @param _spender The address authorized to spend
2040    * @param _value the max amount they can spend
2041    * @param _extraData some extra information to send to the approved contract
2042    */
2043   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
2044       public
2045       onlyMintingFinished
2046       returns (bool)
2047   {
2048       tokenRecipient spender = tokenRecipient(_spender);
2049       if (approve(_spender, _value)) {
2050           spender.receiveApproval(msg.sender, _value, this, _extraData);
2051           return true;
2052       }
2053   }
2054 
2055   /**
2056    * @dev Allows the owner to withdraw ethers from the contract.
2057    * @param ethers quantity in weis of ethers to be withdrawn
2058    * @return true if withdrawal successful ; false otherwise
2059    */
2060   function withdrawEther(uint256 ethers)
2061       public
2062       onlyOwner
2063   {
2064       msg.sender.transfer(ethers);
2065   }
2066 
2067   /**
2068    * @dev Allow the owner to withdraw tokens from the contract without taking tokens from deposits.
2069    * @param tokens quantity of tokens to be withdrawn
2070    */
2071   function withdrawTalao(uint256 tokens)
2072       public
2073       onlyOwner
2074   {
2075       require(balanceOf(this).sub(totalDeposit) >= tokens, "too much tokens asked");
2076       _transfer(this, msg.sender, tokens);
2077   }
2078 
2079   /******************************************/
2080   /*      vault functions start here        */
2081   /******************************************/
2082 
2083   /**
2084   * @dev Allows anyone to create a vault access.
2085   *      Vault deposit is transferred to token contract and sum is stored in totalDeposit
2086   *      Price must be lower than Vault deposit
2087   * @param price to pay to access certificate vault
2088   */
2089   function createVaultAccess (uint256 price)
2090       public
2091       onlyMintingFinished
2092   {
2093       require(accessAllowance[msg.sender][msg.sender].clientAgreement==false, "vault already created");
2094       require(price<=vaultDeposit, "price asked is too high");
2095       require(balanceOf(msg.sender)>vaultDeposit, "user has not enough tokens to send deposit");
2096       data[msg.sender].accessPrice=price;
2097       super.transfer(this, vaultDeposit);
2098       totalDeposit = totalDeposit.add(vaultDeposit);
2099       data[msg.sender].userDeposit=vaultDeposit;
2100       data[msg.sender].sharingPlan=100;
2101       accessAllowance[msg.sender][msg.sender].clientAgreement=true;
2102       emit Vault(msg.sender, msg.sender, VaultStatus.Created);
2103   }
2104 
2105   /**
2106   * @dev Closes a vault access, deposit is sent back to freelance wallet
2107   *      Total deposit in token contract is reduced by user deposit
2108   */
2109   function closeVaultAccess()
2110       public
2111       onlyMintingFinished
2112   {
2113       require(accessAllowance[msg.sender][msg.sender].clientAgreement==true, "vault has not been created");
2114       require(_transfer(this, msg.sender, data[msg.sender].userDeposit), "token deposit transfer failed");
2115       accessAllowance[msg.sender][msg.sender].clientAgreement=false;
2116       totalDeposit=totalDeposit.sub(data[msg.sender].userDeposit);
2117       data[msg.sender].sharingPlan=0;
2118       emit Vault(msg.sender, msg.sender, VaultStatus.Closed);
2119   }
2120 
2121   /**
2122   * @dev Internal transfer function used to transfer tokens from an address to another without prior authorization.
2123   *      Only used in these situations:
2124   *           * Send tokens from the contract to a token buyer (buy() function)
2125   *           * Send tokens from the contract to the owner in order to withdraw tokens (withdrawTalao(tokens) function)
2126   *           * Send tokens from the contract to a user closing its vault thus claiming its deposit back (closeVaultAccess() function)
2127   * @param _from address The address which you want to send tokens from.
2128   * @param _to address The address which you want to transfer to.
2129   * @param _value uint256 the amount of tokens to be transferred.
2130   * @return true if transfer is successful ; should throw otherwise
2131   */
2132   function _transfer(address _from, address _to, uint _value)
2133       internal
2134       returns (bool)
2135   {
2136       require(_to != 0x0, "destination cannot be 0x0");
2137       require(balances[_from] >= _value, "not enough tokens in sender wallet");
2138 
2139       balances[_from] = balances[_from].sub(_value);
2140       balances[_to] = balances[_to].add(_value);
2141       emit Transfer(_from, _to, _value);
2142       return true;
2143   }
2144 
2145   /**
2146   * @dev Appoint an agent or a new agent
2147   *      Former agent is replaced by new agent
2148   *      Agent will receive token on behalf of the freelance talent
2149   * @param newagent agent to appoint
2150   * @param newplan sharing plan is %, 100 means 100% for freelance
2151   */
2152   function agentApproval (address newagent, uint newplan)
2153       public
2154       onlyMintingFinished
2155   {
2156       require(newplan>=0&&newplan<=100, "plan must be between 0 and 100");
2157       require(accessAllowance[msg.sender][msg.sender].clientAgreement==true, "vault has not been created");
2158       emit Vault(data[msg.sender].appointedAgent, msg.sender, VaultStatus.AgentRemoved);
2159       data[msg.sender].appointedAgent=newagent;
2160       data[msg.sender].sharingPlan=newplan;
2161       emit Vault(newagent, msg.sender, VaultStatus.NewAgent);
2162   }
2163 
2164   /**
2165    * @dev Set the quantity of tokens necessary for vault access creation
2166    * @param newdeposit deposit (in tokens) for vault access creation
2167    */
2168   function setVaultDeposit (uint newdeposit)
2169       public
2170       onlyOwner
2171   {
2172       vaultDeposit = newdeposit;
2173   }
2174 
2175   /**
2176   * @dev Buy unlimited access to a freelancer vault
2177   *      Vault access price is transfered from client to agent or freelance depending on the sharing plan
2178   *      Allowance is given to client and one stores block.number for future use
2179   * @param freelance the address of the talent
2180   * @return true if access is granted ; false if not
2181   */
2182   function getVaultAccess (address freelance)
2183       public
2184       onlyMintingFinished
2185       returns (bool)
2186   {
2187       require(accessAllowance[freelance][freelance].clientAgreement==true, "vault does not exist");
2188       require(accessAllowance[msg.sender][freelance].clientAgreement!=true, "access was already granted");
2189       require(balanceOf(msg.sender)>data[freelance].accessPrice, "user has not enough tokens to get access to vault");
2190 
2191       uint256 freelance_share = data[freelance].accessPrice.mul(data[freelance].sharingPlan).div(100);
2192       uint256 agent_share = data[freelance].accessPrice.sub(freelance_share);
2193       if(freelance_share>0) super.transfer(freelance, freelance_share);
2194       if(agent_share>0) super.transfer(data[freelance].appointedAgent, agent_share);
2195       accessAllowance[msg.sender][freelance].clientAgreement=true;
2196       accessAllowance[msg.sender][freelance].clientDate=block.number;
2197       emit Vault(msg.sender, freelance, VaultStatus.NewAccess);
2198       return true;
2199   }
2200 
2201   /**
2202   * @dev Simple getter to retrieve talent agent
2203   * @param freelance talent address
2204   * @return address of the agent
2205   **/
2206   function getFreelanceAgent(address freelance)
2207       public
2208       view
2209       returns (address)
2210   {
2211       return data[freelance].appointedAgent;
2212   }
2213 
2214   /**
2215   * @dev Simple getter to check if user has access to a freelance vault
2216   * @param freelance talent address
2217   * @param user user address
2218   * @return true if access granted or false if not
2219   **/
2220   function hasVaultAccess(address freelance, address user)
2221       public
2222       view
2223       returns (bool)
2224   {
2225       return ((accessAllowance[user][freelance].clientAgreement) || (data[freelance].appointedAgent == user));
2226   }
2227 
2228 }
2229 
2230 // File: contracts/identity/Identity.sol
2231 
2232 /**
2233  * @title The Identity is where ERC 725/735 and our custom code meet.
2234  * @author Talao, Polynomial.
2235  * @notice Mixes ERC 725/735, foundation, token,
2236  * constructor values that never change (creator, category, encryption keys)
2237  * and provides a box to receive decentralized files and texts.
2238  */
2239 contract Identity is ClaimHolder {
2240 
2241     // Foundation contract.
2242     Foundation foundation;
2243 
2244     // Talao token contract.
2245     TalaoToken public token;
2246 
2247     // Identity information struct.
2248     struct IdentityInformation {
2249         // Address of this contract creator (factory).
2250         // bytes16 left on SSTORAGE 1 after this.
2251         address creator;
2252 
2253         // Identity category.
2254         // 1001 => 1999: Freelancer.
2255         // 2001 => 2999: Freelancer team.
2256         // 3001 => 3999: Corporate marketplace.
2257         // 4001 => 4999: Public marketplace.
2258         // 5001 => 5999: Service provider.
2259         // ..
2260         // 64001 => 64999: ?
2261         // bytes14 left after this on SSTORAGE 1.
2262         uint16 category;
2263 
2264         // Asymetric encryption key algorithm.
2265         // We use an integer to store algo with offchain references.
2266         // 1 => RSA 2048
2267         // bytes12 left after this on SSTORAGE 1.
2268         uint16 asymetricEncryptionAlgorithm;
2269 
2270         // Symetric encryption key algorithm.
2271         // We use an integer to store algo with offchain references.
2272         // 1 => AES 128
2273         // bytes10 left after this on SSTORAGE 1.
2274         uint16 symetricEncryptionAlgorithm;
2275 
2276         // Asymetric encryption public key.
2277         // This one can be used to encrypt content especially for this
2278         // contract owner, which is the only one to have the private key,
2279         // offchain of course.
2280         bytes asymetricEncryptionPublicKey;
2281 
2282         // Encrypted symetric encryption key (in Hex).
2283         // When decrypted, this passphrase can regenerate
2284         // the symetric encryption key.
2285         // This key encrypts and decrypts data to be shared with many people.
2286         // Uses 0.5 SSTORAGE for AES 128.
2287         bytes symetricEncryptionEncryptedKey;
2288 
2289         // Other encrypted secret we might use.
2290         bytes encryptedSecret;
2291     }
2292     // This contract Identity information.
2293     IdentityInformation public identityInformation;
2294 
2295     // Identity box: blacklisted addresses.
2296     mapping(address => bool) public identityboxBlacklisted;
2297 
2298     // Identity box: event when someone sent us a text.
2299     event TextReceived (
2300         address indexed sender,
2301         uint indexed category,
2302         bytes text
2303     );
2304 
2305     // Identity box: event when someone sent us an decentralized file.
2306     event FileReceived (
2307         address indexed sender,
2308         uint indexed fileType,
2309         uint fileEngine,
2310         bytes fileHash
2311     );
2312 
2313     /**
2314      * @dev Constructor.
2315      */
2316     constructor(
2317         address _foundation,
2318         address _token,
2319         uint16 _category,
2320         uint16 _asymetricEncryptionAlgorithm,
2321         uint16 _symetricEncryptionAlgorithm,
2322         bytes _asymetricEncryptionPublicKey,
2323         bytes _symetricEncryptionEncryptedKey,
2324         bytes _encryptedSecret
2325     )
2326         public
2327     {
2328         foundation = Foundation(_foundation);
2329         token = TalaoToken(_token);
2330         identityInformation.creator = msg.sender;
2331         identityInformation.category = _category;
2332         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
2333         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
2334         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
2335         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
2336         identityInformation.encryptedSecret = _encryptedSecret;
2337     }
2338 
2339     /**
2340      * @dev Owner of this contract, in the Foundation sense.
2341      * We do not allow this to be used externally,
2342      * since a contract could fake ownership.
2343      * In other contracts, you have to call the Foundation to
2344      * know the real owner of this contract.
2345      */
2346     function identityOwner() internal view returns (address) {
2347         return foundation.contractsToOwners(address(this));
2348     }
2349 
2350     /**
2351      * @dev Check in Foundation if msg.sender is the owner of this contract.
2352      * Same remark.
2353      */
2354     function isIdentityOwner() internal view returns (bool) {
2355         return msg.sender == identityOwner();
2356     }
2357 
2358     /**
2359      * @dev Modifier version of isIdentityOwner.
2360      */
2361     modifier onlyIdentityOwner() {
2362         require(isIdentityOwner(), "Access denied");
2363         _;
2364     }
2365 
2366     /**
2367      * @dev Owner functions require open Vault in token.
2368      */
2369     function isActiveIdentityOwner() public view returns (bool) {
2370         return isIdentityOwner() && token.hasVaultAccess(msg.sender, msg.sender);
2371     }
2372 
2373     /**
2374      * @dev Modifier version of isActiveOwner.
2375      */
2376     modifier onlyActiveIdentityOwner() {
2377         require(isActiveIdentityOwner(), "Access denied");
2378         _;
2379     }
2380 
2381     /**
2382      * @dev Does this contract owner have an open Vault in the token?
2383      */
2384     function isActiveIdentity() public view returns (bool) {
2385         return token.hasVaultAccess(identityOwner(), identityOwner());
2386     }
2387 
2388     /**
2389      * @dev Does msg.sender have an ERC 725 key with certain purpose,
2390      * and does the contract owner have an open Vault in the token?
2391      */
2392     function hasIdentityPurpose(uint256 _purpose) public view returns (bool) {
2393         return (
2394             keyHasPurpose(keccak256(abi.encodePacked(msg.sender)), _purpose) &&
2395             isActiveIdentity()
2396         );
2397     }
2398 
2399     /**
2400      * @dev Modifier version of hasKeyForPurpose
2401      */
2402     modifier onlyIdentityPurpose(uint256 _purpose) {
2403         require(hasIdentityPurpose(_purpose), "Access denied");
2404         _;
2405     }
2406 
2407     /**
2408      * @dev "Send" a text to this contract.
2409      * Text can be encrypted on this contract asymetricEncryptionPublicKey,
2410      * before submitting a TX here.
2411      */
2412     function identityboxSendtext(uint _category, bytes _text) external {
2413         require(!identityboxBlacklisted[msg.sender], "You are blacklisted");
2414         emit TextReceived(msg.sender, _category, _text);
2415     }
2416 
2417     /**
2418      * @dev "Send" a "file" to this contract.
2419      * File should be encrypted on this contract asymetricEncryptionPublicKey,
2420      * before upload on decentralized file storage,
2421      * before submitting a TX here.
2422      */
2423     function identityboxSendfile(
2424         uint _fileType, uint _fileEngine, bytes _fileHash
2425     )
2426         external
2427     {
2428         require(!identityboxBlacklisted[msg.sender], "You are blacklisted");
2429         emit FileReceived(msg.sender, _fileType, _fileEngine, _fileHash);
2430     }
2431 
2432     /**
2433      * @dev Blacklist an address in this Identity box.
2434      */
2435     function identityboxBlacklist(address _address)
2436         external
2437         onlyIdentityPurpose(20004)
2438     {
2439         identityboxBlacklisted[_address] = true;
2440     }
2441 
2442     /**
2443      * @dev Unblacklist.
2444      */
2445     function identityboxUnblacklist(address _address)
2446         external
2447         onlyIdentityPurpose(20004)
2448     {
2449         identityboxBlacklisted[_address] = false;
2450     }
2451 }
2452 
2453 /**
2454  * @title Interface with clones or inherited contracts.
2455  */
2456 interface IdentityInterface {
2457     function identityInformation()
2458         external
2459         view
2460         returns (address, uint16, uint16, uint16, bytes, bytes, bytes);
2461     function identityboxSendtext(uint, bytes) external;
2462 }
2463 
2464 // File: contracts/math/SafeMathUpdated.sol
2465 
2466 /**
2467  * @title SafeMath
2468  * @dev Math operations with safety checks that throw on error
2469  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
2470  */
2471 library SafeMathUpdated {
2472     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2473         if (a == 0) {
2474             return 0;
2475         }
2476         uint256 c = a * b;
2477         assert(c / a == b);
2478         return c;
2479     }
2480 
2481     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2482         uint256 c = a / b;
2483         return c;
2484     }
2485 
2486     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2487         assert(b <= a);
2488         return a - b;
2489     }
2490 
2491     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2492         uint256 c = a + b;
2493         assert(c >= a);
2494         return c;
2495     }
2496 }
2497 
2498 // File: contracts/access/Partnership.sol
2499 
2500 /**
2501  * @title Provides partnership features between contracts.
2502  * @notice If msg.sender is the owner, in the Foundation sense
2503  * (see Foundation.sol, of another partnership contract that is
2504  * authorized in this partnership contract,
2505  * then he passes isPartnershipMember().
2506  * Obviously this function is meant to be used in modifiers
2507  * in contrats that inherit of this one and provide "restricted" content.
2508  * Partnerships are symetrical: when you request a partnership,
2509  * you automatically authorize the requested partnership contract.
2510  * Same thing when you remove a partnership.
2511  * This is done through symetrical functions,
2512  * where the user submits a tx on his own Partnership contract to ask partnership
2513  * to another and not on the other contract.
2514  * Convention here: _function = to be called by another partnership contract.
2515  * @author Talao, Polynomial.
2516  */
2517 contract Partnership is Identity {
2518 
2519     using SafeMathUpdated for uint;
2520 
2521     // Foundation contract.
2522     Foundation foundation;
2523 
2524     // Authorization status.
2525     enum PartnershipAuthorization { Unknown, Authorized, Pending, Rejected, Removed }
2526 
2527     // Other Partnership contract information.
2528     struct PartnershipContract {
2529         // Authorization of this contract.
2530         // bytes31 left after this on SSTORAGE 1.
2531         PartnershipAuthorization authorization;
2532         // Date of partnership creation.
2533         // Let's avoid the 2038 year bug, even if this contract will be dead
2534         // a lot sooner! It costs nothing, so...
2535         // bytes26 left after this on SSTORAGE 1.
2536         uint40 created;
2537         // His symetric encryption key,
2538         // encrypted on our asymetric encryption public key.
2539         bytes symetricEncryptionEncryptedKey;
2540     }
2541     // Our main registry of Partnership contracts.
2542     mapping(address => PartnershipContract) internal partnershipContracts;
2543 
2544     // Index of known partnerships (contracts which interacted at least once).
2545     address[] internal knownPartnershipContracts;
2546 
2547     // Total of authorized Partnerships contracts.
2548     uint public partnershipsNumber;
2549 
2550     // Event when another Partnership contract has asked partnership.
2551     event PartnershipRequested();
2552 
2553     // Event when another Partnership contract has authorized our request.
2554     event PartnershipAccepted();
2555 
2556     /**
2557      * @dev Constructor.
2558      */
2559     constructor(
2560         address _foundation,
2561         address _token,
2562         uint16 _category,
2563         uint16 _asymetricEncryptionAlgorithm,
2564         uint16 _symetricEncryptionAlgorithm,
2565         bytes _asymetricEncryptionPublicKey,
2566         bytes _symetricEncryptionEncryptedKey,
2567         bytes _encryptedSecret
2568     )
2569         Identity(
2570             _foundation,
2571             _token,
2572             _category,
2573             _asymetricEncryptionAlgorithm,
2574             _symetricEncryptionAlgorithm,
2575             _asymetricEncryptionPublicKey,
2576             _symetricEncryptionEncryptedKey,
2577             _encryptedSecret
2578         )
2579         public
2580     {
2581         foundation = Foundation(_foundation);
2582         token = TalaoToken(_token);
2583         identityInformation.creator = msg.sender;
2584         identityInformation.category = _category;
2585         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
2586         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
2587         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
2588         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
2589         identityInformation.encryptedSecret = _encryptedSecret;
2590     }
2591 
2592     /**
2593      * @dev This function will be used in inherited contracts,
2594      * to restrict read access to members of Partnership contracts
2595      * which are authorized in this contract.
2596      */
2597     function isPartnershipMember() public view returns (bool) {
2598         return partnershipContracts[foundation.membersToContracts(msg.sender)].authorization == PartnershipAuthorization.Authorized;
2599     }
2600 
2601     /**
2602      * @dev Modifier version of isPartnershipMember.
2603      * Not used for now, but could be useful.
2604      */
2605     modifier onlyPartnershipMember() {
2606         require(isPartnershipMember());
2607         _;
2608     }
2609 
2610     /**
2611      * @dev Get partnership status in this contract for a user.
2612      */
2613     function getMyPartnershipStatus()
2614         external
2615         view
2616         returns (uint authorization)
2617     {
2618         // If msg.sender has no Partnership contract, return Unknown (0).
2619         if (foundation.membersToContracts(msg.sender) == address(0)) {
2620             return uint(PartnershipAuthorization.Unknown);
2621         } else {
2622             return uint(partnershipContracts[foundation.membersToContracts(msg.sender)].authorization);
2623         }
2624     }
2625 
2626     /**
2627      * @dev Get the list of all known Partnership contracts.
2628      */
2629     function getKnownPartnershipsContracts()
2630         external
2631         view
2632         onlyIdentityPurpose(20003)
2633         returns (address[])
2634     {
2635         return knownPartnershipContracts;
2636     }
2637 
2638     /**
2639      * @dev Get a Partnership contract information.
2640      */
2641     function getPartnership(address _hisContract)
2642         external
2643         view
2644         onlyIdentityPurpose(20003)
2645         returns (uint, uint, uint40, bytes, bytes)
2646     {
2647         (
2648             ,
2649             uint16 hisCategory,
2650             ,
2651             ,
2652             bytes memory hisAsymetricEncryptionPublicKey,
2653             ,
2654         ) = IdentityInterface(_hisContract).identityInformation();
2655         return (
2656             hisCategory,
2657             uint(partnershipContracts[_hisContract].authorization),
2658             partnershipContracts[_hisContract].created,
2659             hisAsymetricEncryptionPublicKey,
2660             partnershipContracts[_hisContract].symetricEncryptionEncryptedKey
2661         );
2662     }
2663 
2664     /**
2665      * @dev Request partnership.
2666      * The owner of this contract requests a partnership
2667      * with another Partnership contract
2668      * through THIS contract.
2669      * We send him our symetric encryption key as well,
2670      * encrypted on his symetric encryption public key.
2671      * Encryption done offchain before submitting this TX.
2672      */
2673     function requestPartnership(address _hisContract, bytes _ourSymetricKey)
2674         external
2675         onlyIdentityPurpose(1)
2676     {
2677         // We can only request partnership with a contract
2678         // if he's not already Known or Removed in our registry.
2679         // If he is, we symetrically are already in his partnerships.
2680         // Indeed when he asked a partnership with us,
2681         // he added us in authorized partnerships.
2682         require(
2683             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Unknown ||
2684             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Removed
2685         );
2686         // Request partnership in the other contract.
2687         // Open interface on his contract.
2688         PartnershipInterface hisInterface = PartnershipInterface(_hisContract);
2689         bool success = hisInterface._requestPartnership(_ourSymetricKey);
2690         // If partnership request was a success,
2691         if (success) {
2692             // If we do not know the Partnership contract yet,
2693             if (partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Unknown) {
2694                 // Then add it to our partnerships index.
2695                 knownPartnershipContracts.push(_hisContract);
2696             }
2697             // Authorize Partnership contract in our contract.
2698             partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Authorized;
2699             // Record date of partnership creation.
2700             partnershipContracts[_hisContract].created = uint40(now);
2701             // Give the Partnership contrat's owner an ERC 725 "Claim" key.
2702             addKey(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3, 1);
2703             // Give the Partnership contract an ERC 725 "Claim" key.
2704             addKey(keccak256(abi.encodePacked(_hisContract)), 3, 1);
2705             // Increment our number of partnerships.
2706             partnershipsNumber = partnershipsNumber.add(1);
2707         }
2708     }
2709 
2710     /**
2711      * @dev Symetry of requestPartnership.
2712      * Called by Partnership contract wanting to partnership.
2713      * He sends us his symetric encryption key as well,
2714      * encrypted on our symetric encryption public key.
2715      * So we can decipher all his content.
2716      */
2717     function _requestPartnership(bytes _hisSymetricKey)
2718         external
2719         returns (bool success)
2720     {
2721         require(
2722             partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Unknown ||
2723             partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Removed
2724         );
2725         // If this Partnership contract is Unknown,
2726         if (partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Unknown) {
2727             // Add the new partnership to our partnerships index.
2728             knownPartnershipContracts.push(msg.sender);
2729             // Record date of partnership creation.
2730             partnershipContracts[msg.sender].created = uint40(now);
2731         }
2732         // Write Pending to our partnerships contract registry.
2733         partnershipContracts[msg.sender].authorization = PartnershipAuthorization.Pending;
2734         // Record his symetric encryption key,
2735         // encrypted on our asymetric encryption public key.
2736         partnershipContracts[msg.sender].symetricEncryptionEncryptedKey = _hisSymetricKey;
2737         // Event for this contrat owner's UI.
2738         emit PartnershipRequested();
2739         // Return success.
2740         success = true;
2741     }
2742 
2743     /**
2744      * @dev Authorize Partnership.
2745      * Before submitting this TX, we must have encrypted our
2746      * symetric encryption key on his asymetric encryption public key.
2747      */
2748     function authorizePartnership(address _hisContract, bytes _ourSymetricKey)
2749         external
2750         onlyIdentityPurpose(1)
2751     {
2752         require(
2753             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Pending,
2754             "Partnership must be Pending"
2755         );
2756         // Authorize the Partnership contract in our contract.
2757         partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Authorized;
2758         // Record the date of partnership creation.
2759         partnershipContracts[_hisContract].created = uint40(now);
2760         // Give the Partnership contrat's owner an ERC 725 "Claim" key.
2761         addKey(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3, 1);
2762         // Give the Partnership contract an ERC 725 "Claim" key.
2763         addKey(keccak256(abi.encodePacked(_hisContract)), 3, 1);
2764         // Increment our number of partnerships.
2765         partnershipsNumber = partnershipsNumber.add(1);
2766         // Log an event in the new authorized partner contract.
2767         PartnershipInterface hisInterface = PartnershipInterface(_hisContract);
2768         hisInterface._authorizePartnership(_ourSymetricKey);
2769     }
2770 
2771     /**
2772      * @dev Allows other Partnership contract to send an event when authorizing.
2773      * He sends us also his symetric encryption key,
2774      * encrypted on our asymetric encryption public key.
2775      */
2776     function _authorizePartnership(bytes _hisSymetricKey) external {
2777         require(
2778             partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Authorized,
2779             "You have no authorized partnership"
2780         );
2781         partnershipContracts[msg.sender].symetricEncryptionEncryptedKey = _hisSymetricKey;
2782         emit PartnershipAccepted();
2783     }
2784 
2785     /**
2786      * @dev Reject Partnership.
2787      */
2788     function rejectPartnership(address _hisContract)
2789         external
2790         onlyIdentityPurpose(1)
2791     {
2792         require(
2793             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Pending,
2794             "Partner must be Pending"
2795         );
2796         partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Rejected;
2797     }
2798 
2799     /**
2800      * @dev Remove Partnership.
2801      */
2802     function removePartnership(address _hisContract)
2803         external
2804         onlyIdentityPurpose(1)
2805     {
2806         require(
2807             (
2808                 partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Authorized ||
2809                 partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Rejected
2810             ),
2811             "Partnership must be Authorized or Rejected"
2812         );
2813         // Remove ourselves in the other Partnership contract.
2814         PartnershipInterface hisInterface = PartnershipInterface(_hisContract);
2815         bool success = hisInterface._removePartnership();
2816         // If success,
2817         if (success) {
2818             // If it was an authorized partnership,
2819             if (partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Authorized) {
2820                 // Remove the partnership creation date.
2821                 delete partnershipContracts[_hisContract].created;
2822                 // Remove his symetric encryption key.
2823                 delete partnershipContracts[_hisContract].symetricEncryptionEncryptedKey;
2824                 // Decrement our number of partnerships.
2825                 partnershipsNumber = partnershipsNumber.sub(1);
2826             }
2827             // If there is one, remove ERC 725 "Claim" key for Partnership contract owner.
2828             if (keyHasPurpose(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3)) {
2829                 removeKey(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3);
2830             }
2831             // If there is one, remove ERC 725 "Claim" key for Partnership contract.
2832             if (keyHasPurpose(keccak256(abi.encodePacked(_hisContract)), 3)) {
2833                 removeKey(keccak256(abi.encodePacked(_hisContract)), 3);
2834             }
2835             // Change his partnership to Removed in our contract.
2836             // We want to have Removed instead of resetting to Unknown,
2837             // otherwise if partnership is initiated again with him,
2838             // our knownPartnershipContracts would have a duplicate entry.
2839             partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Removed;
2840         }
2841     }
2842 
2843     /**
2844      * @dev Symetry of removePartnership.
2845      * Called by the Partnership contract breaking partnership with us.
2846      */
2847     function _removePartnership() external returns (bool success) {
2848         // He wants to break partnership with us, so we break too.
2849         // If it was an authorized partnership,
2850         if (partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Authorized) {
2851             // Remove date of partnership creation.
2852             delete partnershipContracts[msg.sender].created;
2853             // Remove his symetric encryption key.
2854             delete partnershipContracts[msg.sender].symetricEncryptionEncryptedKey;
2855             // Decrement our number of partnerships.
2856             partnershipsNumber = partnershipsNumber.sub(1);
2857         }
2858         // Would have liked to remove ERC 725 "Claim" keys here.
2859         // Unfortunately we can not automate this. Indeed it would require
2860         // the Partnership contract to have an ERC 725 Management key.
2861 
2862         // Remove his authorization.
2863         partnershipContracts[msg.sender].authorization = PartnershipAuthorization.Removed;
2864         // We return to the calling contract that it's done.
2865         success = true;
2866     }
2867 
2868     /**
2869      * @dev Internal function to remove partnerships before selfdestruct.
2870      */
2871     function cleanupPartnership() internal returns (bool success) {
2872         // For each known Partnership contract
2873         for (uint i = 0; i < knownPartnershipContracts.length; i++) {
2874             // If it was an authorized partnership,
2875             if (partnershipContracts[knownPartnershipContracts[i]].authorization == PartnershipAuthorization.Authorized) {
2876                 // Remove ourselves in the other Partnership contract.
2877                 PartnershipInterface hisInterface = PartnershipInterface(knownPartnershipContracts[i]);
2878                 hisInterface._removePartnership();
2879             }
2880         }
2881         success = true;
2882     }
2883 }
2884 
2885 
2886 /**
2887  * @title Interface with clones, inherited contracts or services.
2888  */
2889 interface PartnershipInterface {
2890     function _requestPartnership(bytes) external view returns (bool);
2891     function _authorizePartnership(bytes) external;
2892     function _removePartnership() external returns (bool success);
2893     function getKnownPartnershipsContracts() external returns (address[]);
2894     function getPartnership(address)
2895         external
2896         returns (uint, uint, uint40, bytes, bytes);
2897 }
2898 
2899 // File: contracts/access/Permissions.sol
2900 
2901 /**
2902  * @title Permissions contract.
2903  * @author Talao, Polynomial.
2904  * @notice See ../identity/KeyHolder.sol as well.
2905  */
2906 contract Permissions is Partnership {
2907 
2908     // Foundation contract.
2909     Foundation foundation;
2910 
2911     // Talao token contract.
2912     TalaoToken public token;
2913 
2914     /**
2915      * @dev Constructor.
2916      */
2917     constructor(
2918         address _foundation,
2919         address _token,
2920         uint16 _category,
2921         uint16 _asymetricEncryptionAlgorithm,
2922         uint16 _symetricEncryptionAlgorithm,
2923         bytes _asymetricEncryptionPublicKey,
2924         bytes _symetricEncryptionEncryptedKey,
2925         bytes _encryptedSecret
2926     )
2927         Partnership(
2928             _foundation,
2929             _token,
2930             _category,
2931             _asymetricEncryptionAlgorithm,
2932             _symetricEncryptionAlgorithm,
2933             _asymetricEncryptionPublicKey,
2934             _symetricEncryptionEncryptedKey,
2935             _encryptedSecret
2936         )
2937         public
2938     {
2939         foundation = Foundation(_foundation);
2940         token = TalaoToken(_token);
2941         identityInformation.creator = msg.sender;
2942         identityInformation.category = _category;
2943         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
2944         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
2945         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
2946         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
2947         identityInformation.encryptedSecret = _encryptedSecret;
2948     }
2949 
2950     /**
2951      * @dev Is msg.sender a "member" of this contract, in the Foundation sense?
2952      */
2953     function isMember() public view returns (bool) {
2954         return foundation.membersToContracts(msg.sender) == address(this);
2955     }
2956 
2957     /**
2958      * @dev Read authorization for inherited contracts "private" data.
2959      */
2960     function isReader() public view returns (bool) {
2961         // Get Vault access price in the token for this contract owner,
2962         // in the Foundation sense.
2963         (uint accessPrice,,,) = token.data(identityOwner());
2964         // OR conditions for Reader:
2965         // 1) Same code for
2966         // 1.1) Sender is this contract owner and has an open Vault in the token.
2967         // 1.2) Sender has vaultAccess to this contract owner in the token.
2968         // 2) Owner has open Vault in the token and:
2969         // 2.1) Sender is a member of this contract,
2970         // 2.2) Sender is a member of an authorized Partner contract
2971         // 2.3) Sender has an ERC 725 20001 key "Reader"
2972         // 2.4) Owner has a free vaultAccess in the token
2973         return(
2974             token.hasVaultAccess(identityOwner(), msg.sender) ||
2975             (
2976                 token.hasVaultAccess(identityOwner(), identityOwner()) &&
2977                 (
2978                     isMember() ||
2979                     isPartnershipMember() ||
2980                     hasIdentityPurpose(20001) ||
2981                     (accessPrice == 0 && msg.sender != address(0))
2982                 )
2983             )
2984         );
2985     }
2986 
2987     /**
2988      * @dev Modifier version of isReader.
2989      */
2990     modifier onlyReader() {
2991         require(isReader(), "Access denied");
2992         _;
2993     }
2994 }
2995 
2996 // File: contracts/content/Profile.sol
2997 
2998 /**
2999  * @title Profile contract.
3000  * @author Talao, Polynomial, Slowsense, Blockchain Partner.
3001  */
3002 contract Profile is Permissions {
3003 
3004     // "Private" profile.
3005     // Access controlled by Permissions.sol.
3006     // Nothing is really private on the blockchain,
3007     // so data should be encrypted on symetric key.
3008     struct PrivateProfile {
3009         // Private email.
3010         bytes email;
3011 
3012         // Mobile number.
3013         bytes mobile;
3014     }
3015     PrivateProfile internal privateProfile;
3016 
3017     /**
3018      * @dev Get private profile.
3019      */
3020     function getPrivateProfile()
3021         external
3022         view
3023         onlyReader
3024         returns (bytes, bytes)
3025     {
3026         return (
3027             privateProfile.email,
3028             privateProfile.mobile
3029         );
3030     }
3031 
3032     /**
3033      * @dev Set private profile.
3034      */
3035     function setPrivateProfile(
3036         bytes _privateEmail,
3037         bytes _mobile
3038     )
3039         external
3040         onlyIdentityPurpose(20002)
3041     {
3042         privateProfile.email = _privateEmail;
3043         privateProfile.mobile = _mobile;
3044     }
3045 }
3046 
3047 // File: contracts/content/Documents.sol
3048 
3049 /**
3050  * @title A Documents contract allows to manage documents and share them.
3051  * @notice Also contracts that have an ERC 725 Claim key (3)
3052  * can add certified documents.
3053  * @author Talao, Polynomial, SlowSense, Blockchain Partners.
3054  */
3055 contract Documents is Permissions {
3056 
3057     using SafeMathUpdated for uint;
3058 
3059     // Document struct.
3060     struct Document {
3061 
3062         // True if "published", false if "unpublished".
3063         // 31 bytes remaining in SSTORAGE 1 after this.
3064         bool published;
3065 
3066         // True if doc is encrypted.
3067         // 30 bytes remaining in SSTORAGE 1 after this.
3068         bool encrypted;
3069 
3070         // Position in index.
3071         // 28 bytes remaining in SSTORAGE 1 after this.
3072         uint16 index;
3073 
3074         // Type of document:
3075         // ...
3076         // 50000 => 59999: experiences
3077         // 60000 => max: certificates
3078         // 26 bytes remaining in SSTORAGE 1 after this.
3079         uint16 docType;
3080 
3081         // Version of document type: 1 = "work experience version 1" document, if type_doc = 1
3082         // 24 bytes remaining in SSTORAGE 1 after this.
3083         uint16 docTypeVersion;
3084 
3085         // ID of related experience, for certificates.
3086         // 22 bytes remaining in SSTORAGE 1 after this.
3087         uint16 related;
3088 
3089         // ID of the file location engine.
3090         // 1 = IPFS, 2 = Swarm, 3 = Filecoin, ...
3091         // 20 bytes remaining in SSTORAGE 1 after this.
3092         uint16 fileLocationEngine;
3093 
3094         // Issuer of the document.
3095         // SSTORAGE 1 full after this.
3096         address issuer;
3097 
3098         // Checksum of the file (SHA-256 offchain).
3099         // SSTORAGE 2 filled after this.
3100         bytes32 fileChecksum;
3101 
3102         // Expiration date.
3103         uint40 expires;
3104 
3105         // Hash of the file location in a decentralized engine.
3106         // Example: IPFS hash, Swarm hash, Filecoin hash...
3107         // Uses 1 SSTORAGE for IPFS.
3108         bytes fileLocationHash;
3109     }
3110 
3111     // Documents registry.
3112     mapping(uint => Document) internal documents;
3113 
3114     // Documents index.
3115     uint[] internal documentsIndex;
3116 
3117     // Documents counter.
3118     uint internal documentsCounter;
3119 
3120     // Event: new document added.
3121     event DocumentAdded (uint id);
3122 
3123     // Event: document removed.
3124     event DocumentRemoved (uint id);
3125 
3126     // Event: certificate issued.
3127     event CertificateIssued (bytes32 indexed checksum, address indexed issuer, uint id);
3128 
3129     // Event: certificate accepted.
3130     event CertificateAccepted (bytes32 indexed checksum, address indexed issuer, uint id);
3131 
3132     /**
3133      * @dev Document getter.
3134      * @param _id uint Document ID.
3135      */
3136     function getDocument(uint _id)
3137         external
3138         view
3139         onlyReader
3140         returns (
3141             uint16,
3142             uint16,
3143             uint40,
3144             address,
3145             bytes32,
3146             uint16,
3147             bytes,
3148             bool,
3149             uint16
3150         )
3151     {
3152         Document memory doc = documents[_id];
3153         require(doc.published);
3154         return(
3155             doc.docType,
3156             doc.docTypeVersion,
3157             doc.expires,
3158             doc.issuer,
3159             doc.fileChecksum,
3160             doc.fileLocationEngine,
3161             doc.fileLocationHash,
3162             doc.encrypted,
3163             doc.related
3164         );
3165     }
3166 
3167     /**
3168      * @dev Get all published documents.
3169      */
3170     function getDocuments() external view onlyReader returns (uint[]) {
3171         return documentsIndex;
3172     }
3173 
3174     /**
3175      * @dev Create a document.
3176      */
3177     function createDocument(
3178         uint16 _docType,
3179         uint16 _docTypeVersion,
3180         uint40 _expires,
3181         bytes32 _fileChecksum,
3182         uint16 _fileLocationEngine,
3183         bytes _fileLocationHash,
3184         bool _encrypted
3185     )
3186         external
3187         onlyIdentityPurpose(20002)
3188         returns(uint)
3189     {
3190         require(_docType < 60000);
3191         _createDocument(
3192             _docType,
3193             _docTypeVersion,
3194             _expires,
3195             msg.sender,
3196             _fileChecksum,
3197             _fileLocationEngine,
3198             _fileLocationHash,
3199             _encrypted,
3200             0
3201         );
3202         return documentsCounter;
3203     }
3204 
3205     /**
3206      * @dev Issue a certificate.
3207      */
3208     function issueCertificate(
3209         uint16 _docType,
3210         uint16 _docTypeVersion,
3211         bytes32 _fileChecksum,
3212         uint16 _fileLocationEngine,
3213         bytes _fileLocationHash,
3214         bool _encrypted,
3215         uint16 _related
3216     )
3217         external
3218         returns(uint)
3219     {
3220         require(
3221             keyHasPurpose(keccak256(abi.encodePacked(foundation.membersToContracts(msg.sender))), 3) &&
3222             isActiveIdentity() &&
3223             _docType >= 60000
3224         );
3225         uint id = _createDocument(
3226             _docType,
3227             _docTypeVersion,
3228             0,
3229             foundation.membersToContracts(msg.sender),
3230             _fileChecksum,
3231             _fileLocationEngine,
3232             _fileLocationHash,
3233             _encrypted,
3234             _related
3235         );
3236         emit CertificateIssued(_fileChecksum, foundation.membersToContracts(msg.sender), id);
3237         return id;
3238     }
3239 
3240     /**
3241      * @dev Accept a certificate.
3242      */
3243     function acceptCertificate(uint _id) external onlyIdentityPurpose(20002) {
3244         Document storage doc = documents[_id];
3245         require(!doc.published && doc.docType >= 60000);
3246         // Add to index.
3247         doc.index = uint16(documentsIndex.push(_id).sub(1));
3248         // Publish.
3249         doc.published = true;
3250         // Unpublish related experience, if published.
3251         if (documents[doc.related].published) {
3252             _deleteDocument(doc.related);
3253         }
3254         // Emit event.
3255         emit CertificateAccepted(doc.fileChecksum, doc.issuer, _id);
3256     }
3257 
3258     /**
3259      * @dev Create a document.
3260      */
3261     function _createDocument(
3262         uint16 _docType,
3263         uint16 _docTypeVersion,
3264         uint40 _expires,
3265         address _issuer,
3266         bytes32 _fileChecksum,
3267         uint16 _fileLocationEngine,
3268         bytes _fileLocationHash,
3269         bool _encrypted,
3270         uint16 _related
3271     )
3272         internal
3273         returns(uint)
3274     {
3275         // Increment documents counter.
3276         documentsCounter = documentsCounter.add(1);
3277         // Storage pointer.
3278         Document storage doc = documents[documentsCounter];
3279         // For certificates:
3280         // - add the related experience
3281         // - do not add to index
3282         // - do not publish.
3283         if (_docType >= 60000) {
3284             doc.related = _related;
3285         } else {
3286             // Add to index.
3287             doc.index = uint16(documentsIndex.push(documentsCounter).sub(1));
3288             // Publish.
3289             doc.published = true;
3290         }
3291         // Common data.
3292         doc.encrypted = _encrypted;
3293         doc.docType = _docType;
3294         doc.docTypeVersion = _docTypeVersion;
3295         doc.expires = _expires;
3296         doc.fileLocationEngine = _fileLocationEngine;
3297         doc.issuer = _issuer;
3298         doc.fileChecksum = _fileChecksum;
3299         doc.fileLocationHash = _fileLocationHash;
3300         // Emit event.
3301         emit DocumentAdded(documentsCounter);
3302         // Return document ID.
3303         return documentsCounter;
3304     }
3305 
3306     /**
3307      * @dev Remove a document.
3308      */
3309     function deleteDocument (uint _id) external onlyIdentityPurpose(20002) {
3310         _deleteDocument(_id);
3311     }
3312 
3313     /**
3314      * @dev Remove a document.
3315      */
3316     function _deleteDocument (uint _id) internal {
3317         Document storage docToDelete = documents[_id];
3318         require (_id > 0);
3319         require(docToDelete.published);
3320         // If the removed document is not the last in the index,
3321         if (docToDelete.index < (documentsIndex.length).sub(1)) {
3322             // Find the last document of the index.
3323             uint lastDocId = documentsIndex[(documentsIndex.length).sub(1)];
3324             Document storage lastDoc = documents[lastDocId];
3325             // Move it in the index in place of the document to delete.
3326             documentsIndex[docToDelete.index] = lastDocId;
3327             // Update this document that was moved from last position.
3328             lastDoc.index = docToDelete.index;
3329         }
3330         // Remove last element from index.
3331         documentsIndex.length --;
3332         // Unpublish document.
3333         docToDelete.published = false;
3334         // Emit event.
3335         emit DocumentRemoved(_id);
3336     }
3337 
3338     /**
3339      * @dev "Update" a document.
3340      * Updating a document makes no sense technically.
3341      * Here we provide a function that deletes a doc & create a new one.
3342      * But for UX it's very important to have this in 1 transaction.
3343      */
3344     function updateDocument(
3345         uint _id,
3346         uint16 _docType,
3347         uint16 _docTypeVersion,
3348         uint40 _expires,
3349         bytes32 _fileChecksum,
3350         uint16 _fileLocationEngine,
3351         bytes _fileLocationHash,
3352         bool _encrypted
3353     )
3354         external
3355         onlyIdentityPurpose(20002)
3356         returns (uint)
3357     {
3358         require(_docType < 60000);
3359         _deleteDocument(_id);
3360         _createDocument(
3361             _docType,
3362             _docTypeVersion,
3363             _expires,
3364             msg.sender,
3365             _fileChecksum,
3366             _fileLocationEngine,
3367             _fileLocationHash,
3368             _encrypted,
3369             0
3370         );
3371         return documentsCounter;
3372     }
3373 }
3374 
3375 
3376 /**
3377  * @title Interface with clones, inherited contracts or services.
3378  */
3379 interface DocumentsInterface {
3380     function getDocuments() external returns(uint[]);
3381     function getDocument(uint)
3382         external
3383         returns (
3384             uint16,
3385             uint16,
3386             uint40,
3387             address,
3388             bytes32,
3389             uint16,
3390             bytes,
3391             bool,
3392             uint16
3393         );
3394 }
3395 
3396 // File: contracts/Workspace.sol
3397 
3398 /**
3399  * @title A Workspace contract.
3400  * @author Talao, Polynomial, SlowSense, Blockchain Partners.
3401  */
3402 contract Workspace is Permissions, Profile, Documents {
3403 
3404     /**
3405      * @dev Constructor.
3406      */
3407     constructor(
3408         address _foundation,
3409         address _token,
3410         uint16 _category,
3411         uint16 _asymetricEncryptionAlgorithm,
3412         uint16 _symetricEncryptionAlgorithm,
3413         bytes _asymetricEncryptionPublicKey,
3414         bytes _symetricEncryptionEncryptedKey,
3415         bytes _encryptedSecret
3416     )
3417         Permissions(
3418             _foundation,
3419             _token,
3420             _category,
3421             _asymetricEncryptionAlgorithm,
3422             _symetricEncryptionAlgorithm,
3423             _asymetricEncryptionPublicKey,
3424             _symetricEncryptionEncryptedKey,
3425             _encryptedSecret
3426         )
3427         public
3428     {
3429         foundation = Foundation(_foundation);
3430         token = TalaoToken(_token);
3431         identityInformation.creator = msg.sender;
3432         identityInformation.category = _category;
3433         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
3434         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
3435         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
3436         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
3437         identityInformation.encryptedSecret = _encryptedSecret;
3438     }
3439 
3440     /**
3441      * @dev Destroy contract.
3442      */
3443     function destroyWorkspace() external onlyIdentityOwner {
3444         if (cleanupPartnership() && foundation.renounceOwnershipInFoundation()) {
3445             selfdestruct(msg.sender);
3446         }
3447     }
3448 
3449     /**
3450      * @dev Prevents accidental sending of ether.
3451      */
3452     function() public {
3453         revert();
3454     }
3455 }