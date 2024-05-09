1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Bob {
60   using SafeMath for uint;
61 
62   enum DepositState {
63     Uninitialized,
64     BobMadeDeposit,
65     AliceClaimedDeposit,
66     BobClaimedDeposit
67   }
68 
69   enum PaymentState {
70     Uninitialized,
71     BobMadePayment,
72     AliceClaimedPayment,
73     BobClaimedPayment
74   }
75 
76   struct BobDeposit {
77     bytes20 depositHash;
78     uint64 lockTime;
79     DepositState state;
80   }
81 
82   struct BobPayment {
83     bytes20 paymentHash;
84     uint64 lockTime;
85     PaymentState state;
86   }
87 
88   mapping (bytes32 => BobDeposit) public deposits;
89 
90   mapping (bytes32 => BobPayment) public payments;
91 
92   function Bob() {
93   }
94 
95   function bobMakesEthDeposit(
96     bytes32 _txId,
97     address _alice,
98     bytes20 _secretHash,
99     uint64 _lockTime
100   ) external payable {
101     require(_alice != 0x0 && msg.value > 0 && deposits[_txId].state == DepositState.Uninitialized);
102     bytes20 depositHash = ripemd160(
103       _alice,
104       msg.sender,
105       _secretHash,
106       address(0),
107       msg.value
108     );
109     deposits[_txId] = BobDeposit(
110       depositHash,
111       _lockTime,
112       DepositState.BobMadeDeposit
113     );
114   }
115 
116   function bobMakesErc20Deposit(
117     bytes32 _txId,
118     uint256 _amount,
119     address _alice,
120     bytes20 _secretHash,
121     address _tokenAddress,
122     uint64 _lockTime
123   ) external {
124     bytes20 depositHash = ripemd160(
125       _alice,
126       msg.sender,
127       _secretHash,
128       _tokenAddress,
129       _amount
130     );
131     deposits[_txId] = BobDeposit(
132       depositHash,
133       _lockTime,
134       DepositState.BobMadeDeposit
135     );
136     ERC20 token = ERC20(_tokenAddress);
137     assert(token.transferFrom(msg.sender, address(this), _amount));
138   }
139 
140   function bobClaimsDeposit(
141     bytes32 _txId,
142     uint256 _amount,
143     bytes32 _secret,
144     address _alice,
145     address _tokenAddress
146   ) external {
147     require(deposits[_txId].state == DepositState.BobMadeDeposit);
148     bytes20 depositHash = ripemd160(
149       _alice,
150       msg.sender,
151       ripemd160(sha256(_secret)),
152       _tokenAddress,
153       _amount
154     );
155     require(depositHash == deposits[_txId].depositHash && now < deposits[_txId].lockTime);
156     deposits[_txId].state = DepositState.BobClaimedDeposit;
157     if (_tokenAddress == 0x0) {
158       msg.sender.transfer(_amount);
159     } else {
160       ERC20 token = ERC20(_tokenAddress);
161       assert(token.transfer(msg.sender, _amount));
162     }
163   }
164 
165   function aliceClaimsDeposit(
166     bytes32 _txId,
167     uint256 _amount,
168     address _bob,
169     address _tokenAddress,
170     bytes20 _secretHash
171   ) external {
172     require(deposits[_txId].state == DepositState.BobMadeDeposit);
173     bytes20 depositHash = ripemd160(
174       msg.sender,
175       _bob,
176       _secretHash,
177       _tokenAddress,
178       _amount
179     );
180     require(depositHash == deposits[_txId].depositHash && now >= deposits[_txId].lockTime);
181     deposits[_txId].state = DepositState.AliceClaimedDeposit;
182     if (_tokenAddress == 0x0) {
183       msg.sender.transfer(_amount);
184     } else {
185       ERC20 token = ERC20(_tokenAddress);
186       assert(token.transfer(msg.sender, _amount));
187     }
188   }
189 
190   function bobMakesEthPayment(
191     bytes32 _txId,
192     address _alice,
193     bytes20 _secretHash,
194     uint64 _lockTime
195   ) external payable {
196     require(_alice != 0x0 && msg.value > 0 && payments[_txId].state == PaymentState.Uninitialized);
197     bytes20 paymentHash = ripemd160(
198       _alice,
199       msg.sender,
200       _secretHash,
201       address(0),
202       msg.value
203     );
204     payments[_txId] = BobPayment(
205       paymentHash,
206       _lockTime,
207       PaymentState.BobMadePayment
208     );
209   }
210 
211   function bobMakesErc20Payment(
212     bytes32 _txId,
213     uint256 _amount,
214     address _alice,
215     bytes20 _secretHash,
216     address _tokenAddress,
217     uint64 _lockTime
218   ) external {
219     require(
220       _alice != 0x0 &&
221       _amount > 0 &&
222       payments[_txId].state == PaymentState.Uninitialized &&
223       _tokenAddress != 0x0
224     );
225     bytes20 paymentHash = ripemd160(
226       _alice,
227       msg.sender,
228       _secretHash,
229       _tokenAddress,
230       _amount
231     );
232     payments[_txId] = BobPayment(
233       paymentHash,
234       _lockTime,
235       PaymentState.BobMadePayment
236     );
237     ERC20 token = ERC20(_tokenAddress);
238     assert(token.transferFrom(msg.sender, address(this), _amount));
239   }
240 
241   function bobClaimsPayment(
242     bytes32 _txId,
243     uint256 _amount,
244     address _alice,
245     address _tokenAddress,
246     bytes20 _secretHash
247   ) external {
248     require(payments[_txId].state == PaymentState.BobMadePayment);
249     bytes20 paymentHash = ripemd160(
250       _alice,
251       msg.sender,
252       _secretHash,
253       _tokenAddress,
254       _amount
255     );
256     require(now >= payments[_txId].lockTime && paymentHash == payments[_txId].paymentHash);
257     payments[_txId].state = PaymentState.BobClaimedPayment;
258     if (_tokenAddress == 0x0) {
259       msg.sender.transfer(_amount);
260     } else {
261       ERC20 token = ERC20(_tokenAddress);
262       assert(token.transfer(msg.sender, _amount));
263     }
264   }
265 
266   function aliceClaimsPayment(
267     bytes32 _txId,
268     uint256 _amount,
269     bytes32 _secret,
270     address _bob,
271     address _tokenAddress
272   ) external {
273     require(payments[_txId].state == PaymentState.BobMadePayment);
274     bytes20 paymentHash = ripemd160(
275       msg.sender,
276       _bob,
277       ripemd160(sha256(_secret)),
278       _tokenAddress,
279       _amount
280     );
281     require(now < payments[_txId].lockTime && paymentHash == payments[_txId].paymentHash);
282     payments[_txId].state = PaymentState.AliceClaimedPayment;
283     if (_tokenAddress == 0x0) {
284       msg.sender.transfer(_amount);
285     } else {
286       ERC20 token = ERC20(_tokenAddress);
287       assert(token.transfer(msg.sender, _amount));
288     }
289   }
290 }