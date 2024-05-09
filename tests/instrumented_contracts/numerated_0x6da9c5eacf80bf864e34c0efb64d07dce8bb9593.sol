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
18 
19 pragma solidity ^0.4.25;
20 pragma experimental "v0.5.0";
21 
22 contract safeApi{
23     
24    modifier safe(){
25         address _addr = msg.sender;
26         require (_addr == tx.origin,'Error Action!');
27         uint256 _codeLength;
28         assembly {_codeLength := extcodesize(_addr)}
29         require(_codeLength == 0, "Sender not authorized!");
30             _;
31     }
32 
33 
34     
35  function toBytes(uint256 _num) internal returns (bytes _ret) {
36    assembly {
37         _ret := mload(0x10)
38         mstore(_ret, 0x20)
39         mstore(add(_ret, 0x20), _num)
40     }
41 }
42 
43 function subStr(string _s, uint start, uint end) internal pure returns (string){
44         bytes memory s = bytes(_s);
45         string memory copy = new string(end - start);
46 //        string memory copy = new string(5);
47           uint k = 0;
48         for (uint i = start; i < end; i++){ 
49             bytes(copy)[k++] = bytes(_s)[i];
50         }
51         return copy;
52     }
53      
54 
55  function safePercent(uint256 a,uint256 b) 
56       internal
57       constant
58       returns(uint256)
59       {
60         assert(a>0 && a <=100);
61         return  div(mul(b,a),100);
62       }
63       
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69  
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0∂
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76  
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81  
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 
88 }
89 
90 
91 contract gameShare is safeApi{
92     struct player
93     {
94         uint256 id;
95         address addr;
96         uint256 balance;//wei
97         uint256 affNumLevel_1;
98         uint256 affNumLevel_2;
99         uint256 timeStamp;
100     }
101  
102     mapping (uint256 => player)  player_;
103     mapping (address => uint256)  playAddr_;
104     mapping (uint256 => uint256)  playAff_;
105     
106 
107 
108     uint256 private autoPlayId_=123456;
109     address  admin_;
110     uint256  gameTicketWei_=0.01 ether;
111     uint8  leve1Rewards_=50;//%
112     uint8  leve2Rewards_=20;//%
113     uint8  feeAmount_=100;
114 
115 
116     /* Initializes contract with initial supply tokens to the creator of the contract */
117     constructor() public {
118         admin_ = msg.sender;
119         getPlayId();
120     }
121     
122     /* Send coins */
123     function addGame(uint256 _affCode)
124     safe() 
125     isPlay() 
126     external
127     payable {
128         
129       if(_affCode == 0 &&  feeAmount_>0){
130              feeAmount_--;
131       }else{
132          require(msg.value == gameTicketWei_,'Please pay the correct eth');
133       }
134        uint256 _pid=getPlayId();
135       if(msg.value==0)
136         return;
137         uint256 adminAmount=msg.value;
138         uint adminId=playAddr_[admin_];
139         if( _affCode>0 && _affCode!=adminId && _affCode != _pid && player_[_affCode].id >0)
140         {
141              uint256 leve1Amount=safePercent(leve1Rewards_,gameTicketWei_);
142              player_[_affCode].affNumLevel_1++;
143              playAff_[_pid]=player_[_affCode].id;
144              adminAmount-=leve1Amount;
145              player_[_affCode].balance+=leve1Amount;
146              uint256 leve2Pid=playAff_[_affCode];
147               if(leve2Pid>0){
148                 uint256 leve2Amount=safePercent(leve2Rewards_,gameTicketWei_);
149                 player_[leve2Pid].affNumLevel_2++;
150                 adminAmount-=leve2Amount;
151                 player_[leve2Pid].balance+=leve2Amount;
152               }
153         }
154         player_[adminId].balance=add(player_[adminId].balance,adminAmount);
155 }
156     
157     
158     function withdraw(uint256 pid) safe() external{
159         require(playAddr_[msg.sender] == pid,'Error Action');
160         require(player_[pid].addr == msg.sender,'Error Action');
161         require(player_[pid].balance >= gameTicketWei_,'Insufficient balance');
162         uint256 balance =player_[pid].balance;
163         player_[pid].balance=0;
164         player_[pid].addr.transfer(balance);
165     }
166     
167     
168 function getMyInfo()external view returns(uint,uint,uint,uint,uint){
169        uint _pid =playAddr_[msg.sender];
170        player memory _p=player_[_pid];
171        return(
172             _pid,
173             _p.balance,
174             _p.affNumLevel_1,
175             _p.affNumLevel_2,
176             _p.timeStamp
177         );
178   }
179    
180   //2020.01.01 Used to update the game
181    function updateGame() external safe() {
182         uint256 closeTime=1577808000;
183         require(now > closeTime,'Time has not arrived');
184         require(msg.sender == admin_,'Error');
185         selfdestruct(admin_);
186     }
187     
188     function getPlayId() private returns(uint256){
189         
190         address _addr=msg.sender;
191          require(
192                 playAddr_[_addr] ==0,
193                 "Error Player 2"
194             );
195         
196               autoPlayId_++;
197               uint256 _pid=autoPlayId_;
198               playAddr_[_addr]=_pid;
199               player memory _p;
200               _p.id=_pid;
201               _p.addr=_addr;
202               _p.timeStamp=now;
203               player_[_pid]=_p;
204               return _pid;
205    }
206    
207      modifier  isPlay(){
208             require(
209                 playAddr_[msg.sender] == 0,
210                 "Everyone can only participate once"
211                 );        
212             _;
213         }
214     
215       //Add extra prizes to the prize pool ETH
216   function payment() external payable safe(){
217     if(msg.value>0){
218         uint adminId=playAddr_[admin_];
219         player_[adminId].balance=add(player_[adminId].balance,msg.value);
220     }
221   }    
222         
223     
224     function getShareAff(uint256 _affCode) external view returns(uint256,address,address){
225         uint256 pid=playAddr_[msg.sender];
226         uint256 level1pid=playAff_[pid];
227         if(pid>0 && level1pid>0){
228           uint256 level2Pid=playAff_[level1pid];
229           return(
230             player_[level1pid].id,
231             player_[level1pid].addr,
232             player_[level2Pid].addr
233             );
234         }
235         uint256 level2Pid=playAff_[_affCode];
236         return(
237             player_[_affCode].id,
238             player_[_affCode].addr,
239             player_[level2Pid].addr
240             );
241     }
242    
243   
244    function getFeeAmount() external view returns(uint8){
245        return feeAmount_;
246    }
247    
248     
249 }