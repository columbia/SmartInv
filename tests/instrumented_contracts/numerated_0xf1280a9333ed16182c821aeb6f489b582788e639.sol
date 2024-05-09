1 /*****************************
2 
3 ** PROOF UTILITY TOKEN (PRF) **
4    Developed by @cryptocreater
5    Produced by PROOF CAPITAL GROUP
6 
7 ** TOKEN INFO **
8    Name:     PROOF UTILITY
9    Code:     PRF
10    Decimals: 6
11 
12 ** PRF TOKEN MARKETING **
13     1. The maximum emission of the PROOF UTILITY token is 1 000 000 000 PRF.
14     2. Initial emission of PROOF UTILITY token to replace PROOF TOKEN - 350 000 PRF.
15     3. Renumeration for the founders of the PRF (bounty) - 1% of the total emission of PRF (accrued as the release of PRF tokens).
16     4. The minimum balance to receive a staking profit is 10 PRF.
17     5. The maximum balance for receiving staking profit is 999 999 PRF.
18     6. The profit for holding the token, depending on the balance, per 1 day is: from 10 PRF - 0.10%, from 100 PRF - 0.13%, from 500 PRF - 0.17%, from 1 000 PRF - 0.22%, from 5 000 PRF - 0.28%, from 10 000 PRF - 0.35%, from 50 000 PRF - 0.43%, from 100 000 PRF - 0.52%, from 500 000 PRF - 0.62% and is fixed per second for each transaction at the address, excluding the PROOF ASSET smart contract profit, which receives a reward of 0.62% regardless of the amount of the balance.
19     7. When transferring PRF to an address that has not previously received PRF tokens, this address becomes a follower (referral) of the address from which the PRFs were received (referrer).
20     8. When calculating a profit for a referral, the referrer receives a referral reward from the amount received by the referral for holding the PRF token.
21     9. The minimum balance to receive a referral reward is 100 PRF.
22    10. The maximum balance for receiving a referral reward is 1 000 000 PRF.
23    11. Referral reward is calculated from the amount of the referral profit and depends on the referrer balance: from 100 PRF - 5.2%, from 1 000 PRF - 7.5%, from 10 000 PRF - 12.8%, from 100 000 PRF - 26.5%.
24    12. When calculating all types of profits and rewards, the rule of complication applies, which reduces the income by the percentage of the current supply of the PRF token to it's maximum supply.
25 
26 ** PRF TOKEN MECHANICS **
27    1. To receive PRF tokens, you need to send the required number of ETH tokens to the address of the PROOF UTILITY smart contract.
28    2. The smart contract issues the required number of PRF tokens to the address from which the ETH tokens came according to the average exchange rate of the UNISWAP exchange in the equivalent of ETH to stable coins equivalent to the equivalent of 1 USD.
29    3. To fix the reward and withdraw it to the address, it is necessary to send a zero transaction (0 PRF or 0 ETH) from the address to itself.
30    4. To bind a follower (referral), you need to send any number of PRF tokens to its address. The referral will be linked only if he has not previously been linked to another address.
31    5. The administrator of the smart contract can, without warning and at his own discretion, stop and start the exchange of ETH for PRF on the smart contract, while the process of calculating rewards and profits for existing tokens does not stop.
32    6. To exchange PRF for a PRS token, send PRF to the PROOF ASSET smart contract address to register the exchange and wait for submission of this operation, then send 0 (zero) ETH to the PROOF ASSET smart contract address from the same address to credit PRS tokens to it.
33    7. The initial minimum amount of exchanging a PRF token for a PRS token is 1 (one) PRS or 1 000 (one thousand) PRF and can be reduced without warning and at the discretion of the administrator of the PROOF UTILITY smart contract without the possibility of further increase.
34    8. The administrator of the smart contract can, without warning and at his discretion, raise and lower the exchange rate multiply of ETH tokens for PRF tokens, but not less than 1 PRF to the equivalent of 1 USD.
35 
36 *****************************/
37 
38 pragma solidity 0.6.6;
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 amount);
47     event Approval(address indexed owner, address indexed spender, uint256 amount);
48     event Swap(address indexed account, uint256 amount);
49     event Swaped(address indexed account, uint256 amount);
50 }
51 interface EthRateInterface {
52     function EthToUsdRate() external view returns(uint256);
53 }
54 library SafeMath {
55     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(a + b >= a, "Addition overflow");
57         return a + b;
58     }
59     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(a >= b, "Substruction overflow");
61         return a - b;
62     }  
63 }
64 contract ERC20 is IERC20 {
65     using SafeMath for uint256;
66     mapping (address => uint256) private _balances;    
67     mapping (address => uint256) private _sto;
68     mapping (address => mapping (address => uint256)) private _allowances;
69     uint256 private _totalSupply;
70     string private _name = "PROOF UTILITY";
71     string private _symbol = "PRF";
72     uint8 private _decimals = 6;
73     function name() public view returns (string memory) { return _name; }    
74     function symbol() public view returns (string memory) { return _symbol; }    
75     function decimals() public view returns (uint8) { return _decimals; }
76     function totalSupply() public view override returns (uint256) { return _totalSupply; }
77     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
78     function swapOf(address account) public view returns (uint256) { return _sto[account]; }
79     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
80         _transfer(msg.sender, recipient, amount);
81         return true;
82     }
83     function allowance(address owner, address spender) public view virtual override returns (uint256) { return _allowances[owner][spender]; }
84     function approve(address spender, uint256 amount) public virtual override returns (bool) {
85         _approve(msg.sender, spender, amount);
86         return true;
87     }
88     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
89         _transfer(sender, recipient, amount);
90         _afterTransferFrom(sender, recipient, amount);
91         _approve(sender, msg.sender, _allowances[sender][msg.sender].safeSub(amount));
92         return true;
93     }
94     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
95         _approve(msg.sender, spender, _allowances[msg.sender][spender].safeAdd(addedValue));
96         return true;
97     }
98     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
99         _approve(msg.sender, spender, _allowances[msg.sender][spender].safeSub(subtractedValue));
100         return true;
101     }
102     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
103         require(sender != address(0), "Zero address");
104         require(recipient != address(0), "Zero address");
105         _beforeTokenTransfer(sender, recipient, amount);
106         _balances[sender] = _balances[sender].safeSub(amount);
107         _balances[recipient] = _balances[recipient].safeAdd(amount);
108         emit Transfer(sender, recipient, amount);
109     }
110     function _mint(address account, uint256 amount) internal virtual {
111         require(account != address(0), "Zero account");
112         _beforeTokenTransfer(address(0), account, amount);
113         _totalSupply = _totalSupply.safeAdd(amount);
114         _balances[account] = _balances[account].safeAdd(amount);
115         emit Transfer(address(0), account, amount);
116     }
117     function _burn(address account, uint256 amount) internal virtual {
118         require(account != address(0), "Zero account");
119         _beforeTokenTransfer(account, address(0), amount);
120         _balances[account] = _balances[account].safeSub(amount);
121         _totalSupply = _totalSupply.safeSub(amount);
122         emit Transfer(account, address(0), amount);
123     }
124     function _approve(address owner, address spender, uint256 amount) internal virtual {
125         require(owner != address(0), "Zero owner");
126         require(spender != address(0), "Zero spender");
127         _allowances[owner][spender] = amount;
128         emit Approval(owner, spender, amount);
129     }
130     function _swap(address account, uint256 amount) internal virtual {
131         require (amount > 0, "Zero amount");
132         _sto[account] = _sto[account].safeAdd(amount);
133         emit Swap(account, amount);
134     }
135     function _swaped(address account, uint256 amount) internal virtual {
136         _sto[account] = _sto[account].safeSub(amount);
137         emit Swaped(account, amount);
138     }
139     function _setupDecimals(uint8 decimals_) internal {
140         _decimals = decimals_;
141     }
142     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }    
143     function _afterTransferFrom(address sender, address recipient, uint256 amount) internal virtual { }
144 }
145 contract ProofUtilityToken is ERC20 {
146     using SafeMath for uint256;
147     bool public sales = true;
148     address private insurance;
149     address private smart;
150     address public stoContract = address(0);
151     address[] private founders;
152     mapping(address => address) private referrers;
153     mapping(address => uint64) private fixes;
154     mapping(address => uint256) private holds;
155     uint256 public multiply = 100;
156     uint256 public minimum = 1e9;
157     uint256 private bounted = 35e12;
158     EthRateInterface public EthRateSource = EthRateInterface(0xf1401D5493D257cb7FECE1309B221e186c5b69f9);
159     event Payout(address indexed account, uint256 amount);
160     event CheckIn(address indexed account, uint256 amount, uint256 value);
161     event Profit(address indexed account, uint256 amount);
162     event Reward(address indexed account, uint256 amount);
163     event NewMultiply(uint256 value);
164     event NewMinimum(uint256 value);
165     modifier onlyFounders() {
166         for(uint256 i = 0; i < founders.length; i++) {
167             if(founders[i] == msg.sender) {
168                 _;
169                 return;
170             }
171         }
172         revert("Access denied");
173     }
174     constructor() public {
175         smart = address(this);
176         referrers[smart] = smart;
177         insurance = 0x4141a692Ae0b49Ed22e961526755B8CC9Aa65139;
178         referrers[0x4141a692Ae0b49Ed22e961526755B8CC9Aa65139] = smart;
179         founders.push(0x30517CaE41977fc9d4a21e2423b7D5Ce8D19d0cb);
180         referrers[0x30517CaE41977fc9d4a21e2423b7D5Ce8D19d0cb] = smart;
181         founders.push(0x2589171E72A4aaa7b0e7Cc493DB6db7e32aC97d4);
182         referrers[0x2589171E72A4aaa7b0e7Cc493DB6db7e32aC97d4] = smart;
183         founders.push(0x3d027e252A275650643cE83934f492B6914D3341);
184         referrers[0x3d027e252A275650643cE83934f492B6914D3341] = smart;
185         referrers[0x7c726AC69461e772F975c3212Db5d7cb57352CA2] = smart;
186         _mint(0x7c726AC69461e772F975c3212Db5d7cb57352CA2, 35e10);
187     }
188     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
189         if(from != address(0)) {
190             if(to == stoContract) {
191                 require(amount >= minimum, "Little amount");
192                 _swap(from, amount);
193             }
194             if(referrers[to] == address(0) && amount > 0) referrers[to] = from;
195         }
196         uint256 _supply = totalSupply();
197         if(from == to) {
198             _payout(from, _supply);
199         } else {
200             if(_supply < 1e15) {
201                 if(from != address(0)) {
202                     uint256 _profit = _fixProfit(from, _supply);
203                     if(_profit > 0) _fixReward(referrers[from], _profit, _supply);
204                 }
205                 if(to != address(0)) {
206                     if(fixes[to] > 0) {
207                         uint256 _profit = _fixProfit(to, _supply);
208                         if(_profit > 0) _fixReward(referrers[to], _profit, _supply);
209                     } else fixes[to] = uint64(block.timestamp);
210                 }
211             }
212         }
213     }
214     function _afterTransferFrom(address sender, address recipient, uint256 amount) internal override { if(recipient == stoContract) _swaped(sender, amount); }
215     function _fixProfit(address account, uint256 supply) private returns(uint256 _value) {
216         uint256 _balance = balanceOf(account);
217         uint256 _hold = block.timestamp - fixes[account];
218         uint256 _percent;
219         _value = 0;
220         if(_hold > 0) {
221             if(_balance > 1e7) {
222                 if(account == stoContract) _percent = 62;
223                 else if(_balance < 1e8) _percent = 10;
224                 else if(_balance < 5e8) _percent = 13;
225                 else if(_balance < 1e9) _percent = 17;
226                 else if(_balance < 5e9) _percent = 22;
227                 else if(_balance < 1e10) _percent = 28;
228                 else if(_balance < 5e10) _percent = 35;
229                 else if(_balance < 1e11) _percent = 43;
230                 else if(_balance < 5e11) _percent = 52;
231                 else if(_balance < 1e12) _percent = 62;
232                 else _percent = 0;
233                 if(_percent > 0) {
234                     _value = _hold * _balance * _percent / 864 / 1e6;
235                     uint256 tax = _value * supply / 1e15;
236                     _value = _value.safeSub(tax);
237                     holds[account] = holds[account].safeAdd(_value);
238                     fixes[account] = uint64(block.timestamp);
239                     emit Profit(account, _value);
240                 }
241             }
242         }        
243     }
244     function _fixReward(address referrer, uint256 amount, uint256 supply) private returns(uint256 _value) {
245         uint256 _balance = balanceOf(referrer);
246         uint256 _percent;
247         if(_balance >= 1e8 && _balance < 1e12) {
248             if (_balance < 1e9) _percent = 520;
249             else if(_balance < 1e10) _percent = 750;
250             else if(_balance < 1e11) _percent = 1280;
251             else _percent = 2650;
252             _value = amount * _percent / 10000;
253             uint256 tax = _value * supply / 1e15;
254             _value = _value.safeSub(tax);
255             holds[referrer] = holds[referrer].safeAdd(_value);
256             emit Reward(referrer, _value);
257         }
258     }
259     function _payout(address account, uint256 supply) private {
260         require(supply < 1e15, "Emition is closed");
261         uint256 _profit = _fixProfit(account, supply);
262         if(_profit > 0) _fixReward(referrers[account], _profit, supply);
263         uint256 _userProfit = holds[account];
264         _userProfit = supply + _userProfit > 1e15 ? 1e15 - supply : _userProfit;
265         if(_userProfit > 0) {
266             holds[account] = 0;
267             _mint(account, _userProfit);
268             emit Payout(account, _userProfit);
269         }
270     }
271     receive() payable external {
272         uint256 _supply = totalSupply();
273         require(_supply < 1e15, "Sale finished");
274         if(msg.value > 0) {
275             require(sales, "Sale deactivated");
276             if(referrers[msg.sender] == address(0)) referrers[msg.sender] = smart;
277             uint256 _rate = EthRateSource.EthToUsdRate();
278             require(_rate > 0, "Rate error");
279             uint256 _amount = msg.value * _rate * 100 / multiply / 1e18;
280             if(_supply + _amount > 1e15) _amount = 1e15 - _supply;
281             _mint(msg.sender, _amount);
282             emit CheckIn(msg.sender, msg.value, _amount);
283         } else {
284             require(fixes[msg.sender] > 0, "No profit");
285             _payout(msg.sender, _supply);
286         }
287     }
288     function fnSales() external onlyFounders {
289         if(sales) sales = false;
290         else sales = true;
291     }
292     function fnFounder(address account) external onlyFounders {
293         for(uint8 i = 0; i < 3; i++) {
294             if(founders[i] == msg.sender) founders[i] = account;
295         }
296     }
297     function fnInsurance(address account) external onlyFounders { insurance = account; }
298     function fnSource(address source) external onlyFounders { EthRateSource = EthRateInterface(source); }
299     function fnSto(address source) external onlyFounders {
300         require(stoContract == address(0), "Already indicated");
301         stoContract = source;
302         referrers[stoContract] = smart;
303     }
304     function fnMinimum(uint256 value) external onlyFounders {
305         require(minimum > value, "Big value");
306         minimum = value;
307         emit NewMinimum(value);
308     }
309     function fnMultiply(uint256 value) external onlyFounders {
310         require(value >= 100, "Wrong multiply");
311         multiply = value;
312         emit NewMultiply(value);
313     }
314     function fnProfit(address account) external {
315         require(fixes[account] > 0 && holds[account] + balanceOf(account) > 0, "No profit");
316         _payout(account, totalSupply());
317     }
318     function fnSwap(address account, uint256 amount) external {
319         require(msg.sender == stoContract, "Access denied");
320         _swaped(account, amount);
321     }
322     function fnProof(bool all) external {
323         uint256 _amount = all ? balanceOf(smart) : balanceOf(smart).safeSub(1e9);
324         require(_amount >= 3, "Little amount");
325         for(uint8 i = 0; i < 3; i++) { _transfer(smart, founders[i], _amount / 3); }        
326     }
327     function fnBounty() external {
328         uint256 _delta = totalSupply().safeSub(bounted);
329         uint256 _bounty = _delta / 100;
330         require(_bounty >= 3, "Little amount");
331         bounted = bounted.safeAdd(_delta);
332         for(uint8 i = 0; i < 3; i++) { _mint(founders[i], _bounty / 3); }
333     }
334     function fnEth() external {
335         uint256 _amount = smart.balance;
336         require(_amount >= 10, "Little amount");
337         payable(insurance).transfer(_amount / 10);
338         for(uint8 i = 0; i < 3; i++) { payable(founders[i]).transfer(_amount * 3 / 10); }
339     }
340     function fnBurn(uint256 amount) external { _burn(msg.sender, amount); }
341     function showRate() external view returns(uint256) { return EthRateSource.EthToUsdRate(); }
342     function showTax() external view returns(uint256) { return totalSupply() / 1e13; }
343     function showUser(address account) external view returns(address referrer, uint256 balance, uint256 fix, uint256 profit) { return (referrers[account], balanceOf(account), fixes[account], holds[account]); }
344 }