1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72  
73     contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
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
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender)
122     public view returns (uint256);
123 
124   function transferFrom(address from, address to, uint256 value)
125     public returns (bool);
126 
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(
129     address indexed owner,
130     address indexed spender,
131     uint256 value
132   );
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     public
159     returns (bool)
160   {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address _owner,
196     address _spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 contract Mundocoin is StandardToken {
258   string public name = "Mundocoin"; 
259   string public symbol = "MDC";
260   uint public decimals = 4;
261   uint public INITIAL_SUPPLY = 25000000000000;
262 
263 
264 constructor() public {
265   totalSupply_ = INITIAL_SUPPLY;
266   balances[msg.sender] = INITIAL_SUPPLY;
267 }
268 }