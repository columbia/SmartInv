1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
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
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   uint256 totalSupply_;
43 
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     emit Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) public view returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     emit Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public view returns (uint256) {
93     return allowed[_owner][_spender];
94   }
95 
96   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99     return true;
100   }
101 
102   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
103     uint oldValue = allowed[msg.sender][_spender];
104     if (_subtractedValue > oldValue) {
105       allowed[msg.sender][_spender] = 0;
106     } else {
107       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108     }
109     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113 }
114 
115 contract LPCoinToken is StandardToken{
116   string public name    = "LPCoin";
117   string public symbol  = "LPCoin";
118   uint8 public decimals = 18;
119   uint256 public constant INITIAL_SUPPLY = 10000000000;
120   event Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);
121 
122   function LPCoinToken() public {
123     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
124     balances[msg.sender] = totalSupply_;
125   }
126 
127   function burn(uint256 _burntAmount) public returns (bool success) {
128     require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
129     balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
130     totalSupply_ = totalSupply_.sub(_burntAmount);
131     emit Transfer(address(this), 0x0, _burntAmount);
132     emit Burn(msg.sender, _burntAmount, block.timestamp);
133     return true;
134   }
135 }