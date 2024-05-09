1 /**
2  * Source Code first verified at www.betbeb.com on Thursday, July 6, 2020
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * Math operations with safety checks
9  */
10  interface tokenTransfer {
11     function transfer(address receiver, uint amount);
12     function transferFrom(address _from, address _to, uint256 _value);
13     function balanceOf(address receiver) returns(uint256);
14 }
15 interface tokenTransfers {
16     function transfer(address receiver, uint amount);
17     function transferFrom(address _from, address _to, uint256 _value);
18     function balanceOf(address receiver) returns(uint256);
19 }
20 contract SafeMath {
21   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
28     assert(b > 0);
29     uint256 c = a / b;
30     assert(a == b * c + a % b);
31     return c;
32   }
33 
34   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
40     uint256 c = a + b;
41     assert(c>=a && c>=b);
42     return c;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 contract bitbeb is SafeMath{
52     tokenTransfer public bebTokenTransfer; //BEB 1.0代币 
53     tokenTransfers public bebTokenTransfers; //BEB 2.0代币 
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58 	address public owner;
59 	uint256 Destruction;//销毁数量
60 	uint256 BEBPrice;//初始价格0.00007142ETH
61 	uint256 RiseTime;//上涨时间
62 	uint256 attenuation;//衰减
63 	uint256 exchangeRate;//汇率默认1:14000
64 	uint256 TotalMachine;//矿机总量
65 	uint256 AccumulatedDays;//创世至今天数
66 	uint256 sumExbeb;//总流通
67 	uint256 BebAirdrop;//BEB空投
68 	uint256 AirdropSum;//空投冻结总量
69 	uint256 TimeDay;
70 	address[] public Airdrops;
71 	struct MinUser{
72          uint256 amount;//累计收益
73          uint256 MiningMachine;//矿机
74          uint256 WithdrawalTime;//取款时间
75          uint256 PendingRevenue;//待收益
76          uint256 dayRevenue;//日收益
77      }
78 
79     /* This creates an array with all balances */
80     mapping (address=>MinUser) public MinUsers;
81     mapping (address=>uint256) public locking;//锁定
82     mapping (address => uint256) public balanceOf;
83 	mapping (address => uint256) public freezeOf;
84     mapping (address => mapping (address => uint256)) public allowance;
85 
86     /* This generates a public event on the blockchain that will notify clients */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /* This notifies clients about the amount burnt */
90     event Burn(address indexed from, uint256 value);
91 	
92 	/* This notifies clients about the amount frozen */
93     event Freeze(address indexed from, uint256 value);
94 	
95 	/* This notifies clients about the amount unfrozen */
96     event Unfreeze(address indexed from, uint256 value);
97 
98     /* Initializes contract with initial supply tokens to the creator of the contract */
99     function bitbeb(
100         uint256 initialSupply,
101         string tokenName,
102         uint8 decimalUnits,
103         string tokenSymbol,
104         address _tokenAddress
105         ) {
106         name = tokenName; // Set the name for display purposes
107         symbol = tokenSymbol; // Set the symbol for display purposes
108         decimals = decimalUnits;  
109         totalSupply = initialSupply * 10 ** uint256(decimals);
110         balanceOf[address(this)] = totalSupply;  // Amount of decimals for display purposes
111 		owner = msg.sender;
112 		bebTokenTransfer = tokenTransfer(_tokenAddress);
113 		RiseTime=1578725653;//BEB价格初始化开始上涨时间
114 		BebAirdrop=388* 10 ** uint256(decimals);//初始空投388BEB
115 		BEBPrice=166600000000000;//初始价格0.0001666 ETH
116 		exchangeRate=6002;
117 		attenuation=5;
118 		TimeDay=86400;
119     }
120 
121     /* Send coins */
122     function transfer(address _to, uint256 _value) {
123         require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
124         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
125 		if (_value <= 0) throw; 
126         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
127         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
128         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
129         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
130         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
131     }
132     /* Allow another contract to spend some tokens in your behalf */
133     function approve(address _spender, uint256 _value)
134         returns (bool success) {
135 		if (_value <= 0) throw; 
136         allowance[msg.sender][_spender] = _value;
137         return true;
138     }
139        
140 
141     /* A contract attempts to get the coins */
142     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
143         require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
144         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
145 		if (_value <= 0) throw; 
146         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
147         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
148         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
149         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
150         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
151         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function burn(uint256 _value) returns (bool success) {
157         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
158 		if (_value <= 0) throw; 
159         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
160         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
161         Burn(msg.sender, _value);
162         return true;
163     }
164 	
165 	function freeze(uint256 _value) returns (bool success) {
166 	    require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
167         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
168 		if (_value <= 0) throw; 
169         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
170         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
171         Freeze(msg.sender, _value);
172         return true;
173     }
174 	
175 	function unfreeze(uint256 _value) returns (bool success) {
176 	    require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
177         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
178 		if (_value <= 0) throw; 
179         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
180 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
181         Unfreeze(msg.sender, _value);
182         return true;
183     }
184     //以下是矿机函数
185     function IntoBebMiner(uint256 _value)public{
186         if(_value<=0)throw;
187         require(_value>=1 ether*exchangeRate,"BEB The sum is too small");
188         MinUser storage _user=MinUsers[msg.sender];
189         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
190         uint256 _miner=SafeMath.safeDiv(_value,exchangeRate);
191         balanceOf[msg.sender]=SafeMath.safeSub(balanceOf[msg.sender], _value);
192         if(locking[msg.sender]>0){
193            if(locking[msg.sender]==1){
194             uint256 _shouyi=SafeMath.safeDiv(24000 ether,TotalMachine);
195             uint256 _time=SafeMath.safeSub(now, _user.WithdrawalTime);//计算出时间
196             uint256 _days=_time/TimeDay;
197             if(_days>0){
198                 uint256 _sumshouyi=SafeMath.safeMul(1000000000000000000,_shouyi);
199                 uint256 _BEBsumshouyi=SafeMath.safeMul(_sumshouyi,_days);
200                 bebTokenTransfers.transfer(msg.sender,_BEBsumshouyi);
201                 sumExbeb=SafeMath.safeAdd(sumExbeb,_sumshouyi); 
202             }
203           }else{
204             sumExbeb=SafeMath.safeAdd(sumExbeb,locking[msg.sender]); 
205             //AirdropjieDong=SafeMath.safeAdd(AirdropjieDong,locking[msg.sender]);//空投解冻
206             locking[msg.sender]=0;
207           }   
208         }
209          _user.MiningMachine=SafeMath.safeAdd(_user.MiningMachine,_miner);
210         _user.WithdrawalTime=now;
211         locking[msg.sender]=0;
212         totalSupply=SafeMath.safeSub(totalSupply, _value);//销毁
213         TotalMachine=SafeMath.safeAdd(TotalMachine,_miner);
214         Destruction=SafeMath.safeAdd(Destruction, _value);//销毁数量增加
215         sumExbeb=SafeMath.safeSub(sumExbeb,_value);
216         Burn(msg.sender, _value);   
217     }
218     function MinerToBeb()public{
219         if(now-RiseTime>TimeDay){
220             RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);
221             BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//每日固定上涨0.00000066ETH
222             AccumulatedDays+=1;//计算BEB创始天数
223             exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);
224         }
225         MinUser storage _user=MinUsers[msg.sender];
226         if(_user.MiningMachine>1000000000000000000){
227             if(locking[msg.sender]>1){
228                sumExbeb=SafeMath.safeAdd(sumExbeb,locking[msg.sender]); 
229                locking[msg.sender]=0;
230             }
231         }
232         require(_user.MiningMachine>0,"You don't have a miner");
233         require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
234         //判断用户是不是免费矿机或者空投用户，如果是返回，需要购买矿机后解锁
235         uint256 _miners=_user.MiningMachine;
236         uint256 _times=SafeMath.safeSub(now, _user.WithdrawalTime);
237         require(_times>TimeDay,"No withdrawal for less than 24 hours");
238         uint256 _days=SafeMath.safeDiv(_times,TimeDay);//计算总天数
239         uint256 _shouyi=SafeMath.safeDiv(240000 ether,TotalMachine);//计算每台矿机每天收益
240         uint256 _dayshouyi=SafeMath.safeMul(_miners,_shouyi);
241         //uint256 _daysumshouyi=SafeMath.safeDiv(_dayshouyi,1 ether);//计算用户每天总收益
242         uint256 _aaaa=SafeMath.safeMul(_dayshouyi,_days);
243             uint256 _attenuation=_miners*5/1000*_days;//计算每天衰减量
244             bebTokenTransfers.transfer(msg.sender,_aaaa);
245            _user.MiningMachine=SafeMath.safeSub( _user.MiningMachine,_attenuation);
246            _user.WithdrawalTime=now;
247            sumExbeb=SafeMath.safeAdd(sumExbeb,_aaaa);
248            TotalMachine=SafeMath.safeSub(TotalMachine,_attenuation);
249            _user.amount=SafeMath.safeAdd( _user.amount,_aaaa);
250     }
251     function FreeMiningMachine()public{
252         if(now-RiseTime>TimeDay){
253             RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);
254             BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//每日固定上涨0.00000066ETH
255             AccumulatedDays+=1;//计算BEB创始天数
256             exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);
257         }
258         require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
259         MinUser storage _user=MinUsers[msg.sender];
260         require(_user.MiningMachine==0,"I can't get it. You already have a miner");
261         //uint256 _miner=1000000000000000000;//0.1ETH
262         _user.MiningMachine=SafeMath.safeAdd(_user.MiningMachine,1000000000000000000);//增加0.1台矿机
263         _user.WithdrawalTime=now;
264         locking[msg.sender]=1;
265     }
266     //1.0 BEB兑换POS矿机
267     function OldBebToMiner(uint256 _value)public{
268       if(now<1582591205)throw;
269       uint256 _bebminer=SafeMath.safeDiv(_value,exchangeRate);
270       if(_bebminer<=0)throw;
271       MinUser storage _user=MinUsers[msg.sender];
272         bebTokenTransfer.transferFrom(msg.sender,address(this),_value);  
273         _user.MiningMachine=SafeMath.safeAdd(_user.MiningMachine,_bebminer);
274         _user.WithdrawalTime=now;
275         TotalMachine=SafeMath.safeAdd(TotalMachine,_bebminer);
276     }
277     //买BEB
278     function buyBeb(address _addr) payable public {
279         if(now-RiseTime>TimeDay){
280             RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);
281             BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//每日固定上涨0.00000066ETH
282             AccumulatedDays+=1;//计算BEB创始天数
283             exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);
284         }
285         uint256 amount = msg.value;
286         if(amount<=0)throw;
287         uint256 bebamountub=SafeMath.safeMul(amount,exchangeRate);
288         //require(bebamountub<=buyTota,"Exceeded the maximum quantity available for sale");
289         uint256 _transfer=amount*2/100;
290         uint256 _bebtoeth=amount*98/100;
291        require(balanceOf[_addr]>=bebamountub,"Sorry, your credit is running low");
292        bebTokenTransfers.transferFrom(_addr,msg.sender,bebamountub);
293         owner.transfer(_transfer);//支付2%手续费给项目方
294         _addr.transfer(_bebtoeth);
295         //sellTota=SafeMath.safeAdd(sellTota,bebamountub);
296        // buyTota=SafeMath.safeSub(buyTota,bebamountub);
297     }
298     // sellbeb-eth
299     function sellBeb(uint256 _sellbeb)public {
300         if(now-RiseTime>TimeDay){
301             RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);
302             BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//每日固定上涨0.00000066ETH
303             AccumulatedDays+=1;//计算BEB创始天数
304             exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);
305         }
306          require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
307          approve(address(this),_sellbeb);
308     }
309     //空投Airdrop
310     function AirdropBeb()public{
311         if(now-RiseTime>TimeDay){
312             RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);
313             BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//每日固定上涨0.00000066ETH
314             AccumulatedDays+=1;//计算BEB创始天数
315             exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);
316         }
317         MinUser storage _user=MinUsers[msg.sender];
318         require(_user.MiningMachine<=0);
319         require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");
320         uint256 _airbeb=SafeMath.safeMul(BebAirdrop,166600000000000);
321         BebAirdrop=SafeMath.safeDiv(_airbeb,BEBPrice);
322         bebTokenTransfers.transfer(msg.sender,BebAirdrop);//发送BEB
323         locking[msg.sender]=BebAirdrop;
324         AirdropSum=SafeMath.safeAdd(AirdropSum,BebAirdrop);
325     }
326     function setAddress(address[] _addr)public{
327         if(msg.sender != owner)throw;
328         Airdrops=_addr;
329     }
330     //执行空投
331     function batchAirdrop()public{
332         if(now<1586306405)throw;//2020年4月9日前可以使用这个空投函数
333         if(msg.sender != owner)throw;
334         for(uint i=0;i<Airdrops.length;i++){
335             bebTokenTransfers.transfer(Airdrops[i],BebAirdrop);
336             locking[Airdrops[i]]=BebAirdrop;
337         }
338     }
339     //初始化分配矿机
340     function setMiner(address _addr,uint256 _value)public{
341         if(msg.sender != owner)throw;
342         if(now>1580519056)throw;//2020年1月20日之后这个功能就不能使用了
343         MinUser storage _user=MinUsers[_addr];
344         _user.MiningMachine=_value;
345         _user.WithdrawalTime=now;
346         TotalMachine+=_value;
347     }
348     function setBebTokenTransfers(address _addr)public{
349         if(msg.sender != owner)throw;
350          if(now>1580519056)throw;//2020年1月20日之后这个功能就不能使用了
351         bebTokenTransfers=tokenTransfers(_addr);
352         
353     }
354     //个人查询总收益，矿机数量，取款时间，日收益
355     function getUser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256){
356             MinUser storage _user=MinUsers[_addr];
357             uint256 edays=240000 ether / TotalMachine;
358             uint256 _day=_user.MiningMachine*edays;
359          return (_user.amount,_user.MiningMachine,_user.WithdrawalTime,_day,(now-_user.WithdrawalTime)/TimeDay*_day);
360     }
361     function getQuanju()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
362         //uint256 Destruction;//销毁数量
363 	    //uint256 BEBPrice;//初始价格0.00007142ETH
364 	    //uint256 TotalMachine;//矿机总量
365 	    //uint256 AccumulatedDays;//创世至今天数
366 	    //uint256 sumExbeb;//BEB总流通
367 	    //uint256 BebAirdrop;//BEB每次空投数量
368             
369          return (TotalMachine,Destruction,sumExbeb,BEBPrice,AccumulatedDays,BebAirdrop);
370     }
371     function querBalance()public view returns(uint256){
372          return this.balance;
373      }
374      //项目方数据
375      function getowner()public view returns(uint256,uint256){ 
376          MinUser storage _user=MinUsers[owner];
377          return (_user.MiningMachine,balanceOf[owner]);
378     }
379     //以上是矿机函数
380 	// can accept ether
381 	function() payable {
382     }
383 }