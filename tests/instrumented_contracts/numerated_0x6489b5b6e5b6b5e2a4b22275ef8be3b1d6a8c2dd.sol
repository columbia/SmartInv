1 pragma solidity ^ 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 安全的加减乘除
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7 	function add(uint a, uint b) internal pure returns(uint c) {
8 		c = a + b;
9 		require(c >= a);
10 	}
11 
12 	function sub(uint a, uint b) internal pure returns(uint c) {
13 		require(b <= a);
14 		c = a - b;
15 	}
16 
17 	function mul(uint a, uint b) internal pure returns(uint c) {
18 		c = a * b;
19 		require(a == 0 || c / a == b);
20 	}
21 
22 	function div(uint a, uint b) internal pure returns(uint c) {
23 		require(b > 0);
24 		c = a / b;
25 	}
26 }
27 /* 创建一个父类， 账户管理员 */
28 contract owned {
29 
30     address public owner;
31 
32     constructor() public {
33     owner = msg.sender;
34     }
35 
36     /* modifier是修改标志 */
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
43     function transferOwnership(address newOwner) onlyOwner public {
44         owner = newOwner;
45     }   
46 }
47 contract lepaitoken is owned{
48     using SafeMath for uint;
49     //uint public lastid; //竞拍最后id 时间
50     uint public systemprice;
51     struct putusers{
52 	    	address puser;//竞拍人
53 	    	uint addtime;//竞拍时间
54 	    	uint addmoney; //竞拍价格
55 	    	//bool hasback;//是否已领取金额
56 	    	string useraddr; //竞拍人地址 
57     }
58     struct auctionlist{
59         address adduser;//添加人
60         uint opentime;//开始时间
61         uint endtime;//结束时间
62         uint openprice;//起拍价格
63         uint endprice;//最高价格
64         uint onceprice;//每次加价
65         uint currentprice;//当前价格
66         string goodsname; //商品名字
67         string goodspic; //商品图片 
68         bool ifend;//是否结束
69         uint ifsend;//是否发货
70         uint lastid;
71         //uint[] putids; //竞拍人id组
72         //putusers lastone;//最终获拍者
73         
74         //bool ifother;
75         mapping(uint => putusers) aucusers;//竞拍人id组
76         mapping(address => uint) ausers;
77         mapping(address => address) susers;
78     }
79     auctionlist[] public auctionlisting; //竞拍中的
80     auctionlist[] public auctionlistend; //竞拍结束的
81     auctionlist[] public auctionlistts; //竞拍结束的
82     mapping(address => uint[]) userlist;
83     mapping(address => uint[]) mypostauct;
84     //0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA
85     btycInterface constant private btyc = btycInterface(0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA);
86     /* 通知 */
87 	event auctconfim(address target, uint tokens);
88 	constructor() public {
89 	    systemprice = 20000 ether;
90 	    //lastid = 0;
91 	}
92 	/*添加拍卖 */
93 	function addauction(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, string goodsnames, string goodspics) public returns(uint){
94 	    uint _now = now;
95 	    //uint[] pids;
96 	    //putusers lastones;
97 	    //require(opentimes > _now);
98 	    require(opentimes < _now + 2 days);
99 	    require(endtimes > opentimes);
100 	    require(endtimes < opentimes + 2 days);
101 	    require(btyc.balanceOf(addusers) >= systemprice);
102 	    //uint i = auctionlisting.length;
103 	    //auctionlist memory pt = auctionlist(addusers, opentimes, endtimes, onceprices, openprices, openprices, endprices, goodsnames, goodspics, false, pids, lastone, 0);
104 	    auctionlisting.push(auctionlist(addusers, opentimes, endtimes, onceprices, openprices, openprices, endprices, goodsnames, goodspics, false, 0, 0));
105 	    uint lastid = auctionlisting.length;
106 	    mypostauct[addusers].push(lastid);
107 	    return(lastid);
108 	}
109 	function getmypostlastid() public view returns(uint){
110 	    return(mypostauct[msg.sender].length);
111 	}
112 	function getmypost(uint ids) public view returns(uint){
113 	    return(mypostauct[msg.sender][ids]);
114 	}
115 	function balanceOf(address addr) public view returns(uint) {
116 	    return(btyc.balanceOf(addr));
117 	}
118 	function canuse(address addr) public view returns(uint) {
119 	    return(btyc.getcanuse(addr));
120 	}
121 	function ownerof() public view returns(uint) {
122 	    return(btyc.balanceOf(this));
123 	}
124 	/*用户竞拍*/
125 	function inputauction(uint auctids, address pusers, uint addmoneys,string useraddrs) public {
126 	    uint _now = now;
127 	    auctionlist storage c = auctionlisting[auctids];
128 	    require(c.ifend == false);
129 	    require(c.ifsend == 0);
130 	    
131 	    uint userbalance = canuse(pusers);
132 	    require(addmoneys > c.currentprice);
133 	    require(addmoneys <= c.endprice);
134 	    uint money = addmoneys - c.ausers[pusers];
135 	    require(userbalance >= money);
136 	    
137 	    //else{
138 	    btyc.transfer(this, money);
139 	    c.ausers[pusers] = addmoneys;
140 	    c.susers[pusers] = pusers;
141 	    //c.putids.push(_now);
142 	    
143 	    c.currentprice = addmoneys;
144 	    c.aucusers[c.lastid++] = putusers(pusers, _now, addmoneys,  useraddrs);
145 	    //c.lastid = c.aucusers.length;
146 	    //c.lastone = c.aucusers[_now];
147 	    if(c.endtime < _now || addmoneys == c.endprice) {
148 	        //endauction(auctids);
149 	        c.ifend = true;
150 	        //btyc.mintToken
151 	    }
152 	    userlist[pusers].push(auctids);
153 	    emit auctconfim(pusers, money);
154 	    //}
155 	    
156 	}
157 	/*查看*/
158 	function viewauction(uint aid) public view returns(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, string goodsnames, string goodspics, bool ifends, uint ifsends, uint anum){
159 		auctionlist memory c = auctionlisting[aid];
160 		addusers = c.adduser;
161 		opentimes = c.opentime;
162 		endtimes = c.endtime;
163 		onceprices = c.onceprice;
164 		openprices = c.openprice;
165 		endprices = c.endprice;
166 		goodspics = c.goodspic;
167 		goodsnames = c.goodsname;
168 		ifends = c.ifend;
169 		ifsends = c.ifsend;
170 		anum = c.lastid;
171 	}
172 	function viewauctionlist(uint aid, uint uid) public view returns(address pusers,uint addtimes,uint addmoneys){
173 	    auctionlist storage c = auctionlisting[aid];
174 	    putusers storage u = c.aucusers[uid];
175 	    pusers = u.puser;
176 	    addtimes = u.addtime;
177 	    addmoneys = u.addmoney;
178 	}
179 	function getactlen() public view returns(uint) {
180 	    return(auctionlisting.length);
181 	}
182 	/*
183     function getlastid() public view  returns(uint){
184         return(lastid);
185     }*/
186 	/*
187 	function viewlisting(uint start, uint num) public view{
188 	    //uint len = auctionlisting.length;
189 	   // auctionlist[] rt;
190 	   address[] addusers;
191 	    for(uint i = lastid; i > i - start - num; i--) {
192 	        auctionlist c = auctionlisting[i];
193 	        //uint[] pt = [c.adduser,c.opentime,c.endtime];
194 	        addusers.push(c.adduser);
195 	    }
196 	    //return rt;
197 	    return(addusers);
198 	}*/
199 	function setsendgoods(uint auctids) public {
200 	    uint _now = now;
201 	     auctionlist storage c = auctionlisting[auctids];
202 	     require(c.adduser == msg.sender);
203 	     require(c.endtime < _now);
204 	     //if(c.endtime < _now) {
205 	     //   c.ifend = true;
206 	    //}
207 	     //require(c.ifend == true);
208 	     require(c.ifsend == 0);
209 	     c.ifsend = 1;
210 	     c.ifend = true;
211 	}
212 	function setgetgoods(uint auctids) public {
213 	    uint _now = now;
214 	    auctionlist storage c = auctionlisting[auctids];
215 	    require(c.endtime < _now);
216 	    require(c.ifend == true);
217 	    require(c.ifsend == 1);
218 	    putusers memory lasttuser = c.aucusers[c.lastid];
219 	    require(lasttuser.puser == msg.sender);
220 	    c.ifsend = 2;
221 	    uint getmoney = lasttuser.addmoney*70/100;
222 	    btyc.mintToken(c.adduser, getmoney);
223 	    auctionlistend.push(c);
224 	}
225 	function getuseraddress(uint auctids) public view returns(string){
226 	    auctionlist storage c = auctionlisting[auctids];
227 	    require(c.adduser == msg.sender);
228 	    //putusers memory mdata = c.aucusers[c.lastid];
229 	    return(c.aucusers[c.lastid].useraddr);
230 	}
231 	/*用户获取拍卖金额 */
232 	function endauction(uint auctids) public {
233 	    //uint _now = now;
234 	    auctionlist storage c = auctionlisting[auctids];
235 	    require(c.ifsend == 2);
236 	    //uint[] memory ids = c.putids;
237 	    uint len = c.lastid;
238 	    putusers memory firstuser = c.aucusers[0];
239 	    //putusers memory lasttuser = c.lastone;
240         address suser = msg.sender;
241 	    
242 	    require(c.ifend == true);
243 	    require(len > 1);
244 	    require(c.ausers[suser] > 0);
245 	    if(len == 2) {
246 	        require(firstuser.puser == suser);
247 	        //require(firstuser.hasback == false);
248 	        btyc.mintToken(suser,c.currentprice*3/10 + c.ausers[suser]);
249 	        
250 	    }else{
251 	       
252 	        if(firstuser.puser == suser) {
253 	            //require(firstuser.hasback == false);
254 	            btyc.mintToken(suser,c.currentprice*1/10 + c.ausers[suser]);
255 	            //firstuser.hasback = true;
256 	        }else{
257 	            uint onemoney = (c.currentprice*2/10)/(len-2);
258 	            btyc.mintToken(c.susers[suser],onemoney + c.ausers[suser]);
259 	        }
260 	    }
261 	    c.ausers[suser] = 0;
262 	    
263 	}
264 	function setsystemprice(uint price) public onlyOwner{
265 	    systemprice = price;
266 	}
267 	function setauctionother(uint auctids) public onlyOwner{
268 	    auctionlist storage c = auctionlisting[auctids];
269 	    btyc.freezeAccount(c.adduser, true);
270 	    c.ifsend = 3;
271 	}
272 	function setauctionotherfree(uint auctids) public onlyOwner{
273 	    auctionlist storage c = auctionlisting[auctids];
274 	    btyc.freezeAccount(c.adduser, false);
275 	    c.ifsend = 2;
276 	}
277 	
278 	function tsauction(uint auctids) public{
279 	   auctionlist storage c = auctionlisting[auctids];
280 	   uint _now = now;
281 	   require(c.endtime + 2 days < _now);
282 	   require(c.aucusers[c.lastid].puser == msg.sender);
283 	   if(c.endtime + 2 days < _now && c.ifsend == 0) {
284 	       c.ifsend = 5;
285 	       auctionlistts.push(c);
286 	   }
287 	   if(c.endtime + 9 days < _now && c.ifsend == 1) {
288 	       c.ifsend = 5;
289 	       auctionlistts.push(c);
290 	   }
291 	   
292 	}
293 	function endauctionother(uint auctids) public {
294 	    //uint _now = now;
295 	    auctionlist storage c = auctionlisting[auctids];
296 	    address suser = msg.sender;
297 	    require(c.ifsend == 3);
298 	    require(c.ausers[suser] > 0);
299 	    btyc.mintToken(c.susers[suser],c.ausers[suser]);
300 	    c.ausers[suser] = 0;
301 	    
302 	}
303 	
304 }
305 interface btycInterface {
306     //mapping(address => uint) balances;
307     function balanceOf(address _addr) external view returns (uint256);
308     function mintToken(address target, uint256 mintedAmount) external returns (bool);
309     function transfer(address to, uint tokens) external returns (bool);
310     function freezeAccount(address target, bool freeze) external returns (bool);
311     function getcanuse(address tokenOwner) external view returns(uint);
312 }