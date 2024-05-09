1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     return a / b;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 } 
33 
34 
35 /**
36 * @title ERC20 interface
37 * @dev see https://github.com/ethereum/EIPs/issues/20
38 */
39 contract ERC20 {
40   function totalSupply() public view returns (uint256);
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   
44   function allowance(address owner, address spender)
45     public view returns (uint256);
46 
47   function approve(address spender, uint256 value) public returns (bool);
48   
49   event Transfer(address indexed from, address indexed to, uint256 value);
50   event Approval(
51     address indexed owner,
52     address indexed spender,
53     uint256 value
54   );
55 }
56 
57 
58 contract TokenBasic is ERC20 {
59     
60   using SafeMath for uint256;
61 
62   mapping (address => mapping (address => uint256)) internal allowed;    
63   mapping(address => uint256) balances;
64 
65   uint256 totalSupply_;
66   
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256) {
82     return balances[_owner];
83   }         
84  
85   function approve(address _spender, uint256 _value) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     emit Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   
92   function allowance(
93     address _owner,
94     address _spender
95    )
96     public
97     view
98     returns (uint256)
99   {
100     return allowed[_owner][_spender];
101   }
102 
103   function increaseApproval(
104     address _spender,
105     uint256 _addedValue
106   )
107     public
108     returns (bool)
109   {
110     allowed[msg.sender][_spender] = (
111       allowed[msg.sender][_spender].add(_addedValue));
112     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116   function decreaseApproval(
117     address _spender,
118     uint256 _subtractedValue
119   )
120     public
121     returns (bool)
122   {
123     uint256 oldValue = allowed[msg.sender][_spender];
124     if (_subtractedValue > oldValue) {
125       allowed[msg.sender][_spender] = 0;
126     } else {
127       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
128     }
129     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130     return true;
131   }
132 
133 }
134 
135 /**
136  * @title IEXCO
137  * @dev International Exchange Coin
138  */
139 contract IEXCO is TokenBasic {
140 
141   string public constant name = "International Exchange Coin";	
142   string public constant symbol = "IEXCO";		    
143   uint8 public constant decimals = 18;
144   uint256 public constant INITIAL_SUPPLY = 30000000000 * (10 ** uint256(decimals));
145 
146   constructor() public {
147     totalSupply_ = INITIAL_SUPPLY;
148     balances[msg.sender] = INITIAL_SUPPLY;
149     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
150   }
151 
152 }