1 pragma solidity ^0.4.13;
2 
3 contract TubInterface {
4     function open() public returns (bytes32);
5     function join(uint) public;
6     function exit(uint) public;
7     function lock(bytes32, uint) public;
8     function free(bytes32, uint) public;
9     function draw(bytes32, uint) public;
10     function wipe(bytes32, uint) public;
11     function give(bytes32, address) public;
12     function shut(bytes32) public;
13     function bite(bytes32) public;
14     function cups(bytes32) public returns (address, uint, uint, uint);
15     function gem() public returns (TokenInterface);
16     function gov() public returns (TokenInterface);
17     function skr() public returns (TokenInterface);
18     function sai() public returns (TokenInterface);
19     function vox() public returns (VoxInterface);
20     function ask(uint) public returns (uint);
21     function mat() public returns (uint);
22     function chi() public returns (uint);
23     function ink(bytes32) public returns (uint);
24     function tab(bytes32) public returns (uint);
25     function rap(bytes32) public returns (uint);
26     function per() public returns (uint);
27     function pip() public returns (PipInterface);
28     function pep() public returns (PepInterface);
29     function tag() public returns (uint);
30     function drip() public;
31 }
32 
33 contract TapInterface {
34     function skr() public returns (TokenInterface);
35     function sai() public returns (TokenInterface);
36     function tub() public returns (TubInterface);
37     function bust(uint) public;
38     function boom(uint) public;
39     function cash(uint) public;
40     function mock(uint) public;
41     function heal() public;
42 }
43 
44 contract TokenInterface {
45     function allowance(address, address) public returns (uint);
46     function balanceOf(address) public returns (uint);
47     function approve(address, uint) public;
48     function transfer(address, uint) public returns (bool);
49     function transferFrom(address, address, uint) public returns (bool);
50     function deposit() public payable;
51     function withdraw(uint) public;
52 }
53 
54 contract VoxInterface {
55     function par() public returns (uint);
56 }
57 
58 contract PipInterface {
59     function read() public returns (bytes32);
60 }
61 
62 contract PepInterface {
63     function peek() public returns (bytes32, bool);
64 }
65 
66 contract OtcInterface {
67     function getPayAmount(address, address, uint) public constant returns (uint);
68     function buyAllAmount(address, uint, address pay_gem, uint) public returns (uint);
69 }
70 
71 contract ProxyRegistryInterface {
72     function build(address) public returns (address);
73 }
74 
75 contract DSMath {
76     function add(uint x, uint y) internal pure returns (uint z) {
77         require((z = x + y) >= x);
78     }
79     function sub(uint x, uint y) internal pure returns (uint z) {
80         require((z = x - y) <= x);
81     }
82     function mul(uint x, uint y) internal pure returns (uint z) {
83         require(y == 0 || (z = x * y) / y == x);
84     }
85 
86     function min(uint x, uint y) internal pure returns (uint z) {
87         return x <= y ? x : y;
88     }
89     function max(uint x, uint y) internal pure returns (uint z) {
90         return x >= y ? x : y;
91     }
92     function imin(int x, int y) internal pure returns (int z) {
93         return x <= y ? x : y;
94     }
95     function imax(int x, int y) internal pure returns (int z) {
96         return x >= y ? x : y;
97     }
98 
99     uint constant WAD = 10 ** 18;
100     uint constant RAY = 10 ** 27;
101 
102     function wmul(uint x, uint y) internal pure returns (uint z) {
103         z = add(mul(x, y), WAD / 2) / WAD;
104     }
105     function rmul(uint x, uint y) internal pure returns (uint z) {
106         z = add(mul(x, y), RAY / 2) / RAY;
107     }
108     function wdiv(uint x, uint y) internal pure returns (uint z) {
109         z = add(mul(x, WAD), y / 2) / y;
110     }
111     function rdiv(uint x, uint y) internal pure returns (uint z) {
112         z = add(mul(x, RAY), y / 2) / y;
113     }
114 
115     // This famous algorithm is called "exponentiation by squaring"
116     // and calculates x^n with x as fixed-point and n as regular unsigned.
117     //
118     // It's O(log n), instead of O(n) for naive repeated multiplication.
119     //
120     // These facts are why it works:
121     //
122     //  If n is even, then x^n = (x^2)^(n/2).
123     //  If n is odd,  then x^n = x * x^(n-1),
124     //   and applying the equation for even x gives
125     //    x^n = x * (x^2)^((n-1) / 2).
126     //
127     //  Also, EVM division is flooring and
128     //    floor[(n-1) / 2] = floor[n / 2].
129     //
130     function rpow(uint x, uint n) internal pure returns (uint z) {
131         z = n % 2 != 0 ? x : RAY;
132 
133         for (n /= 2; n != 0; n /= 2) {
134             x = rmul(x, x);
135 
136             if (n % 2 != 0) {
137                 z = rmul(z, x);
138             }
139         }
140     }
141 }
142 
143 contract SaiProxy is DSMath {
144     function open(address tub_) public returns (bytes32) {
145         return TubInterface(tub_).open();
146     }
147 
148     function give(address tub_, bytes32 cup, address lad) public {
149         TubInterface(tub_).give(cup, lad);
150     }
151 
152     function lock(address tub_, bytes32 cup) public payable {
153         if (msg.value > 0) {
154             TubInterface tub = TubInterface(tub_);
155 
156             tub.gem().deposit.value(msg.value)();
157 
158             uint ink = rdiv(msg.value, tub.per());
159             if (tub.gem().allowance(this, tub) != uint(-1)) {
160                 tub.gem().approve(tub, uint(-1));
161             }
162             tub.join(ink);
163 
164             if (tub.skr().allowance(this, tub) != uint(-1)) {
165                 tub.skr().approve(tub, uint(-1));
166             }
167             tub.lock(cup, ink);
168         }
169     }
170 
171     function draw(address tub_, bytes32 cup, uint wad) public {
172         if (wad > 0) {
173             TubInterface tub = TubInterface(tub_);
174             tub.draw(cup, wad);
175             tub.sai().transfer(msg.sender, wad);
176         }
177     }
178 
179     function handleGovFee(TubInterface tub, uint saiDebtFee, address otc_) internal {
180         bytes32 val;
181         bool ok;
182         (val, ok) = tub.pep().peek();
183         if (ok && val != 0) {
184             uint govAmt = wdiv(saiDebtFee, uint(val));
185             if (otc_ != address(0)) {
186                 uint saiGovAmt = OtcInterface(otc_).getPayAmount(tub.sai(), tub.gov(), govAmt);
187                 if (tub.sai().allowance(this, otc_) != uint(-1)) {
188                     tub.sai().approve(otc_, uint(-1));
189                 }
190                 tub.sai().transferFrom(msg.sender, this, saiGovAmt);
191                 OtcInterface(otc_).buyAllAmount(tub.gov(), govAmt, tub.sai(), saiGovAmt);
192             } else {
193                 tub.gov().transferFrom(msg.sender, this, govAmt);
194             }
195         }
196     }
197 
198     function wipe(address tub_, bytes32 cup, uint wad, address otc_) public {
199         if (wad > 0) {
200             TubInterface tub = TubInterface(tub_);
201 
202             tub.sai().transferFrom(msg.sender, this, wad);
203             handleGovFee(tub, rmul(wad, rdiv(tub.rap(cup), tub.tab(cup))), otc_);
204 
205             if (tub.sai().allowance(this, tub) != uint(-1)) {
206                 tub.sai().approve(tub, uint(-1));
207             }
208             if (tub.gov().allowance(this, tub) != uint(-1)) {
209                 tub.gov().approve(tub, uint(-1));
210             }
211             tub.wipe(cup, wad);
212         }
213     }
214 
215     function wipe(address tub_, bytes32 cup, uint wad) public {
216         wipe(tub_, cup, wad, address(0));
217     }
218 
219     function free(address tub_, bytes32 cup, uint jam) public {
220         if (jam > 0) {
221             TubInterface tub = TubInterface(tub_);
222             uint ink = rdiv(jam, tub.per());
223             tub.free(cup, ink);
224             if (tub.skr().allowance(this, tub) != uint(-1)) {
225                 tub.skr().approve(tub, uint(-1));
226             }
227             tub.exit(ink);
228             tub.gem().withdraw(jam);
229             address(msg.sender).transfer(jam);
230         }
231     }
232 
233     function lockAndDraw(address tub_, bytes32 cup, uint wad) public payable {
234         lock(tub_, cup);
235         draw(tub_, cup, wad);
236     }
237 
238     function lockAndDraw(address tub_, uint wad) public payable returns (bytes32 cup) {
239         cup = open(tub_);
240         lockAndDraw(tub_, cup, wad);
241     }
242 
243     function wipeAndFree(address tub_, bytes32 cup, uint jam, uint wad) public payable {
244         wipe(tub_, cup, wad);
245         free(tub_, cup, jam);
246     }
247 
248     function wipeAndFree(address tub_, bytes32 cup, uint jam, uint wad, address otc_) public payable {
249         wipe(tub_, cup, wad, otc_);
250         free(tub_, cup, jam);
251     }
252 
253     function shut(address tub_, bytes32 cup) public {
254         TubInterface tub = TubInterface(tub_);
255         wipeAndFree(tub_, cup, rmul(tub.ink(cup), tub.per()), tub.tab(cup));
256         tub.shut(cup);
257     }
258 
259     function shut(address tub_, bytes32 cup, address otc_) public {
260         TubInterface tub = TubInterface(tub_);
261         wipeAndFree(tub_, cup, rmul(tub.ink(cup), tub.per()), tub.tab(cup), otc_);
262         tub.shut(cup);
263     }
264 }
265 
266 contract SaiProxyCreateAndExecute is SaiProxy {
267 
268     // Create a DSProxy instance and open a cup
269     function createAndOpen(address registry_, address tub_) public returns (address proxy, bytes32 cup) {
270         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
271         cup = open(tub_);
272         TubInterface(tub_).give(cup, proxy);
273     }
274 
275     // Create a DSProxy instance, open a cup, and lock collateral
276     function createOpenAndLock(address registry_, address tub_) public payable returns (address proxy, bytes32 cup) {
277         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
278         cup = open(tub_);
279         lock(tub_, cup);
280         TubInterface(tub_).give(cup, proxy);
281     }
282 
283     // Create a DSProxy instance, open a cup, lock collateral, and draw DAI
284     function createOpenLockAndDraw(address registry_, address tub_, uint wad) public payable returns (address proxy, bytes32 cup) {
285         proxy = ProxyRegistryInterface(registry_).build(msg.sender);
286         cup = open(tub_);
287         lockAndDraw(tub_, cup, wad);
288         TubInterface(tub_).give(cup, proxy);
289     }
290 }