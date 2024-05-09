1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
28 
29 pragma solidity ^0.5.2;
30 
31 
32 /**
33  * @title ERC20Detailed token
34  * @dev The decimals are only for visualization purposes.
35  * All the operations are done using the smallest and indivisible token unit,
36  * just as on Ethereum all the operations are done in wei.
37  */
38 contract ERC20Detailed is IERC20 {
39     string private _name;
40     string private _symbol;
41     uint8 private _decimals;
42 
43     constructor (string memory name, string memory symbol, uint8 decimals) public {
44         _name = name;
45         _symbol = symbol;
46         _decimals = decimals;
47     }
48 
49     /**
50      * @return the name of the token.
51      */
52     function name() public view returns (string memory) {
53         return _name;
54     }
55 
56     /**
57      * @return the symbol of the token.
58      */
59     function symbol() public view returns (string memory) {
60         return _symbol;
61     }
62 
63     /**
64      * @return the number of decimals of the token.
65      */
66     function decimals() public view returns (uint8) {
67         return _decimals;
68     }
69 }
70 
71 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
72 
73 pragma solidity ^0.5.2;
74 
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 
139 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
140 
141 pragma solidity ^0.5.2;
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://eips.ethereum.org/EIPS/eip-20
150  * Originally based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  *
153  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
154  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
155  * compliant implementations may not do it.
156  */
157 contract ERC20 is IERC20 {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowed;
163 
164     uint256 private _totalSupply;
165 
166     /**
167      * @dev Total number of tokens in existence
168      */
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174      * @dev Gets the balance of the specified address.
175      * @param owner The address to query the balance of.
176      * @return A uint256 representing the amount owned by the passed address.
177      */
178     function balanceOf(address owner) public view returns (uint256) {
179         return _balances[owner];
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param owner address The address which owns the funds.
185      * @param spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address owner, address spender) public view returns (uint256) {
189         return _allowed[owner][spender];
190     }
191 
192     /**
193      * @dev Transfer token to a specified address
194      * @param to The address to transfer to.
195      * @param value The amount to be transferred.
196      */
197     function transfer(address to, uint256 value) public returns (bool) {
198         _transfer(msg.sender, to, value);
199         return true;
200     }
201 
202     /**
203      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param spender The address which will spend the funds.
209      * @param value The amount of tokens to be spent.
210      */
211     function approve(address spender, uint256 value) public returns (bool) {
212         _approve(msg.sender, spender, value);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another.
218      * Note that while this function emits an Approval event, this is not required as per the specification,
219      * and other compliant implementations may not emit the event.
220      * @param from address The address which you want to send tokens from
221      * @param to address The address which you want to transfer to
222      * @param value uint256 the amount of tokens to be transferred
223      */
224     function transferFrom(address from, address to, uint256 value) public returns (bool) {
225         _transfer(from, to, value);
226         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
227         return true;
228     }
229 
230     /**
231      * @dev Increase the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param addedValue The amount of tokens to increase the allowance by.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner allowed to a spender.
247      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param subtractedValue The amount of tokens to decrease the allowance by.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
256         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
257         return true;
258     }
259 
260     /**
261      * @dev Transfer token for a specified addresses
262      * @param from The address to transfer from.
263      * @param to The address to transfer to.
264      * @param value The amount to be transferred.
265      */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Approve an address to spend another addresses' tokens.
305      * @param owner The address that owns the tokens.
306      * @param spender The address that will spend the tokens.
307      * @param value The number of tokens that can be spent.
308      */
309     function _approve(address owner, address spender, uint256 value) internal {
310         require(spender != address(0));
311         require(owner != address(0));
312 
313         _allowed[owner][spender] = value;
314         emit Approval(owner, spender, value);
315     }
316 
317     /**
318      * @dev Internal function that burns an amount of the token of a given
319      * account, deducting from the sender's allowance for said account. Uses the
320      * internal burn function.
321      * Emits an Approval event (reflecting the reduced allowance).
322      * @param account The account whose tokens will be burnt.
323      * @param value The amount that will be burnt.
324      */
325     function _burnFrom(address account, uint256 value) internal {
326         _burn(account, value);
327         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
328     }
329 }
330 
331 // File: contracts/lib/CommonValidationsLibrary.sol
332 
333 /*
334     Copyright 2018 Set Labs Inc.
335 
336     Licensed under the Apache License, Version 2.0 (the "License");
337     you may not use this file except in compliance with the License.
338     You may obtain a copy of the License at
339 
340     http://www.apache.org/licenses/LICENSE-2.0
341 
342     Unless required by applicable law or agreed to in writing, software
343     distributed under the License is distributed on an "AS IS" BASIS,
344     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
345     See the License for the specific language governing permissions and
346     limitations under the License.
347 */
348 
349 pragma solidity 0.5.7;
350 
351 
352 library CommonValidationsLibrary {
353 
354     /**
355      * Ensures that an address array is not empty.
356      *
357      * @param  _addressArray       Address array input
358      */
359     function validateNonEmpty(
360         address[] calldata _addressArray
361     )
362         external
363         pure
364     {
365         require(
366             _addressArray.length > 0,
367             "Address array length must be > 0"
368         );
369     }
370 
371     /**
372      * Ensures that an address array and uint256 array are equal length
373      *
374      * @param  _addressArray       Address array input
375      * @param  _uint256Array       Uint256 array input
376      */
377     function validateEqualLength(
378         address[] calldata _addressArray,
379         uint256[] calldata _uint256Array
380     )
381         external
382         pure
383     {
384         require(
385             _addressArray.length == _uint256Array.length,
386             "Input length mismatch"
387         );
388     }
389 }
390 
391 // File: contracts/lib/CommonMath.sol
392 
393 /*
394     Copyright 2018 Set Labs Inc.
395 
396     Licensed under the Apache License, Version 2.0 (the "License");
397     you may not use this file except in compliance with the License.
398     You may obtain a copy of the License at
399 
400     http://www.apache.org/licenses/LICENSE-2.0
401 
402     Unless required by applicable law or agreed to in writing, software
403     distributed under the License is distributed on an "AS IS" BASIS,
404     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
405     See the License for the specific language governing permissions and
406     limitations under the License.
407 */
408 
409 pragma solidity 0.5.7;
410 
411 
412 
413 library CommonMath {
414     using SafeMath for uint256;
415 
416     /**
417      * Calculates and returns the maximum value for a uint256
418      *
419      * @return  The maximum value for uint256
420      */
421     function maxUInt256()
422         internal
423         pure
424         returns (uint256)
425     {
426         return 2 ** 256 - 1;
427     }
428 
429     /**
430     * @dev Performs the power on a specified value, reverts on overflow.
431     */
432     function safePower(
433         uint256 a,
434         uint256 pow
435     )
436         internal
437         pure
438         returns (uint256)
439     {
440         require(a > 0);
441 
442         uint256 result = 1;
443         for (uint256 i = 0; i < pow; i++){
444             uint256 previousResult = result;
445 
446             // Using safemath multiplication prevents overflows
447             result = previousResult.mul(a);
448         }
449 
450         return result;
451     }
452 
453     /**
454      * Checks for rounding errors and returns value of potential partial amounts of a principal
455      *
456      * @param  _principal       Number fractional amount is derived from
457      * @param  _numerator       Numerator of fraction
458      * @param  _denominator     Denominator of fraction
459      * @return uint256          Fractional amount of principal calculated
460      */
461     function getPartialAmount(
462         uint256 _principal,
463         uint256 _numerator,
464         uint256 _denominator
465     )
466         internal
467         pure
468         returns (uint256)
469     {
470         // Get remainder of partial amount (if 0 not a partial amount)
471         uint256 remainder = mulmod(_principal, _numerator, _denominator);
472 
473         // Return if not a partial amount
474         if (remainder == 0) {
475             return _principal.mul(_numerator).div(_denominator);
476         }
477 
478         // Calculate error percentage
479         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
480 
481         // Require error percentage is less than 0.1%.
482         require(
483             errPercentageTimes1000000 < 1000,
484             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
485         );
486 
487         return _principal.mul(_numerator).div(_denominator);
488     }
489 
490 }
491 
492 // File: contracts/core/interfaces/ISetFactory.sol
493 
494 /*
495     Copyright 2018 Set Labs Inc.
496 
497     Licensed under the Apache License, Version 2.0 (the "License");
498     you may not use this file except in compliance with the License.
499     You may obtain a copy of the License at
500 
501     http://www.apache.org/licenses/LICENSE-2.0
502 
503     Unless required by applicable law or agreed to in writing, software
504     distributed under the License is distributed on an "AS IS" BASIS,
505     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
506     See the License for the specific language governing permissions and
507     limitations under the License.
508 */
509 
510 pragma solidity 0.5.7;
511 
512 
513 /**
514  * @title ISetFactory
515  * @author Set Protocol
516  *
517  * The ISetFactory interface provides operability for authorized contracts
518  * to interact with SetTokenFactory
519  */
520 interface ISetFactory {
521 
522     /* ============ External Functions ============ */
523 
524     /**
525      * Return core address
526      *
527      * @return address        core address
528      */
529     function core()
530         external
531         returns (address);
532 
533     /**
534      * Deploys a new Set Token and adds it to the valid list of SetTokens
535      *
536      * @param  _components           The address of component tokens
537      * @param  _units                The units of each component token
538      * @param  _naturalUnit          The minimum unit to be issued or redeemed
539      * @param  _name                 The bytes32 encoded name of the new Set
540      * @param  _symbol               The bytes32 encoded symbol of the new Set
541      * @param  _callData             Byte string containing additional call parameters
542      * @return setTokenAddress       The address of the new Set
543      */
544     function createSet(
545         address[] calldata _components,
546         uint[] calldata _units,
547         uint256 _naturalUnit,
548         bytes32 _name,
549         bytes32 _symbol,
550         bytes calldata _callData
551     )
552         external
553         returns (address);
554 }
555 
556 // File: contracts/core/tokens/SetToken.sol
557 
558 /*
559     Copyright 2018 Set Labs Inc.
560 
561     Licensed under the Apache License, Version 2.0 (the "License");
562     you may not use this file except in compliance with the License.
563     You may obtain a copy of the License at
564 
565     http://www.apache.org/licenses/LICENSE-2.0
566 
567     Unless required by applicable law or agreed to in writing, software
568     distributed under the License is distributed on an "AS IS" BASIS,
569     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
570     See the License for the specific language governing permissions and
571     limitations under the License.
572 */
573 
574 pragma solidity 0.5.7;
575 
576 
577 
578 
579 
580 
581 
582 
583 /**
584  * @title SetToken
585  * @author Set Protocol
586  *
587  * Implementation of the basic Set token.
588  */
589 contract SetToken is
590     ERC20,
591     ERC20Detailed
592 {
593     using SafeMath for uint256;
594 
595     /* ============ State Variables ============ */
596 
597     uint256 public naturalUnit;
598     address[] public components;
599     uint256[] public units;
600 
601     // Mapping of componentHash to isComponent
602     mapping(address => bool) internal isComponent;
603 
604     // Address of the Factory contract that created the SetToken
605     address public factory;
606 
607     /* ============ Constructor ============ */
608 
609     /**
610      * Constructor function for Set token
611      *
612      * As looping operations are expensive, checking for duplicates will be on the onus of the application developer
613      *
614      * @param _factory          The factory used to create the Set Token
615      * @param _components       A list of component address which you want to include
616      * @param _units            A list of quantities of each component (corresponds to the Set of _components)
617      * @param _naturalUnit      The minimum multiple of Sets that can be issued or redeemed
618      * @param _name             The Set's name
619      * @param _symbol           The Set's symbol
620      */
621     constructor(
622         address _factory,
623         address[] memory _components,
624         uint256[] memory _units,
625         uint256 _naturalUnit,
626         string memory _name,
627         string memory _symbol
628     )
629         public
630         ERC20Detailed(
631             _name,
632             _symbol,
633             18
634         )
635     {
636         // Storing count and unit counts to local variable to save on invocation
637         uint256 unitCount = _units.length;
638 
639         // Require naturalUnit passed is greater than 0
640         require(
641             _naturalUnit > 0,
642             "SetToken.constructor: Natural unit must be positive"
643         );
644 
645         // Confirm an empty _components array is not passed
646         CommonValidationsLibrary.validateNonEmpty(_components);
647 
648         // Confirm there is one quantity for every token address
649         CommonValidationsLibrary.validateEqualLength(_components, _units);
650 
651         // NOTE: It will be the onus of developers to check whether the addressExists
652         // are in fact ERC20 addresses
653         uint8 minDecimals = 18;
654         uint8 currentDecimals;
655         for (uint256 i = 0; i < unitCount; i++) {
656             // Check that all units are non-zero
657             uint256 currentUnits = _units[i];
658             require(
659                 currentUnits > 0,
660                 "SetToken.constructor: Units must be positive"
661             );
662 
663             // Check that all addresses are non-zero
664             address currentComponent = _components[i];
665             require(
666                 currentComponent != address(0),
667                 "SetToken.constructor: Invalid component address"
668             );
669 
670             // Figure out which of the components has the minimum decimal value
671             /* solium-disable-next-line security/no-low-level-calls */
672             (bool success, ) = currentComponent.call(abi.encodeWithSignature("decimals()"));
673             if (success) {
674                 currentDecimals = ERC20Detailed(currentComponent).decimals();
675                 minDecimals = currentDecimals < minDecimals ? currentDecimals : minDecimals;
676             } else {
677                 // If one of the components does not implement decimals, we assume the worst
678                 // and set minDecimals to 0
679                 minDecimals = 0;
680             }
681 
682             // Check the component has not already been added
683             require(
684                 !tokenIsComponent(currentComponent),
685                 "SetToken.constructor: Duplicated component"
686             );
687 
688             // Add component to isComponent mapping
689             isComponent[currentComponent] = true;
690 
691             // Add component data to components and units state variables
692             components.push(currentComponent);
693             units.push(currentUnits);
694         }
695 
696         // This is the minimum natural unit possible for a Set with these components.
697         require(
698             _naturalUnit >= CommonMath.safePower(10, uint256(18).sub(minDecimals)),
699             "SetToken.constructor: Invalid natural unit"
700         );
701 
702         factory = _factory;
703         naturalUnit = _naturalUnit;
704     }
705 
706     /* ============ Public Functions ============ */
707 
708     /*
709      * Mint set token for given address.
710      * Can only be called by authorized contracts.
711      *
712      * @param  _issuer      The address of the issuing account
713      * @param  _quantity    The number of sets to attribute to issuer
714      */
715     function mint(
716         address _issuer,
717         uint256 _quantity
718     )
719         external
720     {
721         // Check that function caller is Core
722         require(
723             msg.sender == ISetFactory(factory).core(),
724             "SetToken.mint: Sender must be core"
725         );
726 
727         _mint(_issuer, _quantity);
728     }
729 
730     /*
731      * Burn set token for given address.
732      * Can only be called by authorized contracts.
733      *
734      * @param  _from        The address of the redeeming account
735      * @param  _quantity    The number of sets to burn from redeemer
736      */
737     function burn(
738         address _from,
739         uint256 _quantity
740     )
741         external
742     {
743         // Check that function caller is Core
744         require(
745             msg.sender == ISetFactory(factory).core(),
746             "SetToken.burn: Sender must be core"
747         );
748 
749         _burn(_from, _quantity);
750     }
751 
752     /*
753      * Get addresses of all components in the Set
754      *
755      * @return  componentAddresses       Array of component tokens
756      */
757     function getComponents()
758         external
759         view
760         returns (address[] memory)
761     {
762         return components;
763     }
764 
765     /*
766      * Get units of all tokens in Set
767      *
768      * @return  units       Array of component units
769      */
770     function getUnits()
771         external
772         view
773         returns (uint256[] memory)
774     {
775         return units;
776     }
777 
778     /*
779      * Validates address is member of Set's components
780      *
781      * @param  _tokenAddress     Address of token being checked
782      * @return  bool             Whether token is member of Set's components
783      */
784     function tokenIsComponent(
785         address _tokenAddress
786     )
787         public
788         view
789         returns (bool)
790     {
791         return isComponent[_tokenAddress];
792     }
793 }