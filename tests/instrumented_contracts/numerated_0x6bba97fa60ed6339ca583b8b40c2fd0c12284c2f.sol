1 // solhint-disable-next-line compiler-fixed, compiler-gt-0_4
2 pragma solidity ^0.4.24;
3 
4 //                             _,,ad8888888888bba,_
5 //                         ,ad88888I888888888888888ba,
6 //                       ,88888888I88888888888888888888a,
7 //                     ,d888888888I8888888888888888888888b,
8 //                    d88888PP"""" ""YY88888888888888888888b,
9 //                  ,d88"'__,,--------,,,,.;ZZZY8888888888888,
10 //                 ,8IIl'"                ;;l"ZZZIII8888888888,
11 //                ,I88l;'                  ;lZZZZZ888III8888888,
12 //              ,II88Zl;.                  ;llZZZZZ888888I888888,
13 //             ,II888Zl;.                .;;;;;lllZZZ888888I8888b
14 //            ,II8888Z;;                 `;;;;;''llZZ8888888I8888,
15 //            II88888Z;'                        .;lZZZ8888888I888b
16 //            II88888Z; _,aaa,      .,aaaaa,__.l;llZZZ88888888I888
17 //            II88888IZZZZZZZZZ,  .ZZZZZZZZZZZZZZ;llZZ88888888I888,
18 //            II88888IZZ<'(@@>Z|  |ZZZ<'(@@>ZZZZ;;llZZ888888888I88I
19 //           ,II88888;   `""" ;|  |ZZ; `"""     ;;llZ8888888888I888
20 //           II888888l            `;;          .;llZZ8888888888I888,
21 //          ,II888888Z;           ;;;        .;;llZZZ8888888888I888I
22 //          III888888Zl;    ..,   `;;       ,;;lllZZZ88888888888I888
23 //          II88888888Z;;...;(_    _)      ,;;;llZZZZ88888888888I888,
24 //          II88888888Zl;;;;;' `--'Z;.   .,;;;;llZZZZ88888888888I888b
25 //          ]I888888888Z;;;;'   ";llllll;..;;;lllZZZZ88888888888I8888,
26 //          II888888888Zl.;;"Y88bd888P";;,..;lllZZZZZ88888888888I8888I
27 //          II8888888888Zl;.; `"PPP";;;,..;lllZZZZZZZ88888888888I88888
28 //          II888888888888Zl;;. `;;;l;;;;lllZZZZZZZZW88888888888I88888
29 //          `II8888888888888Zl;.    ,;;lllZZZZZZZZWMZ88888888888I88888
30 //           II8888888888888888ZbaalllZZZZZZZZZWWMZZZ8888888888I888888,
31 //           `II88888888888888888b"WWZZZZZWWWMMZZZZZZI888888888I888888b
32 //            `II88888888888888888;ZZMMMMMMZZZZZZZZllI888888888I8888888
33 //             `II8888888888888888 `;lZZZZZZZZZZZlllll888888888I8888888,
34 //              II8888888888888888, `;lllZZZZllllll;;.Y88888888I8888888b,
35 //             ,II8888888888888888b   .;;lllllll;;;.;..88888888I88888888b,
36 //             II888888888888888PZI;.  .`;;;.;;;..; ...88888888I8888888888,
37 //             II888888888888PZ;;';;.   ;. .;.  .;. .. Y8888888I88888888888b,
38 //            ,II888888888PZ;;'                        `8888888I8888888888888b,
39 //            II888888888'                              888888I8888888888888888b
40 //           ,II888888888                              ,888888I88888888888888888
41 //          ,d88888888888                              d888888I8888888888ZZZZZZZ
42 //       ,ad888888888888I                              8888888I8888ZZZZZZZZZZZZZ
43 //     ,d888888888888888'                              888888IZZZZZZZZZZZZZZZZZZ
44 //   ,d888888888888P'8P'                               Y888ZZZZZZZZZZZZZZZZZZZZZ
45 //  ,8888888888888,  "                                 ,ZZZZZZZZZZZZZZZZZZZZZZZZ
46 // d888888888888888,                                ,ZZZZZZZZZZZZZZZZZZZZZZZZZZZ
47 // 888888888888888888a,      _                    ,ZZZZZZZZZZZZZZZZZZZZ888888888
48 // 888888888888888888888ba,_d'                  ,ZZZZZZZZZZZZZZZZZ88888888888888
49 // 8888888888888888888888888888bbbaaa,,,______,ZZZZZZZZZZZZZZZ888888888888888888
50 // 88888888888888888888888888888888888888888ZZZZZZZZZZZZZZZ888888888888888888888
51 // 8888888888888888888888888888888888888888ZZZZZZZZZZZZZZ88888888888888888888888
52 // 888888888888888888888888888888888888888ZZZZZZZZZZZZZZ888888888888888888888888
53 // 8888888888888888888888888888888888888ZZZZZZZZZZZZZZ88888888888888888888888888
54 // 88888888888888888888888888888888888ZZZZZZZZZZZZZZ8888888888888888888888888888
55 // 8888888888888888888888888888888888ZZZZZZZZZZZZZZ88888888888888888 Da Vinci 88
56 // 88888888888888888888888888888888ZZZZZZZZZZZZZZ8888888888888888888  Coders  88
57 // 8888888888888888888888888888888ZZZZZZZZZZZZZZ88888888888888888888888888888888
58 
59 
60 library SafeMath {
61   function mul(uint a, uint b) internal pure returns (uint c) {
62     if (a == 0) {
63       return 0;
64     }
65 
66     c = a * b;
67     assert(c / a == b);
68     return c;
69   }
70 
71   function div(uint a, uint b) internal pure returns (uint) {
72     return a / b;
73   }
74 
75   function mod(uint a, uint b) internal pure returns (uint) {
76     return a % b;
77   }
78 
79   function sub(uint a, uint b) internal pure returns (uint) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint a, uint b) internal pure returns (uint c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 contract Dividends {
93   using SafeMath for *;
94 
95   uint private constant FIXED_POINT = 1000000000000000000;
96 
97   struct Scheme {
98     uint value;
99     uint shares;
100     uint mask;
101   }
102 
103   struct Vault {
104     uint value;
105     uint shares;
106     uint mask;
107   }
108 
109   mapping (uint => mapping (address => Vault)) private vaultOfAddress;
110   mapping (uint => Scheme) private schemeOfId;
111 
112   function buyShares (uint _schemeId, address _owner, uint _shares, uint _value) internal {
113     require(_owner != address(0));
114     require(_shares > 0 && _value > 0);
115 
116     uint value = _value.mul(FIXED_POINT);
117 
118     Scheme storage scheme = schemeOfId[_schemeId];
119 
120     scheme.value = scheme.value.add(_value);
121     scheme.shares = scheme.shares.add(_shares);
122 
123     require(value > scheme.shares);
124 
125     uint pps = value.div(scheme.shares);
126 
127     Vault storage vault = vaultOfAddress[_schemeId][_owner];
128 
129     vault.shares = vault.shares.add(_shares);
130     vault.mask = vault.mask.add(scheme.mask.mul(_shares));
131     vault.value = vault.value.add(value.sub(pps.mul(scheme.shares)));
132 
133     scheme.mask = scheme.mask.add(pps);
134   }
135 
136   function flushVault (uint _schemeId, address _owner) internal {
137     uint gains = gainsOfVault(_schemeId, _owner);
138     if (gains > 0) {
139       Vault storage vault = vaultOfAddress[_schemeId][_owner];
140       vault.value = vault.value.add(gains);
141       vault.mask = vault.mask.add(gains);
142     }
143   }
144 
145   function withdrawVault (uint _schemeId, address _owner) internal returns (uint) {
146     flushVault(_schemeId, _owner);
147 
148     Vault storage vault = vaultOfAddress[_schemeId][_owner];
149     uint payout = vault.value.div(FIXED_POINT);
150 
151     if (payout > 0) {
152       vault.value = 0;
153     }
154 
155     return payout;
156   }
157 
158   function creditVault (uint _schemeId, address _owner, uint _value) internal {
159     Vault storage vault = vaultOfAddress[_schemeId][_owner];
160     vault.value = vault.value.add(_value.mul(FIXED_POINT));
161   }
162 
163   function gainsOfVault (uint _schemeId, address _owner) internal view returns (uint) {
164     Scheme storage scheme = schemeOfId[_schemeId];
165     Vault storage vault = vaultOfAddress[_schemeId][_owner];
166 
167     if (vault.shares == 0) {
168       return 0;
169     }
170 
171     return scheme.mask.mul(vault.shares).sub(vault.mask);
172   }
173 
174   function valueOfVault (uint _schemeId, address _owner) internal view returns (uint) {
175     Vault storage vault = vaultOfAddress[_schemeId][_owner];
176     return vault.value;
177   }
178 
179   function balanceOfVault (uint _schemeId, address _owner) internal view returns (uint) {
180     Vault storage vault = vaultOfAddress[_schemeId][_owner];
181 
182     uint total = vault.value.add(gainsOfVault(_schemeId, _owner));
183     uint balance = total.div(FIXED_POINT);
184 
185     return balance;
186   }
187 
188   function sharesOfVault (uint _schemeId, address _owner) internal view returns (uint) {
189     Vault storage vault = vaultOfAddress[_schemeId][_owner];
190     return vault.shares;
191   }
192 
193   function valueOfScheme (uint _schemeId) internal view returns (uint) {
194     return schemeOfId[_schemeId].value;
195   }
196 
197   function sharesOfScheme (uint _schemeId) internal view returns (uint) {
198     return schemeOfId[_schemeId].shares;
199   }
200 }
201 
202 
203 library Utils {
204   using SafeMath for uint;
205 
206   uint private constant LAST_COUNTRY = 195;
207 
208   function regularTicketPrice () internal pure returns (uint) {
209     return 100000000000000;
210   }
211 
212   function goldenTicketPrice (uint _x) internal pure returns (uint) {
213     uint price = _x.mul(_x).div(2168819140000000000000000).add(100000000000000).add(_x.div(100000));
214     return price < regularTicketPrice() ? regularTicketPrice() : price;
215   }
216 
217   function ticketsForWithExcess (uint _value) internal pure returns (uint, uint) {
218     uint tickets = _value.div(regularTicketPrice());
219     uint excess = _value.sub(tickets.mul(regularTicketPrice()));
220     return (tickets, excess);
221   }
222 
223   function percentageOf (uint _value, uint _p) internal pure returns (uint) {
224     return _value.mul(_p).div(100);
225   }
226 
227   function validReferralCode (string _code) internal pure returns (bool) {
228     bytes memory b = bytes(_code);
229 
230     if (b.length < 3) {
231       return false;
232     }
233 
234     for (uint i = 0; i < b.length; i++) {
235       bytes1 c = b[i];
236       if (
237         !(c >= 0x30 && c <= 0x39) && // 0-9
238         !(c >= 0x41 && c <= 0x5A) && // A-Z
239         !(c >= 0x61 && c <= 0x7A) && // a-z
240         !(c == 0x2D) // -
241       ) {
242         return false;
243       }
244     }
245 
246     return true;
247   }
248 
249   function validNick (string _nick) internal pure returns (bool) {
250     return bytes(_nick).length > 3;
251   }
252 
253   function validCountryId (uint _countryId) internal pure returns (bool) {
254     return _countryId > 0 && _countryId <= LAST_COUNTRY;
255   }
256 }
257 
258 
259 contract Events {
260   event Started (
261     uint _time
262   );
263 
264   event Bought (
265     address indexed _player,
266     address indexed _referral,
267     uint _countryId,
268     uint _tickets,
269     uint _value,
270     uint _excess
271   );
272 
273   event Promoted (
274     address indexed _player,
275     uint _goldenTickets,
276     uint _endTime
277   );
278 
279   event Withdrew (
280     address indexed _player,
281     uint _amount
282   );
283 
284   event Registered (
285     string _code, address indexed _referral
286   );
287 
288   event Won (
289     address indexed _winner, uint _pot
290   );
291 }
292 
293 
294 contract Constants {
295   uint internal constant MAIN_SCHEME = 1337;
296   uint internal constant DEFAULT_COUNTRY = 1;
297 
298   uint internal constant SET_NICK_FEE = 0.01 ether;
299   uint internal constant REFERRAL_REGISTRATION_FEE = 0.01 ether;
300 
301   uint internal constant TO_DIVIDENDS = 42;
302   uint internal constant TO_REFERRAL = 10;
303   uint internal constant TO_DEVELOPERS = 4;
304   uint internal constant TO_COUNTRY = 12;
305 }
306 
307 
308 contract State is Constants {
309   address internal addressOfOwner;
310 
311   uint internal maxTime = 0;
312   uint internal addedTime = 0;
313 
314   uint internal totalPot = 0;
315   uint internal startTime = 0;
316   uint internal endTime = 0;
317   bool internal potWithdrawn = false;
318   address internal addressOfCaptain;
319 
320   struct Info {
321     address referral;
322     uint countryId;
323     uint withdrawn;
324     string nick;
325   }
326 
327   mapping (address => Info) internal infoOfAddress;
328   mapping (address => string[]) internal codesOfAddress;
329   mapping (string => address) internal addressOfCode;
330 
331   modifier restricted () {
332     require(msg.sender == addressOfOwner);
333     _;
334   }
335 
336   modifier active () {
337     require(startTime > 0);
338     require(block.timestamp < endTime);
339     require(!potWithdrawn);
340     _;
341   }
342 
343   modifier player () {
344     require(infoOfAddress[msg.sender].countryId > 0);
345     _;
346   }
347 }
348 
349 
350 contract Core is Events, State, Dividends {}
351 
352 
353 contract ExternalView is Core {
354   function totalInfo () external view returns (bool, bool, address, uint, uint, uint, uint, uint, uint, address) {
355     return (
356       startTime > 0,
357       block.timestamp >= endTime,
358       addressOfCaptain,
359       totalPot,
360       endTime,
361       sharesOfScheme(MAIN_SCHEME),
362       valueOfScheme(MAIN_SCHEME),
363       maxTime,
364       addedTime,
365       addressOfOwner
366     );
367   }
368 
369   function countryInfo (uint _countryId) external view returns (uint, uint) {
370     return (
371       sharesOfScheme(_countryId),
372       valueOfScheme(_countryId)
373     );
374   }
375 
376   function playerInfo (address _player) external view returns (uint, uint, uint, address, uint, uint, string) {
377     Info storage info = infoOfAddress[_player];
378     return (
379       sharesOfVault(MAIN_SCHEME, _player),
380       balanceOfVault(MAIN_SCHEME, _player),
381       balanceOfVault(info.countryId, _player),
382       info.referral,
383       info.countryId,
384       info.withdrawn,
385       info.nick
386     );
387   }
388 
389   function numberOfReferralCodes (address _player) external view returns (uint) {
390     return codesOfAddress[_player].length;
391   }
392 
393   function referralCodeAt (address _player, uint i) external view returns (string) {
394     return codesOfAddress[_player][i];
395   }
396 
397   function codeToAddress (string _code) external view returns (address) {
398     return addressOfCode[_code];
399   }
400 
401   function goldenTicketPrice (uint _x) external pure returns (uint) {
402     return Utils.goldenTicketPrice(_x);
403   }
404 }
405 
406 
407 contract Internal is Core {
408   function _registerReferral (string _code, address _referral) internal {
409     require(Utils.validReferralCode(_code));
410     require(addressOfCode[_code] == address(0));
411 
412     addressOfCode[_code] = _referral;
413     codesOfAddress[_referral].push(_code);
414 
415     emit Registered(_code, _referral);
416   }
417 }
418 
419 
420 contract WinnerWinner is Core, Internal, ExternalView {
421   using SafeMath for *;
422 
423   constructor () public {
424     addressOfOwner = msg.sender;
425   }
426 
427   function () public payable {
428     buy(addressOfOwner, DEFAULT_COUNTRY);
429   }
430 
431   function start (uint _maxTime, uint _addedTime) public restricted {
432     require(startTime == 0);
433     require(_maxTime > 0 && _addedTime > 0);
434     require(_maxTime > _addedTime);
435 
436     maxTime = _maxTime;
437     addedTime = _addedTime;
438 
439     startTime = block.timestamp;
440     endTime = startTime + maxTime;
441     addressOfCaptain = addressOfOwner;
442 
443     _registerReferral("owner", addressOfOwner);
444 
445     emit Started(startTime);
446   }
447 
448   function buy (address _referral, uint _countryId) public payable active {
449     require(msg.value >= Utils.regularTicketPrice());
450     require(msg.value <= 100000 ether);
451     require(codesOfAddress[_referral].length > 0);
452     require(_countryId != MAIN_SCHEME);
453     require(Utils.validCountryId(_countryId));
454 
455     (uint tickets, uint excess) = Utils.ticketsForWithExcess(msg.value);
456     uint value = msg.value.sub(excess);
457 
458     require(tickets > 0);
459     require(value.add(excess) == msg.value);
460 
461     Info storage info = infoOfAddress[msg.sender];
462 
463     if (info.countryId == 0) {
464       info.referral = _referral;
465       info.countryId = _countryId;
466     }
467 
468     uint vdivs = Utils.percentageOf(value, TO_DIVIDENDS);
469     uint vreferral = Utils.percentageOf(value, TO_REFERRAL);
470     uint vdevs = Utils.percentageOf(value, TO_DEVELOPERS);
471     uint vcountry = Utils.percentageOf(value, TO_COUNTRY);
472     uint vpot = value.sub(vdivs).sub(vreferral).sub(vdevs).sub(vcountry);
473 
474     assert(vdivs.add(vreferral).add(vdevs).add(vcountry).add(vpot) == value);
475 
476     buyShares(MAIN_SCHEME, msg.sender, tickets, vdivs);
477     buyShares(info.countryId, msg.sender, tickets, vcountry);
478 
479     creditVault(MAIN_SCHEME, info.referral, vreferral);
480     creditVault(MAIN_SCHEME, addressOfOwner, vdevs);
481 
482     if (excess > 0) {
483       creditVault(MAIN_SCHEME, msg.sender, excess);
484     }
485 
486     uint goldenTickets = value.div(Utils.goldenTicketPrice(totalPot));
487     if (goldenTickets > 0) {
488       endTime = endTime.add(goldenTickets.mul(addedTime)) > block.timestamp.add(maxTime) ?
489         block.timestamp.add(maxTime) : endTime.add(goldenTickets.mul(addedTime));
490       addressOfCaptain = msg.sender;
491       emit Promoted(addressOfCaptain, goldenTickets, endTime);
492     }
493 
494     totalPot = totalPot.add(vpot);
495 
496     emit Bought(msg.sender, info.referral, info.countryId, tickets, value, excess);
497   }
498 
499   function setNick (string _nick) public payable {
500     require(msg.value == SET_NICK_FEE);
501     require(Utils.validNick(_nick));
502     infoOfAddress[msg.sender].nick = _nick;
503     creditVault(MAIN_SCHEME, addressOfOwner, msg.value);
504   }
505 
506   function registerCode (string _code) public payable {
507     require(startTime > 0);
508     require(msg.value == REFERRAL_REGISTRATION_FEE);
509     _registerReferral(_code, msg.sender);
510     creditVault(MAIN_SCHEME, addressOfOwner, msg.value);
511   }
512 
513   function giftCode (string _code, address _referral) public restricted {
514     _registerReferral(_code, _referral);
515   }
516 
517   function withdraw () public {
518     Info storage info = infoOfAddress[msg.sender];
519     uint payout = withdrawVault(MAIN_SCHEME, msg.sender);
520 
521     if (Utils.validCountryId(info.countryId)) {
522       payout = payout.add(withdrawVault(info.countryId, msg.sender));
523     }
524 
525     if (payout > 0) {
526       info.withdrawn = info.withdrawn.add(payout);
527       msg.sender.transfer(payout);
528       emit Withdrew(msg.sender, payout);
529     }
530   }
531 
532   function withdrawPot () public player {
533     require(startTime > 0);
534     require(block.timestamp > (endTime + 10 minutes));
535     require(!potWithdrawn);
536     require(totalPot > 0);
537     require(addressOfCaptain == msg.sender);
538 
539     uint payout = totalPot;
540     totalPot = 0;
541     potWithdrawn = true;
542     addressOfCaptain.transfer(payout);
543     emit Won(msg.sender, payout);
544   }
545 }