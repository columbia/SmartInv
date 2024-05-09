1 pragma solidity 0.5.17;
2 
3 library Address {
4     function isContract(address account) internal view returns (bool) {
5         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
6         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
7         // for accounts without code, i.e. `keccak256('')`
8         bytes32 codehash;
9         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
10         // solhint-disable-next-line no-inline-assembly
11         assembly { codehash := extcodehash(account) }
12         return (codehash != accountHash && codehash != 0x0);
13     }
14 }
15 
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 }
26 
27 contract ReentrancyGuard {
28     bool private _notEntered;
29 
30     constructor () internal {
31         // Storing an initial non-zero value makes deployment a bit more
32         // expensive, but in exchange the refund on every call to nonReentrant
33         // will be lower in amount. Since refunds are capped to a percetange of
34         // the total transaction's gas, it is best to keep them low in cases
35         // like this one, to increase the likelihood of the full refund coming
36         // into effect.
37         _notEntered = true;
38     }
39 
40     modifier nonReentrant() {
41         // On the first call to nonReentrant, _notEntered will be true
42         require(_notEntered, "ReentrancyGuard: reentrant call");
43 
44         // Any calls to nonReentrant after this point will fail
45         _notEntered = false;
46 
47         _;
48 
49         // By storing the original value once again, a refund is triggered (see
50         // https://eips.ethereum.org/EIPS/eip-2200)
51         _notEntered = true;
52     }
53 }
54 
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 }
88 
89 interface ERC20 {
90     function totalSupply() external view returns (uint256);
91     function balanceOf(address account) external view returns (uint256);
92     function transfer(address recipient, uint256 amount) external returns (bool);
93     function allowance(address owner, address spender) external view returns (uint256);
94     function approve(address spender, uint256 amount) external returns (bool);
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 library SafeERC20 {
102     using SafeMath for uint256;
103     using Address for address;
104 
105     function safeTransfer(ERC20 token, address to, uint256 value) internal {
106         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
107     }
108 
109     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
110         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
111     }
112 
113     function callOptionalReturn(ERC20 token, bytes memory data) private {
114         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
115         // we're implementing it ourselves.
116 
117         // A Solidity high level call has three parts:
118         //  1. The target address is checked to verify it contains contract code
119         //  2. The call itself is made, and success asserted
120         //  3. The return value is decoded, which in turn checks the size of the returned data.
121         // solhint-disable-next-line max-line-length
122         require(address(token).isContract(), "SafeERC20: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = address(token).call(data);
126         require(success, "SafeERC20: low-level call failed");
127 
128         if (returndata.length > 0) { // Return data is optional
129             // solhint-disable-next-line max-line-length
130             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
131         }
132     }
133 }
134 
135 contract ICO is Context, ReentrancyGuard {
136     using SafeMath for uint256;
137     using SafeERC20 for ERC20;
138 
139     // The  GAUF contract
140     ERC20 private _gauf;
141 
142     // The link contract
143     ERC20 private _link;
144 
145     // Address where funds are collected
146     address payable private _wallet;
147 
148     // How many GAUF units a buyer gets per Link.
149     // The rate is the conversion between Link and GAUF unit.
150     uint256 private _linkRate;
151 
152     // How many GAUF units a buyer gets per Ether.
153     // The rate is the conversion between Ether and GAUF unit.
154     uint256 private _ethRate;
155 
156     // Amount of GAUF Delivered
157     uint256 private _gaufDelivered;
158 
159     event GaufPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
160 
161     constructor (uint256 linkRate, uint256 ethRate, address payable wallet, ERC20 link, ERC20 gauf) public {
162         require(linkRate > 0, "ICO: linkRate shouldn't be Zero");
163         require(ethRate > 0, "ICO: ethRate shouldn't be Zero");
164         require(wallet != address(0), "ICO: wallet is the Zero address");
165         require(address(gauf) != address(0), "ICO: token is the Zero address");
166 
167         _linkRate = linkRate;
168         _ethRate = ethRate;
169         _wallet = wallet;
170         _link = link;
171         _gauf = gauf;
172     }
173 
174     function gaufAddress() public view returns (ERC20) {
175         return _gauf;
176     }
177 
178     function linkAddress() public view returns (ERC20) {
179         return _link;
180     }
181 
182     function teamWallet() public view returns (address payable) {
183         return _wallet;
184     }
185 
186     function linkRate() public view returns (uint256) {
187         return _linkRate;
188     }
189 
190     function ethRate() public view returns (uint256) {
191         return _ethRate;
192     }
193 
194     function gaufDelivered() public view returns (uint256) {
195         return _gaufDelivered;
196     }
197 
198     function buyGaufWithLink(uint256 linkAmount) public nonReentrant {
199         address beneficiary = _msgSender();
200         uint256 ContractBalance = _gauf.balanceOf(address(this));
201         uint256 allowance = _link.allowance(beneficiary, address(this));
202 
203         require(linkAmount > 0, "You need to send at least one link");
204         require(allowance >= linkAmount, "Check the Link allowance");
205 
206         // calculate GAUF amount
207         uint256 _gaufAmount = _getLinkRate(linkAmount);
208 
209         _preValidatePurchase(beneficiary, _gaufAmount);
210 
211         require(_gaufAmount <= ContractBalance, "Not enough GAUF in the reserve");
212 
213         // update state
214         _gaufDelivered = _gaufDelivered.add(_gaufAmount);
215 
216         _link.safeTransferFrom(beneficiary, address(this), linkAmount);
217 
218         _processPurchase(beneficiary, _gaufAmount);
219 
220         emit GaufPurchased(_msgSender(), beneficiary, linkAmount, _gaufAmount);
221 
222         _updatePurchasingState(beneficiary, _gaufAmount);
223 
224         _forwardLinkFunds(linkAmount);
225         _postValidatePurchase(beneficiary, _gaufAmount);
226     }
227 
228     function () external payable {
229         buyGaufWithEther();
230     }
231 
232     function buyGaufWithEther() public nonReentrant payable {
233         address beneficiary = _msgSender();
234         uint256 ethAmount = msg.value;
235         uint256 ContractBalance = _gauf.balanceOf(address(this));
236 
237         require(ethAmount > 0, "You need to sendo at least some Ether");
238 
239         // calculate GAUF amount
240         uint256 _gaufAmount = _getEthRate(ethAmount);
241 
242         _preValidatePurchase(beneficiary, _gaufAmount);
243 
244         require(_gaufAmount <= ContractBalance, "Not enough GauF in the reserve");
245 
246         // update state
247         _gaufDelivered = _gaufDelivered.add(_gaufAmount);
248 
249         _processPurchase(beneficiary, _gaufAmount);
250 
251         emit GaufPurchased(_msgSender(), beneficiary, ethAmount, _gaufAmount);
252 
253         _updatePurchasingState(beneficiary, _gaufAmount);
254 
255         _forwardEtherFunds();
256 
257         _postValidatePurchase(beneficiary, _gaufAmount);
258     }
259 
260     function _preValidatePurchase(address beneficiary, uint256 Amount) internal view {
261         require(beneficiary != address(0), "ICO: beneficiary is the zero address");
262         require(Amount != 0, "ICO: Amount is 0");
263         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
264     }
265 
266     function _postValidatePurchase(address beneficiary, uint256 Amount) internal view {
267         // solhint-disable-previous-line no-empty-blocks
268     }
269 
270     function _deliverGauf(address beneficiary, uint256 gaufAmount) internal {
271         _gauf.safeTransfer(beneficiary, gaufAmount);
272     }
273 
274     function _processPurchase(address beneficiary, uint256 gaufAmount) internal {
275         _deliverGauf(beneficiary, gaufAmount);
276     }
277     
278     function _updatePurchasingState(address beneficiary, uint256 Amount) internal {
279         // solhint-disable-previous-line no-empty-blocks
280     }
281 
282     function _getLinkRate(uint256 linkAmount) internal view returns (uint256) {
283         return linkAmount.mul(_linkRate);
284     }
285 
286     function _getEthRate(uint256 ethAmount) internal view returns (uint256) {
287         return ethAmount.mul(_ethRate);
288     }
289 
290     function _forwardLinkFunds(uint256 linkAmount) internal {
291         _link.safeTransfer(_wallet, linkAmount);
292     }
293 
294     function _forwardEtherFunds() internal {
295         _wallet.transfer(msg.value);
296     }
297 }
298 
299 contract LimitedUnitsIco is ICO {
300     using SafeMath for uint256;
301 
302     uint256 private _maxGaufUnits;
303 
304     constructor (uint256 maxGaufUnits) public {
305         require(maxGaufUnits > 0, "Max Capitalization shouldn't be Zero");
306         _maxGaufUnits = maxGaufUnits;
307     }
308 
309     function maxGaufUnits() public view returns (uint256) {
310         return _maxGaufUnits;
311     }
312 
313     function icoReached() public view returns (bool) {
314         return gaufDelivered() >= _maxGaufUnits;
315     }
316 
317     function _preValidatePurchase(address beneficiary, uint256 Amount) internal view {
318         super._preValidatePurchase(beneficiary, Amount);
319         require(gaufDelivered().add(Amount) <= _maxGaufUnits, "Max GAUF Units exceeded");
320     }
321 }
322 
323 contract GaufIco is LimitedUnitsIco {
324 
325     uint256 internal constant _hundredMillion = 10 ** 8;
326     uint256 internal constant _oneGauf = 10**18;
327     uint256 internal constant _maxGaufUnits = _hundredMillion * _oneGauf;
328     uint256 internal constant _oneLinkToGauF = 400;
329      uint256 internal constant _oneEthToGauF = 18000;
330     
331     address payable _wallet = 0xB4F53f448DeD6E3394A4EC7a8Dfce44e1a1CE404;
332     ERC20 internal _link = ERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
333     ERC20 internal _gauf = ERC20(0x8Ce7386fe7688417885ADEBCBfc01A5445226b2C);
334 
335     constructor () public
336         ICO(_oneLinkToGauF, _oneEthToGauF, _wallet, _link, _gauf) 
337         LimitedUnitsIco(_maxGaufUnits)
338     {
339 
340     }
341 }