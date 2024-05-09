1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     
27     //Disable Decimal usage
28     //uint8 public decimals = 0;
29 
30     // 18 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) private allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         //totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         totalSupply = initialSupply;
55         //balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public {
90         _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) internal
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         internal
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157 }
158 
159 /******************************************/
160 /*       ADVANCED TOKEN STARTS HERE       */
161 /******************************************/
162 
163 contract MyAdvancedToken is owned, TokenERC20 {
164 
165     uint256 public sellPrice;
166     uint256 public buyPrice;
167 
168     mapping (address => bool) public frozenAccount;
169 
170     /* This generates a public event on the blockchain that will notify clients */
171     event FrozenFunds(address target, bool frozen);
172 
173     /* Initializes contract with initial supply tokens to the creator of the contract */
174     function MyAdvancedToken(
175         uint256 initialSupply,
176         string tokenName,
177         string tokenSymbol
178     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
179 
180     /* Internal transfer, only can be called by this contract */
181     function _transfer(address _from, address _to, uint _value) internal {
182         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
183         require (balanceOf[_from] >= _value);                // Check if the sender has enough
184         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
185         require(!frozenAccount[_from]);                     // Check if sender is frozen
186         require(!frozenAccount[_to]);                       // Check if recipient is frozen
187         balanceOf[_from] -= _value;                         // Subtract from the sender
188         balanceOf[_to] += _value;                           // Add the same to the recipient
189         Transfer(_from, _to, _value);
190     }
191 
192     /// @notice Create `mintedAmount` tokens and send it to `target`
193     /// @param target Address to receive the tokens
194     /// @param mintedAmount the amount of tokens it will receive
195     function mintToken(address target, uint256 mintedAmount) internal  {
196         //Convert to eth value
197         //mintedAmount = mintedAmount  * 10 ** uint256(decimals);
198         balanceOf[target] += mintedAmount;
199         totalSupply += mintedAmount;
200         //Transfer(0, this, mintedAmount);
201         Transfer(this, target, mintedAmount);
202     }
203 
204     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
205     /// @param target Address to be frozen
206     /// @param freeze either to freeze it or not
207     function freezeAccount(address target, bool freeze) onlyOwner public {
208         frozenAccount[target] = freeze;
209         FrozenFunds(target, freeze);
210     }
211 
212     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
213     /// @param newSellPrice Price the users can sell to the contract
214     /// @param newBuyPrice Price users can buy from the contract
215     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
216         sellPrice = newSellPrice;
217         buyPrice = newBuyPrice;
218     }
219 
220 /* //Don't allow buying this way
221     /// @notice Buy tokens from contract by sending ether
222     function buy() payable public {
223         uint amount = msg.value / buyPrice;               // calculates the amount
224         _transfer(this, msg.sender, amount);              // makes the transfers
225     }
226 */    
227 
228     /// @notice Sell `amount` tokens to contract
229     /// @param amount amount of tokens to be sold
230     function sell(uint256 amount) public {
231         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
232         _transfer(msg.sender, this, amount);              // makes the transfers
233         if (sellPrice>0) {
234             msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
235         }
236         totalSupply -= amount;
237     }
238     
239     function getBalance(address target)  view public returns (uint256){
240         return balanceOf[target];
241     }
242 
243     /**
244      * Destroy tokens from other account
245      *
246      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
247      *
248      * @param _from the address of the sender
249      * @param _value the amount of money to burn
250      */
251     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
252         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
253         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
254         totalSupply -= _value;                              // Update totalSupply
255         Burn(_from, _value);
256         return true;
257     }
258     
259     
260 }
261 
262 
263 interface token {
264     function transfer(address receiver, uint amount) public;
265 }
266 
267 
268 contract ScavengerHuntTokenWatch is MyAdvancedToken {
269     uint public crowdsaleDeadline;
270     uint public tokensDistributed;
271     uint public totalHunters;
272     uint public maxDailyRewards;
273     string public scavengerHuntTokenName;
274     string public scavengerHuntTokenSymbol;
275 
276     //Allow to stop being anonymous
277     mapping (address => bytes32) public registeredNames;
278 
279     // 1 = Digged, No Reward
280     // >1 X = Digged, Got Reward
281     mapping (bytes32 => mapping (bytes32 => uint)) public GPSDigs;
282 
283     //Address of the person that got the reward
284     mapping (bytes32 => mapping (bytes32 => address)) public GPSActivityAddress;
285 
286     //Maximize the daily reward
287     mapping (address => mapping(uint => uint256) ) public dailyRewardCount;
288     
289     
290     
291     //Private
292     uint256 digHashBase;
293     bool crowdsaleClosed = false;
294 
295     event FundTransfer(address backer, uint amountEhter, uint amountScavengerHuntTokens, bool isContribution);
296     event ShareLocation(address owner, uint ScavengerHuntTokenAmount, uint PercentageOfTotal, bytes32 GPSLatitude, bytes32 GPSLongitude);
297     event ShareMessage(address recipient, string Message, string TokenName);
298     event SaleEnded(address owner, uint totalTokensDistributed,uint totalHunters);
299     event SharePersonalMessage(address Sender, string MyPersonalMessage, bytes32 GPSLatitude, bytes32 GPSLongitude);
300     event NameClaimed(address owner, string Name, bytes32 GPSLatitude, bytes32 GPSLongitude);
301     event HunterRewarded(address owner, uint ScavengerHuntTokenAmount, uint PercentageOfTotal, bytes32 GPSLatitude, bytes32 GPSLongitude);
302     
303     modifier afterDeadline() { if (now >= crowdsaleDeadline) _; }
304     
305 
306     /**
307      * Check if deadline was met, so close the sale of tokens
308      */
309     function checkDeadlinePassed() afterDeadline public {
310         SaleEnded(owner, tokensDistributed,totalHunters);
311         crowdsaleClosed = true;
312     }
313 
314     
315     /**
316      * Constrctor function
317      *
318      * Setup the owner
319      */
320      function ScavengerHuntTokenWatch (
321         address ifSuccessfulSendTo,
322         uint durationInMinutes,
323         uint weiCostOfEachToken,
324         uint initialSupply,
325         string tokenName,
326         string tokenSymbol,
327         uint256 adigHashBase,
328         uint aMaxDailyRewards
329         ) MyAdvancedToken(initialSupply, tokenName, tokenSymbol) public {
330         owner=msg.sender;
331         
332         scavengerHuntTokenName = tokenName;
333         scavengerHuntTokenSymbol = tokenSymbol;
334 
335         //Make sure we can get these tokens
336         setPrices(0,weiCostOfEachToken * 1 wei);
337        
338         digHashBase = adigHashBase;
339         maxDailyRewards = aMaxDailyRewards;
340 
341         crowdsaleDeadline = now + durationInMinutes * 1 minutes;
342         tokensDistributed = initialSupply;
343         FundTransfer(ifSuccessfulSendTo, 0, tokensDistributed, true);
344 
345         //Now change the owner to the actual user
346         owner = ifSuccessfulSendTo;
347         totalHunters=1;
348         balanceOf[owner] = initialSupply;
349         
350 
351     }
352 
353 
354     function destroySHT(address _from, uint256 _value) internal {
355         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
356         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
357         totalSupply -= _value;                              // Update totalSupply
358         if(balanceOf[_from]==0) {
359             totalHunters--;
360         }
361     }
362 
363     
364 
365     function extendCrowdsalePeriod (uint durationInMinutes) onlyOwner public {
366         crowdsaleDeadline = now + durationInMinutes * 1 minutes;
367         crowdsaleClosed = false;
368         ShareMessage(msg.sender,"The crowdsale is extended for token ->",scavengerHuntTokenName );
369     }
370 
371     function setMaxDailyRewards(uint aMaxDailyRewards) onlyOwner public {
372         maxDailyRewards = aMaxDailyRewards;
373         ShareMessage(msg.sender,"The maximum of daily reward is now updated for token ->",scavengerHuntTokenName );
374     }
375 
376     
377 
378     //We also allow the calling of the buying function too.
379     function buyScavengerHuntToken() payable public {
380         //Only allow buying in, when crowdsale is open.
381         if (crowdsaleClosed) {
382             ShareMessage(msg.sender,"Sorry: The crowdsale has ended. You cannot buy anymore ->",scavengerHuntTokenName );
383         }
384         require(!crowdsaleClosed);
385         uint amountEth = msg.value;
386         uint amountSht = amountEth / buyPrice;
387 
388         //Mint a token for each payer
389         mintScavengerToken(msg.sender, amountSht);
390 
391         FundTransfer(msg.sender, amountEth, amountSht, true);
392         
393         
394         //And check if fundraiser is closed:
395         checkDeadlinePassed();
396     }
397 
398     
399     function buyScavengerHuntTokenWithLocationSharing(bytes32 GPSLatitude, bytes32 GPSLongitude) payable public {
400         buyScavengerHuntToken();
401         ShareLocation(msg.sender, balanceOf[msg.sender],getPercentageComplete(msg.sender), GPSLatitude, GPSLongitude);
402     }
403 
404     
405     /**
406      * Fallback function
407      *
408      * The function without name is the default function that is called whenever anyone sends funds to a contract
409      */
410     function () payable public {
411         buyScavengerHuntToken();
412     }
413 
414     
415     /// @notice Create `mintedAmount` tokens and send it to `target`
416     /// @param target Address to receive the tokens
417     /// @param mintedAmount the amount of tokens it will receive
418     function mintScavengerToken(address target, uint256 mintedAmount) private {
419         if(balanceOf[target]==0) {
420             //New hunter!
421             totalHunters++;
422         }else {}
423         balanceOf[target] += mintedAmount;
424         totalSupply += mintedAmount;
425         Transfer(this, target, mintedAmount);
426         tokensDistributed += mintedAmount;
427     }
428 
429 
430     /// @notice Create `mintedAmount` tokens and send it to `target`
431     /// @param target Address to receive the tokens
432     /// @param mintedAmount the amount of tokens it will receive
433     function mintExtraScavengerHuntTokens(address target, uint256 mintedAmount) onlyOwner public {
434         mintScavengerToken(target, mintedAmount);
435     }
436 
437 
438 
439     function shareScavengerHuntTokenLocation(bytes32 GPSLatitude, bytes32 GPSLongitude) public {
440         //Only call this if you actually have tokens!
441         require(balanceOf[msg.sender] > 0); 
442         ShareLocation(msg.sender, balanceOf[msg.sender],getPercentageComplete(msg.sender), GPSLatitude, GPSLongitude);
443     }
444 
445     function sharePersonalScavengerHuntTokenMessage(string MyPersonalMessage, bytes32 GPSLatitude, bytes32 GPSLongitude) public {
446         //Only call this if you actually have tokens!
447         require(balanceOf[msg.sender] >=1); 
448         SharePersonalMessage(msg.sender, MyPersonalMessage, GPSLatitude, GPSLongitude);
449         //Personal messages cost 1 token!
450         destroySHT(msg.sender, 1);
451     }
452 
453     function claimName(string MyName, bytes32 GPSLatitude, bytes32 GPSLongitude) public {
454         //Only call this if you actually have tokens!
455         require(bytes(MyName).length < 32);
456         require(balanceOf[msg.sender] >= 10); 
457         registeredNames[msg.sender]=getStringAsKey(MyName);
458         NameClaimed(msg.sender, MyName, GPSLatitude, GPSLongitude);
459         //Claiming your name costs 10 tokens!
460         destroySHT(msg.sender, 10);
461     }
462 
463     
464     function transferScavengerHuntToken(address to, uint SHTokenAmount,bytes32 GPSLatitude, bytes32 GPSLongitude) public {
465         //Share the transfer with the new total
466         if(balanceOf[to]==0) {
467             totalHunters++;
468         }
469 
470         //Call the internal transfer method
471         _transfer(msg.sender, to, SHTokenAmount);
472 
473         ShareLocation(to, balanceOf[to], getPercentageComplete(to), "unknown", "unknown");
474         ShareLocation(msg.sender, balanceOf[msg.sender], getPercentageComplete(msg.sender), GPSLatitude, GPSLongitude);
475         if(balanceOf[msg.sender]==0) {
476             totalHunters--;
477         }
478 
479     }
480 
481     function returnEtherumToOwner(uint amount) onlyOwner public {
482         if (owner.send(amount)) {
483             FundTransfer(owner, amount,0, false);
484         } 
485     }
486 
487     //Date and time library
488 
489     uint constant DAY_IN_SECONDS = 86400;
490     uint constant YEAR_IN_SECONDS = 31536000;
491     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
492 
493     uint constant HOUR_IN_SECONDS = 3600;
494     uint constant MINUTE_IN_SECONDS = 60;
495 
496     uint16 constant ORIGIN_YEAR = 1970;
497     
498     function leapYearsBefore(uint year) internal pure returns (uint) {
499         year -= 1;
500         return year / 4 - year / 100 + year / 400;
501     }    
502     
503     function isLeapYear(uint16 year) internal pure returns (bool) {
504                 if (year % 4 != 0) {
505                         return false;
506                 }
507                 if (year % 100 != 0) {
508                         return true;
509                 }
510                 if (year % 400 != 0) {
511                         return false;
512                 }
513                 return true;
514     }
515     
516     function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
517                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
518                         return 31;
519                 }
520                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
521                         return 30;
522                 }
523                 else if (isLeapYear(year)) {
524                         return 29;
525                 }
526                 else {
527                         return 28;
528                 }
529     }
530 
531     
532     function getToday() public view returns (uint) {
533         uint16 year;
534         uint8 month;
535         uint8 day;
536 
537         uint secondsAccountedFor = 0;
538         uint buf;
539         uint8 i;
540 
541         
542         uint timestamp=now;
543         
544         // Year
545         year = getYear(timestamp);
546         buf = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
547 
548         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
549         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - buf);
550 
551         // Month
552         uint secondsInMonth;
553         for (i = 1; i <= 12; i++) {
554             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, year);
555             if (secondsInMonth + secondsAccountedFor > timestamp) {
556                     month = i;
557                     break;
558             }
559             secondsAccountedFor += secondsInMonth;
560         }
561 
562         // Day
563         for (i = 1; i <= getDaysInMonth(month, year); i++) {
564                 if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
565                         day = i;
566                         break;
567                 }
568                 secondsAccountedFor += DAY_IN_SECONDS;
569         }
570         
571         //20170106
572         uint endDate = uint(year) * 10000;
573         if (month<10) {
574             endDate += uint(month)*100;
575         } else {
576             endDate += uint(month)*10;
577         }
578         endDate += uint(day);
579         return endDate;
580         
581     }
582 
583     function getYear(uint timestamp) internal pure returns (uint16) {
584             uint secondsAccountedFor = 0;
585             uint16 year;
586             uint numLeapYears;
587 
588             // Year
589             year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
590             numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
591 
592             secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
593             secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
594 
595             while (secondsAccountedFor > timestamp) {
596                     if (isLeapYear(uint16(year - 1))) {
597                             secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
598                     }
599                     else {
600                             secondsAccountedFor -= YEAR_IN_SECONDS;
601                     }
602                     year -= 1;
603             }
604             return year;
605     }
606 
607     
608     function hashSeriesNumber(bytes32 series, uint256 number) internal pure returns (bytes32){
609         return keccak256(number, series);
610     }
611     
612     function digRewardCheck(uint hash, uint modulo,uint reward,bytes32 GPSLatitude, bytes32 GPSLongitude) internal returns (uint256) {
613         if (hash % modulo == 0) {
614             //Reward a 50 tokens
615             mintScavengerToken(msg.sender, reward);
616             dailyRewardCount[msg.sender][getToday()]++;
617             GPSDigs[GPSLatitude][GPSLongitude]=reward;
618             GPSActivityAddress[GPSLatitude][GPSLongitude]=msg.sender;
619             HunterRewarded(msg.sender, reward,getPercentageComplete(msg.sender), GPSLatitude, GPSLongitude);
620             return reward;
621         }
622         else {
623             return 0;
624         }
625     }
626 
627     function digForTokens(bytes32 GPSLatitude, bytes32 GPSLongitude) payable public returns(uint256) {
628         //Only call this if you actually have tokens!
629         require(balanceOf[msg.sender] > 1); 
630         //Only once digging is allowed!
631         require(GPSDigs[GPSLatitude][GPSLongitude] == 0); 
632 
633         //You can only win that much per day
634         require( dailyRewardCount[msg.sender][getToday()] <= maxDailyRewards);
635         
636         //Diggin costs 1 tokens!
637         destroySHT(msg.sender, 1);
638 
639         uint hash = uint(hashSeriesNumber(GPSLatitude,digHashBase));
640         hash += uint(hashSeriesNumber(GPSLongitude,digHashBase));
641 
642         uint awarded = digRewardCheck(hash, 100000000,100000,GPSLatitude,GPSLongitude);
643         if (awarded>0) {
644             return awarded;
645         }
646 
647         awarded = digRewardCheck(hash, 100000,1000,GPSLatitude,GPSLongitude);
648         if (awarded>0) {
649             return awarded;
650         }
651         
652         awarded = digRewardCheck(hash, 10000,500,GPSLatitude,GPSLongitude);
653         if (awarded>0) {
654             return awarded;
655         }
656 
657         awarded = digRewardCheck(hash, 1000,200,GPSLatitude,GPSLongitude);
658         if (awarded>0) {
659             return awarded;
660         }
661 
662         awarded = digRewardCheck(hash, 100,50,GPSLatitude,GPSLongitude);
663         if (awarded>0) {
664             return awarded;
665         }
666 
667         awarded = digRewardCheck(hash, 10,3,GPSLatitude,GPSLongitude);
668         if (awarded>0) {
669             return awarded;
670         }
671         
672         //You've got nothing!
673         GPSDigs[GPSLatitude][GPSLongitude]=1;
674         GPSActivityAddress[GPSLatitude][GPSLongitude]=msg.sender;
675         HunterRewarded(msg.sender, 0,getPercentageComplete(msg.sender), GPSLatitude, GPSLongitude);
676         return 0;
677     }
678     
679     
680     function getPercentageComplete(address ScavengerHuntTokenOwner)  view public returns (uint256){
681         //Since there are no decimals, just create some of our own
682         uint256 myBalance = balanceOf[ScavengerHuntTokenOwner]*100000.0;
683         uint256 myTotalSupply = totalSupply;
684         uint256 myResult = myBalance / myTotalSupply;
685         return  myResult;
686     }
687 
688     function getStringAsKey(string key) pure public returns (bytes32 ret) {
689         require(bytes(key).length < 32);
690         assembly {
691           ret := mload(add(key, 32))
692         }
693     }
694     
695     function getKeyAsString(bytes32 x) pure public returns (string) {
696         bytes memory bytesString = new bytes(32);
697         uint charCount = 0;
698         for (uint j = 0; j < 32; j++) {
699             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
700             if (char != 0) {
701                 bytesString[charCount] = char;
702                 charCount++;
703             }
704         }
705         bytes memory bytesStringTrimmed = new bytes(charCount);
706         for (j = 0; j < charCount; j++) {
707             bytesStringTrimmed[j] = bytesString[j];
708         }
709         return string(bytesStringTrimmed);
710     }
711     
712     modifier aftercrowdsaleDeadline()  { if (now >= crowdsaleDeadline) _; }
713     
714 }