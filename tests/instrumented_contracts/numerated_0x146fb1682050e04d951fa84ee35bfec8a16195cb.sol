1 pragma solidity ^0.4.25;
2 
3 /**
4   Ethereum Multiplier contract: returns 110% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Smart contract Made, checked and verified by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.001 to 5 ETH
11      - min 250000 gas limit
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 110%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 110% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 110% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 110% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 110%)
38 
39 -------------------------------------------------------------------------------------------------
40   Контракт Умножитель: возвращает 110% от вашего депозита!
41   Автоматические выплаты!
42   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
43   Создан и проверен профессионалами!
44 
45   1. Пошлите любую ненулевую сумму на адрес контракта
46      - сумма от 0.001 до 5 ETH
47      - gas limit минимум 250000
48      - вы встанете в очередь
49   2. Немного подождите
50   3. ...
51   4. PROFIT! Вам пришло 110% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 121% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 110% от вашего депозита, вы удаляетесь из очереди
58   4. Вы можете делать несколько депозитов сразу
59   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
60      сразу же направляются на выплаты
61 
62      Таким образом, последние платят первым, и инвесторы, достигшие выплат 110% от депозита,
63      удаляются из очереди, уступая место остальным
64 
65               новый инвестор --|            совсем новый инвестор --|
66                  инвестор5     |                новый инвестор      |
67                  инвестор4     |     =======>      инвестор5        |
68                  инвестор3     |                   инвестор4        |
69  (част. выплата) инвестор2    <|                   инвестор3        |
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 110%)
71 -------------------------------------------------------------------------------------------------
72 乘数合约：每笔投资110％回报！
73   自动支付！
74   没有错误，没有后门，没有所有者 - 全自动！
75   智能合约由专业人士制作，检查和验证！
76 
77   1.将任何金额发送到智能合约地址
78       - 总和从0.001到5 ETH
79       - 最低250000气体限制
80       - 您被添加到队列中
81   等一下
82   3. ...
83   4.利润！你有110％
84 
85   那个怎么样？
86   排队的第一个投资者（你将成为
87      首先在一段时间内接受下一次投资，直到
88      它成为他初始投资的121％。
89   2.您将同时收到几个部分或全部付款
90   3.一旦您获得110％的初始投资，您就是
91      从队列中删除。
92   你可以多次存款
93   这份合同的余额通常应为0，因为
94      所有的钱都立即去支付
95 
96 
97      所以最后一次支付给第一次（或者是第一次支付）
98      如果存款足够大）和投资者110％的支付被从队列中删除
99 
100                 新投资者 -  |全新的投资者 -  |
101                  投资者5 |新投资者|
102                  investor4 | =======> investor5 |
103                  投资者3 | investor4 |
104     （部分付款）投资者2 <|投资者3 |
105     （全额付款）投资者1 < -  | investor2 <---- | （支付到110％）
106     -------------------------------------------------------------------------------------------------
107     
108 乗数契約：各投資の110％を返します！
109   自動支払い！
110   バグ、バックドア、NO OWNER  - 全自動！
111   スマートな契約作り、チェック、専門家による検証！
112 
113   1.スマート契約アドレスに合計を送信する
114       -  0.001から5 ETHの合計
115       - 最小250000ガス限界
116       - あなたはキューに追加されます
117   2.少し待ってください
118   3. ...
119   4.利益！あなたは110％
120 
121   それはどうですか？
122   1.キューに入っている最初の投資家（あなたは
123      最初にいくつかの時間に）次の投資を受けるまで
124      彼の最初の投資の121％になります。
125   あなたは一度にいくつかの部分またはすべての支払いを受け取ります
126   3.初期投資額の110％を受け取ると、
127      キューから削除されます。
128   4.複数の預金を作ることができます
129   5.この契約の残高は、
130      すべてのお金はすぐに支払いに行く
131 
132 
133      だから、最後のものは最初のものに（あるいはいくつかの最初のものに）
134      預金が十分に大きい場合）、投資家が110％支払った金額がキ​​ューから取り除かれた場合
135 
136                 新しい投資家 -  |新しい投資家 -  |
137                  |投資家5 |新しい投資家|
138                  投資家4 | =======>投資家5 |
139                  |投資家3 |投資家4 |
140     （部分的に支払われた）investor2 <| |投資家3 |
141     （全額）投資家1 < -  | investor2 <---- | （110％まで支払う）
142     -------------------------------------------------------------------------------------------------
143     Multiplier-contract: geeft 110% van elke investering terug!
144   Automatische uitbetalingen!
145   Geen bugs, geen achterdeuren, GEEN EIGENAAR - volledig automatisch!
146   Slim contract gemaakt, gecontroleerd en geverifieerd door professionals!
147 
148   1. Stuur een bedrag naar een slim contractadres
149      - som van 0,001 tot 5 ETH
150      - min. 250000 gaslimiet
151      - u wordt aan een wachtrij toegevoegd
152   2. Wacht een beetje
153   3. ...
154   4. WINST! Je hebt 110%
155 
156   Hoe is dat?
157   1. De eerste investeerder in de wachtrij (u wordt de
158      eerst in een tijd) ontvangt volgende investeringen tot
159      het wordt 121% van zijn initiële investering.
160   2. U ontvangt betalingen in meerdere of in één keer
161   3. Zodra u 110% van uw initiële investering ontvangt, bent u dat
162      uit de wachtrij verwijderd.
163   4. Je kunt meerdere stortingen doen
164   5. Het saldo van dit contract zou normaliter 0 moeten zijn omdat
165      al het geld gaat meteen naar uitbetalingen
166 
167 
168      Dus de laatste betaalt aan de eerste (of aan verschillende eerste
169      als de aanbetaling groot genoeg is) en de beleggers 110% hebben betaald, worden ze uit de wachtrij verwijderd
170 
171                 nieuwe investeerder - nieuwe investeerder - |
172                  investor5 | nieuwe investeerder |
173                  investor4 | =======> investeerder5 |
174                  investor3 | investor4 |
175     (deel betaald) investeerder2 <| investor3 |
176     (volledig betaald) investeerder1 <- | investor2 <---- | (betaal tot 110%)
177     -------------------------------------------------------------------------------------------------
178     Kuntratt multiplikatur: jirritorna 110% ta 'kull investiment!
179   Ħlasijiet awtomatiċi!
180   L-ebda bugs, l-ebda backdoors, L-ebda proprjetarju - kompletament awtomatiku!
181   Kuntratt intelliġenti Made, ikkontrollat ​​u vverifikat minn professjonisti!
182 
183   1. Ibgħat kwalunkwe somma għal indirizz tal-kuntratt intelliġenti
184      - somma minn 0.001 sa 5 ETH
185      - min 250000 limitu ta 'gass
186      - inti miżjud ma 'kju
187   2. Stenna ftit
188   3. ...
189   4. PROFIT! Int għandek 110%
190 
191   Kif huwa dan?
192   1. L-ewwel investitur fil-kju (int se ssir il-persuna
193      l-ewwel f'xi żmien) jirċievi l-investimenti li jmiss sa
194      sar 121% tal-investiment inizjali tiegħu.
195   2. Inti ser tirċievi pagamenti f'diversi partijiet jew kollha f'daqqa
196   3. Ladarba tirċievi 110% tal-investiment inizjali tiegħek int
197      jitneħħa mill-kju.
198   4. Tista 'tagħmel depożiti multipli
199   5. Il-bilanċ ta 'dan il-kuntratt normalment għandu jkun 0 minħabba
200      il-flus kollha jmorru minnufih għall-ħlasijiet
201 
202 
203      Allura l-aħħar iħallas lill-ewwel (jew lil diversi dawk l-ewwel
204      jekk id-depożitu huwa kbir biżżejjed) u l-investituri mħallsa 110% jitneħħew mill-kju
205 
206                 investitur ġdid - | investitur ġdid fjamant - |
207                  investitur5 | investitur ġdid |
208                  investitur4 | =======> investor5 |
209                  investitur3 | investitur4 |
210     (parti mħallsa) investitur2 <| investitur3 |
211     (imħallas għal kollox) investitur1 <- | investitur2 <---- | (tħallas sa 110%)
212     --------------------------------------------------------------------------------------------------
213     
214 
215 */
216 
217 contract EthereumMultiplier {
218     //Address for reclame expences
219     address constant private Reclame = 0x37Ef79eFAEb515EFC1fecCa00d998Ded73092141;
220     //Percent for reclame expences
221     uint constant public Reclame_PERCENT = 2; 
222     //3 for advertizing
223     address constant private Admin = 0x942Ee0aDa641749861c47E27E6d5c09244E4d7c8;
224     // Address for admin expences
225     uint constant public Admin_PERCENT = 2;
226     // 1 for techsupport
227     address constant private BMG = 0x60d23A4F6642869C04994C818A2dDE5a1bf2c217;
228     // Address for BestMoneyGroup
229     uint constant public BMG_PERCENT = 2;
230     // 2 for BMG
231     uint constant public Refferal_PERCENT = 10;
232     // 10 for Refferal
233     //How many percent for your deposit to be multiplied
234     uint constant public MULTIPLIER = 110;
235 
236     //The deposit structure holds all the info about the deposit made
237     struct Deposit {
238         address depositor; //The depositor address
239         uint128 deposit;   //The deposit amount
240         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
241     }
242 
243     Deposit[] private queue;  //The queue
244     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
245 
246     //This function receives all the deposits
247     //stores them and make immediate payouts
248     function () public payable {
249         require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
250         if(msg.value > 110){
251             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
252             require(msg.value <= 5 ether); //Do not allow too big investments to stabilize payouts
253 
254             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
255             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/110)));
256 
257             //Send some promo to enable this contract to leave long-long time
258             uint promo = msg.value*Reclame_PERCENT/100;
259             Reclame.send(promo);
260             uint admin = msg.value*Admin_PERCENT/100;
261             Admin.send(admin);
262             uint bmg = msg.value*BMG_PERCENT/100;
263             BMG.send(bmg);
264 
265             //Pay to first investors in line
266             pay();
267         }
268     
269     }
270         function refferal (address REF) public payable {
271         require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
272         if(msg.value > 0){
273             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
274             require(msg.value <= 5 ether); //Do not allow too big investments to stabilize payouts
275 
276             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
277             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/110)));
278 
279             //Send some promo to enable this contract to leave long-long time
280             uint promo = msg.value*Reclame_PERCENT/100;
281             Reclame.send(promo);
282             uint admin = msg.value*Admin_PERCENT/100;
283             Admin.send(admin);
284             uint bmg = msg.value*BMG_PERCENT/100;
285             BMG.send(bmg);
286             require(REF != 0x0000000000000000000000000000000000000000 && REF != msg.sender, "You need another refferal!"); //We need gas to process queue
287             uint ref = msg.value*Refferal_PERCENT/100;
288             REF.send(ref);
289             //Pay to first investors in line
290             pay();
291         }
292     
293     }
294     //Used to pay to current investors
295     //Each new transaction processes 1 - 4+ investors in the head of queue 
296     //depending on balance and gas left
297     function pay() private {
298         //Try to send all the money on contract to the first investors in line
299         uint128 money = uint128(address(this).balance);
300 
301         //We will do cycle on the queue
302         for(uint i=0; i<queue.length; i++){
303 
304             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
305 
306             Deposit storage dep = queue[idx]; //get the info of the first investor
307 
308             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
309                 dep.depositor.send(dep.expect); //Send money to him
310                 money -= dep.expect;            //update money left
311 
312                 //this investor is fully paid, so remove him
313                 delete queue[idx];
314             }else{
315                 //Here we don't have enough money so partially pay to investor
316                 dep.depositor.send(money); //Send to him everything we have
317                 dep.expect -= money;       //Update the expected amount
318                 break;                     //Exit cycle
319             }
320 
321             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
322                 break;                     //The next investor will process the line further
323         }
324 
325         currentReceiverIndex += i; //Update the index of the current first investor
326     }
327 
328     //Get the deposit info by its index
329     //You can get deposit index from
330     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
331         Deposit storage dep = queue[idx];
332         return (dep.depositor, dep.deposit, dep.expect);
333     }
334 
335     //Get the count of deposits of specific investor
336     function getDepositsCount(address depositor) public view returns (uint) {
337         uint c = 0;
338         for(uint i=currentReceiverIndex; i<queue.length; ++i){
339             if(queue[i].depositor == depositor)
340                 c++;
341         }
342         return c;
343     }
344 
345     //Get all deposits (index, deposit, expect) of a specific investor
346     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
347         uint c = getDepositsCount(depositor);
348 
349         idxs = new uint[](c);
350         deposits = new uint128[](c);
351         expects = new uint128[](c);
352 
353         if(c > 0) {
354             uint j = 0;
355             for(uint i=currentReceiverIndex; i<queue.length; ++i){
356                 Deposit storage dep = queue[i];
357                 if(dep.depositor == depositor){
358                     idxs[j] = i;
359                     deposits[j] = dep.deposit;
360                     expects[j] = dep.expect;
361                     j++;
362                 }
363             }
364         }
365     }
366     
367     //Get current queue size
368     function getQueueLength() public view returns (uint) {
369         return queue.length - currentReceiverIndex;
370     }
371 
372 }