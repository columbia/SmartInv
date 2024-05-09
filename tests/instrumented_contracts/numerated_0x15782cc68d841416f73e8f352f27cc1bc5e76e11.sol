1 pragma solidity ^0.4.19;
2 
3 /**
4  * XC Plugin Contract Interface.
5  */
6 interface XCPluginInterface {
7 
8     /**
9      * Open the contract service status.
10      */
11     function start() external;
12 
13     /**
14      * Close the contract service status.
15      */
16     function stop() external;
17 
18     /**
19      * Get contract service status.
20      * @return contract service status.
21      */
22     function getStatus() external view returns (bool);
23 
24     /**
25      * Get the current contract platform name.
26      * @return contract platform name.
27      */
28     function getPlatformName() external view returns (bytes32);
29 
30     /**
31      * Set the current contract administrator.
32      * @param account account of contract administrator.
33      */
34     function setAdmin(address account) external;
35 
36     /**
37      * Get the current contract administrator.
38      * @return contract administrator.
39      */
40     function getAdmin() external view returns (address);
41 
42     /**
43      * Get the current token symbol.
44      * @return token symbol.
45      */
46     function getTokenSymbol() external view returns (bytes32);
47 
48     /**
49      * Add a contract trust caller.
50      * @param caller account of caller.
51      */
52     function addCaller(address caller) external;
53 
54     /**
55      * Delete a contract trust caller.
56      * @param caller account of caller.
57      */
58     function deleteCaller(address caller) external;
59 
60     /**
61      * Whether the trust caller exists.
62      * @param caller account of caller.
63      * @return whether exists.
64      */
65     function existCaller(address caller) external view returns (bool);
66 
67     /**
68      * Get all contract trusted callers.
69      * @return al lcallers.
70      */
71     function getCallers() external view returns (address[]);
72 
73     /**
74      * Get the trusted platform name.
75      * @return name a platform name.
76      */
77     function getTrustPlatform() external view returns (bytes32 name);
78 
79     /**
80      * Add the trusted platform public key information.
81      * @param publicKey a public key.
82      */
83     function addPublicKey(address publicKey) external;
84 
85     /**
86      * Delete the trusted platform public key information.
87      * @param publicKey a public key.
88      */
89     function deletePublicKey(address publicKey) external;
90 
91     /**
92      * Whether the trusted platform public key information exists.
93      * @param publicKey a public key.
94      */
95     function existPublicKey(address publicKey) external view returns (bool);
96 
97     /**
98      * Get the count of public key for the trusted platform.
99      * @return count of public key.
100      */
101     function countOfPublicKey() external view returns (uint);
102 
103     /**
104      * Get the list of public key for the trusted platform.
105      * @return list of public key.
106      */
107     function publicKeys() external view returns (address[]);
108 
109     /**
110      * Set the weight of a trusted platform.
111      * @param weight weight of platform.
112      */
113     function setWeight(uint weight) external;
114 
115     /**
116      * Get the weight of a trusted platform.
117      * @return weight of platform.
118      */
119     function getWeight() external view returns (uint);
120 
121     /**
122      * Initiate and vote on the transaction proposal.
123      * @param fromAccount name of to platform.
124      * @param toAccount account of to platform.
125      * @param value transfer amount.
126      * @param txid transaction id.
127      * @param sig transaction signature.
128      */
129     function voteProposal(address fromAccount, address toAccount, uint value, string txid, bytes sig) external;
130 
131     /**
132      * Verify that the transaction proposal is valid.
133      * @param fromAccount name of to platform.
134      * @param toAccount account of to platform.
135      * @param value transfer amount.
136      * @param txid transaction id.
137      */
138     function verifyProposal(address fromAccount, address toAccount, uint value, string txid) external view returns (bool, bool);
139 
140     /**
141      * Commit the transaction proposal.
142      * @param txid transaction id.
143      */
144     function commitProposal(string txid) external returns (bool);
145 
146     /**
147      * Get the transaction proposal information.
148      * @param txid transaction id.
149      * @return status completion status of proposal.
150      * @return fromAccount account of to platform.
151      * @return toAccount account of to platform.
152      * @return value transfer amount.
153      * @return voters notarial voters.
154      * @return weight The weight value of the completed time.
155      */
156     function getProposal(string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight);
157 
158     /**
159      * Delete the transaction proposal information.
160      * @param txid transaction id.
161      */
162     function deleteProposal(string txid) external;
163 }
164 
165 contract XCPlugin is XCPluginInterface {
166 
167     /**
168      * Contract Administrator
169      * @field status Contract external service status.
170      * @field platformName Current contract platform name.
171      * @field tokenSymbol token Symbol.
172      * @field account Current contract administrator.
173      */
174     struct Admin {
175         bool status;
176         bytes32 platformName;
177         bytes32 tokenSymbol;
178         address account;
179         string version;
180     }
181 
182     /**
183      * Transaction Proposal
184      * @field status Transaction proposal status(false:pending,true:complete).
185      * @field fromAccount Account of form platform.
186      * @field toAccount Account of to platform.
187      * @field value Transfer amount.
188      * @field tokenSymbol token Symbol.
189      * @field voters Proposers.
190      * @field weight The weight value of the completed time.
191      */
192     struct Proposal {
193         bool status;
194         address fromAccount;
195         address toAccount;
196         uint value;
197         address[] voters;
198         uint weight;
199     }
200 
201     /**
202      * Trusted Platform
203      * @field status Trusted platform state(false:no trusted,true:trusted).
204      * @field weight weight of platform.
205      * @field publicKeys list of public key.
206      * @field proposals list of proposal.
207      */
208     struct Platform {
209         bool status;
210         bytes32 name;
211         uint weight;
212         address[] publicKeys;
213         mapping(string => Proposal) proposals;
214     }
215 
216     Admin private admin;
217 
218     address[] private callers;
219 
220     Platform private platform;
221 
222 
223     constructor() public {
224         init();
225     }
226 
227     /**
228      * TODO Parameters that must be set before compilation
229      * $Init admin.status
230      * $Init admin.platformName
231      * $Init admin.tokenSymbol
232      * $Init admin.account
233      * $Init admin.version
234      * $Init platform.status
235      * $Init platform.name
236      * $Init platform.weight
237      * $Init platform.publicKeys
238      */
239     function init() internal {
240         // Admin { status | platformName | tokenSymbol | account}
241         admin.status = true;
242         admin.platformName = "ETH";
243         admin.tokenSymbol = "INK";
244         admin.account = msg.sender;
245         admin.version = "1.0";
246         platform.status = true;
247         platform.name = "INK";
248         platform.weight = 3;
249         platform.publicKeys.push(0x80aa17b21c16620a4d7dd06ec1dcc44190b02ca0);
250         platform.publicKeys.push(0xd2e40bb4967b355da8d70be40c277ebcf108063c);
251         platform.publicKeys.push(0x1501e0f09498aa95cb0c2f1e3ee51223e5074720);
252     }
253 
254     function start() onlyAdmin external {
255         if (!admin.status) {
256             admin.status = true;
257         }
258     }
259 
260     function stop() onlyAdmin external {
261         if (admin.status) {
262             admin.status = false;
263         }
264     }
265 
266     function getStatus() external view returns (bool) {
267         return admin.status;
268     }
269 
270     function getPlatformName() external view returns (bytes32) {
271         return admin.platformName;
272     }
273 
274     function setAdmin(address account) onlyAdmin nonzeroAddress(account) external {
275         if (admin.account != account) {
276             admin.account = account;
277         }
278     }
279 
280     function getAdmin() external view returns (address) {
281         return admin.account;
282     }
283 
284     function getTokenSymbol() external view returns (bytes32) {
285         return admin.tokenSymbol;
286     }
287 
288     function addCaller(address caller) onlyAdmin nonzeroAddress(caller) external {
289         if (!_existCaller(caller)) {
290             callers.push(caller);
291         }
292     }
293 
294     function deleteCaller(address caller) onlyAdmin nonzeroAddress(caller) external {
295         for (uint i = 0; i < callers.length; i++) {
296             if (callers[i] == caller) {
297                 if (i != callers.length - 1 ) {
298                     callers[i] = callers[callers.length - 1];
299                 }
300                 callers.length--;
301                 return;
302             }
303         }
304     }
305 
306     function existCaller(address caller) external view returns (bool) {
307         return _existCaller(caller);
308     }
309 
310     function getCallers() external view returns (address[]) {
311         return callers;
312     }
313 
314     function getTrustPlatform() external view returns (bytes32 name){
315         return platform.name;
316     }
317 
318     function setWeight(uint weight) onlyAdmin external {
319         require(weight > 0);
320         if (platform.weight != weight) {
321             platform.weight = weight;
322         }
323     }
324 
325     function getWeight() external view returns (uint) {
326         return platform.weight;
327     }
328 
329     function addPublicKey(address publicKey) onlyAdmin nonzeroAddress(publicKey) external {
330         address[] storage publicKeys = platform.publicKeys;
331         for (uint i; i < publicKeys.length; i++) {
332             if (publicKey == publicKeys[i]) {
333                 return;
334             }
335         }
336         publicKeys.push(publicKey);
337     }
338 
339     function deletePublicKey(address publicKey) onlyAdmin nonzeroAddress(publicKey) external {
340         address[] storage publicKeys = platform.publicKeys;
341         for (uint i = 0; i < publicKeys.length; i++) {
342             if (publicKeys[i] == publicKey) {
343                 if (i != publicKeys.length - 1 ) {
344                     publicKeys[i] = publicKeys[publicKeys.length - 1];
345                 }
346                 publicKeys.length--;
347                 return;
348             }
349         }
350     }
351 
352     function existPublicKey(address publicKey) external view returns (bool) {
353         return _existPublicKey(publicKey);
354     }
355 
356     function countOfPublicKey() external view returns (uint){
357         return platform.publicKeys.length;
358     }
359 
360     function publicKeys() external view returns (address[]){
361         return platform.publicKeys;
362     }
363 
364     function voteProposal(address fromAccount, address toAccount, uint value, string txid, bytes sig) opened external {
365         bytes32 msgHash = hashMsg(platform.name, fromAccount, admin.platformName, toAccount, value, admin.tokenSymbol, txid,admin.version);
366         address publicKey = recover(msgHash, sig);
367         require(_existPublicKey(publicKey));
368         Proposal storage proposal = platform.proposals[txid];
369         if (proposal.value == 0) {
370             proposal.fromAccount = fromAccount;
371             proposal.toAccount = toAccount;
372             proposal.value = value;
373         } else {
374             require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value);
375         }
376         changeVoters(publicKey, txid);
377     }
378 
379     function verifyProposal(address fromAccount, address toAccount, uint value, string txid) external view returns (bool, bool) {
380         Proposal storage proposal = platform.proposals[txid];
381         if (proposal.status) {
382             return (true, (proposal.voters.length >= proposal.weight));
383         }
384         if (proposal.value == 0) {
385             return (false, false);
386         }
387         require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value);
388         return (false, (proposal.voters.length >= platform.weight));
389     }
390 
391     function commitProposal(string txid) external returns (bool) {
392         require((admin.status &&_existCaller(msg.sender)) || msg.sender == admin.account);
393         require(!platform.proposals[txid].status);
394         platform.proposals[txid].status = true;
395         platform.proposals[txid].weight = platform.proposals[txid].voters.length;
396         return true;
397     }
398 
399     function getProposal(string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight){
400         fromAccount = platform.proposals[txid].fromAccount;
401         toAccount = platform.proposals[txid].toAccount;
402         value = platform.proposals[txid].value;
403         voters = platform.proposals[txid].voters;
404         status = platform.proposals[txid].status;
405         weight = platform.proposals[txid].weight;
406         return;
407     }
408 
409     function deleteProposal(string txid) onlyAdmin external {
410         delete platform.proposals[txid];
411     }
412 
413     /**
414      *   ######################
415      *  #  private function  #
416      * ######################
417      */
418 
419     function hashMsg(bytes32 fromPlatform, address fromAccount, bytes32 toPlatform, address toAccount, uint value, bytes32 tokenSymbol, string txid,string version) internal pure returns (bytes32) {
420         return sha256(bytes32ToStr(fromPlatform), ":0x", uintToStr(uint160(fromAccount), 16), ":", bytes32ToStr(toPlatform), ":0x", uintToStr(uint160(toAccount), 16), ":", uintToStr(value, 10), ":", bytes32ToStr(tokenSymbol), ":", txid, ":", version);
421     }
422 
423     function changeVoters(address publicKey, string txid) internal {
424         address[] storage voters = platform.proposals[txid].voters;
425         for (uint i = 0; i < voters.length; i++) {
426             if (voters[i] == publicKey) {
427                 return;
428             }
429         }
430         voters.push(publicKey);
431     }
432 
433     function bytes32ToStr(bytes32 b) internal pure returns (string) {
434         uint length = b.length;
435         for (uint i = 0; i < b.length; i++) {
436             if (b[b.length - 1 - i] != "") {
437                 length -= i;
438                 break;
439             }
440         }
441         bytes memory bs = new bytes(length);
442         for (uint j = 0; j < length; j++) {
443             bs[j] = b[j];
444         }
445         return string(bs);
446     }
447 
448     function uintToStr(uint value, uint base) internal pure returns (string) {
449         uint _value = value;
450         uint length = 0;
451         bytes16 tenStr = "0123456789abcdef";
452         while (true) {
453             if (_value > 0) {
454                 length ++;
455                 _value = _value / base;
456             } else {
457                 break;
458             }
459         }
460         if (base == 16) {
461             length = 40;
462         }
463         bytes memory bs = new bytes(length);
464         for (uint i = 0; i < length; i++) {
465             bs[length - 1 - i] = tenStr[value % base];
466             value = value / base;
467         }
468         return string(bs);
469     }
470 
471     function _existCaller(address caller) internal view returns (bool) {
472         for (uint i = 0; i < callers.length; i++) {
473             if (callers[i] == caller) {
474                 return true;
475             }
476         }
477         return false;
478     }
479 
480     function _existPublicKey(address publicKey) internal view returns (bool) {
481         address[] memory publicKeys = platform.publicKeys;
482         for (uint i = 0; i < publicKeys.length; i++) {
483             if (publicKeys[i] == publicKey) {
484                 return true;
485             }
486         }
487         return false;
488     }
489 
490     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
491         bytes32 r;
492         bytes32 s;
493         uint8 v;
494         assembly {
495             r := mload(add(sig, 32))
496             s := mload(add(sig, 64))
497             v := byte(0, mload(add(sig, 96)))
498         }
499         if (v < 27) {
500             v += 27;
501         }
502         return ecrecover(hash, v, r, s);
503     }
504 
505     modifier onlyAdmin {
506         require(admin.account == msg.sender);
507         _;
508     }
509 
510     modifier nonzeroAddress(address account) {
511         require(account != address(0));
512         _;
513     }
514 
515     modifier opened() {
516         require(admin.status);
517         _;
518     }
519 }