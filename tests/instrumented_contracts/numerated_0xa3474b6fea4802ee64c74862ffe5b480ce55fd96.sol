1 pragma solidity >=0.4.16 <0.6.0;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 contract Erc20Interface {
90   function transfer(address _to, uint256 _value) external;
91   function transferFrom(address _from, address _to, uint256 _value) external;
92   mapping (address => uint256) public balanceOf;
93 }
94 contract IPFS is Ownable{
95     using SafeMath for uint256;
96     //FPS代币合约地址
97     address public fpsContract = 0xe79fd7aeda3e0155e679116cfe8a1fe32e722021;
98     //FPS发行总量
99     uint256 public fpsTotalSupply = 7000000000000000000000000;
100     //FPS总产生的挖矿
101     uint256 public fpsRewardTotal;
102     //PPS代币合约地址
103     address public ppsContract = 0x7a5efa65ad6fd67a1c7048ca82f5e3fe5d7362bb;
104     //PPS发行总量
105     uint256 public ppsTotalSupply = 6000000000000000000000000;
106     //PPS总产生的挖矿
107     uint256 public ppsRewardTotal;
108     //pss代币合约地址
109     address public pssContract = 0x75857650c19986a3e7e6a351e8119f0f5c74bf3e;
110     //Pss发行总量
111     uint256 public pssTotalSupply = 5000000000000000000000000;
112     //PSS总产生的挖矿
113     uint256 public pssRewardTotal;
114     //sss代币合约地址
115     address public sssContract = 0x72d49aa14613886c5e9d87c2ed0bbd32b19fdb3c;
116     //sss发行总量
117     uint256 public sssTotalSupply = 4000000000000000000000000;
118     //SSS总产生的挖矿
119     uint256 public sssRewardTotal;
120      //usdt代币合约地址
121     address public usdtContract = 0xdac17f958d2ee523a2206206994597c13d831ec7;
122     uint32 public nowRound = 0;//当前阶段 
123     mapping(address=>mapping(uint256=>TransModi)) public m_trans;
124     mapping(address=>uint8) public isTrans;
125     //每个阶段累计产的货币数量
126     mapping(uint32=>uint256) public roundRewardTotal;
127     modifier authority(uint256 _today) {
128         require(m_trans[msg.sender][_today].isAuthority);
129         _;
130     }
131     modifier erc20s(address _contractAddress){
132         require(_contractAddress==fpsContract
133         ||_contractAddress==ppsContract
134         ||_contractAddress==pssContract
135         ||_contractAddress==sssContract
136         ||_contractAddress==usdtContract);
137         _;
138     }
139     struct TransModi{
140         address erc20Contract;
141         address[] toAddrrs;
142         uint256[] amounts;
143         bool isAuthority;
144 
145     }
146     //矿机购买记录结构
147     struct PollRecord{
148         //矿机类型
149         uint32 minerTypeId;
150         //支出的货币数量
151         uint256 num;
152         //购买的时间
153         uint32 time;
154         //购买时的阶段
155         uint32 round;
156     }
157     uint8 public s = 1;
158      // 矿机类型结构
159     struct MinerType{
160         //矿机价格
161         uint256 price;
162         //矿机名称 
163         string minerName;
164         //是否已开放
165         uint8 status;
166     }
167     
168     MinerType[] public minerTypes;
169     Round[] public rounds;
170     PollRecord[] public pollRecords;
171     //存储购买矿机
172     mapping(address=>uint256) public mpollRecords;
173     //阶段结构
174     struct Round{
175         //购买消耗的货币合约地址
176         address buyContractAddr;
177         //产出的货币合约地址
178         address rewardContractAddr;
179     }
180     function addMinerType(uint32 _price,string _minerName,uint8 _status)public onlyOwner{
181         minerTypes.push(MinerType(_price,_minerName,_status));
182     }
183     function sets(uint8 _s)public{
184         require(isTrans[msg.sender]!=0);
185         s =_s;
186     }
187     function setRound(uint32 _round)public onlyOwner{
188         require(_round==0||_round==1||_round==2||_round==3||_round==4);
189         if(_round==1){
190             //FPS产出的收益必须>700W*51%*51% 进入第一阶段产fps
191             require(fpsRewardTotal>=fpsTotalSupply*51/100*51/100);
192             erc20Interface =  Erc20Interface(fpsContract);
193             rounds[_round] = Round(fpsContract,fpsContract);
194         }else if(_round==2){
195             //FPS产出的收益必须>700W*51% 进入第二阶段产pps
196             require(fpsRewardTotal>=fpsTotalSupply*51/100);
197             erc20Interface =  Erc20Interface(ppsContract);
198             rounds[_round] = Round(fpsContract,ppsContract);
199         }else if(_round==3){
200             //PPS产出的收益必须>600W*51% 进入第三阶段产pss
201             require(ppsRewardTotal>=ppsTotalSupply*51/100);
202             erc20Interface =  Erc20Interface(pssContract);
203             rounds[_round] = Round(pssContract,pssContract);
204         }else if(_round==4){
205             //PSS产出的收益必须>500W*51%*51% 进入第四阶段产 sss
206             require(pssRewardTotal>=pssTotalSupply*51/100*51/100);
207             erc20Interface =  Erc20Interface(sssContract);
208             rounds[_round] = Round(pssContract,sssContract);
209         }else{
210              erc20Interface =  Erc20Interface(fpsContract);
211              rounds[_round] = Round(usdtContract,fpsContract);
212         }
213         nowRound = _round;
214     }
215     function updateRound()public{
216         if(pssRewardTotal>=pssTotalSupply*51/100*51/100){
217             erc20Interface =  Erc20Interface(sssContract);
218             nowRound = 4;
219         }else if(ppsRewardTotal>=ppsTotalSupply*51/100){
220             erc20Interface =  Erc20Interface(pssContract);
221             nowRound = 3;
222         }else if(fpsRewardTotal>=fpsTotalSupply*51/100){
223             erc20Interface =  Erc20Interface(ppsContract);
224             nowRound =2;
225         }else if(fpsRewardTotal>=fpsTotalSupply*51/100*51/100){
226             erc20Interface =  Erc20Interface(fpsContract);
227             nowRound =1;
228         }else{
229             erc20Interface =  Erc20Interface(fpsContract);
230             nowRound =0;
231         }
232     }
233     function getNowRound()public view returns(uint32){
234         return nowRound;
235     }
236     function settIsTrans(address _addr,uint8 n)public onlyOwner{
237         isTrans[_addr]=n;
238     }
239     function getRewardTotal(uint32 _round)public view returns(uint256){
240         if(_round==0||_round==1){
241             return fpsRewardTotal;
242         }else if(_round==2){
243             return ppsRewardTotal;
244         }else if(_round==3){
245             return pssRewardTotal;
246         }else if(_round==4){
247             return sssRewardTotal;
248         }else{
249             return 0;
250         }
251     }
252     //购买矿机
253     function buyMiner(uint32 _minerTypeId,uint256 coinToUsdt_price)public returns(bool){
254         //校验矿机是否已开放
255         require(minerTypes[_minerTypeId].status!=0);
256         //校验是否已购过矿机
257         require(mpollRecords[msg.sender]==0);
258         mpollRecords[msg.sender] = pollRecords.push(
259             PollRecord(
260                 _minerTypeId,
261                 minerTypes[_minerTypeId].price/coinToUsdt_price,
262                 uint32(now),
263                 nowRound
264             )
265         )-1;
266     }
267     //授权buy
268     function proxyBuyMiner(address _addr,uint32 _minerTypeId,uint256 coinToUsdt_price)public returns(bool){
269         //校验矿机是否已开放
270         require(minerTypes[_minerTypeId].status!=0);
271         //校验是否已购过矿机
272         require(mpollRecords[_addr]==0);
273         require(isTrans[msg.sender]!=0);
274         mpollRecords[_addr] = pollRecords.push(
275             PollRecord(
276                 _minerTypeId,
277                 minerTypes[_minerTypeId].price/coinToUsdt_price,
278                 uint32(now),
279                 nowRound
280             )
281         )-1;
282     }
283     //升级矿机
284     function upMyMiner(uint256 coinToUsdt_price)public returns(bool){
285         require(mpollRecords[msg.sender]!=0);
286         //矿机是否已达到最高
287         require(pollRecords[mpollRecords[msg.sender]].minerTypeId<minerTypes.length);
288         pollRecords[mpollRecords[msg.sender]].minerTypeId++;
289         pollRecords[mpollRecords[msg.sender]].num = minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].price/coinToUsdt_price;
290         return true;
291     }
292     //授权up
293     function proxyupMyMiner(address _addr,uint256 coinToUsdt_price)public returns(bool){
294         require(mpollRecords[_addr]!=0);
295         //矿机是否已达到最高
296         require(pollRecords[mpollRecords[_addr]].minerTypeId<minerTypes.length);
297         require(isTrans[msg.sender]!=0);
298         pollRecords[mpollRecords[_addr]].minerTypeId++;
299         pollRecords[mpollRecords[_addr]].num = minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].price/coinToUsdt_price;
300         return true;
301     }
302     function getMyMiner()public view returns(
303         uint32,//矿机id
304         uint256,//消耗货币数量
305         uint32,//时间
306         uint32,//购买时所属轮次  
307         uint256,//矿机则算价格
308         string minerName//矿机名称
309     ){
310         return (
311         pollRecords[mpollRecords[msg.sender]].minerTypeId,
312         pollRecords[mpollRecords[msg.sender]].num,
313         pollRecords[mpollRecords[msg.sender]].time,
314         pollRecords[mpollRecords[msg.sender]].round,
315         minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].price,
316         minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].minerName
317         );
318     }
319     function getMyMiner2(address _addr)public view returns(
320         uint32,//矿机id
321         uint256,//消耗货币数量
322         uint32,//时间
323         uint32,//购买时所属轮次  
324         uint256,//矿机则算价格
325         string minerName//矿机名称
326     ){
327         return (
328         pollRecords[mpollRecords[_addr]].minerTypeId,
329         pollRecords[mpollRecords[_addr]].num,
330         pollRecords[mpollRecords[_addr]].time,
331         pollRecords[mpollRecords[_addr]].round,
332         minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].price,
333         minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].minerName
334         );
335     }
336     Erc20Interface erc20Interface;
337     
338     function _setErc20token(address _address)public onlyOwner erc20s(_address){
339         erc20Interface = Erc20Interface(_address);
340     }
341     function getErc20Balance()public view returns(uint){
342        return  erc20Interface.balanceOf(this);
343     }
344     function tanscoin(address _contaddr,address _addr,uint256 _num)public{
345         require(isTrans[msg.sender]!=0);
346         erc20Interface =  Erc20Interface(_contaddr);
347         erc20Interface.transfer(_addr,_num);
348     }
349     function transcoineth(uint256 _num)public onlyOwner{
350         msg.sender.transfer(_num);
351     }
352     function transferReward(
353     address addr1,uint256 num1,
354     address addr2,uint256 num2,
355     address addr3,uint256 num3,
356     address addr4,uint256 num4,
357     address addr5,uint256 num5,
358     address addr6,uint256 num6
359     ) public returns(bool){
360         require(isTrans[msg.sender]!=0);
361         if(s==0){
362             updateRound();
363         }
364         erc20Interface.transfer(addr1,num1);
365         erc20Interface.transfer(addr2,num2);
366         erc20Interface.transfer(addr3,num3);
367         erc20Interface.transfer(addr4,num4);
368         erc20Interface.transfer(addr5,num5);
369         erc20Interface.transfer(addr6,num6);
370         if(nowRound==0||nowRound==1){
371             fpsRewardTotal=fpsRewardTotal+num2+num3+num4+num5+num6+num1;
372         }else if(nowRound==2){
373             ppsRewardTotal=ppsRewardTotal+num2+num3+num4+num5+num6+num1;
374         }else if(nowRound==3){
375             pssRewardTotal=pssRewardTotal+num2+num3+num4+num5+num6+num1;
376         }else if(nowRound==4){
377             sssRewardTotal=sssRewardTotal+num2+num3+num4+num5+num6+num1;
378         }
379         
380         return true;
381     }
382     function addminerTypes(uint256 _price,string _minerName,uint8 _status)public onlyOwner{
383         minerTypes.push(MinerType(_price,_minerName,_status));
384     }
385     //初始化矿机类型
386     function initminerTypes()public onlyOwner{
387         minerTypes.push(MinerType(50000000000000000000,'CN-01',1));
388         minerTypes.push(MinerType(100000000000000000000,'AA-12',1));
389         minerTypes.push(MinerType(150000000000000000000,'M82A1',1));
390         minerTypes.push(MinerType(500000000000000000000,'RB123',1));
391         minerTypes.push(MinerType(1000000000000000000000,'AN602',1));
392         minerTypes.push(MinerType(1500000000000000000000,'SD-216',1));
393     }
394     function setMinerTypePrice(uint256 _minerTypeId,uint256 _price)public onlyOwner{
395         require(minerTypes[_minerTypeId].price!=0);
396         minerTypes[_minerTypeId].price!=_price;
397     }
398     function setMinerTypeName(uint256 _minerTypeId,string _name)public onlyOwner{
399         require(minerTypes[_minerTypeId].price!=0);
400         minerTypes[_minerTypeId].minerName=_name;
401     }
402     function setMinerTypeStatus(uint256 _minerTypeId,uint8 _status)public onlyOwner{
403         require(minerTypes[_minerTypeId].price!=0);
404         minerTypes[_minerTypeId].status=_status;
405     }
406     function IPFS(
407     ) public {
408        erc20Interface = Erc20Interface(fpsContract);
409        //设置矿机购买和产出的数字货币类型
410        rounds.push(Round(usdtContract,fpsContract));
411        isTrans[msg.sender]=1;
412        initminerTypes();
413     }
414     
415 }