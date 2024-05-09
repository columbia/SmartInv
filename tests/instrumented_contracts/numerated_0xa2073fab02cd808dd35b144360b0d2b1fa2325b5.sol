1 pragma solidity ^0.4.24;
2 
3 contract ERC725 {
4 
5     uint256 public constant MANAGEMENT_KEY = 1;
6     uint256 public constant ACTION_KEY = 2;
7     uint256 public constant CLAIM_SIGNER_KEY = 3;
8     uint256 public constant ENCRYPTION_KEY = 4;
9 
10     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
11     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
12     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
13     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
14     event Approved(uint256 indexed executionId, bool approved);
15 
16     struct Key {
17         uint256[] purpose; //e.g., MANAGEMENT_KEY = 1, ACTION_KEY = 2, etc.
18         uint256 keyType; // e.g. 1 = ECDSA, 2 = RSA, etc.
19         bytes32 key;
20     }
21 
22     function getKey(bytes32 _key) public constant returns(uint256[] purpose, uint256 keyType, bytes32 key);
23     function getKeyPurpose(bytes32 _key) public constant returns(uint256[] purpose);
24     function getKeysByPurpose(uint256 _purpose) public constant returns(bytes32[] keys);
25     function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) public returns (bool success);
26     function removeKey(bytes32 _key, uint256 _purpose) public returns (bool success);
27     function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId);
28     function approve(uint256 _id, bool _approve) public returns (bool success);
29 }
30 
31 contract ERC20Basic {
32     function balanceOf(address _who) public constant returns (uint256);
33     function transfer(address _to, uint256 _value) public returns (bool);
34 }
35 
36 contract Identity is ERC725 {
37 
38     uint256 constant LOGIN_KEY = 10;
39     uint256 constant FUNDS_MANAGEMENT = 11;
40 
41     uint256 executionNonce;
42 
43     struct Execution {
44         address to;
45         uint256 value;
46         bytes data;
47         bool approved;
48         bool executed;
49     }
50 
51     mapping (bytes32 => Key) keys;
52     mapping (uint256 => bytes32[]) keysByPurpose;
53     mapping (uint256 => Execution) executions;
54 
55     event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
56 
57     modifier onlyManagement() {
58         require(keyHasPurpose(keccak256(msg.sender), MANAGEMENT_KEY), "Sender does not have management key");
59         _;
60     }
61 
62     modifier onlyAction() {
63         require(keyHasPurpose(keccak256(msg.sender), ACTION_KEY), "Sender does not have action key");
64         _;
65     }
66 
67     modifier onlyFundsManagement() {
68         require(keyHasPurpose(keccak256(msg.sender), FUNDS_MANAGEMENT), "Sender does not have funds key");
69         _;
70     }
71 
72     constructor() public {
73         bytes32 _key = keccak256(msg.sender);
74         keys[_key].key = _key;
75         keys[_key].purpose = [MANAGEMENT_KEY];
76         keys[_key].keyType = 1;
77         keysByPurpose[MANAGEMENT_KEY].push(_key);
78         emit KeyAdded(_key, MANAGEMENT_KEY, 1);
79     }
80 
81     function getKey(bytes32 _key)
82         public
83         view
84         returns(uint256[] purpose, uint256 keyType, bytes32 key)
85     {
86         return (keys[_key].purpose, keys[_key].keyType, keys[_key].key);
87     }
88 
89     function getKeyPurpose(bytes32 _key)
90         public
91         view
92         returns(uint256[] purpose)
93     {
94         return (keys[_key].purpose);
95     }
96 
97     function getKeysByPurpose(uint256 _purpose)
98         public
99         view
100         returns(bytes32[] _keys)
101     {
102         return keysByPurpose[_purpose];
103     }
104 
105     function addKey(bytes32 _key, uint256 _purpose, uint256 _type)
106         public
107         onlyManagement
108         returns (bool success)
109     {
110         if (keyHasPurpose(_key, _purpose)) {
111             return true;
112         }
113 
114         keys[_key].key = _key;
115         keys[_key].purpose.push(_purpose);
116         keys[_key].keyType = _type;
117 
118         keysByPurpose[_purpose].push(_key);
119 
120         emit KeyAdded(_key, _purpose, _type);
121 
122         return true;
123     }
124 
125     function approve(uint256 _id, bool _approve)
126         public
127         onlyAction
128         returns (bool success)
129     {
130         emit Approved(_id, _approve);
131 
132         if (_approve == true) {
133             executions[_id].approved = true;
134             success = executions[_id].to.call(executions[_id].data, 0);
135             if (success) {
136                 executions[_id].executed = true;
137                 emit Executed(
138                     _id,
139                     executions[_id].to,
140                     executions[_id].value,
141                     executions[_id].data
142                 );
143             } else {
144                 emit ExecutionFailed(
145                     _id,
146                     executions[_id].to,
147                     executions[_id].value,
148                     executions[_id].data
149                 );
150             }
151             return success;
152         } else {
153             executions[_id].approved = false;
154         }
155         return true;
156     }
157 
158     function execute(address _to, uint256 _value, bytes _data)
159         public
160         returns (uint256 executionId)
161     {
162         require(!executions[executionNonce].executed, "Already executed");
163         executions[executionNonce].to = _to;
164         executions[executionNonce].value = _value;
165         executions[executionNonce].data = _data;
166 
167         emit ExecutionRequested(executionNonce, _to, _value, _data);
168 
169         if (keyHasPurpose(keccak256(msg.sender), ACTION_KEY)) {
170             approve(executionNonce, true);
171         }
172 
173         executionNonce++;
174         return executionNonce-1;
175     }
176 
177     function removeKey(bytes32 _key, uint256 _purpose)
178         public
179         onlyManagement
180         returns (bool success)
181     {
182         require(keys[_key].key == _key, "No such key");
183 
184         if (!keyHasPurpose(_key, _purpose)) {
185             return false;
186         }
187 
188         uint256 arrayLength = keys[_key].purpose.length;
189         int index = -1;
190         for (uint i = 0; i < arrayLength; i++) {
191             if (keys[_key].purpose[i] == _purpose) {
192                 index = int(i);
193                 break;
194             }
195         }
196 
197         if (index != -1) {
198             keys[_key].purpose[uint(index)] = keys[_key].purpose[arrayLength - 1];
199             delete keys[_key].purpose[arrayLength - 1];
200             keys[_key].purpose.length--;
201         }
202 
203         uint256 purposesLen = keysByPurpose[_purpose].length;
204         for (uint j = 0; j < purposesLen; j++) {
205             if (keysByPurpose[_purpose][j] == _key) {
206                 keysByPurpose[_purpose][j] = keysByPurpose[_purpose][purposesLen - 1];
207                 delete keysByPurpose[_purpose][purposesLen - 1];
208                 keysByPurpose[_purpose].length--;
209                 break;
210             }
211         }
212 
213         emit KeyRemoved(_key, _purpose, keys[_key].keyType);
214 
215         return true;
216     }
217 
218     function keyHasPurpose(bytes32 _key, uint256 _purpose)
219         public
220         view
221         returns(bool result)
222     {
223         if (keys[_key].key == 0) return false;
224         uint256 arrayLength = keys[_key].purpose.length;
225         for (uint i = 0; i < arrayLength; i++) {
226             if (keys[_key].purpose[i] == _purpose) {
227                 return true;
228             }
229         }
230         return false;
231     }
232 
233    /**
234      * Send all ether to msg.sender
235      * Requires FUNDS_MANAGEMENT purpose for msg.sender
236      */
237     function withdraw() public onlyFundsManagement {
238         msg.sender.transfer(address(this).balance);
239     }
240 
241     /**
242      * Transfer ether to _account
243      * @param _amount amount to transfer in wei
244      * @param _account recepient
245      * Requires FUNDS_MANAGEMENT purpose for msg.sender
246      */
247     function transferEth(uint _amount, address _account) public onlyFundsManagement {
248         require(_amount <= address(this).balance, "Amount should be less than total balance of the contract");
249         require(_account != address(0), "must be valid address");
250         _account.transfer(_amount);
251     }
252 
253     /**
254      * Returns contract eth balance
255      */
256     function getBalance() public view returns(uint)  {
257         return address(this).balance;
258     }
259 
260     /**
261      * Returns ERC20 token balance for _token
262      * @param _token token address
263      */
264     function getTokenBalance(address _token) public view returns (uint) {
265         return ERC20Basic(_token).balanceOf(this);
266     }
267 
268     /**
269      * Send all tokens for _token to msg.sender
270      * @param _token ERC20 contract address
271      * Requires FUNDS_MANAGEMENT purpose for msg.sender
272      */
273     function withdrawTokens(address _token) public onlyFundsManagement {
274         require(_token != address(0));
275         ERC20Basic token = ERC20Basic(_token);
276         uint balance = token.balanceOf(this);
277         // token returns true on successful transfer
278         assert(token.transfer(msg.sender, balance));
279     }
280 
281     /**
282      * Send tokens for _token to _to
283      * @param _token ERC20 contract address
284      * @param _to recepient
285      * @param _amount amount in 
286      * Requires FUNDS_MANAGEMENT purpose for msg.sender
287      */
288     function transferTokens(address _token, address _to, uint _amount) public onlyFundsManagement {
289         require(_token != address(0));
290         require(_to != address(0));
291         ERC20Basic token = ERC20Basic(_token);
292         uint balance = token.balanceOf(this);
293         require(_amount <= balance);
294         assert(token.transfer(_to, _amount));
295     }
296 
297     function () public payable {}
298 
299 }
300 
301 contract Encoder {
302 
303     function uintToChar(uint8 _uint) internal pure returns(string) {
304         byte b = "\x30"; // ASCII code for 0
305         if (_uint > 9) {
306             b = "\x60";  // ASCII code for the char before a
307             _uint -= 9;
308         }
309         bytes memory bs = new bytes(1);
310         bs[0] = b | byte(_uint);
311         return string(bs);
312     }
313 
314     /**
315      *  Encodes the string representation of a uint8 into bytes
316      */
317     function encodeUInt(uint256 _uint) public pure returns(bytes memory) {
318         if (_uint == 0) {
319             return abi.encodePacked(uintToChar(0));
320         }
321 
322         bytes memory result;
323         uint256 x = _uint;
324         while (x > 0) {
325             result = abi.encodePacked(uintToChar(uint8(x % 10)), result);
326             x /= 10;
327         }
328         return result;
329     }
330 
331     /**
332      *  Encodes the string representation of an address into bytes
333      */
334     function encodeAddress(address _address) public pure returns (bytes memory res) {
335         for (uint i = 0; i < 20; i++) {
336             // get each byte of the address
337             byte b = byte(uint8(uint(_address) / (2**(8*(19 - i)))));
338 
339             // split it into two
340             uint8 high = uint8(b >> 4);
341             uint8 low = uint8(b) & 15;
342 
343             // and encode them as chars
344             res = abi.encodePacked(res, uintToChar(high), uintToChar(low));
345         }
346         return res;
347     }
348 
349     /**
350      *  Encodes a string into bytes
351      */
352     function encodeString(string _str) public pure returns (bytes memory) {
353         return abi.encodePacked(_str);
354     }
355 }
356 
357 contract SignatureValidator {
358 
359     function doHash(string _message1, uint32 _message2, string _header1, string _header2)
360      pure internal returns (bytes32) {
361         return keccak256(
362             abi.encodePacked(
363                     keccak256(abi.encodePacked(_header1, _header2)),
364                     keccak256(abi.encodePacked(_message1, _message2)))
365         );
366     }
367 
368     /**
369      * Returns address of signer for a signed message
370      * @param _message1 message that was signed
371      * @param _nonce nonce that was part of the signed message
372      * @param _header1 header for the message (ex: "string Message")
373      * @param _header2 header for the nonce (ex: "uint32 nonce")
374      * @param _r r from ECDSA
375      * @param _s s from ECDSA
376      * @param _v recovery id
377      */
378     function checkSignature(string _message1, uint32 _nonce, string _header1, string _header2, bytes32 _r, bytes32 _s, uint8 _v)
379      public pure returns (address) {
380         bytes32 hash = doHash(_message1, _nonce, _header1, _header2);
381         return ecrecover(hash, _v, _r, _s);
382     }
383 
384 }
385 
386 
387 /**
388  * ZincAccesor contract used for constructing and managing Identity contracts
389  * Access control is based on signed messages
390  * This contract can be used as a trustless entity that creates an Identity contract and is used to manage it.
391  * It operates as a proxy in order to allow users to interact with it based on signed messages and not spend any gas
392  * It can be upgraded with the user consent by adding a instance of a new version and removing the old one.
393  */
394 
395 contract ZincAccessor is SignatureValidator, Encoder {
396 
397     uint256 public nonce = 0;
398 
399     event UserIdentityCreated(address indexed userAddress, address indexed identityContractAddress);
400     event AccessorAdded(address indexed identityContractAddress, address indexed keyAddress, uint256 indexed purpose);
401     event AccessorRemoved(address indexed identityContractAddress, address indexed keyAddress, uint256 indexed purpose);
402 
403     function checkUserSignature(
404         address _userAddress,
405         string _message1,
406         uint32 _nonce,
407         string _header1,
408         string _header2,
409         bytes32 _r,
410         bytes32 _s,
411         uint8 _v) 
412     pure internal returns (bool) {
413         require(
414             checkSignature(_message1, _nonce, _header1, _header2, _r, _s, _v) == _userAddress,
415             "User signature must be the same as signed message");
416         return true;
417     }
418 
419     modifier checknonce(uint _nonce) {
420         require(++nonce == _nonce, "Wrong nonce");
421         _;
422     }
423 
424     /**
425      * Constructs an Identity contract and returns its address
426      * Requires a signed message to verify the identity of the initial user address
427      * @param _userAddress user address
428      * @param _message1 message that was signed
429      * @param _nonce nonce that was part of the signed message
430      * @param _header1 header for the message (ex: "string Message")
431      * @param _header2 header for the nonce (ex: "uint32 nonce")
432      * @param _r r from ECDSA
433      * @param _s s from ECDSA
434      * @param _v recovery id
435      */
436     function constructUserIdentity(
437         address _userAddress,
438         string _message1,
439         uint32 _nonce,
440         string _header1,
441         string _header2,
442         bytes32 _r,
443         bytes32 _s,
444         uint8 _v)
445     public
446      returns (address) {
447         require(
448             checkUserSignature(_userAddress, _message1, _nonce, _header1, _header2, _r, _s, _v),
449             "User Signature does not match");
450 
451         Identity id = new Identity();
452         id.addKey(keccak256(_userAddress), id.MANAGEMENT_KEY(), 1);
453 
454         emit UserIdentityCreated(_userAddress, address(id));
455 
456         return address(id);
457     }
458 
459     /**
460      * Adds an accessor to an Identity contract
461      * Requires a signed message to verify the identity of the initial user address
462      * Requires _userAddress to have KEY_MANAGEMENT purpose on the Identity contract
463      * Emits AccessorAdded
464      * @param _key key to add to Identity
465      * @param _purpose purpose for _key
466      * @param _idContract address if Identity contract
467      * @param _userAddress user address
468      * @param _message1 message that was signed of the form "Add {_key} to {_idContract} with purpose {_purpose}"
469      * @param _nonce nonce that was part of the signed message
470      * @param _header1 header for the message (ex: "string Message")
471      * @param _header2 header for the nonce (ex: "uint32 nonce")
472      * @param _r r from ECDSA
473      * @param _s s from ECDSA
474      * @param _v recovery id
475      */
476     function addAccessor(
477         address _key,
478         address _idContract,
479         uint256 _purpose,
480         address _userAddress,
481         string _message1,
482         uint32 _nonce,
483         string _header1,
484         string _header2,
485         bytes32 _r,
486         bytes32 _s,
487         uint8 _v)
488     public checknonce(_nonce) returns (bool) {
489         require(checkUserSignature(_userAddress, _message1, _nonce, _header1, _header2, _r, _s, _v));
490         require(
491             keccak256(abi.encodePacked("Add 0x", encodeAddress(_key), " to 0x", encodeAddress(_idContract), " with purpose ", encodeUInt(_purpose))) ==
492             keccak256(encodeString(_message1)), "Message incorrect");
493 
494         Identity id = Identity(_idContract);
495         require(id.keyHasPurpose(keccak256(_userAddress), id.MANAGEMENT_KEY()));
496 
497         id.addKey(keccak256(_key), _purpose, 1);
498         emit AccessorAdded(_idContract, _key, _purpose);
499         return true;
500     }
501 
502     /**
503      * Remove an accessor from Identity contract
504      * Requires a signed message to verify the identity of the initial user address
505      * Requires _userAddress to have KEY_MANAGEMENT purpose on the Identity contract
506      * Emits AccessorRemoved
507      * @param _key key to add to Identity
508      * @param _idContract address if Identity contract
509      * @param _userAddress user address
510      * @param _message1 message that was signed of the form "Remove {_key} from {_idContract}"
511      * @param _nonce nonce that was part of the signed message
512      * @param _header1 header for the message (ex: "string Message")
513      * @param _header2 header for the nonce (ex: "uint32 nonce")
514      * @param _r r from ECDSA
515      * @param _s s from ECDSA
516      * @param _v recovery id
517      */
518     function removeAccessor(
519         address _key,
520         address _idContract,
521         uint256 _purpose,
522         address _userAddress,
523         string _message1,
524         uint32 _nonce,
525         string _header1,
526         string _header2,
527         bytes32 _r,
528         bytes32 _s,
529         uint8 _v)
530     public checknonce(_nonce) returns (bool) {
531         require(checkUserSignature(_userAddress, _message1, _nonce, _header1, _header2, _r, _s, _v));
532         require(
533             keccak256(abi.encodePacked("Remove 0x", encodeAddress(_key), " from 0x", encodeAddress(_idContract), " with purpose ", encodeUInt(_purpose))) ==
534             keccak256(encodeString(_message1)), "Message incorrect");
535 
536         Identity id = Identity(_idContract);
537         require(id.keyHasPurpose(keccak256(_userAddress), id.MANAGEMENT_KEY()));
538 
539         id.removeKey(keccak256(_key), _purpose);
540 
541         emit AccessorRemoved(_idContract, _key, _purpose);
542         return true;
543     }
544 
545 }