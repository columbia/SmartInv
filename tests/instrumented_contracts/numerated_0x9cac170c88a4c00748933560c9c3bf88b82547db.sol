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
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 contract NeolandsToken is StandardToken {
212     
213     string public constant name    = "Neolands Token";
214     string public constant symbol  = "XNL";
215     uint8 public constant decimals = 0;
216     
217     uint256 public constant INITIAL_SUPPLY = 100000000;
218     
219     constructor () public {
220         totalSupply_         = INITIAL_SUPPLY;
221         balances[msg.sender] = INITIAL_SUPPLY;
222         
223         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
224     }
225 }
226 
227 /**
228  * @title Ownable
229  * @dev The Ownable contract has an owner address, and provides basic authorization control
230  * functions, this simplifies the implementation of "user permissions".
231  */
232 contract Ownable {
233   address public owner;
234 
235 
236   event OwnershipRenounced(address indexed previousOwner);
237   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239 
240   /**
241    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
242    * account.
243    */
244   constructor() public {
245     owner = msg.sender;
246   }
247 
248   /**
249    * @dev Throws if called by any account other than the owner.
250    */
251   modifier onlyOwner() {
252     require(msg.sender == owner);
253     _;
254   }
255 
256   /**
257    * @dev Allows the current owner to transfer control of the contract to a newOwner.
258    * @param newOwner The address to transfer ownership to.
259    */
260   function transferOwnership(address newOwner) public onlyOwner {
261     require(newOwner != address(0));
262     emit OwnershipTransferred(owner, newOwner);
263     owner = newOwner;
264   }
265 
266   /**
267    * @dev Allows the current owner to relinquish control of the contract.
268    */
269   function renounceOwnership() public onlyOwner {
270     emit OwnershipRenounced(owner);
271     owner = address(0);
272   }
273 }
274 
275 contract DistributionTokens is Ownable {
276     
277     NeolandsToken private f_token;
278     uint256       private f_price_one_token;
279     bool          private f_trade_is_open;
280     
281     event PaymentOfTokens(address payer, uint256 number_token, uint256 value);
282     
283     constructor () public {
284         f_token           = NeolandsToken(0x0);
285         f_price_one_token = 0;
286         f_trade_is_open   = true;
287     }
288     
289     function () public payable {
290         revert();
291     }
292     
293     function setAddressToken(address _address_token) public onlyOwner {
294         require(_address_token != 0x0);
295         
296         f_token = NeolandsToken(_address_token);
297     }
298     
299     function getAddressToken() public view returns (address) {
300         return address(f_token);
301     }
302     
303     function setPriceOneToken(uint256 _price_token, uint256 _price_ether) public onlyOwner {
304         require(_price_token > 0);
305         require(_price_ether > 0);
306         
307         f_price_one_token = (_price_token * 1 ether) / _price_ether;
308     }
309 
310     function getPriceOneToken() public view returns (uint256) {
311         return f_price_one_token;
312     }
313     
314     function setTradeIsOpen(bool _is_open) public onlyOwner {
315         f_trade_is_open = _is_open;
316     }
317     
318     function getTradeIsOpen() public view returns (bool) {
319         return f_trade_is_open;
320     }
321     
322     function buyToken(uint256 _number_token) public payable returns (bool) {
323 		require(f_trade_is_open);
324 		require(_number_token >  0);
325 		require(_number_token <= _number_token * f_price_one_token);
326 		require(msg.value >  0);
327 		require(msg.value == _number_token * f_price_one_token);
328 		
329 		f_token.transfer(msg.sender, _number_token);
330 		
331 		emit PaymentOfTokens(msg.sender, _number_token, msg.value);
332 		
333 		return true;
334 	}
335 	
336 	function getBalanceToken() public view returns (uint256) {
337 		return f_token.balanceOf(address(this));
338     }
339     
340     function getBalance() public view returns (uint256) {
341 		return address(this).balance;
342     }
343     
344     function outputMoney(address _from, uint256 _value) public onlyOwner returns (bool) {
345         require(address(this).balance >= _value);
346 
347         _from.transfer(_value);
348 
349         return true;
350     }
351 }