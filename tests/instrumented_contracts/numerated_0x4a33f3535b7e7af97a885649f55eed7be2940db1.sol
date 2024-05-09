1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address _who) public view returns (uint256);
7   function transfer(address _to, uint256 _value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (_a == 0) {
21       return 0;
22     }
23 
24     c = _a * _b;
25     assert(c / _a == _b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
33     // assert(_b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = _a / _b;
35     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
36     return _a / _b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     assert(_b <= _a);
44     return _a - _b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
51     c = _a + _b;
52     assert(c >= _a);
53     return c;
54   }
55 }
56 
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address _owner, address _spender)
60     public view returns (uint256);
61 
62   function transferFrom(address _from, address _to, uint256 _value)
63     public returns (bool);
64 
65   function approve(address _spender, uint256 _value) public returns (bool);
66   event Approval(
67     address indexed owner,
68     address indexed spender,
69     uint256 value
70   );
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) internal balances;
77 
78   uint256 internal totalSupply_;
79 
80   /**
81   * @dev Total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev Transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_value <= balances[msg.sender]);
94     require(_to != address(0));
95 
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     emit Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(
126     address _from,
127     address _to,
128     uint256 _value
129   )
130     public
131     returns (bool)
132   {
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135     require(_to != address(0));
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     emit Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(
166     address _owner,
167     address _spender
168    )
169     public
170     view
171     returns (uint256)
172   {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(
186     address _spender,
187     uint256 _addedValue
188   )
189     public
190     returns (bool)
191   {
192     allowed[msg.sender][_spender] = (
193       allowed[msg.sender][_spender].add(_addedValue));
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(
208     address _spender,
209     uint256 _subtractedValue
210   )
211     public
212     returns (bool)
213   {
214     uint256 oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue >= oldValue) {
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
229  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
230  * Note they can later distribute these tokens as they wish using `transfer` and other
231  * `StandardToken` functions.
232  */
233 contract JerusaleumDollar is StandardToken {
234 
235   string public constant name = "Jerusaleum Dollar"; // solium-disable-line uppercase
236   string public constant symbol = "JLMD"; // solium-disable-line uppercase
237   uint8 public constant decimals = 18; // solium-disable-line uppercase
238 
239   uint256 public constant INITIAL_SUPPLY = 100000000000e18;
240 
241   /**
242    * @dev Constructor that gives msg.sender all of existing tokens.
243    */
244   constructor() public {
245     totalSupply_ = INITIAL_SUPPLY;
246     balances[msg.sender] = INITIAL_SUPPLY;
247     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
248   }
249 
250 }