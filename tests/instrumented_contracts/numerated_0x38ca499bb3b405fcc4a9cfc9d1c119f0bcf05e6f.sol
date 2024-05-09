1 pragma solidity ^0.4.24;
2 
3 /*   
4  *    Exodus adaptation of OasisDirectProxy by MakerDAO.
5  */
6 
7 contract OtcInterface {
8     function sellAllAmount(address, uint, address, uint) public returns (uint);
9     function buyAllAmount(address, uint, address, uint) public returns (uint);
10     function getPayAmount(address, address, uint) public constant returns (uint);
11 }
12 
13 contract TokenInterface {
14     function balanceOf(address) public returns (uint);
15     function allowance(address, address) public returns (uint);
16     function approve(address, uint) public;
17     function transfer(address,uint) public returns (bool);
18     function transferFrom(address, address, uint) public returns (bool);
19     function deposit() public payable;
20     function withdraw(uint) public;
21 }
22 
23 contract FeeInterface {
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
85     
86     function withdrawTo(address _to) public auth {
87     /* rescue all ETH */
88         require(_to.call.value(address(this).balance)());
89     }
90     
91     function withdrawTokenTo(TokenInterface token, address _to) public auth {
92     /* rescue all of a token */
93         require(token.transfer(_to, token.balanceOf(this)));
94     }
95 }
96 
97 contract DSMath {
98     function add(uint x, uint y) internal pure returns (uint z) {
99         require((z = x + y) >= x);
100     }
101     function sub(uint x, uint y) internal pure returns (uint z) {
102         require((z = x - y) <= x);
103     }
104     function mul(uint x, uint y) internal pure returns (uint z) {
105         require(y == 0 || (z = x * y) / y == x);
106     }
107     function min(uint x, uint y) internal pure returns (uint z) {
108         return x <= y ? x : y;
109     }
110     function max(uint x, uint y) internal pure returns (uint z) {
111         return x >= y ? x : y;
112     }
113     function imin(int x, int y) internal pure returns (int z) {
114         return x <= y ? x : y;
115     }
116     function imax(int x, int y) internal pure returns (int z) {
117         return x >= y ? x : y;
118     }
119 
120     uint constant WAD = 10 ** 18;
121     uint constant RAY = 10 ** 27;
122 
123     function wmul(uint x, uint y) internal pure returns (uint z) {
124         z = add(mul(x, y), WAD / 2) / WAD;
125     }
126     function rmul(uint x, uint y) internal pure returns (uint z) {
127         z = add(mul(x, y), RAY / 2) / RAY;
128     }
129     function wdiv(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, WAD), y / 2) / y;
131     }
132     function rdiv(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, RAY), y / 2) / y;
134     }
135 
136     function rpow(uint x, uint n) internal pure returns (uint z) {
137         z = n % 2 != 0 ? x : RAY;
138 
139         for (n /= 2; n != 0; n /= 2) {
140             x = rmul(x, x);
141 
142             if (n % 2 != 0) {
143                 z = rmul(z, x);
144             }
145         }
146     }
147 }
148 
149 contract OasisMonetizedProxy is Mortal, DSMath {
150     FeeInterface fees;
151     
152     constructor(FeeInterface _fees) public {
153         fees = _fees;
154     }
155     
156     function setFeeAuthority(FeeInterface _fees) public auth {
157       fees = _fees;
158     }
159     
160     function unwrapAndSend(TokenInterface wethToken, address _to, uint wethAmt) internal {
161         wethToken.withdraw(wethAmt);
162         require(_to.call.value(wethAmt)()); 
163   /* perform a call when sending ETH, in case the _to is a contract */
164     }
165 
166     /*** Public functions start here ***/
167 
168     function sellAllAmount(
169         OtcInterface otc,
170         TokenInterface payToken, 
171         uint payAmt, 
172         TokenInterface buyToken, 
173         uint minBuyAmt
174     ) public returns (uint) {
175         require(payToken.transferFrom(msg.sender, this, payAmt));
176         if (payToken.allowance(this, otc) < payAmt) {
177             payToken.approve(otc, uint(-1));
178         }
179         uint buyAmt = otc.sellAllAmount(payToken, payAmt, buyToken, minBuyAmt);
180         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken);
181         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
182         require(buyToken.transfer(msg.sender, buyAmtRemainder));
183         return buyAmtRemainder;
184     }
185 
186     function sellAllAmountPayEth(
187         OtcInterface otc,
188         TokenInterface wethToken,
189         TokenInterface buyToken,
190         uint minBuyAmt
191     ) public payable returns (uint) {
192         wethToken.deposit.value(msg.value)();
193         if (wethToken.allowance(this, otc) < msg.value) {
194             wethToken.approve(otc, uint(-1));
195         }
196         uint buyAmt = otc.sellAllAmount(wethToken, msg.value, buyToken, minBuyAmt); 
197         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken);
198         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
199         require(buyToken.transfer(msg.sender, buyAmtRemainder));
200         return buyAmtRemainder;
201     }
202 
203     function sellAllAmountBuyEth(
204         OtcInterface otc,
205         TokenInterface payToken, 
206         uint payAmt, 
207         TokenInterface wethToken, 
208         uint minBuyAmt
209     ) public returns (uint) {
210         require(payToken.transferFrom(msg.sender, this, payAmt));
211         if (payToken.allowance(this, otc) < payAmt) {
212             payToken.approve(otc, uint(-1));
213         }
214         uint wethAmt = otc.sellAllAmount(payToken, payAmt, wethToken, minBuyAmt);
215         (uint feeAmt, uint wethAmtRemainder) = fees.takeFee(wethAmt, wethToken);
216         unwrapAndSend(wethToken, owner, feeAmt); /* fee is taken in ETH */ 
217         unwrapAndSend(wethToken, msg.sender, wethAmtRemainder);
218         return wethAmtRemainder;
219     }
220 
221     function buyAllAmount(
222         OtcInterface otc, 
223         TokenInterface buyToken, 
224         uint buyAmt, 
225         TokenInterface payToken, 
226         uint maxPayAmt
227     ) public returns (uint payAmt) {
228         uint payAmtNow = otc.getPayAmount(payToken, buyToken, buyAmt);
229         require(payAmtNow <= maxPayAmt);
230         require(payToken.transferFrom(msg.sender, this, payAmtNow));
231         if (payToken.allowance(this, otc) < payAmtNow) {
232             payToken.approve(otc, uint(-1));
233         } 
234         payAmt = otc.buyAllAmount(buyToken, buyAmt, payToken, payAmtNow);
235         buyAmt = min(buyAmt, buyToken.balanceOf(this));
236         /* To avoid rounding issues we check the minimum value */
237         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken);
238         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
239         require(buyToken.transfer(msg.sender, buyAmtRemainder)); 
240     }
241 
242     function buyAllAmountPayEth(
243         OtcInterface otc, 
244         TokenInterface buyToken, 
245         uint buyAmt, 
246         TokenInterface wethToken
247     ) public payable returns (uint wethAmt) {
248         /* In this case client needs to send more ETH than a estimated 
249            value, then contract will send back the rest */
250         wethToken.deposit.value(msg.value)();
251         if (wethToken.allowance(this, otc) < msg.value) {
252             wethToken.approve(otc, uint(-1));
253         }
254         wethAmt = otc.buyAllAmount(buyToken, buyAmt, wethToken, msg.value);
255         buyAmt = min(buyAmt, buyToken.balanceOf(this));
256         /* To avoid rounding issues we check the minimum value */
257         (uint feeAmt, uint buyAmtRemainder) = fees.takeFee(buyAmt, buyToken); 
258         require(buyToken.transfer(owner, feeAmt)); /* fee is taken */
259         require(buyToken.transfer(msg.sender, buyAmtRemainder)); 
260         unwrapAndSend(wethToken, msg.sender, sub(msg.value, wethAmt)); /* return leftover eth */
261     }
262 
263     function buyAllAmountBuyEth(
264         OtcInterface otc, 
265         TokenInterface wethToken, 
266         uint wethAmt, 
267         TokenInterface payToken, 
268         uint maxPayAmt
269     ) public returns (uint payAmt) {
270         uint payAmtNow = otc.getPayAmount(payToken, wethToken, wethAmt);
271         require(payAmtNow <= maxPayAmt);
272         require(payToken.transferFrom(msg.sender, this, payAmtNow));
273         if (payToken.allowance(this, otc) < payAmtNow) {
274             payToken.approve(otc, uint(-1));
275         }
276         payAmt = otc.buyAllAmount(wethToken, wethAmt, payToken, payAmtNow);
277         (uint feeAmt, uint wethAmtRemainder) = fees.takeFee(wethAmt, wethToken);
278         unwrapAndSend(wethToken, owner, feeAmt);
279         unwrapAndSend(wethToken, msg.sender, wethAmtRemainder);
280     }
281 
282     function() public payable {
283     /* fallback function. Revert ensures no ETH is sent to the contract by accident */
284          revert(); 
285     }
286 }