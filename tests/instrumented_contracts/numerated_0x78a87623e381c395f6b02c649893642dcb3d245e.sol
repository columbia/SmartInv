1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions". This adds two-phase
7  * ownership control to OpenZeppelin's Ownable class. In this model, the original owner 
8  * designates a new owner but does not actually transfer ownership. The new owner then accepts 
9  * ownership and completes the transfer.
10  */
11 contract Ownable {
12   address public owner;
13   address public pendingOwner;
14 
15 
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28     pendingOwner = address(0);
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyPendingOwner() {
43     require(msg.sender == pendingOwner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     require(_newOwner != address(0));
53     pendingOwner = _newOwner;
54   }
55 
56   /**
57    * @dev Allows the pendingOwner address to finalize the transfer.
58    */
59   function claimOwnership() onlyPendingOwner public {
60     emit OwnershipTransferred(owner, pendingOwner);
61     owner = pendingOwner;
62     pendingOwner = address(0);
63   }
64 
65 
66 }
67 
68 /**
69 *
70 * @dev Stores permissions and validators and provides setter and getter methods. 
71 * Permissions determine which methods users have access to call. Validators
72 * are able to mutate permissions at the Regulator level.
73 *
74 */
75 contract RegulatorStorage is Ownable {
76     
77     /** 
78         Structs 
79     */
80 
81     /* Contains metadata about a permission to execute a particular method signature. */
82     struct Permission {
83         string name; // A one-word description for the permission. e.g. "canMint"
84         string description; // A longer description for the permission. e.g. "Allows user to mint tokens."
85         string contract_name; // e.g. "PermissionedToken"
86         bool active; // Permissions can be turned on or off by regulator
87     }
88 
89     /** 
90         Constants: stores method signatures. These are potential permissions that a user can have, 
91         and each permission gives the user the ability to call the associated PermissionedToken method signature
92     */
93     bytes4 public constant MINT_SIG = bytes4(keccak256("mint(address,uint256)"));
94     bytes4 public constant MINT_CUSD_SIG = bytes4(keccak256("mintCUSD(address,uint256)"));
95     bytes4 public constant CONVERT_WT_SIG = bytes4(keccak256("convertWT(uint256)"));
96     bytes4 public constant BURN_SIG = bytes4(keccak256("burn(uint256)"));
97     bytes4 public constant CONVERT_CARBON_DOLLAR_SIG = bytes4(keccak256("convertCarbonDollar(address,uint256)"));
98     bytes4 public constant BURN_CARBON_DOLLAR_SIG = bytes4(keccak256("burnCarbonDollar(address,uint256)"));
99     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
100     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
101     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
102 
103     /** 
104         Mappings 
105     */
106 
107     /* each method signature maps to a Permission */
108     mapping (bytes4 => Permission) public permissions;
109     /* list of validators, either active or inactive */
110     mapping (address => bool) public validators;
111     /* each user can be given access to a given method signature */
112     mapping (address => mapping (bytes4 => bool)) public userPermissions;
113 
114     /** 
115         Events 
116     */
117     event PermissionAdded(bytes4 methodsignature);
118     event PermissionRemoved(bytes4 methodsignature);
119     event ValidatorAdded(address indexed validator);
120     event ValidatorRemoved(address indexed validator);
121 
122     /** 
123         Modifiers 
124     */
125     /**
126     * @notice Throws if called by any account that does not have access to set attributes
127     */
128     modifier onlyValidator() {
129         require (isValidator(msg.sender), "Sender must be validator");
130         _;
131     }
132 
133     /**
134     * @notice Sets a permission within the list of permissions.
135     * @param _methodsignature Signature of the method that this permission controls.
136     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
137     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
138     * @param _contractName Name of the contract that the method belongs to.
139     */
140     function addPermission(
141         bytes4 _methodsignature, 
142         string _permissionName, 
143         string _permissionDescription, 
144         string _contractName) public onlyValidator { 
145         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
146         permissions[_methodsignature] = p;
147         emit PermissionAdded(_methodsignature);
148     }
149 
150     /**
151     * @notice Removes a permission the list of permissions.
152     * @param _methodsignature Signature of the method that this permission controls.
153     */
154     function removePermission(bytes4 _methodsignature) public onlyValidator {
155         permissions[_methodsignature].active = false;
156         emit PermissionRemoved(_methodsignature);
157     }
158     
159     /**
160     * @notice Sets a permission in the list of permissions that a user has.
161     * @param _methodsignature Signature of the method that this permission controls.
162     */
163     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
164         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
165         userPermissions[_who][_methodsignature] = true;
166     }
167 
168     /**
169     * @notice Removes a permission from the list of permissions that a user has.
170     * @param _methodsignature Signature of the method that this permission controls.
171     */
172     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
173         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
174         userPermissions[_who][_methodsignature] = false;
175     }
176 
177     /**
178     * @notice add a Validator
179     * @param _validator Address of validator to add
180     */
181     function addValidator(address _validator) public onlyOwner {
182         validators[_validator] = true;
183         emit ValidatorAdded(_validator);
184     }
185 
186     /**
187     * @notice remove a Validator
188     * @param _validator Address of validator to remove
189     */
190     function removeValidator(address _validator) public onlyOwner {
191         validators[_validator] = false;
192         emit ValidatorRemoved(_validator);
193     }
194 
195     /**
196     * @notice does validator exist?
197     * @return true if yes, false if no
198     **/
199     function isValidator(address _validator) public view returns (bool) {
200         return validators[_validator];
201     }
202 
203     /**
204     * @notice does permission exist?
205     * @return true if yes, false if no
206     **/
207     function isPermission(bytes4 _methodsignature) public view returns (bool) {
208         return permissions[_methodsignature].active;
209     }
210 
211     /**
212     * @notice get Permission structure
213     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
214     * @return Permission
215     **/
216     function getPermission(bytes4 _methodsignature) public view returns 
217         (string name, 
218          string description, 
219          string contract_name,
220          bool active) {
221         return (permissions[_methodsignature].name,
222                 permissions[_methodsignature].description,
223                 permissions[_methodsignature].contract_name,
224                 permissions[_methodsignature].active);
225     }
226 
227     /**
228     * @notice does permission exist?
229     * @return true if yes, false if no
230     **/
231     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
232         return userPermissions[_who][_methodsignature];
233     }
234 }
235 
236 /**
237  * @title Regulator
238  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
239  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
240  * makes compliant transfers possible. Contains the userPermissions necessary
241  * for regulatory compliance.
242  *
243  */
244 contract Regulator is RegulatorStorage {
245     
246     /** 
247         Modifiers 
248     */
249     /**
250     * @notice Throws if called by any account that does not have access to set attributes
251     */
252     modifier onlyValidator() {
253         require (isValidator(msg.sender), "Sender must be validator");
254         _;
255     }
256 
257     /** 
258         Events 
259     */
260     event LogWhitelistedUser(address indexed who);
261     event LogBlacklistedUser(address indexed who);
262     event LogNonlistedUser(address indexed who);
263     event LogSetMinter(address indexed who);
264     event LogRemovedMinter(address indexed who);
265     event LogSetBlacklistDestroyer(address indexed who);
266     event LogRemovedBlacklistDestroyer(address indexed who);
267     event LogSetBlacklistSpender(address indexed who);
268     event LogRemovedBlacklistSpender(address indexed who);
269 
270     /**
271     * @notice Sets the necessary permissions for a user to mint tokens.
272     * @param _who The address of the account that we are setting permissions for.
273     */
274     function setMinter(address _who) public onlyValidator {
275         _setMinter(_who);
276     }
277 
278     /**
279     * @notice Removes the necessary permissions for a user to mint tokens.
280     * @param _who The address of the account that we are removing permissions for.
281     */
282     function removeMinter(address _who) public onlyValidator {
283         _removeMinter(_who);
284     }
285 
286     /**
287     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
288     * @param _who The address of the account that we are setting permissions for.
289     */
290     function setBlacklistSpender(address _who) public onlyValidator {
291         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
292         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
293         emit LogSetBlacklistSpender(_who);
294     }
295     
296     /**
297     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
298     * @param _who The address of the account that we are removing permissions for.
299     */
300     function removeBlacklistSpender(address _who) public onlyValidator {
301         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
302         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
303         emit LogRemovedBlacklistSpender(_who);
304     }
305 
306     /**
307     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
308     * @param _who The address of the account that we are setting permissions for.
309     */
310     function setBlacklistDestroyer(address _who) public onlyValidator {
311         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
312         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
313         emit LogSetBlacklistDestroyer(_who);
314     }
315     
316 
317     /**
318     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
319     * @param _who The address of the account that we are removing permissions for.
320     */
321     function removeBlacklistDestroyer(address _who) public onlyValidator {
322         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
323         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
324         emit LogRemovedBlacklistDestroyer(_who);
325     }
326 
327     /**
328     * @notice Sets the necessary permissions for a "whitelisted" user.
329     * @param _who The address of the account that we are setting permissions for.
330     */
331     function setWhitelistedUser(address _who) public onlyValidator {
332         _setWhitelistedUser(_who);
333     }
334 
335     /**
336     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
337     * frozen; they cannot transfer, burn, or withdraw any tokens.
338     * @param _who The address of the account that we are setting permissions for.
339     */
340     function setBlacklistedUser(address _who) public onlyValidator {
341         _setBlacklistedUser(_who);
342     }
343 
344     /**
345     * @notice Sets the necessary permissions for a "nonlisted" user. Nonlisted users can trade tokens,
346     * but cannot burn them (and therefore cannot convert them into fiat.)
347     * @param _who The address of the account that we are setting permissions for.
348     */
349     function setNonlistedUser(address _who) public onlyValidator {
350         _setNonlistedUser(_who);
351     }
352 
353     /** Returns whether or not a user is whitelisted.
354      * @param _who The address of the account in question.
355      * @return `true` if the user is whitelisted, `false` otherwise.
356      */
357     function isWhitelistedUser(address _who) public view returns (bool) {
358         return (hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
359     }
360 
361     /** Returns whether or not a user is blacklisted.
362      * @param _who The address of the account in question.
363      * @return `true` if the user is blacklisted, `false` otherwise.
364      */
365     function isBlacklistedUser(address _who) public view returns (bool) {
366         return (!hasUserPermission(_who, BURN_SIG) && hasUserPermission(_who, BLACKLISTED_SIG));
367     }
368 
369     /** Returns whether or not a user is nonlisted.
370      * @param _who The address of the account in question.
371      * @return `true` if the user is nonlisted, `false` otherwise.
372      */
373     function isNonlistedUser(address _who) public view returns (bool) {
374         return (!hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
375     }
376 
377     /** Returns whether or not a user is a blacklist spender.
378      * @param _who The address of the account in question.
379      * @return `true` if the user is a blacklist spender, `false` otherwise.
380      */
381     function isBlacklistSpender(address _who) public view returns (bool) {
382         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
383     }
384 
385     /** Returns whether or not a user is a blacklist destroyer.
386      * @param _who The address of the account in question.
387      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
388      */
389     function isBlacklistDestroyer(address _who) public view returns (bool) {
390         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
391     }
392 
393     /** Returns whether or not a user is a minter.
394      * @param _who The address of the account in question.
395      * @return `true` if the user is a minter, `false` otherwise.
396      */
397     function isMinter(address _who) public view returns (bool) {
398         return hasUserPermission(_who, MINT_SIG);
399     }
400 
401     /** Internal Functions **/
402 
403     function _setMinter(address _who) internal {
404         require(isPermission(MINT_SIG), "Minting not supported by token");
405         setUserPermission(_who, MINT_SIG);
406         emit LogSetMinter(_who);
407     }
408 
409     function _removeMinter(address _who) internal {
410         require(isPermission(MINT_SIG), "Minting not supported by token");
411         removeUserPermission(_who, MINT_SIG);
412         emit LogRemovedMinter(_who);
413     }
414 
415     function _setNonlistedUser(address _who) internal {
416         require(isPermission(BURN_SIG), "Burn method not supported by token");
417         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
418         removeUserPermission(_who, BURN_SIG);
419         removeUserPermission(_who, BLACKLISTED_SIG);
420         emit LogNonlistedUser(_who);
421     }
422 
423     function _setBlacklistedUser(address _who) internal {
424         require(isPermission(BURN_SIG), "Burn method not supported by token");
425         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
426         removeUserPermission(_who, BURN_SIG);
427         setUserPermission(_who, BLACKLISTED_SIG);
428         emit LogBlacklistedUser(_who);
429     }
430 
431     function _setWhitelistedUser(address _who) internal {
432         require(isPermission(BURN_SIG), "Burn method not supported by token");
433         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
434         setUserPermission(_who, BURN_SIG);
435         removeUserPermission(_who, BLACKLISTED_SIG);
436         emit LogWhitelistedUser(_who);
437     }
438 }
439 
440 /**
441  * @title CarbonDollarRegulator
442  * @dev CarbonDollarRegulator is a type of Regulator that modifies its definitions of
443  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A CarbonDollar
444  * provides a user the additional ability to convert from CUSD into a whtielisted stablecoin
445  *
446  */
447 contract CarbonDollarRegulator is Regulator {
448 
449     // Getters
450     function isWhitelistedUser(address _who) public view returns(bool) {
451         return (hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
452         && hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
453         && !hasUserPermission(_who, BLACKLISTED_SIG));
454     }
455 
456     function isBlacklistedUser(address _who) public view returns(bool) {
457         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
458         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
459         && hasUserPermission(_who, BLACKLISTED_SIG));
460     }
461 
462     function isNonlistedUser(address _who) public view returns(bool) {
463         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
464         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
465         && !hasUserPermission(_who, BLACKLISTED_SIG));
466     }
467 
468     /** Internal functions **/
469     
470     // Setters: CarbonDollarRegulator overrides the definitions of whitelisted, nonlisted, and blacklisted setUserPermission
471 
472     // CarbonDollar whitelisted users burn CUSD into a WhitelistedToken. Unlike PermissionedToken 
473     // whitelisted users, CarbonDollar whitelisted users cannot burn ordinary CUSD without converting into WT
474     function _setWhitelistedUser(address _who) internal {
475         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
476         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
477         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
478         setUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
479         setUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
480         removeUserPermission(_who, BLACKLISTED_SIG);
481         emit LogWhitelistedUser(_who);
482     }
483 
484     function _setBlacklistedUser(address _who) internal {
485         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
486         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
487         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
488         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
489         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
490         setUserPermission(_who, BLACKLISTED_SIG);
491         emit LogBlacklistedUser(_who);
492     }
493 
494     function _setNonlistedUser(address _who) internal {
495         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
496         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
497         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
498         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
499         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
500         removeUserPermission(_who, BLACKLISTED_SIG);
501         emit LogNonlistedUser(_who);
502     }
503 }