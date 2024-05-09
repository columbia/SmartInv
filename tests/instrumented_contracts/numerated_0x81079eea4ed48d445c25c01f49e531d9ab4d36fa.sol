1 pragma solidity ^0.4.20;
2 contract ERC20ext
3 {
4   function totalSupply() public constant returns (uint supply);
5   function balanceOf( address who ) public constant returns (uint value);
6   function allowance( address owner, address spender ) public constant returns (uint _allowance);
7 
8   function transfer( address to, uint value) public returns (bool ok);
9   function transferFrom( address from, address to, uint value) public returns (bool ok);
10   function approve( address spender, uint value ) public returns (bool ok);
11 
12   event Transfer( address indexed from, address indexed to, uint value);
13   event Approval( address indexed owner, address indexed spender, uint value);
14 
15   // extand
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
27 contract SafeMath 
28 {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
30   {
31     if (a == 0) {
32       return 0;
33     }
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38   function div(uint256 a, uint256 b) internal pure returns (uint256) 
39   {
40     return a / b;
41   }
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
43   {
44     assert(b <= a);
45     return a - b;
46   }
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
48   {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 contract MRC is ERC20ext,SafeMath
55 {
56   string public name;
57   string public symbol;
58   uint8  public decimals = 18;
59   address _cfo;
60   uint256 _supply;
61   mapping (address => uint256) _balances;
62   mapping (address => mapping (address => uint256)) _allowance;
63   mapping (address => bool) public _frozen;
64   function MRC(uint256 initialSupply,string tokenName,string tokenSymbol) public
65   {
66     _cfo    = msg.sender;
67     _supply = initialSupply * 10 ** uint256(decimals);
68     _balances[_cfo] = _supply;
69     name   = tokenName;
70     symbol = tokenSymbol;
71   }
72   modifier onlyCFO()
73   {
74     require(msg.sender == _cfo);
75     _;
76   }
77   function totalSupply() public constant returns (uint256)
78   {
79     return _supply;
80   }
81   function balanceOf(address src) public constant returns (uint256)
82   {
83     return _balances[src];
84   }
85   function allowance(address src, address dst) public constant returns (uint256)
86   {
87     return _allowance[src][dst];
88   }
89   function transfer(address dst, uint wad) public returns (bool)
90   {
91     require(!_frozen[msg.sender]);
92     require(!_frozen[dst]);
93     require(_balances[msg.sender] >= wad);
94     _balances[msg.sender] = sub(_balances[msg.sender],wad);
95     _balances[dst]        = add(_balances[dst], wad);
96     Transfer(msg.sender, dst, wad);
97     return true;
98   }
99   function transferFrom(address src, address dst, uint wad) public returns (bool)
100   {
101     require(!_frozen[msg.sender]);
102     require(!_frozen[dst]);
103     require(_balances[src] >= wad);
104     require(_allowance[src][msg.sender] >= wad);
105 
106     _allowance[src][msg.sender] = sub(_allowance[src][msg.sender],wad);
107 
108     _balances[src] = sub(_balances[src],wad);
109     _balances[dst] = add(_balances[dst],wad);
110 
111     Transfer(src, dst, wad);
112 
113     return true;
114   }
115   function approve(address dst, uint256 wad) public returns (bool)
116   {
117     _allowance[msg.sender][dst] = wad;
118 
119     Approval(msg.sender, dst, wad);
120     return true;
121   }
122   function postMessage(address dst, uint wad,string data) public returns (bool)
123   {
124     return transfer(dst,wad);
125   }
126   function appointNewCFO(address newCFO) onlyCFO public returns (bool)
127   {
128     if (newCFO != _cfo)
129     {
130       _cfo = newCFO;
131       return true;
132     }
133     else
134     {
135       return false;
136     }
137   }
138   function freeze(address dst, bool flag) onlyCFO public returns (bool)
139   {
140     _frozen[dst] = flag;
141 
142     FreezeEvent(dst, flag);
143     return true;
144   }
145   function mint(address dst, uint256 wad) onlyCFO public returns (bool)
146   {
147     _balances[dst] = add(_balances[dst],wad);
148     _supply        = add(_supply,wad);
149 
150     MintEvent(dst, wad);
151     return true;
152   }
153   function melt(address dst, uint256 wad) onlyCFO public returns (bool)
154   {
155     require(_balances[dst] >= wad);
156 
157     _balances[dst] = sub(_balances[dst],wad);
158     _supply        = sub(_supply,wad);
159 
160     MeltEvent(dst, wad);
161     return true;
162   }
163 }