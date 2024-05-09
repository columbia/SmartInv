1 pragma solidity ^0.4.16;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     // This famous algorithm is called "exponentiation by squaring"
44     // and calculates x^n with x as fixed-point and n as regular unsigned.
45     //
46     // It's O(log n), instead of O(n) for naive repeated multiplication.
47     //
48     // These facts are why it works:
49     //
50     //  If n is even, then x^n = (x^2)^(n/2).
51     //  If n is odd,  then x^n = x * x^(n-1),
52     //   and applying the equation for even x gives
53     //    x^n = x * (x^2)^((n-1) / 2).
54     //
55     //  Also, EVM division is flooring and
56     //    floor[(n-1) / 2] = floor[n / 2].
57     //
58     function rpow(uint x, uint n) internal pure returns (uint z) {
59         z = n % 2 != 0 ? x : RAY;
60 
61         for (n /= 2; n != 0; n /= 2) {
62             x = rmul(x, x);
63 
64             if (n % 2 != 0) {
65                 z = rmul(z, x);
66             }
67         }
68     }
69 }
70 
71 contract OtcInterface {
72     function sellAllAmount(address, uint, address, uint) public returns (uint);
73     function buyAllAmount(address, uint, address, uint) public returns (uint);
74     function getPayAmount(address, address, uint) public constant returns (uint);
75 }
76 
77 contract TokenInterface {
78     function balanceOf(address) public returns (uint);
79     function allowance(address, address) public returns (uint);
80     function approve(address, uint) public;
81     function transfer(address,uint) public returns (bool);
82     function transferFrom(address, address, uint) public returns (bool);
83     function deposit() public payable;
84     function withdraw(uint) public;
85 }
86 
87 contract OasisDirectProxy is DSMath {
88     function withdrawAndSend(TokenInterface wethToken, uint wethAmt) internal {
89         wethToken.withdraw(wethAmt);
90         require(msg.sender.call.value(wethAmt)());
91     }
92 
93     function sellAllAmount(OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface buyToken, uint minBuyAmt) public returns (uint buyAmt) {
94         require(payToken.transferFrom(msg.sender, this, payAmt));
95         if (payToken.allowance(this, otc) < payAmt) {
96             payToken.approve(otc, uint(-1));
97         }
98         buyAmt = otc.sellAllAmount(payToken, payAmt, buyToken, minBuyAmt);
99         require(buyToken.transfer(msg.sender, buyAmt));
100     }
101 
102     function sellAllAmountPayEth(OtcInterface otc, TokenInterface wethToken, TokenInterface buyToken, uint minBuyAmt) public payable returns (uint buyAmt) {
103         wethToken.deposit.value(msg.value)();
104         if (wethToken.allowance(this, otc) < msg.value) {
105             wethToken.approve(otc, uint(-1));
106         }
107         buyAmt = otc.sellAllAmount(wethToken, msg.value, buyToken, minBuyAmt);
108         require(buyToken.transfer(msg.sender, buyAmt));
109     }
110 
111     function sellAllAmountBuyEth(OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface wethToken, uint minBuyAmt) public returns (uint wethAmt) {
112         require(payToken.transferFrom(msg.sender, this, payAmt));
113         if (payToken.allowance(this, otc) < payAmt) {
114             payToken.approve(otc, uint(-1));
115         }
116         wethAmt = otc.sellAllAmount(payToken, payAmt, wethToken, minBuyAmt);
117         withdrawAndSend(wethToken, wethAmt);
118     }
119 
120     function buyAllAmount(OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface payToken, uint maxPayAmt) public returns (uint payAmt) {
121         uint payAmtNow = otc.getPayAmount(payToken, buyToken, buyAmt);
122         require(payAmtNow <= maxPayAmt);
123         require(payToken.transferFrom(msg.sender, this, payAmtNow));
124         if (payToken.allowance(this, otc) < payAmtNow) {
125             payToken.approve(otc, uint(-1));
126         }
127         payAmt = otc.buyAllAmount(buyToken, buyAmt, payToken, payAmtNow);
128         require(buyToken.transfer(msg.sender, min(buyAmt, buyToken.balanceOf(this)))); // To avoid rounding issues we check the minimum value
129     }
130 
131     function buyAllAmountPayEth(OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface wethToken) public payable returns (uint wethAmt) {
132         // In this case user needs to send more ETH than a estimated value, then contract will send back the rest
133         wethToken.deposit.value(msg.value)();
134         if (wethToken.allowance(this, otc) < msg.value) {
135             wethToken.approve(otc, uint(-1));
136         }
137         wethAmt = otc.buyAllAmount(buyToken, buyAmt, wethToken, msg.value);
138         require(buyToken.transfer(msg.sender, min(buyAmt, buyToken.balanceOf(this)))); // To avoid rounding issues we check the minimum value
139         withdrawAndSend(wethToken, sub(msg.value, wethAmt));
140     }
141 
142     function buyAllAmountBuyEth(OtcInterface otc, TokenInterface wethToken, uint wethAmt, TokenInterface payToken, uint maxPayAmt) public returns (uint payAmt) {
143         uint payAmtNow = otc.getPayAmount(payToken, wethToken, wethAmt);
144         require(payAmtNow <= maxPayAmt);
145         require(payToken.transferFrom(msg.sender, this, payAmtNow));
146         if (payToken.allowance(this, otc) < payAmtNow) {
147             payToken.approve(otc, uint(-1));
148         }
149         payAmt = otc.buyAllAmount(wethToken, wethAmt, payToken, payAmtNow);
150         withdrawAndSend(wethToken, wethAmt);
151     }
152 
153     function() public payable {}
154 }