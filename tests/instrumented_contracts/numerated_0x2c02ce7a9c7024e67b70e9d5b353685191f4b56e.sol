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
41   function approve(address _spender, uint256 _value) returns (bool success);
42   function allowance(address _owner, address _spender) view returns (uint256 remaining);
43   event Transfer(address indexed _from, address indexed _to, uint256 _value);
44   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45  }
46  
47  contract owned {
48     address public owner;
49 
50     constructor () public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnerShip(address newOwer) public onlyOwner {
60         owner = newOwer;
61     }
62 
63 }
64 contract ERC20 is ERC20Interface,SafeMath{
65 
66     mapping(address => uint256) public balanceOf;
67     mapping(address => mapping(address => uint256)) allowed;
68 
69     constructor(string _name) public {
70        name = _name;  // "UpChain";
71        symbol = "BGS";
72        decimals = 4;
73        totalSupply = 10000000000000;
74        balanceOf[msg.sender] = totalSupply;
75     }
76 
77   function transfer(address _to, uint256 _value) returns (bool success) {
78       require(_to != address(0));
79       require(balanceOf[msg.sender] >= _value);
80       require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
81 
82       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
83       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
84 
85       emit Transfer(msg.sender, _to, _value);
86 
87       return true;
88   }
89 
90 
91   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92       require(_to != address(0));
93       require(allowed[_from][msg.sender] >= _value);
94       require(balanceOf[_from] >= _value);
95       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
96 
97       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
98       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
99 
100       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
101 
102       emit Transfer(msg.sender, _to, _value);
103       return true;
104   }
105 
106   function approve(address _spender, uint256 _value) returns (bool success) {
107       allowed[msg.sender][_spender] = _value;
108 
109       emit Approval(msg.sender, _spender, _value);
110       return true;
111   }
112 
113   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
114       return allowed[_owner][_spender];
115   }
116 
117 }