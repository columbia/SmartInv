1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal pure returns ( uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSub(uint256 x, uint256 y) internal pure returns ( uint256) {
12         assert(x >= y);
13         uint256 z = x - y;
14         return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal pure returns ( uint256) {
18         uint256 z = x * y;
19         assert((x == 0)||(z/x == y));
20         return z;
21     }
22 
23 }
24 
25 contract ERC20 {
26     function totalSupply() constant public returns ( uint supply);
27 
28     function balanceOf( address who ) constant public returns ( uint value);
29     function allowance( address owner, address spender ) constant public returns (uint _allowance);
30     function transfer( address to, uint value) public returns (bool ok);
31     function transferFrom( address from, address to, uint value) public returns (bool ok);
32     function approve( address spender, uint value ) public returns (bool ok);
33 
34     event Transfer( address indexed from, address indexed to, uint value);
35     event Approval( address indexed owner, address indexed spender, uint value);
36 }
37 
38 //implement 
39 contract StandardToken is SafeMath,ERC20 {
40     uint256     _totalSupply;
41     
42     function totalSupply() constant public returns ( uint256) {
43         return _totalSupply;
44     }
45 
46     function transfer(address dst, uint wad) public returns (bool) {
47         assert(balances[msg.sender] >= wad);
48         
49         balances[msg.sender] = safeSub(balances[msg.sender], wad);
50         balances[dst] = safeAdd(balances[dst], wad);
51         
52         Transfer(msg.sender, dst, wad);
53         
54         return true;
55     }
56     
57     function transferFrom(address src, address dst, uint wad) public returns (bool) {
58         assert(wad > 0 );
59         assert(balances[src] >= wad);
60         
61         balances[src] = safeSub(balances[src], wad);
62         balances[dst] = safeAdd(balances[dst], wad);
63         
64         Transfer(src, dst, wad);
65         
66         return true;
67     }
68 
69     function balanceOf(address _owner) constant public returns ( uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) public returns ( bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant public returns ( uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82     
83     function freezeOf(address _owner) constant public returns ( uint256 balance) {
84         return freezes[_owner];
85     }
86     
87 
88     mapping (address => uint256) balances;
89     mapping (address => uint256) freezes;
90     mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract DSAuth {
94     address public authority;
95     address public owner;
96 
97     function DSAuth() public {
98         owner = msg.sender;
99         authority = msg.sender;
100     }
101 
102     function setOwner(address owner_) Owner public
103     {
104         owner = owner_;
105     }
106 
107     modifier Auth {
108         assert(isAuthorized(msg.sender));
109         _;
110     }
111     
112     modifier Owner {
113         assert(msg.sender == owner);
114         _;
115     }
116 
117     function isAuthorized(address src) internal view returns ( bool) {
118         if (src == address(this)) {
119             return true;
120         } else if (src == authority) {
121             return true;
122         }
123         else if (src == owner) {
124             return true;
125         }
126         return false;
127     }
128 
129 }
130 
131 contract DRCToken is StandardToken,DSAuth {
132 
133     string public name = "Digit RedWine Coin";
134     uint8 public decimals = 18;
135     string public symbol = "DRC";
136     
137     /* This notifies clients about the amount frozen */
138     event Freeze(address indexed from, uint256 value);
139     
140     /* This notifies clients about the amount unfrozen */
141     event Unfreeze(address indexed from, uint256 value);
142     
143     /* This notifies clients about the amount burnt */
144     event Burn(address indexed from, uint256 value);
145 
146     function DRCToken() public {
147         
148     }
149 
150     function mint(uint256 wad) Owner public {
151         balances[msg.sender] = safeAdd(balances[msg.sender], wad);
152         _totalSupply = safeAdd(_totalSupply, wad);
153     }
154 
155     function burn(uint256 wad) Owner public {
156         balances[msg.sender] = safeSub(balances[msg.sender], wad);
157         _totalSupply = safeSub(_totalSupply, wad);
158         Burn(msg.sender, wad);
159     }
160 
161     function push(address dst, uint256 wad) public returns ( bool) {
162         return transfer(dst, wad);
163     }
164 
165     function pull(address src, uint256 wad) public returns ( bool) {
166         return transferFrom(src, msg.sender, wad);
167     }
168 
169     function transfer(address dst, uint wad) public returns (bool) {
170         return super.transfer(dst, wad);
171     }
172     
173     function freeze(address dst,uint256 _value) Auth public returns (bool success) {
174         assert(balances[dst] >= _value); // Check if the sender has enough
175         assert(_value > 0) ; 
176         balances[dst] = SafeMath.safeSub(balances[dst], _value);                      // Subtract from the sender
177         freezes[dst] = SafeMath.safeAdd(freezes[dst], _value);                                // Updates totalSupply
178         Freeze(dst, _value);
179         return true;
180     }
181     
182     function unfreeze(address dst,uint256 _value) Auth public returns (bool success) {
183         assert(freezes[dst] >= _value);            // Check if the sender has enough
184         assert(_value > 0) ; 
185         freezes[dst] = SafeMath.safeSub(freezes[dst], _value);                      // Subtract from the sender
186         balances[dst] = SafeMath.safeAdd(balances[dst], _value);
187         Unfreeze(dst, _value);
188         return true;
189     }
190 }