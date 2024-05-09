1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 
92 /**
93  * ERC-20 Token Standard
94  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
95  */
96 contract Token {
97     function totalSupply() public view returns (uint256);
98     function balanceOf(address _owner) public view returns (uint256);
99     function transfer(address _to, uint256 _value) public returns (bool);
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
101     function approve(address _spender, uint256 _value) public returns (bool);
102     function allowance(address _owner, address _spender) public view returns (uint256);
103 
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 }
107 
108 
109 /**
110  * Interface for trading discounts and rebates for specific accounts
111  */
112 contract FeeModifiersInterface {
113     function accountFeeModifiers(address _user) public view returns (uint256 feeDiscount, uint256 feeRebate);
114     function tradingFeeModifiers(address _maker, address _taker) public view returns (uint256 feeMakeDiscount, uint256 feeTakeDiscount, uint256 feeRebate);
115 }
116 
117 
118 /**
119  * Interface for trade tracker to handle trade event
120  */
121 contract TradeTrackerInterface {
122     function tradeEventHandler(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, address _maker, address _user, bytes32 _orderHash, uint256 _gasLimit) public;
123 }
124 
125 
126 contract ETHERCExchange is Ownable {
127     using SafeMath for uint256;
128 
129     // the trade tracker address
130     address public tradeTracker;
131     // the contract which stores fee discounts/rebates
132     address public feeModifiers;
133     // the account that will receive fees
134     address public feeAccount;
135     // maker fee percentage times (1 ether)
136     uint256 public feeMake;
137     // taker fee percentage times (1 ether) 
138     uint256 public feeTake;
139 
140     // mapping of token addresses to mapping of account balances
141     mapping (address => mapping (address => uint256)) public tokens;
142     // mapping of order hash to status cancelled
143     mapping (bytes32 => bool) public cancelledOrders;
144     // mapping order hashes to uints (amount of order that has been filled)
145     mapping (bytes32 => uint256) public orderFills;
146 
147     //Logging events
148     event Deposit(address token, address user, uint256 amount, uint256 balance);
149     event Withdraw(address token, address user, uint256 amount, uint256 balance);
150     event Cancel(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address maker, uint8 v, bytes32 r, bytes32 s, bytes32 orderHash, uint256 amountFilled);
151     event Trade(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, address maker, address taker, bytes32 orderHash);
152 
153     function ETHERCExchange() public {
154         feeAccount = owner;
155     }
156 
157     function() public {
158         revert();
159     }
160 
161     ////////////////////////////////////////////////////////////////////////////////
162     // Fee Discounts, Rebates
163     ////////////////////////////////////////////////////////////////////////////////
164 
165     function getAccountFeeModifiers(address _user) public view returns(uint256 feeDiscount, uint256 feeRebate) {
166         if (feeModifiers != address(0)) {
167             (feeDiscount, feeRebate) = FeeModifiersInterface(feeModifiers).accountFeeModifiers(_user);
168         }
169     }
170 
171     ////////////////////////////////////////////////////////////////////////////////
172     // Funds
173     ////////////////////////////////////////////////////////////////////////////////
174 
175     function deposit() public payable {
176         tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(msg.value);
177         Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
178     }
179 
180     function depositToken(address _token, uint256 _amount) public {
181         require(_token != address(0));
182 
183         if (!Token(_token).transferFrom(msg.sender, this, _amount)) revert();
184         tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
185         Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
186     }
187 
188     function withdraw(uint256 _amount) public {
189         require(tokens[address(0)][msg.sender] >= _amount);
190 
191         tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].sub(_amount);
192         msg.sender.transfer(_amount);
193         Withdraw(address(0), msg.sender, _amount, tokens[address(0)][msg.sender]);
194     }
195 
196     function withdrawToken(address _token, uint256 _amount) public {
197         require(_token != address(0));
198         require(tokens[_token][msg.sender] >= _amount);
199 
200         tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);
201         if (!Token(_token).transfer(msg.sender, _amount)) revert();
202         Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
203     }
204 
205     function balanceOf(address _token, address _user) public view returns (uint256) {
206         return tokens[_token][_user];
207     }
208 
209     ////////////////////////////////////////////////////////////////////////////////
210     // Trading & Order
211     ////////////////////////////////////////////////////////////////////////////////
212 
213     function trade(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, uint256 _expires, uint256 _nonce, address _maker, uint8 _v, bytes32 _r, bytes32 _s, uint256 _amountTrade) public {
214         uint256 executionGasLimit = msg.gas;
215         bytes32 orderHash = getOrderHash(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _maker);
216 
217         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), _v, _r, _s) != _maker ||
218             cancelledOrders[orderHash] ||
219             block.number > _expires ||
220             orderFills[orderHash].add(_amountTrade) > _amountGet
221         ) revert();
222 
223         tradeBalances(_tokenGet, _amountGet, _tokenGive, _amountGive, _maker, _amountTrade);
224         orderFills[orderHash] = orderFills[orderHash].add(_amountTrade);
225         uint256 amountTradeGive = _amountGive.mul(_amountTrade) / _amountGet;
226         if(tradeTracker != address(0)){
227             TradeTrackerInterface(tradeTracker).tradeEventHandler(_tokenGet, _amountTrade, _tokenGive, amountTradeGive, _maker, msg.sender, orderHash, executionGasLimit);
228         }
229         Trade(_tokenGet, _amountTrade, _tokenGive, amountTradeGive, _maker, msg.sender, orderHash);
230     }
231 
232     function tradeBalances(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, address _maker, uint256 _amountTrade) private {
233         uint256 feeMakeValue = _amountTrade.mul(feeMake) / (1 ether);
234         uint256 feeTakeValue = _amountTrade.mul(feeTake) / (1 ether);
235         uint256 feeRebateValue = 0;
236 
237         if (feeModifiers != address(0)) {
238             uint256 feeMakeDiscount; uint256 feeTakeDiscount; uint256 feeRebate;
239             (feeMakeDiscount, feeTakeDiscount, feeRebate) = FeeModifiersInterface(feeModifiers).tradingFeeModifiers(_maker, msg.sender);
240             if (feeMakeValue > 0 && feeMakeDiscount > 0 && feeMakeDiscount <= 100 ) feeMakeValue = feeMakeValue.mul(100 - feeMakeDiscount) / 100;
241             if (feeTakeValue > 0 && feeTakeDiscount > 0 && feeTakeDiscount <= 100 ) feeTakeValue = feeTakeValue.mul(100 - feeTakeDiscount) / 100;
242             if (feeTakeValue > 0 && feeRebate > 0 && feeRebate <= 100) feeRebateValue = feeTakeValue.mul(feeRebate) / 100;
243         }
244 
245         tokens[_tokenGet][msg.sender] = tokens[_tokenGet][msg.sender].sub(_amountTrade.add(feeTakeValue));
246         tokens[_tokenGet][_maker] = tokens[_tokenGet][_maker].add(_amountTrade.sub(feeMakeValue).add(feeRebateValue));
247         tokens[_tokenGive][msg.sender] = tokens[_tokenGive][msg.sender].add(_amountGive.mul(_amountTrade) / _amountGet);
248         tokens[_tokenGive][_maker] = tokens[_tokenGive][_maker].sub(_amountGive.mul(_amountTrade) / _amountGet);
249         tokens[_tokenGet][feeAccount] = tokens[_tokenGet][feeAccount].add(feeMakeValue.add(feeTakeValue).sub(feeRebateValue));
250     }
251 
252     function validateTrade(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, uint256 _expires, uint256 _nonce, address _maker, uint8 _v, bytes32 _r, bytes32 _s, uint256 _amountTrade, address _taker) public view returns (uint8) {
253         uint256 feeTakeValue = calculateTakerFee(_taker, _amountTrade);
254 
255         if (_amountTrade.add(feeTakeValue) > tokens[_tokenGet][_taker]) return 1;
256         if (availableVolume(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _maker, _v, _r, _s) < _amountTrade) return 2;
257         return 0;
258     }
259 
260     function calculateTakerFee(address _taker, uint256 _amountTrade) public view returns (uint256) {
261         uint256 feeTakeValue = _amountTrade.mul(feeTake) / (1 ether);
262 
263         uint256 feeDiscount; uint256 feeRebate;
264         (feeDiscount, feeRebate) = getAccountFeeModifiers(_taker);
265         if (feeTakeValue > 0 && feeDiscount > 0 && feeDiscount <= 100 ) feeTakeValue = feeTakeValue.mul(100 - feeDiscount) / 100;
266 
267         return feeTakeValue;
268     }
269 
270     function getOrderHash(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, uint256 _expires, uint256 _nonce, address _maker) public view returns (bytes32) {
271         return keccak256(this, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _maker);
272     }
273 
274     function availableVolume(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, uint256 _expires, uint256 _nonce, address _maker, uint8 _v, bytes32 _r, bytes32 _s) public view returns (uint256) {
275         bytes32 orderHash = getOrderHash(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _maker);
276 
277         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), _v, _r, _s) != _maker ||
278             cancelledOrders[orderHash] ||
279             block.number > _expires ||
280             _amountGet <= orderFills[orderHash]
281         ) return 0;
282 
283         uint256[2] memory available;
284         available[0] = _amountGet.sub(orderFills[orderHash]);
285         available[1] = tokens[_tokenGive][_maker].mul(_amountGet) / _amountGive;
286         if (available[0] < available[1]) return available[0];
287         return available[1];
288     }
289 
290     function amountFilled(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, uint256 _expires, uint256 _nonce, address _maker) public view returns (uint256) {
291         bytes32 orderHash = getOrderHash(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _maker);
292         return orderFills[orderHash];
293     }
294 
295     function cancelOrder(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive, uint256 _expires, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public {
296         bytes32 orderHash = getOrderHash(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, msg.sender);
297         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), _v, _r, _s) != msg.sender) revert();
298 
299         cancelledOrders[orderHash] = true;
300         Cancel(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, msg.sender, _v, _r, _s, orderHash, orderFills[orderHash]);
301     }
302 
303     ////////////////////////////////////////////////////////////////////////////////
304     // Setting
305     ////////////////////////////////////////////////////////////////////////////////
306 
307     function changeFeeAccount(address _feeAccount) public onlyOwner {
308         require(_feeAccount != address(0));
309         feeAccount = _feeAccount;
310     }
311 
312     function changeFeeMake(uint256 _feeMake) public onlyOwner {
313         require(_feeMake != feeMake);
314         feeMake = _feeMake;
315     }
316 
317     function changeFeeTake(uint256 _feeTake) public onlyOwner {
318         require(_feeTake != feeTake);
319         feeTake = _feeTake;
320     }
321 
322     function changeFeeModifiers(address _feeModifiers) public onlyOwner {
323         require(feeModifiers != _feeModifiers);
324         feeModifiers = _feeModifiers;
325     }
326 
327     function changeTradeTracker(address _tradeTracker) public onlyOwner {
328         require(tradeTracker != _tradeTracker);
329         tradeTracker = _tradeTracker;
330     }
331 }