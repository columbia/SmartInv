1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10   struct Role {
11     mapping (address => bool) bearer;
12   }
13 
14   /**
15    * @dev give an account access to this role
16    */
17   function add(Role storage role, address account) internal {
18     require(account != address(0));
19     require(!has(role, account));
20 
21     role.bearer[account] = true;
22   }
23 
24   /**
25    * @dev remove an account's access to this role
26    */
27   function remove(Role storage role, address account) internal {
28     require(account != address(0));
29     require(has(role, account));
30 
31     role.bearer[account] = false;
32   }
33 
34   /**
35    * @dev check if an account has this role
36    * @return bool
37    */
38   function has(Role storage role, address account)
39     internal
40     view
41     returns (bool)
42   {
43     require(account != address(0));
44     return role.bearer[account];
45   }
46 }
47 
48 // File: node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
49 
50 contract PauserRole {
51   using Roles for Roles.Role;
52 
53   event PauserAdded(address indexed account);
54   event PauserRemoved(address indexed account);
55 
56   Roles.Role private pausers;
57 
58   constructor() internal {
59     _addPauser(msg.sender);
60   }
61 
62   modifier onlyPauser() {
63     require(isPauser(msg.sender));
64     _;
65   }
66 
67   function isPauser(address account) public view returns (bool) {
68     return pausers.has(account);
69   }
70 
71   function addPauser(address account) public onlyPauser {
72     _addPauser(account);
73   }
74 
75   function renouncePauser() public {
76     _removePauser(msg.sender);
77   }
78 
79   function _addPauser(address account) internal {
80     pausers.add(account);
81     emit PauserAdded(account);
82   }
83 
84   function _removePauser(address account) internal {
85     pausers.remove(account);
86     emit PauserRemoved(account);
87   }
88 }
89 
90 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is PauserRole {
97   event Paused(address account);
98   event Unpaused(address account);
99 
100   bool private _paused;
101 
102   constructor() internal {
103     _paused = false;
104   }
105 
106   /**
107    * @return true if the contract is paused, false otherwise.
108    */
109   function paused() public view returns(bool) {
110     return _paused;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!_paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(_paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyPauser whenNotPaused {
133     _paused = true;
134     emit Paused(msg.sender);
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyPauser whenPaused {
141     _paused = false;
142     emit Unpaused(msg.sender);
143   }
144 }
145 
146 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154   address private _owner;
155 
156   event OwnershipTransferred(
157     address indexed previousOwner,
158     address indexed newOwner
159   );
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   constructor() internal {
166     _owner = msg.sender;
167     emit OwnershipTransferred(address(0), _owner);
168   }
169 
170   /**
171    * @return the address of the owner.
172    */
173   function owner() public view returns(address) {
174     return _owner;
175   }
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(isOwner());
182     _;
183   }
184 
185   /**
186    * @return true if `msg.sender` is the owner of the contract.
187    */
188   function isOwner() public view returns(bool) {
189     return msg.sender == _owner;
190   }
191 
192   /**
193    * @dev Allows the current owner to relinquish control of the contract.
194    * @notice Renouncing to ownership will leave the contract without an owner.
195    * It will not be possible to call the functions with the `onlyOwner`
196    * modifier anymore.
197    */
198   function renounceOwnership() public onlyOwner {
199     emit OwnershipTransferred(_owner, address(0));
200     _owner = address(0);
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     _transferOwnership(newOwner);
209   }
210 
211   /**
212    * @dev Transfers control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function _transferOwnership(address newOwner) internal {
216     require(newOwner != address(0));
217     emit OwnershipTransferred(_owner, newOwner);
218     _owner = newOwner;
219   }
220 }
221 
222 // File: contracts/IBounty.sol
223 
224 interface IBounty {
225 
226   function packageBounty(
227     address owner,
228     uint256 needHopsAmount,
229     address[] tokenAddress,
230     uint256[] tokenAmount)
231     external returns (bool);
232   
233   function openBounty(uint256 bountyId)
234     external returns (bool);
235   
236   function checkBounty(uint256 bountyId)
237     external view returns (address, uint256, address[], uint256[]);
238 
239   /* Events */
240   event BountyEvt (
241     uint256 bountyId,
242     address owner,
243     uint256 needHopsAmount,
244     address[] tokenAddress,
245     uint256[] tokenAmount
246   );
247 
248   event OpenBountyEvt (
249     uint256 bountyId,
250     address sender,
251     uint256 needHopsAmount,
252     address[] tokenAddress,
253     uint256[] tokenAmount
254   );
255 }
256 
257 // File: contracts/Role/WhitelistAdminRole.sol
258 
259 /**
260  * @title WhitelistAdminRole
261  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
262  */
263 contract WhitelistAdminRole {
264   using Roles for Roles.Role;
265 
266   event WhitelistAdminAdded(address indexed account);
267   event WhitelistAdminRemoved(address indexed account);
268 
269   Roles.Role private _whitelistAdmins;
270 
271   constructor () internal {
272     _addWhitelistAdmin(msg.sender);
273   }
274 
275   modifier onlyWhitelistAdmin() {
276     require(isWhitelistAdmin(msg.sender));
277     _;
278   }
279 
280   function isWhitelistAdmin(address account) public view returns (bool) {
281     return _whitelistAdmins.has(account);
282   }
283 
284   function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
285     _addWhitelistAdmin(account);
286   }
287 
288   function renounceWhitelistAdmin() public {
289     _removeWhitelistAdmin(msg.sender);
290   }
291 
292   function _addWhitelistAdmin(address account) internal {
293     _whitelistAdmins.add(account);
294     emit WhitelistAdminAdded(account);
295   }
296 
297   function _removeWhitelistAdmin(address account) internal {
298     _whitelistAdmins.remove(account);
299     emit WhitelistAdminRemoved(account);
300   }
301 }
302 
303 // File: contracts/Role/WhitelistedRole.sol
304 
305 /**
306  * @title WhitelistedRole
307  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
308  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
309  * it), and not Whitelisteds themselves.
310  */
311 contract WhitelistedRole is WhitelistAdminRole {
312   using Roles for Roles.Role;
313 
314   event WhitelistedAdded(address indexed account);
315   event WhitelistedRemoved(address indexed account);
316 
317   Roles.Role private _whitelisteds;
318 
319   modifier onlyWhitelisted() {
320     require(isWhitelisted(msg.sender));
321     _;
322   }
323 
324   function isWhitelisted(address account) public view returns (bool) {
325     return _whitelisteds.has(account);
326   }
327 
328   function addWhitelisted(address account) public onlyWhitelistAdmin {
329     _addWhitelisted(account);
330   }
331 
332   function removeWhitelisted(address account) public onlyWhitelistAdmin {
333     _removeWhitelisted(account);
334   }
335 
336   function renounceWhitelisted() public {
337     _removeWhitelisted(msg.sender);
338   }
339 
340   function _addWhitelisted(address account) internal {
341     _whitelisteds.add(account);
342     emit WhitelistedAdded(account);
343   }
344 
345   function _removeWhitelisted(address account) internal {
346     _whitelisteds.remove(account);
347     emit WhitelistedRemoved(account);
348   }
349 }
350 
351 // File: contracts/SafeMath.sol
352 
353 /**
354  * @title SafeMath
355  */
356 library SafeMath {
357   /**
358   * @dev Integer division of two numbers, truncating the quotient.
359   */
360   function div(uint256 a, uint256 b) internal pure returns (uint256) {
361     // assert(b > 0); // Solidity automatically throws when dividing by 0
362     // uint256 c = a / b;
363     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
364     return a / b;
365   }
366 
367   /**
368   * @dev Multiplies two numbers, throws on overflow.
369   */
370   function mul(uint256 a, uint256 b) 
371       internal 
372       pure 
373       returns (uint256 c) 
374   {
375     if (a == 0) {
376       return 0;
377     }
378     c = a * b;
379     require(c / a == b, "SafeMath mul failed");
380     return c;
381   }
382 
383   /**
384   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
385   */
386   function sub(uint256 a, uint256 b)
387       internal
388       pure
389       returns (uint256) 
390   {
391     require(b <= a, "SafeMath sub failed");
392     return a - b;
393   }
394 
395   /**
396   * @dev Adds two numbers, throws on overflow.
397   */
398   function add(uint256 a, uint256 b)
399       internal
400       pure
401       returns (uint256 c) 
402   {
403     c = a + b;
404     require(c >= a, "SafeMath add failed");
405     return c;
406   }
407   
408   /**
409     * @dev gives square root of given x.
410     */
411   function sqrt(uint256 x)
412       internal
413       pure
414       returns (uint256 y) 
415   {
416     uint256 z = ((add(x,1)) / 2);
417     y = x;
418     while (z < y) 
419     {
420       y = z;
421       z = ((add((x / z),z)) / 2);
422     }
423   }
424   
425   /**
426     * @dev gives square. batchplies x by x
427     */
428   function sq(uint256 x)
429       internal
430       pure
431       returns (uint256)
432   {
433     return (mul(x,x));
434   }
435   
436   /**
437     * @dev x to the power of y 
438     */
439   function pwr(uint256 x, uint256 y)
440       internal 
441       pure 
442       returns (uint256)
443   {
444     if (x==0)
445         return (0);
446     else if (y==0)
447         return (1);
448     else 
449     {
450       uint256 z = x;
451       for (uint256 i=1; i < y; i++)
452         z = mul(z,x);
453       return (z);
454     }
455   }
456 }
457 
458 // File: contracts/Bounty.sol
459 
460 interface IERC20 {
461   function transfer(address to, uint256 value) external returns (bool);
462   function balanceOf(address who) external view returns (uint256);
463   function allowance(address tokenOwner, address spender) external view returns (uint256);
464   function burnFrom(address from, uint256 value) external;
465 }
466 
467 interface IERC721 {
468   function mintTo(address to) external returns (bool, uint256);
469   function ownerOf(uint256 tokenId) external view returns (address);
470   function burn(uint256 tokenId) external;
471   function isApprovedForAll(address owner, address operator) external view returns (bool);
472 }
473 
474 contract Bounty is WhitelistedRole, IBounty, Pausable {
475 
476   using SafeMath for *;
477 
478   address public erc20Address;
479   address public bountyNFTAddress;
480 
481   struct Bounty {
482     uint256 needHopsAmount;
483     address[] tokenAddress;
484     uint256[] tokenAmount;
485   }
486 
487   bytes32[] public planBaseIds;
488 
489   mapping (uint256 => Bounty) bountyIdToBounty;
490 
491   constructor (address _erc20Address, address _bountyNFTAddress) {
492     erc20Address = _erc20Address;
493     bountyNFTAddress = _bountyNFTAddress;
494   }
495 
496   function packageBounty (
497     address owner,
498     uint256 needHopsAmount,
499     address[] tokenAddress,
500     uint256[] tokenAmount
501   ) whenNotPaused external returns (bool) {
502     require(isWhitelisted(msg.sender)||isWhitelistAdmin(msg.sender));
503     Bounty memory bounty = Bounty(needHopsAmount, tokenAddress, tokenAmount);
504     (bool success, uint256 bountyId) = IERC721(bountyNFTAddress).mintTo(owner);
505     require(success);
506     bountyIdToBounty[bountyId] = bounty;
507     emit BountyEvt(bountyId, owner, needHopsAmount, tokenAddress, tokenAmount);
508   }
509 
510   function openBounty(uint256 bountyId)
511     whenNotPaused external returns (bool) {
512     Bounty storage bounty = bountyIdToBounty[bountyId];
513     require(IERC721(bountyNFTAddress).ownerOf(bountyId) == msg.sender);
514 
515     require(IERC721(bountyNFTAddress).isApprovedForAll(msg.sender, address(this)));
516     require(IERC20(erc20Address).balanceOf(msg.sender) >= bounty.needHopsAmount);
517     require(IERC20(erc20Address).allowance(msg.sender, address(this)) >= bounty.needHopsAmount);
518     IERC20(erc20Address).burnFrom(msg.sender, bounty.needHopsAmount);
519 
520     for (uint8 i = 0; i < bounty.tokenAddress.length; i++) {
521       require(IERC20(bounty.tokenAddress[i]).transfer(msg.sender, bounty.tokenAmount[i]));
522     }
523 
524     IERC721(bountyNFTAddress).burn(bountyId);
525     delete bountyIdToBounty[bountyId];
526 
527     emit OpenBountyEvt(bountyId, msg.sender, bounty.needHopsAmount, bounty.tokenAddress, bounty.tokenAmount);
528   }
529 
530   function checkBounty(uint256 bountyId) external view returns (
531     address,
532     uint256,
533     address[],
534     uint256[]) {
535     Bounty storage bounty = bountyIdToBounty[bountyId];
536     address owner = IERC721(bountyNFTAddress).ownerOf(bountyId);
537     return (owner, bounty.needHopsAmount, bounty.tokenAddress, bounty.tokenAmount);
538   }
539 }