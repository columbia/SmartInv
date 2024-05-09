1 pragma solidity ^0.4.25;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2019 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * ZeroFilters - A crowd-sourced database of "malicious / suspicious" endpoints
9  *               as reported by "trusted" users within the community.
10  *
11  *               List of Currently Supported Filters*
12  *               -----------------------------------
13  *
14  *                   1. ABUSE
15  *                      - animal | animals
16  *                      - child | children
17  *                      - man | men
18  *                      - woman | women
19  *
20  *                   2. HARASSMENT
21  *                      - bullying
22  *
23  *                   3. REVENGE
24  *                      - porn
25  *
26  *                   4. TERRORISM
27  *                      - ISIS
28  *
29  *               * This is NOT a complete listing of ALL content violations.
30  *                 We are continuing to work along with the community in
31  *                 sculpting a transparent and comprehensive package of
32  *                 acceptable resource usage.
33  *
34  * Version 19.3.11
35  *
36  * https://d14na.org
37  * support@d14na.org
38  */
39 
40 
41 /*******************************************************************************
42  *
43  * ERC Token Standard #20 Interface
44  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45  */
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 /*******************************************************************************
60  *
61  * Owned contract
62  */
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     constructor() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81 
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84 
85         emit OwnershipTransferred(owner, newOwner);
86 
87         owner = newOwner;
88 
89         newOwner = address(0);
90     }
91 }
92 
93 
94 /*******************************************************************************
95  *
96  * Zer0netDb Interface
97  */
98 contract Zer0netDbInterface {
99     /* Interface getters. */
100     function getAddress(bytes32 _key) external view returns (address);
101     function getBool(bytes32 _key)    external view returns (bool);
102     function getBytes(bytes32 _key)   external view returns (bytes);
103     function getInt(bytes32 _key)     external view returns (int);
104     function getString(bytes32 _key)  external view returns (string);
105     function getUint(bytes32 _key)    external view returns (uint);
106 
107     /* Interface setters. */
108     function setAddress(bytes32 _key, address _value) external;
109     function setBool(bytes32 _key, bool _value) external;
110     function setBytes(bytes32 _key, bytes _value) external;
111     function setInt(bytes32 _key, int _value) external;
112     function setString(bytes32 _key, string _value) external;
113     function setUint(bytes32 _key, uint _value) external;
114 
115     /* Interface deletes. */
116     function deleteAddress(bytes32 _key) external;
117     function deleteBool(bytes32 _key) external;
118     function deleteBytes(bytes32 _key) external;
119     function deleteInt(bytes32 _key) external;
120     function deleteString(bytes32 _key) external;
121     function deleteUint(bytes32 _key) external;
122 }
123 
124 
125 /*******************************************************************************
126  *
127  * @notice ZeroFilters
128  *
129  * @dev A key-value store.
130  */
131 contract ZeroFilters is Owned {
132     /* Initialize predecessor contract. */
133     address private _predecessor;
134 
135     /* Initialize successor contract. */
136     address private _successor;
137 
138     /* Initialize revision number. */
139     uint private _revision;
140 
141     /* Initialize Zer0net Db contract. */
142     Zer0netDbInterface private _zer0netDb;
143 
144     /* Set namespace. */
145     string _NAMESPACE = 'zerofilters';
146 
147     event Filter(
148         bytes32 indexed dataId,
149         bytes metadata
150     );
151 
152     /***************************************************************************
153      *
154      * Constructor
155      */
156     constructor() public {
157         /* Set predecessor address. */
158         _predecessor = 0x0;
159 
160         /* Verify predecessor address. */
161         if (_predecessor != 0x0) {
162             /* Retrieve the last revision number (if available). */
163             uint lastRevision = ZeroFilters(_predecessor).getRevision();
164 
165             /* Set (current) revision number. */
166             _revision = lastRevision + 1;
167         }
168 
169         /* Initialize Zer0netDb (eternal) storage database contract. */
170         // NOTE We hard-code the address here, since it should never change.
171         _zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
172     }
173 
174     /**
175      * @dev Only allow access to an authorized Zer0net administrator.
176      */
177     modifier onlyAuthBy0Admin() {
178         /* Verify write access is only permitted to authorized accounts. */
179         require(_zer0netDb.getBool(keccak256(
180             abi.encodePacked(msg.sender, '.has.auth.for.zerofilters'))) == true);
181 
182         _;      // function code is inserted here
183     }
184 
185     /**
186      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
187      */
188     function () public payable {
189         /* Cancel this transaction. */
190         revert('Oops! Direct payments are NOT permitted here.');
191     }
192 
193 
194     /***************************************************************************
195      *
196      * ACTIONS
197      *
198      */
199 
200     /**
201      * Calculate Data Id by Hash
202      */
203     function calcIdByHash(
204         bytes32 _hash
205     ) public view returns (bytes32 dataId) {
206         /* Calculate the data id. */
207         dataId = keccak256(abi.encodePacked(
208             _NAMESPACE, '.hash.', _hash));
209     }
210 
211     /**
212      * Calculate Data Id by Hostname
213      */
214     function calcIdByHostname(
215         string _hostname
216     ) external view returns (bytes32 dataId) {
217         /* Calculate the data id. */
218         dataId = keccak256(abi.encodePacked(
219             _NAMESPACE, '.hostname.', _hostname));
220     }
221 
222     /**
223      * Calculate Data Id by Owner
224      */
225     function calcIdByOwner(
226         address _owner
227     ) external view returns (bytes32 dataId) {
228         /* Calculate the data id. */
229         dataId = keccak256(abi.encodePacked(
230             _NAMESPACE, '.owner.', _owner));
231     }
232 
233     /**
234      * Calculate Data Id by Regular Expression
235      */
236     function calcIdByRegex(
237         string _regex
238     ) external view returns (bytes32 dataId) {
239         /* Calculate the data id. */
240         dataId = keccak256(abi.encodePacked(
241             _NAMESPACE, '.regex.', _regex));
242     }
243 
244 
245     /***************************************************************************
246      *
247      * GETTERS
248      *
249      */
250 
251     /**
252      * Get Info
253      */
254     function getInfo(
255         bytes32 _dataId
256     ) external view returns (bytes info) {
257         /* Return info. */
258         return _getInfo(_dataId);
259     }
260 
261     /**
262      * Get Info by Hash
263      */
264     function getInfoByHash(
265         bytes32 _hash
266     ) external view returns (bytes info) {
267         /* Calculate the data id. */
268         bytes32 dataId = keccak256(abi.encodePacked(
269             _NAMESPACE, '.hash.', _hash));
270 
271         /* Return info. */
272         return _getInfo(dataId);
273     }
274 
275     /**
276      * Get Info by Hostname
277      */
278     function getInfoByHostname(
279         string _hostname
280     ) external view returns (bytes info) {
281         /* Calculate the data id. */
282         bytes32 dataId = keccak256(abi.encodePacked(
283             _NAMESPACE, '.hostname.', _hostname));
284 
285         /* Return info. */
286         return _getInfo(dataId);
287     }
288 
289     /**
290      * Get Info by Owner
291      */
292     function getInfoByOwner(
293         address _owner
294     ) external view returns (bytes info) {
295         /* Calculate the data id. */
296         bytes32 dataId = keccak256(abi.encodePacked(
297             _NAMESPACE, '.owner.', _owner));
298 
299         /* Return info. */
300         return _getInfo(dataId);
301     }
302 
303     /**
304      * Get Info by Regular Expression
305      */
306     function getInfoByRegex(
307         string _regex
308     ) external view returns (bytes info) {
309         /* Calculate the data id. */
310         bytes32 dataId = keccak256(abi.encodePacked(
311             _NAMESPACE, '.regex.', _regex));
312 
313         /* Return info. */
314         return _getInfo(dataId);
315     }
316 
317     /**
318      * Get Info
319      *
320      * Retrieves the JSON-formatted, byte-encoded data stored at
321      * the location of `_dataId`.
322      */
323     function _getInfo(
324         bytes32 _dataId
325     ) private view returns (bytes info) {
326         /* Retrieve info. */
327         info = _zer0netDb.getBytes(_dataId);
328     }
329 
330     /**
331      * Get Revision (Number)
332      */
333     function getRevision() public view returns (uint) {
334         return _revision;
335     }
336 
337     /**
338      * Get Predecessor (Address)
339      */
340     function getPredecessor() public view returns (address) {
341         return _predecessor;
342     }
343 
344     /**
345      * Get Successor (Address)
346      */
347     function getSuccessor() public view returns (address) {
348         return _successor;
349     }
350 
351 
352     /***************************************************************************
353      *
354      * SETTERS
355      *
356      */
357 
358     /**
359      * Set Info by Hash
360      */
361     function setInfoByHash(
362         bytes32 _hash,
363         bytes _data
364     ) onlyAuthBy0Admin external returns (bool success) {
365         /* Calculate the data id. */
366         bytes32 dataId = keccak256(abi.encodePacked(
367             _NAMESPACE, '.hash.', _hash));
368 
369         /* Set info. */
370         return _setInfo(dataId, _data);
371     }
372 
373     /**
374      * Set Info by Hostname
375      */
376     function setInfoByHostname(
377         string _hostname,
378         bytes _data
379     ) onlyAuthBy0Admin external returns (bool success) {
380         /* Calculate the data id. */
381         bytes32 dataId = keccak256(abi.encodePacked(
382             _NAMESPACE, '.hostname.', _hostname));
383 
384         /* Set info. */
385         return _setInfo(dataId, _data);
386     }
387 
388     /**
389      * Set Info by Owner
390      */
391     function setInfoByOwner(
392         address _owner,
393         bytes _data
394     ) onlyAuthBy0Admin external returns (bool success) {
395         /* Calculate the data id. */
396         bytes32 dataId = keccak256(abi.encodePacked(
397             _NAMESPACE, '.owner.', _owner));
398 
399         /* Set info. */
400         return _setInfo(dataId, _data);
401     }
402 
403     /**
404      * Set Info by Regular Expression
405      */
406     function setInfoByRegex(
407         string _regex,
408         bytes _data
409     ) onlyAuthBy0Admin external returns (bool success) {
410         /* Calculate the data id. */
411         bytes32 dataId = keccak256(abi.encodePacked(
412             _NAMESPACE, '.regex.', _regex));
413 
414         /* Set info. */
415         return _setInfo(dataId, _data);
416     }
417 
418     /**
419      * Set Info
420      *
421      * JSON-formatted data, encoded into bytes.
422      */
423     function _setInfo(
424         bytes32 _dataId,
425         bytes _data
426     ) private returns (bool success) {
427         /* Set data. */
428         _zer0netDb.setBytes(_dataId, _data);
429 
430         /* Broadcast event. */
431         emit Filter(_dataId, _data);
432 
433         /* Return success. */
434         return true;
435     }
436 
437     /**
438      * Set Successor
439      *
440      * This is the contract address that replaced this current instnace.
441      */
442     function setSuccessor(
443         address _newSuccessor
444     ) onlyAuthBy0Admin external returns (bool success) {
445         /* Set successor contract. */
446         _successor = _newSuccessor;
447 
448         /* Return success. */
449         return true;
450     }
451 
452 
453     /***************************************************************************
454      *
455      * INTERFACES
456      *
457      */
458 
459     /**
460      * Supports Interface (EIP-165)
461      *
462      * (see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md)
463      *
464      * NOTE: Must support the following conditions:
465      *       1. (true) when interfaceID is 0x01ffc9a7 (EIP165 interface)
466      *       2. (false) when interfaceID is 0xffffffff
467      *       3. (true) for any other interfaceID this contract implements
468      *       4. (false) for any other interfaceID
469      */
470     function supportsInterface(
471         bytes4 _interfaceID
472     ) external pure returns (bool) {
473         /* Initialize constants. */
474         bytes4 InvalidId = 0xffffffff;
475         bytes4 ERC165Id = 0x01ffc9a7;
476 
477         /* Validate condition #2. */
478         if (_interfaceID == InvalidId) {
479             return false;
480         }
481 
482         /* Validate condition #1. */
483         if (_interfaceID == ERC165Id) {
484             return true;
485         }
486 
487         // TODO Add additional interfaces here.
488 
489         /* Return false (for condition #4). */
490         return false;
491     }
492 
493 
494     /***************************************************************************
495      *
496      * UTILITIES
497      *
498      */
499 
500     /**
501      * Transfer Any ERC20 Token
502      *
503      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
504      *
505      * @dev Provides an ERC20 interface, which allows for the recover
506      *      of any accidentally sent ERC20 tokens.
507      */
508     function transferAnyERC20Token(
509         address _tokenAddress,
510         uint _tokens
511     ) public onlyOwner returns (bool success) {
512         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
513     }
514 }