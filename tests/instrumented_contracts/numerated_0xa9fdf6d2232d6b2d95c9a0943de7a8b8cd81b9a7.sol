1 //////////////////////////////////////////////////////////////////////////////////////////////////////
2 
3 //////////////////////////////////////////////////////////////////////////////////////////////////////
4 
5 pragma solidity ^0.4.21;
6 
7 
8 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol 2018-04-24 add
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 contract Base {
36     using SafeMath for uint256;
37     uint public createTime = now;
38     address public owner;   
39     uint public currentEventId = 1;
40     uint256 public ownerDividend = 0 ;
41     uint256 public thisEther = 0 ;
42     
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function setOwner(address _newOwner)  public  onlyOwner {
49         require(msg.sender == tx.origin);
50         userRefund();
51         owner = _newOwner;
52     }
53 
54     function getEventId() internal returns(uint _result) {  
55         _result = currentEventId;
56         currentEventId ++;
57     }
58 
59     function userRefund() public onlyOwner returns(bool _result) {
60         require(msg.sender == tx.origin);
61         if(ownerDividend > 0 ){
62             msg.sender.transfer(ownerDividend);
63             ownerDividend = 0 ;
64         }
65         return true;
66     }
67 }
68     
69 contract FreeCell is Base{
70 
71     string constant public name = "FreeCell";
72     uint256 public curPosition = 0;
73     uint public lastPlayTime = 0;
74     uint public expirationTime = 24 hours;
75 
76     uint256 public BASE_BET_ETHER = 0.01 ether;
77     uint public REWARD_WIN_MULTIPLE_PER = 60;
78     uint public PRE_WIN_MULTIPLE_PER = 30;
79     uint public KING_WIN_MULTIPLE_PER = REWARD_WIN_MULTIPLE_PER + PRE_WIN_MULTIPLE_PER;
80     uint public REWARD_NUM = 200;
81     uint public REWARD_FORWARD_POSITION = REWARD_NUM - 1 ;
82     uint public CELL_ADD_SPACE = 0.0005 ether ; 
83     uint public STEP_SIZE = 50 ;
84     uint public MAX_LENGTH = 1000000 ; 
85 
86     function FreeCell() public {
87         require(REWARD_WIN_MULTIPLE_PER.add(PRE_WIN_MULTIPLE_PER) < 100) ;
88         require(curPosition == 0);
89         owner = msg.sender;
90         lastPlayTime = now;
91     }
92 
93     struct betInfo {
94         address addr;
95         uint256 card;
96     }
97 
98     mapping (uint256 => betInfo) public playerBetInfoOf;
99     mapping (uint256 => uint256) public resultOf;
100 
101     event OnGetAward(uint256 indexed _position,  address indexed _player, uint256 indexed _card, uint256  _prePosition, uint256 _rewardMoney, uint8 _type, uint256 _eventId, uint256 _eventTime);
102     event OnPlay(uint256 indexed _position,  address indexed _player, uint256 indexed _card, uint256 _eventId, uint256 _eventTime);
103 
104     function playBatch(uint256 num) public payable returns(bool _result){
105         require(msg.sender == tx.origin);
106         uint256 userMoney = msg.value;
107 
108         if(now.sub(lastPlayTime) > expirationTime){
109             getEventId();
110             address _lastPalayUser = playerBetInfoOf[curPosition].addr ;
111             uint256 _toLastPlayer = _rewardKing(1, MAX_LENGTH,_lastPalayUser,uint8(4));  
112             if(userMoney > 0){
113                 msg.sender.transfer(userMoney);
114             }
115             if(_toLastPlayer > 0 ){
116                 _lastPalayUser.transfer(_toLastPlayer);
117             }
118             lastPlayTime = now ;
119             _result = true;
120             return ;
121         }else{
122             lastPlayTime = now ;
123         }
124 
125         for(uint256 i = 0;i < num; i++){
126             (_result,userMoney) = _play(userMoney);
127             if(!_result){
128                 break ; 
129             }
130         }
131         if(userMoney > 0){
132             msg.sender.transfer(userMoney);
133         }
134     }
135 
136     function play() public payable returns(bool _result){
137         require(msg.sender == tx.origin);
138         uint256 userMoney = msg.value;
139 
140         if(now.sub(lastPlayTime) > expirationTime){
141             getEventId();
142             address _lastPalayUser = playerBetInfoOf[curPosition].addr ;
143             uint256 _toLastPlayer = _rewardKing(1, MAX_LENGTH,_lastPalayUser,uint8(4));  
144             if(userMoney > 0){
145                 msg.sender.transfer(userMoney);
146             }
147             if(_toLastPlayer > 0 ){
148                 _lastPalayUser.transfer(_toLastPlayer);
149             }
150             lastPlayTime = now ;
151             _result = true;
152             return ;
153         }else{
154             lastPlayTime = now ;
155         }
156 
157         (_result,userMoney) = _play(userMoney);
158         require(_result);
159         if(userMoney > 0){
160             msg.sender.transfer(userMoney);
161         }
162     }
163 
164     function _isKingKong(uint256 _card) private pure returns(bool _result){
165         _result = false;
166         if(_card % 111111 == 0){
167            _result = true ;
168         }
169     }
170 
171     function _isStraight(uint256 _card) private pure returns(bool _result){
172         _result = false;
173         if(_card >= 543210){
174             if(_isKingKong(_card.sub(12345)) || _isKingKong(_card.sub(543210))){
175                 _result = true ;
176             }
177         }else if(_card > 123455){
178             if(_isKingKong(_card.sub(12345))){
179                 _result = true ;
180             }
181         }else{
182             _result = false;
183         }
184     }
185 
186     function viewPosition(uint256 _card) public view returns(uint256 _position) {
187         _position = resultOf[_card];
188         if(_position > curPosition || playerBetInfoOf[_position].card != _card){
189             _position = 0 ;
190         }
191     }
192 
193     function viewBetEther(uint256 _position) public view returns(uint256 _betEther) {
194         _betEther = _position.sub(1).div(STEP_SIZE).mul(CELL_ADD_SPACE).add(BASE_BET_ETHER);
195         return _betEther;
196     }
197 
198     function viewNeedBetEther(uint256 num) public view returns(uint256 _betEther) {
199         require(num <= 20) ;
200         return  viewSumEther(curPosition.add(1),curPosition.add(num));
201     }
202 
203     function _sumEther(uint256 _position) private view returns(uint256 _totalEther){
204         if(_position < STEP_SIZE){
205             return _position.mul(BASE_BET_ETHER);     
206         }else if(_position % STEP_SIZE == 0){
207             return viewBetEther(_position).add(BASE_BET_ETHER).mul(_position).div(2);       
208         }else{
209             uint256 _remainder = _position % STEP_SIZE;
210             uint256 _bak = _position.sub(_remainder);
211             return viewBetEther(_bak).add(BASE_BET_ETHER).mul(_bak).div(2).add(viewBetEther(_position).mul(_remainder));          
212         }
213     }
214     
215     function viewSumEther(uint256 _prePosition,uint256 _curPosition) public view returns(uint256 _betEther) {
216         if(_prePosition <= 1){
217             return _sumEther(_curPosition);
218         }
219         return _sumEther(_curPosition).sub(_sumEther(_prePosition.sub(1)));
220     }
221 
222     function _play(uint256 _userMoney) private returns(bool _result,uint256 _toUserMoney){
223         _result = false;
224         _toUserMoney = _userMoney;
225         
226         uint256 _betEther = viewBetEther(curPosition.add(1));
227         if(_toUserMoney < _betEther){
228             return (_result,_toUserMoney);
229         }
230 
231         curPosition++;
232         _toUserMoney= _toUserMoney.sub(_betEther);                   
233         thisEther = thisEther.add(_betEther);
234         
235         uint256 seed = uint256(
236             keccak256(
237                 block.timestamp,
238                 block.difficulty,
239                 uint256(keccak256(block.coinbase))/(now),
240                 block.gaslimit,
241                 uint256(keccak256(msg.sender))/ (now),
242                 block.number,
243                 _betEther,
244                 getEventId(),
245                 gasleft()
246             )
247         );
248 
249         uint256 _card =  seed % MAX_LENGTH; 
250 
251         emit OnPlay(curPosition, msg.sender, _card, currentEventId, now);
252 
253         uint256 _toRewardPlayer = 0;
254         if(_isKingKong(_card) || _isStraight(_card)){
255             if(curPosition > REWARD_FORWARD_POSITION){
256                uint256 _prePosition = curPosition.sub(REWARD_FORWARD_POSITION);
257             }else{
258                 _prePosition = 1;
259             }            
260             _toRewardPlayer = _rewardKing(_prePosition, _card,msg.sender,uint8(3));
261             _toUserMoney= _toUserMoney.add(_toRewardPlayer);  
262             _result = true;
263             return (_result,_toUserMoney);
264        }
265 
266        _prePosition = resultOf[_card];
267        if(_prePosition != 0 && _prePosition < curPosition && playerBetInfoOf[_prePosition].card == _card ){
268             _toRewardPlayer = _reward(_prePosition, _card);
269             _toUserMoney= _toUserMoney.add(_toRewardPlayer); 
270             _result = true;
271             return (_result,_toUserMoney);
272        }else{
273             betInfo memory bi = betInfo({
274                 addr :  msg.sender,
275                 card : _card
276             });
277             playerBetInfoOf[curPosition] = bi;
278             resultOf[_card]=curPosition;
279             _result = true;
280             return (_result,_toUserMoney);
281        }
282     }
283 
284     function _reward(uint256 _prePosition,uint256 _card) private returns(uint256 _toRewardPlayer){
285         _toRewardPlayer = 0;
286         require(_prePosition >= 1);
287 
288         betInfo memory bi = playerBetInfoOf[_prePosition];
289         require(bi.addr != 0x0);
290 
291         uint256 _sumRewardMoney = viewSumEther(_prePosition, curPosition);
292  
293         _toRewardPlayer = _sumRewardMoney.mul(REWARD_WIN_MULTIPLE_PER).div(100) ;
294         uint256 _toPrePlayer = _sumRewardMoney.mul(PRE_WIN_MULTIPLE_PER).div(100) ;
295         uint256 _toOwner = _sumRewardMoney.sub(_toRewardPlayer).sub(_toPrePlayer);
296 
297         emit OnGetAward(curPosition,msg.sender,_card,_prePosition,_toRewardPlayer,uint8(1),currentEventId,now);
298         emit OnGetAward(_prePosition,bi.addr,_card,curPosition,_toPrePlayer,uint8(2),currentEventId,now);
299 
300         curPosition = _prePosition.sub(1);
301         thisEther = thisEther.sub(_sumRewardMoney);
302         ownerDividend = ownerDividend.add(_toOwner);
303         if(msg.sender != bi.addr){
304             bi.addr.transfer(_toPrePlayer);
305         }else{
306            _toRewardPlayer = _toRewardPlayer.add(_toPrePlayer);
307         }
308     }
309         
310     function _rewardKing(uint256 _prePosition,uint256 _card, address _user,uint8 _type) private returns(uint256 _toRewardPlayer){
311         _toRewardPlayer = 0;
312         require(_prePosition >= 1);
313    
314         uint256 _sumRewardMoney = viewSumEther(_prePosition, curPosition);
315         _toRewardPlayer = _sumRewardMoney.mul(KING_WIN_MULTIPLE_PER).div(100) ; 
316         uint256 _toOwner = _sumRewardMoney.sub(_toRewardPlayer);
317 
318         emit OnGetAward(curPosition,_user,_card,_prePosition,_toRewardPlayer,_type,currentEventId,now);
319         
320         curPosition = _prePosition.sub(1);
321         thisEther = thisEther.sub(_sumRewardMoney);
322         ownerDividend = ownerDividend.add(_toOwner);
323     }
324 }