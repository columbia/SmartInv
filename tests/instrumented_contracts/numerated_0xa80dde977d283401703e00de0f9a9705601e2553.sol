1 pragma solidity ^ 0.4.25;
2 
3 /* 创建一个父类， 账户管理员 */
4 contract owned {
5 
6     address public owner;
7 
8     constructor() public {
9     owner = msg.sender;
10     }
11     /* modifier是修改标志 */
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }   
20 }
21 contract lepaitoken is owned{
22     using SafeMath for uint;
23     string public symbol;
24 	string public name;
25 	uint8 public decimals;
26     uint public systemprice;
27     struct putusers{
28 	    	address puser;//竞拍人
29 	    	uint addtime;//竞拍时间
30 	    	uint addmoney; //竞拍价格
31 	    	string useraddr; //竞拍人地址 
32     }
33     struct auctionlist{
34         address adduser;//添加人0
35         uint opentime;//开始时间1
36         uint endtime;//结束时间2
37         uint openprice;//起拍价格3
38         uint endprice;//最高价格4
39         uint onceprice;//每次加价5
40         uint currentprice;//当前价格6
41         string goodsname; //商品名字7
42         string goodspic; //商品图片8 
43         bool ifend;//是否结束9
44         uint ifsend;//是否发货10
45         uint lastid;//竞拍数11
46         mapping(uint => putusers) aucusers;//竞拍人的数据组
47         mapping(address => uint) ausers;//竞拍人的竞拍价格
48     }
49     auctionlist[] public auctionlisting; //竞拍中的
50     auctionlist[] public auctionlistend; //竞拍结束的
51     auctionlist[] public auctionlistts; //竞拍投诉 
52     mapping(address => uint[]) userlist;//用户所有竞拍的订单
53     mapping(address => uint[]) mypostauct;//发布者所有发布的订单
54     mapping(address => uint) balances;
55     //管理员帐号
56 	mapping(address => bool) public admins;
57 	/* 冻结账户 */
58 	mapping(address => bool) public frozenAccount;
59 	bool public actived;
60     //0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA
61     address btycaddress = 0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA;
62     btycInterface constant private btyc = btycInterface(0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA);
63     /* 通知 */
64 	event auctconfim(address target, uint tokens);//竞拍成功通知
65 	event getmoneys(address target, uint tokens);//获取返利通知
66 	event Transfer(address indexed from, address indexed to, uint tokens);
67 	event FrozenFunds(address target, bool frozen);
68 	/* modifier是修改标志 */
69     modifier onlyadmin {
70         require(admins[msg.sender] == true);
71         _;
72     }
73 	constructor() public {
74 	    symbol = "BTYC";
75 		name = "BTYC Coin";
76 		decimals = 18;
77 	    systemprice = 20000 ether;
78 	    admins[owner] = true;
79 	    actived = true;
80 	}
81 	/*添加拍卖 */
82 	function addauction(uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, string goodsnames, string goodspics) public returns(uint){
83 	    uint _now = now;
84 	    address addusers = msg.sender;
85 	    require(actived == true);
86 	    require(!frozenAccount[addusers]);
87 	    require(opentimes >= _now - 1 hours);
88 	    require(opentimes < _now + 2 days);
89 	    require(endtimes > opentimes);
90 	    //require(endtimes > _now + 2 days);
91 	    require(endtimes < opentimes + 2 days);
92 	    require(btyc.balanceOf(addusers) >= systemprice);
93 	    auctionlisting.push(auctionlist(addusers, opentimes, endtimes, openprices, endprices, onceprices, openprices, goodsnames, goodspics, false, 0, 0));
94 	    uint lastid = auctionlisting.length;
95 	    mypostauct[addusers].push(lastid);
96 	    return(lastid);
97 	}
98 	//发布者发布的数量
99 	function getmypostlastid() public view returns(uint){
100 	    return(mypostauct[msg.sender].length);
101 	}
102 	//发布者发布的订单id
103 	function getmypost(uint ids) public view returns(uint){
104 	    return(mypostauct[msg.sender][ids]);
105 	}
106 	/* 获取用户金额 */
107 	function balanceOf(address tokenOwner) public view returns(uint balance) {
108 		return balances[tokenOwner];
109 	}
110 	//btyc用户余额
111 	function btycBalanceOf(address addr) public view returns(uint) {
112 	    return(btyc.balanceOf(addr));
113 	}
114 	/* 私有的交易函数 */
115     function _transfer(address _from, address _to, uint _value) private {
116         // 防止转移到0x0
117         require(_to != 0x0);
118         require(actived == true);
119         // 检测发送者是否有足够的资金
120         require(balances[_from] >= _value);
121         // 检查是否溢出（数据类型的溢出）
122         require(balances[_to] + _value > balances[_to]);
123         // 将此保存为将来的断言， 函数最后会有一个检验
124         uint previousBalances = balances[_from] + balances[_to];
125         // 减少发送者资产
126         balances[_from] -= _value;
127         // 增加接收者的资产
128         balances[_to] += _value;
129         emit Transfer(_from, _to, _value);
130         // 断言检测， 不应该为错
131         assert(balances[_from] + balances[_to] == previousBalances);
132     }
133     function transfer(address _to, uint256 _value) public returns(bool){
134         _transfer(msg.sender, _to, _value);
135     }
136     function transferadmin(address _from, address _to, uint _value)  public onlyadmin{
137         _transfer(_from, _to, _value);
138     }
139     function transferto(uint256 _value) public returns(bool){
140         _transfer(msg.sender, this, _value);
141     }
142 	function addusermoney(address addr, uint money) public onlyadmin{
143 	    balances[addr] = balances[addr].add(money);
144 		emit Transfer(this, addr, money);
145 	}
146 	//用户可用余额
147 	function canuse(address addr) public view returns(uint) {
148 	    return(btyc.getcanuse(addr));
149 	}
150 	//合约现有余额
151 	function btycownerof() public view returns(uint) {
152 	    return(btyc.balanceOf(this));
153 	}
154 	function ownerof() public view returns(uint) {
155 	    return(balances[this]);
156 	}
157 	//把合约余额转出
158 	function sendleftmoney(address _to, uint _value) public onlyadmin{
159 	     _transfer(this, _to, _value);
160 	}
161 	/*用户竞拍*/
162 	function inputauction(uint auctids, uint addmoneys, string useraddrs) public payable{
163 	    uint _now = now;
164 	    address pusers = msg.sender;
165 	    require(!frozenAccount[pusers]);
166 	    require(actived == true);
167 	    auctionlist storage c = auctionlisting[auctids];
168 	    require(c.ifend == false);
169 	    require(c.ifsend == 0);
170 	    
171 	    uint userbalance = canuse(pusers);
172 	    require(addmoneys > c.currentprice);
173 	    require(addmoneys <= c.endprice);
174 	   // uint userhasmoney = c.ausers[pusers];
175 	   require(addmoneys > c.ausers[pusers]);
176 	    uint money = addmoneys - c.ausers[pusers];
177 	    
178 	    require(userbalance >= money);
179 	    if(c.endtime < _now) {
180 	        c.ifend = true;
181 	    }else{
182 	        if(addmoneys == c.endprice){
183 	            c.ifend = true;
184 	        }
185 	        btycsubmoney(pusers, money);
186 	        c.ausers[pusers] = addmoneys;
187 	        c.currentprice = addmoneys;
188 	        c.aucusers[c.lastid++] = putusers(pusers, _now, addmoneys,  useraddrs);
189 	    
190 	        userlist[pusers].push(auctids);
191 	        //emit auctconfim(pusers, money);
192 	    }
193 	    
194 	    
195 	    //}
196 	    
197 	}
198 	//获取用户自己竞拍的总数
199 	function getuserlistlength(address uaddr) public view returns(uint len) {
200 	    len = userlist[uaddr].length;
201 	}
202 	//查看单个订单
203 	function viewauction(uint aid) public view returns(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, uint currentprices, string goodsnames, string goodspics, bool ifends, uint ifsends, uint anum){
204 		auctionlist storage c = auctionlisting[aid];
205 		addusers = c.adduser;//0
206 		opentimes = c.opentime;//1
207 		endtimes = c.endtime;//2
208 		onceprices = c.onceprice;//3
209 		openprices = c.openprice;//4
210 		endprices = c.endprice;//5
211 		currentprices = c.currentprice;//6
212 		goodspics = c.goodspic;//7
213 		goodsnames = c.goodsname;//8
214 		ifends = c.ifend;//9
215 		ifsends = c.ifsend;//10
216 		anum = c.lastid;//11
217 		
218 	}
219 	//获取单个订单的竞拍者数据
220 	function viewauctionlist(uint aid, uint uid) public view returns(address pusers,uint addtimes,uint addmoneys){
221 	    auctionlist storage c = auctionlisting[aid];
222 	    putusers storage u = c.aucusers[uid];
223 	    pusers = u.puser;//0
224 	    addtimes = u.addtime;//1
225 	    addmoneys = u.addmoney;//2
226 	}
227 	//获取所有竞拍商品的总数
228 	function getactlen() public view returns(uint) {
229 	    return(auctionlisting.length);
230 	}
231 	//获取投诉订单的总数
232 	function getacttslen() public view returns(uint) {
233 	    return(auctionlistts.length);
234 	}
235 	//获取竞拍完结的总数
236 	function getactendlen() public view returns(uint) {
237 	    return(auctionlistend.length);
238 	}
239 	//发布者设定发货
240 	function setsendgoods(uint auctids) public {
241 	    uint _now = now;
242 	     auctionlist storage c = auctionlisting[auctids];
243 	     require(!frozenAccount[msg.sender]);
244 	     require(c.adduser == msg.sender);
245 	     require(c.endtime < _now);
246 	     require(c.ifsend == 0);
247 	     c.ifsend = 1;
248 	     c.ifend = true;
249 	}
250 	//竞拍者收到货物后动作
251 	function setgetgoods(uint auctids) public {
252 	    uint _now = now;
253 	    require(actived == true);
254 	    require(!frozenAccount[msg.sender]);
255 	    auctionlist storage c = auctionlisting[auctids];
256 	    require(c.endtime < _now);
257 	    require(c.ifend == true);
258 	    require(c.ifsend == 1);
259 	    putusers storage lasttuser = c.aucusers[c.lastid];
260 	    require(lasttuser.puser == msg.sender);
261 	    c.ifsend = 2;
262 	    uint getmoney = lasttuser.addmoney*70/100;
263 	    btycaddmoney(c.adduser, getmoney);
264 	    auctionlistend.push(c);
265 	}
266 	//获取用户的发货地址（发布者）
267 	function getuseraddress(uint auctids) public view returns(string){
268 	    auctionlist storage c = auctionlisting[auctids];
269 	    require(c.adduser == msg.sender);
270 	    //putusers memory mdata = c.aucusers[c.lastid];
271 	    return(c.aucusers[c.lastid].useraddr);
272 	}
273 	function editusetaddress(uint aid, string setaddr) public returns(bool){
274 	    require(actived == true);
275 	    auctionlist storage c = auctionlisting[aid];
276 	    putusers storage data = c.aucusers[c.lastid];
277 	    require(data.puser == msg.sender);
278 	    require(!frozenAccount[msg.sender]);
279 	    data.useraddr = setaddr;
280 	    return(true);
281 	}
282 	/*用户获取拍卖金额和返利，只能返利一次 */
283 	function endauction(uint auctids) public {
284 	    //uint _now = now;
285 	    auctionlist storage c = auctionlisting[auctids];
286 	    require(actived == true);
287 	    require(c.ifsend == 2);
288 	    uint len = c.lastid;
289 	    putusers storage firstuser = c.aucusers[0];
290         address suser = msg.sender;
291 	    require(!frozenAccount[suser]);
292 	    require(c.ifend == true);
293 	    require(len > 1);
294 	    require(c.ausers[suser] > 0);
295 	    uint sendmoney = 0;
296 	    if(len == 2) {
297 	        require(firstuser.puser == suser);
298 	        sendmoney = c.currentprice*3/10 + c.ausers[suser];
299 	    }else{
300 	        if(firstuser.puser == suser) {
301 	            sendmoney = c.currentprice*1/10 + c.ausers[suser];
302 	        }else{
303 	            uint onemoney = (c.currentprice*2/10)/(len-2);
304 	            sendmoney = onemoney + c.ausers[suser];
305 	        }
306 	    }
307 	    require(sendmoney > 0);
308 	    c.ausers[suser] = 0;
309 	    btycaddmoney(suser, sendmoney);
310 	    emit getmoneys(suser, sendmoney);
311 	    
312 	}
313 	//设定拍卖标准价
314 	function setsystemprice(uint price) public onlyadmin{
315 	    systemprice = price;
316 	}
317 	//管理员冻结发布者和商品
318 	function setauctionother(uint auctids) public onlyadmin{
319 	    auctionlist storage c = auctionlisting[auctids];
320 	    btyc.freezeAccount(c.adduser, true);
321 	    c.ifend = true;
322 	    c.ifsend = 3;
323 	}
324 	//设定商品状态
325 	function setauctionsystem(uint auctids, uint setnum) public onlyadmin{
326 	    auctionlist storage c = auctionlisting[auctids]; 
327 	    c.ifend = true;
328 	    c.ifsend = setnum;
329 	}
330 	
331 	//设定商品正常
332 	function setauctionotherfree(uint auctids) public onlyadmin{
333 	    auctionlist storage c = auctionlisting[auctids];
334 	    btyc.freezeAccount(c.adduser, false);
335 	    c.ifsend = 2;
336 	}
337 	//投诉发布者未发货或货物不符
338 	function tsauction(uint auctids) public{
339 	    require(actived == true);
340 	   auctionlist storage c = auctionlisting[auctids];
341 	   uint _now = now;
342 	   require(c.endtime > _now);
343 	   require(c.endtime + 2 days < _now);
344 	   require(c.aucusers[c.lastid].puser == msg.sender);
345 	   if(c.endtime + 2 days < _now && c.ifsend == 0) {
346 	       c.ifsend = 5;
347 	       c.ifend = true;
348 	       auctionlistts.push(c);
349 	   }
350 	   if(c.endtime + 9 days < _now && c.ifsend == 1) {
351 	       c.ifsend = 5;
352 	       c.ifend = true;
353 	       auctionlistts.push(c);
354 	   }
355 	}
356 	//管理员设定违规竞拍返还竞拍者
357 	function endauctionother(uint auctids) public {
358 	    require(actived == true);
359 	    //uint _now = now;
360 	    auctionlist storage c = auctionlisting[auctids];
361 	    address suser = msg.sender;
362 	    require(c.ifsend == 3);
363 	    require(c.ausers[suser] > 0);
364 	    btycaddmoney(suser,c.ausers[suser]);
365 	    c.ausers[suser] = 0;
366 	    emit getmoneys(suser, c.ausers[suser]);
367 	}
368 	/*
369 	 * 设置管理员
370 	 * @param {Object} address
371 	 */
372 	function admAccount(address target, bool freeze) onlyOwner public {
373 		admins[target] = freeze;
374 	}
375 	function addbtycmoney(address addr, uint money) onlyadmin public{
376 	    btycaddmoney(addr, money);
377 	}
378 	function subbtycmoney(address addr, uint money) onlyadmin public{
379 	    btycsubmoney(addr, money);
380 	}
381 	function btycaddmoney(address addr, uint money) private{
382 	    address[] memory addrs =  new address[](1);
383 	    uint[] memory moneys =  new uint[](1);
384 	    addrs[0] = addr;
385 	    moneys[0] = money;
386 	    btyc.addBalances(addrs, moneys);
387 	    emit Transfer(this, addr, money);
388 	}
389 	function btycsubmoney(address addr, uint money) private{
390 	    address[] memory addrs =  new address[](1);
391 	    uint[] memory moneys =  new uint[](1);
392 	    addrs[0] = addr;
393 	    moneys[0] = money;
394 	    btyc.subBalances(addrs, moneys);
395 	    emit Transfer(addr, this, money);
396 	}
397 	/*
398 	 * 设置是否开启
399 	 * @param {Object} bool
400 	 */
401 	function setactive(bool tags) public onlyOwner {
402 		actived = tags;
403 	}
404 	// 冻结 or 解冻账户
405 	function freezeAccount(address target, bool freeze) public {
406 		require(admins[msg.sender] == true);
407 		frozenAccount[target] = freeze;
408 		emit FrozenFunds(target, freeze);
409 	}
410 	
411 }
412 //btyc接口类
413 interface btycInterface {
414     function balanceOf(address _addr) external view returns (uint256);
415     function mintToken(address target, uint256 mintedAmount) external returns (bool);
416     //function transfer(address to, uint tokens) external returns (bool);
417     function freezeAccount(address target, bool freeze) external returns (bool);
418     function getcanuse(address tokenOwner) external view returns(uint);
419     function addBalances(address[] recipients, uint256[] moenys) external returns(uint);
420     function subBalances(address[] recipients, uint256[] moenys) external returns(uint);
421 }
422 library SafeMath {
423 	function add(uint a, uint b) internal pure returns(uint c) {
424 		c = a + b;
425 		require(c >= a);
426 	}
427 
428 	function sub(uint a, uint b) internal pure returns(uint c) {
429 		require(b <= a);
430 		c = a - b;
431 	}
432 
433 	function mul(uint a, uint b) internal pure returns(uint c) {
434 		c = a * b;
435 		require(a == 0 || c / a == b);
436 	}
437 
438 	function div(uint a, uint b) internal pure returns(uint c) {
439 		require(b > 0);
440 		c = a / b;
441 	}
442 }