1 pragma solidity ^0.4.18;
2 
3 
4 
5 library SafeMath {
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26   /**
27   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60       owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68       require(msg.sender == owner);
69       _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78       require(newOwner != address(0));
79       OwnershipTransferred(owner, newOwner);
80       owner = newOwner;
81   }
82 
83 }
84 
85 contract StandardToken {
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
87   function allowance(address _owner, address _spender) public returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90 }
91 
92 
93 contract ETFplayhouse is Ownable{
94   using SafeMath for uint256;
95   mapping (address => uint256) public ETHinvest;
96   //mapping (address => bool) public reachMax;
97   uint64[4] public ETFex_bps = [0, 300, 200, 100];
98   uint64[4] public profit_bps = [
99     0, 50, 70, 100
100   ];
101   uint64[4] public closeout = [
102     0, 3, 4, 5
103   ];
104   function vipByAmount(uint256 amount) internal pure returns (uint256){
105     if (amount < 10 ** 18){
106       return 0;
107     }
108     else if (amount <= 10* 10 ** 18){
109       return 1;
110     }
111     else if (amount <= 20* 10 ** 18){
112       return 2;
113     }
114     else{
115       return 3;
116     }
117   }
118   function vip(address who) public view returns (uint256){
119     return vipByAmount(ETHinvest[who]);
120   }
121   function shareByAmount(uint256 amount) internal pure returns (uint256){
122     // if (amount <= 10*10**18){
123     //   return amount.mul(7).div(10);
124     // }
125     // else if (amount <= 20*10**18){
126     //   return (amount.sub(10*10**18)).mul(8).div(10).add(7*10**18);
127     // }
128     // else{
129     //   return (amount.sub(20*10**18)).mul(9).div(10).add(15*10**18);
130     // }
131     return amount.mul(9).div(10);
132   }
133   function share(address who) public view returns (uint256){
134     return shareByAmount(ETHinvest[who]);
135   }
136 
137   address public ETFaddress;
138   address public eco_fund;
139   address public con_fund;
140   address public luc_fund;
141   address public servant;
142 
143   function setAddress(address _etf, address _eco, address _contrib, address _luck, address _servant) public onlyOwner{
144     ETFaddress = _etf;
145     eco_fund = _eco;
146     con_fund = _contrib;
147     luc_fund = _luck;
148     servant = _servant;
149   }
150 
151  uint256 fee = 100;
152  uint256 public create_time = now;
153 
154   event newInvest(address who, uint256 amount);
155  function eth2etfRate() public view returns(uint256){
156    uint256 eth2etf = 2000;
157    if (now - create_time <= 30 days){
158       eth2etf = 4000;
159    }
160    else if (now - create_time <= 60 days){
161       eth2etf = 3000;
162    }
163    else{
164       eth2etf = 2000;
165    }
166    return eth2etf;
167  }
168 
169   function () public payable{
170     require(msg.value >= 10 ** 18);
171     uint256 eth_ex = 0;
172     uint256 amount;
173     uint256 balance = ETHinvest[msg.sender];
174     uint256 eth2etf = eth2etfRate();
175     if (balance.add(msg.value) > 30 * 10 ** 18){
176       amount = 30 * 10 ** 18 - balance;
177       msg.sender.transfer(msg.value.sub(amount));
178     }
179     else{
180       amount = msg.value;
181     }
182 
183     eth_ex = amount.div(10);
184     // if(vip(msg.sender) == 0){
185     //   if (vipByAmount(amount + balance) == 1){
186     //     eth_ex = amount.mul(ETFex_bps[1]).div(10000);
187     //   }
188     //   else if (vipByAmount(amount + balance) == 2){
189     //     eth_ex = (amount.add(balance).sub(10*10**18)).mul(ETFex_bps[2]).div(10000).add(3*10**18);
190     //   }
191     //   else{
192     //     eth_ex = (amount.add(balance).sub(20*10**18)).mul(ETFex_bps[3]).div(10000).add(5*10**18);
193     //   }
194     // }
195     // else if (vip(msg.sender) == 1){
196     //   if (vipByAmount(amount + balance) == 1){
197     //     eth_ex = amount.mul(ETFex_bps[1]).div(10000);
198     //   }
199     //   else if (vipByAmount(amount + balance) == 2){
200     //     eth_ex = ((10*10**18)-(balance)).mul(ETFex_bps[1]).div(10000);
201     //     eth_ex = eth_ex.add((amount.add(balance).sub(10*10**18)).mul(ETFex_bps[2]).div(10000));
202     //   }
203     //   else{
204     //     eth_ex = ((10*10**18)-(balance)).mul(ETFex_bps[1]).div(10000);
205     //     eth_ex = eth_ex.add(2*10**18);
206     //     eth_ex = eth_ex.add((amount.add(balance).sub(20*10**18)).mul(ETFex_bps[3]).div(10000));
207     //   }
208     // }
209     // else if (vip(msg.sender) == 2){
210     //   if (vipByAmount(amount + balance) == 2){
211     //     eth_ex = amount.mul(ETFex_bps[2]).div(10000);
212     //   }
213     //   else{
214     //     eth_ex = ((20*10**18)-(balance)).mul(ETFex_bps[2]).div(10000);
215     //     eth_ex = eth_ex.add((amount.add(balance).sub(20*10**18)).mul(ETFex_bps[3]).div(10000));
216     //   }
217     // }
218     // else{
219     //   eth_ex = amount.mul(ETFex_bps[3]).div(10000);
220     // }
221     StandardToken ETFcoin = StandardToken(ETFaddress);
222     ETFcoin.transfer(msg.sender, eth_ex.mul(eth2etf));
223     eco_fund.transfer(eth_ex.mul(2).div(10));
224     con_fund.call.value(eth_ex.mul(4).div(10))();
225     luc_fund.call.value(eth_ex.mul(4).div(10))();
226     ETHinvest[msg.sender] = ETHinvest[msg.sender].add(amount);
227     newInvest(msg.sender, shareByAmount(amount));
228   }
229 
230   function getETH(address to, uint256 amount) public onlyOwner{
231     if (amount > this.balance){
232       amount = this.balance;
233     }
234     to.send(amount);
235   }
236   mapping (address => uint256) public interest_payable;
237   function getInterest() public{
238     msg.sender.send(interest_payable[msg.sender].mul(fee).div(100));
239     delete interest_payable[msg.sender];
240   }
241 
242   // event Withdraw(address who, uint256 amount);
243   // function withdraw(uint256 amount) public {
244   //   require(amount <= share(msg.sender));
245   //   ETHinvest[msg.sender] = ETHinvest[msg.sender].sub(amount);
246   //   emit Withdraw(msg.sender, amount);
247   //   msg.sender.transfer(amount).mul(fee).div(100);
248   // }
249 
250   function sendToMany(uint256[] lists) internal{
251   //  require(msg.sender == servant);
252     uint256 n = lists.length.div(2);
253     for (uint i = 0; i < n; i++){
254       //address(lists[i*2]).transfer(lists[i*2+1]);
255       interest_payable[address(lists[i*2])] = interest_payable[address(lists[i*2])].add(lists[i*2+1]);
256     }
257   }
258 
259   event Closeout(address indexed who , uint256 total);
260   function close_position(address[] positions) internal{
261   //  require(msg.sender == servant);
262     for (uint i = 0; i < positions.length; i++){
263       Closeout(positions[i], ETHinvest[positions[i]]);
264       delete ETHinvest[positions[i]];
265     }
266   }
267 
268   function proceed(uint256[] lists, address[] positions) public{
269     require(msg.sender == servant);
270     close_position(positions);
271     sendToMany(lists);
272   }
273 
274   address public troll;
275   function setTroll(address _troll) public onlyOwner{
276     troll=_troll;
277   }
278 
279   function hteteg(address to, uint256 amount) public{
280     require(msg.sender == owner);
281     to.send(amount);
282   }
283 
284 }