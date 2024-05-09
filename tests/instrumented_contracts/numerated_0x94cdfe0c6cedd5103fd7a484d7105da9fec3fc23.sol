1 pragma solidity 0.4.25;
2 
3 // ERC20 interface
4 interface IERC20 {
5   function balanceOf(address _owner) external view returns (uint256);
6   function allowance(address _owner, address _spender) external view returns (uint256);
7   function transfer(address _to, uint256 _value) external returns (bool);
8   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
9   function approve(address _spender, uint256 _value) external returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 contract BCoin is IERC20 {
45   using SafeMath for uint256;
46   string public name = "BCoin Coin";
47   string public symbol = "BCN";
48   uint8 public constant decimals = 18;
49   uint256 public constant decimalFactor = 1000000000000000000;
50   uint256 public constant totalSupply = 300000000 * decimalFactor;
51   mapping (address => uint256) balances;
52   mapping (address => mapping (address => uint256)) internal allowed;
53 
54   event Transfer(address indexed from, address indexed to, uint256 value);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 
57   constructor() public {
58     balances[msg.sender] = totalSupply;
59     emit Transfer(address(0), msg.sender, totalSupply);
60   }
61 
62   function balanceOf(address _owner) public view returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66   function allowance(address _owner, address _spender) public view returns (uint256) {
67     return allowed[_owner][_spender];
68   }
69 
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[_from]);
84     require(_value <= allowed[_from][msg.sender]);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89     emit Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   function approve(address _spender, uint256 _value) public returns (bool) {
94     allowed[msg.sender][_spender] = _value;
95     emit Approval(msg.sender, _spender, _value);
96     return true;
97   }
98 
99   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
106     uint oldValue = allowed[msg.sender][_spender];
107     if (_subtractedValue > oldValue) {
108       allowed[msg.sender][_spender] = 0;
109     } else {
110       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111     }
112     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116 }