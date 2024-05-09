1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20 interface 
7  * 
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 
22 /**
23  * @title OwnableMintable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * @dev Added mintOwner address how controls the minting
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract OwnableMintable {
29   address public owner;
30   address public mintOwner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34   event MintOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43     mintOwner = msg.sender;
44   }
45 
46   
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyMintOwner() {
60     require(msg.sender == mintOwner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer mint control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferMintOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit MintOwnershipTransferred(mintOwner, newOwner);
81     mintOwner = newOwner;
82   }
83 
84 }
85 
86 
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 
133   function uint2str(uint i) internal pure returns (string){
134       if (i == 0) return "0";
135       uint j = i;
136       uint length;
137       while (j != 0){
138           length++;
139           j /= 10;
140       }
141       bytes memory bstr = new bytes(length);
142       uint k = length - 1;
143       while (i != 0){
144           bstr[k--] = byte(48 + i % 10);
145           i /= 10;
146       }
147       return string(bstr);
148   }
149  
150   
151 }
152 
153 
154 
155 /**
156  *
157  * @title EDToken
158  * @notice An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
159  *  
160  *
161  */
162 contract HSYToken is ERC20, OwnableMintable {
163   using SafeMath for uint256;
164 
165 
166   string public constant name = "HSYToken";  // The Token's name
167   string public constant symbol = "HSY";    // Identifier 
168   uint8 public constant decimals = 18;      // Number of decimals 
169 
170   //Hardcap is 244,000,000 - 244 million + 18 decimals
171   uint256  hardCap_ = 244000000 * (10**uint256(18));
172   
173 
174   //Balances
175   mapping(address => uint256) balances;
176   mapping(address => mapping (address => uint256)) internal allowed;
177 
178   //Minting
179   event Mint(address indexed to, uint256 amount);
180   event PauseMinting(); 
181   event UnPauseMinting(); 
182 
183   //If token is mintable
184   bool public pauseMinting = false;
185 
186   //Total supply of tokens 
187   uint256 totalSupply_ = 9999999999999999999999;
188 
189 
190   //Constructor
191   constructor() public {
192     
193   }
194 
195 
196   //Fix for the ERC20 short address attack.
197   modifier onlyPayloadSize(uint size) {
198     assert(msg.data.length >= size + 4);
199     _;
200   } 
201  
202 
203   /**
204    * @dev total number of tokens in existence
205    */
206   function totalSupply() public view returns (uint256) {
207     return totalSupply_;
208   }
209 
210   /**
211    * @dev allowed total number of tokens
212    */
213   function hardCap() public view returns (uint256) {
214     return hardCap_;
215   }
216  
217   /**
218    * @dev transfer token for a specified address
219    * @param _to The address to transfer to.
220    * @param _value The amount to be transferred.
221    */
222   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
223     return _transfer(msg.sender, _to, _value); 
224   }
225 
226 
227   /**
228    * @dev Internal transfer, only can be called by this contract  
229    * @param _from is msg.sender The address to transfer from.
230    * @param _to The address to transfer to.
231    * @param _value The amount to be transferred.
232    */
233   function _transfer(address _from, address _to, uint _value) internal returns (bool){
234       require(_to != address(0)); // Prevent transfer to 0x0 address.
235       require(_value <= balances[msg.sender]);  // Check if the sender has enough      
236 
237       // SafeMath.sub will throw if there is not enough balance.
238       balances[_from] = balances[_from].sub(_value);
239       balances[_to] = balances[_to].add(_value);
240       emit Transfer(_from, _to, _value);
241       return true;
242   }
243 
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
252 
253     require(_to != address(0));                     // Prevent transfer to 0x0 address. Use burn() instead
254     require(_value <= balances[_from]);             // Check if the sender has enough
255     require(_value <= allowed[_from][msg.sender]);  // Check if the sender is allowed to send
256 
257 
258     // SafeMath.sub will throw if there is not enough balance.
259     balances[_from] = balances[_from].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     emit Transfer(_from, _to, _value);
263     return true; 
264   }
265 
266    
267 
268   /**
269    * @dev Gets the balance of the specified address.
270    * @param _owner The address to query the the balance of.
271    * @return An uint256 representing the amount owned by the passed address.
272    */
273   function balanceOf(address _owner) public view returns (uint256 balance) {
274     return balances[_owner];
275   }
276 
277 
278 
279   /**
280    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
281    *
282    * Beware that changing an allowance with this method brings the risk that someone may use both the old
283    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
284    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:  
285    * @param _spender The address which will spend the funds.
286    * @param _value The amount of tokens to be spent.
287    */
288   function approve(address _spender, uint256 _value) public returns (bool) {
289     allowed[msg.sender][_spender] = _value;
290     emit Approval(msg.sender, _spender, _value);
291     return true;
292   }
293 
294 
295 
296   /**
297    * @dev Function to check the amount of tokens that an owner allowed to a spender.
298    * @param _owner address The address which owns the funds.
299    * @param _spender address The address which will spend the funds.
300    * @return A uint256 specifying the amount of tokens still available for the spender.
301    */
302   function allowance(address _owner, address _spender) public view returns (uint256) {
303     return allowed[_owner][_spender];
304   }
305 
306 
307 
308   /**
309    * @dev Increase the amount of tokens that an owner allowed to a spender.
310    *
311    * approve should be called when allowed[_spender] == 0. To increment
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)   
314    * @param _spender The address which will spend the funds.
315    * @param _addedValue The amount of tokens to increase the allowance by.
316    */
317   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
318     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323 
324 
325   /**
326    * @dev Decrease the amount of tokens that an owner allowed to a spend.
327    *
328    * approve should be called when allowed[_spender] == 0. To decrement
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)   
331    * @param _spender The address which will spend the funds.
332    * @param _subtractedValue The amount of tokens to decrease the allowance by.
333    */
334   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
335     uint oldValue = allowed[msg.sender][_spender];
336     if (_subtractedValue > oldValue) {
337       allowed[msg.sender][_spender] = 0;
338     } else {
339       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
340     }
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345  
346 
347   /**
348    *  MintableToken functionality
349    */
350   modifier canMint() {
351     require(!pauseMinting);
352     _;
353   }
354   
355 
356   /**
357    * @dev Function to mint tokens
358    * @param _to The address that will receive the minted tokens.
359    * @param _amount The amount of tokens to mint.
360    * @return A boolean that indicates if the operation was successful.
361    */
362   function mint(address _to, uint256 _amount) onlyMintOwner canMint public returns (bool) {
363     require(_to != address(0)); // Prevent transfer to 0x0 address.
364     require(totalSupply_.add(_amount) <= hardCap_);
365 
366     totalSupply_ = totalSupply_.add(_amount);
367     balances[_to] = balances[_to].add(_amount);
368 
369     emit Mint(_to, _amount); 
370     emit Transfer(address(0), _to, _amount);
371     return true;
372   }
373 
374 
375 
376   /**
377    * @dev Function to pause minting new tokens.
378    * @notice Pause minting
379    */
380   function toggleMinting()  onlyOwner public {
381     if(pauseMinting){
382       pauseMinting = false;
383       emit UnPauseMinting();
384     }else{
385       pauseMinting = true;
386       emit PauseMinting();
387     }     
388   }
389 
390 
391   /**
392    * @dev Owner can transfer other tokens that are sent here by mistake
393    * 
394    */
395   function refundOtherTokens(address _recipient, ERC20 _token)  onlyOwner public {
396     require(_token != this);
397     uint256 balance = _token.balanceOf(this);
398     require(_token.transfer(_recipient, balance));
399   }
400 
401  
402 }