1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) { return 0;}
6     uint256 c = a * b;
7     assert(c / a == b);
8     return c;
9   }
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract ERC20Basic {
26   function totalSupply() public view returns (uint256);
27   function balanceOf(address who) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34   mapping(address => uint256) balances;
35   uint256 totalSupply_;
36   function totalSupply() public view returns (uint256) {
37     return totalSupply_;
38   }
39   function transfer(address _to, uint256 _value) public returns (bool) {
40     require(_to != address(0));
41     require(_value <= balances[msg.sender]);
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     emit Transfer(msg.sender, _to, _value);
45     return true;
46   }
47   function balanceOf(address _owner) public view returns (uint256 balance) {
48     return balances[_owner];
49   }
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20, BasicToken {
60   mapping (address => mapping (address => uint256)) internal allowed;
61   event Burn(address indexed burner, uint256 value);
62   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[_from]);
65     require(_value <= allowed[_from][msg.sender]);
66     balances[_from] = balances[_from].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
69     emit Transfer(_from, _to, _value);
70     return true;
71   }
72   function approve(address _spender, uint256 _value) public returns (bool) {
73     require((_value == 0)||(allowed[msg.sender][_spender] == 0));
74     allowed[msg.sender][_spender] = _value;
75     emit Approval(msg.sender, _spender, _value);
76     return true;
77   }
78   function allowance(address _owner, address _spender) public view returns (uint256) {
79     return allowed[_owner][_spender];
80   }
81   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
82     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
83     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
84     return true;
85   }
86   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
87     uint oldValue = allowed[msg.sender][_spender];
88     if (_subtractedValue > oldValue) {
89       allowed[msg.sender][_spender] = 0;
90     } else {
91       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
92     }
93     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96   function burn(uint256 _value) public {
97     _burn(msg.sender, _value);
98   }
99   function _burn(address _who, uint256 _value) internal {
100     require(_value <= balances[_who]);
101     balances[_who] = balances[_who].sub(_value);
102     totalSupply_ = totalSupply_.sub(_value);
103     emit Burn(_who, _value);
104     emit Transfer(_who, address(0), _value);
105   }
106 }
107 
108 contract BlockcloudToken is StandardToken {
109   string public name    = "Blockcloud Token";
110   string public symbol  = "BLOC";
111   uint8 public decimals = 18;
112   uint256 public constant INITIAL_SUPPLY = 10000000000;
113  constructor() public {
114     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
115     balances[msg.sender] = totalSupply_;
116   }
117 }