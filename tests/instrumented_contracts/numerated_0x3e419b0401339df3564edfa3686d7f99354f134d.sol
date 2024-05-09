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
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipRenounced(address indexed previousOwner);
59   event OwnershipTransferred(
60     address indexed previousOwner,
61     address indexed newOwner
62   );
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to relinquish control of the contract.
83    * @notice Renouncing to ownership will leave the contract without an owner.
84    * It will not be possible to call the functions with the `onlyOwner`
85    * modifier anymore.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * @dev https://github.com/ethereum/EIPs/issues/20
117  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract ERC20StandardToken {
120   event Transfer(address indexed from, address indexed to, uint256 value);
121   event Approval(address indexed _owner, address indexed _spender, uint _value);
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124   mapping (address => uint256) public balanceOf;
125   
126   using SafeMath for uint256;
127   uint256 totalSupply_;
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135    
136   function transferFrom(address _from,address _to,uint256 _value) public returns (bool)
137   {
138     require(_to != address(0));
139     require(_value <= balanceOf[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balanceOf[_from] = balanceOf[_from].sub(_value);
143     balanceOf[_to] = balanceOf[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     emit Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return totalSupply_;
154   }
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balanceOf[msg.sender]);
164 
165     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
166     balanceOf[_to] = balanceOf[_to].add(_value);
167     emit Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
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
182   
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
195 
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    *
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217  
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
241    
242   function decreaseApproval(
243     address _spender,
244     uint _subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 
262 
263  /**
264  * @title Contract that will work with ERC223 tokens.
265  */
266 
267 contract addtionalERC223Interface {
268     function transfer(address to, uint256 value, bytes data) public returns (bool);
269     event Transfer(address indexed from, address indexed to, uint value, bytes data);
270 }
271 
272 contract ERC223ReceivingContract { 
273     /**
274     * @dev Standard ERC223 function that will handle incoming token transfers.
275     *
276     * @param _from  Token sender address.
277     * @param _value Amount of tokens.
278     * @param _data  Transaction metadata.
279     */
280     
281     struct TKN {
282         address sender;
283         uint value;
284         bytes data;
285         bytes4 sig;
286     }
287     
288     function tokenFallback(address _from, uint256 _value, bytes _data) public pure
289     {
290         TKN memory tkn;
291         tkn.sender = _from;
292         tkn.value = _value;
293         tkn.data = _data;
294         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
295         tkn.sig = bytes4(u);        
296     }
297 }
298 
299 
300 /**
301  * @title Reference implementation of the ERC223 standard token.
302  */
303 contract ERC223Token is addtionalERC223Interface , ERC20StandardToken {
304  
305     function _transfer(address _to, uint256 _value ) private returns (bool) {
306         require(balanceOf[msg.sender] >= _value);
307         
308         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
309         balanceOf[_to] = balanceOf[_to].add(_value);
310         
311         return true;
312     }
313 
314     function _transferFallback(address _to, uint256 _value, bytes _data) private returns (bool) {
315         require(balanceOf[msg.sender] >= _value);
316 
317         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
318         balanceOf[_to] = balanceOf[_to].add(_value);
319 
320         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
321         receiver.tokenFallback(msg.sender, _value, _data);
322         
323         emit Transfer(msg.sender, _to, _value, _data);
324         
325         return true;
326     }
327 
328     /**
329      * @dev Transfer the specified amount of tokens to the specified address.
330      *      Invokes the `tokenFallback` function if the recipient is a contract.
331      *      The token transfer fails if the recipient is a contract
332      *      but does not implement the `tokenFallback` function
333      *      or the fallback function to receive funds.
334      *
335      * @param _to    Receiver address.
336      * @param _value Amount of tokens that will be transferred.
337      * @param _data  Transaction metadata.
338      */
339     function transfer(address _to, uint256 _value, bytes _data) public returns (bool OK) {
340         // Standard function transfer similar to ERC20 transfer with no _data .
341         // Added due to backwards compatibility reasons .
342         if(isContract(_to))
343         {
344             return _transferFallback(_to,_value,_data);
345         }else{
346             _transfer(_to,_value);
347             emit Transfer(msg.sender, _to, _value, _data);
348         }
349         
350         return true;
351     }
352     
353     /**
354      * @dev Transfer the specified amount of tokens to the specified address.
355      *      This function works the same with the previous one
356      *      but doesn't contain `_data` param.
357      *      Added due to backwards compatibility reasons.
358      *
359      * @param _to    Receiver address.
360      * @param _value Amount of tokens that will be transferred.
361      */
362     function transfer(address _to, uint256 _value) public returns (bool) {
363         bytes memory empty;
364 
365         if(isContract(_to))
366         {
367             return _transferFallback(_to,_value,empty);
368         }else{
369             _transfer(_to,_value);
370             emit Transfer(msg.sender, _to, _value);
371         }
372         
373     }
374     
375     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
376     function isContract(address _addr) private view returns (bool) {
377         uint length;
378         assembly {
379             //retrieve the size of the code on target address, this needs assembly
380             length := extcodesize(_addr)
381         }
382         return (length > 0);
383     }    
384 
385     
386     
387 }
388 
389 
390 contract NANASHITOKEN is ERC223Token , Ownable
391 {
392     event Burn(address indexed from, uint256 amount);
393     event Mint(address indexed to, uint256 amount);
394 
395     string public name = "NANASHITOKEN";
396     string public symbol = "NNSH";
397     uint8 public decimals = 18;
398     
399     constructor() public{
400         address founder = 0x34c6D2bd70862D33c2d6710cF683e9b0860017a3;
401         address developer = 0x0ede4523d0aD50FF840Be95Dd680704f761C1E06;
402     
403         owner = founder;
404         uint256  dec = decimals;
405         totalSupply_ = 500 * 1e8 * (10**dec);
406         balanceOf[founder] = totalSupply_.mul(97).div(100);
407         balanceOf[developer] = totalSupply_.mul(3).div(100);
408     }
409     
410     function burn(address _from, uint256 _unitAmount) onlyOwner public {
411         require(_unitAmount > 0
412                 && balanceOf[_from] >= _unitAmount);
413 
414         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
415         totalSupply_ = totalSupply_.sub(_unitAmount);
416         emit Burn(_from, _unitAmount);
417     }
418     
419     /**
420      * @dev Function to mint tokens
421      * @param _to The address that will receive the minted tokens.
422      * @param _unitAmount The amount of tokens to mint.
423      */
424     function mint(address _to, uint256 _unitAmount) onlyOwner public returns (bool) {
425         require(_unitAmount > 0);
426 
427         totalSupply_ = totalSupply_.add(_unitAmount);
428         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
429         emit Mint(_to, _unitAmount);
430         emit Transfer(address(0), _to, _unitAmount);
431         return true;
432     }    
433     
434     
435 }