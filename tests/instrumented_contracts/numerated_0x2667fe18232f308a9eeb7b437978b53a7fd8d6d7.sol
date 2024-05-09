1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20 {
5   function totalSupply() public view returns (uint256);
6 
7   function balanceOf(address _who) public view returns (uint256);
8 
9   function allowance(address _owner, address _spender)  public view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) public returns (bool);
12 
13   function approve(address _spender, uint256 _value)  public returns (bool);
14 
15   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
16 
17   event Transfer(
18     address indexed from,
19     address indexed to,
20     uint256 value
21   );
22 
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28 }
29 
30 library SafeMath {
31 
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     if (_a == 0) {
34       return 0;
35     }
36 
37     c = _a * _b;
38     assert(c / _a == _b);
39     return c;
40   }
41 
42   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     return _a / _b;
44   }
45 
46   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     assert(_b <= _a);
48     return _a - _b;
49   }
50 
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
52     c = _a + _b;
53     assert(c >= _a);
54     return c;
55   }
56 }
57 
58 contract StandardToken is  ERC20 {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   mapping (address => mapping (address => uint256)) internal allowed;
64 
65   uint256 totalSupply_; 
66   
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   function balanceOf(address _owner) public view returns (uint256) {
72     return balances[_owner];
73   }
74 
75   function allowance(address _owner,address _spender) public view returns (uint256) {
76     return allowed[_owner][_spender];
77   }
78 
79   function approve(address _spender, uint256 _value) public returns (bool) {
80     allowed[msg.sender][_spender] = _value;
81     emit Approval(msg.sender, _spender, _value);
82     return true;
83   }
84    
85    
86     
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_value <= balances[msg.sender]);
89     require(_to != address(0));
90     
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     emit Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function transferFrom(address _from,address _to, uint256 _value) public returns (bool)  {
98     require(_value <= balances[_from]);
99     require(_value <= allowed[_from][msg.sender]);
100     require(_to != address(0));
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     emit Transfer(_from, _to, _value);
106     return true;
107   }
108 
109   function increaseApproval(address _spender, uint256 _addedValue ) public returns (bool) {
110       allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115  
116   function decreaseApproval(address _spender, uint256 _subtractedValue) public  returns (bool)  {
117     uint256 oldValue = allowed[msg.sender][_spender];
118     if (_subtractedValue >= oldValue) {
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
129 
130 contract EGCTToken is StandardToken {
131 
132   string public constant name = "Excellent game coin token";
133   string public constant symbol = "EGCT";
134   uint8 public constant decimals = 4;
135 
136   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
137 
138   constructor() public {
139     totalSupply_ = INITIAL_SUPPLY;
140     balances[msg.sender] = INITIAL_SUPPLY;
141     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
142   }
143 
144 }