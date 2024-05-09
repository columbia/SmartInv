1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-09
3  * BEB dapp for www.betbeb.com
4 */
5 pragma solidity^0.4.24;  
6 interface tokenTransfer {
7     function transfer(address receiver, uint amount);
8     function transferFrom(address _from, address _to, uint256 _value);
9     function balanceOf(address receiver) returns(uint256);
10 }
11 
12 contract Ownable {
13   address public owner;
14  
15     function Ownable () public {
16         owner = msg.sender;
17     }
18  
19     modifier onlyOwner {
20         require (msg.sender == owner);
21         _;
22     }
23  
24     /**
25      * @param  newOwner address
26      */
27     function transferOwnership(address newOwner) onlyOwner public {
28         if (newOwner != address(0)) {
29         owner = newOwner;
30       }
31     }
32 }
33 
34 contract BEBmining is Ownable{
35 tokenTransfer public bebTokenTransfer; //代币 
36     uint8 decimals = 18;
37    struct BebUser {
38         address customerAddr;
39         uint256 amount; 
40         uint256 bebtime;
41         uint256 interest;
42     }
43     //ETH miner
44     struct miner{
45         uint256 mining;
46         uint256 _mining;
47         uint256 lastDate;
48         uint256 amountdays;
49         uint256 ethbomus;
50         uint256 amountTotal;
51         uint256 ETHV1;
52         uint256 ETHV2;
53         uint256 ETHV3;
54         uint256 ETHV4;
55         uint256 ETHV5;
56         uint256 IntegralMining;
57     }
58     struct bebvv{
59         uint256 BEBV1;
60         uint256 BEBV2;
61         uint256 BEBV3;
62         uint256 BEBV4;
63         uint256 BEBV5;
64     }
65     mapping(address=>bebvv)public bebvvs;
66     mapping(address=>miner)public miners;
67     address[]public minersArray;
68     uint256 ethExchuangeRate=210;//eth-usd
69     uint256 bebethexchuang=97000;//beb-eth
70     uint256 bebethex=83360;//eth-beb
71     uint256 bounstotal;
72     uint256 TotalInvestment;
73     uint256 sumethbos;
74     uint256 depreciationTime=86400;
75     uint256 SellBeb;//SellBeb MAX 10000BEB
76     uint256 BuyBeb;//BuyBeb MAX 100000BEB
77     uint256 IncomePeriod=730;//Income period
78     address addressDraw;
79     uint256 intotime=1579073112;
80     event bomus(address to,uint256 amountBouns,string lx);
81     function BEBmining(address _tokenAddress,address Draw){
82          bebTokenTransfer = tokenTransfer(_tokenAddress);
83          addressDraw=Draw;
84      }
85       //BUY Ethminter
86     function EthTomining(address _addr)payable public{
87         uint256 amount=msg.value;
88         uint256 usdt=amount;
89         uint256 _udst=amount;
90         miner storage user=miners[_addr];
91         require(amount>800000000000000000);
92         if(usdt>40000000000000000000){
93            usdt=amount*150/100;
94            user.ETHV5+=1;
95         }else{
96             if (usdt > 25000000000000000000){
97                     usdt = amount* 130 / 100;
98                     user.ETHV4+=1;
99                 }
100                 else{
101                     if (usdt > 9000000000000000000){
102                         usdt = amount * 120 / 100;
103                          user.ETHV3+=1;
104                     }
105                     else{
106                         if (usdt > 4000000000000000000){
107                             usdt = amount * 110 / 100;
108                              user.ETHV2+=1;
109                         }
110                         else{
111                           user.ETHV1+=1;  
112                         }
113                     }
114                 }
115         }
116         uint256 _transfer=amount*15/100;
117         addressDraw.transfer(_transfer);
118         TotalInvestment+=usdt;
119         user.mining+=usdt;
120         user._mining+=_udst;
121         //user._mining+=_udst;
122         user.lastDate=now;
123         bomus(msg.sender,usdt,"Purchase success!");
124     }
125     //BUY BEBminter
126     function BebTomining(uint256 _value,address _addr)public{
127         uint256 usdt=_value* 10 ** 18;
128         uint256 _udst=usdt/bebethex;
129         uint256 bebudst=usdt/bebethex;
130         miner storage user=miners[_addr];
131         bebvv storage _user=bebvvs[_addr];
132         require(usdt>40000000000000000000000);
133         if(usdt>2000000000000000000000000){
134            _udst=usdt/bebethexchuang*150/100;
135            _user.BEBV5+=1; 
136         }else{
137             if (usdt > 400000000000000000000000){
138                     _udst = usdt / bebethexchuang * 130 / 100;
139                    _user.BEBV4+=1; 
140                 }
141                 else{
142                     if (usdt > 200000000000000000000000){
143                         _udst = usdt / bebethexchuang * 120 / 100;
144                         _user.BEBV3+=1; 
145                     }
146                     else{
147                         if (usdt > 120000000000000000000000){
148                             _udst = usdt / bebethexchuang * 110 / 100;
149                             _user.BEBV2+=1; 
150                         }else{
151                           _user.BEBV1+=1;  
152                         }
153                     }
154                 }
155                 
156             }
157         bebTokenTransfer.transferFrom(msg.sender,address(this),usdt);
158         TotalInvestment+=_udst;
159         user.mining+=_udst;
160         user._mining+=bebudst;
161         user.lastDate=now;
162         bomus(msg.sender,usdt,"Purchase success!");
163     }
164     //BUY  积分 minter
165     function integralTomining(uint256 _value,address _addr)onlyOwner{
166         uint256 eth=_value* 10 ** 18;
167         uint256 _eth=eth/bebethex;
168         miner storage user=miners[_addr];
169         bebTokenTransfer.transferFrom(msg.sender,address(this),eth);
170         TotalInvestment+=_eth;
171         user.mining+=_eth;
172         if(user.lastDate==0){
173            user.lastDate=now; 
174         }
175         uint256 jifen=_value/50000;
176         user.IntegralMining+=jifen;
177         //user.lastDate=now;
178         bomus(_addr,_eth,"Purchase success!");
179     }
180     //BUY  迁移合约
181     function migrateTomining(uint256 _value,uint256 _minin,uint256 time,uint256 _amountTotal,address _addr,uint256 bebv1,uint256 bebv2,uint256 bebv3,uint256 bebv4,uint256 bebv5)onlyOwner{
182         require(intotime>now);//函数过期功能作废
183         miner storage user=miners[_addr];
184         bebvv storage _user=bebvvs[_addr];
185         //uint256 _usdtt=_udst/bebethexchuang;
186         uint256 BEBETH=_minin* 10 ** 18;
187         uint256 udst=BEBETH/bebethex;//BEB-ETH
188         user.amountTotal=_amountTotal;//ETH
189         user.mining+=_value;
190         user._mining+=udst;
191         user.lastDate=time;
192         _user.BEBV1=bebv1;
193         _user.BEBV2=bebv2;
194         _user.BEBV3=bebv3;
195         _user.BEBV4=bebv4;
196         _user.BEBV5=bebv5;
197     }
198     function setTomining(uint256 _value,uint256 _minin,address _addr)onlyOwner{
199         require(intotime>now);//函数过期功能作废
200         miner storage user=miners[_addr];
201         user.mining-=_value;//ETH
202         user._mining-=_minin;//ETH
203     }
204     function setToTomining(uint256 _value,uint256 _minin,address _addr)onlyOwner{
205         require(intotime>now);//函数过期功能作废
206         miner storage user=miners[_addr];
207         user.mining+=_value;//ETH
208         user._mining+=_minin;//ETH
209     }
210     //执行地址
211     function setaddress(address _addr)onlyOwner{
212         addressDraw=_addr;
213     }
214     function freeSettlement()public{
215         miner storage user=miners[msg.sender];
216         bebvv storage _user=bebvvs[msg.sender];
217         uint256 amuont=user.mining;
218         require(amuont>0,"You don't have a mining machine");
219         uint256 _ethbomus=user.ethbomus;
220         uint256 _lastDate=user.lastDate;
221         uint256 _amountTotal=user.amountTotal;
222         uint256 sumincome=_amountTotal*100/amuont;
223         uint256 depreciation=(now-_lastDate)/depreciationTime;
224         require(depreciation>0,"Less than 1 day of earnings");
225         //The expiration of the income period, the mining machine scrapped
226         uint256 Bebday=amuont*depreciation/100;
227         uint256 profit=Bebday;
228         require(profit>0,"Mining amount 0");
229         if(sumincome>IncomePeriod){
230            uint256 _Bebday=amuont*depreciation/100*3/100;
231            require(this.balance>_Bebday,"Insufficient contract balance");
232             user.lastDate=now;
233             user.ethbomus+=_Bebday;
234             user.amountTotal+=_Bebday;
235             user.amountdays+=depreciation;
236             bounstotal+=_Bebday;
237             user.ethbomus=0;
238             sumethbos=0;
239            msg.sender.transfer(_Bebday);
240            if(user.amountdays>730){
241                //收益730天后报废
242              //Mining machine scrap
243            user.mining=0;
244            user.lastDate=0;
245            user.ethbomus=0;
246            sumethbos=0;
247            user.amountTotal=0;
248            user.amountdays=0;
249            user.ETHV1=0;
250            user.ETHV2=0;
251            user.ETHV3=0;
252            user.ETHV4=0;
253            user.ETHV5=0;
254            user.IntegralMining=0;
255            user._mining=0;
256            _user.BEBV1=0;
257            _user.BEBV2=0;
258            _user.BEBV3=0;
259            _user.BEBV4=0;
260            _user.BEBV5=0;
261            }
262         }else{
263             require(this.balance>profit,"Insufficient contract balance");
264             user.lastDate=now;
265             user.ethbomus+=Bebday;
266             user.amountTotal+=Bebday;
267             user.amountdays+=depreciation;
268             bounstotal+=profit;
269             user.ethbomus=0;
270             sumethbos=0;
271            msg.sender.transfer(profit);  
272         }
273         
274     }
275     function Refund()public{
276         miner storage user=miners[msg.sender];
277         bebvv storage _user=bebvvs[msg.sender];
278         uint256 benjin=user._mining-user.amountTotal;
279         uint256 dayts=user.amountdays;
280         uint256 dayxi=benjin*1/1000*dayts;
281         uint256 _amount=benjin+dayxi;
282         require(dayts<30);
283         require(_amount>0,"Insufficient contract balance");
284         require(this.balance>_amount,"Insufficient contract balance");
285         msg.sender.transfer(_amount);
286            user.mining=0;
287            user.lastDate=0;
288            user.ethbomus=0;
289            sumethbos=0;
290            user.amountTotal=0;
291            user.amountdays=0;
292            user.ETHV1=0;
293            user.ETHV2=0;
294            user.ETHV3=0;
295            user.ETHV4=0;
296            user.ETHV5=0;
297            user.IntegralMining=0;
298            user._mining=0;
299            _user.BEBV1=0;
300            _user.BEBV2=0;
301            _user.BEBV3=0;
302            _user.BEBV4=0;
303            _user.BEBV5=0;
304     }
305     function getbebmining()public view returns(uint256,uint256,uint256,uint256,uint256){
306          bebvv storage user=bebvvs[msg.sender];
307         return (user.BEBV1,user.BEBV2,user.BEBV3,user.BEBV4,user.BEBV5);
308      }
309      function querBalance()public view returns(uint256){
310          return this.balance;
311      }
312     function querYrevenue()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
313         miner storage user=miners[msg.sender];
314         uint256 _amuont=user.mining;
315         uint256 _min=user._mining;
316         uint256 _amountTotal=user.amountTotal;
317         if(_amuont==0){
318             percentage=0;
319         }else{
320         uint256 percentage=100-(_amountTotal*100/_amuont*100/730);    
321         }
322         uint256 _lastDate=user.lastDate;
323         uint256 dayzmount=_amuont/100;
324         uint256 depreciation=(now-_lastDate)/depreciationTime;
325         //require(depreciation>0,"Less than 1 day of earnings");
326         uint256  Bebday=_amuont*depreciation/100;
327                  sumethbos=Bebday;
328 
329         uint256 profit=sumethbos;
330         return (percentage,dayzmount,_min,profit,user.amountTotal,user.lastDate);
331     }
332     function ethmining()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
333         miner storage user=miners[msg.sender];
334         return (user.ETHV1,user.ETHV2,user.ETHV3,user.ETHV4,user.ETHV5,user.IntegralMining);
335     }
336     function getquerYrevenue()public view returns(uint256,uint256,uint256){
337         miner storage user=miners[msg.sender];
338         return (user.mining,user.amountTotal,user.lastDate);
339     }
340     function RefundData()public view returns(uint256,uint256,uint256,uint256){
341         miner storage user=miners[msg.sender];
342         uint256 benjin=user._mining-user.amountTotal;
343         uint256 dayts=user.amountdays;
344         uint256 dayxi=benjin*1/1000*dayts;
345         return (user._mining,user.amountTotal,dayxi,benjin+dayxi);
346     }
347     function ModifyexchangeRate(uint256 sellbeb,uint256 buybeb,uint256 _ethExchuangeRate,uint256 maxsell,uint256 maxbuy) onlyOwner{
348         ethExchuangeRate=_ethExchuangeRate;
349         bebethexchuang=sellbeb;
350         bebethex=buybeb;
351         SellBeb=maxsell* 10 ** 18;
352         BuyBeb=maxbuy* 10 ** 18;
353         
354     }
355     // sellbeb-eth
356     function sellBeb(uint256 _sellbeb)public {
357         uint256 _sellbebt=_sellbeb* 10 ** 18;
358          require(_sellbeb>0,"The exchange amount must be greater than 0");
359          require(_sellbeb<SellBeb,"More than the daily redemption limit");
360          uint256 bebex=_sellbebt/bebethexchuang;
361          require(this.balance>bebex,"Insufficient contract balance");
362          bebTokenTransfer.transferFrom(msg.sender,address(this),_sellbebt);
363          msg.sender.transfer(bebex);
364     }
365     //buyBeb-eth
366     function buyBeb() payable public {
367         uint256 amount = msg.value;
368         uint256 bebamountub=amount*bebethex;
369         uint256 _transfer=amount*15/100;
370         require(getTokenBalance()>bebamountub);
371         addressDraw.transfer(_transfer);
372         bebTokenTransfer.transfer(msg.sender,bebamountub);  
373     }
374     function queryRate() public view returns(uint256,uint256,uint256,uint256,uint256){
375         return (ethExchuangeRate,bebethexchuang,bebethex,SellBeb,BuyBeb);
376     }
377     function TotalRevenue()public view returns(uint256,uint256) {
378      return (bounstotal,TotalInvestment/ethExchuangeRate);
379     }
380     function setioc(uint256 _value)onlyOwner{
381         IncomePeriod=_value;
382     }
383     event messageBetsGame(address sender,bool isScuccess,string message);
384     function getTokenBalance() public view returns(uint256){
385          return bebTokenTransfer.balanceOf(address(this));
386     }
387     function BEBwithdrawAmount(uint256 amount) onlyOwner {
388         uint256 _amountbeb=amount* 10 ** 18;
389         require(getTokenBalance()>_amountbeb,"Insufficient contract balance");
390        bebTokenTransfer.transfer(owner,_amountbeb);
391     } 
392     function ()payable{
393         
394     }
395 }