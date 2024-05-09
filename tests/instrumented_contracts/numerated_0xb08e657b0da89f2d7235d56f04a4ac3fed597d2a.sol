1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library Roles {
6   struct Role {
7     mapping (address => bool) bearer;
8   }
9 
10   /**
11    * @dev give an address access to this role
12    */
13   function add(Role storage role, address addr)
14     internal
15   {
16     role.bearer[addr] = true;
17   }
18 
19   /**
20    * @dev remove an address' access to this role
21    */
22   function remove(Role storage role, address addr)
23     internal
24   {
25     role.bearer[addr] = false;
26   }
27 
28   /**
29    * @dev check if an address has this role
30    * // reverts
31    */
32   function check(Role storage role, address addr)
33     view
34     internal
35   {
36     require(has(role, addr));
37   }
38 
39   /**
40    * @dev check if an address has this role
41    * @return bool
42    */
43   function has(Role storage role, address addr)
44     view
45     internal
46     returns (bool)
47   {
48     return role.bearer[addr];
49   }
50 }
51 
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (a == 0) {
62       return 0;
63     }
64 
65     c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 contract Ownable {
99   address public owner;
100 
101 
102   event OwnershipRenounced(address indexed previousOwner);
103   event OwnershipTransferred(
104     address indexed previousOwner,
105     address indexed newOwner
106   );
107 
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   constructor() public {
114     owner = msg.sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to relinquish control of the contract.
127    */
128   function renounceOwnership() public onlyOwner {
129     emit OwnershipRenounced(owner);
130     owner = address(0);
131   }
132 
133   /**
134    * @dev Allows the current owner to transfer control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137   function transferOwnership(address _newOwner) public onlyOwner {
138     _transferOwnership(_newOwner);
139   }
140 
141   /**
142    * @dev Transfers control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function _transferOwnership(address _newOwner) internal {
146     require(_newOwner != address(0));
147     emit OwnershipTransferred(owner, _newOwner);
148     owner = _newOwner;
149   }
150 }
151 
152 contract RBAC {
153   using Roles for Roles.Role;
154 
155   mapping (string => Roles.Role) private roles;
156 
157   event RoleAdded(address addr, string roleName);
158   event RoleRemoved(address addr, string roleName);
159 
160   /**
161    * @dev reverts if addr does not have role
162    * @param addr address
163    * @param roleName the name of the role
164    * // reverts
165    */
166   function checkRole(address addr, string roleName)
167     view
168     public
169   {
170     roles[roleName].check(addr);
171   }
172 
173   /**
174    * @dev determine if addr has role
175    * @param addr address
176    * @param roleName the name of the role
177    * @return bool
178    */
179   function hasRole(address addr, string roleName)
180     view
181     public
182     returns (bool)
183   {
184     return roles[roleName].has(addr);
185   }
186 
187   /**
188    * @dev add a role to an address
189    * @param addr address
190    * @param roleName the name of the role
191    */
192   function addRole(address addr, string roleName)
193     internal
194   {
195     roles[roleName].add(addr);
196     emit RoleAdded(addr, roleName);
197   }
198 
199   /**
200    * @dev remove a role from an address
201    * @param addr address
202    * @param roleName the name of the role
203    */
204   function removeRole(address addr, string roleName)
205     internal
206   {
207     roles[roleName].remove(addr);
208     emit RoleRemoved(addr, roleName);
209   }
210 
211   /**
212    * @dev modifier to scope access to a single role (uses msg.sender as addr)
213    * @param roleName the name of the role
214    * // reverts
215    */
216   modifier onlyRole(string roleName)
217   {
218     checkRole(msg.sender, roleName);
219     _;
220   }
221 
222   /**
223    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
224    * @param roleNames the names of the roles to scope access to
225    * // reverts
226    *
227    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
228    *  see: https://github.com/ethereum/solidity/issues/2467
229    */
230   // modifier onlyRoles(string[] roleNames) {
231   //     bool hasAnyRole = false;
232   //     for (uint8 i = 0; i < roleNames.length; i++) {
233   //         if (hasRole(msg.sender, roleNames[i])) {
234   //             hasAnyRole = true;
235   //             break;
236   //         }
237   //     }
238 
239   //     require(hasAnyRole);
240 
241   //     _;
242   // }
243 }
244 
245 contract Whitelist is Ownable, RBAC {
246   event WhitelistedAddressAdded(address addr);
247   event WhitelistedAddressRemoved(address addr);
248 
249   string public constant ROLE_WHITELISTED = "whitelist";
250 
251   /**
252    * @dev Throws if called by any account that's not whitelisted.
253    */
254   modifier onlyWhitelisted() {
255     checkRole(msg.sender, ROLE_WHITELISTED);
256     _;
257   }
258 
259   /**
260    * @dev add an address to the whitelist
261    * @param addr address
262    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
263    */
264   function addAddressToWhitelist(address addr)
265     onlyOwner
266     public
267   {
268     addRole(addr, ROLE_WHITELISTED);
269     emit WhitelistedAddressAdded(addr);
270   }
271 
272   /**
273    * @dev getter to determine if address is in whitelist
274    */
275   function whitelist(address addr)
276     public
277     view
278     returns (bool)
279   {
280     return hasRole(addr, ROLE_WHITELISTED);
281   }
282 
283   /**
284    * @dev add addresses to the whitelist
285    * @param addrs addresses
286    * @return true if at least one address was added to the whitelist,
287    * false if all addresses were already in the whitelist
288    */
289   function addAddressesToWhitelist(address[] addrs)
290     onlyOwner
291     public
292   {
293     for (uint256 i = 0; i < addrs.length; i++) {
294       addAddressToWhitelist(addrs[i]);
295     }
296   }
297 
298   /**
299    * @dev remove an address from the whitelist
300    * @param addr address
301    * @return true if the address was removed from the whitelist,
302    * false if the address wasn't in the whitelist in the first place
303    */
304   function removeAddressFromWhitelist(address addr)
305     onlyOwner
306     public
307   {
308     removeRole(addr, ROLE_WHITELISTED);
309     emit WhitelistedAddressRemoved(addr);
310   }
311 
312   /**
313    * @dev remove addresses from the whitelist
314    * @param addrs addresses
315    * @return true if at least one address was removed from the whitelist,
316    * false if all addresses weren't in the whitelist in the first place
317    */
318   function removeAddressesFromWhitelist(address[] addrs)
319     onlyOwner
320     public
321   {
322     for (uint256 i = 0; i < addrs.length; i++) {
323       removeAddressFromWhitelist(addrs[i]);
324     }
325   }
326 
327 }
328 
329 contract StartersProxy is Whitelist{
330     using SafeMath for uint256;
331 
332     uint256 public TX_PER_SIGNER_LIMIT = 5;          //limit of metatx per signer
333     uint256 public META_BET = 1 finney;              //wei, equal to 0.001 ETH
334     uint256 public DEBT_INCREASING_FACTOR = 3;       //increasing factor (times) applied on the bet
335 
336     struct Record {
337         uint256 nonce;
338         uint256 debt;
339     }
340     mapping(address => Record) signersBacklog;
341     event Received (address indexed sender, uint value);
342     event Forwarded (address signer, address destination, uint value, bytes data);
343 
344     function() public payable {
345         emit Received(msg.sender, msg.value);
346     }
347 
348     constructor(address[] _senders) public {
349         addAddressToWhitelist(msg.sender);
350         addAddressesToWhitelist(_senders);
351     }
352 
353     function forwardPlay(address signer, address destination, bytes data, bytes32 hash, bytes signature) onlyWhitelisted public {
354         require(signersBacklog[signer].nonce < TX_PER_SIGNER_LIMIT, "Signer has reached the tx limit");
355 
356         signersBacklog[signer].nonce++;
357         //we increase the personal debt here
358         //it grows much (much) faster than the actual bet to compensate sender's and proxy's expenses
359         uint256 debtIncrease = META_BET.mul(DEBT_INCREASING_FACTOR);
360         signersBacklog[signer].debt = signersBacklog[signer].debt.add(debtIncrease);
361 
362         forward(signer, destination, META_BET, data, hash, signature);
363     }
364 
365     function forwardWin(address signer, address destination, bytes data, bytes32 hash, bytes signature) onlyWhitelisted public {
366         require(signersBacklog[signer].nonce > 0, 'Hm, no meta plays for this signer');
367 
368         forward(signer, destination, 0, data, hash, signature);
369     }
370 
371     function forward(address signer, address destination,  uint256 value, bytes data, bytes32 hash, bytes signature) internal {
372         require(recoverSigner(hash, signature) == signer);
373 
374         //execute the transaction with all the given parameters
375         require(executeCall(destination, value, data));
376         emit Forwarded(signer, destination, value, data);
377     }
378 
379     //borrowed from OpenZeppelin's ESDA stuff:
380     //https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/ECDSA.sol
381     function recoverSigner(bytes32 _hash, bytes _signature) onlyWhitelisted public view returns (address){
382         bytes32 r;
383         bytes32 s;
384         uint8 v;
385         // Check the signature length
386         require (_signature.length == 65);
387         // Divide the signature in r, s and v variables
388         // ecrecover takes the signature parameters, and the only way to get them
389         // currently is to use assembly.
390         assembly {
391             r := mload(add(_signature, 32))
392             s := mload(add(_signature, 64))
393             v := byte(0, mload(add(_signature, 96)))
394         }
395         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
396         if (v < 27) {
397             v += 27;
398         }
399         // If the version is correct return the signer address
400         require(v == 27 || v == 28);
401         return ecrecover(keccak256(
402                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
403             ), v, r, s);
404     }
405 
406     // this originally was copied from GnosisSafe
407     // https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/GnosisSafe.sol
408     function executeCall(address to, uint256 value, bytes data) internal returns (bool success) {
409         assembly {
410             success := call(gas, to, value, add(data, 0x20), mload(data), 0, 0)
411         }
412     }
413 
414     function payDebt(address signer) public payable{
415         require(signersBacklog[signer].nonce > 0, "Provided address has no debt");
416         require(signersBacklog[signer].debt >= msg.value, "Address's debt is less than payed amount");
417 
418         signersBacklog[signer].debt = signersBacklog[signer].debt.sub(msg.value);
419     }
420 
421     function debt(address signer) public view returns (uint256) {
422         return signersBacklog[signer].debt;
423     }
424 
425     function gamesLeft(address signer) public view returns (uint256) {
426         return TX_PER_SIGNER_LIMIT.sub(signersBacklog[signer].nonce);
427     }
428 
429     function withdraw(uint256 amountWei) onlyWhitelisted public {
430         msg.sender.transfer(amountWei);
431     }
432 
433     function setMetaBet(uint256 _newMetaBet) onlyWhitelisted public {
434         META_BET = _newMetaBet;
435     }
436 
437     function setTxLimit(uint256 _newTxLimit) onlyWhitelisted public {
438         TX_PER_SIGNER_LIMIT = _newTxLimit;
439     }
440 
441     function setDebtIncreasingFactor(uint256 _newFactor) onlyWhitelisted public {
442         DEBT_INCREASING_FACTOR = _newFactor;
443     }
444 
445 
446 }