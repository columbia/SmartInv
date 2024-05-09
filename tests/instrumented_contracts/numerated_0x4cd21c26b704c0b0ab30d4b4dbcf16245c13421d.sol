1 pragma solidity ^0.4.26;
2 
3 library SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 }
28 
29 contract Token {
30 
31     uint256 public totalSupply;
32 
33     function balanceOf(address _owner) view public returns (uint256 balance);
34 
35     function transfer(address _to, uint256 _value) public returns (bool success);
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract StandardToken is Token {
48 
49     mapping (address => uint256) public _balances;
50     mapping (address => mapping (address => uint256)) public _allowed;
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         require(_to != address(0));
54         require(_value <= _balances[msg.sender]);
55         require(_balances[_to] + _value > _balances[_to]);
56         _balances[msg.sender] = SafeMath.safeSub(_balances[msg.sender], _value);
57         _balances[_to] = SafeMath.safeAdd(_balances[_to], _value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_to != address(0));
64         require(_value <= _balances[_from]);
65         require(_value <= _allowed[_from][msg.sender]);
66         require(_balances[_to] + _value > _balances[_to]);
67         _balances[_to] = SafeMath.safeAdd(_balances[_to], _value);
68         _balances[_from] = SafeMath.safeSub(_balances[_from], _value);
69         _allowed[_from][msg.sender] = SafeMath.safeSub(_allowed[_from][msg.sender], _value);
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) view public returns (uint256 balance) {
75         return _balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         require((_value == 0) || (_allowed[msg.sender][_spender] == 0));
80         _allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
86         return _allowed[_owner][_spender];
87     }
88 }
89 
90 contract TokenERC20 is StandardToken {
91     function () public payable {
92         revert();
93     }
94 
95     string public name = "Hundred percent";
96     uint8 public decimals = 10;
97     string public symbol = "YBF";
98     uint256 public totalSupply = 1000000000*10**10;
99 
100     constructor() public {
101         _balances[msg.sender] = totalSupply;
102         emit Transfer(address(0), msg.sender, totalSupply);
103     }
104 }