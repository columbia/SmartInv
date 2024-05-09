1 pragma solidity ^0.4.24;
2 
3 /**
4  ZOMO 5D v2.6.8
5 
6  * This product is protected under license.  Any unauthorized copy, modification, or use is prohibited.
7 
8 **/
9 
10 
11 contract Z5Devents {
12 
13 
14     
15     event onNewName
16     (
17         uint256 indexed playerID,
18         address indexed playerAddress,
19         bytes32 indexed playerName,
20         bool isNewPlayer,
21         uint256 affiliateID,
22         address affiliateAddress,
23         bytes32 affiliateName,
24         uint256 amountPaid,
25         uint256 timeStamp
26     );
27     
28 
29     event onEndTx
30     (
31        
32         bytes32 playerName,
33         address playerAddress,
34         uint256 ethIn,
35         uint256 keysBought,
36         address winnerAddr,
37         bytes32 winnerName,
38         uint256 amountWon,
39         uint256 newPot,
40         uint256 genAmount,
41         uint256 potAmount,
42         uint256 airDropPot,
43 		uint256 currentround
44     );
45     
46 	
47     event onWithdraw
48     (
49         uint256 indexed playerID,
50         address playerAddress,
51         bytes32 playerName,
52         uint256 ethOut,
53         uint256 timeStamp
54     );
55     
56 
57     event onWithdrawAndDistribute
58     (
59         address playerAddress,
60         bytes32 playerName,
61         uint256 ethOut,
62         address winnerAddr,
63         bytes32 winnerName,
64         uint256 amountWon,
65         uint256 newPot,
66         uint256 genAmount
67     );
68     
69 
70 	
71     event onBuyAndDistribute
72     (
73         address playerAddress,
74         bytes32 playerName,
75         uint256 ethIn,
76         address winnerAddr,
77         bytes32 winnerName,
78         uint256 amountWon,
79         uint256 newPot,
80         uint256 genAmount
81     );
82 
83     event onReLoadAndDistribute
84     (
85         address playerAddress,
86         bytes32 playerName,
87         address winnerAddr,
88         bytes32 winnerName,
89         uint256 amountWon,
90         uint256 newPot,
91         uint256 genAmount
92     );
93     
94 
95     event onAffiliatePayout
96     (
97         uint256 indexed affiliateID,
98         address affiliateAddress,
99         bytes32 affiliateName,
100         uint256 indexed roundID,
101         uint256 indexed buyerID,
102         uint256 amount,
103         uint256 timeStamp
104     );
105     
106 
107 
108 }
109 
110 
111 
112 
113 
114 contract ZoMo5D is Z5Devents 
115 {
116     using SafeMath for *;
117     using NameCheck for string;
118     using Z5DKeyCount for uint256;
119 	
120 
121     string constant public name = "ZoMo5D";
122     string constant public symbol = "Z5D";
123 
124    
125     uint256 constant private rndInit_ = 24 hours;
126     uint256 constant private rndInc_ = 30 seconds;              
127     uint256 constant private rndMax_ = 24 hours;                
128 	uint256 constant private betPre_ = 5 days;     
129 
130 
131 	uint256 public BetTime;
132 
133 
134 	uint256 public airDropPot_;            
135 	uint256 public comm; 
136 	uint256 public lott;
137 	
138     uint256 public rID_;    
139 
140 	
141 
142 	
143     mapping (address => uint256) public pIDxAddr_;         
144     mapping (bytes32 => uint256) public pIDxName_;         
145     mapping (uint256 => Z5Ddatasets.Player) public plyr_;   
146     mapping (uint256 => mapping (uint256 => Z5Ddatasets.PlayerRounds)) public plyrRnds_;    
147     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; 
148 	
149 	uint256 public pID_;
150 	
151 	mapping (address => bool) internal team;
152 
153 
154     mapping (uint256 => Z5Ddatasets.Round) public round_;  
155     mapping (uint256 => uint256) public rndEth_;      
156 	mapping (uint256 => Z5Ddatasets.lotty) public Rndlotty;
157 
158 	
159 	uint256 public lottrnd;
160 	
161     uint256 public fees_;       
162     uint256 public potSplit_;     
163 
164 	
165 	ZoMo5DInterface private Z5DToken = ZoMo5DInterface(0x8b4f4872434DB00eB34B9420946534179249d676);
166 	
167 	
168     constructor() public
169     {
170 		
171 		
172         fees_ = 59;  
173      
174         
175         potSplit_ = 25;  
176 		
177 		plyr_[1].addr = 0xEAc1b04cBdd484244fC0dB0A8BEdA6212fFb32b1;
178         plyr_[1].name = "zomo5d";
179         pIDxAddr_[0xEAc1b04cBdd484244fC0dB0A8BEdA6212fFb32b1] = 1;
180         pIDxName_["zomo5d"] = 1;
181         plyrNames_[1]["zomo5d"] = true;
182         pID_++;
183         
184   
185 		
186 		team[msg.sender] =true;
187 		team[0x13856bc546DbDE959F45cC863BbeBd40b5e8cCc2] = true;
188 		team[0xe418De1360a8e64de9468485F439B9174CE265a1] = true;
189 		team[0x654DC353AF41Cc83Ae99Bd7F4d4733f2948adCED] = true;
190         team[0xEAc1b04cBdd484244fC0dB0A8BEdA6212fFb32b1] = true;
191 		team[0x78Ac79844328Ca4d652bCCC5f49ff7C43dC7c25d] = true;
192 
193 		
194     }    
195 	
196 	
197 	modifier onlyowner()
198      {
199          require(team[msg.sender]==true);
200          _;
201      }
202 
203     modifier isActivated() {
204         require(activated_ == true, "not ready"); 
205         _;
206     }
207     
208     
209     modifier NotContract() {
210         address _addr = msg.sender;
211         uint256 _codeLength;
212         
213         assembly {_codeLength := extcodesize(_addr)}
214         require(_codeLength == 0, "contract is not accepted");
215         _;
216     }
217 
218     
219     modifier isWithinLimits(uint256 _eth) {
220         require(_eth >= 1000000000, "not a valid currency");
221         _;    
222     }
223     
224 	
225     function AirDistribute(uint256 _pID,uint256 amount_) onlyowner() public
226 	{
227 		require(amount_<=airDropPot_);
228 		airDropPot_ = airDropPot_.sub(amount_);
229 		plyr_[_pID].win = (plyr_[_pID].win).add(amount_);
230 		
231 	}
232 	
233 	
234 	
235 	
236 	function CommDistribute(uint256 _pID,uint256 amount_) onlyowner() public
237 	{
238 		require(amount_<=comm);
239 		comm = comm.sub(amount_);
240 		plyr_[_pID].win = (plyr_[_pID].win).add(amount_);
241 		
242 	}
243 	
244 	function lottDistribute(uint256 _pID,uint256 amount_,uint256 Lottround) onlyowner() public
245 	{
246 		
247 		require(amount_<=Rndlotty[Lottround].rndlott);
248 		Rndlotty[Lottround].rndlott = (Rndlotty[Lottround].rndlott).sub(amount_);
249 		plyr_[_pID].win = (plyr_[_pID].win).add(amount_);
250 		
251 	}
252 	
253 	
254 	function BetfromZ5D(uint256 amount_) isActivated() public
255 	{
256 		require(amount_>0,"amount_ should greater than 0");
257 		uint256 _pID = pIDxAddr_[msg.sender];
258 		require(_pID>0,"you should regist pid first");
259 		Z5DToken.AuthTransfer(msg.sender,amount_);
260 		plyr_[_pID].token = plyr_[_pID].token.add(amount_);
261 		BetCore(_pID,amount_);		
262 	}
263 	
264 	event BetTransfer(address indexed from, uint256 value, uint256 _round);
265 	
266 	function Betfromvault(uint256 amount_) isActivated() public
267 	{
268 	    
269 		require(amount_>0,"amount_ should greater than 0");
270 		uint256 _pID = pIDxAddr_[msg.sender];
271 		require(_pID>0,"you should regist pid first");
272 		updateGenVault(_pID, plyr_[_pID].lrnd);
273 		uint256 TokenAmount = plyr_[_pID].token ;
274 		
275 		require(TokenAmount>amount_,"you don't have enough token");		
276 		BetCore(_pID,amount_);	
277 	}
278 
279 	function BetCore(uint256 _pID,uint256 amount_) private
280 	{
281 		//update last bet 
282 		updateBetVault(_pID);
283 		plyr_[_pID].bet = amount_.add(plyr_[_pID].bet);
284 		plyr_[_pID].token = plyr_[_pID].token.sub(amount_);
285 		plyr_[_pID].lrnd_lott = lottrnd;
286 		
287 		Rndlotty[lottrnd].rndToken = Rndlotty[lottrnd].rndToken.add(amount_);
288 		emit BetTransfer(plyr_[_pID].addr, amount_ , lottrnd);
289 	}
290 	
291 	
292 	function BetEnd() private
293 	{
294 		
295 		if 	(Rndlotty[lottrnd].rndToken > 0)
296 		{
297 			uint256 Betearn=lott.mul(3)/10;
298 		    Rndlotty[lottrnd].rndToken = Betearn/(Rndlotty[lottrnd].rndToken);
299 			Rndlotty[lottrnd].rndlott = lott.mul(5)/10;
300 		    lott = lott.sub(Rndlotty[lottrnd].rndlott).sub(Betearn);
301 			lottrnd++;
302 		}
303 		
304 		if (round_[rID_].pot > 1000000000000000000000)
305 		{
306 			uint256 fornext = (round_[rID_].pot).mul(5)/1000;
307 			round_[rID_].pot = (round_[rID_].pot).sub(fornext);
308 			lott = lott.add(fornext);
309 		}
310 		
311 		
312 	}
313 	
314 	function updateBetVault(uint256 _pID) private
315 	{
316 		uint256 _now = now;
317 		
318 		if (BetTime <_now)
319 		{	
320 			BetTime = _now + betPre_;
321 			BetEnd();	
322 		}
323 		
324 		uint256 lrnPlayed = plyr_[_pID].lrnd_lott;
325 		
326 		
327 		if (lrnPlayed>0 && lrnPlayed<lottrnd)
328 		{
329 		    uint256 lrnWin = (Rndlotty[lrnPlayed].rndToken).mul(plyr_[_pID].bet);
330 		    plyr_[_pID].bet = 0;
331 			plyr_[_pID].win = plyr_[_pID].win.add(lrnWin);
332 			plyr_[_pID].lrnd_lott = 0;
333 		}
334 		
335 	}
336 	
337 	
338 	
339     function() isActivated() NotContract() isWithinLimits(msg.value) public payable
340     {
341        
342         Z5Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
343         uint256 _pID = pIDxAddr_[msg.sender];
344         buyCore(_pID, plyr_[_pID].laff, _eventData_);
345     }
346     
347     
348 	 function GrabName(string _nameString) isActivated() NotContract() public payable
349 	 {
350 		 bytes32 _name = _nameString.nameCheck();
351 		 
352 		 require(msg.value >= 10000000000000000, "not enouhgh for name registration");
353 		 uint256 _pID_name = pIDxName_[_name];
354 		 address  _addr = msg.sender;
355 		 uint256 _pID_add = pIDxAddr_[_addr];
356 		 
357 		 if (_pID_name!=0)
358 		 {
359 			require(plyrNames_[_pID_add][_name] ==true,"name had been registered");
360 		 }
361 		 
362 		 if (_pID_add == 0)
363 		 {
364 			 pID_++;
365 			 pIDxAddr_[_addr] = pID_;
366 
367 			 plyr_[pID_].addr = _addr;
368 			 _pID_add = pID_;
369 
370 		 }
371 
372 		 pIDxName_[_name] = _pID_add;
373 		 plyr_[_pID_add].name = _name;
374 		 plyrNames_[_pID_add][_name] = true;
375 		 Z5DToken.deposit.value(msg.value)();
376 
377 		 
378 		 
379 	 }
380 
381 	 
382     function buyXid(uint256 _affCode) isActivated() NotContract() isWithinLimits(msg.value) public payable
383     {
384         Z5Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
385         
386         uint256 _pID = pIDxAddr_[msg.sender];
387         
388         
389         if (_affCode == 0 || _affCode == _pID)
390         {
391 
392             _affCode = plyr_[_pID].laff;
393        
394         } else if (_affCode != plyr_[_pID].laff) {
395             plyr_[_pID].laff = _affCode;
396         }
397  
398 
399         buyCore(_pID, _affCode, _eventData_);
400     }
401     
402     function buyXaddr(address _affCode) isActivated() NotContract() isWithinLimits(msg.value) public payable
403     {
404 
405         Z5Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
406         
407 
408         uint256 _pID = pIDxAddr_[msg.sender];
409 
410         uint256 _affID;
411         if (_affCode == address(0) || _affCode == msg.sender)
412         {
413 
414             _affID = plyr_[_pID].laff;
415         
416 
417         } else {
418  
419             _affID = pIDxAddr_[_affCode];
420             if (_affID != plyr_[_pID].laff)
421             {
422 
423                 plyr_[_pID].laff = _affID;
424             }
425         }
426         
427 
428         buyCore(_pID, _affID, _eventData_);
429     }
430     
431     function buyXname(bytes32 _affCode) isActivated() NotContract() isWithinLimits(msg.value) public
432         payable
433     {
434         
435         Z5Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
436         
437 
438         uint256 _pID = pIDxAddr_[msg.sender];
439         
440      
441         uint256 _affID;
442 
443         if (_affCode == '' || _affCode == plyr_[_pID].name)
444         {
445 
446             _affID = plyr_[_pID].laff;
447 
448         } else {
449 
450             _affID = pIDxName_[_affCode];
451             
452           
453             if (_affID != plyr_[_pID].laff)
454             {
455         
456                 plyr_[_pID].laff = _affID;
457             }
458         }
459         
460    
461 
462         
463     
464         buyCore(_pID, _affID, _eventData_);
465     }
466     
467    
468    
469    
470     function reLoadXid(uint256 _affCode, uint256 _eth) isActivated() NotContract() isWithinLimits(_eth) public
471     {
472       
473         Z5Ddatasets.EventReturns memory _eventData_;
474         
475        
476         uint256 _pID = pIDxAddr_[msg.sender];
477         
478         
479         if (_affCode == 0 || _affCode == _pID)
480         {
481             
482             _affCode = plyr_[_pID].laff;
483             
484         
485         } else if (_affCode != plyr_[_pID].laff) {
486             
487             plyr_[_pID].laff = _affCode;
488         }
489 
490 
491 
492         reLoadCore(_pID, _affCode, _eth, _eventData_);
493     }
494     
495     function reLoadXaddr(address _affCode, uint256 _eth)
496         isActivated()
497         NotContract()
498         isWithinLimits(_eth)
499         public
500     {
501    
502         Z5Ddatasets.EventReturns memory _eventData_;
503         
504    
505         uint256 _pID = pIDxAddr_[msg.sender];
506         
507       
508         uint256 _affID;
509        
510         if (_affCode == address(0) || _affCode == msg.sender)
511         {
512             
513             _affID = plyr_[_pID].laff;
514         
515          
516         } else {
517            
518             _affID = pIDxAddr_[_affCode];
519             
520             
521             if (_affID != plyr_[_pID].laff)
522             {
523                
524                 plyr_[_pID].laff = _affID;
525             }
526         }
527         
528         
529         
530         reLoadCore(_pID, _affID, _eth, _eventData_);
531     }
532     
533     function reLoadXname(bytes32 _affCode, uint256 _eth) isActivated() NotContract() isWithinLimits(_eth) public
534     {
535        
536         Z5Ddatasets.EventReturns memory _eventData_;
537         
538         
539         uint256 _pID = pIDxAddr_[msg.sender];
540         
541         
542         uint256 _affID;
543         
544         if (_affCode == '' || _affCode == plyr_[_pID].name)
545         {
546            
547             _affID = plyr_[_pID].laff;
548         
549         
550         } else {
551            
552             _affID = pIDxName_[_affCode];
553             
554             
555             if (_affID != plyr_[_pID].laff)
556             {
557               
558                 plyr_[_pID].laff = _affID;
559             }
560         }
561         
562 
563         
564 
565         reLoadCore(_pID, _affID, _eth, _eventData_);
566     }
567 
568    
569     function withdraw() isActivated() NotContract() public
570     {
571  
572         uint256 _rID = rID_;
573 
574         uint256 _now = now;
575         
576 
577 		
578         uint256 _pID = pIDxAddr_[msg.sender];
579         
580 
581         uint256 _eth;
582         uint256 token_temp;
583 		
584  
585         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
586         {
587           
588             Z5Ddatasets.EventReturns memory _eventData_;
589             
590             
591 			round_[_rID].ended = true;
592             _eventData_ = endRound(_eventData_);
593             
594 			
595             _eth = withdrawEarnings(_pID);
596 
597 
598             if (_eth > 0)
599                 plyr_[_pID].addr.transfer(_eth);
600 			
601 			token_temp = plyr_[_pID].token;
602 			if 	(token_temp > 0)
603 			{
604 				plyr_[_pID].token = 0;
605 				Z5DToken.transferTokensFromVault(plyr_[_pID].addr,token_temp);
606 
607 			}
608             
609           
610             emit Z5Devents.onWithdrawAndDistribute
611             (
612                 msg.sender, 
613                 plyr_[_pID].name, 
614                 _eth, 
615                 _eventData_.winnerAddr, 
616                 _eventData_.winnerName, 
617                 _eventData_.amountWon, 
618                 _eventData_.newPot,  
619                 _eventData_.genAmount
620             );
621             
622       
623         } else {
624           
625             _eth = withdrawEarnings(_pID);
626 
627 
628             if (_eth > 0)
629                 plyr_[_pID].addr.transfer(_eth);
630 			
631 			token_temp = plyr_[_pID].token;
632 			if 	(token_temp > 0)
633 			{
634 				plyr_[_pID].token = 0;
635 				Z5DToken.transferTokensFromVault(plyr_[_pID].addr,token_temp);
636 
637 			}
638 			
639 			
640 			
641 			
642         
643             emit Z5Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
644         }
645     }
646     
647 
648     function getBuyPrice() public view returns(uint256)
649     {  
650      
651         uint256 _rID = rID_;
652         
653        
654         uint256 _now = now;
655         
656         
657         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
658             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
659         else 
660             return ( 75000000000000 );
661     }
662     
663     
664     function getTimeLeft() public view returns(uint256)
665     {
666        
667         uint256 _rID = rID_;
668         
669        
670         uint256 _now = now;
671         
672         if (_now < round_[_rID].end)
673             if (_now > round_[_rID].strt)
674                 return( (round_[_rID].end).sub(_now) );
675             else
676                 return( (round_[_rID].strt).sub(_now) );
677         else
678             return(0);
679     }
680     
681     
682     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256)
683     {
684      
685         uint256 _rID = rID_;
686         
687         
688         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
689         {
690            
691             if (round_[_rID].plyr == _pID)
692             {
693                 return
694                 (
695                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(50)) / 100 ),
696                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
697                     plyr_[_pID].aff
698                 );
699            
700             } 
701 			else if (round_[_rID].plyr_2nd == _pID)
702 			{
703 				return
704                 (
705                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(10)) / 100 ),
706                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
707                     plyr_[_pID].aff
708                 );
709 				
710 			}
711 			else if (round_[_rID].plyr_3rd == _pID)
712 			{
713 				return
714                 (
715                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(5)) / 100 ),
716                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
717                     plyr_[_pID].aff
718                 );
719 				
720 			}
721 			
722 
723 			else {
724                 return
725                 (
726                     plyr_[_pID].win,
727                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
728                     plyr_[_pID].aff
729                 );
730             }
731             
732        
733         } else {
734             return
735             (
736                 plyr_[_pID].win,
737                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
738                 plyr_[_pID].aff
739             );
740         }
741     }
742     
743 
744     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256)
745     {
746         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
747     }
748     
749 
750     function getCurrentRoundInfo() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
751     {
752         
753         uint256 _rID = rID_;
754         return
755         (
756             _rID,                           //0
757             round_[_rID].keys,              //1
758             round_[_rID].end,               //2
759             round_[_rID].strt,              //3
760             round_[_rID].pot,               //4
761             ((round_[_rID].plyr * 10)),     //5
762             plyr_[round_[_rID].plyr].addr,  //6
763             plyr_[round_[_rID].plyr].name,  //7
764             rndEth_[_rID]                 //8
765 			
766 			
767 			
768         );
769     }
770 
771 
772     function getPlayerInfoByAddress(address _addr) public view returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
773     {
774 
775 
776         
777         if (_addr == address(0))
778         {
779             _addr == msg.sender;
780         }
781         uint256 _pID = pIDxAddr_[_addr];
782         uint256 lrnWin =0;
783 		uint256 lrnPlayed = plyr_[_pID].lrnd_lott;
784 		if (lrnPlayed>0 && lrnPlayed<lottrnd)
785 		{
786 			lrnWin = (Rndlotty[lrnPlayed].rndToken).mul(plyr_[_pID].bet);
787 		}	
788 		
789 		
790         return
791         (
792             _pID,                               //0
793             plyr_[_pID].name,                   //1
794             plyrRnds_[_pID][rID_].keys,         //2
795             plyr_[_pID].win.add(lrnWin),        //3
796             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
797             plyr_[_pID].aff,                    //5
798             plyrRnds_[_pID][rID_].eth,           //6
799 			(plyr_[_pID].token).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), 	 //7
800 			plyr_[_pID].bet,					//8
801 			plyr_[_pID].lrnd_lott				//9	
802 			
803         );
804     }
805 
806 
807 	 
808     function buyCore(uint256 _pID, uint256 _affID, Z5Ddatasets.EventReturns memory _eventData_)
809 	private
810     {
811        
812         uint256 _rID = rID_;
813        
814         uint256 _now = now;
815         
816         updateBetVault(_pID);
817         
818       
819         if (_now > round_[_rID].strt&& (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
820         {
821             
822             core(_rID, _pID, msg.value, _affID, _eventData_);
823         
824         
825         } else {
826             if (_now > round_[_rID].end && round_[_rID].ended == false) 
827             {
828 
829 			    round_[_rID].ended = true;
830                 _eventData_ = endRound(_eventData_);
831                 emit Z5Devents.onBuyAndDistribute
832                 (
833                     msg.sender, 
834                     plyr_[_pID].name, 
835                     msg.value, 
836                     _eventData_.winnerAddr, 
837                     _eventData_.winnerName, 
838                     _eventData_.amountWon, 
839                     _eventData_.newPot,  
840                     _eventData_.genAmount
841                 );
842             }
843 
844             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
845         }
846     }
847     
848 
849     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, Z5Ddatasets.EventReturns memory _eventData_) private
850     {
851      
852         uint256 _rID = rID_;
853 
854         uint256 _now = now;
855         
856 		updateBetVault(_pID);
857 		
858 		
859         if (_now > round_[_rID].strt&& (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
860         {
861             
862             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
863             
864             core(_rID, _pID, _eth, _affID, _eventData_);
865   
866         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
867             round_[_rID].ended = true;
868             _eventData_ = endRound(_eventData_);
869                 
870 
871             emit Z5Devents.onReLoadAndDistribute
872             (
873                 msg.sender, 
874                 plyr_[_pID].name, 
875                 _eventData_.winnerAddr, 
876                 _eventData_.winnerName, 
877                 _eventData_.amountWon, 
878                 _eventData_.newPot, 
879                 _eventData_.genAmount
880             );
881         }
882     }
883     
884     
885 	
886     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, Z5Ddatasets.EventReturns memory _eventData_)
887     private
888     {
889         if (plyrRnds_[_pID][_rID].keys == 0)
890             _eventData_ = managePlayer(_pID, _eventData_);
891 
892         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
893         {
894             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
895             uint256 _refund = _eth.sub(_availableLimit);
896             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
897             _eth = _availableLimit;
898         }
899 		
900         if (_eth > 1000000000) 
901         {
902 
903             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
904 			
905             if (_keys >= 1000000000000000000)
906             {
907 				updateTimer(_keys, _rID);
908 				if (round_[_rID].plyr != _pID)
909 				{	
910 					round_[_rID].plyr_3rd = round_[_rID].plyr_2nd;
911 					round_[_rID].plyr_2nd = round_[_rID].plyr;
912 					round_[_rID].plyr = _pID; 
913 				}	
914           
915         }
916 
917             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
918             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
919             
920             round_[_rID].keys = _keys.add(round_[_rID].keys);
921             round_[_rID].eth = _eth.add(round_[_rID].eth);
922             rndEth_[_rID] = _eth.add(rndEth_[_rID]);
923 
924             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
925 			
926             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
927 
928 		    endTx(_pID, _eth, _keys, _eventData_);
929         }
930     }
931 
932 	
933     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256)
934     {
935         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
936     }
937     
938 	
939     
940     function calcKeysReceived(uint256 _rID, uint256 _eth)
941         public
942         view
943         returns(uint256)
944     {
945 
946         uint256 _now = now;
947 
948         if (_now > round_[_rID].strt&& (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
949             return ( (round_[_rID].eth).keysRec(_eth) );
950         else 
951             return ( (_eth).keys() );
952     }
953     
954    
955     function iWantXKeys(uint256 _keys) public view returns(uint256)
956     {
957 
958         uint256 _rID = rID_;
959 
960         uint256 _now = now;
961 
962         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
963             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
964         else 
965             return ( (_keys).eth() );
966     }
967 
968 
969 	 
970 	 
971 	 
972 	 
973     function determinePID(Z5Ddatasets.EventReturns memory _eventData_)
974         private
975         returns (Z5Ddatasets.EventReturns)
976     {
977 		
978 		address  _addr = msg.sender;
979 
980         if (pIDxAddr_[_addr] == 0)
981         {
982 
983 			pID_++;	
984             pIDxAddr_[_addr] = pID_;
985             plyr_[pID_].addr = _addr;
986             
987 
988         } 
989         return (_eventData_);
990     }
991     
992 
993    
994     function managePlayer(uint256 _pID, Z5Ddatasets.EventReturns memory _eventData_) private returns (Z5Ddatasets.EventReturns)
995     {
996         
997         if (plyr_[_pID].lrnd != 0)
998             updateGenVault(_pID, plyr_[_pID].lrnd);
999 
1000         plyr_[_pID].lrnd = rID_;
1001             
1002         
1003         return(_eventData_);
1004     }
1005     
1006    
1007     function endRound(Z5Ddatasets.EventReturns memory _eventData_) private returns (Z5Ddatasets.EventReturns)
1008     {
1009 
1010         uint256 _rID = rID_;
1011         
1012      
1013         uint256 _winPID = round_[_rID].plyr;
1014 		uint256 _winPID_2nd = round_[_rID].plyr_2nd;
1015 		uint256 _winPID_3rd = round_[_rID].plyr_3rd;
1016 		
1017 		if (_winPID_2nd == 0)
1018 		{
1019 			_winPID_2nd = 1;
1020 		}
1021         
1022 		if (_winPID_3rd == 0)
1023 		{
1024 			_winPID_3rd = 1;
1025 		}
1026 
1027         uint256 _pot = round_[_rID].pot;
1028         
1029 
1030 
1031         uint256 _win = (_pot.mul(50)) / 100;
1032 		
1033 		
1034         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1035         uint256 _res = (_pot.sub(_win.add(_win/5).add(_win/10))).sub(_gen);
1036 
1037         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1038         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1039         if (_dust > 0)
1040         {
1041             _gen = _gen.sub(_dust);
1042             _res = _res.add(_dust);
1043         }
1044 
1045         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1046 		plyr_[_winPID_2nd].win = (_win/5).add(plyr_[_winPID_2nd].win);
1047 		plyr_[_winPID_3rd].win = (_win/10).add(plyr_[_winPID_3rd].win);
1048 
1049         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1050 
1051         _eventData_.winnerAddr = plyr_[_winPID].addr;
1052         _eventData_.winnerName = plyr_[_winPID].name;
1053         _eventData_.amountWon = _win;
1054         _eventData_.genAmount = _gen;
1055         _eventData_.newPot = _res;
1056 
1057         rID_++;
1058         _rID++;
1059         round_[_rID].strt = now;
1060         round_[_rID].end = now.add(rndInit_);
1061         round_[_rID].pot = _res;
1062         
1063         return(_eventData_);
1064     }
1065     
1066     
1067     function updateGenVault(uint256 _pID, uint256 _rIDlast) private 
1068     {
1069         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1070         if (_earnings > 0)
1071         {
1072             
1073             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1074 			plyr_[_pID].token = _earnings.add(plyr_[_pID].token);
1075             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1076         }
1077     }
1078     
1079     
1080     function updateTimer(uint256 _keys, uint256 _rID)
1081         private
1082     {
1083 
1084         uint256 _now = now;
1085 
1086         uint256 _newTime;
1087         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1088             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1089         else
1090             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1091         
1092       
1093         if (_newTime < (rndMax_).add(_now))
1094             round_[_rID].end = _newTime;
1095         else
1096             round_[_rID].end = rndMax_.add(_now);
1097     }
1098     
1099     
1100     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, Z5Ddatasets.EventReturns memory _eventData_) private returns(Z5Ddatasets.EventReturns)
1101     {
1102 
1103       
1104         uint256 z5dgame = (_eth / 100).mul(3);
1105         uint256 _aff = (_eth.mul(11))/100;
1106         if (_affID != _pID && plyr_[_affID].name != '') {
1107             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1108 			plyr_[_affID].token = _aff.add(plyr_[_affID].token);
1109             emit Z5Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1110         } 
1111 		else
1112 		{
1113 			z5dgame = z5dgame.add(_aff);
1114 		}
1115 		
1116 		plyr_[_pID].token = z5dgame.add(plyr_[_pID].token);
1117 		Z5DToken.deposit.value(z5dgame)();
1118 		
1119 		
1120 
1121         return(_eventData_);
1122     }
1123     
1124 
1125     
1126    
1127     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, Z5Ddatasets.EventReturns memory _eventData_)
1128       private returns(Z5Ddatasets.EventReturns)
1129     {
1130      
1131         uint256 _gen = (_eth.mul(fees_)) / 100;
1132     
1133         uint256 _air = _eth / 100;
1134 		
1135 		
1136 		
1137         airDropPot_ = airDropPot_.add(_air);
1138 		comm = comm.add(_air.mul(3));
1139 		lott = lott.add(_air.mul(3));
1140         _eth = _eth.sub((_eth.mul(21)) / 100);     
1141         uint256 _pot = _eth.sub(_gen);
1142 
1143         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1144         if (_dust > 0)
1145             _gen = _gen.sub(_dust);
1146         
1147         
1148         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1149         
1150 
1151         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1152         _eventData_.potAmount = _pot;
1153         
1154         return(_eventData_);
1155     }
1156 
1157    
1158 	
1159 	
1160 	
1161 	
1162     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256)
1163     {
1164 
1165         
1166         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1167         
1168 		round_[_rID].mask = _ppt.add(round_[_rID].mask);
1169             
1170         
1171         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1172         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1173         
1174         
1175         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1176     }
1177     
1178     
1179 	
1180 	
1181 	
1182     function withdrawEarnings(uint256 _pID) private returns(uint256)
1183     {
1184 
1185         updateGenVault(_pID, plyr_[_pID].lrnd);
1186 		
1187 		updateBetVault(_pID);
1188         
1189 
1190         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1191 		
1192 		
1193 
1194         if (_earnings > 0)
1195         {
1196 			
1197 			plyr_[_pID].gen = 0;
1198             plyr_[_pID].win = 0;
1199             plyr_[_pID].aff = 0;
1200         }
1201 
1202         return(_earnings);
1203     }
1204     
1205     
1206     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, Z5Ddatasets.EventReturns memory _eventData_) private
1207     {
1208   
1209         emit Z5Devents.onEndTx
1210         (
1211 
1212             plyr_[_pID].name,
1213             msg.sender,
1214             _eth,
1215             _keys,
1216             _eventData_.winnerAddr,
1217             _eventData_.winnerName,
1218             _eventData_.amountWon,
1219             _eventData_.newPot,
1220             _eventData_.genAmount,
1221             _eventData_.potAmount,
1222             airDropPot_,
1223 			rID_
1224         );
1225     }
1226 
1227     bool public activated_ = false;
1228 	
1229 	function activate() onlyowner() public
1230     {
1231 
1232         require(activated_ == false, "already activated");
1233         
1234       
1235         activated_ = true;
1236 
1237 		rID_ = 1;
1238         round_[1].strt = now ;
1239         round_[1].end = now + rndInit_;
1240 		
1241 		BetTime = round_[1].strt + betPre_;
1242 		lottrnd = 1 ;
1243 		
1244     }
1245 	
1246 	function claimsaleagent() public
1247     {
1248         Z5DToken.claimSalesAgent();
1249     }
1250     
1251 }
1252 
1253 
1254 interface ZoMo5DInterface 
1255 {
1256 	function transferTokensFromVault(address toAddress, uint256 tokensAmount) external;
1257 	function claimSalesAgent() external;
1258 	function deposit() external payable;
1259 	function AuthTransfer(address from_, uint256 amount) external;
1260        
1261 }
1262 
1263 
1264 
1265 library Z5Ddatasets {
1266 
1267     struct EventReturns {
1268         address winnerAddr;         
1269         bytes32 winnerName;        
1270         uint256 amountWon;          
1271         uint256 newPot;            
1272         uint256 genAmount;         
1273         uint256 potAmount;          
1274     }
1275     struct Player {
1276         address addr;   
1277         bytes32 name;   
1278         uint256 win;    
1279         uint256 gen;   
1280         uint256 aff;    
1281         uint256 lrnd;  
1282         uint256 laff; 
1283 		uint256 token;
1284 		uint256 lrnd_lott;
1285 		uint256 bet;
1286 		
1287     }
1288     struct PlayerRounds {
1289         uint256 eth;    
1290         uint256 keys;   
1291         uint256 mask;  
1292     }
1293     struct Round {
1294         uint256 plyr;   	
1295 		uint256 plyr_2nd;   
1296 		uint256 plyr_3rd;	
1297         uint256 end;    	
1298         bool ended;     	
1299         uint256 strt;   	
1300         uint256 keys;   	
1301         uint256 eth;    	
1302         uint256 pot;    	
1303         uint256 mask;   	
1304 
1305     }
1306 	
1307 	struct lotty{
1308 		uint256 rndToken;
1309 		uint256 rndlott;
1310 		
1311 	}
1312 
1313 }
1314 
1315 
1316 
1317 library Z5DKeyCount {
1318     using SafeMath for *;
1319 
1320     function keysRec(uint256 _curEth, uint256 _newEth) internal pure returns (uint256)
1321     {	
1322 	
1323         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1324     }
1325     
1326 
1327     function ethRec(uint256 _curKeys, uint256 _sellKeys) internal pure returns (uint256)
1328     {
1329         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1330     }
1331 
1332 
1333     function keys(uint256 _eth) internal pure returns(uint256)
1334     {
1335 		
1336 		return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1337 	
1338     }
1339     
1340     
1341     function eth(uint256 _keys) 
1342         internal
1343         pure
1344         returns(uint256)  
1345     {
1346         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1347     }
1348 }
1349 
1350 
1351 
1352 
1353 library NameCheck {
1354     
1355     function nameCheck(string _input) internal pure returns(bytes32)
1356     {
1357         bytes memory _temp = bytes(_input);
1358         uint256 _length = _temp.length;
1359 
1360         require (_length <= 32 && _length > 0, "name is limited to 32 characters");
1361         
1362         if (_temp[0] == 0x30)
1363         {
1364             require(_temp[1] != 0x78, "0x start is not allowed");
1365             require(_temp[1] != 0x58, "0X start is not allowed");
1366         }
1367         
1368         bool _hasNonNumber;
1369         
1370         for (uint256 i = 0; i < _length; i++)
1371         {
1372             
1373             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1374             {
1375                 
1376                 _temp[i] = byte(uint(_temp[i]) + 32);
1377 				if (_hasNonNumber == false)
1378 					_hasNonNumber = true;
1379             } 
1380 			else 
1381 			{
1382 				
1383                 require
1384                 (
1385                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||(_temp[i] > 0x2f && _temp[i] < 0x3a)
1386                 );
1387                 
1388                
1389                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1390                     _hasNonNumber = true;    
1391             }
1392         }
1393         
1394         require(_hasNonNumber == true, "only numbers is not allowed");
1395         
1396         bytes32 retrieve;
1397         assembly 
1398 		{
1399             retrieve := mload(add(_temp, 32))
1400         }
1401         return (retrieve);
1402     }
1403 }
1404 
1405 
1406 library SafeMath {
1407     
1408 
1409     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
1410     {
1411         if (a == 0) {
1412             return 0;
1413         }
1414         c = a * b;
1415         require(c / a == b, "Multiplication failed");
1416         return c;
1417     }
1418 
1419 
1420     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
1421     {
1422         require(b <= a, "Subtraction failed");
1423         return a - b;
1424     }
1425 
1426 
1427     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
1428     {
1429         c = a + b;
1430         require(c >= a, "add failed");
1431         return c;
1432     }
1433     
1434 
1435     function sqrt(uint256 x) internal pure returns (uint256 y) 
1436     {
1437         uint256 z = ((add(x,1)) / 2);
1438         y = x;
1439         while (z < y) 
1440         {
1441             y = z;
1442             z = ((add((x / z),z)) / 2);
1443         }
1444     }
1445 
1446     function sq(uint256 x) internal pure returns (uint256)
1447     {
1448         return (mul(x,x));
1449     }
1450     
1451 
1452 }