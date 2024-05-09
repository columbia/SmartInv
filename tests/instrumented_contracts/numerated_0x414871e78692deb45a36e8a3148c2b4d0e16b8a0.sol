1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 } 
32 
33 
34 /**
35 * @title ERC20 interface
36 */
37 contract ERC20 {
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   
42   function allowance(address owner, address spender)
43     public view returns (uint256);
44 
45   function approve(address spender, uint256 value) public returns (bool);
46   
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(
49     address indexed owner,
50     address indexed spender,
51     uint256 value
52   );
53 }
54 
55 
56 contract OJGTokenBasic is ERC20 {
57     
58   using SafeMath for uint256;
59 
60   mapping (address => mapping (address => uint256)) internal allowed;    
61   mapping(address => uint256) balances;
62 
63   uint256 totalSupply_;
64   
65   function totalSupply() public view returns (uint256) {
66     return totalSupply_;
67   }
68 
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[msg.sender]);
72 
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     emit Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   function balanceOf(address _owner) public view returns (uint256) {
80     return balances[_owner];
81   }         
82  
83   function approve(address _spender, uint256 _value) public returns (bool) {
84     allowed[msg.sender][_spender] = _value;
85     emit Approval(msg.sender, _spender, _value);
86     return true;
87   }
88 
89   
90   function allowance(
91     address _owner,
92     address _spender
93    )
94     public
95     view
96     returns (uint256)
97   {
98     return allowed[_owner][_spender];
99   }
100 
101   function increaseApproval(
102     address _spender,
103     uint256 _addedValue
104   )
105     public
106     returns (bool)
107   {
108     allowed[msg.sender][_spender] = (
109       allowed[msg.sender][_spender].add(_addedValue));
110     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 
114   function decreaseApproval(
115     address _spender,
116     uint256 _subtractedValue
117   )
118     public
119     returns (bool)
120   {
121     uint256 oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131 }
132 
133 /**
134  * @title OJG
135  * @dev OJTGOLD
136  */
137 contract OJG is OJGTokenBasic {
138 
139   string public constant name = "OJTGOLD";	
140   string public constant symbol = "OJG";		    
141   uint8 public constant decimals = 18;
142   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
143 
144   constructor() public {
145     totalSupply_ = INITIAL_SUPPLY;
146     balances[msg.sender] = INITIAL_SUPPLY;
147     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
148   }
149 
150 }