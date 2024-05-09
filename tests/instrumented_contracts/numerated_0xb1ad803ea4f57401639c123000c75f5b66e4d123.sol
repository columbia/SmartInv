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
78     DepositState state;
79   }
80 
81   struct BobPayment {
82     bytes20 paymentHash;
83     PaymentState state;
84   }
85 
86   uint public blocksPerDeal;
87 
88   mapping (bytes32 => BobDeposit) public deposits;
89 
90   mapping (bytes32 => BobPayment) public payments;
91 
92   function Bob(uint _blocksPerDeal) {
93     require(_blocksPerDeal > 0);
94     blocksPerDeal = _blocksPerDeal;
95   }
96 
97   function bobMakesEthDeposit(
98     bytes32 _txId,
99     address _alice,
100     bytes20 _secretHash
101   ) external payable {
102     require(_alice != 0x0 && msg.value > 0 && deposits[_txId].state == DepositState.Uninitialized);
103     bytes20 depositHash = ripemd160(
104       _alice,
105       msg.sender,
106       _secretHash,
107       address(0),
108       msg.value,
109       block.number.add(blocksPerDeal.mul(2))
110     );
111     deposits[_txId] = BobDeposit(
112       depositHash,
113       DepositState.BobMadeDeposit
114     );
115   }
116 
117   function bobMakesErc20Deposit(
118     bytes32 _txId,
119     uint _amount,
120     address _alice,
121     bytes20 _secretHash,
122     address _tokenAddress
123   ) external {
124     bytes20 depositHash = ripemd160(
125       _alice,
126       msg.sender,
127       _secretHash,
128       _tokenAddress,
129       _amount,
130       block.number.add(blocksPerDeal.mul(2))
131     );
132     deposits[_txId] = BobDeposit(
133       depositHash,
134       DepositState.BobMadeDeposit
135     );
136     ERC20 token = ERC20(_tokenAddress);
137     assert(token.transferFrom(msg.sender, address(this), _amount));
138   }
139 
140   function bobClaimsDeposit(
141     bytes32 _txId,
142     uint _amount,
143     uint _aliceCanClaimAfter,
144     address _alice,
145     address _tokenAddress,
146     bytes _secret
147   ) external {
148     require(deposits[_txId].state == DepositState.BobMadeDeposit);
149     bytes20 depositHash = ripemd160(
150       _alice,
151       msg.sender,
152       ripemd160(sha256(_secret)),
153       _tokenAddress,
154       _amount,
155       _aliceCanClaimAfter
156     );
157     require(depositHash == deposits[_txId].depositHash && block.number < _aliceCanClaimAfter);
158     deposits[_txId].state = DepositState.BobClaimedDeposit;
159     if (_tokenAddress == 0x0) {
160       msg.sender.transfer(_amount);
161     } else {
162       ERC20 token = ERC20(_tokenAddress);
163       assert(token.transfer(msg.sender, _amount));
164     }
165   }
166 
167   function aliceClaimsDeposit(
168     bytes32 _txId,
169     uint _amount,
170     uint _aliceCanClaimAfter,
171     address _bob,
172     address _tokenAddress,
173     bytes20 _secretHash
174   ) external {
175     require(deposits[_txId].state == DepositState.BobMadeDeposit);
176     bytes20 depositHash = ripemd160(
177       msg.sender,
178       _bob,
179       _secretHash,
180       _tokenAddress,
181       _amount,
182       _aliceCanClaimAfter
183     );
184     require(depositHash == deposits[_txId].depositHash && block.number >= _aliceCanClaimAfter);
185     deposits[_txId].state = DepositState.AliceClaimedDeposit;
186     if (_tokenAddress == 0x0) {
187       msg.sender.transfer(_amount);
188     } else {
189       ERC20 token = ERC20(_tokenAddress);
190       assert(token.transfer(msg.sender, _amount));
191     }
192   }
193 
194   function bobMakesEthPayment(
195     bytes32 _txId,
196     address _alice,
197     bytes20 _secretHash
198   ) external payable {
199     require(_alice != 0x0 && msg.value > 0 && payments[_txId].state == PaymentState.Uninitialized);
200     bytes20 paymentHash = ripemd160(
201       _alice,
202       msg.sender,
203       _secretHash,
204       address(0),
205       msg.value,
206       block.number.add(blocksPerDeal)
207     );
208     payments[_txId] = BobPayment(
209       paymentHash,
210       PaymentState.BobMadePayment
211     );
212   }
213 
214   function bobMakesErc20Payment(
215     bytes32 _txId,
216     uint _amount,
217     address _alice,
218     bytes20 _secretHash,
219     address _tokenAddress
220   ) external {
221     require(
222       _alice != 0x0 &&
223       _amount > 0 &&
224       payments[_txId].state == PaymentState.Uninitialized &&
225       _tokenAddress != 0x0
226     );
227     bytes20 paymentHash = ripemd160(
228       _alice,
229       msg.sender,
230       _secretHash,
231       _tokenAddress,
232       _amount,
233       block.number.add(blocksPerDeal)
234     );
235     payments[_txId] = BobPayment(
236       paymentHash,
237       PaymentState.BobMadePayment
238     );
239     ERC20 token = ERC20(_tokenAddress);
240     assert(token.transferFrom(msg.sender, address(this), _amount));
241   }
242 
243   function bobClaimsPayment(
244     bytes32 _txId,
245     uint _amount,
246     uint _bobCanClaimAfter,
247     address _alice,
248     address _tokenAddress,
249     bytes20 _secretHash
250   ) external {
251     require(payments[_txId].state == PaymentState.BobMadePayment);
252     bytes20 paymentHash = ripemd160(
253       _alice,
254       msg.sender,
255       _secretHash,
256       _tokenAddress,
257       _amount,
258       _bobCanClaimAfter
259     );
260     require(block.number >= _bobCanClaimAfter && paymentHash == payments[_txId].paymentHash);
261     payments[_txId].state = PaymentState.BobClaimedPayment;
262     if (_tokenAddress == 0x0) {
263       msg.sender.transfer(_amount);
264     } else {
265       ERC20 token = ERC20(_tokenAddress);
266       assert(token.transfer(msg.sender, _amount));
267     }
268   }
269 
270   function aliceClaimsPayment(
271     bytes32 _txId,
272     uint _amount,
273     uint _bobCanClaimAfter,
274     address _bob,
275     address _tokenAddress,
276     bytes _secret
277   ) external {
278     require(payments[_txId].state == PaymentState.BobMadePayment);
279     bytes20 paymentHash = ripemd160(
280       msg.sender,
281       _bob,
282       ripemd160(sha256(_secret)),
283       _tokenAddress,
284       _amount,
285       _bobCanClaimAfter
286     );
287     require(block.number < _bobCanClaimAfter && paymentHash == payments[_txId].paymentHash);
288     payments[_txId].state = PaymentState.AliceClaimedPayment;
289     if (_tokenAddress == 0x0) {
290       msg.sender.transfer(_amount);
291     } else {
292       ERC20 token = ERC20(_tokenAddress);
293       assert(token.transfer(msg.sender, _amount));
294     }
295   }
296 }