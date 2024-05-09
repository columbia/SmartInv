1 pragma solidity ^0.4.23;
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
18     constructor() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24     public
25     auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32     public
33     auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
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
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed sig,
60         address  indexed guy,
61         bytes32  indexed foo,
62         bytes32  indexed bar,
63         uint wad,
64         bytes fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         require(!stopped);
88         _;
89     }
90     function stop() public auth note {
91         stopped = true;
92     }
93 
94     function start() public auth note {
95         stopped = false;
96     }
97 
98 }
99 
100 contract DSMath {
101     function add(uint x, uint y) internal pure returns (uint z) {
102         require((z = x + y) >= x);
103     }
104 
105     function sub(uint x, uint y) internal pure returns (uint z) {
106         require((z = x - y) <= x);
107     }
108 
109     function mul(uint x, uint y) internal pure returns (uint z) {
110         require(y == 0 || (z = x * y) / y == x);
111     }
112 }
113 
114 contract ERC20Events {
115     event Approval(address indexed from, address indexed to, uint value);
116     event Transfer(address indexed from, address indexed to, uint value);
117 }
118 
119 contract ERC20 is ERC20Events {
120     function totalSupply() public view returns (uint);
121 
122     function balanceOf(address guy) public view returns (uint);
123 
124     function allowance(address src, address guy) public view returns (uint);
125 
126     function approve(address guy, uint value) public returns (bool);
127 
128     function transfer(address dst, uint value) public returns (bool);
129 
130     function transferFrom(
131         address src, address dst, uint value
132     ) public returns (bool);
133 }
134 
135 contract DCUCoin is ERC20, DSMath, DSStop {
136     string public    name;
137     string public    symbol;
138     uint8 public     decimals = 18;
139     uint256 internal supply;
140     mapping(address => uint256)                      balances;
141     mapping(address => mapping(address => uint256))  approvals;
142 
143     constructor(uint256 token_supply, string token_name, string token_symbol) public {
144         balances[msg.sender] = token_supply;
145         supply = token_supply;
146         name = token_name;
147         symbol = token_symbol;
148     }
149 
150     function() public payable {
151         revert();
152     }
153 
154     function setName(string token_name) auth public {
155         name = token_name;
156     }
157 
158     function totalSupply() constant public returns (uint256) {
159         return supply;
160     }
161 
162     function balanceOf(address src) public view returns (uint) {
163         return balances[src];
164     }
165 
166     function allowance(address src, address guy) public view returns (uint) {
167         return approvals[src][guy];
168     }
169 
170     function transfer(address dst, uint value) public stoppable returns (bool) {
171         // uint never less than 0. The negative number will become to a big positive number
172         require(value < supply);
173         require(balances[msg.sender] >= value);
174 
175         balances[msg.sender] = sub(balances[msg.sender], value);
176         balances[dst] = add(balances[dst], value);
177 
178         emit Transfer(msg.sender, dst, value);
179 
180         return true;
181     }
182 
183     function transferFrom(address src, address dst, uint value) public stoppable returns (bool)
184     {
185         // uint never less than 0. The negative number will become to a big positive number
186         require(value < supply);
187         require(approvals[src][msg.sender] >= value);
188         require(balances[src] >= value);
189 
190         approvals[src][msg.sender] = sub(approvals[src][msg.sender], value);
191         balances[src] = sub(balances[src], value);
192         balances[dst] = add(balances[dst], value);
193 
194         emit Transfer(src, dst, value);
195 
196         return true;
197     }
198 
199     function approve(address guy, uint value) public stoppable returns (bool) {
200         // uint never less than 0. The negative number will become to a big positive number
201         require(value < supply);
202 
203         approvals[msg.sender][guy] = value;
204 
205         emit Approval(msg.sender, guy, value);
206 
207         return true;
208     }
209 }