1 pragma solidity ^0.5.0;
2 
3 contract GemLike {
4     function approve(address, uint) public;
5     function transfer(address, uint) public;
6     function transferFrom(address, address, uint) public;
7     function deposit() public payable;
8     function withdraw(uint) public;
9 }
10 
11 contract ManagerLike {
12     function cdpCan(address, uint, address) public view returns (uint);
13     function ilks(uint) public view returns (bytes32);
14     function owns(uint) public view returns (address);
15     function urns(uint) public view returns (address);
16     function vat() public view returns (address);
17     function open(bytes32, address) public returns (uint);
18     function give(uint, address) public;
19     function cdpAllow(uint, address, uint) public;
20     function urnAllow(address, uint) public;
21     function frob(uint, int, int) public;
22     function flux(uint, address, uint) public;
23     function move(uint, address, uint) public;
24     function exit(address, uint, address, uint) public;
25     function quit(uint, address) public;
26     function enter(address, uint) public;
27     function shift(uint, uint) public;
28 }
29 
30 contract VatLike {
31     function can(address, address) public view returns (uint);
32     function ilks(bytes32) public view returns (uint, uint, uint, uint, uint);
33     function dai(address) public view returns (uint);
34     function urns(bytes32, address) public view returns (uint, uint);
35     function frob(bytes32, address, address, address, int, int) public;
36     function hope(address) public;
37     function move(address, address, uint) public;
38 }
39 
40 contract GemJoinLike {
41     function dec() public returns (uint);
42     function gem() public returns (GemLike);
43     function join(address, uint) public payable;
44     function exit(address, uint) public;
45 }
46 
47 contract GNTJoinLike {
48     function bags(address) public view returns (address);
49     function make(address) public returns (address);
50 }
51 
52 contract DaiJoinLike {
53     function vat() public returns (VatLike);
54     function dai() public returns (GemLike);
55     function join(address, uint) public payable;
56     function exit(address, uint) public;
57 }
58 
59 contract HopeLike {
60     function hope(address) public;
61     function nope(address) public;
62 }
63 
64 contract ProxyRegistryInterface {
65     function build(address) public returns (address);
66 }
67 
68 contract EndLike {
69     function fix(bytes32) public view returns (uint);
70     function cash(bytes32, uint) public;
71     function free(bytes32) public;
72     function pack(uint) public;
73     function skim(bytes32, address) public;
74 }
75 
76 contract JugLike {
77     function drip(bytes32) public returns (uint);
78 }
79 
80 contract PotLike {
81     function pie(address) public view returns (uint);
82     function drip() public returns (uint);
83     function join(uint) public;
84     function exit(uint) public;
85 }
86 
87 contract ProxyRegistryLike {
88     function proxies(address) public view returns (address);
89     function build(address) public returns (address);
90 }
91 
92 contract ProxyLike {
93     function owner() public view returns (address);
94 }
95 
96 contract DSProxy {
97     function execute(address _target, bytes memory _data) public payable returns (bytes32);
98     function setOwner(address owner_) public;
99 }
100 
101 // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
102 // WARNING: These functions meant to be used as a a library for a DSProxy. Some are unsafe if you call them directly.
103 // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
104 
105 contract Common {
106     uint256 constant RAY = 10 ** 27;
107 
108     // Internal functions
109 
110     function mul(uint x, uint y) internal pure returns (uint z) {
111         require(y == 0 || (z = x * y) / y == x, "mul-overflow");
112     }
113 
114     // Public functions
115 
116     function daiJoin_join(address apt, address urn, uint wad) public {
117         // Gets DAI from the user's wallet
118         DaiJoinLike(apt).dai().transferFrom(msg.sender, address(this), wad);
119         // Approves adapter to take the DAI amount
120         DaiJoinLike(apt).dai().approve(apt, wad);
121         // Joins DAI into the vat
122         DaiJoinLike(apt).join(urn, wad);
123     }
124 }
125 
126 contract SaverProxyActions is Common {
127 
128 
129     event CDPAction(string indexed, uint indexed, uint, uint);
130 
131     // Internal functions
132 
133     function sub(uint x, uint y) internal pure returns (uint z) {
134         require((z = x - y) <= x, "sub-overflow");
135     }
136 
137     function toInt(uint x) internal pure returns (int y) {
138         y = int(x);
139         require(y >= 0, "int-overflow");
140     }
141 
142     function toRad(uint wad) internal pure returns (uint rad) {
143         rad = mul(wad, 10 ** 27);
144     }
145 
146     function convertTo18(address gemJoin, uint256 amt) internal returns (uint256 wad) {
147         // For those collaterals that have less than 18 decimals precision we need to do the conversion before passing to frob function
148         // Adapters will automatically handle the difference of precision
149         wad = mul(
150             amt,
151             10 ** (18 - GemJoinLike(gemJoin).dec())
152         );
153     }
154 
155     function _getDrawDart(
156         address vat,
157         address jug,
158         address urn,
159         bytes32 ilk,
160         uint wad
161     ) internal returns (int dart) {
162         // Updates stability fee rate
163         uint rate = JugLike(jug).drip(ilk);
164 
165         // Gets DAI balance of the urn in the vat
166         uint dai = VatLike(vat).dai(urn);
167 
168         // If there was already enough DAI in the vat balance, just exits it without adding more debt
169         if (dai < mul(wad, RAY)) {
170             // Calculates the needed dart so together with the existing dai in the vat is enough to exit wad amount of DAI tokens
171             dart = toInt(sub(mul(wad, RAY), dai) / rate);
172             // This is neeeded due lack of precision. It might need to sum an extra dart wei (for the given DAI wad amount)
173             dart = mul(uint(dart), rate) < mul(wad, RAY) ? dart + 1 : dart;
174         }
175     }
176 
177     function _getWipeDart(
178         address vat,
179         uint dai,
180         address urn,
181         bytes32 ilk
182     ) internal view returns (int dart) {
183         // Gets actual rate from the vat
184         (, uint rate,,,) = VatLike(vat).ilks(ilk);
185         // Gets actual art value of the urn
186         (, uint art) = VatLike(vat).urns(ilk, urn);
187 
188         // Uses the whole dai balance in the vat to reduce the debt
189         dart = toInt(dai / rate);
190         // Checks the calculated dart is not higher than urn.art (total debt), otherwise uses its value
191         dart = uint(dart) <= art ? - dart : - toInt(art);
192     }
193 
194     function _getWipeAllWad(
195         address vat,
196         address usr,
197         address urn,
198         bytes32 ilk
199     ) internal view returns (uint wad) {
200         // Gets actual rate from the vat
201         (, uint rate,,,) = VatLike(vat).ilks(ilk);
202         // Gets actual art value of the urn
203         (, uint art) = VatLike(vat).urns(ilk, urn);
204         // Gets actual dai amount in the urn
205         uint dai = VatLike(vat).dai(usr);
206 
207         uint rad = sub(mul(art, rate), dai);
208         wad = rad / RAY;
209 
210         // If the rad precision has some dust, it will need to request for 1 extra wad wei
211         wad = mul(wad, RAY) < rad ? wad + 1 : wad;
212     }
213 
214     // Public functions
215 
216     function transfer(address gem, address dst, uint wad) public {
217         GemLike(gem).transfer(dst, wad);
218     }
219 
220     function ethJoin_join(address apt, address urn) public payable {
221         // Wraps ETH in WETH
222         GemJoinLike(apt).gem().deposit.value(msg.value)();
223         // Approves adapter to take the WETH amount
224         GemJoinLike(apt).gem().approve(address(apt), msg.value);
225         // Joins WETH collateral into the vat
226         GemJoinLike(apt).join(urn, msg.value);
227     }
228 
229     function gemJoin_join(address apt, address urn, uint wad, bool transferFrom) public {
230         // Only executes for tokens that have approval/transferFrom implementation
231         if (transferFrom) {
232             // Gets token from the user's wallet
233             GemJoinLike(apt).gem().transferFrom(msg.sender, address(this), wad);
234             // Approves adapter to take the token amount
235             GemJoinLike(apt).gem().approve(apt, wad);
236         }
237         // Joins token collateral into the vat
238         GemJoinLike(apt).join(urn, wad);
239     }
240 
241     function hope(
242         address obj,
243         address usr
244     ) public {
245         HopeLike(obj).hope(usr);
246     }
247 
248     function nope(
249         address obj,
250         address usr
251     ) public {
252         HopeLike(obj).nope(usr);
253     }
254 
255     function open(
256         address manager,
257         bytes32 ilk,
258         address usr
259     ) public returns (uint cdp) {
260         cdp = ManagerLike(manager).open(ilk, usr);
261     }
262 
263     function give(
264         address manager,
265         uint cdp,
266         address usr
267     ) public {
268         ManagerLike(manager).give(cdp, usr);
269 
270         emit CDPAction('give', cdp, 0, 0);
271     }
272 
273     function giveToProxy(
274         address proxyRegistry,
275         address manager,
276         uint cdp,
277         address dst
278     ) public {
279         // Gets actual proxy address
280         address proxy = ProxyRegistryLike(proxyRegistry).proxies(dst);
281         // Checks if the proxy address already existed and dst address is still the owner
282         if (proxy == address(0) || ProxyLike(proxy).owner() != dst) {
283             uint csize;
284             assembly {
285                 csize := extcodesize(dst)
286             }
287             // We want to avoid creating a proxy for a contract address that might not be able to handle proxies, then losing the CDP
288             require(csize == 0, "Dst-is-a-contract");
289             // Creates the proxy for the dst address
290             proxy = ProxyRegistryLike(proxyRegistry).build(dst);
291         }
292         // Transfers CDP to the dst proxy
293         give(manager, cdp, proxy);
294     }
295 
296     function cdpAllow(
297         address manager,
298         uint cdp,
299         address usr,
300         uint ok
301     ) public {
302         ManagerLike(manager).cdpAllow(cdp, usr, ok);
303     }
304 
305     function urnAllow(
306         address manager,
307         address usr,
308         uint ok
309     ) public {
310         ManagerLike(manager).urnAllow(usr, ok);
311     }
312 
313     function flux(
314         address manager,
315         uint cdp,
316         address dst,
317         uint wad
318     ) public {
319         ManagerLike(manager).flux(cdp, dst, wad);
320     }
321 
322     function move(
323         address manager,
324         uint cdp,
325         address dst,
326         uint rad
327     ) public {
328         ManagerLike(manager).move(cdp, dst, rad);
329     }
330 
331     function frob(
332         address manager,
333         uint cdp,
334         int dink,
335         int dart
336     ) public {
337         ManagerLike(manager).frob(cdp, dink, dart);
338     }
339 
340     function quit(
341         address manager,
342         uint cdp,
343         address dst
344     ) public {
345         ManagerLike(manager).quit(cdp, dst);
346     }
347 
348     function enter(
349         address manager,
350         address src,
351         uint cdp
352     ) public {
353         ManagerLike(manager).enter(src, cdp);
354     }
355 
356     function shift(
357         address manager,
358         uint cdpSrc,
359         uint cdpOrg
360     ) public {
361         ManagerLike(manager).shift(cdpSrc, cdpOrg);
362     }
363 
364     function makeGemBag(
365         address gemJoin
366     ) public returns (address bag) {
367         bag = GNTJoinLike(gemJoin).make(address(this));
368     }
369 
370     function lockETH(
371         address manager,
372         address ethJoin,
373         uint cdp
374     ) public payable {
375         // Receives ETH amount, converts it to WETH and joins it into the vat
376         ethJoin_join(ethJoin, address(this));
377         // Locks WETH amount into the CDP
378         VatLike(ManagerLike(manager).vat()).frob(
379             ManagerLike(manager).ilks(cdp),
380             ManagerLike(manager).urns(cdp),
381             address(this),
382             address(this),
383             toInt(msg.value),
384             0
385         );
386 
387         emit CDPAction('lockETH', cdp, msg.value, 0);
388     }
389 
390     function lockGem(
391         address manager,
392         address gemJoin,
393         uint cdp,
394         uint wad,
395         bool transferFrom
396     ) public {
397         // Takes token amount from user's wallet and joins into the vat
398         gemJoin_join(gemJoin, address(this), wad, transferFrom);
399         // Locks token amount into the CDP
400         VatLike(ManagerLike(manager).vat()).frob(
401             ManagerLike(manager).ilks(cdp),
402             ManagerLike(manager).urns(cdp),
403             address(this),
404             address(this),
405             toInt(convertTo18(gemJoin, wad)),
406             0
407         );
408 
409         emit CDPAction('lockGem', cdp, wad, 0);
410     }
411 
412     function freeETH(
413         address manager,
414         address ethJoin,
415         uint cdp,
416         uint wad
417     ) public {
418         // Unlocks WETH amount from the CDP
419         frob(manager, cdp, -toInt(wad), 0);
420         // Moves the amount from the CDP urn to proxy's address
421         flux(manager, cdp, address(this), wad);
422         // Exits WETH amount to proxy address as a token
423         GemJoinLike(ethJoin).exit(address(this), wad);
424         // Converts WETH to ETH
425         GemJoinLike(ethJoin).gem().withdraw(wad);
426         // Sends ETH back to the user's wallet
427         msg.sender.transfer(wad);
428 
429         emit CDPAction('freeETH', cdp, wad, 0);
430     }
431 
432     function freeGem(
433         address manager,
434         address gemJoin,
435         uint cdp,
436         uint wad
437     ) public {
438         uint wad18 = convertTo18(gemJoin, wad);
439         // Unlocks token amount from the CDP
440         frob(manager, cdp, -toInt(wad18), 0);
441         // Moves the amount from the CDP urn to proxy's address
442         flux(manager, cdp, address(this), wad18);
443         // Exits token amount to the user's wallet as a token
444         GemJoinLike(gemJoin).exit(msg.sender, wad);
445 
446         emit CDPAction('freeGem', cdp, wad, 0);
447     }
448 
449     function exitETH(
450         address manager,
451         address ethJoin,
452         uint cdp,
453         uint wad
454     ) public {
455         // Moves the amount from the CDP urn to proxy's address
456         flux(manager, cdp, address(this), wad);
457 
458         // Exits WETH amount to proxy address as a token
459         GemJoinLike(ethJoin).exit(address(this), wad);
460         // Converts WETH to ETH
461         GemJoinLike(ethJoin).gem().withdraw(wad);
462         // Sends ETH back to the user's wallet
463         msg.sender.transfer(wad);
464     }
465 
466     function exitGem(
467         address manager,
468         address gemJoin,
469         uint cdp,
470         uint wad
471     ) public {
472         // Moves the amount from the CDP urn to proxy's address
473         flux(manager, cdp, address(this), convertTo18(gemJoin, wad));
474 
475         // Exits token amount to the user's wallet as a token
476         GemJoinLike(gemJoin).exit(msg.sender, wad);
477     }
478 
479     function draw(
480         address manager,
481         address jug,
482         address daiJoin,
483         uint cdp,
484         uint wad
485     ) public {
486         address urn = ManagerLike(manager).urns(cdp);
487         address vat = ManagerLike(manager).vat();
488         bytes32 ilk = ManagerLike(manager).ilks(cdp);
489         // Generates debt in the CDP
490         frob(manager, cdp, 0, _getDrawDart(vat, jug, urn, ilk, wad));
491         // Moves the DAI amount (balance in the vat in rad) to proxy's address
492         move(manager, cdp, address(this), toRad(wad));
493         // Allows adapter to access to proxy's DAI balance in the vat
494         if (VatLike(vat).can(address(this), address(daiJoin)) == 0) {
495             VatLike(vat).hope(daiJoin);
496         }
497         // Exits DAI to the user's wallet as a token
498         DaiJoinLike(daiJoin).exit(msg.sender, wad);
499 
500         emit CDPAction('draw', cdp, 0, wad);
501     }
502 
503     function wipe(
504         address manager,
505         address daiJoin,
506         uint cdp,
507         uint wad
508     ) public {
509         address vat = ManagerLike(manager).vat();
510         address urn = ManagerLike(manager).urns(cdp);
511         bytes32 ilk = ManagerLike(manager).ilks(cdp);
512 
513         address own = ManagerLike(manager).owns(cdp);
514         if (own == address(this) || ManagerLike(manager).cdpCan(own, cdp, address(this)) == 1) {
515             // Joins DAI amount into the vat
516             daiJoin_join(daiJoin, urn, wad);
517             // Paybacks debt to the CDP
518             frob(manager, cdp, 0, _getWipeDart(vat, VatLike(vat).dai(urn), urn, ilk));
519         } else {
520              // Joins DAI amount into the vat
521             daiJoin_join(daiJoin, address(this), wad);
522             // Paybacks debt to the CDP
523             VatLike(vat).frob(
524                 ilk,
525                 urn,
526                 address(this),
527                 address(this),
528                 0,
529                 _getWipeDart(vat, wad * RAY, urn, ilk)
530             );
531         }
532 
533         emit CDPAction('wipe', cdp, 0, wad);
534     }
535 
536     function wipeAll(
537         address manager,
538         address daiJoin,
539         uint cdp
540     ) public {
541         address vat = ManagerLike(manager).vat();
542         address urn = ManagerLike(manager).urns(cdp);
543         bytes32 ilk = ManagerLike(manager).ilks(cdp);
544         (, uint art) = VatLike(vat).urns(ilk, urn);
545 
546         address own = ManagerLike(manager).owns(cdp);
547         if (own == address(this) || ManagerLike(manager).cdpCan(own, cdp, address(this)) == 1) {
548             // Joins DAI amount into the vat
549             daiJoin_join(daiJoin, urn, _getWipeAllWad(vat, urn, urn, ilk));
550             // Paybacks debt to the CDP
551             frob(manager, cdp, 0, -int(art));
552         } else {
553             // Joins DAI amount into the vat
554             daiJoin_join(daiJoin, address(this), _getWipeAllWad(vat, address(this), urn, ilk));
555             // Paybacks debt to the CDP
556             VatLike(vat).frob(
557                 ilk,
558                 urn,
559                 address(this),
560                 address(this),
561                 0,
562                 -int(art)
563             );
564         }
565 
566         emit CDPAction('wipeAll', cdp, 0, art);
567     }
568 
569     function lockETHAndDraw(
570         address manager,
571         address jug,
572         address ethJoin,
573         address daiJoin,
574         uint cdp,
575         uint wadD
576     ) public payable {
577         address urn = ManagerLike(manager).urns(cdp);
578         address vat = ManagerLike(manager).vat();
579         bytes32 ilk = ManagerLike(manager).ilks(cdp);
580         // Receives ETH amount, converts it to WETH and joins it into the vat
581         ethJoin_join(ethJoin, urn);
582         // Locks WETH amount into the CDP and generates debt
583         frob(manager, cdp, toInt(msg.value), _getDrawDart(vat, jug, urn, ilk, wadD));
584         // Moves the DAI amount (balance in the vat in rad) to proxy's address
585         move(manager, cdp, address(this), toRad(wadD));
586         // Allows adapter to access to proxy's DAI balance in the vat
587         if (VatLike(vat).can(address(this), address(daiJoin)) == 0) {
588             VatLike(vat).hope(daiJoin);
589         }
590         // Exits DAI to the user's wallet as a token
591         DaiJoinLike(daiJoin).exit(msg.sender, wadD);
592     }
593 
594     function openLockETHAndDraw(
595         address manager,
596         address jug,
597         address ethJoin,
598         address daiJoin,
599         bytes32 ilk,
600         uint wadD
601     ) public payable returns (uint cdp) {
602         cdp = open(manager, ilk, address(this));
603         lockETHAndDraw(manager, jug, ethJoin, daiJoin, cdp, wadD);
604 
605         emit CDPAction('openLockETHAndDraw', cdp, msg.value, wadD);
606     }
607 
608     function lockGemAndDraw(
609         address manager,
610         address jug,
611         address gemJoin,
612         address daiJoin,
613         uint cdp,
614         uint wadC,
615         uint wadD,
616         bool transferFrom
617     ) public {
618         address urn = ManagerLike(manager).urns(cdp);
619         address vat = ManagerLike(manager).vat();
620         bytes32 ilk = ManagerLike(manager).ilks(cdp);
621         // Takes token amount from user's wallet and joins into the vat
622         gemJoin_join(gemJoin, urn, wadC, transferFrom);
623         // Locks token amount into the CDP and generates debt
624         frob(manager, cdp, toInt(convertTo18(gemJoin, wadC)), _getDrawDart(vat, jug, urn, ilk, wadD));
625         // Moves the DAI amount (balance in the vat in rad) to proxy's address
626         move(manager, cdp, address(this), toRad(wadD));
627         // Allows adapter to access to proxy's DAI balance in the vat
628         if (VatLike(vat).can(address(this), address(daiJoin)) == 0) {
629             VatLike(vat).hope(daiJoin);
630         }
631         // Exits DAI to the user's wallet as a token
632         DaiJoinLike(daiJoin).exit(msg.sender, wadD);
633 
634     }
635 
636     function openLockGemAndDraw(
637         address manager,
638         address jug,
639         address gemJoin,
640         address daiJoin,
641         bytes32 ilk,
642         uint wadC,
643         uint wadD,
644         bool transferFrom
645     ) public returns (uint cdp) {
646         cdp = open(manager, ilk, address(this));
647         lockGemAndDraw(manager, jug, gemJoin, daiJoin, cdp, wadC, wadD, transferFrom);
648 
649         emit CDPAction('openLockGemAndDraw', cdp, wadC, wadD);
650 
651     }
652 
653     function wipeAllAndFreeETH(
654         address manager,
655         address ethJoin,
656         address daiJoin,
657         uint cdp,
658         uint wadC
659     ) public {
660         address vat = ManagerLike(manager).vat();
661         address urn = ManagerLike(manager).urns(cdp);
662         bytes32 ilk = ManagerLike(manager).ilks(cdp);
663         (, uint art) = VatLike(vat).urns(ilk, urn);
664 
665         // Joins DAI amount into the vat
666         daiJoin_join(daiJoin, urn, _getWipeAllWad(vat, urn, urn, ilk));
667         // Paybacks debt to the CDP and unlocks WETH amount from it
668         frob(
669             manager,
670             cdp,
671             -toInt(wadC),
672             -int(art)
673         );
674         // Moves the amount from the CDP urn to proxy's address
675         flux(manager, cdp, address(this), wadC);
676         // Exits WETH amount to proxy address as a token
677         GemJoinLike(ethJoin).exit(address(this), wadC);
678         // Converts WETH to ETH
679         GemJoinLike(ethJoin).gem().withdraw(wadC);
680         // Sends ETH back to the user's wallet
681         msg.sender.transfer(wadC);
682 
683         emit CDPAction('wipeAllAndFreeETH', cdp, wadC, art);
684     }
685 
686     function wipeAndFreeGem(
687         address manager,
688         address gemJoin,
689         address daiJoin,
690         uint cdp,
691         uint wadC,
692         uint wadD
693     ) public {
694         address urn = ManagerLike(manager).urns(cdp);
695         // Joins DAI amount into the vat
696         daiJoin_join(daiJoin, urn, wadD);
697         uint wad18 = convertTo18(gemJoin, wadC);
698         // Paybacks debt to the CDP and unlocks token amount from it
699         frob(
700             manager,
701             cdp,
702             -toInt(wad18),
703             _getWipeDart(ManagerLike(manager).vat(), VatLike(ManagerLike(manager).vat()).dai(urn), urn, ManagerLike(manager).ilks(cdp))
704         );
705         // Moves the amount from the CDP urn to proxy's address
706         flux(manager, cdp, address(this), wad18);
707         // Exits token amount to the user's wallet as a token
708         GemJoinLike(gemJoin).exit(msg.sender, wadC);
709     }
710 
711     function wipeAllAndFreeGem(
712         address manager,
713         address gemJoin,
714         address daiJoin,
715         uint cdp,
716         uint wadC
717     ) public {
718         address vat = ManagerLike(manager).vat();
719         address urn = ManagerLike(manager).urns(cdp);
720         bytes32 ilk = ManagerLike(manager).ilks(cdp);
721         (, uint art) = VatLike(vat).urns(ilk, urn);
722 
723         // Joins DAI amount into the vat
724         daiJoin_join(daiJoin, urn, _getWipeAllWad(vat, urn, urn, ilk));
725         uint wad18 = convertTo18(gemJoin, wadC);
726         // Paybacks debt to the CDP and unlocks token amount from it
727         frob(
728             manager,
729             cdp,
730             -toInt(wad18),
731             -int(art)
732         );
733         // Moves the amount from the CDP urn to proxy's address
734         flux(manager, cdp, address(this), wad18);
735         // Exits token amount to the user's wallet as a token
736         GemJoinLike(gemJoin).exit(msg.sender, wadC);
737 
738         emit CDPAction('wipeAllAndFreeGem', cdp, wadC, art);
739     }
740 
741     function createProxyAndCDP(
742         address manager,
743         address jug,
744         address ethJoin,
745         address daiJoin,
746         bytes32 ilk,
747         uint wadD,
748         address registry
749         ) public payable returns(uint) {
750       
751             address proxy = ProxyRegistryInterface(registry).build(msg.sender);
752             
753             uint cdp = openLockETHAndDraw(manager,
754                 jug,
755                 ethJoin,
756                 daiJoin,
757                 ilk,
758                 wadD
759                 );
760             
761             give(manager, cdp, address(proxy));
762             
763             return cdp;
764 
765     }
766 
767     function createProxyAndGemCDP(
768         address manager,
769         address jug,
770         address gemJoin,
771         address daiJoin,
772         bytes32 ilk,
773         uint wadC,
774         uint wadD,
775         bool transferFrom,
776         address registry
777         ) public returns(uint) {
778             
779 
780             address proxy = ProxyRegistryInterface(registry).build(msg.sender);
781             
782             uint cdp = openLockGemAndDraw(manager,
783                 jug,
784                 gemJoin,
785                 daiJoin,
786                 ilk,
787                 wadC,
788                 wadD,
789                 transferFrom);
790             
791             give(manager, cdp, address(proxy));
792             
793             return cdp;
794     }
795 }