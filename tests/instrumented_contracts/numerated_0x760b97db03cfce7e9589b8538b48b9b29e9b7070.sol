1 pragma solidity ^0.4.20;
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
39   function transfer(address _to, uint256 _value) returns (bool success);
40   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41   
42   function approve(address _spender, uint256 _value) returns (bool success);
43   function allowance(address _owner, address _spender) view returns (uint256 remaining);
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46  }
47  
48  contract owned {
49     address public owner;
50 
51     constructor () public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnerShip(address newOwer) public onlyOwner {
61         owner = newOwer;
62     }
63 
64 }
65 
66 contract ERC20 is ERC20Interface,SafeMath{
67 
68     mapping(address => uint256) public balanceOf;
69 
70     mapping(address => mapping(address => uint256)) allowed;
71 
72     constructor(string _name) public {
73        name = _name;  
74        symbol = "ADC";
75        decimals = 4;
76        totalSupply =1800000000000;
77        balanceOf[msg.sender] = totalSupply;
78     }
79 
80   function transfer(address _to, uint256 _value) returns (bool success) {
81       require(_to != address(0));
82       require(balanceOf[msg.sender] >= _value);
83       require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
84 
85       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
86       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
87 
88       emit Transfer(msg.sender, _to, _value);
89 
90       return true;
91   }
92 
93 
94   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95       require(_to != address(0));
96       require(allowed[_from][msg.sender] >= _value);
97       require(balanceOf[_from] >= _value);
98       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
99 
100       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
101       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
102 
103       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
104 
105       emit Transfer(msg.sender, _to, _value);
106       return true;
107   }
108 
109   function approve(address _spender, uint256 _value) returns (bool success) {
110       allowed[msg.sender][_spender] = _value;
111 
112       emit Approval(msg.sender, _spender, _value);
113       return true;
114   }
115 
116   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
117       return allowed[_owner][_spender];
118   }
119 
120 }