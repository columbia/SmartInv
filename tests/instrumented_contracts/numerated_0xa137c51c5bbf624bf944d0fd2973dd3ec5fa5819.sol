1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) public pure  returns (uint256)  {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b)public pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b)public pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b)public pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function _assert(bool assertion)public pure {
29     assert(!assertion);
30   }
31 }
32 
33 
34 contract ERC20Interface {
35   string public name;
36   string public symbol;
37   uint8 public  decimals;
38   uint public totalSupply;
39   
40   function transfer(address _to, uint256 _value) returns (bool success);
41   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
42   function approve(address _spender, uint256 _value) returns (bool success);
43   function allowance(address _owner, address _spender) view returns (uint256 remaining);
44   
45   event Transfer(address indexed _from, address indexed _to, uint256 _value);
46   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47  }
48  
49 contract ERC20 is ERC20Interface,SafeMath{
50 
51     mapping(address => uint256) public balanceOf;
52 
53     mapping(address => mapping(address => uint256)) allowed;
54 
55     constructor(string _name) public {
56        name = _name;  // "UpChain";
57        symbol = "MCBF";
58        decimals = 4;
59        totalSupply = 8800000000000;
60        balanceOf[msg.sender] = totalSupply;
61     }
62 
63   function transfer(address _to, uint256 _value) returns (bool success) {
64       require(_to != address(0));
65       require(balanceOf[msg.sender] >= _value);
66       require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
67 
68       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
69       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
70 
71       emit Transfer(msg.sender, _to, _value);
72 
73       return true;
74   }
75 
76 
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78       require(_to != address(0));
79       require(allowed[_from][msg.sender] >= _value);
80       require(balanceOf[_from] >= _value);
81       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
82 
83       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
84       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
85 
86       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
87 
88       emit Transfer(msg.sender, _to, _value);
89       return true;
90   }
91 
92   function approve(address _spender, uint256 _value) returns (bool success) {
93       allowed[msg.sender][_spender] = _value;
94 
95       emit Approval(msg.sender, _spender, _value);
96       return true;
97   }
98 
99   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101   }
102 
103 }