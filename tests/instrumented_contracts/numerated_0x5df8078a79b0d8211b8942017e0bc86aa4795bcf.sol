1 // charge fees in dai2eth maybe
2 
3 pragma solidity 0.4.24;
4 
5 
6 library SafeMath {
7 
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         require(c / a == b, "Assertion Failed");
14         return c;
15     }
16     
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0, "Assertion Failed");
19         uint256 c = a / b;
20         return c;
21     }
22 
23 }
24 
25 interface IERC20 {
26     function transfer(address to, uint256 value) external returns (bool);
27     function approve(address spender, uint256 value) external returns (bool);
28 }
29 
30 interface AddressRegistry {
31     function getAddr(string name) external view returns(address);
32 }
33 
34 interface MakerCDP {
35     function open() external returns (bytes32 cup);
36     function join(uint wad) external; // Join PETH
37     function give(bytes32 cup, address guy) external;
38     function lock(bytes32 cup, uint wad) external;
39     function draw(bytes32 cup, uint wad) external;
40     function per() external view returns (uint ray);
41 }
42 
43 interface PriceInterface {
44     function peek() external view returns (bytes32, bool);
45 }
46 
47 interface WETHFace {
48     function deposit() external payable;
49 }
50 
51 interface Swap {
52     function dai2eth(uint srcDAI) external returns (uint destETH);
53 }
54 
55 interface InstaBank {
56     function claimCDP(uint cdpNum) external;
57     function transferCDPInternal(uint cdpNum, address nextOwner) external;
58 }
59 
60 
61 contract Registry {
62     address public addressRegistry;
63     modifier onlyAdmin() {
64         require(
65             msg.sender == getAddress("admin"),
66             "Permission Denied"
67         );
68         _;
69     }
70     function getAddress(string name) internal view returns(address) {
71         AddressRegistry addrReg = AddressRegistry(addressRegistry);
72         return addrReg.getAddr(name);
73     }
74 }
75 
76 
77 contract GlobalVar is Registry {
78 
79     using SafeMath for uint;
80     using SafeMath for uint256;
81 
82     address public cdpAddr; // SaiTub
83     bool public freezed;
84 
85     function getETHRate() public view returns (uint) {
86         PriceInterface ethRate = PriceInterface(getAddress("ethfeed"));
87         bytes32 ethrate;
88         (ethrate, ) = ethRate.peek();
89         return uint(ethrate);
90     }
91 
92     function approveERC20() public {
93         IERC20 wethTkn = IERC20(getAddress("weth"));
94         wethTkn.approve(cdpAddr, 2**256 - 1);
95         IERC20 pethTkn = IERC20(getAddress("peth"));
96         pethTkn.approve(cdpAddr, 2**256 - 1);
97         IERC20 mkrTkn = IERC20(getAddress("mkr"));
98         mkrTkn.approve(cdpAddr, 2**256 - 1);
99         IERC20 daiTkn = IERC20(getAddress("dai"));
100         daiTkn.approve(cdpAddr, 2**256 - 1);
101     }
102 
103 }
104 
105 
106 contract LoopNewCDP is GlobalVar {
107 
108     event LevNewCDP(uint cdpNum, uint ethLocked, uint daiMinted);
109 
110     function pethPEReth(uint ethNum) public view returns (uint rPETH) {
111         MakerCDP loanMaster = MakerCDP(cdpAddr);
112         rPETH = (ethNum.mul(10 ** 27)).div(loanMaster.per());
113     }
114 
115     // useETH = msg.sender + personal ETH used to assist the operation
116     function riskNewCDP(uint eth2Lock, uint dai2Mint, bool isCDP2Sender) public payable {
117         require(!freezed, "Operation Disabled");
118 
119         uint contractETHBal = address(this).balance - msg.value;
120 
121         MakerCDP loanMaster = MakerCDP(cdpAddr);
122         bytes32 cup = loanMaster.open(); // New CDP
123 
124         WETHFace wethTkn = WETHFace(getAddress("weth"));
125         wethTkn.deposit.value(eth2Lock)(); // ETH to WETH
126         uint pethToLock = pethPEReth(eth2Lock); // PETH : ETH
127         loanMaster.join(pethToLock); // WETH to PETH
128         loanMaster.lock(cup, pethToLock); // PETH to CDP
129 
130         loanMaster.draw(cup, dai2Mint);
131         address dai2ethContract = getAddress("dai2eth");
132         IERC20 daiTkn = IERC20(getAddress("dai"));
133         daiTkn.transfer(dai2ethContract, dai2Mint); // DAI >>> dai2eth
134         Swap resolveSwap = Swap(dai2ethContract);
135         resolveSwap.dai2eth(dai2Mint); // DAI >>> ETH
136 
137         uint nowBal = address(this).balance;
138         if (nowBal > contractETHBal) {
139             msg.sender.transfer(nowBal - contractETHBal);
140         }
141         require(contractETHBal == address(this).balance, "No Refund of Contract ETH");
142 
143         if (isCDP2Sender) { // CDP >>> msg.sender
144             loanMaster.give(cup, msg.sender);
145         } else { // CDP >>> InstaBank
146             InstaBank resolveBank = InstaBank(getAddress("bankv2"));
147             resolveBank.claimCDP(uint(cup));
148             resolveBank.transferCDPInternal(uint(cup), msg.sender);
149         }
150 
151         emit LevNewCDP(uint(cup), eth2Lock, dai2Mint);
152     }
153 
154 }
155 
156 
157 contract LeverageCDP is LoopNewCDP {
158 
159     constructor(address rAddr) public {
160         addressRegistry = rAddr;
161         cdpAddr = getAddress("cdp");
162         approveERC20();
163     }
164 
165     function () public payable {}
166 
167     function collectETH(uint ethQty) public onlyAdmin {
168         msg.sender.transfer(ethQty);
169     }
170 
171     function freeze(bool stop) public onlyAdmin {
172         freezed = stop;
173     }
174 
175 }