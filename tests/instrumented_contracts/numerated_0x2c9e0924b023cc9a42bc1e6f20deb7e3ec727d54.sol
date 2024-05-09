1 contract DSNote {
2     event LogNote(
3         bytes4   indexed  sig,
4         address  indexed  guy,
5         bytes32  indexed  foo,
6         bytes32  indexed  bar,
7         uint              wad,
8         bytes             fax
9     ) anonymous;
10 
11     modifier note {
12         bytes32 foo;
13         bytes32 bar;
14 
15         assembly {
16             foo := calldataload(4)
17             bar := calldataload(36)
18         }
19 
20         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
21 
22         _;
23     }
24 }
25 
26 contract DSAuthority {
27     function canCall(
28         address src, address dst, bytes4 sig
29     ) public view returns (bool);
30 }
31 
32 contract DSAuthEvents {
33     event LogSetAuthority (address indexed authority);
34     event LogSetOwner     (address indexed owner);
35 }
36 
37 contract DSAuth is DSAuthEvents {
38     DSAuthority  public  authority;
39     address      public  owner;
40 
41     constructor() public {
42         owner = msg.sender;
43         emit LogSetOwner(msg.sender);
44     }
45 
46     function setAuthority(DSAuthority authority_)
47         public
48         auth
49     {
50         authority = authority_;
51         emit LogSetAuthority(authority);
52     }
53 
54     modifier auth {
55         require(isAuthorized(msg.sender, msg.sig));
56         _;
57     }
58 
59     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
60         if (src == address(this)) {
61             return true;
62         } else if (src == owner) {
63             return true;
64         } else if (authority == DSAuthority(0)) {
65             return false;
66         } else {
67             return authority.canCall(src, this, sig);
68         }
69     }
70 }
71 
72 contract DSStop is DSNote, DSAuth {
73 
74     bool public stopped;
75 
76     modifier stoppable {
77         require(!stopped);
78         _;
79     }
80     function stop() public auth note {
81         stopped = true;
82     }
83     function start() public auth note {
84         stopped = false;
85     }
86 
87 }
88 
89 contract DSMath {
90     function add(uint x, uint y) internal pure returns (uint z) {
91         require((z = x + y) >= x);
92     }
93     function sub(uint x, uint y) internal pure returns (uint z) {
94         require((z = x - y) <= x);
95     }
96     function mul(uint x, uint y) internal pure returns (uint z) {
97         require(y == 0 || (z = x * y) / y == x);
98     }
99 
100     function min(uint x, uint y) internal pure returns (uint z) {
101         return x <= y ? x : y;
102     }
103     function max(uint x, uint y) internal pure returns (uint z) {
104         return x >= y ? x : y;
105     }
106     function imin(int x, int y) internal pure returns (int z) {
107         return x <= y ? x : y;
108     }
109     function imax(int x, int y) internal pure returns (int z) {
110         return x >= y ? x : y;
111     }
112 }
113 
114 contract ERC20Events {
115     event Approval(address indexed src, address indexed guy, uint wad);
116     event Transfer(address indexed src, address indexed dst, uint wad);
117 }
118 
119 contract ERC20 is ERC20Events {
120     function totalSupply() public view returns (uint);
121     function balanceOf(address guy) public view returns (uint);
122     function frozenFunds(address guy) public view returns (uint);
123     function allowance(address src, address guy) public view returns (uint);
124 
125     function approve(address guy, uint wad) public returns (bool);
126     function transfer(address dst, uint wad) public returns (bool);
127     function transferFrom(
128         address src, address dst, uint wad
129     ) public returns (bool);
130 }
131 
132 contract DSTokenBase is ERC20, DSMath {
133     uint256                                            _supply;
134     mapping (address => uint256)                       _balances;
135     mapping (address => uint256)                       _frozens;
136     mapping (address => mapping (address => uint256))  _approvals;
137 
138     constructor(uint supply) public {
139         _balances[msg.sender] = supply;
140         _supply = supply;
141     }
142 
143     function totalSupply() public view returns (uint) {
144         return _supply;
145     }
146     function balanceOf(address src) public view returns (uint) {
147         return _balances[src];
148     }
149     function frozenFunds(address src) public view returns (uint) {
150         return _frozens[src];
151     }
152     function allowance(address src, address guy) public view returns (uint) {
153         return _approvals[src][guy];
154     }
155 
156     function transfer(address dst, uint wad) public returns (bool) {
157         return transferFrom(msg.sender, dst, wad);
158     }
159 
160     function transferFrom(address src, address dst, uint wad)
161         public
162         returns (bool)
163     {
164         if (src != msg.sender) {
165             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
166         }
167 
168         _balances[src] = sub(_balances[src], wad);
169         _balances[dst] = add(_balances[dst], wad);
170 
171         emit Transfer(src, dst, wad);
172 
173         return true;
174     }
175 
176     function approve(address guy, uint wad) public returns (bool) {
177         _approvals[msg.sender][guy] = wad;
178 
179         emit Approval(msg.sender, guy, wad);
180 
181         return true;
182     }
183 }
184 
185 contract DSToken is DSTokenBase(100000000000000000000000), DSStop {
186 
187     string  public  symbol = "ICT";
188     uint8  public  decimals = 18; // standard token precision. override to customize
189 
190     event Mint(address indexed guy, uint wad);
191     event Burn(address indexed guy, uint wad);
192     event Freeze(address indexed guy, uint wad);
193 
194     function approve(address guy) public stoppable returns (bool) {
195         return super.approve(guy, uint(-1));
196     }
197 
198     function approve(address guy, uint wad) public stoppable returns (bool) {
199         return super.approve(guy, wad);
200     }
201 
202     function transferFrom(address src, address dst, uint wad)
203         public
204         stoppable
205         returns (bool)
206     {
207         require(_balances[src] - _frozens[src] >= wad);
208         
209         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
210             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
211         }
212 
213         _balances[src] = sub(_balances[src], wad);
214         _balances[dst] = add(_balances[dst], wad);
215 
216         emit Transfer(src, dst, wad);
217 
218         return true;
219     }
220     function transferMulti(address[] dsts, uint wad)  public auth returns (bool) {  
221         require(dsts.length > 0);
222         require(_balances[msg.sender] - _frozens[msg.sender] >= wad*dsts.length);
223         
224         for(uint32 i=0; i<dsts.length; i++){
225             transfer(dsts[i], wad);
226         }  
227         return true;
228     }
229     function push(address dst, uint wad) public {
230         transferFrom(msg.sender, dst, wad);
231     }
232     function pull(address src, uint wad) public {
233         transferFrom(src, msg.sender, wad);
234     }
235     function move(address src, address dst, uint wad) public {
236         transferFrom(src, dst, wad);
237     }
238 
239     function mint(uint wad) public {
240         mint(msg.sender, wad);
241     }
242     function burn(uint wad) public {
243         burn(msg.sender, wad);
244     }
245     function mint(address guy, uint wad) public auth stoppable {
246         _balances[guy] = add(_balances[guy], wad);
247         _supply = add(_supply, wad);
248         emit Mint(guy, wad);
249     }
250     function burn(address guy, uint wad) public auth stoppable {
251         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
252             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
253         }
254 
255         _balances[guy] = sub(_balances[guy], wad);
256         _supply = sub(_supply, wad);
257         emit Burn(guy, wad);
258     }
259     function freezeAccount(address guy, uint wad) public auth {
260         require(_balances[guy] >= wad);
261         
262         _frozens[guy] = add(0, wad);
263         emit Freeze(guy, wad);
264     }
265 
266     // Optional token name
267     string   public  name = "Ideal China Token";
268 
269     function setName(string name_) public auth {
270         name = name_;
271     }
272     
273     function setSymbol(string symbol_) public auth {
274         symbol = symbol_;
275     }
276 }