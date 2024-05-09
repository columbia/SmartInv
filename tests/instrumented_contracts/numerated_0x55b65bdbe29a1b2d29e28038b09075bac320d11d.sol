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
21 contract safeApi{
22     
23    modifier safe(){
24         address _addr = msg.sender;
25         require (_addr == tx.origin,'Error Action!');
26         uint256 _codeLength;
27         assembly {_codeLength := extcodesize(_addr)}
28         require(_codeLength == 0, "Sender not authorized!");
29             _;
30     }
31 
32 
33     
34  function toBytes(uint256 _num) internal returns (bytes _ret) {
35    assembly {
36         _ret := mload(0x10)
37         mstore(_ret, 0x20)
38         mstore(add(_ret, 0x20), _num)
39     }
40 }
41 
42 function subStr(string _s, uint start, uint end) internal pure returns (string){
43         bytes memory s = bytes(_s);
44         string memory copy = new string(end - start);
45 //        string memory copy = new string(5);
46           uint k = 0;
47         for (uint i = start; i < end; i++){ 
48             bytes(copy)[k++] = bytes(_s)[i];
49         }
50         return copy;
51     }
52      
53 
54  function safePercent(uint256 a,uint256 b) 
55       internal
56       constant
57       returns(uint256)
58       {
59         assert(a>0 && a <=100);
60         return  div(mul(b,a),100);
61       }
62       
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68  
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0∂
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75  
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80  
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 
87 }
88 
89 contract gameShare is safeApi{
90     struct player
91     {
92         uint256 id;
93         address addr;
94         uint256 balance;//wei
95         uint256 affNumLevel_1;
96         uint256 affNumLevel_2;
97         uint256 timeStamp;
98     }
99  
100     mapping (uint256 => player) public player_;
101     mapping (address => uint256) public playAddr_;
102     mapping (uint256 => uint256) public playAff_;
103     
104     mapping (address => uint256) private contractWhite;
105     address [] private contractWhitelist;
106     
107     mapping(address=>uint256) public otherGameAff_;
108     
109     uint256 private autoPlayId_=123456;
110     address public admin_;
111     uint256 public gameTicketWei_=10000000000000000;//0.01 ether
112     uint8 public leve1Rewards_=50;//%
113     uint8 public leve2Rewards_=20;//%
114     uint256 public feeAmount_=200;
115 
116 
117     /* Initializes contract with initial supply tokens to the creator of the contract */
118     constructor() public {
119         admin_ = msg.sender;
120         getPlayId();
121         contractWhitelist.push(address(0));
122     }
123     
124     /* Send coins */
125     function addGame(uint256 _affCode)
126     safe() 
127     isPlay() 
128     external
129     payable {
130         
131       if(_affCode == 0 &&  feeAmount_>0){
132              feeAmount_--;
133       }else{
134          require(msg.value == gameTicketWei_,'Please pay the correct eth');
135       }
136        uint256 _pid=getPlayId();
137       if(msg.value==0)
138         return;
139        
140         uint256 adminAmount=msg.value;
141         if(_affCode>0 && _affCode != _pid && player_[_affCode].id >0)
142         {
143              uint256 leve1Amount=safePercent(leve1Rewards_,gameTicketWei_);
144              player_[_affCode].affNumLevel_1++;
145              playAff_[_pid]=player_[_affCode].id;
146              adminAmount-=leve1Amount;
147              player_[_affCode].balance+=leve1Amount;
148              uint256 leve2Pid=playAff_[_affCode];
149               if(leve2Pid>0){
150                 uint256 leve2Amount=safePercent(leve2Rewards_,gameTicketWei_);
151                 player_[leve2Pid].affNumLevel_2++;
152                 adminAmount-=leve2Amount;
153                 player_[leve2Pid].balance+=leve2Amount;
154               }
155         }
156         player_[playAddr_[admin_]].balance=add(player_[playAddr_[admin_]].balance,adminAmount);
157     }
158     
159     
160     function withdraw(uint256 pid) safe() external{
161         require(playAddr_[msg.sender] == pid,'Error Action');
162         require(player_[pid].addr == msg.sender,'Error Action');
163         require(player_[pid].balance >= gameTicketWei_,'Insufficient balance');
164         uint256 balance =player_[pid].balance;
165         player_[pid].balance=0;
166         player_[pid].addr.transfer(balance);
167     }
168     
169 
170     
171     function getPlayId() private returns(uint256){
172         
173          require(
174                 playAddr_[msg.sender] ==0,
175                 "Error Player"
176             );
177         
178         autoPlayId_++;
179         uint256 _pid=autoPlayId_;
180        
181         playAddr_[msg.sender]=_pid;
182         player_[_pid].id=_pid;
183         player_[_pid].addr=msg.sender;
184         player_[_pid].balance=0;
185         player_[_pid].timeStamp=now;    
186         return _pid;
187    }
188    
189      modifier  isPlay(){
190             require(
191                 playAddr_[msg.sender] == 0,
192                 "Everyone can only participate once"
193                 );        
194             _;
195         }
196     
197     function getShareAff(uint256 _affCode) external view returns(uint256,address,address){
198         
199         
200         uint256 pid=playAddr_[msg.sender];
201         uint256 level1pid=playAff_[pid];
202         if(pid>0 && level1pid>0){
203           uint256 level2Pid=playAff_[level1pid];
204           return(
205             player_[level1pid].id,
206             player_[level1pid].addr,
207             player_[level2Pid].addr
208             );
209         }
210         uint256 level2Pid=playAff_[_affCode];
211         return(
212             player_[_affCode].id,
213             player_[_affCode].addr,
214             player_[level2Pid].addr
215             );
216     }
217         
218     function getOtherGameAff() external view returns(uint256,address,address){
219         uint256 pid=otherGameAff_[msg.sender];
220         require(pid>0 && player_[pid].id>0);
221         uint256 level2Pid = playAff_[pid];
222         return(
223             pid,
224             player_[pid].addr,
225             player_[level2Pid].addr
226             );
227     }
228   
229     //Create a user's sharing relationship
230     function addOtherGameAff(uint256 pid,address myAddr,address level1,address level2) public{
231         
232         uint256 _codeLength;
233         address _addr = msg.sender;
234         assembly {_codeLength := extcodesize(_addr)}
235         require(_codeLength > 0, "Sender not authorized!");
236         require(contractWhite[_addr]>0,'ERROR');
237         require(address(0)!= myAddr);
238         require(pid >0 && address(0)!= level1 && player_[pid].addr == level1,'Error1');
239         require(myAddr!=level1,'Error4');
240         require(myAddr!=level2,'Error4');
241         uint256  level2Pid=playAff_[pid];
242         require(level2==player_[level2Pid].addr,'Error2');
243         uint256 addfPid=otherGameAff_[myAddr];        
244         if(addfPid>0){
245             require(addfPid ==pid);
246             return;
247         }
248         otherGameAff_[myAddr]=pid;
249     }
250     
251     //update Can get a contract to share information
252     function updateCW(address addr,uint8 status) external safe(){
253         require(msg.sender==admin_);
254         if(status==0){
255             if(contractWhite[addr]==0){
256                 contractWhitelist.push(addr);
257                 contractWhite[addr]=contractWhitelist.length;
258             }
259         }else{
260            delete contractWhitelist[contractWhite[addr]];
261            delete  contractWhite[addr];
262         }
263     }
264     
265       //2020.01.01 Close Game
266    function closeGame() external safe() {
267         uint256 closeTime=1577808000;
268         require(now > closeTime,'Time has not arrived');
269         require(msg.sender == admin_,'Error');
270         selfdestruct(admin_);
271     }
272     
273     function getCwList() external  safe()  view returns( address []){
274          require(msg.sender==admin_);
275          return contractWhitelist;
276     }
277         
278 }