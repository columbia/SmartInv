1 // Resolver to Wipe & Coll any CDP
2 pragma solidity 0.4.24;
3 
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         require(c / a == b, "Assertion Failed");
13         return c;
14     }
15     
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0, "Assertion Failed");
18         uint256 c = a / b;
19         return c;
20     }
21 
22 }
23 
24 interface IERC20 {
25     function balanceOf(address who) external view returns (uint256);
26     function transfer(address to, uint256 value) external returns (bool);
27     function approve(address spender, uint256 value) external returns (bool);
28     function transferFrom(address from, address to, uint256 value) external returns (bool);
29 }
30 
31 interface AddressRegistry {
32     function getAddr(string name) external view returns(address);
33 }
34 
35 interface MakerCDP {
36     function join(uint wad) external; // Join PETH
37     function lock(bytes32 cup, uint wad) external;
38     function wipe(bytes32 cup, uint wad) external;
39     function per() external view returns (uint ray);
40 }
41 
42 interface PriceInterface {
43     function peek() external view returns (bytes32, bool);
44 }
45 
46 interface WETHFace {
47     function deposit() external payable;
48     function withdraw(uint wad) external;
49 }
50 
51 interface InstaKyber {
52     function executeTrade(
53         address src,
54         address dest,
55         uint srcAmt,
56         uint minConversionRate,
57         uint maxDestAmt
58     ) external payable returns (uint destAmt);
59 
60     function getExpectedPrice(
61         address src,
62         address dest,
63         uint srcAmt
64     ) external view returns (uint, uint);
65 }
66 
67 
68 contract Registry {
69 
70     address public addressRegistry;
71     modifier onlyAdmin() {
72         require(
73             msg.sender == getAddress("admin"),
74             "Permission Denied"
75         );
76         _;
77     }
78     
79     function getAddress(string name) internal view returns(address) {
80         AddressRegistry addrReg = AddressRegistry(addressRegistry);
81         return addrReg.getAddr(name);
82     }
83 
84 }
85 
86 
87 contract Helper is Registry {
88 
89     using SafeMath for uint;
90     using SafeMath for uint256;
91 
92     address public cdpAddr;
93     address public eth;
94     address public weth;
95     address public peth;
96     address public mkr;
97     address public dai;
98     address public kyber;
99 
100     function pethPEReth(uint ethNum) public view returns (uint rPETH) {
101         MakerCDP loanMaster = MakerCDP(cdpAddr);
102         rPETH = (ethNum.mul(10 ** 27)).div(loanMaster.per());
103     }
104 
105 }
106 
107 
108 contract Lock is Helper {
109 
110     event LockedETH(uint cdpNum, address lockedBy, uint lockETH, uint lockPETH);
111 
112     function lockETH(uint cdpNum) public payable {
113         MakerCDP loanMaster = MakerCDP(cdpAddr);
114         WETHFace wethTkn = WETHFace(weth);
115         wethTkn.deposit.value(msg.value)(); // ETH to WETH
116         uint pethToLock = pethPEReth(msg.value);
117         loanMaster.join(pethToLock); // WETH to PETH
118         loanMaster.lock(bytes32(cdpNum), pethToLock); // PETH to CDP
119         emit LockedETH(
120             cdpNum, msg.sender, msg.value, pethToLock
121         );
122     }
123 
124 }
125 
126 
127 contract Wipe is Lock {
128 
129     event WipedDAI(uint cdpNum, address wipedBy, uint daiWipe, uint mkrCharged);
130 
131     function wipeDAI(uint cdpNum, uint daiWipe) public payable {
132         IERC20 daiTkn = IERC20(dai);
133         IERC20 mkrTkn = IERC20(mkr);
134 
135         uint contractMKR = mkrTkn.balanceOf(address(this)); // contract MKR balance before wiping
136         daiTkn.transferFrom(msg.sender, address(this), daiWipe); // get DAI to pay the debt
137         MakerCDP loanMaster = MakerCDP(cdpAddr);
138         loanMaster.wipe(bytes32(cdpNum), daiWipe); // wipe DAI
139         uint mkrCharged = contractMKR - mkrTkn.balanceOf(address(this)); // MKR fee = before wiping bal - after wiping bal
140 
141         // claiming paid MKR back
142         if (msg.value > 0) { // Interacting with Kyber to swap ETH with MKR
143             swapETHMKR(
144                 mkrCharged, msg.value
145             );
146         } else { // take MKR directly from address
147             mkrTkn.transferFrom(msg.sender, address(this), mkrCharged); // user paying MKR fees
148         }
149 
150         emit WipedDAI(
151             cdpNum, msg.sender, daiWipe, mkrCharged
152         );
153     }
154 
155     function swapETHMKR(
156         uint mkrCharged,
157         uint ethQty
158     ) internal 
159     {
160         InstaKyber instak = InstaKyber(kyber);
161         uint minRate;
162         (, minRate) = instak.getExpectedPrice(eth, mkr, ethQty);
163         uint mkrBought = instak.executeTrade.value(ethQty)(
164             eth, mkr, ethQty, minRate, mkrCharged
165         );
166         require(mkrCharged == mkrBought, "ETH not sufficient to cover the MKR fees.");
167         if (address(this).balance > 0) {
168             msg.sender.transfer(address(this).balance);
169         }
170     }
171 
172 }
173 
174 
175 contract ApproveTkn is Wipe {
176 
177     function approveERC20() public {
178         IERC20 wethTkn = IERC20(weth);
179         wethTkn.approve(cdpAddr, 2**256 - 1);
180         IERC20 pethTkn = IERC20(peth);
181         pethTkn.approve(cdpAddr, 2**256 - 1);
182         IERC20 mkrTkn = IERC20(mkr);
183         mkrTkn.approve(cdpAddr, 2**256 - 1);
184         IERC20 daiTkn = IERC20(dai);
185         daiTkn.approve(cdpAddr, 2**256 - 1);
186     }
187 
188 }
189 
190 
191 contract PublicCDP is ApproveTkn {
192 
193     event MKRCollected(uint amount);
194 
195     constructor(address rAddr) public {
196         addressRegistry = rAddr;
197         cdpAddr = getAddress("cdp");
198         eth = getAddress("eth");
199         weth = getAddress("weth");
200         peth = getAddress("peth");
201         mkr = getAddress("mkr");
202         dai = getAddress("dai");
203         kyber = getAddress("InstaKyber");
204         approveERC20();
205     }
206 
207     function () public payable {}
208 
209     // collecting MKR token kept as balance to pay fees
210     function collectMKR(uint amount) public onlyAdmin {
211         IERC20 mkrTkn = IERC20(mkr);
212         mkrTkn.transfer(msg.sender, amount);
213         emit MKRCollected(amount);
214     }
215 
216 }