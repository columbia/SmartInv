1 pragma solidity ^0.4.23;
2 
3 // * https://dice1.win - fair games that pay Ether. Version 1.
4 //
5 // * Ethereum smart contract, deployed at 0x5116A7B3FFF82C0FFaB4A49aBaE659aBF49A3f95.
6 
7 contract Dice1Win{
8     using SafeMath for uint256;
9     
10     uint256 constant MIN_BET = 0.01 ether;
11     mapping(address => uint256) public balanceOf;
12     address public owner;
13     
14     struct Bet {
15         uint256 amount;
16         uint256 target;
17         address gambler;
18     }
19     
20     uint256 public times = 1;
21     uint256 public totalBig ;
22     uint256 public totalSmall ;
23     
24     Bet[] public big ;
25     Bet[] public small ;
26     
27     
28     event placeBetEvent(uint256 totalCount);
29     event settleBetEvent(uint256 random, uint256 times);
30     event FailedPayment(address indexed beneficiary, uint256 amount);
31     event Payment(address indexed beneficiary, uint256 amount);
32     
33     
34     function placeBet(uint256 _target) external payable {
35         require (msg.value >= MIN_BET);
36         
37         if(_target ==1){
38             big.push(
39                 Bet({
40                     amount : msg.value,
41                     target : 1,
42                     gambler: msg.sender
43                 })
44             );
45             totalBig = totalBig.add(msg.value);
46         }
47         
48         if(_target ==0){
49             small.push(
50                 Bet({
51                     amount : msg.value,
52                     target : 0,
53                     gambler: msg.sender
54                 })
55             );
56             totalSmall = totalSmall.add(msg.value);
57         }
58         
59         uint256 totalCount = big.length.add(small.length);
60         
61         if(totalCount >= 20){
62             settleBet();
63         }
64         
65         emit placeBetEvent(totalCount);
66         
67     }
68     
69     
70     function getInfo(uint256 _uint) view public returns(uint256){
71         if(_uint ==1){
72             return big.length;
73         }
74         
75         if(_uint ==0){
76             return small.length;
77         }
78         
79     }
80     
81     
82     
83     function settleBet() private {
84         
85         times += 1;
86         
87         if(totalSmall == 0 || totalBig==0){
88             for(uint256 i=0;i<big.length;i++){
89                 balanceOf[big[i].gambler] = balanceOf[big[i].gambler].add(big[i].amount);
90             }
91             for( i=0;i<small.length;i++){
92                 balanceOf[small[i].gambler] = balanceOf[small[i].gambler].add(small[i].amount);
93             }
94             emit settleBetEvent(100, times);
95         }else{
96             
97             uint _random = random();
98             if(_random >=50){
99                 for( i=0;i<big.length;i++){
100                     balanceOf[big[i].gambler] = balanceOf[big[i].gambler].add(big[i].amount * odds(1)/10000);
101                 }
102             }else{
103                 for( i=0;i<small.length;i++){
104                     balanceOf[small[i].gambler] = balanceOf[small[i].gambler].add(small[i].amount * odds(0) / 10000);
105                 }
106             }
107             balanceOf[owner] = balanceOf[owner].add((totalSmall + totalBig)  * 1/100);
108             emit settleBetEvent(_random, times);
109         }
110         
111         clean();
112         
113         
114     }
115     
116     function odds(uint256 _target) view public returns(uint256){
117         
118         if(totalSmall == 0 || totalBig == 0){
119             return 0;
120         }
121         
122         if(_target == 1){
123             return 10000*(totalSmall.add(totalBig)) / totalBig * 99/100;
124         }
125         
126         if(_target == 0){
127             return 10000*(totalSmall.add(totalBig)) / totalSmall * 99/100;
128         }
129 
130     }
131     
132     function withdrawFunds(uint256 withdrawAmount) public  {
133         require (balanceOf[msg.sender] >= withdrawAmount);
134         require (withdrawAmount >= 0);
135         
136         if (msg.sender.send(withdrawAmount)) {
137             emit Payment(msg.sender, withdrawAmount);
138             balanceOf[msg.sender] = balanceOf[msg.sender].sub(withdrawAmount);
139         } else {
140             emit FailedPayment(msg.sender, withdrawAmount);
141         }
142         
143     }
144     
145     
146     
147     
148     function random() private view returns(uint256){
149         
150         if(big.length >0){
151             address addr = big[big.length-1].gambler;  
152         }else{
153              addr = msg.sender; 
154         }
155 
156         uint256 random = uint(keccak256(now, addr, (totalSmall + totalSmall))) % 100;
157         
158         if(small.length >0){
159              addr = small[big.length-1].gambler;  
160         }else{
161              addr = msg.sender; 
162         }
163         
164         uint256 random2 = uint(keccak256(now, addr, random)) % 100;
165         
166         return random2;
167     }
168     
169     
170     function clean() private{
171         delete totalBig;
172         delete totalSmall;
173         delete big;
174         delete small;
175     }
176     
177     
178     constructor() public {
179         owner = msg.sender;
180     }
181 
182 }
183 
184 
185 
186 library SafeMath {
187     int256 constant private INT256_MIN = -2**255;
188 
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         if (a == 0) {
191             return 0;
192         }
193         uint256 c = a * b;
194         require(c / a == b);
195         return c;
196     }
197 
198     function mul(int256 a, int256 b) internal pure returns (int256) {
199         if (a == 0) {
200             return 0;
201         }
202         require(!(a == -1 && b == INT256_MIN));
203         int256 c = a * b;
204         require(c / a == b);
205         return c;
206     }
207 
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b > 0);
210         uint256 c = a / b;
211         return c;
212     }
213 
214     function div(int256 a, int256 b) internal pure returns (int256) {
215         require(b != 0);
216         require(!(b == -1 && a == INT256_MIN)); 
217         int256 c = a / b;
218         return c;
219     }
220 
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         require(b <= a);
223         uint256 c = a - b;
224         return c;
225     }
226 
227     function sub(int256 a, int256 b) internal pure returns (int256) {
228         int256 c = a - b;
229         require((b >= 0 && c <= a) || (b < 0 && c > a));
230         return c;
231     }
232 
233     function add(uint256 a, uint256 b) internal pure returns (uint256) {
234         uint256 c = a + b;
235         require(c >= a);
236         return c;
237     }
238 
239     function add(int256 a, int256 b) internal pure returns (int256) {
240         int256 c = a + b;
241         require((b >= 0 && c >= a) || (b < 0 && c < a));
242         return c;
243     }
244 
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         require(b != 0);
247         return a % b;
248     }
249 }