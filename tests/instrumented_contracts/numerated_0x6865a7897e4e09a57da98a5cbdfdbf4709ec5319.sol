1 pragma solidity ^0.4.25;
2 
3 contract Ownerable{
4     
5     address public owner;
6 
7     address public delegate;
8 
9     constructor() public{
10         owner = msg.sender;
11         delegate = msg.sender;
12     }
13 
14     modifier onlyOwner() {
15         require(msg.sender == owner,"Permission denied");
16         _;
17     }
18 
19     modifier onlyDelegate() {
20         require(msg.sender == delegate,"Permission denied");
21         _;
22     }
23     
24     modifier onlyOwnerOrDelegate() {
25         require(msg.sender == owner||msg.sender == delegate,"Permission denied");
26         _;
27     }
28     
29     function changeOwner(address newOwner) public onlyOwner{
30         require(newOwner!= 0x0,"address is invalid");
31         owner = newOwner;
32     }
33     
34     function changeDelegate(address newDelegate) public onlyOwner{
35         require(newDelegate!= 0x0,"address is invalid");
36         delegate = newDelegate;
37     }
38     
39 }
40 
41 contract Pausable is Ownerable{
42   event Paused();
43   event Unpaused();
44 
45   bool private _paused = false;
46 
47   /**
48    * @return true if the contract is paused, false otherwise.
49    */
50   function paused() public view returns(bool) {
51     return _paused;
52   }
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!_paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(_paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() public onlyOwner whenNotPaused {
74     _paused = true;
75     emit Paused();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() public onlyOwner whenPaused {
82     _paused = false;
83     emit Unpaused();
84   }
85 }
86 
87 contract EthTransfer is Pausable{
88     
89     using SafeMath for uint256;
90     
91     uint256 constant ADMIN_DEPOIST_TIME_INTERVAL = 24 hours;
92     uint256 constant ADMIN_DEPOIST_MAX_AMOUNT = 50 ether;
93     uint256 last_time_admin_depoist = 0;
94     
95     uint constant HOUSE_EDGE_PERCENT = 15; //1.5%
96     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.00045 ether;
97     
98     uint256 public _total_house_edge = 0;
99     
100     uint256 public _ID = 1; //AUTO INCREMENT
101     uint256 public _newChannelID = 10000;
102         
103     event addChannelSucc    (uint256 indexed id,uint256 channelID,string name);
104     event rechargeSucc      (uint256 indexed id,uint256 channelID,address user,uint256 amount,string ext);
105     event depositSucc       (uint256 indexed id,uint256 channelID,address beneficiary,uint256 amount,uint256 houseEdge,string ext);
106     event withdrawSucc      (uint256 indexed id,uint256 amount);
107     event depositBySuperAdminSucc           (uint256 indexed id,uint256 amount,address beneficiary);
108     event changeChannelDelegateSucc         (uint256 indexed id,address newDelegate);
109     
110     mapping(uint256 => Channel) public _channelMap; // channelID => channel info
111     
112     mapping(address => uint256) public _idMap; // delegate => channelID
113     
114     function addNewChannel(string name_,address channelDelegate_,uint256 partnershipCooperationBounsRate_) public onlyDelegate{
115         require(_idMap[channelDelegate_] == 0,"An address can only manage one channel.");
116         
117         _channelMap[_newChannelID] = Channel(name_,_newChannelID,channelDelegate_,0,partnershipCooperationBounsRate_);
118         _idMap[channelDelegate_] = _newChannelID;
119         
120         emit addChannelSucc(_ID,_newChannelID,name_);
121         _newChannelID++;
122         _ID++;
123     }
124     
125     function() public payable{
126         revert();
127     }
128     
129     function recharge(uint256 channelID_,string ext_) public payable whenNotPaused{
130         Channel storage targetChannel = _channelMap[channelID_];
131         require(targetChannel.channelID!=0,"target Channel is no exist");
132         uint256 inEth = msg.value;
133 
134         uint256 partnershipCooperationBouns = inEth * targetChannel.partnershipCooperationBounsRate / 100 ;
135         _total_house_edge = _total_house_edge.add(partnershipCooperationBouns);
136 
137         uint256 targetEth = inEth.sub(partnershipCooperationBouns);
138         targetChannel.totalEth = targetChannel.totalEth.add(targetEth);
139         
140         emit rechargeSucc(_ID, channelID_, msg.sender, inEth, ext_);
141         _ID++;
142     }
143 
144     function changeChannelDelegate(address newDelegate_) public whenNotPaused{
145         require(_idMap[msg.sender] != 0,"this address isn't a manager");
146         Channel storage channelInfo = _channelMap[_idMap[msg.sender]];
147         require(channelInfo.channelDelegate == msg.sender,"You are not the administrator of this channel.");
148         require(_idMap[newDelegate_] == 0,"An address can only manage one channel.");
149         
150         channelInfo.channelDelegate = newDelegate_;
151         _idMap[msg.sender] = 0;
152         _idMap[newDelegate_] = channelInfo.channelID;
153         
154         emit changeChannelDelegateSucc(_ID, newDelegate_);
155         _ID++;
156     }    
157     
158     function deposit(address beneficiary_,uint256 amount_,string ext_) public whenNotPaused{
159         //Verify user identity
160         require(_idMap[msg.sender] != 0,"this address isn't a manager");
161         
162         Channel storage channelInfo = _channelMap[_idMap[msg.sender]];
163         //Query administrator privileges
164         require(channelInfo.channelDelegate == msg.sender,"You are not the administrator of this channel.");
165         //Is order completed?
166         bytes32 orderId = keccak256(abi.encodePacked(ext_));
167         require(!channelInfo.channelOrderHistory[orderId],"this order is deposit already");
168         channelInfo.channelOrderHistory[orderId] = true;
169         
170         uint256 totalLeftEth = channelInfo.totalEth.sub(amount_);
171         
172         uint houseEdge = amount_ * HOUSE_EDGE_PERCENT / 1000;
173         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
174             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
175         }
176         
177         channelInfo.totalEth = totalLeftEth.sub(houseEdge);
178         _total_house_edge = _total_house_edge.add(houseEdge);
179         
180         beneficiary_.transfer(amount_);
181         
182         emit depositSucc(_ID, channelInfo.channelID, beneficiary_, amount_, houseEdge, ext_);
183         _ID++;
184     }
185     
186     function depositByDelegate(address beneficiary_,uint256 amount_,string ext_, bytes32 r, bytes32 s, uint8 v) public onlyDelegate whenNotPaused{
187         //Verify user identity 
188         bytes32 signatureHash = keccak256(abi.encodePacked(beneficiary_, amount_,ext_));
189         address secretSigner = ecrecover(signatureHash, v, r, s);
190         require(_idMap[secretSigner] != 0,"this address isn't a manager");
191         
192         Channel storage channelInfo = _channelMap[_idMap[secretSigner]];
193         //Query administrator privileges
194         require(channelInfo.channelDelegate == secretSigner,"You are not the administrator of this channel.");
195         //Is order completed?
196         bytes32 orderId = keccak256(abi.encodePacked(ext_));
197         require(!channelInfo.channelOrderHistory[orderId],"this order is deposit already");
198         channelInfo.channelOrderHistory[orderId] = true;
199         
200         uint256 totalLeftEth = channelInfo.totalEth.sub(amount_);
201         
202         uint houseEdge = amount_ * HOUSE_EDGE_PERCENT / 1000;
203         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
204             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
205         }
206         
207         channelInfo.totalEth = totalLeftEth.sub(houseEdge);
208         _total_house_edge = _total_house_edge.add(houseEdge);
209         
210         beneficiary_.transfer(amount_);
211         
212         emit depositSucc(_ID, channelInfo.channelID, beneficiary_, amount_, houseEdge, ext_);
213         _ID++;
214     }
215     
216     function withdraw() public onlyOwnerOrDelegate {
217         require(_total_house_edge > 0,"no edge to withdraw");
218         owner.transfer(_total_house_edge);
219         
220         emit withdrawSucc(_ID,_total_house_edge);
221         _total_house_edge = 0;
222         _ID++;
223     }
224     
225     function depositBySuperAdmin(uint256 channelID_, uint256 amount_, address beneficiary_) public onlyOwner{
226         require(now - last_time_admin_depoist >= ADMIN_DEPOIST_TIME_INTERVAL," super admin time limit");
227         require(amount_ <= ADMIN_DEPOIST_MAX_AMOUNT," over super admin deposit amount limit");
228         last_time_admin_depoist = now;
229         Channel storage channelInfo = _channelMap[channelID_];
230         uint256 totalLeftEth = channelInfo.totalEth.sub(amount_);
231         channelInfo.totalEth = totalLeftEth;
232         beneficiary_.transfer(amount_);
233         
234         emit depositBySuperAdminSucc(_ID, amount_, beneficiary_);
235         _ID++;
236     }
237     
238     struct Channel{
239         string name;
240         uint256 channelID;
241         address channelDelegate;
242         uint256 totalEth;
243         uint256 partnershipCooperationBounsRate;
244         mapping(bytes32 => bool) channelOrderHistory;
245     }
246     
247     function destory() public onlyOwner whenPaused{
248         selfdestruct(owner);    
249     }
250 }
251 
252 
253 /**
254  * @title SafeMath v0.1.9
255  * @dev Math operations with safety checks that throw on error
256  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
257  * - added sqrt
258  * - added sq
259  * - added pwr
260  * - changed asserts to requires with error log outputs
261  * - removed div, its useless
262  */
263 library SafeMath {
264 
265     /**
266     * @dev Multiplies two numbers, throws on overflow.
267     */
268     function mul(uint256 a, uint256 b)
269         internal
270         pure
271         returns (uint256 c)
272     {
273         if (a == 0) {
274             return 0;
275         }
276         c = a * b;
277         require(c / a == b, "SafeMath mul failed");
278         return c;
279     }
280 
281     /**
282     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
283     */
284     function sub(uint256 a, uint256 b)
285         internal
286         pure
287         returns (uint256)
288     {
289         require(b <= a, "SafeMath sub failed");
290         return a - b;
291     }
292 
293     /**
294     * @dev Adds two numbers, throws on overflow.
295     */
296     function add(uint256 a, uint256 b)
297         internal
298         pure
299         returns (uint256 c)
300     {
301         c = a + b;
302         require(c >= a, "SafeMath add failed");
303         return c;
304     }
305 
306     /**
307      * @dev gives square root of given x.
308      */
309     function sqrt(uint256 x)
310         internal
311         pure
312         returns (uint256 y)
313     {
314         uint256 z = ((add(x,1)) / 2);
315         y = x;
316         while (z < y)
317         {
318             y = z;
319             z = ((add((x / z),z)) / 2);
320         }
321     }
322 
323     /**
324      * @dev gives square. multiplies x by x
325      */
326     function sq(uint256 x)
327         internal
328         pure
329         returns (uint256)
330     {
331         return (mul(x,x));
332     }
333 
334     /**
335      * @dev x to the power of y
336      */
337     function pwr(uint256 x, uint256 y)
338         internal
339         pure
340         returns (uint256)
341     {
342         if (x==0)
343             return (0);
344         else if (y==0)
345             return (1);
346         else
347         {
348             uint256 z = x;
349             for (uint256 i=1; i < y; i++)
350                 z = mul(z,x);
351             return (z);
352         }
353     }
354 }