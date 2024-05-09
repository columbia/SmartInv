1 pragma solidity ^0.5.4;
2 
3 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 
19 /**
20  * @title Module
21  * @dev Interface for a module.
22  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
23  * can never end up in a "frozen" state.
24  * @author Julien Niset - <julien@argent.xyz>
25  */
26 interface Module {
27 
28     /**
29      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
30      * @param _wallet The wallet.
31      */
32     function init(BaseWallet _wallet) external;
33 
34     /**
35      * @dev Adds a module to a wallet.
36      * @param _wallet The target wallet.
37      * @param _module The modules to authorise.
38      */
39     function addModule(BaseWallet _wallet, Module _module) external;
40 
41     /**
42     * @dev Utility method to recover any ERC20 token that was sent to the
43     * module by mistake.
44     * @param _token The token to recover.
45     */
46     function recoverToken(address _token) external;
47 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
48 
49 // This program is free software: you can redistribute it and/or modify
50 // it under the terms of the GNU General Public License as published by
51 // the Free Software Foundation, either version 3 of the License, or
52 // (at your option) any later version.
53 
54 // This program is distributed in the hope that it will be useful,
55 // but WITHOUT ANY WARRANTY; without even the implied warranty of
56 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
57 // GNU General Public License for more details.
58 
59 // You should have received a copy of the GNU General Public License
60 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
61 
62 
63 /**
64  * @title BaseWallet
65  * @dev Simple modular wallet that authorises modules to call its invoke() method.
66  * @author Julien Niset - <julien@argent.xyz>
67  */
68 contract BaseWallet {
69 
70     // The implementation of the proxy
71     address public implementation;
72     // The owner
73     address public owner;
74     // The authorised modules
75     mapping (address => bool) public authorised;
76     // The enabled static calls
77     mapping (bytes4 => address) public enabled;
78     // The number of modules
79     uint public modules;
80 
81     event AuthorisedModule(address indexed module, bool value);
82     event EnabledStaticCall(address indexed module, bytes4 indexed method);
83     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
84     event Received(uint indexed value, address indexed sender, bytes data);
85     event OwnerChanged(address owner);
86 
87     /**
88      * @dev Throws if the sender is not an authorised module.
89      */
90     modifier moduleOnly {
91         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
92         _;
93     }
94 
95     /**
96      * @dev Inits the wallet by setting the owner and authorising a list of modules.
97      * @param _owner The owner.
98      * @param _modules The modules to authorise.
99      */
100     function init(address _owner, address[] calldata _modules) external {
101         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
102         require(_modules.length > 0, "BW: construction requires at least 1 module");
103         owner = _owner;
104         modules = _modules.length;
105         for (uint256 i = 0; i < _modules.length; i++) {
106             require(authorised[_modules[i]] == false, "BW: module is already added");
107             authorised[_modules[i]] = true;
108             Module(_modules[i]).init(this);
109             emit AuthorisedModule(_modules[i], true);
110         }
111         if (address(this).balance > 0) {
112             emit Received(address(this).balance, address(0), "");
113         }
114     }
115 
116     /**
117      * @dev Enables/Disables a module.
118      * @param _module The target module.
119      * @param _value Set to true to authorise the module.
120      */
121     function authoriseModule(address _module, bool _value) external moduleOnly {
122         if (authorised[_module] != _value) {
123             emit AuthorisedModule(_module, _value);
124             if (_value == true) {
125                 modules += 1;
126                 authorised[_module] = true;
127                 Module(_module).init(this);
128             } else {
129                 modules -= 1;
130                 require(modules > 0, "BW: wallet must have at least one module");
131                 delete authorised[_module];
132             }
133         }
134     }
135 
136     /**
137     * @dev Enables a static method by specifying the target module to which the call
138     * must be delegated.
139     * @param _module The target module.
140     * @param _method The static method signature.
141     */
142     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
143         require(authorised[_module], "BW: must be an authorised module for static call");
144         enabled[_method] = _module;
145         emit EnabledStaticCall(_module, _method);
146     }
147 
148     /**
149      * @dev Sets a new owner for the wallet.
150      * @param _newOwner The new owner.
151      */
152     function setOwner(address _newOwner) external moduleOnly {
153         require(_newOwner != address(0), "BW: address cannot be null");
154         owner = _newOwner;
155         emit OwnerChanged(_newOwner);
156     }
157 
158     /**
159      * @dev Performs a generic transaction.
160      * @param _target The address for the transaction.
161      * @param _value The value of the transaction.
162      * @param _data The data of the transaction.
163      */
164     function invoke(address _target, uint _value, bytes calldata _data) external moduleOnly returns (bytes memory _result) {
165         bool success;
166         // solium-disable-next-line security/no-call-value
167         (success, _result) = _target.call.value(_value)(_data);
168         if (!success) {
169             // solium-disable-next-line security/no-inline-assembly
170             assembly {
171                 returndatacopy(0, 0, returndatasize)
172                 revert(0, returndatasize)
173             }
174         }
175         emit Invoked(msg.sender, _target, _value, _data);
176     }
177 
178     /**
179      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
180      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
181      * to an enabled method, or logs the call otherwise.
182      */
183     function() external payable {
184         if (msg.data.length > 0) {
185             address module = enabled[msg.sig];
186             if (module == address(0)) {
187                 emit Received(msg.value, msg.sender, msg.data);
188             } else {
189                 require(authorised[module], "BW: must be an authorised module for static call");
190                 // solium-disable-next-line security/no-inline-assembly
191                 assembly {
192                     calldatacopy(0, 0, calldatasize())
193                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
194                     returndatacopy(0, 0, returndatasize())
195                     switch result
196                     case 0 {revert(0, returndatasize())}
197                     default {return (0, returndatasize())}
198                 }
199             }
200         }
201     }
202 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
203 
204 // This program is free software: you can redistribute it and/or modify
205 // it under the terms of the GNU General Public License as published by
206 // the Free Software Foundation, either version 3 of the License, or
207 // (at your option) any later version.
208 
209 // This program is distributed in the hope that it will be useful,
210 // but WITHOUT ANY WARRANTY; without even the implied warranty of
211 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
212 // GNU General Public License for more details.
213 
214 // You should have received a copy of the GNU General Public License
215 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
216 
217 
218 
219 /**
220  * @title Owned
221  * @dev Basic contract to define an owner.
222  * @author Julien Niset - <julien@argent.im>
223  */
224 contract Owned {
225 
226     // The owner
227     address public owner;
228 
229     event OwnerChanged(address indexed _newOwner);
230 
231     /**
232      * @dev Throws if the sender is not the owner.
233      */
234     modifier onlyOwner {
235         require(msg.sender == owner, "Must be owner");
236         _;
237     }
238 
239     constructor() public {
240         owner = msg.sender;
241     }
242 
243     /**
244      * @dev Lets the owner transfer ownership of the contract to a new owner.
245      * @param _newOwner The new owner.
246      */
247     function changeOwner(address _newOwner) external onlyOwner {
248         require(_newOwner != address(0), "Address must not be null");
249         owner = _newOwner;
250         emit OwnerChanged(_newOwner);
251     }
252 }
253 
254 /**
255  * ERC20 contract interface.
256  */
257 contract ERC20 {
258     function totalSupply() public view returns (uint);
259     function decimals() public view returns (uint);
260     function balanceOf(address tokenOwner) public view returns (uint balance);
261     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
262     function transfer(address to, uint tokens) public returns (bool success);
263     function approve(address spender, uint tokens) public returns (bool success);
264     function transferFrom(address from, address to, uint tokens) public returns (bool success);
265 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
266 
267 // This program is free software: you can redistribute it and/or modify
268 // it under the terms of the GNU General Public License as published by
269 // the Free Software Foundation, either version 3 of the License, or
270 // (at your option) any later version.
271 
272 // This program is distributed in the hope that it will be useful,
273 // but WITHOUT ANY WARRANTY; without even the implied warranty of
274 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
275 // GNU General Public License for more details.
276 
277 // You should have received a copy of the GNU General Public License
278 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
279 
280 
281 
282 /**
283  * @title ModuleRegistry
284  * @dev Registry of authorised modules.
285  * Modules must be registered before they can be authorised on a wallet.
286  * @author Julien Niset - <julien@argent.im>
287  */
288 contract ModuleRegistry is Owned {
289 
290     mapping (address => Info) internal modules;
291     mapping (address => Info) internal upgraders;
292 
293     event ModuleRegistered(address indexed module, bytes32 name);
294     event ModuleDeRegistered(address module);
295     event UpgraderRegistered(address indexed upgrader, bytes32 name);
296     event UpgraderDeRegistered(address upgrader);
297 
298     struct Info {
299         bool exists;
300         bytes32 name;
301     }
302 
303     /**
304      * @dev Registers a module.
305      * @param _module The module.
306      * @param _name The unique name of the module.
307      */
308     function registerModule(address _module, bytes32 _name) external onlyOwner {
309         require(!modules[_module].exists, "MR: module already exists");
310         modules[_module] = Info({exists: true, name: _name});
311         emit ModuleRegistered(_module, _name);
312     }
313 
314     /**
315      * @dev Deregisters a module.
316      * @param _module The module.
317      */
318     function deregisterModule(address _module) external onlyOwner {
319         require(modules[_module].exists, "MR: module does not exist");
320         delete modules[_module];
321         emit ModuleDeRegistered(_module);
322     }
323 
324         /**
325      * @dev Registers an upgrader.
326      * @param _upgrader The upgrader.
327      * @param _name The unique name of the upgrader.
328      */
329     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
330         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
331         upgraders[_upgrader] = Info({exists: true, name: _name});
332         emit UpgraderRegistered(_upgrader, _name);
333     }
334 
335     /**
336      * @dev Deregisters an upgrader.
337      * @param _upgrader The _upgrader.
338      */
339     function deregisterUpgrader(address _upgrader) external onlyOwner {
340         require(upgraders[_upgrader].exists, "MR: upgrader does not exist");
341         delete upgraders[_upgrader];
342         emit UpgraderDeRegistered(_upgrader);
343     }
344 
345     /**
346     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
347     * registry.
348     * @param _token The token to recover.
349     */
350     function recoverToken(address _token) external onlyOwner {
351         uint total = ERC20(_token).balanceOf(address(this));
352         ERC20(_token).transfer(msg.sender, total);
353     }
354 
355     /**
356      * @dev Gets the name of a module from its address.
357      * @param _module The module address.
358      * @return the name.
359      */
360     function moduleInfo(address _module) external view returns (bytes32) {
361         return modules[_module].name;
362     }
363 
364     /**
365      * @dev Gets the name of an upgrader from its address.
366      * @param _upgrader The upgrader address.
367      * @return the name.
368      */
369     function upgraderInfo(address _upgrader) external view returns (bytes32) {
370         return upgraders[_upgrader].name;
371     }
372 
373     /**
374      * @dev Checks if a module is registered.
375      * @param _module The module address.
376      * @return true if the module is registered.
377      */
378     function isRegisteredModule(address _module) external view returns (bool) {
379         return modules[_module].exists;
380     }
381 
382     /**
383      * @dev Checks if a list of modules are registered.
384      * @param _modules The list of modules address.
385      * @return true if all the modules are registered.
386      */
387     function isRegisteredModule(address[] calldata _modules) external view returns (bool) {
388         for (uint i = 0; i < _modules.length; i++) {
389             if (!modules[_modules[i]].exists) {
390                 return false;
391             }
392         }
393         return true;
394     }
395 
396     /**
397      * @dev Checks if an upgrader is registered.
398      * @param _upgrader The upgrader address.
399      * @return true if the upgrader is registered.
400      */
401     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
402         return upgraders[_upgrader].exists;
403     }
404 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
405 
406 // This program is free software: you can redistribute it and/or modify
407 // it under the terms of the GNU General Public License as published by
408 // the Free Software Foundation, either version 3 of the License, or
409 // (at your option) any later version.
410 
411 // This program is distributed in the hope that it will be useful,
412 // but WITHOUT ANY WARRANTY; without even the implied warranty of
413 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
414 // GNU General Public License for more details.
415 
416 // You should have received a copy of the GNU General Public License
417 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
418 
419 
420 /**
421  * @title Storage
422  * @dev Base contract for the storage of a wallet.
423  * @author Julien Niset - <julien@argent.im>
424  */
425 contract Storage {
426 
427     /**
428      * @dev Throws if the caller is not an authorised module.
429      */
430     modifier onlyModule(BaseWallet _wallet) {
431         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
432         _;
433     }
434 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
435 
436 // This program is free software: you can redistribute it and/or modify
437 // it under the terms of the GNU General Public License as published by
438 // the Free Software Foundation, either version 3 of the License, or
439 // (at your option) any later version.
440 
441 // This program is distributed in the hope that it will be useful,
442 // but WITHOUT ANY WARRANTY; without even the implied warranty of
443 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
444 // GNU General Public License for more details.
445 
446 // You should have received a copy of the GNU General Public License
447 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
448 
449 
450 interface IGuardianStorage{
451 
452     /**
453      * @dev Lets an authorised module add a guardian to a wallet.
454      * @param _wallet The target wallet.
455      * @param _guardian The guardian to add.
456      */
457     function addGuardian(BaseWallet _wallet, address _guardian) external;
458 
459     /**
460      * @dev Lets an authorised module revoke a guardian from a wallet.
461      * @param _wallet The target wallet.
462      * @param _guardian The guardian to revoke.
463      */
464     function revokeGuardian(BaseWallet _wallet, address _guardian) external;
465 
466     /**
467      * @dev Checks if an account is a guardian for a wallet.
468      * @param _wallet The target wallet.
469      * @param _guardian The account.
470      * @return true if the account is a guardian for a wallet.
471      */
472     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
473 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
474 
475 // This program is free software: you can redistribute it and/or modify
476 // it under the terms of the GNU General Public License as published by
477 // the Free Software Foundation, either version 3 of the License, or
478 // (at your option) any later version.
479 
480 // This program is distributed in the hope that it will be useful,
481 // but WITHOUT ANY WARRANTY; without even the implied warranty of
482 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
483 // GNU General Public License for more details.
484 
485 // You should have received a copy of the GNU General Public License
486 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
487 
488 
489 
490 
491 /**
492  * @title GuardianStorage
493  * @dev Contract storing the state of wallets related to guardians and lock.
494  * The contract only defines basic setters and getters with no logic. Only modules authorised
495  * for a wallet can modify its state.
496  * @author Julien Niset - <julien@argent.im>
497  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
498  */
499 contract GuardianStorage is IGuardianStorage, Storage {
500 
501     struct GuardianStorageConfig {
502         // the list of guardians
503         address[] guardians;
504         // the info about guardians
505         mapping (address => GuardianInfo) info;
506         // the lock's release timestamp
507         uint256 lock;
508         // the module that set the last lock
509         address locker;
510     }
511 
512     struct GuardianInfo {
513         bool exists;
514         uint128 index;
515     }
516 
517     // wallet specific storage
518     mapping (address => GuardianStorageConfig) internal configs;
519 
520     // *************** External Functions ********************* //
521 
522     /**
523      * @dev Lets an authorised module add a guardian to a wallet.
524      * @param _wallet The target wallet.
525      * @param _guardian The guardian to add.
526      */
527     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
528         GuardianStorageConfig storage config = configs[address(_wallet)];
529         config.info[_guardian].exists = true;
530         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
531     }
532 
533     /**
534      * @dev Lets an authorised module revoke a guardian from a wallet.
535      * @param _wallet The target wallet.
536      * @param _guardian The guardian to revoke.
537      */
538     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
539         GuardianStorageConfig storage config = configs[address(_wallet)];
540         address lastGuardian = config.guardians[config.guardians.length - 1];
541         if (_guardian != lastGuardian) {
542             uint128 targetIndex = config.info[_guardian].index;
543             config.guardians[targetIndex] = lastGuardian;
544             config.info[lastGuardian].index = targetIndex;
545         }
546         config.guardians.length--;
547         delete config.info[_guardian];
548     }
549 
550     /**
551      * @dev Returns the number of guardians for a wallet.
552      * @param _wallet The target wallet.
553      * @return the number of guardians.
554      */
555     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
556         return configs[address(_wallet)].guardians.length;
557     }
558 
559     /**
560      * @dev Gets the list of guaridans for a wallet.
561      * @param _wallet The target wallet.
562      * @return the list of guardians.
563      */
564     function getGuardians(BaseWallet _wallet) external view returns (address[] memory) {
565         GuardianStorageConfig storage config = configs[address(_wallet)];
566         address[] memory guardians = new address[](config.guardians.length);
567         for (uint256 i = 0; i < config.guardians.length; i++) {
568             guardians[i] = config.guardians[i];
569         }
570         return guardians;
571     }
572 
573     /**
574      * @dev Checks if an account is a guardian for a wallet.
575      * @param _wallet The target wallet.
576      * @param _guardian The account.
577      * @return true if the account is a guardian for a wallet.
578      */
579     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
580         return configs[address(_wallet)].info[_guardian].exists;
581     }
582 
583     /**
584      * @dev Lets an authorised module set the lock for a wallet.
585      * @param _wallet The target wallet.
586      * @param _releaseAfter The epoch time at which the lock should automatically release.
587      */
588     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
589         configs[address(_wallet)].lock = _releaseAfter;
590         if (_releaseAfter != 0 && msg.sender != configs[address(_wallet)].locker) {
591             configs[address(_wallet)].locker = msg.sender;
592         }
593     }
594 
595     /**
596      * @dev Checks if the lock is set for a wallet.
597      * @param _wallet The target wallet.
598      * @return true if the lock is set for the wallet.
599      */
600     function isLocked(BaseWallet _wallet) external view returns (bool) {
601         return configs[address(_wallet)].lock > now;
602     }
603 
604     /**
605      * @dev Gets the time at which the lock of a wallet will release.
606      * @param _wallet The target wallet.
607      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
608      */
609     function getLock(BaseWallet _wallet) external view returns (uint256) {
610         return configs[address(_wallet)].lock;
611     }
612 
613     /**
614      * @dev Gets the address of the last module that modified the lock for a wallet.
615      * @param _wallet The target wallet.
616      * @return the address of the last module that modified the lock for a wallet.
617      */
618     function getLocker(BaseWallet _wallet) external view returns (address) {
619         return configs[address(_wallet)].locker;
620     }
621 }/* The MIT License (MIT)
622 
623 Copyright (c) 2016 Smart Contract Solutions, Inc.
624 
625 Permission is hereby granted, free of charge, to any person obtaining
626 a copy of this software and associated documentation files (the
627 "Software"), to deal in the Software without restriction, including
628 without limitation the rights to use, copy, modify, merge, publish,
629 distribute, sublicense, and/or sell copies of the Software, and to
630 permit persons to whom the Software is furnished to do so, subject to
631 the following conditions:
632 
633 The above copyright notice and this permission notice shall be included
634 in all copies or substantial portions of the Software.
635 
636 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
637 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
638 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
639 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
640 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
641 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
642 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
643 
644 
645 
646 /**
647  * @title SafeMath
648  * @dev Math operations with safety checks that throw on error
649  */
650 library SafeMath {
651 
652     /**
653     * @dev Multiplies two numbers, reverts on overflow.
654     */
655     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
656         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
657         // benefit is lost if 'b' is also tested.
658         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
659         if (a == 0) {
660             return 0;
661         }
662 
663         uint256 c = a * b;
664         require(c / a == b);
665 
666         return c;
667     }
668 
669     /**
670     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
671     */
672     function div(uint256 a, uint256 b) internal pure returns (uint256) {
673         require(b > 0); // Solidity only automatically asserts when dividing by 0
674         uint256 c = a / b;
675         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
676 
677         return c;
678     }
679 
680     /**
681     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
682     */
683     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
684         require(b <= a);
685         uint256 c = a - b;
686 
687         return c;
688     }
689 
690     /**
691     * @dev Adds two numbers, reverts on overflow.
692     */
693     function add(uint256 a, uint256 b) internal pure returns (uint256) {
694         uint256 c = a + b;
695         require(c >= a);
696 
697         return c;
698     }
699 
700     /**
701     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
702     * reverts when dividing by zero.
703     */
704     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
705         require(b != 0);
706         return a % b;
707     }
708 
709     /**
710     * @dev Returns ceil(a / b).
711     */
712     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
713         uint256 c = a / b;
714         if(a % b == 0) {
715             return c;
716         }
717         else {
718             return c + 1;
719         }
720     }
721 
722     // from DSMath - operations on fixed precision floats
723 
724     uint256 constant WAD = 10 ** 18;
725     uint256 constant RAY = 10 ** 27;
726 
727     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
728         z = add(mul(x, y), WAD / 2) / WAD;
729     }
730     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
731         z = add(mul(x, y), RAY / 2) / RAY;
732     }
733     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
734         z = add(mul(x, WAD), y / 2) / y;
735     }
736     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
737         z = add(mul(x, RAY), y / 2) / y;
738     }
739 }
740 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
741 
742 // This program is free software: you can redistribute it and/or modify
743 // it under the terms of the GNU General Public License as published by
744 // the Free Software Foundation, either version 3 of the License, or
745 // (at your option) any later version.
746 
747 // This program is distributed in the hope that it will be useful,
748 // but WITHOUT ANY WARRANTY; without even the implied warranty of
749 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
750 // GNU General Public License for more details.
751 
752 // You should have received a copy of the GNU General Public License
753 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
754 
755 
756 
757 
758 
759 
760 
761 /**
762  * @title BaseModule
763  * @dev Basic module that contains some methods common to all modules.
764  * @author Julien Niset - <julien@argent.im>
765  */
766 contract BaseModule is Module {
767 
768     // Empty calldata
769     bytes constant internal EMPTY_BYTES = "";
770 
771     // The adddress of the module registry.
772     ModuleRegistry internal registry;
773     // The address of the Guardian storage
774     GuardianStorage internal guardianStorage;
775 
776     /**
777      * @dev Throws if the wallet is locked.
778      */
779     modifier onlyWhenUnlocked(BaseWallet _wallet) {
780         // solium-disable-next-line security/no-block-members
781         require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
782         _;
783     }
784 
785     event ModuleCreated(bytes32 name);
786     event ModuleInitialised(address wallet);
787 
788     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
789         registry = _registry;
790         guardianStorage = _guardianStorage;
791         emit ModuleCreated(_name);
792     }
793 
794     /**
795      * @dev Throws if the sender is not the target wallet of the call.
796      */
797     modifier onlyWallet(BaseWallet _wallet) {
798         require(msg.sender == address(_wallet), "BM: caller must be wallet");
799         _;
800     }
801 
802     /**
803      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
804      */
805     modifier onlyWalletOwner(BaseWallet _wallet) {
806         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
807         _;
808     }
809 
810     /**
811      * @dev Throws if the sender is not the owner of the target wallet.
812      */
813     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
814         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
815         _;
816     }
817 
818     /**
819      * @dev Inits the module for a wallet by logging an event.
820      * The method can only be called by the wallet itself.
821      * @param _wallet The wallet.
822      */
823     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
824         emit ModuleInitialised(address(_wallet));
825     }
826 
827     /**
828      * @dev Adds a module to a wallet. First checks that the module is registered.
829      * @param _wallet The target wallet.
830      * @param _module The modules to authorise.
831      */
832     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
833         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
834         _wallet.authoriseModule(address(_module), true);
835     }
836 
837     /**
838     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
839     * module by mistake and transfer them to the Module Registry.
840     * @param _token The token to recover.
841     */
842     function recoverToken(address _token) external {
843         uint total = ERC20(_token).balanceOf(address(this));
844         ERC20(_token).transfer(address(registry), total);
845     }
846 
847     /**
848      * @dev Helper method to check if an address is the owner of a target wallet.
849      * @param _wallet The target wallet.
850      * @param _addr The address.
851      */
852     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
853         return _wallet.owner() == _addr;
854     }
855 
856     /**
857      * @dev Helper method to invoke a wallet.
858      * @param _wallet The target wallet.
859      * @param _to The target address for the transaction.
860      * @param _value The value of the transaction.
861      * @param _data The data of the transaction.
862      */
863     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
864         bool success;
865         // solium-disable-next-line security/no-call-value
866         (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
867         if (success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
868             (_res) = abi.decode(_res, (bytes));
869         } else if (_res.length > 0) {
870             // solium-disable-next-line security/no-inline-assembly
871             assembly {
872                 returndatacopy(0, 0, returndatasize)
873                 revert(0, returndatasize)
874             }
875         } else if (!success) {
876             revert("BM: wallet invoke reverted");
877         }
878     }
879 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
880 
881 // This program is free software: you can redistribute it and/or modify
882 // it under the terms of the GNU General Public License as published by
883 // the Free Software Foundation, either version 3 of the License, or
884 // (at your option) any later version.
885 
886 // This program is distributed in the hope that it will be useful,
887 // but WITHOUT ANY WARRANTY; without even the implied warranty of
888 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
889 // GNU General Public License for more details.
890 
891 // You should have received a copy of the GNU General Public License
892 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
893 
894 
895 
896 library GuardianUtils {
897 
898     /**
899     * @dev Checks if an address is an account guardian or an account authorised to sign on behalf of a smart-contract guardian
900     * given a list of guardians.
901     * @param _guardians the list of guardians
902     * @param _guardian the address to test
903     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
904     */
905     function isGuardian(address[] memory _guardians, address _guardian) internal view returns (bool, address[] memory) {
906         if (_guardians.length == 0 || _guardian == address(0)) {
907             return (false, _guardians);
908         }
909         bool isFound = false;
910         address[] memory updatedGuardians = new address[](_guardians.length - 1);
911         uint256 index = 0;
912         for (uint256 i = 0; i < _guardians.length; i++) {
913             if (!isFound) {
914                 // check if _guardian is an account guardian
915                 if (_guardian == _guardians[i]) {
916                     isFound = true;
917                     continue;
918                 }
919                 // check if _guardian is the owner of a smart contract guardian
920                 if (isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
921                     isFound = true;
922                     continue;
923                 }
924             }
925             if (index < updatedGuardians.length) {
926                 updatedGuardians[index] = _guardians[i];
927                 index++;
928             }
929         }
930         return isFound ? (true, updatedGuardians) : (false, _guardians);
931     }
932 
933    /**
934     * @dev Checks if an address is a contract.
935     * @param _addr The address.
936     */
937     function isContract(address _addr) internal view returns (bool) {
938         uint32 size;
939         // solium-disable-next-line security/no-inline-assembly
940         assembly {
941             size := extcodesize(_addr)
942         }
943         return (size > 0);
944     }
945 
946     /**
947     * @dev Checks if an address is the owner of a guardian contract.
948     * The method does not revert if the call to the owner() method consumes more then 5000 gas.
949     * @param _guardian The guardian contract
950     * @param _owner The owner to verify.
951     */
952     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
953         address owner = address(0);
954         bytes4 sig = bytes4(keccak256("owner()"));
955         // solium-disable-next-line security/no-inline-assembly
956         assembly {
957             let ptr := mload(0x40)
958             mstore(ptr,sig)
959             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
960             if eq(result, 1) {
961                 owner := mload(ptr)
962             }
963         }
964         return owner == _owner;
965     }
966 }
967 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
968 
969 // This program is free software: you can redistribute it and/or modify
970 // it under the terms of the GNU General Public License as published by
971 // the Free Software Foundation, either version 3 of the License, or
972 // (at your option) any later version.
973 
974 // This program is distributed in the hope that it will be useful,
975 // but WITHOUT ANY WARRANTY; without even the implied warranty of
976 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
977 // GNU General Public License for more details.
978 
979 // You should have received a copy of the GNU General Public License
980 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
981 
982 
983 
984 
985 /**
986  * @title RelayerModuleV2
987  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
988  * RelayerModuleV2 should ultimately replace RelayerModule and be subclassed by all modules.
989  * It is currently only subclassed by RecoveryManager and ApprovedTransfer.
990  * @author Julien Niset <julien@argent.xyz>, Olivier VDB <olivier@argent.xyz>
991  */
992 contract RelayerModuleV2 is BaseModule {
993 
994     uint256 constant internal BLOCKBOUND = 10000;
995 
996     mapping (address => RelayerConfig) public relayer;
997 
998     struct RelayerConfig {
999         uint256 nonce;
1000         mapping (bytes32 => bool) executedTx;
1001     }
1002 
1003     enum OwnerSignature {
1004         Required,
1005         Optional,
1006         Disallowed
1007     }
1008 
1009     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
1010 
1011     /**
1012      * @dev Throws if the call did not go through the execute() method.
1013      */
1014     modifier onlyExecute {
1015         require(msg.sender == address(this), "RM: must be called via execute()");
1016         _;
1017     }
1018 
1019     /* ***************** Abstract methods ************************* */
1020 
1021     /**
1022     * @dev Gets the number of valid signatures that must be provided to execute a
1023     * specific relayed transaction.
1024     * @param _wallet The target wallet.
1025     * @param _data The data of the relayed transaction.
1026     * @return The number of required signatures.
1027     */
1028     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) public view returns (uint256);
1029 
1030     /**
1031     * @dev Validates the signatures provided with a relayed transaction.
1032     * The method MUST return false if one or more signatures are not valid.
1033     * @param _wallet The target wallet.
1034     * @param _data The data of the relayed transaction.
1035     * @param _signHash The signed hash representing the relayed transaction.
1036     * @param _signatures The signatures as a concatenated byte array.
1037     * @return A boolean indicating whether the signatures are valid.
1038     */
1039     function validateSignatures(
1040         BaseWallet _wallet,
1041         bytes memory _data,
1042         bytes32 _signHash,
1043         bytes memory _signatures
1044     )
1045         internal view returns (bool);
1046 
1047     /* ***************** External methods ************************* */
1048 
1049     /**
1050     * @dev Executes a relayed transaction.
1051     * @param _wallet The target wallet.
1052     * @param _data The data for the relayed transaction
1053     * @param _nonce The nonce used to prevent replay attacks.
1054     * @param _signatures The signatures as a concatenated byte array.
1055     * @param _gasPrice The gas price to use for the gas refund.
1056     * @param _gasLimit The gas limit to use for the gas refund.
1057     */
1058     function execute(
1059         BaseWallet _wallet,
1060         bytes calldata _data,
1061         uint256 _nonce,
1062         bytes calldata _signatures,
1063         uint256 _gasPrice,
1064         uint256 _gasLimit
1065     )
1066         external
1067         returns (bool success)
1068     {
1069         uint startGas = gasleft();
1070         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
1071         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
1072         require(verifyData(address(_wallet), _data), "RM: Target of _data != _wallet");
1073         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
1074         require(requiredSignatures * 65 == _signatures.length, "RM: Wrong number of signatures");
1075         require(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures), "RM: Invalid signatures");
1076         // The correctness of the refund is checked on the next line using an `if` instead of a `require`
1077         // in order to prevent a failing refund from being replayable in the future.
1078         if (verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
1079             // solium-disable-next-line security/no-call-value
1080             (success,) = address(this).call(_data);
1081             refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
1082         }
1083         emit TransactionExecuted(address(_wallet), success, signHash);
1084     }
1085 
1086     /**
1087     * @dev Gets the current nonce for a wallet.
1088     * @param _wallet The target wallet.
1089     */
1090     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
1091         return relayer[address(_wallet)].nonce;
1092     }
1093 
1094     /* ***************** Internal & Private methods ************************* */
1095 
1096     /**
1097     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
1098     * @param _from The starting address for the relayed transaction (should be the module)
1099     * @param _to The destination address for the relayed transaction (should be the wallet)
1100     * @param _value The value for the relayed transaction
1101     * @param _data The data for the relayed transaction
1102     * @param _nonce The nonce used to prevent replay attacks.
1103     * @param _gasPrice The gas price to use for the gas refund.
1104     * @param _gasLimit The gas limit to use for the gas refund.
1105     */
1106     function getSignHash(
1107         address _from,
1108         address _to,
1109         uint256 _value,
1110         bytes memory _data,
1111         uint256 _nonce,
1112         uint256 _gasPrice,
1113         uint256 _gasLimit
1114     )
1115         internal
1116         pure
1117         returns (bytes32)
1118     {
1119         return keccak256(
1120             abi.encodePacked(
1121                 "\x19Ethereum Signed Message:\n32",
1122                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
1123         ));
1124     }
1125 
1126     /**
1127     * @dev Checks if the relayed transaction is unique.
1128     * @param _wallet The target wallet.
1129     * @param _nonce The nonce
1130     * @param _signHash The signed hash of the transaction
1131     */
1132     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
1133         if (relayer[address(_wallet)].executedTx[_signHash] == true) {
1134             return false;
1135         }
1136         relayer[address(_wallet)].executedTx[_signHash] = true;
1137         return true;
1138     }
1139 
1140     /**
1141     * @dev Checks that a nonce has the correct format and is valid.
1142     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
1143     * @param _wallet The target wallet.
1144     * @param _nonce The nonce
1145     */
1146     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
1147         if (_nonce <= relayer[address(_wallet)].nonce) {
1148             return false;
1149         }
1150         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
1151         if (nonceBlock > block.number + BLOCKBOUND) {
1152             return false;
1153         }
1154         relayer[address(_wallet)].nonce = _nonce;
1155         return true;
1156     }
1157 
1158     /**
1159     * @dev Validates the signatures provided with a relayed transaction.
1160     * The method MUST throw if one or more signatures are not valid.
1161     * @param _wallet The target wallet.
1162     * @param _signHash The signed hash representing the relayed transaction.
1163     * @param _signatures The signatures as a concatenated byte array.
1164     * @param _option An enum indicating whether the owner is required, optional or disallowed.
1165     */
1166     function validateSignatures(
1167         BaseWallet _wallet,
1168         bytes32 _signHash,
1169         bytes memory _signatures,
1170         OwnerSignature _option
1171     )
1172         internal view returns (bool)
1173     {
1174         address lastSigner = address(0);
1175         address[] memory guardians;
1176         if (_option != OwnerSignature.Required || _signatures.length > 65) {
1177             guardians = guardianStorage.getGuardians(_wallet); // guardians are only read if they may be needed
1178         }
1179         bool isGuardian;
1180 
1181         for (uint8 i = 0; i < _signatures.length / 65; i++) {
1182             address signer = recoverSigner(_signHash, _signatures, i);
1183 
1184             if (i == 0) {
1185                 if (_option == OwnerSignature.Required) {
1186                     // First signer must be owner
1187                     if (isOwner(_wallet, signer)) {
1188                         continue;
1189                     }
1190                     return false;
1191                 } else if (_option == OwnerSignature.Optional) {
1192                     // First signer can be owner
1193                     if (isOwner(_wallet, signer)) {
1194                         continue;
1195                     }
1196                 }
1197             }
1198             if (signer <= lastSigner) {
1199                 return false; // Signers must be different
1200             }
1201             lastSigner = signer;
1202             (isGuardian, guardians) = GuardianUtils.isGuardian(guardians, signer);
1203             if (!isGuardian) {
1204                 return false;
1205             }
1206         }
1207         return true;
1208     }
1209 
1210     /**
1211     * @dev Recovers the signer at a given position from a list of concatenated signatures.
1212     * @param _signedHash The signed hash
1213     * @param _signatures The concatenated signatures.
1214     * @param _index The index of the signature to recover.
1215     */
1216     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
1217         uint8 v;
1218         bytes32 r;
1219         bytes32 s;
1220         // we jump 32 (0x20) as the first slot of bytes contains the length
1221         // we jump 65 (0x41) per signature
1222         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
1223         // solium-disable-next-line security/no-inline-assembly
1224         assembly {
1225             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
1226             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
1227             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
1228         }
1229         require(v == 27 || v == 28); // solium-disable-line error-reason
1230         return ecrecover(_signedHash, v, r, s);
1231     }
1232 
1233     /**
1234     * @dev Refunds the gas used to the Relayer.
1235     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures.
1236     * @param _wallet The target wallet.
1237     * @param _gasUsed The gas used.
1238     * @param _gasPrice The gas price for the refund.
1239     * @param _gasLimit The gas limit for the refund.
1240     * @param _signatures The number of signatures used in the call.
1241     * @param _relayer The address of the Relayer.
1242     */
1243     function refund(
1244         BaseWallet _wallet,
1245         uint _gasUsed,
1246         uint _gasPrice,
1247         uint _gasLimit,
1248         uint _signatures,
1249         address _relayer
1250     )
1251         internal
1252     {
1253         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
1254         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
1255         if (_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
1256             if (_gasPrice > tx.gasprice) {
1257                 amount = amount * tx.gasprice;
1258             } else {
1259                 amount = amount * _gasPrice;
1260             }
1261             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
1262         }
1263     }
1264 
1265     /**
1266     * @dev Returns false if the refund is expected to fail.
1267     * @param _wallet The target wallet.
1268     * @param _gasUsed The expected gas used.
1269     * @param _gasPrice The expected gas price for the refund.
1270     */
1271     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1272         if (_gasPrice > 0 &&
1273             _signatures > 1 &&
1274             (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
1275             return false;
1276         }
1277         return true;
1278     }
1279 
1280     /**
1281     * @dev Parses the data to extract the method signature.
1282     */
1283     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
1284         require(_data.length >= 4, "RM: Invalid functionPrefix");
1285         // solium-disable-next-line security/no-inline-assembly
1286         assembly {
1287             prefix := mload(add(_data, 0x20))
1288         }
1289     }
1290 
1291    /**
1292     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
1293     * as the wallet passed as the input of the execute() method.
1294     @return false if the addresses are different.
1295     */
1296     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
1297         require(_data.length >= 36, "RM: Invalid dataWallet");
1298         address dataWallet;
1299         // solium-disable-next-line security/no-inline-assembly
1300         assembly {
1301             //_data = {length:32}{sig:4}{_wallet:32}{...}
1302             dataWallet := mload(add(_data, 0x24))
1303         }
1304         return dataWallet == _wallet;
1305     }
1306 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1307 
1308 // This program is free software: you can redistribute it and/or modify
1309 // it under the terms of the GNU General Public License as published by
1310 // the Free Software Foundation, either version 3 of the License, or
1311 // (at your option) any later version.
1312 
1313 // This program is distributed in the hope that it will be useful,
1314 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1315 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1316 // GNU General Public License for more details.
1317 
1318 // You should have received a copy of the GNU General Public License
1319 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1320 
1321 
1322 
1323 
1324 
1325 /**
1326  * @title RecoveryManager
1327  * @dev Module to manage the recovery of a wallet owner.
1328  * Recovery is executed by a consensus of the wallet's guardians and takes
1329  * 24 hours before it can be finalized. Once finalised the ownership of the wallet
1330  * is transfered to a new address.
1331  * @author Julien Niset - <julien@argent.im>
1332  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
1333  */
1334 contract RecoveryManager is BaseModule, RelayerModuleV2 {
1335 
1336     bytes32 constant NAME = "RecoveryManager";
1337 
1338     bytes4 constant internal EXECUTE_RECOVERY_PREFIX = bytes4(keccak256("executeRecovery(address,address)"));
1339     bytes4 constant internal FINALIZE_RECOVERY_PREFIX = bytes4(keccak256("finalizeRecovery(address)"));
1340     bytes4 constant internal CANCEL_RECOVERY_PREFIX = bytes4(keccak256("cancelRecovery(address)"));
1341     bytes4 constant internal TRANSFER_OWNERSHIP_PREFIX = bytes4(keccak256("transferOwnership(address,address)"));
1342 
1343     struct RecoveryConfig {
1344         address recovery;
1345         uint64 executeAfter;
1346         uint32 guardianCount;
1347     }
1348 
1349     // Wallet specific storage
1350     mapping (address => RecoveryConfig) internal recoveryConfigs;
1351 
1352     // Recovery period
1353     uint256 public recoveryPeriod;
1354     // Lock period
1355     uint256 public lockPeriod;
1356     // Security period used for (non-recovery) ownership transfer
1357     uint256 public securityPeriod;
1358     // Security window used for (non-recovery) ownership transfer
1359     uint256 public securityWindow;
1360     // Location of the Guardian storage
1361     GuardianStorage public guardianStorage;
1362 
1363     // *************** Events *************************** //
1364 
1365     event RecoveryExecuted(address indexed wallet, address indexed _recovery, uint64 executeAfter);
1366     event RecoveryFinalized(address indexed wallet, address indexed _recovery);
1367     event RecoveryCanceled(address indexed wallet, address indexed _recovery);
1368     event OwnershipTransfered(address indexed wallet, address indexed _newOwner);
1369 
1370     // *************** Modifiers ************************ //
1371 
1372     /**
1373      * @dev Throws if there is no ongoing recovery procedure.
1374      */
1375     modifier onlyWhenRecovery(BaseWallet _wallet) {
1376         require(recoveryConfigs[address(_wallet)].executeAfter > 0, "RM: there must be an ongoing recovery");
1377         _;
1378     }
1379 
1380     /**
1381      * @dev Throws if there is an ongoing recovery procedure.
1382      */
1383     modifier notWhenRecovery(BaseWallet _wallet) {
1384         require(recoveryConfigs[address(_wallet)].executeAfter == 0, "RM: there cannot be an ongoing recovery");
1385         _;
1386     }
1387 
1388     // *************** Constructor ************************ //
1389 
1390     constructor(
1391         ModuleRegistry _registry,
1392         GuardianStorage _guardianStorage,
1393         uint256 _recoveryPeriod,
1394         uint256 _lockPeriod,
1395         uint256 _securityPeriod,
1396         uint256 _securityWindow
1397     )
1398         BaseModule(_registry, _guardianStorage, NAME)
1399         public
1400     {
1401         require(_lockPeriod >= _recoveryPeriod && _recoveryPeriod >= _securityPeriod + _securityWindow, "RM: insecure security periods");
1402         guardianStorage = _guardianStorage;
1403         recoveryPeriod = _recoveryPeriod;
1404         lockPeriod = _lockPeriod;
1405         securityPeriod = _securityPeriod;
1406         securityWindow = _securityWindow;
1407     }
1408 
1409     // *************** External functions ************************ //
1410 
1411     /**
1412      * @dev Lets the guardians start the execution of the recovery procedure.
1413      * Once triggered the recovery is pending for the security period before it can
1414      * be finalised.
1415      * Must be confirmed by N guardians, where N = ((Nb Guardian + 1) / 2).
1416      * @param _wallet The target wallet.
1417      * @param _recovery The address to which ownership should be transferred.
1418      */
1419     function executeRecovery(BaseWallet _wallet, address _recovery) external onlyExecute notWhenRecovery(_wallet) {
1420         require(_recovery != address(0), "RM: recovery address cannot be null");
1421         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1422         config.recovery = _recovery;
1423         config.executeAfter = uint64(now + recoveryPeriod);
1424         config.guardianCount = uint32(guardianStorage.guardianCount(_wallet));
1425         guardianStorage.setLock(_wallet, now + lockPeriod);
1426         emit RecoveryExecuted(address(_wallet), _recovery, config.executeAfter);
1427     }
1428 
1429     /**
1430      * @dev Finalizes an ongoing recovery procedure if the security period is over.
1431      * The method is public and callable by anyone to enable orchestration.
1432      * @param _wallet The target wallet.
1433      */
1434     function finalizeRecovery(BaseWallet _wallet) external onlyWhenRecovery(_wallet) {
1435         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1436         require(uint64(now) > config.executeAfter, "RM: the recovery period is not over yet");
1437         _wallet.setOwner(config.recovery);
1438         emit RecoveryFinalized(address(_wallet), config.recovery);
1439         guardianStorage.setLock(_wallet, 0);
1440         delete recoveryConfigs[address(_wallet)];
1441     }
1442 
1443     /**
1444      * @dev Lets the owner cancel an ongoing recovery procedure.
1445      * Must be confirmed by N guardians, where N = ((Nb Guardian + 1) / 2) - 1.
1446      * @param _wallet The target wallet.
1447      */
1448     function cancelRecovery(BaseWallet _wallet) external onlyExecute onlyWhenRecovery(_wallet) {
1449         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1450         emit RecoveryCanceled(address(_wallet), config.recovery);
1451         guardianStorage.setLock(_wallet, 0);
1452         delete recoveryConfigs[address(_wallet)];
1453     }
1454 
1455     /**
1456      * @dev Lets the owner start the execution of the ownership transfer procedure.
1457      * Once triggered the ownership transfer is pending for the security period before it can
1458      * be finalised.
1459      * @param _wallet The target wallet.
1460      * @param _newOwner The address to which ownership should be transferred.
1461      */
1462     function transferOwnership(BaseWallet _wallet, address _newOwner) external onlyExecute onlyWhenUnlocked(_wallet) {
1463         require(_newOwner != address(0), "RM: new owner address cannot be null");
1464         _wallet.setOwner(_newOwner);
1465 
1466         emit OwnershipTransfered(address(_wallet), _newOwner);
1467     }
1468 
1469     /**
1470     * @dev Gets the details of the ongoing recovery procedure if any.
1471     * @param _wallet The target wallet.
1472     */
1473     function getRecovery(BaseWallet _wallet) public view returns(address _address, uint64 _executeAfter, uint32 _guardianCount) {
1474         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1475         return (config.recovery, config.executeAfter, config.guardianCount);
1476     }
1477 
1478     // *************** Implementation of RelayerModule methods ********************* //
1479 
1480     function validateSignatures(
1481         BaseWallet _wallet,
1482         bytes memory _data,
1483         bytes32 _signHash,
1484         bytes memory _signatures
1485     )
1486         internal view returns (bool)
1487     {
1488         bytes4 functionSignature = functionPrefix(_data);
1489         if (functionSignature == TRANSFER_OWNERSHIP_PREFIX) {
1490             return validateSignatures(_wallet, _signHash, _signatures, OwnerSignature.Required);
1491         } else if (functionSignature == EXECUTE_RECOVERY_PREFIX) {
1492             return validateSignatures(_wallet, _signHash, _signatures, OwnerSignature.Disallowed);
1493         } else if (functionSignature == CANCEL_RECOVERY_PREFIX) {
1494             return validateSignatures(_wallet, _signHash, _signatures, OwnerSignature.Optional);
1495         }
1496     }
1497 
1498     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) public view returns (uint256) {
1499         bytes4 methodId = functionPrefix(_data);
1500         if (methodId == EXECUTE_RECOVERY_PREFIX) {
1501             uint walletGuardians = guardianStorage.guardianCount(_wallet);
1502             require(walletGuardians > 0, "RM: no guardians set on wallet");
1503             return SafeMath.ceil(walletGuardians, 2);
1504         }
1505         if (methodId == FINALIZE_RECOVERY_PREFIX) {
1506             return 0;
1507         }
1508         if (methodId == CANCEL_RECOVERY_PREFIX) {
1509             return SafeMath.ceil(recoveryConfigs[address(_wallet)].guardianCount + 1, 2);
1510         }
1511         if (methodId == TRANSFER_OWNERSHIP_PREFIX) {
1512             uint majorityGuardians = SafeMath.ceil(guardianStorage.guardianCount(_wallet), 2);
1513             return SafeMath.add(majorityGuardians, 1);
1514         }
1515         revert("RM: unknown method");
1516     }
1517 }