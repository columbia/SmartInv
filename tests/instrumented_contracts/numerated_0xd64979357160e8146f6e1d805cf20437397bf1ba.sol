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
86 contract TubInterface {
87     function open() public returns (bytes32);
88     function join(uint) public;
89     function exit(uint) public;
90     function lock(bytes32, uint) public;
91     function free(bytes32, uint) public;
92     function draw(bytes32, uint) public;
93     function wipe(bytes32, uint) public;
94     function give(bytes32, address) public;
95     function shut(bytes32) public;
96     function bite(bytes32) public;
97     function cups(bytes32) public returns (address, uint, uint, uint);
98     function gem() public returns (TokenInterface);
99     function gov() public returns (TokenInterface);
100     function skr() public returns (TokenInterface);
101     function sai() public returns (TokenInterface);
102     function vox() public returns (VoxInterface);
103     function ask(uint) public returns (uint);
104     function mat() public returns (uint);
105     function chi() public returns (uint);
106     function ink(bytes32) public returns (uint);
107     function tab(bytes32) public returns (uint);
108     function rap(bytes32) public returns (uint);
109     function per() public returns (uint);
110     function pip() public returns (PipInterface);
111     function pep() public returns (PepInterface);
112     function tag() public returns (uint);
113     function drip() public;
114 }
115 
116 contract TapInterface {
117     function skr() public returns (TokenInterface);
118     function sai() public returns (TokenInterface);
119     function tub() public returns (TubInterface);
120     function bust(uint) public;
121     function boom(uint) public;
122     function cash(uint) public;
123     function mock(uint) public;
124     function heal() public;
125 }
126 
127 contract TokenInterface {
128     function allowance(address, address) public returns (uint);
129     function balanceOf(address) public returns (uint);
130     function approve(address, uint) public;
131     function transfer(address, uint) public returns (bool);
132     function transferFrom(address, address, uint) public returns (bool);
133     function deposit() public payable;
134     function withdraw(uint) public;
135 }
136 
137 contract VoxInterface {
138     function par() public returns (uint);
139 }
140 
141 contract PipInterface {
142     function read() public returns (bytes32);
143 }
144 
145 contract PepInterface {
146     function peek() public returns (bytes32, bool);
147 }
148 
149 contract OtcInterface {
150     function getPayAmount(address, address, uint) public constant returns (uint);
151     function buyAllAmount(address, uint, address pay_gem, uint) public returns (uint);
152 }
153 
154 contract SaiProxy is DSMath {
155     function open(address tub_) public returns (bytes32) {
156         return TubInterface(tub_).open();
157     }
158 
159     function give(address tub_, bytes32 cup, address lad) public {
160         TubInterface(tub_).give(cup, lad);
161     }
162 
163     function lock(address tub_, bytes32 cup) public payable {
164         if (msg.value > 0) {
165             TubInterface tub = TubInterface(tub_);
166 
167             tub.gem().deposit.value(msg.value)();
168 
169             uint ink = rdiv(msg.value, tub.per());
170             if (tub.gem().allowance(this, tub) != uint(-1)) {
171                 tub.gem().approve(tub, uint(-1));
172             }
173             tub.join(ink);
174 
175             if (tub.skr().allowance(this, tub) != uint(-1)) {
176                 tub.skr().approve(tub, uint(-1));
177             }
178             tub.lock(cup, ink);
179         }
180     }
181 
182     function draw(address tub_, bytes32 cup, uint wad) public {
183         if (wad > 0) {
184             TubInterface tub = TubInterface(tub_);
185             tub.draw(cup, wad);
186             tub.sai().transfer(msg.sender, wad);
187         }
188     }
189 
190     function handleGovFee(TubInterface tub, uint saiDebtFee, address otc_) internal {
191         bytes32 val;
192         bool ok;
193         (val, ok) = tub.pep().peek();
194         if (ok && val != 0) {
195             uint govAmt = wdiv(saiDebtFee, uint(val));
196             if (otc_ != address(0)) {
197                 uint saiGovAmt = OtcInterface(otc_).getPayAmount(tub.sai(), tub.gov(), govAmt);
198                 if (tub.sai().allowance(this, otc_) != uint(-1)) {
199                     tub.sai().approve(otc_, uint(-1));
200                 }
201                 tub.sai().transferFrom(msg.sender, this, saiGovAmt);
202                 OtcInterface(otc_).buyAllAmount(tub.gov(), govAmt, tub.sai(), saiGovAmt);
203             } else {
204                 tub.gov().transferFrom(msg.sender, this, govAmt);
205             }
206         }
207     }
208 
209     function wipe(address tub_, bytes32 cup, uint wad, address otc_) public {
210         if (wad > 0) {
211             TubInterface tub = TubInterface(tub_);
212 
213             tub.sai().transferFrom(msg.sender, this, wad);
214             handleGovFee(tub, rmul(wad, rdiv(tub.rap(cup), tub.tab(cup))), otc_);
215 
216             if (tub.sai().allowance(this, tub) != uint(-1)) {
217                 tub.sai().approve(tub, uint(-1));
218             }
219             if (tub.gov().allowance(this, tub) != uint(-1)) {
220                 tub.gov().approve(tub, uint(-1));
221             }
222             tub.wipe(cup, wad);
223         }
224     }
225 
226     function wipe(address tub_, bytes32 cup, uint wad) public {
227         wipe(tub_, cup, wad, address(0));
228     }
229 
230     function free(address tub_, bytes32 cup, uint jam) public {
231         if (jam > 0) {
232             TubInterface tub = TubInterface(tub_);
233             uint ink = rdiv(jam, tub.per());
234             tub.free(cup, ink);
235             if (tub.skr().allowance(this, tub) != uint(-1)) {
236                 tub.skr().approve(tub, uint(-1));
237             }
238             tub.exit(ink);
239             tub.gem().withdraw(jam);
240             address(msg.sender).transfer(jam);
241         }
242     }
243 
244     function lockAndDraw(address tub_, bytes32 cup, uint wad) public payable {
245         lock(tub_, cup);
246         draw(tub_, cup, wad);
247     }
248 
249     function lockAndDraw(address tub_, uint wad) public payable returns (bytes32 cup) {
250         cup = open(tub_);
251         lockAndDraw(tub_, cup, wad);
252     }
253 
254     function wipeAndFree(address tub_, bytes32 cup, uint jam, uint wad) public payable {
255         wipe(tub_, cup, wad);
256         free(tub_, cup, jam);
257     }
258 
259     function wipeAndFree(address tub_, bytes32 cup, uint jam, uint wad, address otc_) public payable {
260         wipe(tub_, cup, wad, otc_);
261         free(tub_, cup, jam);
262     }
263 
264     function shut(address tub_, bytes32 cup) public {
265         TubInterface tub = TubInterface(tub_);
266         wipeAndFree(tub_, cup, rmul(tub.ink(cup), tub.per()), tub.tab(cup));
267         tub.shut(cup);
268     }
269 
270     function shut(address tub_, bytes32 cup, address otc_) public {
271         TubInterface tub = TubInterface(tub_);
272         wipeAndFree(tub_, cup, rmul(tub.ink(cup), tub.per()), tub.tab(cup), otc_);
273         tub.shut(cup);
274     }
275 }
276 
277 contract ProxyRegistryInterface {
278     function build(address) public returns (address);
279 }
280 
281 contract SaiProxyCreateAndExecute is SaiProxy {
282 
283     // Create a DSProxy instance and open a cup
284     function createAndOpen(address registry_, address tub_) public returns (address proxy, bytes32 cup) {
285         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
286         cup = open(tub_);
287         TubInterface(tub_).give(cup, proxy);
288     }
289 
290     // Create a DSProxy instance, open a cup, and lock collateral
291     function createOpenAndLock(address registry_, address tub_) public payable returns (address proxy, bytes32 cup) {
292         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
293         cup = open(tub_);
294         lock(tub_, cup);
295         TubInterface(tub_).give(cup, proxy);
296     }
297 
298     // Create a DSProxy instance, open a cup, lock collateral, and draw DAI
299     function createOpenLockAndDraw(address registry_, address tub_, uint wad) public payable returns (address proxy, bytes32 cup) {
300         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
301         cup = open(tub_);
302         lockAndDraw(tub_, cup, wad);
303         TubInterface(tub_).give(cup, proxy);
304     }
305 }