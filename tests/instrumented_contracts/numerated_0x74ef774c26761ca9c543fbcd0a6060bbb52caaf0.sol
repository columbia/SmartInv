1 pragma solidity ^0.4.24;
2 
3 contract LNEvents 
4 {
5     event onBuyKey
6     (
7         uint256 indexed rID,
8         uint256 indexed pID,
9         address pAddr,
10         uint256 cnt,
11         uint256 ts
12     );
13     event onBuyNum
14     (
15         uint256 indexed rID,
16         uint256 indexed playerID,
17         uint256 num1,
18         uint256 num2,
19         uint256 ts
20     );
21     event onEndRound 
22     (
23         uint256 indexed rID,
24         uint256 luck_num,
25         uint256 luck_cnt,
26         uint256 luck_win,
27         uint256 ts
28     );
29     event onWin
30     (
31         uint256 indexed pID,
32         uint256 indexed rID,
33         uint256 luck_cnt,
34         uint256 luck_win
35     );
36     event onWithdraw
37     (
38         uint256 indexed pID,
39         uint256 amount,
40         uint256 ts
41     );
42 }
43 
44 contract LuckyNum is LNEvents {
45     using SafeMath for *;
46     using NameFilter for *;
47 
48     address public ga_CEO;
49     
50     uint256 public gu_RID;
51     uint256 public gu_LastPID;   
52     uint256 constant public gu_price = 25000000000000000;
53     uint256 public gu_keys ;
54     uint256 public gu_ppt  ;
55 
56     mapping (address => uint256) public gd_Addr2PID;
57     mapping (bytes32 => uint256) public gd_Name2PID;
58     mapping (uint256 => SAMdatasets.Player) public gd_Player;
59     mapping (uint256 => mapping (uint256 => SAMdatasets.PlayerRounds)) public gd_PlyrRnd;
60     mapping (uint256 => SAMdatasets.Round) public gd_RndData;
61     
62     constructor()
63         public
64     {
65         ga_CEO = msg.sender;
66 
67         gu_RID = 1;
68         SetRndTime();
69 	}
70 
71     modifier IsPlayer() {
72         address addr = msg.sender;
73         uint256 codeLen;
74         
75         assembly {codeLen := extcodesize(addr)}
76         require(codeLen == 0, "Not Human");
77         _;
78     }
79 
80     modifier CheckEthRange(uint256 eth) {
81         require(eth >= gu_price && eth <= 250000000000000000000, 
82                 "Out of Range");
83         _;    
84     }
85     
86     function CalcKeys(uint256 eth) 
87         internal
88         pure
89         returns(uint256)
90     {
91         return (eth/gu_price);
92     }
93     
94     function CalcEth(uint256 keys) 
95         internal
96         pure
97         returns(uint256)  
98     {
99         return (keys*gu_price) ;
100     }
101 
102     function Kill()
103         public
104     {
105         require(ga_CEO == msg.sender, "only ga_CEO can modify ga_CEO");
106         selfdestruct(ga_CEO);
107     }
108 
109     function ModCEO(address newCEO) 
110         IsPlayer() 
111         public
112     {
113         require(address(0) != newCEO, "CEO Can not be 0");
114         require(ga_CEO == msg.sender, "only ga_CEO can modify ga_CEO");
115         ga_CEO = newCEO;
116     }
117     
118     function GetAffID(uint256 pID, string affName, uint256 affID, address affAddr)
119         internal
120         returns(uint256)
121     {
122         uint256 aID = 0;
123         bytes32 name = affName.nameFilter() ;
124         if (name != '' && name != gd_Player[pID].name)
125         {
126             aID = gd_Name2PID[name];
127         } 
128         if (aID == 0 && affID != 0 && affID != pID){
129             aID = affID;
130         } 
131         if (aID == 0 && affAddr != address(0) && affAddr != msg.sender)
132         {
133             aID = gd_Addr2PID[affAddr];
134         } 
135         if (aID == 0)
136         {
137             aID = gd_Player[pID].laff;
138         }
139         if (aID != 0 && gd_Player[pID].laff != aID) 
140         {
141             gd_Player[pID].laff = aID;
142         }
143         return (aID) ;
144     }
145 
146     function OnBuyKey(string affName, uint256 affID, address affAddr)
147         IsPlayer()
148         CheckEthRange(msg.value)
149         public
150         payable
151     {
152         uint256 pID = GetPIDXAddr(msg.sender);
153         uint256 aID = GetAffID(pID, affName, affID, affAddr);
154         BuyKey(pID, aID, msg.value);
155     }
156 
157     function OnBuyNum(uint256 num1, uint256 num2)
158         IsPlayer()
159         public
160     {
161         uint256 pID = GetPIDXAddr(msg.sender);
162         BuyNum(pID, num1, num2);
163     }
164 
165     function OnEndRound()
166         IsPlayer()
167         public
168     {
169         require(ga_CEO == msg.sender, "only ga_CEO can modify ga_CEO");
170         EndRound();
171     }
172 
173     function GetAKWin(uint256 pID)
174         private
175         view
176         returns(uint256)
177     {
178         return ((gu_ppt.mul(gd_Player[pID].keys)/(1000000000000000000)).sub(gd_Player[pID].mask)) ;
179     
180     }
181 
182     function GetRKWin(uint256 pID, uint256 lrnd)
183         private
184         view
185         returns(uint256)
186     {
187         return ( (gd_RndData[lrnd].kppt.mul(gd_PlyrRnd[pID][lrnd].keys)/ (1000000000000000000)).sub(gd_PlyrRnd[pID][lrnd].mask) ) ;
188     }
189 
190     function GetRNWin(uint256 pID, uint256 lrnd)
191         private
192         view
193         returns(uint256)
194     {
195         if (gd_RndData[lrnd].nppt > 0)
196         {
197             uint256 cnt = gd_PlyrRnd[pID][lrnd].d_num[gd_RndData[lrnd].luckNum];
198             if (cnt > 0)
199             {
200                 return gd_RndData[lrnd].nppt.mul(cnt);
201             }
202         }
203         return 0;
204     }
205     
206     function GetUnmaskGen(uint256 pID, uint256 lrnd)
207         private
208         view
209         returns(uint256)
210     {
211         uint256 a_kwin = GetAKWin(pID);
212         uint256 r_kwin = GetRKWin(pID, lrnd) ;
213         return a_kwin.add(r_kwin);
214     }
215     function GetUnmaskWin(uint256 pID, uint256 lrnd)
216         private
217         view
218         returns(uint256)
219     {
220         return GetRNWin(pID, lrnd) ;
221     }
222 
223     function UpdateVault(uint256 pID, uint256 lrnd)
224         private 
225     {
226         uint256 a_kwin = GetAKWin(pID);
227         uint256 r_kwin = GetRKWin(pID, lrnd) ;
228         uint256 r_nwin = GetRNWin(pID, lrnd) ;
229         gd_Player[pID].gen = a_kwin.add(r_kwin).add(gd_Player[pID].gen);
230         if (r_nwin > 0)
231         {
232             gd_Player[pID].win = r_nwin.add(gd_Player[pID].win);
233             emit LNEvents.onWin(pID, lrnd, gd_PlyrRnd[pID][lrnd].d_num[gd_RndData[lrnd].luckNum], r_nwin);
234         }
235         if (a_kwin > 0)
236         {
237             gd_Player[pID].mask = a_kwin.add(gd_Player[pID].mask) ;
238         }
239         if (r_kwin > 0)
240         {
241             gd_PlyrRnd[pID][lrnd].win = r_kwin.add(gd_PlyrRnd[pID][lrnd].win) ;
242             gd_PlyrRnd[pID][lrnd].mask = r_kwin.add(gd_PlyrRnd[pID][lrnd].mask);
243         }
244         if(lrnd != gu_RID){
245             gd_Player[pID].lrnd = gu_RID;
246         }
247     }
248 
249     function Withdraw()
250         IsPlayer()
251         public
252     {
253         uint256 pID = gd_Addr2PID[msg.sender];
254         
255         UpdateVault(pID, gd_Player[pID].lrnd);
256         
257         uint256 balance = gd_Player[pID].win.add(gd_Player[pID].gen).add(gd_Player[pID].aff_gen) ;
258         if (balance > 0)
259         {
260             gd_Player[pID].addr.transfer(balance);
261             gd_Player[pID].gen = 0;
262             gd_Player[pID].win = 0;
263             gd_Player[pID].aff_gen = 0;
264             emit LNEvents.onWithdraw(pID, balance, now);
265         }
266     }
267 
268     function GetKeyPrice()
269         public
270         pure
271         returns(uint256)
272     {  
273         return gu_price;
274     }
275     
276     function GetLeftTime()
277         public
278         view
279         returns(uint256)
280     {
281         if (now < gd_RndData[gu_RID].end)
282         {
283             return( (gd_RndData[gu_RID].end).sub(now) );
284         }
285         return(0);
286     }
287 
288     function GetPlayerNumCnt(address addr, uint256 num)
289         public
290         view
291         returns(uint256)
292     {
293         if (addr == address(0))
294         {
295             addr == msg.sender;
296         }
297         uint256 rID = gu_RID;
298         uint256 pID = gd_Addr2PID[addr];
299         return ( gd_PlyrRnd[pID][rID].d_num[num] );
300     }
301 
302     function GetPlayerNumCnt(uint256 num)
303         public
304         view
305         returns(uint256)
306     {
307         uint256 rID = gu_RID;
308         return ( gd_RndData[rID].d_num[num] );
309     }
310     
311     function TransAllDict2Num(uint256 s, uint256 e)
312         internal
313         view
314         returns (uint256)
315     {   
316         uint256 rID = gu_RID;
317         uint256 num = 0;
318         for(uint256 i = s ; i <= e ; i ++)
319         {
320             if (gd_RndData[rID].d_num[i] > 30)
321             {
322                 num = num.add(31 << ((i-s)*5));
323             }
324             else if(gd_RndData[rID].d_num[i] > 0)
325             {
326                 num = num.add(gd_RndData[rID].d_num[i] << ((i-s)*5));
327             }
328         }
329         return (num);
330     }
331 
332     function GetCurRoundInfo()
333         public
334         view
335         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
336     {
337         uint256 rID = gu_RID;
338         return
339         (
340             rID,
341             gu_keys,
342             gd_RndData[rID].state,
343             gd_RndData[rID].keys,
344             gd_RndData[rID].pot,
345             gd_RndData[rID].ncnt,
346             ((gd_RndData[rID-1].nppt) << 8)+gd_RndData[rID-1].luckNum,
347             TransAllDict2Num(1, 50),
348             TransAllDict2Num(51, 100)
349         );
350     }
351 
352     function GenOneHis(uint256 rID)
353         internal
354         view
355         returns(uint256)
356     {
357         uint256 nppt = gd_RndData[rID].nppt;
358         uint256 luckNum = gd_RndData[rID].luckNum;
359         uint256 luckCnt = gd_RndData[rID].d_num[luckNum];
360         return ((nppt << 64)+(rID << 40)+(luckNum<<32)+luckCnt);
361     }
362 
363     function LuckNumHis()
364         public
365         view
366         returns(uint256, uint256, uint256, uint256, uint256, 
367         uint256, uint256, uint256, uint256, uint256)
368     {
369         return 
370         (
371             gu_RID > 1? GenOneHis(gu_RID-1) : 0 ,
372             gu_RID > 2? GenOneHis(gu_RID-2) : 0 ,
373             gu_RID > 3? GenOneHis(gu_RID-3) : 0 ,
374             gu_RID > 4? GenOneHis(gu_RID-4) : 0 ,
375             gu_RID > 5? GenOneHis(gu_RID-5) : 0 ,
376             gu_RID > 6? GenOneHis(gu_RID-6) : 0 ,
377             gu_RID > 7? GenOneHis(gu_RID-7) : 0 ,
378             gu_RID > 8? GenOneHis(gu_RID-8) : 0 ,
379             gu_RID > 9? GenOneHis(gu_RID-9) : 0 ,
380             gu_RID > 10? GenOneHis(gu_RID-10) : 0  
381         ) ;
382     }
383 
384     function TransUserDict2Num(uint256 pID, uint256 s, uint256 e)
385         internal
386         view
387         returns (uint256)
388     {   
389         uint256 num = 0;
390         for(uint256 i = s ; i <= e ; i ++)
391         {
392             if (gd_PlyrRnd[pID][gu_RID].d_num[i] > 30)
393             {
394                 num = num.add(31 << ((i-s)*5));
395             }
396             else if(gd_PlyrRnd[pID][gu_RID].d_num[i] > 0)
397             {
398                 num = num.add(gd_PlyrRnd[pID][gu_RID].d_num[i] << ((i-s)*5));
399             }
400         }
401         return (num);
402     }
403 
404     function GetPlayerInfoXAddr(address addr)
405         public 
406         view 
407         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, 
408                 uint256, uint256, uint256, uint256)
409     {
410         if (addr == address(0))
411         {
412             addr == msg.sender;
413         }
414         uint256 pID = gd_Addr2PID[addr];
415         return
416         (
417             pID,
418             gd_Player[pID].name,
419             gd_Player[pID].gen.add(GetUnmaskGen(pID, gd_Player[pID].lrnd)),
420             gd_Player[pID].win.add(GetUnmaskWin(pID, gd_Player[pID].lrnd)),
421             (gd_Player[pID].keys << 32) + gd_Player[pID].used_keys,
422             gd_PlyrRnd[pID][gu_RID].keys,
423             gd_PlyrRnd[pID][gu_RID].ncnt,
424             gd_Player[pID].aff_gen,
425             gd_PlyrRnd[pID][gu_RID].win.add(GetRKWin(pID, gu_RID)),
426             TransUserDict2Num(pID, 1, 50),
427             TransUserDict2Num(pID, 51, 100)
428         );
429     }
430 
431     function GetPlayerBalance(address addr)
432         public
433         view
434         returns (uint256)
435     {
436         if (addr == address(0))
437         {
438             addr == msg.sender;
439         }
440         return (addr.balance);
441     }
442 
443     function BuyKey(uint256 pID, uint256 affID, uint256 eth)
444         private
445     {
446         UpdateVault(pID, gd_Player[pID].lrnd);
447         if (gd_RndData[gu_RID].state == 0)
448         {
449             uint256 keys = CalcKeys(eth); 
450             uint256 gasfee = eth.sub(keys.mul(gu_price));
451             if (gasfee > 0)
452             {
453                 gd_Player[pID].win = gd_Player[pID].win.add(gasfee);
454             }
455             gasfee = eth / 20;
456             ga_CEO.transfer(gasfee);
457             uint256 gen2 = eth/4 ;
458             uint256 pot = eth.sub(gasfee).sub(gen2);
459             if (affID != 0)
460             {
461                 uint256 affFee = eth / 20 ;
462                 gd_Player[affID].aff_gen = affFee.add(gd_Player[affID].aff_gen);
463                 gd_PlyrRnd[affID][gu_RID].win = affFee.add(gd_PlyrRnd[affID][gu_RID].win) ;
464                 pot = pot.sub(affFee);
465             }
466 
467             gd_Player[pID].keys = keys.add(gd_Player[pID].keys);
468             gd_Player[pID].eth = eth.add(gd_Player[pID].eth) ;
469             gd_Player[pID].mask = ((gu_ppt.mul(keys))/(1000000000000000000)).add(gd_Player[pID].mask);
470             gu_keys = keys.add(gu_keys); 
471 
472             gd_PlyrRnd[pID][gu_RID].keys = keys.add(gd_PlyrRnd[pID][gu_RID].keys);
473             gd_PlyrRnd[pID][gu_RID].eth = eth.add(gd_PlyrRnd[pID][gu_RID].eth);
474             gd_RndData[gu_RID].eth = eth.add(gd_RndData[gu_RID].eth);
475             gd_RndData[gu_RID].keys = keys.add(gd_RndData[gu_RID].keys);
476             UpdateMask(gu_RID, pID, gen2, keys);
477             gd_RndData[gu_RID].pot = pot.add(gd_RndData[gu_RID].pot);
478             emit LNEvents.onBuyKey(gu_RID, pID, msg.sender, keys, now);
479         } 
480         else 
481         {   
482             gd_Player[pID].win = gd_Player[pID].win.add(eth);
483         }
484     }
485 
486     function BuyNum(uint256 pID, uint256 num1, uint256 num2)
487         private
488     {
489         UpdateVault(pID, gd_Player[pID].lrnd);
490         if (gd_RndData[gu_RID].state == 0)
491         {
492             uint256 i = 0;
493             uint256 cnt = 0;
494             uint256 t_cnt = 0;
495             for(i = 1 ; i <= 50 && num1 > 0; i ++)
496             {
497                 cnt = (num1 & 0x1F) ;
498                 if (cnt > 0)
499                 {
500                     t_cnt = cnt.add(t_cnt);
501                     gd_PlyrRnd[pID][gu_RID].d_num[i] = cnt.add(gd_PlyrRnd[pID][gu_RID].d_num[i]);
502                     gd_RndData[gu_RID].d_num[i] = cnt.add(gd_RndData[gu_RID].d_num[i]);
503                 }
504                 num1 = (num1 >> 5) ;
505             }
506             for(i = 51 ; i <= 100 && num2 > 0; i ++)
507             {
508                 cnt = (num2 & 0x1F) ;
509                 if (cnt > 0)
510                 {
511                     t_cnt = cnt.add(t_cnt);
512                     gd_PlyrRnd[pID][gu_RID].d_num[i] = cnt.add(gd_PlyrRnd[pID][gu_RID].d_num[i]);
513                     gd_RndData[gu_RID].d_num[i] = cnt.add(gd_RndData[gu_RID].d_num[i]);
514                 }
515                 num2 = (num2 >> 5) ;
516             }
517             require (t_cnt <= gd_Player[pID].keys, "Lack Of Keys");
518 
519             gd_PlyrRnd[pID][gu_RID].ncnt = t_cnt.add(gd_PlyrRnd[pID][gu_RID].ncnt);
520             gd_RndData[gu_RID].ncnt = t_cnt.add(gd_RndData[gu_RID].ncnt);
521 
522             gu_keys = gu_keys.sub(t_cnt);
523             gd_Player[pID].keys = gd_Player[pID].keys.sub(t_cnt);
524             gd_Player[pID].used_keys = gd_Player[pID].used_keys.add(t_cnt);
525             gd_Player[pID].mask = gu_ppt.mul(gd_Player[pID].keys)/1000000000000000000;
526             if (gd_Player[pID].keys < gd_PlyrRnd[pID][gu_RID].keys){
527                 cnt = gd_PlyrRnd[pID][gu_RID].keys-gd_Player[pID].keys;
528                 gd_PlyrRnd[pID][gu_RID].keys = gd_Player[pID].keys;
529                 gd_PlyrRnd[pID][gu_RID].mask = gd_RndData[gu_RID].kppt.mul(gd_PlyrRnd[pID][gu_RID].keys)/1000000000000000000;
530                 gd_RndData[gu_RID].keys = gd_RndData[gu_RID].keys.sub(cnt);
531             }
532             emit LNEvents.onBuyNum(gu_RID, pID, num1, num2, now);
533         }
534     }
535 
536     function updateAllMask(uint256 pID, uint256 gen, uint256 keys)
537         internal
538         returns(uint256)
539     {
540         uint256 ppt = gen.mul(1000000000000000000)/gu_keys;
541         gu_ppt = ppt.add(gu_ppt) ; 
542         uint256 pearn = ppt.mul(keys)/(1000000000000000000) ;
543         gd_Player[pID].mask = ((gu_ppt.mul(keys))/(1000000000000000000)).sub(pearn).add(gd_Player[pID].mask);
544         return (gen.sub((ppt.mul(gu_keys))/(1000000000000000000)));
545     }
546     
547     function UpdateMask(uint256 rID, uint256 pID, uint256 gen, uint256 keys)
548         internal
549         returns(uint256)
550     {
551         uint256 ppt = gen.mul(1000000000000000000)/gd_RndData[rID].keys;
552         gd_RndData[rID].kppt = ppt.add(gd_RndData[rID].kppt);
553         uint256 pearn = ppt.mul(keys)/(1000000000000000000) ;
554         gd_PlyrRnd[pID][rID].mask = (((gd_RndData[rID].kppt.mul(keys))/(1000000000000000000)).sub(pearn)).add(gd_PlyrRnd[pID][rID].mask);
555         return (gen.sub((ppt.mul(gd_RndData[rID].keys))/(1000000000000000000)));
556     }
557     
558     function GetEthXKey(uint256 keys)
559         public
560         pure
561         returns(uint256)
562     {
563         return ( CalcEth(keys) );
564     }
565 
566     function GetPIDXAddr(address addr)
567         private
568         returns (uint256)
569     {
570         uint256 pID = gd_Addr2PID[addr];
571         if ( pID == 0) 
572         {
573             gu_LastPID++;
574             gd_Addr2PID[addr] = gu_LastPID;
575             gd_Player[gu_LastPID].addr = addr;
576             uint256 seed = uint256(keccak256(abi.encodePacked(
577                 (block.timestamp).add
578                 (block.difficulty).add
579                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
580                 (block.gaslimit).add
581                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
582                 (block.number)
583             )));
584             gd_Player[gu_LastPID].name = seed.GenName(gu_LastPID);
585             gd_Name2PID[gd_Player[gu_LastPID].name] = gu_LastPID;
586 
587             return (gu_LastPID);
588         } else {
589             return (pID);
590         }
591     }
592 
593     function SetRndTime()
594         private
595     {
596         gd_RndData[gu_RID].strt = now.sub(now%7200);
597         gd_RndData[gu_RID].end = gd_RndData[gu_RID].strt+7200;
598         while (gd_RndData[gu_RID].end < now+1800)
599         {
600             gd_RndData[gu_RID].end += 7200;
601         }
602         
603     }
604     
605     function EndRound()
606         private
607     {
608         uint256 seed = uint256(keccak256(abi.encodePacked(
609             
610             (block.timestamp).add
611             (block.difficulty).add
612             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
613             (block.gaslimit).add
614             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
615             (block.number)
616             
617         )));
618         uint256 luckNum = (seed%100)+1;
619         gd_RndData[gu_RID].luckNum = luckNum;
620         if (gd_RndData[gu_RID].d_num[luckNum] > 0)
621         {
622             uint256 gen = 0; 
623             if (gu_keys > 0)
624             {
625                 gen = gd_RndData[gu_RID].pot/20;
626                 gu_ppt = gu_ppt.add(gen.mul(1000000000000000000)/gu_keys) ;
627             }
628 
629             uint256 pot = gd_RndData[gu_RID].pot.mul(75)/100;
630             gd_RndData[gu_RID+1].pot = gd_RndData[gu_RID].pot.sub(pot).sub(gen);
631 
632             uint256 gasfee = pot.mul(3)/100;
633             ga_CEO.transfer(gasfee);
634             pot = pot.sub(gasfee);
635             gd_RndData[gu_RID].nppt = pot/gd_RndData[gu_RID].d_num[luckNum];
636             
637             emit LNEvents.onEndRound(gu_RID, luckNum, 
638                                     gd_RndData[gu_RID].d_num[luckNum], 
639                                     gd_RndData[gu_RID].nppt, now);
640         }else{
641             gd_RndData[gu_RID+1].pot = gd_RndData[gu_RID].pot;
642         }
643 
644         gu_RID = gu_RID+1;
645         SetRndTime();
646     }
647 }
648 
649 library SAMdatasets {
650     struct Player {
651         address addr; 
652         bytes32 name;
653         uint256 keys;
654         uint256 used_keys;
655         uint256 mask;
656         uint256 eth ;
657         uint256 aff_gen;
658         uint256 gen ;
659         uint256 win;
660         uint256 laff;
661         uint256 lrnd;
662     }
663     struct PlayerRounds {
664         uint256 eth;
665         uint256 win;
666         uint256 keys;
667         uint256 mask;
668         uint256 ncnt;
669         mapping (uint256 => uint256) d_num ;
670     }
671 
672     struct Round {
673         uint256 state;
674         uint256 strt;
675         uint256 end; 
676         uint256 keys;
677         uint256 eth;
678         uint256 pot;
679         uint256 ncnt;
680         uint256 kppt;
681         uint256 luckNum;
682         mapping (uint256 => uint256) d_num ;
683         uint256 nppt;
684     }
685 }
686 
687 library NameFilter {
688     function nameFilter(string _input)
689         internal
690         pure
691         returns(bytes32)
692     {
693         bytes memory _temp = bytes(_input);
694         uint256 _length = _temp.length;
695         
696         require (_length <= 32 && _length > 0, "Invalid Length");
697         if (_temp[0] == 0x30)
698         {
699             require(_temp[1] != 0x78, "CAN NOT Start With 0x");
700             require(_temp[1] != 0x58, "CAN NOT Start With 0X");
701         }
702         
703         bool _hasNonNumber;
704         
705         for (uint256 i = 0; i < _length; i++)
706         {
707             if (_temp[i] > 0x60 && _temp[i] < 0x7b)
708             {
709                 _temp[i] = byte(uint(_temp[i]) - 32);
710                 if (_hasNonNumber == false)
711                 {
712                     _hasNonNumber = true;
713                 }
714             } else {
715                 require
716                 (
717                     (_temp[i] > 0x40 && _temp[i] < 0x5b) ||
718                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
719                     "Include Illegal Characters!"
720                 );                
721                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
722                 {
723                     _hasNonNumber = true; 
724                 }  
725             }
726         }
727         
728         require(_hasNonNumber == true, "All Numbers Not Allowed");
729         
730         bytes32 _ret;
731         assembly {
732             _ret := mload(add(_temp, 32))
733         }
734         return (_ret);
735     }
736     
737     function GenName(uint256 seed, uint256 lastPID)
738         internal
739         pure
740         returns(bytes32)
741     {
742         bytes memory name = new bytes(12);
743         uint256 lID = lastPID; 
744         name[11] = (byte(seed%26+0x41));
745         seed /=100;
746         name[10] = (byte(seed%26+0x41));
747         seed /=100;
748         for(uint256 l = 10 ; l > 0 ; l --)
749         {
750             if (lID > 0)
751             {
752                 name[l-1] = (byte(lID%10+0x30));
753                 lID /= 10;
754             }
755             else{
756                 name[l-1] = (byte(seed%26+0x41));
757                 seed /=100;
758             }
759         }
760         bytes32 _ret;
761         assembly {
762             _ret := mload(add(name, 32))
763         }
764         return (_ret);
765     }
766 }
767 
768 library SafeMath {
769     function mul(uint256 a, uint256 b) 
770         internal 
771         pure 
772         returns (uint256 c) 
773     {
774         if (a == 0) 
775         {
776             return 0;
777         }
778         c = a * b;
779         require(c / a == b, "Mul Failed");
780         return c;
781     }
782     function sub(uint256 a, uint256 b)
783         internal
784         pure
785         returns (uint256) 
786     {
787         require(b <= a, "Sub Failed");
788         return a - b;
789     }
790 
791     function add(uint256 a, uint256 b)
792         internal
793         pure
794         returns (uint256 c) 
795     {
796         c = a + b;
797         require(c >= a, "Add Failed");
798         return c;
799     }
800 }