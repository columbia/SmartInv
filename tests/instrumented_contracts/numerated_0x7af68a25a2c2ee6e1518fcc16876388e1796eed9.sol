1 pragma solidity ^ 0.4.25;
2 /* 创建一个父类， 账户管理员 */
3 contract owned {
4 
5     address public owner;
6 
7     constructor() public {
8     owner = msg.sender;
9     }
10     /* modifier是修改标志 */
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }   
19 }
20 contract lepaitoken is owned{
21     uint public systemprice;
22     struct putusers{
23 	    	address puser;//竞拍人
24 	    	uint addtime;//竞拍时间
25 	    	uint addmoney; //竞拍价格
26 	    	string useraddr; //竞拍人地址 
27     }
28     struct auctionlist{
29         address adduser;//添加人0
30         uint opentime;//开始时间1
31         uint endtime;//结束时间2
32         uint openprice;//起拍价格3
33         uint endprice;//最高价格4
34         uint onceprice;//每次加价5
35         uint currentprice;//当前价格6
36         string goodsname; //商品名字7
37         string goodspic; //商品图片8 
38         bool ifend;//是否结束9
39         uint ifsend;//是否发货10
40         uint lastid;//竞拍数11
41         mapping(uint => putusers) aucusers;//竞拍人的数据组
42         mapping(address => uint) ausers;//竞拍人的竞拍价格
43     }
44     auctionlist[] public auctionlisting; //竞拍中的
45     auctionlist[] public auctionlistend; //竞拍结束的
46     auctionlist[] public auctionlistts; //竞拍投诉 
47     mapping(address => uint[]) userlist;//用户所有竞拍的订单
48     mapping(address => uint[]) mypostauct;//发布者所有发布的订单
49     //0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA
50     btycInterface constant private btyc = btycInterface(0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA);
51     /* 通知 */
52 	event auctconfim(address target, uint tokens);//竞拍成功通知
53 	event getmoneys(address target, uint tokens);//获取返利通知
54 	constructor() public {
55 	    systemprice = 20000 ether;
56 	}
57 	/*添加拍卖 */
58 	function addauction(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, string goodsnames, string goodspics) public returns(uint){
59 	    uint _now = now;
60 	    require(opentimes >= _now - 1 hours);
61 	    require(opentimes < _now + 2 days);
62 	    require(endtimes > opentimes);
63 	    //require(endtimes > _now + 2 days);
64 	    require(endtimes < opentimes + 2 days);
65 	    require(btyc.balanceOf(addusers) >= systemprice);
66 	    auctionlisting.push(auctionlist(addusers, opentimes, endtimes, openprices, endprices, onceprices, openprices, goodsnames, goodspics, false, 0, 0));
67 	    uint lastid = auctionlisting.length;
68 	    mypostauct[addusers].push(lastid);
69 	    return(lastid);
70 	}
71 	//发布者发布的数量
72 	function getmypostlastid() public view returns(uint){
73 	    return(mypostauct[msg.sender].length);
74 	}
75 	//发布者发布的订单id
76 	function getmypost(uint ids) public view returns(uint){
77 	    return(mypostauct[msg.sender][ids]);
78 	}
79 	//用户余额
80 	function balanceOf(address addr) public view returns(uint) {
81 	    return(btyc.balanceOf(addr));
82 	}
83 	//用户可用余额
84 	function canuse(address addr) public view returns(uint) {
85 	    return(btyc.getcanuse(addr));
86 	}
87 	//合约现有余额
88 	function ownerof() public view returns(uint) {
89 	    return(btyc.balanceOf(this));
90 	}
91 	//把合约余额转出
92 	function sendleftmoney(uint money, address toaddr) public onlyOwner{
93 	    btyc.transfer(toaddr, money);
94 	}
95 	/*用户竞拍*/
96 	function inputauction(uint auctids, address pusers, uint addmoneys,string useraddrs) public {
97 	    uint _now = now;
98 	    auctionlist storage c = auctionlisting[auctids];
99 	    require(c.ifend == false);
100 	    require(c.ifsend == 0);
101 	    
102 	    uint userbalance = canuse(pusers);
103 	    require(addmoneys > c.currentprice);
104 	    require(addmoneys <= c.endprice);
105 	    uint userhasmoney = c.ausers[pusers];
106 	    uint money = addmoneys;
107 	    if(userhasmoney > 0) {
108 	        require(addmoneys > userhasmoney);
109 	        money = addmoneys - userhasmoney;
110 	    }
111 	    
112 	    require(userbalance >= money);
113 	    if(c.endtime < _now) {
114 	        c.ifend = true;
115 	    }else{
116 	        if(addmoneys == c.endprice){
117 	            c.ifend = true;
118 	        }
119 	        btyc.transfer(this, money);
120 	        c.ausers[pusers] = addmoneys;
121 	        c.currentprice = addmoneys;
122 	        c.aucusers[c.lastid++] = putusers(pusers, _now, addmoneys,  useraddrs);
123 	    
124 	        userlist[pusers].push(auctids);
125 	        emit auctconfim(pusers, money);
126 	    }
127 	    
128 	    
129 	    //}
130 	    
131 	}
132 	//获取用户自己竞拍的总数
133 	function getuserlistlength(address uaddr) public view returns(uint len) {
134 	    len = userlist[uaddr].length;
135 	}
136 	//查看单个订单
137 	function viewauction(uint aid) public view returns(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, uint currentprices, string goodsnames, string goodspics, bool ifends, uint ifsends, uint anum){
138 		auctionlist storage c = auctionlisting[aid];
139 		addusers = c.adduser;//0
140 		opentimes = c.opentime;//1
141 		endtimes = c.endtime;//2
142 		onceprices = c.onceprice;//3
143 		openprices = c.openprice;//4
144 		endprices = c.endprice;//5
145 		currentprices = c.currentprice;//6
146 		goodspics = c.goodspic;//7
147 		goodsnames = c.goodsname;//8
148 		ifends = c.ifend;//9
149 		ifsends = c.ifsend;//10
150 		anum = c.lastid;//11
151 		
152 	}
153 	//获取单个订单的竞拍者数据
154 	function viewauctionlist(uint aid, uint uid) public view returns(address pusers,uint addtimes,uint addmoneys){
155 	    auctionlist storage c = auctionlisting[aid];
156 	    putusers storage u = c.aucusers[uid];
157 	    pusers = u.puser;//0
158 	    addtimes = u.addtime;//1
159 	    addmoneys = u.addmoney;//2
160 	}
161 	//获取所有竞拍商品的总数
162 	function getactlen() public view returns(uint) {
163 	    return(auctionlisting.length);
164 	}
165 	//获取投诉订单的总数
166 	function getacttslen() public view returns(uint) {
167 	    return(auctionlistts.length);
168 	}
169 	//获取竞拍完结的总数
170 	function getactendlen() public view returns(uint) {
171 	    return(auctionlistend.length);
172 	}
173 	//发布者设定发货
174 	function setsendgoods(uint auctids) public {
175 	    uint _now = now;
176 	     auctionlist storage c = auctionlisting[auctids];
177 	     require(c.adduser == msg.sender);
178 	     require(c.endtime < _now);
179 	     require(c.ifsend == 0);
180 	     c.ifsend = 1;
181 	     c.ifend = true;
182 	}
183 	//竞拍者收到货物后动作
184 	function setgetgoods(uint auctids) public {
185 	    uint _now = now;
186 	    auctionlist storage c = auctionlisting[auctids];
187 	    require(c.endtime < _now);
188 	    require(c.ifend == true);
189 	    require(c.ifsend == 1);
190 	    putusers storage lasttuser = c.aucusers[c.lastid];
191 	    require(lasttuser.puser == msg.sender);
192 	    c.ifsend = 2;
193 	    uint getmoney = lasttuser.addmoney*70/100;
194 	    btyc.mintToken(c.adduser, getmoney);
195 	    auctionlistend.push(c);
196 	}
197 	//获取用户的发货地址（发布者）
198 	function getuseraddress(uint auctids) public view returns(string){
199 	    auctionlist storage c = auctionlisting[auctids];
200 	    require(c.adduser == msg.sender);
201 	    //putusers memory mdata = c.aucusers[c.lastid];
202 	    return(c.aucusers[c.lastid].useraddr);
203 	}
204 	function editusetaddress(uint aid, string setaddr) public returns(bool){
205 	    auctionlist storage c = auctionlisting[aid];
206 	    putusers storage data = c.aucusers[c.lastid];
207 	    require(data.puser == msg.sender);
208 	    data.useraddr = setaddr;
209 	    return(true);
210 	}
211 	/*用户获取拍卖金额和返利，只能返利一次 */
212 	function endauction(uint auctids) public {
213 	    //uint _now = now;
214 	    auctionlist storage c = auctionlisting[auctids];
215 	    require(c.ifsend == 2);
216 	    uint len = c.lastid;
217 	    putusers storage firstuser = c.aucusers[0];
218         address suser = msg.sender;
219 	    
220 	    require(c.ifend == true);
221 	    require(len > 1);
222 	    require(c.ausers[suser] > 0);
223 	    uint sendmoney = 0;
224 	    if(len == 2) {
225 	        require(firstuser.puser == suser);
226 	        sendmoney = c.currentprice*3/10 + c.ausers[suser];
227 	    }else{
228 	        if(firstuser.puser == suser) {
229 	            sendmoney = c.currentprice*1/10 + c.ausers[suser];
230 	        }else{
231 	            uint onemoney = (c.currentprice*2/10)/(len-2);
232 	            sendmoney = onemoney + c.ausers[suser];
233 	        }
234 	    }
235 	    require(sendmoney > 0);
236 	    btyc.mintToken(suser, sendmoney);
237 	    c.ausers[suser] = 0;
238 	    emit getmoneys(suser, sendmoney);
239 	    
240 	}
241 	//设定拍卖标准价
242 	function setsystemprice(uint price) public onlyOwner{
243 	    systemprice = price;
244 	}
245 	//管理员冻结发布者和商品
246 	function setauctionother(uint auctids) public onlyOwner{
247 	    auctionlist storage c = auctionlisting[auctids];
248 	    btyc.freezeAccount(c.adduser, true);
249 	    c.ifend = true;
250 	    c.ifsend = 3;
251 	}
252 	//设定商品状态
253 	function setauctionsystem(uint auctids, uint setnum) public onlyOwner{
254 	    auctionlist storage c = auctionlisting[auctids]; 
255 	    c.ifend = true;
256 	    c.ifsend = setnum;
257 	}
258 	//设定商品正常
259 	function setauctionotherfree(uint auctids) public onlyOwner{
260 	    auctionlist storage c = auctionlisting[auctids];
261 	    btyc.freezeAccount(c.adduser, false);
262 	    c.ifsend = 2;
263 	}
264 	//投诉发布者未发货或货物不符
265 	function tsauction(uint auctids) public{
266 	   auctionlist storage c = auctionlisting[auctids];
267 	   uint _now = now;
268 	   require(c.endtime > _now);
269 	   require(c.endtime + 2 days < _now);
270 	   require(c.aucusers[c.lastid].puser == msg.sender);
271 	   if(c.endtime + 2 days < _now && c.ifsend == 0) {
272 	       c.ifsend = 5;
273 	       c.ifend = true;
274 	       auctionlistts.push(c);
275 	   }
276 	   if(c.endtime + 9 days < _now && c.ifsend == 1) {
277 	       c.ifsend = 5;
278 	       c.ifend = true;
279 	       auctionlistts.push(c);
280 	   }
281 	}
282 	//管理员设定违规竞拍返还竞拍者
283 	function endauctionother(uint auctids) public {
284 	    //uint _now = now;
285 	    auctionlist storage c = auctionlisting[auctids];
286 	    address suser = msg.sender;
287 	    require(c.ifsend == 3);
288 	    require(c.ausers[suser] > 0);
289 	    btyc.mintToken(suser,c.ausers[suser]);
290 	    c.ausers[suser] = 0;
291 	    emit getmoneys(suser, c.ausers[suser]);
292 	}
293 	
294 }
295 //btyc接口类
296 interface btycInterface {
297     //mapping(address => uint) balances;
298     function balanceOf(address _addr) external view returns (uint256);
299     function mintToken(address target, uint256 mintedAmount) external returns (bool);
300     function transfer(address to, uint tokens) external returns (bool);
301     function freezeAccount(address target, bool freeze) external returns (bool);
302     function getcanuse(address tokenOwner) external view returns(uint);
303 }