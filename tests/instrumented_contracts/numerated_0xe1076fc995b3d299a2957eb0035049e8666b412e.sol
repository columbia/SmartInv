1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         require(c / a == b, "Assertion Failed");
12         return c;
13     }
14     
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0, "Assertion Failed");
17         uint256 c = a / b;
18         return c;
19     }
20 
21 }
22 
23 interface IERC20 {
24     function balanceOf(address who) external view returns (uint256);
25     function transfer(address to, uint256 value) external returns (bool);
26     function approve(address spender, uint256 value) external returns (bool);
27     function transferFrom(address from, address to, uint256 value) external returns (bool);
28 }
29 
30 interface AddressRegistry {
31     function getAddr(string name) external view returns(address);
32 }
33 
34 interface MakerCDP {
35     function open() external returns (bytes32 cup);
36     function join(uint wad) external; // Join PETH
37     function exit(uint wad) external; // Exit PETH
38     function give(bytes32 cup, address guy) external;
39     function lock(bytes32 cup, uint wad) external;
40     function free(bytes32 cup, uint wad) external;
41     function draw(bytes32 cup, uint wad) external;
42     function wipe(bytes32 cup, uint wad) external;
43     function per() external view returns (uint ray);
44 }
45 
46 interface PriceInterface {
47     function peek() external view returns (bytes32, bool);
48 }
49 
50 interface WETHFace {
51     function deposit() external payable;
52     function withdraw(uint wad) external;
53 }
54 
55 interface InstaKyber {
56     function executeTrade(
57         address src,
58         address dest,
59         uint srcAmt,
60         uint minConversionRate,
61         uint maxDestAmt
62     ) external payable returns (uint destAmt);
63 
64     function getExpectedPrice(
65         address src,
66         address dest,
67         uint srcAmt
68     ) external view returns (uint, uint);
69 }
70 
71 
72 contract Registry {
73 
74     address public addressRegistry;
75     modifier onlyAdmin() {
76         require(
77             msg.sender == getAddress("admin"),
78             "Permission Denied"
79         );
80         _;
81     }
82     
83     function getAddress(string name) internal view returns(address) {
84         AddressRegistry addrReg = AddressRegistry(addressRegistry);
85         return addrReg.getAddr(name);
86     }
87 
88 }
89 
90 
91 contract GlobalVar is Registry {
92 
93     using SafeMath for uint;
94     using SafeMath for uint256;
95 
96     bytes32 blankCDP = 0x0000000000000000000000000000000000000000000000000000000000000000;
97     address cdpAddr; // cups
98     mapping (address => bytes32) cdps; // borrower >>> CDP Bytes
99     bool public freezed;
100 
101 }
102 
103 
104 contract IssueLoan is GlobalVar {
105 
106     event LockedETH(address borrower, uint lockETH, uint lockPETH, address lockedBy);
107     event LoanedDAI(address borrower, uint loanDAI);
108     event NewCDP(address borrower, bytes32 cdpBytes);
109 
110     function pethPEReth(uint ethNum) public view returns (uint rPETH) {
111         MakerCDP loanMaster = MakerCDP(cdpAddr);
112         rPETH = (ethNum.mul(10 ** 27)).div(loanMaster.per());
113     }
114 
115     function borrow(uint daiDraw) public payable {
116         if (msg.value > 0) {lockETH(msg.sender);}
117         if (daiDraw > 0) {drawDAI(daiDraw);}
118     }
119 
120     function lockETH(address borrower) public payable {
121         MakerCDP loanMaster = MakerCDP(cdpAddr);
122         if (cdps[borrower] == blankCDP) {
123             require(msg.sender == borrower, "Creating CDP for others is not permitted at the moment.");
124             cdps[msg.sender] = loanMaster.open();
125             emit NewCDP(msg.sender, cdps[msg.sender]);
126         }
127         WETHFace wethTkn = WETHFace(getAddress("weth"));
128         wethTkn.deposit.value(msg.value)(); // ETH to WETH
129         uint pethToLock = pethPEReth(msg.value);
130         loanMaster.join(pethToLock); // WETH to PETH
131         loanMaster.lock(cdps[borrower], pethToLock); // PETH to CDP
132         emit LockedETH(
133             borrower, msg.value, pethToLock, msg.sender
134         );
135     }
136 
137     function drawDAI(uint daiDraw) public {
138         require(!freezed, "Operation Disabled");
139         MakerCDP loanMaster = MakerCDP(cdpAddr);
140         loanMaster.draw(cdps[msg.sender], daiDraw);
141         IERC20 daiTkn = IERC20(getAddress("dai"));
142         daiTkn.transfer(msg.sender, daiDraw);
143         emit LoanedDAI(msg.sender, daiDraw);
144     }
145 
146 }
147 
148 
149 contract RepayLoan is IssueLoan {
150 
151     event WipedDAI(address borrower, uint daiWipe, uint mkrCharged, address wipedBy);
152     event UnlockedETH(address borrower, uint ethFree);
153 
154     function repay(uint daiWipe, uint ethFree) public payable {
155         if (daiWipe > 0) {wipeDAI(daiWipe, msg.sender);}
156         if (ethFree > 0) {unlockETH(ethFree);}
157     }
158 
159     function wipeDAI(uint daiWipe, address borrower) public payable {
160         address dai = getAddress("dai");
161         address mkr = getAddress("mkr");
162         address eth = getAddress("eth");
163 
164         IERC20 daiTkn = IERC20(dai);
165         IERC20 mkrTkn = IERC20(mkr);
166 
167         uint contractMKR = mkrTkn.balanceOf(address(this)); // contract MKR balance before wiping
168         daiTkn.transferFrom(msg.sender, address(this), daiWipe); // get DAI to pay the debt
169         MakerCDP loanMaster = MakerCDP(cdpAddr);
170         loanMaster.wipe(cdps[borrower], daiWipe); // wipe DAI
171         uint mkrCharged = contractMKR - mkrTkn.balanceOf(address(this)); // MKR fee = before wiping bal - after wiping bal
172 
173         // claiming paid MKR back
174         if (msg.value > 0) { // Interacting with Kyber to swap ETH with MKR
175             swapETHMKR(
176                 eth, mkr, mkrCharged, msg.value
177             );
178         } else { // take MKR directly from address
179             mkrTkn.transferFrom(msg.sender, address(this), mkrCharged); // user paying MKR fees
180         }
181 
182         emit WipedDAI(
183             borrower, daiWipe, mkrCharged, msg.sender
184         );
185     }
186 
187     function unlockETH(uint ethFree) public {
188         require(!freezed, "Operation Disabled");
189         uint pethToUnlock = pethPEReth(ethFree);
190         MakerCDP loanMaster = MakerCDP(cdpAddr);
191         loanMaster.free(cdps[msg.sender], pethToUnlock); // CDP to PETH
192         loanMaster.exit(pethToUnlock); // PETH to WETH
193         WETHFace wethTkn = WETHFace(getAddress("weth"));
194         wethTkn.withdraw(ethFree); // WETH to ETH
195         msg.sender.transfer(ethFree);
196         emit UnlockedETH(msg.sender, ethFree);
197     }
198 
199     function swapETHMKR(
200         address eth,
201         address mkr,
202         uint mkrCharged,
203         uint ethQty
204     ) internal 
205     {
206         InstaKyber instak = InstaKyber(getAddress("InstaKyber"));
207         uint minRate;
208         (, minRate) = instak.getExpectedPrice(eth, mkr, ethQty);
209         uint mkrBought = instak.executeTrade.value(ethQty)(
210             eth, mkr, ethQty, minRate, mkrCharged
211         );
212         require(mkrCharged == mkrBought, "ETH not sufficient to cover the MKR fees.");
213         if (address(this).balance > 0) {
214             msg.sender.transfer(address(this).balance);
215         }
216     }
217 
218 }
219 
220 
221 contract BorrowTasks is RepayLoan {
222 
223     event TranferCDP(bytes32 cdp, address owner, address nextOwner);
224 
225     function transferCDP(address nextOwner) public {
226         require(nextOwner != 0, "Invalid Address.");
227         MakerCDP loanMaster = MakerCDP(cdpAddr);
228         loanMaster.give(cdps[msg.sender], nextOwner);
229         cdps[msg.sender] = blankCDP;
230         emit TranferCDP(cdps[msg.sender], msg.sender, nextOwner);
231     }
232 
233     function getETHRate() public view returns (uint) {
234         PriceInterface ethRate = PriceInterface(getAddress("ethfeed"));
235         bytes32 ethrate;
236         (ethrate, ) = ethRate.peek();
237         return uint(ethrate);
238     }
239 
240     function getCDP(address borrower) public view returns (uint, bytes32) {
241         return (uint(cdps[borrower]), cdps[borrower]);
242     }
243 
244     function approveERC20() public {
245         IERC20 wethTkn = IERC20(getAddress("weth"));
246         wethTkn.approve(cdpAddr, 2**256 - 1);
247         IERC20 pethTkn = IERC20(getAddress("peth"));
248         pethTkn.approve(cdpAddr, 2**256 - 1);
249         IERC20 mkrTkn = IERC20(getAddress("mkr"));
250         mkrTkn.approve(cdpAddr, 2**256 - 1);
251         IERC20 daiTkn = IERC20(getAddress("dai"));
252         daiTkn.approve(cdpAddr, 2**256 - 1);
253     }
254 
255 }
256 
257 
258 contract InstaMaker is BorrowTasks {
259 
260     event MKRCollected(uint amount);
261 
262     constructor(address rAddr) public {
263         addressRegistry = rAddr;
264         cdpAddr = getAddress("cdp");
265         approveERC20();
266     }
267 
268     function () public payable {}
269 
270     function freeze(bool stop) public onlyAdmin {
271         freezed = stop;
272     }
273 
274     // collecting MKR token kept as balance to pay fees
275     function collectMKR(uint amount) public onlyAdmin {
276         IERC20 mkrTkn = IERC20(getAddress("mkr"));
277         mkrTkn.transfer(msg.sender, amount);
278         emit MKRCollected(amount);
279     }
280 
281 }