1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   uint256 totalSupply_;
50 
51   function totalSupply() public view returns (uint256) {
52     return totalSupply_;
53   }
54 
55   function transfer(address _to, uint256 _value) public returns (bool) {
56     require(_to != address(0));
57     require(_value <= balances[msg.sender]);
58 
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     emit Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65   function balanceOf(address _owner) public view returns (uint256) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74 
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79 
80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     emit Transfer(_from, _to, _value);
84     return true;
85   }
86 
87 
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     allowed[msg.sender][_spender] = _value;
90     emit Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function allowance(address _owner, address _spender) public view returns (uint256) {
95     return allowed[_owner][_spender];
96   }
97 
98   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115 }
116 
117 contract Token is StandardToken{
118 	
119 	string public constant name = "Wobitter Exchange Token"; 
120 	string public constant symbol = "WO"; 
121 	uint8 public constant decimals = 18; 
122 
123 	uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
124 	
125 	constructor() public {
126 		totalSupply_ = INITIAL_SUPPLY;
127 		balances[msg.sender] = INITIAL_SUPPLY;
128 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
129 	}
130 }