1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22 
23     function sub(
24         uint256 a,
25         uint256 b,
26         string memory errorMessage
27     ) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41 
42         return c;
43     }
44 
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48 
49     function div(
50         uint256 a,
51         uint256 b,
52         string memory errorMessage
53     ) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57 
58         return c;
59     }
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     constructor() {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(
92             newOwner != address(0),
93             "Ownable: new owner is the zero address"
94         );
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 abstract contract IERC20 {
101     function decimals() external view virtual returns (uint8);
102 
103     function name() external view virtual returns (string memory);
104 
105     function symbol() external view virtual returns (string memory);
106 }
107 
108 library TransferHelper {
109     function safeApprove(
110         address token,
111         address to,
112         uint256 value
113     ) internal {
114         (bool success, bytes memory data) = token.call(
115             abi.encodeWithSelector(0x095ea7b3, to, value)
116         );
117         require(
118             success && (data.length == 0 || abi.decode(data, (bool))),
119             "TransferHelper: APPROVE_FAILED"
120         );
121     }
122 
123     function safeTransfer(
124         address token,
125         address to,
126         uint256 value
127     ) internal {
128         (bool success, bytes memory data) = token.call(
129             abi.encodeWithSelector(0xa9059cbb, to, value)
130         );
131         require(
132             success && (data.length == 0 || abi.decode(data, (bool))),
133             "TransferHelper: TRANSFER_FAILED"
134         );
135     }
136 
137     function safeTransferFrom(
138         address token,
139         address from,
140         address to,
141         uint256 value
142     ) internal {
143         (bool success, bytes memory data) = token.call(
144             abi.encodeWithSelector(0x23b872dd, from, to, value)
145         );
146         require(
147             success && (data.length == 0 || abi.decode(data, (bool))),
148             "TransferHelper: TRANSFER_FROM_FAILED"
149         );
150     }
151 
152     function safeTransferETH(address to, uint256 value) internal {
153         (bool success, ) = to.call{value: value}(new bytes(0));
154         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
155     }
156 }
157 
158 contract BridgeEternaETH is Context, Ownable {
159     using SafeMath for uint256;
160 
161     mapping(uint256 => uint256) private _nonces;
162     mapping(uint256 => mapping(uint256 => bool)) private nonceProcessed;
163     mapping(uint256 => uint256) private _processedFees;
164     mapping(address => bool) public _isExcludedFromFees;
165     
166     uint256 private _bridgeFee = 3;
167     bool public _isBridgingPaused = false;
168 
169 
170     address public eterna;
171     address public system = address(0xbC31F1D71625096BaD94d811AE4AF7EcB7B7097F);
172     address public governor = address(0xd070544810510865114Ad5A0b6a821A5BD2E7C49);
173     address public bridgeFeesAddress = address(0xD378dBeD86689D0dBA19Ca2bab322B6f23765288);
174 
175     event SwapRequest(
176         address indexed to,
177         uint256 amount,
178         uint256 nonce,
179         uint256 toChainID
180     );
181     
182 
183     modifier onlySystem() {
184         require(system == _msgSender(), "Ownable: caller is not the system");
185         _;
186     }
187     
188     modifier onlyGovernance() {
189         require(governor == _msgSender(), "Ownable: caller is not the system");
190         _;
191     }
192 
193     modifier bridgingPaused() {
194         require(!_isBridgingPaused, "the bridging is paused");
195         _;
196     }
197 
198     constructor() {
199         _processedFees[56] = 0.0005 ether;
200     }
201 
202 
203     function updateEternaContract(address _eterna) external onlyOwner {
204        eterna = _eterna;
205    }
206    
207    function excludeFromFees(address account, bool exclude) external onlyGovernance {
208        _isExcludedFromFees[account] = exclude;
209    }
210 
211     function setBridgeFee(uint256 bridgeFee) external onlyGovernance returns (bool) {
212         require(bridgeFee > 0, "Invalid Percentage");
213         _bridgeFee = bridgeFee;
214         return true;
215     }
216     
217     function changeGovernor(address _governor) external onlyGovernance {
218         governor = _governor;
219     }
220     
221 
222     function getBridgeFee() external view returns (uint256) {
223         return _bridgeFee;
224     }
225     
226     function setBridgeFeesAddress(address _bridgeFeesAddress) external onlyGovernance {
227         bridgeFeesAddress = _bridgeFeesAddress;
228     }
229 
230     function setSystem(address _system) external onlyOwner returns (bool) {
231         system = _system;
232         return true;
233     }
234 
235 
236     function setProcessedFess(uint256 chainID, uint256 processedFees)
237         external
238         onlyOwner
239     {
240         _processedFees[chainID] = processedFees;
241     }
242     
243     function getProcessedFees(uint256 chainID) external view returns(uint256){
244         return _processedFees[chainID];
245     }
246 
247     function getBridgeStatus(uint256 nonce, uint256 fromChainID)
248         external
249         view
250         returns (bool)
251     {
252         return nonceProcessed[fromChainID][nonce];
253     }
254 
255 
256     function updateBridgingStaus(bool paused) external onlyOwner {
257         _isBridgingPaused = paused;
258     }
259 
260 
261 
262     function swap(uint256 amount, uint256 toChainID)
263         external
264         payable
265         bridgingPaused
266     {
267         require(
268             msg.value >= _processedFees[toChainID],
269             "Insufficient processed fees"
270         );
271         uint256 _nonce = _nonces[toChainID];
272         _nonce = _nonce.add(1);
273         _nonces[toChainID] = _nonce;
274         TransferHelper.safeTransferFrom(
275             eterna,
276             _msgSender(),
277             address(this),
278             amount
279         );
280         payable(system).transfer(msg.value);
281         emit SwapRequest(_msgSender(), amount, _nonce, toChainID);
282     }
283 
284     function feeCalculation(uint256 amount) public view returns (uint256) {
285         uint256 _amountAfterFee = (amount - (amount.mul(_bridgeFee) / 1000));
286         return _amountAfterFee;
287     }
288 
289     function swapBack(
290         address to,
291         uint256 amount,
292         uint256 nonce,
293         uint256 fromChainID
294     ) external onlySystem {
295         require(
296             !nonceProcessed[fromChainID][nonce],
297             "Swap is already proceeds"
298         );
299         nonceProcessed[fromChainID][nonce] = true;
300 
301         uint256 temp;
302         if(_isExcludedFromFees[to]){
303             temp = amount;
304         } else {
305             temp = feeCalculation(amount);
306         }
307         uint256 fees = amount.sub(temp);
308 
309        if(fees > 0) {
310             TransferHelper.safeTransfer(eterna, bridgeFeesAddress, fees);
311        }
312        
313         TransferHelper.safeTransfer(eterna, to, temp);
314     }
315 
316     function withdrawTokens(address token, uint256 amount, address to) external onlyOwner {
317         TransferHelper.safeTransfer(token, to, amount);
318     }
319 }