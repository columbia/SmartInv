1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title Standard ERC20 token
47  *
48  * @dev Implementation of the basic standard token.
49  * @dev https://github.com/ethereum/EIPs/issues/20
50  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
51  */
52  
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70  
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     emit Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     emit Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * @dev Increase the amount of tokens that an owner allowed to a spender.
163    *
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    * @param _spender The address which will spend the funds.
169    * @param _addedValue The amount of tokens to increase the allowance by.
170    */
171   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
172     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   /**
178    * @dev Decrease the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To decrement
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _subtractedValue The amount of tokens to decrease the allowance by.
186    */
187   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
188     uint oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue > oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 
200 /**
201  * @title BnkTestToken
202  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
203  * Note they can later distribute these tokens as they wish using `transfer` and other
204  * `StandardToken` functions.
205  * 
206  */
207 contract TestTokenERC20 is StandardToken {
208 
209   string public constant name = "TestTokenERC20"; // solium-disable-line uppercase
210   string public constant symbol = "T20"; // solium-disable-line uppercase
211   uint8 public constant decimals = 18; // solium-disable-line uppercase
212   uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
213 
214   /**
215    * @dev Constructor that gives msg.sender all of existing tokens.
216    */
217   function TestTokenERC20() public {
218     totalSupply_ = INITIAL_SUPPLY;
219     balances[msg.sender] = INITIAL_SUPPLY;
220     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
221   }
222 
223 }