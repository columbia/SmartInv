1 pragma solidity ^0.5.4;// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 
17 /**
18  * @title Module
19  * @dev Interface for a module.
20  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
21  * can never end up in a "frozen" state.
22  * @author Julien Niset - <julien@argent.xyz>
23  */
24 interface Module {
25 
26     /**
27      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
28      * @param _wallet The wallet.
29      */
30     function init(BaseWallet _wallet) external;
31 
32     /**
33      * @dev Adds a module to a wallet.
34      * @param _wallet The target wallet.
35      * @param _module The modules to authorise.
36      */
37     function addModule(BaseWallet _wallet, Module _module) external;
38 
39     /**
40     * @dev Utility method to recover any ERC20 token that was sent to the
41     * module by mistake.
42     * @param _token The token to recover.
43     */
44     function recoverToken(address _token) external;
45 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
46 
47 // This program is free software: you can redistribute it and/or modify
48 // it under the terms of the GNU General Public License as published by
49 // the Free Software Foundation, either version 3 of the License, or
50 // (at your option) any later version.
51 
52 // This program is distributed in the hope that it will be useful,
53 // but WITHOUT ANY WARRANTY; without even the implied warranty of
54 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
55 // GNU General Public License for more details.
56 
57 // You should have received a copy of the GNU General Public License
58 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
59 
60 
61 /**
62  * @title BaseWallet
63  * @dev Simple modular wallet that authorises modules to call its invoke() method.
64  * @author Julien Niset - <julien@argent.xyz>
65  */
66 contract BaseWallet {
67 
68     // The implementation of the proxy
69     address public implementation;
70     // The owner
71     address public owner;
72     // The authorised modules
73     mapping (address => bool) public authorised;
74     // The enabled static calls
75     mapping (bytes4 => address) public enabled;
76     // The number of modules
77     uint public modules;
78 
79     event AuthorisedModule(address indexed module, bool value);
80     event EnabledStaticCall(address indexed module, bytes4 indexed method);
81     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
82     event Received(uint indexed value, address indexed sender, bytes data);
83     event OwnerChanged(address owner);
84 
85     /**
86      * @dev Throws if the sender is not an authorised module.
87      */
88     modifier moduleOnly {
89         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
90         _;
91     }
92 
93     /**
94      * @dev Inits the wallet by setting the owner and authorising a list of modules.
95      * @param _owner The owner.
96      * @param _modules The modules to authorise.
97      */
98     function init(address _owner, address[] calldata _modules) external {
99         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
100         require(_modules.length > 0, "BW: construction requires at least 1 module");
101         owner = _owner;
102         modules = _modules.length;
103         for (uint256 i = 0; i < _modules.length; i++) {
104             require(authorised[_modules[i]] == false, "BW: module is already added");
105             authorised[_modules[i]] = true;
106             Module(_modules[i]).init(this);
107             emit AuthorisedModule(_modules[i], true);
108         }
109         if (address(this).balance > 0) {
110             emit Received(address(this).balance, address(0), "");
111         }
112     }
113 
114     /**
115      * @dev Enables/Disables a module.
116      * @param _module The target module.
117      * @param _value Set to true to authorise the module.
118      */
119     function authoriseModule(address _module, bool _value) external moduleOnly {
120         if (authorised[_module] != _value) {
121             emit AuthorisedModule(_module, _value);
122             if (_value == true) {
123                 modules += 1;
124                 authorised[_module] = true;
125                 Module(_module).init(this);
126             } else {
127                 modules -= 1;
128                 require(modules > 0, "BW: wallet must have at least one module");
129                 delete authorised[_module];
130             }
131         }
132     }
133 
134     /**
135     * @dev Enables a static method by specifying the target module to which the call
136     * must be delegated.
137     * @param _module The target module.
138     * @param _method The static method signature.
139     */
140     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
141         require(authorised[_module], "BW: must be an authorised module for static call");
142         enabled[_method] = _module;
143         emit EnabledStaticCall(_module, _method);
144     }
145 
146     /**
147      * @dev Sets a new owner for the wallet.
148      * @param _newOwner The new owner.
149      */
150     function setOwner(address _newOwner) external moduleOnly {
151         require(_newOwner != address(0), "BW: address cannot be null");
152         owner = _newOwner;
153         emit OwnerChanged(_newOwner);
154     }
155 
156     /**
157      * @dev Performs a generic transaction.
158      * @param _target The address for the transaction.
159      * @param _value The value of the transaction.
160      * @param _data The data of the transaction.
161      */
162     function invoke(address _target, uint _value, bytes calldata _data) external moduleOnly returns (bytes memory _result) {
163         bool success;
164         // solium-disable-next-line security/no-call-value
165         (success, _result) = _target.call.value(_value)(_data);
166         if (!success) {
167             // solium-disable-next-line security/no-inline-assembly
168             assembly {
169                 returndatacopy(0, 0, returndatasize)
170                 revert(0, returndatasize)
171             }
172         }
173         emit Invoked(msg.sender, _target, _value, _data);
174     }
175 
176     /**
177      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
178      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
179      * to an enabled method, or logs the call otherwise.
180      */
181     function() external payable {
182         if (msg.data.length > 0) {
183             address module = enabled[msg.sig];
184             if (module == address(0)) {
185                 emit Received(msg.value, msg.sender, msg.data);
186             } else {
187                 require(authorised[module], "BW: must be an authorised module for static call");
188                 // solium-disable-next-line security/no-inline-assembly
189                 assembly {
190                     calldatacopy(0, 0, calldatasize())
191                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
192                     returndatacopy(0, 0, returndatasize())
193                     switch result
194                     case 0 {revert(0, returndatasize())}
195                     default {return (0, returndatasize())}
196                 }
197             }
198         }
199     }
200 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
201 
202 // This program is free software: you can redistribute it and/or modify
203 // it under the terms of the GNU General Public License as published by
204 // the Free Software Foundation, either version 3 of the License, or
205 // (at your option) any later version.
206 
207 // This program is distributed in the hope that it will be useful,
208 // but WITHOUT ANY WARRANTY; without even the implied warranty of
209 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
210 // GNU General Public License for more details.
211 
212 // You should have received a copy of the GNU General Public License
213 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
214 
215 
216 
217 /**
218  * @title Owned
219  * @dev Basic contract to define an owner.
220  * @author Julien Niset - <julien@argent.im>
221  */
222 contract Owned {
223 
224     // The owner
225     address public owner;
226 
227     event OwnerChanged(address indexed _newOwner);
228 
229     /**
230      * @dev Throws if the sender is not the owner.
231      */
232     modifier onlyOwner {
233         require(msg.sender == owner, "Must be owner");
234         _;
235     }
236 
237     constructor() public {
238         owner = msg.sender;
239     }
240 
241     /**
242      * @dev Lets the owner transfer ownership of the contract to a new owner.
243      * @param _newOwner The new owner.
244      */
245     function changeOwner(address _newOwner) external onlyOwner {
246         require(_newOwner != address(0), "Address must not be null");
247         owner = _newOwner;
248         emit OwnerChanged(_newOwner);
249     }
250 }
251 
252 /**
253  * ERC20 contract interface.
254  */
255 contract ERC20 {
256     function totalSupply() public view returns (uint);
257     function decimals() public view returns (uint);
258     function balanceOf(address tokenOwner) public view returns (uint balance);
259     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
260     function transfer(address to, uint tokens) public returns (bool success);
261     function approve(address spender, uint tokens) public returns (bool success);
262     function transferFrom(address from, address to, uint tokens) public returns (bool success);
263 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
264 
265 // This program is free software: you can redistribute it and/or modify
266 // it under the terms of the GNU General Public License as published by
267 // the Free Software Foundation, either version 3 of the License, or
268 // (at your option) any later version.
269 
270 // This program is distributed in the hope that it will be useful,
271 // but WITHOUT ANY WARRANTY; without even the implied warranty of
272 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
273 // GNU General Public License for more details.
274 
275 // You should have received a copy of the GNU General Public License
276 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
277 
278 
279 
280 /**
281  * @title ModuleRegistry
282  * @dev Registry of authorised modules.
283  * Modules must be registered before they can be authorised on a wallet.
284  * @author Julien Niset - <julien@argent.im>
285  */
286 contract ModuleRegistry is Owned {
287 
288     mapping (address => Info) internal modules;
289     mapping (address => Info) internal upgraders;
290 
291     event ModuleRegistered(address indexed module, bytes32 name);
292     event ModuleDeRegistered(address module);
293     event UpgraderRegistered(address indexed upgrader, bytes32 name);
294     event UpgraderDeRegistered(address upgrader);
295 
296     struct Info {
297         bool exists;
298         bytes32 name;
299     }
300 
301     /**
302      * @dev Registers a module.
303      * @param _module The module.
304      * @param _name The unique name of the module.
305      */
306     function registerModule(address _module, bytes32 _name) external onlyOwner {
307         require(!modules[_module].exists, "MR: module already exists");
308         modules[_module] = Info({exists: true, name: _name});
309         emit ModuleRegistered(_module, _name);
310     }
311 
312     /**
313      * @dev Deregisters a module.
314      * @param _module The module.
315      */
316     function deregisterModule(address _module) external onlyOwner {
317         require(modules[_module].exists, "MR: module does not exist");
318         delete modules[_module];
319         emit ModuleDeRegistered(_module);
320     }
321 
322         /**
323      * @dev Registers an upgrader.
324      * @param _upgrader The upgrader.
325      * @param _name The unique name of the upgrader.
326      */
327     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
328         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
329         upgraders[_upgrader] = Info({exists: true, name: _name});
330         emit UpgraderRegistered(_upgrader, _name);
331     }
332 
333     /**
334      * @dev Deregisters an upgrader.
335      * @param _upgrader The _upgrader.
336      */
337     function deregisterUpgrader(address _upgrader) external onlyOwner {
338         require(upgraders[_upgrader].exists, "MR: upgrader does not exist");
339         delete upgraders[_upgrader];
340         emit UpgraderDeRegistered(_upgrader);
341     }
342 
343     /**
344     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
345     * registry.
346     * @param _token The token to recover.
347     */
348     function recoverToken(address _token) external onlyOwner {
349         uint total = ERC20(_token).balanceOf(address(this));
350         ERC20(_token).transfer(msg.sender, total);
351     }
352 
353     /**
354      * @dev Gets the name of a module from its address.
355      * @param _module The module address.
356      * @return the name.
357      */
358     function moduleInfo(address _module) external view returns (bytes32) {
359         return modules[_module].name;
360     }
361 
362     /**
363      * @dev Gets the name of an upgrader from its address.
364      * @param _upgrader The upgrader address.
365      * @return the name.
366      */
367     function upgraderInfo(address _upgrader) external view returns (bytes32) {
368         return upgraders[_upgrader].name;
369     }
370 
371     /**
372      * @dev Checks if a module is registered.
373      * @param _module The module address.
374      * @return true if the module is registered.
375      */
376     function isRegisteredModule(address _module) external view returns (bool) {
377         return modules[_module].exists;
378     }
379 
380     /**
381      * @dev Checks if a list of modules are registered.
382      * @param _modules The list of modules address.
383      * @return true if all the modules are registered.
384      */
385     function isRegisteredModule(address[] calldata _modules) external view returns (bool) {
386         for (uint i = 0; i < _modules.length; i++) {
387             if (!modules[_modules[i]].exists) {
388                 return false;
389             }
390         }
391         return true;
392     }
393 
394     /**
395      * @dev Checks if an upgrader is registered.
396      * @param _upgrader The upgrader address.
397      * @return true if the upgrader is registered.
398      */
399     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
400         return upgraders[_upgrader].exists;
401     }
402 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
403 
404 // This program is free software: you can redistribute it and/or modify
405 // it under the terms of the GNU General Public License as published by
406 // the Free Software Foundation, either version 3 of the License, or
407 // (at your option) any later version.
408 
409 // This program is distributed in the hope that it will be useful,
410 // but WITHOUT ANY WARRANTY; without even the implied warranty of
411 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
412 // GNU General Public License for more details.
413 
414 // You should have received a copy of the GNU General Public License
415 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
416 
417 
418 /**
419  * @title Storage
420  * @dev Base contract for the storage of a wallet.
421  * @author Julien Niset - <julien@argent.im>
422  */
423 contract Storage {
424 
425     /**
426      * @dev Throws if the caller is not an authorised module.
427      */
428     modifier onlyModule(BaseWallet _wallet) {
429         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
430         _;
431     }
432 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
433 
434 // This program is free software: you can redistribute it and/or modify
435 // it under the terms of the GNU General Public License as published by
436 // the Free Software Foundation, either version 3 of the License, or
437 // (at your option) any later version.
438 
439 // This program is distributed in the hope that it will be useful,
440 // but WITHOUT ANY WARRANTY; without even the implied warranty of
441 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
442 // GNU General Public License for more details.
443 
444 // You should have received a copy of the GNU General Public License
445 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
446 
447 
448 interface IGuardianStorage{
449 
450     /**
451      * @dev Lets an authorised module add a guardian to a wallet.
452      * @param _wallet The target wallet.
453      * @param _guardian The guardian to add.
454      */
455     function addGuardian(BaseWallet _wallet, address _guardian) external;
456 
457     /**
458      * @dev Lets an authorised module revoke a guardian from a wallet.
459      * @param _wallet The target wallet.
460      * @param _guardian The guardian to revoke.
461      */
462     function revokeGuardian(BaseWallet _wallet, address _guardian) external;
463 
464     /**
465      * @dev Checks if an account is a guardian for a wallet.
466      * @param _wallet The target wallet.
467      * @param _guardian The account.
468      * @return true if the account is a guardian for a wallet.
469      */
470     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
471 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
472 
473 // This program is free software: you can redistribute it and/or modify
474 // it under the terms of the GNU General Public License as published by
475 // the Free Software Foundation, either version 3 of the License, or
476 // (at your option) any later version.
477 
478 // This program is distributed in the hope that it will be useful,
479 // but WITHOUT ANY WARRANTY; without even the implied warranty of
480 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
481 // GNU General Public License for more details.
482 
483 // You should have received a copy of the GNU General Public License
484 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
485 
486 
487 
488 
489 /**
490  * @title GuardianStorage
491  * @dev Contract storing the state of wallets related to guardians and lock.
492  * The contract only defines basic setters and getters with no logic. Only modules authorised
493  * for a wallet can modify its state.
494  * @author Julien Niset - <julien@argent.im>
495  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
496  */
497 contract GuardianStorage is IGuardianStorage, Storage {
498 
499     struct GuardianStorageConfig {
500         // the list of guardians
501         address[] guardians;
502         // the info about guardians
503         mapping (address => GuardianInfo) info;
504         // the lock's release timestamp
505         uint256 lock;
506         // the module that set the last lock
507         address locker;
508     }
509 
510     struct GuardianInfo {
511         bool exists;
512         uint128 index;
513     }
514 
515     // wallet specific storage
516     mapping (address => GuardianStorageConfig) internal configs;
517 
518     // *************** External Functions ********************* //
519 
520     /**
521      * @dev Lets an authorised module add a guardian to a wallet.
522      * @param _wallet The target wallet.
523      * @param _guardian The guardian to add.
524      */
525     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
526         GuardianStorageConfig storage config = configs[address(_wallet)];
527         config.info[_guardian].exists = true;
528         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
529     }
530 
531     /**
532      * @dev Lets an authorised module revoke a guardian from a wallet.
533      * @param _wallet The target wallet.
534      * @param _guardian The guardian to revoke.
535      */
536     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
537         GuardianStorageConfig storage config = configs[address(_wallet)];
538         address lastGuardian = config.guardians[config.guardians.length - 1];
539         if (_guardian != lastGuardian) {
540             uint128 targetIndex = config.info[_guardian].index;
541             config.guardians[targetIndex] = lastGuardian;
542             config.info[lastGuardian].index = targetIndex;
543         }
544         config.guardians.length--;
545         delete config.info[_guardian];
546     }
547 
548     /**
549      * @dev Returns the number of guardians for a wallet.
550      * @param _wallet The target wallet.
551      * @return the number of guardians.
552      */
553     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
554         return configs[address(_wallet)].guardians.length;
555     }
556 
557     /**
558      * @dev Gets the list of guaridans for a wallet.
559      * @param _wallet The target wallet.
560      * @return the list of guardians.
561      */
562     function getGuardians(BaseWallet _wallet) external view returns (address[] memory) {
563         GuardianStorageConfig storage config = configs[address(_wallet)];
564         address[] memory guardians = new address[](config.guardians.length);
565         for (uint256 i = 0; i < config.guardians.length; i++) {
566             guardians[i] = config.guardians[i];
567         }
568         return guardians;
569     }
570 
571     /**
572      * @dev Checks if an account is a guardian for a wallet.
573      * @param _wallet The target wallet.
574      * @param _guardian The account.
575      * @return true if the account is a guardian for a wallet.
576      */
577     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
578         return configs[address(_wallet)].info[_guardian].exists;
579     }
580 
581     /**
582      * @dev Lets an authorised module set the lock for a wallet.
583      * @param _wallet The target wallet.
584      * @param _releaseAfter The epoch time at which the lock should automatically release.
585      */
586     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
587         configs[address(_wallet)].lock = _releaseAfter;
588         if (_releaseAfter != 0 && msg.sender != configs[address(_wallet)].locker) {
589             configs[address(_wallet)].locker = msg.sender;
590         }
591     }
592 
593     /**
594      * @dev Checks if the lock is set for a wallet.
595      * @param _wallet The target wallet.
596      * @return true if the lock is set for the wallet.
597      */
598     function isLocked(BaseWallet _wallet) external view returns (bool) {
599         return configs[address(_wallet)].lock > now;
600     }
601 
602     /**
603      * @dev Gets the time at which the lock of a wallet will release.
604      * @param _wallet The target wallet.
605      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
606      */
607     function getLock(BaseWallet _wallet) external view returns (uint256) {
608         return configs[address(_wallet)].lock;
609     }
610 
611     /**
612      * @dev Gets the address of the last module that modified the lock for a wallet.
613      * @param _wallet The target wallet.
614      * @return the address of the last module that modified the lock for a wallet.
615      */
616     function getLocker(BaseWallet _wallet) external view returns (address) {
617         return configs[address(_wallet)].locker;
618     }
619 }/* The MIT License (MIT)
620 
621 Copyright (c) 2016 Smart Contract Solutions, Inc.
622 
623 Permission is hereby granted, free of charge, to any person obtaining
624 a copy of this software and associated documentation files (the
625 "Software"), to deal in the Software without restriction, including
626 without limitation the rights to use, copy, modify, merge, publish,
627 distribute, sublicense, and/or sell copies of the Software, and to
628 permit persons to whom the Software is furnished to do so, subject to
629 the following conditions:
630 
631 The above copyright notice and this permission notice shall be included
632 in all copies or substantial portions of the Software.
633 
634 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
635 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
636 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
637 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
638 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
639 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
640 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
641 
642 
643 
644 /**
645  * @title SafeMath
646  * @dev Math operations with safety checks that throw on error
647  */
648 library SafeMath {
649 
650     /**
651     * @dev Multiplies two numbers, reverts on overflow.
652     */
653     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
654         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
655         // benefit is lost if 'b' is also tested.
656         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
657         if (a == 0) {
658             return 0;
659         }
660 
661         uint256 c = a * b;
662         require(c / a == b);
663 
664         return c;
665     }
666 
667     /**
668     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
669     */
670     function div(uint256 a, uint256 b) internal pure returns (uint256) {
671         require(b > 0); // Solidity only automatically asserts when dividing by 0
672         uint256 c = a / b;
673         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
674 
675         return c;
676     }
677 
678     /**
679     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
680     */
681     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
682         require(b <= a);
683         uint256 c = a - b;
684 
685         return c;
686     }
687 
688     /**
689     * @dev Adds two numbers, reverts on overflow.
690     */
691     function add(uint256 a, uint256 b) internal pure returns (uint256) {
692         uint256 c = a + b;
693         require(c >= a);
694 
695         return c;
696     }
697 
698     /**
699     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
700     * reverts when dividing by zero.
701     */
702     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
703         require(b != 0);
704         return a % b;
705     }
706 
707     /**
708     * @dev Returns ceil(a / b).
709     */
710     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
711         uint256 c = a / b;
712         if(a % b == 0) {
713             return c;
714         }
715         else {
716             return c + 1;
717         }
718     }
719 
720     // from DSMath - operations on fixed precision floats
721 
722     uint256 constant WAD = 10 ** 18;
723     uint256 constant RAY = 10 ** 27;
724 
725     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
726         z = add(mul(x, y), WAD / 2) / WAD;
727     }
728     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
729         z = add(mul(x, y), RAY / 2) / RAY;
730     }
731     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
732         z = add(mul(x, WAD), y / 2) / y;
733     }
734     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
735         z = add(mul(x, RAY), y / 2) / y;
736     }
737 }
738 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
739 
740 // This program is free software: you can redistribute it and/or modify
741 // it under the terms of the GNU General Public License as published by
742 // the Free Software Foundation, either version 3 of the License, or
743 // (at your option) any later version.
744 
745 // This program is distributed in the hope that it will be useful,
746 // but WITHOUT ANY WARRANTY; without even the implied warranty of
747 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
748 // GNU General Public License for more details.
749 
750 // You should have received a copy of the GNU General Public License
751 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
752 
753 
754 
755 
756 
757 
758 
759 /**
760  * @title BaseModule
761  * @dev Basic module that contains some methods common to all modules.
762  * @author Julien Niset - <julien@argent.im>
763  */
764 contract BaseModule is Module {
765 
766     // Empty calldata
767     bytes constant internal EMPTY_BYTES = "";
768 
769     // The adddress of the module registry.
770     ModuleRegistry internal registry;
771     // The address of the Guardian storage
772     GuardianStorage internal guardianStorage;
773 
774     /**
775      * @dev Throws if the wallet is locked.
776      */
777     modifier onlyWhenUnlocked(BaseWallet _wallet) {
778         // solium-disable-next-line security/no-block-members
779         require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
780         _;
781     }
782 
783     event ModuleCreated(bytes32 name);
784     event ModuleInitialised(address wallet);
785 
786     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
787         registry = _registry;
788         guardianStorage = _guardianStorage;
789         emit ModuleCreated(_name);
790     }
791 
792     /**
793      * @dev Throws if the sender is not the target wallet of the call.
794      */
795     modifier onlyWallet(BaseWallet _wallet) {
796         require(msg.sender == address(_wallet), "BM: caller must be wallet");
797         _;
798     }
799 
800     /**
801      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
802      */
803     modifier onlyWalletOwner(BaseWallet _wallet) {
804         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
805         _;
806     }
807 
808     /**
809      * @dev Throws if the sender is not the owner of the target wallet.
810      */
811     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
812         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
813         _;
814     }
815 
816     /**
817      * @dev Inits the module for a wallet by logging an event.
818      * The method can only be called by the wallet itself.
819      * @param _wallet The wallet.
820      */
821     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
822         emit ModuleInitialised(address(_wallet));
823     }
824 
825     /**
826      * @dev Adds a module to a wallet. First checks that the module is registered.
827      * @param _wallet The target wallet.
828      * @param _module The modules to authorise.
829      */
830     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
831         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
832         _wallet.authoriseModule(address(_module), true);
833     }
834 
835     /**
836     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
837     * module by mistake and transfer them to the Module Registry.
838     * @param _token The token to recover.
839     */
840     function recoverToken(address _token) external {
841         uint total = ERC20(_token).balanceOf(address(this));
842         ERC20(_token).transfer(address(registry), total);
843     }
844 
845     /**
846      * @dev Helper method to check if an address is the owner of a target wallet.
847      * @param _wallet The target wallet.
848      * @param _addr The address.
849      */
850     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
851         return _wallet.owner() == _addr;
852     }
853 
854     /**
855      * @dev Helper method to invoke a wallet.
856      * @param _wallet The target wallet.
857      * @param _to The target address for the transaction.
858      * @param _value The value of the transaction.
859      * @param _data The data of the transaction.
860      */
861     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
862         bool success;
863         // solium-disable-next-line security/no-call-value
864         (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
865         if (success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
866             (_res) = abi.decode(_res, (bytes));
867         } else if (_res.length > 0) {
868             // solium-disable-next-line security/no-inline-assembly
869             assembly {
870                 returndatacopy(0, 0, returndatasize)
871                 revert(0, returndatasize)
872             }
873         } else if (!success) {
874             revert("BM: wallet invoke reverted");
875         }
876     }
877 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
878 
879 // This program is free software: you can redistribute it and/or modify
880 // it under the terms of the GNU General Public License as published by
881 // the Free Software Foundation, either version 3 of the License, or
882 // (at your option) any later version.
883 
884 // This program is distributed in the hope that it will be useful,
885 // but WITHOUT ANY WARRANTY; without even the implied warranty of
886 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
887 // GNU General Public License for more details.
888 
889 // You should have received a copy of the GNU General Public License
890 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
891 
892 
893 
894 /**
895  * @title RelayerModule
896  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
897  * @author Julien Niset - <julien@argent.im>
898  */
899 contract RelayerModule is BaseModule {
900 
901     uint256 constant internal BLOCKBOUND = 10000;
902 
903     mapping (address => RelayerConfig) public relayer;
904 
905     struct RelayerConfig {
906         uint256 nonce;
907         mapping (bytes32 => bool) executedTx;
908     }
909 
910     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
911 
912     /**
913      * @dev Throws if the call did not go through the execute() method.
914      */
915     modifier onlyExecute {
916         require(msg.sender == address(this), "RM: must be called via execute()");
917         _;
918     }
919 
920     /* ***************** Abstract method ************************* */
921 
922     /**
923     * @dev Gets the number of valid signatures that must be provided to execute a
924     * specific relayed transaction.
925     * @param _wallet The target wallet.
926     * @param _data The data of the relayed transaction.
927     * @return The number of required signatures.
928     */
929     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
930 
931     /**
932     * @dev Validates the signatures provided with a relayed transaction.
933     * The method MUST throw if one or more signatures are not valid.
934     * @param _wallet The target wallet.
935     * @param _data The data of the relayed transaction.
936     * @param _signHash The signed hash representing the relayed transaction.
937     * @param _signatures The signatures as a concatenated byte array.
938     */
939     function validateSignatures(
940         BaseWallet _wallet,
941         bytes memory _data,
942         bytes32 _signHash,
943         bytes memory _signatures) internal view returns (bool);
944 
945     /* ************************************************************ */
946 
947     /**
948     * @dev Executes a relayed transaction.
949     * @param _wallet The target wallet.
950     * @param _data The data for the relayed transaction
951     * @param _nonce The nonce used to prevent replay attacks.
952     * @param _signatures The signatures as a concatenated byte array.
953     * @param _gasPrice The gas price to use for the gas refund.
954     * @param _gasLimit The gas limit to use for the gas refund.
955     */
956     function execute(
957         BaseWallet _wallet,
958         bytes calldata _data,
959         uint256 _nonce,
960         bytes calldata _signatures,
961         uint256 _gasPrice,
962         uint256 _gasLimit
963     )
964         external
965         returns (bool success)
966     {
967         uint startGas = gasleft();
968         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
969         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
970         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
971         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
972         if ((requiredSignatures * 65) == _signatures.length) {
973             if (verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
974                 if (requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
975                     // solium-disable-next-line security/no-call-value
976                     (success,) = address(this).call(_data);
977                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
978                 }
979             }
980         }
981         emit TransactionExecuted(address(_wallet), success, signHash);
982     }
983 
984     /**
985     * @dev Gets the current nonce for a wallet.
986     * @param _wallet The target wallet.
987     */
988     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
989         return relayer[address(_wallet)].nonce;
990     }
991 
992     /**
993     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
994     * @param _from The starting address for the relayed transaction (should be the module)
995     * @param _to The destination address for the relayed transaction (should be the wallet)
996     * @param _value The value for the relayed transaction
997     * @param _data The data for the relayed transaction
998     * @param _nonce The nonce used to prevent replay attacks.
999     * @param _gasPrice The gas price to use for the gas refund.
1000     * @param _gasLimit The gas limit to use for the gas refund.
1001     */
1002     function getSignHash(
1003         address _from,
1004         address _to,
1005         uint256 _value,
1006         bytes memory _data,
1007         uint256 _nonce,
1008         uint256 _gasPrice,
1009         uint256 _gasLimit
1010     )
1011         internal
1012         pure
1013         returns (bytes32)
1014     {
1015         return keccak256(
1016             abi.encodePacked(
1017                 "\x19Ethereum Signed Message:\n32",
1018                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
1019         ));
1020     }
1021 
1022     /**
1023     * @dev Checks if the relayed transaction is unique.
1024     * @param _wallet The target wallet.
1025     * @param _signHash The signed hash of the transaction
1026     */
1027     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 /* _nonce */, bytes32 _signHash) internal returns (bool) {
1028         if (relayer[address(_wallet)].executedTx[_signHash] == true) {
1029             return false;
1030         }
1031         relayer[address(_wallet)].executedTx[_signHash] = true;
1032         return true;
1033     }
1034 
1035     /**
1036     * @dev Checks that a nonce has the correct format and is valid.
1037     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
1038     * @param _wallet The target wallet.
1039     * @param _nonce The nonce
1040     */
1041     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
1042         if (_nonce <= relayer[address(_wallet)].nonce) {
1043             return false;
1044         }
1045         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
1046         if (nonceBlock > block.number + BLOCKBOUND) {
1047             return false;
1048         }
1049         relayer[address(_wallet)].nonce = _nonce;
1050         return true;
1051     }
1052 
1053     /**
1054     * @dev Recovers the signer at a given position from a list of concatenated signatures.
1055     * @param _signedHash The signed hash
1056     * @param _signatures The concatenated signatures.
1057     * @param _index The index of the signature to recover.
1058     */
1059     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
1060         uint8 v;
1061         bytes32 r;
1062         bytes32 s;
1063         // we jump 32 (0x20) as the first slot of bytes contains the length
1064         // we jump 65 (0x41) per signature
1065         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
1066         // solium-disable-next-line security/no-inline-assembly
1067         assembly {
1068             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
1069             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
1070             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
1071         }
1072         require(v == 27 || v == 28); // solium-disable-line error-reason
1073         return ecrecover(_signedHash, v, r, s);
1074     }
1075 
1076     /**
1077     * @dev Refunds the gas used to the Relayer.
1078     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures.
1079     * @param _wallet The target wallet.
1080     * @param _gasUsed The gas used.
1081     * @param _gasPrice The gas price for the refund.
1082     * @param _gasLimit The gas limit for the refund.
1083     * @param _signatures The number of signatures used in the call.
1084     * @param _relayer The address of the Relayer.
1085     */
1086     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
1087         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
1088         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
1089         if (_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
1090             if (_gasPrice > tx.gasprice) {
1091                 amount = amount * tx.gasprice;
1092             } else {
1093                 amount = amount * _gasPrice;
1094             }
1095             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
1096         }
1097     }
1098 
1099     /**
1100     * @dev Returns false if the refund is expected to fail.
1101     * @param _wallet The target wallet.
1102     * @param _gasUsed The expected gas used.
1103     * @param _gasPrice The expected gas price for the refund.
1104     */
1105     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1106         if (_gasPrice > 0 &&
1107             _signatures > 1 &&
1108             (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
1109             return false;
1110         }
1111         return true;
1112     }
1113 
1114     /**
1115     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
1116     * as the wallet passed as the input of the execute() method.
1117     @return false if the addresses are different.
1118     */
1119     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
1120         require(_data.length >= 36, "RM: Invalid dataWallet");
1121         address dataWallet;
1122         // solium-disable-next-line security/no-inline-assembly
1123         assembly {
1124             //_data = {length:32}{sig:4}{_wallet:32}{...}
1125             dataWallet := mload(add(_data, 0x24))
1126         }
1127         return dataWallet == _wallet;
1128     }
1129 
1130     /**
1131     * @dev Parses the data to extract the method signature.
1132     */
1133     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
1134         require(_data.length >= 4, "RM: Invalid functionPrefix");
1135         // solium-disable-next-line security/no-inline-assembly
1136         assembly {
1137             prefix := mload(add(_data, 0x20))
1138         }
1139     }
1140 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1141 
1142 // This program is free software: you can redistribute it and/or modify
1143 // it under the terms of the GNU General Public License as published by
1144 // the Free Software Foundation, either version 3 of the License, or
1145 // (at your option) any later version.
1146 
1147 // This program is distributed in the hope that it will be useful,
1148 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1149 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1150 // GNU General Public License for more details.
1151 
1152 // You should have received a copy of the GNU General Public License
1153 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1154 
1155 
1156 
1157 
1158 /**
1159  * @title OnlyOwnerModule
1160  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
1161  * must be called with one signature frm the owner.
1162  * @author Julien Niset - <julien@argent.im>
1163  */
1164 contract OnlyOwnerModule is BaseModule, RelayerModule {
1165 
1166     // bytes4 private constant IS_ONLY_OWNER_MODULE = bytes4(keccak256("isOnlyOwnerModule()"));
1167 
1168    /**
1169     * @dev Returns a constant that indicates that the module is an OnlyOwnerModule.
1170     * @return The constant bytes4(keccak256("isOnlyOwnerModule()"))
1171     */
1172     function isOnlyOwnerModule() external pure returns (bytes4) {
1173         // return IS_ONLY_OWNER_MODULE;
1174         return this.isOnlyOwnerModule.selector;
1175     }
1176 
1177     /**
1178      * @dev Adds a module to a wallet. First checks that the module is registered.
1179      * Unlike its overrided parent, this method can be called via the RelayerModule's execute()
1180      * @param _wallet The target wallet.
1181      * @param _module The modules to authorise.
1182      */
1183     function addModule(BaseWallet _wallet, Module _module) external onlyWalletOwner(_wallet) {
1184         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
1185         _wallet.authoriseModule(address(_module), true);
1186     }
1187 
1188     // *************** Implementation of RelayerModule methods ********************* //
1189 
1190     // Overrides to use the incremental nonce and save some gas
1191     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 /* _signHash */) internal returns (bool) {
1192         return checkAndUpdateNonce(_wallet, _nonce);
1193     }
1194 
1195     function validateSignatures(
1196         BaseWallet _wallet,
1197         bytes memory /* _data */,
1198         bytes32 _signHash,
1199         bytes memory _signatures
1200     )
1201         internal
1202         view
1203         returns (bool)
1204     {
1205         address signer = recoverSigner(_signHash, _signatures, 0);
1206         return isOwner(_wallet, signer); // "OOM: signer must be owner"
1207     }
1208 
1209     function getRequiredSignatures(BaseWallet /* _wallet */, bytes memory /* _data */) internal view returns (uint256) {
1210         return 1;
1211     }
1212 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1213 
1214 // This program is free software: you can redistribute it and/or modify
1215 // it under the terms of the GNU General Public License as published by
1216 // the Free Software Foundation, either version 3 of the License, or
1217 // (at your option) any later version.
1218 
1219 // This program is distributed in the hope that it will be useful,
1220 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1221 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1222 // GNU General Public License for more details.
1223 
1224 // You should have received a copy of the GNU General Public License
1225 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1226 
1227 
1228 /**
1229  * @title BaseTransfer
1230  * @dev Module containing internal methods to execute or approve transfers
1231  * @author Olivier VDB - <olivier@argent.xyz>
1232  */
1233 contract BaseTransfer is BaseModule {
1234 
1235     // Mock token address for ETH
1236     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1237 
1238     // *************** Events *************************** //
1239 
1240     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);
1241     event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
1242     event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);
1243     event ApprovedAndCalledContract(
1244         address indexed wallet,
1245         address indexed to,
1246         address spender,
1247         address indexed token,
1248         uint256 amountApproved,
1249         uint256 amountSpent,
1250         bytes data
1251     );
1252     // *************** Internal Functions ********************* //
1253 
1254     /**
1255     * @dev Helper method to transfer ETH or ERC20 for a wallet.
1256     * @param _wallet The target wallet.
1257     * @param _token The ERC20 address.
1258     * @param _to The recipient.
1259     * @param _value The amount of ETH to transfer
1260     * @param _data The data to *log* with the transfer.
1261     */
1262     function doTransfer(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes memory _data) internal {
1263         if (_token == ETH_TOKEN) {
1264             invokeWallet(address(_wallet), _to, _value, EMPTY_BYTES);
1265         } else {
1266             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
1267             invokeWallet(address(_wallet), _token, 0, methodData);
1268         }
1269         emit Transfer(address(_wallet), _token, _value, _to, _data);
1270     }
1271 
1272     /**
1273     * @dev Helper method to approve spending the ERC20 of a wallet.
1274     * @param _wallet The target wallet.
1275     * @param _token The ERC20 address.
1276     * @param _spender The spender address.
1277     * @param _value The amount of token to transfer.
1278     */
1279     function doApproveToken(BaseWallet _wallet, address _token, address _spender, uint256 _value) internal {
1280         bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, _value);
1281         invokeWallet(address(_wallet), _token, 0, methodData);
1282         emit Approved(address(_wallet), _token, _value, _spender);
1283     }
1284 
1285     /**
1286     * @dev Helper method to call an external contract.
1287     * @param _wallet The target wallet.
1288     * @param _contract The contract address.
1289     * @param _value The ETH value to transfer.
1290     * @param _data The method data.
1291     */
1292     function doCallContract(BaseWallet _wallet, address _contract, uint256 _value, bytes memory _data) internal {
1293         invokeWallet(address(_wallet), _contract, _value, _data);
1294         emit CalledContract(address(_wallet), _contract, _value, _data);
1295     }
1296 
1297     /**
1298     * @dev Helper method to approve a certain amount of token and call an external contract.
1299     * The address that spends the _token and the address that is called with _data can be different.
1300     * @param _wallet The target wallet.
1301     * @param _token The ERC20 address.
1302     * @param _spender The spender address.
1303     * @param _amount The amount of tokens to transfer.
1304     * @param _contract The contract address.
1305     * @param _data The method data.
1306     */
1307     function doApproveTokenAndCallContract(
1308         BaseWallet _wallet,
1309         address _token,
1310         address _spender,
1311         uint256 _amount,
1312         address _contract,
1313         bytes memory _data
1314     )
1315         internal
1316     {
1317         uint256 existingAllowance = ERC20(_token).allowance(address(_wallet), _spender);
1318         uint256 totalAllowance = SafeMath.add(existingAllowance, _amount);
1319         // Approve the desired amount plus existing amount. This logic allows for potential gas saving later
1320         // when restoring the original approved amount, in cases where the _spender uses the exact approved _amount.
1321         bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, totalAllowance);
1322 
1323         invokeWallet(address(_wallet), _token, 0, methodData);
1324         invokeWallet(address(_wallet), _contract, 0, _data);
1325 
1326         // Calculate the approved amount that was spent after the call
1327         uint256 unusedAllowance = ERC20(_token).allowance(address(_wallet), _spender);
1328         uint256 usedAllowance = SafeMath.sub(totalAllowance, unusedAllowance);
1329         // Ensure the amount spent does not exceed the amount approved for this call
1330         require(usedAllowance <= _amount, "BT: insufficient amount for call");
1331 
1332         if (unusedAllowance != existingAllowance) {
1333             // Restore the original allowance amount if the amount spent was different (can be lower).
1334             methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, existingAllowance);
1335             invokeWallet(address(_wallet), _token, 0, methodData);
1336         }
1337 
1338         emit ApprovedAndCalledContract(
1339             address(_wallet),
1340             _contract,
1341             _spender,
1342             _token,
1343             _amount,
1344             usedAllowance,
1345             _data);
1346     }
1347 }
1348 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1349 
1350 // This program is free software: you can redistribute it and/or modify
1351 // it under the terms of the GNU General Public License as published by
1352 // the Free Software Foundation, either version 3 of the License, or
1353 // (at your option) any later version.
1354 
1355 // This program is distributed in the hope that it will be useful,
1356 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1357 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1358 // GNU General Public License for more details.
1359 
1360 // You should have received a copy of the GNU General Public License
1361 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1362 
1363 
1364 
1365 /**
1366  * @title LimitManager
1367  * @dev Module to manage a daily spending limit
1368  * @author Julien Niset - <julien@argent.im>
1369  */
1370 contract LimitManager is BaseModule {
1371 
1372     // large limit when the limit can be considered disabled
1373     uint128 constant private LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38
1374 
1375     using SafeMath for uint256;
1376 
1377     struct LimitManagerConfig {
1378         // The daily limit
1379         Limit limit;
1380         // The current usage
1381         DailySpent dailySpent;
1382     }
1383 
1384     struct Limit {
1385         // the current limit
1386         uint128 current;
1387         // the pending limit if any
1388         uint128 pending;
1389         // when the pending limit becomes the current limit
1390         uint64 changeAfter;
1391     }
1392 
1393     struct DailySpent {
1394         // The amount already spent during the current period
1395         uint128 alreadySpent;
1396         // The end of the current period
1397         uint64 periodEnd;
1398     }
1399 
1400     // wallet specific storage
1401     mapping (address => LimitManagerConfig) internal limits;
1402     // The default limit
1403     uint256 public defaultLimit;
1404 
1405     // *************** Events *************************** //
1406 
1407     event LimitChanged(address indexed wallet, uint indexed newLimit, uint64 indexed startAfter);
1408 
1409     // *************** Constructor ********************** //
1410 
1411     constructor(uint256 _defaultLimit) public {
1412         defaultLimit = _defaultLimit;
1413     }
1414 
1415     // *************** External/Public Functions ********************* //
1416 
1417     /**
1418      * @dev Inits the module for a wallet by setting the limit to the default value.
1419      * @param _wallet The target wallet.
1420      */
1421     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
1422         Limit storage limit = limits[address(_wallet)].limit;
1423         if (limit.current == 0 && limit.changeAfter == 0) {
1424             limit.current = uint128(defaultLimit);
1425         }
1426     }
1427 
1428     // *************** Internal Functions ********************* //
1429 
1430     /**
1431      * @dev Changes the daily limit.
1432      * The limit is expressed in ETH and the change is pending for the security period.
1433      * @param _wallet The target wallet.
1434      * @param _newLimit The new limit.
1435      * @param _securityPeriod The security period.
1436      */
1437     function changeLimit(BaseWallet _wallet, uint256 _newLimit, uint256 _securityPeriod) internal {
1438         Limit storage limit = limits[address(_wallet)].limit;
1439         // solium-disable-next-line security/no-block-members
1440         uint128 current = (limit.changeAfter > 0 && limit.changeAfter < now) ? limit.pending : limit.current;
1441         limit.current = current;
1442         limit.pending = uint128(_newLimit);
1443         // solium-disable-next-line security/no-block-members
1444         limit.changeAfter = uint64(now.add(_securityPeriod));
1445         // solium-disable-next-line security/no-block-members
1446         emit LimitChanged(address(_wallet), _newLimit, uint64(now.add(_securityPeriod)));
1447     }
1448 
1449      /**
1450      * @dev Disable the daily limit.
1451      * The change is pending for the security period.
1452      * @param _wallet The target wallet.
1453      * @param _securityPeriod The security period.
1454      */
1455     function disableLimit(BaseWallet _wallet, uint256 _securityPeriod) internal {
1456         changeLimit(_wallet, LIMIT_DISABLED, _securityPeriod);
1457     }
1458 
1459     /**
1460     * @dev Gets the current daily limit for a wallet.
1461     * @param _wallet The target wallet.
1462     * @return the current limit expressed in ETH.
1463     */
1464     function getCurrentLimit(BaseWallet _wallet) public view returns (uint256 _currentLimit) {
1465         Limit storage limit = limits[address(_wallet)].limit;
1466         _currentLimit = uint256(currentLimit(limit.current, limit.pending, limit.changeAfter));
1467     }
1468 
1469     /**
1470     * @dev Returns whether the daily limit is disabled for a wallet.
1471     * @param _wallet The target wallet.
1472     * @return true if the daily limit is disabled, false otherwise.
1473     */
1474     function isLimitDisabled(BaseWallet _wallet) public view returns (bool _limitDisabled) {
1475         uint256 currentLimit = getCurrentLimit(_wallet);
1476         _limitDisabled = currentLimit == LIMIT_DISABLED;
1477     }
1478 
1479     /**
1480     * @dev Gets a pending limit for a wallet if any.
1481     * @param _wallet The target wallet.
1482     * @return the pending limit (in ETH) and the time at chich it will become effective.
1483     */
1484     function getPendingLimit(BaseWallet _wallet) external view returns (uint256 _pendingLimit, uint64 _changeAfter) {
1485         Limit storage limit = limits[address(_wallet)].limit;
1486         // solium-disable-next-line security/no-block-members
1487         return ((now < limit.changeAfter)? (uint256(limit.pending), limit.changeAfter) : (0,0));
1488     }
1489 
1490     /**
1491     * @dev Gets the amount of tokens that has not yet been spent during the current period.
1492     * @param _wallet The target wallet.
1493     * @return the amount of tokens (in ETH) that has not been spent yet and the end of the period.
1494     */
1495     function getDailyUnspent(BaseWallet _wallet) external view returns (uint256 _unspent, uint64 _periodEnd) {
1496         uint256 limit = getCurrentLimit(_wallet);
1497         DailySpent storage expense = limits[address(_wallet)].dailySpent;
1498         // solium-disable-next-line security/no-block-members
1499         if (now > expense.periodEnd) {
1500             _unspent = limit;
1501             // solium-disable-next-line security/no-block-members
1502             _periodEnd = uint64(now + 24 hours);
1503         } else {
1504             _periodEnd = expense.periodEnd;
1505             if (expense.alreadySpent < limit) {
1506                 _unspent = limit - expense.alreadySpent;
1507             }
1508         }
1509     }
1510 
1511     /**
1512     * @dev Helper method to check if a transfer is within the limit.
1513     * If yes the daily unspent for the current period is updated.
1514     * @param _wallet The target wallet.
1515     * @param _amount The amount for the transfer
1516     */
1517     function checkAndUpdateDailySpent(BaseWallet _wallet, uint _amount) internal returns (bool) {
1518         if (_amount == 0)
1519             return true;
1520         Limit storage limit = limits[address(_wallet)].limit;
1521         uint128 current = currentLimit(limit.current, limit.pending, limit.changeAfter);
1522         if (isWithinDailyLimit(_wallet, current, _amount)) {
1523             updateDailySpent(_wallet, current, _amount);
1524             return true;
1525         }
1526         return false;
1527     }
1528 
1529     /**
1530     * @dev Helper method to update the daily spent for the current period.
1531     * @param _wallet The target wallet.
1532     * @param _limit The current limit for the wallet.
1533     * @param _amount The amount to add to the daily spent.
1534     */
1535     function updateDailySpent(BaseWallet _wallet, uint128 _limit, uint _amount) internal {
1536         if (_limit != LIMIT_DISABLED) {
1537             DailySpent storage expense = limits[address(_wallet)].dailySpent;
1538             // solium-disable-next-line security/no-block-members
1539             if (expense.periodEnd < now) {
1540                 // solium-disable-next-line security/no-block-members
1541                 expense.periodEnd = uint64(now + 24 hours);
1542                 expense.alreadySpent = uint128(_amount);
1543             } else {
1544                 expense.alreadySpent += uint128(_amount);
1545             }
1546         }
1547     }
1548 
1549     /**
1550     * @dev Checks if a transfer amount is withing the daily limit for a wallet.
1551     * @param _wallet The target wallet.
1552     * @param _limit The current limit for the wallet.
1553     * @param _amount The transfer amount.
1554     * @return true if the transfer amount is withing the daily limit.
1555     */
1556     function isWithinDailyLimit(BaseWallet _wallet, uint _limit, uint _amount) internal view returns (bool) {
1557         if (_limit == LIMIT_DISABLED) {
1558             return true;
1559         }
1560         DailySpent storage expense = limits[address(_wallet)].dailySpent;
1561         // solium-disable-next-line security/no-block-members
1562         if (expense.periodEnd < now) {
1563             return (_amount <= _limit);
1564         } else {
1565             return (expense.alreadySpent + _amount <= _limit && expense.alreadySpent + _amount >= expense.alreadySpent);
1566         }
1567     }
1568 
1569     /**
1570     * @dev Helper method to get the current limit from a Limit struct.
1571     * @param _current The value of the current parameter
1572     * @param _pending The value of the pending parameter
1573     * @param _changeAfter The value of the changeAfter parameter
1574     */
1575     function currentLimit(uint128 _current, uint128 _pending, uint64 _changeAfter) internal view returns (uint128) {
1576         // solium-disable-next-line security/no-block-members
1577         if (_changeAfter > 0 && _changeAfter < now) {
1578             return _pending;
1579         }
1580         return _current;
1581     }
1582 
1583 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1584 
1585 // This program is free software: you can redistribute it and/or modify
1586 // it under the terms of the GNU General Public License as published by
1587 // the Free Software Foundation, either version 3 of the License, or
1588 // (at your option) any later version.
1589 
1590 // This program is distributed in the hope that it will be useful,
1591 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1592 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1593 // GNU General Public License for more details.
1594 
1595 // You should have received a copy of the GNU General Public License
1596 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1597 
1598 
1599 
1600 /**
1601  * @title TransferStorage
1602  * @dev Contract storing the state of wallets related to transfers (limit and whitelist).
1603  * The contract only defines basic setters and getters with no logic. Only modules authorised
1604  * for a wallet can modify its state.
1605  * @author Julien Niset - <julien@argent.im>
1606  */
1607 contract TransferStorage is Storage {
1608 
1609     // wallet specific storage
1610     mapping (address => mapping (address => uint256)) internal whitelist;
1611 
1612     // *************** External Functions ********************* //
1613 
1614     /**
1615      * @dev Lets an authorised module add or remove an account from the whitelist of a wallet.
1616      * @param _wallet The target wallet.
1617      * @param _target The account to add/remove.
1618      * @param _value True for addition, false for revokation.
1619      */
1620     function setWhitelist(BaseWallet _wallet, address _target, uint256 _value) external onlyModule(_wallet) {
1621         whitelist[address(_wallet)][_target] = _value;
1622     }
1623 
1624     /**
1625      * @dev Gets the whitelist state of an account for a wallet.
1626      * @param _wallet The target wallet.
1627      * @param _target The account.
1628      * @return the epoch time at which an account strats to be whitelisted, or zero if the account is not whitelisted.
1629      */
1630     function getWhitelist(BaseWallet _wallet, address _target) external view returns (uint256) {
1631         return whitelist[address(_wallet)][_target];
1632     }
1633 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1634 
1635 // This program is free software: you can redistribute it and/or modify
1636 // it under the terms of the GNU General Public License as published by
1637 // the Free Software Foundation, either version 3 of the License, or
1638 // (at your option) any later version.
1639 
1640 // This program is distributed in the hope that it will be useful,
1641 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1642 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1643 // GNU General Public License for more details.
1644 
1645 // You should have received a copy of the GNU General Public License
1646 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1647 
1648 
1649 /**
1650  * @title Managed
1651  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
1652  * @author Julien Niset - <julien@argent.im>
1653  */
1654 contract Managed is Owned {
1655 
1656     // The managers
1657     mapping (address => bool) public managers;
1658 
1659     /**
1660      * @dev Throws if the sender is not a manager.
1661      */
1662     modifier onlyManager {
1663         require(managers[msg.sender] == true, "M: Must be manager");
1664         _;
1665     }
1666 
1667     event ManagerAdded(address indexed _manager);
1668     event ManagerRevoked(address indexed _manager);
1669 
1670     /**
1671     * @dev Adds a manager.
1672     * @param _manager The address of the manager.
1673     */
1674     function addManager(address _manager) external onlyOwner {
1675         require(_manager != address(0), "M: Address must not be null");
1676         if (managers[_manager] == false) {
1677             managers[_manager] = true;
1678             emit ManagerAdded(_manager);
1679         }
1680     }
1681 
1682     /**
1683     * @dev Revokes a manager.
1684     * @param _manager The address of the manager.
1685     */
1686     function revokeManager(address _manager) external onlyOwner {
1687         require(managers[_manager] == true, "M: Target must be an existing manager");
1688         delete managers[_manager];
1689         emit ManagerRevoked(_manager);
1690     }
1691 }
1692 
1693 contract KyberNetwork {
1694 
1695     function getExpectedRate(
1696         ERC20 src,
1697         ERC20 dest,
1698         uint srcQty
1699     )
1700         public
1701         view
1702         returns (uint expectedRate, uint slippageRate);
1703 
1704     function trade(
1705         ERC20 src,
1706         uint srcAmount,
1707         ERC20 dest,
1708         address payable destAddress,
1709         uint maxDestAmount,
1710         uint minConversionRate,
1711         address walletId
1712     )
1713         public
1714         payable
1715         returns(uint);
1716 }
1717 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1718 
1719 // This program is free software: you can redistribute it and/or modify
1720 // it under the terms of the GNU General Public License as published by
1721 // the Free Software Foundation, either version 3 of the License, or
1722 // (at your option) any later version.
1723 
1724 // This program is distributed in the hope that it will be useful,
1725 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1726 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1727 // GNU General Public License for more details.
1728 
1729 // You should have received a copy of the GNU General Public License
1730 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1731 
1732 
1733 
1734 
1735 
1736 contract TokenPriceProvider is Managed {
1737 
1738     // Mock token address for ETH
1739     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1740 
1741     using SafeMath for uint256;
1742 
1743     mapping(address => uint256) public cachedPrices;
1744 
1745     // Address of the KyberNetwork contract
1746     KyberNetwork public kyberNetwork;
1747 
1748     constructor(KyberNetwork _kyberNetwork) public {
1749         kyberNetwork = _kyberNetwork;
1750     }
1751 
1752     function setPrice(ERC20 _token, uint256 _price) public onlyManager {
1753         cachedPrices[address(_token)] = _price;
1754     }
1755 
1756     function setPriceForTokenList(ERC20[] calldata _tokens, uint256[] calldata _prices) external onlyManager {
1757         for (uint16 i = 0; i < _tokens.length; i++) {
1758             setPrice(_tokens[i], _prices[i]);
1759         }
1760     }
1761 
1762     /**
1763      * @dev Converts the value of _amount tokens in ether.
1764      * @param _amount the amount of tokens to convert (in 'token wei' twei)
1765      * @param _token the ERC20 token contract
1766      * @return the ether value (in wei) of _amount tokens with contract _token
1767      */
1768     function getEtherValue(uint256 _amount, address _token) external view returns (uint256) {
1769         uint256 decimals = ERC20(_token).decimals();
1770         uint256 price = cachedPrices[_token];
1771         return price.mul(_amount).div(10**decimals);
1772     }
1773 
1774     //
1775     // The following is added to be backward-compatible with Argent's old backend
1776     //
1777 
1778     function setKyberNetwork(KyberNetwork _kyberNetwork) external onlyManager {
1779         kyberNetwork = _kyberNetwork;
1780     }
1781 
1782     function syncPrice(ERC20 _token) external {
1783         require(address(kyberNetwork) != address(0), "Kyber sync is disabled");
1784         (uint256 expectedRate,) = kyberNetwork.getExpectedRate(_token, ERC20(ETH_TOKEN_ADDRESS), 10000);
1785         cachedPrices[address(_token)] = expectedRate;
1786     }
1787 
1788     function syncPriceForTokenList(ERC20[] calldata _tokens) external {
1789         require(address(kyberNetwork) != address(0), "Kyber sync is disabled");
1790         for (uint16 i = 0; i < _tokens.length; i++) {
1791             (uint256 expectedRate,) = kyberNetwork.getExpectedRate(_tokens[i], ERC20(ETH_TOKEN_ADDRESS), 10000);
1792             cachedPrices[address(_tokens[i])] = expectedRate;
1793         }
1794     }
1795 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1796 
1797 // This program is free software: you can redistribute it and/or modify
1798 // it under the terms of the GNU General Public License as published by
1799 // the Free Software Foundation, either version 3 of the License, or
1800 // (at your option) any later version.
1801 
1802 // This program is distributed in the hope that it will be useful,
1803 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1804 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1805 // GNU General Public License for more details.
1806 
1807 // You should have received a copy of the GNU General Public License
1808 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1809 
1810 
1811 
1812 
1813 
1814 
1815 
1816 
1817 
1818 
1819 /**
1820  * @title TransferManager
1821  * @dev Module to transfer and approve tokens (ETH or ERC20) or data (contract call) based on a security context (daily limit, whitelist, etc).
1822  * This module is the V2 of TokenTransfer.
1823  * @author Julien Niset - <julien@argent.xyz>
1824  */
1825 contract TransferManager is BaseModule, RelayerModule, OnlyOwnerModule, BaseTransfer, LimitManager {
1826 
1827     bytes32 constant NAME = "TransferManager";
1828 
1829     bytes4 private constant ERC1271_ISVALIDSIGNATURE_BYTES = bytes4(keccak256("isValidSignature(bytes,bytes)"));
1830     bytes4 private constant ERC1271_ISVALIDSIGNATURE_BYTES32 = bytes4(keccak256("isValidSignature(bytes32,bytes)"));
1831 
1832     enum ActionType { Transfer }
1833 
1834     using SafeMath for uint256;
1835 
1836     struct TokenManagerConfig {
1837         // Mapping between pending action hash and their timestamp
1838         mapping (bytes32 => uint256) pendingActions;
1839     }
1840 
1841     // wallet specific storage
1842     mapping (address => TokenManagerConfig) internal configs;
1843 
1844     // The security period
1845     uint256 public securityPeriod;
1846     // The execution window
1847     uint256 public securityWindow;
1848     // The Token storage
1849     TransferStorage public transferStorage;
1850     // The Token price provider
1851     TokenPriceProvider public priceProvider;
1852     // The previous limit manager needed to migrate the limits
1853     LimitManager public oldLimitManager;
1854 
1855     // *************** Events *************************** //
1856 
1857     event AddedToWhitelist(address indexed wallet, address indexed target, uint64 whitelistAfter);
1858     event RemovedFromWhitelist(address indexed wallet, address indexed target);
1859     event PendingTransferCreated(address indexed wallet, bytes32 indexed id, uint256 indexed executeAfter,
1860     address token, address to, uint256 amount, bytes data);
1861     event PendingTransferExecuted(address indexed wallet, bytes32 indexed id);
1862     event PendingTransferCanceled(address indexed wallet, bytes32 indexed id);
1863 
1864     // *************** Constructor ********************** //
1865 
1866     constructor(
1867         ModuleRegistry _registry,
1868         TransferStorage _transferStorage,
1869         GuardianStorage _guardianStorage,
1870         address _priceProvider,
1871         uint256 _securityPeriod,
1872         uint256 _securityWindow,
1873         uint256 _defaultLimit,
1874         LimitManager _oldLimitManager
1875     )
1876         BaseModule(_registry, _guardianStorage, NAME)
1877         LimitManager(_defaultLimit)
1878         public
1879     {
1880         transferStorage = _transferStorage;
1881         priceProvider = TokenPriceProvider(_priceProvider);
1882         securityPeriod = _securityPeriod;
1883         securityWindow = _securityWindow;
1884         oldLimitManager = _oldLimitManager;
1885     }
1886 
1887     /**
1888      * @dev Inits the module for a wallet by setting up the isValidSignature (EIP 1271)
1889      * static call redirection from the wallet to the module and copying all the parameters
1890      * of the daily limit from the previous implementation of the LimitManager module.
1891      * @param _wallet The target wallet.
1892      */
1893     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
1894 
1895         // setup static calls
1896         _wallet.enableStaticCall(address(this), ERC1271_ISVALIDSIGNATURE_BYTES);
1897         _wallet.enableStaticCall(address(this), ERC1271_ISVALIDSIGNATURE_BYTES32);
1898 
1899         // setup default limit for new deployment
1900         if (address(oldLimitManager) == address(0)) {
1901             super.init(_wallet);
1902             return;
1903         }
1904         // get limit from previous LimitManager
1905         uint256 current = oldLimitManager.getCurrentLimit(_wallet);
1906         (uint256 pending, uint64 changeAfter) = oldLimitManager.getPendingLimit(_wallet);
1907         // setup default limit for new wallets
1908         if (current == 0 && changeAfter == 0) {
1909             super.init(_wallet);
1910             return;
1911         }
1912         // migrate existing limit for existing wallets
1913         if (current == pending) {
1914             limits[address(_wallet)].limit.current = uint128(current);
1915         } else {
1916             limits[address(_wallet)].limit = Limit(uint128(current), uint128(pending), changeAfter);
1917         }
1918         // migrate daily pending if we are within a rolling period
1919         (uint256 unspent, uint64 periodEnd) = oldLimitManager.getDailyUnspent(_wallet);
1920         // solium-disable-next-line security/no-block-members
1921         if (periodEnd > now) {
1922             limits[address(_wallet)].dailySpent = DailySpent(uint128(current.sub(unspent)), periodEnd);
1923         }
1924     }
1925 
1926     // *************** External/Public Functions ********************* //
1927 
1928     /**
1929     * @dev lets the owner transfer tokens (ETH or ERC20) from a wallet.
1930     * @param _wallet The target wallet.
1931     * @param _token The address of the token to transfer.
1932     * @param _to The destination address
1933     * @param _amount The amoutn of token to transfer
1934     * @param _data The data for the transaction
1935     */
1936     function transferToken(
1937         BaseWallet _wallet,
1938         address _token,
1939         address _to,
1940         uint256 _amount,
1941         bytes calldata _data
1942     )
1943         external
1944         onlyWalletOwner(_wallet)
1945         onlyWhenUnlocked(_wallet)
1946     {
1947         if (isWhitelisted(_wallet, _to)) {
1948             // transfer to whitelist
1949             doTransfer(_wallet, _token, _to, _amount, _data);
1950         } else {
1951             uint256 etherAmount = (_token == ETH_TOKEN) ? _amount : priceProvider.getEtherValue(_amount, _token);
1952             if (checkAndUpdateDailySpent(_wallet, etherAmount)) {
1953                 // transfer under the limit
1954                 doTransfer(_wallet, _token, _to, _amount, _data);
1955             } else {
1956                 // transfer above the limit
1957                 (bytes32 id, uint256 executeAfter) = addPendingAction(ActionType.Transfer, _wallet, _token, _to, _amount, _data);
1958                 emit PendingTransferCreated(address(_wallet), id, executeAfter, _token, _to, _amount, _data);
1959             }
1960         }
1961     }
1962 
1963     /**
1964     * @dev lets the owner approve an allowance of ERC20 tokens for a spender (dApp).
1965     * @param _wallet The target wallet.
1966     * @param _token The address of the token to transfer.
1967     * @param _spender The address of the spender
1968     * @param _amount The amount of tokens to approve
1969     */
1970     function approveToken(
1971         BaseWallet _wallet,
1972         address _token,
1973         address _spender,
1974         uint256 _amount
1975     )
1976         external
1977         onlyWalletOwner(_wallet)
1978         onlyWhenUnlocked(_wallet)
1979     {
1980         if (isWhitelisted(_wallet, _spender)) {
1981             // approve to whitelist
1982             doApproveToken(_wallet, _token, _spender, _amount);
1983         } else {
1984             // get current alowance
1985             uint256 currentAllowance = ERC20(_token).allowance(address(_wallet), _spender);
1986             if (_amount <= currentAllowance) {
1987                 // approve if we reduce the allowance
1988                 doApproveToken(_wallet, _token, _spender, _amount);
1989             } else {
1990                 // check if delta is under the limit
1991                 uint delta = _amount - currentAllowance;
1992                 uint256 deltaInEth = priceProvider.getEtherValue(delta, _token);
1993                 require(checkAndUpdateDailySpent(_wallet, deltaInEth), "TM: Approve above daily limit");
1994                 // approve if under the limit
1995                 doApproveToken(_wallet, _token, _spender, _amount);
1996             }
1997         }
1998     }
1999 
2000     /**
2001     * @dev lets the owner call a contract.
2002     * @param _wallet The target wallet.
2003     * @param _contract The address of the contract.
2004     * @param _value The amount of ETH to transfer as part of call
2005     * @param _data The encoded method data
2006     */
2007     function callContract(
2008         BaseWallet _wallet,
2009         address _contract,
2010         uint256 _value,
2011         bytes calldata _data
2012     )
2013         external
2014         onlyWalletOwner(_wallet)
2015         onlyWhenUnlocked(_wallet)
2016     {
2017         // Make sure we don't call a module, the wallet itself, or a supported ERC20
2018         authoriseContractCall(_wallet, _contract);
2019 
2020         if (isWhitelisted(_wallet, _contract)) {
2021             // call to whitelist
2022             doCallContract(_wallet, _contract, _value, _data);
2023         } else {
2024             require(checkAndUpdateDailySpent(_wallet, _value), "TM: Call contract above daily limit");
2025             // call under the limit
2026             doCallContract(_wallet, _contract, _value, _data);
2027         }
2028     }
2029 
2030     /**
2031     * @dev lets the owner do an ERC20 approve followed by a call to a contract.
2032     * We assume that the contract will pull the tokens and does not require ETH.
2033     * @param _wallet The target wallet.
2034     * @param _token The token to approve.
2035     * @param _spender The address to approve.
2036     * @param _amount The amount of ERC20 tokens to approve.
2037     * @param _contract The address of the contract.
2038     * @param _data The encoded method data
2039     */
2040     function approveTokenAndCallContract(
2041         BaseWallet _wallet,
2042         address _token,
2043         address _spender,
2044         uint256 _amount,
2045         address _contract,
2046         bytes calldata _data
2047     )
2048         external
2049         onlyWalletOwner(_wallet)
2050         onlyWhenUnlocked(_wallet)
2051     {
2052         // Make sure we don't call a module, the wallet itself, or a supported ERC20
2053         authoriseContractCall(_wallet, _contract);
2054 
2055         if (!isWhitelisted(_wallet, _spender)) {
2056             // check if the amount is under the daily limit
2057             // check the entire amount because the currently approved amount will be restored and should still count towards the daily limit
2058             uint256 valueInEth = priceProvider.getEtherValue(_amount, _token);
2059             require(checkAndUpdateDailySpent(_wallet, valueInEth), "TM: Approve above daily limit");
2060         }
2061 
2062         doApproveTokenAndCallContract(_wallet, _token, _spender, _amount, _contract, _data);
2063     }
2064 
2065     /**
2066      * @dev Adds an address to the whitelist of a wallet.
2067      * @param _wallet The target wallet.
2068      * @param _target The address to add.
2069      */
2070     function addToWhitelist(
2071         BaseWallet _wallet,
2072         address _target
2073     )
2074         external
2075         onlyWalletOwner(_wallet)
2076         onlyWhenUnlocked(_wallet)
2077     {
2078         require(!isWhitelisted(_wallet, _target), "TT: target already whitelisted");
2079         // solium-disable-next-line security/no-block-members
2080         uint256 whitelistAfter = now.add(securityPeriod);
2081         transferStorage.setWhitelist(_wallet, _target, whitelistAfter);
2082         emit AddedToWhitelist(address(_wallet), _target, uint64(whitelistAfter));
2083     }
2084 
2085     /**
2086      * @dev Removes an address from the whitelist of a wallet.
2087      * @param _wallet The target wallet.
2088      * @param _target The address to remove.
2089      */
2090     function removeFromWhitelist(
2091         BaseWallet _wallet,
2092         address _target
2093     )
2094         external
2095         onlyWalletOwner(_wallet)
2096         onlyWhenUnlocked(_wallet)
2097     {
2098         require(isWhitelisted(_wallet, _target), "TT: target not whitelisted");
2099         transferStorage.setWhitelist(_wallet, _target, 0);
2100         emit RemovedFromWhitelist(address(_wallet), _target);
2101     }
2102 
2103     /**
2104     * @dev Executes a pending transfer for a wallet.
2105     * The method can be called by anyone to enable orchestration.
2106     * @param _wallet The target wallet.
2107     * @param _token The token of the pending transfer.
2108     * @param _to The destination address of the pending transfer.
2109     * @param _amount The amount of token to transfer of the pending transfer.
2110     * @param _data The data associated to the pending transfer.
2111     * @param _block The block at which the pending transfer was created.
2112     */
2113     function executePendingTransfer(
2114         BaseWallet _wallet,
2115         address _token,
2116         address _to,
2117         uint _amount,
2118         bytes calldata _data,
2119         uint _block
2120     )
2121         external
2122         onlyWhenUnlocked(_wallet)
2123     {
2124         bytes32 id = keccak256(abi.encodePacked(ActionType.Transfer, _token, _to, _amount, _data, _block));
2125         uint executeAfter = configs[address(_wallet)].pendingActions[id];
2126         require(executeAfter > 0, "TT: unknown pending transfer");
2127         uint executeBefore = executeAfter.add(securityWindow);
2128         // solium-disable-next-line security/no-block-members
2129         require(executeAfter <= now && now <= executeBefore, "TT: transfer outside of the execution window");
2130         delete configs[address(_wallet)].pendingActions[id];
2131         doTransfer(_wallet, _token, _to, _amount, _data);
2132         emit PendingTransferExecuted(address(_wallet), id);
2133     }
2134 
2135     function cancelPendingTransfer(
2136         BaseWallet _wallet,
2137         bytes32 _id
2138     )
2139         external
2140         onlyWalletOwner(_wallet)
2141         onlyWhenUnlocked(_wallet)
2142     {
2143         require(configs[address(_wallet)].pendingActions[_id] > 0, "TT: unknown pending action");
2144         delete configs[address(_wallet)].pendingActions[_id];
2145         emit PendingTransferCanceled(address(_wallet), _id);
2146     }
2147 
2148     /**
2149      * @dev Lets the owner of a wallet change its daily limit.
2150      * The limit is expressed in ETH. Changes to the limit take 24 hours.
2151      * @param _wallet The target wallet.
2152      * @param _newLimit The new limit.
2153      */
2154     function changeLimit(BaseWallet _wallet, uint256 _newLimit) external onlyWalletOwner(_wallet) onlyWhenUnlocked(_wallet) {
2155         changeLimit(_wallet, _newLimit, securityPeriod);
2156     }
2157 
2158     /**
2159      * @dev Convenience method to disable the limit
2160      * The limit is disabled by setting it to an arbitrary large value.
2161      * @param _wallet The target wallet.
2162      */
2163     function disableLimit(BaseWallet _wallet) external onlyWalletOwner(_wallet) onlyWhenUnlocked(_wallet) {
2164         disableLimit(_wallet, securityPeriod);
2165     }
2166 
2167     /**
2168     * @dev Checks if an address is whitelisted for a wallet.
2169     * @param _wallet The target wallet.
2170     * @param _target The address.
2171     * @return true if the address is whitelisted.
2172     */
2173     function isWhitelisted(BaseWallet _wallet, address _target) public view returns (bool _isWhitelisted) {
2174         uint whitelistAfter = transferStorage.getWhitelist(_wallet, _target);
2175         // solium-disable-next-line security/no-block-members
2176         return whitelistAfter > 0 && whitelistAfter < now;
2177     }
2178 
2179     /**
2180     * @dev Gets the info of a pending transfer for a wallet.
2181     * @param _wallet The target wallet.
2182     * @param _id The pending transfer ID.
2183     * @return the epoch time at which the pending transfer can be executed.
2184     */
2185     function getPendingTransfer(BaseWallet _wallet, bytes32 _id) external view returns (uint64 _executeAfter) {
2186         _executeAfter = uint64(configs[address(_wallet)].pendingActions[_id]);
2187     }
2188 
2189     /**
2190     * @dev Implementation of EIP 1271.
2191     * Should return whether the signature provided is valid for the provided data.
2192     * @param _data Arbitrary length data signed on the behalf of address(this)
2193     * @param _signature Signature byte array associated with _data
2194     */
2195     function isValidSignature(bytes calldata _data, bytes calldata _signature) external view returns (bytes4) {
2196         bytes32 msgHash = keccak256(abi.encodePacked(_data));
2197         isValidSignature(msgHash, _signature);
2198         return ERC1271_ISVALIDSIGNATURE_BYTES;
2199     }
2200 
2201     /**
2202     * @dev Implementation of EIP 1271.
2203     * Should return whether the signature provided is valid for the provided data.
2204     * @param _msgHash Hash of a message signed on the behalf of address(this)
2205     * @param _signature Signature byte array associated with _msgHash
2206     */
2207     function isValidSignature(bytes32 _msgHash, bytes memory _signature) public view returns (bytes4) {
2208         require(_signature.length == 65, "TM: invalid signature length");
2209         address signer = recoverSigner(_msgHash, _signature, 0);
2210         require(isOwner(BaseWallet(msg.sender), signer), "TM: Invalid signer");
2211         return ERC1271_ISVALIDSIGNATURE_BYTES32;
2212     }
2213 
2214     // *************** Internal Functions ********************* //
2215 
2216     /**
2217      * @dev Creates a new pending action for a wallet.
2218      * @param _action The target action.
2219      * @param _wallet The target wallet.
2220      * @param _token The target token for the action.
2221      * @param _to The recipient of the action.
2222      * @param _amount The amount of token associated to the action.
2223      * @param _data The data associated to the action.
2224      * @return the identifier for the new pending action and the time when the action can be executed
2225      */
2226     function addPendingAction(
2227         ActionType _action,
2228         BaseWallet _wallet,
2229         address _token,
2230         address _to,
2231         uint _amount,
2232         bytes memory _data
2233     )
2234         internal
2235         returns (bytes32 id, uint256 executeAfter)
2236     {
2237         id = keccak256(abi.encodePacked(_action, _token, _to, _amount, _data, block.number));
2238         require(configs[address(_wallet)].pendingActions[id] == 0, "TM: duplicate pending action");
2239         // solium-disable-next-line security/no-block-members
2240         executeAfter = now.add(securityPeriod);
2241         configs[address(_wallet)].pendingActions[id] = executeAfter;
2242     }
2243 
2244     /**
2245     * @dev Make sure a contract call is not trying to call a module, the wallet itself, or a supported ERC20.
2246     * @param _wallet The target wallet.
2247     * @param _contract The address of the contract.
2248      */
2249     function authoriseContractCall(BaseWallet _wallet, address _contract) internal view {
2250         require(
2251             _contract != address(_wallet) && // not the wallet itself
2252             !_wallet.authorised(_contract) && // not an authorised module
2253             (priceProvider.cachedPrices(_contract) == 0 || isLimitDisabled(_wallet)), // not an ERC20 listed in the provider (or limit disabled)
2254             "TM: Forbidden contract");
2255     }
2256 
2257     // *************** Implementation of RelayerModule methods ********************* //
2258 
2259     // Overrides refund to add the refund in the daily limit.
2260     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
2261         // 21000 (transaction) + 7620 (execution of refund) + 7324 (execution of updateDailySpent) + 672 to log the event + _gasUsed
2262         uint256 amount = 36616 + _gasUsed;
2263         if (_gasPrice > 0 && _signatures > 0 && amount <= _gasLimit) {
2264             if (_gasPrice > tx.gasprice) {
2265                 amount = amount * tx.gasprice;
2266             } else {
2267                 amount = amount * _gasPrice;
2268             }
2269             checkAndUpdateDailySpent(_wallet, amount);
2270             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
2271         }
2272     }
2273 
2274     // Overrides verifyRefund to add the refund in the daily limit.
2275     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
2276         if (_gasPrice > 0 && _signatures > 0 && (
2277             address(_wallet).balance < _gasUsed * _gasPrice ||
2278             isWithinDailyLimit(_wallet, getCurrentLimit(_wallet), _gasUsed * _gasPrice) == false ||
2279             _wallet.authorised(address(this)) == false
2280         ))
2281         {
2282             return false;
2283         }
2284         return true;
2285     }
2286 }