1 pragma solidity ^0.4.15;
2  
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 library SafeMath {
17     
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23  
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28  
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33  
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract BasicToken is ERC20Basic {
42     
43   using SafeMath for uint256;
44  
45   mapping(address => uint256) balances;
46 
47   event ShowTestB(bool _bool);
48   event ShowTestU(string _string, uint _uint);
49 
50   //uint256 ico_finish = 1512565200;
51   uint256 ico_finish = 1513774800;
52 
53   struct FreezePhases {
54     uint256 firstPhaseTime;
55     uint256 secondPhaseTime;
56     uint256 thirdPhaseTime;
57     uint256 fourPhaseTime;
58 
59     uint256 countTokens;
60 
61     uint256 firstPhaseCount;
62     uint256 secondPhaseCount;
63     uint256 thirdPhaseCount;
64     uint256 fourPhaseCount;
65   }
66 
67   mapping(address => FreezePhases) founding_tokens;
68   mapping(address => FreezePhases) angel_tokens;
69   mapping(address => FreezePhases) team_core_tokens;
70   mapping(address => FreezePhases) pe_investors_tokens;
71 
72   mapping(address => bool) forceFreeze;
73 
74   address[] founding_addresses;
75   address[] angel_addresses;
76   address[] team_core_addresses;
77   address[] pe_investors_addresses;
78 
79   function isFreeze(address _addr, uint256 _value) public {
80     require(!forceFreeze[_addr]);
81 
82     if (now < ico_finish) {
83       revert();
84     }
85 
86     bool isFounder = false;
87     bool isAngel = false;
88     bool isTeam = false;
89     bool isPE = false;
90 
91     //for founding
92     //-----------------------------------------------------//
93 
94     isFounder = findAddress(founding_addresses, _addr);
95 
96     if (isFounder) {
97       if (now > founding_tokens[_addr].firstPhaseTime && now < founding_tokens[_addr].secondPhaseTime) {
98         if (_value <= founding_tokens[_addr].firstPhaseCount) {
99           founding_tokens[_addr].firstPhaseCount = founding_tokens[_addr].firstPhaseCount - _value;
100         } else {
101           revert();
102         }
103       } else {
104         founding_tokens[_addr].secondPhaseCount = founding_tokens[_addr].secondPhaseCount + founding_tokens[_addr].firstPhaseCount;
105         founding_tokens[_addr].firstPhaseCount = 0;
106       }
107 
108       if (now > founding_tokens[_addr].secondPhaseTime && now < founding_tokens[_addr].thirdPhaseTime) {
109         if (_value <= founding_tokens[_addr].secondPhaseCount) {
110           founding_tokens[_addr].secondPhaseCount = founding_tokens[_addr].secondPhaseCount - _value;
111         } else {
112           revert();
113         }
114       } else {
115         founding_tokens[_addr].thirdPhaseCount = founding_tokens[_addr].thirdPhaseCount + founding_tokens[_addr].secondPhaseCount;
116         founding_tokens[_addr].secondPhaseCount = 0;
117       }
118 
119       if (now > founding_tokens[_addr].thirdPhaseTime && now < founding_tokens[_addr].fourPhaseTime) {
120         if (_value <= founding_tokens[_addr].thirdPhaseCount) {
121           founding_tokens[_addr].thirdPhaseCount = founding_tokens[_addr].thirdPhaseCount - _value;
122         } else {
123           revert();
124         }
125       } else {
126         founding_tokens[_addr].fourPhaseCount = founding_tokens[_addr].fourPhaseCount + founding_tokens[_addr].thirdPhaseCount;
127         founding_tokens[_addr].thirdPhaseCount = 0;
128       }
129 
130       if (now > founding_tokens[_addr].fourPhaseTime) {
131         if (_value <= founding_tokens[_addr].fourPhaseCount) {
132           founding_tokens[_addr].fourPhaseCount = founding_tokens[_addr].fourPhaseCount - _value;
133         } else {
134           revert();
135         }
136       }
137     }
138     //-----------------------------------------------------//
139 
140     //for angel
141     //-----------------------------------------------------//
142 
143     isAngel = findAddress(angel_addresses, _addr);
144 
145     ShowTestB(isAngel);
146     ShowTestU("firstPhaseCount", angel_tokens[_addr].firstPhaseCount);
147     ShowTestB(_value <= angel_tokens[_addr].firstPhaseCount);
148 
149     if (isAngel) {
150       if (now > angel_tokens[_addr].firstPhaseTime && now < angel_tokens[_addr].secondPhaseTime) {
151         if (_value <= angel_tokens[_addr].firstPhaseCount) {
152           angel_tokens[_addr].firstPhaseCount = angel_tokens[_addr].firstPhaseCount - _value;
153         } else {
154           revert();
155         }
156       } else {
157         angel_tokens[_addr].secondPhaseCount = angel_tokens[_addr].secondPhaseCount + angel_tokens[_addr].firstPhaseCount;
158         angel_tokens[_addr].firstPhaseCount = 0;
159       }
160 
161       if (now > angel_tokens[_addr].secondPhaseTime && now < angel_tokens[_addr].thirdPhaseTime) {
162         if (_value <= angel_tokens[_addr].secondPhaseCount) {
163           angel_tokens[_addr].secondPhaseCount = angel_tokens[_addr].secondPhaseCount - _value;
164         } else {
165           revert();
166         }
167       } else {
168         angel_tokens[_addr].thirdPhaseCount = angel_tokens[_addr].thirdPhaseCount + angel_tokens[_addr].secondPhaseCount;
169         angel_tokens[_addr].secondPhaseCount = 0;
170       }
171 
172       if (now > angel_tokens[_addr].thirdPhaseTime && now < angel_tokens[_addr].fourPhaseTime) {
173         if (_value <= angel_tokens[_addr].thirdPhaseCount) {
174           angel_tokens[_addr].thirdPhaseCount = angel_tokens[_addr].thirdPhaseCount - _value;
175         } else {
176           revert();
177         }
178       } else {
179         angel_tokens[_addr].fourPhaseCount = angel_tokens[_addr].fourPhaseCount + angel_tokens[_addr].thirdPhaseCount;
180         angel_tokens[_addr].thirdPhaseCount = 0;
181       }
182 
183       if (now > angel_tokens[_addr].fourPhaseTime) {
184         if (_value <= angel_tokens[_addr].fourPhaseCount) {
185           angel_tokens[_addr].fourPhaseCount = angel_tokens[_addr].fourPhaseCount - _value;
186         } else {
187           revert();
188         }
189       }
190     }
191     //-----------------------------------------------------//
192 
193     //for Team Core
194     //-----------------------------------------------------//
195 
196     isTeam = findAddress(team_core_addresses, _addr);
197 
198     if (isTeam) {
199       if (now > team_core_tokens[_addr].firstPhaseTime && now < team_core_tokens[_addr].secondPhaseTime) {
200         if (_value <= team_core_tokens[_addr].firstPhaseCount) {
201           team_core_tokens[_addr].firstPhaseCount = team_core_tokens[_addr].firstPhaseCount - _value;
202         } else {
203           revert();
204         }
205       } else {
206         team_core_tokens[_addr].secondPhaseCount = team_core_tokens[_addr].secondPhaseCount + team_core_tokens[_addr].firstPhaseCount;
207         team_core_tokens[_addr].firstPhaseCount = 0;
208       }
209 
210       if (now > team_core_tokens[_addr].secondPhaseTime && now < team_core_tokens[_addr].thirdPhaseTime) {
211         if (_value <= team_core_tokens[_addr].secondPhaseCount) {
212           team_core_tokens[_addr].secondPhaseCount = team_core_tokens[_addr].secondPhaseCount - _value;
213         } else {
214           revert();
215         }
216       } else {
217         team_core_tokens[_addr].thirdPhaseCount = team_core_tokens[_addr].thirdPhaseCount + team_core_tokens[_addr].secondPhaseCount;
218         team_core_tokens[_addr].secondPhaseCount = 0;
219       }
220 
221       if (now > team_core_tokens[_addr].thirdPhaseTime && now < team_core_tokens[_addr].fourPhaseTime) {
222         if (_value <= team_core_tokens[_addr].thirdPhaseCount) {
223           team_core_tokens[_addr].thirdPhaseCount = team_core_tokens[_addr].thirdPhaseCount - _value;
224         } else {
225           revert();
226         }
227       } else {
228         team_core_tokens[_addr].fourPhaseCount = team_core_tokens[_addr].fourPhaseCount + team_core_tokens[_addr].thirdPhaseCount;
229         team_core_tokens[_addr].thirdPhaseCount = 0;
230       }
231 
232       if (now > team_core_tokens[_addr].fourPhaseTime) {
233         if (_value <= team_core_tokens[_addr].fourPhaseCount) {
234           team_core_tokens[_addr].fourPhaseCount = team_core_tokens[_addr].fourPhaseCount - _value;
235         } else {
236           revert();
237         }
238       }
239     }
240     //-----------------------------------------------------//
241 
242     //for PE Investors
243     //-----------------------------------------------------//
244 
245     isPE = findAddress(pe_investors_addresses, _addr);
246 
247     if (isPE) {
248       if (now > pe_investors_tokens[_addr].firstPhaseTime && now < pe_investors_tokens[_addr].secondPhaseTime) {
249         if (_value <= pe_investors_tokens[_addr].firstPhaseCount) {
250           pe_investors_tokens[_addr].firstPhaseCount = pe_investors_tokens[_addr].firstPhaseCount - _value;
251         } else {
252           revert();
253         }
254       } else {
255         pe_investors_tokens[_addr].secondPhaseCount = pe_investors_tokens[_addr].secondPhaseCount + pe_investors_tokens[_addr].firstPhaseCount;
256         pe_investors_tokens[_addr].firstPhaseCount = 0;
257       }
258 
259       if (now > pe_investors_tokens[_addr].secondPhaseTime && now < pe_investors_tokens[_addr].thirdPhaseTime) {
260         if (_value <= pe_investors_tokens[_addr].secondPhaseCount) {
261           pe_investors_tokens[_addr].secondPhaseCount = pe_investors_tokens[_addr].secondPhaseCount - _value;
262         } else {
263           revert();
264         }
265       } else {
266         pe_investors_tokens[_addr].thirdPhaseCount = pe_investors_tokens[_addr].thirdPhaseCount + pe_investors_tokens[_addr].secondPhaseCount;
267         pe_investors_tokens[_addr].secondPhaseCount = 0;
268       }
269 
270       if (now > pe_investors_tokens[_addr].thirdPhaseTime && now < pe_investors_tokens[_addr].fourPhaseTime) {
271         if (_value <= pe_investors_tokens[_addr].thirdPhaseCount) {
272           pe_investors_tokens[_addr].thirdPhaseCount = pe_investors_tokens[_addr].thirdPhaseCount - _value;
273         } else {
274           revert();
275         }
276       } else {
277         pe_investors_tokens[_addr].fourPhaseCount = pe_investors_tokens[_addr].fourPhaseCount + pe_investors_tokens[_addr].thirdPhaseCount;
278         pe_investors_tokens[_addr].thirdPhaseCount = 0;
279       }
280 
281       if (now > pe_investors_tokens[_addr].fourPhaseTime) {
282         if (_value <= pe_investors_tokens[_addr].fourPhaseCount) {
283           pe_investors_tokens[_addr].fourPhaseCount = pe_investors_tokens[_addr].fourPhaseCount - _value;
284         } else {
285           revert();
286         }
287       }
288     }
289     //-----------------------------------------------------//
290 
291 
292   }
293 
294   function transfer(address _to, uint256 _value) public returns (bool) {
295     require(balances[msg.sender] >= _value);
296     isFreeze(msg.sender, _value);
297     balances[msg.sender] = balances[msg.sender].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     Transfer(msg.sender, _to, _value);
300     return true;
301   }
302 
303   function newTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
304     require(balances[_from] >= _value);
305     isFreeze(_from, _value);
306     balances[_from] = balances[_from].sub(_value);
307     balances[_to] = balances[_to].add(_value);
308     Transfer(_from, _to, _value);
309     return true;
310   }
311  
312   function balanceOf(address _owner) constant returns (uint256 balance) {
313     return balances[_owner];
314   }
315 
316   function findAddress(address[] _addresses, address _addr) private returns(bool) {
317     for (uint256 i = 0; i < _addresses.length; i++) {
318       if (_addresses[i] == _addr) {
319         return true;
320       }
321     }
322     return false;
323   }
324  
325 }
326 contract Ownable {
327     
328   address public owner;
329  
330   function Ownable() {
331     owner = msg.sender;
332   }
333 
334   modifier onlyOwner() {
335     require(msg.sender == owner);
336     _;
337   }
338 
339   function transferOwnership(address newOwner) onlyOwner {
340     require(newOwner != address(0));      
341     owner = newOwner;
342   }
343  
344 }
345 contract StandardToken is ERC20, BasicToken {
346  
347   mapping (address => mapping (address => uint256)) allowed;
348  
349   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
350     isFreeze(_from, _value);
351     var _allowance = allowed[_from][msg.sender];
352  
353     balances[_to] = balances[_to].add(_value);
354     balances[_from] = balances[_from].sub(_value);
355     allowed[_from][msg.sender] = _allowance.sub(_value);
356     Transfer(_from, _to, _value);
357     return true;
358   }
359 }
360 contract MintableToken is StandardToken, Ownable {
361 
362   using SafeMath for uint256;
363 
364   bool mintingFinished = false;
365 
366   bool private initialize = false;
367 
368   // when ICO Finish
369   uint256 firstPhaseTime = 0;
370   // when 3 months Finish
371   uint256 secondPhaseTime = 0;
372   // when 6 months Finish
373   uint256 thirdPhaseTime = 0;
374   // when 9 months Finish
375   uint256 fourPhaseTime = 0;
376 
377   uint256 countTokens = 0;
378 
379   uint256 firstPart = 0;
380   uint256 secondPart = 0;
381   uint256 thirdPart = 0;
382 
383   // 25%
384   uint256 firstPhaseCount = 0;
385   // 25%
386   uint256 secondPhaseCount = 0;
387   // 25%
388   uint256 thirdPhaseCount = 0;
389   // 25%
390   uint256 fourPhaseCount = 0;
391 
392   uint256 totalAmount = 500000000E18;         // 500 000 000;  // with 18 decimals
393 
394   address poolAddress;
395 
396   bool unsoldMove = false;
397 
398   event Mint(address indexed to, uint256 amount);
399 
400     modifier isInitialize() {
401     require(!initialize);
402     _;
403   }
404 
405   function setTotalSupply(address _addr) public onlyOwner isInitialize {
406     totalSupply = totalAmount;
407     poolAddress = _addr;
408     mint(_addr, totalAmount);
409     initialize = true;
410   }
411 
412   modifier canMint() {
413     require(!mintingFinished);
414     _;
415   }
416 
417   function tokenTransferOwnership(address _address) public onlyOwner {
418     transferOwnership(_address);
419   }
420 
421   function finishMinting() public onlyOwner {
422     mintingFinished = true;
423   }
424   
425   function mint(address _address, uint256 _tokens) canMint onlyOwner public {
426 
427     Mint(_address, _tokens);
428 
429     balances[_address] = balances[_address].add(_tokens);
430   }
431 
432   function transferTokens(address _to, uint256 _amount, uint256 freezeTime, uint256 _type) public onlyOwner {
433     require(balances[poolAddress] >= _amount);
434 
435     Transfer(poolAddress, _to, _amount);
436 
437     ShowTestU("Before condition",_amount);
438 
439     if (_type == 0) {
440       setFreezeForAngel(freezeTime, _to, _amount);
441     ShowTestU("Inside", _amount);      
442       balances[poolAddress] = balances[poolAddress] - _amount;
443       balances[_to] = balances[_to] + _amount;
444     }
445 
446     if (_type == 1) {
447       setFreezeForFounding(freezeTime, _to, _amount);
448       balances[poolAddress] = balances[poolAddress] - _amount;
449       balances[_to] = balances[_to] + _amount;
450     }
451 
452     if (_type == 2) {
453       setFreezeForPEInvestors(freezeTime, _to, _amount);
454       balances[poolAddress] = balances[poolAddress] - _amount;
455       balances[_to] = balances[_to] + _amount;
456     }
457   }
458 
459   function transferTokens(address _from, address _to, uint256 _amount, uint256 freezeTime, uint256 _type) public onlyOwner {
460     require(balances[_from] >= _amount);
461 
462     Transfer(_from, _to, _amount);
463 
464     if (_type == 3) {
465       setFreezeForCoreTeam(freezeTime, _to, _amount);
466       balances[_from] = balances[_from] - _amount;
467       balances[_to] = balances[_to] + _amount;
468     }
469   }
470 
471   // 0
472   function setFreezeForAngel(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
473     ico_finish = _time;
474     
475     if (angel_tokens[_address].firstPhaseTime != ico_finish) {
476       angel_addresses.push(_address);
477     }
478 
479     // when ICO Finish
480     firstPhaseTime = ico_finish;
481     // when 3 months Finish
482     secondPhaseTime = ico_finish + 90 days;
483     // when 6 months Finish
484     thirdPhaseTime = ico_finish + 180 days;
485     // when 9 months Finish
486     fourPhaseTime = ico_finish + 270 days;
487 
488     countTokens = angel_tokens[_address].countTokens + _tokens;
489 
490     firstPart = _tokens.mul(25).div(100);
491 
492     // 25%
493     firstPhaseCount = angel_tokens[_address].firstPhaseCount + firstPart;
494     // 25%
495     secondPhaseCount = angel_tokens[_address].secondPhaseCount + firstPart;
496     // 25%
497     thirdPhaseCount = angel_tokens[_address].thirdPhaseCount + firstPart;
498     // 25%
499     fourPhaseCount = angel_tokens[_address].fourPhaseCount + firstPart;
500 
501     ShowTestU("setFreezeForAngel: firstPhaseCount", firstPhaseCount);
502 
503     FreezePhases memory freezePhase = FreezePhases({firstPhaseTime: firstPhaseTime, secondPhaseTime: secondPhaseTime, thirdPhaseTime: thirdPhaseTime, fourPhaseTime: fourPhaseTime, countTokens: countTokens, firstPhaseCount: firstPhaseCount, secondPhaseCount: secondPhaseCount, thirdPhaseCount: thirdPhaseCount, fourPhaseCount: fourPhaseCount});
504     
505     angel_tokens[_address] = freezePhase;
506 
507     ShowTestU("setFreezeForAngel: angel_tokens[_address].firstPhaseCount", angel_tokens[_address].firstPhaseCount);
508   }
509   // 1
510   function setFreezeForFounding(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
511     ico_finish = _time;
512 
513     if (founding_tokens[_address].firstPhaseTime != ico_finish) {
514       founding_addresses.push(_address);
515     }
516 
517     // when ICO Finish
518     firstPhaseTime = ico_finish;
519     // when 3 months Finish
520     secondPhaseTime = ico_finish + 180 days;
521     // when 6 months Finish
522     thirdPhaseTime = ico_finish + 360 days;
523     // when 9 months Finish
524     fourPhaseTime = ico_finish + 540 days;
525 
526     countTokens = founding_tokens[_address].countTokens + _tokens;
527 
528     firstPart = _tokens.mul(20).div(100);
529     secondPart = _tokens.mul(30).div(100);
530 
531     // 20%
532     firstPhaseCount = founding_tokens[_address].firstPhaseCount + firstPart;
533     // 20%
534     secondPhaseCount = founding_tokens[_address].secondPhaseCount + firstPart;
535     // 30%
536     thirdPhaseCount = founding_tokens[_address].thirdPhaseCount + secondPart;
537     // 30%
538     fourPhaseCount = founding_tokens[_address].fourPhaseCount + secondPart;
539 
540     FreezePhases memory freezePhase = FreezePhases(firstPhaseTime, secondPhaseTime, thirdPhaseTime, fourPhaseTime, countTokens, firstPhaseCount, secondPhaseCount, thirdPhaseCount, fourPhaseCount);
541     
542     angel_tokens[_address] = freezePhase;
543 
544   }
545   // 2
546   function setFreezeForPEInvestors(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
547     ico_finish = _time;
548 
549     if (pe_investors_tokens[_address].firstPhaseTime != ico_finish) {
550       pe_investors_addresses.push(_address);
551     }
552 
553     // when ICO Finish
554     firstPhaseTime = ico_finish;
555     // when 3 months Finish
556     secondPhaseTime = ico_finish + 180 days;
557     // when 6 months Finish
558     thirdPhaseTime = ico_finish + 360 days;
559     // when 9 months Finish
560     fourPhaseTime = ico_finish + 540 days;
561 
562     countTokens = pe_investors_tokens[_address].countTokens + _tokens;
563 
564     firstPart = _tokens.mul(20).div(100);
565     secondPart = _tokens.mul(30).div(100);
566 
567     // 20%
568     firstPhaseCount = pe_investors_tokens[_address].firstPhaseCount + firstPart;
569     // 20%
570     secondPhaseCount = pe_investors_tokens[_address].secondPhaseCount + firstPart;
571     // 30%
572     thirdPhaseCount = pe_investors_tokens[_address].thirdPhaseCount + secondPart;
573     // 30%
574     fourPhaseCount = pe_investors_tokens[_address].fourPhaseCount + secondPart;
575   }
576   // 3
577   function setFreezeForCoreTeam(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
578     ico_finish = _time;
579 
580     if (team_core_tokens[_address].firstPhaseTime != ico_finish) {
581       team_core_addresses.push(_address);
582     }
583 
584     // when ICO Finish
585     firstPhaseTime = ico_finish;
586     // when 6 months Finish
587     secondPhaseTime = ico_finish + 180 days;
588     // when 12 months Finish
589     thirdPhaseTime = ico_finish + 360 days;
590     // when 18 months Finish
591     fourPhaseTime = ico_finish + 540 days;
592 
593     countTokens = team_core_tokens[_address].countTokens + _tokens;
594 
595     firstPart = _tokens.mul(5).div(100);
596     secondPart = _tokens.mul(10).div(100);
597     thirdPart = _tokens.mul(75).div(100);
598 
599     // 5%
600     firstPhaseCount = team_core_tokens[_address].firstPhaseCount + firstPart;
601     // 10%
602     secondPhaseCount = team_core_tokens[_address].secondPhaseCount + secondPart;
603     // 10%
604     thirdPhaseCount = team_core_tokens[_address].thirdPhaseCount + secondPart;
605     // 75%
606     fourPhaseCount = team_core_tokens[_address].fourPhaseCount + thirdPart;
607   }
608 
609   function withdrowTokens(address _address, uint256 _tokens) onlyOwner public {
610     balances[poolAddress] = balances[poolAddress] - _tokens;
611     balances[_address] = balances[_address].add(_tokens);
612   }
613 
614   function getOwnerToken() public constant returns(address) {
615     return owner;
616   }
617 
618   function setFreeze(address _addr) public onlyOwner {
619     forceFreeze[_addr] = true;
620   }
621 
622   function removeFreeze(address _addr) public onlyOwner {
623     forceFreeze[_addr] = false;
624   }
625 
626   function moveUnsold(address _addr) public onlyOwner {
627     require(!unsoldMove);
628     
629     balances[_addr] = balances[_addr].add(balances[poolAddress]);
630 
631     unsoldMove = true;
632   }
633 
634   function newTransferManualTokensnewTransfer(address _from, address _to, uint256 _value) onlyOwner returns (bool) {
635     return newTransfer(_from, _to, _value);
636   }
637 
638   function approve(address _spender, uint256 _value) returns (bool) {
639  
640     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
641  
642     allowed[msg.sender][_spender] = _value;
643     Approval(msg.sender, _spender, _value);
644     return true;
645   }
646  
647   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
648     return allowed[_owner][_spender];
649   }
650  
651 }
652 contract SingleTokenCoin is MintableToken {
653     
654     string public constant name = "ADD Token";
655     
656     string public constant symbol = "ADD";
657     
658     uint32 public constant decimals = 18;
659     
660 }