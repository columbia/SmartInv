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
44     function lad(bytes32 cup) external view returns (address);
45 }
46 
47 interface PriceInterface {
48     function peek() external view returns (bytes32, bool);
49 }
50 
51 interface WETHFace {
52     function deposit() external payable;
53     function withdraw(uint wad) external;
54 }
55 
56 interface InstaKyber {
57     function executeTrade(
58         address src,
59         address dest,
60         uint srcAmt,
61         uint minConversionRate,
62         uint maxDestAmt
63     ) external payable returns (uint destAmt);
64 
65     function getExpectedPrice(
66         address src,
67         address dest,
68         uint srcAmt
69     ) external view returns (uint, uint);
70 }
71 
72 
73 contract Registry {
74 
75     address public addressRegistry;
76     modifier onlyAdmin() {
77         require(
78             msg.sender == getAddress("admin"),
79             "Permission Denied"
80         );
81         _;
82     }
83     
84     function getAddress(string name) internal view returns(address) {
85         AddressRegistry addrReg = AddressRegistry(addressRegistry);
86         return addrReg.getAddr(name);
87     }
88 
89 }
90 
91 
92 contract GlobalVar is Registry {
93 
94     using SafeMath for uint;
95     using SafeMath for uint256;
96 
97     bytes32 blankCDP = 0x0000000000000000000000000000000000000000000000000000000000000000;
98     address cdpAddr; // cups
99     mapping (address => bytes32) cdps; // borrower >>> CDP Bytes
100     bool public freezed;
101 
102 }
103 
104 
105 contract IssueLoan is GlobalVar {
106 
107     event LockedETH(address borrower, uint lockETH, uint lockPETH, address lockedBy);
108     event LoanedDAI(address borrower, uint loanDAI, address payTo);
109     event NewCDP(address borrower, bytes32 cdpBytes);
110 
111     function pethPEReth(uint ethNum) public view returns (uint rPETH) {
112         MakerCDP loanMaster = MakerCDP(cdpAddr);
113         rPETH = (ethNum.mul(10 ** 27)).div(loanMaster.per());
114     }
115 
116     function borrow(uint daiDraw, address beneficiary) public payable {
117         if (msg.value > 0) {lockETH(msg.sender);}
118         if (daiDraw > 0) {drawDAI(daiDraw, beneficiary);}
119     }
120 
121     function lockETH(address borrower) public payable {
122         MakerCDP loanMaster = MakerCDP(cdpAddr);
123         if (cdps[borrower] == blankCDP) {
124             require(msg.sender == borrower, "Creating CDP for others is not permitted at the moment.");
125             cdps[msg.sender] = loanMaster.open();
126             emit NewCDP(msg.sender, cdps[msg.sender]);
127         }
128         WETHFace wethTkn = WETHFace(getAddress("weth"));
129         wethTkn.deposit.value(msg.value)(); // ETH to WETH
130         uint pethToLock = pethPEReth(msg.value);
131         loanMaster.join(pethToLock); // WETH to PETH
132         loanMaster.lock(cdps[borrower], pethToLock); // PETH to CDP
133         emit LockedETH(
134             borrower, msg.value, pethToLock, msg.sender
135         );
136     }
137 
138     function drawDAI(uint daiDraw, address beneficiary) public {
139         require(!freezed, "Operation Disabled");
140         MakerCDP loanMaster = MakerCDP(cdpAddr);
141         loanMaster.draw(cdps[msg.sender], daiDraw);
142         IERC20 daiTkn = IERC20(getAddress("dai"));
143         address payTo = msg.sender;
144         if (payTo != address(0)) {
145             payTo = beneficiary;
146         }
147         daiTkn.transfer(payTo, daiDraw);
148         emit LoanedDAI(msg.sender, daiDraw, payTo);
149     }
150 
151 }
152 
153 
154 contract RepayLoan is IssueLoan {
155 
156     event WipedDAI(address borrower, uint daiWipe, uint mkrCharged, address wipedBy);
157     event UnlockedETH(address borrower, uint ethFree);
158 
159     function repay(uint daiWipe, uint ethFree) public payable {
160         if (daiWipe > 0) {wipeDAI(daiWipe, msg.sender);}
161         if (ethFree > 0) {unlockETH(ethFree);}
162     }
163 
164     function wipeDAI(uint daiWipe, address borrower) public payable {
165         address dai = getAddress("dai");
166         address mkr = getAddress("mkr");
167         address eth = getAddress("eth");
168 
169         IERC20 daiTkn = IERC20(dai);
170         IERC20 mkrTkn = IERC20(mkr);
171 
172         uint contractMKR = mkrTkn.balanceOf(address(this)); // contract MKR balance before wiping
173         daiTkn.transferFrom(msg.sender, address(this), daiWipe); // get DAI to pay the debt
174         MakerCDP loanMaster = MakerCDP(cdpAddr);
175         loanMaster.wipe(cdps[borrower], daiWipe); // wipe DAI
176         uint mkrCharged = contractMKR - mkrTkn.balanceOf(address(this)); // MKR fee = before wiping bal - after wiping bal
177 
178         // claiming paid MKR back
179         if (msg.value > 0) { // Interacting with Kyber to swap ETH with MKR
180             swapETHMKR(
181                 eth, mkr, mkrCharged, msg.value
182             );
183         } else { // take MKR directly from address
184             mkrTkn.transferFrom(msg.sender, address(this), mkrCharged); // user paying MKR fees
185         }
186 
187         emit WipedDAI(
188             borrower, daiWipe, mkrCharged, msg.sender
189         );
190     }
191 
192     function unlockETH(uint ethFree) public {
193         require(!freezed, "Operation Disabled");
194         uint pethToUnlock = pethPEReth(ethFree);
195         MakerCDP loanMaster = MakerCDP(cdpAddr);
196         loanMaster.free(cdps[msg.sender], pethToUnlock); // CDP to PETH
197         loanMaster.exit(pethToUnlock); // PETH to WETH
198         WETHFace wethTkn = WETHFace(getAddress("weth"));
199         wethTkn.withdraw(ethFree); // WETH to ETH
200         msg.sender.transfer(ethFree);
201         emit UnlockedETH(msg.sender, ethFree);
202     }
203 
204     function swapETHMKR(
205         address eth,
206         address mkr,
207         uint mkrCharged,
208         uint ethQty
209     ) internal 
210     {
211         InstaKyber instak = InstaKyber(getAddress("InstaKyber"));
212         uint minRate;
213         (, minRate) = instak.getExpectedPrice(eth, mkr, ethQty);
214         uint mkrBought = instak.executeTrade.value(ethQty)(
215             eth, mkr, ethQty, minRate, mkrCharged
216         );
217         require(mkrCharged == mkrBought, "ETH not sufficient to cover the MKR fees.");
218         if (address(this).balance > 0) {
219             msg.sender.transfer(address(this).balance);
220         }
221     }
222 
223 }
224 
225 
226 contract BorrowTasks is RepayLoan {
227 
228     event TranferCDP(bytes32 cdp, address owner, address nextOwner);
229     event CDPClaimed(bytes32 cdp, address owner);
230 
231     function transferCDP(address nextOwner) public {
232         require(nextOwner != 0, "Invalid Address.");
233         MakerCDP loanMaster = MakerCDP(cdpAddr);
234         loanMaster.give(cdps[msg.sender], nextOwner);
235         cdps[msg.sender] = blankCDP;
236         emit TranferCDP(cdps[msg.sender], msg.sender, nextOwner);
237     }
238 
239     function claimCDP(uint cdpNum) public {
240         bytes32 cdpBytes = bytes32(cdpNum);
241         MakerCDP loanMaster = MakerCDP(cdpAddr);
242         address cdpOwner = loanMaster.lad(cdpBytes);
243         require(cdps[cdpOwner] == blankCDP, "More than 1 CDP is not allowed.");
244         cdps[cdpOwner] = cdpBytes;
245         emit CDPClaimed(cdpBytes, msg.sender);
246     }
247 
248     function getETHRate() public view returns (uint) {
249         PriceInterface ethRate = PriceInterface(getAddress("ethfeed"));
250         bytes32 ethrate;
251         (ethrate, ) = ethRate.peek();
252         return uint(ethrate);
253     }
254 
255     function getCDP(address borrower) public view returns (uint, bytes32) {
256         return (uint(cdps[borrower]), cdps[borrower]);
257     }
258 
259     function approveERC20() public {
260         IERC20 wethTkn = IERC20(getAddress("weth"));
261         wethTkn.approve(cdpAddr, 2**256 - 1);
262         IERC20 pethTkn = IERC20(getAddress("peth"));
263         pethTkn.approve(cdpAddr, 2**256 - 1);
264         IERC20 mkrTkn = IERC20(getAddress("mkr"));
265         mkrTkn.approve(cdpAddr, 2**256 - 1);
266         IERC20 daiTkn = IERC20(getAddress("dai"));
267         daiTkn.approve(cdpAddr, 2**256 - 1);
268     }
269 
270 }
271 
272 
273 contract InstaMaker is BorrowTasks {
274 
275     event MKRCollected(uint amount);
276 
277     constructor(address rAddr) public {
278         addressRegistry = rAddr;
279         cdpAddr = getAddress("cdp");
280         approveERC20();
281     }
282 
283     function () public payable {}
284 
285     function freeze(bool stop) public onlyAdmin {
286         freezed = stop;
287     }
288 
289     // collecting MKR token kept as balance to pay fees
290     function collectMKR(uint amount) public onlyAdmin {
291         IERC20 mkrTkn = IERC20(getAddress("mkr"));
292         mkrTkn.transfer(msg.sender, amount);
293         emit MKRCollected(amount);
294     }
295 
296 }