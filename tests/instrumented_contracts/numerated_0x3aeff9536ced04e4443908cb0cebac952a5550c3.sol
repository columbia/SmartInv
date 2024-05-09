1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-24
3  */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.21;
7 
8 //        |-----------------------------------------------------------------------------------------------------------|
9 //        |                                                                        %################.                 |
10 //        |                                                                       #####################@              |
11 //        |                                                         |           ######    @#####    &####             |
12 //        |                                                         |           ###%        ,         ###%            |
13 //        |                                                         |          &###,  /&@@     @(@@   ####            |
14 //        |                                                         |           ###@       &..%      *####            |
15 //        |  $$$$$$$\  $$$$$$$$\ $$\   $$\  $$$$$$\ $$\     $$\     |           @####     .,,,,@    #####             |
16 //        |  $$  __$$\ $$  _____|$$$\  $$ |$$  __$$\\$$\   $$  |    |            %##(       ,*      @##(@             |
17 //        |  $$ |  $$ |$$ |      $$$$\ $$ |$$ /  \__|\$$\ $$  /     |        /#&##@                    ##&#&          |
18 //        |  $$$$$$$  |$$$$$\    $$ $$\$$ |$$ |$$$$\  \$$$$  /      |       ######                        #(###       |
19 //        |  $$  ____/ $$  __|   $$ \$$$$ |$$ |\_$$ |  \$$  /       |    #######                          ######.     |
20 //        |  $$ |      $$ |      $$ |\$$$ |$$ |  $$ |   $$ |        |  &#######@                          ##(#####    |
21 //        |  $$ |      $$$$$$$$\ $$ | \$$ |\$$$$$$  |   $$ |        |        ###                           &##        |
22 //        |  \__|      \________|\__|  \__| \______/    \__|        |        &##%                          ###        |
23 //        |                                                         |         %###                        @##@        |
24 //        |                                                         |           %###@                  &###&          |
25 //        |                                                                    &,,,,,&################@,,,,,%         |
26 //        |                                                                  ,.,,,.*%@               /(.,,,,/@        |
27 //        |-----------------------------------------------------------------------------------------------------------|
28 //                                -----> Ken and the community makes penguins fly! 🚀  <-----     */
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32 
33     function decimals() external view returns (uint8);
34 
35     function symbol() external view returns (string memory);
36 
37     function name() external view returns (string memory);
38 
39     function balanceOf(address account) external view returns (uint256);
40 
41     function transfer(
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     function allowance(
47         address _owner,
48         address spender
49     ) external view returns (uint256);
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     function transferFrom(
54         address sender,
55         address recipient,
56         uint256 amount
57     ) external returns (bool);
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(
61         address indexed owner,
62         address indexed spender,
63         uint256 value
64     );
65 }
66 
67 interface IDEXRouter {
68     function factory() external pure returns (address);
69 
70     function WETH() external pure returns (address);
71 
72     function swapExactTokensForETHSupportingFeeOnTransferTokens(
73         uint amountIn,
74         uint amountOutMin,
75         address[] calldata path,
76         address to,
77         uint deadline
78     ) external;
79 }
80 
81 interface IDEXFactory {
82     function createPair(
83         address tokenA,
84         address tokenB
85     ) external returns (address pair);
86 }
87 
88 contract PengyX is IERC20 {
89     string private _name;
90     string private _symbol;
91     uint8 private constant _decimals = 18;
92     uint256 private _totalSupply;
93 
94     mapping(address => bool) public isExcludedFromFees;
95     mapping(address => uint256) private _balances;
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     mapping(address => bool) public isBlacklisted;
99 
100     uint64 public autoBlacklistAddressCounter = 0;
101     uint64 public autoBlacklistAddressLimit = 25;
102 
103     address public owner;
104     address public constant feeWallet = 0x70fc94190723bACC4Bb80A11039D8c098aE6C355;
105     address public constant liqWallet = 0x88ebA82a850321fe5a0618aaD874828afB6DB775;
106     address public constant cexWallet = 0xEe2ff4932cEc4FD5B3Cffea7305C44feA579b315;
107     address public constant airdropWallet = 0xB803b0E5E7457B135085E896FD7A3398b266cd43;
108     address public immutable pair;
109     address public immutable router;
110     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
111     address public immutable WETH;
112 
113     bool private isSwapping;
114 
115     modifier onlyDeployer() {
116         require(msg.sender == owner, "Only the owner can do that");
117         _;
118     }
119 
120     event AddressAutoBlacklisted(address indexed buyer);
121     event BlacklistedAddressStatusChanged(
122         address indexed blacklistedAddress,
123         bool status
124     );
125 
126     constructor() {
127         owner = msg.sender;
128         _name = "PENGYX";
129         _symbol = "PENGYX";
130         _totalSupply = 3_000_000_000 * (10 ** _decimals);
131         router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap V2 router
132 
133         WETH = IDEXRouter(router).WETH();
134 
135         pair = IDEXFactory(IDEXRouter(router).factory()).createPair(
136             address(this),
137             WETH
138         );
139 
140         isExcludedFromFees[owner] = true;
141         isExcludedFromFees[liqWallet] = true;
142         isExcludedFromFees[cexWallet] = true;
143         isExcludedFromFees[airdropWallet] = true;
144 
145         _balances[owner] = _totalSupply;
146         emit Transfer(address(0), owner, _totalSupply);
147     }
148 
149     receive() external payable {}
150 
151     function name() public view override returns (string memory) {
152         return _name;
153     }
154 
155     function totalSupply() public view override returns (uint256) {
156         return _totalSupply - _balances[DEAD];
157     }
158 
159     function decimals() public pure override returns (uint8) {
160         return _decimals;
161     }
162 
163     function symbol() public view override returns (string memory) {
164         return _symbol;
165     }
166 
167     function balanceOf(address account) public view override returns (uint256) {
168         return _balances[account];
169     }
170 
171     function rescueEth(uint256 amount) external onlyDeployer {
172         (bool success, ) = address(owner).call{value: amount}("");
173         success = true;
174     }
175 
176     // If the limit is not reached, automatically add this address to the blacklist
177     function autoBlacklistBuyerIfNeeded(address buyer) internal {
178         // Prevent these addresses from being blacklisted
179         if (buyer == owner || buyer == pair || buyer == router) return;
180 
181         if (
182             autoBlacklistAddressCounter < autoBlacklistAddressLimit &&
183             !isBlacklisted[buyer]
184         ) {
185             autoBlacklistAddressCounter++;
186             isBlacklisted[buyer] = true;
187 
188             emit AddressAutoBlacklisted(buyer);
189         }
190     }
191 
192     function changeBlacklistedAddressStatus(
193         address blacklistedAddress,
194         bool status
195     ) external onlyDeployer {
196         isBlacklisted[blacklistedAddress] = status;
197 
198         emit BlacklistedAddressStatusChanged(blacklistedAddress, status);
199     }
200 
201     function swapAllContractTokensForEth() internal {
202         address[] memory path = new address[](2);
203         path[0] = address(this);
204         path[1] = WETH;
205 
206         uint256 tokenAmount = _balances[address(this)];
207 
208         if (tokenAmount > 0) {
209             _allowances[address(this)][router] += tokenAmount;
210             // Swap all the PENGY balance to ETH
211             IDEXRouter(router)
212                 .swapExactTokensForETHSupportingFeeOnTransferTokens(
213                     tokenAmount,
214                     0,
215                     path,
216                     feeWallet,
217                     block.timestamp
218                 );
219         }
220     }
221 
222     function rescueToken(address token, uint256 amount) external onlyDeployer {
223         IERC20(token).transfer(owner, amount);
224     }
225 
226     function allowance(
227         address holder,
228         address spender
229     ) public view override returns (uint256) {
230         return _allowances[holder][spender];
231     }
232 
233     function transfer(
234         address recipient,
235         uint256 amount
236     ) external override returns (bool) {
237         return _transferFrom(msg.sender, recipient, amount);
238     }
239 
240     function approveMax(address spender) public returns (bool) {
241         return approve(spender, type(uint256).max);
242     }
243 
244     function approve(
245         address spender,
246         uint256 amount
247     ) public override returns (bool) {
248         require(spender != address(0), "NO_ZERO");
249         _allowances[msg.sender][spender] = amount;
250         emit Approval(msg.sender, spender, amount);
251         return true;
252     }
253 
254     function increaseAllowance(
255         address spender,
256         uint256 addedValue
257     ) public returns (bool) {
258         require(spender != address(0), "NO_ZERO");
259         _allowances[msg.sender][spender] =
260             allowance(msg.sender, spender) +
261             addedValue;
262         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
263         return true;
264     }
265 
266     function decreaseAllowance(
267         address spender,
268         uint256 subtractedValue
269     ) public returns (bool) {
270         require(spender != address(0), "NO_ZERO");
271         require(
272             allowance(msg.sender, spender) >= subtractedValue,
273             "INSUFF_ALLOWANCE"
274         );
275         _allowances[msg.sender][spender] =
276             allowance(msg.sender, spender) -
277             subtractedValue;
278         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
279         return true;
280     }
281 
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) external override returns (bool) {
287         if (_allowances[sender][msg.sender] != type(uint256).max) {
288             require(
289                 _allowances[sender][msg.sender] >= amount,
290                 "INSUFF_ALLOWANCE"
291             );
292             _allowances[sender][msg.sender] -= amount;
293             emit Approval(sender, msg.sender, _allowances[sender][msg.sender]);
294         }
295         return _transferFrom(sender, recipient, amount);
296     }
297 
298     function _transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) internal returns (bool) {
303         // Prevent a blacklisted wallet from buying/selling/transfering
304         require(!isBlacklisted[sender], "BLACKLISTED");
305 
306         // If it's a buy, check if should automatically blacklist the buyer
307         if (sender == pair) {
308             autoBlacklistBuyerIfNeeded(recipient);
309         }
310 
311         if (!checkTaxFree(sender, recipient)) {
312             _lowGasTransfer(sender, address(this), amount / 100);
313             amount = (amount * 99) / 100;
314         }
315 
316         if (!isSwapping && sender != pair) {
317             isSwapping = true;
318             swapAllContractTokensForEth();
319             isSwapping = false;
320         }
321 
322         return _lowGasTransfer(sender, recipient, amount);
323     }
324 
325     function checkTaxFree(
326         address sender,
327         address recipient
328     ) internal view returns (bool) {
329         if (isSwapping) return true;
330         if (isExcludedFromFees[sender] || isExcludedFromFees[recipient])
331             return true;
332         if (sender == pair || recipient == pair) return false;
333         return true;
334     }
335 
336     function _lowGasTransfer(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) internal returns (bool) {
341         require(sender != address(0), "Can't use zero addresses here");
342         require(
343             amount <= _balances[sender],
344             "Can't transfer more than you own"
345         );
346         if (amount == 0) return true;
347         _balances[sender] -= amount;
348         _balances[recipient] += amount;
349         emit Transfer(sender, recipient, amount);
350         return true;
351     }
352 
353     function excludeFromFees(
354         address excludedWallet,
355         bool status
356     ) external onlyDeployer {
357         isExcludedFromFees[excludedWallet] = status;
358     }
359 
360     function renounceOwnership() external onlyDeployer {
361         owner = address(0);
362     }
363 }
364 
365 /*
366 
367 The topics and opinions discussed by Ken the Crypto and the PENGY community are intended to convey general information only. All opinions expressed by Ken or the community should be treated as such.
368 
369 This contract does not provide legal, investment, financial, tax, or any other type of similar advice.
370 
371 As with all alternative currencies, Do Your Own Research (DYOR) before purchasing. Ken and the rest of the PENGY community are working to increase coin adoption, but no individual or community shall be held responsible for any financial losses or gains that may be incurred as a result of trading PENGY.
372 
373 If you’re with us — Hop In, We’re Going Places 🚀
374 
375 */