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
39   function transfer(address _to, uint256 _value)public returns (bool success);
40   function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
41   
42   function approve(address _spender, uint256 _value)public returns (bool success);
43   function allowance(address _owner, address _spender)public view returns (uint256 remaining);
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46  }
47  
48 contract ERC20 is ERC20Interface,SafeMath {
49 
50     mapping(address => uint256) public balanceOf;
51 
52     mapping(address => mapping(address => uint256)) allowed;
53 
54     constructor(string _name) public {
55        name = _name;  // "UpChain";
56        symbol = "FMC ";
57        decimals = 4;
58        totalSupply = 900000000000;
59        balanceOf[msg.sender] = totalSupply;
60     }
61 	
62   function transfer(address _to, uint256 _value)public returns (bool success) {
63       require(_to != address(0));
64       require(balanceOf[msg.sender] >= _value);
65       require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
66 
67       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
68       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
69 
70       emit Transfer(msg.sender, _to, _value);
71 
72       return true;
73   }
74 
75 
76   function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
77       require(_to != address(0));
78       require(allowed[_from][msg.sender] >= _value);
79       require(balanceOf[_from] >= _value);
80       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
81 
82       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
83       balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
84 
85       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
86 
87       emit Transfer(msg.sender, _to, _value);
88       return true;
89   }
90 
91   function approve(address _spender, uint256 _value)public returns (bool success) {
92       allowed[msg.sender][_spender] = _value;
93 
94       emit Approval(msg.sender, _spender, _value);
95       return true;
96   }
97 
98   function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100   }
101 
102 }
103 
104 contract owned {
105     address public owner;
106 
107     constructor () public {
108         owner = msg.sender;
109     }
110 
111     modifier onlyOwner {
112         require(msg.sender == owner);
113         _;
114     }
115 
116     function transferOwnerShip(address newOwer) public onlyOwner {
117         owner = newOwer;
118     }
119 
120 }
121 
122 contract AdvanceToken is ERC20, owned{
123 
124     mapping (address => bool) public frozenAccount;
125 
126     event FrozenFunds(address target, bool frozen);
127 
128     constructor (string _name) ERC20(_name) public {
129 
130     }
131 
132 
133     function freezeAccount(address target, bool freeze) public onlyOwner {
134         frozenAccount[target] = freeze;
135         emit FrozenFunds(target, freeze);
136     }
137 
138 
139   function transfer(address _to, uint256 _value) public returns (bool success) {
140         success = _transfer(msg.sender, _to, _value);
141   }
142 
143 
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(allowed[_from][msg.sender] >= _value);
146         success =  _transfer(_from, _to, _value);
147         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
148   }
149 
150   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
151       require(_to != address(0));
152       require(!frozenAccount[_from]);
153 
154       require(balanceOf[_from] >= _value);
155       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
156 
157       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
158       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
159 
160       emit Transfer(_from, _to, _value);
161       return true;
162   }
163 }