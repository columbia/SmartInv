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
36 * @dev see https://github.com/ethereum/EIPs/issues/20
37 */
38 contract ERC20 {
39   function totalSupply() public view returns (uint256);
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   
43   function allowance(address owner, address spender)
44     public view returns (uint256);
45 
46   function approve(address spender, uint256 value) public returns (bool);
47   
48   event Transfer(address indexed from, address indexed to, uint256 value);
49   event Approval(
50     address indexed owner,
51     address indexed spender,
52     uint256 value
53   );
54 }
55 
56 
57 contract TokenBasic is ERC20 {
58     
59   using SafeMath for uint256;
60 
61   mapping (address => mapping (address => uint256)) internal allowed;    
62   mapping(address => uint256) balances;
63 
64   uint256 totalSupply_;
65   
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   function balanceOf(address _owner) public view returns (uint256) {
81     return balances[_owner];
82   }         
83  
84   function approve(address _spender, uint256 _value) public returns (bool) {
85     allowed[msg.sender][_spender] = _value;
86     emit Approval(msg.sender, _spender, _value);
87     return true;
88   }
89 
90   
91   function allowance(
92     address _owner,
93     address _spender
94    )
95     public
96     view
97     returns (uint256)
98   {
99     return allowed[_owner][_spender];
100   }
101 
102   function increaseApproval(
103     address _spender,
104     uint256 _addedValue
105   )
106     public
107     returns (bool)
108   {
109     allowed[msg.sender][_spender] = (
110       allowed[msg.sender][_spender].add(_addedValue));
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115   function decreaseApproval(
116     address _spender,
117     uint256 _subtractedValue
118   )
119     public
120     returns (bool)
121   {
122     uint256 oldValue = allowed[msg.sender][_spender];
123     if (_subtractedValue > oldValue) {
124       allowed[msg.sender][_spender] = 0;
125     } else {
126       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
127     }
128     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129     return true;
130   }
131 
132 }
133 
134 /**
135  * @title BTBIT
136  * @dev BTBIT Coin
137  */
138 contract BTBIT is TokenBasic {
139 
140   string public constant name = "BTBIT Coin";	
141   string public constant symbol = "BTBIT";		    
142   uint8 public constant decimals = 18;
143   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
144 
145   constructor() public {
146     totalSupply_ = INITIAL_SUPPLY;
147     balances[msg.sender] = INITIAL_SUPPLY;
148     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
149   }
150 
151 }