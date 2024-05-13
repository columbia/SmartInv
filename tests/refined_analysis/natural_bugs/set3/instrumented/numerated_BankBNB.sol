1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 import "@openzeppelin/contracts/math/Math.sol";
37 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
38 
39 import "../interfaces/IBank.sol";
40 import "../library/SafeToken.sol";
41 
42 import "./BankBridge.sol";
43 import "../vaults/venus/VaultVenus.sol";
44 
45 
46 contract BankBNB is IBank, WhitelistUpgradeable, ReentrancyGuardUpgradeable {
47     using SafeMath for uint;
48     using SafeToken for address;
49 
50     /* ========== CONSTANTS ============= */
51 
52     address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
53     address public constant TREASURY = 0x0989091F27708Bc92ea4cA60073e03592B94C0eE;
54 
55     /* ========== STATE VARIABLES ========== */
56 
57     IBankConfig public config;
58     BankBridge public bankBridge;
59     VaultVenus public vaultVenus;
60 
61     uint public lastAccrueTime;
62     uint public reserved;
63     uint public totalDebt;
64     uint public totalShares;
65     mapping(address => mapping(address => uint)) private _shares;
66 
67     /* ========== EVENTS ========== */
68 
69     event DebtAdded(address indexed pool, address indexed account, uint share);
70     event DebtRemoved(address indexed pool, address indexed account, uint share);
71     event DebtHandedOver(address indexed pool, address indexed from, address indexed to, uint share);
72 
73     /* ========== MODIFIERS ========== */
74 
75     modifier accrue {
76         vaultVenus.updateVenusFactors();
77         if (block.timestamp > lastAccrueTime) {
78             uint interest = pendingInterest();
79             uint reserve = interest.mul(config.getReservePoolBps()).div(10000);
80             totalDebt = totalDebt.add(interest);
81             reserved = reserved.add(reserve);
82             lastAccrueTime = block.timestamp;
83         }
84         _;
85         vaultVenus.updateVenusFactors();
86     }
87 
88     modifier onlyBridge {
89         require(msg.sender == address(bankBridge), "BankBNB: caller is not the bridge");
90         _;
91     }
92 
93     receive() payable external {}
94 
95     /* ========== INITIALIZER ========== */
96 
97     function initialize() external initializer {
98         __ReentrancyGuard_init();
99         __WhitelistUpgradeable_init();
100 
101         lastAccrueTime = block.timestamp;
102     }
103 
104     /* ========== VIEW FUNCTIONS ========== */
105 
106     function pendingInterest() public view returns (uint) {
107         if (block.timestamp <= lastAccrueTime) return 0;
108 
109         uint ratePerSec = config.getInterestRate(totalDebt, vaultVenus.balance());
110         return ratePerSec.mul(totalDebt).mul(block.timestamp.sub(lastAccrueTime)).div(1e18);
111     }
112 
113     function pendingDebtOf(address pool, address account) public view override returns (uint) {
114         uint share = sharesOf(pool, account);
115         if (totalShares == 0) return share;
116 
117         return share.mul(totalDebt.add(pendingInterest())).div(totalShares);
118     }
119 
120     function pendingDebtOfBridge() external view override returns (uint) {
121         return pendingDebtOf(address(this), address(bankBridge));
122     }
123 
124     function sharesOf(address pool, address account) public view override returns (uint) {
125         return _shares[pool][account];
126     }
127 
128     function shareToAmount(uint share) public view override returns (uint) {
129         if (totalShares == 0) return share;
130         return share.mul(totalDebt).div(totalShares);
131     }
132 
133     function amountToShare(uint amount) public view override returns (uint) {
134         if (totalShares == 0) return amount;
135         return amount.mul(totalShares).div(totalDebt);
136     }
137 
138     function debtToProviders() public view override returns (uint) {
139         return totalDebt.sub(reserved);
140     }
141 
142     function getUtilizationInfo() public view override returns (uint liquidity, uint utilized) {
143         return (vaultVenus.balance(), totalDebt);
144     }
145 
146     /* ========== MUTATIVE FUNCTIONS ========== */
147 
148     function accruedDebtOf(address pool, address account) public override accrue returns (uint) {
149         return shareToAmount(sharesOf(pool, account));
150     }
151 
152     function accruedDebtOfBridge() public override accrue returns (uint) {
153         return shareToAmount(sharesOf(address(this), address(bankBridge)));
154     }
155 
156     function executeAccrue() external override {
157         if (block.timestamp > lastAccrueTime) {
158             uint interest = pendingInterest();
159             uint reserve = interest.mul(config.getReservePoolBps()).div(10000);
160             totalDebt = totalDebt.add(interest);
161             reserved = reserved.add(reserve);
162             lastAccrueTime = block.timestamp;
163         }
164     }
165 
166     /* ========== RESTRICTED FUNCTIONS - CONFIGURATION ========== */
167 
168     function setBankBridge(address payable newBridge) external onlyOwner {
169         require(address(bankBridge) == address(0), "BankBNB: bridge is already set");
170         require(newBridge != address(0), "BankBNB: invalid bridge address");
171         bankBridge = BankBridge(newBridge);
172     }
173 
174     function setVaultVenus(address payable newVaultVenus) external onlyOwner {
175         require(address(vaultVenus) == address(0), "BankBNB: VaultVenus is already set");
176         require(newVaultVenus != address(0) && VaultVenus(newVaultVenus).stakingToken() == WBNB, "BankBNB: invalid VaultVenus");
177         vaultVenus = VaultVenus(newVaultVenus);
178     }
179 
180     function updateConfig(address newConfig) external onlyOwner {
181         require(newConfig != address(0), "BankBNB: invalid config address");
182         config = IBankConfig(newConfig);
183     }
184 
185     /* ========== RESTRICTED FUNCTIONS - BANKING ========== */
186 
187     function borrow(address pool, address account, uint amount) external override accrue onlyWhitelisted returns (uint debtInBNB) {
188         amount = Math.min(amount, vaultVenus.balance());
189         amount = vaultVenus.borrow(amount);
190         uint share = amountToShare(amount);
191 
192         _shares[pool][account] = _shares[pool][account].add(share);
193         totalShares = totalShares.add(share);
194         totalDebt = totalDebt.add(amount);
195 
196         SafeToken.safeTransferETH(msg.sender, amount);
197         emit DebtAdded(pool, account, share);
198         return amount;
199     }
200 
201 //    function repayPartial(address pool, address account) public override payable accrue onlyWhitelisted {
202 //        uint debt = accruedDebtOf(pool, account);
203 //        uint available = Math.min(msg.value, debt);
204 //        vaultVenus.repay{value : available}();
205 //
206 //        uint share = Math.min(amountToShare(available), _shares[pool][account]);
207 //        _shares[pool][account] = _shares[pool][account].sub(share);
208 //        totalShares = totalShares.sub(share);
209 //        totalDebt = totalDebt.sub(available);
210 //        emit DebtRemoved(pool, account, share);
211 //
212 //        if (totalDebt < reserved) {
213 //            _decreaseReserved(TREASURY, reserved);
214 //        }
215 //    }
216 
217     function repayAll(address pool, address account) public override payable accrue onlyWhitelisted returns (uint profitInETH, uint lossInETH) {
218         uint received = msg.value;
219         uint bnbBefore = address(this).balance;
220 
221         uint debt = accruedDebtOf(pool, account);
222         uint profit = received > debt ? received.sub(debt) : 0;
223         uint loss = received < debt ? debt.sub(received) : 0;
224 
225         profitInETH = profit > 0 ? bankBridge.realizeProfit{value : profit}() : 0;
226         lossInETH = loss > 0 ? bankBridge.realizeLoss(loss) : 0;
227         received =  loss > 0 ? received.add(address(this).balance).sub(bnbBefore) : received.sub(profit);
228 
229         uint available = Math.min(received, debt);
230         vaultVenus.repay{value : available}();
231 
232         uint share = _shares[pool][account];
233         if (loss > 0) {
234             uint unpaidDebtShare = Math.min(amountToShare(loss), share);
235             _shares[address(this)][address(bankBridge)] = _shares[address(this)][address(bankBridge)].add(unpaidDebtShare);
236             emit DebtHandedOver(pool, account, msg.sender, unpaidDebtShare);
237 
238             share = share.sub(unpaidDebtShare);
239         }
240 
241         delete _shares[pool][account];
242         totalShares = totalShares.sub(share);
243         totalDebt = totalDebt.sub(available);
244         emit DebtRemoved(pool, account, share);
245 
246         _cleanupDust();
247 
248         if (totalDebt < reserved) {
249             _decreaseReserved(TREASURY, reserved);
250         }
251     }
252 
253     function repayBridge() external override payable {
254         uint debtInBNB = accruedDebtOfBridge();
255         if (debtInBNB == 0) return;
256         require(msg.value >= debtInBNB, "BankBNB: not enough value");
257 
258         vaultVenus.repay{ value: debtInBNB }();
259 
260         uint share = _shares[address(this)][address(bankBridge)];
261         delete _shares[address(this)][address(bankBridge)];
262         totalShares = totalShares.sub(share);
263         totalDebt = totalDebt.sub(debtInBNB);
264         emit DebtRemoved(address(this), address(bankBridge), share);
265 
266         _cleanupDust();
267 
268         if (totalDebt < reserved) {
269             _decreaseReserved(TREASURY, reserved);
270         }
271 
272         if (msg.value > debtInBNB) {
273             SafeToken.safeTransferETH(msg.sender, msg.value.sub(debtInBNB));
274         }
275     }
276 
277     function bridgeETH(address to, uint amount) external override onlyWhitelisted {
278         bankBridge.bridgeETH(to, amount);
279     }
280 
281     /* ========== RESTRICTED FUNCTIONS - OPERATION ========== */
282 
283     function withdrawReserved(address to, uint amount) external onlyOwner accrue nonReentrant {
284         require(amount <= reserved, "BankBNB: amount exceeded");
285         _decreaseReserved(to, amount);
286     }
287 
288     /* ========== PRIVATE FUNCTIONS ========== */
289 
290     function _decreaseReserved(address to, uint amount) private {
291         reserved = reserved.sub(amount);
292         amount = vaultVenus.borrow(amount);
293         SafeToken.safeTransferETH(to, amount);
294     }
295 
296     function _cleanupDust() private {
297         if (totalDebt < 1000 && totalShares < 1000) {
298             totalShares = 0;
299             totalDebt = 0;
300         }
301     }
302 }
