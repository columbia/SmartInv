1 pragma solidity ^0.4.18;
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 pragma solidity ^0.4.18;
55 
56 pragma solidity ^0.4.18;
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * See https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address _who) public view returns (uint256);
67   function transfer(address _to, uint256 _value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transferFrom(address _from, address _to, uint256 _value)
81     public returns (bool);
82 
83   function approve(address _spender, uint256 _value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 contract Bob {
92   using SafeMath for uint;
93 
94   enum DepositState {
95     Uninitialized,
96     BobMadeDeposit,
97     AliceClaimedDeposit,
98     BobClaimedDeposit
99   }
100 
101   enum PaymentState {
102     Uninitialized,
103     BobMadePayment,
104     AliceClaimedPayment,
105     BobClaimedPayment
106   }
107 
108   struct BobDeposit {
109     bytes20 depositHash;
110     uint64 lockTime;
111     DepositState state;
112   }
113 
114   struct BobPayment {
115     bytes20 paymentHash;
116     uint64 lockTime;
117     PaymentState state;
118   }
119 
120   mapping (bytes32 => BobDeposit) public deposits;
121 
122   mapping (bytes32 => BobPayment) public payments;
123 
124   function Bob() public {
125   }
126 
127   function bobMakesEthDeposit(
128     bytes32 _txId,
129     address _alice,
130     bytes20 _secretHash,
131     uint64 _lockTime
132   ) external payable {
133     require(_alice != 0x0 && msg.value > 0 && deposits[_txId].state == DepositState.Uninitialized);
134     bytes20 depositHash = ripemd160(
135       _alice,
136       msg.sender,
137       _secretHash,
138       address(0),
139       msg.value
140     );
141     deposits[_txId] = BobDeposit(
142       depositHash,
143       _lockTime,
144       DepositState.BobMadeDeposit
145     );
146   }
147 
148   function bobMakesErc20Deposit(
149     bytes32 _txId,
150     uint256 _amount,
151     address _alice,
152     bytes20 _secretHash,
153     address _tokenAddress,
154     uint64 _lockTime
155   ) external {
156     bytes20 depositHash = ripemd160(
157       _alice,
158       msg.sender,
159       _secretHash,
160       _tokenAddress,
161       _amount
162     );
163     deposits[_txId] = BobDeposit(
164       depositHash,
165       _lockTime,
166       DepositState.BobMadeDeposit
167     );
168     ERC20 token = ERC20(_tokenAddress);
169     assert(token.transferFrom(msg.sender, address(this), _amount));
170   }
171 
172   function bobClaimsDeposit(
173     bytes32 _txId,
174     uint256 _amount,
175     bytes32 _secret,
176     address _alice,
177     address _tokenAddress
178   ) external {
179     require(deposits[_txId].state == DepositState.BobMadeDeposit);
180     bytes20 depositHash = ripemd160(
181       _alice,
182       msg.sender,
183       ripemd160(sha256(_secret)),
184       _tokenAddress,
185       _amount
186     );
187     require(depositHash == deposits[_txId].depositHash && now < deposits[_txId].lockTime);
188     deposits[_txId].state = DepositState.BobClaimedDeposit;
189     if (_tokenAddress == 0x0) {
190       msg.sender.transfer(_amount);
191     } else {
192       ERC20 token = ERC20(_tokenAddress);
193       assert(token.transfer(msg.sender, _amount));
194     }
195   }
196 
197   function aliceClaimsDeposit(
198     bytes32 _txId,
199     uint256 _amount,
200     address _bob,
201     address _tokenAddress,
202     bytes20 _secretHash
203   ) external {
204     require(deposits[_txId].state == DepositState.BobMadeDeposit);
205     bytes20 depositHash = ripemd160(
206       msg.sender,
207       _bob,
208       _secretHash,
209       _tokenAddress,
210       _amount
211     );
212     require(depositHash == deposits[_txId].depositHash && now >= deposits[_txId].lockTime);
213     deposits[_txId].state = DepositState.AliceClaimedDeposit;
214     if (_tokenAddress == 0x0) {
215       msg.sender.transfer(_amount);
216     } else {
217       ERC20 token = ERC20(_tokenAddress);
218       assert(token.transfer(msg.sender, _amount));
219     }
220   }
221 
222   function bobMakesEthPayment(
223     bytes32 _txId,
224     address _alice,
225     bytes20 _secretHash,
226     uint64 _lockTime
227   ) external payable {
228     require(_alice != 0x0 && msg.value > 0 && payments[_txId].state == PaymentState.Uninitialized);
229     bytes20 paymentHash = ripemd160(
230       _alice,
231       msg.sender,
232       _secretHash,
233       address(0),
234       msg.value
235     );
236     payments[_txId] = BobPayment(
237       paymentHash,
238       _lockTime,
239       PaymentState.BobMadePayment
240     );
241   }
242 
243   function bobMakesErc20Payment(
244     bytes32 _txId,
245     uint256 _amount,
246     address _alice,
247     bytes20 _secretHash,
248     address _tokenAddress,
249     uint64 _lockTime
250   ) external {
251     require(
252       _alice != 0x0 &&
253       _amount > 0 &&
254       payments[_txId].state == PaymentState.Uninitialized &&
255       _tokenAddress != 0x0
256     );
257     bytes20 paymentHash = ripemd160(
258       _alice,
259       msg.sender,
260       _secretHash,
261       _tokenAddress,
262       _amount
263     );
264     payments[_txId] = BobPayment(
265       paymentHash,
266       _lockTime,
267       PaymentState.BobMadePayment
268     );
269     ERC20 token = ERC20(_tokenAddress);
270     assert(token.transferFrom(msg.sender, address(this), _amount));
271   }
272 
273   function bobClaimsPayment(
274     bytes32 _txId,
275     uint256 _amount,
276     address _alice,
277     address _tokenAddress,
278     bytes20 _secretHash
279   ) external {
280     require(payments[_txId].state == PaymentState.BobMadePayment);
281     bytes20 paymentHash = ripemd160(
282       _alice,
283       msg.sender,
284       _secretHash,
285       _tokenAddress,
286       _amount
287     );
288     require(now >= payments[_txId].lockTime && paymentHash == payments[_txId].paymentHash);
289     payments[_txId].state = PaymentState.BobClaimedPayment;
290     if (_tokenAddress == 0x0) {
291       msg.sender.transfer(_amount);
292     } else {
293       ERC20 token = ERC20(_tokenAddress);
294       assert(token.transfer(msg.sender, _amount));
295     }
296   }
297 
298   function aliceClaimsPayment(
299     bytes32 _txId,
300     uint256 _amount,
301     bytes32 _secret,
302     address _bob,
303     address _tokenAddress
304   ) external {
305     require(payments[_txId].state == PaymentState.BobMadePayment);
306     bytes20 paymentHash = ripemd160(
307       msg.sender,
308       _bob,
309       ripemd160(sha256(_secret)),
310       _tokenAddress,
311       _amount
312     );
313     require(now < payments[_txId].lockTime && paymentHash == payments[_txId].paymentHash);
314     payments[_txId].state = PaymentState.AliceClaimedPayment;
315     if (_tokenAddress == 0x0) {
316       msg.sender.transfer(_amount);
317     } else {
318       ERC20 token = ERC20(_tokenAddress);
319       assert(token.transfer(msg.sender, _amount));
320     }
321   }
322 }