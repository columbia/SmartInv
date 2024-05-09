1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract Owned {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     function Owned() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40     
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 
50 contract SicBo is Owned {
51     using SafeMath for uint;
52 
53     uint public LimitBottom = 0.05 ether;
54     uint public LimitTop = 0.2 ether;
55     
56     address public Drawer;
57 
58     struct Game {
59         bytes32 Bets;
60         bytes32 SecretKey_P;
61         bool isPlay;
62         bool isPay;
63         uint Result;
64         uint Time;
65         address Buyer;
66     }
67     
68     mapping (bytes32 => Game) public TicketPool;
69     
70     event SubmitTicket(bytes32 indexed SecretKey_D_hash, uint Bet_amount, bytes32 Bet, bytes32 SecretKey_P, address Player);   
71     event Result(bytes32 indexed SecretKey_D_hash, bytes32 indexed SecretKey_D,address indexed Buyer, uint Dice1, uint Dice2, uint Dice3, uint Game_Result, uint time);
72     event Pay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);
73     event Owe(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);
74     event OwePay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);
75     
76     function SicBo (address drawer_) public {
77         Drawer = drawer_;
78     }
79     
80     function submit(bytes32 Bets, bytes32 secretKey_P, bytes32 secretKey_D_hash) payable public {
81         
82         require(TicketPool[secretKey_D_hash].Time == 0);
83         require(msg.value >= LimitBottom && msg.value <= LimitTop);
84 
85         uint  bet_total_amount = 0;
86         for (uint i = 0; i < 29; i++) {
87             if(Bets[i] == 0x00) continue;
88             
89             uint bet_amount_ = uint(Bets[i]).mul(10000000000000000);
90 
91             bet_total_amount = bet_total_amount.add(bet_amount_);
92         }
93         
94         if(bet_total_amount == msg.value){
95             SubmitTicket(secretKey_D_hash, msg.value, Bets, secretKey_P, msg.sender);
96             TicketPool[secretKey_D_hash] = Game(Bets,secretKey_P,false,false,0,block.timestamp,msg.sender);
97         }else{
98             revert();
99         }
100         
101     }
102     
103     function award(bytes32 secretKey_D) public {
104         
105         require(Drawer == msg.sender);
106         
107         bytes32 secretKey_D_hash = keccak256(secretKey_D);
108         
109         Game local_ = TicketPool[secretKey_D_hash];
110         
111         require(local_.Time != 0 && !local_.isPlay);
112         
113         uint dice1 = uint(keccak256("Pig World ia a Awesome game place", local_.SecretKey_P, secretKey_D)) % 6 + 1;
114         uint dice2 = uint(keccak256(secretKey_D, "So you will like us so much!!!!", local_.SecretKey_P)) % 6 + 1;
115         uint dice3 = uint(keccak256(local_.SecretKey_P, secretKey_D, "Don't think this is unfair", "Our game are always provably fair...")) % 6 + 1;
116     
117         uint amount = 0;
118         uint total = dice1 + dice2 + dice3;
119         
120         for (uint ii = 0; ii < 29; ii++) {
121             if(local_.Bets[ii] == 0x00) continue;
122             
123             uint bet_amount = uint(local_.Bets[ii]) * 10000000000000000;
124             
125             if(ii >= 23)
126                 if (dice1 == ii - 22 || dice2 == ii - 22 || dice3 == ii - 22) {
127                     uint8 count = 1;
128                     if (dice1 == ii - 22) count++;
129                     if (dice2 == ii - 22) count++;
130                     if (dice3 == ii - 22) count++;
131                     amount += count * bet_amount;
132                 }
133 
134             if(ii <= 8)
135                 if (dice1 == dice2 && dice2 == dice3 && dice1 == dice3) {
136                     if (ii == 8) {
137                         amount += 31 * bet_amount;
138                     }
139     
140                     if(ii >= 2 && ii <= 7)
141                         if (dice1 == ii - 1) {
142                             amount += 181 * bet_amount;
143                         }
144     
145                 } else {
146                     
147                     if (ii == 0 && total <= 10) {
148                         amount += 2 * bet_amount;
149                     }
150                     
151                     if (ii == 1 && total >= 11) {
152                         amount += 2 * bet_amount;
153                     }
154                 }
155                 
156             if(ii >= 9 && ii <= 22){
157                 if (ii == 9 && total == 4) {
158                     amount += 61 * bet_amount;
159                 }
160                 if (ii == 10 && total == 5) {
161                     amount += 31 * bet_amount;
162                 }
163                 if (ii == 11 && total == 6) {
164                     amount += 18 * bet_amount;
165                 }
166                 if (ii == 12 && total == 7) {
167                     amount += 13 * bet_amount;
168                 }
169                 if (ii == 13 && total == 8) {
170                     amount += 9 * bet_amount;
171                 }
172                 if (ii == 14 && total == 9) {
173                     amount += 8 * bet_amount;
174                 }
175                 if (ii == 15 && total == 10) {
176                     amount += 7 * bet_amount;
177                 }
178                 if (ii == 16 && total == 11) {
179                     amount += 7 * bet_amount;
180                 }
181                 if (ii == 17 && total == 12) {
182                     amount += 8 * bet_amount;
183                 }
184                 if (ii == 18 && total == 13) {
185                     amount += 9 * bet_amount;
186                 }
187                 if (ii == 19 && total == 14) {
188                     amount += 13 * bet_amount;
189                 }
190                 if (ii == 20 && total == 15) {
191                     amount += 18 * bet_amount;
192                 }
193                 if (ii == 21 && total == 16) {
194                     amount += 31 * bet_amount;
195                 }
196                 if (ii == 22 && total == 17) {
197                     amount += 61 * bet_amount;
198                 }
199             }
200         }
201         
202         Result(secretKey_D_hash, secretKey_D, TicketPool[secretKey_D_hash].Buyer, dice1, dice2, dice3, amount, block.timestamp);
203         TicketPool[secretKey_D_hash].isPlay = true;
204         
205         if(amount != 0){
206             TicketPool[secretKey_D_hash].Result = amount;
207             if (address(this).balance >= amount && TicketPool[secretKey_D_hash].Buyer.send(amount)) {
208                 TicketPool[secretKey_D_hash].isPay = true;
209                 Pay(secretKey_D_hash,TicketPool[secretKey_D_hash].Buyer, amount);
210             } else {
211                 Owe(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, amount);
212                 TicketPool[secretKey_D_hash].isPay = false;
213             } 
214          } else {
215             TicketPool[secretKey_D_hash].isPay = true;
216         }
217         
218     }
219     
220     function () public payable {
221        
222     }
223     
224     function withdraw(uint withdrawEther_) public onlyOwner {
225         msg.sender.transfer(withdrawEther_);
226     }
227     
228     function changeLimit(uint _bottom, uint _top) public onlyOwner {
229         LimitBottom = _bottom;
230         LimitTop = _top;
231     }
232     
233     function changeDrawer(address drawer_) public onlyOwner {
234         Drawer = drawer_;
235     }
236     
237     function getisPlay(bytes32 secretKey_D_hash) public constant returns (bool isplay){
238         return TicketPool[secretKey_D_hash].isPlay;
239     }
240     
241     function getTicketTime(bytes32 secretKey_D_hash) public constant returns (uint Time){
242         return TicketPool[secretKey_D_hash].Time;
243     }
244     
245     function chargeOwe(bytes32 secretKey_D_hash) public {
246         require(!TicketPool[secretKey_D_hash].isPay);
247         require(TicketPool[secretKey_D_hash].isPlay);
248         require(TicketPool[secretKey_D_hash].Result != 0);
249         
250         if(address(this).balance >= TicketPool[secretKey_D_hash].Result){
251             if (TicketPool[secretKey_D_hash].Buyer.send(TicketPool[secretKey_D_hash].Result)) {
252                 TicketPool[secretKey_D_hash].isPay = true;
253                 OwePay(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, TicketPool[secretKey_D_hash].Result);
254             }
255         } 
256     }
257 }