1 /// math.sol -- mixin for inline numerical wizardry
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.4.13;
17 
18 contract DSMath {
19     function add(uint x, uint y) internal pure returns (uint z) {
20         require((z = x + y) >= x);
21     }
22     function sub(uint x, uint y) internal pure returns (uint z) {
23         require((z = x - y) <= x);
24     }
25     function mul(uint x, uint y) internal pure returns (uint z) {
26         require(y == 0 || (z = x * y) / y == x);
27     }
28 
29     function min(uint x, uint y) internal pure returns (uint z) {
30         return x <= y ? x : y;
31     }
32     function max(uint x, uint y) internal pure returns (uint z) {
33         return x >= y ? x : y;
34     }
35     function imin(int x, int y) internal pure returns (int z) {
36         return x <= y ? x : y;
37     }
38     function imax(int x, int y) internal pure returns (int z) {
39         return x >= y ? x : y;
40     }
41 
42     uint constant WAD = 10 ** 18;
43     uint constant RAY = 10 ** 27;
44 
45     function wmul(uint x, uint y) internal pure returns (uint z) {
46         z = add(mul(x, y), WAD / 2) / WAD;
47     }
48     function rmul(uint x, uint y) internal pure returns (uint z) {
49         z = add(mul(x, y), RAY / 2) / RAY;
50     }
51     function wdiv(uint x, uint y) internal pure returns (uint z) {
52         z = add(mul(x, WAD), y / 2) / y;
53     }
54     function rdiv(uint x, uint y) internal pure returns (uint z) {
55         z = add(mul(x, RAY), y / 2) / y;
56     }
57 
58     // This famous algorithm is called "exponentiation by squaring"
59     // and calculates x^n with x as fixed-point and n as regular unsigned.
60     //
61     // It's O(log n), instead of O(n) for naive repeated multiplication.
62     //
63     // These facts are why it works:
64     //
65     //  If n is even, then x^n = (x^2)^(n/2).
66     //  If n is odd,  then x^n = x * x^(n-1),
67     //   and applying the equation for even x gives
68     //    x^n = x * (x^2)^((n-1) / 2).
69     //
70     //  Also, EVM division is flooring and
71     //    floor[(n-1) / 2] = floor[n / 2].
72     //
73     function rpow(uint x, uint n) internal pure returns (uint z) {
74         z = n % 2 != 0 ? x : RAY;
75 
76         for (n /= 2; n != 0; n /= 2) {
77             x = rmul(x, x);
78 
79             if (n % 2 != 0) {
80                 z = rmul(z, x);
81             }
82         }
83     }
84 }
85 
86 // This program is free software: you can redistribute it and/or modify
87 // it under the terms of the GNU General Public License as published by
88 // the Free Software Foundation, either version 3 of the License, or
89 // (at your option) any later version.
90 
91 // This program is distributed in the hope that it will be useful,
92 // but WITHOUT ANY WARRANTY; without even the implied warranty of
93 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
94 // GNU General Public License for more details.
95 
96 // You should have received a copy of the GNU General Public License
97 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
98 
99 pragma solidity ^0.4.13;
100 
101 contract DSAuthority {
102     function canCall(
103         address src, address dst, bytes4 sig
104     ) public view returns (bool);
105 }
106 
107 contract DSAuthEvents {
108     event LogSetAuthority (address indexed authority);
109     event LogSetOwner     (address indexed owner);
110 }
111 
112 contract DSAuth is DSAuthEvents {
113     DSAuthority  public  authority;
114     address      public  owner;
115 
116     function DSAuth() public {
117         owner = msg.sender;
118         LogSetOwner(msg.sender);
119     }
120 
121     function setOwner(address owner_)
122         public
123         auth
124     {
125         owner = owner_;
126         LogSetOwner(owner);
127     }
128 
129     function setAuthority(DSAuthority authority_)
130         public
131         auth
132     {
133         authority = authority_;
134         LogSetAuthority(authority);
135     }
136 
137     modifier auth {
138         require(isAuthorized(msg.sender, msg.sig));
139         _;
140     }
141 
142     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
143         if (src == address(this)) {
144             return true;
145         } else if (src == owner) {
146             return true;
147         } else if (authority == DSAuthority(0)) {
148             return false;
149         } else {
150             return authority.canCall(src, this, sig);
151         }
152     }
153 }
154 
155 /// erc20.sol -- API for the ERC20 token standard
156 
157 // See <https://github.com/ethereum/EIPs/issues/20>.
158 
159 // This file likely does not meet the threshold of originality
160 // required for copyright to apply.  As a result, this is free and
161 // unencumbered software belonging to the public domain.
162 
163 pragma solidity ^0.4.8;
164 
165 contract ERC20Events {
166     event Approval(address indexed src, address indexed guy, uint wad);
167     event Transfer(address indexed src, address indexed dst, uint wad);
168 }
169 
170 contract ERC20 is ERC20Events {
171     function totalSupply() public view returns (uint);
172     function balanceOf(address guy) public view returns (uint);
173     function allowance(address src, address guy) public view returns (uint);
174 
175     function approve(address guy, uint wad) public returns (bool);
176     function transfer(address dst, uint wad) public returns (bool);
177     function transferFrom(
178         address src, address dst, uint wad
179     ) public returns (bool);
180 }
181 
182 /* Viewly main token sale contract, where contributors send ethers in order to
183  * later receive VIEW tokens (outside of this contract).
184  */
185 contract ViewlyMainSale is DSAuth, DSMath {
186 
187     // STATE
188 
189     uint public minContributionAmount = 5 ether; // initial min contribution amount
190     uint public maxTotalAmount = 4300 ether;     // initial min contribution amount
191     address public beneficiary;                  // address to collect contributed amount to
192     uint public startBlock;                      // start block of sale
193     uint public endBlock;                        // end block of sale
194 
195     uint public totalContributedAmount;          // stores all contributions
196     uint public totalRefundedAmount;             // stores all refunds
197 
198     mapping(address => uint256) public contributions;
199     mapping(address => uint256) public refunds;
200 
201     bool public whitelistRequired;
202     mapping(address => bool) public whitelist;
203 
204 
205     // EVENTS
206 
207     event LogContribute(address contributor, uint amount);
208     event LogRefund(address contributor, uint amount);
209     event LogCollectAmount(uint amount);
210 
211 
212     // MODIFIERS
213 
214     modifier saleOpen() {
215         require(block.number >= startBlock);
216         require(block.number <= endBlock);
217         _;
218     }
219 
220     modifier requireWhitelist() {
221         if (whitelistRequired) require(whitelist[msg.sender]);
222         _;
223     }
224 
225 
226     // PUBLIC
227 
228     function ViewlyMainSale(address beneficiary_) public {
229         beneficiary = beneficiary_;
230     }
231 
232     function() public payable {
233         contribute();
234     }
235 
236 
237     // AUTH-REQUIRED
238 
239     function refund(address contributor) public auth {
240         uint amount = contributions[contributor];
241         require(amount > 0);
242         require(amount <= this.balance);
243 
244         contributions[contributor] = 0;
245         refunds[contributor] += amount;
246         totalRefundedAmount += amount;
247         totalContributedAmount -= amount;
248         contributor.transfer(amount);
249         LogRefund(contributor, amount);
250     }
251 
252     function setMinContributionAmount(uint minAmount) public auth {
253         require(minAmount > 0);
254 
255         minContributionAmount = minAmount;
256     }
257 
258     function setMaxTotalAmount(uint maxAmount) public auth {
259         require(maxAmount > 0);
260 
261         maxTotalAmount = maxAmount;
262     }
263 
264     function initSale(uint startBlock_, uint endBlock_) public auth {
265         require(startBlock_ > 0);
266         require(endBlock_ > startBlock_);
267 
268         startBlock = startBlock_;
269         endBlock   = endBlock_;
270     }
271 
272     function collectAmount(uint amount) public auth {
273         require(this.balance >= amount);
274 
275         beneficiary.transfer(amount);
276         LogCollectAmount(amount);
277     }
278 
279     function addToWhitelist(address[] contributors) public auth {
280         require(contributors.length != 0);
281 
282         for (uint i = 0; i < contributors.length; i++) {
283           whitelist[contributors[i]] = true;
284         }
285     }
286 
287     function removeFromWhitelist(address[] contributors) public auth {
288         require(contributors.length != 0);
289 
290         for (uint i = 0; i < contributors.length; i++) {
291           whitelist[contributors[i]] = false;
292         }
293     }
294 
295     function setWhitelistRequired(bool setting) public auth {
296         whitelistRequired = setting;
297     }
298 
299     function setOwner(address owner_) public auth {
300         revert();
301     }
302 
303     function setAuthority(DSAuthority authority_) public auth {
304         revert();
305     }
306 
307     function recoverTokens(address token_) public auth {
308         ERC20 token = ERC20(token_);
309         token.transfer(beneficiary, token.balanceOf(this));
310     }
311 
312 
313     // PRIVATE
314 
315     function contribute() private saleOpen requireWhitelist {
316         require(msg.value >= minContributionAmount);
317         require(maxTotalAmount >= add(totalContributedAmount, msg.value));
318 
319         contributions[msg.sender] += msg.value;
320         totalContributedAmount += msg.value;
321         LogContribute(msg.sender, msg.value);
322     }
323 }