1 pragma solidity ^0.4.24;
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
34 interface Kyber {
35     function trade(
36         address src,
37         uint srcAmount,
38         address dest,
39         address destAddress,
40         uint maxDestAmount,
41         uint minConversionRate,
42         address walletId
43     ) external payable returns (uint);
44 
45     function getExpectedRate(
46         address src,
47         address dest,
48         uint srcQty
49     ) external view returns (uint, uint);
50 }
51 
52 
53 contract Registry {
54     address public addressRegistry;
55     modifier onlyAdmin() {
56         require(
57             msg.sender == getAddress("admin"),
58             "Permission Denied"
59         );
60         _;
61     }
62     function getAddress(string name) internal view returns(address) {
63         AddressRegistry addrReg = AddressRegistry(addressRegistry);
64         return addrReg.getAddr(name);
65     }
66 
67 }
68 
69 
70 contract Trade is Registry {
71 
72     using SafeMath for uint;
73     using SafeMath for uint256;
74 
75     event KyberTrade(
76         address src,
77         uint srcAmt,
78         address dest,
79         uint destAmt,
80         address beneficiary,
81         uint minConversionRate,
82         address affiliate
83     );
84 
85     function getExpectedPrice(
86         address src,
87         address dest,
88         uint srcAmt
89     ) public view returns (uint, uint) 
90     {
91         Kyber kyberFunctions = Kyber(getAddress("kyber"));
92         return kyberFunctions.getExpectedRate(
93             src,
94             dest,
95             srcAmt
96         );
97     }
98 
99     function approveKyber(address[] tokenArr) public {
100         address kyberProxy = getAddress("kyber");
101         for (uint i = 0; i < tokenArr.length; i++) {
102             IERC20 tokenFunctions = IERC20(tokenArr[i]);
103             tokenFunctions.approve(kyberProxy, 2**256 - 1);
104         }
105     }
106 
107     function executeTrade(
108         address src, // token to sell
109         address dest, // token to buy
110         uint srcAmt, // amount of token for sell
111         uint minConversionRate, // minimum slippage rate
112         uint maxDestAmt // max amount of dest token
113     ) public payable returns (uint destAmt)
114     {
115 
116         address eth = getAddress("eth");
117         uint ethQty = getToken(
118             msg.sender,
119             src,
120             srcAmt,
121             eth
122         );
123         
124         // Interacting with Kyber Proxy Contract
125         Kyber kyberFunctions = Kyber(getAddress("kyber"));
126         destAmt = kyberFunctions.trade.value(ethQty)(
127             src,
128             srcAmt,
129             dest,
130             msg.sender,
131             maxDestAmt,
132             minConversionRate,
133             getAddress("admin")
134         );
135 
136         // maxDestAmt usecase implementated
137         if (src == eth && address(this).balance > 0) {
138             msg.sender.transfer(address(this).balance);
139         } else if (src != eth) { // as there is no balanceOf of eth
140             IERC20 srcTkn = IERC20(src);
141             uint srcBal = srcTkn.balanceOf(address(this));
142             if (srcBal > 0) {
143                 srcTkn.transfer(msg.sender, srcBal);
144             }
145         }
146 
147         emit KyberTrade(
148             src,
149             srcAmt,
150             dest,
151             destAmt,
152             msg.sender,
153             minConversionRate,
154             getAddress("admin")
155         );
156 
157     }
158 
159     function getToken(
160         address trader,
161         address src,
162         uint srcAmt,
163         address eth
164     ) internal returns (uint ethQty)
165     {
166         if (src == eth) {
167             require(msg.value == srcAmt, "Invalid Operation");
168             ethQty = srcAmt;
169         } else {
170             IERC20 tokenFunctions = IERC20(src);
171             tokenFunctions.transferFrom(trader, address(this), srcAmt);
172             ethQty = 0;
173         }
174     }
175 
176 }
177 
178 
179 contract InstaKyber is Trade {
180 
181     constructor(address rAddr) public {
182         addressRegistry = rAddr;
183     }
184 
185     function () public payable {}
186 
187 }