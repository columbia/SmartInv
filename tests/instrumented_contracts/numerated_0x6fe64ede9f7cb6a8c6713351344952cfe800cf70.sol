1 pragma solidity ^0.4. 21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  *  ERC20 interface
37  * Illuminati Xtra funds github
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * transfer function to enable token transfer for a specified address
57   * gets address _to The address to transfer to.
58   * gets value _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 /**
79  * @title ERC20 interface
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) constant returns (uint256);
83   function transferFrom(address from, address to, uint256 value) returns (bool);
84   function approve(address spender, uint256 value) returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev Illuminati Xtra Funds github
93  */
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) allowed;
97 
98 
99   /**
100    * @dev Transfer tokens from one address to another
101    * @param _from address The address which you want to send tokens from
102    * @param _to address The address which you want to transfer to
103    * @param _value uint256 the amout of tokens to be transfered
104    */
105   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
106     var _allowance = allowed[_from][msg.sender];
107 
108     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109     // require (_value <= _allowance);
110 
111     balances[_to] = balances[_to].add(_value);
112     balances[_from] = balances[_from].sub(_value);
113     allowed[_from][msg.sender] = _allowance.sub(_value);
114     Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) returns (bool) {
124 
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
130 
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifing the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
143     return allowed[_owner][_spender];
144   }
145 
146 }
147 
148 
149 /**
150  * @title SimpleToken
151  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
152  * Note they can later distribute these tokens as they wish using `transfer` and other
153  * `StandardToken` functions.
154  */
155 contract IlumXToken is StandardToken {
156 
157   string public constant name = "Illuminati X";
158   string public constant symbol = "IlumX";
159   address public creator = msg.sender;
160   uint256 public constant decimals = 18;
161   
162 
163   uint256 public constant INITIAL_SUPPLY = 940000000 * 10**18;
164 
165   /**
166    * @dev Contructor that gives msg.sender all of existing tokens.
167    */
168   
169   function IlumXToken() {
170     require(msg.sender == creator);
171  	totalSupply = INITIAL_SUPPLY;
172     balances[msg.sender] = INITIAL_SUPPLY;
173     
174   }
175 
176 
177     
178 }