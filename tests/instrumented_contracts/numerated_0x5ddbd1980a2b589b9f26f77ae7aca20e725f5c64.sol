1 pragma solidity ^0.4.25;
2 
3 contract RISK{
4 
5     //global variables
6     uint16[19][3232] private adjacencies;
7     address private admin = msg.sender;
8     uint256 private seed = block.timestamp;
9     uint256 public roundID;
10     mapping(uint256=>RoundData) public Rounds;
11     bool public isactive;
12     mapping(address=>uint256) private playerlastroundwithdrawn;
13     
14     
15     //settings that are read at the beggining of a round, and admin can change them, taking effect at new round 
16     uint16 public beginterritories = 5; //number of territories to claim at createnation
17     uint16 public maxroll= 6;
18     uint256 public trucetime=72 hours;
19     uint256 public price=30 finney;
20     uint256 public maxextensiontruce=50; //max number of territories owned during truce
21     
22     
23     //store names
24     mapping(bytes32=>address) public ownerXname; //get owner by name, anyone can own an arbitrary number of names
25     mapping(address=>bytes32) public nameXaddress;//get the current name in use by the address
26     mapping(bytes32=>uint256) public priceXname; //get the price of a name
27 
28 
29 
30     /*_____       _     _ _      ______                _   _                 
31      |  __ \     | |   | (_)    |  ____|              | | (_)                
32      | |__) |   _| |__ | |_  ___| |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
33      |  ___/ | | | '_ \| | |/ __|  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
34      | |   | |_| | |_) | | | (__| |  | |_| | | | | (__| |_| | (_) | | | \__ \
35      |_|    \__,_|_.__/|_|_|\___|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/*/
36 
37 
38     function createnation(uint16[] territories,string _name,
39     uint256 RGB)
40     public
41     payable
42     {
43         RequireHuman();
44         require(isactive);
45         uint256 _rID = roundID;
46         uint16 _teamcnt =Rounds[_rID].teamcnt;
47         
48         
49         require(_teamcnt<255); //max 255 teams, with 0 being unclaimed territories
50         
51         
52         RGB=colorfilter(RGB);//format and check it's not one of the UI colors
53         require(!Rounds[_rID].iscolorregistered[RGB]); //color must be unique
54         
55         
56         bytes32 name=nameFilter(_name);
57         require(ownerXname[name]==msg.sender); //player must own this name
58         require(Rounds[_rID].isnameregistered[name]==false); //name must be unique to round
59 
60 
61         uint16 _beginterritories =  Rounds[roundID].beginterritories;
62         require(msg.value==Rounds[_rID].price);
63         require(territories.length==_beginterritories);//send only the exact ammount pls
64         require(Rounds[_rID].teamXaddr[msg.sender]==0); //one player can only play with one team
65         
66         uint i;
67         for (i =0 ; i<territories.length;i++){
68             require(territories[i]<uint16(2750)); //don't claim sea provinces
69             require(getownership(territories[i])==uint16(0)); //don't claim other players' lands
70         }
71 
72         _teamcnt+=1; //increase the team counter
73 
74         setownership(territories[0],_teamcnt);
75         for (i =1 ; i<territories.length;i++){ 
76             require(hasteamadjacency(territories[i],_teamcnt)); //all territories should share borders
77             setownership(territories[i],_teamcnt);
78         }
79         
80 
81         //starting a nation gives as many shares to the pot as the number of territories claimed
82         Rounds[_rID].validrollsXaddr[msg.sender]+=_beginterritories;
83         Rounds[_rID].validrollsXteam[_teamcnt]+=_beginterritories;
84         
85         
86         Rounds[_rID].teamXaddr[msg.sender]=_teamcnt; //map the players address to his team
87         Rounds[_rID].nationnameXteam[_teamcnt]=name;
88         Rounds[_rID].colorXteam[_teamcnt]=RGB;
89         Rounds[_rID].iscolorregistered[RGB]=true;
90         Rounds[_rID].teamcnt=_teamcnt;
91         Rounds[_rID].isnameregistered[name]=true;//don't allow countries with duplicate names
92         Rounds[_rID].pot+=msg.value;
93         
94         
95         //trigger event
96         emit oncreatenation(
97             nameXaddress[msg.sender],
98             name,
99             RGB,
100             _teamcnt,
101             territories,
102             msg.sender);
103     }
104     
105     
106     function roll(uint16[] territories,uint16 team) 
107     payable
108     public
109     {
110         RequireHuman();
111         require(isactive);
112         
113         require(team!=0);
114         
115         uint256 _rID = roundID;
116         uint256 _now = block.timestamp;
117         uint256 _roundstart = Rounds[_rID].roundstart;
118         uint256 _trucetime = Rounds[_rID].trucetime;
119 
120 
121         if (Rounds[_rID].teamXaddr[msg.sender]==0){ //new player
122             Rounds[_rID].teamXaddr[msg.sender]=team;
123         }
124         else{
125             require(Rounds[_rID].teamXaddr[msg.sender]==team); //don't allow to switch teams   
126         }
127 
128 
129         //require(territories.length==maxroll); //should allow player to input fewer or extra territories, as a backup plan in case someone is includead earlier in the block or for endgame too
130         
131         
132         require(msg.value==Rounds[_rID].price ); 
133         
134         uint16 _maxroll = Rounds[_rID].maxroll;
135         seed = uint256(keccak256(abi.encodePacked((seed^block.timestamp)))); //far from safe, but the advantadge to roll a 6 is not worth for a miner to cheat
136         uint256 rolled = (seed % _maxroll)+1; //dice roll from 1 to maxroll
137         uint256 validrolls=0; 
138         uint16[] memory territoriesconquered = new uint16[](_maxroll);
139         
140         if  (_roundstart+_trucetime<_now){//check if the truce has ended
141             for (uint i = 0 ; i<territories.length;i++){
142                 if (getownership(territories[i])==team){ //dont waste a roll for own provinces
143                     continue;
144                 }
145                 if (hasteamadjacency(territories[i],team)){//valid territory, is adjacent to own
146                     territoriesconquered[validrolls]=territories[i];
147                     setownership(territories[i],team); //invade it
148                     validrolls+=1;
149                     if (validrolls==rolled){//exit the loop when we reached our rolled
150                         break;
151                     }
152                 }
153             }
154         }
155         else{//if truce
156             require(Rounds[_rID].validrollsXteam[team]<Rounds[_rID].maxextensiontruce); //limit number of territories during truce, don't allow to roll if 50 territories or more
157             for  (i = 0 ; i<territories.length;i++){
158                 if (getownership(territories[i])!=0){ //only invade neutral provinces
159                     continue;
160                 }
161                 if (hasteamadjacency(territories[i],team)){//valid territory, is adjacent to own
162                     territoriesconquered[validrolls]=territories[i];
163                     setownership(territories[i],team); //invade it
164                     validrolls+=1;
165                     if (validrolls==rolled){//exit the loop when we reached our rolled
166                         break;
167                     }
168                 }
169             }
170         }
171 
172         Rounds[_rID].validrollsXaddr[msg.sender]+=validrolls;
173         Rounds[_rID].validrollsXteam[team]+=validrolls;
174         
175         uint256 refund;
176         if (validrolls<rolled){
177             refund = ((rolled-validrolls)*msg.value)/rolled;
178         }
179         Rounds[_rID].pot+=msg.value-refund;
180         if (refund>0){
181             msg.sender.transfer(refund);
182         }
183         
184         
185         //trigger event
186         emit onroll(
187             nameXaddress[msg.sender],
188             Rounds[_rID].nationnameXteam[team],
189             rolled,
190             team,
191             territoriesconquered,
192             msg.sender
193             );
194     }
195 
196 
197     function endround()
198     //call this in a separate function cause it can take quite a bit of gas, around 1Mio gas
199     public
200     {
201         RequireHuman();
202         require(isactive);
203         
204         uint256 _rID = roundID;
205         require(Rounds[_rID].teamcnt>0); // require at least one nation has been created
206 
207         uint256 _pot = Rounds[_rID].pot;
208         uint256 fee =_pot/20; //5% admin fee
209         uint256 nextpot = _pot/20; //5% of current pot to next round
210         uint256 finalpot = _pot-fee-nextpot; //remaining pot to distribute 
211         
212         
213         uint256 _roundstart=Rounds[_rID].roundstart;
214         uint256 _now=block.timestamp;
215         require(_roundstart+Rounds[_rID].trucetime<_now);//require that the truce has ended
216 
217 
218         uint256[] memory _owners_ = new uint256[](86);
219         for (uint16 i = 0;i<86;i++){ //memory copy of owners, saves around 400k gas by avoiding SSLOAD opcodes
220             _owners_[i]=Rounds[_rID].owners[i];
221         }
222 
223         uint16 t;
224         uint16 team;
225         uint16 j;
226         for ( i = 1; i<uint16(2750);i++){ //loop until you find a nonzero team
227             t=getownership2(i,_owners_[i/32]);
228             if (t!=uint16(0)){
229                 team=t;
230                 j=i+1;
231                 break;
232             }
233         }
234         
235         for ( i = j; i<uint16(2750);i++){ //check that all nonzero territories belong to team
236             t=getownership2(i,_owners_[i/32]);
237             if(t>0){
238                 if(t!=team){
239                     require(false);
240                 }
241             }
242         }
243         Rounds[_rID].teampotshare[team]=finalpot; //entire pot to winner team
244         Rounds[_rID].winner=Rounds[_rID].nationnameXteam[team];
245         
246         
247         admin.transfer(fee);
248         
249         
250         //start next round
251         _rID+=1;
252         Rounds[_rID].trucetime =trucetime;
253         Rounds[_rID].roundstart =block.timestamp;
254         Rounds[_rID].beginterritories =beginterritories; 
255         Rounds[_rID].maxroll = maxroll;
256         Rounds[_rID].pot = nextpot;
257         Rounds[_rID].price = price;
258         Rounds[_rID].maxextensiontruce = maxextensiontruce;
259         roundID=_rID;
260         
261         emit onendround();
262     }
263 
264 
265     function withdraw() 
266     public
267     {
268         RequireHuman();
269         uint256 balance;
270         uint256 _roundID=roundID;
271         balance=getbalance(_roundID);
272         playerlastroundwithdrawn[msg.sender]=_roundID-1;
273         if (balance>0){
274             msg.sender.transfer(balance);
275         }
276     }
277     
278     
279     function buyname( string _name)
280     public
281     payable
282     {
283         RequireHuman();
284         
285         
286         bytes32 name=nameFilter(_name);
287         address prevowner=ownerXname[name];
288         require(prevowner!=msg.sender);
289         uint256 buyprice = 3*priceXname[name]/2; //require 1.5X what was paid to get the name
290         if (3 finney > buyprice){ //starting bids at 3mETH
291             buyprice = 3 finney;
292         }
293         require(msg.value>=buyprice);
294         
295         uint256 fee;
296         uint256 topot;
297         uint256 reimbursement;
298         
299         
300         if (prevowner==address(0)){ //if it's the first time the name is purchased, the payment goes to the pot
301             Rounds[roundID].pot+=msg.value ;   
302         }
303         else{
304             fee = buyprice/20; //5% fee on refund
305             topot = msg.value-buyprice;//anything over the buyprice goes to the pot
306             reimbursement=buyprice-fee; //ammount to pay back
307             if (topot>0){
308             Rounds[roundID].pot+=topot;
309             }
310         }
311         
312 
313         nameXaddress[prevowner]=''; //change the name of the previous owner to empty
314         ownerXname[name]=msg.sender; //set new owner
315         priceXname[name]=msg.value; //new buyprice
316         bytes32 prevname = nameXaddress[msg.sender];
317         nameXaddress[msg.sender]=name; //set name bought as display name for buyer
318         
319         emit onbuyname(
320             name,
321             msg.value,
322             prevname,
323             msg.sender
324             );
325             
326         if (fee>0){
327         admin.transfer(fee);
328             
329         }
330         if (reimbursement>0){
331         prevowner.transfer(reimbursement);
332         }
333     }
334     
335     
336     function switchname(bytes32 name) //switch between owned names
337     public
338     {
339         require(ownerXname[name]==msg.sender);//check that sender is the owner of this name
340         nameXaddress[msg.sender]=name;//set it
341     }
342     
343     
344     function clearname() //empty name, use default random one on UI
345     public
346     {
347         bytes32 empty;
348         nameXaddress[msg.sender]=empty;
349     }
350     
351 
352     /*_____      _            _       ______                _   _                 
353      |  __ \    (_)          | |     |  ____|              | | (_)                
354      | |__) | __ ___   ____ _| |_ ___| |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
355      |  ___/ '__| \ \ / / _` | __/ _ \  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
356      | |   | |  | |\ V / (_| | ||  __/ |  | |_| | | | | (__| |_| | (_) | | | \__ \
357      |_|   |_|  |_| \_/ \__,_|\__\___|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/*/
358 
359 
360     function getownership(uint16 terr) 
361     private 
362     view
363     returns(uint16)
364     {//index is floor division, perform AND with a filter that's full of 0s except in the 8 bit range we want to access so it returns only that 8bit window
365         //shift it to the 8 rightmost bits and convert to int16
366         return(uint16((Rounds[roundID].owners[terr/32]&(255*2**(8*(uint256(terr%32)))))/(2**(uint256(terr)%32*8))));
367     }
368 
369 
370     function getownership2(uint16 terr,uint256 ownuint) //slightly modified version of getownership() to use in endround()
371     private 
372     pure
373     returns(uint16)
374     {//index if floor division, perform AND with a filter that's full of 0s except in the 8 bit range we want to access so it returns only that 8bit window
375         //shift it right and convert to int16
376         return(uint16((ownuint&255*2**(8*(uint256(terr)%32)))/(2**(uint256(terr)%32*8))));
377     } 
378 
379 
380     function setownership(uint16 terr, uint16 team)
381     private
382     { //index is floor division, perform AND with a filter that's full of 1s except in the 8bit range we want to access so that it removes the prev record
383         //perform OR with the team number shifted left into the position
384         Rounds[roundID].owners[terr/32]=(Rounds[roundID].owners[terr/32]&(115792089237316195423570985008687907853269984665640564039457584007913129639935-(255*(2**(8*(uint256(terr)%32))))))|(uint256(team)*2**((uint256(terr)%32)*8));
385     }
386 
387 
388     function areadjacent(uint16 terr1, uint16 terr2) 
389     private
390     view
391     returns(bool)
392     {
393         for (uint i=0;i<19;i++){
394             if (adjacencies[terr1][i]==terr2){//are adjacent
395                 return true;
396             }
397             if (adjacencies[terr1][i]==0){ //exit early if we get to the end of the valid adjacencies
398                 return false;
399             }
400         }
401         return false;
402     } 
403 
404 
405     function hasteamadjacency(uint16 terr,uint16 team) 
406     private
407     view
408     returns(bool)
409     {
410         for (uint i = 0; i<adjacencies[terr].length;i++){
411             if (getownership(adjacencies[terr][i])==team){
412                 return true;
413             }
414         }
415         return false;
416     }
417     
418     
419     //block transactions from contracts
420     function RequireHuman()
421     private
422     view
423     {
424         uint256  size;
425         address addr = msg.sender;
426         
427         assembly {size := extcodesize(addr)}
428         require(size == 0 );
429     }
430 
431    /*__      ___               ______                _   _                 
432      \ \    / (_)             |  ____|              | | (_)                
433       \ \  / / _  _____      _| |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
434        \ \/ / | |/ _ \ \ /\ / /  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
435         \  /  | |  __/\ V  V /| |  | |_| | | | | (__| |_| | (_) | | | \__ \
436          \/   |_|\___| \_/\_/ |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/ */
437 
438     
439     function colorfilter(uint256 RGB)
440     public
441     pure
442     returns(uint256)
443     {
444         //rounds the R, G and B values down to the closest 32 mutiple, removes anything outside the range
445         //this is done to ensure all colors are different enough to avoid confusion
446         RGB=RGB&14737632;
447 
448         //filter out game default colors
449         require(RGB!=12632256);
450         require(RGB!=14704640);
451         require(RGB!=14729344);
452         require(RGB!=8421504);
453         require(RGB!=224);
454         require(RGB!=8404992);
455 
456 
457         return(RGB);
458     }
459 
460 
461     function getbalance(uint rID)
462     public
463     view
464     returns(uint256)
465     {
466         uint16 team;
467         uint256 balance;
468         for (uint i = playerlastroundwithdrawn[msg.sender]+1;i<rID;i++){
469             if (Rounds[i].validrollsXaddr[msg.sender]==0){ //skip if player didn't take part in the round
470                 continue;
471             }
472             
473             team=Rounds[i].teamXaddr[msg.sender];
474             
475             balance += (Rounds[i].teampotshare[team]*Rounds[i].validrollsXaddr[msg.sender])/Rounds[i].validrollsXteam[team];
476         }
477         return balance;
478     }
479      
480      
481     function nameFilter(string _input) //Versioned from team JUST, no numbers, no caps, but caps are displayed after each space on the UI
482     public
483     pure
484     returns(bytes32)
485     {
486         bytes memory _temp = bytes(_input);
487         uint256 _length = _temp.length;
488         
489         //sorry limited to 32 characters
490         require (_length <= 32 && _length > 0, "string must be between 1 and 64 characters");
491         // make sure it doesnt start with or end with space
492         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
493         
494         // check
495         for (uint256 i = 0; i < _length; i++)
496         {
497                 require
498                 (
499                     // require character is a space
500                     _temp[i] == 0x20 || 
501                     // OR lowercase a-z
502                     (_temp[i] > 0x60 && _temp[i] < 0x7b) 
503                 );
504                 // make sure theres not 2x spaces in a row
505                 if (_temp[i] == 0x20){
506                     
507                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
508                 }
509             }
510         bytes32 _ret;
511         assembly {
512             _ret := mload(add(_temp, 32))
513         }
514         return (_ret);
515     }
516     
517     
518     //retrieve arrays and mappings from inside the struct array
519     function readowners()
520     view
521     public
522     returns(uint256[101])
523     {
524         return(Rounds[roundID].owners);
525     }
526     
527     
528     function readownerXname(string name)
529     view
530     public
531     returns(address)
532     {
533         return(ownerXname[nameFilter(name)]);
534     }
535     
536     
537     function readisnameregistered(string name)
538     view
539     public
540     returns(bool)
541     {
542         return(Rounds[roundID].isnameregistered[nameFilter(name)]);
543     }
544     
545     
546     function readnameXaddress(address addr)
547     view
548     public
549     returns(bytes32)
550     {
551         return(nameXaddress[addr]);
552     }
553     
554     
555     function readpriceXname(string name)
556     view
557     public
558     returns(uint256)
559     {
560         return(priceXname[nameFilter(name)]*3/2);
561     }
562     
563     
564     function readteamXaddr(address adr)
565     view
566     public
567     returns(uint16){
568         return(Rounds[roundID].teamXaddr[adr]);
569     }
570     
571     
572     function readvalidrollsXteam(uint16 tim)
573     view
574     public
575     returns(uint256){
576         return(Rounds[roundID].validrollsXteam[tim]);
577     }
578     
579     
580     function readvalidrollsXaddr(address adr)
581     view
582     public
583     returns(uint256){
584         return(Rounds[roundID].validrollsXaddr[adr]);
585     }
586     
587     
588     function readnationnameXteam()
589     view
590     public
591     returns(bytes32[256]){
592         bytes32[256] memory temp;
593         for (uint16 i = 0; i<256; i++){
594             temp[i]=Rounds[roundID].nationnameXteam[i];
595         }
596         return(temp);
597     }
598     
599     
600     function readcolorXteam()
601     view
602     public
603     returns(uint256[256]){
604         uint256[256] memory temp;
605         for (uint16 i = 0; i<256; i++){
606             temp[i]=Rounds[roundID].colorXteam[i];
607         }
608         return(temp);
609     }
610     
611     
612     function readiscolorregistered(uint256 rgb)
613     view
614     public
615     returns(bool){
616         return(Rounds[roundID].iscolorregistered[colorfilter(rgb)]);
617     }
618     
619     
620     function readhistoricalrounds()
621     view
622     public
623     returns(bytes32[]){
624         bytes32[] memory asdfg=new bytes32[](2*roundID-2);
625         for (uint256 i = 1;i<roundID;i++){
626             asdfg[2*i]=Rounds[roundID].winner;
627             asdfg[2*i+1]=bytes32(Rounds[roundID].pot);
628         }
629         return asdfg;
630     }
631     
632 
633      
634    /*_____             ______                _   _
635     |  __ \           |  ____|              | | (_)                
636     | |  | | _____   _| |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
637     | |  | |/ _ \ \ / /  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
638     | |__| |  __/\ V /| |  | |_| | | | | (__| |_| | (_) | | | \__ \
639     |_____/ \___| \_/ |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/ */
640    
641 
642     //used to load the adjacencies file that's required to block invalid actions
643     function addadjacencies(uint16[] indexes,uint16[] numvals,uint16[] adjs)
644     public
645     {   
646         require(msg.sender==admin);
647         require(!isactive);
648         
649         uint cnt=0;
650         for (uint i = 0; i<indexes.length;i++){
651             for (uint j = 0;j<numvals[i];j++){
652                 adjacencies[indexes[i]][j]=adjs[cnt];
653                 cnt++;
654             }
655         }   
656     }
657 
658 
659     //blocks the add function so dev can't modify the adjacencies after they've been loaded, serves as activate function too
660     function finishedloading()
661     public
662     {
663         require(msg.sender==admin);
664         require(!isactive);
665         
666         isactive=true;
667         
668         //seed the first round
669         roundID=1;
670         uint256 _rID=roundID;
671         //Rounds[_rID].roundtime =roundtime;
672         Rounds[_rID].roundstart =block.timestamp;
673         Rounds[_rID].beginterritories =beginterritories; 
674         Rounds[_rID].maxroll = maxroll;
675         Rounds[_rID].trucetime = trucetime;
676         Rounds[_rID].price = price;
677         Rounds[_rID].maxextensiontruce = maxextensiontruce;
678     }
679     
680     
681     //admin can change some settings to balance the game if required, they will get into effect at the beggining of a new round
682     function changesettings(/*uint256 _roundtime,*/ uint16 _beginterritories, uint16 _maxroll,uint256 _trucetime,uint256 _price,uint256 _maxextensiontruce)
683     public
684     {
685         require(msg.sender==admin);
686         //roundtime = _roundtime;
687         beginterritories = _beginterritories ;
688         maxroll = _maxroll;
689         trucetime = _trucetime;
690         price = _price;
691         maxextensiontruce = _maxextensiontruce;
692         
693     }
694 
695 
696     /* _____ _                   _       
697       / ____| |                 | |      
698      | (___ | |_ _ __ _   _  ___| |_ ___ 
699       \___ \| __| '__| | | |/ __| __/ __|
700       ____) | |_| |  | |_| | (__| |_\__ \
701      |_____/ \__|_|   \__,_|\___|\__|___/*/
702 
703      
704     struct RoundData{
705         
706         //tracks ownership of the territories
707         //encoded in 8bit such that 0=noncolonized and the remaining 255 values reference a team
708         //32 territories fit each entry, for a total of 3232, there are only 3231 territories 
709         //the one that corresponds to the nonexisting ID=0 remains empty
710         uint256[101] owners;
711         
712         
713         mapping(address=>uint16) teamXaddr; //return team by address
714         //keep track of the rolls to split the pot
715         mapping(uint16=>uint256) validrollsXteam; // number of valid rolls by team
716         mapping(address=>uint256) validrollsXaddr; //valid rolls by address
717         mapping(uint16=>uint256) teampotshare; //money that each team gets at the end of the round is stored here
718         mapping(uint16=>bytes32) nationnameXteam;
719         uint256 pot;
720         
721         //1xRGB for map display color
722         mapping(uint16=>uint256) colorXteam;
723         //track which colors are registered
724         mapping(uint256=>bool) iscolorregistered;
725         
726         
727         mapping(bytes32=>bool) isnameregistered; //avoid duplicate nation names within a same round
728         
729         
730         //counter
731         uint16 teamcnt;
732         
733         
734         //timers
735         uint256 roundstart;
736         
737         
738         //these settings can be modified by admin to balance if required, will get into effect when a new round is started
739         uint16 beginterritories; //number of territories to claim at createnation
740         uint16 maxroll;// = 6;
741         uint256 trucetime;
742         uint256 price;
743         uint256 maxextensiontruce;
744         
745         bytes32 winner;
746     }
747 
748 
749     /*______               _       
750      |  ____|             | |      
751      | |____   _____ _ __ | |_ ___ 
752      |  __\ \ / / _ \ '_ \| __/ __|
753      | |___\ V /  __/ | | | |_\__ \
754      |______\_/ \___|_| |_|\__|___/*/
755 
756      
757      event oncreatenation(
758         bytes32 leadername,
759         bytes32 nationname,
760         uint256 color,
761         uint16 team,
762         uint16[] territories,
763         address addr
764      );
765 
766      event onroll(
767         bytes32 playername,
768         bytes32 nationname,
769         uint256 rolled,
770         uint16 team,
771         uint16[] territories,
772         address addr
773      );
774      event onbuyname(
775         bytes32 newname,
776         uint256 price,
777         bytes32 prevname,
778         address addr
779      );
780      event onendround(
781      );
782 }