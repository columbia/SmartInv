1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.4;
4 
5 // Interfaces for contract interaction
6 interface INterfaces {
7     function balanceOf(address) external returns (uint256);
8 
9     function transfer(address, uint256) external returns (bool);
10 
11     function transferFrom(
12         address,
13         address,
14         uint256
15     ) external returns (bool);
16 
17     function allowance(address, address) external returns (uint256);
18 
19     //usdc
20     function transferWithAuthorization(
21         address from,
22         address to,
23         uint256 value,
24         uint256 validAfter,
25         uint256 validBefore,
26         bytes32 nonce,
27         uint8 v,
28         bytes32 r,
29         bytes32 s
30     ) external;
31 }
32 
33 // USDT is not ERC-20 compliant, not returning true on transfers
34 interface IUsdt {
35     function transfer(address, uint256) external;
36 
37     function transferFrom(
38         address,
39         address,
40         uint256
41     ) external;
42 }
43 
44 // BigShortBets.com presale contract - via StableCoins and ETH
45 //
46 // USE ONLY OWN WALLET (Metamask, Trezor, Ledger...)
47 // DO NOT SEND FROM EXCHANGES OR ANY SERVICES
48 //
49 // Use ONLY ETH network, ERC20 tokens (Not Binance/Tron/whatever!)
50 //
51 // Set approval to contract address or use USDC authorization first
52 //
53 // DO NOT SEND STABLE TOKENS DIRECTLY - IT WILL NOT COUNT THAT!
54 //
55 // send ONLY round number of USD(c|t)/DAI!
56 // ie 20, 500, 2000 NOT 20.1, 500.5, 2000.3
57 // contract will ignore decimals
58 //
59 // Need 150k gas limit
60 // use proper pay* function
61 contract BigShortBetsPresale2 {
62     // max USD per user
63     uint256 private immutable _maxUsd;
64     // soft limit USD total
65     uint256 private immutable _limitUsd;
66     // max ETH per user
67     uint256 private immutable _maxEth;
68     // soft limit ETH total
69     uint256 private immutable _limitEth;
70     // contract starts accepting transfers
71     uint256 private immutable _dateStart;
72     // hard time limit
73     uint256 private immutable _dateEnd;
74 
75     // total collected USD
76     uint256 private _usdCollected;
77 
78     uint256 private constant DECIMALS_DAI = 18;
79     uint256 private constant DECIMALS_USDC = 6;
80     uint256 private constant DECIMALS_USDT = 6;
81 
82     // addresses of tokens
83     address private immutable usdt;
84     address private immutable usdc;
85     address private immutable dai;
86 
87     address public owner;
88     address public newOwner;
89 
90     bool private _presaleEnded;
91 
92     // deposited per user
93     mapping(address => uint256) private _usdBalance;
94     mapping(address => uint256) private _ethBalance;
95 
96     // deposited per tokens
97     mapping(address => uint256) private _deposited;
98 
99     // will be set after presale
100     uint256 private _tokensPerEth;
101 
102     string private constant ERROR_ANS = "Approval not set!";
103 
104     event AcceptedUSD(address indexed user, uint256 amount);
105     event AcceptedETH(address indexed user, uint256 amount);
106 
107     constructor(
108         address _owner,
109         uint256 maxUsd,
110         uint256 limitUsd,
111         uint256 maxEth,
112         uint256 limitEth,
113         uint256 startDate,
114         uint256 endDate,
115         address _usdt,
116         address _usdc,
117         address _dai
118     ) {
119         owner = _owner;
120         _maxUsd = maxUsd;
121         _limitUsd = limitUsd;
122         _maxEth = maxEth;
123         _limitEth = limitEth;
124         _dateStart = startDate;
125         _dateEnd = endDate;
126         usdt = _usdt;
127         usdc = _usdc;
128         dai = _dai;
129 
130         /**
131         mainnet:
132         usdt=0xdAC17F958D2ee523a2206206994597C13D831ec7;
133         usdc=0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
134         dai=0x6B175474E89094C44Da98b954EedeAC495271d0F;
135         */
136     }
137 
138     //pay in using USDC
139     //need prepare and sign approval first
140     //not included in dapp
141     function payUsdcByAuthorization(
142         address from,
143         address to,
144         uint256 value,
145         uint256 validAfter,
146         uint256 validBefore,
147         bytes32 nonce,
148         uint8 v,
149         bytes32 r,
150         bytes32 s
151     ) external {
152         require(to == address(this), "Wrong authorization address");
153         // should throw on any error
154         INterfaces(usdc).transferWithAuthorization(
155             from,
156             to,
157             value,
158             validAfter,
159             validBefore,
160             nonce,
161             v,
162             r,
163             s
164         );
165         // not msg.sender, approval can be sent by anyone
166         _pay(from, value, DECIMALS_USDC);
167         _deposited[usdc] += value;
168     }
169 
170     //pay in using USDC
171     //use approve/transferFrom
172     function payUSDC(uint256 amount) external {
173         require(
174             INterfaces(usdc).allowance(msg.sender, address(this)) >= amount,
175             ERROR_ANS
176         );
177         require(
178             INterfaces(usdc).transferFrom(msg.sender, address(this), amount),
179             "USDC transfer failed"
180         );
181         _pay(msg.sender, amount, DECIMALS_USDC);
182         _deposited[usdc] += amount;
183     }
184 
185     //pay in using USDT
186     //need set approval first
187     function payUSDT(uint256 amount) external {
188         require(
189             INterfaces(usdt).allowance(msg.sender, address(this)) >= amount,
190             ERROR_ANS
191         );
192         IUsdt(usdt).transferFrom(msg.sender, address(this), amount);
193         _pay(msg.sender, amount, DECIMALS_USDT);
194         _deposited[usdt] += amount;
195     }
196 
197     //pay in using DAI
198     //need set approval first
199     function payDAI(uint256 amount) external {
200         require(
201             INterfaces(dai).allowance(msg.sender, address(this)) >= amount,
202             ERROR_ANS
203         );
204         require(
205             INterfaces(dai).transferFrom(msg.sender, address(this), amount),
206             "DAI transfer failed"
207         );
208         _pay(msg.sender, amount, DECIMALS_DAI);
209         _deposited[dai] += amount;
210     }
211 
212     //direct ETH send will not back
213     //
214     //accept ETH
215 
216     // takes about 50k gas
217     receive() external payable {
218         _payEth(msg.sender, msg.value);
219     }
220 
221     // takes about 35k gas
222     function payETH() external payable {
223         _payEth(msg.sender, msg.value);
224     }
225 
226     function _payEth(address user, uint256 amount) internal notEnded {
227         uint256 amt = _ethBalance[user] + amount;
228         require(amt <= _maxEth, "ETH per user reached");
229         _ethBalance[user] += amt;
230         emit AcceptedETH(user, amount);
231     }
232 
233     function _pay(
234         address user,
235         uint256 amount,
236         uint256 decimals
237     ) internal notEnded {
238         uint256 usd = amount / (10**decimals);
239         _usdBalance[user] += usd;
240         require(_usdBalance[user] <= _maxUsd, "USD amount too high");
241         _usdCollected += usd;
242         emit AcceptedUSD(user, usd);
243     }
244 
245     //
246     // external readers
247     //
248     function USDcollected() external view returns (uint256) {
249         return _usdCollected;
250     }
251 
252     function ETHcollected() external view returns (uint256) {
253         return address(this).balance;
254     }
255 
256     function USDmax() external view returns (uint256) {
257         return _maxUsd;
258     }
259 
260     function USDlimit() external view returns (uint256) {
261         return _limitUsd;
262     }
263 
264     function ETHmax() external view returns (uint256) {
265         return _maxEth;
266     }
267 
268     function ETHlimit() external view returns (uint256) {
269         return _limitEth;
270     }
271 
272     function dateStart() external view returns (uint256) {
273         return _dateStart;
274     }
275 
276     function dateEnd() external view returns (uint256) {
277         return _dateEnd;
278     }
279 
280     function tokensBoughtOf(address user) external view returns (uint256 amt) {
281         require(_tokensPerEth > 0, "Tokens/ETH ratio not set yet");
282         amt = (_usdBalance[user] * 95) / 100;
283         amt += _ethBalance[user] * _tokensPerEth;
284         return amt;
285     }
286 
287     function usdDepositOf(address user) external view returns (uint256) {
288         return _usdBalance[user];
289     }
290 
291     function ethDepositOf(address user) external view returns (uint256) {
292         return _ethBalance[user];
293     }
294 
295     modifier notEnded() {
296         require(!_presaleEnded, "Presale ended");
297         require(
298             block.timestamp > _dateStart && block.timestamp < _dateEnd,
299             "Too soon or too late"
300         );
301         _;
302     }
303 
304     modifier onlyOwner() {
305         require(msg.sender == owner, "Only for contract Owner");
306         _;
307     }
308 
309     modifier timeIsUp() {
310         require(block.timestamp > _dateEnd, "SOON");
311         _;
312     }
313 
314     function endPresale() external onlyOwner {
315         require(
316             _usdCollected > _limitUsd || address(this).balance > _limitEth,
317             "Limit not reached"
318         );
319         _presaleEnded = true;
320     }
321 
322     function setTokensPerEth(uint256 ratio) external onlyOwner {
323         require(_tokensPerEth == 0, "Ratio already set");
324         _tokensPerEth = ratio;
325     }
326 
327     // take out all stables and ETH
328     function takeAll() external onlyOwner timeIsUp {
329         _presaleEnded = true; //just to save gas for ppl that want buy too late
330         uint256 amt = INterfaces(usdt).balanceOf(address(this));
331         if (amt > 0) {
332             IUsdt(usdt).transfer(owner, amt);
333         }
334         amt = INterfaces(usdc).balanceOf(address(this));
335         if (amt > 0) {
336             INterfaces(usdc).transfer(owner, amt);
337         }
338         amt = INterfaces(dai).balanceOf(address(this));
339         if (amt > 0) {
340             INterfaces(dai).transfer(owner, amt);
341         }
342         amt = address(this).balance;
343         if (amt > 0) {
344             payable(owner).transfer(amt);
345         }
346     }
347 
348     // we can recover any ERC20 token send in wrong way... for price!
349     function recoverErc20(address token) external onlyOwner {
350         uint256 amt = INterfaces(token).balanceOf(address(this));
351         // do not take deposits
352         amt -= _deposited[token];
353         if (amt > 0) {
354             INterfaces(token).transfer(owner, amt);
355         }
356     }
357 
358     // should not be needed, but...
359     function recoverEth() external onlyOwner timeIsUp {
360         payable(owner).transfer(address(this).balance);
361     }
362 
363     function changeOwner(address _newOwner) external onlyOwner {
364         newOwner = _newOwner;
365     }
366 
367     function acceptOwnership() external {
368         require(
369             msg.sender != address(0) && msg.sender == newOwner,
370             "Only NewOwner"
371         );
372         newOwner = address(0);
373         owner = msg.sender;
374     }
375 }
376 
377 // rav3n_pl was here