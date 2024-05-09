1 pragma solidity ^0.4.24;
2 
3 
4 contract Ceil {
5     
6     
7     function ceil(uint a, uint m) constant returns (uint ) {
8         return ((a + m - 1) / m) * m;
9     }
10     
11     
12 }
13 
14 
15 contract QuickSort {
16     
17     
18     function sort(uint[] data) public constant returns(uint[]) {
19        quickSort(data, int(0), int(data.length - 1));
20        return data;
21     }
22     
23     
24     function quickSort(uint[] memory arr, int left, int right) internal{
25         int i = left;
26         int j = right;
27         if(i==j) return;
28         uint pivot = arr[uint(left + (right - left) / 2)];
29         while (i <= j) {
30             while (arr[uint(i)] < pivot) i++;
31             while (pivot < arr[uint(j)]) j--;
32             if (i <= j) {
33                 (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
34                 i++;
35                 j--;
36             }
37         }
38         if (left < j)
39             quickSort(arr, left, j);
40         if (i < right)
41             quickSort(arr, i, right);
42     }
43     
44     
45 }
46 
47 
48 contract Abssub{
49     
50     
51     function AbsSub(uint x,uint y) constant returns(uint ){
52         if (x>=y){
53             return(x-y);
54         }else{
55             return(y-x);
56         }
57     }
58     
59     
60 }
61 
62 
63 contract Rounding{
64     
65     
66     function rounding(uint x) constant returns(uint ){
67         if (x-(x/10)*10>=5){
68             return(x/10+1);
69         }else{
70             return(x/10);
71         }
72     }
73     
74     
75 }
76 
77 
78 contract FiveElementsAdministration is QuickSort,Ceil,Abssub,Rounding{
79     
80     
81     address[] Users;
82     uint[5][] Guesses;
83     uint[] EntryPaid;
84     uint[5] Weights;
85     uint[5] Ans;
86     uint[5] AvgGuesses;
87     uint[] ERaw;
88     // Raw Error Datas
89     uint[] Error;
90     uint[] EST;
91     // Error Datas Sorted and Trimmed
92     address[] Winners;
93     uint[] WinEntryPaid;
94     uint MinEntryPrice;
95     uint FeePM;
96     // Fee Per Million
97     uint ExpirationTime;
98     uint Period;
99     uint Round;
100     uint WOCC;
101     bool Frozen;
102     address constant private Admin=0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
103     address constant private Adam=0x9640a35e5345CB0639C4DD0593567F9334FfeB8a;
104     address constant private Tummy=0x820090F4D39a9585a327cc39ba483f8fE7a9DA84;
105     address constant private Willy=0xA4757a60d41Ff94652104e4BCdB2936591c74d1D;
106     address constant private Nicky=0x89473CD97F49E6d991B68e880f4162e2CBaC3561;
107     address constant private Artem=0xA7e8AFa092FAa27F06942480D28edE6fE73E5F88;
108     address FiveElementsContractAddress;
109     
110     
111     //event ResultsAndPayouts(uint RealPriceA,uint RealPriceB,uint RealPriceC,uint RealPriceD,uint RealPriceE,uint TotalWinners,uint TotalParticipants,uint PayoutsPerEtherEntry,uint TotalPrizePool,uint AverageEntryPaid);
112     
113     
114     event ResultsAudit(uint RealPriceA,uint RealPriceB,uint RealPriceC,uint RealPriceD,uint RealPriceE);
115     
116     
117     event PayoutInfo(uint TotalWinners,uint TotalParticipants,uint PayoutsPerEtherEntry,uint TotalPrizePool,uint AverageEntryPaid);
118     
119     
120     event NoPlayers();
121     
122     
123     event Extension(uint extension,uint newExpirationTime);
124     
125     
126     event Initialisation(uint EntryPrice,uint FeePerMillion,uint submissionPeriod,uint expirationTime,uint WA,uint WB,uint WC,uint WD,uint WE);
127     
128     
129     event UserBetAmount(address indexed User,uint Amount);
130     
131     
132     event RoundNumber(uint round);
133     
134     
135     event FiveElementsAddressSet(address indexed FiveElementsAddress);
136     
137     
138     event UserJoined(address indexed User,address indexed AddedBy,uint Value,uint GuessA,uint GuessB,uint GuessC,uint GuessD,uint GuessE);
139     
140     
141     event BetAmountUpdated(address indexed User,address indexed UpdatedBy,uint BetMoreAmount,uint TotalBetAmount);
142     
143     
144     event LiveRanking(address indexed User,uint Rank,uint TotalPlayers,uint TotalEntryPaid);
145     
146     
147     event MinEntryInWei(uint MinEntryValue);
148     
149     
150     event WeightsSet(uint WA,uint WB,uint WC,uint WD,uint WE);
151     
152     
153     event ContractFrozen(string Status);
154     
155     
156     event ContractDefrosted(string Status);
157     
158     
159     event FundsEjected(uint TotalEjected);
160     
161     
162     event UserQuitGame(address indexed User,address indexed FunctionActivatedBy,uint TotalRefundAmount);
163     
164     
165     event UserRefundAmount(address indexed User,address indexed FunctionActivatedBy,uint RefundAmount,uint NewEntryBalance);
166     
167     
168     event Volume(uint PrizePool,uint TotalPlayers);
169     
170     
171     event CurrentFeePerMillion(uint FeePerMillion);
172     
173     
174     event AvgOfAllGuesses(uint AvgGuessA,uint AvgGuessB,uint AvgGuessC,uint AvgGuessD,uint AvgGuessE,uint ActivationCount);
175     
176     
177     event ReceivedFunds(address indexed Sender,uint Value);
178     
179     
180     function Results(uint RealPriceA,uint RealPriceB,uint RealPriceC,uint RealPriceD,uint RealPriceE,bool Freeze){
181         require(msg.sender==Admin || msg.sender==Adam);
182         uint Bal=address(this).balance;
183         Ans[0]=RealPriceA;
184         Ans[1]=RealPriceB;
185         Ans[2]=RealPriceC;
186         Ans[3]=RealPriceD;
187         Ans[4]=RealPriceE;
188         require(Ans[0]>0 && Ans[1]>0 && Ans[2]>0 && Ans[3]>0 && Ans[4]>0);
189         uint L=Users.length;
190         if (L>0){
191             for (uint k=0;k<L;k++){
192                 uint E=0;
193                 for (uint j=0;j<5;j++){
194                     E=E+1000000*Weights[j]*AbsSub(Guesses[k][j],Ans[j])/Ans[j];
195                 }
196                 ERaw.push(E);
197             }
198             Error=sort(ERaw);
199             uint store=Error[L-1]+1;
200         for (k=0;k<L;k++){
201             if (store!=Error[k]){
202                 EST.push(Error[k]);
203                 store=Error[k];
204             }
205         }
206         uint M=EST[ceil(5*(EST.length),10)/10-1];
207         uint Sum=0;
208         for (k=0;k<L;k++){
209             if (ERaw[k]<=M){
210                 Winners.push(Users[k]);
211                 WinEntryPaid.push(EntryPaid[k]);
212                 Sum=Sum+EntryPaid[k];
213             }
214         }
215         uint WL=Winners.length;
216         for (k=0;k<WL;k++){
217             uint I=0;
218             while (I<L&&Winners[k]!=Users[I]){
219                 I=I+1;
220             }
221             Users[I].transfer(EntryPaid[I]*Bal*(1000000-FeePM)/(1000000*Sum));
222         }
223         for (k=0;k<L;k++){
224             for (j=0;j<5;j++){
225                 AvgGuesses[j]=AvgGuesses[j]+Guesses[k][j];
226             }
227         }
228         for (j=0;j<5;j++){
229             AvgGuesses[j]=rounding(10*AvgGuesses[j]/L);
230         }
231         emit AvgOfAllGuesses(AvgGuesses[0],AvgGuesses[1],AvgGuesses[2],AvgGuesses[3],AvgGuesses[4],WOCC);
232         //emit ResultsAndPayouts(uint RealPriceA,uint RealPriceB,uint RealPriceC,uint RealPriceD,uint RealPriceE,Winners.length,L,Bal/Sum,Bal,Bal/L);
233         emit ResultsAudit(Ans[0],Ans[1],Ans[2],Ans[3],Ans[4]);
234         emit PayoutInfo(Winners.length,L,Bal/Sum,Bal,Bal/L);
235         }else{
236         emit NoPlayers();
237         emit ResultsAudit(Ans[0],Ans[1],Ans[2],Ans[3],Ans[4]);
238         }
239         Frozen=Freeze;
240         Round=Round+1;
241         ExpirationTime=now+Period;
242         Adam.transfer(address(this).balance/2);
243         Admin.transfer(address(this).balance);
244         delete Users;
245         delete Guesses;
246         delete EntryPaid;
247         delete AvgGuesses;
248         delete ERaw;
249         delete Error;
250         delete EST;
251         delete Winners;
252         delete WinEntryPaid;
253         delete WOCC;
254     }
255     
256     
257     function SetExtension(uint extension){
258         require(msg.sender==Admin || msg.sender==Adam);
259         ExpirationTime=ExpirationTime+extension;
260         emit Extension(extension,ExpirationTime);
261     }
262     
263     
264     function Initialise(uint EntryPrice,uint FeePerMillion,uint SetSubmissionPeriod,uint WA,uint WB,uint WC,uint WD,uint WE,bool FirstRound){
265         require(msg.sender==Admin || msg.sender==Adam);
266         MinEntryPrice=EntryPrice;
267         FeePM=FeePerMillion;
268         Period=SetSubmissionPeriod;
269         ExpirationTime=now+Period;
270         Weights[0]=WA;
271         Weights[1]=WB;
272         Weights[2]=WC;
273         Weights[3]=WD;
274         Weights[4]=WE;
275         if (FirstRound==true){
276             Round=1;
277         }
278         Frozen=false;
279         emit Initialisation(EntryPrice,FeePerMillion,SetSubmissionPeriod,ExpirationTime,WA,WB,WC,WD,WE);
280         emit RoundNumber(Round);
281     }
282     
283     
284     function GetBetAmount(address User)public returns(uint Amount){
285         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
286         uint L=Users.length;
287         uint k=0;
288         while (k<L&&User!=Users[k]){
289             k=k+1;
290         }
291         if (k<L){
292             Amount=EntryPaid[k];
293         }else{
294             Amount=0;
295         }
296         emit UserBetAmount(User,Amount);
297     }
298     
299     
300     function GetRoundNumber()public returns(uint round){
301         round=Round;
302         emit RoundNumber(round);
303     }
304     
305     
306     function SetFiveElementsAddress(address ContractAddress){
307         require(msg.sender==Admin || msg.sender==Adam);
308         FiveElementsContractAddress=ContractAddress;
309         emit FiveElementsAddressSet(ContractAddress);
310     }
311     
312     
313     function UserJoin(address User,uint Value,uint GuessA,uint GuessB,uint GuessC,uint GuessD,uint GuessE){
314         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
315         require(Frozen==false);
316         require(Value>0);
317         require(now<=ExpirationTime || msg.sender==Admin || msg.sender==Adam);
318         uint L=Users.length;
319         uint k=0;
320         while (k<L&&User!=Users[k]){
321             k=k+1;
322         }
323         require(k>=L);
324         Users.push(User);
325         EntryPaid.push(Value);
326         Guesses.push([GuessA,GuessB,GuessC,GuessD,GuessE]);
327         emit UserJoined(User,msg.sender,Value,GuessA,GuessB,GuessC,GuessD,GuessE);
328     }
329     
330     
331     function UpdateBetAmount(address User,uint Value){
332         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
333         require(Frozen==false);
334         require(Value>0);
335         require(now<=ExpirationTime+14400 || msg.sender==Admin || msg.sender==Adam);
336         uint L=Users.length;
337         uint k=0;
338         while (k<L&&User!=Users[k]){
339             k=k+1;
340         }
341         require(k<L);
342         EntryPaid[k]=EntryPaid[k]+Value;
343         emit BetAmountUpdated(User,msg.sender,Value,EntryPaid[k]);
344     }
345     
346     
347     function GetCurrentRank(address User,uint RealPriceA,uint RealPriceB,uint RealPriceC,uint RealPriceD,uint RealPriceE)public returns(uint Rank,uint TotalPlayers){
348         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
349         Ans[0]=RealPriceA;
350         Ans[1]=RealPriceB;
351         Ans[2]=RealPriceC;
352         Ans[3]=RealPriceD;
353         Ans[4]=RealPriceE;
354         require(Ans[0]>0 && Ans[1]>0 && Ans[2]>0 && Ans[3]>0 && Ans[4]>0);
355         uint L=Users.length;
356         require(L>0);
357         for (uint k=0;k<L;k++){
358                 uint E=0;
359                 for (uint j=0;j<5;j++){
360                     E=E+1000000*Weights[j]*AbsSub(Guesses[k][j],Ans[j])/Ans[j];
361                 }
362                 ERaw.push(E);
363             }
364             Error=sort(ERaw);
365             uint store=Error[L-1]+1;
366         for (k=0;k<L;k++){
367             if (store!=Error[k]){
368                 EST.push(Error[k]);
369                 store=Error[k];
370             }
371         }
372         k=0;
373         while (k<L&&User!=Users[k]){
374             k=k+1;
375         }
376         require(k<L);
377         uint TP=EST.length;
378         j=0;
379         while (ERaw[k]>=EST[j]){
380             j=j+1;
381         }
382         TotalPlayers=TP;
383         Rank=j;
384         delete ERaw;
385         delete Error;
386         delete EST;
387         emit LiveRanking(User,Rank,TotalPlayers,EntryPaid[k]);
388     }
389     
390     
391     function GetMinEntry()public returns(uint MinEntry){
392         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
393         MinEntry=MinEntryPrice;
394         emit MinEntryInWei(MinEntry);
395     }
396     
397     
398     function SetWeights(uint WA,uint WB,uint WC,uint WD,uint WE){
399         require(msg.sender==Admin || msg.sender==Adam);
400         Weights[0]=WA;
401         Weights[1]=WB;
402         Weights[2]=WC;
403         Weights[3]=WD;
404         Weights[4]=WE;
405         emit WeightsSet(WA,WB,WC,WD,WE);
406     }
407     
408     
409     function FreezeContract(){
410         require(msg.sender==Admin || msg.sender==Adam);
411         require(Frozen==false);
412         Frozen=true;
413         emit ContractFrozen("Frozen");
414     }
415     
416     
417     function UnfreezeContract(){
418         require(msg.sender==Admin || msg.sender==Adam);
419         require(Frozen==true);
420         Frozen=false;
421         emit ContractDefrosted("Defrosted");
422     }
423     
424     
425     function FreezeContractAndEjectFunds(){
426         require(msg.sender==Admin || msg.sender==Adam);
427         Frozen=true;
428         uint Bal=address(this).balance;
429         uint L=Users.length;
430         for (uint k=0;k<L;k++){
431             Users[k].transfer(EntryPaid[k]);
432         }
433         emit ContractFrozen("Frozen");
434         emit FundsEjected(Bal);
435         delete Users;
436         delete Guesses;
437         delete EntryPaid;
438     }
439     
440     
441     function QuitAndRefund(address User){
442         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
443         require(now<=ExpirationTime || msg.sender==Admin || msg.sender==Adam);
444         uint L=Users.length;
445         uint k=0;
446         while (k<L&&User!=Users[k]){
447             k=k+1;
448         }
449         require(k<L);
450         if (User==Admin || User==Adam){
451             User.transfer(EntryPaid[k]);
452         }else{
453         User.transfer(EntryPaid[k]*(1000000-FeePM)/1000000);
454         Admin.transfer(EntryPaid[k]*FeePM/2000000);
455         Adam.transfer(EntryPaid[k]*FeePM/2000000);
456         }
457         emit UserQuitGame(User,msg.sender,EntryPaid[k]);
458         delete Users[k];
459         delete Guesses[k];
460         delete EntryPaid[k];
461     }
462     
463     
464     function RefundAmount(address User,uint Amount){
465         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
466         require(now<=ExpirationTime || msg.sender==Admin || msg.sender==Adam);
467         uint L=Users.length;
468         uint k=0;
469         while (k<L&&User!=Users[k]){
470             k=k+1;
471         }
472         require(k<L);
473         require(EntryPaid[k]>Amount && ((EntryPaid[k]-Amount)>=MinEntryPrice || User==Admin || User==Adam || User==Tummy || User==Willy || User==Nicky || User==Artem));
474         if (User==Admin || User==Adam){
475             User.transfer(Amount);
476         }else{
477         User.transfer(Amount*(1000000-FeePM)/1000000);
478         Admin.transfer(Amount*FeePM/2000000);
479         Adam.transfer(Amount*FeePM/2000000);
480         }
481         EntryPaid[k]=EntryPaid[k]-Amount;
482         emit UserRefundAmount(User,msg.sender,Amount,EntryPaid[k]);
483     }
484     
485     
486     function GetBetVolume(){
487         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
488         uint L=Users.length;
489         uint Bal=address(this).balance;
490         emit Volume(Bal,L);
491     }
492     
493     
494     function GetFeePerMillion()public returns(uint FeePerMillion){
495         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
496         FeePerMillion=FeePM;
497         emit CurrentFeePerMillion(FeePerMillion);
498     }
499     
500     
501     function AverageOfAllGuesses()public returns(uint[5] ){
502         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
503         uint L=Users.length;
504         require(L>0 || msg.sender==Admin || msg.sender==Adam);
505         if (L>0){
506         require((now<=ExpirationTime && now+7200>=ExpirationTime) || msg.sender==Admin || msg.sender==Adam);
507         require(WOCC<=5 || msg.sender==Admin || msg.sender==Adam);
508         for (uint k=0;k<L;k++){
509             for (uint j=0;j<5;j++){
510                 AvgGuesses[j]=AvgGuesses[j]+Guesses[k][j];
511             }
512         }
513         for (j=0;j<5;j++){
514             AvgGuesses[j]=rounding(10*AvgGuesses[j]/L);
515         }
516         if (msg.sender==Admin || msg.sender==Adam){
517         }else{
518         WOCC=WOCC+1;
519         }
520         return AvgGuesses;
521         emit AvgOfAllGuesses(AvgGuesses[0],AvgGuesses[1],AvgGuesses[2],AvgGuesses[3],AvgGuesses[4],WOCC);
522         delete AvgGuesses;
523         }else{
524         emit NoPlayers();
525         }
526     }
527     
528     
529     function GetWisdomOfCrowdsActivationCount()public returns(uint ){
530         require(msg.sender==Admin || msg.sender==Adam || msg.sender==FiveElementsContractAddress);
531         return(WOCC);
532     }
533     
534     
535     function () public payable{
536         emit ReceivedFunds(msg.sender,msg.value);
537     }
538     
539     
540 }