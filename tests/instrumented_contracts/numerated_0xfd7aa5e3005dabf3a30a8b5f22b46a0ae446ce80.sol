1 pragma solidity ^0.4.13;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57   mapping(address => uint256) balances;
58   uint256 totalSupply_;
59 
60   /**
61   * @dev total number of tokens in existence
62   */
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256) {
88     return balances[_owner];
89   }
90 }
91 
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 contract StandardToken is ERC20, BasicToken {
100   mapping (address => mapping (address => uint256)) internal allowed;
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111     balances[_from] = balances[_from].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114     emit Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    *
121    * Beware that changing an allowance with this method brings the risk that someone may use both the old
122    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
123    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
124    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) public returns (bool) {
129     allowed[msg.sender][_spender] = _value;
130     emit Approval(msg.sender, _spender, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(address _owner, address _spender) public view returns (uint256) {
141     return allowed[_owner][_spender];
142   }
143 
144   /**
145    * @dev Increase the amount of tokens that an owner allowed to a spender.
146    *
147    * approve should be called when allowed[_spender] == 0. To increment
148    * allowed value is better to use this function to avoid 2 calls (and wait until
149    * the first transaction is mined)
150    * From MonolithDAO Token.sol
151    * @param _spender The address which will spend the funds.
152    * @param _addedValue The amount of tokens to increase the allowance by.
153    */
154   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   /**
161    * @dev Decrease the amount of tokens that an owner allowed to a spender.
162    *
163    * approve should be called when allowed[_spender] == 0. To decrement
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    * @param _spender The address which will spend the funds.
168    * @param _subtractedValue The amount of tokens to decrease the allowance by.
169    */
170   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
171     uint oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 }
181 
182 contract UinfoToken is StandardToken {
183     using SafeMath for uint256;
184     uint8 public constant decimals = 18;
185     uint  public constant INITIAL_SUPPLY = 10 ** (9 + uint(decimals));
186     string public constant name = "Ur Infomation,Useful Infomation";
187     string public constant symbol = "UINFO";
188     function UinfoToken () public {
189         totalSupply_ = INITIAL_SUPPLY;
190         balances[msg.sender] = INITIAL_SUPPLY;
191     }
192 }