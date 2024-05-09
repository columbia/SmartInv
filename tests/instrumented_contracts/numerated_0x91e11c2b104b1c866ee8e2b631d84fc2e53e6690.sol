1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address _who) public view returns (uint256);
62   function transfer(address _to, uint256 _value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address _owner, address _spender)
72     public view returns (uint256);
73 
74   function transferFrom(address _from, address _to, uint256 _value)
75     public returns (bool);
76 
77   function approve(address _spender, uint256 _value) public returns (bool);
78   event Approval(
79     address indexed owner,
80     address indexed spender,
81     uint256 value
82   );
83 }
84 
85 contract Bob {
86   using SafeMath for uint;
87 
88   enum DepositState {
89     Uninitialized,
90     BobMadeDeposit,
91     AliceClaimedDeposit,
92     BobClaimedDeposit
93   }
94 
95   enum PaymentState {
96     Uninitialized,
97     BobMadePayment,
98     AliceClaimedPayment,
99     BobClaimedPayment
100   }
101 
102   struct BobDeposit {
103     bytes20 depositHash;
104     uint64 lockTime;
105     DepositState state;
106   }
107 
108   struct BobPayment {
109     bytes20 paymentHash;
110     uint64 lockTime;
111     PaymentState state;
112   }
113 
114   mapping (bytes32 => BobDeposit) public deposits;
115 
116   mapping (bytes32 => BobPayment) public payments;
117 
118   constructor() public { }
119 
120   function bobMakesEthDeposit(
121     bytes32 _txId,
122     address _alice,
123     bytes20 _bobHash,
124     bytes20 _aliceHash,
125     uint64 _lockTime
126   ) external payable {
127     require(_alice != 0x0 && msg.value > 0 && deposits[_txId].state == DepositState.Uninitialized);
128     bytes20 depositHash = ripemd160(abi.encodePacked(
129       _alice,
130       msg.sender,
131       _bobHash,
132       _aliceHash,
133       address(0),
134       msg.value
135     ));
136     deposits[_txId] = BobDeposit(
137       depositHash,
138       _lockTime,
139       DepositState.BobMadeDeposit
140     );
141   }
142 
143   function bobMakesErc20Deposit(
144     bytes32 _txId,
145     uint256 _amount,
146     address _alice,
147     bytes20 _bobHash,
148     bytes20 _aliceHash,
149     address _tokenAddress,
150     uint64 _lockTime
151   ) external {
152     bytes20 depositHash = ripemd160(abi.encodePacked(
153       _alice,
154       msg.sender,
155       _bobHash,
156       _aliceHash,
157       _tokenAddress,
158       _amount
159     ));
160     deposits[_txId] = BobDeposit(
161       depositHash,
162       _lockTime,
163       DepositState.BobMadeDeposit
164     );
165     ERC20 token = ERC20(_tokenAddress);
166     assert(token.transferFrom(msg.sender, address(this), _amount));
167   }
168 
169   function bobClaimsDeposit(
170     bytes32 _txId,
171     uint256 _amount,
172     bytes32 _bobSecret,
173     bytes20 _aliceHash,
174     address _alice,
175     address _tokenAddress
176   ) external {
177     require(deposits[_txId].state == DepositState.BobMadeDeposit);
178     bytes20 depositHash = ripemd160(abi.encodePacked(
179       _alice,
180       msg.sender,
181       ripemd160(abi.encodePacked(sha256(abi.encodePacked(_bobSecret)))),
182       _aliceHash,
183       _tokenAddress,
184       _amount
185     ));
186     require(depositHash == deposits[_txId].depositHash && now < deposits[_txId].lockTime);
187     deposits[_txId].state = DepositState.BobClaimedDeposit;
188     if (_tokenAddress == 0x0) {
189       msg.sender.transfer(_amount);
190     } else {
191       ERC20 token = ERC20(_tokenAddress);
192       assert(token.transfer(msg.sender, _amount));
193     }
194   }
195 
196   function aliceClaimsDeposit(
197     bytes32 _txId,
198     uint256 _amount,
199     bytes32 _aliceSecret,
200     address _bob,
201     address _tokenAddress,
202     bytes20 _bobHash
203   ) external {
204     require(deposits[_txId].state == DepositState.BobMadeDeposit);
205     bytes20 depositHash = ripemd160(abi.encodePacked(
206       msg.sender,
207       _bob,
208       _bobHash,
209       ripemd160(abi.encodePacked(sha256(abi.encodePacked(_aliceSecret)))),
210       _tokenAddress,
211       _amount
212     ));
213     require(depositHash == deposits[_txId].depositHash && now >= deposits[_txId].lockTime);
214     deposits[_txId].state = DepositState.AliceClaimedDeposit;
215     if (_tokenAddress == 0x0) {
216       msg.sender.transfer(_amount);
217     } else {
218       ERC20 token = ERC20(_tokenAddress);
219       assert(token.transfer(msg.sender, _amount));
220     }
221   }
222 
223   function bobMakesEthPayment(
224     bytes32 _txId,
225     address _alice,
226     bytes20 _secretHash,
227     uint64 _lockTime
228   ) external payable {
229     require(_alice != 0x0 && msg.value > 0 && payments[_txId].state == PaymentState.Uninitialized);
230     bytes20 paymentHash = ripemd160(abi.encodePacked(
231       _alice,
232       msg.sender,
233       _secretHash,
234       address(0),
235       msg.value
236     ));
237     payments[_txId] = BobPayment(
238       paymentHash,
239       _lockTime,
240       PaymentState.BobMadePayment
241     );
242   }
243 
244   function bobMakesErc20Payment(
245     bytes32 _txId,
246     uint256 _amount,
247     address _alice,
248     bytes20 _secretHash,
249     address _tokenAddress,
250     uint64 _lockTime
251   ) external {
252     require(
253       _alice != 0x0 &&
254       _amount > 0 &&
255       payments[_txId].state == PaymentState.Uninitialized &&
256       _tokenAddress != 0x0
257     );
258     bytes20 paymentHash = ripemd160(abi.encodePacked(
259       _alice,
260       msg.sender,
261       _secretHash,
262       _tokenAddress,
263       _amount
264     ));
265     payments[_txId] = BobPayment(
266       paymentHash,
267       _lockTime,
268       PaymentState.BobMadePayment
269     );
270     ERC20 token = ERC20(_tokenAddress);
271     assert(token.transferFrom(msg.sender, address(this), _amount));
272   }
273 
274   function bobClaimsPayment(
275     bytes32 _txId,
276     uint256 _amount,
277     address _alice,
278     address _tokenAddress,
279     bytes20 _secretHash
280   ) external {
281     require(payments[_txId].state == PaymentState.BobMadePayment);
282     bytes20 paymentHash = ripemd160(abi.encodePacked(
283       _alice,
284       msg.sender,
285       _secretHash,
286       _tokenAddress,
287       _amount
288     ));
289     require(now >= payments[_txId].lockTime && paymentHash == payments[_txId].paymentHash);
290     payments[_txId].state = PaymentState.BobClaimedPayment;
291     if (_tokenAddress == 0x0) {
292       msg.sender.transfer(_amount);
293     } else {
294       ERC20 token = ERC20(_tokenAddress);
295       assert(token.transfer(msg.sender, _amount));
296     }
297   }
298 
299   function aliceClaimsPayment(
300     bytes32 _txId,
301     uint256 _amount,
302     bytes32 _secret,
303     address _bob,
304     address _tokenAddress
305   ) external {
306     require(payments[_txId].state == PaymentState.BobMadePayment);
307     bytes20 paymentHash = ripemd160(abi.encodePacked(
308       msg.sender,
309       _bob,
310       ripemd160(abi.encodePacked(sha256(abi.encodePacked(_secret)))),
311       _tokenAddress,
312       _amount
313     ));
314     require(now < payments[_txId].lockTime && paymentHash == payments[_txId].paymentHash);
315     payments[_txId].state = PaymentState.AliceClaimedPayment;
316     if (_tokenAddress == 0x0) {
317       msg.sender.transfer(_amount);
318     } else {
319       ERC20 token = ERC20(_tokenAddress);
320       assert(token.transfer(msg.sender, _amount));
321     }
322   }
323 }