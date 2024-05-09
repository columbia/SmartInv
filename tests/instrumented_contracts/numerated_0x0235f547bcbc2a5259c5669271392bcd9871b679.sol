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
66 contract SelfDesctructionContract is owned {
67    
68    string  public someValue;
69    modifier ownerRestricted {
70       require(owner == msg.sender);
71       _;
72    } 
73  
74    function SelfDesctructionContract() {
75       owner = msg.sender;
76    }
77    
78    function setSomeValue(string value){
79       someValue = value;
80    } 
81 
82    function destroyContract() ownerRestricted {
83      selfdestruct(owner);
84    }
85 }
86  
87 contract ERC20 is ERC20Interface,SafeMath,SelfDesctructionContract{
88 
89     mapping(address => uint256) public balanceOf;
90 
91     mapping(address => mapping(address => uint256)) allowed;
92 
93     constructor(string _name) public {
94        name = _name;  // "UpChain";
95        symbol = "BSC(bitsay)";
96        decimals = 4;
97        totalSupply = 760000000000;
98        balanceOf[msg.sender] = totalSupply;
99     }
100 
101   function transfer(address _to, uint256 _value) returns (bool success) {
102       require(_to != address(0));
103       require(balanceOf[msg.sender] >= _value);
104       require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
105 
106       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
107       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
108 
109       emit Transfer(msg.sender, _to, _value);
110 
111       return true;
112   }
113 
114 
115   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
116       require(_to != address(0));
117       require(allowed[_from][msg.sender] >= _value);
118       require(balanceOf[_from] >= _value);
119       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
120 
121       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
122       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
123 
124       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
125 
126       emit Transfer(msg.sender, _to, _value);
127       return true;
128   }
129 
130   function approve(address _spender, uint256 _value) returns (bool success) {
131       allowed[msg.sender][_spender] = _value;
132 
133       emit Approval(msg.sender, _spender, _value);
134       return true;
135   }
136 
137   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
138       return allowed[_owner][_spender];
139   }
140 
141 }