1 /// auth.sol -- widely-used access control pattern for Ethereum
2 
3 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
4 
5 // Licensed under the Apache License, Version 2.0 (the "License").
6 // You may not use this file except in compliance with the License.
7 
8 // Unless required by applicable law or agreed to in writing, software
9 // distributed under the License is distributed on an "AS IS" BASIS,
10 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11 
12 pragma solidity ^0.4.13;
13 
14 contract Authority {
15     function canCall(address src, address dst, bytes4 sig) constant returns (bool);
16 }
17 
18 contract AuthEvents {
19     event LogSetAuthority (address indexed authority);
20     event LogSetOwner     (address indexed owner);
21     event UnauthorizedAccess (address caller, bytes4 sig);
22 }
23 
24 contract Auth is AuthEvents {
25     Authority  public  authority;
26     address public owner;
27 
28     function Auth() {
29         owner = msg.sender;
30         LogSetOwner(msg.sender);
31     }
32 
33     function setOwner(address owner_) auth {
34         owner = owner_;
35         LogSetOwner(owner);
36     }
37 
38     function setAuthority(Authority authority_) auth {
39         authority = authority_;
40         LogSetAuthority(authority);
41     }
42 
43     modifier auth {
44         require(isAuthorized(msg.sender, msg.sig));
45         _;
46     }
47 
48     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
49         if (src == address(this)) {
50             return true;
51         } else if (src == owner && authority == Authority(0)) {
52             /*the owner has privileges only as long as no Authority has been defined*/
53             return true;
54         } else if (authority == Authority(0)) {
55             UnauthorizedAccess(src, sig);
56             return false;
57         } else {
58             return authority.canCall(src, this, sig);
59         }
60     }
61 }
62 /*
63    Copyright 2017 DappHub, LLC
64 
65    Licensed under the Apache License, Version 2.0 (the "License");
66    you may not use this file except in compliance with the License.
67    You may obtain a copy of the License at
68 
69        http://www.apache.org/licenses/LICENSE-2.0
70 
71    Unless required by applicable law or agreed to in writing, software
72    distributed under the License is distributed on an "AS IS" BASIS,
73    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
74    See the License for the specific language governing permissions and
75    limitations under the License.
76 */
77 
78 
79 // Token standard API
80 // https://github.com/ethereum/EIPs/issues/20
81 
82 contract ERC20Events {
83     event Transfer( address indexed from, address indexed to, uint value);
84     event Approval( address indexed owner, address indexed spender, uint value);
85 }
86 
87 contract ERC20 is ERC20Events{
88     function totalSupply() constant returns (uint supply);
89     function balanceOf( address who ) constant returns (uint value);
90     function allowance( address owner, address spender ) constant returns (uint _allowance);
91 
92     function transfer( address to, uint value) returns (bool ok);
93     function transferFrom( address from, address to, uint value) returns (bool ok);
94     function approve( address spender, uint value ) returns (bool ok);
95 
96 }
97 /// math.sol -- mixin for inline numerical wizardry
98 
99 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
100 
101 // Licensed under the Apache License, Version 2.0 (the "License").
102 // You may not use this file except in compliance with the License.
103 
104 // Unless required by applicable law or agreed to in writing, software
105 // distributed under the License is distributed on an "AS IS" BASIS,
106 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
107 
108 
109 contract Math {
110     
111     /*
112     standard uint256 functions
113      */
114 
115     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
116         require((z = x + y) >= x);
117     }
118 
119     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
120         require((z = x - y) <= x);
121     }
122 
123     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
124         z = x * y;
125         require(z == 0 || z >= (x > y ? x : y));
126     }
127 
128     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
129         require(y > 0);
130         z = x / y;
131     }
132 
133     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
134         return x <= y ? x : y;
135     }
136     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
137         return x >= y ? x : y;
138     }
139 
140     /*
141     uint128 functions (h is for half)
142      */
143 
144 
145     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
146         require((z = x + y) >= x);
147     }
148 
149     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
150         require((z = x - y) <= x);
151     }
152 
153     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
154         require((z = x * y) >= x);
155     }
156 
157     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
158         require(y > 0);
159         z = x / y;
160     }
161 
162     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
163         return x <= y ? x : y;
164     }
165     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
166         return x >= y ? x : y;
167     }
168 
169 
170     /*
171     int256 functions
172      */
173 
174     function imin(int256 x, int256 y) constant internal returns (int256 z) {
175         return x <= y ? x : y;
176     }
177     function imax(int256 x, int256 y) constant internal returns (int256 z) {
178         return x >= y ? x : y;
179     }
180 
181     /*
182     WAD math
183      */
184 
185     uint128 constant WAD = 10 ** 18;
186 
187     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
188         return hadd(x, y);
189     }
190 
191     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
192         return hsub(x, y);
193     }
194 
195     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
196         z = cast((uint256(x) * y + WAD / 2) / WAD);
197     }
198 
199     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
200         z = cast((uint256(x) * WAD + y / 2) / y);
201     }
202 
203     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
204         return hmin(x, y);
205     }
206     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
207         return hmax(x, y);
208     }
209 
210     /*
211     RAY math
212      */
213 
214     uint128 constant RAY = 10 ** 27;
215 
216     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
217         return hadd(x, y);
218     }
219 
220     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
221         return hsub(x, y);
222     }
223 
224     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
225         z = cast((uint256(x) * y + RAY / 2) / RAY);
226     }
227 
228     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
229         z = cast((uint256(x) * RAY + y / 2) / y);
230     }
231 
232     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
233         // This famous algorithm is called "exponentiation by squaring"
234         // and calculates x^n with x as fixed-point and n as regular unsigned.
235         //
236         // It's O(log n), instead of O(n) for naive repeated multiplication.
237         //
238         // These facts are why it works:
239         //
240         //  If n is even, then x^n = (x^2)^(n/2).
241         //  If n is odd,  then x^n = x * x^(n-1),
242         //   and applying the equation for even x gives
243         //    x^n = x * (x^2)^((n-1) / 2).
244         //
245         //  Also, EVM division is flooring and
246         //    floor[(n-1) / 2] = floor[n / 2].
247 
248         z = n % 2 != 0 ? x : RAY;
249 
250         for (n /= 2; n != 0; n /= 2) {
251             x = rmul(x, x);
252 
253             if (n % 2 != 0) {
254                 z = rmul(z, x);
255             }
256         }
257     }
258 
259     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
260         return hmin(x, y);
261     }
262     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
263         return hmax(x, y);
264     }
265 
266     function cast(uint256 x) constant internal returns (uint128 z) {
267         require((z = uint128(x)) == x);
268     }
269 
270 }
271 
272 
273 contract Migrations {
274   address public owner;
275   uint public last_completed_migration;
276 
277   modifier restricted() {
278     if (msg.sender == owner) _;
279   }
280 
281   function Migrations() {
282     owner = msg.sender;
283   }
284 
285   function setCompleted(uint completed) restricted {
286     last_completed_migration = completed;
287   }
288 
289   function upgrade(address new_address) restricted {
290     Migrations upgraded = Migrations(new_address);
291     upgraded.setCompleted(last_completed_migration);
292   }
293 }
294 /// note.sol -- the `note' modifier, for logging calls as events
295 
296 // Copyright (C) 2017  DappHub, LLC
297 //
298 // Licensed under the Apache License, Version 2.0 (the "License").
299 // You may not use this file except in compliance with the License.
300 //
301 // Unless required by applicable law or agreed to in writing, software
302 // distributed under the License is distributed on an "AS IS" BASIS,
303 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
304 
305 
306 
307 
308 contract Note {
309     event LogNote(
310         bytes4   indexed sig,
311         address  indexed guy,
312         bytes32  indexed foo,
313         bytes32  indexed bar,
314         uint wad,
315         bytes fax
316     ) anonymous;
317 
318     modifier note {
319         bytes32 foo;
320         bytes32 bar;
321 
322         assembly {
323         foo := calldataload(4)
324         bar := calldataload(36)
325         }
326 
327         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
328 
329         _;
330     }
331 }
332 /// stop.sol -- mixin for enable/disable functionality
333 
334 // Copyright (C) 2017  DappHub, LLC
335 
336 // Licensed under the Apache License, Version 2.0 (the "License").
337 // You may not use this file except in compliance with the License.
338 
339 // Unless required by applicable law or agreed to in writing, software
340 // distributed under the License is distributed on an "AS IS" BASIS,
341 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
342 
343 
344 contract Stoppable is Auth, Note {
345 
346     bool public stopped;
347 
348     modifier stoppable {
349         require (!stopped);
350         _;
351     }
352     function stop() auth note {
353         stopped = true;
354     }
355     function start() auth note {
356         stopped = false;
357     }
358 
359 }// token.sol -- ERC20 implementation with minting and burning
360 
361 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
362 
363 // Licensed under the Apache License, Version 2.0 (the "License").
364 // You may not use this file except in compliance with the License.
365 
366 // Unless required by applicable law or agreed to in writing, software
367 // distributed under the License is distributed on an "AS IS" BASIS,
368 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
369 
370 
371 contract Token is ERC20, Stoppable {
372 
373     bytes32 public symbol;    
374     string public name; // Optional token name
375     uint256 public decimals = 18; // standard token precision. override to customize
376     TokenLogic public logic;
377 
378     function Token(string name_, bytes32 symbol_) {
379         name = name_;
380         symbol = symbol_;
381     }
382 
383     function setLogic(TokenLogic logic_) auth note returns(bool){
384         logic = logic_;
385         return true;
386     }
387 
388     function setOwner(address owner_) auth {
389         uint wad = balanceOf(owner);
390         logic.transfer(owner, owner_, wad);
391         Transfer(owner, owner_, wad);
392         logic.setOwner(owner_);
393         super.setOwner(owner_);
394     }
395 
396 
397     function totalSupply() constant returns (uint256){
398         return logic.totalSupply();
399     }
400 
401     function balanceOf( address who ) constant returns (uint value) {
402         return logic.balanceOf(who);
403     }
404 
405     function allowance( address owner, address spender ) constant returns (uint _allowance) {
406         return logic.allowance(owner, spender);
407     }
408 
409     function transfer(address dst, uint wad) stoppable note returns (bool) {
410         bool retVal = logic.transfer(msg.sender, dst, wad);
411         Transfer(msg.sender, dst, wad);
412         return retVal;
413     }
414     
415     function transferFrom(address src, address dst, uint wad) stoppable note returns (bool) {
416         bool retVal = logic.transferFrom(src, dst, wad);
417         Transfer(src, dst, wad);
418         return retVal;
419     }
420 
421     function approve(address guy, uint wad) stoppable note returns (bool) {
422         return logic.approve(msg.sender, guy, wad);
423     }
424 
425     function push(address dst, uint128 wad) returns (bool) {
426         return transfer(dst, wad);
427     }
428 
429     function pull(address src, uint128 wad) returns (bool) {
430         return transferFrom(src, msg.sender, wad);
431     }
432 
433     function mint(uint128 wad) auth stoppable note {
434         logic.mint(wad);
435         Transfer(this, msg.sender, wad);
436     }
437 
438     function burn(uint128 wad) auth stoppable note {
439         logic.burn(msg.sender, wad);
440     }
441 
442     function setName(string name_) auth {
443         name = name_;
444     }
445 
446     function setSymbol(bytes32 symbol_) auth {
447         symbol = symbol_;
448     }
449 
450     function () payable {
451         require(msg.value > 0);
452         uint wad = logic.handlePayment(msg.sender, msg.value);
453         Transfer(this, msg.sender, wad);
454     }
455 
456 /*special functions for ICO*/
457     function transferEth(address dst, uint wad) {
458         require(msg.sender == address(logic));
459         require(wad < this.balance);
460         dst.transfer(wad);
461     }
462 
463 /*this function is called from logic to trigger the correct event upon receiving ETH*/
464     function triggerTansferEvent(address src,  address dst, uint wad) {
465         require(msg.sender == address(logic));
466         Transfer(src, dst, wad);
467     }
468 
469     function payout(address dst) auth {
470         require(dst != address(0));
471         dst.transfer(this.balance);
472     }
473 
474 }
475 
476 contract TokenData is Auth {
477     uint256 public supply;
478     mapping (address => uint256) public balances;
479     mapping (address => mapping (address => uint256)) public approvals;
480     address token;
481 
482     modifier tokenOnly {
483         assert(msg.sender == token);
484         _;
485     }
486 
487     function TokenData(address token_, uint supply_, address owner_) {
488         token = token_;
489         supply = supply_;
490         owner = owner_;
491         balances[owner] = supply;
492     }
493 
494     function setOwner(address owner_) tokenOnly {
495         owner = owner_;
496         LogSetOwner(owner);
497     }
498 
499     function setToken(address token_) auth {
500         token = token_;
501     }
502 
503     function setSupply(uint supply_) tokenOnly {
504         supply = supply_;
505     }
506 
507     function setBalances(address guy, uint balance) tokenOnly {
508         balances[guy] = balance;
509     }
510 
511     function setApprovals(address src, address guy, uint wad) tokenOnly {
512         approvals[src][guy] = wad;
513     }
514 
515 }/// base.sol -- basic ERC20 implementation
516 
517 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
518 
519 // Licensed under the Apache License, Version 2.0 (the "License").
520 // You may not use this file except in compliance with the License.
521 
522 // Unless required by applicable law or agreed to in writing, software
523 // distributed under the License is distributed on an "AS IS" BASIS,
524 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
525 
526 
527 contract TokenLogic is ERC20Events, Math, Stoppable {
528 
529     TokenData public data;
530     Token public token;
531     uint public tokensPerWei=3000;
532     bool public presale = true;
533     uint public icoStart=1503756000; // = Aug 26 2017 2pm GMT
534     uint public icoEnd;   //1504188000 = Aug 31 2017 2pm GMT
535     uint public icoSale; //the number of tokens sold during the ICO
536     uint public maxIco = 90000000000000000000000000; // the maximum number of tokens sold during ICO
537 
538     address[] contributors;
539 
540     function TokenLogic(Token token_, TokenData data_, uint icoStart_, uint icoHours_) {
541         require(token_ != Token(0x0));
542 
543         if(data_ == address(0x0)) {
544             data = new TokenData(this, 120000000000000000000000000, msg.sender);
545         } else {
546             data = data_;
547         }
548         token = token_;
549         icoStart = icoStart_;
550         icoEnd = icoStart + icoHours_ * 3600;
551     }
552 
553     modifier tokenOnly {
554         assert(msg.sender == address(token) || msg.sender == address(this));
555         _;
556     }
557 
558     function contributorCount() constant returns(uint) {
559         return contributors.length;
560     }
561 
562     function setOwner(address owner_) tokenOnly {
563         owner = owner_;
564         LogSetOwner(owner);
565         data.setOwner(owner);
566     }
567 
568     function setToken(Token token_) auth {
569         token = token_;
570     }
571 
572     function setIcoStart(uint icoStart_, uint icoHours_) auth {
573         icoStart = icoStart_;
574         icoEnd = icoStart + icoHours_ * 3600;
575     }
576 
577     function setPresale(bool presale_) auth {
578         presale = presale_;
579     }
580 
581     function setTokensPerWei(uint tokensPerWei_) auth {
582         require(tokensPerWei_ > 0);
583         tokensPerWei = tokensPerWei_;
584     }
585 
586     function totalSupply() constant returns (uint256) {
587         return data.supply();
588     }
589 
590     function balanceOf(address src) constant returns (uint256) {
591         return data.balances(src);
592     }
593 
594     function allowance(address src, address guy) constant returns (uint256) {
595         return data.approvals(src, guy);
596     }
597     
598     function transfer(address src, address dst, uint wad) tokenOnly returns (bool) {
599         require(balanceOf(src) >= wad);
600         
601         data.setBalances(src, sub(data.balances(src), wad));
602         data.setBalances(dst, add(data.balances(dst), wad));
603         
604         return true;
605     }
606     
607     function transferFrom(address src, address dst, uint wad) tokenOnly returns (bool) {
608         require(data.balances(src) >= wad);
609         require(data.approvals(src, dst) >= wad);
610         
611         data.setApprovals(src, dst, sub(data.approvals(src, dst), wad));
612         data.setBalances(src, sub(data.balances(src), wad));
613         data.setBalances(dst, add(data.balances(dst), wad));
614         
615         return true;
616     }
617     
618     function approve(address src, address guy, uint256 wad) tokenOnly returns (bool) {
619 
620         data.setApprovals(src, guy, wad);
621         
622         Approval(src, guy, wad);
623         
624         return true;
625     }
626 
627     function mint(uint128 wad) tokenOnly {
628         data.setBalances(data.owner(), add(data.balances(data.owner()), wad));
629         data.setSupply(add(data.supply(), wad));
630     }
631 
632     function burn(address src, uint128 wad) tokenOnly {
633         require(balanceOf(src) >= wad);
634         data.setBalances(src, sub(data.balances(src), wad));
635         data.setSupply(sub(data.supply(), wad));
636     }
637 
638     function returnIcoInvestments(uint contributorIndex) auth {
639         /*this can only be done after the ICO close date and if less than 20mio tokens were sold*/
640         require(now > icoEnd && icoSale < 20000000000000000000000000);
641 
642         address src = contributors[contributorIndex];
643         require(src != address(0));
644 
645         uint srcBalance = balanceOf(src);
646 
647         /*transfer the sent ETH amount minus a 5 finney (0.005 ETH ~ 1USD) tax to pay for Gas*/
648         token.transferEth(src, sub(div(srcBalance, tokensPerWei), 5 finney));
649 
650         /*give back the tokens*/
651         data.setBalances(src, sub(data.balances(src), srcBalance));
652         data.setBalances(owner, add(data.balances(owner), srcBalance));
653         token.triggerTansferEvent(src, owner, srcBalance);
654 
655         /*reset the address after the transfer to avoid errors*/
656         contributors[contributorIndex] = address(0);
657     }
658 
659     function handlePayment(address src, uint eth) tokenOnly returns (uint){
660         require(eth > 0);
661         /*the time stamp has to be between the start and end times of the ICO*/
662         require(now >= icoStart && now <= icoEnd);
663         /*no more than 90 mio tokens shall be sold in the ICO*/
664         require(icoSale < maxIco);
665 
666         uint tokenAmount = mul(tokensPerWei, eth);
667         if (!presale) {
668             //first 168 hours
669             if (now < icoStart + (168 * 3600)) {
670                 tokenAmount = tokenAmount * 150 / 100;
671             }
672             //168 to 312 hours
673             else if (now < icoStart + (312 * 3600)) {
674                 tokenAmount = tokenAmount * 130 / 100;
675             }
676             //312 to 456 hours
677             else if (now < icoStart + (456 * 3600)) {
678                 tokenAmount = tokenAmount * 110 / 100;
679             }
680         }
681 
682         icoSale += tokenAmount;
683         if(icoSale > maxIco) {
684             uint excess = sub(icoSale, maxIco);
685             tokenAmount = sub(tokenAmount, excess);
686             token.transferEth(src, div(excess, tokensPerWei));
687             icoSale = maxIco;
688         }
689 
690         require(balanceOf(owner) >= tokenAmount);
691 
692         data.setBalances(owner, sub(data.balances(owner), tokenAmount));
693         data.setBalances(src, add(data.balances(src), tokenAmount));
694         contributors.push(src);
695 
696         token.triggerTansferEvent(owner, src, tokenAmount);
697 
698         return tokenAmount;
699     }
700 }