1 pragma solidity ^0.4.24;
2 
3 library KeyHolderLibrary {
4     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
5     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
6     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
7     event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
8     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
9     event Approved(uint256 indexed executionId, bool approved);
10 
11     struct Key {
12         uint256[] purposes; //e.g., MANAGEMENT_KEY = 1, ACTION_KEY = 2, etc.
13         uint256 keyType; // e.g. 1 = ECDSA, 2 = RSA, etc.
14         bytes32 key;
15     }
16 
17     struct KeyHolderData {
18         uint256 executionNonce;
19         mapping (bytes32 => Key) keys;
20         mapping (uint256 => bytes32[]) keysByPurpose;
21         mapping (uint256 => Execution) executions;
22     }
23 
24     struct Execution {
25         address to;
26         uint256 value;
27         bytes data;
28         bool approved;
29         bool executed;
30     }
31 
32     function init(KeyHolderData storage _keyHolderData)
33         public
34     {
35         bytes32 _key = keccak256(abi.encodePacked(msg.sender));
36         _keyHolderData.keys[_key].key = _key;
37         _keyHolderData.keys[_key].purposes.push(1);
38         _keyHolderData.keys[_key].keyType = 1;
39         _keyHolderData.keysByPurpose[1].push(_key);
40         emit KeyAdded(_key, 1, 1);
41     }
42 
43     function getKey(KeyHolderData storage _keyHolderData, bytes32 _key)
44         public
45         view
46         returns(uint256[] purposes, uint256 keyType, bytes32 key)
47     {
48         return (
49             _keyHolderData.keys[_key].purposes,
50             _keyHolderData.keys[_key].keyType,
51             _keyHolderData.keys[_key].key
52         );
53     }
54 
55     function getKeyPurposes(KeyHolderData storage _keyHolderData, bytes32 _key)
56         public
57         view
58         returns(uint256[] purposes)
59     {
60         return (_keyHolderData.keys[_key].purposes);
61     }
62 
63     function getKeysByPurpose(KeyHolderData storage _keyHolderData, uint256 _purpose)
64         public
65         view
66         returns(bytes32[] _keys)
67     {
68         return _keyHolderData.keysByPurpose[_purpose];
69     }
70 
71     function addKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose, uint256 _type)
72         public
73         returns (bool success)
74     {
75         require(!keyHasPurpose(_keyHolderData, _key, _purpose), "Key already exists with same purpose"); // Key should not already exist with same purpose
76         if (msg.sender != address(this)) {
77             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
78         }
79 
80         _keyHolderData.keys[_key].key = _key;
81         _keyHolderData.keys[_key].purposes.push(_purpose);
82         _keyHolderData.keys[_key].keyType = _type;
83 
84         _keyHolderData.keysByPurpose[_purpose].push(_key);
85 
86         emit KeyAdded(_key, _purpose, _type);
87 
88         return true;
89     }
90 
91     function addKeys(KeyHolderData storage _keyHolderData, bytes32[] _keys, uint256 _purpose, uint256 _type)
92         public
93         returns (bool success)
94     {
95         for (uint16 i = 0; i < _keys.length; i++) {
96             addKey(
97                 _keyHolderData,
98                 _keys[i],
99                 _purpose,
100                 _type
101             );
102         }
103 
104         return true;
105     }
106 
107     function approve(KeyHolderData storage _keyHolderData, uint256 _id, bool _approve)
108         public
109         returns (bool success)
110     {
111         require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 2), "Sender does not have action key");
112         require(!_keyHolderData.executions[_id].executed, "Already executed");
113 
114         emit Approved(_id, _approve);
115 
116         if (_approve == true) {
117             _keyHolderData.executions[_id].approved = true;
118             success = _keyHolderData.executions[_id].to.call(_keyHolderData.executions[_id].data, 0);
119             if (success) {
120                 _keyHolderData.executions[_id].executed = true;
121                 emit Executed(
122                     _id,
123                     _keyHolderData.executions[_id].to,
124                     _keyHolderData.executions[_id].value,
125                     _keyHolderData.executions[_id].data
126                 );
127                 return;
128             } else {
129                 emit ExecutionFailed(
130                     _id,
131                     _keyHolderData.executions[_id].to,
132                     _keyHolderData.executions[_id].value,
133                     _keyHolderData.executions[_id].data
134                 );
135                 return;
136             }
137         } else {
138             _keyHolderData.executions[_id].approved = false;
139         }
140         return true;
141     }
142 
143     function execute(KeyHolderData storage _keyHolderData, address _to, uint256 _value, bytes _data)
144         public
145         returns (uint256 executionId)
146     {
147         require(!_keyHolderData.executions[_keyHolderData.executionNonce].executed, "Already executed");
148         _keyHolderData.executions[_keyHolderData.executionNonce].to = _to;
149         _keyHolderData.executions[_keyHolderData.executionNonce].value = _value;
150         _keyHolderData.executions[_keyHolderData.executionNonce].data = _data;
151 
152         emit ExecutionRequested(_keyHolderData.executionNonce, _to, _value, _data);
153 
154         if (keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),1) || keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),2)) {
155             approve(_keyHolderData, _keyHolderData.executionNonce, true);
156         }
157 
158         _keyHolderData.executionNonce++;
159         return _keyHolderData.executionNonce-1;
160     }
161 
162     function removeKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
163         public
164         returns (bool success)
165     {
166         if (msg.sender != address(this)) {
167             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
168         }
169 
170         require(_keyHolderData.keys[_key].key == _key, "No such key");
171         emit KeyRemoved(_key, _purpose, _keyHolderData.keys[_key].keyType);
172 
173         // Remove purpose from key
174         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
175         for (uint i = 0; i < purposes.length; i++) {
176             if (purposes[i] == _purpose) {
177                 purposes[i] = purposes[purposes.length - 1];
178                 delete purposes[purposes.length - 1];
179                 purposes.length--;
180                 break;
181             }
182         }
183 
184         // If no more purposes, delete key
185         if (purposes.length == 0) {
186             delete _keyHolderData.keys[_key];
187         }
188 
189         // Remove key from keysByPurpose
190         bytes32[] storage keys = _keyHolderData.keysByPurpose[_purpose];
191         for (uint j = 0; j < keys.length; j++) {
192             if (keys[j] == _key) {
193                 keys[j] = keys[keys.length - 1];
194                 delete keys[keys.length - 1];
195                 keys.length--;
196                 break;
197             }
198         }
199 
200         return true;
201     }
202 
203     function keyHasPurpose(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
204         public
205         view
206         returns(bool result)
207     {
208         bool isThere;
209         if (_keyHolderData.keys[_key].key == 0) {
210             return false;
211         }
212 
213         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
214         for (uint i = 0; i < purposes.length; i++) {
215             if (purposes[i] <= _purpose) {
216                 isThere = true;
217                 break;
218             }
219         }
220         return isThere;
221     }
222 }
223 
224 library ClaimHolderLibrary {
225     event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
226     event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
227 
228     struct Claim {
229         uint256 topic;
230         uint256 scheme;
231         address issuer; // msg.sender
232         bytes signature; // this.address + topic + data
233         bytes data;
234         string uri;
235     }
236 
237     struct Claims {
238         mapping (bytes32 => Claim) byId;
239         mapping (uint256 => bytes32[]) byTopic;
240     }
241 
242     function addClaim(
243         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
244         Claims storage _claims,
245         uint256 _topic,
246         uint256 _scheme,
247         address _issuer,
248         bytes _signature,
249         bytes _data,
250         string _uri
251     )
252         public
253         returns (bytes32 claimRequestId)
254     {
255         if (msg.sender != address(this)) {
256             bytes32 sender = keccak256(abi.encodePacked(msg.sender));
257             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, sender, 1) ||
258                     KeyHolderLibrary.keyHasPurpose(_keyHolderData, sender, 3), "Sender does not have claim signer key");
259         }
260 
261         bytes32 claimId = keccak256(abi.encodePacked(_issuer, _topic));
262 
263         if (_claims.byId[claimId].issuer != _issuer) {
264             _claims.byTopic[_topic].push(claimId);
265         }
266 
267         _claims.byId[claimId].topic = _topic;
268         _claims.byId[claimId].scheme = _scheme;
269         _claims.byId[claimId].issuer = _issuer;
270         _claims.byId[claimId].signature = _signature;
271         _claims.byId[claimId].data = _data;
272         _claims.byId[claimId].uri = _uri;
273 
274         emit ClaimAdded(
275             claimId,
276             _topic,
277             _scheme,
278             _issuer,
279             _signature,
280             _data,
281             _uri
282         );
283 
284         return claimId;
285     }
286 
287     function addClaims(
288         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
289         Claims storage _claims,
290         uint256[] _topic,
291         address[] _issuer,
292         bytes _signature,
293         bytes _data,
294         uint256[] _offsets
295     )
296         public
297     {
298         uint offset = 0;
299         for (uint16 i = 0; i < _topic.length; i++) {
300             addClaim(
301                 _keyHolderData,
302                 _claims,
303                 _topic[i],
304                 1,
305                 _issuer[i],
306                 getBytes(_signature, (i * 65), 65),
307                 getBytes(_data, offset, _offsets[i]),
308                 ""
309             );
310             offset += _offsets[i];
311         }
312     }
313 
314     function removeClaim(
315         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
316         Claims storage _claims,
317         bytes32 _claimId
318     )
319         public
320         returns (bool success)
321     {
322         if (msg.sender != address(this)) {
323             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key");
324         }
325 
326         emit ClaimRemoved(
327             _claimId,
328             _claims.byId[_claimId].topic,
329             _claims.byId[_claimId].scheme,
330             _claims.byId[_claimId].issuer,
331             _claims.byId[_claimId].signature,
332             _claims.byId[_claimId].data,
333             _claims.byId[_claimId].uri
334         );
335 
336         delete _claims.byId[_claimId];
337         return true;
338     }
339 
340     function getClaim(Claims storage _claims, bytes32 _claimId)
341         public
342         view
343         returns(
344           uint256 topic,
345           uint256 scheme,
346           address issuer,
347           bytes signature,
348           bytes data,
349           string uri
350         )
351     {
352         return (
353             _claims.byId[_claimId].topic,
354             _claims.byId[_claimId].scheme,
355             _claims.byId[_claimId].issuer,
356             _claims.byId[_claimId].signature,
357             _claims.byId[_claimId].data,
358             _claims.byId[_claimId].uri
359         );
360     }
361 
362     function getBytes(bytes _str, uint256 _offset, uint256 _length)
363         internal
364         pure
365         returns (bytes)
366     {
367         bytes memory sig = new bytes(_length);
368         uint256 j = 0;
369         for (uint256 k = _offset; k < _offset + _length; k++) {
370             sig[j] = _str[k];
371             j++;
372         }
373         return sig;
374     }
375 }
376 
377 contract ERC725 {
378     uint256 constant MANAGEMENT_KEY = 1;
379     uint256 constant ACTION_KEY = 2;
380     uint256 constant CLAIM_SIGNER_KEY = 3;
381     uint256 constant ENCRYPTION_KEY = 4;
382 
383     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
384     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
385     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
386     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
387     event Approved(uint256 indexed executionId, bool approved);
388 
389     function getKey(bytes32 _key) public view returns(uint256[] purposes, uint256 keyType, bytes32 key);
390     function keyHasPurpose(bytes32 _key, uint256 _purpose) public view returns (bool exists);
391     function getKeysByPurpose(uint256 _purpose) public view returns(bytes32[] keys);
392     function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) public returns (bool success);
393     function removeKey(bytes32 _key, uint256 _purpose) public returns (bool success);
394     function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId);
395     function approve(uint256 _id, bool _approve) public returns (bool success);
396 }
397 
398 contract ERC735 {
399     event ClaimRequested(uint256 indexed claimRequestId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
400     event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
401     event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
402     event ClaimChanged(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
403 
404     struct Claim {
405         uint256 topic;
406         uint256 scheme;
407         address issuer; // msg.sender
408         bytes signature; // this.address + topic + data
409         bytes data;
410         string uri;
411     }
412 
413     function getClaim(bytes32 _claimId) public view returns(uint256 topic, uint256 scheme, address issuer, bytes signature, bytes data, string uri);
414     function getClaimIdsByTopic(uint256 _topic) public view returns(bytes32[] claimIds);
415     function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes _signature, bytes _data, string _uri) public returns (bytes32 claimRequestId);
416     function removeClaim(bytes32 _claimId) public returns (bool success);
417 }
418 
419 contract KeyHolder is ERC725 {
420     KeyHolderLibrary.KeyHolderData keyHolderData;
421 
422     constructor() public {
423         KeyHolderLibrary.init(keyHolderData);
424     }
425 
426     function getKey(bytes32 _key)
427         public
428         view
429         returns(uint256[] purposes, uint256 keyType, bytes32 key)
430     {
431         return KeyHolderLibrary.getKey(keyHolderData, _key);
432     }
433 
434     function getKeyPurposes(bytes32 _key)
435         public
436         view
437         returns(uint256[] purposes)
438     {
439         return KeyHolderLibrary.getKeyPurposes(keyHolderData, _key);
440     }
441 
442     function getKeysByPurpose(uint256 _purpose)
443         public
444         view
445         returns(bytes32[] _keys)
446     {
447         return KeyHolderLibrary.getKeysByPurpose(keyHolderData, _purpose);
448     }
449 
450     function addKey(bytes32 _key, uint256 _purpose, uint256 _type)
451         public
452         returns (bool success)
453     {
454         return KeyHolderLibrary.addKey(keyHolderData, _key, _purpose, _type);
455     }
456 
457     function addKeys(bytes32[] _keys, uint256 _purpose, uint256 _type)
458         public
459         returns (bool success)
460     {
461         return KeyHolderLibrary.addKeys(keyHolderData, _keys, _purpose, _type);
462     }
463 
464     function approve(uint256 _id, bool _approve)
465         public
466         returns (bool success)
467     {
468         return KeyHolderLibrary.approve(keyHolderData, _id, _approve);
469     }
470 
471     function execute(address _to, uint256 _value, bytes _data)
472         public
473         returns (uint256 executionId)
474     {
475         return KeyHolderLibrary.execute(keyHolderData, _to, _value, _data);
476     }
477 
478     function removeKey(bytes32 _key, uint256 _purpose)
479         public
480         returns (bool success)
481     {
482         return KeyHolderLibrary.removeKey(keyHolderData, _key, _purpose);
483     }
484 
485     function keyHasPurpose(bytes32 _key, uint256 _purpose)
486         public
487         view
488         returns(bool exists)
489     {
490         return KeyHolderLibrary.keyHasPurpose(keyHolderData, _key, _purpose);
491     }
492 }
493 
494 contract ClaimHolder is KeyHolder, ERC735 {
495     ClaimHolderLibrary.Claims claims;
496 
497     function addClaim(
498         uint256 _topic,
499         uint256 _scheme,
500         address _issuer,
501         bytes _signature,
502         bytes _data,
503         string _uri
504     )
505         public
506         returns (bytes32 claimRequestId)
507     {
508         return ClaimHolderLibrary.addClaim(
509             keyHolderData,
510             claims,
511             _topic,
512             _scheme,
513             _issuer,
514             _signature,
515             _data,
516             _uri
517         );
518     }
519 
520     function addClaims(
521         uint256[] _topic,
522         address[] _issuer,
523         bytes _signature,
524         bytes _data,
525         uint256[] _offsets
526     )
527         public
528     {
529         ClaimHolderLibrary.addClaims(
530             keyHolderData,
531             claims,
532             _topic,
533             _issuer,
534             _signature,
535             _data,
536             _offsets
537         );
538     }
539 
540     function removeClaim(bytes32 _claimId) public returns (bool success) {
541         return ClaimHolderLibrary.removeClaim(keyHolderData, claims, _claimId);
542     }
543 
544     function getClaim(bytes32 _claimId)
545         public
546         view
547         returns(
548             uint256 topic,
549             uint256 scheme,
550             address issuer,
551             bytes signature,
552             bytes data,
553             string uri
554         )
555     {
556         return ClaimHolderLibrary.getClaim(claims, _claimId);
557     }
558 
559     function getClaimIdsByTopic(uint256 _topic)
560         public
561         view
562         returns(bytes32[] claimIds)
563     {
564         return claims.byTopic[_topic];
565     }
566 }
567 
568 contract managed {
569     address public admin;
570 
571     constructor() public {
572         admin = msg.sender;
573     }
574 
575     modifier onlyAdmin {
576         require(msg.sender == admin);
577         _;
578     }
579 
580     function transferOwnership(address newAdmin) onlyAdmin public {
581         admin = newAdmin;
582     }
583 }
584 
585 contract WhooseWalletAdmin is managed {
586     mapping(address => address) contracts;
587 
588     function addContract(address addr) public returns(bool success) {
589         contracts[addr] = addr;
590         return true;
591     }
592 
593     function removeContract(address addr) public onlyAdmin returns(bool success) {
594         delete contracts[addr];
595         return true;
596     }
597 
598     function getContract(address addr) public view onlyAdmin returns(address addr_res) {
599         return contracts[addr];
600     }
601 
602     // ERC725
603     function getKey(address _walletAddress, bytes32 _key)
604         public view onlyAdmin returns(uint256[] purposes, uint256 keyType, bytes32 key) {
605         WhooseWallet _wallet = WhooseWallet(_walletAddress);
606         return _wallet.getKey(_key);
607     }
608 
609     function keyHasPurpose(address _walletAddress, bytes32 _key, uint256 _purpose)
610         public view onlyAdmin returns (bool exists) {
611         WhooseWallet _wallet = WhooseWallet(_walletAddress);
612         return _wallet.keyHasPurpose(_key, _purpose);
613     }
614 
615     function getKeysByPurpose(address _walletAddress, uint256 _purpose)
616         public view onlyAdmin returns(bytes32[] keys) {
617         WhooseWallet _wallet = WhooseWallet(_walletAddress);
618         return _wallet.getKeysByPurpose(_purpose);
619     }
620 
621     function addKey(address _walletAddress, bytes32 _key, uint256 _purpose, uint256 _keyType)
622         public onlyAdmin returns (bool success) {
623         WhooseWallet _wallet = WhooseWallet(_walletAddress);
624         return _wallet.addKey(_key, _purpose, _keyType);
625     }
626 
627     function addKeys(address _walletAddress, bytes32[] _keys, uint256 _purpose, uint256 _keyType)
628         public onlyAdmin returns (bool success) {
629         WhooseWallet _wallet = WhooseWallet(_walletAddress);
630         return _wallet.addKeys(_keys, _purpose, _keyType);
631     }
632 
633     function removeKey(address _walletAddress, bytes32 _key, uint256 _purpose)
634         public onlyAdmin returns (bool success) {
635         WhooseWallet _wallet = WhooseWallet(_walletAddress);
636         return _wallet.removeKey(_key, _purpose);
637     }
638 
639     function execute(address _walletAddress, address _to, uint256 _value, bytes _data)
640         public onlyAdmin returns (uint256 executionId) {
641         WhooseWallet _wallet = WhooseWallet(_walletAddress);
642         return _wallet.execute(_to, _value, _data);
643     }
644 
645     function approve(address _walletAddress, uint256 _id, bool _approve)
646         public onlyAdmin returns (bool success) {
647         WhooseWallet _wallet = WhooseWallet(_walletAddress);
648         return _wallet.approve(_id, _approve);
649     }
650 
651     // ERC735
652     function getClaim(address _walletAddress, bytes32 _claimId)
653         public onlyAdmin view returns(uint256 topic, uint256 scheme, address issuer, bytes signature, bytes data, string uri) {
654         WhooseWallet _wallet = WhooseWallet(_walletAddress);
655         return _wallet.getClaim(_claimId);
656     }
657 
658     function getClaimIdsByTopic(address _walletAddress, uint256 _topic)
659         public onlyAdmin view returns(bytes32[] claimIds) {
660         WhooseWallet _wallet = WhooseWallet(_walletAddress);
661         return _wallet.getClaimIdsByTopic(_topic);
662     }
663 
664     function addClaim(address _walletAddress, uint256 _topic, uint256 _scheme, address issuer, bytes _signature, bytes _data, string _uri)
665         public onlyAdmin returns (bytes32 claimRequestId) {
666         WhooseWallet _wallet = WhooseWallet(_walletAddress);
667         return _wallet.addClaim(_topic, _scheme, issuer, _signature, _data, _uri);
668     }
669 
670     function removeClaim(address _walletAddress, bytes32 _claimId)
671         public onlyAdmin returns (bool success) {
672         WhooseWallet _wallet = WhooseWallet(_walletAddress);
673         return _wallet.removeClaim(_claimId);
674     }
675 
676     function kill(address _walletAddress)
677         public onlyAdmin returns (bool success) {
678         WhooseWallet _wallet = WhooseWallet(_walletAddress);
679         _wallet.destruct();
680         return true;
681     }
682 }
683 
684 contract WhooseWallet is ClaimHolder {
685     address whooseWalletAdminAddress = 0x6babebb9657257F83492D457E7f41B2524368dE6;
686 
687     constructor() public {
688         bytes32 _admin = keccak256(abi.encodePacked(whooseWalletAdminAddress));
689         addKey(_admin, 1, 1);
690 
691         WhooseWalletAdmin _walletAdmin = WhooseWalletAdmin(whooseWalletAdminAddress);
692         _walletAdmin.addContract(address(this));
693     }
694 
695     function destruct() public {
696         if (msg.sender != address(this) && whooseWalletAdminAddress != address(this)) {
697             bytes32 sender = keccak256(abi.encodePacked(msg.sender));
698             require(KeyHolderLibrary.keyHasPurpose(keyHolderData, sender, 1), "Sender does not have management key");
699         }
700 
701         selfdestruct(whooseWalletAdminAddress);
702     }
703 }