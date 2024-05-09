1 pragma solidity 0.4.26;
2 
3 contract SafeMath {
4     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         _assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11         _assert(b > 0);
12         uint256 c = a / b;
13         _assert(a == b * c + a % b);
14         return c;
15     }
16 
17     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18         _assert(b <= a);
19         return a - b;
20     }
21 
22     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         _assert(c >= a && c >= b);
25         return c;
26     }
27 
28     function _assert(bool assertion) internal pure {
29         if (!assertion) {
30             revert();
31         }
32     }
33 }
34 
35 contract StarExchangeCoin is SafeMath {
36     string public name = "Star Exchange Coin";
37     string public symbol = "SEC";
38     uint8 constant public decimals = 8;
39     mapping(address => uint256)  _balances;
40     mapping(address => mapping(address => uint256)) public _allowed;
41 
42     uint256  public totalSupply = 20 * 100000000 * 100000000;
43 
44 
45     constructor () public{
46         _balances[msg.sender] = totalSupply;
47         emit Transfer(0x0, msg.sender, totalSupply);
48     }
49 
50     function balanceOf(address addr) public view returns (uint256) {
51         return _balances[addr];
52     }
53 
54 
55     function transfer(address _to, uint256 _value)  public returns (bool) {
56         if (_to == address(0)) {
57             return burn(_value);
58         } else {
59             require(_balances[msg.sender] >= _value && _value >= 0);
60             require(_balances[_to] + _value >= _balances[_to]);
61 
62             _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
63             _balances[_to] = safeAdd(_balances[_to], _value);
64             emit Transfer(msg.sender, _to, _value);
65             return true;
66         }
67     }
68 
69     function burn(uint256 _value) public returns (bool) {
70         require(_balances[msg.sender] >= _value && _value > 0);
71         require(totalSupply >= _value);
72         _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
73         totalSupply = safeSub(totalSupply, _value);
74         emit Burn(msg.sender, _value);
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
79         require(_to != address(0));
80         require(_balances[_from] >= _value && _value >= 0);
81         require(_balances[_to] + _value >= _balances[_to]);
82 
83         require(_allowed[_from][msg.sender] >= _value);
84 
85         _balances[_to] = safeAdd(_balances[_to], _value);
86         _balances[_from] = safeSub(_balances[_from], _value);
87         _allowed[_from][msg.sender] = safeSub(_allowed[_from][msg.sender], _value);
88         emit Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(address spender, uint256 value)  public returns (bool) {
93         require(spender != address(0));
94         require(value == 0 || _allowed[msg.sender][spender] == 0);
95         _allowed[msg.sender][spender] = value;
96         emit Approval(msg.sender, spender, value);
97         return true;
98     }
99 
100     function allowance(address _master, address _spender) public view returns (uint256) {
101         return _allowed[_master][_spender];
102     }
103 
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105     event Transfer(address indexed _from, address indexed _to, uint256 value);
106     event Burn(address indexed _from, uint256 value);
107 }