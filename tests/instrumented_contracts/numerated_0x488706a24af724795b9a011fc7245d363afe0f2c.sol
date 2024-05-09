1 pragma solidity ^0.5.6;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Adds two numbers, throws on overflow.
12   */
13   function add(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a + b;
15     require(c >= a);
16     return c;
17   }
18 
19   /**
20   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
21   */
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b <= a);
24     return a - b;
25   }
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     require(a == 0 || c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b > 0);
44     uint256 c = a / b;
45     require(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49 }
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 _totalSupply;
87 
88   /**
89    * @dev Fix for the ERC20 short address attack.
90    */
91   modifier onlyPayloadSize(uint size) {
92     if(msg.data.length < size + 4) {
93       revert();
94     }
95     _;
96   }
97 
98   /**
99   * @dev total number of tokens in existence
100   */
101   function totalSupply() public view returns (uint256) {
102     return _totalSupply;
103   }
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     emit Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public view returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     emit Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
167     require(_spender != address(0));
168     // require(_value <= balances[msg.sender]);
169     allowed[msg.sender][_spender] = _value;
170     emit Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public onlyPayloadSize(2 * 32) returns (bool) {
195     require(_spender != address(0));
196     // require(allowed[msg.sender][_spender].add(_addedValue) <= balances[msg.sender]);
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   /**
203    * @dev Decrease the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To decrement
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _subtractedValue The amount of tokens to decrease the allowance by.
211    */
212   function decreaseApproval(address _spender, uint _subtractedValue) public onlyPayloadSize(2 * 32) returns (bool) {
213     require(_spender != address(0));
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 
227 /**
228  * @title SimpleToken
229  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
230  * Note they can later distribute these tokens as they wish using `transfer` and other
231  * `StandardToken` functions.
232  */
233 contract QuickChainToken is StandardToken {
234 
235     string public constant name = "QuickChain Token";
236     string public constant symbol = "QCT";
237     uint8 public constant decimals = 8;
238 
239     uint256 public constant INITIAL_SUPPLY = 21 * (10 ** 8) * (10 ** uint256(decimals));
240 
241     /**
242     * @dev Constructor that gives msg.sender all of existing tokens.
243     */
244     constructor() public {
245         _totalSupply = INITIAL_SUPPLY;
246         balances[msg.sender] = INITIAL_SUPPLY;
247         emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
248     }
249 
250 }