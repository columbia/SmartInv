1 /*
2  ______   _________  ___   ___   _______    _______             ________  ______      
3 /_____/\ /________/\/__/\ /__/\ /______/\  /______/\           /_______/\/_____/\     
4 \::::_\/_\__.::.__\/\::\ \\  \ \\::::__\/__\::::__\/__         \__.::._\/\:::_ \ \    
5  \:\/___/\  \::\ \   \::\/_\ .\ \\:\ /____/\\:\ /____/\  ___      \::\ \  \:\ \ \ \   
6   \::___\/_  \::\ \   \:: ___::\ \\:\\_  _\/ \:\\_  _\/ /__/\     _\::\ \__\:\ \ \ \  
7    \:\____/\  \::\ \   \: \ \\::\ \\:\_\ \ \  \:\_\ \ \ \::\ \   /__\::\__/\\:\_\ \ \ 
8     \_____\/   \__\/    \__\/ \::\/ \_____\/   \_____\/  \:_\/   \________\/ \_____\/ 
9   ______ _______ _    _    _____  ____   ____  _____     _____          __  __ ______  _____ 
10  |  ____|__   __| |  | |  / ____|/ __ \ / __ \|  __ \   / ____|   /\   |  \/  |  ____|/ ____|
11  | |__     | |  | |__| | | |  __| |  | | |  | | |  | | | |  __   /  \  | \  / | |__  | (___  
12  |  __|    | |  |  __  | | | |_ | |  | | |  | | |  | | | | |_ | / /\ \ | |\/| |  __|  \___ \ 
13  | |____   | |  | |  | | | |__| | |__| | |__| | |__| | | |__| |/ ____ \| |  | | |____ ____) |
14  |______|  |_|  |_|  |_|  \_____|\____/ \____/|_____/   \_____/_/    \_\_|  |_|______|_____/ 
15                                                                                              
16                                                          BY : LmsSky@Gmail.com
17 */                            
18 pragma solidity ^0.4.25;
19 pragma experimental "v0.5.0";
20 contract safeApi{
21     
22    modifier safe(){
23         address _addr = msg.sender;
24         require (_addr == tx.origin,'Error Action!');
25         uint256 _codeLength;
26         assembly {_codeLength := extcodesize(_addr)}
27         require(_codeLength == 0, "Sender not authorized!");
28             _;
29     }
30 
31 
32     
33  function toBytes(uint256 _num) internal returns (bytes _ret) {
34    assembly {
35         _ret := mload(0x10)
36         mstore(_ret, 0x20)
37         mstore(add(_ret, 0x20), _num)
38     }
39 }
40 
41 function subStr(string _s, uint start, uint end) internal pure returns (string){
42         bytes memory s = bytes(_s);
43         string memory copy = new string(end - start);
44 //        string memory copy = new string(5);
45           uint k = 0;
46         for (uint i = start; i < end; i++){ 
47             bytes(copy)[k++] = bytes(_s)[i];
48         }
49         return copy;
50     }
51      
52 
53  function safePercent(uint256 a,uint256 b) 
54       internal
55       constant
56       returns(uint256)
57       {
58         assert(a>0 && a <=100);
59         return  div(mul(b,a),100);
60       }
61       
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67  
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0∂
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74  
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79  
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 
86 }
87 contract gameFinances is safeApi{
88 mapping(bytes32=>uint)  validQueryId;
89     struct player
90     {
91         uint64 id;
92         uint32 affNumLevel_1;
93         uint32 affNumLevel_2;
94         uint32 timeStamp;
95         uint balance;//wei
96         uint gameBalance;
97         address addr;
98     }
99 
100     struct  gameConfig
101     {
102          uint8 eachPct;
103          uint8 feePct;
104          uint8 poolPct;
105          uint8 adminPct;
106          uint8 levelPct1;
107          uint8 levelPct2;
108          uint16 index;
109          uint32 maxPct;
110          uint64 autoPlayId;
111     }
112     
113    struct  orderInfo
114     {  
115        uint64 pid;
116        uint32 pct;
117        uint32 times;
118        uint eth;
119        uint balance;
120     }
121     
122     struct gameInfo{
123        uint64 winner;
124        uint32 pointer;
125        uint bonus;//Additional bonuses other than the prize pool are issued by the admin
126        uint totalEth;
127        uint lastTime;
128        uint startTime;
129        orderInfo[] list;
130        mapping(uint64=>playerRecord) pinfo;
131     }
132     
133       struct  playerRecord
134     {  
135        bool status;
136        uint32 times;
137     } 
138     
139     event join(
140         uint16 indexed index,
141         uint key,
142         address indexed addr
143     );
144     
145    
146     event next_game(
147         uint16 indexed index
148         ); 
149     
150      mapping (uint64 => player)  player_;
151      mapping (address => uint64)  playAddr_;
152      mapping (uint64 => uint64)  playAff_;
153      mapping(uint16 =>gameInfo) gameInfo_;
154 
155      gameConfig  gameConfig_;
156      address  admin_;
157   
158      constructor() public {
159          admin_ = msg.sender;
160          getPlayId(msg.sender);
161          gameConfig_.eachPct=20;
162          gameConfig_.maxPct=100;
163          gameConfig_.feePct=6;
164          gameConfig_.poolPct=70;
165          gameConfig_.adminPct=15;
166          gameConfig_.levelPct1=10;
167          gameConfig_.levelPct2=5;
168          gameConfig_.index=1;
169          gameInfo_[1].startTime=now;
170     }
171     
172 function  joinGame(address _level1, address _level2) external payable safe(){
173         uint16 _index=gameConfig_.index;
174         gameInfo storage _g=gameInfo_[_index];
175         uint _now=now;
176         if(_g.lastTime>0){
177           require(_g.lastTime+86400 >_now,'Please wait for the start of the next round');
178         }
179         uint64 _pid=getPlayId(msg.sender);
180         initAddf(_pid,_level1,_level2);
181         uint _value=msg.value;
182         require(_value>=0.1 ether && _value<= 100 ether,'Eth Error');
183         require(_value%0.1 ether==0,'Eth Error2');
184         playerRecord storage _pr=_g.pinfo[_pid];
185         _g.totalEth=add(_g.totalEth,_value);
186         require(_pr.status==false,'Last settlement has not been completed');
187         _pr.status=true;
188         _pr.times++;
189          gameMatch(_g,_value);
190          uint32 _pct=gameConfig_.maxPct;
191         if(_pr.times<5){
192                _pct=_pr.times * gameConfig_.eachPct;
193         }
194         uint _balance = add(_value,safePercent(_pct,_value));
195         _g.list.push(orderInfo(
196             _pid,
197             _pct,
198              _pr.times,
199             _value,
200             _balance
201           ));
202       _g.lastTime=_now;
203 
204       emit join(_index,_g.list.length,msg.sender);
205 }
206 
207 //Start the next round of games
208 function nextGame() external safe(){
209     require(msg.sender == admin_,'Error 1');
210     uint16 _index=gameConfig_.index;
211     uint  _endTime=gameInfo_[_index].lastTime+86400;
212     uint _now=now;
213     require(_now > _endTime,'Error 2');
214      emit next_game(_index);
215      uint _lastIndex=gameInfo_[_index].list.length;
216      //Transfer to the winner
217      if(_lastIndex>0){
218          uint64 _winnerId=gameInfo_[_index].list[_lastIndex-1].pid;
219          uint _prizePool=safePercent(gameConfig_.feePct,gameInfo_[_index].totalEth);
220          _prizePool=safePercent(gameConfig_.poolPct,_prizePool);
221          _prizePool=add(_prizePool,gameInfo_[_index].bonus);//Additional bonuses other than the prize pool are issued by the admin
222          uint _adminFee =  safePercent(gameConfig_.feePct,_prizePool);//Admin fee
223          uint64 _adminId=playAddr_[admin_];
224          player_[_adminId].balance=add(player_[_adminId].balance,_adminFee);
225          uint _winnerAmount=sub(_prizePool,_adminFee);
226          player_[_winnerId].addr.transfer(_winnerAmount);
227      }
228     _index++;
229     gameConfig_.index=_index;
230     gameInfo_[_index].startTime=_now;
231 }
232 
233 function gameMatch(gameInfo storage _g,  uint _value) private{
234         uint _length=_g.list.length;
235         if(_length==0){
236              uint64 adminId=playAddr_[admin_];
237              player_[adminId].gameBalance=add(player_[adminId].gameBalance,_value);
238              return;
239         }
240             uint _myBalance=_value;
241             for(uint32 i=_g.pointer;i<_length;i++){
242                 orderInfo storage  _gip=_g.list[i];
243                 if(_gip.balance==0)
244                      break;
245                 if(_myBalance>=_gip.balance){
246                     _g.pinfo[_gip.pid].status=false;
247                     _myBalance=sub(_myBalance,_gip.balance);
248                     player_[_gip.pid].gameBalance=add( player_[_gip.pid].gameBalance,_gip.balance);
249                     _gip.balance=0;
250                     _g.pointer++;
251                 }else{
252                     _gip.balance=sub(_gip.balance,_myBalance);
253                     player_[_gip.pid].gameBalance=add(player_[_gip.pid].gameBalance,_myBalance);
254                     _myBalance=0;
255                     break;
256                }
257             }
258             if(_myBalance>0){
259                 uint64 adminId=playAddr_[admin_];
260                 player_[adminId].gameBalance=add(player_[adminId].gameBalance,_myBalance);
261             }
262 }
263     
264 function initAddf(uint64 _pid,address _level1, address _level2) private{
265     
266             address  _errorAddr=address(0);
267             uint64 _level1Pid=playAff_[_pid];
268             if(_level1Pid>0 || _level1 ==_errorAddr || _level1==_level2 || msg.sender==_level1 || msg.sender==_level2)
269                return;
270            if(_level1Pid==0 && _level1 == _errorAddr){
271                   uint64 adminId=playAddr_[admin_];
272                   playAff_[_pid]=adminId;
273                   return;
274            }
275               _level1Pid= playAddr_[_level1];
276               if(_level1Pid==0){
277                  _level1Pid=getPlayId(_level1);
278               }
279                   player_[_level1Pid].affNumLevel_1++;
280                   playAff_[_pid]=_level1Pid;
281                   uint64 _level2Pid=playAff_[_level1Pid];
282                   
283                   if(_level2Pid==0 &&  _level2 == _errorAddr){
284                      return;   
285                   }
286                      _level2Pid= playAddr_[_level2];
287                     if(_level2Pid==0){
288                        _level2Pid=getPlayId(_level2);
289                         playAff_[_level1Pid]=_level2Pid;
290                     }
291                     player_[_level2Pid].affNumLevel_2++;
292 }
293 
294     
295 function withdraw(uint64 pid) safe() external{
296         require(playAddr_[msg.sender] == pid,'Error Action');
297         require(player_[pid].addr == msg.sender,'Error Action');
298         require(player_[pid].balance > 0,'Insufficient balance');
299         uint balance =player_[pid].balance;
300         player_[pid].balance=0;
301         player_[pid].addr.transfer(balance);
302 }
303 
304 
305  function withdrawGame(uint64 pid) safe() external{
306         require(playAddr_[msg.sender] == pid,'Error Action');
307         require(player_[pid].addr == msg.sender,'Error Action');
308         require(player_[pid].gameBalance >0,'Insufficient balance');
309         uint _balance =player_[pid].gameBalance;
310         player_[pid].gameBalance=0;
311         uint64 _level1Pid=playAff_[pid];
312         uint64 _adminId=playAddr_[admin_];
313         //Withdrawal fee
314         uint _fee=safePercent(gameConfig_.feePct,_balance);
315         //The prize pool has been increased when the investment is added, there is no need to operate here.
316         //Admin
317         uint _adminAmount=safePercent(gameConfig_.adminPct,_fee);
318         
319         //1 Level
320         uint levellAmount=safePercent(gameConfig_.levelPct1,_fee);
321         
322         //2 Level
323         uint level2Amount=safePercent(gameConfig_.levelPct2,_fee);
324         if(_level1Pid >0 && _level1Pid!=_adminId){
325             player_[_level1Pid].balance=add(player_[_level1Pid].balance,levellAmount);
326             uint64 _level2Pid=playAff_[_level1Pid];
327              if(_level2Pid>0){
328                 player_[_level2Pid].balance=add(player_[_level2Pid].balance,level2Amount);
329              }else{
330                 _adminAmount=add(_adminAmount,level2Amount);
331              }
332         }else{
333             _adminAmount=add(_adminAmount,add(levellAmount,level2Amount));
334         }
335         player_[_adminId].balance=add(player_[_adminId].balance,_adminAmount);
336         return player_[pid].addr.transfer(sub(_balance,_fee));
337     }
338    
339      //2020.01.01 Used to update the game
340    function updateGame() external safe() {
341         uint time=1577808000;
342         require(now > time,'Time has not arrived');
343         require(msg.sender == admin_,'Error');
344         selfdestruct(admin_);
345     }
346    
347     function getPlayId(address addr) private returns(uint64){
348         require (address(0)!=addr,'Error Addr');
349         if(playAddr_[addr] >0){
350          return playAddr_[addr];
351         }
352               gameConfig_.autoPlayId++;
353               playAddr_[addr]=  gameConfig_.autoPlayId;
354               player memory _p;
355               _p.id=  gameConfig_.autoPlayId;
356               _p.addr=addr;
357               _p.timeStamp=uint32(now);
358               player_[gameConfig_.autoPlayId]=_p;
359               return gameConfig_.autoPlayId;
360    }
361    
362    function getGameInfo(uint16 _index)external view returns(
363        uint16,uint,uint,uint,uint,uint,uint
364        ){ 
365         gameInfo memory _g;
366        if(_index==0){
367              _g=gameInfo_[gameConfig_.index];
368        }else{
369              _g=gameInfo_[_index];
370        }
371        return(
372              gameConfig_.index,
373              _g.bonus,//Additional bonuses other than the prize pool are issued by the admin
374             _g.totalEth,
375             _g.startTime,
376             _g.lastTime,
377             _g.list.length,
378             gameInfo_[gameConfig_.index].list.length
379         );
380   }
381   
382   function getOrderInfo(uint16 _index, uint64 _key)external view returns(uint32,uint,uint,uint32){ 
383            uint64 _pid =playAddr_[msg.sender];
384        orderInfo memory _g=gameInfo_[_index].list[_key];
385        require(_g.pid==_pid,'Error 404');
386        return(
387             _g.pct,
388             _g.eth,
389             _g.balance,
390             _g.times
391         );
392   }
393     
394   function getMyGameStatus(uint16 _index)external view returns (bool,uint32){
395          uint64 _pid =playAddr_[msg.sender];
396          playerRecord memory _g;
397        if(_index>0){
398            _g=gameInfo_[_index].pinfo[_pid];
399        }else{
400              _g=gameInfo_[gameConfig_.index].pinfo[_pid];
401        }
402       return (
403             _g.status,
404             _g.times
405           );
406   }
407   
408  function getMyInfo()external view returns(uint64,uint,uint32,uint32,uint32,uint){ 
409        uint64 _pid =playAddr_[msg.sender];
410        player memory _p=player_[_pid];
411        return(
412             _pid,
413             _p.balance,
414             _p.affNumLevel_1,
415             _p.affNumLevel_2,
416             _p.timeStamp,
417             _p.gameBalance
418         );
419   }
420   
421   //Add extra prizes to the prize pool ETH
422   function payment() external payable safe(){
423       //Additional bonuses other than the prize pool are issued by the admin
424       if(msg.value>0)
425      gameInfo_[gameConfig_.index].bonus=add(gameInfo_[gameConfig_.index].bonus,msg.value);
426   }
427   
428 
429   function getConfig() external view returns(
430        uint8,uint8,uint8,uint8,uint8,uint8,uint32
431        ){
432      return (      
433          gameConfig_.eachPct,
434          gameConfig_.feePct,
435          gameConfig_.poolPct,
436          gameConfig_.adminPct,
437          gameConfig_.levelPct1,
438          gameConfig_.levelPct2,
439         gameConfig_.maxPct
440       );
441     }
442 }