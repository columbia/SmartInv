1 pragma solidity ^0.4.16;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) constant returns (uint256);
54   function transfer(address to, uint256 value) returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
99 
100   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
101     
102     require(_to != address(0));
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_to] = balances[_to].add(_value);
107     balances[_from] = balances[_from].sub(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109 
110     Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifing the amount of tokens still avaible for the spender.
130    */
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135 }
136 
137 contract BurnableToken is BasicToken {
138 
139   event Burn(address indexed burner, uint256 value);
140 
141   /**
142    * @dev Burns a specific amount of tokens.
143    * @param _value The amount of token to be burned.
144    */
145   function burn(uint256 _value) public {
146     require(_value <= balances[msg.sender]);
147     // no need to require value <= totalSupply, since that would imply the
148     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
149 
150     address burner = msg.sender;
151     balances[burner] = balances[burner].sub(_value);
152     totalSupply = totalSupply.sub(_value);
153     Burn(burner, _value);
154     Transfer(burner, address(0), _value);
155   }
156 }
157 
158 contract IntroToken is StandardToken {
159 
160   string public name = "INTRO Token";
161   string public symbol = "ITR";
162   uint8 public decimals = 18;
163   
164   // Выпускаем 200 000 000 монет
165   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
166   
167   function IntroToken() {
168     totalSupply = INITIAL_SUPPLY;
169     balances[msg.sender] = INITIAL_SUPPLY;
170   }
171 
172 }