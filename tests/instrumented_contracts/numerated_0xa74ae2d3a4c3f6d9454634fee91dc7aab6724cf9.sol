1 pragma solidity ^0.4.24;
2 contract DSNote {
3     event LogNote(
4         bytes4   indexed  sig,
5         address  indexed  guy,
6         bytes32  indexed  foo,
7         bytes32  indexed  bar,
8         uint              wad,
9         bytes             fax
10     ) anonymous;
11 
12     modifier note {
13         bytes32 foo;
14         bytes32 bar;
15 
16         assembly {
17             foo := calldataload(4)
18             bar := calldataload(36)
19         }
20 
21         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
22 
23         _;
24     }
25 }
26 
27 contract DSAuthority {
28     function canCall(
29         address src, address dst, bytes4 sig
30     ) public view returns (bool);
31 }
32 
33 contract DSAuthEvents {
34     event LogSetOwner     (address indexed owner);
35 }
36 
37 contract DSAuth is DSAuthEvents {
38     address      public  owner;
39 
40     constructor() public {
41         owner = msg.sender;
42         emit LogSetOwner(msg.sender);
43     }
44 
45     modifier auth {
46         require(isAuthorized(msg.sender));
47         _;
48     }
49 
50     function isAuthorized(address src) internal view returns (bool) {
51         if (src == owner) {
52             return true;
53         } else {
54             return false;
55         }
56     }
57 }
58 
59 contract DSStop is DSNote, DSAuth {
60 
61     bool public stopped;
62 
63     modifier stoppable {
64         require(!stopped);
65         _;
66     }
67     function stop() public auth note {
68         stopped = true;
69     }
70     function start() public auth note {
71         stopped = false;
72     }
73 
74 }
75 
76 contract DSMath {
77     function add(uint x, uint y) internal pure returns (uint z) {
78         require((z = x + y) >= x);
79     }
80     function sub(uint x, uint y) internal pure returns (uint z) {
81         require((z = x - y) <= x);
82     }
83     function mul(uint x, uint y) internal pure returns (uint z) {
84         require(y == 0 || (z = x * y) / y == x);
85     }
86 }
87 
88 contract ERC20Events {
89     event Approval(address indexed src, address indexed guy, uint wad);
90     event Transfer(address indexed src, address indexed dst, uint wad);
91 }
92 
93 contract ERC20 is ERC20Events {
94     function totalSupply() public view returns (uint);
95     function balanceOf(address guy) public view returns (uint);
96     function frozenFunds(address guy) public view returns (uint);
97     function allowance(address src, address guy) public view returns (uint);
98 
99     function approve(address guy, uint wad) public returns (bool);
100     function transfer(address dst, uint wad) public returns (bool);
101     function transferFrom(
102         address src, address dst, uint wad
103     ) public returns (bool);
104 }
105 
106 contract DSTokenBase is ERC20, DSMath {
107     uint256                                            _supply;
108     mapping (address => uint256)                       _balances;
109     mapping (address => uint256)                       _frozens;
110     mapping (address => mapping (address => uint256))  _approvals;
111 
112     constructor(uint supply) public {
113         _balances[msg.sender] = supply;
114         _supply = supply;
115     }
116 
117     function totalSupply() public view returns (uint) {
118         return _supply;
119     }
120     function balanceOf(address src) public view returns (uint) {
121         return _balances[src];
122     }
123     function frozenFunds(address src) public view returns (uint) {
124         return _frozens[src];
125     }
126     function allowance(address src, address guy) public view returns (uint) {
127         return _approvals[src][guy];
128     }
129 
130     function transfer(address dst, uint wad) public returns (bool) {
131         return transferFrom(msg.sender, dst, wad);
132     }
133 
134     function transferFrom(address src, address dst, uint wad)
135         public
136         returns (bool)
137     {
138         if (src != msg.sender) {
139             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
140         }
141 
142         _balances[src] = sub(_balances[src], wad);
143         _balances[dst] = add(_balances[dst], wad);
144 
145         emit Transfer(src, dst, wad);
146 
147         return true;
148     }
149 
150     function approve(address guy, uint wad) public returns (bool) {
151         _approvals[msg.sender][guy] = wad;
152 
153         emit Approval(msg.sender, guy, wad);
154 
155         return true;
156     }
157 }
158 
159 contract DSToken is DSTokenBase(2000000000000000000000000000), DSStop {
160 
161     string  public  symbol = "NES";
162     uint8  public  decimals = 18; 
163     event Freeze(address indexed guy, uint wad);
164 
165     function approve(address guy) public stoppable returns (bool) {
166         return super.approve(guy, uint(-1));
167     }
168 
169     function approve(address guy, uint wad) public stoppable returns (bool) {
170         return super.approve(guy, wad);
171     }
172 
173     function transferFrom(address src, address dst, uint wad)
174         public
175         stoppable
176         returns (bool)
177     {
178         require(_balances[src] - _frozens[src] >= wad);
179         
180         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
181             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
182         }
183 
184         _balances[src] = sub(_balances[src], wad);
185         _balances[dst] = add(_balances[dst], wad);
186 
187         emit Transfer(src, dst, wad);
188 
189         return true;
190     }
191     function transferMulti(address[] dsts, uint wad)  public auth returns (bool) {  
192         require(dsts.length > 0);
193         require(_balances[msg.sender] - _frozens[msg.sender] >= mul(wad, dsts.length));
194         
195         for(uint32 i=0; i<dsts.length; i++){
196             transfer(dsts[i], wad);
197         }  
198         return true;
199     }
200     
201     function push(address dst, uint wad) public {
202         transferFrom(msg.sender, dst, wad);
203     }
204     
205     function pull(address src, uint wad) public {
206         transferFrom(src, msg.sender, wad);
207     }
208     
209     function move(address src, address dst, uint wad) public {
210         transferFrom(src, dst, wad);
211     }
212     
213     function freezeAccount(address guy, uint wad) public auth {
214         require(_balances[guy] >= wad);
215         
216         _frozens[guy] = add(0, wad);
217         emit Freeze(guy, wad);
218     }
219 
220     string   public  name = "Gencoin";
221 
222     function setName(string name_) public auth {
223         name = name_;
224     }
225     
226     function setSymbol(string symbol_) public auth {
227         symbol = symbol_;
228     }
229 }