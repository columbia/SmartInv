1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     string internal _symbol;
5     string internal _name;
6     uint8 internal _decimals;
7     uint internal _totalSupply = 200000000;
8     mapping (address => uint) internal _balanceOf;
9     mapping (address => mapping (address => uint)) internal _allowances;
10     
11     function Token(string symbol, string name, uint8 decimals, uint totalSupply) public {
12         _symbol = symbol;
13         _name = name;
14         _decimals = decimals;
15         _totalSupply = totalSupply;
16     }
17     
18     function name() public constant returns (string) {
19         return _name;
20     }
21     
22     function symbol() public constant returns (string) {
23         return _symbol;
24     }
25     
26     function decimals() public constant returns (uint8) {
27         return _decimals;
28     }
29     
30     function totalSupply() public constant returns (uint) {
31         return _totalSupply;
32     }
33     
34     function balanceOf(address _addr) public constant returns (uint);
35     function transfer(address _to, uint _value) public returns (bool);
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37 }
38 
39 interface ERC20 {
40     function transferFrom(address _from, address _to, uint _value) public returns (bool);
41     function approve(address _spender, uint _value) public returns (bool);
42     function allowance(address _owner, address _spender) public constant returns (uint);
43     event Approval(address indexed _owner, address indexed _spender, uint _value);
44 }
45 
46 interface ERC223 {
47     function transfer(address _to, uint _value, bytes _data) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
49 }
50 
51 contract ERC223ReceivingContract {
52     function tokenFallback(address _from, uint _value, bytes _data) public;
53 }
54 
55 contract Maya_Preferred is Token("MAYP", "Maya Preferred", 18, 200000000 * 10 ** 18), ERC20, ERC223 {
56 
57     function Maya_Preferred() public {
58         _balanceOf[msg.sender] = _totalSupply;
59     }
60     
61     function totalSupply() public constant returns (uint) {
62         return _totalSupply;
63     }
64     
65     function balanceOf(address _addr) public constant returns (uint) {
66         return _balanceOf[_addr];
67     }
68 
69     function transfer(address _to, uint _value) public returns (bool) {
70         if (_value > 0 && 
71             _value <= _balanceOf[msg.sender] &&
72             !isContract(_to)) {
73             _balanceOf[msg.sender] -= _value;
74             _balanceOf[_to] += _value;
75             Transfer(msg.sender, _to, _value);
76             return true;
77         }
78         return false;
79     }
80 
81     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
82         if (_value > 0 && 
83             _value <= _balanceOf[msg.sender] &&
84             isContract(_to)) {
85             _balanceOf[msg.sender] -= _value;
86             _balanceOf[_to] += _value;
87             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
88                 _contract.tokenFallback(msg.sender, _value, _data);
89             Transfer(msg.sender, _to, _value, _data);
90             return true;
91         }
92         return false;
93     }
94 
95     function isContract(address _addr) returns (bool) {
96         uint codeSize;
97         assembly {
98             codeSize := extcodesize(_addr)
99         }
100         return codeSize > 0;
101     }
102 
103     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
104         if (_allowances[_from][msg.sender] > 0 &&
105             _value > 0 &&
106             _allowances[_from][msg.sender] >= _value &&
107             _balanceOf[_from] >= _value) {
108             _balanceOf[_from] -= _value;
109             _balanceOf[_to] += _value;
110             _allowances[_from][msg.sender] -= _value;
111             Transfer(_from, _to, _value);
112             return true;
113         }
114         return false;
115     }
116     
117     function approve(address _spender, uint _value) public returns (bool) {
118         _allowances[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122     
123     function allowance(address _owner, address _spender) public constant returns (uint) {
124         return _allowances[_owner][_spender];
125     }
126 }