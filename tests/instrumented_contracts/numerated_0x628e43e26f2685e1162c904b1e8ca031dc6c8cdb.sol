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
46     auctionlist[] public auctionlistts; //竞拍结束的
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
60 	    require(opentimes < _now + 2 days);
61 	    require(endtimes > opentimes);
62 	    require(endtimes > _now + 2 days);
63 	    require(endtimes < opentimes + 2 days);
64 	    require(btyc.balanceOf(addusers) >= systemprice);
65 	    auctionlisting.push(auctionlist(addusers, opentimes, endtimes, openprices, endprices, onceprices, openprices, goodsnames, goodspics, false, 0, 0));
66 	    uint lastid = auctionlisting.length;
67 	    mypostauct[addusers].push(lastid);
68 	    return(lastid);
69 	}
70 	//发布者发布的数量
71 	function getmypostlastid() public view returns(uint){
72 	    return(mypostauct[msg.sender].length);
73 	}
74 	//发布者发布的订单id
75 	function getmypost(uint ids) public view returns(uint){
76 	    return(mypostauct[msg.sender][ids]);
77 	}
78 	//用户余额
79 	function balanceOf(address addr) public view returns(uint) {
80 	    return(btyc.balanceOf(addr));
81 	}
82 	//用户可用余额
83 	function canuse(address addr) public view returns(uint) {
84 	    return(btyc.getcanuse(addr));
85 	}
86 	//合约现有余额
87 	function ownerof() public view returns(uint) {
88 	    return(btyc.balanceOf(this));
89 	}
90 	//把合约余额转出
91 	function sendleftmoney(uint money, address toaddr) public onlyOwner{
92 	    btyc.transfer(toaddr, money);
93 	}
94 	/*用户竞拍*/
95 	function inputauction(uint auctids, address pusers, uint addmoneys,string useraddrs) public {
96 	    uint _now = now;
97 	    auctionlist storage c = auctionlisting[auctids];
98 	    require(c.ifend == false);
99 	    require(c.ifsend == 0);
100 	    
101 	    uint userbalance = canuse(pusers);
102 	    require(addmoneys > c.currentprice);
103 	    require(addmoneys <= c.endprice);
104 	    uint userhasmoney = c.ausers[pusers];
105 	    uint money = addmoneys;
106 	    if(userhasmoney > 0) {
107 	        require(addmoneys > userhasmoney);
108 	        money = addmoneys - userhasmoney;
109 	    }
110 	    
111 	    require(userbalance >= money);
112 	    if(c.endtime < _now) {
113 	        c.ifend = true;
114 	    }else{
115 	        if(addmoneys == c.endprice){
116 	            c.ifend = true;
117 	        }
118 	        btyc.transfer(this, money);
119 	        c.ausers[pusers] = addmoneys;
120 	        c.currentprice = addmoneys;
121 	        c.aucusers[c.lastid++] = putusers(pusers, _now, addmoneys,  useraddrs);
122 	    
123 	        userlist[pusers].push(auctids);
124 	        emit auctconfim(pusers, money);
125 	    }
126 	    
127 	    
128 	    //}
129 	    
130 	}
131 	//获取用户自己竞拍的总数
132 	function getuserlistlength(address uaddr) public view returns(uint len) {
133 	    len = userlist[uaddr].length;
134 	}
135 	//查看单个订单
136 	function viewauction(uint aid) public view returns(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, uint currentprices, string goodsnames, string goodspics, bool ifends, uint ifsends, uint anum){
137 		auctionlist storage c = auctionlisting[aid];
138 		addusers = c.adduser;//0
139 		opentimes = c.opentime;//1
140 		endtimes = c.endtime;//2
141 		onceprices = c.onceprice;//3
142 		openprices = c.openprice;//4
143 		endprices = c.endprice;//5
144 		currentprices = c.currentprice;//6
145 		goodspics = c.goodspic;//7
146 		goodsnames = c.goodsname;//8
147 		ifends = c.ifend;//9
148 		ifsends = c.ifsend;//10
149 		anum = c.lastid;//11
150 		
151 	}
152 	//获取单个订单的竞拍者数据
153 	function viewauctionlist(uint aid, uint uid) public view returns(address pusers,uint addtimes,uint addmoneys){
154 	    auctionlist storage c = auctionlisting[aid];
155 	    putusers storage u = c.aucusers[uid];
156 	    pusers = u.puser;//0
157 	    addtimes = u.addtime;//1
158 	    addmoneys = u.addmoney;//2
159 	}
160 	//获取所有竞拍商品的总数
161 	function getactlen() public view returns(uint) {
162 	    return(auctionlisting.length);
163 	}
164 	//获取投诉订单的总数
165 	function getacttslen() public view returns(uint) {
166 	    return(auctionlistts.length);
167 	}
168 	//获取竞拍完结的总数
169 	function getactendlen() public view returns(uint) {
170 	    return(auctionlistend.length);
171 	}
172 	//发布者设定发货
173 	function setsendgoods(uint auctids) public {
174 	    uint _now = now;
175 	     auctionlist storage c = auctionlisting[auctids];
176 	     require(c.adduser == msg.sender);
177 	     require(c.endtime < _now);
178 	     require(c.ifsend == 0);
179 	     c.ifsend = 1;
180 	     c.ifend = true;
181 	}
182 	//竞拍者收到货物后动作
183 	function setgetgoods(uint auctids) public {
184 	    uint _now = now;
185 	    auctionlist storage c = auctionlisting[auctids];
186 	    require(c.endtime < _now);
187 	    require(c.ifend == true);
188 	    require(c.ifsend == 1);
189 	    putusers storage lasttuser = c.aucusers[c.lastid];
190 	    require(lasttuser.puser == msg.sender);
191 	    c.ifsend = 2;
192 	    uint getmoney = lasttuser.addmoney*70/100;
193 	    btyc.mintToken(c.adduser, getmoney);
194 	    auctionlistend.push(c);
195 	}
196 	//获取用户的发货地址（发布者）
197 	function getuseraddress(uint auctids) public view returns(string){
198 	    auctionlist storage c = auctionlisting[auctids];
199 	    require(c.adduser == msg.sender);
200 	    //putusers memory mdata = c.aucusers[c.lastid];
201 	    return(c.aucusers[c.lastid].useraddr);
202 	}
203 	function editusetaddress(uint aid, string setaddr) public returns(bool){
204 	    auctionlist storage c = auctionlisting[aid];
205 	    putusers storage data = c.aucusers[c.lastid];
206 	    require(data.puser == msg.sender);
207 	    data.useraddr = setaddr;
208 	    return(true);
209 	}
210 	/*用户获取拍卖金额和返利，只能返利一次 */
211 	function endauction(uint auctids) public {
212 	    //uint _now = now;
213 	    auctionlist storage c = auctionlisting[auctids];
214 	    require(c.ifsend == 2);
215 	    uint len = c.lastid;
216 	    putusers storage firstuser = c.aucusers[0];
217         address suser = msg.sender;
218 	    
219 	    require(c.ifend == true);
220 	    require(len > 1);
221 	    require(c.ausers[suser] > 0);
222 	    uint sendmoney = 0;
223 	    if(len == 2) {
224 	        require(firstuser.puser == suser);
225 	        sendmoney = c.currentprice*3/10 + c.ausers[suser];
226 	    }else{
227 	        if(firstuser.puser == suser) {
228 	            sendmoney = c.currentprice*1/10 + c.ausers[suser];
229 	        }else{
230 	            uint onemoney = (c.currentprice*2/10)/(len-2);
231 	            sendmoney = onemoney + c.ausers[suser];
232 	        }
233 	    }
234 	    require(sendmoney > 0);
235 	    btyc.mintToken(suser, sendmoney);
236 	    c.ausers[suser] = 0;
237 	    emit getmoneys(suser, sendmoney);
238 	    
239 	}
240 	//设定拍卖标准价
241 	function setsystemprice(uint price) public onlyOwner{
242 	    systemprice = price;
243 	}
244 	//管理员冻结发布者和商品
245 	function setauctionother(uint auctids) public onlyOwner{
246 	    auctionlist storage c = auctionlisting[auctids];
247 	    btyc.freezeAccount(c.adduser, true);
248 	    c.ifend = true;
249 	    c.ifsend = 3;
250 	}
251 	//设定商品状态
252 	function setauctionsystem(uint auctids, uint setnum) public onlyOwner{
253 	    auctionlist storage c = auctionlisting[auctids]; 
254 	    c.ifend = true;
255 	    c.ifsend = setnum;
256 	}
257 	//设定商品正常
258 	function setauctionotherfree(uint auctids) public onlyOwner{
259 	    auctionlist storage c = auctionlisting[auctids];
260 	    btyc.freezeAccount(c.adduser, false);
261 	    c.ifsend = 2;
262 	}
263 	//投诉发布者未发货或货物不符
264 	function tsauction(uint auctids) public{
265 	   auctionlist storage c = auctionlisting[auctids];
266 	   uint _now = now;
267 	   require(c.endtime > _now);
268 	   require(c.endtime + 2 days < _now);
269 	   require(c.aucusers[c.lastid].puser == msg.sender);
270 	   if(c.endtime + 2 days < _now && c.ifsend == 0) {
271 	       c.ifsend = 5;
272 	       c.ifend = true;
273 	       auctionlistts.push(c);
274 	   }
275 	   if(c.endtime + 9 days < _now && c.ifsend == 1) {
276 	       c.ifsend = 5;
277 	       c.ifend = true;
278 	       auctionlistts.push(c);
279 	   }
280 	}
281 	//管理员设定违规竞拍返还竞拍者
282 	function endauctionother(uint auctids) public {
283 	    //uint _now = now;
284 	    auctionlist storage c = auctionlisting[auctids];
285 	    address suser = msg.sender;
286 	    require(c.ifsend == 3);
287 	    require(c.ausers[suser] > 0);
288 	    btyc.mintToken(suser,c.ausers[suser]);
289 	    c.ausers[suser] = 0;
290 	    emit getmoneys(suser, c.ausers[suser]);
291 	}
292 	
293 }
294 //btyc接口类
295 interface btycInterface {
296     //mapping(address => uint) balances;
297     function balanceOf(address _addr) external view returns (uint256);
298     function mintToken(address target, uint256 mintedAmount) external returns (bool);
299     function transfer(address to, uint tokens) external returns (bool);
300     function freezeAccount(address target, bool freeze) external returns (bool);
301     function getcanuse(address tokenOwner) external view returns(uint);
302 }