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
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
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
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(
155     address _from,
156     address _to,
157     uint256 _value
158   )
159     public
160     returns (bool)
161   {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     emit Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address _owner,
197     address _spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(
240     address _spender,
241     uint _subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 
259 
260 contract FANXToken is StandardToken {
261     
262     string public name = "FANX Token";
263     string public symbol = "FANX";
264     uint8  public decimals = 18;
265     uint256 public INITIAL_SUPPLY = 1000000000 * 10 ** uint256(decimals);
266 
267     constructor() public {
268         totalSupply_ = INITIAL_SUPPLY;
269         balances[msg.sender] = INITIAL_SUPPLY;
270     }
271 }