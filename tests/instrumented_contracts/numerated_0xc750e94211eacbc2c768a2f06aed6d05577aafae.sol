1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   // events
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   // public functions
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address addr) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11 }
12 
13 contract BasicToken is ERC20Basic {
14   using SafeMath for uint256;
15 
16       // public variables
17                      string public name;
18   string public symbol;
19   uint8 public decimals = 18;
20 
21   // internal variables
22   uint256 _totalSupply;
23   mapping(address => uint256) _balances;
24   mapping(address => uint256) _freezeOf;
25 
26   // events
27 
28   // public functions
29   function totalSupply() public view returns (uint256) {
30     return _totalSupply;
31   }
32 
33   function balanceOf(address addr) public view returns (uint256 balance) {
34     return _balances[addr];
35   }
36 
37   function transfer(address to, uint256 value) public returns (bool) {
38     require(to != address(0));
39     require(value <= _balances[msg.sender]);
40 
41     _balances[msg.sender] = _balances[msg.sender].sub(value);
42     _balances[to] = _balances[to].add(value);
43     emit Transfer(msg.sender, to, value);
44     return true;
45   }
46 
47   // internal functions
48 }
49 
50 contract ERC20 is ERC20Basic {
51   // events
52   event Approval(address indexed owner, address indexed agent, uint256 value);
53 
54   // public functions
55   function allowance(address owner, address agent) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address agent, uint256 value) public returns (bool);
58 
59 }
60 
61 contract Ownable {
62 
63   // public variables
64   address public owner;
65 
66   // internal variables
67 
68   // events
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71   // public functions
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87   // internal functions
88 }
89 
90 contract StandardToken is ERC20, BasicToken {
91   // public variables
92 
93   // internal variables
94   mapping (address => mapping (address => uint256)) _allowances;
95 
96   // events
97 
98   // public functions
99   function transferFrom(address from, address to, uint256 value) public returns (bool) {
100     require(to != address(0));
101     require(value <= _balances[from]);
102     require(value <= _allowances[from][msg.sender]);
103 
104     _balances[from] = _balances[from].sub(value);
105     _balances[to] = _balances[to].add(value);
106     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
107     emit Transfer(from, to, value);
108     return true;
109   }
110 
111   function approve(address agent, uint256 value) public returns (bool) {
112     _allowances[msg.sender][agent] = value;
113     emit Approval(msg.sender, agent, value);
114     return true;
115   }
116 
117   function allowance(address owner, address agent) public view returns (uint256) {
118     return _allowances[owner][agent];
119   }
120 
121   function increaseApproval(address agent, uint value) public returns (bool) {
122     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
123     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
124     return true;
125   }
126 
127   function decreaseApproval(address agent, uint value) public returns (bool) {
128     uint allowanceValue = _allowances[msg.sender][agent];
129     if (value > allowanceValue) {
130       _allowances[msg.sender][agent] = 0;
131     } else {
132       _allowances[msg.sender][agent] = allowanceValue.sub(value);
133     }
134     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
135     return true;
136   }
137 
138   // internal functions
139 }
140 
141 contract Vnk is StandardToken{
142   // public variables
143   address public manager;
144   string public name = "vietnam digital ecology";
145   string public symbol = "VNK";
146   uint8 public decimals = 8;
147 
148   address[] public invs;
149   uint lastReleased = 0;
150 
151   uint256 public releaseTime = 1548508570; // 2019.1.27
152   uint256 public rate = 100; // ¶Ò»»±ÈÀý
153 
154 
155   event Freeze(address indexed from, uint256 value);
156 
157   /* This notifies clients about the amount unfrozen */
158   event Unfreeze(address indexed from, uint256 value);
159 
160   function() public payable
161   {
162 
163   }
164 
165   constructor() public {
166     _totalSupply = 600000000 * (10 ** uint256(decimals));
167 
168     _balances[msg.sender] = _totalSupply;
169     manager = msg.sender;
170     emit Transfer(0x0, msg.sender, _totalSupply);
171   }
172 
173   modifier onlyManager(){//Ö»ÄÜ¹ÜÀíÔ±²Ù×÷
174     require(msg.sender == manager);
175     _;
176   }
177 
178   function releaseByNum(uint256 num) public onlyManager() returns (bool){//num µÚnum´ÎÊÍ·Å
179     require(num >= 1);
180     require(num <= 12);
181     require(num == (lastReleased.add(1)));
182     //require(now > (releaseTime.add(num.mul(1)) ));//30ÌìÎªÒ»¸öÔÂ todo test
183     require(now > (releaseTime.add(num.mul(2592000)) ));//30ÌìÎªÒ»¸öÔÂ
184 
185 
186     for(uint i = 0; i < invs.length; i++)
187     {
188       uint256 releaseNum = _freezeOf[invs[i]].div( 13 - num );
189       _freezeOf[invs[i]] = _freezeOf[invs[i]].sub(releaseNum);
190       _balances[invs[i]] = _balances[invs[i]].add(releaseNum);
191       emit Freeze(invs[i], releaseNum);
192     }
193     lastReleased = lastReleased.add(1);
194 
195   }
196 
197   function releaseByInv(address inv, uint256 num) public onlyManager() returns (bool){//num ÊÍ·Å»õ±ÒÊý
198     require(num >= 1);
199     _freezeOf[inv] = _freezeOf[inv].sub(num);
200     _balances[inv] = _balances[inv].add(num);
201     emit Freeze(inv, num);
202   }
203 
204   //ÊÍ·ÅÊ±¼äÊÇ·ñµ½´ï
205   function checkTime(uint256 num) public view returns (bool){
206     //return now > (releaseTime.add(num.mul(1))); //todo test 1535702756
207     return now > (releaseTime.add(num.mul(2592000)));
208   }
209 
210   function sendToInv(address inv, uint256 eth) public onlyManager() returns (bool){// Ê×´Î·¢¸øÍ¶×ÊÈË
211     uint256 give = eth.mul(rate);
212     uint256 firstRealease = give.mul(20).div(100);
213     _freezeOf[inv] = give.sub(firstRealease);
214     _balances[inv] = firstRealease;
215     invs.push(inv);
216   }
217 
218   function getAllInv() public view onlyManager() returns (address[]){
219     return invs;
220   }
221 
222   function getLastReleased() public view onlyManager() returns (uint256){
223     return lastReleased;
224   }
225 
226   function setRate(uint256 _rate) public onlyManager() returns (bool){
227     rate = _rate;
228   }
229 
230   function setReleaseTime(uint256 _releaseTime) public onlyManager() returns (bool){
231     releaseTime = _releaseTime;
232   }
233 
234 
235 
236   function getRate() public view returns (uint256){
237     return rate;
238   }
239 
240 }
241 
242 library SafeMath {
243   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244     if (a == 0) {
245       return 0;
246     }
247     uint256 c = a * b;
248     assert(c / a == b);
249     return c;
250   }
251 
252   function div(uint256 a, uint256 b) internal pure returns (uint256) {
253     // assert(b > 0); // Solidity automatically throws when dividing by 0
254     uint256 c = a / b;
255     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
256     return c;
257   }
258 
259   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260     assert(b <= a);
261     return a - b;
262   }
263 
264   function add(uint256 a, uint256 b) internal pure returns (uint256) {
265     uint256 c = a + b;
266     assert(c >= a);
267     return c;
268   }
269 }