1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b, "Assertion Failed");
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0, "Assertion Failed");
16         uint256 c = a / b;
17         return c;
18     }
19 
20 }
21 
22 interface IERC20 {
23     function transfer(address to, uint256 value) external returns (bool);
24     function approve(address spender, uint256 value) external returns (bool);
25 }
26 
27 interface AddressRegistry {
28     function getAddr(string calldata name) external view returns (address);
29 }
30 
31 interface MakerCDP {
32     function open() external returns (bytes32 cup);
33     function join(uint wad) external; // Join PETH
34     function give(bytes32 cup, address guy) external;
35     function lock(bytes32 cup, uint wad) external;
36     function draw(bytes32 cup, uint wad) external;
37     function per() external view returns (uint ray);
38 }
39 
40 interface PriceInterface {
41     function peek() external view returns (bytes32, bool);
42 }
43 
44 interface WETHFace {
45     function deposit() external payable;
46 }
47 
48 interface Swap {
49     function dai2eth(uint srcDAI) external returns (uint destETH);
50 }
51 
52 interface InstaBank {
53     function claimCDP(uint cdpNum) external;
54     function transferCDPInternal(uint cdpNum, address nextOwner) external;
55 }
56 
57 
58 contract Registry {
59     address public addressRegistry;
60     modifier onlyAdmin() {
61         require(msg.sender == getAddress("admin"), "Permission Denied");
62         _;
63     }
64     function getAddress(string memory name) internal view returns (address) {
65         AddressRegistry addrReg = AddressRegistry(addressRegistry);
66         return addrReg.getAddr(name);
67     }
68 }
69 
70 
71 contract GlobalVar is Registry {
72     using SafeMath for uint;
73     using SafeMath for uint256;
74 
75     address public cdpAddr; // SaiTub
76     bool public freezed;
77 
78     function getETHRate() public view returns (uint) {
79         PriceInterface ethRate = PriceInterface(getAddress("ethfeed"));
80         bytes32 ethrate;
81         (ethrate, ) = ethRate.peek();
82         return uint(ethrate);
83     }
84 
85     function approveERC20() public {
86         IERC20 wethTkn = IERC20(getAddress("weth"));
87         wethTkn.approve(cdpAddr, 2 ** 256 - 1);
88         IERC20 pethTkn = IERC20(getAddress("peth"));
89         pethTkn.approve(cdpAddr, 2 ** 256 - 1);
90         IERC20 mkrTkn = IERC20(getAddress("mkr"));
91         mkrTkn.approve(cdpAddr, 2 ** 256 - 1);
92         IERC20 daiTkn = IERC20(getAddress("dai"));
93         daiTkn.approve(cdpAddr, 2 ** 256 - 1);
94     }
95 
96 }
97 
98 
99 contract LoopNewCDP is GlobalVar {
100     event LevNewCDP(uint cdpNum, address borrower, uint ethLocked, uint daiMinted);
101 
102     function pethPEReth(uint ethNum) public view returns (uint rPETH) {
103         MakerCDP loanMaster = MakerCDP(cdpAddr);
104         rPETH = (ethNum.mul(10 ** 27)).div(loanMaster.per());
105     }
106 
107     // useETH = msg.sender + personal ETH used to assist the operation
108     function riskNewCDP(uint eth2Lock, uint dai2Mint, bool isCDP2Sender) public payable {
109         require(!freezed, "Operation Disabled");
110 
111         uint contractETHBal = address(this).balance - msg.value;
112 
113         MakerCDP loanMaster = MakerCDP(cdpAddr);
114         bytes32 cup = loanMaster.open(); // New CDP
115 
116         WETHFace wethTkn = WETHFace(getAddress("weth"));
117         wethTkn.deposit.value(eth2Lock)(); // ETH to WETH
118         uint pethToLock = pethPEReth(eth2Lock); // PETH : ETH
119         loanMaster.join(pethToLock); // WETH to PETH
120         loanMaster.lock(cup, pethToLock); // PETH to CDP
121 
122         loanMaster.draw(cup, dai2Mint);
123         address dai2ethContract = getAddress("dai2eth");
124         IERC20 daiTkn = IERC20(getAddress("dai"));
125         daiTkn.transfer(dai2ethContract, dai2Mint); // DAI >>> dai2eth
126         Swap resolveSwap = Swap(dai2ethContract);
127         resolveSwap.dai2eth(dai2Mint); // DAI >>> ETH
128 
129         uint nowBal = address(this).balance;
130         if (nowBal > contractETHBal) {
131             msg.sender.transfer(nowBal - contractETHBal);
132         }
133         require(contractETHBal == address(this).balance, "No Refund of Contract ETH");
134 
135         if (isCDP2Sender) {
136             // CDP >>> msg.sender
137             loanMaster.give(cup, msg.sender);
138         } else {
139             // CDP >>> InstaBank
140             InstaBank resolveBank = InstaBank(getAddress("bankv2"));
141             resolveBank.claimCDP(uint(cup));
142             resolveBank.transferCDPInternal(uint(cup), msg.sender);
143         }
144 
145         emit LevNewCDP(uint(cup), msg.sender, eth2Lock, dai2Mint);
146     }
147 
148 }
149 
150 
151 contract LeverageCDP is LoopNewCDP {
152     constructor(address rAddr) public {
153         addressRegistry = rAddr;
154         cdpAddr = getAddress("cdp");
155         approveERC20();
156     }
157 
158     function() external payable {}
159 
160     function collectETH(uint ethQty) public onlyAdmin {
161         msg.sender.transfer(ethQty);
162     }
163 
164     function freeze(bool stop) public onlyAdmin {
165         freezed = stop;
166     }
167 
168 }