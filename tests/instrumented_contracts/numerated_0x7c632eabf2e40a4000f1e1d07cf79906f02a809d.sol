1 /**
2  *Submitted for verification at Etherscan.io on 2018-08-06
3 */
4 
5 pragma solidity ^0.4.19;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
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
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     // SafeMath.sub will throw if there is not enough balance.
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109   }
110 }
111 
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 }
212 
213 /////
214 
215 /**
216  * @title Ownable
217  * @dev The Ownable contract has an owner address, and provides basic authorization control
218  * functions, this simplifies the implementation of "user permissions".
219  */
220 contract Ownable {
221   address public owner;
222 
223 
224   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226 
227   /**
228    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229    * account.
230    */
231   function Ownable() public {
232     owner = msg.sender;
233   }
234 
235   /**
236    * @dev Throws if called by any account other than the owner.
237    */
238   modifier onlyOwner() {
239     require(msg.sender == owner);
240     _;
241   }
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address newOwner) public onlyOwner {
248     require(newOwner != address(0));
249     OwnershipTransferred(owner, newOwner);
250     owner = newOwner;
251   }
252 
253 }
254 
255 /**
256  * @title Pausable
257  * @dev Base contract which allows children to implement an emergency stop mechanism.
258  */
259 contract Pausable is Ownable {
260   event Pause();
261   event Unpause();
262 
263   bool public paused = false;
264 
265 
266   /**
267    * @dev modifier to allow actions only when the contract IS paused
268    */
269   modifier whenNotPaused() {
270     require(!paused);
271     _;
272   }
273 
274   /**
275    * @dev modifier to allow actions only when the contract IS NOT paused
276    */
277   modifier whenPaused {
278     require(paused);
279     _;
280   }
281 
282   /**
283    * @dev called by the owner to pause, triggers stopped state
284    */
285   function pause() onlyOwner whenNotPaused public returns (bool) {
286     paused = true;
287     Pause();
288     return true;
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() onlyOwner whenPaused public returns (bool) {
295     paused = false;
296     Unpause();
297     return true;
298   }
299 }
300 
301 contract PausableToken is StandardToken, Pausable {
302 	function transferFrom(address from, address to, uint256 value) whenNotPaused public returns (bool) {
303 		return super.transferFrom(from,to,value);
304 	}
305 
306 	function approve(address spender, uint256 value) whenNotPaused public returns (bool) {
307 		return super.approve(spender,value);
308 	}
309 
310 	function transfer(address to, uint256 value) whenNotPaused public returns (bool) {
311 		return super.transfer(to,value);
312 	}
313 
314 	function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
315 		return super.increaseApproval(_spender,_addedValue);
316 	}
317 
318 	function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
319 		return super.decreaseApproval(_spender,_subtractedValue);
320 	}
321 }
322 
323 /**
324  * @title SEK Token for Seven Eleven Kitty Project
325  * 
326  */
327 contract SEK is PausableToken {
328     string public name = "Seven Eleven Kitty";
329     string public symbol = "SEK";
330     uint public decimals = 8;
331     string public version = "1.0";
332 
333     event Burn(address indexed from, uint256 value);
334   
335     function SEK() public {
336         totalSupply_ = 10000000000 * 10 ** 8;
337         balances[owner] = totalSupply_;
338     }
339 
340    function burn(uint256 _value) onlyOwner public returns (bool success) {
341         require(balances[msg.sender] >= _value);                   // Check if the sender has enough
342 		    require(_value > 0); 
343         balances[msg.sender] = balances[msg.sender].sub(_value);  // Subtract from the sender
344         totalSupply_ = totalSupply_.sub(_value);                  // Updates totalSupply
345         Burn(msg.sender, _value);
346         return true;
347     }
348 
349     function () public {
350         revert();
351     }
352 }