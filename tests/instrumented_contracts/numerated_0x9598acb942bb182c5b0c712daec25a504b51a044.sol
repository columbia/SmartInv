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
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a / b;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 } 
30 
31 
32 /**
33 * @title ERC20 interface
34 */
35 contract ERC20 {
36   function totalSupply() public view returns (uint256);
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   function allowance(address owner, address spender)
41     public view returns (uint256);
42   
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 
48 contract TokenBasic is ERC20 {
49     
50   using SafeMath for uint256;
51   uint256 totalSupply_;    
52 
53   mapping (address => mapping (address => uint256)) internal allowed;    
54   mapping(address => uint256) balances;
55 
56   function totalSupply() public view returns (uint256) {
57     return totalSupply_;
58   }
59 
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     emit Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   function balanceOf(address _owner) public view returns (uint256) {
71     return balances[_owner];
72   }         
73  
74   function approve(address _spender, uint256 _value) public returns (bool) {
75     allowed[msg.sender][_spender] = _value;
76     emit Approval(msg.sender, _spender, _value);
77     return true;
78   }
79 
80   
81   function allowance(
82     address _owner,
83     address _spender
84    )
85     public
86     view
87     returns (uint256)
88   {
89     return allowed[_owner][_spender];
90   }
91 
92   function increaseApproval(
93     address _spender,
94     uint256 _addedValue
95   )
96     public
97     returns (bool)
98   {
99     allowed[msg.sender][_spender] = (
100       allowed[msg.sender][_spender].add(_addedValue));
101     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105   function decreaseApproval(
106     address _spender,
107     uint256 _subtractedValue
108   )
109     public
110     returns (bool)
111   {
112     uint256 oldValue = allowed[msg.sender][_spender];
113     if (_subtractedValue > oldValue) {
114       allowed[msg.sender][_spender] = 0;
115     } else {
116       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117     }
118     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119     return true;
120   }
121 
122 }
123 
124 /**
125  * @title KKAK-G COIN
126  */
127 contract KAKG is TokenBasic {
128 
129   string public constant name = "KKAK-G";	
130   string public constant symbol = "KAKG";		    
131   uint8 public constant decimals = 18;
132   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
133 
134   constructor() public {
135     totalSupply_ = INITIAL_SUPPLY;
136     balances[msg.sender] = INITIAL_SUPPLY;
137     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
138   }
139 
140 }