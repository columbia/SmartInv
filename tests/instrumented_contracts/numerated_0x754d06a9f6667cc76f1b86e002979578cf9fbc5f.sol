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
96 	function inputauction(uint auctids, address pusers, uint addmoneys,string useraddrs) public payable{
97 	    uint _now = now;
98 	    auctionlist storage c = auctionlisting[auctids];
99 	    require(c.ifend == false);
100 	    require(c.ifsend == 0);
101 	    
102 	    uint userbalance = canuse(pusers);
103 	    require(addmoneys > c.currentprice);
104 	    require(addmoneys <= c.endprice);
105 	   // uint userhasmoney = c.ausers[pusers];
106 	   require(addmoneys > c.ausers[pusers]);
107 	    uint money = addmoneys - c.ausers[pusers];
108 	    
109 	    require(userbalance >= money);
110 	    if(c.endtime < _now) {
111 	        c.ifend = true;
112 	    }else{
113 	        if(addmoneys == c.endprice){
114 	            c.ifend = true;
115 	        }
116 	        btyc.transfer(this, money);
117 	        c.ausers[pusers] = addmoneys;
118 	        c.currentprice = addmoneys;
119 	        c.aucusers[c.lastid++] = putusers(pusers, _now, addmoneys,  useraddrs);
120 	    
121 	        userlist[pusers].push(auctids);
122 	        //emit auctconfim(pusers, money);
123 	    }
124 	    
125 	    
126 	    //}
127 	    
128 	}
129 	//获取用户自己竞拍的总数
130 	function getuserlistlength(address uaddr) public view returns(uint len) {
131 	    len = userlist[uaddr].length;
132 	}
133 	//查看单个订单
134 	function viewauction(uint aid) public view returns(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, uint currentprices, string goodsnames, string goodspics, bool ifends, uint ifsends, uint anum){
135 		auctionlist storage c = auctionlisting[aid];
136 		addusers = c.adduser;//0
137 		opentimes = c.opentime;//1
138 		endtimes = c.endtime;//2
139 		onceprices = c.onceprice;//3
140 		openprices = c.openprice;//4
141 		endprices = c.endprice;//5
142 		currentprices = c.currentprice;//6
143 		goodspics = c.goodspic;//7
144 		goodsnames = c.goodsname;//8
145 		ifends = c.ifend;//9
146 		ifsends = c.ifsend;//10
147 		anum = c.lastid;//11
148 		
149 	}
150 	//获取单个订单的竞拍者数据
151 	function viewauctionlist(uint aid, uint uid) public view returns(address pusers,uint addtimes,uint addmoneys){
152 	    auctionlist storage c = auctionlisting[aid];
153 	    putusers storage u = c.aucusers[uid];
154 	    pusers = u.puser;//0
155 	    addtimes = u.addtime;//1
156 	    addmoneys = u.addmoney;//2
157 	}
158 	//获取所有竞拍商品的总数
159 	function getactlen() public view returns(uint) {
160 	    return(auctionlisting.length);
161 	}
162 	//获取投诉订单的总数
163 	function getacttslen() public view returns(uint) {
164 	    return(auctionlistts.length);
165 	}
166 	//获取竞拍完结的总数
167 	function getactendlen() public view returns(uint) {
168 	    return(auctionlistend.length);
169 	}
170 	//发布者设定发货
171 	function setsendgoods(uint auctids) public {
172 	    uint _now = now;
173 	     auctionlist storage c = auctionlisting[auctids];
174 	     require(c.adduser == msg.sender);
175 	     require(c.endtime < _now);
176 	     require(c.ifsend == 0);
177 	     c.ifsend = 1;
178 	     c.ifend = true;
179 	}
180 	//竞拍者收到货物后动作
181 	function setgetgoods(uint auctids) public {
182 	    uint _now = now;
183 	    auctionlist storage c = auctionlisting[auctids];
184 	    require(c.endtime < _now);
185 	    require(c.ifend == true);
186 	    require(c.ifsend == 1);
187 	    putusers storage lasttuser = c.aucusers[c.lastid];
188 	    require(lasttuser.puser == msg.sender);
189 	    c.ifsend = 2;
190 	    uint getmoney = lasttuser.addmoney*70/100;
191 	    btyc.mintToken(c.adduser, getmoney);
192 	    auctionlistend.push(c);
193 	}
194 	//获取用户的发货地址（发布者）
195 	function getuseraddress(uint auctids) public view returns(string){
196 	    auctionlist storage c = auctionlisting[auctids];
197 	    require(c.adduser == msg.sender);
198 	    //putusers memory mdata = c.aucusers[c.lastid];
199 	    return(c.aucusers[c.lastid].useraddr);
200 	}
201 	function editusetaddress(uint aid, string setaddr) public returns(bool){
202 	    auctionlist storage c = auctionlisting[aid];
203 	    putusers storage data = c.aucusers[c.lastid];
204 	    require(data.puser == msg.sender);
205 	    data.useraddr = setaddr;
206 	    return(true);
207 	}
208 	/*用户获取拍卖金额和返利，只能返利一次 */
209 	function endauction(uint auctids) public {
210 	    //uint _now = now;
211 	    auctionlist storage c = auctionlisting[auctids];
212 	    require(c.ifsend == 2);
213 	    uint len = c.lastid;
214 	    putusers storage firstuser = c.aucusers[0];
215         address suser = msg.sender;
216 	    
217 	    require(c.ifend == true);
218 	    require(len > 1);
219 	    require(c.ausers[suser] > 0);
220 	    uint sendmoney = 0;
221 	    if(len == 2) {
222 	        require(firstuser.puser == suser);
223 	        sendmoney = c.currentprice*3/10 + c.ausers[suser];
224 	    }else{
225 	        if(firstuser.puser == suser) {
226 	            sendmoney = c.currentprice*1/10 + c.ausers[suser];
227 	        }else{
228 	            uint onemoney = (c.currentprice*2/10)/(len-2);
229 	            sendmoney = onemoney + c.ausers[suser];
230 	        }
231 	    }
232 	    require(sendmoney > 0);
233 	    btyc.mintToken(suser, sendmoney);
234 	    c.ausers[suser] = 0;
235 	    emit getmoneys(suser, sendmoney);
236 	    
237 	}
238 	//设定拍卖标准价
239 	function setsystemprice(uint price) public onlyOwner{
240 	    systemprice = price;
241 	}
242 	//管理员冻结发布者和商品
243 	function setauctionother(uint auctids) public onlyOwner{
244 	    auctionlist storage c = auctionlisting[auctids];
245 	    btyc.freezeAccount(c.adduser, true);
246 	    c.ifend = true;
247 	    c.ifsend = 3;
248 	}
249 	//设定商品状态
250 	function setauctionsystem(uint auctids, uint setnum) public onlyOwner{
251 	    auctionlist storage c = auctionlisting[auctids]; 
252 	    c.ifend = true;
253 	    c.ifsend = setnum;
254 	}
255 	//设定商品正常
256 	function setauctionotherfree(uint auctids) public onlyOwner{
257 	    auctionlist storage c = auctionlisting[auctids];
258 	    btyc.freezeAccount(c.adduser, false);
259 	    c.ifsend = 2;
260 	}
261 	//投诉发布者未发货或货物不符
262 	function tsauction(uint auctids) public{
263 	   auctionlist storage c = auctionlisting[auctids];
264 	   uint _now = now;
265 	   require(c.endtime > _now);
266 	   require(c.endtime + 2 days < _now);
267 	   require(c.aucusers[c.lastid].puser == msg.sender);
268 	   if(c.endtime + 2 days < _now && c.ifsend == 0) {
269 	       c.ifsend = 5;
270 	       c.ifend = true;
271 	       auctionlistts.push(c);
272 	   }
273 	   if(c.endtime + 9 days < _now && c.ifsend == 1) {
274 	       c.ifsend = 5;
275 	       c.ifend = true;
276 	       auctionlistts.push(c);
277 	   }
278 	}
279 	//管理员设定违规竞拍返还竞拍者
280 	function endauctionother(uint auctids) public {
281 	    //uint _now = now;
282 	    auctionlist storage c = auctionlisting[auctids];
283 	    address suser = msg.sender;
284 	    require(c.ifsend == 3);
285 	    require(c.ausers[suser] > 0);
286 	    btyc.mintToken(suser,c.ausers[suser]);
287 	    c.ausers[suser] = 0;
288 	    emit getmoneys(suser, c.ausers[suser]);
289 	}
290 	
291 }
292 //btyc接口类
293 interface btycInterface {
294     //mapping(address => uint) balances;
295     function balanceOf(address _addr) external view returns (uint256);
296     function mintToken(address target, uint256 mintedAmount) external returns (bool);
297     function transfer(address to, uint tokens) external returns (bool);
298     function freezeAccount(address target, bool freeze) external returns (bool);
299     function getcanuse(address tokenOwner) external view returns(uint);
300 }