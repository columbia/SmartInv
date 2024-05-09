1 pragma solidity ^0.4.16;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function sub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function div(uint a, uint b) internal pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 contract Owned {
21     address public owner;
22     address public newOwner;
23     event OwnershipTransferred(address indexed _from, address indexed _to);
24     function Owned() public {
25         owner = msg.sender;
26     }
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     function transferOwnership(address _newOwner) public onlyOwner {
32         newOwner = _newOwner;
33     }
34     
35     function acceptOwnership() public {
36         require(msg.sender == newOwner);
37         OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39         newOwner = address(0);
40     }
41 }
42 contract JungleScratch is Owned {
43     using SafeMath for uint;
44     uint public LimitBottom = 0.02 ether;
45     uint public LimitTop = 0.1 ether;
46     
47     address public Drawer;
48     struct Game {
49         bytes32 SecretKey_P;
50         bool isPlay;
51         bool isPay;
52         uint Result;
53         uint Time;
54         address Buyer;
55         uint value;
56     }
57     
58     mapping (bytes32 => Game) public TicketPool;
59     
60     event SubmitTicket(bytes32 indexed SecretKey_D_hash, uint Bet_amount,bytes32 SecretKey_P, address Player);   
61     event Result(bytes32 SecretKey_D_hash, bytes32 SecretKey_D,address Buyer, uint[] Bird_Result, uint Game_Result, uint time);
62     event Pay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);
63     event Owe(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);
64     event OwePay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);
65     
66     function JungleScratch (address drawer_) public {
67         Drawer = drawer_;
68     }
69     
70     function submit(bytes32 secretKey_P, bytes32 secretKey_D_hash) payable public {
71         require(msg.value == 0.02 ether || msg.value == 0.04 ether || msg.value == 0.06 ether || msg.value == 0.08 ether || msg.value == 0.1 ether);
72         require(TicketPool[secretKey_D_hash].Time == 0);
73         require(msg.value >= LimitBottom && msg.value <= LimitTop);
74         uint check = msg.value.div(20000000000000000);
75         require(check == 1 || check == 2 || check == 3 || check == 4 || check == 5);
76         
77         SubmitTicket(secretKey_D_hash, msg.value, secretKey_P, msg.sender);
78         TicketPool[secretKey_D_hash] = Game(secretKey_P,false,false,0,block.timestamp,msg.sender,msg.value);
79     }
80     
81     function award(bytes32 secretKey_D) public {
82         
83         require(Drawer == msg.sender);
84         
85         bytes32 secretKey_D_hash = keccak256(secretKey_D);
86         
87         Game local_ = TicketPool[secretKey_D_hash];
88         
89         require(local_.Time != 0 && !local_.isPlay);
90         
91         uint game_result = 0;
92         uint[] memory RandomResult = new uint[](9);
93         
94         RandomResult[0] = uint(keccak256("Pig World is an AWESOME team",secretKey_D,'a',local_.SecretKey_P)) % 1000 + 1;
95         RandomResult[1] = uint(keccak256(local_.SecretKey_P,"Every Game in our world is provably fair",secretKey_D,'b')) % 1000 + 1;
96         RandomResult[2] = uint(keccak256('c',secretKey_D,"OMG it is a revolution dapp",local_.SecretKey_P)) % 1000 + 1;
97         RandomResult[3] = uint(keccak256(secretKey_D,"hahahaha",local_.SecretKey_P,'d',"thanks for our team member and all player support.")) % 1000 + 1;
98         RandomResult[4] = uint(keccak256("CC is our CEO",secretKey_D,"he can eat Betel nut",local_.SecretKey_P,'e')) % 1000 + 1;
99         RandomResult[5] = uint(keccak256(20180612,"justin is our researcher",secretKey_D,"and he love little girl(at least 18, so it is ok)",local_.SecretKey_P,'f')) % 1000 + 1;
100         RandomResult[6] = uint(keccak256("jeremy is our marketing",secretKey_D,'g',local_.SecretKey_P,"he is very humble and serious")) % 1000 + 1;
101         RandomResult[7] = uint(keccak256('h',secretKey_D,"We are a geek team",local_.SecretKey_P,"we love blockchain")) % 1000 + 1;
102         RandomResult[8] = uint(keccak256(secretKey_D,"hope you win a big prize",local_.SecretKey_P,"love you all!!!",'i')) % 1000 + 1;
103         
104         for (uint n = 0; n < 9; n++) {
105             
106             if(RandomResult[n]< 81){
107                 RandomResult[n] = 0;
108             } else if(RandomResult[n]< 168){
109                 RandomResult[n] = 1;
110             } else if(RandomResult[n]< 266){
111                 RandomResult[n] = 2;
112             } else if(RandomResult[n]< 381){
113                 RandomResult[n] = 3;
114             } else if(RandomResult[n]< 535){
115                 RandomResult[n] = 4;
116             } else if(RandomResult[n]< 749){
117                 RandomResult[n] = 5;
118             } else if(RandomResult[n]< 1001){
119                 RandomResult[n] = 6;
120             }
121         }
122             
123         for(uint nn = 0; nn < 6; nn++){
124             uint count = 0;
125             for(uint p = 0; p < 9; p++){
126                 if(RandomResult[p] == nn)
127                     count ++;
128             }
129             
130             if(count >= 3 && nn == 0)
131                 game_result = game_result.add(TicketPool[secretKey_D_hash].value.div(20000000000000000).mul(0.1 ether));
132                 
133             if(count >= 3 && nn == 1)
134                 game_result = game_result.add(TicketPool[secretKey_D_hash].value.div(20000000000000000).mul(0.08 ether));
135                 
136             if(count >= 3 && nn == 2)
137                 game_result = game_result.add(TicketPool[secretKey_D_hash].value.div(20000000000000000).mul(0.06 ether));
138                 
139             if(count >= 3 && nn == 3)
140                 game_result = game_result.add(TicketPool[secretKey_D_hash].value.div(20000000000000000).mul(0.04 ether));
141                 
142             if(count >= 3 && nn == 4)
143                 game_result = game_result.add(TicketPool[secretKey_D_hash].value.div(20000000000000000).mul(0.02 ether)); 
144                 
145             if(count >= 3 && nn == 5)
146                 game_result = game_result.add(TicketPool[secretKey_D_hash].value.div(20000000000000000).mul(0.01 ether)); 
147         }
148     
149         
150         if(game_result != 0){
151             TicketPool[secretKey_D_hash].Result = game_result;
152             if (address(this).balance >= game_result && TicketPool[secretKey_D_hash].Buyer.send(game_result)) {
153                 TicketPool[secretKey_D_hash].isPay = true;
154                 Pay(secretKey_D_hash,TicketPool[secretKey_D_hash].Buyer, game_result);
155             } else {
156                 Owe(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, game_result);
157                 TicketPool[secretKey_D_hash].isPay = false;
158             } 
159          } else {
160             TicketPool[secretKey_D_hash].isPay = true;
161         }
162         
163         Result(secretKey_D_hash, secretKey_D, TicketPool[secretKey_D_hash].Buyer, RandomResult, game_result, block.timestamp);
164         TicketPool[secretKey_D_hash].isPlay = true;
165     }
166     
167     function () public payable {
168        
169     }
170     
171     function withdraw(uint withdrawEther_) public onlyOwner {
172         msg.sender.transfer(withdrawEther_);
173     }
174     
175     function changeLimit(uint _bottom, uint _top) public onlyOwner {
176         LimitBottom = _bottom;
177         LimitTop = _top;
178     }
179     
180     function changeDrawer(address drawer_) public onlyOwner {
181         Drawer = drawer_;
182     }
183     
184     function getisPlay(bytes32 secretKey_D_hash) public constant returns (bool isplay){
185         return TicketPool[secretKey_D_hash].isPlay;
186     }
187     
188     function getTicketTime(bytes32 secretKey_D_hash) public constant returns (uint Time){
189         return TicketPool[secretKey_D_hash].Time;
190     }
191     
192     function chargeOwe(bytes32 secretKey_D_hash) public {
193         require(!TicketPool[secretKey_D_hash].isPay);
194         require(TicketPool[secretKey_D_hash].isPlay);
195         require(TicketPool[secretKey_D_hash].Result != 0);
196         
197         if(address(this).balance >= TicketPool[secretKey_D_hash].Result){
198             if (TicketPool[secretKey_D_hash].Buyer.send(TicketPool[secretKey_D_hash].Result)) {
199                 TicketPool[secretKey_D_hash].isPay = true;
200                 OwePay(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, TicketPool[secretKey_D_hash].Result);
201             }
202         } 
203     }
204 }