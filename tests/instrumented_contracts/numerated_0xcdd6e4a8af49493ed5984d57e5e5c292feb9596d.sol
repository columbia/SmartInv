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
51         if (src == address(this)) {
52             return true;
53         } else if (src == owner) {
54             return true;
55         } else {
56             return false;
57         }
58     }
59 }
60 
61 contract DSStop is DSNote, DSAuth {
62 
63     bool public stopped;
64 
65     modifier stoppable {
66         require(!stopped);
67         _;
68     }
69     function stop() public auth note {
70         stopped = true;
71     }
72     function start() public auth note {
73         stopped = false;
74     }
75 
76 }
77 
78 contract DSMath {
79     function add(uint x, uint y) internal pure returns (uint z) {
80         require((z = x + y) >= x);
81     }
82     function sub(uint x, uint y) internal pure returns (uint z) {
83         require((z = x - y) <= x);
84     }
85     function mul(uint x, uint y) internal pure returns (uint z) {
86         require(y == 0 || (z = x * y) / y == x);
87     }
88 }
89 
90 contract ERC20Events {
91     event Approval(address indexed src, address indexed guy, uint wad);
92     event Transfer(address indexed src, address indexed dst, uint wad);
93 }
94 
95 contract ERC20 is ERC20Events {
96     function totalSupply() public view returns (uint);
97     function balanceOf(address guy) public view returns (uint);
98     function frozenFunds(address guy) public view returns (uint);
99     function allowance(address src, address guy) public view returns (uint);
100 
101     function approve(address guy, uint wad) public returns (bool);
102     function transfer(address dst, uint wad) public returns (bool);
103     function transferFrom(
104         address src, address dst, uint wad
105     ) public returns (bool);
106 }
107 
108 contract DSTokenBase is ERC20, DSMath {
109     uint256                                            _supply;
110     mapping (address => uint256)                       _balances;
111     mapping (address => uint256)                       _frozens;
112     mapping (address => mapping (address => uint256))  _approvals;
113 
114     constructor(uint supply) public {
115         _balances[msg.sender] = supply;
116         _supply = supply;
117     }
118 
119     function totalSupply() public view returns (uint) {
120         return _supply;
121     }
122     function balanceOf(address src) public view returns (uint) {
123         return _balances[src];
124     }
125     function frozenFunds(address src) public view returns (uint) {
126         return _frozens[src];
127     }
128     function allowance(address src, address guy) public view returns (uint) {
129         return _approvals[src][guy];
130     }
131 
132     function transfer(address dst, uint wad) public returns (bool) {
133         return transferFrom(msg.sender, dst, wad);
134     }
135 
136     function transferFrom(address src, address dst, uint wad)
137         public
138         returns (bool)
139     {
140         if (src != msg.sender) {
141             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
142         }
143 
144         _balances[src] = sub(_balances[src], wad);
145         _balances[dst] = add(_balances[dst], wad);
146 
147         emit Transfer(src, dst, wad);
148 
149         return true;
150     }
151 
152     function approve(address guy, uint wad) public returns (bool) {
153         _approvals[msg.sender][guy] = wad;
154 
155         emit Approval(msg.sender, guy, wad);
156 
157         return true;
158     }
159 }
160 
161 contract DSToken is DSTokenBase(7000000000000000000000000000), DSStop {
162 
163     string  public  symbol = "MYT";
164     uint8  public  decimals = 18; // standard token precision. override to customize
165     event Freeze(address indexed guy, uint wad);
166 
167     function approve(address guy) public stoppable returns (bool) {
168         return super.approve(guy, uint(-1));
169     }
170 
171     function approve(address guy, uint wad) public stoppable returns (bool) {
172         return super.approve(guy, wad);
173     }
174 
175     function transferFrom(address src, address dst, uint wad)
176         public
177         stoppable
178         returns (bool)
179     {
180         require(_balances[src] - _frozens[src] >= wad);
181         
182         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
183             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
184         }
185 
186         _balances[src] = sub(_balances[src], wad);
187         _balances[dst] = add(_balances[dst], wad);
188 
189         emit Transfer(src, dst, wad);
190 
191         return true;
192     }
193     function transferMulti(address[] dsts, uint wad)  public auth returns (bool) {  
194         require(dsts.length > 0);
195         require(_balances[msg.sender] - _frozens[msg.sender] >= mul(wad, dsts.length));
196         
197         for(uint32 i=0; i<dsts.length; i++){
198             transfer(dsts[i], wad);
199         }  
200         return true;
201     }
202     
203     function push(address dst, uint wad) public {
204         transferFrom(msg.sender, dst, wad);
205     }
206     
207     function pull(address src, uint wad) public {
208         transferFrom(src, msg.sender, wad);
209     }
210     
211     function move(address src, address dst, uint wad) public {
212         transferFrom(src, dst, wad);
213     }
214     
215     function freezeAccount(address guy, uint wad) public auth {
216         require(_balances[guy] >= wad);
217         
218         _frozens[guy] = add(0, wad);
219         emit Freeze(guy, wad);
220     }
221 
222     string   public  name = "MeYou Token";
223 
224     function setName(string name_) public auth {
225         name = name_;
226     }
227     
228     function setSymbol(string symbol_) public auth {
229         symbol = symbol_;
230     }
231 }