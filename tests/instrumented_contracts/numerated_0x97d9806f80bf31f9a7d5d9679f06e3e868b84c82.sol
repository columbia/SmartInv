1 pragma solidity >=0.4.16 <0.6.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 contract Erc20Interface {
85   function transfer(address _to, uint256 _value) external;
86   function transferFrom(address _from, address _to, uint256 _value) external;
87   mapping (address => uint256) public balanceOf;
88   function destruction(uint256 _value) external;
89 }
90 contract IPFS is Ownable{
91     using SafeMath for uint256;
92     //FPS代币合约地址
93     address public fpsContract = 0x75259fce71f515b195e28d9a6fc85ebc40ab878d;
94     //FPS发行总量
95     uint256 public fpsTotalSupply = 7000000000000000000000000;
96     //FPS总产生的挖矿
97     uint256 public fpsRewardTotal;
98     //PPS代币合约地址
99     address public ppsContract = 0x77b2fdf56de2ea5681730ca5477be673a6b38d49;
100     //PPS发行总量
101     uint256 public ppsTotalSupply = 6000000000000000000000000;
102     //PPS总产生的挖矿
103     uint256 public ppsRewardTotal;
104     //pss代币合约地址
105     address public pssContract = 0xbfc60c5a28781b53bedaf8a7ae1158d758e569fd;
106     //Pss发行总量
107     uint256 public pssTotalSupply = 5000000000000000000000000;
108     //PSS总产生的挖矿
109     uint256 public pssRewardTotal;
110     //sss代币合约地址
111     address public sssContract = 0x67c9f5b0677268ea034e7db499e39d16685ecaf8;
112     //sss发行总量
113     uint256 public sssTotalSupply = 4000000000000000000000000;
114     //SSS总产生的挖矿
115     uint256 public sssRewardTotal;
116      //usdt代币合约地址
117     address public usdtContract = 0xdac17f958d2ee523a2206206994597c13d831ec7;
118     uint32 public nowRound = 1;//当前阶段 
119     uint32 public smallNowRound = 1;//阶段小期 
120     mapping(address=>mapping(uint256=>TransModi)) public m_trans;
121     mapping(address=>uint8) public isTrans;
122     //每个阶段累计产的货币数量
123     mapping(uint32=>uint256) public roundRewardTotal;
124     modifier authority(uint256 _today) {
125         require(m_trans[msg.sender][_today].isAuthority);
126         _;
127     }
128     modifier erc20s(address _contractAddress){
129         require(_contractAddress==fpsContract
130         ||_contractAddress==ppsContract
131         ||_contractAddress==pssContract
132         ||_contractAddress==sssContract
133         ||_contractAddress==usdtContract);
134         _;
135     }
136     struct TransModi{
137         address erc20Contract;
138         address[] toAddrrs;
139         uint256[] amounts;
140         bool isAuthority;
141 
142     }
143     //矿机购买记录结构
144     struct PollRecord{
145         //矿机类型
146         uint32 minerTypeId;
147         //支出的货币数量
148         uint256 num;
149         //购买的时间
150         uint32 time;
151         //购买时的阶段
152         uint32 round;
153     }
154     mapping(address=>bool) authdestruction;//币种销毁计划授权
155     struct BuyCoinType{
156         //兑换矿机所消耗币种合约地址1
157         address contaddr1;
158         //兑换矿机种所消耗币种占比值1
159         uint8 num1;
160         //兑换矿机所消耗币种合约地址2
161         address contaddr2;
162         //兑换矿机种所消耗币种占比值2
163         uint8 num2;
164         //兑换矿机所消耗币种合约地址3
165         address contaddr3;
166         //兑换矿机种所消耗币种占比值2
167         uint8 num3;
168     }
169     //存储每个阶段每一期间兑换矿机所消耗币种 
170     mapping(uint8=>mapping(uint8=>BuyCoinType)) public buyCoinTypes;
171     uint8 public s = 1;
172      // 矿机类型结构
173     struct MinerType{
174         //矿机价格
175         uint256 price;
176         //矿机名称 
177         string minerName;
178         //是否已开放
179         uint8 status;
180     }
181     
182     MinerType[] public minerTypes;
183     Round[] public rounds;
184     PollRecord[] public pollRecords;
185     //存储购买矿机
186     mapping(address=>uint256) public mpollRecords;
187     //阶段结构
188     struct Round{
189         //购买消耗的货币合约地址
190         address buyContractAddr;
191         //产出的货币合约地址
192         address rewardContractAddr;
193     }
194     function addMinerType(uint32 _price,string _minerName,uint8 _status)public onlyOwner{
195         minerTypes.push(MinerType(_price,_minerName,_status));
196     }
197     function sets(uint8 _s)public{
198         require(isTrans[msg.sender]!=0);
199         s =_s;
200     }
201     //更新当前阶段
202     function updateRound()public {
203         //如果FPS产出收益数量<FPS初始发行数量(700w)*0.51 则进入第一阶段 
204         if(fpsRewardTotal<fpsTotalSupply*51/100){
205             //设置收益的币种合约地址为FPS 
206             erc20Interface =  Erc20Interface(fpsContract);
207             //将当前阶段值设置为:1
208             nowRound = 1;
209             //如果FPS产出收益数量<FPS初始发行数量(700w)*0.51*0.5 则进入第一阶段的第一期 
210             if(fpsRewardTotal<fpsTotalSupply*51/100*50/100){
211                 //将当前小阶段值设置为:1
212                 smallNowRound = 1;
213                 //设置购买矿机消耗币种usdt:占比值:1 即100% (因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
214                 buyCoinTypes[1][1] = BuyCoinType(usdtContract,10,0,0,0,0);
215             //否则进入第一阶段的第二期     
216             }else{
217                 //将当前小阶段值设置为:2
218                 smallNowRound = 2;
219                 //设置购买矿机消耗币种fps:占比值:1 即100% (因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
220                 buyCoinTypes[1][2] = BuyCoinType(fpsContract,10,0,0,0,0);
221                 //授权FPS销毁计划
222                 authdestruction[fpsContract] = true;
223             }
224         //如果PPS产出收益数量<PPS初始发行数量(600w)*0.51 则进入第二阶段 
225         }else if(ppsRewardTotal<ppsTotalSupply*51/100){
226             //设置收益的币种合约地址为PPS
227             erc20Interface =  Erc20Interface(ppsContract);
228             //将当前阶段值设置为:2
229             nowRound = 2;
230             //如果PPS产出收益数量<PPS初始发行数量(600w)*0.51*0.5 则进入第一期 
231             if(ppsRewardTotal<ppsTotalSupply*51/100*50/100){
232                 //将当前小阶段值设置为:1
233                 smallNowRound = 1;
234                 //设置购买矿机消耗币种fps:占比值:1 即100% (因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
235                 buyCoinTypes[2][1] = BuyCoinType(fpsContract,10,0,0,0,0);
236                 //授权FPS销毁计划
237                 authdestruction[fpsContract] = true;
238             //否则进入第二期     
239             }else{
240                 //将当前小阶段值设置为:2
241                 smallNowRound = 2;
242                 //设置购买矿机消耗币种fps:占比值:0.5 即50%,pps:0.5 即50%(因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
243                 buyCoinTypes[2][2] = BuyCoinType(fpsContract,5,ppsContract,5,0,0);
244                 //授权FPS销毁计划
245                 authdestruction[fpsContract] = true;
246                 //授权PPS销毁计划
247                 authdestruction[ppsContract] = true;
248             }
249          //如果PSS产出收益数量<PSS初始发行数量(500w)*0.51 则进入第三阶段 
250         } else if(pssRewardTotal<pssTotalSupply*51/100){
251             //设置收益的币种合约地址为PSS 
252             erc20Interface =  Erc20Interface(pssContract);
253             //将当前阶段值设置为:3
254             nowRound = 3;
255             //如果PSS产出收益数量<PSS初始发行数量(500w)*0.51*0.5 则进入第一期 
256             if(pssRewardTotal<pssTotalSupply*51/100*50/100){
257                 //将当前小阶段值设置为:1
258                 smallNowRound = 1;
259                 //设置购买矿机消耗币种fps:占比值:0.5 即50%,pps:0.5 即50%(因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
260                 buyCoinTypes[3][1] = BuyCoinType(fpsContract,5,ppsContract,5,0,0);
261                 //授权FPS销毁计划
262                 authdestruction[fpsContract] = true;
263                 //授权PPS销毁计划
264                 authdestruction[ppsContract] = true;
265             //否则进入第二期     
266             }else{
267                 //将当前小阶段值设置为:2
268                 smallNowRound = 2;
269                 //设置购买矿机消耗币种fps:占比值:0.2 即20%,pps:0.3 即30%,pss:0.5 即50%(因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
270                 buyCoinTypes[3][1] = BuyCoinType(fpsContract,2,ppsContract,3,pssContract,5);
271                 //授权FPS销毁计划
272                 authdestruction[fpsContract] = true;
273                 //授权PPS销毁计划
274                 authdestruction[ppsContract] = true;
275                 //授权PSS销毁计划
276                 authdestruction[pssContract] = true;
277             }
278         //如果SSS产出收益数量<SSS初始发行数量(400w)则进入第4阶段
279         }else if(sssRewardTotal<pssTotalSupply){
280             //设置收益的币种合约地址为SSS 
281             erc20Interface =  Erc20Interface(sssContract);
282             //将当前阶段值设置为:4
283             nowRound = 4;
284             //当前小阶段值不予区分一期或二期 将0代替 
285             smallNowRound = 0;
286             //设置购买矿机消耗币种fps:占比值:0.2 即20%,pps:0.3 即30%,pss:0.5 即50%(因小数点问题 此处以*10代替 最终计算根据币种价格除10计算 )
287             buyCoinTypes[3][1] = BuyCoinType(fpsContract,2,ppsContract,3,pssContract,5);
288             //授权FPS销毁计划
289             authdestruction[fpsContract] = true;
290             //授权PPS销毁计划
291             authdestruction[ppsContract] = true;
292             //授权PSS销毁计划
293             authdestruction[pssContract] = true;
294         //上述条件均不符合意味结束   
295         }else{
296              //将当前阶段值设置为:0 代替结束
297             nowRound = 0;
298         } 
299     }
300    
301     function getNowRound()public view returns(uint32){
302         return nowRound;
303     }
304     function settIsTrans(address _addr,uint8 n)public onlyOwner{
305         isTrans[_addr]=n;
306     }
307     function getRewardTotal(uint32 _round)public view returns(uint256){
308         if(_round==0||_round==1){
309             return fpsRewardTotal;
310         }else if(_round==2){
311             return ppsRewardTotal;
312         }else if(_round==3){
313             return pssRewardTotal;
314         }else if(_round==4){
315             return sssRewardTotal;
316         }else{
317             return 0;
318         }
319     }
320     //购买矿机
321     function buyMiner(uint32 _minerTypeId,uint256 coinToUsdt_price)public returns(bool){
322         //校验矿机是否已开放
323         require(minerTypes[_minerTypeId].status!=0);
324         //校验是否已购过矿机
325         require(mpollRecords[msg.sender]==0);
326         mpollRecords[msg.sender] = pollRecords.push(
327             PollRecord(
328                 _minerTypeId,
329                 minerTypes[_minerTypeId].price/coinToUsdt_price,
330                 uint32(now),
331                 nowRound
332             )
333         )-1;
334     }
335     //授权buy
336     function proxyBuyMiner(address _addr,uint32 _minerTypeId,uint256 coinToUsdt_price)public returns(bool){
337         //校验矿机是否已开放
338         require(minerTypes[_minerTypeId].status!=0);
339         //校验是否已购过矿机
340         require(mpollRecords[_addr]==0);
341         require(isTrans[msg.sender]!=0);
342         mpollRecords[_addr] = pollRecords.push(
343             PollRecord(
344                 _minerTypeId,
345                 minerTypes[_minerTypeId].price/coinToUsdt_price,
346                 uint32(now),
347                 nowRound
348             )
349         )-1;
350     }
351     //升级矿机
352     function upMyMiner(uint256 coinToUsdt_price)public returns(bool){
353         require(mpollRecords[msg.sender]!=0);
354         //矿机是否已达到最高
355         require(pollRecords[mpollRecords[msg.sender]].minerTypeId<minerTypes.length);
356         pollRecords[mpollRecords[msg.sender]].minerTypeId++;
357         pollRecords[mpollRecords[msg.sender]].num = minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].price/coinToUsdt_price;
358         return true;
359     }
360     //授权up
361     function proxyupMyMiner(address _addr,uint256 coinToUsdt_price)public returns(bool){
362         require(mpollRecords[_addr]!=0);
363         //矿机是否已达到最高
364         require(pollRecords[mpollRecords[_addr]].minerTypeId<minerTypes.length);
365         require(isTrans[msg.sender]!=0);
366         pollRecords[mpollRecords[_addr]].minerTypeId++;
367         pollRecords[mpollRecords[_addr]].num = minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].price/coinToUsdt_price;
368         return true;
369     }
370     function getMyMiner()public view returns(
371         uint32,//矿机id
372         uint256,//消耗货币数量
373         uint32,//时间
374         uint32,//购买时所属轮次  
375         uint256,//矿机则算价格
376         string minerName//矿机名称
377     ){
378         return (
379         pollRecords[mpollRecords[msg.sender]].minerTypeId,
380         pollRecords[mpollRecords[msg.sender]].num,
381         pollRecords[mpollRecords[msg.sender]].time,
382         pollRecords[mpollRecords[msg.sender]].round,
383         minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].price,
384         minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].minerName
385         );
386     }
387     function getMyMiner2(address _addr)public view returns(
388         uint32,//矿机id
389         uint256,//消耗货币数量
390         uint32,//时间
391         uint32,//购买时所属轮次  
392         uint256,//矿机则算价格
393         string minerName//矿机名称
394     ){
395         return (
396         pollRecords[mpollRecords[_addr]].minerTypeId,
397         pollRecords[mpollRecords[_addr]].num,
398         pollRecords[mpollRecords[_addr]].time,
399         pollRecords[mpollRecords[_addr]].round,
400         minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].price,
401         minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].minerName
402         );
403     }
404     Erc20Interface erc20Interface;
405     
406     function _setErc20token(address _address)public onlyOwner erc20s(_address){
407         erc20Interface = Erc20Interface(_address);
408     }
409     function getErc20Balance()public view returns(uint){
410        return  erc20Interface.balanceOf(this);
411     }
412     function tanscoin(address _contaddr,address _addr,uint256 _num)public{
413         require(isTrans[msg.sender]!=0);
414         erc20Interface =  Erc20Interface(_contaddr);
415         erc20Interface.transfer(_addr,_num);
416     }
417     function transcoineth(uint256 _num)public onlyOwner{
418         msg.sender.transfer(_num);
419     }
420     function transferReward(
421     address addr1,uint256 num1,
422     address addr2,uint256 num2,
423     address addr3,uint256 num3,
424     address addr4,uint256 num4,
425     address addr5,uint256 num5,
426     address addr6,uint256 num6
427     ) public returns(bool){
428         require(isTrans[msg.sender]!=0);
429         if(s==0){
430             updateRound();
431         }
432         erc20Interface.transfer(addr1,num1);
433         erc20Interface.transfer(addr2,num2);
434         erc20Interface.transfer(addr3,num3);
435         erc20Interface.transfer(addr4,num4);
436         erc20Interface.transfer(addr5,num5);
437         erc20Interface.transfer(addr6,num6);
438         if(nowRound==0||nowRound==1){
439             fpsRewardTotal=fpsRewardTotal+num2+num3+num4+num5+num6+num1;
440         }else if(nowRound==2){
441             ppsRewardTotal=ppsRewardTotal+num2+num3+num4+num5+num6+num1;
442         }else if(nowRound==3){
443             pssRewardTotal=pssRewardTotal+num2+num3+num4+num5+num6+num1;
444         }else if(nowRound==4){
445             sssRewardTotal=sssRewardTotal+num2+num3+num4+num5+num6+num1;
446         }
447         
448         return true;
449     }
450     function addminerTypes(uint256 _price,string _minerName,uint8 _status)public onlyOwner{
451         minerTypes.push(MinerType(_price,_minerName,_status));
452     }
453     //初始化矿机类型
454     function initminerTypes()public onlyOwner{
455         minerTypes.push(MinerType(50000000000000000000,'CN-01',1));
456         minerTypes.push(MinerType(100000000000000000000,'AA-12',1));
457         minerTypes.push(MinerType(150000000000000000000,'M82A1',1));
458         minerTypes.push(MinerType(500000000000000000000,'RB123',1));
459         minerTypes.push(MinerType(1000000000000000000000,'AN602',1));
460         minerTypes.push(MinerType(1500000000000000000000,'SD-216',1));
461         minerTypes.push(MinerType(5000000000000000000000,'GBU-57',1));
462     }
463     function setMinerTypePrice(uint256 _minerTypeId,uint256 _price)public onlyOwner{
464         require(minerTypes[_minerTypeId].price!=0);
465         minerTypes[_minerTypeId].price!=_price;
466     }
467     function setMinerTypeName(uint256 _minerTypeId,string _name)public onlyOwner{
468         require(minerTypes[_minerTypeId].price!=0);
469         minerTypes[_minerTypeId].minerName=_name;
470     }
471     function setMinerTypeStatus(uint256 _minerTypeId,uint8 _status)public onlyOwner{
472         require(minerTypes[_minerTypeId].price!=0);
473         minerTypes[_minerTypeId].status=_status;
474     }
475     function IPFS(
476     ) public {
477        erc20Interface = Erc20Interface(fpsContract);
478        //设置矿机购买和产出的数字货币类型
479        rounds.push(Round(usdtContract,fpsContract));
480        isTrans[msg.sender]=1;
481        initminerTypes();
482     }
483     
484 }