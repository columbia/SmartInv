1 // Copyright (c) 2017 Sweetbridge Stiftung (Sweetbridge Foundation)
2 //
3 // Licensed under the Apache License, Version 2.0 (the "License");
4 // you may not use this file except in compliance with the License.
5 // You may obtain a copy of the License at
6 //
7 //     http://www.apache.org/licenses/LICENSE-2.0
8 //
9 // Unless required by applicable law or agreed to in writing, software
10 // distributed under the License is distributed on an "AS IS" BASIS,
11 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
12 // See the License for the specific language governing permissions and
13 // limitations under the License.
14 
15 /// math.sol -- mixin for inline numerical wizardry
16 
17 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
18 
19 // Licensed under the Apache License, Version 2.0 (the "License").
20 // You may not use this file except in compliance with the License.
21 
22 // Unless required by applicable law or agreed to in writing, software
23 // distributed under the License is distributed on an "AS IS" BASIS,
24 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
25 
26 pragma solidity ^0.4.17;
27 
28 
29 library Math {
30 
31     // standard uint256 functions
32     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
33         require((z = x + y) >= x);
34     }
35 
36     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
37         require((z = x - y) <= x);
38     }
39 
40     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
41         z = x * y;
42         require((z == 0 && (x == 0 || y == 0)) || z >= (x > y ? x : y));
43     }
44 
45     //division by zero is ignored and returns zero
46     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
47         z = y > 0 ? x / y : 0;
48     }
49 
50     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
51         return x <= y ? x : y;
52     }
53 
54     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
55         return x >= y ? x : y;
56     }
57 
58     /*
59     uint128 functions (h is for half)
60      */
61 
62     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
63         require((z = x + y) >= x);
64     }
65 
66     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
67         require((z = x - y) <= x);
68     }
69 
70     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
71         require((z = x * y) >= x);
72     }
73 
74     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
75         require(y > 0);
76         z = x / y;
77     }
78 
79     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
80         return x <= y ? x : y;
81     }
82 
83     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
84         return x >= y ? x : y;
85     }
86 
87     /*
88     int256 functions
89      */
90 
91     function imin(int256 x, int256 y) pure internal returns (int256 z) {
92         return x <= y ? x : y;
93     }
94 
95     function imax(int256 x, int256 y) pure internal returns (int256 z) {
96         return x >= y ? x : y;
97     }
98 
99     /*
100     WAD math
101      */
102 
103     uint128 constant WAD = 10 ** 18;
104 
105     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
106         return hadd(x, y);
107     }
108 
109     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
110         return hsub(x, y);
111     }
112 
113     function wmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
114         z = cast((uint256(x) * y + WAD / 2) / WAD);
115     }
116 
117     function wdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
118         z = cast((uint256(x) * WAD + y / 2) / y);
119     }
120 
121     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
122         return hmin(x, y);
123     }
124 
125     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
126         return hmax(x, y);
127     }
128 
129     /*
130     RAY math
131      */
132 
133     uint128 constant RAY = 10 ** 27;
134 
135     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
136         return hadd(x, y);
137     }
138 
139     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
140         return hsub(x, y);
141     }
142 
143     function rmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
144         z = cast((uint256(x) * y + RAY / 2) / RAY);
145     }
146 
147     function rdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
148         z = cast((uint256(x) * RAY + y / 2) / y);
149     }
150 
151     function rpow(uint128 x, uint64 n) pure internal returns (uint128 z) {
152         // This famous algorithm is called "exponentiation by squaring"
153         // and calculates x^n with x as fixed-point and n as regular unsigned.
154         //
155         // It's O(log n), instead of O(n) for naive repeated multiplication.
156         //
157         // These facts are why it works:
158         //
159         //  If n is even, then x^n = (x^2)^(n/2).
160         //  If n is odd,  then x^n = x * x^(n-1),
161         //   and applying the equation for even x gives
162         //    x^n = x * (x^2)^((n-1) / 2).
163         //
164         //  Also, EVM division is flooring and
165         //    floor[(n-1) / 2] = floor[n / 2].
166 
167         z = n % 2 != 0 ? x : RAY;
168 
169         for (n /= 2; n != 0; n /= 2) {
170             x = rmul(x, x);
171 
172             if (n % 2 != 0) {
173                 z = rmul(z, x);
174             }
175         }
176     }
177 
178     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
179         return hmin(x, y);
180     }
181 
182     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
183         return hmax(x, y);
184     }
185 
186     function cast(uint256 x) pure internal returns (uint128 z) {
187         require((z = uint128(x)) == x);
188     }
189 }
190 
191 contract OwnedEvents {
192     event LogSetOwner (address newOwner);
193 }
194 
195 
196 contract Owned is OwnedEvents {
197     address public owner;
198 
199     function Owned() public {
200         owner = msg.sender;
201     }
202 
203     modifier onlyOwner() {
204         require(msg.sender == owner);
205         _;
206     }
207 
208     function setOwner(address owner_) public onlyOwner {
209         owner = owner_;
210         LogSetOwner(owner);
211     }
212 
213 }
214 
215 interface SecuredWithRolesI {
216     function hasRole(string roleName) public view returns (bool);
217     function senderHasRole(string roleName) public view returns (bool);
218     function contractHash() public view returns (bytes32);
219 }
220 
221 
222 contract SecuredWithRoles is Owned {
223     RolesI public roles;
224     bytes32 public contractHash;
225     bool public stopped = false;
226 
227     function SecuredWithRoles(string contractName_, address roles_) public {
228         contractHash = keccak256(contractName_);
229         roles = RolesI(roles_);
230     }
231 
232     modifier stoppable() {
233         require(!stopped);
234         _;
235     }
236 
237     modifier onlyRole(string role) {
238         require(senderHasRole(role));
239         _;
240     }
241 
242     modifier roleOrOwner(string role) {
243         require(msg.sender == owner || senderHasRole(role));
244         _;
245     }
246 
247     // returns true if the role has been defined for the contract
248     function hasRole(string roleName) public view returns (bool) {
249         return roles.knownRoleNames(contractHash, keccak256(roleName));
250     }
251 
252     function senderHasRole(string roleName) public view returns (bool) {
253         return hasRole(roleName) && roles.roleList(contractHash, keccak256(roleName), msg.sender);
254     }
255 
256     function stop() public roleOrOwner("stopper") {
257         stopped = true;
258     }
259 
260     function restart() public roleOrOwner("restarter") {
261         stopped = false;
262     }
263 
264     function setRolesContract(address roles_) public onlyOwner {
265         // it must not be possible to change the roles contract on the roles contract itself
266         require(this != address(roles));
267         roles = RolesI(roles_);
268     }
269 
270 }
271 
272 
273 interface RolesI {
274     function knownRoleNames(bytes32 contractHash, bytes32 nameHash) public view returns (bool);
275     function roleList(bytes32 contractHash, bytes32 nameHash, address member) public view returns (bool);
276 
277     function addContractRole(bytes32 ctrct, string roleName) public;
278     function removeContractRole(bytes32 ctrct, string roleName) public;
279     function grantUserRole(bytes32 ctrct, string roleName, address user) public;
280     function revokeUserRole(bytes32 ctrct, string roleName, address user) public;
281 }
282 
283 
284 contract RolesEvents {
285     event LogRoleAdded(bytes32 contractHash, string roleName);
286     event LogRoleRemoved(bytes32 contractHash, string roleName);
287     event LogRoleGranted(bytes32 contractHash, string roleName, address user);
288     event LogRoleRevoked(bytes32 contractHash, string roleName, address user);
289 }
290 
291 
292 contract Roles is RolesEvents, SecuredWithRoles {
293     // mapping is contract -> role -> sender_address -> boolean
294     mapping(bytes32 => mapping (bytes32 => mapping (address => bool))) public roleList;
295     // the intention is
296     mapping (bytes32 => mapping (bytes32 => bool)) public knownRoleNames;
297 
298     function Roles() SecuredWithRoles("RolesRepository", this) public {}
299 
300     function addContractRole(bytes32 ctrct, string roleName) public roleOrOwner("admin") {
301         require(!knownRoleNames[ctrct][keccak256(roleName)]);
302         knownRoleNames[ctrct][keccak256(roleName)] = true;
303         LogRoleAdded(ctrct, roleName);
304     }
305 
306     function removeContractRole(bytes32 ctrct, string roleName) public roleOrOwner("admin") {
307         require(knownRoleNames[ctrct][keccak256(roleName)]);
308         delete knownRoleNames[ctrct][keccak256(roleName)];
309         LogRoleRemoved(ctrct, roleName);
310     }
311 
312     function grantUserRole(bytes32 ctrct, string roleName, address user) public roleOrOwner("admin") {
313         require(knownRoleNames[ctrct][keccak256(roleName)]);
314         roleList[ctrct][keccak256(roleName)][user] = true;
315         LogRoleGranted(ctrct, roleName, user);
316     }
317 
318     function revokeUserRole(bytes32 ctrct, string roleName, address user) public roleOrOwner("admin") {
319         delete roleList[ctrct][keccak256(roleName)][user];
320         LogRoleRevoked(ctrct, roleName, user);
321     }
322 
323 }
324 
325 // Token standard API
326 // https://github.com/ethereum/EIPs/issues/20
327 contract ERC20Events {
328     event Transfer( address indexed from, address indexed to, uint256 value);
329     event Approval( address indexed owner, address indexed spender, uint256 value);
330 }
331 
332 
333 contract ERC20 is ERC20Events {
334     function totalSupply() public view returns (uint256 supply);
335     function balanceOf( address who ) public  view returns (uint256 value);
336     function allowance( address owner, address spender ) public view returns (uint256 _allowance);
337 
338     function transfer( address to, uint256 value) public returns (bool ok);
339     function transferFrom( address from, address to, uint256 value) public returns (bool ok);
340     function approve( address spender, uint256 value ) public returns (bool ok);
341 
342 }
343 
344 contract TokenData is Owned {
345     uint256 public supply;
346     mapping (address => uint256) public balances;
347     mapping (address => mapping (address => uint256)) public approvals;
348     address logic;
349 
350     modifier onlyLogic {
351         assert(msg.sender == logic);
352         _;
353     }
354 
355     function TokenData(address logic_, address owner_) public {
356         logic = logic_;
357         owner = owner_;
358         balances[owner] = supply;
359     }
360 
361     function setTokenLogic(address logic_) public onlyLogic {
362         logic = logic_;
363     }
364 
365     function setSupply(uint256 supply_) public onlyLogic {
366         supply = supply_;
367     }
368 
369     function setBalances(address guy, uint256 balance) public onlyLogic {
370         balances[guy] = balance;
371     }
372 
373     function setApprovals(address src, address guy, uint256 wad) public onlyLogic {
374         approvals[src][guy] = wad;
375     }
376 
377 
378 }
379 
380 interface TokenI {
381     function totalSupply() public view returns (uint256 supply);
382     function balanceOf( address who ) public  view returns (uint256 value);
383     function allowance( address owner, address spender ) public view returns (uint256 _allowance);
384 
385     function triggerTransfer(address src, address dst, uint256 wad);
386     function transfer( address to, uint256 value) public returns (bool ok);
387     function transferFrom( address from, address to, uint256 value) public returns (bool ok);
388     function approve( address spender, uint256 value ) public returns (bool ok);
389 
390     function mintFor(address recipient, uint256 wad) public;
391 }
392 
393 interface TokenLogicI {
394     // we have slightly different interface then ERC20, because
395     function totalSupply() public view returns (uint256 supply);
396     function balanceOf( address who ) public view returns (uint256 value);
397     function allowance( address owner, address spender ) public view returns (uint256 _allowance);
398     function transferFrom( address from, address to, uint256 value) public returns (bool ok);
399     // this two functions are different from ERC20. ERC20 assumes that msg.sender is the owner,
400     // but because logic contract is behind a proxy we need to add an owner parameter.
401     function transfer( address owner, address to, uint256 value) public returns (bool ok);
402     function approve( address owner, address spender, uint256 value ) public returns (bool ok);
403 
404     function setToken(address token_) public;
405     function mintFor(address dest, uint256 wad) public;
406     function burn(address src, uint256 wad) public;
407 }
408 
409 
410 contract TokenLogicEvents {
411     event WhiteListAddition(bytes32 listName);
412     event AdditionToWhiteList(bytes32 listName, address guy);
413     event WhiteListRemoval(bytes32 listName);
414     event RemovalFromWhiteList(bytes32 listName, address guy);
415 }
416 
417 
418 contract TokenLogic is TokenLogicEvents, TokenLogicI, SecuredWithRoles {
419 
420     TokenData public data;
421     Token public token;     // facade: Token.sol:Token
422 
423     /* White lists are used to restrict who can transact with whom.
424      * Since we can't iterate over the mapping we need to store the keys separaterly in the
425      *   listNames
426      */
427     bytes32[] public listNames;
428     mapping (address => mapping (bytes32 => bool)) public whiteLists;
429     // by default there is no need for white listing addresses, anyone can transact freely
430     bool public freeTransfer = true;
431 
432     function TokenLogic(
433         address token_,
434         address tokenData_,
435         address rolesContract) public SecuredWithRoles("TokenLogic", rolesContract)
436     {
437         require(token_ != address(0x0));
438         require(rolesContract != address(0x0));
439 
440         token = Token(token_);
441         if (tokenData_ == address(0x0)) {
442             data = new TokenData(this, msg.sender);
443         } else {
444             data = TokenData(tokenData_);
445         }
446     }
447 
448     modifier tokenOnly {
449         assert(msg.sender == address(token));
450         _;
451     }
452 
453     /* check that freeTransfer is true or that the owner is involved or both sender and recipient are in the same whitelist*/
454     modifier canTransfer(address src, address dst) {
455         require(freeTransfer || src == owner || dst == owner || sameWhiteList(src, dst));
456         _;
457     }
458 
459     function sameWhiteList(address src, address dst) internal view returns(bool) {
460         for(uint8 i = 0; i < listNames.length; i++) {
461             bytes32 listName = listNames[i];
462             if(whiteLists[src][listName] && whiteLists[dst][listName]) {
463                 return true;
464             }
465         }
466         return false;
467     }
468 
469     function listNamesLen() public view returns (uint256) {
470         return listNames.length;
471     }
472 
473     function listExists(bytes32 listName) public view returns (bool) {
474         var (, ok) = indexOf(listName);
475         return ok;
476     }
477 
478     function indexOf(bytes32 listName) public view returns (uint8, bool) {
479         for(uint8 i = 0; i < listNames.length; i++) {
480             if(listNames[i] == listName) {
481                 return (i, true);
482             }
483         }
484         return (0, false);
485     }
486 
487     function replaceLogic(address newLogic) public onlyOwner {
488         token.setLogic(TokenLogicI(newLogic));
489         data.setTokenLogic(newLogic);
490         selfdestruct(owner);
491     }
492 
493     /* creating a removeWhiteList would be too onerous. Therefore it does not exist*/
494     function addWhiteList(bytes32 listName) public onlyRole("admin") {
495         require(! listExists(listName));
496         require(listNames.length < 256);
497         listNames.push(listName);
498         WhiteListAddition(listName);
499     }
500 
501     function removeWhiteList(bytes32 listName) public onlyRole("admin") {
502         var (i, ok) = indexOf(listName);
503         require(ok);
504         if(i < listNames.length - 1) {
505             listNames[i] = listNames[listNames.length - 1];
506         }
507         delete listNames[listNames.length - 1];
508         --listNames.length;
509         WhiteListRemoval(listName);
510     }
511 
512     function addToWhiteList(bytes32 listName, address guy) public onlyRole("userManager") {
513         require(listExists(listName));
514 
515         whiteLists[guy][listName] = true;
516         AdditionToWhiteList(listName, guy);
517     }
518 
519     function removeFromWhiteList(bytes32 listName, address guy) public onlyRole("userManager") {
520         require(listExists(listName));
521 
522         whiteLists[guy][listName] = false;
523         RemovalFromWhiteList(listName, guy);
524     }
525 
526     function setFreeTransfer(bool isFree) public onlyOwner {
527         freeTransfer = isFree;
528     }
529 
530     function setToken(address token_) public onlyOwner {
531         token = Token(token_);
532     }
533 
534     function totalSupply() public view returns (uint256) {
535         return data.supply();
536     }
537 
538     function balanceOf(address src) public view returns (uint256) {
539         return data.balances(src);
540     }
541 
542     function allowance(address src, address spender) public view returns (uint256) {
543         return data.approvals(src, spender);
544     }
545 
546     function transfer(address src, address dst, uint256 wad) public tokenOnly canTransfer(src, dst)  returns (bool) {
547         // balance check is not needed because sub(a, b) will throw if a<b
548         data.setBalances(src, Math.sub(data.balances(src), wad));
549         data.setBalances(dst, Math.add(data.balances(dst), wad));
550 
551         return true;
552     }
553 
554     function transferFrom(address src, address dst, uint256 wad) public tokenOnly canTransfer(src, dst)  returns (bool) {
555         // balance and approval check is not needed because sub(a, b) will throw if a<b
556         data.setApprovals(src, dst, Math.sub(data.approvals(src, dst), wad));
557         data.setBalances(src, Math.sub(data.balances(src), wad));
558         data.setBalances(dst, Math.add(data.balances(dst), wad));
559 
560         return true;
561     }
562 
563     function approve(address src, address dst, uint256 wad) public tokenOnly returns (bool) {
564         data.setApprovals(src, dst, wad);
565         return true;
566     }
567 
568     function mintFor(address dst, uint256 wad) public tokenOnly {
569         data.setBalances(dst, Math.add(data.balances(dst), wad));
570         data.setSupply(Math.add(data.supply(), wad));
571     }
572 
573     function burn(address src, uint256 wad) public tokenOnly {
574         data.setBalances(src, Math.sub(data.balances(src), wad));
575         data.setSupply(Math.sub(data.supply(), wad));
576     }
577 }
578 
579 contract TokenEvents {
580     event LogBurn(address indexed src, uint256 wad);
581     event LogMint(address indexed src, uint256 wad);
582     event LogLogicReplaced(address newLogic);
583     event Transfer(address indexed from, address indexed to, uint256 value);
584     event Approval(address indexed owner, address indexed spender, uint256 value);
585 }
586 
587 /**
588  * @title Contract that will work with ERC223 tokens.
589  */
590 interface ERC223ReceivingContract {
591     /**
592      * @dev Standard ERC223 function that will handle incoming token transfers.
593      *
594      * @param src  Token sender address.
595      * @param wad  Amount of tokens.
596      * @param _data  Transaction metadata.
597      */
598     function tokenFallback(address src, uint wad, bytes _data) public;
599 }
600 
601 contract Token is TokenI, SecuredWithRoles, TokenEvents {
602     string public symbol;
603     string public name; // Optional token name
604     uint8 public decimals = 18; // standard token precision. override to customize
605     TokenLogicI public logic;
606 
607     function Token(string name_, string symbol_, address rolesContract) public SecuredWithRoles(name_, rolesContract) {
608         // you can't create logic here, because this contract would be the owner.
609         name = name_;
610         symbol = symbol_;
611     }
612 
613     modifier logicOnly {
614         require(address(logic) == address(0x0) || address(logic) == msg.sender);
615         _;
616     }
617 
618     function totalSupply() public view returns (uint256) {
619         return logic.totalSupply();
620     }
621 
622     function balanceOf( address who ) public view returns (uint256 value) {
623         return logic.balanceOf(who);
624     }
625 
626     function allowance(address owner, address spender ) public view returns (uint256 _allowance) {
627         return logic.allowance(owner, spender);
628     }
629 
630     function triggerTransfer(address src, address dst, uint256 wad) logicOnly {
631         Transfer(src, dst, wad);
632     }
633 
634     function setLogic(address logic_) public logicOnly {
635         assert(logic_ != address(0));
636         logic = TokenLogicI(logic_);
637         LogLogicReplaced(logic);
638     }
639 
640     /**
641      * @dev Transfer the specified amount of tokens to the specified address.
642      *      Invokes the `tokenFallback` function if the recipient is a contract.
643      *      The token transfer fails if the recipient is a contract
644      *      but does not implement the `tokenFallback` function
645      *      or the fallback function to receive funds.
646      */
647     function transfer(address dst, uint256 wad) public stoppable returns (bool) {
648         bool retVal = logic.transfer(msg.sender, dst, wad);
649         if (retVal) {
650             uint codeLength;
651             assembly {
652             // Retrieve the size of the code on target address, this needs assembly .
653                 codeLength := extcodesize(dst)
654             }
655             if (codeLength>0) {
656                 ERC223ReceivingContract receiver = ERC223ReceivingContract(dst);
657                 bytes memory empty;
658                 receiver.tokenFallback(msg.sender, wad, empty);
659             }
660 
661             Transfer(msg.sender, dst, wad);
662         }
663         return retVal;
664     }
665 
666     function transferFrom(address src, address dst, uint256 wad) public stoppable returns (bool) {
667         bool retVal = logic.transferFrom(src, dst, wad);
668         if (retVal) {
669             uint codeLength;
670             assembly {
671             // Retrieve the size of the code on target address, this needs assembly .
672                 codeLength := extcodesize(dst)
673             }
674             if (codeLength>0) {
675                 ERC223ReceivingContract receiver = ERC223ReceivingContract(dst);
676                 bytes memory empty;
677                 receiver.tokenFallback(src, wad, empty);
678             }
679 
680             Transfer(src, dst, wad);
681         }
682         return retVal;
683     }
684 
685     function approve(address guy, uint256 wad) public stoppable returns (bool) {
686         bool ok = logic.approve(msg.sender, guy, wad);
687         if (ok)
688             Approval(msg.sender, guy, wad);
689         return ok;
690     }
691 
692     function pull(address src, uint256 wad) public stoppable returns (bool) {
693         return transferFrom(src, msg.sender, wad);
694     }
695 
696     function mintFor(address recipient, uint256 wad) public stoppable onlyRole("minter") {
697         logic.mintFor(recipient, wad);
698         LogMint(recipient, wad);
699         Transfer(address(0x0), recipient, wad);
700     }
701 
702     function burn(uint256 wad) public stoppable {
703         logic.burn(msg.sender, wad);
704         LogBurn(msg.sender, wad);
705     }
706 
707     function setName(string name_) public roleOrOwner("admin") {
708         name = name_;
709     }
710 }
711 
712 contract SweetTokenLogic is TokenLogic {
713 
714     function SweetTokenLogic(
715         address token_,
716         address tokenData_,
717         address rolesContract,
718         address[] initialWallets,
719         uint256[] initialBalances)
720     TokenLogic(token_, tokenData_, rolesContract) public
721     {
722         if (tokenData_ == address(0x0)) {
723             uint256 totalSupply;
724             require(initialBalances.length == initialWallets.length);
725             for (uint256 i = 0; i < initialWallets.length; i++) {
726                 data.setBalances(initialWallets[i], initialBalances[i]);
727                 token.triggerTransfer(address(0x0), initialWallets[i], initialBalances[i]);
728                 totalSupply = Math.add(totalSupply, initialBalances[i]);
729             }
730             data.setSupply(totalSupply);
731         }
732     }
733 
734     function mintFor(address, uint256) public tokenOnly {
735         // no more SweetTokens can be minted after the initial mint
736         assert(false);
737     }
738 
739     function burn(address, uint256) public tokenOnly {
740         // burning is not possible
741         assert(false);
742     }
743 }
744 
745 
746 contract SweetToken is Token {
747     function SweetToken(string name_, string symbol_, address rolesContract) public Token(name_, symbol_, rolesContract) {
748         // you shouldn't create logic here, because this contract would be the owner.
749     }
750 
751 }