1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     allowed[msg.sender][_spender] = _value;
122     emit Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   function allowance(address _owner, address _spender) public view returns (uint256) {
127     return allowed[_owner][_spender];
128   }
129 
130   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
137     uint oldValue = allowed[msg.sender][_spender];
138     if (_subtractedValue > oldValue) {
139       allowed[msg.sender][_spender] = 0;
140     } else {
141       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142     }
143     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144     return true;
145   }
146 
147 }
148 
149 contract CoinExchange is StandardToken {
150 
151   string public constant name = "CoinExchange"; // solium-disable-line uppercase
152   string public constant symbol = "CEX"; // solium-disable-line uppercase
153   uint8 public constant decimals = 18; // solium-disable-line uppercase
154 
155   function CoinExchange() public {
156     totalSupply_ = 150000000 * (10 ** uint256(decimals));
157     balances[msg.sender] = totalSupply_;
158     emit Transfer(0x0, msg.sender, totalSupply_);
159   }
160 }