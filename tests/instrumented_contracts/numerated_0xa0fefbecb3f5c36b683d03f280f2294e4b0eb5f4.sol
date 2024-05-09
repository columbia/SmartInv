1 /*   
2  *    Exodus adaptation of OasisDirectProxy by MakerDAO.
3  *    Edited by Konnor Klashinsky (kklash).
4  *    Work in progress; Second Mainnet iteration.
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
61 
62 contract DSAuthority {
63     function canCall(
64         address src, address dst, bytes4 sig
65     ) public view returns (bool);
66 }
67 
68 contract DSAuthEvents {
69     event LogSetAuthority (address indexed authority);
70     event LogSetOwner     (address indexed owner);
71 }
72 
73 contract DSAuth is DSAuthEvents {
74     DSAuthority  public  authority;
75     address      public  owner;
76 
77     constructor() public {
78         owner = msg.sender;
79         emit LogSetOwner(msg.sender);
80     }
81 
82     function setOwner(address owner_)
83         public
84         auth
85     {
86         owner = owner_;
87         emit LogSetOwner(owner);
88     }
89 
90     function setAuthority(DSAuthority authority_)
91         public
92         auth
93     {
94         authority = authority_;
95         emit LogSetAuthority(authority);
96     }
97 
98     modifier auth {
99         require(isAuthorized(msg.sender, msg.sig));
100         _;
101     }
102 
103     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
104         if (src == address(this)) {
105             return true;
106         } else if (src == owner) {
107             return true;
108         } else if (authority == DSAuthority(0)) {
109             return false;
110         } else {
111             return authority.canCall(src, this, sig);
112         }
113     }
114 }
115 
116 contract OtcInterface {
117     function sellAllAmount(address, uint, address, uint) public returns (uint);
118     function buyAllAmount(address, uint, address, uint) public returns (uint);
119     function getPayAmount(address, address, uint) public constant returns (uint);
120 }
121 
122 
123 contract TokenInterface {
124     function balanceOf(address) public returns (uint);
125     function allowance(address, address) public returns (uint);
126     function approve(address, uint) public;
127     function transfer(address,uint) public returns (bool);
128     function transferFrom(address, address, uint) public returns (bool);
129     function deposit() public payable;
130     function withdraw(uint) public;
131 }
132 
133 contract Mortal is DSAuth {
134     function kill() public auth {
135         selfdestruct(owner);
136     }
137 }
138 
139 contract OasisDirectProxy is Mortal, DSMath {
140     uint feePercentageWad;
141     
142     constructor() public {
143         feePercentageWad = 0.01 ether; /* set initial fee to 1% */
144     }
145 
146     function newFee(uint newFeePercentageWad) public auth {
147         require(newFeePercentageWad <= 1 ether);
148         feePercentageWad = newFeePercentageWad;
149     }
150 
151     function takeFee(uint amt) public view returns (uint fee, uint remaining) {
152        /* shave the fee off of an amount */
153         fee = mul(amt, feePercentageWad) / WAD;
154         remaining = sub(amt, fee);
155     }
156     
157     function withdrawAndSend(TokenInterface wethToken, uint wethAmt) internal {
158         wethToken.withdraw(wethAmt);
159         require(msg.sender.call.value(wethAmt)());
160     }
161     
162     /* 
163      *   Public functions start here
164      */
165     
166     function sellAllAmount(
167         OtcInterface otc,
168         TokenInterface payToken, 
169         uint payAmt, 
170         TokenInterface buyToken, 
171         uint minBuyAmt
172     ) public returns (uint) {
173         require(payToken.transferFrom(msg.sender, this, payAmt));
174         if (payToken.allowance(this, otc) < payAmt) {
175             payToken.approve(otc, uint(-1));
176         }
177         uint buyAmt = otc.sellAllAmount(payToken, payAmt, buyToken, minBuyAmt);
178         (uint feeAmt, uint buyAmtRemainder) = takeFee(buyAmt);
179         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
180         require(buyToken.transfer(msg.sender, buyAmtRemainder));
181         return buyAmtRemainder;
182     }
183 
184     function sellAllAmountPayEth(
185         OtcInterface otc,
186         TokenInterface wethToken,
187         TokenInterface buyToken,
188         uint minBuyAmt
189     ) public payable returns (uint) {
190         wethToken.deposit.value(msg.value)();
191         if (wethToken.allowance(this, otc) < msg.value) {
192             wethToken.approve(otc, uint(-1));
193         }
194         uint buyAmt = otc.sellAllAmount(wethToken, msg.value, buyToken, minBuyAmt);
195         (uint feeAmt, uint buyAmtRemainder) = takeFee(buyAmt);
196         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
197         require(buyToken.transfer(msg.sender, buyAmtRemainder));
198         return buyAmtRemainder;
199     }
200 
201     function sellAllAmountBuyEth(
202         OtcInterface otc,
203         TokenInterface payToken, 
204         uint payAmt, 
205         TokenInterface wethToken, 
206         uint minBuyAmt
207     ) public returns (uint) {
208         require(payToken.transferFrom(msg.sender, this, payAmt));
209         if (payToken.allowance(this, otc) < payAmt) {
210             payToken.approve(otc, uint(-1));
211         }
212         uint wethAmt = otc.sellAllAmount(payToken, payAmt, wethToken, minBuyAmt);
213         (uint feeAmt, uint wethAmtRemainder) = takeFee(wethAmt);
214         require(wethToken.transfer(owner, feeAmt)); /* fee is taken in WETH */ 
215         withdrawAndSend(wethToken, wethAmtRemainder);
216         return wethAmtRemainder;
217     }
218 
219     function buyAllAmount(
220         OtcInterface otc, 
221         TokenInterface buyToken, 
222         uint buyAmt, 
223         TokenInterface payToken, 
224         uint maxPayAmt
225     ) public returns (uint payAmt) {
226         uint payAmtNow = otc.getPayAmount(payToken, buyToken, buyAmt);
227         require(payAmtNow <= maxPayAmt);
228         require(payToken.transferFrom(msg.sender, this, payAmtNow));
229         if (payToken.allowance(this, otc) < payAmtNow) {
230             payToken.approve(otc, uint(-1));
231         } 
232         payAmt = otc.buyAllAmount(buyToken, buyAmt, payToken, payAmtNow);
233         (uint feeAmt, uint buyAmtRemainder) = takeFee(min(buyAmt, buyToken.balanceOf(this)));
234         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
235         require(buyToken.transfer(msg.sender, buyAmtRemainder)); // To avoid rounding issues we check the minimum value
236     }
237 
238     function buyAllAmountPayEth(
239         OtcInterface otc, 
240         TokenInterface buyToken, 
241         uint buyAmt, 
242         TokenInterface wethToken
243     ) public payable returns (uint wethAmt) {
244         // In this case user needs to send more ETH than a estimated value, then contract will send back the rest
245         wethToken.deposit.value(msg.value)();
246         if (wethToken.allowance(this, otc) < msg.value) {
247             wethToken.approve(otc, uint(-1));
248         }
249         wethAmt = otc.buyAllAmount(buyToken, buyAmt, wethToken, msg.value);
250         (uint feeAmt, uint finalRemainder) = takeFee(min(buyAmt, buyToken.balanceOf(this))); 
251         // To avoid rounding issues we check the minimum value
252         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
253         require(buyToken.transfer(msg.sender, finalRemainder)); 
254         withdrawAndSend(wethToken, sub(msg.value, wethAmt));
255     }
256 
257     function buyAllAmountBuyEth(
258         OtcInterface otc, 
259         TokenInterface wethToken, 
260         uint wethAmt, 
261         TokenInterface payToken, 
262         uint maxPayAmt
263     ) public returns (uint payAmt) {
264         uint payAmtNow = otc.getPayAmount(payToken, wethToken, wethAmt);
265         require(payAmtNow <= maxPayAmt);
266         require(payToken.transferFrom(msg.sender, this, payAmtNow));
267         if (payToken.allowance(this, otc) < payAmtNow) {
268             payToken.approve(otc, uint(-1));
269         }
270         payAmt = otc.buyAllAmount(wethToken, wethAmt, payToken, payAmtNow);
271         (uint feeAmt, uint wethAmtRemainder) = takeFee(wethAmt);
272         require(wethToken.transfer(owner, feeAmt));
273         withdrawAndSend(wethToken, wethAmtRemainder);
274     }
275 
276     function() public payable {} /* fallback function */
277 }