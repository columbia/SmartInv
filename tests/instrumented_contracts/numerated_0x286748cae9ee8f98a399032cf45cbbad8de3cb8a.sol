1 pragma solidity ^0.4.24;
2 
3 contract MathLib 
4 {
5     function add(uint256 x, uint256 y) pure internal returns (uint256 z) 
6     {
7         assert((z = x + y) >= x);
8     }
9 
10     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) 
11     {
12         assert((z = x - y) <= x);
13     }
14 
15     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) 
16     {
17         assert((z = x * y) >= x);
18     }
19 
20     function div(uint256 x, uint256 y) pure internal returns (uint256 z) 
21     {
22         z = x / y;
23     }
24 
25     function min(uint256 x, uint256 y) pure internal returns (uint256 z) 
26     {
27         return x <= y ? x : y;
28     }
29     
30     function max(uint256 x, uint256 y) pure internal returns (uint256 z) 
31     {
32         return x >= y ? x : y;
33     }
34 
35 }
36 
37 contract ERC20 
38 {
39     function totalSupply() public constant returns (uint supply);
40     function balanceOf(address who) public constant returns (uint value);
41     function allowance(address owner, address spender) public constant returns (uint _allowance);
42 
43     function transfer(address to, uint value) public returns (bool ok);
44     function transferFrom(address from, address to, uint value) public returns (bool ok);
45     function approve(address spender, uint value) public returns (bool ok);
46 
47     event Transfer(address indexed from, address indexed to, uint value);
48     event Approval(address indexed owner, address indexed spender, uint value);
49 }
50 
51 contract TokenBase is ERC20, MathLib 
52 {
53     uint256                                            _supply;
54     mapping (address => uint256)                       _balances;
55     mapping (address => mapping (address => uint256))  _approvals;
56     
57     constructor(uint256 supply) public 
58     {
59         _balances[msg.sender] = supply;
60         _supply = supply;
61     }
62     
63     function totalSupply() public constant returns (uint256) 
64     {
65         return _supply;
66     }
67     
68     function balanceOf(address src) public constant returns (uint256) 
69     {
70         return _balances[src];
71     }
72     
73     function allowance(address src, address guy) public constant returns (uint256) 
74     {
75         return _approvals[src][guy];
76     }
77     
78     function transfer(address dst, uint wad) public returns (bool) 
79     {
80         assert(_balances[msg.sender] >= wad);
81         
82         _balances[msg.sender] = sub(_balances[msg.sender], wad);
83         _balances[dst] = add(_balances[dst], wad);
84         
85         emit Transfer(msg.sender, dst, wad);
86         
87         return true;
88     }
89     
90     function transferFrom(address src, address dst, uint wad) public returns (bool)
91     {
92         assert(_balances[src] >= wad);
93         assert(_approvals[src][msg.sender] >= wad);
94         
95         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
96         _balances[src] = sub(_balances[src], wad);
97         _balances[dst] = add(_balances[dst], wad);
98         
99         emit Transfer(src, dst, wad);
100         
101         return true;
102     }
103     
104     function approve(address guy, uint256 wad) public returns (bool)
105     {
106         _approvals[msg.sender][guy] = wad;
107         
108         emit Approval(msg.sender, guy, wad);
109         
110         return true;
111     }
112 
113 }
114 
115 interface GatewayVote 
116 {
117     function burnForGateway(address from, string receiver, uint64 wad) external;
118 }
119 
120 contract WBCHToken is TokenBase(0) 
121 {
122 
123     uint8   public  decimals = 8;
124     address private Gateway;
125         
126     string  public  name   = "Wrapped BCH (BCH-MALLOW-ETH for standard)";
127     string  public  symbol = "WBCH";
128     
129     
130     event Mint(address receiver, uint64 wad);
131     event Burn(address from, string receiver, uint64 wad);
132     event GatewayChangedTo(address newer);
133 
134     constructor(address gateway) public
135     {
136         Gateway = gateway;
137         emit GatewayChangedTo(Gateway);
138     }
139 
140     function transfer(address dst, uint wad) public returns (bool)
141     {
142         return super.transfer(dst, wad);
143     }
144     
145     function transferFrom(address src, address dst, uint wad) public returns (bool) 
146     {
147         return super.transferFrom(src, dst, wad);
148     }
149     
150     function approve(address guy, uint wad) public returns (bool) 
151     {
152         return super.approve(guy, wad);
153     }
154 
155     function mint(address receiver, uint64 wad) external returns (bool)
156     {
157         require(msg.sender == Gateway);
158         
159         _balances[receiver] = add(_balances[receiver], wad);
160         _supply = add(_supply, wad);
161         
162         emit Mint(receiver, wad);
163         
164         return true;
165     }
166     
167     function changeGatewayAddr(address newer) external returns (bool)
168     {
169         require(msg.sender == Gateway);
170         Gateway = newer;
171         
172         emit GatewayChangedTo(Gateway);
173         
174         return true;
175     }
176     
177     function burn(uint64 wad, string receiver) external
178     {
179         assert(_balances[msg.sender] >= wad);
180         
181         _balances[msg.sender] = sub(_balances[msg.sender], wad);
182         _supply = sub(_supply, wad);
183         
184         emit Burn(msg.sender, receiver, wad);
185         
186         GatewayVote(Gateway).burnForGateway(msg.sender, receiver, wad);
187     }
188 }