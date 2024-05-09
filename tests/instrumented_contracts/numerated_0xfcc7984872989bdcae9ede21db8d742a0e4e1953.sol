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
55         uint minConversionRate
56     );
57 
58     function approveDAIKyber() public {
59         IERC20 tokenFunctions = IERC20(getAddress("dai"));
60         tokenFunctions.approve(getAddress("kyber"), 2**255);
61     }
62 
63     function expectedETH(uint srcDAI) public view returns (uint, uint) {
64         Kyber kyberFunctions = Kyber(getAddress("kyber"));
65         return kyberFunctions.getExpectedRate(getAddress("dai"), getAddress("eth"), srcDAI);
66     }
67 
68     function dai2eth(uint srcDAI) public returns (uint destAmt) {
69         address src = getAddress("dai");
70         address dest = getAddress("eth");
71         uint minConversionRate;
72         (, minConversionRate) = expectedETH(srcDAI);
73 
74         // Interacting with Kyber Proxy Contract
75         Kyber kyberFunctions = Kyber(getAddress("kyber"));
76         destAmt = kyberFunctions.trade.value(0)(
77             src,
78             srcDAI,
79             dest,
80             msg.sender,
81             2**255,
82             minConversionRate,
83             getAddress("admin")
84         );
85 
86         emit KyberTrade(
87             src, srcDAI, dest, destAmt, msg.sender, minConversionRate
88         );
89 
90     }
91 
92 }
93 
94 
95 contract DAI2ETH is Trade {
96 
97     constructor(address rAddr) public {
98         addressRegistry = rAddr;
99         approveDAIKyber();
100     }
101 
102     function () public payable {}
103 
104 }