1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  */
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 
61 /**
62  * @title ERC20 interface
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract EOJBasic is ERC20 {
72 
73   using SafeMath for uint256;
74 
75   mapping (address => mapping (address => uint256)) internal allowed;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   function balanceOf(address _owner) public view returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99 
100   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[_from]);
103     require(_value <= allowed[_from][msg.sender]);
104 
105     balances[_from] = balances[_from].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108     Transfer(_from, _to, _value);
109     return true;
110   }
111 
112   function approve(address _spender, uint256 _value) public returns (bool) {
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   function allowance(address _owner, address _spender) public view returns (uint256) {
119     return allowed[_owner][_spender];
120   }
121 
122   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
123     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
129     uint oldValue = allowed[msg.sender][_spender];
130     if (_subtractedValue > oldValue) {
131       allowed[msg.sender][_spender] = 0;
132     } else {
133       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134     }
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139 }
140 
141 contract EOJ is EOJBasic {
142     string public name = 'End Of JUlie';
143     string public symbol = 'EOJ';
144     uint8 public decimals = 8;
145     uint public INITIAL_SUPPLY =  50000000 * 10**uint(decimals);
146 
147     function EOJ() public {
148         totalSupply_ = INITIAL_SUPPLY;
149         balances[msg.sender] = INITIAL_SUPPLY;
150     }
151 }