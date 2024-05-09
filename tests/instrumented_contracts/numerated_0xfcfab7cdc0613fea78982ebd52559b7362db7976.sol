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
894 library GuardianUtils {
895 
896     /**
897     * @dev Checks if an address is an account guardian or an account authorised to sign on behalf of a smart-contract guardian
898     * given a list of guardians.
899     * @param _guardians the list of guardians
900     * @param _guardian the address to test
901     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
902     */
903     function isGuardian(address[] memory _guardians, address _guardian) internal view returns (bool, address[] memory) {
904         if (_guardians.length == 0 || _guardian == address(0)) {
905             return (false, _guardians);
906         }
907         bool isFound = false;
908         address[] memory updatedGuardians = new address[](_guardians.length - 1);
909         uint256 index = 0;
910         for (uint256 i = 0; i < _guardians.length; i++) {
911             if (!isFound) {
912                 // check if _guardian is an account guardian
913                 if (_guardian == _guardians[i]) {
914                     isFound = true;
915                     continue;
916                 }
917                 // check if _guardian is the owner of a smart contract guardian
918                 if (isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
919                     isFound = true;
920                     continue;
921                 }
922             }
923             if (index < updatedGuardians.length) {
924                 updatedGuardians[index] = _guardians[i];
925                 index++;
926             }
927         }
928         return isFound ? (true, updatedGuardians) : (false, _guardians);
929     }
930 
931    /**
932     * @dev Checks if an address is a contract.
933     * @param _addr The address.
934     */
935     function isContract(address _addr) internal view returns (bool) {
936         uint32 size;
937         // solium-disable-next-line security/no-inline-assembly
938         assembly {
939             size := extcodesize(_addr)
940         }
941         return (size > 0);
942     }
943 
944     /**
945     * @dev Checks if an address is the owner of a guardian contract.
946     * The method does not revert if the call to the owner() method consumes more then 5000 gas.
947     * @param _guardian The guardian contract
948     * @param _owner The owner to verify.
949     */
950     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
951         address owner = address(0);
952         bytes4 sig = bytes4(keccak256("owner()"));
953         // solium-disable-next-line security/no-inline-assembly
954         assembly {
955             let ptr := mload(0x40)
956             mstore(ptr,sig)
957             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
958             if eq(result, 1) {
959                 owner := mload(ptr)
960             }
961         }
962         return owner == _owner;
963     }
964 }
965 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
966 
967 // This program is free software: you can redistribute it and/or modify
968 // it under the terms of the GNU General Public License as published by
969 // the Free Software Foundation, either version 3 of the License, or
970 // (at your option) any later version.
971 
972 // This program is distributed in the hope that it will be useful,
973 // but WITHOUT ANY WARRANTY; without even the implied warranty of
974 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
975 // GNU General Public License for more details.
976 
977 // You should have received a copy of the GNU General Public License
978 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
979 
980 
981 
982 
983 /**
984  * @title RelayerModuleV2
985  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
986  * RelayerModuleV2 should ultimately replace RelayerModule and be subclassed by all modules.
987  * It is currently only subclassed by RecoveryManager and ApprovedTransfer.
988  * @author Julien Niset <julien@argent.xyz>, Olivier VDB <olivier@argent.xyz>
989  */
990 contract RelayerModuleV2 is BaseModule {
991 
992     uint256 constant internal BLOCKBOUND = 10000;
993 
994     mapping (address => RelayerConfig) public relayer;
995 
996     struct RelayerConfig {
997         uint256 nonce;
998         mapping (bytes32 => bool) executedTx;
999     }
1000 
1001     enum OwnerSignature {
1002         Required,
1003         Optional,
1004         Disallowed
1005     }
1006 
1007     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
1008 
1009     /**
1010      * @dev Throws if the call did not go through the execute() method.
1011      */
1012     modifier onlyExecute {
1013         require(msg.sender == address(this), "RM: must be called via execute()");
1014         _;
1015     }
1016 
1017     /* ***************** Abstract methods ************************* */
1018 
1019     /**
1020     * @dev Gets the number of valid signatures that must be provided to execute a
1021     * specific relayed transaction.
1022     * @param _wallet The target wallet.
1023     * @param _data The data of the relayed transaction.
1024     * @return The number of required signatures.
1025     */
1026     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) public view returns (uint256);
1027 
1028     /**
1029     * @dev Validates the signatures provided with a relayed transaction.
1030     * The method MUST return false if one or more signatures are not valid.
1031     * @param _wallet The target wallet.
1032     * @param _data The data of the relayed transaction.
1033     * @param _signHash The signed hash representing the relayed transaction.
1034     * @param _signatures The signatures as a concatenated byte array.
1035     * @return A boolean indicating whether the signatures are valid.
1036     */
1037     function validateSignatures(
1038         BaseWallet _wallet,
1039         bytes memory _data,
1040         bytes32 _signHash,
1041         bytes memory _signatures
1042     )
1043         internal view returns (bool);
1044 
1045     /* ***************** External methods ************************* */
1046 
1047     /**
1048     * @dev Executes a relayed transaction.
1049     * @param _wallet The target wallet.
1050     * @param _data The data for the relayed transaction
1051     * @param _nonce The nonce used to prevent replay attacks.
1052     * @param _signatures The signatures as a concatenated byte array.
1053     * @param _gasPrice The gas price to use for the gas refund.
1054     * @param _gasLimit The gas limit to use for the gas refund.
1055     */
1056     function execute(
1057         BaseWallet _wallet,
1058         bytes calldata _data,
1059         uint256 _nonce,
1060         bytes calldata _signatures,
1061         uint256 _gasPrice,
1062         uint256 _gasLimit
1063     )
1064         external
1065         returns (bool success)
1066     {
1067         uint startGas = gasleft();
1068         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
1069         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
1070         require(verifyData(address(_wallet), _data), "RM: Target of _data != _wallet");
1071         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
1072         require(requiredSignatures * 65 == _signatures.length, "RM: Wrong number of signatures");
1073         require(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures), "RM: Invalid signatures");
1074         // The correctness of the refund is checked on the next line using an `if` instead of a `require`
1075         // in order to prevent a failing refund from being replayable in the future.
1076         if (verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
1077             // solium-disable-next-line security/no-call-value
1078             (success,) = address(this).call(_data);
1079             refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
1080         }
1081         emit TransactionExecuted(address(_wallet), success, signHash);
1082     }
1083 
1084     /**
1085     * @dev Gets the current nonce for a wallet.
1086     * @param _wallet The target wallet.
1087     */
1088     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
1089         return relayer[address(_wallet)].nonce;
1090     }
1091 
1092     /* ***************** Internal & Private methods ************************* */
1093 
1094     /**
1095     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
1096     * @param _from The starting address for the relayed transaction (should be the module)
1097     * @param _to The destination address for the relayed transaction (should be the wallet)
1098     * @param _value The value for the relayed transaction
1099     * @param _data The data for the relayed transaction
1100     * @param _nonce The nonce used to prevent replay attacks.
1101     * @param _gasPrice The gas price to use for the gas refund.
1102     * @param _gasLimit The gas limit to use for the gas refund.
1103     */
1104     function getSignHash(
1105         address _from,
1106         address _to,
1107         uint256 _value,
1108         bytes memory _data,
1109         uint256 _nonce,
1110         uint256 _gasPrice,
1111         uint256 _gasLimit
1112     )
1113         internal
1114         pure
1115         returns (bytes32)
1116     {
1117         return keccak256(
1118             abi.encodePacked(
1119                 "\x19Ethereum Signed Message:\n32",
1120                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
1121         ));
1122     }
1123 
1124     /**
1125     * @dev Checks if the relayed transaction is unique.
1126     * @param _wallet The target wallet.
1127     * @param _nonce The nonce
1128     * @param _signHash The signed hash of the transaction
1129     */
1130     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
1131         if (relayer[address(_wallet)].executedTx[_signHash] == true) {
1132             return false;
1133         }
1134         relayer[address(_wallet)].executedTx[_signHash] = true;
1135         return true;
1136     }
1137 
1138     /**
1139     * @dev Checks that a nonce has the correct format and is valid.
1140     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
1141     * @param _wallet The target wallet.
1142     * @param _nonce The nonce
1143     */
1144     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
1145         if (_nonce <= relayer[address(_wallet)].nonce) {
1146             return false;
1147         }
1148         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
1149         if (nonceBlock > block.number + BLOCKBOUND) {
1150             return false;
1151         }
1152         relayer[address(_wallet)].nonce = _nonce;
1153         return true;
1154     }
1155 
1156     /**
1157     * @dev Validates the signatures provided with a relayed transaction.
1158     * The method MUST throw if one or more signatures are not valid.
1159     * @param _wallet The target wallet.
1160     * @param _signHash The signed hash representing the relayed transaction.
1161     * @param _signatures The signatures as a concatenated byte array.
1162     * @param _option An enum indicating whether the owner is required, optional or disallowed.
1163     */
1164     function validateSignatures(
1165         BaseWallet _wallet,
1166         bytes32 _signHash,
1167         bytes memory _signatures,
1168         OwnerSignature _option
1169     )
1170         internal view returns (bool)
1171     {
1172         address lastSigner = address(0);
1173         address[] memory guardians;
1174         if (_option != OwnerSignature.Required || _signatures.length > 65) {
1175             guardians = guardianStorage.getGuardians(_wallet); // guardians are only read if they may be needed
1176         }
1177         bool isGuardian;
1178 
1179         for (uint8 i = 0; i < _signatures.length / 65; i++) {
1180             address signer = recoverSigner(_signHash, _signatures, i);
1181 
1182             if (i == 0) {
1183                 if (_option == OwnerSignature.Required) {
1184                     // First signer must be owner
1185                     if (isOwner(_wallet, signer)) {
1186                         continue;
1187                     }
1188                     return false;
1189                 } else if (_option == OwnerSignature.Optional) {
1190                     // First signer can be owner
1191                     if (isOwner(_wallet, signer)) {
1192                         continue;
1193                     }
1194                 }
1195             }
1196             if (signer <= lastSigner) {
1197                 return false; // Signers must be different
1198             }
1199             lastSigner = signer;
1200             (isGuardian, guardians) = GuardianUtils.isGuardian(guardians, signer);
1201             if (!isGuardian) {
1202                 return false;
1203             }
1204         }
1205         return true;
1206     }
1207 
1208     /**
1209     * @dev Recovers the signer at a given position from a list of concatenated signatures.
1210     * @param _signedHash The signed hash
1211     * @param _signatures The concatenated signatures.
1212     * @param _index The index of the signature to recover.
1213     */
1214     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
1215         uint8 v;
1216         bytes32 r;
1217         bytes32 s;
1218         // we jump 32 (0x20) as the first slot of bytes contains the length
1219         // we jump 65 (0x41) per signature
1220         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
1221         // solium-disable-next-line security/no-inline-assembly
1222         assembly {
1223             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
1224             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
1225             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
1226         }
1227         require(v == 27 || v == 28); // solium-disable-line error-reason
1228         return ecrecover(_signedHash, v, r, s);
1229     }
1230 
1231     /**
1232     * @dev Refunds the gas used to the Relayer.
1233     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures.
1234     * @param _wallet The target wallet.
1235     * @param _gasUsed The gas used.
1236     * @param _gasPrice The gas price for the refund.
1237     * @param _gasLimit The gas limit for the refund.
1238     * @param _signatures The number of signatures used in the call.
1239     * @param _relayer The address of the Relayer.
1240     */
1241     function refund(
1242         BaseWallet _wallet,
1243         uint _gasUsed,
1244         uint _gasPrice,
1245         uint _gasLimit,
1246         uint _signatures,
1247         address _relayer
1248     )
1249         internal
1250     {
1251         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
1252         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
1253         if (_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
1254             if (_gasPrice > tx.gasprice) {
1255                 amount = amount * tx.gasprice;
1256             } else {
1257                 amount = amount * _gasPrice;
1258             }
1259             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
1260         }
1261     }
1262 
1263     /**
1264     * @dev Returns false if the refund is expected to fail.
1265     * @param _wallet The target wallet.
1266     * @param _gasUsed The expected gas used.
1267     * @param _gasPrice The expected gas price for the refund.
1268     */
1269     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1270         if (_gasPrice > 0 &&
1271             _signatures > 1 &&
1272             (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
1273             return false;
1274         }
1275         return true;
1276     }
1277 
1278     /**
1279     * @dev Parses the data to extract the method signature.
1280     */
1281     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
1282         require(_data.length >= 4, "RM: Invalid functionPrefix");
1283         // solium-disable-next-line security/no-inline-assembly
1284         assembly {
1285             prefix := mload(add(_data, 0x20))
1286         }
1287     }
1288 
1289    /**
1290     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
1291     * as the wallet passed as the input of the execute() method.
1292     @return false if the addresses are different.
1293     */
1294     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
1295         require(_data.length >= 36, "RM: Invalid dataWallet");
1296         address dataWallet;
1297         // solium-disable-next-line security/no-inline-assembly
1298         assembly {
1299             //_data = {length:32}{sig:4}{_wallet:32}{...}
1300             dataWallet := mload(add(_data, 0x24))
1301         }
1302         return dataWallet == _wallet;
1303     }
1304 }// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
1305 
1306 // This program is free software: you can redistribute it and/or modify
1307 // it under the terms of the GNU General Public License as published by
1308 // the Free Software Foundation, either version 3 of the License, or
1309 // (at your option) any later version.
1310 
1311 // This program is distributed in the hope that it will be useful,
1312 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1313 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1314 // GNU General Public License for more details.
1315 
1316 // You should have received a copy of the GNU General Public License
1317 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1318 
1319 
1320 
1321 
1322 
1323 /**
1324  * @title RecoveryManager
1325  * @dev Module to manage the recovery of a wallet owner.
1326  * Recovery is executed by a consensus of the wallet's guardians and takes
1327  * 24 hours before it can be finalized. Once finalised the ownership of the wallet
1328  * is transfered to a new address.
1329  * @author Julien Niset - <julien@argent.im>
1330  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
1331  */
1332 contract RecoveryManager is BaseModule, RelayerModuleV2 {
1333 
1334     bytes32 constant NAME = "RecoveryManager";
1335 
1336     bytes4 constant internal EXECUTE_RECOVERY_PREFIX = bytes4(keccak256("executeRecovery(address,address)"));
1337     bytes4 constant internal FINALIZE_RECOVERY_PREFIX = bytes4(keccak256("finalizeRecovery(address)"));
1338     bytes4 constant internal CANCEL_RECOVERY_PREFIX = bytes4(keccak256("cancelRecovery(address)"));
1339     bytes4 constant internal TRANSFER_OWNERSHIP_PREFIX = bytes4(keccak256("transferOwnership(address,address)"));
1340 
1341     struct RecoveryConfig {
1342         address recovery;
1343         uint64 executeAfter;
1344         uint32 guardianCount;
1345     }
1346 
1347     // Wallet specific storage
1348     mapping (address => RecoveryConfig) internal recoveryConfigs;
1349 
1350     // Recovery period
1351     uint256 public recoveryPeriod;
1352     // Lock period
1353     uint256 public lockPeriod;
1354     // Security period used for (non-recovery) ownership transfer
1355     uint256 public securityPeriod;
1356     // Security window used for (non-recovery) ownership transfer
1357     uint256 public securityWindow;
1358     // Location of the Guardian storage
1359     GuardianStorage public guardianStorage;
1360 
1361     // *************** Events *************************** //
1362 
1363     event RecoveryExecuted(address indexed wallet, address indexed _recovery, uint64 executeAfter);
1364     event RecoveryFinalized(address indexed wallet, address indexed _recovery);
1365     event RecoveryCanceled(address indexed wallet, address indexed _recovery);
1366     event OwnershipTransfered(address indexed wallet, address indexed _newOwner);
1367 
1368     // *************** Modifiers ************************ //
1369 
1370     /**
1371      * @dev Throws if there is no ongoing recovery procedure.
1372      */
1373     modifier onlyWhenRecovery(BaseWallet _wallet) {
1374         require(recoveryConfigs[address(_wallet)].executeAfter > 0, "RM: there must be an ongoing recovery");
1375         _;
1376     }
1377 
1378     /**
1379      * @dev Throws if there is an ongoing recovery procedure.
1380      */
1381     modifier notWhenRecovery(BaseWallet _wallet) {
1382         require(recoveryConfigs[address(_wallet)].executeAfter == 0, "RM: there cannot be an ongoing recovery");
1383         _;
1384     }
1385 
1386     // *************** Constructor ************************ //
1387 
1388     constructor(
1389         ModuleRegistry _registry,
1390         GuardianStorage _guardianStorage,
1391         uint256 _recoveryPeriod,
1392         uint256 _lockPeriod,
1393         uint256 _securityPeriod,
1394         uint256 _securityWindow
1395     )
1396         BaseModule(_registry, _guardianStorage, NAME)
1397         public
1398     {
1399         require(_lockPeriod >= _recoveryPeriod && _recoveryPeriod >= _securityPeriod + _securityWindow, "RM: insecure security periods");
1400         guardianStorage = _guardianStorage;
1401         recoveryPeriod = _recoveryPeriod;
1402         lockPeriod = _lockPeriod;
1403         securityPeriod = _securityPeriod;
1404         securityWindow = _securityWindow;
1405     }
1406 
1407     // *************** External functions ************************ //
1408 
1409     /**
1410      * @dev Lets the guardians start the execution of the recovery procedure.
1411      * Once triggered the recovery is pending for the security period before it can
1412      * be finalised.
1413      * Must be confirmed by N guardians, where N = ((Nb Guardian + 1) / 2).
1414      * @param _wallet The target wallet.
1415      * @param _recovery The address to which ownership should be transferred.
1416      */
1417     function executeRecovery(BaseWallet _wallet, address _recovery) external onlyExecute notWhenRecovery(_wallet) {
1418         require(_recovery != address(0), "RM: recovery address cannot be null");
1419         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1420         config.recovery = _recovery;
1421         config.executeAfter = uint64(now + recoveryPeriod);
1422         config.guardianCount = uint32(guardianStorage.guardianCount(_wallet));
1423         guardianStorage.setLock(_wallet, now + lockPeriod);
1424         emit RecoveryExecuted(address(_wallet), _recovery, config.executeAfter);
1425     }
1426 
1427     /**
1428      * @dev Finalizes an ongoing recovery procedure if the security period is over.
1429      * The method is public and callable by anyone to enable orchestration.
1430      * @param _wallet The target wallet.
1431      */
1432     function finalizeRecovery(BaseWallet _wallet) external onlyWhenRecovery(_wallet) {
1433         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1434         require(uint64(now) > config.executeAfter, "RM: the recovery period is not over yet");
1435         _wallet.setOwner(config.recovery);
1436         emit RecoveryFinalized(address(_wallet), config.recovery);
1437         guardianStorage.setLock(_wallet, 0);
1438         delete recoveryConfigs[address(_wallet)];
1439     }
1440 
1441     /**
1442      * @dev Lets the owner cancel an ongoing recovery procedure.
1443      * Must be confirmed by N guardians, where N = ((Nb Guardian + 1) / 2) - 1.
1444      * @param _wallet The target wallet.
1445      */
1446     function cancelRecovery(BaseWallet _wallet) external onlyExecute onlyWhenRecovery(_wallet) {
1447         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1448         emit RecoveryCanceled(address(_wallet), config.recovery);
1449         guardianStorage.setLock(_wallet, 0);
1450         delete recoveryConfigs[address(_wallet)];
1451     }
1452 
1453     /**
1454      * @dev Lets the owner start the execution of the ownership transfer procedure.
1455      * Once triggered the ownership transfer is pending for the security period before it can
1456      * be finalised.
1457      * @param _wallet The target wallet.
1458      * @param _newOwner The address to which ownership should be transferred.
1459      */
1460     function transferOwnership(BaseWallet _wallet, address _newOwner) external onlyExecute onlyWhenUnlocked(_wallet) {
1461         require(_newOwner != address(0), "RM: new owner address cannot be null");
1462         _wallet.setOwner(_newOwner);
1463 
1464         emit OwnershipTransfered(address(_wallet), _newOwner);
1465     }
1466 
1467     /**
1468     * @dev Gets the details of the ongoing recovery procedure if any.
1469     * @param _wallet The target wallet.
1470     */
1471     function getRecovery(BaseWallet _wallet) public view returns(address _address, uint64 _executeAfter, uint32 _guardianCount) {
1472         RecoveryConfig storage config = recoveryConfigs[address(_wallet)];
1473         return (config.recovery, config.executeAfter, config.guardianCount);
1474     }
1475 
1476     // *************** Implementation of RelayerModule methods ********************* //
1477 
1478     function validateSignatures(
1479         BaseWallet _wallet,
1480         bytes memory _data,
1481         bytes32 _signHash,
1482         bytes memory _signatures
1483     )
1484         internal view returns (bool)
1485     {
1486         bytes4 functionSignature = functionPrefix(_data);
1487         if (functionSignature == TRANSFER_OWNERSHIP_PREFIX) {
1488             return validateSignatures(_wallet, _signHash, _signatures, OwnerSignature.Required);
1489         } else if (functionSignature == EXECUTE_RECOVERY_PREFIX) {
1490             return validateSignatures(_wallet, _signHash, _signatures, OwnerSignature.Disallowed);
1491         } else if (functionSignature == CANCEL_RECOVERY_PREFIX) {
1492             return validateSignatures(_wallet, _signHash, _signatures, OwnerSignature.Optional);
1493         }
1494     }
1495 
1496     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) public view returns (uint256) {
1497         bytes4 methodId = functionPrefix(_data);
1498         if (methodId == EXECUTE_RECOVERY_PREFIX) {
1499             return SafeMath.ceil(guardianStorage.guardianCount(_wallet), 2);
1500         }
1501         if (methodId == FINALIZE_RECOVERY_PREFIX) {
1502             return 0;
1503         }
1504         if (methodId == CANCEL_RECOVERY_PREFIX) {
1505             return SafeMath.ceil(recoveryConfigs[address(_wallet)].guardianCount + 1, 2);
1506         }
1507         if (methodId == TRANSFER_OWNERSHIP_PREFIX) {
1508             uint majorityGuardians = SafeMath.ceil(guardianStorage.guardianCount(_wallet), 2);
1509             return SafeMath.add(majorityGuardians, 1);
1510         }
1511         revert("RM: unknown method");
1512     }
1513 }