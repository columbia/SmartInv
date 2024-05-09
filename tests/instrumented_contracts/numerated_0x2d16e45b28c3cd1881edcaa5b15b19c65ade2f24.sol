1 pragma solidity ^0.5.2;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 contract PauserRole {
47     using Roles for Roles.Role;
48 
49     event PauserAdded(address indexed account);
50     event PauserRemoved(address indexed account);
51 
52     Roles.Role private _pausers;
53 
54     constructor () internal {
55         _addPauser(msg.sender);
56     }
57 
58     modifier onlyPauser() {
59         require(isPauser(msg.sender));
60         _;
61     }
62 
63     function isPauser(address account) public view returns (bool) {
64         return _pausers.has(account);
65     }
66 
67     function addPauser(address account) public onlyPauser {
68         _addPauser(account);
69     }
70 
71     function renouncePauser() public {
72         _removePauser(msg.sender);
73     }
74 
75     function _addPauser(address account) internal {
76         _pausers.add(account);
77         emit PauserAdded(account);
78     }
79 
80     function _removePauser(address account) internal {
81         _pausers.remove(account);
82         emit PauserRemoved(account);
83     }
84 }
85 
86 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is PauserRole {
93     event Paused(address account);
94     event Unpaused(address account);
95 
96     bool private _paused;
97 
98     constructor () internal {
99         _paused = false;
100     }
101 
102     /**
103      * @return true if the contract is paused, false otherwise.
104      */
105     function paused() public view returns (bool) {
106         return _paused;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is not paused.
111      */
112     modifier whenNotPaused() {
113         require(!_paused);
114         _;
115     }
116 
117     /**
118      * @dev Modifier to make a function callable only when the contract is paused.
119      */
120     modifier whenPaused() {
121         require(_paused);
122         _;
123     }
124 
125     /**
126      * @dev called by the owner to pause, triggers stopped state
127      */
128     function pause() public onlyPauser whenNotPaused {
129         _paused = true;
130         emit Paused(msg.sender);
131     }
132 
133     /**
134      * @dev called by the owner to unpause, returns to normal state
135      */
136     function unpause() public onlyPauser whenPaused {
137         _paused = false;
138         emit Unpaused(msg.sender);
139     }
140 }
141 
142 // File: contracts/Adminable.sol
143 
144 contract Adminable {
145     using Roles for Roles.Role;
146 
147     event AdminAdded(address indexed account);
148     event AdminRemoved(address indexed account);
149 
150     Roles.Role private _admins;
151 
152     constructor () internal {
153         _addAdmin(msg.sender);
154     }
155 
156     modifier onlyAdmin() {
157         require(isAdmin(msg.sender));
158         _;
159     }
160 
161     function isAdmin(address account) public view returns (bool) {
162         return _admins.has(account);
163     }
164 
165     function addAdmin(address account) public onlyAdmin {
166         _addAdmin(account);
167     }
168 
169     function renounceAdmin() public {
170         _removeAdmin(msg.sender);
171     }
172 
173     function _addAdmin(address account) internal {
174         _admins.add(account);
175         emit AdminAdded(account);
176     }
177 
178     function _removeAdmin(address account) internal {
179         _admins.remove(account);
180         emit AdminRemoved(account);
181     }
182 }
183 
184 // File: contracts/Authorizable.sol
185 
186 contract Authorizable is Adminable {
187 
188     address public authorizedAddress;
189     
190     modifier onlyAuthorized() {
191         require(msg.sender == authorizedAddress);
192         _;
193     }
194 
195     function updateAuthorizedAddress(address _address) onlyAdmin public {
196         authorizedAddress = _address;
197     }
198 
199 }
200 
201 // File: contracts/SoarStorage.sol
202 
203 /**
204     @title Soar Storage
205     @author Marek Tlacbaba (marek@soar.earth)
206     @dev This smart contract behave as simple storage and can be 
207     accessed only by authorized caller who is responsible for any
208     checks and validation. The authorized caller can updated by 
209     admins so it allows to update application logic 
210     and keeping data and events untouched.
211 */
212 
213 //TODO
214 // use safeMath
215 contract SoarStorage is Authorizable {
216 
217     /**
218     Status: 
219         0 - unknown
220         1 - created
221         2 - updated
222         3 - deleted
223     */
224     struct ListingObject {
225         address owner;
226         address sponsor;
227         bytes12 geohash;
228         mapping (address => mapping (bytes32 => uint )) sales;
229         uint256 salesCount;
230         uint8 status;
231     }
232 
233     uint public counter = 0;
234     mapping (bytes32 => ListingObject) internal listings;
235 
236     event Listing (
237         bytes32 filehash,
238         address indexed owner,
239         address indexed sponsor,
240         string previewUrl, 
241         string url, 
242         string pointWKT,
243         bytes12 geohash, 
244         string metadata
245     );
246 
247     event ListingUpdated (
248         bytes32 filehash,
249         address indexed owner, 
250         address indexed sponsor,
251         string previewUrl, 
252         string url, 
253         string pointWKT,
254         bytes12 geohash, 
255         string metadata 
256     );
257 
258     event ListingDeleted (
259         bytes32 filehash,
260         address indexed owner,
261         address indexed sponsor
262     );
263 
264     event Sale(
265         address indexed buyer, 
266         bytes32 id, 
267         address indexed owner, 
268         address sponsor,
269         bytes32 indexed filehash,
270         uint price 
271     );
272 
273     function putListing (
274         bytes32 _filehash,
275         address _owner,
276         address _sponsor,
277         string memory _previewUrl, 
278         string memory _url, 
279         string memory _pointWKT, 
280         bytes12 _geohash, 
281         string memory _metadata
282     ) 
283         public 
284         onlyAuthorized 
285     {
286         listings[_filehash].owner = _owner;
287         listings[_filehash].sponsor = _sponsor;
288         listings[_filehash].geohash = _geohash;
289         listings[_filehash].status = 1;
290         counter++;
291         emit Listing(
292             _filehash, 
293             _owner,
294             _sponsor, 
295             _previewUrl, 
296             _url, 
297             _pointWKT, 
298             _geohash, 
299             _metadata
300         );
301     }
302 
303     function updateListing (
304         bytes32 _filehash,
305         address _owner,
306         address _sponsor,
307         string memory _previewUrl, 
308         string memory _url, 
309         string memory _pointWKT, 
310         bytes12 _geohash, 
311         string memory _metadata 
312     ) 
313         public 
314         onlyAuthorized 
315     {
316         listings[_filehash].geohash = _geohash;
317         listings[_filehash].status = 2;
318         emit ListingUpdated(
319             _filehash, 
320             _owner,
321             _sponsor, 
322             _previewUrl, 
323             _url, 
324             _pointWKT, 
325             _geohash, 
326             _metadata
327         );
328     }
329 
330     function deleteListing(
331         bytes32 _filehash 
332     )
333         public 
334         onlyAuthorized 
335     {
336         listings[_filehash].status = 3;
337         counter--;
338         emit ListingDeleted(_filehash, listings[_filehash].owner, listings[_filehash].sponsor);
339     }
340 
341     function putSale (
342         address _buyer,
343         bytes32 _id,
344         bytes32 _filehash, 
345         uint256 _price
346     ) 
347         public 
348         onlyAuthorized 
349     {
350         listings[_filehash].sales[_buyer][_id] = _price;
351         listings[_filehash].salesCount++;
352         emit Sale(_buyer, _id, listings[_filehash].owner, listings[_filehash].sponsor, _filehash, _price);
353     }
354 
355     function getListingDetails(bytes32 _filehash, address _user, bytes32 _id) 
356         public view
357         returns (
358             address owner_,
359             address sponsor_,
360             bytes12 geohash_,
361             uint8 status_,
362             uint256 sale_
363         )
364     {
365         owner_ = listings[_filehash].owner;
366         sponsor_ = listings[_filehash].sponsor;
367         geohash_ = listings[_filehash].geohash;
368         status_ = listings[_filehash].status;
369         sale_ = listings[_filehash].sales[_user][_id];
370     }
371 }
372 
373 // File: contracts/Soar.sol
374 
375 /**
376     @title Soar
377     @author Marek Tlacbaba (marek@soar.earth)
378     @dev Main Soar smart contract with bussiness logic composing
379     all other parts together and it is by design upgradable. When all
380     development is finished then all admins can be removed and no more 
381     upgrade will be allowed.
382 */
383  
384 contract Soar is Pausable, Adminable {
385 
386     // attributes
387     address public soarStorageAddress;
388 
389     // contracts
390     SoarStorage private soarStorageContract;
391 
392     bytes32 private emptyUserId = "00000000000000000000000000000000";
393     address private emptySponsor = address(0);
394 
395     mapping (address => mapping ( address => bool)) private sponsors;
396 
397     event SponsorAdminAdded(address indexed sponsor, address admin);
398     event SponsorAdminRemoved(address indexed sponsor, address admin);
399 
400     modifier listingExistAndNotDeleted(bytes32 _filehash) {
401         (,,,uint8 status,) = soarStorageContract.getListingDetails(_filehash, msg.sender, emptyUserId);
402         require(status == 1 || status == 2, "Listing must exist and not be deleted");
403         _;
404     }
405 
406     modifier listingNotExistOrDeleted(bytes32 _filehash) {
407         (,,,uint8 status,) = soarStorageContract.getListingDetails(_filehash, msg.sender, emptyUserId);
408         require(status == 0 || status == 3, "Listing can not exist or must be deleted");
409         _;
410     }
411 
412     modifier onlySponsor(address _sponsor) {
413         require(sponsors[_sponsor][msg.sender] == true, "Only sponsor");
414         _;
415     }
416 
417     modifier onlySponsorListingOwner(bytes32 _filehash, address _sponsor) {
418         require(sponsors[_sponsor][msg.sender] == true, "Only sponsor");
419         (,address sponsor,,uint8 status,) = soarStorageContract.getListingDetails(_filehash, msg.sender, emptyUserId);
420         require(status == 1 || status == 2, "Listing must exist and not be deleted");
421         require(sponsor == _sponsor, "Incorrect sponsor");
422         _;
423     }
424     
425     constructor() public {}
426 
427     /**
428         @dev Create listing as sponsor and put it in storage.
429     */
430     function sponsorCreateListing(
431         address _sponsor,
432         address _owner,
433         bytes32 _filehash,
434         string memory _previewUrl, 
435         string memory _url, 
436         string memory _pointWKT, 
437         bytes12 _geohash, 
438         string memory _metadata) 
439         public
440         whenNotPaused
441         listingNotExistOrDeleted(_filehash)
442         onlySponsor(_sponsor)
443     {
444         soarStorageContract.putListing(_filehash, _owner, _sponsor, _previewUrl, _url, _pointWKT, _geohash, _metadata);
445     }
446 
447     /**
448         @dev Update listing as sponsor in storage.
449     */
450     function sponsorUpdateListing(
451         address _sponsor,
452         address _owner,
453         bytes32 _filehash,
454         string memory _previewUrl, 
455         string memory _url, 
456         string memory _pointWKT, 
457         bytes12 _geohash, 
458         string memory _metadata) 
459         public
460         whenNotPaused
461         onlySponsorListingOwner(_filehash, _sponsor)
462     {
463         soarStorageContract.updateListing(_filehash, _owner, _sponsor, _previewUrl, _url, _pointWKT, _geohash, _metadata);
464     }
465 
466     /**
467         @dev Delete listing as sponsor in storage.
468     */
469     function sponsorDeleteListing(
470         address _sponsor,
471         bytes32 _filehash) 
472         public
473         whenNotPaused
474         onlySponsorListingOwner(_filehash, _sponsor)
475     {
476         soarStorageContract.deleteListing(_filehash);
477     }
478 
479     function listingExist(bytes32 _filehash) 
480         public view
481         whenNotPaused  
482         returns (bool exists_) 
483     {
484         (,,,uint8 status,) = soarStorageContract.getListingDetails(_filehash, msg.sender, emptyUserId);
485         exists_ = (status == 1 || status == 2);
486     }
487 
488     /**
489     ADMIN FUNCTIONS
490      */
491 
492     function addSponsorAdmin(address _sponsor, address _admin) 
493         public 
494         whenNotPaused
495         onlyAdmin 
496     {
497         sponsors[_sponsor][_admin] = true;
498         emit SponsorAdminAdded(_sponsor, _admin);
499     }
500 
501     function removeSponsorAdmin(address _sponsor, address _admin) 
502         public
503         whenNotPaused
504         onlyAdmin 
505     {
506         sponsors[_sponsor][_admin] = false;
507         emit SponsorAdminRemoved(_sponsor, _admin);
508     }
509 
510     function isSponsorAdmin(address _sponsor) 
511         public view
512         returns (bool isSponsorAdmin_)
513     {
514         isSponsorAdmin_ = sponsors[_sponsor][msg.sender] == true;
515     }
516 
517     function setSoarStorageContract(address _address) 
518         public
519         whenNotPaused 
520         onlyAdmin 
521     {
522         soarStorageContract = SoarStorage(_address);
523         soarStorageAddress = _address;
524     }
525 
526 }