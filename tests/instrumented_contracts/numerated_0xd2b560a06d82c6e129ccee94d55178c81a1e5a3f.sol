1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     function transferFrom(address from, address to, uint256 value) external returns (bool);
6     function transfer(address to, uint256 value) external returns (bool);
7 }
8 
9 interface Kyber {
10     function trade(
11         address src,
12         uint srcAmount,
13         address dest,
14         address destAddress,
15         uint maxDestAmount,
16         uint minConversionRate,
17         address walletId
18     ) external payable returns (uint);
19 
20     function getExpectedRate(
21         address src,
22         address dest,
23         uint srcQty
24     ) external view returns (uint, uint);
25 }
26 
27 
28 contract KyberSwap {
29 
30     address public kyberAddress;
31     address public daiAddress;
32     address public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
33     address public admin;
34     uint public fees;
35 
36     modifier onlyAdmin() {
37         require(msg.sender == admin, "Permission Denied");
38         _;
39     }
40 
41     function getExpectedPrice(
42         address src,
43         address dest,
44         uint srcAmt
45     ) public view returns (uint, uint)
46     {
47         Kyber kyberFunctions = Kyber(kyberAddress);
48         return kyberFunctions.getExpectedRate(
49             src,
50             dest,
51             srcAmt
52         );
53     }
54 
55 }
56 
57 
58 contract PayModel is KyberSwap {
59 
60     event Paid(address payer, address receiver, uint amount, address token);
61 
62     function payETH(
63         uint daiToPay, // max amount of dest token
64         address payTo
65     ) public payable returns (uint destAmt)
66     {
67         Kyber kyberFunctions = Kyber(kyberAddress); // Interacting with Kyber Proxy Contract
68 
69         uint minConversionRate;
70         (, minConversionRate) = kyberFunctions.getExpectedRate(
71             ethAddress,
72             daiAddress,
73             msg.value
74         );
75         
76         destAmt = kyberFunctions.trade.value(msg.value)(
77             ethAddress, // src is ETH
78             msg.value, // srcAmt
79             daiAddress, // dest is DAI
80             address(this), // destAmt receiver
81             daiToPay, // max destAmt
82             minConversionRate, // min accepted conversion rate
83             admin // affiliate
84         );
85         require(daiToPay == destAmt, "Can't pay less.");
86 
87         IERC20 daiToken = IERC20(daiAddress);
88         daiToken.transfer(payTo, daiToPay * fees / 1000);
89         
90         // maxDestAmt usecase implementated (only works with ETH)
91         msg.sender.transfer(address(this).balance);
92 
93         emit Paid(
94             msg.sender, payTo, daiToPay, ethAddress
95         );
96     }
97 
98     function payDAI(address payTo, uint daiToPay) public {
99         IERC20 daiToken = IERC20(daiAddress);
100         daiToken.transferFrom(msg.sender, payTo, daiToPay * fees / 1000);
101         emit Paid(
102             msg.sender, payTo, daiToPay, daiAddress
103         );
104     }
105 
106 }
107 
108 
109 contract PayDApp is PayModel {
110 
111     constructor(address proxyAddr, address daiAddr) public {
112         kyberAddress = proxyAddr;
113         daiAddress = daiAddr;
114         admin = msg.sender;
115         fees = 995;
116     }
117 
118     function () external payable {}
119 
120     function setFees(uint newFee) public onlyAdmin {
121         fees = newFee;
122     }
123 
124     function collectFees(uint amount) public onlyAdmin {
125         IERC20 daiToken = IERC20(daiAddress);
126         daiToken.transfer(admin, amount);
127     }
128 
129     function setAdmin(address newAdmin) public onlyAdmin {
130         admin = newAdmin;
131     }
132 
133 }