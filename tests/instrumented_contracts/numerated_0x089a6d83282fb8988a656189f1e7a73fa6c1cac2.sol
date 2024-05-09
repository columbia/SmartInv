1 pragma solidity ^0.4.14;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint supply);
5     function balanceOf( address who ) constant returns (uint value);
6     function allowance( address owner, address spender ) constant returns (uint _allowance);
7 
8     function transfer( address to, uint value) returns (bool ok);
9     function transferFrom( address from, address to, uint value) returns (bool ok);
10     function approve( address spender, uint value ) returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract DSMath {
17     
18     /*
19     standard uint256 functions
20      */
21 
22     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         assert((z = x + y) >= x);
24     }
25 
26     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         assert((z = x - y) <= x);
28     }
29 
30     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
31         assert((z = x * y) >= x);
32     }
33 
34     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
35         z = x / y;
36     }
37 
38     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         return x <= y ? x : y;
40     }
41     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
42         return x >= y ? x : y;
43     }
44 
45     /*
46     uint128 functions (h is for half)
47      */
48 
49 
50     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
51         assert((z = x + y) >= x);
52     }
53 
54     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
55         assert((z = x - y) <= x);
56     }
57 
58     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
59         assert((z = x * y) >= x);
60     }
61 
62     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
63         z = x / y;
64     }
65 
66     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
67         return x <= y ? x : y;
68     }
69     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
70         return x >= y ? x : y;
71     }
72 
73 
74     /*
75     int256 functions
76      */
77 
78     function imin(int256 x, int256 y) constant internal returns (int256 z) {
79         return x <= y ? x : y;
80     }
81     function imax(int256 x, int256 y) constant internal returns (int256 z) {
82         return x >= y ? x : y;
83     }
84 
85     /*
86     WAD math
87      */
88 
89     uint128 constant WAD = 10 ** 18;
90 
91     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
92         return hadd(x, y);
93     }
94 
95     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
96         return hsub(x, y);
97     }
98 
99     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
100         z = cast((uint256(x) * y + WAD / 2) / WAD);
101     }
102 
103     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
104         z = cast((uint256(x) * WAD + y / 2) / y);
105     }
106 
107     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
108         return hmin(x, y);
109     }
110     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
111         return hmax(x, y);
112     }
113 
114     /*
115     RAY math
116      */
117 
118     uint128 constant RAY = 10 ** 27;
119 
120     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
121         return hadd(x, y);
122     }
123 
124     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
125         return hsub(x, y);
126     }
127 
128     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
129         z = cast((uint256(x) * y + RAY / 2) / RAY);
130     }
131 
132     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
133         z = cast((uint256(x) * RAY + y / 2) / y);
134     }
135 
136     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
137         // This famous algorithm is called "exponentiation by squaring"
138         // and calculates x^n with x as fixed-point and n as regular unsigned.
139         //
140         // It's O(log n), instead of O(n) for naive repeated multiplication.
141         //
142         // These facts are why it works:
143         //
144         //  If n is even, then x^n = (x^2)^(n/2).
145         //  If n is odd,  then x^n = x * x^(n-1),
146         //   and applying the equation for even x gives
147         //    x^n = x * (x^2)^((n-1) / 2).
148         //
149         //  Also, EVM division is flooring and
150         //    floor[(n-1) / 2] = floor[n / 2].
151 
152         z = n % 2 != 0 ? x : RAY;
153 
154         for (n /= 2; n != 0; n /= 2) {
155             x = rmul(x, x);
156 
157             if (n % 2 != 0) {
158                 z = rmul(z, x);
159             }
160         }
161     }
162 
163     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
164         return hmin(x, y);
165     }
166     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
167         return hmax(x, y);
168     }
169 
170     function cast(uint256 x) constant internal returns (uint128 z) {
171         assert((z = uint128(x)) == x);
172     }
173 
174 }
175 
176 contract TokenBase is ERC20, DSMath {
177     uint256                                            _supply;
178     mapping (address => uint256)                       _balances;
179     mapping (address => mapping (address => uint256))  _approvals;
180 
181     function totalSupply() constant returns (uint256) {
182         return _supply;
183     }
184     function balanceOf(address addr) constant returns (uint256) {
185         return _balances[addr];
186     }
187     function allowance(address from, address to) constant returns (uint256) {
188         return _approvals[from][to];
189     }
190     
191     function transfer(address to, uint value) returns (bool) {
192         assert(_balances[msg.sender] >= value);
193         
194         _balances[msg.sender] = sub(_balances[msg.sender], value);
195         _balances[to] = add(_balances[to], value);
196         
197         Transfer(msg.sender, to, value);
198         
199         return true;
200     }
201     
202     function transferFrom(address from, address to, uint value) returns (bool) {
203         assert(_balances[from] >= value);
204         assert(_approvals[from][msg.sender] >= value);
205         
206         _approvals[from][msg.sender] = sub(_approvals[from][msg.sender], value);
207         _balances[from] = sub(_balances[from], value);
208         _balances[to] = add(_balances[to], value);
209         
210         Transfer(from, to, value);
211         
212         return true;
213     }
214     
215     function approve(address to, uint256 value) returns (bool) {
216         _approvals[msg.sender][to] = value;
217         
218         Approval(msg.sender, to, value);
219         
220         return true;
221     }
222 
223 }
224 
225 contract Owned
226 {
227     address public owner;
228     
229     function Owned()
230     {
231         owner = msg.sender;
232     }
233     
234     modifier onlyOwner()
235     {
236         if (msg.sender != owner) revert();
237         _;
238     }
239 }
240 
241 contract Migrable is TokenBase, Owned
242 {
243     event Migrate(address indexed _from, address indexed _to, uint256 _value);
244     address public migrationAgent;
245     uint256 public totalMigrated;
246 
247 
248     function migrate() external {
249         migrate_participant(msg.sender);
250     }
251     
252     function migrate_participant(address _participant) internal
253     {
254         // Abort if not in Operational Migration state.
255         if (migrationAgent == 0)  revert();
256         if (_balances[_participant] == 0)  revert();
257         
258         uint256 _value = _balances[_participant];
259         _balances[_participant] = 0;
260         _supply = sub(_supply, _value);
261         totalMigrated = add(totalMigrated, _value);
262         MigrationAgent(migrationAgent).migrateFrom(_participant, _value);
263         Migrate(_participant, migrationAgent, _value);
264         
265     }
266 
267     function setMigrationAgent(address _agent) onlyOwner external {
268         if (migrationAgent != 0)  revert();
269         migrationAgent = _agent;
270     }
271 }
272 
273 contract ProspectorsGoldToken is TokenBase, Owned, Migrable {
274     string public constant name = "Prospectors Gold";
275     string public constant symbol = "PGL";
276     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
277 
278     address private game_address = 0xb1; // Address 0xb1 is provably non-transferrable. Game tokens will be moved to game platform after developing
279     uint public constant game_allocation = 110000000 * WAD; // Base allocation of tokens owned by game (50%). Not saled tokens will be moved to game balance.
280     uint public constant dev_allocation = 45000000 * WAD; //tokens allocated to prospectors team and developers (~20.5%)
281     uint public constant crowdfunding_allocation = 60000000 * WAD; //tokens allocated to crowdsale (~27.2%)
282     uint public constant bounty_allocation = 500000 * WAD; //tokens allocated to bounty program (~0.2%)
283     uint public constant presale_allocation = 4500000 * WAD; //tokens allocated to very early investors (~2%)
284 
285     bool public locked = true; //token non transfarable yet. it can be unlocked after success crowdsale
286 
287     address public bounty; //bounty tokens manager contract address
288     address public prospectors_dev_allocation; //prospectors team and developers tokens holder. Contract allows to get tokens in 5 periods (180, 360 days, 1, 2, 3 and 4 years)
289     ProspectorsCrowdsale public crowdsale; //crowdsale contract address
290 
291     function ProspectorsGoldToken() {
292         _supply = 220000000 * WAD;
293         _balances[this] = _supply;
294         mint_for(game_address, game_allocation);
295     }
296     
297     //override and prevent transfer if crowdsale fails
298     function transfer(address to, uint value) returns (bool)
299     {
300         if (locked == true && msg.sender != address(crowdsale)) revert();
301         return super.transfer(to, value);
302     }
303     
304     //override and prevent transfer if crowdsale fails
305     function transferFrom(address from, address to, uint value)  returns (bool)
306     {
307         if (locked == true) revert();
308         return super.transferFrom(from, to, value);
309     }
310     
311     //unlock transfers if crowdsale success
312     function unlock() returns (bool)
313     {
314         if (locked == true && crowdsale.is_success() == true)
315         {
316             locked = false;
317             return true;
318         }
319         else
320         {
321             return false;
322         }
323     }
324 
325     //mint tokens for crowdsale
326     function init_crowdsale(address _crowdsale) onlyOwner
327     {
328         if (address(0) != address(crowdsale)) revert();
329         crowdsale = ProspectorsCrowdsale(_crowdsale);
330         mint_for(crowdsale, crowdfunding_allocation);
331     }
332     
333     //mint tokens for bounty contract.
334     function init_bounty_program(address _bounty) onlyOwner
335     {
336         if (address(0) != address(bounty)) revert();
337         bounty = _bounty;
338         mint_for(bounty, bounty_allocation);
339     }
340     
341     //mint tokens for dev. Also mint tokens for very early investors.
342     function init_dev_and_presale_allocation(address presale_token_address, address _prospectors_dev_allocation) onlyOwner
343     {
344         if (address(0) != prospectors_dev_allocation) revert();
345         prospectors_dev_allocation = _prospectors_dev_allocation;
346         mint_for(prospectors_dev_allocation, dev_allocation);
347         mint_for(presale_token_address, presale_allocation);
348     }
349     
350     //this function will be called after game release
351     function migrate_game_balance() onlyOwner
352     {
353         migrate_participant(game_address);
354     }
355     
356     //adding tokens to crowdsale, bounty, game and prospectors team
357     function mint_for(address addr, uint amount) private
358     {
359         if (_balances[this] >= amount)
360         {
361             _balances[this] = sub(_balances[this], amount);
362             _balances[addr] = add(_balances[addr], amount);
363             Transfer(this, addr, amount);
364         }
365     }
366 }
367 
368 contract ProspectorsCrowdsale {
369     function is_success() returns (bool);
370 }
371 
372 contract MigrationAgent {
373     function migrateFrom(address _from, uint256 _value);
374 }