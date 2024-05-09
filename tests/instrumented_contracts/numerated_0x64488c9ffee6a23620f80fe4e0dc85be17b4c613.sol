1 pragma solidity ^0.4.25;
2 
3 /**
4   MTWE - Mineable Token With Exchange
5 */
6 
7 contract MTWE {
8     struct Order {
9         address creator;
10         bool buy;
11         uint price;
12         uint amount;
13     }
14     
15     string public name = 'MTWE';
16     string public symbol = 'MTWE';
17     uint8 public decimals = 18;
18     uint256 public totalSupply = 10000000000000000000000000;
19     
20     uint private seed;
21     
22     mapping (address => uint256) public balanceOf;
23     mapping (address => uint256) public successesOf;
24     mapping (address => uint256) public failsOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26     
27     Order[] public orders;
28     uint public orderCount;
29     
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event PlaceBuy(address indexed user, uint price, uint amount, uint id);
32     event PlaceSell(address indexed user, uint price, uint amount, uint id);
33     event FillOrder(uint indexed id, address indexed user, uint amount);
34     event CancelOrder(uint indexed id);
35     
36     /* Initializes contract with initial supply tokens to the creator of the contract */
37     constructor () public {
38         balanceOf[msg.sender] = totalSupply;
39     }
40     
41     /*** Helpers */
42     
43     /* Converts uint256 to bytes32 */
44     function toBytes(uint256 x) internal pure returns (bytes b) {
45         b = new bytes(32);
46         assembly {
47             mstore(add(b, 32), x)
48         }
49     }
50     
51     function safeAdd(uint a, uint b) private pure returns (uint) {
52         uint c = a + b;
53         assert(c >= a);
54         return c;
55     }
56     
57     function safeSub(uint a, uint b) private pure returns (uint) {
58         assert(b <= a);
59         return a - b;
60     }
61     
62     function safeMul(uint a, uint b) private pure returns (uint) {
63         if (a == 0) {
64           return 0;
65         }
66         
67         uint c = a * b;
68         assert(c / a == b);
69         return c;
70     }
71     
72     function safeIDiv(uint a, uint b) private pure returns (uint) {
73         uint c = a / b;
74         assert(b * c == a);
75         return c;
76     }
77     
78     /* Returns a pseudo-random number */
79     function random(uint lessThan) internal returns (uint) {
80         seed += block.timestamp + uint(msg.sender);
81         return uint(sha256(toBytes(uint(blockhash(block.number - 1)) + seed))) % lessThan;
82     }
83     
84     function calcAmountEther(uint price, uint amount) internal pure returns (uint) {
85         return safeIDiv(safeMul(price, amount), 1000000000000000000);
86     }
87     
88     /*** Token */
89     
90     /* Internal transfer, only can be called by this contract */
91     function _transfer(address _from, address _to, uint _value) internal {
92         require(_to != 0x0);
93         require(balanceOf[_from] >= _value);
94         require(balanceOf[_to] + _value > balanceOf[_to]);
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         balanceOf[_from] -= _value;
97         balanceOf[_to] += _value;
98         emit Transfer(_from, _to, _value);
99         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
100     }
101     
102     /* Send coins */
103     function transfer(address _to, uint256 _value) public {
104         _transfer(msg.sender, _to, _value);
105     }
106     
107     /* Transfer tokens from other address */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114     
115     /* Set allowance for other address */
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120     
121     /*** Exchange */
122     
123     function placeBuy(uint price, uint amount) external payable {
124         require(price > 0 && amount > 0 && msg.value == calcAmountEther(price, amount));
125         orders.push(Order({
126             creator: msg.sender,
127             buy: true,
128             price: price,
129             amount: amount
130         }));
131         emit PlaceBuy(msg.sender, price, amount, orderCount);
132         orderCount++;
133     }
134     
135     function placeSell(uint price, uint amount) external {
136         require(price > 0 && amount > 0);
137         _transfer(msg.sender, this, amount);
138         orders.push(Order({
139             creator: msg.sender,
140             buy: false,
141             price: price,
142             amount: amount
143         }));
144         emit PlaceSell(msg.sender, price, amount, orderCount);
145         orderCount++;
146     }
147     
148     function fillOrder(uint id, uint amount) external payable {
149         require(id < orders.length);
150         require(amount > 0);
151         require(orders[id].creator != msg.sender);
152         require(orders[id].amount >= amount);
153         if (orders[id].buy) {
154             require(msg.value == 0);
155             
156             /* send tokens from sender to creator */
157             _transfer(msg.sender, orders[id].creator, amount);
158             
159             /* send Ether to sender */
160             msg.sender.transfer(calcAmountEther(orders[id].price, amount));
161         } else {
162             uint etherAmount = calcAmountEther(orders[id].price, amount);
163             require(msg.value == etherAmount);
164             
165             /* send tokens to sender */
166             _transfer(this, msg.sender, amount);
167             
168             /* send Ether from sender to creator */
169             orders[id].creator.transfer(etherAmount);
170         }
171         if (orders[id].amount == amount) {
172             delete orders[id];
173         } else {
174             orders[id].amount -= amount;
175         }
176         emit FillOrder(id, msg.sender, amount);
177     }
178     
179     function cancelOrder(uint id) external {
180         require(id < orders.length);
181         require(orders[id].creator == msg.sender);
182         require(orders[id].amount > 0);
183         if (orders[id].buy) {
184             /* return Ether */
185             msg.sender.transfer(calcAmountEther(orders[id].price, orders[id].amount));
186         } else {
187             /* return tokens */
188             _transfer(this, msg.sender, orders[id].amount);
189         }
190         delete orders[id];
191         emit CancelOrder(id);
192     }
193     
194     function () public payable {
195         if (msg.value == 0) {
196             uint minedHashRel = random(10000);
197             uint k = balanceOf[msg.sender] * 10000 / totalSupply;
198             if (k > 0) {
199                 if (k > 19) {
200                     k = 19;
201                 }
202                 k = 2 ** k;
203                 k = 5000 / k;
204                 k = 5000 - k;
205                 if (minedHashRel < k) {
206                     uint reward = minedHashRel * 10000000000000000;
207                     balanceOf[msg.sender] += reward;
208                     totalSupply += reward;
209                     emit Transfer(0, this, reward);
210                     emit Transfer(this, msg.sender, reward);
211                     successesOf[msg.sender]++;
212                 } else {
213                     emit Transfer(this, msg.sender, 0);
214                     failsOf[msg.sender]++;
215                 }
216             } else {
217                 revert();
218             }
219         } else {
220             revert();
221         }
222     }
223 }