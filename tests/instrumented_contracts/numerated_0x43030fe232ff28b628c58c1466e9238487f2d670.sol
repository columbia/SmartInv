1 /************************************************************************************
2 This is the source code for the AXE token written in Solidity language.				*
3 This token is based on ERC20 specification 											*	
4 The Axe token is made for AXE FINANCIAL CORPORATION - MAURITIUS						*
5 Version 1.0																			*
6 									
7 Date: 22-AUG-2018																	*
8 ************************************************************************************/
9 pragma solidity ^0.4.24;
10 
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
23     // benefit is lost if 'b' is also tested.
24     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25     if (a == 0) {
26       return 0;
27     }
28 
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender)
126     public view returns (uint256);
127 
128   function transferFrom(address from, address to, uint256 value)
129     public returns (bool);
130 
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(
133     address indexed owner,
134     address indexed spender,
135     uint256 value
136   );
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 /**
261  * @title AXEToken A token contract which generates the token having symbol AXE and follows the
262  * ERC20 standard.
263  */ 
264 
265 contract AXEToken is StandardToken { 
266    
267     /// Token specifics 
268 	string public name="AXE";                   // Token Name
269 	uint8 public decimals=18;                   // How many parts token can be divided.
270     string public symbol="AXE";                 // An identifier: eg SBX, XPR etc..
271     
272     string public version = '1.0';
273 
274     constructor(address _wallet) public {
275         require(_wallet != address(0));
276         totalSupply_ = 10000000000*10**18;
277         balances[_wallet] = totalSupply_;
278         emit Transfer(address(0), _wallet, balances[_wallet]);
279     }
280     
281     
282     
283 	
284 }