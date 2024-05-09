1 pragma solidity ^0.4.23;
2 
3 /// math.sol -- mixin for inline numerical wizardry
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 pragma solidity ^0.4.13;
19 
20 contract DSMath {
21     function add(uint x, uint y) internal pure returns (uint z) {
22         require((z = x + y) >= x);
23     }
24     function sub(uint x, uint y) internal pure returns (uint z) {
25         require((z = x - y) <= x);
26     }
27     function mul(uint x, uint y) internal pure returns (uint z) {
28         require(y == 0 || (z = x * y) / y == x);
29     }
30 
31     function min(uint x, uint y) internal pure returns (uint z) {
32         return x <= y ? x : y;
33     }
34     function max(uint x, uint y) internal pure returns (uint z) {
35         return x >= y ? x : y;
36     }
37     function imin(int x, int y) internal pure returns (int z) {
38         return x <= y ? x : y;
39     }
40     function imax(int x, int y) internal pure returns (int z) {
41         return x >= y ? x : y;
42     }
43 
44     uint constant WAD = 10 ** 18;
45     uint constant RAY = 10 ** 27;
46 
47     function wmul(uint x, uint y) internal pure returns (uint z) {
48         z = add(mul(x, y), WAD / 2) / WAD;
49     }
50     function rmul(uint x, uint y) internal pure returns (uint z) {
51         z = add(mul(x, y), RAY / 2) / RAY;
52     }
53     function wdiv(uint x, uint y) internal pure returns (uint z) {
54         z = add(mul(x, WAD), y / 2) / y;
55     }
56     function rdiv(uint x, uint y) internal pure returns (uint z) {
57         z = add(mul(x, RAY), y / 2) / y;
58     }
59 
60     // This famous algorithm is called "exponentiation by squaring"
61     // and calculates x^n with x as fixed-point and n as regular unsigned.
62     //
63     // It's O(log n), instead of O(n) for naive repeated multiplication.
64     //
65     // These facts are why it works:
66     //
67     //  If n is even, then x^n = (x^2)^(n/2).
68     //  If n is odd,  then x^n = x * x^(n-1),
69     //   and applying the equation for even x gives
70     //    x^n = x * (x^2)^((n-1) / 2).
71     //
72     //  Also, EVM division is flooring and
73     //    floor[(n-1) / 2] = floor[n / 2].
74     //
75     function rpow(uint x, uint n) internal pure returns (uint z) {
76         z = n % 2 != 0 ? x : RAY;
77 
78         for (n /= 2; n != 0; n /= 2) {
79             x = rmul(x, x);
80 
81             if (n % 2 != 0) {
82                 z = rmul(z, x);
83             }
84         }
85     }
86 }
87 
88 contract TubInterface {
89     function open() public returns (bytes32);
90     function join(uint) public;
91     function exit(uint) public;
92     function lock(bytes32, uint) public;
93     function free(bytes32, uint) public;
94     function draw(bytes32, uint) public;
95     function wipe(bytes32, uint) public;
96     function give(bytes32, address) public;
97     function shut(bytes32) public;
98     function cups(bytes32) public view returns (address, uint, uint, uint);
99     function gem() public view returns (TokenInterface);
100     function gov() public view returns (TokenInterface);
101     function skr() public view returns (TokenInterface);
102     function sai() public view returns (TokenInterface);
103     function mat() public view returns (uint);
104     function ink(bytes32) public view returns (uint);
105     function tab(bytes32) public view returns (uint);
106     function rap(bytes32) public view returns (uint);
107     function per() public view returns (uint);
108     function pep() public view returns (PepInterface);
109 }
110 
111 contract TokenInterface {
112     function allowance(address, address) public view returns (uint);
113     function balanceOf(address) public view returns (uint);
114     function approve(address, uint) public;
115     function transfer(address, uint) public returns (bool);
116     function transferFrom(address, address, uint) public returns (bool);
117     function deposit() public payable;
118     function withdraw(uint) public;
119 }
120 
121 contract PepInterface {
122     function peek() public returns (bytes32, bool);
123 }
124 
125 contract OtcInterface {
126     function getPayAmount(address, address, uint) public view returns (uint);
127     function buyAllAmount(address, uint, address pay_gem, uint) public returns (uint);
128 }
129 
130 contract SaiProxy is DSMath {
131     function open(address tub_) public returns (bytes32) {
132         return TubInterface(tub_).open();
133     }
134 
135     function give(address tub_, bytes32 cup, address lad) public {
136         TubInterface(tub_).give(cup, lad);
137     }
138 
139     function lock(address tub_, bytes32 cup) public payable {
140         if (msg.value > 0) {
141             TubInterface tub = TubInterface(tub_);
142 
143             (address lad,,,) = tub.cups(cup);
144             require(lad == address(this), "cup-not-owned");
145 
146             tub.gem().deposit.value(msg.value)();
147 
148             uint ink = rdiv(msg.value, tub.per());
149             ink = rmul(ink, tub.per()) <= msg.value ? ink : ink - 1;
150 
151             if (tub.gem().allowance(this, tub) != uint(-1)) {
152                 tub.gem().approve(tub, uint(-1));
153             }
154             tub.join(ink);
155 
156             if (tub.skr().allowance(this, tub) != uint(-1)) {
157                 tub.skr().approve(tub, uint(-1));
158             }
159             tub.lock(cup, ink);
160         }
161     }
162 
163     function draw(address tub_, bytes32 cup, uint wad) public {
164         if (wad > 0) {
165             TubInterface tub = TubInterface(tub_);
166             tub.draw(cup, wad);
167             tub.sai().transfer(msg.sender, wad);
168         }
169     }
170 
171     function handleGovFee(TubInterface tub, uint saiDebtFee, address otc_) internal {
172         bytes32 val;
173         bool ok;
174         (val, ok) = tub.pep().peek();
175         if (ok && val != 0) {
176             uint govAmt = wdiv(saiDebtFee, uint(val));
177             if (otc_ != address(0)) {
178                 uint saiGovAmt = OtcInterface(otc_).getPayAmount(tub.sai(), tub.gov(), govAmt);
179                 if (tub.sai().allowance(this, otc_) != uint(-1)) {
180                     tub.sai().approve(otc_, uint(-1));
181                 }
182                 tub.sai().transferFrom(msg.sender, this, saiGovAmt);
183                 OtcInterface(otc_).buyAllAmount(tub.gov(), govAmt, tub.sai(), saiGovAmt);
184             } else {
185                 tub.gov().transferFrom(msg.sender, this, govAmt);
186             }
187         }
188     }
189 
190     function wipe(address tub_, bytes32 cup, uint wad, address otc_) public {
191         if (wad > 0) {
192             TubInterface tub = TubInterface(tub_);
193 
194             tub.sai().transferFrom(msg.sender, this, wad);
195             handleGovFee(tub, rmul(wad, rdiv(tub.rap(cup), tub.tab(cup))), otc_);
196 
197             if (tub.sai().allowance(this, tub) != uint(-1)) {
198                 tub.sai().approve(tub, uint(-1));
199             }
200             if (tub.gov().allowance(this, tub) != uint(-1)) {
201                 tub.gov().approve(tub, uint(-1));
202             }
203             tub.wipe(cup, wad);
204         }
205     }
206 
207     function wipe(address tub_, bytes32 cup, uint wad) public {
208         wipe(tub_, cup, wad, address(0));
209     }
210 
211     function free(address tub_, bytes32 cup, uint jam) public {
212         if (jam > 0) {
213             TubInterface tub = TubInterface(tub_);
214             uint ink = rdiv(jam, tub.per());
215             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
216             tub.free(cup, ink);
217             if (tub.skr().allowance(this, tub) != uint(-1)) {
218                 tub.skr().approve(tub, uint(-1));
219             }
220             tub.exit(ink);
221             uint freeJam = tub.gem().balanceOf(this); // Withdraw possible previous stuck WETH as well
222             tub.gem().withdraw(freeJam);
223             address(msg.sender).transfer(freeJam);
224         }
225     }
226 
227     function lockAndDraw(address tub_, bytes32 cup, uint wad) public payable {
228         lock(tub_, cup);
229         draw(tub_, cup, wad);
230     }
231 
232     function lockAndDraw(address tub_, uint wad) public payable returns (bytes32 cup) {
233         cup = open(tub_);
234         lockAndDraw(tub_, cup, wad);
235     }
236 
237     function wipeAndFree(address tub_, bytes32 cup, uint jam, uint wad) public payable {
238         wipe(tub_, cup, wad);
239         free(tub_, cup, jam);
240     }
241 
242     function wipeAndFree(address tub_, bytes32 cup, uint jam, uint wad, address otc_) public payable {
243         wipe(tub_, cup, wad, otc_);
244         free(tub_, cup, jam);
245     }
246 
247     function shut(address tub_, bytes32 cup) public {
248         TubInterface tub = TubInterface(tub_);
249         wipeAndFree(tub_, cup, rmul(tub.ink(cup), tub.per()), tub.tab(cup));
250         tub.shut(cup);
251     }
252 
253     function shut(address tub_, bytes32 cup, address otc_) public {
254         TubInterface tub = TubInterface(tub_);
255         wipeAndFree(tub_, cup, rmul(tub.ink(cup), tub.per()), tub.tab(cup), otc_);
256         tub.shut(cup);
257     }
258 }
259 
260 contract ProxyRegistryInterface {
261     function build(address) public returns (address);
262 }
263 
264 contract SaiProxyCreateAndExecute is SaiProxy {
265 
266     // Create a DSProxy instance and open a cup
267     function createAndOpen(address registry_, address tub_) public returns (address proxy, bytes32 cup) {
268         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
269         cup = open(tub_);
270         TubInterface(tub_).give(cup, proxy);
271     }
272 
273     // Create a DSProxy instance, open a cup, and lock collateral
274     function createOpenAndLock(address registry_, address tub_) public payable returns (address proxy, bytes32 cup) {
275         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
276         cup = open(tub_);
277         lock(tub_, cup);
278         TubInterface(tub_).give(cup, proxy);
279     }
280 
281     // Create a DSProxy instance, open a cup, lock collateral, and draw DAI
282     function createOpenLockAndDraw(address registry_, address tub_, uint wad) public payable returns (address proxy, bytes32 cup) {
283         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
284         cup = open(tub_);
285         lockAndDraw(tub_, cup, wad);
286         TubInterface(tub_).give(cup, proxy);
287     }
288 }