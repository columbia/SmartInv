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
105     function Beneficial() public {
106     }
107 
108     address public shareholder;                
109     bool public shareholderIsToken = false;     
110     string public officialUrl;                 
111 	
112     function setOfficialUrl(string _newOfficialUrl) public onlyOwner{
113         officialUrl = _newOfficialUrl;
114     }       
115      
116     function setShareholder(address _newShareholder, bool _isToken) public onlyOwner {
117         require(_newShareholder != 0x0);
118         shareholderIsToken = _isToken;
119         shareholder = _newShareholder;
120     }
121     
122     function _userRefund(address _to) internal  returns(bool _result){ 
123         require (_to != 0x0);  
124         lock();
125         uint256 amount = userEtherOf[msg.sender];   
126         if(amount > 0){
127             userEtherOf[msg.sender] = 0;
128             if(shareholderIsToken && msg.sender == shareholder){       
129                 IDividendToken token = IDividendToken(shareholder);
130                 token.profitOrgPay.value(amount)();
131             }
132             else{
133                 _to.transfer(amount); 
134             }
135             _result = true;
136         }
137         else{
138             _result = false;
139         }
140         unLock();
141     }
142 }
143 
144 contract Auction is Beneficial {
145     function Auction()  Beneficial() public {
146         owner = msg.sender;
147         shareholder = msg.sender;
148     }
149    
150     int public gameIndex = 1;                      
151     mapping(int => address) public indexGameOf;    
152 
153     function _addIndexGame(address _gameAddr) private {
154             indexGameOf[gameIndex] = _gameAddr;
155             gameIndex ++;
156     }
157    
158     mapping(address => bool) public whiteListOf;    
159     mapping (uint64 => address) public indexAddress;    
160 
161     event OnWhiteListChange(address indexed _Addr, address _operator, bool _result,  uint _eventTime, uint _eventId);
162 
163     function addWhiteList(address _Addr) public onlyOwner {
164         require (_Addr != 0x0);  
165         whiteListOf[_Addr] = true;
166         _addIndexGame(_Addr);
167         emit OnWhiteListChange(_Addr, msg.sender, true, now, getEventId());
168     }  
169 
170     function delWhiteList(address _Addr) public onlyOwner {
171         require (_Addr != 0x0);  
172         whiteListOf[_Addr] = false;    
173         emit OnWhiteListChange(_Addr, msg.sender, false, now, getEventId()) ;
174     }
175     
176     function isWhiteListGame(address _Addr) private view returns(bool _result) { 
177         _result = whiteListOf[_Addr];
178     }
179 
180     uint auctionId = 1;             
181 
182     struct AuctionObj {
183         uint id;                  
184         address objAddr;          
185         uint256 beginTime;        
186         uint256 endTime;          
187         uint256 price;            
188         address winnerAddr;       
189         uint bankerTime;         
190         bool emptyGameBanker;   
191     } 
192 
193     mapping (address => AuctionObj) public auctionObjOf;   
194 
195     event OnSetAuctionObj(uint indexed _auctionId, address indexed  _objAddr, uint256 _beginTime, uint256 _endTime, uint _bankerTime, bool _result, uint _code, uint _eventTime, uint _eventId);
196 
197     function setAuctionObj(address _gameAddr, uint256 _auctionEndTime, uint _bankerTime)             
198         public onlyOwner  returns (bool _result) 
199     {
200         _result = _setAuctionObj(_gameAddr, _auctionEndTime, _bankerTime);    
201     }
202 
203     function addWhiteListAddSetAuctionObj(address _gameAddr, uint256 _auctionEndTime, uint _bankerTime) 
204         public onlyOwner returns (bool _result)
205     {    
206          addWhiteList(_gameAddr);
207         _result = _setAuctionObj(_gameAddr, _auctionEndTime, _bankerTime);    
208     }
209 
210     //uint constant minBankTime = 1 days;                
211 
212     function _setAuctionObj(address _gameAddr, uint256 _auctionEndTime, uint _bankerTime)  private  returns (bool _result) {   
213         _result = false;
214         require(_gameAddr != 0x0);
215         require(now < _auctionEndTime);
216         //require(minBankTime <= _bankerTime);
217         //require(_bankerTime < 10 years);
218         if(!isWhiteListGame(_gameAddr)) {               
219             emit OnSetAuctionObj(auctionId, _gameAddr, now,  _auctionEndTime, _bankerTime, false, 1, now, getEventId()) ;
220             return;
221         }     
222       
223         AuctionObj storage ao = auctionObjOf[_gameAddr];
224         if(ao.endTime <= now && !ao.emptyGameBanker) {   
225             AuctionObj memory  newAO = AuctionObj({
226                 id: auctionId,
227                 objAddr: _gameAddr,
228                 beginTime: now,
229                 endTime : _auctionEndTime,
230                 winnerAddr: owner,
231                 price: 0,
232                 bankerTime: _bankerTime,
233                 emptyGameBanker: true                  
234             });
235             emit OnSetAuctionObj(auctionId, _gameAddr, now,  _auctionEndTime, _bankerTime, true, 0, now, getEventId()) ;
236             auctionObjOf[_gameAddr] = newAO;      
237             auctionId ++;
238             _result = true;
239             return;
240         }else{
241             emit OnSetAuctionObj(auctionId, _gameAddr, now,  _auctionEndTime, _bankerTime, false, 2, now, getEventId()) ;
242         }
243     }
244 
245     event OnBid(uint indexed _auctionId, address _sender, address  _objAddr, uint256 _price, bool  _result, uint  _code, uint _eventTime, uint _eventId);
246 
247     function bid(address _objAddr, uint256 _price) public payable returns(bool _result) {    
248         _result = false;
249         require(_objAddr != 0x0);
250 		AuctionObj storage ao = auctionObjOf[_objAddr];
251         if(msg.value > 0){
252             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
253         }
254         if(10**16 > _price){                 
255             emit OnBid(ao.id, msg.sender, _objAddr,  _price, false, 3, now, getEventId());
256             return;
257         }
258         if(userEtherOf[msg.sender] < _price){                 
259             emit OnBid(ao.id, msg.sender, _objAddr,  _price, false, 1, now, getEventId());
260             return;
261         }
262         if(now < ao.endTime) {                 
263             if(_price > ao.price) {            
264                 userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(_price);          
265                 userEtherOf[ao.winnerAddr] = userEtherOf[ao.winnerAddr].add(ao.price);    
266                 ao.price = _price;
267                 ao.winnerAddr = msg.sender;
268                 emit OnBid(ao.id, msg.sender, _objAddr,  _price, true, 0, now, getEventId());
269                 _result = true;
270                 return;
271             }
272         }
273 
274         emit OnBid(ao.id, msg.sender, _objAddr,  _price, false, 2, now, getEventId());
275         return;
276     }
277 
278     event OnSetGameBanker(uint indexed _auctionId, address indexed _gameAddr, bool indexed _result,  uint _code, uint _eventTime, uint _eventId);
279 
280     function setGameBanker(address _gameAddr) public returns (bool _result) {      
281         _result = false;
282         require(_gameAddr != 0x0);
283         //require(isWhiteListGame(_gameAddr));      
284         lock();
285         AuctionObj storage ao = auctionObjOf[_gameAddr];
286         if(ao.id > 0 && ao.endTime <= now) {                                         
287             IGame g = IGame(_gameAddr);
288             if(g.bankerEndTime() < now && g.canSetBanker()){                      
289                 _result = g.setBanker(ao.winnerAddr,  now,  now.add(ao.bankerTime));     
290                 if(_result){
291 					emit OnSetGameBanker(ao.id, _gameAddr, _result, 0, now, getEventId());
292                     ao.emptyGameBanker = false;                                            
293                     userEtherOf[shareholder] =  userEtherOf[shareholder].add(ao.price);    
294                     _setAuctionObj(_gameAddr,  (now.add(ao.bankerTime)).sub(1 hours) , ao.bankerTime); 
295                 }else{
296 				  emit OnSetGameBanker(ao.id, _gameAddr, false, 1, now, getEventId());     
297 				}
298             }else{
299                 emit OnSetGameBanker(ao.id, _gameAddr, false, 2, now, getEventId());     
300             }
301         }else{
302             emit OnSetGameBanker(ao.id, _gameAddr, false, 3, now, getEventId());
303         }
304         unLock();
305     }
306     
307     function () public payable {
308         if(msg.value > 0) {          
309             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
310         }
311     }
312 
313 }