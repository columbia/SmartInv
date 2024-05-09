1 contract Token {
2     string internal _symbol;
3     string internal _name;
4     uint8 internal _decimals;
5     uint internal _totalSupply = 1000;
6     mapping (address => uint) internal _balanceOf;
7     mapping (address => mapping (address => uint)) internal _allowances;
8     
9     function Token(string symbol, string name, uint8 decimals, uint totalSupply) public {
10         _symbol = symbol;
11         _name = name;
12         _decimals = decimals;
13         _totalSupply = totalSupply;
14     }
15     
16     function name() public constant returns (string) {
17         return _name;
18     }
19     
20     function symbol() public constant returns (string) {
21         return _symbol;
22     }
23     
24     function decimals() public constant returns (uint8) {
25         return _decimals;
26     }
27     
28     function totalSupply() public constant returns (uint) {
29         return _totalSupply;
30     }
31     
32     function balanceOf(address _addr) public constant returns (uint);
33     function transfer(address _to, uint _value) public returns (bool);
34     event Transfer(address indexed _from, address indexed _to, uint _value);
35 }
36 
37 interface ERC20 {
38     function transferFrom(address _from, address _to, uint _value) public returns (bool);
39     function approve(address _spender, uint _value) public returns (bool);
40     function allowance(address _owner, address _spender) public constant returns (uint);
41     event Approval(address indexed _owner, address indexed _spender, uint _value);
42 }
43 
44 interface ERC223 {
45     function transfer(address _to, uint _value, bytes _data) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
47 }
48 
49 contract ERC223ReceivingContract {
50     function tokenFallback(address _from, uint _value, bytes _data) public;
51 }
52 
53 contract FandBToken is Token("FAB", "F&BCoin", 0, 10000), ERC20, ERC223 {
54 
55     function FandBToken() public {
56         _balanceOf[msg.sender] = _totalSupply;
57     }
58     
59     function totalSupply() public constant returns (uint) {
60         return _totalSupply;
61     }
62     
63     function balanceOf(address _addr) public constant returns (uint) {
64         return _balanceOf[_addr];
65     }
66 
67     function transfer(address _to, uint _value) public returns (bool) {
68         if (_value > 0 && 
69             _value <= _balanceOf[msg.sender] &&
70             !isContract(_to)) {
71             _balanceOf[msg.sender] -= _value;
72             _balanceOf[_to] += _value;
73             Transfer(msg.sender, _to, _value);
74             return true;
75         }
76         return false;
77     }
78 
79     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
80         if (_value > 0 && 
81             _value <= _balanceOf[msg.sender] &&
82             isContract(_to)) {
83             _balanceOf[msg.sender] -= _value;
84             _balanceOf[_to] += _value;
85             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
86                 _contract.tokenFallback(msg.sender, _value, _data);
87             Transfer(msg.sender, _to, _value, _data);
88             return true;
89         }
90         return false;
91     }
92 
93     function isContract(address _addr) returns (bool) {
94         uint codeSize;
95         assembly {
96             codeSize := extcodesize(_addr)
97         }
98         return codeSize > 0;
99     }
100 
101     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
102         if (_allowances[_from][msg.sender] > 0 &&
103             _value > 0 &&
104             _allowances[_from][msg.sender] >= _value &&
105             _balanceOf[_from] >= _value) {
106             _balanceOf[_from] -= _value;
107             _balanceOf[_to] += _value;
108             _allowances[_from][msg.sender] -= _value;
109             Transfer(_from, _to, _value);
110             return true;
111         }
112         return false;
113     }
114     
115     function approve(address _spender, uint _value) public returns (bool) {
116         _allowances[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120     
121     function allowance(address _owner, address _spender) public constant returns (uint) {
122         return _allowances[_owner][_spender];
123     }
124 }