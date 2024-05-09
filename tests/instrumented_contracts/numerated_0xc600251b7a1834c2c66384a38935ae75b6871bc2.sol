1 // Written by Nick Poulden, Tyler Yasaka, and the Origin Protocol Team.
2 pragma solidity ^0.4.13;
3 
4 library ClaimHolderLibrary {
5     event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
6     event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
7 
8     struct Claim {
9         uint256 topic;
10         uint256 scheme;
11         address issuer; // msg.sender
12         bytes signature; // this.address + topic + data
13         bytes data;
14         string uri;
15     }
16 
17     struct Claims {
18         mapping (bytes32 => Claim) byId;
19         mapping (uint256 => bytes32[]) byTopic;
20     }
21 
22     function addClaim(
23         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
24         Claims storage _claims,
25         uint256 _topic,
26         uint256 _scheme,
27         address _issuer,
28         bytes _signature,
29         bytes _data,
30         string _uri
31     )
32         public
33         returns (bytes32 claimRequestId)
34     {
35         if (msg.sender != address(this)) {
36             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 3), "Sender does not have claim signer key");
37         }
38 
39         bytes32 claimId = keccak256(abi.encodePacked(_issuer, _topic));
40 
41         if (_claims.byId[claimId].issuer != _issuer) {
42             _claims.byTopic[_topic].push(claimId);
43         }
44 
45         _claims.byId[claimId].topic = _topic;
46         _claims.byId[claimId].scheme = _scheme;
47         _claims.byId[claimId].issuer = _issuer;
48         _claims.byId[claimId].signature = _signature;
49         _claims.byId[claimId].data = _data;
50         _claims.byId[claimId].uri = _uri;
51 
52         emit ClaimAdded(
53             claimId,
54             _topic,
55             _scheme,
56             _issuer,
57             _signature,
58             _data,
59             _uri
60         );
61 
62         return claimId;
63     }
64 
65     function addClaims(
66         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
67         Claims storage _claims,
68         uint256[] _topic,
69         address[] _issuer,
70         bytes _signature,
71         bytes _data,
72         uint256[] _offsets
73     )
74         public
75     {
76         uint offset = 0;
77         for (uint16 i = 0; i < _topic.length; i++) {
78             addClaim(
79                 _keyHolderData,
80                 _claims,
81                 _topic[i],
82                 1,
83                 _issuer[i],
84                 getBytes(_signature, (i * 65), 65),
85                 getBytes(_data, offset, _offsets[i]),
86                 ""
87             );
88             offset += _offsets[i];
89         }
90     }
91 
92     function removeClaim(
93         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
94         Claims storage _claims,
95         bytes32 _claimId
96     )
97         public
98         returns (bool success)
99     {
100         if (msg.sender != address(this)) {
101             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key");
102         }
103 
104         emit ClaimRemoved(
105             _claimId,
106             _claims.byId[_claimId].topic,
107             _claims.byId[_claimId].scheme,
108             _claims.byId[_claimId].issuer,
109             _claims.byId[_claimId].signature,
110             _claims.byId[_claimId].data,
111             _claims.byId[_claimId].uri
112         );
113 
114         delete _claims.byId[_claimId];
115         return true;
116     }
117 
118     function getClaim(Claims storage _claims, bytes32 _claimId)
119         public
120         view
121         returns(
122           uint256 topic,
123           uint256 scheme,
124           address issuer,
125           bytes signature,
126           bytes data,
127           string uri
128         )
129     {
130         return (
131             _claims.byId[_claimId].topic,
132             _claims.byId[_claimId].scheme,
133             _claims.byId[_claimId].issuer,
134             _claims.byId[_claimId].signature,
135             _claims.byId[_claimId].data,
136             _claims.byId[_claimId].uri
137         );
138     }
139 
140     function getBytes(bytes _str, uint256 _offset, uint256 _length)
141         internal
142         pure
143         returns (bytes)
144     {
145         bytes memory sig = new bytes(_length);
146         uint256 j = 0;
147         for (uint256 k = _offset; k < _offset + _length; k++) {
148             sig[j] = _str[k];
149             j++;
150         }
151         return sig;
152     }
153 }
154 
155 contract ERC725 {
156 
157     uint256 constant MANAGEMENT_KEY = 1;
158     uint256 constant ACTION_KEY = 2;
159     uint256 constant CLAIM_SIGNER_KEY = 3;
160     uint256 constant ENCRYPTION_KEY = 4;
161 
162     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
163     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
164     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
165     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
166     event Approved(uint256 indexed executionId, bool approved);
167 
168     function getKey(bytes32 _key) public view returns(uint256[] purposes, uint256 keyType, bytes32 key);
169     function keyHasPurpose(bytes32 _key, uint256 _purpose) public view returns (bool exists);
170     function getKeysByPurpose(uint256 _purpose) public view returns(bytes32[] keys);
171     function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) public returns (bool success);
172     function removeKey(bytes32 _key, uint256 _purpose) public returns (bool success);
173     function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId);
174     function approve(uint256 _id, bool _approve) public returns (bool success);
175 }
176 
177 contract ERC735 {
178 
179     event ClaimRequested(uint256 indexed claimRequestId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
180     event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
181     event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
182     event ClaimChanged(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
183 
184     struct Claim {
185         uint256 topic;
186         uint256 scheme;
187         address issuer; // msg.sender
188         bytes signature; // this.address + topic + data
189         bytes data;
190         string uri;
191     }
192 
193     function getClaim(bytes32 _claimId) public view returns(uint256 topic, uint256 scheme, address issuer, bytes signature, bytes data, string uri);
194     function getClaimIdsByTopic(uint256 _topic) public view returns(bytes32[] claimIds);
195     function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes _signature, bytes _data, string _uri) public returns (bytes32 claimRequestId);
196     function removeClaim(bytes32 _claimId) public returns (bool success);
197 }
198 
199 contract KeyHolder is ERC725 {
200     KeyHolderLibrary.KeyHolderData keyHolderData;
201 
202     constructor() public {
203         KeyHolderLibrary.init(keyHolderData);
204     }
205 
206     function getKey(bytes32 _key)
207         public
208         view
209         returns(uint256[] purposes, uint256 keyType, bytes32 key)
210     {
211         return KeyHolderLibrary.getKey(keyHolderData, _key);
212     }
213 
214     function getKeyPurposes(bytes32 _key)
215         public
216         view
217         returns(uint256[] purposes)
218     {
219         return KeyHolderLibrary.getKeyPurposes(keyHolderData, _key);
220     }
221 
222     function getKeysByPurpose(uint256 _purpose)
223         public
224         view
225         returns(bytes32[] _keys)
226     {
227         return KeyHolderLibrary.getKeysByPurpose(keyHolderData, _purpose);
228     }
229 
230     function addKey(bytes32 _key, uint256 _purpose, uint256 _type)
231         public
232         returns (bool success)
233     {
234         return KeyHolderLibrary.addKey(keyHolderData, _key, _purpose, _type);
235     }
236 
237     function approve(uint256 _id, bool _approve)
238         public
239         returns (bool success)
240     {
241         return KeyHolderLibrary.approve(keyHolderData, _id, _approve);
242     }
243 
244     function execute(address _to, uint256 _value, bytes _data)
245         public
246         returns (uint256 executionId)
247     {
248         return KeyHolderLibrary.execute(keyHolderData, _to, _value, _data);
249     }
250 
251     function removeKey(bytes32 _key, uint256 _purpose)
252         public
253         returns (bool success)
254     {
255         return KeyHolderLibrary.removeKey(keyHolderData, _key, _purpose);
256     }
257 
258     function keyHasPurpose(bytes32 _key, uint256 _purpose)
259         public
260         view
261         returns(bool exists)
262     {
263         return KeyHolderLibrary.keyHasPurpose(keyHolderData, _key, _purpose);
264     }
265 
266 }
267 
268 contract ClaimHolder is KeyHolder, ERC735 {
269 
270     ClaimHolderLibrary.Claims claims;
271 
272     function addClaim(
273         uint256 _topic,
274         uint256 _scheme,
275         address _issuer,
276         bytes _signature,
277         bytes _data,
278         string _uri
279     )
280         public
281         returns (bytes32 claimRequestId)
282     {
283         return ClaimHolderLibrary.addClaim(
284             keyHolderData,
285             claims,
286             _topic,
287             _scheme,
288             _issuer,
289             _signature,
290             _data,
291             _uri
292         );
293     }
294 
295     function addClaims(
296         uint256[] _topic,
297         address[] _issuer,
298         bytes _signature,
299         bytes _data,
300         uint256[] _offsets
301     )
302         public
303     {
304         ClaimHolderLibrary.addClaims(
305             keyHolderData,
306             claims,
307             _topic,
308             _issuer,
309             _signature,
310             _data,
311             _offsets
312         );
313     }
314 
315     function removeClaim(bytes32 _claimId) public returns (bool success) {
316         return ClaimHolderLibrary.removeClaim(keyHolderData, claims, _claimId);
317     }
318 
319     function getClaim(bytes32 _claimId)
320         public
321         view
322         returns(
323             uint256 topic,
324             uint256 scheme,
325             address issuer,
326             bytes signature,
327             bytes data,
328             string uri
329         )
330     {
331         return ClaimHolderLibrary.getClaim(claims, _claimId);
332     }
333 
334     function getClaimIdsByTopic(uint256 _topic)
335         public
336         view
337         returns(bytes32[] claimIds)
338     {
339         return claims.byTopic[_topic];
340     }
341 }
342 
343 contract ClaimHolderRegistered is ClaimHolder {
344 
345     constructor (
346         address _userRegistryAddress
347     )
348         public
349     {
350         V00_UserRegistry userRegistry = V00_UserRegistry(_userRegistryAddress);
351         userRegistry.registerUser();
352     }
353 }
354 
355 contract ClaimHolderPresigned is ClaimHolderRegistered {
356 
357     constructor(
358         address _userRegistryAddress,
359         uint256[] _topic,
360         address[] _issuer,
361         bytes _signature,
362         bytes _data,
363         uint256[] _offsets
364     )
365         ClaimHolderRegistered(_userRegistryAddress)
366         public
367     {
368         ClaimHolderLibrary.addClaims(
369             keyHolderData,
370             claims,
371             _topic,
372             _issuer,
373             _signature,
374             _data,
375             _offsets
376         );
377     }
378 }
379 
380 library KeyHolderLibrary {
381     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
382     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
383     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
384     event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
385     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
386     event Approved(uint256 indexed executionId, bool approved);
387 
388     struct Key {
389         uint256[] purposes; //e.g., MANAGEMENT_KEY = 1, ACTION_KEY = 2, etc.
390         uint256 keyType; // e.g. 1 = ECDSA, 2 = RSA, etc.
391         bytes32 key;
392     }
393 
394     struct KeyHolderData {
395         uint256 executionNonce;
396         mapping (bytes32 => Key) keys;
397         mapping (uint256 => bytes32[]) keysByPurpose;
398         mapping (uint256 => Execution) executions;
399     }
400 
401     struct Execution {
402         address to;
403         uint256 value;
404         bytes data;
405         bool approved;
406         bool executed;
407     }
408 
409     function init(KeyHolderData storage _keyHolderData)
410         public
411     {
412         bytes32 _key = keccak256(abi.encodePacked(msg.sender));
413         _keyHolderData.keys[_key].key = _key;
414         _keyHolderData.keys[_key].purposes.push(1);
415         _keyHolderData.keys[_key].keyType = 1;
416         _keyHolderData.keysByPurpose[1].push(_key);
417         emit KeyAdded(_key, 1, 1);
418     }
419 
420     function getKey(KeyHolderData storage _keyHolderData, bytes32 _key)
421         public
422         view
423         returns(uint256[] purposes, uint256 keyType, bytes32 key)
424     {
425         return (
426             _keyHolderData.keys[_key].purposes,
427             _keyHolderData.keys[_key].keyType,
428             _keyHolderData.keys[_key].key
429         );
430     }
431 
432     function getKeyPurposes(KeyHolderData storage _keyHolderData, bytes32 _key)
433         public
434         view
435         returns(uint256[] purposes)
436     {
437         return (_keyHolderData.keys[_key].purposes);
438     }
439 
440     function getKeysByPurpose(KeyHolderData storage _keyHolderData, uint256 _purpose)
441         public
442         view
443         returns(bytes32[] _keys)
444     {
445         return _keyHolderData.keysByPurpose[_purpose];
446     }
447 
448     function addKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose, uint256 _type)
449         public
450         returns (bool success)
451     {
452         require(_keyHolderData.keys[_key].key != _key, "Key already exists"); // Key should not already exist
453         if (msg.sender != address(this)) {
454             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
455         }
456 
457         _keyHolderData.keys[_key].key = _key;
458         _keyHolderData.keys[_key].purposes.push(_purpose);
459         _keyHolderData.keys[_key].keyType = _type;
460 
461         _keyHolderData.keysByPurpose[_purpose].push(_key);
462 
463         emit KeyAdded(_key, _purpose, _type);
464 
465         return true;
466     }
467 
468     function approve(KeyHolderData storage _keyHolderData, uint256 _id, bool _approve)
469         public
470         returns (bool success)
471     {
472         require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 2), "Sender does not have action key");
473         require(!_keyHolderData.executions[_id].executed, "Already executed");
474 
475         emit Approved(_id, _approve);
476 
477         if (_approve == true) {
478             _keyHolderData.executions[_id].approved = true;
479             success = _keyHolderData.executions[_id].to.call(_keyHolderData.executions[_id].data, 0);
480             if (success) {
481                 _keyHolderData.executions[_id].executed = true;
482                 emit Executed(
483                     _id,
484                     _keyHolderData.executions[_id].to,
485                     _keyHolderData.executions[_id].value,
486                     _keyHolderData.executions[_id].data
487                 );
488                 return;
489             } else {
490                 emit ExecutionFailed(
491                     _id,
492                     _keyHolderData.executions[_id].to,
493                     _keyHolderData.executions[_id].value,
494                     _keyHolderData.executions[_id].data
495                 );
496                 return;
497             }
498         } else {
499             _keyHolderData.executions[_id].approved = false;
500         }
501         return true;
502     }
503 
504     function execute(KeyHolderData storage _keyHolderData, address _to, uint256 _value, bytes _data)
505         public
506         returns (uint256 executionId)
507     {
508         require(!_keyHolderData.executions[_keyHolderData.executionNonce].executed, "Already executed");
509         _keyHolderData.executions[_keyHolderData.executionNonce].to = _to;
510         _keyHolderData.executions[_keyHolderData.executionNonce].value = _value;
511         _keyHolderData.executions[_keyHolderData.executionNonce].data = _data;
512 
513         emit ExecutionRequested(_keyHolderData.executionNonce, _to, _value, _data);
514 
515         if (keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),1) || keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),2)) {
516             approve(_keyHolderData, _keyHolderData.executionNonce, true);
517         }
518 
519         _keyHolderData.executionNonce++;
520         return _keyHolderData.executionNonce-1;
521     }
522 
523     function removeKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
524         public
525         returns (bool success)
526     {
527         if (msg.sender != address(this)) {
528             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
529         }
530 
531         require(_keyHolderData.keys[_key].key == _key, "No such key");
532         emit KeyRemoved(_key, _purpose, _keyHolderData.keys[_key].keyType);
533 
534         // Remove purpose from key
535         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
536         for (uint i = 0; i < purposes.length; i++) {
537             if (purposes[i] == _purpose) {
538                 purposes[i] = purposes[purposes.length - 1];
539                 delete purposes[purposes.length - 1];
540                 purposes.length--;
541                 break;
542             }
543         }
544 
545         // If no more purposes, delete key
546         if (purposes.length == 0) {
547             delete _keyHolderData.keys[_key];
548         }
549 
550         // Remove key from keysByPurpose
551         bytes32[] storage keys = _keyHolderData.keysByPurpose[_purpose];
552         for (uint j = 0; j < keys.length; j++) {
553             if (keys[j] == _key) {
554                 keys[j] = keys[keys.length - 1];
555                 delete keys[keys.length - 1];
556                 keys.length--;
557                 break;
558             }
559         }
560 
561         return true;
562     }
563 
564     function keyHasPurpose(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
565         public
566         view
567         returns(bool result)
568     {
569         bool isThere;
570         if (_keyHolderData.keys[_key].key == 0) {
571             return false;
572         }
573 
574         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
575         for (uint i = 0; i < purposes.length; i++) {
576             if (purposes[i] <= _purpose) {
577                 isThere = true;
578                 break;
579             }
580         }
581         return isThere;
582     }
583 }
584 
585 contract V00_UserRegistry {
586     /*
587     * Events
588     */
589 
590     event NewUser(address _address, address _identity);
591 
592     /*
593     * Storage
594     */
595 
596     // Mapping from ethereum wallet to ERC725 identity
597     mapping(address => address) public users;
598 
599     /*
600     * Public functions
601     */
602 
603     /// @dev registerUser(): Add a user to the registry
604     function registerUser()
605         public
606     {
607         users[tx.origin] = msg.sender;
608         emit NewUser(tx.origin, msg.sender);
609     }
610 
611     /// @dev clearUser(): Remove user from the registry
612     function clearUser()
613         public
614     {
615         users[msg.sender] = 0;
616     }
617 }