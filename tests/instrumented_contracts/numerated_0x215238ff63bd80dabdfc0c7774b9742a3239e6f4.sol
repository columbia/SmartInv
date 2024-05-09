1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title ERC20Detailed token
27  * @dev The decimals are only for visualization purposes.
28  * All the operations are done using the smallest and indivisible token unit,
29  * just as on Ethereum all the operations are done in wei.
30  */
31 contract ERC20Detailed is IERC20 {
32     string private _name;
33     string private _symbol;
34     uint8 private _decimals;
35 
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     /**
43      * @return the name of the token.
44      */
45     function name() public view returns (string memory) {
46         return _name;
47     }
48 
49     /**
50      * @return the symbol of the token.
51      */
52     function symbol() public view returns (string memory) {
53         return _symbol;
54     }
55 
56     /**
57      * @return the number of decimals of the token.
58      */
59     function decimals() public view returns (uint8) {
60         return _decimals;
61     }
62 }
63 
64 contract SignerRole {
65     using Roles for Roles.Role;
66 
67     event SignerAdded(address indexed account);
68     event SignerRemoved(address indexed account);
69 
70     Roles.Role private _signers;
71 
72     constructor () internal {
73         _addSigner(msg.sender);
74     }
75 
76     modifier onlySigner() {
77         require(isSigner(msg.sender));
78         _;
79     }
80 
81     function isSigner(address account) public view returns (bool) {
82         return _signers.has(account);
83     }
84 
85     function addSigner(address account) public onlySigner {
86         _addSigner(account);
87     }
88 
89     function renounceSigner() public {
90         _removeSigner(msg.sender);
91     }
92 
93     function _addSigner(address account) internal {
94         _signers.add(account);
95         emit SignerAdded(account);
96     }
97 
98     function _removeSigner(address account) internal {
99         _signers.remove(account);
100         emit SignerRemoved(account);
101     }
102 }
103 
104 contract PauserRole {
105     using Roles for Roles.Role;
106 
107     event PauserAdded(address indexed account);
108     event PauserRemoved(address indexed account);
109 
110     Roles.Role private _pausers;
111 
112     constructor () internal {
113         _addPauser(msg.sender);
114     }
115 
116     modifier onlyPauser() {
117         require(isPauser(msg.sender));
118         _;
119     }
120 
121     function isPauser(address account) public view returns (bool) {
122         return _pausers.has(account);
123     }
124 
125     function addPauser(address account) public onlyPauser {
126         _addPauser(account);
127     }
128 
129     function renouncePauser() public {
130         _removePauser(msg.sender);
131     }
132 
133     function _addPauser(address account) internal {
134         _pausers.add(account);
135         emit PauserAdded(account);
136     }
137 
138     function _removePauser(address account) internal {
139         _pausers.remove(account);
140         emit PauserRemoved(account);
141     }
142 }
143 
144 /**
145  * @title Pausable
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract Pausable is PauserRole {
149     event Paused(address account);
150     event Unpaused(address account);
151 
152     bool private _paused;
153 
154     constructor () internal {
155         _paused = false;
156     }
157 
158     /**
159      * @return true if the contract is paused, false otherwise.
160      */
161     function paused() public view returns (bool) {
162         return _paused;
163     }
164 
165     /**
166      * @dev Modifier to make a function callable only when the contract is not paused.
167      */
168     modifier whenNotPaused() {
169         require(!_paused);
170         _;
171     }
172 
173     /**
174      * @dev Modifier to make a function callable only when the contract is paused.
175      */
176     modifier whenPaused() {
177         require(_paused);
178         _;
179     }
180 
181     /**
182      * @dev called by the owner to pause, triggers stopped state
183      */
184     function pause() public onlyPauser whenNotPaused {
185         _paused = true;
186         emit Paused(msg.sender);
187     }
188 
189     /**
190      * @dev called by the owner to unpause, returns to normal state
191      */
192     function unpause() public onlyPauser whenPaused {
193         _paused = false;
194         emit Unpaused(msg.sender);
195     }
196 }
197 
198 /**
199  * @title SafeMath
200  * @dev Unsigned math operations with safety checks that revert on error
201  */
202 library SafeMath {
203     /**
204     * @dev Multiplies two unsigned integers, reverts on overflow.
205     */
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
208         // benefit is lost if 'b' is also tested.
209         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
210         if (a == 0) {
211             return 0;
212         }
213 
214         uint256 c = a * b;
215         require(c / a == b);
216 
217         return c;
218     }
219 
220     /**
221     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
222     */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         // Solidity only automatically asserts when dividing by 0
225         require(b > 0);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
234     */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b <= a);
237         uint256 c = a - b;
238 
239         return c;
240     }
241 
242     /**
243     * @dev Adds two unsigned integers, reverts on overflow.
244     */
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a);
248 
249         return c;
250     }
251 
252     /**
253     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
254     * reverts when dividing by zero.
255     */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         require(b != 0);
258         return a % b;
259     }
260 }
261 
262 contract DistributionConfigurable is PauserRole {
263 
264   /**
265     Structures
266    */
267 
268   struct DistributionConfig {
269     address lockedWallet;
270     address unlockWallet;
271     uint256 ratioDTV;
272     uint256 ratioDecimals;
273   }
274 
275   /**
276     State variables
277    */
278 
279   DistributionConfig[] public distributionConfigs;
280 
281   /**
282     Events
283    */
284 
285   event DistributionConfigAdded(
286     address indexed lockedWallet,
287     address indexed unlockWallet,
288     uint256 ratioDTV,
289     uint256 ratioDecimals
290   );
291 
292   event DistributionConfigEdited(
293     uint256 indexed index,
294     address indexed lockedWallet,
295     address indexed unlockWallet,
296     uint256 previousRatioDTV,
297     uint256 previousRatioDecimals,
298     uint256 ratioDTV,
299     uint256 ratioDecimals
300   );
301 
302   event DistributionConfigDeleted(
303     uint256 indexed index,
304     address indexed lockedWallet,
305     address indexed unlockWallet,
306     uint256 ratioDTV,
307     uint256 ratioDecimals
308   );
309 
310   /**
311     External views
312    */
313 
314   function distributionConfigsLength()
315     external view
316     returns (uint256 length)
317   {
318     return distributionConfigs.length;
319   }
320 
321   /**
322     Public
323    */
324 
325   function addDistributionConfig(
326     address lockedWallet,
327     address unlockWallet,
328     uint256 ratioDTV,
329     uint256 ratioDecimals
330   ) public onlyPauser {
331     require(lockedWallet != address(0), "lockedWallet address cannot be zero");
332     require(unlockWallet != address(0), "unlockWallet address cannot be zero");
333     require(lockedWallet != unlockWallet, "lockedWallet and unlockWallet addresses cannot be the same");
334     require(ratioDTV > 0, "ratioDTV cannot be zero");
335     require(ratioDecimals > 0, "ratioDecimals cannot be zero");
336     distributionConfigs.push(DistributionConfig({
337       lockedWallet: lockedWallet,
338       unlockWallet: unlockWallet,
339       ratioDTV: ratioDTV,
340       ratioDecimals: ratioDecimals
341     }));
342     emit DistributionConfigAdded(
343       lockedWallet,
344       unlockWallet,
345       ratioDTV,
346       ratioDecimals
347     );
348   }
349 
350   function editDistributionConfig(
351     uint256 index,
352     uint256 ratioDTV,
353     uint256 ratioDecimals
354   ) public onlyPauser {
355     require(index < distributionConfigs.length, "index is out of bound");
356     require(ratioDTV > 0, "ratioDTV cannot be zero");
357     require(ratioDecimals > 0, "ratioDecimals cannot be zero");
358     emit DistributionConfigEdited(
359       index,
360       distributionConfigs[index].lockedWallet,
361       distributionConfigs[index].unlockWallet,
362       distributionConfigs[index].ratioDTV,
363       distributionConfigs[index].ratioDecimals,
364       ratioDTV,
365       ratioDecimals
366     );
367     distributionConfigs[index].ratioDTV = ratioDTV;
368     distributionConfigs[index].ratioDecimals = ratioDecimals;
369   }
370 
371   function deleteDistributionConfig(
372     uint256 index
373   ) public onlyPauser {
374     require(index < distributionConfigs.length, "index is out of bound");
375     emit DistributionConfigDeleted(
376       index,
377       distributionConfigs[index].lockedWallet,
378       distributionConfigs[index].unlockWallet,
379       distributionConfigs[index].ratioDTV,
380       distributionConfigs[index].ratioDecimals
381     );
382     // Replace the element to delete and shift elements of the array.
383     for (uint i = index; i<distributionConfigs.length-1; i++){
384       distributionConfigs[i] = distributionConfigs[i+1];
385     }
386     distributionConfigs.length--;
387   }
388 
389 }
390 
391 
392 /**
393  * @title Roles
394  * @dev Library for managing addresses assigned to a Role.
395  */
396 library Roles {
397     struct Role {
398         mapping (address => bool) bearer;
399     }
400 
401     /**
402      * @dev give an account access to this role
403      */
404     function add(Role storage role, address account) internal {
405         require(account != address(0));
406         require(!has(role, account));
407 
408         role.bearer[account] = true;
409     }
410 
411     /**
412      * @dev remove an account's access to this role
413      */
414     function remove(Role storage role, address account) internal {
415         require(account != address(0));
416         require(has(role, account));
417 
418         role.bearer[account] = false;
419     }
420 
421     /**
422      * @dev check if an account has this role
423      * @return bool
424      */
425     function has(Role storage role, address account) internal view returns (bool) {
426         require(account != address(0));
427         return role.bearer[account];
428     }
429 }
430 
431 contract ATD is Pausable, SignerRole, DistributionConfigurable {
432   using SafeMath for uint256;
433 
434   /**
435     State variables
436    */
437 
438   ERC20Detailed public token;
439 
440   /**
441     Constructor
442    */
443 
444   constructor(
445     ERC20Detailed _token
446   ) public {
447     token = _token;
448   }
449 
450   /**
451     Events
452    */
453 
454   event Distributed(
455     uint256 indexed date,
456     address indexed lockedWallet,
457     address indexed unlockWallet,
458     uint256 ratioDTV,
459     uint256 ratioDecimals,
460     uint256 dailyTradedVolume,
461     uint256 amount
462   );
463 
464   event TotalDistributed(
465     uint256 indexed date,
466     uint256 dailyTradedVolume,
467     uint256 amount
468   );
469 
470   /**
471     Publics
472    */
473 
474   function distribute(
475     uint256 dailyTradedVolume
476   ) public whenNotPaused onlySigner {
477     require(
478       dailyTradedVolume.div(10 ** uint256(token.decimals())) > 0,
479       "dailyTradedVolume is not in token unit"
480     );
481     uint256 total = 0;
482     for (uint256 i = 0; i < distributionConfigs.length; i++) {
483       DistributionConfig storage dc = distributionConfigs[i];
484       uint256 amount = dailyTradedVolume.mul(dc.ratioDTV).div(10 ** dc.ratioDecimals);
485       token.transferFrom(dc.lockedWallet, dc.unlockWallet, amount);
486       total = total.add(amount);
487       emit Distributed(
488         now,
489         dc.lockedWallet,
490         dc.unlockWallet,
491         dc.ratioDTV,
492         dc.ratioDecimals,
493         dailyTradedVolume,
494         amount
495       );
496     }
497     emit TotalDistributed(now, dailyTradedVolume, total);
498   }
499 
500   /**
501     Publics
502    */
503 
504   function destroy() public onlyPauser {
505     selfdestruct(msg.sender);
506   }
507 
508 }