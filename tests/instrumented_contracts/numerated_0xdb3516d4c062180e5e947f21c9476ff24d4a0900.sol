1 pragma solidity ^0.5.12;
2 
3 contract ReserveLike {
4     function depositToken(address, string memory, bytes memory, uint) public;
5 }
6 
7 contract WrappedDaiLike {
8     function setProxy(address) public;
9     function setReserve(address) public;
10 
11     uint public totalSupply;
12     function approve(address, uint) public returns (bool);
13 
14     function mint(address, uint) public;
15     function burn(address, uint) public;
16 }
17 
18 contract DaiLike {
19     function approve(address, uint) public returns (bool);
20     function transferFrom(address, address, uint) public returns (bool);
21 }
22 
23 contract JoinLike {
24     VatLike public vat;
25     DaiLike public dai;
26 
27     function join(address, uint) public;
28     function exit(address, uint) public;
29 }
30 
31 contract PotLike {
32     mapping(address => uint) public pie;
33     uint public chi;
34 
35     VatLike public vat;
36     uint public rho;
37 
38     function drip() public returns (uint);
39 
40     function join(uint) public;
41     function exit(uint) public;
42 }
43 
44 contract VatLike {
45     mapping(address => uint) public dai;
46 
47     function hope(address) public;
48     function move(address, address, uint) public;
49 }
50 
51 contract DaiProxy {
52     string public constant version = "0511";
53 
54     // --- Owner ---
55     address public owner;
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     event SetOwner(address owner);
63 
64     function setOwner(address _owner) public onlyOwner {
65         owner = _owner;
66         emit SetOwner(_owner);
67     }
68 
69     // --- State ---
70     enum State { Ready, Running, Killed }
71 
72     State public state = State.Ready;
73 
74     modifier notStarted {
75         require(state == State.Ready);
76         _;
77     }
78 
79     modifier notPaused {
80         require(state == State.Running);
81         _;
82     }
83 
84     // --- Math ---
85     uint constant ONE = 10 ** 27;
86 
87     function add(uint a, uint b) private pure returns (uint) {
88         require(a <= uint(-1) - b);
89         return a + b;
90     }
91 
92     function sub(uint a, uint b) private pure returns (uint) {
93         require(a >= b);
94         return a - b;
95     }
96 
97     function mul(uint a, uint b) private pure returns (uint) {
98         require(b == 0 || a <= uint(-1) / b);
99         return a * b;
100     }
101 
102     function div(uint a, uint b) private pure returns (uint) {
103         require(b != 0);
104         return a / b;
105     }
106 
107     function ceil(uint a, uint b) private pure returns (uint) {
108         require(b != 0);
109 
110         uint r = a / b;
111         return a > r * b ? r + 1 : r;
112     }
113 
114     function muldiv(uint a, uint b, uint c) private pure returns (uint) {
115         uint safe = 1 << (256 - 32);  // 2.696e67
116         uint mask = (1 << 32) - 1;
117 
118         require(c != 0 && c < safe);
119 
120         if (b == 0) return 0;
121         if (a < b) (a, b) = (b, a);
122         
123         uint p = a / c;
124         uint r = a % c;
125 
126         uint res = 0;
127 
128         while (true) {  // most 8 times
129             uint v = b & mask;
130             res = add(res, add(mul(p, v), r * v / c));
131 
132             b >>= 32;
133             if (b == 0) break;
134 
135             require(p < safe);
136 
137             p <<= 32;
138             r <<= 32;
139 
140             p = add(p, r / c);
141             r %= c;
142         }
143 
144         return res;
145     }
146 
147     // --- Contracts & Constructor ---
148     DaiLike public Dai;
149     JoinLike public Join;
150     PotLike public Pot;
151     VatLike public Vat;
152 
153     ReserveLike public Reserve;
154 
155     WrappedDaiLike public EDai;
156     WrappedDaiLike public ODai;
157 
158     event SetReserve(address reserve);
159 
160     constructor(address dai, address join, address pot, address vat, address eDai, address oDai) public {
161         owner = msg.sender;
162 
163         Dai = DaiLike(dai);
164         Join = JoinLike(join);
165         Pot = PotLike(pot);
166         Vat = VatLike(vat);
167 
168         EDai = WrappedDaiLike(eDai);
169         ODai = WrappedDaiLike(oDai);
170 
171         require(address(Join.dai()) == dai);
172         require(address(Join.vat()) == vat);
173         require(address(Pot.vat()) == vat);
174 
175         Vat.hope(pot);  // Pot.join
176         Vat.hope(join);  // Join.exit
177 
178         require(Dai.approve(join, uint(-1)));  // Join.join -> dai.burn
179     }
180 
181     function setReserve(address reserve) public onlyOwner {
182         require(EDai.approve(address(Reserve), 0));
183         require(ODai.approve(address(Reserve), 0));
184 
185         Reserve = ReserveLike(reserve);
186 
187         EDai.setReserve(reserve);
188         ODai.setReserve(reserve);
189 
190         // approve for Reserve.depositToken
191         require(EDai.approve(reserve, uint(-1)));
192         require(ODai.approve(reserve, uint(-1)));
193 
194         emit SetReserve(reserve);
195     }
196 
197     modifier onlyEDai {
198         require(msg.sender == address(EDai));
199         _;
200     }
201 
202     modifier onlyODai {
203         require(msg.sender == address(ODai));
204         _;
205     }
206 
207     // --- Integration ---
208     function chi() private returns (uint) {
209         return now > Pot.rho() ? Pot.drip() : Pot.chi();
210     }
211 
212     function joinDai(uint dai) private {
213         require(Dai.transferFrom(msg.sender, address(this), dai));
214         Join.join(address(this), dai);
215 
216         uint vat = Vat.dai(address(this));
217         Pot.join(div(vat, chi()));
218     }
219 
220     function exitDai(address to, uint dai) private {
221         uint vat = Vat.dai(address(this));
222         uint req = mul(dai, ONE);
223 
224         if (req > vat) {
225             uint pot = ceil(req - vat, chi());
226             Pot.exit(pot);
227         }
228 
229         Join.exit(to, dai);
230     }
231 
232     function mintODai(address to, uint dai) private returns (uint) {
233         uint wad = dai;
234 
235         if (ODai.totalSupply() != 0) {
236             uint pie = Pot.pie(address(this));
237             uint vat = Vat.dai(address(this));
238 
239             // 기존 rad
240             uint rad = sub(add(mul(pie, chi()), vat), mul(EDai.totalSupply(), ONE));
241 
242             // rad : supply = dai * ONE : wad
243             wad = muldiv(ODai.totalSupply(), mul(dai, ONE), rad);
244         }
245 
246         joinDai(dai);
247         ODai.mint(to, wad);
248         return wad;
249     }
250 
251     function depositEDai(string memory toChain, uint dai, bytes memory to) public notPaused {
252         require(dai > 0);
253 
254         joinDai(dai);
255 
256         EDai.mint(address(this), dai);
257         Reserve.depositToken(address(EDai), toChain, to, dai);
258     }
259 
260     function depositODai(string memory toChain, uint dai, bytes memory to) public notPaused {
261         require(dai > 0);
262 
263         uint wad = mintODai(address(this), dai);
264         Reserve.depositToken(address(ODai), toChain, to, wad);
265     }
266 
267     function swapFromEDai(address from, address to, uint dai) private {
268         EDai.burn(from, dai);
269         exitDai(to, dai);
270     }
271 
272     function swapFromODai(address from, address to, uint wad) private {
273         uint pie = Pot.pie(address(this));
274         uint vat = Vat.dai(address(this));
275 
276         // 기존 rad
277         uint rad = sub(add(mul(pie, chi()), vat), mul(EDai.totalSupply(), ONE));
278 
279         // rad : supply = dai * ONE : wad
280         uint dai = muldiv(rad, wad, mul(ODai.totalSupply(), ONE));
281 
282         ODai.burn(from, wad);
283         exitDai(to, dai);
284     }
285 
286     function withdrawEDai(address to, uint dai) public onlyEDai notPaused {
287         require(dai > 0);
288 
289         swapFromEDai(address(Reserve), to, dai);
290     }
291 
292     function withdrawODai(address to, uint wad) public onlyODai notPaused {
293         require(wad > 0);
294 
295         swapFromODai(address(Reserve), to, wad);
296     }
297 
298     function swapToEDai(uint dai) public notPaused {
299         require(dai > 0);
300 
301         joinDai(dai);
302         EDai.mint(msg.sender, dai);
303     }
304 
305     function swapToODai(uint dai) public notPaused {
306         require(dai > 0);
307 
308         mintODai(msg.sender, dai);
309     }
310 
311     function swapFromEDai(uint dai) public notPaused {
312         require(dai > 0);
313 
314         swapFromEDai(msg.sender, msg.sender, dai);
315     }
316 
317     function swapFromODai(uint wad) public notPaused {
318         require(wad > 0);
319 
320         swapFromODai(msg.sender, msg.sender, wad);
321     }
322 
323     // --- Migration ---
324     DaiProxy public NewProxy;
325 
326     event SetNewProxy(address proxy);
327     event StartProxy(address prev);
328     event KillProxy(address next, bool mig);
329 
330     modifier onlyNewProxy {
331         require(msg.sender == address(NewProxy));
332         _;
333     }
334 
335 
336     function setNewProxy(address proxy) public onlyOwner {
337         NewProxy = DaiProxy(proxy);
338         emit SetNewProxy(proxy);
339     }
340 
341 
342     function killProxy(address to) public notPaused onlyOwner {
343         state = State.Killed;
344 
345         chi();
346 
347         Pot.exit(Pot.pie(address(this)));
348         Join.exit(to, Vat.dai(address(this)) / ONE);
349 
350         emit KillProxy(to, false);
351     }
352 
353 
354     function migrateProxy() public notPaused onlyNewProxy {
355         state = State.Killed;
356 
357         EDai.setProxy(address(NewProxy));
358         ODai.setProxy(address(NewProxy));
359 
360         chi();
361 
362         Pot.exit(Pot.pie(address(this)));
363         Vat.move(address(this), address(NewProxy), Vat.dai(address(this)));
364 
365         emit KillProxy(address(NewProxy), true);
366     }
367 
368 
369     function startProxy(address oldProxy) public notStarted onlyOwner {
370         state = State.Running;
371 
372         if (oldProxy != address(0)) {
373             DaiProxy(oldProxy).migrateProxy();
374 
375             uint vat = Vat.dai(address(this));
376             Pot.join(div(vat, chi()));
377         }
378 
379         emit StartProxy(oldProxy);
380     }
381 }