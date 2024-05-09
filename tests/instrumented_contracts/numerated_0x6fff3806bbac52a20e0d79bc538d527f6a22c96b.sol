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
78 // Token standard API
79 // https://github.com/ethereum/EIPs/issues/20
80 
81 contract ERC20Events {
82     event Transfer( address indexed from, address indexed to, uint value);
83     event Approval( address indexed owner, address indexed spender, uint value);
84 }
85 
86 contract ERC20 is ERC20Events{
87     function totalSupply() constant returns (uint supply);
88     function balanceOf( address who ) constant returns (uint value);
89     function allowance( address owner, address spender ) constant returns (uint _allowance);
90 
91     function transfer( address to, uint value) returns (bool ok);
92     function transferFrom( address from, address to, uint value) returns (bool ok);
93     function approve( address spender, uint value ) returns (bool ok);
94 
95 }
96 /// math.sol -- mixin for inline numerical wizardry
97 
98 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
99 
100 // Licensed under the Apache License, Version 2.0 (the "License").
101 // You may not use this file except in compliance with the License.
102 
103 // Unless required by applicable law or agreed to in writing, software
104 // distributed under the License is distributed on an "AS IS" BASIS,
105 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
106 
107 contract Math {
108     
109     /*
110     standard uint256 functions
111      */
112 
113     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
114         require((z = x + y) >= x);
115     }
116 
117     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
118         require((z = x - y) <= x);
119     }
120 
121     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
122         z = x * y;
123         require(z == 0 || z >= (x > y ? x : y));
124     }
125 
126     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
127         require(y > 0);
128         z = x / y;
129     }
130 
131     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
132         return x <= y ? x : y;
133     }
134     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
135         return x >= y ? x : y;
136     }
137 
138     /*
139     uint128 functions (h is for half)
140      */
141 
142 
143     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
144         require((z = x + y) >= x);
145     }
146 
147     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
148         require((z = x - y) <= x);
149     }
150 
151     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
152         require((z = x * y) >= x);
153     }
154 
155     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
156         require(y > 0);
157         z = x / y;
158     }
159 
160     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
161         return x <= y ? x : y;
162     }
163     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
164         return x >= y ? x : y;
165     }
166 
167 
168     /*
169     int256 functions
170      */
171 
172     function imin(int256 x, int256 y) constant internal returns (int256 z) {
173         return x <= y ? x : y;
174     }
175     function imax(int256 x, int256 y) constant internal returns (int256 z) {
176         return x >= y ? x : y;
177     }
178 
179     /*
180     WAD math
181      */
182 
183     uint128 constant WAD = 10 ** 18;
184 
185     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
186         return hadd(x, y);
187     }
188 
189     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
190         return hsub(x, y);
191     }
192 
193     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
194         z = cast((uint256(x) * y + WAD / 2) / WAD);
195     }
196 
197     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
198         z = cast((uint256(x) * WAD + y / 2) / y);
199     }
200 
201     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
202         return hmin(x, y);
203     }
204     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
205         return hmax(x, y);
206     }
207 
208     /*
209     RAY math
210      */
211 
212     uint128 constant RAY = 10 ** 27;
213 
214     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
215         return hadd(x, y);
216     }
217 
218     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
219         return hsub(x, y);
220     }
221 
222     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
223         z = cast((uint256(x) * y + RAY / 2) / RAY);
224     }
225 
226     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
227         z = cast((uint256(x) * RAY + y / 2) / y);
228     }
229 
230     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
231         // This famous algorithm is called "exponentiation by squaring"
232         // and calculates x^n with x as fixed-point and n as regular unsigned.
233         //
234         // It's O(log n), instead of O(n) for naive repeated multiplication.
235         //
236         // These facts are why it works:
237         //
238         //  If n is even, then x^n = (x^2)^(n/2).
239         //  If n is odd,  then x^n = x * x^(n-1),
240         //   and applying the equation for even x gives
241         //    x^n = x * (x^2)^((n-1) / 2).
242         //
243         //  Also, EVM division is flooring and
244         //    floor[(n-1) / 2] = floor[n / 2].
245 
246         z = n % 2 != 0 ? x : RAY;
247 
248         for (n /= 2; n != 0; n /= 2) {
249             x = rmul(x, x);
250 
251             if (n % 2 != 0) {
252                 z = rmul(z, x);
253             }
254         }
255     }
256 
257     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
258         return hmin(x, y);
259     }
260     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
261         return hmax(x, y);
262     }
263 
264     function cast(uint256 x) constant internal returns (uint128 z) {
265         require((z = uint128(x)) == x);
266     }
267 
268 }
269 
270 contract Migrations {
271   address public owner;
272   uint public last_completed_migration;
273 
274   modifier restricted() {
275     if (msg.sender == owner) _;
276   }
277 
278   function Migrations() {
279     owner = msg.sender;
280   }
281 
282   function setCompleted(uint completed) restricted {
283     last_completed_migration = completed;
284   }
285 
286   function upgrade(address new_address) restricted {
287     Migrations upgraded = Migrations(new_address);
288     upgraded.setCompleted(last_completed_migration);
289   }
290 }
291 /// note.sol -- the `note' modifier, for logging calls as events
292 
293 // Copyright (C) 2017  DappHub, LLC
294 //
295 // Licensed under the Apache License, Version 2.0 (the "License").
296 // You may not use this file except in compliance with the License.
297 //
298 // Unless required by applicable law or agreed to in writing, software
299 // distributed under the License is distributed on an "AS IS" BASIS,
300 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
301 
302 
303 contract Note {
304     event LogNote(
305         bytes4   indexed sig,
306         address  indexed guy,
307         bytes32  indexed foo,
308         bytes32  indexed bar,
309         uint wad,
310         bytes fax
311     ) anonymous;
312 
313     modifier note {
314         bytes32 foo;
315         bytes32 bar;
316 
317         assembly {
318         foo := calldataload(4)
319         bar := calldataload(36)
320         }
321 
322         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
323 
324         _;
325     }
326 }
327 /// stop.sol -- mixin for enable/disable functionality
328 
329 // Copyright (C) 2017  DappHub, LLC
330 
331 // Licensed under the Apache License, Version 2.0 (the "License").
332 // You may not use this file except in compliance with the License.
333 
334 // Unless required by applicable law or agreed to in writing, software
335 // distributed under the License is distributed on an "AS IS" BASIS,
336 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
337 
338 
339 contract Stoppable is Auth, Note {
340 
341     bool public stopped;
342 
343     modifier stoppable {
344         require (!stopped);
345         _;
346     }
347     function stop() auth note {
348         stopped = true;
349     }
350     function start() auth note {
351         stopped = false;
352     }
353 
354 }// token.sol -- ERC20 implementation with minting and burning
355 
356 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
357 
358 // Licensed under the Apache License, Version 2.0 (the "License").
359 // You may not use this file except in compliance with the License.
360 
361 // Unless required by applicable law or agreed to in writing, software
362 // distributed under the License is distributed on an "AS IS" BASIS,
363 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
364 
365 
366 contract Token is ERC20, Stoppable {
367 
368     bytes32 public symbol;    
369     string public name; // Optional token name
370     uint256 public decimals = 18; // standard token precision. override to customize
371     TokenLogic public logic;
372 
373     function Token(string name_, bytes32 symbol_) {
374         name = name_;
375         symbol = symbol_;
376     }
377 
378     function setLogic(TokenLogic logic_) auth note returns(bool){
379         logic = logic_;
380         return true;
381     }
382 
383     function setOwner(address owner_) auth {
384         uint wad = balanceOf(owner);
385         logic.transfer(owner, owner_, wad);
386         Transfer(owner, owner_, wad);
387         logic.setOwner(owner_);
388         super.setOwner(owner_);
389     }
390 
391 
392     function totalSupply() constant returns (uint256){
393         return logic.totalSupply();
394     }
395 
396     function balanceOf( address who ) constant returns (uint value) {
397         return logic.balanceOf(who);
398     }
399 
400     function allowance( address owner, address spender ) constant returns (uint _allowance) {
401         return logic.allowance(owner, spender);
402     }
403 
404     function transfer(address dst, uint wad) stoppable note returns (bool) {
405         bool retVal = logic.transfer(msg.sender, dst, wad);
406         Transfer(msg.sender, dst, wad);
407         return retVal;
408     }
409     
410     function transferFrom(address src, address dst, uint wad) stoppable note returns (bool) {
411         bool retVal = logic.transferFrom(src, dst, wad);
412         Transfer(src, dst, wad);
413         return retVal;
414     }
415 
416     function approve(address guy, uint wad) stoppable note returns (bool) {
417         return logic.approve(msg.sender, guy, wad);
418     }
419 
420     function push(address dst, uint128 wad) returns (bool) {
421         return transfer(dst, wad);
422     }
423 
424     function pull(address src, uint128 wad) returns (bool) {
425         return transferFrom(src, msg.sender, wad);
426     }
427 
428     function mint(uint128 wad) auth stoppable note {
429         logic.mint(wad);
430         Transfer(this, msg.sender, wad);
431     }
432 
433     function burn(uint128 wad) auth stoppable note {
434         logic.burn(msg.sender, wad);
435     }
436 
437     function setName(string name_) auth {
438         name = name_;
439     }
440 
441     function setSymbol(bytes32 symbol_) auth {
442         symbol = symbol_;
443     }
444 
445     function () payable {
446         require(msg.value > 0);
447         uint wad = logic.handlePayment(msg.sender, msg.value);
448         Transfer(this, msg.sender, wad);
449     }
450 
451 /*special functions for ICO*/
452     function transferEth(address dst, uint wad) {
453         require(msg.sender == address(logic));
454         require(wad < this.balance);
455         dst.transfer(wad);
456     }
457 
458 /*this function is called from logic to trigger the correct event upon receiving ETH*/
459     function triggerTansferEvent(address src,  address dst, uint wad) {
460         require(msg.sender == address(logic));
461         Transfer(src, dst, wad);
462     }
463 
464     function payout(address dst) auth {
465         require(dst != address(0));
466         dst.transfer(this.balance);
467     }
468 
469 }
470 
471 contract TokenData is Auth {
472     uint256 public supply;
473     mapping (address => uint256) public balances;
474     mapping (address => mapping (address => uint256)) public approvals;
475     address token;
476 
477     modifier tokenOnly {
478         assert(msg.sender == token);
479         _;
480     }
481 
482     function TokenData(address token_, uint supply_, address owner_) {
483         token = token_;
484         supply = supply_;
485         owner = owner_;
486         balances[owner] = supply;
487     }
488 
489     function setOwner(address owner_) tokenOnly {
490         owner = owner_;
491         LogSetOwner(owner);
492     }
493 
494     function setToken(address token_) auth {
495         token = token_;
496     }
497 
498     function setSupply(uint supply_) tokenOnly {
499         supply = supply_;
500     }
501 
502     function setBalances(address guy, uint balance) tokenOnly {
503         balances[guy] = balance;
504     }
505 
506     function setApprovals(address src, address guy, uint wad) tokenOnly {
507         approvals[src][guy] = wad;
508     }
509 
510 }/// base.sol -- basic ERC20 implementation
511 
512 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
513 
514 // Licensed under the Apache License, Version 2.0 (the "License").
515 // You may not use this file except in compliance with the License.
516 
517 // Unless required by applicable law or agreed to in writing, software
518 // distributed under the License is distributed on an "AS IS" BASIS,
519 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
520 
521 contract TokenLogic is ERC20Events, Math, Stoppable {
522 
523     TokenData public data;
524     Token public token;
525     uint public tokensPerWei=300;
526     uint public icoStart=1503756000; // = Aug 26 2017 2pm GMT
527     uint public icoEnd;   //1504188000 = Aug 31 2017 2pm GMT
528     uint public icoSale; //the number of tokens sold during the ICO
529     uint public maxIco = 90000000000000000000000000; // the maximum number of tokens sold during ICO
530 
531     address[] contributors;
532 
533     function TokenLogic(Token token_, TokenData data_, uint icoStart_, uint icoHours_) {
534         require(token_ != Token(0x0));
535 
536         if(data_ == address(0x0)) {
537             data = new TokenData(this, 120000000000000000000000000, msg.sender);
538         } else {
539             data = data_;
540         }
541         token = token_;
542         icoStart = icoStart_;
543         icoEnd = icoStart + icoHours_ * 3600;
544     }
545 
546     modifier tokenOnly {
547         assert(msg.sender == address(token) || msg.sender == address(this));
548         _;
549     }
550 
551     function contributorCount() constant returns(uint) {
552         return contributors.length;
553     }
554 
555     function setOwner(address owner_) tokenOnly {
556         owner = owner_;
557         LogSetOwner(owner);
558         data.setOwner(owner);
559     }
560 
561     function setToken(Token token_) auth {
562         token = token_;
563     }
564 
565     function setIcoStart(uint icoStart_, uint icoHours_) auth {
566         icoStart = icoStart_;
567         icoEnd = icoStart + icoHours_ * 3600;
568     }
569 
570     function setTokensPerWei(uint tokensPerWei_) auth {
571         require(tokensPerWei_ > 0);
572         tokensPerWei = tokensPerWei_;
573     }
574 
575     function totalSupply() constant returns (uint256) {
576         return data.supply();
577     }
578 
579     function balanceOf(address src) constant returns (uint256) {
580         return data.balances(src);
581     }
582 
583     function allowance(address src, address guy) constant returns (uint256) {
584         return data.approvals(src, guy);
585     }
586     
587     function transfer(address src, address dst, uint wad) tokenOnly returns (bool) {
588         require(balanceOf(src) >= wad);
589         
590         data.setBalances(src, sub(data.balances(src), wad));
591         data.setBalances(dst, add(data.balances(dst), wad));
592         
593         return true;
594     }
595     
596     function transferFrom(address src, address dst, uint wad) tokenOnly returns (bool) {
597         require(data.balances(src) >= wad);
598         require(data.approvals(src, dst) >= wad);
599         
600         data.setApprovals(src, dst, sub(data.approvals(src, dst), wad));
601         data.setBalances(src, sub(data.balances(src), wad));
602         data.setBalances(dst, add(data.balances(dst), wad));
603         
604         return true;
605     }
606     
607     function approve(address src, address guy, uint256 wad) tokenOnly returns (bool) {
608 
609         data.setApprovals(src, guy, wad);
610         
611         Approval(src, guy, wad);
612         
613         return true;
614     }
615 
616     function mint(uint128 wad) tokenOnly {
617         data.setBalances(data.owner(), add(data.balances(data.owner()), wad));
618         data.setSupply(add(data.supply(), wad));
619     }
620 
621     function burn(address src, uint128 wad) tokenOnly {
622         data.setBalances(src, sub(data.balances(src), wad));
623         data.setSupply(sub(data.supply(), wad));
624     }
625 
626     function returnIcoInvestments(uint contributorIndex) auth {
627         /*this can only be done after the ICO close date and if less than 20mio tokens were sold*/
628         require(now > icoEnd && icoSale < 20000000000000000000000000);
629 
630         address src = contributors[contributorIndex];
631         require(src != address(0));
632 
633         uint srcBalance = balanceOf(src);
634 
635         /*transfer the sent ETH amount minus a 5 finney (0.005 ETH ~ 1USD) tax to pay for Gas*/
636         token.transferEth(src, sub(div(srcBalance, tokensPerWei), 5 finney));
637 
638         /*give back the tokens*/
639         data.setBalances(src, sub(data.balances(src), srcBalance));
640         data.setBalances(owner, add(data.balances(owner), srcBalance));
641         token.triggerTansferEvent(src, owner, srcBalance);
642 
643         /*reset the address after the transfer to avoid errors*/
644         contributors[contributorIndex] = address(0);
645     }
646 
647     function handlePayment(address src, uint eth) tokenOnly returns (uint){
648         require(eth > 0);
649         /*the time stamp has to be between the start and end times of the ICO*/
650         require(now >= icoStart && now <= icoEnd);
651         /*no more than 90 mio tokens shall be sold in the ICO*/
652         require(icoSale < maxIco);
653 
654         uint tokenAmount = mul(tokensPerWei, eth);
655 //first 10 hours
656         if(now < icoStart + (10 * 3600)) {
657             tokenAmount = tokenAmount * 125 / 100;
658         }
659 //10 to 34 hours
660         else if(now < icoStart + (34 * 3600)) {
661             tokenAmount = tokenAmount * 115 / 100;
662         }
663 //34 to 58 hours
664         else if(now < icoStart + (58 * 3600)) {
665             tokenAmount = tokenAmount * 105 / 100;
666         }
667 
668         icoSale += tokenAmount;
669         if(icoSale > maxIco) {
670             uint excess = sub(icoSale, maxIco);
671             tokenAmount = sub(tokenAmount, excess);
672             token.transferEth(src, div(excess, tokensPerWei));
673             icoSale = maxIco;
674         }
675 
676         require(balanceOf(owner) >= tokenAmount);
677 
678         data.setBalances(owner, sub(data.balances(owner), tokenAmount));
679         data.setBalances(src, add(data.balances(src), tokenAmount));
680         contributors.push(src);
681 
682         token.triggerTansferEvent(owner, src, tokenAmount);
683 
684         return tokenAmount;
685     }
686 }