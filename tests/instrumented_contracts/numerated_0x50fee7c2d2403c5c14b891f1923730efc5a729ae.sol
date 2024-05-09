1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     // SafeMath.sub will throw if there is not enough balance.
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   /**
50   * @dev Gets the balance of the specified address.
51   * @param _owner The address to query the the balance of.
52   * @return An uint256 representing the amount owned by the passed address.
53   */
54   function balanceOf(address _owner) public view returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 
61 
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
81 
82   /**
83    * @dev Transfer tokens from one address to another
84    * @param _from address The address which you want to send tokens from
85    * @param _to address The address which you want to transfer to
86    * @param _value uint256 the amount of tokens to be transferred
87    */
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    *
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(address _owner, address _spender) public view returns (uint256) {
123     return allowed[_owner][_spender];
124   }
125 
126   /**
127    * @dev Increase the amount of tokens that an owner allowed to a spender.
128    *
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    * @param _spender The address which will spend the funds.
134    * @param _addedValue The amount of tokens to increase the allowance by.
135    */
136   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
137     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142   /**
143    * @dev Decrease the amount of tokens that an owner allowed to a spender.
144    *
145    * approve should be called when allowed[_spender] == 0. To decrement
146    * allowed value is better to use this function to avoid 2 calls (and wait until
147    * the first transaction is mined)
148    * From MonolithDAO Token.sol
149    * @param _spender The address which will spend the funds.
150    * @param _subtractedValue The amount of tokens to decrease the allowance by.
151    */
152   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163 }
164 
165 
166 /**
167  * @title SafeMath
168  * @dev Math operations with safety checks that throw on error
169  */
170 library SafeMath {
171 
172   /**
173   * @dev Multiplies two numbers, throws on overflow.
174   */
175   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176     if (a == 0) {
177       return 0;
178     }
179     uint256 c = a * b;
180     assert(c / a == b);
181     return c;
182   }
183 
184   /**
185   * @dev Integer division of two numbers, truncating the quotient.
186   */
187   function div(uint256 a, uint256 b) internal pure returns (uint256) {
188     // assert(b > 0); // Solidity automatically throws when dividing by 0
189     uint256 c = a / b;
190     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191     return c;
192   }
193 
194   /**
195   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
196   */
197   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198     assert(b <= a);
199     return a - b;
200   }
201 
202   /**
203   * @dev Adds two numbers, throws on overflow.
204   */
205   function add(uint256 a, uint256 b) internal pure returns (uint256) {
206     uint256 c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 contract MetuljcekCekincekToken is StandardToken, Ownable {
253 
254   /* Public variables of the token */
255   string public standard = 'Token 0.1';
256   string public name = "MetuljcekCekincek";
257   string public symbol = "MCT";
258   uint8 public decimals = 18;
259 
260   bool public mintingFinished = false;
261 
262 
263   event Mint(address indexed to, uint256 amount);
264   event MintFinished();
265   event Burn(address indexed burner, uint256 value);
266 
267   /**
268    * @dev Function to mint tokens
269    * @param _to The address that will receive the minted tokens.
270    * @param _amount The amount of tokens to mint.
271    * @return A boolean that indicates if the operation was successful.
272    */
273   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
274     require(!mintingFinished);
275     totalSupply_ = totalSupply_.add(_amount);
276     balances[_to] = balances[_to].add(_amount);
277     Mint(_to, _amount);
278     Transfer(0x0, _to, _amount);
279     return true;
280   }
281 
282   /**
283    * @dev Function to stop minting new tokens.
284    * @return True if the operation was successful.
285    */
286   function finishMinting() onlyOwner public returns (bool) {
287     mintingFinished = true;
288     MintFinished();
289     return true;
290   }
291 
292   /**
293    * @dev Burns a specific amount of tokens.
294    * @param _value The amount of token to be burned.
295    */
296   function burn(uint256 _value) public {
297       require(_value > 0);
298 
299       address burner = msg.sender;
300       balances[burner] = balances[burner].sub(_value);
301       totalSupply_ = totalSupply_.sub(_value);
302       Burn(burner, _value);
303   }
304 }