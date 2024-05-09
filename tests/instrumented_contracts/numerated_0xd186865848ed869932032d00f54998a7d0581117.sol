1 pragma solidity ^0.4.24;
2 /*   
3  *    Exodus adaptation of OasisDirectProxy by MakerDAO.
4  *    Work in progress; Second Mainnet iteration.
5  */
6 contract OtcInterface {
7     function sellAllAmount(address, uint, address, uint) public returns (uint);
8     function buyAllAmount(address, uint, address, uint) public returns (uint);
9     function getPayAmount(address, address, uint) public constant returns (uint);
10 }
11 
12 contract TokenInterface {
13     function balanceOf(address) public returns (uint);
14     function allowance(address, address) public returns (uint);
15     function approve(address, uint) public;
16     function transfer(address,uint) public returns (bool);
17     function transferFrom(address, address, uint) public returns (bool);
18     function deposit() public payable;
19     function withdraw(uint) public;
20 }
21 
22 contract FeeInterface {
23     function rateOf (address token) public view returns (uint);
24     function takeFee (uint amt, address token) public view returns (uint fee, uint remaining);
25 }
26 
27 contract DSAuthority {
28     function canCall(
29         address src, address dst, bytes4 sig
30     ) public view returns (bool);
31 }
32 
33 contract DSAuthEvents {
34     event LogSetAuthority (address indexed authority);
35     event LogSetOwner     (address indexed owner);
36 }
37 
38 contract DSAuth is DSAuthEvents {
39     DSAuthority  public  authority;
40     address      public  owner;
41 
42     constructor() public {
43         owner = msg.sender;
44         emit LogSetOwner(msg.sender);
45     }
46 
47     function setOwner(address owner_)
48         public
49         auth
50     {
51         owner = owner_;
52         emit LogSetOwner(owner);
53     }
54 
55     function setAuthority(DSAuthority authority_)
56         public
57         auth
58     {
59         authority = authority_;
60         emit LogSetAuthority(authority);
61     }
62 
63     modifier auth {
64         require(isAuthorized(msg.sender, msg.sig));
65         _;
66     }
67 
68     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
69         if (src == address(this)) {
70             return true;
71         } else if (src == owner) {
72             return true;
73         } else if (authority == DSAuthority(0)) {
74             return false;
75         } else {
76             return authority.canCall(src, this, sig);
77         }
78     }
79 }
80 
81 contract Mortal is DSAuth {
82     function kill() public auth {
83         selfdestruct(owner);
84     }
85 }
86 
87 contract DSMath {
88     function add(uint x, uint y) internal pure returns (uint z) {
89         require((z = x + y) >= x);
90     }
91     function sub(uint x, uint y) internal pure returns (uint z) {
92         require((z = x - y) <= x);
93     }
94     function mul(uint x, uint y) internal pure returns (uint z) {
95         require(y == 0 || (z = x * y) / y == x);
96     }
97     function min(uint x, uint y) internal pure returns (uint z) {
98         return x <= y ? x : y;
99     }
100     function max(uint x, uint y) internal pure returns (uint z) {
101         return x >= y ? x : y;
102     }
103     function imin(int x, int y) internal pure returns (int z) {
104         return x <= y ? x : y;
105     }
106     function imax(int x, int y) internal pure returns (int z) {
107         return x >= y ? x : y;
108     }
109 
110     uint constant WAD = 10 ** 18;
111     uint constant RAY = 10 ** 27;
112 
113     function wmul(uint x, uint y) internal pure returns (uint z) {
114         z = add(mul(x, y), WAD / 2) / WAD;
115     }
116     function rmul(uint x, uint y) internal pure returns (uint z) {
117         z = add(mul(x, y), RAY / 2) / RAY;
118     }
119     function wdiv(uint x, uint y) internal pure returns (uint z) {
120         z = add(mul(x, WAD), y / 2) / y;
121     }
122     function rdiv(uint x, uint y) internal pure returns (uint z) {
123         z = add(mul(x, RAY), y / 2) / y;
124     }
125 
126     function rpow(uint x, uint n) internal pure returns (uint z) {
127         z = n % 2 != 0 ? x : RAY;
128 
129         for (n /= 2; n != 0; n /= 2) {
130             x = rmul(x, x);
131 
132             if (n % 2 != 0) {
133                 z = rmul(z, x);
134             }
135         }
136     }
137 }
138 
139 contract OasisMonetizedProxy is Mortal, DSMath {
140     uint feePercentageWad;
141     FeeInterface fees;
142     constructor(FeeInterface _fees) public {
143         fees = _fees;
144     }
145     
146     function setFeeAuthority (FeeInterface newSource) public auth {
147         fees = newSource;
148     }
149     
150     function withdrawAndSend(TokenInterface wethToken, uint wethAmt) internal {
151         wethToken.withdraw(wethAmt);
152         require(msg.sender.call.value(wethAmt)());
153     }
154 
155     /*** Public functions start here ***/
156     
157     function sellAllAmount(
158         OtcInterface otc,
159         TokenInterface payToken, 
160         uint payAmt, 
161         TokenInterface buyToken, 
162         uint minBuyAmt
163     ) public returns (uint) {
164         require(payToken.transferFrom(msg.sender, this, payAmt));
165         if (payToken.allowance(this, otc) < payAmt) {
166             payToken.approve(otc, uint(-1));
167         }
168         uint buyAmt = otc.sellAllAmount(payToken, payAmt, buyToken, minBuyAmt);
169         buyToken.balanceOf(this);
170         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken);
171         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
172         require(buyToken.transfer(msg.sender, buyAmtRemainder));
173         return buyAmtRemainder;
174     }
175 
176     function sellAllAmountPayEth(
177         OtcInterface otc,
178         TokenInterface wethToken,
179         TokenInterface buyToken,
180         uint minBuyAmt
181     ) public payable returns (uint) {
182         wethToken.deposit.value(msg.value)();
183         if (wethToken.allowance(this, otc) < msg.value) {
184             wethToken.approve(otc, uint(-1));
185         }
186         uint buyAmt = otc.sellAllAmount(wethToken, msg.value, buyToken, minBuyAmt); 
187         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken);
188         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
189         require(buyToken.transfer(msg.sender, buyAmtRemainder));
190         return buyAmtRemainder;
191     }
192 
193     function sellAllAmountBuyEth(
194         OtcInterface otc,
195         TokenInterface payToken, 
196         uint payAmt, 
197         TokenInterface wethToken, 
198         uint minBuyAmt
199     ) public returns (uint) {
200         require(payToken.transferFrom(msg.sender, this, payAmt));
201         if (payToken.allowance(this, otc) < payAmt) {
202             payToken.approve(otc, uint(-1));
203         }
204         uint wethAmt = otc.sellAllAmount(payToken, payAmt, wethToken, minBuyAmt);
205         (uint feeAmt, uint wethAmtRemainder) = fees.takeFee(wethAmt, wethToken);
206         require(wethToken.transfer(owner, feeAmt)); /* fee is taken in WETH */ 
207         withdrawAndSend(wethToken, wethAmtRemainder);
208         return wethAmtRemainder;
209     }
210 
211     function buyAllAmount(
212         OtcInterface otc, 
213         TokenInterface buyToken, 
214         uint buyAmt, 
215         TokenInterface payToken, 
216         uint maxPayAmt
217     ) public returns (uint payAmt) {
218         uint payAmtNow = otc.getPayAmount(payToken, buyToken, buyAmt);
219         require(payAmtNow <= maxPayAmt);
220         require(payToken.transferFrom(msg.sender, this, payAmtNow));
221         if (payToken.allowance(this, otc) < payAmtNow) {
222             payToken.approve(otc, uint(-1));
223         } 
224         payAmt = otc.buyAllAmount(buyToken, buyAmt, payToken, payAmtNow);
225         min(buyAmt, buyToken.balanceOf(this)); // To avoid rounding issues we check the minimum value
226         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken);
227         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
228         require(buyToken.transfer(msg.sender, buyAmtRemainder)); 
229     }
230 
231     function buyAllAmountPayEth(
232         OtcInterface otc, 
233         TokenInterface buyToken, 
234         uint buyAmt, 
235         TokenInterface wethToken
236     ) public payable returns (uint wethAmt) {
237         // In this case user needs to send more ETH than a estimated value, then contract will send back the rest
238         wethToken.deposit.value(msg.value)();
239         if (wethToken.allowance(this, otc) < msg.value) {
240             wethToken.approve(otc, uint(-1));
241         }
242         wethAmt = otc.buyAllAmount(buyToken, buyAmt, wethToken, msg.value);
243         buyAmt = min(buyAmt, buyToken.balanceOf(this)); // To avoid rounding issues we check the minimum value
244         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken); 
245         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
246         require(buyToken.transfer(msg.sender, buyAmtRemainder)); 
247         withdrawAndSend(wethToken, sub(msg.value, wethAmt)); /* return leftover eth */
248     }
249 
250     function buyAllAmountBuyEth(
251         OtcInterface otc, 
252         TokenInterface wethToken, 
253         uint wethAmt, 
254         TokenInterface payToken, 
255         uint maxPayAmt
256     ) public returns (uint payAmt) {
257         uint payAmtNow = otc.getPayAmount(payToken, wethToken, wethAmt);
258         require(payAmtNow <= maxPayAmt);
259         require(payToken.transferFrom(msg.sender, this, payAmtNow));
260         if (payToken.allowance(this, otc) < payAmtNow) {
261             payToken.approve(otc, uint(-1));
262         }
263         payAmt = otc.buyAllAmount(wethToken, wethAmt, payToken, payAmtNow);
264         (uint feeAmt, uint wethAmtRemainder) = fees.takeFee(wethAmt, wethToken);
265         require(wethToken.transfer(owner, feeAmt));
266         withdrawAndSend(wethToken, wethAmtRemainder);
267     }
268 
269     function() public payable {} /* fallback function */
270 }