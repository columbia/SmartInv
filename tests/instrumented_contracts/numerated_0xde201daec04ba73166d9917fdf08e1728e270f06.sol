1 pragma solidity 0.5.16; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12 
13 
14 ███╗   ███╗███████╗██╗  ██╗██████╗     ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
15 ████╗ ████║██╔════╝╚██╗██╔╝██╔══██╗    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
16 ██╔████╔██║█████╗   ╚███╔╝ ██████╔╝       ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
17 ██║╚██╔╝██║██╔══╝   ██╔██╗ ██╔═══╝        ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
18 ██║ ╚═╝ ██║███████╗██╔╝ ██╗██║            ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
19 ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝            ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
20                                                                                    
21 
22 
23                                                                              
24 
25 
26 === 'MEXP' Token contract with following features ===
27     => TRC20 Compliance
28     => Higher degree of control by owner - safeguard functionality
29     => SafeMath implementation 
30     => Burnable and minting ( For MOJI Players)
31 
32 
33 ======================= Quick Stats ===================
34     => Name        : "MOJI Experience Points"
35     => Symbol      : MEXP
36     => Total supply: 0 (Minted only by MOJI players only)
37     => Decimals    : 18
38 */
39 
40 
41 //*******************************************************************//
42 //------------------------ SafeMath Library -------------------------//
43 //*******************************************************************//
44 /**
45     * @title SafeMath
46     * @dev Math operations with safety checks that throw on error
47     */
48 library SafeMath {
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51         return 0;
52     }
53     uint256 c = a * b;
54     require(c / a == b);
55     return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     return a - b;
68     }
69 
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     require(c >= a);
73     return c;
74     }
75 }
76 
77 
78 //*******************************************************************//
79 //------------------ Contract to Manage Ownership -------------------//
80 //*******************************************************************//
81     
82 contract owned {
83     address payable public owner;
84     address payable private newOwner;
85 
86     /**
87         Signer is deligated admin wallet, which can do sub-owner functions.
88         Signer calls following four functions:
89             => claimOwnerTokens
90             => distributeMainDividend
91             => distributeLeaders1
92             => distributeLeaders2
93     */
94     address public signer;
95 
96     event OwnershipTransferred(address indexed _from, address indexed _to);
97 
98     constructor() public {
99         owner = msg.sender;
100         signer = msg.sender;
101     }
102 
103     modifier onlyOwner {
104         require(msg.sender == owner);
105         _;
106     }
107 
108     modifier onlySigner {
109         require(msg.sender == signer);
110         _;
111     }
112 
113     function changeSigner(address _signer) public onlyOwner {
114         signer = _signer;
115     }
116 
117     function transferOwnership(address payable _newOwner) public onlyOwner {
118         newOwner = _newOwner;
119     }
120 
121     //this flow is to prevent transferring ownership to wrong wallet by mistake
122     function acceptOwnership() public {
123         require(msg.sender == newOwner);
124         emit OwnershipTransferred(owner, newOwner);
125         owner = newOwner;
126         newOwner = address(0);
127     }
128 }
129 
130 
131 //**************************************************************************//
132 //-------------------    NIFTYMOJI CONTRACT INTERFACE    --------------------//
133 //**************************************************************************//
134 
135 interface niftyMoji 
136 {
137     function ownerOf(uint256 tokenId) external view returns (address);
138     function powerNLucks(uint256 tokenID) external view returns(uint256, uint256);
139     function totalSupply() external view returns(uint256);
140 } 
141     
142 
143     
144 //****************************************************************************//
145 //---------------------    MEXP MAIN CODE STARTS HERE   ---------------------//
146 //****************************************************************************//
147     
148 contract MEXPToken is owned {
149 
150     /*===============================
151     =         DATA STORAGE          =
152     ===============================*/
153 
154     // Public variables of the token
155     using SafeMath for uint256;
156     uint256 public withdrawnByAdmin; 
157     string public constant name = "MOJI Experience Points";
158     string public constant symbol = "MEXP";
159     uint256 public constant decimals = 18; 
160     uint256 public totalSupply;
161     uint256 public burnTracker;     //mainly used in mintToken function..
162     uint256 public mintingMultiplier=10000;  // 10000 = 1, 123 = 0.0123 admin can set it minting per day, will be factored as luck %
163     address public niftyMojiContractAddress = 0xde544E54a330Abd1eA8a0E6693D46BFe95D9A684;  // admin can set / change this address 
164     uint256 public battleFees=1;  // default is 0.000000000000000001 Ether for battle fees, which admin can change
165     uint256 public mintTokenFee = 0.001 ether;
166     uint256 public battleWinReward= 10**18; // = 1 token with 18 decimal places, admin can change
167     uint256 public battleLooseReward = 10**17; // = 0.1 token with 10 decimal places, admin can change
168     uint256 public maxBattlePerDay=10;  //daily 10 max battles
169     bool public globalHalt; // Emergency Break
170     uint256 public lastFinishedIndex;
171 
172     // This creates a mapping with all data storage
173     mapping (address => uint256) public balanceOf;
174     mapping(uint256 => uint256) public totalMintedForTokenId;
175     mapping(uint256 => uint256) public totalMintedByOwnerForTokenID;
176     mapping(uint256 => uint256) public totalMintedByUserForTokenID;
177     mapping(uint256 => uint256) public totalMintedByBattleForTokenID;
178     mapping(uint256 => uint256) public dayTracker;
179     mapping (address => mapping (address => uint256)) public allowance;
180     
181     mapping(address => uint256) public BattleCountEndTime;
182     mapping (address => uint256) public userBattleCount;
183     mapping(address => bool) public blackListedUser;
184     mapping(uint256 => bool) public blackListedToken;
185     
186 
187 
188     struct battleInfo
189     {
190         uint256 tokenID;
191         uint256 userSeed;
192         uint256 rewardAmount;
193         uint256 blockNo;
194         uint256 opponentTokenID;
195     }
196 
197     battleInfo[] public battleInfos;
198 
199     /*===============================
200     =         PUBLIC EVENTS         =
201     ===============================*/
202 
203     // This generates a public event of token transfer
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     // This notifies clients about the amount burnt
207     event Burn(address indexed indexed from, uint256 value);
208 
209     // This trackes approvals
210     event Approval(address indexed owner, address indexed spender, uint256 value );
211 
212     /*======================================
213     =       STANDARD TRC20 FUNCTIONS       =
214     ======================================*/
215 
216     /* Internal transfer, only can be called by this contract */
217     function _transfer(address _from, address _to, uint _value) internal {
218         
219         //checking conditions
220         require(!globalHalt, "paused by admin");
221         require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead      
222         // overflow and undeflow checked by SafeMath Library
223         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
224         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient       
225         // emit Transfer event
226         emit Transfer(_from, _to, _value);
227     }
228 
229     /**
230         * Transfer tokens
231         *
232         * Send `_value` tokens to `_to` from your account
233         *
234         * @param _to The address of the recipient
235         * @param _value the amount to send
236         */
237     function transfer(address _to, uint256 _value) public returns (bool success) {
238         require(!blackListedUser[msg.sender], "you are not allowed");
239         //no need to check for input validations, as that is ruled by SafeMath
240         _transfer(msg.sender, _to, _value);
241         
242         return true;
243     }
244 
245     /**
246         * Transfer tokens from other address
247         *
248         * Send `_value` tokens to `_to` in behalf of `_from`
249         *
250         * @param _from The address of the sender
251         * @param _to The address of the recipient
252         * @param _value the amount to send
253         */
254     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
255         require(!blackListedUser[msg.sender], "you are not allowed");
256         //require(_value <= allowance[_from][msg.sender]);     // no need for this condition as it is already checked by SafeMath below
257         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
258         _transfer(_from, _to, _value);
259         
260         return true;
261     }
262 
263     /**
264         * Set allowance for other address
265         *
266         * Allows `_spender` to spend no more than `_value` tokens in your behalf
267         *
268         * @param _spender The address authorized to spend
269         * @param _value the max amount they can spend
270         */
271     function approve(address _spender, uint256 _value) public returns (bool success) {
272         require(!blackListedUser[msg.sender], "you are not allowed");
273         require(!globalHalt, "paused by admin");
274         allowance[msg.sender][_spender] = _value;
275         emit Approval(msg.sender, _spender, _value);
276         return true;
277     }
278 
279 
280     /*=====================================
281     =       CUSTOM PUBLIC FUNCTIONS       =
282     ======================================*/
283 
284     /**
285         Constructor function
286     */
287     constructor() public 
288     {
289         battleInfo memory temp;
290         battleInfos.push(temp);
291         
292     }
293 
294     /**
295         * Fallback function. It just accepts incoming Ether
296     */
297     function () payable external {}
298     
299 
300     /**
301         * Destroy tokens
302         *
303         * Remove `_value` tokens from the system irreversibly
304         *
305         * @param _value the amount of money to burn
306         */
307     function burn(uint256 _value) public returns (bool success) {
308 
309         require(!globalHalt, "paused by admin");
310         require(!blackListedUser[msg.sender], "you are not allowed");
311         //checking of enough token balance is done by SafeMath
312         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
313         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
314         burnTracker = burnTracker.add(_value);
315         
316         emit Transfer(msg.sender, address(0), _value);
317         //althogh we can track all the "burn" from the Transfer function, we just kept it as it is. As that is no much harm
318         emit Burn(msg.sender, _value);
319         return true;
320     }
321 
322     /**
323         * Destroy tokens from other account
324         *
325         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
326         *
327         * @param _from the address of the sender
328         * @param _value the amount of money to burn
329         */
330     function burnFrom(address _from, uint256 _value) public returns (bool success) {
331 
332         require(!globalHalt, "paused by admin");
333         require(!blackListedUser[msg.sender], "you are not allowed");
334         //checking of allowance and token value is done by SafeMath
335         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
336         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
337         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
338         burnTracker = burnTracker.add(_value);
339         
340         emit Transfer(_from, address(0), _value);
341         emit  Burn(_from, _value);
342         return true;
343     }
344 
345     function mintTokenOwnerOnly(address user, uint256 _tokenID, uint256 tokenAmount) public onlyOwner returns(bool)
346     {
347         require(user != address(this) && user != address(0), "invalid address" );
348         require(tokenAmount > 0 , "Invalid token to mint");
349         require(!blackListedToken[_tokenID], "this token is blacklisted");
350         if(_tokenID != 0)
351         {
352             require(niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID) == user,"user is not the owner of this tokenID");
353             totalMintedForTokenId[_tokenID] = totalMintedForTokenId[_tokenID].add(tokenAmount);
354             totalMintedByOwnerForTokenID[_tokenID] = totalMintedByOwnerForTokenID[_tokenID].add(tokenAmount);
355         }
356         totalSupply = totalSupply.add(tokenAmount);
357         balanceOf[user] = balanceOf[user].add(tokenAmount);
358         //emitting Transfer event
359         emit Transfer(address(0),user,tokenAmount);
360         return true;
361     }       
362 
363 
364     function blackListUser(address user) public onlyOwner returns(bool)
365     {
366         blackListedUser[user] = true;
367         return true;
368     }
369 
370 
371     function removeUserFromBlackList(address user) public onlyOwner returns(bool)
372     {
373         blackListedUser[user] = false;
374         return true;
375     }
376 
377 
378 
379 
380     function blackListToken(uint256 _tokenID) public onlyOwner returns(bool)
381     {
382         blackListedToken[_tokenID] = true;
383         return true;
384     }
385 
386 
387     function removeTokenFromBlackList(uint256 _tokenID) public onlyOwner returns(bool)
388     {
389         blackListedToken[_tokenID] = false;
390         return true;
391     }
392 
393     //Minting according to luck percent of the given token id 
394     function mintToken(uint256 _tokenID)  public payable returns(bool) {
395         require(!globalHalt, "paused by admin");
396         address caller = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
397         require(!blackListedUser[caller], "you are not allowed");
398         require(!blackListedToken[_tokenID], "this token is blacklisted");
399         require(caller == msg.sender,"caller is not the owner of this tokenID");
400         require(msg.value >= mintTokenFee, 'Not enough token minting fee');
401         uint256 dt = dayTracker[_tokenID];
402         if (dt != 0)
403         {
404             uint256 secPassed  =  now - dt ;
405             require(secPassed > 0 , "already minted for the day");
406             (,uint256 luckPercent ) = niftyMoji(niftyMojiContractAddress).powerNLucks(_tokenID);
407             uint256 mintAmount = (( (mintingMultiplier * (10 ** 18) * ((luckPercent + 9 ) / 10 ) ) / 100000 ) /  86400 ) * secPassed ;
408             dayTracker[_tokenID] = now ;            
409             totalMintedByUserForTokenID[_tokenID] = totalMintedByUserForTokenID[_tokenID].add(mintAmount);
410             totalMintedForTokenId[_tokenID] = totalMintedForTokenId[_tokenID].add(mintAmount);
411             totalSupply = totalSupply.add(mintAmount);
412             balanceOf[caller] = balanceOf[caller].add(mintAmount);
413             //emitting Transfer event
414             emit Transfer(address(0),caller,mintAmount);
415         }
416         else
417         {
418            dayTracker[_tokenID] = now; 
419         }
420         owner.transfer(msg.value);
421         return true;
422     }
423 
424     function viewAmountIfIMintNow(uint256 _tokenID) public view returns(uint256 amount)
425     {
426         uint256 dt = dayTracker[_tokenID];
427         if (dt != 0)
428         {
429             uint256 secPassed  =  now - dt ;
430             (,uint256 luckPercent ) = niftyMoji(niftyMojiContractAddress).powerNLucks(_tokenID);
431             amount = (( (mintingMultiplier * (10 ** 18) * ((luckPercent + 9 ) / 10 ) ) / 100000 ) /  86400 ) * secPassed ;
432             return amount;
433         }
434         else
435         {
436            return (0);
437         }        
438     }
439 
440     function setMaxBattlePerDay(uint _maxBattlePerDay) public onlyOwner returns (bool)
441     {
442         maxBattlePerDay = _maxBattlePerDay;
443         return true;
444     }
445 
446 
447     event initiateBattleEv(address caller,uint256 _tokenID,uint256 _userSeed,uint256 battleInfoIndex, uint256 blockNo);
448     function initiateBattle(uint256 _tokenID, uint256 _userSeed) public payable returns (uint256 battleID)
449     { 
450         require(!globalHalt, "paused by admin");
451         require(msg.value == battleFees, "Invalid fees amount");
452         address caller = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
453         require(!blackListedUser[caller], "you are not allowed");
454         require(!blackListedToken[_tokenID], "this token is blacklisted");
455         require(caller == msg.sender,"caller is not the owner of this tokenID");
456         require( userBattleCount[caller] <= maxBattlePerDay, "enough for the day");
457         if(BattleCountEndTime[caller] >= now )
458         {
459             userBattleCount[caller] += 1;
460         }
461         else
462         {
463             BattleCountEndTime[caller] = now + 86400;
464             userBattleCount[caller] = 1;
465         }        
466         battleInfo memory temp;
467         temp.tokenID = _tokenID;
468         temp.userSeed = _userSeed;
469         temp.blockNo = block.number;
470         battleInfos.push(temp);
471         //emitting Transfer event
472         battleID = battleInfos.length - 1;
473         address(owner).transfer(msg.value);
474         emit initiateBattleEv(caller, _tokenID, _userSeed, battleID,block.number );   
475         return battleID;
476     }
477 
478 
479     event finishBattleEv(address user, uint256 battleInfoIndex, uint256 _tokenID, uint256 randomToken, uint256 mintAmount);
480     function finishBattle(uint256 _battleInfoIndex,bytes32 blockHashValue) public onlySigner returns (bool)  // returns winning amount minted
481     { 
482         require(_battleInfoIndex < battleInfos.length, "Invalid Battle Index");
483         require(battleInfos[_battleInfoIndex].rewardAmount == 0, "Already finished");
484         uint256 _tokenID = battleInfos[_battleInfoIndex].tokenID;
485         uint256 _userSeed = battleInfos[_battleInfoIndex].userSeed;
486         address caller = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
487         bool success;
488         uint256 randomToken;
489         address randomTokenUser;
490         for(uint256 i=0;i<50;i++)
491         {
492             randomToken = uint256(keccak256(abi.encodePacked(blockHashValue, _userSeed))) % niftyMoji(niftyMojiContractAddress).totalSupply() + 1;
493             randomTokenUser = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
494             if(blackListedToken[randomToken] || blackListedUser[randomTokenUser])
495             {
496                 _userSeed += block.number%8;
497             }
498             else
499             {
500                 success = true;
501                 break;
502             }
503         }
504         require(success, "try again");
505         (uint256 powerPercent,uint256 luckPercent ) = niftyMoji(niftyMojiContractAddress).powerNLucks(_tokenID);
506         (uint256 powerPercent2,uint256 luckPercent2 ) = niftyMoji(niftyMojiContractAddress).powerNLucks(randomToken); 
507         uint256 mintAmount;
508         if( powerPercent + luckPercent > powerPercent2 + luckPercent2) 
509         {
510             mintAmount = battleWinReward ;           
511         } 
512         else
513         {
514             mintAmount = battleLooseReward;
515         }
516         battleInfos[_battleInfoIndex].rewardAmount = mintAmount;
517         battleInfos[_battleInfoIndex].opponentTokenID = randomToken;
518 
519         emit finishBattleEv(caller,_battleInfoIndex, _tokenID, randomToken, mintAmount);   
520         balanceOf[caller] = balanceOf[caller].add(mintAmount);
521         totalSupply = totalSupply.add(mintAmount);
522         totalMintedForTokenId[_tokenID] = totalMintedForTokenId[_tokenID].add(mintAmount);
523         totalMintedByBattleForTokenID[_tokenID] = totalMintedByBattleForTokenID[_tokenID].add(mintAmount);
524         dayTracker[_tokenID] = now;
525         lastFinishedIndex = _battleInfoIndex;                       
526         emit Transfer(address(0),caller,mintAmount);
527         return true;
528     }
529 
530     function multipleFinishBattle (bytes32[] memory _blockHashValue) public onlySigner returns(bool)
531     {
532         uint i;
533 
534         for(i=0;i<_blockHashValue.length;i++)
535         {
536            require(finishBattle(lastFinishedIndex + i + 1,_blockHashValue[i]),"could not fihish battle");
537         }
538         return true;
539     }
540 
541     function lastUnFinishedIndexNBlock() public view returns (uint256 lastUnFinishedIndex, uint256 blockNo)
542     {
543         uint len = battleInfos.length-1;
544         if(len >  lastFinishedIndex)
545         {
546             return (lastFinishedIndex +1, battleInfos[lastFinishedIndex +1].blockNo);
547         }
548         else
549         {
550             return (0,0);
551         }
552     }
553 
554 
555     function setNiftyMojiContractAddress(address _niftyMojiContractAddress) public onlyOwner returns(bool)
556     {
557         niftyMojiContractAddress = _niftyMojiContractAddress;
558         return true;
559     }
560 
561 
562     function setMintingMultiplier(uint256 _mintingMultiplier) public onlyOwner returns (bool)
563     {
564         mintingMultiplier = _mintingMultiplier;
565         return true;
566     }
567 
568 
569     function setbattleFees(uint256 _battleFees) public onlyOwner returns(bool)
570     {
571         battleFees = _battleFees;
572         return true;
573     }
574     
575     function setMintTokenFee(uint256 _mintTokenFee) public onlyOwner returns(bool)
576     {
577         mintTokenFee = _mintTokenFee;
578         return true;
579     }
580     
581     
582     
583 
584     function setBattleReward(uint256 winReward, uint256 looseReward) public onlyOwner returns(bool)
585     {
586         battleWinReward = winReward;
587         battleLooseReward = looseReward;
588         return true;
589     }
590 
591     /**
592         * If global halt is off, then this funtion will on it. And vice versa
593         * This also change safeguard for token movement status
594     */
595     function changeGlobalHalt() onlyOwner public returns(bool) {
596         if (globalHalt == false){
597             globalHalt = true;
598         }
599         else{
600             globalHalt = false;  
601         }
602         return true;
603     }
604 
605  
606 
607     /**
608         * Function to check Ether balance in this contract
609     */
610     function totalEtherbalanceContract() public view returns(uint256){
611         return address(this).balance;
612     }
613 
614 
615     /**
616      * Just in rare case, owner wants to transfer Ether from contract to owner address
617      */
618     function manualWithdrawEtherAdmin(uint64 Amount) public onlyOwner returns (bool){
619         require (address(this).balance >= Amount);
620         address(owner).transfer(Amount);
621         withdrawnByAdmin = withdrawnByAdmin.add(Amount);
622         return true;
623     }
624 
625 
626 }