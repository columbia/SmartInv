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
117 /**
118 * @dev Contract Version Manager for non-upgradeable contracts
119 */
120 contract ContractManager is Ownable {
121 
122     event VersionAdded(
123         string contractName,
124         string versionName,
125         address indexed implementation
126     );
127 
128     event VersionUpdated(
129         string contractName,
130         string versionName,
131         Status status,
132         BugLevel bugLevel
133     );
134 
135     event VersionRecommended(string contractName, string versionName);
136 
137     event RecommendedVersionRemoved(string contractName);
138 
139     /**
140     * @dev Signifies the status of a version
141     */
142     enum Status {BETA, RC, PRODUCTION, DEPRECATED}
143 
144     /**
145     * @dev Indicated the highest level of bug found in the version
146     */
147     enum BugLevel {NONE, LOW, MEDIUM, HIGH, CRITICAL}
148 
149     /**
150     * @dev A struct to encode version details
151     */
152     struct Version {
153         // the version number string ex. "v1.0"
154         string versionName;
155 
156         Status status;
157 
158         BugLevel bugLevel;
159         // the address of the instantiation of the version
160         address implementation;
161         // the date when this version was registered with the contract
162         uint256 dateAdded;
163     }
164 
165     /**
166     * @dev List of all contracts registered (append-only)
167     */
168     string[] internal contracts;
169 
170     /**
171     * @dev Mapping to keep track which contract names have been registered.
172     * Used to save gas when checking for redundant contract names
173     */
174     mapping(string=>bool) internal contractExists;
175 
176     /**
177     * @dev Mapping to keep track of all version names for easch contract name
178     */
179     mapping(string=>string[]) internal contractVsVersionString;
180 
181     /**
182     * @dev Mapping from contract names to version names to version structs
183     */
184     mapping(string=>mapping(string=>Version)) internal contractVsVersions;
185 
186     /**
187     * @dev Mapping from contract names to the version names of their
188     * recommended versions
189     */
190     mapping(string=>string) internal contractVsRecommendedVersion;
191 
192     modifier nonZeroAddress(address _address) {
193         require(
194             _address != address(0),
195             "The provided address is the 0 address"
196         );
197         _;
198     }
199 
200     modifier contractRegistered(string contractName) {
201 
202         require(contractExists[contractName], "Contract does not exists");
203         _;
204     }
205 
206     modifier versionExists(string contractName, string versionName) {
207         require(
208             contractVsVersions[contractName][versionName].implementation != address(0),
209             "Version does not exists for contract"
210         );
211         _;
212     }
213 
214     /**
215     * @dev Allows owner to register a new version of a contract
216     * @param contractName The contract name of the contract to be added
217     * @param versionName The name of the version to be added
218     * @param status Status of the version to be added
219     * @param implementation The address of the implementation of the version
220     */
221     function addVersion(
222         string contractName,
223         string versionName,
224         Status status,
225         address implementation
226     )
227         external
228         onlyOwner
229         nonZeroAddress(implementation)
230     {
231         // version name must not be the empty string
232         require(bytes(versionName).length>0, "Empty string passed as version");
233 
234         // contract name must not be the empty string
235         require(
236             bytes(contractName).length>0,
237             "Empty string passed as contract name"
238         );
239 
240         // implementation must be a contract
241         require(
242             Address.isContract(implementation),
243             "Cannot set an implementation to a non-contract address"
244         );
245 
246         if (!contractExists[contractName]) {
247             contracts.push(contractName);
248             contractExists[contractName] = true;
249         }
250 
251         // the version name should not already be registered for
252         // the given contract
253         require(
254             contractVsVersions[contractName][versionName].implementation == address(0),
255             "Version already exists for contract"
256         );
257         contractVsVersionString[contractName].push(versionName);
258 
259         contractVsVersions[contractName][versionName] = Version({
260             versionName:versionName,
261             status:status,
262             bugLevel:BugLevel.NONE,
263             implementation:implementation,
264             dateAdded:block.timestamp
265         });
266 
267         emit VersionAdded(contractName, versionName, implementation);
268     }
269 
270     /**
271     * @dev Allows owner to update a contract version
272     * @param contractName Name of the contract
273     * @param versionName Version of the contract
274     * @param status Status of the contract
275     * @param bugLevel New bug level for the contract
276     */
277     function updateVersion(
278         string contractName,
279         string versionName,
280         Status status,
281         BugLevel bugLevel
282     )
283         external
284         onlyOwner
285         contractRegistered(contractName)
286         versionExists(contractName, versionName)
287     {
288 
289         contractVsVersions[contractName][versionName].status = status;
290         contractVsVersions[contractName][versionName].bugLevel = bugLevel;
291 
292         emit VersionUpdated(
293             contractName,
294             versionName,
295             status,
296             bugLevel
297         );
298     }
299 
300     /**
301     * @dev Allows owner to set the recommended version
302     * @param contractName Name of the contract
303     * @param versionName Version of the contract
304     */
305     function markRecommendedVersion(
306         string contractName,
307         string versionName
308     )
309         external
310         onlyOwner
311         contractRegistered(contractName)
312         versionExists(contractName, versionName)
313     {
314         // set the version name as the recommended version
315         contractVsRecommendedVersion[contractName] = versionName;
316 
317         emit VersionRecommended(contractName, versionName);
318     }
319 
320     /**
321     * @dev Get recommended version for the contract.
322     * @return Details of recommended version
323     */
324     function getRecommendedVersion(
325         string contractName
326     )
327         external
328         view
329         contractRegistered(contractName)
330         returns (
331             string versionName,
332             Status status,
333             BugLevel bugLevel,
334             address implementation,
335             uint256 dateAdded
336         )
337     {
338         versionName = contractVsRecommendedVersion[contractName];
339 
340         Version storage recommendedVersion = contractVsVersions[
341             contractName
342         ][
343             versionName
344         ];
345 
346         status = recommendedVersion.status;
347         bugLevel = recommendedVersion.bugLevel;
348         implementation = recommendedVersion.implementation;
349         dateAdded = recommendedVersion.dateAdded;
350 
351         return (
352             versionName,
353             status,
354             bugLevel,
355             implementation,
356             dateAdded
357         );
358     }
359 
360     /**
361     * @dev Allows owner to remove a version from being recommended
362     * @param contractName Name of the contract
363     */
364     function removeRecommendedVersion(string contractName)
365         external
366         onlyOwner
367         contractRegistered(contractName)
368     {
369         // delete the recommended version name from the mapping
370         delete contractVsRecommendedVersion[contractName];
371 
372         emit RecommendedVersionRemoved(contractName);
373     }
374 
375     /**
376     * @dev Get total count of contracts registered
377     */
378     function getTotalContractCount() external view returns (uint256 count) {
379         count = contracts.length;
380         return count;
381     }
382 
383     /**
384     * @dev Get total count of versions for the contract
385     * @param contractName Name of the contract
386     */
387     function getVersionCountForContract(string contractName)
388         external
389         view
390         returns (uint256 count)
391     {
392         count = contractVsVersionString[contractName].length;
393         return count;
394     }
395 
396     /**
397     * @dev Returns the contract at a given index in the contracts array
398     * @param index The index to be searched for
399     */
400     function getContractAtIndex(uint256 index)
401         external
402         view
403         returns (string contractName)
404     {
405         contractName = contracts[index];
406         return contractName;
407     }
408 
409     /**
410     * @dev Returns the version name of a contract at specific index in a
411     * contractVsVersionString[contractName] array
412     * @param contractName Name of the contract
413     * @param index The index to be searched for
414     */
415     function getVersionAtIndex(string contractName, uint256 index)
416         external
417         view
418         returns (string versionName)
419     {
420         versionName = contractVsVersionString[contractName][index];
421         return versionName;
422     }
423 
424     /**
425     * @dev Returns the version details for the given contract and version name
426     * @param contractName Name of the contract
427     * @param versionName Version string for the contract
428     */
429     function getVersionDetails(string contractName, string versionName)
430         external
431         view
432         returns (
433             string versionString,
434             Status status,
435             BugLevel bugLevel,
436             address implementation,
437             uint256 dateAdded
438         )
439     {
440         Version storage v = contractVsVersions[contractName][versionName];
441 
442         versionString = v.versionName;
443         status = v.status;
444         bugLevel = v.bugLevel;
445         implementation = v.implementation;
446         dateAdded = v.dateAdded;
447 
448         return (
449             versionString,
450             status,
451             bugLevel,
452             implementation,
453             dateAdded
454         );
455     }
456 }