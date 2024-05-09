1 pragma solidity ^0.4.15;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSMath {
58     function add(uint x, uint y) internal pure returns (uint z) {
59         require((z = x + y) >= x);
60     }
61     function sub(uint x, uint y) internal pure returns (uint z) {
62         require((z = x - y) <= x);
63     }
64     function mul(uint x, uint y) internal pure returns (uint z) {
65         require(y == 0 || (z = x * y) / y == x);
66     }
67 
68     function min(uint x, uint y) internal pure returns (uint z) {
69         return x <= y ? x : y;
70     }
71     function max(uint x, uint y) internal pure returns (uint z) {
72         return x >= y ? x : y;
73     }
74     function imin(int x, int y) internal pure returns (int z) {
75         return x <= y ? x : y;
76     }
77     function imax(int x, int y) internal pure returns (int z) {
78         return x >= y ? x : y;
79     }
80 
81     uint constant WAD = 10 ** 18;
82     uint constant RAY = 10 ** 27;
83 
84     function wmul(uint x, uint y) internal pure returns (uint z) {
85         z = add(mul(x, y), WAD / 2) / WAD;
86     }
87     function rmul(uint x, uint y) internal pure returns (uint z) {
88         z = add(mul(x, y), RAY / 2) / RAY;
89     }
90     function wdiv(uint x, uint y) internal pure returns (uint z) {
91         z = add(mul(x, WAD), y / 2) / y;
92     }
93     function rdiv(uint x, uint y) internal pure returns (uint z) {
94         z = add(mul(x, RAY), y / 2) / y;
95     }
96     function rpow(uint x, uint n) internal pure returns (uint z) {
97         z = n % 2 != 0 ? x : RAY;
98 
99         for (n /= 2; n != 0; n /= 2) {
100             x = rmul(x, x);
101 
102             if (n % 2 != 0) {
103                 z = rmul(z, x);
104             }
105         }
106     }
107 }
108 
109 contract DSNote {
110     event LogNote(
111         bytes4   indexed  sig,
112         address  indexed  guy,
113         bytes32  indexed  foo,
114         bytes32  indexed  bar,
115         uint              wad,
116         bytes             fax
117     ) anonymous;
118 
119     modifier note {
120         bytes32 foo;
121         bytes32 bar;
122 
123         assembly {
124             foo := calldataload(4)
125             bar := calldataload(36)
126         }
127 
128         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
129 
130         _;
131     }
132 }
133 
134 contract DSThing is DSAuth, DSNote, DSMath {
135 }
136 
137 contract DSStop is DSNote, DSAuth {
138 
139     bool public stopped;
140 
141     modifier stoppable {
142         require(!stopped);
143         _;
144     }
145     function stop() public auth note {
146         stopped = true;
147     }
148     function start() public auth note {
149         stopped = false;
150     }
151 
152 }
153 
154 contract ERC20 {
155     function totalSupply() public view returns (uint supply);
156     function balanceOf( address who ) public view returns (uint value);
157     function allowance( address owner, address spender ) public view returns (uint _allowance);
158 
159     function transfer( address to, uint value) public returns (bool ok);
160     function transferFrom( address from, address to, uint value) public returns (bool ok);
161     function approve( address spender, uint value ) public returns (bool ok);
162 
163     event Transfer( address indexed from, address indexed to, uint value);
164     event Approval( address indexed owner, address indexed spender, uint value);
165 }
166 
167 contract DSTokenBase is ERC20, DSMath {
168     uint256 _supply = 1000000000000000000000000000;
169     mapping (address => uint256)                       _balances;
170     mapping (address => mapping (address => uint256))  _approvals;
171 
172     function DSTokenBase() public {
173         _balances[msg.sender] = _supply;
174     }
175 
176     function totalSupply() public view returns (uint) {
177         return _supply;
178     }
179     function balanceOf(address src) public view returns (uint) {
180         return _balances[src];
181     }
182     function allowance(address src, address guy) public view returns (uint) {
183         return _approvals[src][guy];
184     }
185 
186     function transfer(address dst, uint wad) public returns (bool) {
187         return transferFrom(msg.sender, dst, wad);
188     }
189 
190     function transferFrom(address src, address dst, uint wad)
191         public
192         returns (bool)
193     {
194         if (src != msg.sender) {
195             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
196         }
197 
198         _balances[src] = sub(_balances[src], wad);
199         _balances[dst] = add(_balances[dst], wad);
200 
201         Transfer(src, dst, wad);
202 
203         return true;
204     }
205 
206     function approve(address guy, uint wad) public returns (bool) {
207         _approvals[msg.sender][guy] = wad;
208 
209         Approval(msg.sender, guy, wad);
210 
211         return true;
212     }
213 }
214 
215 contract DSToken is DSTokenBase, DSStop {
216 
217     string  public  symbol;
218     uint256  public  decimals = 18; // standard token precision. override to customize
219 
220     function DSToken(string symbol_) public {
221         symbol = symbol_;
222     }
223 
224     function approve(address guy) public stoppable returns (bool) {
225         return super.approve(guy, uint(-1));
226     }
227 
228     function approve(address guy, uint wad) public stoppable returns (bool) {
229         return super.approve(guy, wad);
230     }
231 
232     function transferFrom(address src, address dst, uint wad)
233         public
234         stoppable
235         returns (bool)
236     {
237         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
238             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
239         }
240 
241         _balances[src] = sub(_balances[src], wad);
242         _balances[dst] = add(_balances[dst], wad);
243 
244         Transfer(src, dst, wad);
245 
246         return true;
247     }
248 
249     // Optional token name
250     bytes32   public  name = "";
251 
252     function setName(bytes32 name_) public auth {
253         name = name_;
254     }
255 }