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
250 contract IEthereumForkArbiter {
251 
252     ////////////////////////
253     // Events
254     ////////////////////////
255 
256     event LogForkAnnounced(
257         string name,
258         string url,
259         uint256 blockNumber
260     );
261 
262     event LogForkSigned(
263         uint256 blockNumber,
264         bytes32 blockHash
265     );
266 
267     ////////////////////////
268     // Public functions
269     ////////////////////////
270 
271     function nextForkName()
272         public
273         constant
274         returns (string);
275 
276     function nextForkUrl()
277         public
278         constant
279         returns (string);
280 
281     function nextForkBlockNumber()
282         public
283         constant
284         returns (uint256);
285 
286     function lastSignedBlockNumber()
287         public
288         constant
289         returns (uint256);
290 
291     function lastSignedBlockHash()
292         public
293         constant
294         returns (bytes32);
295 
296     function lastSignedTimestamp()
297         public
298         constant
299         returns (uint256);
300 
301 }
302 
303 contract EthereumForkArbiter is
304     IEthereumForkArbiter,
305     AccessControlled,
306     AccessRoles,
307     Reclaimable
308 {
309     ////////////////////////
310     // Mutable state
311     ////////////////////////
312 
313     string private _nextForkName;
314 
315     string private _nextForkUrl;
316 
317     uint256 private _nextForkBlockNumber;
318 
319     uint256 private _lastSignedBlockNumber;
320 
321     bytes32 private _lastSignedBlockHash;
322 
323     uint256 private _lastSignedTimestamp;
324 
325     ////////////////////////
326     // Constructor
327     ////////////////////////
328 
329     function EthereumForkArbiter(IAccessPolicy accessPolicy)
330         AccessControlled(accessPolicy)
331         Reclaimable()
332         public
333     {
334     }
335 
336     ////////////////////////
337     // Public functions
338     ////////////////////////
339 
340     /// @notice Announce that a particular future Ethereum fork will the one taken by the contract. The contract on the other branch should be considered invalid. Once the fork has happened, it will additionally be confirmed by signing a block on the fork. Notice that forks may happen unannounced.
341     function announceFork(
342         string name,
343         string url,
344         uint256 blockNumber
345     )
346         public
347         only(ROLE_PLATFORM_OPERATOR_REPRESENTATIVE)
348     {
349         require(blockNumber == 0 || blockNumber > block.number);
350 
351         // Store announcement
352         _nextForkName = name;
353         _nextForkUrl = url;
354         _nextForkBlockNumber = blockNumber;
355 
356         // Log
357         LogForkAnnounced(_nextForkName, _nextForkUrl, _nextForkBlockNumber);
358     }
359 
360     /// @notice Declare that the current fork (as identified by a blockhash) is the valid fork. The valid fork is always the one with the most recent signature.
361     function signFork(uint256 number, bytes32 hash)
362         public
363         only(ROLE_PLATFORM_OPERATOR_REPRESENTATIVE)
364     {
365         require(block.blockhash(number) == hash);
366 
367         // Reset announcement
368         delete _nextForkName;
369         delete _nextForkUrl;
370         delete _nextForkBlockNumber;
371 
372         // Store signature
373         _lastSignedBlockNumber = number;
374         _lastSignedBlockHash = hash;
375         _lastSignedTimestamp = block.timestamp;
376 
377         // Log
378         LogForkSigned(_lastSignedBlockNumber, _lastSignedBlockHash);
379     }
380 
381     function nextForkName()
382         public
383         constant
384         returns (string)
385     {
386         return _nextForkName;
387     }
388 
389     function nextForkUrl()
390         public
391         constant
392         returns (string)
393     {
394         return _nextForkUrl;
395     }
396 
397     function nextForkBlockNumber()
398         public
399         constant
400         returns (uint256)
401     {
402         return _nextForkBlockNumber;
403     }
404 
405     function lastSignedBlockNumber()
406         public
407         constant
408         returns (uint256)
409     {
410         return _lastSignedBlockNumber;
411     }
412 
413     function lastSignedBlockHash()
414         public
415         constant
416         returns (bytes32)
417     {
418         return _lastSignedBlockHash;
419     }
420 
421     function lastSignedTimestamp()
422         public
423         constant
424         returns (uint256)
425     {
426         return _lastSignedTimestamp;
427     }
428 }