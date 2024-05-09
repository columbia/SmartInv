1 pragma solidity ^0.4.18;
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
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   uint256 totalSupply_;
125 
126   /**
127   * @dev total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141 
142     // SafeMath.sub will throw if there is not enough balance.
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) public view returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 /**
258  * @title Burnable Token
259  * @dev Token that can be irreversibly burned (destroyed).
260  */
261 contract BurnableToken is BasicToken {
262 
263   event Burn(address indexed burner, uint256 value);
264 
265   /**
266    * @dev Burns a specific amount of tokens.
267    * @param _value The amount of token to be burned.
268    */
269   function burn(uint256 _value) public {
270     require(_value <= balances[msg.sender]);
271     // no need to require value <= totalSupply, since that would imply the
272     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
273 
274     address burner = msg.sender;
275     balances[burner] = balances[burner].sub(_value);
276     totalSupply_ = totalSupply_.sub(_value);
277     Burn(burner, _value);
278   }
279 }
280 
281 interface TokenRecipient { function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool); }
282 
283 contract Finchain is StandardToken, BurnableToken, Ownable {
284 	string public name;
285 	string public symbol;
286 	uint8 public decimals; 
287 	bool public transfer_enabled = false;
288  
289   
290 	function Finchain(uint256 _initalSupply, string _name, string _symbol, uint8 _decimals) public{
291 		decimals = _decimals;
292 		totalSupply_  = _initalSupply * (10 ** uint256(decimals));
293 		name = _name;
294 		symbol = _symbol;
295 		balances[msg.sender] = totalSupply_ ;
296 	}
297   
298 	/**
299      * Enables the ability of anyone to transfer their tokens. This can
300      * only be called by the token owner. Once enabled, it is not
301      * possible to disable transfers.
302     */
303 	function enableTransfer() external onlyOwner {
304 		transfer_enabled = true;
305 	}
306   
307 	modifier onlyWhenTransferEnabled() {
308 		if(!transfer_enabled){
309 			require(msg.sender == owner);
310 		}
311         _;
312     }
313   
314 	
315 	function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
316         return super.transfer(_to, _value);
317     }
318 	
319 	function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
320         bool result = super.transferFrom(_from, _to, _value);
321 	
322         return result;
323     }
324 	
325 	
326 	/* Transfer and then calls the receiving contract */
327 	function transferAndCall(address _recipient, uint256 _value, bytes _extraData) external{
328 		transfer(_recipient, _value);
329 		//call the tokenFallback function on the contract you want to be notified.
330 		require(TokenRecipient(_recipient).tokenFallback(msg.sender,_value,_extraData)); 
331 	}
332 	
333 	function burn(uint256 _value) public {
334         require(transfer_enabled || msg.sender == owner);
335         super.burn(_value);
336         Transfer(msg.sender, address(0x0), _value);
337     }
338 	
339 	function () {
340         //if ether is sent to this address, send it back.
341         throw;
342     }
343 }