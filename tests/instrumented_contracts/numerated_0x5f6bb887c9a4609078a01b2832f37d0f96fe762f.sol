1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-12
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 contract SafeMath {
8     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         _assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15         _assert(b > 0);
16         uint256 c = a / b;
17         _assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         _assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         _assert(c >= a && c >= b);
29         return c;
30     }
31 
32     function _assert(bool assertion) internal pure {
33         if (!assertion) {
34             revert();
35         }
36     }
37 }
38 
39 contract LTT is SafeMath {
40     string public name = "LiteToken";
41     string public symbol = "LTT";
42     uint8 constant public decimals = 8;
43     mapping(address => uint256)  _balances;
44     mapping(address => mapping(address => uint256)) public _allowed;
45 
46     uint256  public totalSupply = 21000000 * 100000000;
47 
48 
49     constructor () public{
50         _balances[msg.sender] = totalSupply;
51         emit Transfer(0x0, msg.sender, totalSupply);
52     }
53 
54     function balanceOf(address addr) public view returns (uint256) {
55         return _balances[addr];
56     }
57 
58 
59     function transfer(address _to, uint256 _value)  public returns (bool) {
60 //        require(_to != address(0));
61         if (_to == address(0)) {
62             return burn(_value);
63         } else {
64             require(_balances[msg.sender] >= _value && _value > 0);
65             require(_balances[_to] + _value >= _balances[_to]);
66 
67             _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
68             _balances[_to] = safeAdd(_balances[_to], _value);
69             emit Transfer(msg.sender, _to, _value);
70             return true;
71         }
72     }
73 
74     function burn(uint256 _value) public returns (bool) {
75         require(_balances[msg.sender] >= _value && _value > 0);
76         require(totalSupply >= _value);
77         _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
78         totalSupply = safeSub(totalSupply, _value);
79         emit Burn(msg.sender, _value);
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
84         require(_to != address(0));
85         require(_balances[_from] >= _value && _value > 0);
86         require(_balances[_to] + _value >= _balances[_to]);
87 
88         require(_allowed[_from][msg.sender] >= _value);
89 
90         _balances[_to] = safeAdd(_balances[_to], _value);
91         _balances[_from] = safeSub(_balances[_from], _value);
92         _allowed[_from][msg.sender] = safeSub(_allowed[_from][msg.sender], _value);
93         emit Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address spender, uint256 value)  public returns (bool) {
98         require(spender != address(0));
99         _allowed[msg.sender][spender] = value;
100         emit Approval(msg.sender, spender, value);
101         return true;
102     }
103 
104     function allowance(address _master, address _spender) public view returns (uint256) {
105         return _allowed[_master][_spender];
106     }
107 
108     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109     event Transfer(address indexed _from, address indexed _to, uint256 value);
110     event Burn(address indexed _from, uint256 value);
111 }