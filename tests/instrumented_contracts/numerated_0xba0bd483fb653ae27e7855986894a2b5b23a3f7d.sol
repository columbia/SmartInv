1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title ERC20
7  * 
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);  
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   function allowance(address owner, address spender) public view returns (uint256); 
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 
69 /**
70  * @title Ownable && Mintable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * @dev Added mintOwner address how controls the minting
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77   address public mintOwner;
78 
79 
80   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81   event MintOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() public {
89     owner = msg.sender;
90     mintOwner = msg.sender;
91   }
92 
93   
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Throws if called by any account other than the owner.
105    */
106   modifier onlyMintOwner() {
107     require(msg.sender == mintOwner);
108     _;
109   }
110 
111   /**
112    * @dev Allows the current owner to transfer control of the contract to a newOwner.
113    * @param newOwner The address to transfer ownership to.
114    */
115   function transferOwnership(address newOwner) public onlyOwner {
116     require(newOwner != address(0));
117     emit OwnershipTransferred(owner, newOwner);
118     owner = newOwner;
119   }
120 
121   /**
122    * @dev Allows the current owner to transfer mint control of the contract to a newOwner.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferMintOwnership(address newOwner) public onlyOwner {
126     require(newOwner != address(0));
127     emit MintOwnershipTransferred(mintOwner, newOwner);
128     mintOwner = newOwner;
129   }
130 
131 }
132 
133 
134 
135 
136 /**
137  *
138  * @title Edge token
139  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
140  *  
141  *
142  */
143 contract EdgeToken is ERC20, Ownable {
144   using SafeMath for uint256;
145 
146   //Balances
147   mapping(address => uint256) balances;
148   mapping(address => mapping (address => uint256)) internal allowed;
149 
150   //Minting
151   event Mint(address indexed to, uint256 amount);
152   event MintFinished(); 
153 
154   //If token is mintable
155   bool public mintingFinished = false;
156 
157   //Total supply of tokens 
158   uint256 totalSupply_ = 0;
159 
160   //Hardcap is 1,000,000,000 - One billion tokens
161   uint256 hardCap_ = 1000000000000000000000000000;
162 
163   //Constructor
164   constructor() public {
165     
166   }
167 
168 
169   //Fix for the ERC20 short address attack.
170   modifier onlyPayloadSize(uint size) {
171     assert(msg.data.length >= size + 4);
172     _;
173    } 
174 
175  
176 
177   /**
178    * @dev total number of tokens in existence
179    */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185    * @dev allowed total number of tokens
186    */
187   function hardCap() public view returns (uint256) {
188     return hardCap_;
189   }
190  
191   /**
192    * @dev transfer token for a specified address
193    * @param _to The address to transfer to.
194    * @param _value The amount to be transferred.
195    */
196   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
197     return _transfer(msg.sender, _to, _value); 
198   }
199 
200 
201   /**
202    * @dev Internal transfer, only can be called by this contract  
203    * @param _from is msg.sender The address to transfer from.
204    * @param _to The address to transfer to.
205    * @param _value The amount to be transferred.
206    */
207   function _transfer(address _from, address _to, uint _value) internal returns (bool){
208       require(_to != address(0)); // Prevent transfer to 0x0 address.
209       require(_value <= balances[msg.sender]);  // Check if the sender has enough      
210 
211       // SafeMath.sub will throw if there is not enough balance.
212       balances[_from] = balances[_from].sub(_value);
213       balances[_to] = balances[_to].add(_value);
214       emit Transfer(_from, _to, _value);
215       return true;
216   }
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
226 
227     require(_to != address(0));                     // Prevent transfer to 0x0 address. Use burn() instead
228     require(_value <= balances[_from]);             // Check if the sender has enough
229     require(_value <= allowed[_from][msg.sender]);  // Check if the sender is allowed to send
230 
231 
232     // SafeMath.sub will throw if there is not enough balance.
233     balances[_from] = balances[_from].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236     emit Transfer(_from, _to, _value);
237     return true; 
238   }
239 
240    
241 
242   /**
243    * @dev Gets the balance of the specified address.
244    * @param _owner The address to query the the balance of.
245    * @return An uint256 representing the amount owned by the passed address.
246    */
247   function balanceOf(address _owner) public view returns (uint256 balance) {
248     return balances[_owner];
249   }
250 
251 
252 
253   /**
254    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255    *
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _value The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     emit Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269 
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(address _owner, address _spender) public view returns (uint256) {
278     return allowed[_owner][_spender];
279   }
280 
281 
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
294     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
295     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spend.
303    *
304    * approve should be called when allowed[_spender] == 0. To decrement
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _subtractedValue The amount of tokens to decrease the allowance by.
310    */
311   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
312     uint oldValue = allowed[msg.sender][_spender];
313     if (_subtractedValue > oldValue) {
314       allowed[msg.sender][_spender] = 0;
315     } else {
316       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
317     }
318     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322  
323 
324   /**
325    *  MintableToken functionality
326    */
327   modifier canMint() {
328     require(!mintingFinished);
329     _;
330   }
331   
332 
333   /**
334    * @dev Function to mint tokens
335    * @param _to The address that will receive the minted tokens.
336    * @param _amount The amount of tokens to mint.
337    * @return A boolean that indicates if the operation was successful.
338    */
339   function mint(address _to, uint256 _amount) onlyMintOwner canMint public returns (bool) {
340     require(totalSupply_.add(_amount) <= hardCap_);
341 
342     totalSupply_ = totalSupply_.add(_amount);
343     balances[_to] = balances[_to].add(_amount);
344 
345     emit Mint(_to, _amount); 
346     emit Transfer(address(0), _to, _amount);
347     return true;
348   }
349 
350 
351 
352   /**
353    * @dev Function to stop minting new tokens.
354    * @return True if the operation was successful.
355    */
356   function finishMinting() onlyOwner canMint public returns (bool) {
357     mintingFinished = true;
358     emit MintFinished();
359     return true;
360   }
361 
362 
363   /**
364    * @dev Owner can transfer other tokens that are sent here by mistake
365    * 
366    */
367   function refundOtherTokens(address _recipient, ERC20 _token) public onlyOwner {
368     require(_token != this);
369     uint256 balance = _token.balanceOf(this);
370     require(_token.transfer(_recipient, balance));
371   }
372 
373  
374 }
375 
376  
377 /**
378  * @title EDGE token EDGE
379  * 
380  */
381 contract EToken is EdgeToken {
382   string public constant name = "We Got Edge Token";  
383   string public constant symbol = "EDGE";   
384   uint8 public constant decimals = 18;  
385 
386 }