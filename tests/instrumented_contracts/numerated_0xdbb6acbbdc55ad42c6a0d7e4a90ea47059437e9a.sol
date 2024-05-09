1 pragma solidity ^0.5.6;
2 pragma experimental ABIEncoderV2;
3 
4 contract ERC20 {
5     function totalSupply() public view returns (uint);
6     function balanceOf(address tokenOwner) public view returns (uint balance);
7     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
8     function transfer(address to, uint tokens) public returns (bool success);
9     function approve(address spender, uint tokens) public returns (bool success);
10     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract Structs {
16     struct Hmmm {
17         uint256 value;
18     }
19 
20     struct TotalPar {
21         uint128 borrow;
22         uint128 supply;
23     }
24 
25     enum ActionType {
26         Deposit,   // supply tokens
27         Withdraw,  // borrow tokens
28         Transfer,  // transfer balance between accounts
29         Buy,       // buy an amount of some token (externally)
30         Sell,      // sell an amount of some token (externally)
31         Trade,     // trade tokens against another account
32         Liquidate, // liquidate an undercollateralized or expiring account
33         Vaporize,  // use excess tokens to zero-out a completely negative account
34         Call       // send arbitrary data to an address
35     }
36 
37     enum AssetDenomination {
38         Wei, // the amount is denominated in wei
39         Par  // the amount is denominated in par
40     }
41 
42     enum AssetReference {
43         Delta, // the amount is given as a delta from the current value
44         Target // the amount is given as an exact number to end up at
45     }
46 
47     struct AssetAmount {
48         bool sign; // true if positive
49         AssetDenomination denomination;
50         AssetReference ref;
51         uint256 value;
52     }
53 
54     struct ActionArgs {
55         ActionType actionType;
56         uint256 accountId;
57         AssetAmount amount;
58         uint256 primaryMarketId;
59         uint256 secondaryMarketId;
60         address otherAddress;
61         uint256 otherAccountId;
62         bytes data;
63     }
64 
65     struct Info {
66         address owner;  // The address that owns the account
67         uint256 number; // A nonce that allows a single address to control many accounts
68     }
69 
70     struct Wei {
71         bool sign; // true if positive
72         uint256 value;
73     }
74 }
75 
76 contract DyDx is Structs {
77     function getEarningsRate() public view returns (Hmmm memory);
78     function getMarketInterestRate(uint256 marketId) public view returns (Hmmm memory);
79     function getMarketTotalPar(uint256 marketId) public view returns (TotalPar memory);
80     function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);
81     function operate(Info[] memory, ActionArgs[] memory) public;
82 }
83 
84 contract Compound {
85     struct Market {
86         bool isSupported;
87         uint blockNumber;
88         address interestRateModel;
89 
90         uint totalSupply;
91         uint supplyRateMantissa;
92         uint supplyIndex;
93 
94         uint totalBorrows;
95         uint borrowRateMantissa;
96         uint borrowIndex;
97     }
98 
99     function supply(address asset, uint amount) public returns (uint);
100     function withdraw(address asset, uint requestedAmount) public returns (uint);
101     function getSupplyBalance(address account, address asset) view public returns (uint);
102     function markets(address) public view returns(Market memory);
103     function supplyRatePerBlock() public view returns (uint);
104     function mint(uint mintAmount) public returns (uint);
105     function redeem(uint redeemTokens) public returns (uint);
106     function balanceOf(address account) public view returns (uint);
107 }
108 
109 contract Defimanager is Structs {
110 
111     uint256 DECIMAL = 10 ** 18;
112     // address dydxAddr       = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
113     // address compoundAddr   = 0x61bbd7Bd5EE2A202d7e62519750170A52A8DFD45;
114     // address daiAddr        = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
115     //0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359; //0x4e17c87c52d0E9a0cAd3Fbc53b77d9514F003807
116 
117     // MAINNET ADDRESSES
118     address dydxAddr       = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
119     address compoundAddr   = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
120     address daiAddr        = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
121 
122     // KOVAN ADDRESSES
123     // address dydxAddr       = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE;
124     // address compoundAddr   = 0xb6b09fBffBa6A5C4631e5F7B2e3Ee183aC259c0d;
125     // address daiAddr        = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
126 
127     uint256 public balancePrev           = 10 ** 18; // at least this much dai must be sent to the contract on creation
128     uint256 public benchmarkBalancePrev  = 10 ** 18;
129 
130     struct Account {
131         uint256 userBalanceLast;
132         uint256 benchmarkBalanceLast;
133     }
134 
135     mapping (address => Account) accounts;
136 
137     enum CurrentLender {
138         NONE,
139         DYDX,
140         COMPOUND
141     }
142 
143     DyDx dydx      = DyDx(dydxAddr);
144     Compound comp  = Compound(compoundAddr);
145     ERC20 dai      = ERC20(daiAddr);
146 
147     CurrentLender public lender;
148 
149     function approveDai() public {
150         dai.approve(compoundAddr, uint(-1)); //also add to constructor
151         dai.approve(dydxAddr, uint(-1));
152     }
153 
154     function poke() public {
155         uint move = which();
156         require(move != 999, "Something went wrong finding the best rate");
157         if (move == 0 && lender == CurrentLender.DYDX) {
158             supplyDyDx(balanceDai());
159         } else if (move == 0 && lender == CurrentLender.COMPOUND) {
160             compToDyDx();
161         } else if (move == 1 && lender == CurrentLender.COMPOUND) {
162             supplyComp(balanceDai());
163         } else if (move == 1 && lender == CurrentLender.DYDX) {
164             dydxToComp();
165         }
166     }
167 
168     function which() public view returns(uint) {
169         uint aprDyDx = pokeDyDx();
170         uint aprComp = pokeCompound();
171         if (aprDyDx > aprComp) return 0;
172         if (aprComp > aprDyDx) return 1;
173         return 999;
174     }
175 
176     function dydxToComp() internal {
177         withdrawDyDx(balanceDyDx());
178         supplyComp(balanceDai());
179     }
180 
181     function compToDyDx() internal {
182         withdrawComp(balanceComp());
183         supplyDyDx(balanceDai());
184     }
185 
186     function pokeDyDx() public view returns(uint256) {
187         uint256 rate      = dydx.getMarketInterestRate(1).value;
188         uint256 aprBorrow = rate * 31622400;
189         uint256 borrow    = dydx.getMarketTotalPar(1).borrow;
190         uint256 supply    = dydx.getMarketTotalPar(1).supply;
191         uint256 usage     = (borrow * DECIMAL) / supply;
192         uint256 apr       = (((aprBorrow * usage) / DECIMAL) * dydx.getEarningsRate().value) / DECIMAL;
193         return apr;
194     }
195 
196     function pokeCompound() public view returns(uint256) {
197         uint interestRate = comp.supplyRatePerBlock();
198         uint apr          = interestRate * 2108160;
199         return apr;
200     }
201 
202     function balanceDyDx() public view returns(uint256) {
203         Wei memory bal = dydx.getAccountWei(Info(address(this), 0), 1);
204         return bal.value;
205     }
206 
207     function balanceComp() public view returns(uint) {
208         return comp.balanceOf(address(this));
209     }
210 
211     function balanceDai() public view returns(uint) {
212         return dai.balanceOf(address(this));
213     }
214 
215     function balanceDaiCurrent() public view returns (uint) {
216         if (lender == CurrentLender.COMPOUND) {
217             return balanceComp() + balanceDai();
218         }
219         if (lender == CurrentLender.DYDX) { 
220             return balanceDyDx() + balanceDai();
221         }
222         return balanceDai();
223     }
224 
225     function supplyDyDx(uint256 amount) public returns(uint) {
226         Info[] memory infos = new Info[](1);
227         infos[0] = Info(address(this), 0);
228 
229         AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);
230         ActionArgs memory act;
231         act.actionType = ActionType.Deposit;
232         act.accountId = 0;
233         act.amount = amt;
234         act.primaryMarketId = 1;
235         act.otherAddress = address(this);
236 
237         ActionArgs[] memory args = new ActionArgs[](1);
238         args[0] = act;
239 
240         dydx.operate(infos, args);
241 
242         lender = CurrentLender.DYDX;
243     }
244 
245     function withdrawDyDx(uint256 amount) public {
246         Info[] memory infos = new Info[](1);
247         infos[0] = Info(address(this), 0);
248 
249         AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);
250         ActionArgs memory act;
251         act.actionType = ActionType.Withdraw;
252         act.accountId = 0;
253         act.amount = amt;
254         act.primaryMarketId = 1;
255         act.otherAddress = address(this);
256 
257         ActionArgs[] memory args = new ActionArgs[](1);
258         args[0] = act;
259 
260         dydx.operate(infos, args);
261         // lender = CurrentLender.NONE; - only if amount = entire dydx balance
262     }
263 
264     function supplyComp(uint amount) public {
265         require(comp.mint(amount) == 0, "COMPOUND: mint fail");
266 
267         lender = CurrentLender.COMPOUND;
268     }
269 
270     function withdrawComp(uint amount) public {
271         require(comp.redeem(amount) == 0, "COMPOUND: redeem fail");
272         // lender = CurrentLender.NONE;
273     }
274 
275     function initializeNewUser() public {
276         accounts[msg.sender].userBalanceLast = 0;
277         accounts[msg.sender].benchmarkBalanceLast = (benchmarkBalancePrev * balanceDaiCurrent()) / balancePrev;
278     }
279 
280     function depositDai(uint amount) public returns(uint) {
281 
282         dai.approve(compoundAddr, uint(-1)); //also add to constructor
283         dai.approve(dydxAddr, uint(-1));
284 
285         //figure out current benchmark account balance
286         uint256 benchmarkCurrentBalance = (benchmarkBalancePrev * balanceDaiCurrent()) / balancePrev;
287         
288         //figure out how much the user actually has right now
289 
290         uint256 userCurrentBalance = benchmarkCurrentBalance * accounts[msg.sender].userBalanceLast / accounts[msg.sender].benchmarkBalanceLast;
291 
292         //update user's balance to add the amount being deposited
293         accounts[msg.sender].userBalanceLast = userCurrentBalance + amount;
294 
295         //update the global benchmark balance
296         benchmarkBalancePrev = benchmarkCurrentBalance;
297 
298         //track the benchmark balance for the user
299         accounts[msg.sender].benchmarkBalanceLast = benchmarkCurrentBalance;
300 
301         balancePrev = balanceDaiCurrent() + amount;
302         require(dai.transferFrom(msg.sender, address(this), amount), 'balance too low');
303 
304         if (lender == CurrentLender.DYDX) {
305             supplyDyDx(amount);
306         }
307         if (lender == CurrentLender.COMPOUND) {
308             supplyComp(amount);
309         }
310     }
311 
312     function withdrawDai(uint amount) public returns(uint) {
313         uint256 benchmarkCurrentBalance = (benchmarkBalancePrev * balanceDaiCurrent()) / balancePrev;
314         uint256 userCurrentBalance = benchmarkCurrentBalance * accounts[msg.sender].userBalanceLast / accounts[msg.sender].benchmarkBalanceLast;
315         require(amount <= userCurrentBalance, 'cannot withdraw'); 
316 
317         accounts[msg.sender].userBalanceLast = userCurrentBalance - amount;
318         benchmarkBalancePrev = benchmarkCurrentBalance;
319         accounts[msg.sender].benchmarkBalanceLast = benchmarkCurrentBalance;
320 
321         balancePrev = balanceDaiCurrent() + amount;
322 
323         //do withdrawal
324         if (lender == CurrentLender.DYDX) {
325             withdrawDyDx(amount);
326         }
327 
328         if (lender == CurrentLender.COMPOUND) {
329             withdrawComp(amount);
330         }
331 
332         require(dai.transferFrom(address(this), msg.sender, amount), 'transfer failed');
333 
334     }
335 
336 }