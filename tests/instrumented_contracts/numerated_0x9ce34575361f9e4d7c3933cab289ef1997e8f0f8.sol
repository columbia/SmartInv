1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6       if (_a == 0) {
7           return 0;
8         }
9       uint256 c = _a * _b;
10       assert(c / _a == _b);
11       return c;
12   }
13 
14   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15       require(_b > 0);
16       uint256 c = _a / _b;
17       return c;
18   }
19 
20   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
21       assert(_b <= _a);
22       uint256 c = _a - _b;
23       return c;
24   }
25 
26   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
27       uint256 c = _a + _b;
28       assert(c >= _a);
29       return c;
30   }
31 }
32 
33 contract ERC20 {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address _who) public view returns (uint256);
36   function allowance(address _owner, address _spender) public view returns (uint256);
37   function transfer(address _to, uint256 _value) public returns (bool);
38   function approve(address _spender, uint256 _value) public returns (bool);
39   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract StandardToken is ERC20 {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48   mapping (address => mapping (address => uint256)) internal allowed;
49   uint256 totalSupply_;
50 
51   function totalSupply() public view returns (uint256) {
52     return totalSupply_;
53   }
54 
55   function balanceOf(address _owner) public view returns (uint256) {
56     return balances[_owner];
57   }
58 
59   function allowance(address _owner, address _spender) public view returns (uint256) {
60     return allowed[_owner][_spender];
61   }
62 
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_value <= balances[msg.sender]);
65     require(_to != address(0));
66 
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     emit Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   function approve(address _spender, uint256 _value) public returns (bool) {
74     allowed[msg.sender][_spender] = _value;
75     emit Approval(msg.sender, _spender, _value);
76     return true;
77   }
78 
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81 
82     balances[_from] = balances[_from].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
85     emit Transfer(_from, _to, _value);
86     return true;
87   }
88 }
89 
90 contract JDLEOToken2 is StandardToken{
91     using SafeMath for uint256;
92     
93     string public name="JDLEOToken2";
94     string public symbol="JDLEO2";
95     uint256 public decimals=18;
96     address owner;
97     
98     event Burn(uint256 amount);
99 
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     constructor(uint256 initialSupply) public {
106         totalSupply_ = initialSupply * (10 ** decimals);
107         balances[msg.sender]=totalSupply_;
108         owner=msg.sender;
109     }
110     
111     function burn(uint256 _amount) onlyOwner public returns (bool) {
112         require(0 < _amount && _amount <= balances[msg.sender]);
113         balances[msg.sender] = balances[msg.sender].sub(_amount);
114         totalSupply_ = totalSupply_.sub(_amount);
115         emit Burn(_amount);
116         return true;
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         _transferOwnership(newOwner);
121     }
122     
123     function _transferOwnership(address newOwner) internal {
124         owner = newOwner;
125     }
126 }