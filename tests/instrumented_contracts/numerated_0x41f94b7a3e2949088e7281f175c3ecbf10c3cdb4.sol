1 pragma solidity ^0.4.20;
2 
3 contract ERC20ext
4 {
5   function totalSupply() public constant returns (uint supply);
6   function balanceOf( address who ) public constant returns (uint value);
7   function allowance( address owner, address spender ) public constant returns (uint _allowance);
8 
9   function transfer( address to, uint value) public returns (bool ok);
10   function transferFrom( address from, address to, uint value) public returns (bool ok);
11   function approve( address spender, uint value ) public returns (bool ok);
12 
13   event Transfer( address indexed from, address indexed to, uint value);
14   event Approval( address indexed owner, address indexed spender, uint value);
15 
16   function postMessage(address dst, uint wad,string data) public returns (bool ok);
17   function appointNewCFO(address newCFO) public returns (bool ok);
18 
19   function melt(address dst, uint256 wad) public returns (bool ok);
20   function mint(address dst, uint256 wad) public returns (bool ok);
21   function freeze(address dst, bool flag) public returns (bool ok);
22 
23   event MeltEvent(address indexed dst, uint256 wad);
24   event MintEvent(address indexed dst, uint256 wad);
25   event FreezeEvent(address indexed dst, bool flag);
26 }
27 
28 contract SafeMath 
29 {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
31   {
32     if (a == 0) {
33       return 0;
34     }
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) 
41   {
42     return a / b;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
46   {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
52   {
53     c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 contract SGCH is ERC20ext,SafeMath
60 {
61   string public name;
62   string public symbol;
63   uint8  public decimals = 18;
64 
65   address _cfo;
66   uint256 _supply;
67 
68   mapping (address => uint256) _balances;
69   mapping (address => mapping (address => uint256)) _allowance;
70   mapping (address => bool) public _frozen;
71 
72   function SGCH(uint256 initialSupply,string tokenName,string tokenSymbol) public
73   {
74     _cfo    = msg.sender;
75     _supply = initialSupply * 10 ** uint256(decimals);
76     _balances[_cfo] = _supply;
77 
78     name   = tokenName;
79     symbol = tokenSymbol;
80   }
81 
82   modifier onlyCFO()
83   {
84     require(msg.sender == _cfo);
85     _;
86   }
87 
88   function totalSupply() public constant returns (uint256)
89   {
90     return _supply;
91   }
92   function balanceOf(address src) public constant returns (uint256)
93   {
94     return _balances[src];
95   }
96   function allowance(address src, address dst) public constant returns (uint256)
97   {
98     return _allowance[src][dst];
99   }
100   function transfer(address dst, uint wad) public returns (bool)
101   {
102     require(!_frozen[msg.sender]);
103     require(!_frozen[dst]);
104 
105     require(_balances[msg.sender] >= wad);
106 
107     _balances[msg.sender] = sub(_balances[msg.sender],wad);
108     _balances[dst]        = add(_balances[dst], wad);
109 
110     Transfer(msg.sender, dst, wad);
111 
112     return true;
113   }
114   function transferFrom(address src, address dst, uint wad) public returns (bool)
115   {
116     require(!_frozen[msg.sender]);
117     require(!_frozen[dst]);
118 
119     require(_balances[src] >= wad);
120 
121     require(_allowance[src][msg.sender] >= wad);
122 
123     _allowance[src][msg.sender] = sub(_allowance[src][msg.sender],wad);
124 
125     _balances[src] = sub(_balances[src],wad);
126     _balances[dst] = add(_balances[dst],wad);
127 
128     Transfer(src, dst, wad);
129 
130     return true;
131   }
132 
133   function approve(address dst, uint256 wad) public returns (bool)
134   {
135     _allowance[msg.sender][dst] = wad;
136 
137     Approval(msg.sender, dst, wad);
138     return true;
139   }
140 
141   function postMessage(address dst, uint wad,string data) public returns (bool)
142   {
143     return transfer(dst,wad);
144   }
145   function appointNewCFO(address newCFO) onlyCFO public returns (bool)
146   {
147     if (newCFO != _cfo)
148     {
149       _cfo = newCFO;
150       return true;
151     }
152     else
153     {
154       return false;
155     }
156   }
157 
158   function freeze(address dst, bool flag) onlyCFO public returns (bool)
159   {
160     _frozen[dst] = flag;
161 
162     FreezeEvent(dst, flag);
163     return true;
164   }
165 
166   function mint(address dst, uint256 wad) onlyCFO public returns (bool)
167   {
168     _balances[dst] = add(_balances[dst],wad);
169     _supply        = add(_supply,wad);
170 
171     MintEvent(dst, wad);
172     return true;
173   }
174 
175   function melt(address dst, uint256 wad) onlyCFO public returns (bool)
176   {
177     require(_balances[dst] >= wad);
178 
179     _balances[dst] = sub(_balances[dst],wad);
180     _supply        = sub(_supply,wad);
181 
182     MeltEvent(dst, wad);
183     return true;
184   }
185 }