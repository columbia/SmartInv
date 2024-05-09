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
49     uint public lastid; //竞拍最后id 时间
50     uint public systemprice = 20000 ether;
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
69         uint[] putids; //竞拍人id组
70         putusers lastone;//最终获拍者
71         uint ifsend;//是否发货
72         //bool ifother;
73         mapping(uint => putusers) aucusers;//竞拍人id组
74         mapping(address => uint) ausers;
75         mapping(address => address) susers;
76     }
77     auctionlist[] public auctionlisting; //竞拍中的
78     auctionlist[] public auctionlistend; //竞拍结束的
79     auctionlist[] public auctionlistts; //竞拍结束的
80     mapping(address => uint[]) userlist;
81     btycInterface constant private btyc = btycInterface(0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA);
82     /* 通知 */
83 	event auctconfim(address target, uint tokens);
84 	constructor() public {
85 	    
86 	}
87 	/*添加拍卖 */
88 	function addauction(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, string goodsnames, string goodspics) public returns(uint){
89 	    uint _now = now;
90 	    uint[] memory pids;
91 	    putusers memory lastone;
92 	    require(opentimes > _now);
93 	    require(opentimes < _now + 2 days);
94 	    require(endtimes > _now + 2 days);
95 	    require(endtimes < _now + 4 days);
96 	    require(btyc.balanceOf(addusers) >= systemprice);
97 	    //uint i = auctionlisting.length;
98 	    auctionlisting[lastid++] = auctionlist(addusers, opentimes, endtimes, onceprices, openprices, openprices, endprices, goodsnames, goodspics, false, pids, lastone,0);
99 	}
100 	function balanceOf(address addr) public view returns(uint) {
101 	    return(btyc.balanceOf(addr));
102 	}
103 	function canuse(address addr) public view returns(uint) {
104 	    return(btyc.getcanuse(addr));
105 	}
106 	function ownerof() public view returns(uint) {
107 	    return(btyc.balanceOf(this));
108 	}
109 	/*用户竞拍*/
110 	function inputauction(uint auctids, address pusers, uint addmoneys,string useraddrs) public {
111 	    uint _now = now;
112 	    auctionlist storage c = auctionlisting[auctids];
113 	    require(c.ifend == false);
114 	    require(c.ifsend == 0);
115 	    
116 	    uint userbalance = canuse(pusers);
117 	    require(addmoneys > c.currentprice);
118 	    require(addmoneys <= c.endprice);
119 	    uint money = addmoneys - c.ausers[pusers];
120 	    require(userbalance >= money);
121 	    
122 	    //else{
123 	    btyc.transfer(this, money);
124 	    c.ausers[pusers] = addmoneys;
125 	    c.susers[pusers] = pusers;
126 	    c.putids.push(_now);
127 	    c.currentprice = addmoneys;
128 	    c.aucusers[_now] = putusers(pusers, _now, addmoneys,  useraddrs);
129 	    c.lastone = c.aucusers[_now];
130 	    if(c.endtime < _now || addmoneys == c.endprice) {
131 	        //endauction(auctids);
132 	        c.ifend = true;
133 	        //btyc.mintToken
134 	    }
135 	    userlist[pusers].push(auctids);
136 	    emit auctconfim(pusers, money);
137 	    //}
138 	    
139 	}
140 	/*查看*/
141 	function viewauction(uint aid) public view returns(address addusers,uint opentimes, uint endtimes, uint onceprices, uint openprices, uint endprices, string goodsnames, string goodspics, bool ifends, uint ifsends, uint anum){
142 		auctionlist memory c = auctionlisting[aid];
143 		addusers = c.adduser;
144 		opentimes = c.opentime;
145 		endtimes = c.endtime;
146 		onceprices = c.onceprice;
147 		openprices = c.openprice;
148 		endprices = c.endprice;
149 		goodspics = c.goodspic;
150 		goodsnames = c.goodsname;
151 		ifends = c.ifend;
152 		ifsends = c.ifsend;
153 		anum = c.putids.length;
154 	}
155 	function getactlen() public view returns(uint) {
156 	    return(auctionlisting.length);
157 	}
158     function getlastid() public view  returns(uint){
159         return(lastid);
160     }
161 	/*
162 	function viewlisting(uint start, uint num) public view{
163 	    //uint len = auctionlisting.length;
164 	   // auctionlist[] rt;
165 	   address[] addusers;
166 	    for(uint i = lastid; i > i - start - num; i--) {
167 	        auctionlist c = auctionlisting[i];
168 	        //uint[] pt = [c.adduser,c.opentime,c.endtime];
169 	        addusers.push(c.adduser);
170 	    }
171 	    //return rt;
172 	    return(addusers);
173 	}*/
174 	function setsendgoods(uint auctids) public {
175 	    uint _now = now;
176 	     auctionlist storage c = auctionlisting[auctids];
177 	     require(c.adduser == msg.sender);
178 	     require(c.endtime < _now);
179 	     //if(c.endtime < _now) {
180 	     //   c.ifend = true;
181 	    //}
182 	     //require(c.ifend == true);
183 	     require(c.ifsend == 0);
184 	     c.ifsend = 1;
185 	     c.ifend = true;
186 	}
187 	function setgetgoods(uint auctids) public {
188 	    uint _now = now;
189 	    auctionlist storage c = auctionlisting[auctids];
190 	    require(c.endtime < _now);
191 	    require(c.ifend == true);
192 	    require(c.ifsend == 1);
193 	    putusers memory lasttuser = c.lastone;
194 	    require(lasttuser.puser == msg.sender);
195 	    c.ifsend = 2;
196 	    uint getmoney = lasttuser.addmoney*70/100;
197 	    btyc.mintToken(c.adduser, getmoney);
198 	    auctionlistend.push(c);
199 	}
200 	function getuseraddress(uint auctids) public view returns(string){
201 	    auctionlist memory c = auctionlisting[auctids];
202 	    require(c.adduser == msg.sender);
203 	    return(c.lastone.useraddr);
204 	}
205 	/*用户获取拍卖金额 */
206 	function endauction(uint auctids) public {
207 	    //uint _now = now;
208 	    auctionlist storage c = auctionlisting[auctids];
209 	    require(c.ifsend == 2);
210 	    uint[] memory ids = c.putids;
211 	    uint len = ids.length;
212 	    putusers memory firstuser = c.aucusers[ids[0]];
213 	    //putusers memory lasttuser = c.lastone;
214         address suser = msg.sender;
215 	    
216 	    require(c.ifend == true);
217 	    require(len > 1);
218 	    require(c.ausers[suser] > 0);
219 	    if(len == 2) {
220 	        require(firstuser.puser == suser);
221 	        //require(firstuser.hasback == false);
222 	        btyc.mintToken(suser,c.currentprice*3/10 + c.ausers[suser]);
223 	        
224 	    }else{
225 	       
226 	        if(firstuser.puser == suser) {
227 	            //require(firstuser.hasback == false);
228 	            btyc.mintToken(suser,c.currentprice*1/10 + c.ausers[suser]);
229 	            //firstuser.hasback = true;
230 	        }else{
231 	            uint onemoney = (c.currentprice*2/10)/(len-2);
232 	            btyc.mintToken(c.susers[suser],onemoney + c.ausers[suser]);
233 	        }
234 	    }
235 	    c.ausers[suser] = 0;
236 	    
237 	}
238 	function setsystemprice(uint price) public onlyOwner{
239 	    systemprice = price;
240 	}
241 	function setauctionother(uint auctids) public onlyOwner{
242 	    auctionlist storage c = auctionlisting[auctids];
243 	    btyc.freezeAccount(c.adduser, true);
244 	    c.ifsend = 3;
245 	}
246 	function setauctionotherfree(uint auctids) public onlyOwner{
247 	    auctionlist storage c = auctionlisting[auctids];
248 	    btyc.freezeAccount(c.adduser, false);
249 	    c.ifsend = 2;
250 	}
251 	
252 	function tsauction(uint auctids) public{
253 	   auctionlist storage c = auctionlisting[auctids];
254 	   uint _now = now;
255 	   require(c.endtime + 2 days < _now);
256 	   require(c.lastone.puser == msg.sender);
257 	   if(c.endtime + 2 days < _now && c.ifsend == 0) {
258 	       c.ifsend = 5;
259 	       auctionlistts.push(c);
260 	   }
261 	   if(c.endtime + 9 days < _now && c.ifsend == 1) {
262 	       c.ifsend = 5;
263 	       auctionlistts.push(c);
264 	   }
265 	   
266 	}
267 	function endauctionother(uint auctids) public {
268 	    //uint _now = now;
269 	    auctionlist storage c = auctionlisting[auctids];
270 	    address suser = msg.sender;
271 	    require(c.ifsend == 3);
272 	    require(c.ausers[suser] > 0);
273 	    btyc.mintToken(c.susers[suser],c.ausers[suser]);
274 	    c.ausers[suser] = 0;
275 	    
276 	}
277 	
278 }
279 interface btycInterface {
280     //mapping(address => uint) balances;
281     function balanceOf(address _addr) external view returns (uint256);
282     function mintToken(address target, uint256 mintedAmount) external returns (bool);
283     function transfer(address to, uint tokens) external returns (bool);
284     function freezeAccount(address target, bool freeze) external returns (bool);
285     function getcanuse(address tokenOwner) external view returns(uint);
286 }