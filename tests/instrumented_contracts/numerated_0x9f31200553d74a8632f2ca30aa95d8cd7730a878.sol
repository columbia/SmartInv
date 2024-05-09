1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-02
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // ERC20 interface
8 interface IERC20 {
9   function balanceOf(address _owner) external view returns (uint256);
10   function allowance(address _owner, address _spender) external view returns (uint256);
11   function transfer(address _to, uint256 _value) external returns (bool);
12   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
13   function approve(address _spender, uint256 _value) external returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 contract RYM is IERC20 {
49   using SafeMath for uint256;
50   address private deployer;
51   address private multisend = 0x7c7a2EC168FE7929726fE90B65b4AddC5467c653;
52   string public name = "RYM";
53   string public symbol = "RYM";
54   uint8 public constant decimals = 6;
55   uint256 public constant decimalFactor = 10 ** uint256(decimals);
56   uint256 public constant totalSupply = 3015397 * decimalFactor;
57   mapping (address => uint256) balances;
58   mapping (address => mapping (address => uint256)) internal allowed;
59 
60   event Transfer(address indexed from, address indexed to, uint256 value);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63   constructor() public {
64     balances[msg.sender] = totalSupply;
65     deployer = msg.sender;
66     emit Transfer(address(0), msg.sender, totalSupply);
67   }
68 
69   function balanceOf(address _owner) public view returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73   function allowance(address _owner, address _spender) public view returns (uint256) {
74     return allowed[_owner][_spender];
75   }
76 
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80     require(block.timestamp >= 1537164000 || msg.sender == deployer || msg.sender == multisend);
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     emit Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93     require(block.timestamp >= 1537164000);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     emit Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     emit Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
109     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
110     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 
114   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
115     uint oldValue = allowed[msg.sender][_spender];
116     if (_subtractedValue > oldValue) {
117       allowed[msg.sender][_spender] = 0;
118     } else {
119       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120     }
121     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125 }