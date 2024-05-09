1 /*   
2  *    Exodus adaptation of OasisDirectProxy by MakerDAO.
3  *    Edited by Konnor Klashinsky (kklash).
4  *    Work in progress, first Mainnet iteration.
5  */
6 pragma solidity ^0.4.24;
7 
8 
9 contract DSMath {
10     function add(uint x, uint y) internal pure returns (uint z) {
11         require((z = x + y) >= x);
12     }
13     function sub(uint x, uint y) internal pure returns (uint z) {
14         require((z = x - y) <= x);
15     }
16     function mul(uint x, uint y) internal pure returns (uint z) {
17         require(y == 0 || (z = x * y) / y == x);
18     }
19     function min(uint x, uint y) internal pure returns (uint z) {
20         return x <= y ? x : y;
21     }
22     function max(uint x, uint y) internal pure returns (uint z) {
23         return x >= y ? x : y;
24     }
25     function imin(int x, int y) internal pure returns (int z) {
26         return x <= y ? x : y;
27     }
28     function imax(int x, int y) internal pure returns (int z) {
29         return x >= y ? x : y;
30     }
31 
32     uint constant WAD = 10 ** 18;
33     uint constant RAY = 10 ** 27;
34 
35     function wmul(uint x, uint y) internal pure returns (uint z) {
36         z = add(mul(x, y), WAD / 2) / WAD;
37     }
38     function rmul(uint x, uint y) internal pure returns (uint z) {
39         z = add(mul(x, y), RAY / 2) / RAY;
40     }
41     function wdiv(uint x, uint y) internal pure returns (uint z) {
42         z = add(mul(x, WAD), y / 2) / y;
43     }
44     function rdiv(uint x, uint y) internal pure returns (uint z) {
45         z = add(mul(x, RAY), y / 2) / y;
46     }
47 
48     function rpow(uint x, uint n) internal pure returns (uint z) {
49         z = n % 2 != 0 ? x : RAY;
50 
51         for (n /= 2; n != 0; n /= 2) {
52             x = rmul(x, x);
53 
54             if (n % 2 != 0) {
55                 z = rmul(z, x);
56             }
57         }
58     }
59 }
60 
61 contract OtcInterface {
62     function sellAllAmount(address, uint, address, uint) public returns (uint);
63     function buyAllAmount(address, uint, address, uint) public returns (uint);
64     function getPayAmount(address, address, uint) public constant returns (uint);
65 }
66 
67 contract TokenInterface {
68     function balanceOf(address) public returns (uint);
69     function allowance(address, address) public returns (uint);
70     function approve(address, uint) public;
71     function transfer(address,uint) public returns (bool);
72     function transferFrom(address, address, uint) public returns (bool);
73     function deposit() public payable;
74     function withdraw(uint) public;
75 }
76 
77 contract Control {
78 /* TODO: convert to DSAuth if needed */
79     address owner;
80     
81     modifier auth {
82          require(msg.sender == owner);
83          _; /* func body goes here */
84     }
85 
86     function withdrawTo(address _to, uint amt) public auth {
87         _to.transfer(amt);
88     }
89     
90     function withdrawTokenTo(TokenInterface token, address _to, uint amt) public auth {
91         require(token.transfer(_to, amt));
92     }
93 
94     function kill() public auth {
95         selfdestruct(owner);
96     }
97 }
98 
99 contract OasisDirectProxy is Control, DSMath {
100     uint feePercentageWad;
101     
102     constructor() public {
103         owner = msg.sender;
104         feePercentageWad = 0.01 ether; /* set initial fee to 1% */
105     }
106 
107     function newFee(uint newFeePercentageWad) public auth {
108         require(newFeePercentageWad <= 1 ether);
109         feePercentageWad = newFeePercentageWad;
110     }
111 
112     function takeFee(uint amt) public view returns (uint fee, uint remaining) {
113        /* shave the fee off of an amount */
114         fee = wmul(amt*WAD, feePercentageWad) / WAD;
115         remaining = sub(amt, fee);
116     }
117     
118     function withdrawAndSend(TokenInterface wethToken, uint wethAmt) internal {
119         wethToken.withdraw(wethAmt);
120         require(msg.sender.call.value(wethAmt)());
121     }
122     
123     function sellAllAmount(
124         OtcInterface otc,
125         TokenInterface payToken, 
126         uint payAmt, 
127         TokenInterface buyToken, 
128         uint minBuyAmt
129     ) public returns (uint) {
130         require(payToken.transferFrom(msg.sender, this, payAmt));
131         if (payToken.allowance(this, otc) < payAmt) {
132             payToken.approve(otc, uint(-1));
133         }
134         uint buyAmt = otc.sellAllAmount(payToken, payAmt, buyToken, minBuyAmt);
135         (uint feeAmt, uint buyAmtRemainder) = takeFee(buyAmt);
136         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
137         require(buyToken.transfer(msg.sender, buyAmtRemainder));
138         return buyAmtRemainder;
139     }
140 
141     function sellAllAmountPayEth(
142         OtcInterface otc,
143         TokenInterface wethToken,
144         TokenInterface buyToken,
145         uint minBuyAmt
146     ) public payable returns (uint) {
147         wethToken.deposit.value(msg.value)();
148         if (wethToken.allowance(this, otc) < msg.value) {
149             wethToken.approve(otc, uint(-1));
150         }
151         uint buyAmt = otc.sellAllAmount(wethToken, msg.value, buyToken, minBuyAmt);
152         (uint feeAmt, uint buyAmtRemainder) = takeFee(buyAmt);
153         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
154         require(buyToken.transfer(msg.sender, buyAmtRemainder));
155         return buyAmtRemainder;
156     }
157 
158     function sellAllAmountBuyEth(
159         OtcInterface otc,
160         TokenInterface payToken, 
161         uint payAmt, 
162         TokenInterface wethToken, 
163         uint minBuyAmt
164     ) public returns (uint) {
165         require(payToken.transferFrom(msg.sender, this, payAmt));
166         if (payToken.allowance(this, otc) < payAmt) {
167             payToken.approve(otc, uint(-1));
168         }
169         uint wethAmt = otc.sellAllAmount(payToken, payAmt, wethToken, minBuyAmt);
170         (uint feeAmt, uint wethAmtRemainder) = takeFee(wethAmt);
171         require(wethToken.transfer(owner, feeAmt)); /* fee is taken in WETH */ 
172         withdrawAndSend(wethToken, wethAmtRemainder);
173         return wethAmtRemainder;
174     }
175 
176     function buyAllAmount(
177         OtcInterface otc, 
178         TokenInterface buyToken, 
179         uint buyAmt, 
180         TokenInterface payToken, 
181         uint maxPayAmt
182     ) public returns (uint payAmt) {
183         uint payAmtNow = otc.getPayAmount(payToken, buyToken, buyAmt);
184         require(payAmtNow <= maxPayAmt);
185         require(payToken.transferFrom(msg.sender, this, payAmtNow));
186         if (payToken.allowance(this, otc) < payAmtNow) {
187             payToken.approve(otc, uint(-1));
188         } 
189         payAmt = otc.buyAllAmount(buyToken, buyAmt, payToken, payAmtNow);
190         require(buyToken.transfer(msg.sender, min(buyAmt, buyToken.balanceOf(this)))); // To avoid rounding issues we check the minimum value
191                                 /* TODO: Find out what this is for, before touching it */
192     }
193 
194     function buyAllAmountPayEth(
195         OtcInterface otc, 
196         TokenInterface buyToken, 
197         uint buyAmt, 
198         TokenInterface wethToken
199     ) public payable returns (uint wethAmt) {
200         // In this case user needs to send more ETH than a estimated value, then contract will send back the rest
201         wethToken.deposit.value(msg.value)();
202         if (wethToken.allowance(this, otc) < msg.value) {
203             wethToken.approve(otc, uint(-1));
204         }
205         wethAmt = otc.buyAllAmount(buyToken, buyAmt, wethToken, msg.value);
206         require(buyToken.transfer(msg.sender, min(buyAmt, buyToken.balanceOf(this)))); // To avoid rounding issues we check the minimum value
207                                                        /* TODO: Find out what this is for, before touching it */
208         withdrawAndSend(wethToken, sub(msg.value, wethAmt));
209     }
210 
211     function buyAllAmountBuyEth(
212         OtcInterface otc, 
213         TokenInterface wethToken, 
214         uint wethAmt, 
215         TokenInterface payToken, 
216         uint maxPayAmt
217     ) public returns (uint payAmt) {
218         uint payAmtNow = otc.getPayAmount(payToken, wethToken, wethAmt);
219         require(payAmtNow <= maxPayAmt);
220         require(payToken.transferFrom(msg.sender, this, payAmtNow));
221         if (payToken.allowance(this, otc) < payAmtNow) {
222             payToken.approve(otc, uint(-1));
223         }
224         payAmt = otc.buyAllAmount(wethToken, wethAmt, payToken, payAmtNow);
225         (uint feeAmt, uint wethAmtRemainder) = takeFee(wethAmt);
226         require(wethToken.transfer(owner, feeAmt));
227         withdrawAndSend(wethToken, wethAmtRemainder);
228     }
229 
230     function() public payable {}
231 }