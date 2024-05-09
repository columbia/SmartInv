1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b);
12 
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0);
18         uint256 c = a / b;
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
41 }
42 
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   uint256 totalSupply_;
56 
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     emit Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   function balanceOf(address _owner) public view returns (uint256) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public view returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) internal allowed;
87 
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     emit Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function approve(address _spender, uint256 _value) public returns (bool) {
101     allowed[msg.sender][_spender] = _value;
102     emit Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function allowance(address _owner, address _spender) public view returns (uint256) {
107     return allowed[_owner][_spender];
108   }
109 
110   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
111     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
112     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
117     uint oldValue = allowed[msg.sender][_spender];
118     if (_subtractedValue > oldValue) {
119       allowed[msg.sender][_spender] = 0;
120     } else {
121       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122     }
123     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126 
127 }
128 
129 contract WOTChain is StandardToken {
130 
131     string public name;
132     string public symbol;
133     uint8 public decimals = 18;
134 
135   constructor(
136     uint256 initialSupply,
137     string memory tokenName,
138     string memory tokenSymbol
139   ) public {
140     totalSupply_ = initialSupply * (10 ** uint256(decimals));
141     balances[msg.sender] = totalSupply_;
142     name = tokenName;
143     symbol = tokenSymbol;
144     emit Transfer(0x0, msg.sender, totalSupply_);
145   }
146 }