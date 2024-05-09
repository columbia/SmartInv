1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function balanceOf(address who) external view returns (uint256);
5     function approve(address spender, uint256 value) external returns (bool);
6 }
7 
8 interface AddressRegistry {
9     function getAddr(string name) external view returns(address);
10 }
11 
12 interface Kyber {
13     function trade(
14         address src,
15         uint srcAmount,
16         address dest,
17         address destAddress,
18         uint maxDestAmount,
19         uint minConversionRate,
20         address walletId
21     ) external payable returns (uint);
22 
23     function getExpectedRate(
24         address src,
25         address dest,
26         uint srcQty
27     ) external view returns (uint, uint);
28 }
29 
30 
31 contract Registry {
32     address public addressRegistry;
33     modifier onlyAdmin() {
34         require(
35             msg.sender == getAddress("admin"),
36             "Permission Denied"
37         );
38         _;
39     }
40     function getAddress(string name) internal view returns(address) {
41         AddressRegistry addrReg = AddressRegistry(addressRegistry);
42         return addrReg.getAddr(name);
43     }
44 }
45 
46 
47 contract Trade is Registry {
48 
49     event KyberTrade(
50         address src,
51         uint srcAmt,
52         address dest,
53         uint destAmt,
54         address beneficiary,
55         uint minConversionRate,
56         address affiliate
57     );
58 
59     function approveDAIKyber() public {
60         IERC20 tokenFunctions = IERC20(getAddress("dai"));
61         tokenFunctions.approve(getAddress("kyber"), 2**255);
62     }
63 
64     function expectedETH(uint srcDAI) public view returns (uint, uint) {
65         Kyber kyberFunctions = Kyber(getAddress("kyber"));
66         return kyberFunctions.getExpectedRate(getAddress("dai"), getAddress("eth"), srcDAI);
67     }
68 
69     function dai2eth(uint srcDAI) public payable returns (uint destAmt) {
70         address src = getAddress("dai");
71         address dest = getAddress("eth");
72         uint minConversionRate;
73         (, minConversionRate) = expectedETH(srcDAI);
74 
75         // Interacting with Kyber Proxy Contract
76         Kyber kyberFunctions = Kyber(getAddress("kyber"));
77         destAmt = kyberFunctions.trade.value(msg.value)(
78             src,
79             srcDAI,
80             dest,
81             msg.sender,
82             2**255,
83             minConversionRate,
84             getAddress("admin")
85         );
86 
87         emit KyberTrade(
88             src, srcDAI, dest, destAmt, msg.sender, minConversionRate, getAddress("admin")
89         );
90 
91     }
92 
93 }
94 
95 
96 contract DAI2ETH is Trade {
97 
98     constructor(address rAddr) public {
99         addressRegistry = rAddr;
100         approveDAIKyber();
101     }
102 
103     function () public payable {}
104 
105 }