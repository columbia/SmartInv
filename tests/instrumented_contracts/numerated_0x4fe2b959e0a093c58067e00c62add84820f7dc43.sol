1 /* MUSystem is a global Savings system 
2 based of the mathematical algorithm created 
3 by the Mavrodi brothers - Sergey and Vyacheslav. 
4 The solidity code was written by the enthusiast and devoted MMM participant.
5 According to these rules MMM worked in Russia in the nineties.
6 
7 Today you help someone — Tomorrow you will be helped!
8 
9 Mutual Uniting System (MUSystem):
10 email: mutualunitingsystem@gmail.com
11 https://mutualunitingsystem.online/
12 
13 "MMM IS A FINANCIAL NUCLEAR WEAPON.
14 They say Baba Vanga predicted, “Pyramid from Russia will travel the world.”
15 When Sergey Mavrodi passed away, many people thought this prediction 
16 wasn't going to come true. What if it's just started to materialize?"
17 
18 Financial apocalypse is inevitable! Together we can do a lot!
19 Thank you Sergey Mavrodi. You've opened my eyes. */
20 
21 pragma solidity 0.4.25;
22 
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c=a * b;
29     require(c / a == b);
30     return c;
31   }
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b > 0); 
34     uint256 c=a / b;
35     return c;
36   }
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b <= a);
39     uint256 c=a - b;
40     return c;
41   }
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c=a + b;
44     require(c >= a);
45     return c;
46   }
47   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b != 0);
49     return a % b;
50   }
51 }
52 
53 contract MUSystem{
54     
55     using SafeMath for uint;
56     
57     string public constant name="Mutual Uniting System";
58     string public constant symbol="MUS";
59     uint public constant decimals=15;
60     uint public totalSupply;
61     address private creatorOwner;
62     mapping (address => uint) balances;
63     
64     struct User{
65         uint UserBuyFirstDate;
66         uint UserBuyFirstPack;
67         uint UserCycle;
68         uint UserBuyTokenPackNum;
69         uint UserFirstAmt;
70         uint UserBuyDate;
71         uint UserSellDate;
72         uint UserContinued;
73         uint UserTotalAmtDepositCurrentPack;
74         uint UserTotalAmtDeposit;
75         uint UserAmtDepositCurrentPackTRUE;
76         uint UserSellTokenPackNum;
77         uint UserTotalAmtWithdrawal;
78         uint UserTotalAmtWithdrawalCurrentPack;
79         uint UserWithdrawalFromFirstRefunded;
80         uint UserWithdrawalFromDisparity;
81     }
82     mapping (address => User) users;
83     
84     struct DepositTemp{
85         address useraddress;
86         uint p;
87         uint bonus;
88         uint userAmt;
89         uint amtToSend;
90         uint bonusAmount;
91         uint userBuyDate;
92         uint userSellDate;
93         uint userFirstAmt;
94         uint userContinued;
95         uint userAmtToStore;
96         uint availableTokens;
97         uint feeCompensation;
98         uint UserTokenObtain;
99         uint userBuyFirstPack;
100         uint userBuyFirstDate;
101         uint currentPackNumber;
102         uint amtForfirstRefund;
103         uint UserBuyTokenPackNum;
104         uint userTotalAmtDeposit;
105         uint bonusAmountRefunded;
106         uint currentPackStartDate;
107         uint userAmtOverloadToSend;
108         uint currentPackTokenPriceSellout;
109         uint userAmtDepositCurrentPackTRUE;
110         uint userTotalAmtDepositCurrentPack;
111     }
112     
113     struct WithdrawTemp{
114         address useraddress;
115         uint userTotalAmtWithdrawalCurrentPack;
116         uint UserTokensReturnAboveCurrentPack;
117         uint userWithdrawalFromFirstRefunded;
118         uint userTotalAmtDepositCurrentPack;
119         uint userAmtDepositCurrentPackTRUE;
120         uint UserTokensReturnToCurrentPack;
121         uint currentPackTokenPriceSellout;
122         uint currentPackTokenPriceBuyout;
123         uint withdrawAmtAboveCurrentPack;
124         uint userWithdrawalFromDisparity;
125         uint bonusTokensReturnDecrease;
126         bool returnTokenInCurrentPack;
127         uint withdrawAmtToCurrentPack;
128         uint remainsFromFirstRefunded;
129         uint overallDisparityAmounts;
130         uint userTotalAmtWithdrawal;
131         uint useFromFirstRefunded;
132         uint remainsFromDisparity;
133         uint TokensReturnDecrease;
134         uint currentPackStartDate;
135         uint userAvailableAmount;
136         uint currentPackDeposits;
137         uint currentPackNumber;
138         uint userBuyFirstPack;
139         uint UserTokensReturn;
140         uint useFromDisparity;
141         uint overallRefunded;
142         uint userSellDate;
143         uint userFirstAmt;
144         uint userBuyDate;
145         uint bonusToSend;
146         uint withdrawAmt;
147         uint wAtoStore;
148         uint thisBal;
149         uint bonus;
150         uint diff;
151         uint dsp;
152         bool ra;
153     }
154 
155     uint private Cycle;
156     uint private PrevPackCost;
157     bool private feeTransfered;
158     uint private NextPackDelta;
159     uint private NextPackYield;
160     uint private CurrentPackFee;
161     uint private RestartModeDate;
162     uint private CurrentPackCost;
163     uint private OverallDeposits;
164     uint private OverallRefunded;
165     uint private PrevPackTotalAmt;
166     uint private CurrentPackYield;
167     uint private CurrentPackDelta;
168     bool private RestartMode=false;
169     uint private CurrentPackNumber;
170     uint private OverallWithdrawals;
171     uint private CurrentPackRestAmt;
172     uint private CurrentPackTotalAmt;
173     uint private CurrentPackDeposits;
174     uint private CurrentPackStartDate; 
175     uint private CurrentPackTotalToPay;
176     uint private OverallDisparityAmounts;
177     uint private PrevPackTokenPriceBuyout; 
178     uint private NextPackTokenPriceBuyout;
179     uint private PrevPackTokenPriceSellout;
180     uint private CurrentPackTokenPriceBuyout;
181     uint private CurrentPackDisparityAmounts;
182     uint private CurrentPackTokenPriceSellout;
183     uint private CurrentPackTotalToPayDisparity;
184     uint private CurrentPackTokenAvailablePercent;
185 
186     constructor () public payable {
187         creatorOwner=msg.sender;
188         CurrentPackNumber=1;
189         Cycle=0;
190         mint(50000000000000000);
191         packSettings(CurrentPackNumber);
192     }
193 
194     function packSettings (uint _currentPackNumber) internal {
195         CurrentPackNumber=_currentPackNumber;
196         if(_currentPackNumber==1){
197             CurrentPackTokenPriceSellout=10;
198             CurrentPackTokenPriceBuyout=10;
199             CurrentPackCost=500000000000000000;
200             CurrentPackFee=0;
201         }
202         if(_currentPackNumber==2){
203             PrevPackTotalAmt=CurrentPackCost;
204             CurrentPackDelta=0;
205             NextPackTokenPriceBuyout=CurrentPackTokenPriceSellout*110/100;
206             NextPackYield=NextPackTokenPriceBuyout/CurrentPackTokenPriceSellout;
207             NextPackDelta=NextPackYield;
208             CurrentPackTokenPriceSellout=NextPackTokenPriceBuyout+NextPackDelta;
209             CurrentPackTokenPriceBuyout=CurrentPackTokenPriceSellout;
210             CurrentPackCost=50000000000000000*CurrentPackTokenPriceSellout;
211             CurrentPackTotalAmt=CurrentPackCost+PrevPackTotalAmt;
212             CurrentPackFee=0;
213         }
214         if(_currentPackNumber>2){
215             PrevPackTokenPriceSellout=CurrentPackTokenPriceSellout;
216             PrevPackTokenPriceBuyout=CurrentPackTokenPriceBuyout;
217             PrevPackCost=CurrentPackCost;
218             PrevPackTotalAmt=CurrentPackTotalAmt;
219             CurrentPackDelta=NextPackDelta;
220             CurrentPackTokenPriceBuyout=NextPackTokenPriceBuyout;
221             NextPackTokenPriceBuyout=PrevPackTokenPriceSellout*110;
222             if(NextPackTokenPriceBuyout<=100){  
223                 NextPackTokenPriceBuyout=PrevPackTokenPriceSellout*11/10;
224             }
225             if(NextPackTokenPriceBuyout>100){ 
226                 NextPackTokenPriceBuyout=NextPackTokenPriceBuyout*10**3;
227                 NextPackTokenPriceBuyout=((NextPackTokenPriceBuyout/10000)+5)/10;
228             }
229             NextPackYield=NextPackTokenPriceBuyout-PrevPackTokenPriceSellout;
230             NextPackDelta=NextPackYield*101;
231             if(NextPackDelta<=100){ 
232                 NextPackDelta=CurrentPackDelta+(NextPackYield*101/100);
233             }
234             if(NextPackDelta>100){
235                 NextPackDelta=NextPackDelta*10**3;
236                 NextPackDelta=((NextPackDelta/10000)+5)/10;
237                 NextPackDelta=CurrentPackDelta+NextPackDelta;
238             }
239             CurrentPackTokenPriceSellout=NextPackTokenPriceBuyout+NextPackDelta;
240             CurrentPackCost=50000000000000000*CurrentPackTokenPriceSellout;
241             CurrentPackTotalToPay=50000000000000000*CurrentPackTokenPriceBuyout;
242             CurrentPackTotalAmt=CurrentPackCost+PrevPackTotalAmt-CurrentPackTotalToPay;
243             CurrentPackFee=PrevPackTotalAmt-CurrentPackTotalToPay-(PrevPackCost*7/10);
244         }
245         CurrentPackDisparityAmounts=0;
246         CurrentPackDeposits=0;
247         CurrentPackTokenAvailablePercent=100;
248         CurrentPackStartDate=now;
249         emit NextPack(CurrentPackTokenPriceSellout, CurrentPackTokenPriceBuyout);
250     }
251 
252     function aboutCurrentPack () public constant returns (uint num, uint bal, uint overallRefunded, uint dsp, uint availableTokens, uint availableTokensInPercentage, uint availableAmountToDepositInWei, uint tokenPriceSellout, uint tokenPriceBuyout, uint cycle, uint overallDeposits, uint overallWithdrawals, bool){
253         if(CurrentPackDeposits+OverallDisparityAmounts > CurrentPackDisparityAmounts+OverallRefunded){
254             dsp = CurrentPackDeposits+OverallDisparityAmounts-CurrentPackDisparityAmounts-OverallRefunded;
255         }else{
256             dsp=0;
257         }
258         return (CurrentPackNumber, address(this).balance, OverallRefunded, dsp, balances[address(this)], CurrentPackTokenAvailablePercent, balances[address(this)].mul(CurrentPackTokenPriceSellout), CurrentPackTokenPriceSellout, CurrentPackTokenPriceBuyout, Cycle, OverallDeposits, OverallWithdrawals, RestartMode);
259     }
260 
261     function aboutUser () public constant returns (uint UserFirstAmt, uint remainsFromFirstRefunded, uint UserContinued, uint userTotalAmtDeposit, uint userTotalAmtWithdrawal, uint userAvailableAmount, uint userAvailableAmount1, uint remainsFromDisparity, uint depCP, uint witCP, uint userCycle, uint wAmtToCurrentPack, uint userBuyFirstDate){
262         if(users[msg.sender].UserBuyDate>CurrentPackStartDate && users[msg.sender].UserBuyTokenPackNum==CurrentPackNumber){
263             wAmtToCurrentPack=users[msg.sender].UserAmtDepositCurrentPackTRUE; 
264         }else{
265             wAmtToCurrentPack=0;
266         }
267         if(users[msg.sender].UserSellDate>CurrentPackStartDate && users[msg.sender].UserSellTokenPackNum==CurrentPackNumber){    
268             witCP=users[msg.sender].UserTotalAmtWithdrawalCurrentPack;
269         }else{
270             witCP=0;
271         }
272         if(users[msg.sender].UserBuyDate>CurrentPackStartDate && users[msg.sender].UserBuyTokenPackNum==CurrentPackNumber){
273             depCP=users[msg.sender].UserTotalAmtDepositCurrentPack;
274         }else{
275             depCP=0;
276         }
277         remainsFromFirstRefunded=(users[msg.sender].UserFirstAmt*6/10).sub(users[msg.sender].UserWithdrawalFromFirstRefunded);
278         remainsFromDisparity=(users[msg.sender].UserFirstAmt*7/10).sub(users[msg.sender].UserWithdrawalFromDisparity);
279         userAvailableAmount=(balances[msg.sender]-((wAmtToCurrentPack)/CurrentPackTokenPriceSellout))*CurrentPackTokenPriceBuyout+wAmtToCurrentPack;
280         if(CurrentPackTokenAvailablePercent<10){userAvailableAmount+userAvailableAmount/100;}
281         if(userAvailableAmount>remainsFromDisparity){
282             userAvailableAmount=userAvailableAmount-remainsFromDisparity;
283         }else{
284             userAvailableAmount=0;
285         }
286         if (userAvailableAmount<10){
287             userAvailableAmount=0;
288         }
289         uint dsp=0;
290         if(CurrentPackDeposits+OverallDisparityAmounts>CurrentPackDisparityAmounts+OverallRefunded){
291             dsp = CurrentPackDeposits+OverallDisparityAmounts-CurrentPackDisparityAmounts-OverallRefunded;
292         }
293         if(address(this).balance>dsp){
294             userAvailableAmount1=address(this).balance-dsp;
295         }else{
296             userAvailableAmount1=0;
297         }
298         return (users[msg.sender].UserFirstAmt, remainsFromFirstRefunded, users[msg.sender].UserContinued, users[msg.sender].UserTotalAmtDeposit, users[msg.sender].UserTotalAmtWithdrawal, userAvailableAmount, userAvailableAmount1, remainsFromDisparity, depCP, witCP, userCycle, wAmtToCurrentPack, users[msg.sender].UserBuyFirstDate);
299     }
300 
301     function nextPack (uint _currentPackNumber)internal{
302         transferFee();
303         feeTransfered=false;
304         CurrentPackNumber=_currentPackNumber+1;
305         if(_currentPackNumber>0){
306             mint(50000000000000000);
307         }
308         packSettings(CurrentPackNumber);
309     }
310 
311     function restart(bool _rm)internal{
312         if(_rm==true){
313             if(RestartMode==false){
314                 RestartMode=true;
315                 RestartModeDate=now;
316             }else{
317                 if(now>RestartModeDate+14*1 days){
318                     Cycle=Cycle+1;
319                     nextPack(0);
320                     RestartMode=false;
321                 }
322             }
323         }else{
324             if(RestartMode==true){
325                 RestartMode=false;
326                 RestartModeDate=0;
327             }
328         }
329     }
330     
331     function transferFee()internal{
332         if(CurrentPackNumber>2 && feeTransfered==false && RestartMode==false){
333             if(address(this).balance>=CurrentPackFee){
334                 feeTransfered=true;
335                 creatorOwner.transfer(CurrentPackFee);
336             }
337         }
338     }
339 
340     function deposit() public payable{ 
341         require(msg.sender!=0x0 && msg.sender!=0);
342         DepositTemp memory d;
343         d.userAmt=msg.value;
344         d.useraddress=msg.sender;
345         require(d.userAmt<250 * 1 ether);
346         d.availableTokens=balances[address(this)];
347         d.currentPackTokenPriceSellout=CurrentPackTokenPriceSellout;
348         require(d.userAmt<=d.availableTokens.mul(d.currentPackTokenPriceSellout).add(d.availableTokens.mul(d.currentPackTokenPriceSellout).div(10)).add(10*1 finney)); 
349         require(d.userAmt.div(d.currentPackTokenPriceSellout)>0);
350         d.currentPackNumber=CurrentPackNumber;
351         d.currentPackStartDate=CurrentPackStartDate;
352         d.UserBuyTokenPackNum=users[d.useraddress].UserBuyTokenPackNum;
353         d.userBuyFirstDate=users[d.useraddress].UserBuyFirstDate;
354         d.userBuyDate=users[d.useraddress].UserBuyDate;
355         d.userContinued=users[d.useraddress].UserContinued;
356         d.userTotalAmtDepositCurrentPack=users[d.useraddress].UserTotalAmtDepositCurrentPack;
357         d.userTotalAmtDeposit=users[d.useraddress].UserTotalAmtDeposit;
358         if(d.UserBuyTokenPackNum==d.currentPackNumber && d.userBuyDate>=d.currentPackStartDate){
359             require(d.userTotalAmtDepositCurrentPack.add(d.userAmt)<250*1 ether);
360             d.userAmtDepositCurrentPackTRUE=users[d.useraddress].UserAmtDepositCurrentPackTRUE;
361         }else{
362             d.userTotalAmtDepositCurrentPack=0;
363             d.userAmtDepositCurrentPackTRUE=0;
364         }
365         if(users[d.useraddress].UserSellTokenPackNum==d.currentPackNumber && users[d.useraddress].UserSellDate>=d.currentPackStartDate){
366             d.p=users[d.useraddress].UserTotalAmtWithdrawalCurrentPack/20;
367             require(d.userAmt>d.p);
368             d.userAmt=d.userAmt.sub(d.p);
369         }
370         d.UserTokenObtain=d.userAmt/d.currentPackTokenPriceSellout;
371         if(d.UserTokenObtain*d.currentPackTokenPriceSellout<d.userAmt){
372             d.UserTokenObtain=d.UserTokenObtain+1;
373         }
374         if(d.UserTokenObtain>d.availableTokens){
375             d.amtToSend=d.currentPackTokenPriceSellout*(d.UserTokenObtain-d.availableTokens);
376             d.userAmt=d.userAmt.sub(d.amtToSend);
377             d.UserTokenObtain=d.availableTokens;
378         }
379         if(d.userAmt>=100*1 finney){  
380             if(now<=(d.currentPackStartDate+1*1 days)){
381                 d.bonus=d.UserTokenObtain*75/10000+1;
382             }else{
383                 if(now<=(d.currentPackStartDate+2*1 days)){
384                     d.bonus=d.UserTokenObtain*50/10000+1;
385                 }else{
386                     if(now<=(d.currentPackStartDate+3*1 days)){
387                         d.bonus=d.UserTokenObtain*25/10000+1;
388                     }
389                 }
390             }
391         }
392         if(d.userContinued>=4 && now>=(d.userBuyFirstDate+1*1 weeks)){
393             d.bonus=d.bonus+d.UserTokenObtain/100+1;
394         }
395         if(d.bonus>0){
396             d.UserTokenObtain=d.UserTokenObtain.add(d.bonus);
397             if(d.UserTokenObtain>d.availableTokens){
398                 d.userAmtOverloadToSend=d.currentPackTokenPriceSellout*(d.UserTokenObtain-d.availableTokens);
399                 d.bonusAmountRefunded=d.userAmtOverloadToSend;
400                 d.UserTokenObtain=d.availableTokens;
401                 d.amtToSend=d.amtToSend.add(d.userAmtOverloadToSend);
402                 d.bonus=0;
403             }else{
404                 d.bonusAmount=d.bonus*d.currentPackTokenPriceSellout;
405             }
406         }
407         if(d.UserBuyTokenPackNum==0){
408             d.userContinued=1;
409             d.userBuyFirstDate=now;
410             d.userFirstAmt=d.userAmt.add(d.bonusAmount);
411             d.userBuyFirstPack=d.currentPackNumber;
412             d.amtForfirstRefund=d.userFirstAmt*6/10;
413             OverallDisparityAmounts=OverallDisparityAmounts+d.userFirstAmt*7/10;
414             CurrentPackDisparityAmounts=CurrentPackDisparityAmounts+d.userFirstAmt*7/10;
415             d.amtToSend=d.amtToSend.add(d.amtForfirstRefund);
416             d.feeCompensation=d.feeCompensation+2500000000000000;
417             OverallRefunded=OverallRefunded+d.amtForfirstRefund;
418         }else{
419             d.userFirstAmt=users[d.useraddress].UserFirstAmt;
420             d.userBuyFirstPack=users[d.useraddress].UserBuyFirstPack;
421             if(d.UserBuyTokenPackNum==d.currentPackNumber-1){
422                 d.userContinued=d.userContinued+1;
423             }else{
424                 d.userContinued=1;
425             }
426         }
427         d.userAmtToStore=d.userAmt.add(d.bonusAmount);
428         d.userTotalAmtDepositCurrentPack=d.userTotalAmtDepositCurrentPack.add(d.userAmtToStore);
429         d.userTotalAmtDeposit=d.userTotalAmtDeposit.add(d.userAmtToStore);
430         d.userAmtDepositCurrentPackTRUE=d.userAmtDepositCurrentPackTRUE.add(d.userAmtToStore);
431         CurrentPackDeposits=CurrentPackDeposits.add(d.userAmtToStore);
432         OverallDeposits=OverallDeposits.add(d.userAmtToStore);
433         transfer(address(this), d.useraddress, d.UserTokenObtain, false, 0, 0);
434         User storage user=users[d.useraddress];
435         user.UserBuyFirstDate=d.userBuyFirstDate;
436         user.UserBuyFirstPack=d.userBuyFirstPack;
437         user.UserBuyTokenPackNum=d.currentPackNumber;
438         user.UserBuyDate=now;
439         user.UserFirstAmt=d.userFirstAmt;
440         user.UserContinued=d.userContinued;
441         user.UserTotalAmtDepositCurrentPack=d.userTotalAmtDepositCurrentPack;
442         user.UserTotalAmtDeposit=d.userTotalAmtDeposit;
443         user.UserAmtDepositCurrentPackTRUE=d.userAmtDepositCurrentPackTRUE;
444         restart(false);
445         d.feeCompensation=d.feeCompensation+500000000000000;
446         if(balances[address(this)]==0){
447             nextPack(d.currentPackNumber);
448             d.feeCompensation=d.feeCompensation+1000000000000000;
449         }else{
450             CurrentPackTokenAvailablePercent=balances[address(this)]/500000000000000;
451         }
452         if(d.feeCompensation>0 && d.userAmt>d.feeCompensation){
453             d.amtToSend=d.amtToSend.add(d.feeCompensation);
454         }
455         emit Deposit(d.useraddress, d.userAmtToStore, d.amtForfirstRefund, d.bonusAmount, d.bonusAmountRefunded, d.feeCompensation, d.UserTokenObtain, d.bonus, d.currentPackNumber, d.amtToSend);
456         if(d.amtToSend>0){ 
457             d.useraddress.transfer(d.amtToSend);
458         }
459     }
460 
461     function withdraw(uint WithdrawAmount, uint WithdrawTokens, bool AllowToUseDisparity) public {
462         require(msg.sender!=0x0 && msg.sender!=0);
463         require(WithdrawTokens>0 || WithdrawAmount>0);
464         require(WithdrawTokens<=balances[msg.sender]);
465         WithdrawTemp memory w;
466         w.useraddress=msg.sender;
467         w.userFirstAmt=users[w.useraddress].UserFirstAmt;
468         w.userBuyFirstPack=users[w.useraddress].UserBuyFirstPack;
469         w.currentPackNumber=CurrentPackNumber;
470         w.currentPackStartDate=CurrentPackStartDate;
471         w.currentPackTokenPriceSellout=CurrentPackTokenPriceSellout;
472         w.currentPackTokenPriceBuyout=CurrentPackTokenPriceBuyout;
473         w.overallRefunded=OverallRefunded;
474         w.overallDisparityAmounts=OverallDisparityAmounts;
475         w.userTotalAmtWithdrawal=users[w.useraddress].UserTotalAmtWithdrawal;
476         w.userWithdrawalFromFirstRefunded=users[w.useraddress].UserWithdrawalFromFirstRefunded;
477         w.remainsFromFirstRefunded=(w.userFirstAmt*6/10).sub(w.userWithdrawalFromFirstRefunded);
478         w.userWithdrawalFromDisparity=users[w.useraddress].UserWithdrawalFromDisparity;
479         w.remainsFromDisparity=(w.userFirstAmt*7/10).sub(w.userWithdrawalFromDisparity);
480         w.thisBal=address(this).balance;
481         w.currentPackDeposits=CurrentPackDeposits;
482         if(users[w.useraddress].UserBuyTokenPackNum==w.currentPackNumber && users[w.useraddress].UserBuyDate>=w.currentPackStartDate){
483             w.userTotalAmtDepositCurrentPack=users[w.useraddress].UserTotalAmtDepositCurrentPack;
484             w.userAmtDepositCurrentPackTRUE=users[w.useraddress].UserAmtDepositCurrentPackTRUE;
485             w.withdrawAmtToCurrentPack=users[w.useraddress].UserAmtDepositCurrentPackTRUE;
486             w.returnTokenInCurrentPack=true;
487         }else{
488             w.returnTokenInCurrentPack=false;
489         }
490         if(users[w.useraddress].UserSellTokenPackNum==w.currentPackNumber && users[w.useraddress].UserSellDate>=w.currentPackStartDate){
491             w.userTotalAmtWithdrawalCurrentPack=users[w.useraddress].UserTotalAmtWithdrawalCurrentPack;
492         }
493         if(CurrentPackDeposits+OverallDisparityAmounts>CurrentPackDisparityAmounts+OverallRefunded){
494             w.dsp=CurrentPackDeposits+OverallDisparityAmounts-CurrentPackDisparityAmounts-OverallRefunded;
495         }else{
496             w.dsp=0;
497         }
498         w.userAvailableAmount=(balances[w.useraddress]-(w.withdrawAmtToCurrentPack/w.currentPackTokenPriceSellout))*w.currentPackTokenPriceBuyout+w.withdrawAmtToCurrentPack;
499         if(w.thisBal>=w.dsp){
500             if(w.userAvailableAmount>w.thisBal-w.dsp){
501                 if(w.currentPackNumber==w.userBuyFirstPack){
502                     if(w.userAvailableAmount>w.thisBal-w.dsp+w.userAmtDepositCurrentPackTRUE){
503                         w.userAvailableAmount=w.thisBal-w.dsp+w.userAmtDepositCurrentPackTRUE;
504                     }
505                 }else{
506                     if(w.userAvailableAmount>w.thisBal-w.dsp+w.remainsFromDisparity+w.userAmtDepositCurrentPackTRUE){
507                         w.userAvailableAmount=w.thisBal-w.dsp+w.remainsFromDisparity+w.userAmtDepositCurrentPackTRUE;
508                     }
509                 }
510             }
511         }else{
512             if(w.userAmtDepositCurrentPackTRUE>w.remainsFromDisparity){
513                 if(w.userAvailableAmount>w.userAmtDepositCurrentPackTRUE){
514                     w.userAvailableAmount=w.userAmtDepositCurrentPackTRUE;
515                 }
516             }else{
517                 if(w.userAvailableAmount>w.remainsFromDisparity){
518                     w.userAvailableAmount=w.remainsFromDisparity;
519                 }
520             }
521             if(w.userAvailableAmount>w.thisBal+w.remainsFromFirstRefunded){
522                 w.userAvailableAmount=w.thisBal+w.remainsFromFirstRefunded;
523             }
524             if(w.currentPackNumber>2){
525                 w.ra=true;
526             }
527         }
528         if(WithdrawTokens>0 && WithdrawAmount==0){
529             w.UserTokensReturn=WithdrawTokens;
530             if(w.returnTokenInCurrentPack==true){
531                 w.UserTokensReturnToCurrentPack=w.withdrawAmtToCurrentPack.div(w.currentPackTokenPriceSellout);
532                 if(w.UserTokensReturn>w.UserTokensReturnToCurrentPack){
533                     w.UserTokensReturnAboveCurrentPack=w.UserTokensReturn.sub(w.UserTokensReturnToCurrentPack);
534                     w.withdrawAmtAboveCurrentPack=w.UserTokensReturnAboveCurrentPack.mul(w.currentPackTokenPriceBuyout);
535                 }else{
536                     w.withdrawAmtToCurrentPack=w.UserTokensReturn.mul(w.currentPackTokenPriceSellout);
537                     w.UserTokensReturnToCurrentPack=w.UserTokensReturn;
538                     w.withdrawAmtAboveCurrentPack=0;
539                     w.UserTokensReturnAboveCurrentPack=0;
540                 }
541             }else{
542                 w.withdrawAmtToCurrentPack=0;
543                 w.UserTokensReturnToCurrentPack=0;
544                 w.UserTokensReturnAboveCurrentPack=w.UserTokensReturn;
545                 w.withdrawAmtAboveCurrentPack=w.UserTokensReturnAboveCurrentPack.mul(w.currentPackTokenPriceBuyout);
546             }
547             w.withdrawAmt=w.withdrawAmtToCurrentPack.add(w.withdrawAmtAboveCurrentPack);
548         }else{
549             w.withdrawAmt=WithdrawAmount;
550         }
551         if(w.withdrawAmt>w.userAvailableAmount){
552             w.withdrawAmt=w.userAvailableAmount;
553         }
554         if(w.remainsFromDisparity>0){
555            if(w.userAvailableAmount>=w.remainsFromDisparity){
556                 w.userAvailableAmount=w.userAvailableAmount-w.remainsFromDisparity;
557             }else{
558                 w.userAvailableAmount=0;
559             }
560         }
561         if(w.userAvailableAmount<100){
562             w.userAvailableAmount=0;
563         }
564         if(AllowToUseDisparity==false && w.remainsFromDisparity>0){
565             if(w.withdrawAmt>w.userAvailableAmount){
566                 w.withdrawAmt=w.userAvailableAmount;
567             }
568         }
569         if(w.returnTokenInCurrentPack==true){
570             w.UserTokensReturnToCurrentPack=w.withdrawAmtToCurrentPack.div(w.currentPackTokenPriceSellout);
571             if(w.withdrawAmt>w.withdrawAmtToCurrentPack){ 
572                 w.withdrawAmtAboveCurrentPack=w.withdrawAmt.sub(w.withdrawAmtToCurrentPack);
573                 w.UserTokensReturnAboveCurrentPack=w.withdrawAmtAboveCurrentPack.div(w.currentPackTokenPriceBuyout);
574             }else{
575                 w.withdrawAmtToCurrentPack=w.withdrawAmt;
576                 w.UserTokensReturnToCurrentPack=w.withdrawAmtToCurrentPack.div(w.currentPackTokenPriceSellout);
577                 w.withdrawAmtAboveCurrentPack=0;
578                 w.UserTokensReturnAboveCurrentPack=0;
579             }
580         }else{
581             w.withdrawAmtToCurrentPack=0;
582             w.UserTokensReturnToCurrentPack=0;
583             w.withdrawAmtAboveCurrentPack=w.withdrawAmt;
584             w.UserTokensReturnAboveCurrentPack=w.withdrawAmtAboveCurrentPack.div(w.currentPackTokenPriceBuyout);
585         }
586         if(AllowToUseDisparity==true && w.remainsFromDisparity>0){
587             if(w.withdrawAmt>w.userAvailableAmount){
588                 w.useFromDisparity=w.withdrawAmt-w.userAvailableAmount;
589                 if(w.remainsFromDisparity<w.useFromDisparity){
590                     w.useFromDisparity=w.remainsFromDisparity;
591                 }
592                 w.userWithdrawalFromDisparity=w.userWithdrawalFromDisparity.add(w.useFromDisparity);
593                 if(w.remainsFromFirstRefunded>0){
594                     if(w.useFromDisparity>w.remainsFromDisparity-w.remainsFromFirstRefunded){
595                         w.useFromFirstRefunded=w.useFromDisparity+w.remainsFromFirstRefunded-w.remainsFromDisparity;
596                         if (w.remainsFromFirstRefunded<w.useFromFirstRefunded){
597                             w.useFromFirstRefunded=w.remainsFromFirstRefunded;
598                         }
599                         w.userWithdrawalFromFirstRefunded=w.userWithdrawalFromFirstRefunded+w.useFromFirstRefunded;
600                         w.withdrawAmt=w.withdrawAmt.sub(w.useFromFirstRefunded);
601                     }
602                 }
603             }
604         }
605         if(CurrentPackTokenAvailablePercent<10){
606             w.bonus=(w.withdrawAmt+w.useFromFirstRefunded)/100;
607             w.bonusToSend=w.bonus;
608         }
609         if(w.thisBal>w.dsp && w.bonus>0){
610             if(w.withdrawAmt+w.bonus>w.thisBal-w.dsp){
611                 w.bonusToSend=0;
612                 w.diff=w.bonus;
613                 if(w.UserTokensReturnAboveCurrentPack>0){
614                     w.bonusTokensReturnDecrease=w.diff/w.currentPackTokenPriceBuyout;
615                     if(w.UserTokensReturnAboveCurrentPack>=w.bonusTokensReturnDecrease){
616                         w.UserTokensReturnAboveCurrentPack=w.UserTokensReturnAboveCurrentPack-w.bonusTokensReturnDecrease;
617                         
618                     }else{
619                         w.diff=w.bonusTokensReturnDecrease-w.UserTokensReturnAboveCurrentPack;
620                         w.UserTokensReturnAboveCurrentPack=0;
621                         w.bonusTokensReturnDecrease=w.diff*w.currentPackTokenPriceBuyout/w.currentPackTokenPriceSellout;
622                         w.UserTokensReturnToCurrentPack=w.UserTokensReturnToCurrentPack-w.bonusTokensReturnDecrease;
623                     }
624                 }else{
625                     w.bonusTokensReturnDecrease=w.diff/w.currentPackTokenPriceSellout;
626                     if(w.UserTokensReturnToCurrentPack>=w.bonusTokensReturnDecrease){
627                         w.UserTokensReturnToCurrentPack=w.UserTokensReturnToCurrentPack-w.bonusTokensReturnDecrease;
628                     }
629                 }
630             }
631         }
632         if(w.thisBal<=w.dsp){
633             if(w.bonus>0){
634                 w.bonusToSend=0;
635                 w.diff=w.bonus;
636                 if(w.UserTokensReturnAboveCurrentPack>0){
637                     w.bonusTokensReturnDecrease=w.diff/w.currentPackTokenPriceBuyout;
638                     if(w.UserTokensReturnAboveCurrentPack>=w.bonusTokensReturnDecrease){
639                         w.UserTokensReturnAboveCurrentPack=w.UserTokensReturnAboveCurrentPack-w.bonusTokensReturnDecrease;
640                     }else{
641                         w.diff=w.bonusTokensReturnDecrease-w.UserTokensReturnAboveCurrentPack;
642                         w.UserTokensReturnAboveCurrentPack=0;
643                         w.bonusTokensReturnDecrease=w.diff*w.currentPackTokenPriceBuyout/w.currentPackTokenPriceSellout;
644                         w.UserTokensReturnToCurrentPack=w.UserTokensReturnToCurrentPack-w.bonusTokensReturnDecrease;
645                     }
646                 }else{
647                     w.bonusTokensReturnDecrease=w.diff/w.currentPackTokenPriceSellout;
648                     if(w.UserTokensReturnToCurrentPack>=w.bonusTokensReturnDecrease){
649                         w.UserTokensReturnToCurrentPack=w.UserTokensReturnToCurrentPack-w.bonusTokensReturnDecrease;
650                     }
651                 }
652             }
653             if(w.withdrawAmt>w.thisBal){
654                 w.diff=w.withdrawAmt+100-w.thisBal;
655                 if(w.UserTokensReturnAboveCurrentPack>0){
656                     w.TokensReturnDecrease=w.diff/w.currentPackTokenPriceBuyout;
657                     if(w.UserTokensReturnAboveCurrentPack>=w.TokensReturnDecrease){
658                         w.UserTokensReturnAboveCurrentPack=w.UserTokensReturnAboveCurrentPack-w.TokensReturnDecrease;
659                         w.withdrawAmtAboveCurrentPack=w.UserTokensReturnAboveCurrentPack*w.currentPackTokenPriceBuyout;
660                     }else{
661                         w.diff=w.TokensReturnDecrease-w.UserTokensReturnAboveCurrentPack;
662                         w.UserTokensReturnAboveCurrentPack=0;
663                         w.TokensReturnDecrease=w.diff*w.currentPackTokenPriceBuyout/w.currentPackTokenPriceSellout;
664                         w.UserTokensReturnToCurrentPack=w.UserTokensReturnToCurrentPack-w.TokensReturnDecrease;
665                     }
666                 }else{
667                     w.TokensReturnDecrease=w.diff/w.currentPackTokenPriceSellout;
668                     if(w.UserTokensReturnToCurrentPack>=w.TokensReturnDecrease){
669                         w.UserTokensReturnToCurrentPack=w.UserTokensReturnToCurrentPack-w.TokensReturnDecrease;
670                         w.withdrawAmtToCurrentPack=w.UserTokensReturnToCurrentPack*w.currentPackTokenPriceSellout;
671                     }
672                 }
673                 w.withdrawAmt=w.withdrawAmtToCurrentPack+w.withdrawAmtAboveCurrentPack;
674                 if(w.withdrawAmt>=w.useFromFirstRefunded){
675                     w.withdrawAmt=w.withdrawAmt-w.useFromFirstRefunded;
676                 }else{
677                     w.diff=w.useFromFirstRefunded-w.withdrawAmt;
678                     w.withdrawAmt=0;
679                     w.useFromFirstRefunded=w.useFromFirstRefunded-w.diff;
680                 }
681                 if(w.withdrawAmt>w.thisBal){
682                     w.withdrawAmt=w.thisBal;
683                 }
684             }
685         }
686         User storage user=users[w.useraddress];
687         if(w.userAmtDepositCurrentPackTRUE>w.withdrawAmtToCurrentPack){
688             user.UserAmtDepositCurrentPackTRUE=w.userAmtDepositCurrentPackTRUE-w.withdrawAmtToCurrentPack;
689         }else{
690             user.UserAmtDepositCurrentPackTRUE=0;
691         }
692         if(w.overallDisparityAmounts>w.useFromDisparity){
693             OverallDisparityAmounts=w.overallDisparityAmounts-w.useFromDisparity;
694         }else{
695             OverallDisparityAmounts=0;
696         }
697         if(w.userBuyFirstPack==w.currentPackNumber && users[w.useraddress].UserBuyFirstDate>=w.currentPackStartDate){
698             if(CurrentPackDisparityAmounts>w.useFromDisparity){
699                 CurrentPackDisparityAmounts=CurrentPackDisparityAmounts-w.useFromDisparity;
700             }else{
701                 CurrentPackDisparityAmounts=0;
702             }
703         }
704         if(w.overallRefunded>w.useFromFirstRefunded){
705             OverallRefunded=w.overallRefunded-w.useFromFirstRefunded;
706         }else{
707             OverallRefunded=0;
708         }
709         if(w.currentPackDeposits>w.withdrawAmtToCurrentPack){
710             CurrentPackDeposits=w.currentPackDeposits-w.withdrawAmtToCurrentPack;
711         }else{
712             CurrentPackDeposits=0;
713         }
714         w.UserTokensReturn=w.UserTokensReturnToCurrentPack+w.UserTokensReturnAboveCurrentPack;
715         w.wAtoStore=w.withdrawAmt+w.useFromFirstRefunded+w.bonusToSend;
716         w.userTotalAmtWithdrawal=w.userTotalAmtWithdrawal+w.wAtoStore;
717         w.userTotalAmtWithdrawalCurrentPack=w.userTotalAmtWithdrawalCurrentPack+w.wAtoStore;
718         OverallWithdrawals=OverallWithdrawals+w.wAtoStore;
719         user.UserSellTokenPackNum=w.currentPackNumber;
720         user.UserSellDate=now;
721         user.UserTotalAmtWithdrawal=w.userTotalAmtWithdrawal;
722         user.UserTotalAmtWithdrawalCurrentPack=w.userTotalAmtWithdrawalCurrentPack;
723         user.UserWithdrawalFromFirstRefunded=w.userWithdrawalFromFirstRefunded;
724         user.UserWithdrawalFromDisparity=w.userWithdrawalFromDisparity;
725         emit Withdraw(w.useraddress, w.wAtoStore, w.useFromFirstRefunded, w.bonus, w.bonusToSend, w.currentPackNumber, w.UserTokensReturn, w.UserTokensReturnToCurrentPack, w.bonusTokensReturnDecrease, w.TokensReturnDecrease);
726         if (w.UserTokensReturn==balances[w.useraddress]+1){
727             w.UserTokensReturn=balances[w.useraddress];
728             if (w.UserTokensReturnToCurrentPack==balances[w.useraddress]+1){
729                 w.UserTokensReturnToCurrentPack=balances[w.useraddress];
730             }
731             if (w.UserTokensReturnAboveCurrentPack==balances[w.useraddress]+1){
732                 w.UserTokensReturnAboveCurrentPack=balances[w.useraddress];
733             }
734         }
735         transfer(w.useraddress, address(this), w.UserTokensReturn, w.returnTokenInCurrentPack, w.UserTokensReturnToCurrentPack, w.UserTokensReturnAboveCurrentPack);
736         CurrentPackTokenAvailablePercent=balances[address(this)]/500000000000000;
737         if(w.ra==true){
738             restart(true);
739         }
740         if(w.withdrawAmt+w.bonus>0){
741             w.useraddress.transfer(w.withdrawAmt+w.bonusToSend);
742         }
743     }
744 
745     function transfer(address _from, address _to, uint _value, bool _rttcp, uint _rtcp, uint _racp) internal returns (bool success) {
746         balances[_from]=balances[_from].sub(_value); 
747         if(_to==address(this)){ 
748             if(_rttcp==true){
749                 balances[_to]=balances[_to].add(_rtcp);
750             }else{
751                 balances[_to]=balances[_to];
752             }
753             totalSupply=totalSupply.sub(_racp);
754         }else{
755             balances[_to]=balances[_to].add(_value);
756         }
757         emit Transfer(_from, _to, _value); 
758         return true;
759     }
760 
761     function balanceOf(address tokenOwner) public constant returns (uint balance) {
762         return balances[tokenOwner];
763     }
764 
765     function mint(uint _value) internal returns (bool) {
766         balances[address(this)]=balances[address(this)].add(_value);
767         totalSupply=totalSupply.add(_value);
768         return true;
769     }
770     
771     event Deposit(address indexed addr, uint, uint, uint, uint, uint, uint, uint, uint, uint);
772     event Withdraw(address indexed addr, uint, uint, uint, uint, uint, uint, uint, uint, uint);
773     event Transfer(address indexed _from, address indexed _to, uint _value);
774     event NextPack(uint indexed CurrentPackTokenPriceSellout, uint indexed CurrentPackTokenPriceBuyout);
775 }