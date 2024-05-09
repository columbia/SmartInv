1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11    modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   /**
17    * @dev Allows the current owner to transfer control of the contract to a newOwner.
18    * @param newOwner The address to transfer ownership to.
19    */
20   function transferOwnership(address newOwner) public onlyOwner {
21     require(newOwner != address(0));
22     emit OwnershipTransferred(owner, newOwner);
23     owner = newOwner;
24   }
25 
26 }
27 
28 library SafeMath {
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39    function div(uint256 a, uint256 b) internal pure returns (uint256) {
40        uint256 c = a / b;
41         return c;
42   }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 contract BasicToken is ERC20Basic {
64   
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68   uint256 totalSupply_;
69 
70   /**
71   * @dev total number of tokens in existence
72   */
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 }
97 
98 contract NDUXBase is BasicToken, Ownable {
99 
100   string public constant name = "NODUX";
101   string public constant symbol = "NDUX";
102   uint constant maxTotalSupply = 75000000;
103   
104   function NDUXBase() public {
105     mint(this, maxTotalSupply);
106   }
107 
108   function mint(address to, uint amount) internal returns(bool) {
109     require(to != address(0) && amount > 0);
110     totalSupply_ = totalSupply_.add(amount);
111     balances[to] = balances[to].add(amount);
112     emit Transfer(address(0), to, amount);
113     return true;
114   }
115   
116   function send(address to, uint amount) public onlyOwner returns(bool) {
117     require(to != address(0));
118     require(amount <= balances[this]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[this] = balances[this].sub(amount);
122     balances[to] = balances[to].add(amount);
123     emit Transfer(this, to, amount);
124   }
125 
126   function burn(address from, uint amount) public onlyOwner returns(bool) {
127     require(from != address(0) && amount > 0);
128     balances[from] = balances[from].sub(amount);
129     totalSupply_ = totalSupply_.sub(amount);
130     emit Transfer(from, address(0), amount);
131     return true;
132   }
133 
134 }
135 
136 contract TxFeatures is BasicToken {
137 
138   struct Tx {
139     uint timestamp;
140     uint amount;
141   }
142 
143   mapping(address => Tx[]) public txs;
144 
145   event NewTx(address user, uint timestamp, uint amount);
146 
147   function pushtx(address user, uint amount) internal {
148     emit NewTx(user, now, amount);
149     txs[user].push(Tx(now, amount));
150   }
151 
152   function poptxs(address user, uint amount) internal {
153     require(balanceOf(user) >= amount);
154     Tx[] storage usertxs = txs[user];
155 
156     for(Tx storage curtx = usertxs[usertxs.length - 1]; usertxs.length != 0;) {
157 
158       if(curtx.amount > amount) {
159         curtx.amount -= amount;
160         amount = 0;
161       } else {
162         amount -= curtx.amount;
163         delete usertxs[usertxs.length - 1];
164         --usertxs.length;
165       }
166       if(amount == 0) break;
167     }
168 
169     require(amount == 0);
170 
171   }
172 }
173 
174 contract NDUXB is NDUXBase, TxFeatures {
175    
176      function calculateTokensEnabledOne(address user, uint minAge) public view onlyOwner returns(uint amount) {
177     Tx[] storage usertxs = txs[user];
178     for(uint it = 0; it < usertxs.length; ++it) {
179       Tx storage curtx = usertxs[it];
180       uint diff = now - curtx.timestamp;
181       if(diff >= minAge) {
182         amount += curtx.amount;
183       }
184     }
185     return amount;
186   }
187 
188   event SendMiningProfit(address user, uint tokens, uint ethers);
189 
190   function sendMiningProfit(address[] users, uint minAge) public payable onlyOwner returns(uint) {
191     require(users.length > 0);
192     uint total = 0;
193 
194     uint[] memory __balances = new uint[](users.length);
195 
196     for(uint it = 0; it < users.length; ++it) {
197       address user = users[it];
198       uint balance = calculateTokensEnabledOne(user, minAge);
199       __balances[it] = balance;
200       total += balance;
201     }
202 
203     if(total == 0) return 0;
204 
205     uint ethersPerToken = msg.value / total;
206 
207     for(it = 0; it < users.length; ++it) {
208       user = users[it];
209       balance = __balances[it];
210       uint ethers = balance * ethersPerToken;
211       if(balance > 0)
212         user.transfer(balance * ethersPerToken);
213       emit SendMiningProfit(user, balance, ethers);
214     }
215     return ethersPerToken;
216   }
217 
218   function calculateTokensEnabledforAirdrop(address[] users,uint minAge) public view onlyOwner returns(uint total) {
219     for(uint it = 0; it < users.length; ++it) {
220       total += calculateTokensEnabledOne(users[it], minAge);
221     }
222   }
223 
224   function airdrop(address[] users, uint minAge, uint percent, uint maxToSend) public onlyOwner returns(uint) {
225     require(users.length > 0);
226     require(balanceOf(msg.sender) >= maxToSend);
227     require(percent > 0 && percent < 10);
228 
229     uint total = 0;
230 
231     for(uint it = 0; it < users.length; ++it) {
232       address user = users[it];
233       uint balance = calculateTokensEnabledOne(user, minAge);
234       if(balance > 0) {
235         uint toSend = balance.mul(percent).div(100);
236         total += toSend;
237         transfer(user, balance.mul(percent).div(100));
238         require(total <= maxToSend);
239       }
240     }
241 
242     return total;
243   }
244 
245   function send(address to, uint amount) public onlyOwner returns(bool) {
246     super.send(to, amount);
247     pushtx(to, amount);
248   }
249 
250   function burn(address from, uint amount) public onlyOwner returns(bool) {
251     poptxs(from, amount);
252     return super.burn(from, amount);
253   }
254 
255   function transfer(address _to, uint256 _value) public returns (bool) {
256     poptxs(msg.sender, _value);
257     pushtx(_to, _value);
258     super.transfer(_to, _value);
259   }
260   
261   function () payable public {  }
262   
263   function sendAllLocalEthers(address to) public onlyOwner {
264     to.transfer(address(this).balance);
265   }
266   
267 }