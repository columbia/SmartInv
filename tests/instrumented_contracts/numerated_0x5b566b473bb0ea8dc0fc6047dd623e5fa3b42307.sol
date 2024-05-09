1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     // uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return a / b;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 interface IDividendToken{                     
33     function profitOrgPay() payable external ; 
34 }
35 
36 interface IGame { 
37     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) external returns(bool _result); 
38     function canSetBanker() view external  returns (bool);  
39     function bankerEndTime() constant  external returns (uint);  
40 }
41 
42 
43 contract Base { 
44     using SafeMath for uint256; 
45     uint public createTime = now;
46     address public owner;
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;                                 
51     }
52 
53     function setOwner(address _newOwner)  public  onlyOwner {
54         owner = _newOwner;
55     }
56         
57     bool public globalLocked = false;      
58 
59     function lock() internal {            
60         require(!globalLocked);
61         globalLocked = true;
62     }
63 
64     function unLock() internal {
65         require(globalLocked);
66         globalLocked = false;
67     }    
68   
69     function setLock()  public onlyOwner {      
70         globalLocked = false;     
71     }
72 
73     mapping (address => uint256) public userEtherOf;    
74     
75     function userRefund() public  returns(bool _result) {            
76         return _userRefund(msg.sender);
77     }
78 
79     function _userRefund(address _to) internal returns(bool _result) {    
80         require (_to != 0x0);  
81         lock();
82         uint256 amount = userEtherOf[msg.sender];   
83         if(amount > 0) {
84             userEtherOf[msg.sender] = 0;
85             _to.transfer(amount); 
86             _result = true;
87         }
88         else {
89             _result = false;
90         }
91         unLock();
92     }
93 
94     uint public currentEventId = 1;                             
95 
96     function getEventId() internal returns(uint _result) {    
97         _result = currentEventId;
98         currentEventId ++;
99     }
100 
101 }
102 
103 contract Beneficial is Base {            
104 
105     //function Beneficial() public {
106     //}
107 
108     address public shareholder;                
109     bool public shareholderIsToken = false;     
110     string public officialUrl;                 
111 	
112     function setOfficialUrl(string _newOfficialUrl) public onlyOwner{
113         officialUrl = _newOfficialUrl;
114     }       
115 
116 /*     
117     function setShareholder(address _newShareholder, bool _isToken) public onlyOwner {
118         require(_newShareholder != 0x0);
119         shareholderIsToken = _isToken;
120         shareholder = _newShareholder;
121     }
122 */
123 
124     function _userRefund(address _to) internal  returns(bool _result){ 
125         require (_to != 0x0);  
126         lock();
127         uint256 amount = userEtherOf[msg.sender];   
128         if(amount > 0){
129             userEtherOf[msg.sender] = 0;
130             if(shareholderIsToken && msg.sender == shareholder){       
131                 IDividendToken token = IDividendToken(shareholder);
132                 token.profitOrgPay.value(amount)();
133             }
134             else{
135                 _to.transfer(amount); 
136             }
137             _result = true;
138         }
139         else{
140             _result = false;
141         }
142         unLock();
143     }
144 }
145 
146 contract Auction is Beneficial {
147     //function Auction(address _gameToken)  Beneficial() public {
148     function Auction(address _gameToken) public {
149         owner = msg.sender;
150 		shareholder = _gameToken;
151 		shareholderIsToken = true;
152     }
153    
154     int public gameIndex = 1;                      
155     mapping(int => address) public indexGameOf;    
156 
157     function _addIndexGame(address _gameAddr) private {
158             indexGameOf[gameIndex] = _gameAddr;
159             gameIndex ++;
160     }
161    
162     mapping(address => bool) public whiteListOf;    
163 
164     event OnWhiteListChange(address indexed _Addr, address _operator, bool _result,  uint _eventTime, uint _eventId);
165 
166     function addWhiteList(address _Addr) public onlyOwner {
167         require (_Addr != 0x0);  
168         whiteListOf[_Addr] = true;
169         _addIndexGame(_Addr);
170         emit OnWhiteListChange(_Addr, msg.sender, true, now, getEventId());
171     }  
172 
173     function delWhiteList(address _Addr) public onlyOwner {
174         require (_Addr != 0x0);  
175         whiteListOf[_Addr] = false;    
176         emit OnWhiteListChange(_Addr, msg.sender, false, now, getEventId()) ;
177     }
178     
179     function isWhiteListGame(address _Addr) private view returns(bool _result) { 
180         _result = whiteListOf[_Addr];
181     }
182 
183     uint auctionId = 1;             
184 
185     struct AuctionObj {
186         uint id;                  
187         address objAddr;          
188         uint256 beginTime;        
189         uint256 endTime;          
190         uint256 price;            
191         address winnerAddr;       
192         uint bankerTime;         
193         bool emptyGameBanker;   
194     } 
195 
196     mapping (address => AuctionObj) public auctionObjOf;   
197 
198     event OnSetAuctionObj(uint indexed _auctionId, address indexed  _objAddr, uint256 _beginTime, uint256 _endTime, uint _bankerTime, bool _result, uint _code, uint _eventTime, uint _eventId);
199 
200     function setAuctionObj(address _gameAddr, uint256 _auctionEndTime, uint _bankerTime)             
201         public onlyOwner  returns (bool _result) 
202     {
203         _result = _setAuctionObj(_gameAddr, _auctionEndTime, _bankerTime);    
204     }
205 
206     function addWhiteListAddSetAuctionObj(address _gameAddr, uint256 _auctionEndTime, uint _bankerTime) 
207         public onlyOwner returns (bool _result)
208     {    
209          addWhiteList(_gameAddr);
210         _result = _setAuctionObj(_gameAddr, _auctionEndTime, _bankerTime);    
211     }
212 
213     //uint constant minBankTime = 1 days;                
214 
215     function _setAuctionObj(address _gameAddr, uint256 _auctionEndTime, uint _bankerTime)  private  returns (bool _result) {   
216         _result = false;
217         require(_gameAddr != 0x0);
218         require(now < _auctionEndTime);
219         //require(minBankTime <= _bankerTime);
220         //require(_bankerTime < 10 years);
221         if(!isWhiteListGame(_gameAddr)) {               
222             emit OnSetAuctionObj(auctionId, _gameAddr, now,  _auctionEndTime, _bankerTime, false, 1, now, getEventId()) ;
223             return;
224         }     
225       
226         AuctionObj storage ao = auctionObjOf[_gameAddr];
227         if(ao.endTime <= now && !ao.emptyGameBanker) {   
228             AuctionObj memory  newAO = AuctionObj({
229                 id: auctionId,
230                 objAddr: _gameAddr,
231                 beginTime: now,
232                 endTime : _auctionEndTime,
233                 winnerAddr: owner,
234                 price: 0,
235                 bankerTime: _bankerTime,
236                 emptyGameBanker: true                  
237             });
238             emit OnSetAuctionObj(auctionId, _gameAddr, now,  _auctionEndTime, _bankerTime, true, 0, now, getEventId()) ;
239             auctionObjOf[_gameAddr] = newAO;      
240             auctionId ++;
241             _result = true;
242             return;
243         }else{
244             emit OnSetAuctionObj(auctionId, _gameAddr, now,  _auctionEndTime, _bankerTime, false, 2, now, getEventId()) ;
245         }
246     }
247 
248     event OnBid(uint indexed _auctionId, address _sender, address  _objAddr, uint256 _price, bool  _result, uint  _code, uint _eventTime, uint _eventId);
249 
250     function bid(address _objAddr, uint256 _price) public payable returns(bool _result) {    
251         _result = false;
252         require(_objAddr != 0x0);
253 		AuctionObj storage ao = auctionObjOf[_objAddr];
254         if(msg.value > 0){
255             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
256         }
257         if(10**16 > _price){                 
258             emit OnBid(ao.id, msg.sender, _objAddr,  _price, false, 3, now, getEventId());
259             return;
260         }
261         if(userEtherOf[msg.sender] < _price){                 
262             emit OnBid(ao.id, msg.sender, _objAddr,  _price, false, 1, now, getEventId());
263             return;
264         }
265         if(now < ao.endTime) {                 
266             if(_price > ao.price) {            
267                 userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(_price);          
268                 userEtherOf[ao.winnerAddr] = userEtherOf[ao.winnerAddr].add(ao.price);    
269                 ao.price = _price;
270                 ao.winnerAddr = msg.sender;
271                 emit OnBid(ao.id, msg.sender, _objAddr,  _price, true, 0, now, getEventId());
272                 _result = true;
273                 return;
274             }
275         }
276 
277         emit OnBid(ao.id, msg.sender, _objAddr,  _price, false, 2, now, getEventId());
278         return;
279     }
280 
281     event OnSetGameBanker(uint indexed _auctionId, address indexed _gameAddr, bool indexed _result,  uint _code, uint _eventTime, uint _eventId);
282 
283     function setGameBanker(address _gameAddr) public returns (bool _result) {      
284         _result = false;
285         require(_gameAddr != 0x0);
286         //require(isWhiteListGame(_gameAddr));      
287         lock();
288         AuctionObj storage ao = auctionObjOf[_gameAddr];
289         if(ao.id > 0 && ao.endTime <= now) {                                         
290             IGame g = IGame(_gameAddr);
291             if(g.bankerEndTime() < now && g.canSetBanker()){                      
292                 _result = g.setBanker(ao.winnerAddr,  now,  now.add(ao.bankerTime));     
293                 if(_result){
294 					emit OnSetGameBanker(ao.id, _gameAddr, _result, 0, now, getEventId());
295                     ao.emptyGameBanker = false;                                            
296                     userEtherOf[shareholder] =  userEtherOf[shareholder].add(ao.price);    
297                     _setAuctionObj(_gameAddr,  (now.add(ao.bankerTime)).sub(1 hours) , ao.bankerTime); 
298                 }else{
299 				  emit OnSetGameBanker(ao.id, _gameAddr, false, 1, now, getEventId());     
300 				}
301             }else{
302                 emit OnSetGameBanker(ao.id, _gameAddr, false, 2, now, getEventId());     
303             }
304         }else{
305             emit OnSetGameBanker(ao.id, _gameAddr, false, 3, now, getEventId());
306         }
307         unLock();
308     }
309     
310     function () public payable {
311         if(msg.value > 0) {          
312             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
313         }
314     }
315 
316 }