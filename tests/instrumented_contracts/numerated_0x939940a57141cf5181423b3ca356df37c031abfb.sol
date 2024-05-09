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
11 interface tokenTransferUSDT {
12     function transfer(address receiver, uint amount);
13     function transferFrom(address _from, address _to, uint256 _value);
14     function balances(address receiver) returns(uint256);
15 }
16 interface tokenTransferBET {
17     function transfer(address receiver, uint amount);
18     function transferFrom(address _from, address _to, uint256 _value);
19     function balanceOf(address receiver) returns(uint256);
20 }
21 contract SafeMath {
22       address public owner;
23        
24   function SafeMath () public {
25         owner = msg.sender;
26     }
27   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
34     assert(b > 0);
35     uint256 c = a / b;
36     assert(a == b * c + a % b);
37     return c;
38   }
39 
40   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
46     uint256 c = a + b;
47     assert(c>=a && c>=b);
48     return c;
49   }
50 
51   function assert(bool assertion) internal {
52     if (!assertion) {
53       throw;
54     }
55   }
56     modifier onlyOwner {
57         require (msg.sender == owner);
58         _;
59     }
60     function transferOwnership(address newOwner) onlyOwner public {
61         if (newOwner != address(0)) {
62         owner = newOwner;
63       }
64     }
65 }
66 contract bebBUYtwo is SafeMath{
67 tokenTransfer public bebTokenTransfer; //代币 
68 tokenTransferUSDT public bebTokenTransferUSDT;
69 tokenTransferBET public bebTokenTransferBET;
70     uint8 decimals;
71     uint256 bebethex;//eth-beb
72     uint256 BEBday;
73     uint256 bebjiage;
74     uint256 bebtime;
75     uint256 usdtex;
76     address ownerstoex;
77     uint256 ProfitSUMBEB;
78     uint256 SUMdeposit;
79     uint256 SUMWithdraw;
80     uint256 USDTdeposit;
81     uint256 USDTWithdraw;
82     uint256 BEBzanchen;//赞成总量
83     uint256 BEBfandui;//反对总量
84     address shenqingzhichu;//申请人地址
85     uint256 shenqingAmount;//申请金额
86     uint256 huobileixing;//货币类型1=ETH，2=BEB，3=USDT
87     string purpose;//用途
88     bool KAIGUAN;//表决开关
89     string boody;//是否通过
90     uint256 buyOrSell;
91     struct BEBuser{
92         uint256 amount;
93         uint256 dayamount;//每天
94         uint256 bebdays;//天数
95         uint256 usertime;//时间
96         uint256 zhiyaBEB;
97         uint256 sumProfit;
98         uint256 amounts;
99         bool vote;
100     }
101     struct USDTuser{
102         uint256 amount;
103         uint256 dayamount;//每天
104         uint256 bebdays;//天数
105         uint256 usertime;//时间
106         uint256 zhiyaBEB;
107         uint256 sumProfit;
108     }
109     mapping(address=>uint256)public buybebs;
110     mapping(address=>USDTuser)public USDTusers;
111     mapping(address=>BEBuser)public BEBusers;
112     function bebBUYtwo(address _tokenAddress,address _usdtadderss,address _BETadderss,address _addr){
113          bebTokenTransfer = tokenTransfer(_tokenAddress);
114          bebTokenTransferUSDT =tokenTransferUSDT(_usdtadderss);
115          bebTokenTransferBET =tokenTransferBET(_BETadderss);
116          ownerstoex=_addr;
117          bebethex=5623;
118          decimals=18;
119          BEBday=20;
120          bebjiage=178480000000000;
121          bebtime=now;
122          usdtex=170;
123      }
124      //USDT
125       function setUSDT(uint256 _value) public{
126          require(_value>=10000000);
127          uint256 _valueToBEB=SafeMath.safeDiv(_value,1000000);
128          uint256 _valueToBEBs=_valueToBEB*10**18;
129          uint256 _usdts=SafeMath.safeMul(_value,120);//100;
130          uint256 _usdt=SafeMath.safeDiv(_usdts,100);//100;
131          uint256 _bebex=SafeMath.safeMul(bebjiage,usdtex);
132          uint256 _usdtexs=SafeMath.safeDiv(1000000000000000000,_bebex);
133          uint256 _usdtex=SafeMath.safeMul(_usdtexs,_valueToBEBs);
134          USDTuser storage _user=USDTusers[msg.sender];
135          require(_user.amount==0,"Already invested ");
136          bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value);
137          bebTokenTransfer.transferFrom(msg.sender,address(this),_usdtex);
138          _user.zhiyaBEB=_usdtex;
139          _user.amount=_value;
140          _user.dayamount=SafeMath.safeDiv(_usdt,BEBday);
141          _user.usertime=now;
142          _user.sumProfit+=_value*20/100;
143          ProfitSUMBEB+=_usdtex*10/100;
144          USDTdeposit+=_value;
145          
146      }
147      function setETH()payable public{
148          require(msg.value>=500000000000000000);
149          uint256 _eths=SafeMath.safeMul(msg.value,120);
150          uint256 _eth=SafeMath.safeDiv(_eths,100);
151          uint256 _beb=SafeMath.safeMul(msg.value,bebethex);
152          BEBuser storage _user=BEBusers[msg.sender];
153          require(_user.amount==0,"Already invested ");
154          bebTokenTransfer.transferFrom(msg.sender,address(this),_beb);
155          _user.zhiyaBEB=_beb;
156          _user.amount=msg.value;
157          _user.dayamount=SafeMath.safeDiv(_eth,BEBday);
158          _user.usertime=now;
159          _user.sumProfit+=msg.value*20/100;
160          ProfitSUMBEB+=_beb*10/100;
161          SUMdeposit+=msg.value;
162          
163      }
164      function DayQuKuan()public{
165          if(now-bebtime>86400){
166             bebtime+=86400;
167             bebjiage+=660000000000;//每日固定上涨0.00000066ETH
168             bebethex=1 ether/bebjiage;
169         }
170         BEBuser storage _users=BEBusers[msg.sender];
171         uint256 _eths=_users.dayamount;
172         require(_eths>0,"You didn't invest");
173         require(_users.bebdays<BEBday,"Expired");
174         uint256 _time=(now-_users.usertime)/86400;
175         require(_time>=1,"Less than a day");
176         uint256 _ddaayy=_users.bebdays+1;
177         if(BEBday==20){
178         msg.sender.transfer(_users.dayamount);
179         SUMWithdraw+=_users.dayamount;
180         _users.bebdays=_ddaayy;
181         _users.usertime+=86400;
182         if(_ddaayy==BEBday){
183         uint256 _bebs=_users.zhiyaBEB*90/100;
184          bebTokenTransfer.transfer(msg.sender,_bebs);
185          _users.amount=0;
186          _users.dayamount=0;
187           _users.bebdays=0;
188           _users.zhiyaBEB=0;
189         }
190         }else{
191          uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday);
192          bebTokenTransfer.transfer(msg.sender,_values);
193         _users.bebdays=_ddaayy;
194         _users.usertime+=86400;
195         if(_ddaayy==BEBday){
196          uint256 _bebss=_users.zhiyaBEB*90/100;
197          bebTokenTransfer.transfer(msg.sender,_bebss);
198          _users.amount=0;
199          _users.dayamount=0;
200           _users.bebdays=0;
201           _users.zhiyaBEB=0;
202         }   
203         }
204         
205      }
206      function DayQuKuanUsdt()public{
207          if(now-bebtime>86400){
208             bebtime+=86400;
209             bebjiage+=660000000000;//每日固定上涨0.00000066ETH
210             bebethex=1 ether/bebjiage;
211         }
212         USDTuser storage _users=USDTusers[msg.sender];
213         uint256 _eths=_users.dayamount;
214         require(_eths>0,"You didn't invest");
215         require(_users.bebdays<BEBday,"Expired");
216         uint256 _time=(now-_users.usertime)/86400;
217         require(_time>=1,"Less than a day");
218         uint256 _ddaayy=_users.bebdays+1;
219         if(BEBday==20){
220         bebTokenTransferUSDT.transfer(msg.sender,_eths);
221         USDTWithdraw+=_eths;
222         _users.bebdays=_ddaayy;
223         _users.usertime+=86400;
224         if(_ddaayy==BEBday){
225         uint256 _bebs=_users.zhiyaBEB*90/100;
226          bebTokenTransfer.transfer(msg.sender,_bebs);
227          _users.amount=0;
228          _users.dayamount=0;
229           _users.bebdays=0;
230           _users.zhiyaBEB=0;
231         }
232         }else{
233          uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday);
234          bebTokenTransfer.transfer(msg.sender,_values);
235         _users.bebdays=_ddaayy;
236         _users.usertime+=86400;
237         if(_ddaayy==BEBday){
238          uint256 _bebss=_users.zhiyaBEB*90/100;
239          bebTokenTransfer.transfer(msg.sender,_bebss);
240          _users.amount=0;
241          _users.dayamount=0;
242           _users.bebdays=0;
243           _users.zhiyaBEB=0;
244         }   
245         }
246         
247      }
248      //申请支出
249      function ChaiwuzhiChu(address _addr,uint256 _values,uint256 _leixing,string _purpose)public{
250          require(!KAIGUAN,"The last round of voting is not over");
251          require(getTokenBalanceBET(address(this))<1,"And bet didn't get it back");
252          uint256 _value=getTokenBalanceBET(msg.sender);//BET持有数量
253         require(_value>=1 ether,"You have no right to apply");
254          KAIGUAN=true;//开始投票
255          shenqingzhichu=_addr;//申请人地址
256          if(_leixing==3){
257             uint256 _usdts= SafeMath.safeDiv(_values,1000000000000000000);
258             uint256 _usdttozhichu=_usdts*1000000;
259             shenqingAmount=_usdttozhichu;
260          }else{
261            shenqingAmount=_values;//申请支出金额
262          }
263          huobileixing=_leixing;//1=eth,2=BEB,3=USDT
264          purpose=_purpose;
265          boody="投票中...";
266      }
267      //投票赞成
268     function setVoteZancheng()public{
269         BEBuser storage _user=BEBusers[msg.sender];
270         require(KAIGUAN);
271         uint256 _value=getTokenBalanceBET(msg.sender);//BET持有数量
272         require(_value>=1 ether,"You have no right to vote");
273         require(!_user.vote,"You have voted");
274         bebTokenTransferBET.transferFrom(msg.sender,address(this),_value);//转入BET
275         BEBzanchen+=_value;//赞成增加
276         _user.amounts=_value;//赋值
277         _user.vote=true;//赋值已经投票
278         if(BEBzanchen>=51 ether){
279             //投票通过执行财务支出
280             if(huobileixing!=0){
281                 if(huobileixing==1){
282                  shenqingzhichu.transfer(shenqingAmount);//支出ETH
283                  KAIGUAN=false;
284                  BEBfandui=0;//票数归零
285                  BEBzanchen=0;//票数归零
286                  huobileixing=0;//撤销本次申请
287                  boody="通过";
288                  //shenqingzhichu=0;//撤销地址
289                  //shenqingAmount=0;//撤销申请金额
290                 }else{
291                     if(huobileixing==2){
292                       bebTokenTransfer.transfer(shenqingzhichu,shenqingAmount);//支出BEB
293                       KAIGUAN=false;
294                       BEBfandui=0;//票数归零
295                       BEBzanchen=0;//票数归零
296                       huobileixing=0;//撤销本次申请
297                       boody="通过";
298                     }else{
299                         bebTokenTransferUSDT.transfer(shenqingzhichu,shenqingAmount);//支出USDT
300                         KAIGUAN=false;
301                         BEBfandui=0;//票数归零
302                         BEBzanchen=0;//票数归零
303                         huobileixing=0;//撤销本次申请
304                         boody="通过";
305                     }          
306                  }
307             }
308         }
309     }
310     //投票反对
311     function setVoteFandui()public{
312         require(KAIGUAN);
313         BEBuser storage _user=BEBusers[msg.sender];
314         uint256 _value=getTokenBalanceBET(msg.sender);
315         require(_value>=1 ether,"You have no right to vote");
316         require(!_user.vote,"You have voted");
317         bebTokenTransferBET.transferFrom(msg.sender,address(this),_value);//转入BET
318         BEBfandui+=_value;//赞成增加
319         _user.amounts=_value;//赋值
320         _user.vote=true;//赋值已经投票
321         if(BEBfandui>=51 ether){
322             //反对大于51%表决不通过
323             BEBfandui=0;//票数归零
324             BEBzanchen=0;//票数归零
325             huobileixing=0;//撤销本次申请
326             shenqingzhichu=0;//撤销地址
327             shenqingAmount=0;//撤销申请金额
328             KAIGUAN=false;
329             boody="拒绝";
330         }
331     }
332     //取回BET
333      function quhuiBET()public{
334         require(!KAIGUAN,"Bet cannot be retrieved while voting is in progress");
335         BEBuser storage _user=BEBusers[msg.sender];
336         require(_user.vote,"You did not vote");
337         bebTokenTransferBET.transfer(msg.sender,_user.amounts);//退回BET
338         _user.vote=false;
339         _user.amounts=0;
340      }
341      function buybeb()payable public{
342         uint256 _amount=msg.value;
343         uint256 _buybeb=SafeMath.safeMul(_amount,bebethex);
344         require(_buybeb<=ProfitSUMBEB);
345         bebTokenTransfer.transfer(msg.sender,_buybeb);//支出BEB
346         buybebs[msg.sender]+=_buybeb;
347         buyOrSell+=_buybeb;
348         ProfitSUMBEB-=_buybeb;
349      }
350      function sellbeb(uint256 _value) public{
351          require(_value>bebethex);
352          require(buybebs[msg.sender]>=_value,"Sorry, your credit is running low");
353         uint256 _sellbeb=SafeMath.safeDiv(_value,bebethex);
354         uint256 _selleth=_sellbeb*95/100;
355         bebTokenTransfer.transferFrom(msg.sender,address(this),_value);
356         msg.sender.transfer(_selleth);
357         buybebs[msg.sender]-=_value;
358         buyOrSell-=_selleth;
359         ProfitSUMBEB+=_value;
360      }
361      function setBEB(uint256 _value)public{
362          require(_value>0);
363          bebTokenTransfer.transferFrom(msg.sender,address(this),_value);
364          ProfitSUMBEB+=_value;
365      }
366      function setusdtex(uint256 _value)public{
367          require(ownerstoex==msg.sender);
368          usdtex=_value;
369      }
370      function setETHS()payable onlyOwner{
371          SUMdeposit+=msg.value;
372      }
373      function setUSDTS(uint256 _value)onlyOwner{
374          bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value);
375          USDTdeposit+=_value;
376      }
377      function querBalance()public view returns(uint256){
378          return this.balance;
379      }
380     function getTokenBalance() public view returns(uint256){
381          return bebTokenTransfer.balanceOf(address(this));
382     }
383     function getTokenBalanceUSDT() public view returns(uint256){
384          return bebTokenTransferUSDT.balances(address(this));
385     }
386     function BETwithdrawal(uint256 amount)onlyOwner {
387       bebTokenTransferBET.transfer(msg.sender,amount);
388     }
389     function setBEBday(uint256 _BEBday)onlyOwner{
390         BEBday=_BEBday;
391     }
392     function setusersUSDT(address _addr)onlyOwner{
393        USDTuser storage _user=USDTusers[_addr];
394        _user.amount=0;
395        _user.dayamount=0;
396        _user.bebdays=0;
397        _user.usertime=0;
398        _user.zhiyaBEB=0;
399        _user.sumProfit=0;
400         
401     }
402     function setusersETH(address _addr)onlyOwner{
403        BEBuser storage _user=BEBusers[_addr];
404        _user.amount=0;
405        _user.dayamount=0;
406        _user.bebdays=0;
407        _user.usertime=0;
408        _user.zhiyaBEB=0;
409        _user.sumProfit=0;
410         
411     }
412     function getuserBuybebs() public view returns(uint256){
413          return buybebs[msg.sender];
414     }
415     function getTokenBalanceBET(address _addr) public view returns(uint256){
416          return bebTokenTransferBET.balanceOf(_addr);
417     }
418     function getQuanju()public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
419             
420          return (bebjiage,bebethex,ProfitSUMBEB,SUMdeposit,SUMWithdraw,USDTdeposit,USDTWithdraw,buyOrSell,usdtex);
421     }
422     function getUSDTuser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
423             USDTuser storage _users=USDTusers[_addr];
424             //uint256 amount;//USDT总投资
425         //uint256 dayamount;//每天回本息
426         //uint256 bebdays;//回款天数
427         //uint256 usertime;//上一次取款时间
428         //uint256 zhiyaBEB;质押BEB数量
429         //uint256 sumProfit;总收益
430          return (_users.amount,_users.dayamount,_users.bebdays,_users.usertime,_users.zhiyaBEB,_users.sumProfit);
431     }
432     function getBEBuser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,bool){
433             BEBuser storage _users=BEBusers[_addr];
434             //uint256 amount;//投资金额
435             //uint256 dayamount;//每天回本息
436             //uint256 bebdays;//回款天数
437             //uint256 usertime;//上一次取款时间
438             //uint256 zhiyaBEB;//质押BEB数量
439             //uint256 sumProfit;//总收益
440             // uint256 amounts;//投票BET数量
441            //bool vote;//是否投票
442          return (_users.amount,_users.dayamount,_users.bebdays,_users.usertime,_users.zhiyaBEB,_users.sumProfit,_users.amounts,_users.vote);
443     }
444     function getBETvote()public view returns(uint256,uint256,address,uint256,uint256,string,bool,string){
445             //uint256 BEBzanchen;//赞成总量
446     //uint256 BEBfandui;//反对总量
447     //address shenqingzhichu;//申请人地址
448     //uint256 shenqingAmount;//申请金额
449     //uint256 huobileixing;//货币类型1=ETH，2=BEB，3=USDT
450     //string purpose;//用途
451     //bool KAIGUAN;//表决开关
452     //string boody;//是否通过，状态
453          return (BEBzanchen,BEBfandui,shenqingzhichu,shenqingAmount,huobileixing,purpose,KAIGUAN,boody);
454     }
455     function getUsdt()public view returns(uint256){
456         return usdtex;
457     }
458     function ()payable{
459         
460     }
461 }