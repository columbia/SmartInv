1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function add(uint256 _a, uint256 _b) pure internal returns (uint256) {
5         uint256 c = _a + _b;
6         assert(c >= _a && c >= _b);
7         
8         return c;
9     }
10 
11     function sub(uint256 _a, uint256 _b) pure internal returns (uint256) {
12         assert(_b <= _a);
13 
14         return _a - _b;
15     }
16 
17     function mul(uint256 _a, uint256 _b) pure internal returns (uint256) {
18         uint256 c = _a * _b;
19         assert(_a == 0 || c / _a == _b);
20 
21         return c;
22     }
23 
24     function div(uint256 _a, uint256 _b) pure internal returns (uint256) {
25         assert(_b > 0);
26 
27         return _a / _b;
28     }
29 }
30 
31 contract Token {
32     string public name;
33     string public symbol;
34     uint256 public decimals;
35     uint256 public totalSupply;
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     function transfer(address _to, uint256 _value) public returns (bool _success);
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success);
41     function approve(address _spender, uint256 _value) public returns (bool _success);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract StrictToken is Token {
48     bool public strict = true;
49     mapping (address => uint256) public rate;
50 
51     function getRate(address _address) public view returns (uint256);
52     function getStrict() public pure returns (bool);
53 }
54 
55 contract TrexDexMain {
56     using SafeMath for uint256;
57 
58     address public owner;
59     address public feeAddress;
60     mapping (address => mapping (address => uint256)) public makeFees;
61     mapping (address => mapping (address => uint256)) public takeFees;
62     mapping (address => uint256) public depositFees;
63     mapping (address => uint256) public withdrawFees;
64     mapping (address => bool) public strictTokens;
65     mapping (address => bool) public tokenDeposits;
66     mapping (address => bool) public tokenWithdraws;
67     mapping (address => mapping (address => bool)) public tokenTrades;
68     mapping (address => mapping (address => uint256)) public deposits;
69     mapping (address => mapping (bytes32 => bool)) public orders;
70     mapping (address => mapping (bytes32 => uint256)) public orderFills;
71 
72     event Order(address buyTokenAddress, uint256 buyAmount, address sellTokenAddress, uint256 sellAmount, address takeAddress, address baseTokenAddress, uint256 expireBlock, uint256 nonce, address makeAddress);
73     event Cancel(bytes32 orderHash);
74     event Trade(bytes32 orderHash, uint256 buyAmount, uint256 sellAmount, uint256 takeFee, uint256 makeFee, address takeAddress);
75     event Deposit(address tokenAddress, address userAddress, uint256 amount, uint256 fee, uint256 balance);
76     event Withdraw(address tokenAddress, address userAddress, uint256 amount, uint256 fee, uint256 balance);
77     event TransferIn(address tokenAddress, address userAddress, uint256 amount, uint256 balance);
78     event TransferOut(address tokenAddress, address userAddress, uint256 amount, uint256 balance);
79 
80     modifier isOwner {
81         assert(msg.sender == owner);
82         _;
83     }
84 
85     modifier hasPayloadSize(uint256 size) {
86         assert(msg.data.length >= size + 4);
87         _;
88     }    
89 
90     constructor(address _feeAddress) public {
91         owner = msg.sender;
92         feeAddress = _feeAddress;
93     }
94 
95     function() public {
96         revert();
97     }
98 
99     function transfer(address _tokenAddress, address _userAddress, uint256 _amount) public isOwner {
100         require (deposits[_tokenAddress][msg.sender] >= _amount);
101         deposits[_tokenAddress][_userAddress] = deposits[_tokenAddress][_userAddress].add(_amount);
102         deposits[_tokenAddress][msg.sender] = deposits[_tokenAddress][msg.sender].sub(_amount);
103 
104         emit TransferIn(_tokenAddress, _userAddress, _amount, deposits[_tokenAddress][_userAddress]);
105         emit TransferOut(_tokenAddress, msg.sender, _amount, deposits[_tokenAddress][msg.sender]);
106     }
107 
108     function setOwner(address _owner) public isOwner {
109         owner = _owner;
110     }
111 
112     function setFeeAddress(address _feeAddress) public isOwner {
113         feeAddress = _feeAddress;
114     }
115 
116     function setStrictToken(address _tokenAddress, bool _isStrict) public isOwner {
117         strictTokens[_tokenAddress] = _isStrict;
118     }
119 
120     function setTokenTransfers(address[] _tokenAddress, bool[] _depositEnabled, bool[] _withdrawEnabled, uint256[] _depositFee, uint256[] _withdrawFee) public isOwner {
121         for (uint256 i = 0; i < _tokenAddress.length; i++) {
122             setTokenTransfer(_tokenAddress[i], _depositEnabled[i], _withdrawEnabled[i], _depositFee[i], _withdrawFee[i]);
123         }
124     }
125 
126     function setTokenTransfer(address _tokenAddress, bool _depositEnabled, bool _withdrawEnabled, uint256 _depositFee, uint256 _withdrawFee) public isOwner {
127         tokenDeposits[_tokenAddress] = _depositEnabled;
128         tokenWithdraws[_tokenAddress] = _withdrawEnabled;
129         depositFees[_tokenAddress] = _depositFee;
130         withdrawFees[_tokenAddress] = _withdrawFee;
131     }
132 
133     function setTokenTrades(address[] _tokenAddress, address[] _baseTokenAddress, bool[] _tradeEnabled, uint256[] _makeFee, uint256[] _takeFee) public isOwner {
134         for (uint256 i = 0; i < _tokenAddress.length; i++) {
135             setTokenTrade(_tokenAddress[i], _baseTokenAddress[i], _tradeEnabled[i], _makeFee[i], _takeFee[i]);
136         }
137     }
138 
139     function setTokenTrade(address _tokenAddress, address _baseTokenAddress, bool _tradeEnabled, uint256 _makeFee, uint256 _takeFee) public isOwner {
140         tokenTrades[_baseTokenAddress][_tokenAddress] = _tradeEnabled;
141         makeFees[_baseTokenAddress][_tokenAddress] = _makeFee;
142         takeFees[_baseTokenAddress][_tokenAddress] = _takeFee;
143     }
144 
145     function deposit() payable public {
146         uint256 fee = _depositToken(0x0, msg.sender, msg.value);
147 
148         emit Deposit(0x0, msg.sender, msg.value, fee, deposits[0x0][msg.sender]);
149     }
150 
151     function depositToken(address _tokenAddress, uint256 _amount) public hasPayloadSize(2 * 32) {
152         require (_tokenAddress != 0x0 && tokenDeposits[_tokenAddress]);
153         require (Token(_tokenAddress).transferFrom(msg.sender, this, _amount));
154         uint256 fee = _depositToken(_tokenAddress, msg.sender, _amount);
155 
156         emit Deposit(_tokenAddress, msg.sender, _amount, fee, deposits[_tokenAddress][msg.sender]);
157     }
158 
159     function _depositToken(address _tokenAddress, address _userAddress, uint256 _amount) private returns (uint256 fee) {
160         fee = _amount.mul(depositFees[_tokenAddress]).div(1 ether);
161         deposits[_tokenAddress][_userAddress] = deposits[_tokenAddress][_userAddress].add(_amount.sub(fee));
162         deposits[_tokenAddress][feeAddress] = deposits[_tokenAddress][feeAddress].add(fee);
163     }
164 
165     function withdraw(uint256 _amount) public hasPayloadSize(32) {
166         require (deposits[0x0][msg.sender] >= _amount);
167         uint256 fee = _withdrawToken(0x0, msg.sender, _amount);
168         msg.sender.transfer(_amount - fee);
169 
170         emit Withdraw(0x0, msg.sender, _amount, fee, deposits[0x0][msg.sender]);
171     }
172 
173     function withdrawToken(address _tokenAddress, uint256 _amount) public hasPayloadSize(2 * 32) {
174         require (_tokenAddress != 0x0 && tokenWithdraws[_tokenAddress]);
175         require (deposits[_tokenAddress][msg.sender] >= _amount);
176         uint256 fee = _withdrawToken(_tokenAddress, msg.sender, _amount);
177         if (!Token(_tokenAddress).transfer(msg.sender, _amount - fee)) {
178             revert();
179         }
180 
181         emit Withdraw(_tokenAddress, msg.sender, _amount, fee, deposits[_tokenAddress][msg.sender]);
182     }
183 
184     function _withdrawToken(address _tokenAddress, address _userAddress, uint256 _amount) private returns (uint256 fee) {
185         fee = _amount.mul(withdrawFees[_tokenAddress]).div(1 ether);
186         deposits[_tokenAddress][_userAddress] = deposits[_tokenAddress][_userAddress].sub(_amount);
187         deposits[_tokenAddress][feeAddress] = deposits[_tokenAddress][feeAddress].add(fee);
188     }
189 
190     function balanceOf(address _tokenAddress, address _userAddress) view public returns (uint256) {
191         return deposits[_tokenAddress][_userAddress];
192     }
193 
194     function order(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce) public hasPayloadSize(8 * 32) {
195         require (_checkTrade(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _baseTokenAddress));
196         bytes32 hash = _buildHash(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce);
197         require (!orders[msg.sender][hash]);
198         orders[msg.sender][hash] = true;
199 
200         emit Order(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce, msg.sender);
201     }
202 
203     function tradeMulti(address[] _buyTokenAddress, uint256[] _buyAmount, address[] _sellTokenAddress, uint256[] _sellAmount, address[] _takeAddress, address[] _baseTokenAddress, uint256[] _expireBlock, uint256[] _nonce, address[] _makeAddress, uint256[] _amount, uint8[] _v, bytes32[] _r, bytes32[] _s) public {
204         for (uint256 i = 0; i < _buyTokenAddress.length; i++) {
205             trade(_buyTokenAddress[i], _buyAmount[i], _sellTokenAddress[i], _sellAmount[i], _takeAddress[i], _baseTokenAddress[i], _expireBlock[i], _nonce[i], _makeAddress[i], _amount[i], _v[i], _r[i], _s[i]);
206         }
207     }
208 
209     function trade(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce, address _makeAddress, uint256 _amount, uint8 _v, bytes32 _r, bytes32 _s) public {
210         assert(msg.data.length >= 13 * 32 + 4);
211         require (_checkTrade(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _baseTokenAddress));
212         require (_takeAddress == 0x0 || msg.sender == _takeAddress);
213         bytes32 hash = _buildHash(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce);
214         require (_checkHash(hash, _makeAddress, _v, _r, _s));
215         require (block.number <= _expireBlock);
216         require (orderFills[_makeAddress][hash] + _amount <= _buyAmount);
217         _trade(hash, _buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _baseTokenAddress, _makeAddress, _amount);
218     }
219 
220     function _trade(bytes32 hash, address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _baseTokenAddress, address _makeAddress, uint256 _amount) private {
221         address tokenAddress = (_baseTokenAddress == _buyTokenAddress ? _sellTokenAddress : _buyTokenAddress);
222         uint256 makeFee = _amount.mul(makeFees[_baseTokenAddress][tokenAddress]).div(1 ether);
223         uint256 takeFee = _amount.mul(takeFees[_baseTokenAddress][tokenAddress]).div(1 ether);
224         if (_buyAmount == 0) {
225             _buyAmount = _calcStrictAmount(_sellTokenAddress, _sellAmount, _buyTokenAddress);
226         }
227         else if (_sellAmount == 0) {
228             _sellAmount = _calcStrictAmount(_buyTokenAddress, _buyAmount, _sellTokenAddress);
229         }
230         uint256 tradeAmount = _sellAmount.mul(_amount).div(_buyAmount);
231         deposits[_buyTokenAddress][msg.sender] = deposits[_buyTokenAddress][msg.sender].sub(_amount.add(takeFee));
232         deposits[_buyTokenAddress][_makeAddress] = deposits[_buyTokenAddress][_makeAddress].add(_amount.sub(makeFee));
233         deposits[_buyTokenAddress][feeAddress] = deposits[_buyTokenAddress][feeAddress].add(makeFee.add(takeFee));
234         deposits[_sellTokenAddress][_makeAddress] = deposits[_sellTokenAddress][_makeAddress].sub(tradeAmount);
235         deposits[_sellTokenAddress][msg.sender] = deposits[_sellTokenAddress][msg.sender].add(tradeAmount);
236         orderFills[_makeAddress][hash] = orderFills[_makeAddress][hash].add(_amount);
237 
238         emit Trade(hash, _amount, tradeAmount, takeFee, makeFee, msg.sender);
239     }
240 
241     function _calcStrictAmount(address _tokenAddress, uint256 _amount, address _strictTokenAddress) private view returns (uint256) {
242         uint256 rate = StrictToken(_strictTokenAddress).getRate(_tokenAddress);
243         require(rate > 0);
244 
245         return rate.mul(_amount).div(1 ether);
246     }
247 
248     function _checkTrade(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _baseTokenAddress) private view returns (bool) {
249         if (!_checkTradeAddress(_buyTokenAddress, _sellTokenAddress, _baseTokenAddress)) {
250             return false;
251         }
252         else if (_buyAmount != 0 && strictTokens[_buyTokenAddress]) {
253             return false;
254         }
255         else if (_sellAmount != 0 && strictTokens[_sellTokenAddress]) {
256             return false;
257         }
258 
259         return true;
260     }
261 
262     function _checkTradeAddress(address _buyTokenAddress, address _sellTokenAddress, address _baseTokenAddress) private view returns (bool) {
263         return _baseTokenAddress == _buyTokenAddress ? tokenTrades[_buyTokenAddress][_sellTokenAddress] : tokenTrades[_sellTokenAddress][_buyTokenAddress];
264     }
265 
266     function testTrade(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce, address _makeAddress, uint256 _amount, uint8 _v, bytes32 _r, bytes32 _s) constant public returns (bool) {
267         if (!_checkTrade(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _baseTokenAddress)) {
268             return false;
269         }
270         else if (!(_takeAddress == 0x0 || msg.sender == _takeAddress)) {
271             return false;
272         }
273         else if (!_hasDeposit(_buyTokenAddress, _takeAddress, _amount)) {
274             return false;
275         }
276         else if (availableVolume(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce, _makeAddress, _v, _r, _s) > _amount) {
277             return false;
278         }
279         
280         return true;
281     }
282 
283     function _hasDeposit(address _buyTokenAddress, address _userAddress, uint256 _amount) private view returns (bool) {
284         return deposits[_buyTokenAddress][_userAddress] >= _amount;
285     }
286 
287     function availableVolume(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce, address _makeAddress, uint8 _v, bytes32 _r, bytes32 _s) constant public returns (uint256) {
288         bytes32 hash = _buildHash(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce);
289         if (!_checkHash(hash, _makeAddress, _v, _r, _s)) {
290             return 0;
291         }
292 
293         return _availableVolume(hash, _buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _makeAddress);
294     }
295 
296     function _availableVolume(bytes32 hash, address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _makeAddress) private view returns (uint256) {
297         if (_buyAmount == 0) {
298             _buyAmount = _calcStrictAmount(_sellTokenAddress, _sellAmount, _buyTokenAddress);
299         }
300         else if (_sellAmount == 0) {
301             _sellAmount = _calcStrictAmount(_buyTokenAddress, _buyAmount, _sellTokenAddress);
302         }
303         uint256 available1 = _buyAmount.sub(orderFills[_makeAddress][hash]);
304         uint256 available2 = deposits[_sellTokenAddress][_makeAddress].mul(_buyAmount).div(_sellAmount);
305 
306         return available1 < available2 ? available1 : available2;
307     }
308 
309     function amountFilled(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce, address _makeAddress) constant public returns (uint256) {
310         bytes32 hash = _buildHash(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce);
311 
312         return orderFills[_makeAddress][hash];
313     }
314 
315     function cancelOrder(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public hasPayloadSize(11 * 32) {
316         bytes32 hash = _buildHash(_buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce);
317         require (_checkHash(hash, msg.sender, _v, _r, _s));
318         orderFills[msg.sender][hash] = _buyAmount;
319 
320         emit Cancel(hash);
321     }
322 
323     function _buildHash(address _buyTokenAddress, uint256 _buyAmount, address _sellTokenAddress, uint256 _sellAmount, address _takeAddress, address _baseTokenAddress, uint256 _expireBlock, uint256 _nonce) private view returns (bytes32) {
324         return sha256(abi.encodePacked(this, _buyTokenAddress, _buyAmount, _sellTokenAddress, _sellAmount, _takeAddress, _baseTokenAddress, _expireBlock, _nonce));
325     }
326 
327     function _checkHash(bytes32 _hash, address _makeAddress, uint8 _v, bytes32 _r, bytes32 _s) private view returns (bool) {
328         return (orders[_makeAddress][_hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)), _v, _r, _s) == _makeAddress);
329     }
330 
331 }