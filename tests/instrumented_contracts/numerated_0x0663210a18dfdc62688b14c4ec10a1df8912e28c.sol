1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59     
60   mapping (address => uint256) balances;
61   uint256 totalSupply_;
62   
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66   
67     /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0x0));
75     require(_value <= balances[msg.sender]);
76 
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of. 
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97 }
98 
99 contract BurnableToken is BasicToken {
100 
101   event Burn(address indexed burner, uint256 value);
102 
103   /**
104    * @dev Burns a specific amount of tokens.
105    * @param _value The amount of token to be burned.
106    */
107   function burn(uint256 _value) public {
108     require(_value <= balances[msg.sender]);
109     // no need to require value <= totalSupply, since that would imply the
110     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
111 
112     address burner = msg.sender;
113     balances[burner] = balances[burner].sub(_value);
114     totalSupply_ = totalSupply_.sub(_value);
115     emit Burn(burner, _value);
116     emit Transfer(burner, address(0), _value);
117   }
118 }
119 
120 contract StandardToken is ERC20, BurnableToken {
121 
122   mapping (address => mapping (address => uint256)) allowed;
123 
124   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125     
126     require(_to != address(0x0));
127     require(_value <= balances[msg.sender]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_to] = balances[_to].add(_value);
131     balances[_from] = balances[_from].sub(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133 
134     emit Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifing the amount of tokens still avaible for the spender.
153    */
154   function allowance(address _owner, address _spender) public view returns (uint256) {
155     return allowed[_owner][_spender];
156   }
157 }
158 
159 contract ETLToken is StandardToken {
160 
161   string public name = "E-talon";
162   string public symbol = "ETALON";
163   uint8 public decimals = 8;
164   uint256 public INITIAL_SUPPLY = 10000000000000000;
165 
166   // Issue and send all tokens to owner
167   function ETLToken() public {
168     totalSupply_ = INITIAL_SUPPLY;
169     balances[msg.sender] = totalSupply_;
170   }
171   
172 }