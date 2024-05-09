1 pragma solidity >=0.4.23;
2 
3 /**
4  * @author Dan Emmons at Loci.io
5  */  
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76 
77   /**
78   * @dev Multiplies two numbers, throws on overflow.
79   */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     if (a == 0) {
82       return 0;
83     }
84     uint256 c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   /**
90   * @dev Integer division of two numbers, truncating the quotient.
91   */
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return c;
97   }
98 
99   /**
100   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   /**
108   * @dev Adds two numbers, throws on overflow.
109   */
110   function add(uint256 a, uint256 b) internal pure returns (uint256) {
111     uint256 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 totalSupply_;
128 
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(address _owner, address _spender) public view returns (uint256) {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 /**
259  * @title Contactable token
260  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
261  * contact information.
262  */
263 contract Contactable is Ownable {
264 
265   string public contactInformation;
266 
267   /**
268     * @dev Allows the owner to set a string with their contact information.
269     * @param info The contact information to attach to the contract.
270     */
271   function setContactInformation(string info) onlyOwner public {
272     contactInformation = info;
273   }
274 }
275 
276 contract LOCIcredits is Ownable, Contactable {    
277     using SafeMath for uint256;    
278 
279     StandardToken token; // LOCIcoin deployed contract
280     mapping (address => bool) internal allowedOverrideAddresses;
281 
282     mapping (string => LOCIuser) users;    
283     string[] userKeys;
284     uint256 userCount;        
285 
286     // convenience for accounting
287     event UserAdded( string id, uint256 time );
288 
289     // core usage: increaseCredits, reduceCredits, buyCreditsAndSpend, buyCreditsAndSpendAndRecover
290     event CreditsAdjusted( string id, uint8 adjustment, uint256 value, uint8 reason, address register );    
291 
292     // special usage: transferCreditsInternally (only required in the event of a user that created multiple accounts)
293     event CreditsTransferred( string id, uint256 value, uint8 reason, string beneficiary );
294 
295     modifier onlyOwnerOrOverride() {
296         // owner or any addresses listed in the overrides
297         // can perform token transfers while inactive
298         require(msg.sender == owner || allowedOverrideAddresses[msg.sender]);
299         _;
300     }
301 
302     struct LOCIuser {        
303         uint256 credits;
304         bool registered;
305         address wallet;
306     }
307     
308     constructor( address _token, string _contactInformation ) public {
309         owner = msg.sender;
310         token = StandardToken(_token); // LOCIcoin address
311         contactInformation = _contactInformation;        
312     }    
313     
314     function increaseCredits( string _id, uint256 _value, uint8 _reason, address _register ) public onlyOwnerOrOverride returns(uint256) {
315                 
316         LOCIuser storage user = users[_id];
317 
318         if( !user.registered ) {
319             user.registered = true;
320             userKeys.push(_id);
321             userCount = userCount.add(1);
322             emit UserAdded(_id,now);
323         }
324 
325         user.credits = user.credits.add(_value);        
326         require( token.transferFrom( _register, address(this), _value ) );
327         emit CreditsAdjusted(_id, 1, _value, _reason, _register);
328         return user.credits;
329     }
330 
331     function reduceCredits( string _id, uint256 _value, uint8 _reason, address _register ) public onlyOwnerOrOverride returns(uint256) {
332              
333         LOCIuser storage user = users[_id];     
334         require( user.registered );
335         // SafeMath.sub will throw if there is not enough balance.
336         user.credits = user.credits.sub(_value);        
337         require( user.credits >= 0 );        
338         require( token.transfer( _register, _value ) );           
339         emit CreditsAdjusted(_id, 2, _value, _reason, _register);        
340         
341         return user.credits;
342     }        
343 
344     function buyCreditsAndSpend( string _id, uint256 _value, uint8 _reason, address _register, uint256 _spend ) public onlyOwnerOrOverride returns(uint256) {
345         increaseCredits(_id, _value, _reason, _register);
346         return reduceCredits(_id, _spend, _reason, _register );        
347     }        
348 
349     function buyCreditsAndSpendAndRecover(string _id, uint256 _value, uint8 _reason, address _register, uint256 _spend, address _recover ) public onlyOwnerOrOverride returns(uint256) {
350         buyCreditsAndSpend(_id, _value, _reason, _register, _spend);
351         return reduceCredits(_id, getCreditsFor(_id), _reason, _recover);
352     }    
353 
354     function transferCreditsInternally( string _id, uint256 _value, uint8 _reason, string _beneficiary ) public onlyOwnerOrOverride returns(uint256) {        
355 
356         LOCIuser storage user = users[_id];   
357         require( user.registered );
358 
359         LOCIuser storage beneficiary = users[_beneficiary];
360         if( !beneficiary.registered ) {
361             beneficiary.registered = true;
362             userKeys.push(_beneficiary);
363             userCount = userCount.add(1);
364             emit UserAdded(_beneficiary,now);
365         }
366 
367         require(_value <= user.credits);        
368         user.credits = user.credits.sub(_value);
369         require( user.credits >= 0 );
370         
371         beneficiary.credits = beneficiary.credits.add(_value);
372         require( beneficiary.credits >= _value );
373 
374         emit CreditsAdjusted(_id, 2, _value, _reason, 0x0);
375         emit CreditsAdjusted(_beneficiary, 1, _value, _reason, 0x0);
376         emit CreditsTransferred(_id, _value, _reason, _beneficiary );
377         
378         return user.credits;
379     }   
380 
381     function assignUserWallet( string _id, address _wallet ) public onlyOwnerOrOverride returns(uint256) {
382         LOCIuser storage user = users[_id];   
383         require( user.registered );
384         user.wallet = _wallet;
385         return user.credits;
386     }
387 
388     function withdrawUserSpecifiedFunds( string _id, uint256 _value, uint8 _reason ) public returns(uint256) {
389         LOCIuser storage user = users[_id];           
390         require( user.registered, "user is not registered" );    
391         require( user.wallet == msg.sender, "user.wallet is not msg.sender" );
392         
393         user.credits = user.credits.sub(_value);
394         require( user.credits >= 0 );               
395         require( token.transfer( user.wallet, _value ), "transfer failed" );                   
396         emit CreditsAdjusted(_id, 2, _value, _reason, user.wallet );        
397         
398         return user.credits;
399     }
400 
401     function getUserWallet( string _id ) public constant returns(address) {
402         return users[_id].wallet;
403     }
404 
405     function getTotalSupply() public constant returns(uint256) {        
406         return token.balanceOf(address(this));
407     }
408 
409     function getCreditsFor( string _id ) public constant returns(uint256) {
410         return users[_id].credits;
411     }
412 
413     function getUserCount() public constant returns(uint256) {
414         return userCount;
415     }    
416 
417     function getUserKey(uint256 _index) public constant returns(string) {
418         require(_index <= userKeys.length-1);
419         return userKeys[_index];
420     }
421 
422     function getCreditsAtIndex(uint256 _index) public constant returns(uint256) {
423         return getCreditsFor(getUserKey(_index));
424     }
425 
426     // non-core functionality 
427     function ownerSetOverride(address _address, bool enable) external onlyOwner {
428         allowedOverrideAddresses[_address] = enable;
429     }
430 
431     function isAllowedOverrideAddress(address _addr) external constant returns (bool) {
432         return allowedOverrideAddresses[_addr];
433     }
434 
435     // enable recovery of ether sent to this contract
436     function ownerTransferWei(address _beneficiary, uint256 _value) external onlyOwner {
437         require(_beneficiary != 0x0);
438         require(_beneficiary != address(token));        
439 
440         // if zero requested, send the entire amount, otherwise the amount requested
441         uint256 _amount = _value > 0 ? _value : address(this).balance;
442 
443         _beneficiary.transfer(_amount);
444     }
445 
446     // enable recovery of LOCIcoin sent to this contract
447     function ownerRecoverTokens(address _beneficiary) external onlyOwner {
448         require(_beneficiary != 0x0);            
449         require(_beneficiary != address(token));        
450 
451         uint256 _tokensRemaining = token.balanceOf(address(this));
452         if (_tokensRemaining > 0) {
453             token.transfer(_beneficiary, _tokensRemaining);
454         }
455     }
456 
457     // enable recovery of any other StandardToken sent to this contract
458     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
459         return StandardToken(tokenAddress).transfer(owner, tokens);
460     }
461 }