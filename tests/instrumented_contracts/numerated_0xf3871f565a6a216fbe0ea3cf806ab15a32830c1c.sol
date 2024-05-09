1 pragma solidity ^0.4.21;
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
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     // uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return a / b;
20   }
21 
22   /**
23   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24   */
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   /**
31   * @dev Adds two numbers, throws on overflow.
32   */
33   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract ERC20Basic {
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58   uint8 public decimals = 5;
59 
60   uint256 public totalSupply_;
61 
62 
63   constructor() public {
64       totalSupply_ = 10000000000 * 10 ** uint256(decimals);
65       balances[msg.sender] = totalSupply_ ;
66   }
67 
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70   }
71 
72 
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83 
84   function balanceOf(address _owner) public view returns (uint256) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 contract NFSCToken is ERC20, BasicToken {
91 
92   string public name = "New Food safety Chain";
93   string public symbol = "NFSC";
94 
95 
96   mapping (address => mapping (address => uint256)) internal allowed;
97 
98   struct ReleaseRecord {
99       uint256 amount; // release amount
100       uint256 releasedTime; // release time
101   }
102 
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[_from]);
106     require(_value <= allowed[_from][msg.sender]);
107 
108     balances[_from] = balances[_from].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111     emit Transfer(_from, _to, _value);
112     return true;
113   }
114 
115 
116   function approve(address _spender, uint256 _value) public returns (bool) {
117     allowed[msg.sender][_spender] = _value;
118     emit Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122 
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124     return allowed[_owner][_spender];
125   }
126 
127 
128   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134 
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136     uint oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146 }