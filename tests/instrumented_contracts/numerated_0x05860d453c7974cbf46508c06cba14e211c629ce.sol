1 pragma solidity ^0.4.24;
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
44 contract EdenCoin is IERC20 {
45   using SafeMath for uint256;
46   address private deployer;
47   address private multisend = 0xB76a20D5d42c041593DF95D7d72b74B2543824f9;
48   string public name = "Eden Coin";
49   string public symbol = "EDN";
50   uint8 public constant decimals = 18;
51   uint256 public constant decimalFactor = 10 ** uint256(decimals);
52   uint256 public constant totalSupply = 1000000000 * decimalFactor;
53   mapping (address => uint256) balances;
54   mapping (address => mapping (address => uint256)) internal allowed;
55 
56   event Transfer(address indexed from, address indexed to, uint256 value);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59   constructor() public {
60     balances[msg.sender] = totalSupply;
61     deployer = msg.sender;
62     emit Transfer(address(0), msg.sender, totalSupply);
63   }
64 
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69   function allowance(address _owner, address _spender) public view returns (uint256) {
70     return allowed[_owner][_spender];
71   }
72 
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76     require(block.timestamp >= 1537164000 || msg.sender == deployer || msg.sender == multisend);
77 
78     // SafeMath.sub will throw if there is not enough balance.
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[_from]);
88     require(_value <= allowed[_from][msg.sender]);
89     require(block.timestamp >= 1537164000);
90 
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94     emit Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   function approve(address _spender, uint256 _value) public returns (bool) {
99     allowed[msg.sender][_spender] = _value;
100     emit Approval(msg.sender, _spender, _value);
101     return true;
102   }
103 
104   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121 }