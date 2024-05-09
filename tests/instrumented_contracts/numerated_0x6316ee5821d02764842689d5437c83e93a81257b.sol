1 pragma solidity 0.4.24;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library Address {
7     /**
8      * Returns whether the target address is a contract
9      * @dev This function will return false if invoked during the constructor of a contract,
10      * as the code is not actually created until after the constructor finishes.
11      * @param account address of the account to check
12      * @return whether the target address is a contract
13      */
14     function isContract(address account) internal view returns (bool) {
15         uint256 size;
16         // XXX Currently there is no better way to check if there is a contract in an address
17         // than to check the size of the code at that address.
18         // See https://ethereum.stackexchange.com/a/14016/36603
19         // for more details about how this works.
20         // TODO Check this again before the Serenity release, because all addresses will be
21         // contracts then.
22         // solium-disable-next-line security/no-inline-assembly
23         assembly { size := extcodesize(account) }
24         return size > 0;
25     }
26 }
27 
28 
29 
30 
31 
32 
33 
34 
35 
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     constructor () internal {
53         _owner = msg.sender;
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @return the address of the owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner());
69         _;
70     }
71 
72     /**
73      * @return true if `msg.sender` is the owner of the contract.
74      */
75     function isOwner() public view returns (bool) {
76         return msg.sender == _owner;
77     }
78 
79     /**
80      * @dev Allows the current owner to relinquish control of the contract.
81      * @notice Renouncing to ownership will leave the contract without an owner.
82      * It will not be possible to call the functions with the `onlyOwner`
83      * modifier anymore.
84      */
85     function renounceOwnership() public onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Allows the current owner to transfer control of the contract to a newOwner.
92      * @param newOwner The address to transfer ownership to.
93      */
94     function transferOwnership(address newOwner) public onlyOwner {
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers control of the contract to a newOwner.
100      * @param newOwner The address to transfer ownership to.
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0));
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 /**
119 * @dev Contract Version Manager
120 */
121 contract ContractManager is Ownable {
122 
123     event VersionAdded(
124         string contractName,
125         string versionName,
126         address indexed implementation
127     );
128 
129     event StatusChanged(
130         string contractName,
131         string versionName,
132         Status status
133     );
134 
135     event BugLevelChanged(
136         string contractName,
137         string versionName,
138         BugLevel bugLevel
139     );
140 
141     event VersionAudited(string contractName, string versionName);
142 
143     event VersionRecommended(string contractName, string versionName);
144 
145     event RecommendedVersionRemoved(string contractName);
146 
147     /**
148     * @dev Indicates the status of the version
149     */
150     enum Status {BETA, RC, PRODUCTION, DEPRECATED}
151 
152     /**
153     * @dev Indicates the highest level of bug found in this version
154     */
155     enum BugLevel{NONE, LOW, MEDIUM, HIGH, CRITICAL}
156 
157     /**
158     * @dev struct to store info about each version
159     */
160     struct Version {
161         string versionName; // ie: "0.0.1"
162         Status status;
163         BugLevel bugLevel;
164         address implementation;
165         bool audited;
166         uint256 timeAdded;
167     }
168 
169     /**
170     * @dev List of all registered contracts
171     */
172     string[] internal _contracts;
173 
174     /**
175     * @dev To keep track of which contracts have been registered so far
176     * to save gas while checking for redundant contracts
177     */
178     mapping(string => bool) internal _contractExists;
179 
180     /**
181     * @dev To keep track of all versions of a given contract
182     */
183     mapping(string => string[]) internal _contractVsVersionString;
184 
185     /**
186     * @dev Mapping of contract name & version name to version struct
187     */
188     mapping(string => mapping(string => Version)) internal _contractVsVersions;
189 
190     /**
191     * @dev Mapping between contract name and the name of its recommended
192     * version
193     */
194     mapping(string => string) internal _contractVsRecommendedVersion;
195 
196     modifier nonZeroAddress(address _address){
197         require(_address != address(0), "The provided address is a 0 address");
198         _;
199     }
200 
201     modifier contractRegistered(string contractName) {
202 
203         require(_contractExists[contractName], "Contract does not exists");
204         _;
205     }
206 
207     modifier versionExists(string contractName, string versionName) {
208         require(
209             _contractVsVersions[contractName][versionName].implementation != address(0),
210             "Version does not exists for contract"
211         );
212         _;
213     }
214 
215     /**
216     * @dev Allow owner to add a new version for a contract
217     * @param contractName The contract name
218     * @param versionName The version name
219     * @param status Status of the new version
220     * @param implementation The address of the new version
221     */
222     function addVersion(
223         string contractName,
224         string versionName,
225         Status status,
226         address implementation
227     )
228         external
229         onlyOwner
230         nonZeroAddress(implementation)
231     {
232 
233         //do not allow contract name to be the empty string
234         require(
235             bytes(contractName).length > 0,
236             "ContractName cannot be empty"
237         );
238 
239         //do not allow empty string as version name
240         require(
241             bytes(versionName).length > 0,
242             "VersionName cannot be empty"
243         );
244 
245         //implementation must be a contract address
246         require(
247             Address.isContract(implementation),
248             "Iimplementation cannot be a non-contract address"
249         );
250 
251         //version should not already exist for the contract
252         require(
253             _contractVsVersions[contractName][versionName].implementation == address(0),
254             "This Version already exists for this contract"
255         );
256 
257         //if this is a new contractName then push it to the contracts[] array
258         if (!_contractExists[contractName]) {
259             _contracts.push(contractName);
260             _contractExists[contractName] = true;
261         }
262 
263         _contractVsVersionString[contractName].push(versionName);
264 
265         _contractVsVersions[contractName][versionName] = Version({
266             versionName:versionName,
267             status:status,
268             bugLevel:BugLevel.NONE,
269             implementation:implementation,
270             audited:false,
271             timeAdded:block.timestamp
272         });
273 
274         emit VersionAdded(contractName, versionName, implementation);
275     }
276 
277     /**
278     * @dev Change the status of a version of a contract
279     * @param contractName Name of the contract
280     * @param versionName Version of the contract
281     * @param status Status to be set
282     */
283     function changeStatus(
284         string contractName,
285         string versionName,
286         Status status
287     )
288         external
289         onlyOwner
290         contractRegistered(contractName)
291         versionExists(contractName, versionName)
292     {
293         string storage recommendedVersion = _contractVsRecommendedVersion[
294             contractName
295         ];
296 
297         //if the recommended version is being marked as DEPRECATED then it will
298         //be removed from being recommended
299         if (
300             keccak256(
301                 abi.encodePacked(
302                     recommendedVersion
303                 )
304             ) == keccak256(
305                 abi.encodePacked(
306                     versionName
307                 )
308             ) && status == Status.DEPRECATED
309         )
310         {
311             removeRecommendedVersion(contractName);
312         }
313 
314         _contractVsVersions[contractName][versionName].status = status;
315 
316         emit StatusChanged(contractName, versionName, status);
317     }
318 
319     /**
320     * @dev Change the bug level for a version of a contract
321     * @param contractName Name of the contract
322     * @param versionName Version of the contract
323     * @param bugLevel New bug level for the contract
324     */
325     function changeBugLevel(
326         string contractName,
327         string versionName,
328         BugLevel bugLevel
329     )
330         external
331         onlyOwner
332         contractRegistered(contractName)
333         versionExists(contractName, versionName)
334     {
335         string storage recommendedVersion = _contractVsRecommendedVersion[
336             contractName
337         ];
338 
339         //if the recommended version of this contract is being marked as
340         // CRITICAL (status level 4) then it will no longer be marked as
341         // recommended
342         if (
343             keccak256(
344                 abi.encodePacked(
345                     recommendedVersion
346                 )
347             ) == keccak256(
348                 abi.encodePacked(
349                     versionName
350                 )
351             ) && bugLevel == BugLevel.CRITICAL
352         )
353         {
354             removeRecommendedVersion(contractName);
355         }
356 
357         _contractVsVersions[contractName][versionName].bugLevel = bugLevel;
358 
359         emit BugLevelChanged(contractName, versionName, bugLevel);
360     }
361 
362     /**
363     * @dev Mark a version of a contract as having been audited
364     * @param contractName Name of the contract
365     * @param versionName Version of the contract
366     */
367     function markVersionAudited(
368         string contractName,
369         string versionName
370     )
371         external
372         contractRegistered(contractName)
373         versionExists(contractName, versionName)
374         onlyOwner
375     {
376         //this version should not already be marked audited
377         require(
378             !_contractVsVersions[contractName][versionName].audited,
379             "Version is already audited"
380         );
381 
382         _contractVsVersions[contractName][versionName].audited = true;
383 
384         emit VersionAudited(contractName, versionName);
385     }
386 
387     /**
388     * @dev Set recommended version
389     * @param contractName Name of the contract
390     * @param versionName Version of the contract
391     * Version should be in Production stage (status 2) and bug level should
392     * not be HIGH or CRITICAL (status level should be less than 3).
393     * Version must be marked as audited
394     */
395     function markRecommendedVersion(
396         string contractName,
397         string versionName
398     )
399         external
400         onlyOwner
401         contractRegistered(contractName)
402         versionExists(contractName, versionName)
403     {
404         //version must be in PRODUCTION state (status 2)
405         require(
406             _contractVsVersions[contractName][versionName].status == Status.PRODUCTION,
407             "Version is not in PRODUCTION state (status level should be 2)"
408         );
409 
410         //check version must be audited
411         require(
412             _contractVsVersions[contractName][versionName].audited,
413             "Version is not audited"
414         );
415 
416         //version must have bug level lower than HIGH
417         require(
418             _contractVsVersions[contractName][versionName].bugLevel < BugLevel.HIGH,
419             "Version bug level is HIGH or CRITICAL (bugLevel should be < 3)"
420         );
421 
422         //mark new version as recommended version for the contract
423         _contractVsRecommendedVersion[contractName] = versionName;
424 
425         emit VersionRecommended(contractName, versionName);
426     }
427 
428     /**
429     * @dev Get the version of the recommended version for a contract.
430     * @return Details of recommended version
431     */
432     function getRecommendedVersion(
433         string contractName
434     )
435         external
436         view
437         contractRegistered(contractName)
438         returns (
439             string versionName,
440             Status status,
441             BugLevel bugLevel,
442             address implementation,
443             bool audited,
444             uint256 timeAdded
445         )
446     {
447         versionName = _contractVsRecommendedVersion[contractName];
448 
449         Version storage recommendedVersion = _contractVsVersions[
450             contractName
451         ][
452             versionName
453         ];
454 
455         status = recommendedVersion.status;
456         bugLevel = recommendedVersion.bugLevel;
457         implementation = recommendedVersion.implementation;
458         audited = recommendedVersion.audited;
459         timeAdded = recommendedVersion.timeAdded;
460 
461         return (
462             versionName,
463             status,
464             bugLevel,
465             implementation,
466             audited,
467             timeAdded
468         );
469     }
470 
471     /**
472     * @dev Get the total number of contracts registered
473     */
474     function getTotalContractCount() external view returns (uint256 count) {
475         count = _contracts.length;
476         return count;
477     }
478 
479     /**
480     * @dev Get total count of versions for a contract
481     * @param contractName Name of the contract
482     */
483     function getVersionCountForContract(string contractName)
484         external
485         view
486         returns (uint256 count)
487     {
488         count = _contractVsVersionString[contractName].length;
489         return count;
490     }
491 
492     /**
493     * @dev Returns the contract at index
494     * @param index The index to be searched for
495     */
496     function getContractAtIndex(uint256 index)
497         external
498         view
499         returns (string contractName)
500     {
501         contractName = _contracts[index];
502         return contractName;
503     }
504 
505     /**
506     * @dev Returns versionName of a contract at a specific index
507     * @param contractName Name of the contract
508     * @param index The index to be searched for
509     */
510     function getVersionAtIndex(string contractName, uint256 index)
511         external
512         view
513         returns (string versionName)
514     {
515         versionName = _contractVsVersionString[contractName][index];
516         return versionName;
517     }
518 
519     /**
520     * @dev Returns the version details for the given contract and version
521     * @param contractName Name of the contract
522     * @param versionName Version string for the contract
523     */
524     function getVersionDetails(string contractName, string versionName)
525         external
526         view
527         returns (
528             string versionString,
529             Status status,
530             BugLevel bugLevel,
531             address implementation,
532             bool audited,
533             uint256 timeAdded
534         )
535     {
536         Version storage v = _contractVsVersions[contractName][versionName];
537 
538         versionString = v.versionName;
539         status = v.status;
540         bugLevel = v.bugLevel;
541         implementation = v.implementation;
542         audited = v.audited;
543         timeAdded = v.timeAdded;
544 
545         return (
546             versionString,
547             status,
548             bugLevel,
549             implementation,
550             audited,
551             timeAdded
552         );
553     }
554 
555     /**
556     * @dev Remove the "recommended" status of the currently recommended version
557     * of a contract (if any)
558     * @param contractName Name of the contract
559     */
560     function removeRecommendedVersion(string contractName)
561         public
562         onlyOwner
563         contractRegistered(contractName)
564     {
565         //delete it from mapping
566         delete _contractVsRecommendedVersion[contractName];
567 
568         emit RecommendedVersionRemoved(contractName);
569     }
570 }