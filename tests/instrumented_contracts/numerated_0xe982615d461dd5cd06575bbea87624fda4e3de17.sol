1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6 * Copyright CENTRE SECZ 2018
7 *
8 * Permission is hereby granted, free of charge, to any person obtaining a copy 
9 * of this software and associated documentation files (the "Software"), to deal 
10 * in the Software without restriction, including without limitation the rights 
11 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
12 * copies of the Software, and to permit persons to whom the Software is furnished to 
13 * do so, subject to the following conditions:
14 *
15 * The above copyright notice and this permission notice shall be included in all 
16 * copies or substantial portions of the Software.
17 *
18 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
19 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
20 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
21 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
22 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
23 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
24 */
25 
26 pragma solidity ^0.4.24;
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract from https://github.com/zeppelinos/labs/blob/master/upgradeability_ownership/contracts/ownership/Ownable.sol 
31  * branch: master commit: 3887ab77b8adafba4a26ace002f3a684c1a3388b modified to:
32  * 1) Add emit prefix to OwnershipTransferred event (7/13/18)
33  * 2) Replace constructor with constructor syntax (7/13/18)
34  * 3) consolidate OwnableStorage into this contract
35  */
36 contract Ownable {
37 
38   // Owner of the contract
39   address private _owner;
40 
41   /**
42   * @dev Event to show ownership has been transferred
43   * @param previousOwner representing the address of the previous owner
44   * @param newOwner representing the address of the new owner
45   */
46   event OwnershipTransferred(address previousOwner, address newOwner);
47 
48   /**
49   * @dev The constructor sets the original owner of the contract to the sender account.
50   */
51   constructor() public {
52     setOwner(msg.sender);
53   }
54 
55   /**
56  * @dev Tells the address of the owner
57  * @return the address of the owner
58  */
59   function owner() public view returns (address) {
60     return _owner;
61   }
62 
63   /**
64    * @dev Sets a new owner address
65    */
66   function setOwner(address newOwner) internal {
67     _owner = newOwner;
68   }
69 
70   /**
71   * @dev Throws if called by any account other than the owner.
72   */
73   modifier onlyOwner() {
74     require(msg.sender == owner());
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner(), newOwner);
85     setOwner(newOwner);
86   }
87 }
88 
89 // File: contracts/minting/Controller.sol
90 
91 /**
92 * Copyright CENTRE SECZ 2018
93 *
94 * Permission is hereby granted, free of charge, to any person obtaining a copy
95 * of this software and associated documentation files (the "Software"), to deal
96 * in the Software without restriction, including without limitation the rights
97 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
98 * copies of the Software, and to permit persons to whom the Software is
99 * furnished to do so, subject to the following conditions:
100 *
101 * The above copyright notice and this permission notice shall be included in all
102 * copies or substantial portions of the Software.
103 *
104 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
105 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
106 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
107 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
108 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
109 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
110 * THE SOFTWARE.
111 */
112 
113 pragma solidity ^0.4.24;
114 
115 
116 /**
117  * @title Controller
118  * @notice Generic implementation of the owner-controller-worker model.
119  * One owner manages many controllers. Each controller manages one worker.
120  * Workers may be reused across different controllers.
121  */
122 contract Controller is Ownable {
123     /**
124      * @notice A controller manages a single worker address.
125      * controllers[controller] = worker
126      */
127     mapping(address => address) internal controllers;
128 
129     event ControllerConfigured(
130         address indexed _controller,
131         address indexed _worker
132     );
133     event ControllerRemoved(address indexed _controller);
134 
135     /**
136      * @notice Ensures that caller is the controller of a non-zero worker 
137      * address.
138      */
139     modifier onlyController() {
140         require(controllers[msg.sender] != address(0), 
141             "The value of controllers[msg.sender] must be non-zero");
142         _;
143     }
144 
145     /**
146      * @notice Gets the worker at address _controller.
147      */
148     function getWorker(
149         address _controller
150     )
151         external
152         view
153         returns (address)
154     {
155         return controllers[_controller];
156     }
157 
158     // onlyOwner functions
159 
160     /**
161      * @notice Configure a controller with the given worker.
162      * @param _controller The controller to be configured with a worker.
163      * @param _worker The worker to be set for the newly configured controller.
164      * _worker must not be a non-zero address. To disable a worker,
165      * use removeController instead.
166      */
167     function configureController(
168         address _controller,
169         address _worker
170     )
171         public 
172         onlyOwner 
173     {
174         require(_controller != address(0), 
175             "Controller must be a non-zero address");
176         require(_worker != address(0), "Worker must be a non-zero address");
177         controllers[_controller] = _worker;
178         emit ControllerConfigured(_controller, _worker);
179     }
180 
181     /**
182      * @notice disables a controller by setting its worker to address(0).
183      * @param _controller The controller to disable.
184      */
185     function removeController(
186         address _controller
187     )
188         public 
189         onlyOwner 
190     {
191         require(_controller != address(0), 
192             "Controller must be a non-zero address");
193         require(controllers[_controller] != address(0), 
194             "Worker must be a non-zero address");
195         controllers[_controller] = address(0);
196         emit ControllerRemoved(_controller);
197     }
198 }
199 
200 // File: contracts/minting/MinterManagementInterface.sol
201 
202 /**
203 * Copyright CENTRE SECZ 2019
204 *
205 * Permission is hereby granted, free of charge, to any person obtaining a copy
206 * of this software and associated documentation files (the "Software"), to deal
207 * in the Software without restriction, including without limitation the rights
208 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
209 * copies of the Software, and to permit persons to whom the Software is
210 * furnished to do so, subject to the following conditions:
211 *
212 * The above copyright notice and this permission notice shall be included in all
213 * copies or substantial portions of the Software.
214 *
215 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
216 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
217 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
218 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
219 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
220 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
221 * THE SOFTWARE.
222 */
223 
224 pragma solidity ^0.4.24;
225 
226 /** 
227  * @notice A contract that implements the MinterManagementInterface has external 
228  * functions for adding and removing minters and modifying their allowances. 
229  * An example is the FiatTokenV1 contract that implements USDC.
230  */
231 interface MinterManagementInterface {
232     function isMinter(address _account) external view returns (bool);
233     function minterAllowance(address _minter) external view returns (uint256);
234 
235     function configureMinter(
236         address _minter,
237         uint256 _minterAllowedAmount
238     )
239         external
240         returns (bool);
241 
242     function removeMinter(address _minter) external returns (bool);
243 }
244 
245 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
246 
247 /**
248  * @title SafeMath
249  * @dev Math operations with safety checks that throw on error
250  */
251 library SafeMath {
252 
253   /**
254   * @dev Multiplies two numbers, throws on overflow.
255   */
256   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
257     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
258     // benefit is lost if 'b' is also tested.
259     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
260     if (a == 0) {
261       return 0;
262     }
263 
264     c = a * b;
265     assert(c / a == b);
266     return c;
267   }
268 
269   /**
270   * @dev Integer division of two numbers, truncating the quotient.
271   */
272   function div(uint256 a, uint256 b) internal pure returns (uint256) {
273     // assert(b > 0); // Solidity automatically throws when dividing by 0
274     // uint256 c = a / b;
275     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276     return a / b;
277   }
278 
279   /**
280   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
281   */
282   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283     assert(b <= a);
284     return a - b;
285   }
286 
287   /**
288   * @dev Adds two numbers, throws on overflow.
289   */
290   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
291     c = a + b;
292     assert(c >= a);
293     return c;
294   }
295 }
296 
297 // File: contracts/minting/MintController.sol
298 
299 /**
300 * Copyright CENTRE SECZ 2018
301 *
302 * Permission is hereby granted, free of charge, to any person obtaining a copy
303 * of this software and associated documentation files (the "Software"), to deal
304 * in the Software without restriction, including without limitation the rights
305 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
306 * copies of the Software, and to permit persons to whom the Software is
307 * furnished to do so, subject to the following conditions:
308 *
309 * The above copyright notice and this permission notice shall be included in all
310 * copies or substantial portions of the Software.
311 *
312 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
313 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
314 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
315 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
316 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
317 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
318 * THE SOFTWARE.
319 */
320 
321 pragma solidity ^0.4.24;
322 
323 
324 
325 
326 /**
327  * @title MintController
328  * @notice The MintController contract manages minters for a contract that 
329  * implements the MinterManagerInterface. It lets the owner designate certain 
330  * addresses as controllers, and these controllers then manage the 
331  * minters by adding and removing minters, as well as modifying their minting 
332  * allowance. A controller may manage exactly one minter, but the same minter 
333  * address may be managed by multiple controllers.
334  * @dev MintController inherits from the Controller contract. It treats the 
335  * Controller workers as minters.
336  */
337 contract MintController is Controller {
338     using SafeMath for uint256;
339 
340     /**
341     * @title MinterManagementInterface
342     * @notice MintController calls the minterManager to execute/record minter 
343     * management tasks, as well as to query the status of a minter address.
344     */
345     MinterManagementInterface internal minterManager;
346 
347     event MinterManagerSet(
348         address indexed _oldMinterManager,
349         address indexed _newMinterManager
350     );
351     event MinterConfigured(
352         address indexed _msgSender,
353         address indexed _minter,
354         uint256 _allowance
355     );
356     event MinterRemoved(
357         address indexed _msgSender,
358         address indexed _minter
359     );
360     event MinterAllowanceIncremented(
361         address indexed _msgSender,
362         address indexed _minter,
363         uint256 _increment,
364         uint256 _newAllowance
365     );
366 
367     event MinterAllowanceDecremented(
368         address indexed msgSender,
369         address indexed minter,
370         uint256 decrement,
371         uint256 newAllowance
372     );
373 
374     /**
375      * @notice Initializes the minterManager.
376      * @param _minterManager The address of the minterManager contract.
377      */
378     constructor(address _minterManager) public {
379         minterManager = MinterManagementInterface(_minterManager);
380     }
381 
382     /**
383      * @notice gets the minterManager
384      */
385     function getMinterManager(
386     )
387         external
388         view
389         returns (MinterManagementInterface)
390     {
391         return minterManager;
392     }
393 
394     // onlyOwner functions
395 
396     /**
397      * @notice Sets the minterManager.
398      * @param _newMinterManager The address of the new minterManager contract.
399      */
400     function setMinterManager(
401         address _newMinterManager
402     )
403         public
404         onlyOwner
405     {
406         emit MinterManagerSet(address(minterManager), _newMinterManager);
407         minterManager = MinterManagementInterface(_newMinterManager);
408     }
409 
410     // onlyController functions
411 
412     /**
413      * @notice Removes the controller's own minter.
414      */
415     function removeMinter() public onlyController returns (bool) {
416         address minter = controllers[msg.sender];
417         emit MinterRemoved(msg.sender, minter);
418         return minterManager.removeMinter(minter);
419     }
420 
421     /**
422      * @notice Enables the minter and sets its allowance.
423      * @param _newAllowance New allowance to be set for minter.
424      */
425     function configureMinter(
426         uint256 _newAllowance
427     )
428         public
429         onlyController
430         returns (bool)
431     {
432         address minter = controllers[msg.sender];
433         emit MinterConfigured(msg.sender, minter, _newAllowance);
434         return internal_setMinterAllowance(minter, _newAllowance);
435     }
436 
437     /**
438      * @notice Increases the minter's allowance if and only if the minter is an 
439      * active minter.
440      * @dev An minter is considered active if minterManager.isMinter(minter) 
441      * returns true.
442      */
443     function incrementMinterAllowance(
444         uint256 _allowanceIncrement
445     )
446         public
447         onlyController
448         returns (bool)
449     {
450         require(_allowanceIncrement > 0, 
451             "Allowance increment must be greater than 0");
452         address minter = controllers[msg.sender];
453         require(minterManager.isMinter(minter), 
454             "Can only increment allowance for minters in minterManager");
455 
456         uint256 currentAllowance = minterManager.minterAllowance(minter);
457         uint256 newAllowance = currentAllowance.add(_allowanceIncrement);
458 
459         emit MinterAllowanceIncremented(
460             msg.sender,
461             minter,
462             _allowanceIncrement,
463             newAllowance
464         );
465 
466         return internal_setMinterAllowance(minter, newAllowance);
467     }
468 
469     /**
470      * @notice decreases the minter allowance if and only if the minter is
471      * currently active. The controller can safely send a signed 
472      * decrementMinterAllowance() transaction to a minter and not worry 
473      * about it being used to undo a removeMinter() transaction.
474      */
475     function decrementMinterAllowance(
476         uint256 _allowanceDecrement
477     )
478         public
479         onlyController
480         returns (bool)
481     {
482         require(_allowanceDecrement > 0, 
483             "Allowance decrement must be greater than 0");
484         address minter = controllers[msg.sender];
485         require(minterManager.isMinter(minter), 
486             "Can only decrement allowance for minters in minterManager");
487 
488         uint256 currentAllowance = minterManager.minterAllowance(minter);
489         uint256 actualAllowanceDecrement = (
490             currentAllowance > _allowanceDecrement ? 
491             _allowanceDecrement : currentAllowance
492         );
493         uint256 newAllowance = currentAllowance.sub(actualAllowanceDecrement);
494 
495         emit MinterAllowanceDecremented(
496             msg.sender,
497             minter,
498             actualAllowanceDecrement,
499             newAllowance
500         );
501 
502         return internal_setMinterAllowance(minter, newAllowance);
503     }
504 
505     // Internal functions
506 
507     /**
508      * @notice Uses the MinterManagementInterface to enable the minter and
509      * set its allowance.
510      * @param _minter Minter to set new allowance of.
511      * @param _newAllowance New allowance to be set for minter.
512      */
513     function internal_setMinterAllowance(
514         address _minter,
515         uint256 _newAllowance
516     )
517         internal
518         returns (bool)
519     {
520         return minterManager.configureMinter(_minter, _newAllowance);
521     }
522 }
523 
524 // File: contracts/minting/MasterMinter.sol
525 
526 /**
527 * Copyright CENTRE SECZ 2018
528 *
529 * Permission is hereby granted, free of charge, to any person obtaining a copy
530 * of this software and associated documentation files (the "Software"), to deal
531 * in the Software without restriction, including without limitation the rights
532 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
533 * copies of the Software, and to permit persons to whom the Software is
534 * furnished to do so, subject to the following conditions:
535 *
536 * The above copyright notice and this permission notice shall be included in all
537 * copies or substantial portions of the Software.
538 *
539 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
540 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
541 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
542 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
543 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
544 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
545 * THE SOFTWARE.
546 */
547 
548 pragma solidity ^0.4.24;
549 
550 
551 /**
552  * @title MasterMinter
553  * @notice MasterMinter uses multiple controllers to manage minters for a 
554  * contract that implements the MinterManagerInterface.
555  * @dev MasterMinter inherits all its functionality from MintController.
556  */
557 contract MasterMinter is MintController {
558 
559     constructor(address _minterManager) MintController(_minterManager) public {
560     }
561 }