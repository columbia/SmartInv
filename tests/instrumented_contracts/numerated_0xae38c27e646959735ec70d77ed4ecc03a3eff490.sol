1 pragma solidity 0.4.15;
2 
3 /// @title provides subject to role checking logic
4 contract IAccessPolicy {
5 
6     ////////////////////////
7     // Public functions
8     ////////////////////////
9 
10     /// @notice We don't make this function constant to allow for state-updating access controls such as rate limiting.
11     /// @dev checks if subject belongs to requested role for particular object
12     /// @param subject address to be checked against role, typically msg.sender
13     /// @param role identifier of required role
14     /// @param object contract instance context for role checking, typically contract requesting the check
15     /// @param verb additional data, in current AccessControll implementation msg.sig
16     /// @return if subject belongs to a role
17     function allowed(
18         address subject,
19         bytes32 role,
20         address object,
21         bytes4 verb
22     )
23         public
24         returns (bool);
25 }
26 
27 /// @title enables access control in implementing contract
28 /// @dev see AccessControlled for implementation
29 contract IAccessControlled {
30 
31     ////////////////////////
32     // Events
33     ////////////////////////
34 
35     /// @dev must log on access policy change
36     event LogAccessPolicyChanged(
37         address controller,
38         IAccessPolicy oldPolicy,
39         IAccessPolicy newPolicy
40     );
41 
42     ////////////////////////
43     // Public functions
44     ////////////////////////
45 
46     /// @dev allows to change access control mechanism for this contract
47     ///     this method must be itself access controlled, see AccessControlled implementation and notice below
48     /// @notice it is a huge issue for Solidity that modifiers are not part of function signature
49     ///     then interfaces could be used for example to control access semantics
50     /// @param newPolicy new access policy to controll this contract
51     /// @param newAccessController address of ROLE_ACCESS_CONTROLLER of new policy that can set access to this contract
52     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
53         public;
54 
55     function accessPolicy()
56         public
57         constant
58         returns (IAccessPolicy);
59 
60 }
61 
62 contract StandardRoles {
63 
64     ////////////////////////
65     // Constants
66     ////////////////////////
67 
68     // @notice Soldity somehow doesn't evaluate this compile time
69     // @dev role which has rights to change permissions and set new policy in contract, keccak256("AccessController")
70     bytes32 internal constant ROLE_ACCESS_CONTROLLER = 0xac42f8beb17975ed062dcb80c63e6d203ef1c2c335ced149dc5664cc671cb7da;
71 }
72 
73 /// @title Granular code execution permissions
74 /// @notice Intended to replace existing Ownable pattern with more granular permissions set to execute smart contract functions
75 ///     for each function where 'only' modifier is applied, IAccessPolicy implementation is called to evaluate if msg.sender belongs to required role for contract being called.
76 ///     Access evaluation specific belong to IAccessPolicy implementation, see RoleBasedAccessPolicy for details.
77 /// @dev Should be inherited by a contract requiring such permissions controll. IAccessPolicy must be provided in constructor. Access policy may be replaced to a different one
78 ///     by msg.sender with ROLE_ACCESS_CONTROLLER role
79 contract AccessControlled is IAccessControlled, StandardRoles {
80 
81     ////////////////////////
82     // Mutable state
83     ////////////////////////
84 
85     IAccessPolicy private _accessPolicy;
86 
87     ////////////////////////
88     // Modifiers
89     ////////////////////////
90 
91     /// @dev limits function execution only to senders assigned to required 'role'
92     modifier only(bytes32 role) {
93         require(_accessPolicy.allowed(msg.sender, role, this, msg.sig));
94         _;
95     }
96 
97     ////////////////////////
98     // Constructor
99     ////////////////////////
100 
101     function AccessControlled(IAccessPolicy policy) internal {
102         require(address(policy) != 0x0);
103         _accessPolicy = policy;
104     }
105 
106     ////////////////////////
107     // Public functions
108     ////////////////////////
109 
110     //
111     // Implements IAccessControlled
112     //
113 
114     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
115         public
116         only(ROLE_ACCESS_CONTROLLER)
117     {
118         // ROLE_ACCESS_CONTROLLER must be present
119         // under the new policy. This provides some
120         // protection against locking yourself out.
121         require(newPolicy.allowed(newAccessController, ROLE_ACCESS_CONTROLLER, this, msg.sig));
122 
123         // We can now safely set the new policy without foot shooting.
124         IAccessPolicy oldPolicy = _accessPolicy;
125         _accessPolicy = newPolicy;
126 
127         // Log event
128         LogAccessPolicyChanged(msg.sender, oldPolicy, newPolicy);
129     }
130 
131     function accessPolicy()
132         public
133         constant
134         returns (IAccessPolicy)
135     {
136         return _accessPolicy;
137     }
138 }
139 
140 contract AccessRoles {
141 
142     ////////////////////////
143     // Constants
144     ////////////////////////
145 
146     // NOTE: All roles are set to the keccak256 hash of the
147     // CamelCased role name, i.e.
148     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
149 
150     // may setup LockedAccount, change disbursal mechanism and set migration
151     bytes32 internal constant ROLE_LOCKED_ACCOUNT_ADMIN = 0x4675da546d2d92c5b86c4f726a9e61010dce91cccc2491ce6019e78b09d2572e;
152 
153     // may setup whitelists and abort whitelisting contract with curve rollback
154     bytes32 internal constant ROLE_WHITELIST_ADMIN = 0xaef456e7c864418e1d2a40d996ca4febf3a7e317fe3af5a7ea4dda59033bbe5c;
155 
156     // May issue (generate) Neumarks
157     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
158 
159     // May burn Neumarks it owns
160     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
161 
162     // May create new snapshots on Neumark
163     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
164 
165     // May enable/disable transfers on Neumark
166     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
167 
168     // may reclaim tokens/ether from contracts supporting IReclaimable interface
169     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
170 
171     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
172     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
173 
174     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
175     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
176 }
177 
178 contract IBasicToken {
179 
180     ////////////////////////
181     // Events
182     ////////////////////////
183 
184     event Transfer(
185         address indexed from,
186         address indexed to,
187         uint256 amount);
188 
189     ////////////////////////
190     // Public functions
191     ////////////////////////
192 
193     /// @dev This function makes it easy to get the total number of tokens
194     /// @return The total number of tokens
195     function totalSupply()
196         public
197         constant
198         returns (uint256);
199 
200     /// @param owner The address that's balance is being requested
201     /// @return The balance of `owner` at the current block
202     function balanceOf(address owner)
203         public
204         constant
205         returns (uint256 balance);
206 
207     /// @notice Send `amount` tokens to `to` from `msg.sender`
208     /// @param to The address of the recipient
209     /// @param amount The amount of tokens to be transferred
210     /// @return Whether the transfer was successful or not
211     function transfer(address to, uint256 amount)
212         public
213         returns (bool success);
214 
215 }
216 
217 /// @title allows deriving contract to recover any token or ether that it has balance of
218 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
219 ///     be ready to handle such claims
220 /// @dev use with care!
221 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
222 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
223 ///         see LockedAccount as an example
224 contract Reclaimable is AccessControlled, AccessRoles {
225 
226     ////////////////////////
227     // Constants
228     ////////////////////////
229 
230     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
231 
232     ////////////////////////
233     // Public functions
234     ////////////////////////
235 
236     function reclaim(IBasicToken token)
237         public
238         only(ROLE_RECLAIMER)
239     {
240         address reclaimer = msg.sender;
241         if(token == RECLAIM_ETHER) {
242             reclaimer.transfer(this.balance);
243         } else {
244             uint256 balance = token.balanceOf(this);
245             require(token.transfer(reclaimer, balance));
246         }
247     }
248 }
249 
250 /// @title access policy based on Access Control Lists concept
251 /// @dev Allows to assign an address to a set of roles (n:n relation) and querying if such specific assignment exists.
252 ///     This assignment happens in two contexts:
253 ///         - contract context which allows to build a set of local permissions enforced for particular contract
254 ///         - global context which defines set of global permissions that apply to any contract using this RoleBasedAccessPolicy as Access Policy
255 ///     Permissions are cascading as follows
256 ///         - evaluate permission for given subject for given object (local context)
257 ///         - evaluate permission for given subject for all objects (global context)
258 ///         - evaluate permissions for any subject (everyone) for given object (everyone local context)
259 ///         - evaluate permissions for any subject (everyone) for all objects (everyone global context)
260 ///         - if still unset then disallow
261 ///     Permission is cascaded up only if it was evaluated as Unset at particular level. See EVERYONE and GLOBAL definitions for special values (they are 0x0 addresses)
262 ///     RoleBasedAccessPolicy is its own policy. When created, creator has ROLE_ACCESS_CONTROLLER role. Right pattern is to transfer this control to some other (non deployer) account and then destroy deployer private key.
263 ///     See IAccessControlled for definitions of subject, object and role
264 contract RoleBasedAccessPolicy is
265     IAccessPolicy,
266     AccessControlled,
267     Reclaimable
268 {
269 
270     ////////////////
271     // Types
272     ////////////////
273 
274     // Łukasiewicz logic values
275     enum TriState {
276         Unset,
277         Allow,
278         Deny
279     }
280 
281     ////////////////////////
282     // Constants
283     ////////////////////////
284 
285     IAccessControlled private constant GLOBAL = IAccessControlled(0x0);
286 
287     address private constant EVERYONE = 0x0;
288 
289     ////////////////////////
290     // Mutable state
291     ////////////////////////
292 
293     /// @dev subject → role → object → allowed
294     mapping (address =>
295         mapping(bytes32 =>
296             mapping(address => TriState))) private _access;
297 
298     /// @notice used to enumerate all users assigned to given role in object context
299     /// @dev object → role → addresses
300     mapping (address =>
301         mapping(bytes32 => address[])) private _accessList;
302 
303     ////////////////////////
304     // Events
305     ////////////////////////
306 
307     /// @dev logs change of permissions, 'controller' is an address with ROLE_ACCESS_CONTROLLER
308     event LogAccessChanged(
309         address controller,
310         address indexed subject,
311         bytes32 role,
312         address indexed object,
313         TriState oldValue,
314         TriState newValue
315     );
316 
317     event LogAccess(
318         address indexed subject,
319         bytes32 role,
320         address indexed object,
321         bytes4 verb,
322         bool granted
323     );
324 
325     ////////////////////////
326     // Constructor
327     ////////////////////////
328 
329     function RoleBasedAccessPolicy()
330         AccessControlled(this) // We are our own policy. This is immutable.
331         public
332     {
333         // Issue the local and global AccessContoler role to creator
334         _access[msg.sender][ROLE_ACCESS_CONTROLLER][this] = TriState.Allow;
335         _access[msg.sender][ROLE_ACCESS_CONTROLLER][GLOBAL] = TriState.Allow;
336         // Update enumerator accordingly so those permissions are visible as any other
337         updatePermissionEnumerator(msg.sender, ROLE_ACCESS_CONTROLLER, this, TriState.Unset, TriState.Allow);
338         updatePermissionEnumerator(msg.sender, ROLE_ACCESS_CONTROLLER, GLOBAL, TriState.Unset, TriState.Allow);
339     }
340 
341     ////////////////////////
342     // Public functions
343     ////////////////////////
344 
345     // Overrides `AccessControlled.setAccessPolicy(IAccessPolicy,address)`
346     function setAccessPolicy(IAccessPolicy, address)
347         public
348         only(ROLE_ACCESS_CONTROLLER)
349     {
350         // `RoleBasedAccessPolicy` always controls its
351         // own access. Disallow changing this by overriding
352         // the `AccessControlled.setAccessPolicy` function.
353         revert();
354     }
355 
356     // Implements `IAccessPolicy.allowed(address, bytes32, address, bytes4)`
357     function allowed(
358         address subject,
359         bytes32 role,
360         address object,
361         bytes4 verb
362     )
363         public
364         // constant // NOTE: Solidity does not allow subtyping interfaces
365         returns (bool)
366     {
367         bool set = false;
368         bool allow = false;
369         TriState value = TriState.Unset;
370 
371         // Cascade local, global, everyone local, everyone global
372         value = _access[subject][role][object];
373         set = value != TriState.Unset;
374         allow = value == TriState.Allow;
375         if (!set) {
376             value = _access[subject][role][GLOBAL];
377             set = value != TriState.Unset;
378             allow = value == TriState.Allow;
379         }
380         if (!set) {
381             value = _access[EVERYONE][role][object];
382             set = value != TriState.Unset;
383             allow = value == TriState.Allow;
384         }
385         if (!set) {
386             value = _access[EVERYONE][role][GLOBAL];
387             set = value != TriState.Unset;
388             allow = value == TriState.Allow;
389         }
390         // If none is set then disallow
391         if (!set) {
392             allow = false;
393         }
394 
395         // Log and return
396         LogAccess(subject, role, object, verb, allow);
397         return allow;
398     }
399 
400     // Assign a role to a user globally
401     function setUserRole(
402         address subject,
403         bytes32 role,
404         IAccessControlled object,
405         TriState newValue
406     )
407         public
408         only(ROLE_ACCESS_CONTROLLER)
409     {
410         setUserRolePrivate(subject, role, object, newValue);
411     }
412 
413     // Atomically change a set of role assignments
414     function setUserRoles(
415         address[] subjects,
416         bytes32[] roles,
417         IAccessControlled[] objects,
418         TriState[] newValues
419     )
420         public
421         only(ROLE_ACCESS_CONTROLLER)
422     {
423         require(subjects.length == roles.length);
424         require(subjects.length == objects.length);
425         require(subjects.length == newValues.length);
426         for(uint256 i = 0; i < subjects.length; ++i) {
427             setUserRolePrivate(subjects[i], roles[i], objects[i], newValues[i]);
428         }
429     }
430 
431     function getValue(
432         address subject,
433         bytes32 role,
434         IAccessControlled object
435     )
436         public
437         constant
438         returns (TriState)
439     {
440         return _access[subject][role][object];
441     }
442 
443     function getUsers(
444         IAccessControlled object,
445         bytes32 role
446     )
447         public
448         constant
449         returns (address[])
450     {
451         return _accessList[object][role];
452     }
453 
454     ////////////////////////
455     // Private functions
456     ////////////////////////
457 
458     function setUserRolePrivate(
459         address subject,
460         bytes32 role,
461         IAccessControlled object,
462         TriState newValue
463     )
464         private
465     {
466         // An access controler is not allowed to revoke his own right on this
467         // contract. This prevents access controlers from locking themselves
468         // out. We also require the current contract to be its own policy for
469         // this to work. This is enforced elsewhere.
470         require(role != ROLE_ACCESS_CONTROLLER || subject != msg.sender || object != this);
471 
472         // Fetch old value and short-circuit no-ops
473         TriState oldValue = _access[subject][role][object];
474         if(oldValue == newValue) {
475             return;
476         }
477 
478         // Update the mapping
479         _access[subject][role][object] = newValue;
480 
481         // Update permission in enumerator
482         updatePermissionEnumerator(subject, role, object, oldValue, newValue);
483 
484         // Log
485         LogAccessChanged(msg.sender, subject, role, object, oldValue, newValue);
486     }
487 
488     function updatePermissionEnumerator(
489         address subject,
490         bytes32 role,
491         IAccessControlled object,
492         TriState oldValue,
493         TriState newValue
494     )
495         private
496     {
497         // Update the list on add / remove
498         address[] storage list = _accessList[object][role];
499         // Add new subject only when going form Unset to Allow/Deny
500         if(oldValue == TriState.Unset && newValue != TriState.Unset) {
501             list.push(subject);
502         }
503         // Remove subject when unsetting Allow/Deny
504         if(oldValue != TriState.Unset && newValue == TriState.Unset) {
505             for(uint256 i = 0; i < list.length; ++i) {
506                 if(list[i] == subject) {
507                     // replace unset address with last address in the list, cut list size
508                     list[i] = list[list.length - 1];
509                     delete list[list.length - 1];
510                     list.length -= 1;
511                     // there will be no more matches
512                     break;
513                 }
514             }
515         }
516     }
517 }