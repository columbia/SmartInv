1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
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
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 // Interfaces 
31 
32 contract ERC20 {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   function allowance(address owner, address spender) public view returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address spender, uint256 value) public returns (bool);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 // Implementation
44 
45 contract ERC20Token is ERC20 {
46 
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50   mapping (address => mapping (address => uint256)) internal allowed;
51 
52   uint256 totalSupply_;
53 
54   event Burn(address indexed burner, uint256 value);
55 
56   function totalSupply() public view returns (uint256) {
57     return totalSupply_;
58   }
59 
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     emit Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   function balanceOf(address _owner) public view returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[_from]);
76     require(_value <= allowed[_from][msg.sender]);
77 
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     emit Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   function approve(address _spender, uint256 _value) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     emit Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) public view returns (uint256) {
92     return allowed[_owner][_spender];
93   }
94 
95   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98     return true;
99   }
100 
101   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102     uint oldValue = allowed[msg.sender][_spender];
103     if (_subtractedValue > oldValue) {
104       allowed[msg.sender][_spender] = 0;
105     } else {
106       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107     }
108     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }  
111 
112   function burn(uint256 _value) public {
113     require(_value <= balances[msg.sender]);
114 
115     address burner = msg.sender;
116     balances[burner] = balances[burner].sub(_value);
117     totalSupply_ = totalSupply_.sub(_value);
118     emit Burn(burner, _value);
119     emit Transfer(burner, address(0), _value);
120   }  
121 
122 }
123 
124 contract BuToken is ERC20Token {
125   string public name;
126   string public symbol;
127   uint8 public decimals;
128 
129   function BuToken() public {
130     name = "BUY Payment Token";
131     symbol = "BUY";
132     decimals = 0;  
133     balances[msg.sender] = 10**9;
134     totalSupply_ = 10**9;
135   }
136 
137 }