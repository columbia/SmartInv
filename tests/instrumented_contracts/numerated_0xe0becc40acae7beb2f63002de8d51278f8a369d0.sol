1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65       owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73       require(msg.sender == owner);
74       _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83       require(newOwner != address(0));
84       OwnershipTransferred(owner, newOwner);
85       owner = newOwner;
86   }
87 
88 }
89 contract StandardToken {
90   function transfer(address to, uint256 value) public returns (bool);
91   function allowance(address _owner, address _spender) public view returns (uint256);
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
93 }
94 
95 contract ETFloft is Ownable{
96   using SafeMath for uint256;
97   mapping (address => uint256) public reward_payable;
98   mapping (address => uint256) public reward_payable_ETF;
99 
100   address public servant;
101   address public ETFaddress;
102   address public eco_fund;
103   address public collector;
104 
105   function setAddress(address _etf,address _servant, address _ecofund, address _collector) public onlyOwner{
106     servant = _servant;
107     ETFaddress = _etf;
108     eco_fund = _ecofund;
109     collector = _collector;
110   }
111 
112 
113    function getReward() public{
114     msg.sender.transfer(reward_payable[msg.sender]);
115     delete reward_payable[msg.sender];
116   }
117    function getRewardETF() public{
118       StandardToken ETFcoin = StandardToken(ETFaddress);
119       ETFcoin.transfer(msg.sender, reward_payable_ETF[msg.sender]);
120       delete reward_payable_ETF[msg.sender];
121     }
122 
123 
124   struct loft{
125     uint32 number;
126     address owner;
127   }
128   loft[] public lofts;
129   function inResults(uint32 n, uint32 result) public pure returns(uint){
130        uint32 r;
131     if (result != 0){
132           r = n & result;
133     }
134     else{
135          r = n;
136     }
137    uint a;
138     for(uint i;i<32;i++){
139       if( (r & (uint32(1)<< i)  >0 )  ){
140         a += 1;
141       }
142     }
143     return a;
144   }
145   uint256 public round;
146   event newLoft(uint32 n, address indexed owner, uint256 indexed r);
147   function buyLoft(uint256[5] numbers) public{
148     require(tx.origin ==msg.sender);
149     StandardToken ETFcoin = StandardToken(ETFaddress);
150     require(ETFcoin.allowance(msg.sender, this) >= 100*10**18);
151     require(ETFcoin.transferFrom(msg.sender, this, 100*10**18));
152     uint32 n;
153     for(uint i;i<5;i++){
154       n+= (uint32(1) << (numbers[i]-1));
155     }
156     require(inResults(n,0) == 5);
157     lofts.push(loft(n, msg.sender));
158     newLoft(n, msg.sender, round);
159   }
160   function test() public{
161     balance += 100 *10**18;
162   }
163   uint256 public balance;
164 
165   event LoftResult(uint32 n, uint256 round);
166   function openLoft(uint256 seed) public{
167     require(msg.sender == servant);
168     uint32 n;
169     uint32 j;
170     uint i;
171     if(seed == 0){
172       for(i=0;i<5;i++){
173         j = uint32(1) << (uint256(sha256(now))%32);
174         while(inResults(n+j, 0)!= (i+1)){
175           j = uint32(1) << (uint256(sha256(now))%32);
176         }
177         n+=j;
178      }
179     }
180     else{
181       n = uint32(seed);
182     }
183     address[] winner1;
184     address[] winner2;
185     address[] winner3;
186     address[] winner4;
187     address[] winner5;
188 
189     uint256 total;
190     uint256 pay;
191     uint a;
192     StandardToken ETFcoin = StandardToken(ETFaddress);
193     LoftResult(n, round);
194     round +=1;
195     for(i=0;i<lofts.length;i++){
196       a = inResults(lofts[i].number, n);
197       if (a==1){
198         winner5.push(lofts[i].owner);
199       }
200       else if  (a==2){
201         winner4.push(lofts[i].owner);
202       }
203       else if  (a==3){
204         winner3.push(lofts[i].owner);
205       }
206       else if  (a==4){
207         winner2.push(lofts[i].owner);
208       }
209       else if  (a==5){
210         winner1.push(lofts[i].owner);
211       }
212       else{
213         1;
214       }
215     }
216     delete lofts;
217 
218 
219     total = balance.mul(50).div(100).div(2);
220     for(i=0;i<winner1.length; i++){
221       reward_payable[winner1[i]] += ( total.div(winner1.length) );
222       pay += ( total.div(winner1.length) );
223       //winner[0][i].send( total.div(winner[0].length) -1);
224     }
225     total = balance.mul(30).div(100).div(2);
226     for( i=0;i<winner2.length; i++){
227       reward_payable[winner2[i]] += ( total.div(winner2.length) );
228       pay += ( total.div(winner2.length) );
229       //winner[1][i].send( total.div(winner[1].length) -1);
230     }
231     total = balance.mul(20).div(100).div(2);
232     for( i=0;i<winner3.length; i++){
233       reward_payable[winner3[i]] += ( total.div(winner3.length) );
234       pay += ( total.div(winner3.length) );
235       //winner[2][i].send( total.div(winner[2].length) -1);
236     }
237     for( i=0;i<winner4.length; i++){
238       //reward_payable_ETF[winner4[i]] += 500 * 10 **18;
239       //ETFcoin.transfer(winner[3][i], 100 * 10 **18);
240     }
241     for( i=0;i<winner5.length; i++){
242       //reward_payable_ETF[winner5[i]] += 200 * 10 **18;
243       //ETFcoin.transfer(winner[4][i], 100 * 10 **18);
244     }
245     balance -= pay;
246   }
247 
248     address[] public winner1;
249     address[] public winner2;
250     address[] public winner3;
251     address[] public winner4;
252     address[] public winner5;
253 
254  uint256 public fee = 10;
255 
256 function openLoft2(uint256 seed) public {
257     require(msg.sender == servant);
258     uint32 n;
259     uint32 j;
260     uint i;
261     if(seed == 0){
262       for(i=0;i<5;i++){
263         j = uint32(1) << (uint256(sha256(now))%32);
264         while(inResults(n+j, 0)!= (i+1)){
265           j = uint32(1) << (uint256(sha256(now))%32);
266         }
267         n+=j;
268      }
269     }
270     else{
271       n = uint32(seed);
272     }
273 
274 
275     uint256 total;
276     uint256 pay;
277     uint256 fees;
278     uint a;
279     //StandardToken ETFcoin = StandardToken(ETFaddress);
280     LoftResult(n, round);
281     round +=1;
282     for(i=0;i<lofts.length;i++){
283       a = inResults(lofts[i].number, n);
284       if (a==1){
285         winner5.push(lofts[i].owner);
286       }
287       else if  (a==2){
288         winner4.push(lofts[i].owner);
289       }
290       else if  (a==3){
291         winner3.push(lofts[i].owner);
292       }
293       else if  (a==4){
294         winner2.push(lofts[i].owner);
295       }
296       else if  (a==5){
297         winner1.push(lofts[i].owner);
298       }
299       else{
300         1;
301       }
302     }
303     delete lofts;
304     total = balance.mul(50).div(100).div(2);
305     for(i=0;i<winner1.length; i++){
306       reward_payable[winner1[i]] += ( total.div(winner1.length) * 90 / 100);
307       pay += ( total.div(winner1.length) * 90 / 100);
308       fees +=  ( total.div(winner1.length) * 10 / 100);
309       //winner[0][i].send( total.div(winner[0].length) -1);
310     }
311     total = balance.mul(30).div(100).div(2);
312     for( i=0;i<winner2.length; i++){
313       reward_payable[winner2[i]] += ( total.div(winner2.length) * 90 / 100);
314       pay += ( total.div(winner2.length) * 90 / 100);
315       fees +=  ( total.div(winner2.length) * 10 / 100);
316       //winner[1][i].send( total.div(winner[1].length) -1);
317     }
318     total = balance.mul(20).div(100).div(2);
319     for( i=0;i<winner3.length; i++){
320       reward_payable[winner3[i]] += ( total.div(winner3.length) * 90 / 100);
321       pay += ( total.div(winner3.length) * 90 / 100);
322       fees +=  ( total.div(winner3.length) * 10 / 100);
323       //winner[2][i].send( total.div(winner[2].length) -1);
324     }
325     for( i=0;i<winner4.length; i++){
326       reward_payable_ETF[winner4[i]] += 500 * 10 **18;
327       //ETFcoin.transfer(winner[3][i], 100 * 10 **18);
328     }
329     for( i=0;i<winner5.length; i++){
330       reward_payable_ETF[winner5[i]] += 200 * 10 **18;
331       //ETFcoin.transfer(winner[4][i], 100 * 10 **18);
332     }
333     balance -= pay;
334     delete winner1;
335     delete winner2;
336 
337 delete winner3;
338 delete winner4;
339 delete winner5;
340 collector.send(fees);
341 
342   }
343   function () payable public {
344     balance += msg.value;
345     if (balance >= 100000*10**18){
346         uint256 _amount;
347       _amount = (balance - 100000*10**18) * 3 / 10;
348       eco_fund.send(_amount);
349     }
350   }
351 }