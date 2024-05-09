1 pragma solidity ^0.5.2;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         // benefit is lost if 'b' is also tested.
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11 
12         return c;
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23 
24         return c;
25     }
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29 
30         return c;
31     }
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 pragma solidity ^0.5.2;
39 contract Ownable {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43     constructor () internal {
44         _owner = msg.sender;
45         emit OwnershipTransferred(address(0), _owner);
46     }
47     function owner() public view returns (address) {
48         return _owner;
49     }
50     modifier onlyOwner() {
51         require(isOwner());
52         _;
53     }
54     function isOwner() public view returns (bool) {
55         return msg.sender == _owner;
56     }
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64     function _transferOwnership(address newOwner) internal {
65         require(newOwner != address(0));
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 }
70 
71 pragma solidity ^0.5.2;
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 pragma solidity ^0.5.2;
91 
92 interface IVault {
93     function transfer(address token, address from, address to, uint256 amount, uint256 fromFeeRate, uint256 toFeeRate) external;
94 
95     function calculateFee(uint256 amount, uint256 feeRate) external pure returns (uint256);
96 
97     function balanceOf(address token, address client) external view returns (uint256);
98 
99     event Transfer(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 fromFee, uint256 toFee);
100 }
101 
102 pragma solidity ^0.5.2;
103 
104 
105 
106 
107 
108 contract ExchangeV1 is Ownable {
109     using SafeMath for uint256;
110 
111     event VaultChanged(address indexed account);
112     event MarketPermissionChanged(address indexed base, address indexed quote, bool permission);
113     event BlacklistChanged(address indexed client, bool tradeBlacklist);
114     event MarketFeeRateChanged(address indexed base, address indexed quote, uint256 makeFeeRate, uint256 takeFeeRate);
115     event Trade(bytes32 indexed orderHash, uint256 amount, uint256 price, address indexed take, uint256 makeFee, uint256 takeFee);
116     event Cancel(bytes32 indexed orderHash);
117 
118     address private _vault;
119     mapping (address => mapping (address => bool)) private _marketPermissions;
120     mapping (address => bool) private _tradeBlacklist;
121     mapping (address => mapping (address => uint256)) private _makeFeeRates;
122     mapping (address => mapping (address => uint256)) private _takeFeeRates;
123     mapping (bytes32 => uint256) private _orderFills;
124 
125     constructor () public {
126     } 
127     
128     function renounceOwnership() public onlyOwner {
129         revert();
130     }
131 
132     function setVault(address account) public onlyOwner {
133         if (_vault != account) {
134             _vault = account;
135             emit VaultChanged(account);
136         }
137     }
138 
139     function vault() public view returns (address) {
140         return _vault;
141     }
142 
143     function setMarketPermission(address base, address quote, bool permission) public onlyOwner {
144         if (isMarketPermitted(base, quote) != permission) {
145             _marketPermissions[base][quote] = permission;
146             emit MarketPermissionChanged(base, quote, permission);
147         }
148     }
149 
150     function multiSetMarketPermission(address[] memory bases, address[] memory quotes, bool[] memory permissions) public onlyOwner {
151         require(bases.length == quotes.length && bases.length == permissions.length);
152         for (uint256 i = 0; i < bases.length; i++) {
153             setMarketPermission(bases[i], quotes[i], permissions[i]);
154         }
155     }
156 
157     function isMarketPermitted(address base, address quote) public view returns (bool) {
158         return _marketPermissions[base][quote];
159     }
160 
161     function isTradeBlacklisted(address client) public view returns (bool) {
162         return _tradeBlacklist[client];
163     }
164 
165     function setBlacklist(address client, bool tradeBlacklist) public onlyOwner {
166         if (isTradeBlacklisted(client) != tradeBlacklist) {
167             _tradeBlacklist[client] = tradeBlacklist;
168             emit BlacklistChanged(client, isTradeBlacklisted(client));
169         }
170     }
171     
172     function multiSetBlacklist(address[] memory clients, bool[] memory tradeBlacklists) public onlyOwner {
173         require(clients.length == tradeBlacklists.length);
174         for (uint256 i = 0; i < clients.length; i++) {
175             setBlacklist(clients[i], tradeBlacklists[i]);
176         }
177     }
178 
179     function setMarketFeeRate(address base, address quote, uint256 makeFeeRate, uint256 takeFeeRate) public onlyOwner {
180         if (makeFeeRateOf(base, quote) != makeFeeRate || takeFeeRateOf(base, quote) != takeFeeRate) {
181             _makeFeeRates[base][quote] = makeFeeRate;
182             _takeFeeRates[base][quote] = takeFeeRate;
183             emit MarketFeeRateChanged(base, quote, makeFeeRate, takeFeeRate);
184         }
185     }
186 
187     function multiSetMarketFeeRate(address[] memory bases, address[] memory quotes, uint256[] memory makeFeeRates, uint256[] memory takeFeeRates) public onlyOwner {
188         require(bases.length == quotes.length && bases.length == makeFeeRates.length && bases.length == takeFeeRates.length);
189         for (uint256 i = 0; i < bases.length; i++) {
190             setMarketFeeRate(bases[i], quotes[i], makeFeeRates[i], takeFeeRates[i]);
191         }
192     }
193 
194     function makeFeeRateOf(address base, address quote) public view returns (uint256) {
195         return _makeFeeRates[base][quote];
196     }
197 
198     function takeFeeRateOf(address base, address quote) public view returns (uint256) {
199         return _takeFeeRates[base][quote];
200     }
201 
202     function orderFillOf(bytes32 orderHash) public view returns (uint256) {
203         return _orderFills[orderHash];
204     }
205 
206     function trade(address base, address quote, uint256 baseAmount, uint256 quoteAmount, bool isBuy, uint256 expire, uint256 nonce, address make, uint256 amount, uint8 v, bytes32 r, bytes32 s) public {
207         bytes32 orderHash = _buildOrderHash(base, quote, baseAmount, quoteAmount, isBuy, expire, nonce);
208         require(block.timestamp < expire && isMarketPermitted(base, quote) && !isTradeBlacklisted(msg.sender) && orderFillOf(orderHash).add(amount) <= baseAmount && _checkOrderHash(orderHash, make, v, r, s));
209         _trade(orderHash, base, quote, baseAmount, quoteAmount, isBuy, make, amount);
210     }
211 
212     function _trade(bytes32 orderHash, address base, address quote, uint256 baseAmount, uint256 quoteAmount, bool isBuy, address make, uint256 amount) private {
213         uint256 price = amount.mul(quoteAmount).div(baseAmount);
214         uint256 makeFeeRate = makeFeeRateOf(base, quote);
215         uint256 takeFeeRate = takeFeeRateOf(base, quote);
216         if (isBuy) {
217             _transfer(base, msg.sender, make, amount, 0, 0);
218             _transfer(quote, make, msg.sender, price, makeFeeRate, takeFeeRate);
219         }
220         else {
221             _transfer(base, make, msg.sender, amount, 0, 0);
222             _transfer(quote, msg.sender, make, price, takeFeeRate, makeFeeRate);
223         }
224         _orderFills[orderHash] = orderFillOf(orderHash).add(amount);
225         emit Trade(orderHash, amount, price, msg.sender, _calculateFee(price, makeFeeRate), _calculateFee(price, takeFeeRate));
226     }
227 
228     function multiTrade(address[] memory bases, address[] memory quotes, uint256[] memory baseAmounts, uint256[] memory quoteAmounts, bool[] memory isBuys, uint256[] memory expires, uint256[] memory nonces, address[] memory makes, uint256[] memory amounts, uint8[] memory vs, bytes32[] memory rs, bytes32[] memory ss) public {
229         require(bases.length == quotes.length && bases.length == baseAmounts.length && bases.length == quoteAmounts.length && bases.length == isBuys.length && bases.length == expires.length && bases.length == nonces.length && bases.length == makes.length && bases.length == amounts.length && bases.length == vs.length && bases.length == rs.length && bases.length == ss.length);
230         for (uint256 i = 0; i < bases.length; i++) {
231             trade(bases[i], quotes[i], baseAmounts[i], quoteAmounts[i], isBuys[i], expires[i], nonces[i], makes[i], amounts[i], vs[i], rs[i], ss[i]);
232         }
233     }
234 
235     function availableAmountOf(address base, address quote, uint256 baseAmount, uint256 quoteAmount, bool isBuy, uint256 expire, uint256 nonce, address make, uint8 v, bytes32 r, bytes32 s) public view returns (uint256) {
236         bytes32 orderHash = _buildOrderHash(base, quote, baseAmount, quoteAmount, isBuy, expire, nonce);
237         return block.timestamp >= expire || !_checkOrderHash(orderHash, make, v, r, s) ? 0 : _availableAmountOf(orderHash, base, quote, baseAmount, quoteAmount, isBuy, make);
238     }
239 
240     function _availableAmountOf(bytes32 orderHash, address base, address quote, uint256 baseAmount, uint256 quoteAmount, bool isBuy, address make) private view returns (uint256) {
241         uint256 availableByFill = baseAmount.sub(orderFillOf(orderHash));
242         uint256 availableByBalance = isBuy ? _balanceOf(quote, make).mul(baseAmount).div(quoteAmount) : _balanceOf(base, make);
243         return availableByFill < availableByBalance ? availableByFill : availableByBalance;
244     }
245 
246     function cancel(address base, address quote, uint256 baseAmount, uint256 quoteAmount, bool isBuy, uint256 expire, uint256 nonce, uint8 v, bytes32 r, bytes32 s) public {
247         bytes32 orderHash = _buildOrderHash(base, quote, baseAmount, quoteAmount, isBuy, expire, nonce);
248         require(_checkOrderHash(orderHash, msg.sender, v, r, s));
249         _orderFills[orderHash] = baseAmount;
250         emit Cancel(orderHash);
251     }
252 
253     function multiCancel(address[] memory bases, address[] memory quotes, uint256[] memory baseAmounts, uint256[] memory quoteAmounts, bool[] memory isBuys, uint256[] memory expires, uint256[] memory nonces, uint8[] memory vs, bytes32[] memory rs, bytes32[] memory ss) public {
254         require(bases.length == quotes.length && bases.length == baseAmounts.length && bases.length == quoteAmounts.length && bases.length == isBuys.length && bases.length == expires.length && bases.length == nonces.length && bases.length == vs.length && bases.length == rs.length && bases.length == ss.length);
255         for (uint256 i = 0; i < bases.length; i++) {
256             cancel(bases[i], quotes[i], baseAmounts[i], quoteAmounts[i], isBuys[i], expires[i], nonces[i], vs[i], rs[i], ss[i]);
257         }
258     }
259 
260     function _transfer(address token, address from, address to, uint256 amount, uint256 fromFeeRate, uint256 toFeeRate) private {
261         IVault(vault()).transfer(token, from, to, amount, fromFeeRate, toFeeRate);
262     }
263 
264     function _calculateFee(uint256 amount, uint256 feeRate) private view returns (uint256) {
265         return IVault(vault()).calculateFee(amount, feeRate);
266     }
267 
268     function _balanceOf(address token, address client) private view returns (uint256) {
269         return IVault(vault()).balanceOf(token, client);
270     }
271 
272    function _buildOrderHash(address base, address quote, uint256 baseAmount, uint256 quoteAmount, bool isBuy, uint256 expire, uint256 nonce) private view returns (bytes32) {
273         return sha256(abi.encodePacked(address(this), base, quote, baseAmount, quoteAmount, isBuy, expire, nonce));
274     }
275 
276     function _checkOrderHash(bytes32 orderHash, address make, uint8 v, bytes32 r, bytes32 s) private pure returns (bool) {
277         return ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)), v, r, s) == make;
278     }
279 }