1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor () public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
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
74 }
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     /// Total amount of tokens
82   uint256 public totalSupply;
83   
84   function balanceOf(address _owner) public view returns (uint256 balance);
85   
86   function transfer(address _to, uint256 _amount) public returns (bool success);
87   
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
97   
98   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
99   
100   function approve(address _spender, uint256 _amount) public returns (bool success);
101   
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   //balance in each address account
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _amount The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _amount) public returns (bool success) {
121     require(_to != address(0));
122     require(balances[msg.sender] >= _amount && _amount > 0
123         && balances[_to].add(_amount) > balances[_to]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126     balances[msg.sender] = balances[msg.sender].sub(_amount);
127     balances[_to] = balances[_to].add(_amount);
128     emit Transfer(msg.sender, _to, _amount);
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256 balance) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  */
149 contract StandardToken is ERC20, BasicToken {
150   
151   
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _amount uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
162     require(_to != address(0));
163     require(balances[_from] >= _amount);
164     require(allowed[_from][msg.sender] >= _amount);
165     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
166 
167     balances[_from] = balances[_from].sub(_amount);
168     balances[_to] = balances[_to].add(_amount);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
170     emit Transfer(_from, _to, _amount);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _amount The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _amount) public returns (bool success) {
185     allowed[msg.sender][_spender] = _amount;
186     emit Approval(msg.sender, _spender, _amount);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableToken is StandardToken, Ownable {
207 
208     event Burn(address indexed burner, uint256 value);
209 
210   /**
211    * @dev Burns a specific amount of tokens.
212    * @param _value The amount of token to be burned.
213    */
214 
215   function burn(uint256 _value) public {
216 
217     _burn(msg.sender, _value);
218 
219   }
220 
221   function _burn(address _who, uint256 _value) internal {
222 
223     require(_value <= balances[_who]);
224     // no need to require value <= totalSupply, since that would imply the
225     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
226     balances[_who] = balances[_who].sub(_value);
227     totalSupply = totalSupply.sub(_value);
228     emit Burn(_who, _value);
229     emit Transfer(_who, address(0), _value);
230   }
231 } 
232 
233 /**
234  * @title Mintable token
235  * @dev ERC20 token, with mintable token creation
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240     using SafeMath for uint256;
241 
242   mapping(address => uint256)public shares;
243   
244   address[] public beneficiaries;
245  
246   event Mint(address indexed to, uint256 amount);
247   event MintFinished();
248   event BeneficiariesAdded();
249   
250   uint256 public lastMintingTime;
251   uint256 public mintingStartTime = 1543622400;
252   uint256 public mintingThreshold = 31536000;
253   uint256 public lastMintedTokens = 91000000000000000;
254 
255   bool public mintingFinished = false;
256   
257   
258 
259   modifier canMint() {
260     require(!mintingFinished);
261     require(totalSupply < 910000000000000000);// Total minting has not yet been finished
262     require(beneficiaries.length == 7);//Check beneficiaries has been added
263     _;
264   }
265 
266   modifier hasMintPermission() {
267     require(msg.sender == owner);
268     _;
269   }
270 
271   /**
272    * @dev Function to mint tokens
273    * @return A boolean that indicates if the operation was successful.
274    */
275 
276   function mint() hasMintPermission  canMint public  returns (bool){
277     
278     uint256 _amount = tokensToMint();
279     
280     totalSupply = totalSupply.add(_amount);
281     
282     
283     for(uint8 i = 0; i<beneficiaries.length; i++){
284         
285         balances[beneficiaries[i]] = balances[beneficiaries[i]].add(_amount.mul(shares[beneficiaries[i]]).div(100));
286         emit Mint(beneficiaries[i], _amount.mul(shares[beneficiaries[i]]).div(100));
287         emit Transfer(address(0), beneficiaries[i], _amount.mul(shares[beneficiaries[i]]).div(100));
288     }
289     
290     lastMintingTime = now;
291     
292    
293      return true;
294   }
295   
296   //Return how much tokens will be minted as per algorithm. Each year 10% tokens will be reduced
297   function tokensToMint()private returns(uint256 _tokensToMint){
298       
299       uint8 tiersToBeMinted = currentTier() - getTierForLastMiniting();
300       
301       require(tiersToBeMinted>0);
302       
303       for(uint8 i = 0;i<tiersToBeMinted;i++){
304           _tokensToMint = _tokensToMint.add(lastMintedTokens.sub(lastMintedTokens.mul(10).div(100)));
305           lastMintedTokens = lastMintedTokens.sub(lastMintedTokens.mul(10).div(100));
306       }
307       
308       return _tokensToMint;
309       
310   }
311  
312   function currentTier()private view returns(uint8 _tier) {
313       
314       uint256 currentTime = now;
315       
316       uint256 nextTierStartTime = mintingStartTime;
317       
318       while(nextTierStartTime < currentTime) {
319           nextTierStartTime = nextTierStartTime.add(mintingThreshold);
320           _tier++;
321       }
322       
323       return _tier;
324       
325   }
326   
327   function getTierForLastMiniting()private view returns(uint8 _tier) {
328       
329        uint256 nextTierStartTime = mintingStartTime;
330       
331       while(nextTierStartTime < lastMintingTime) {
332           nextTierStartTime = nextTierStartTime.add(mintingThreshold);
333           _tier++;
334       }
335       
336       return _tier;
337       
338   }
339   
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345 
346   function finishMinting() onlyOwner canMint public returns (bool) {
347     mintingFinished = true;
348     emit MintFinished();
349     return true;
350   }
351 
352 
353 function beneficiariesPercentage(address[] _beneficiaries, uint256[] percentages) onlyOwner external returns(bool){
354    
355     require(_beneficiaries.length == 7);
356     require(percentages.length == 7);
357     
358     uint256 sumOfPercentages;
359     
360     if(beneficiaries.length>0) {
361         
362         for(uint8 j = 0;j<beneficiaries.length;j++) {
363             
364             shares[beneficiaries[j]] = 0;
365             delete beneficiaries[j];
366             
367             
368         }
369         beneficiaries.length = 0;
370         
371     }
372 
373     for(uint8 i = 0; i < _beneficiaries.length; i++){
374 
375       require(_beneficiaries[i] != 0x0);
376       require(percentages[i] > 0);
377       beneficiaries.push(_beneficiaries[i]);
378       
379       shares[_beneficiaries[i]] = percentages[i];
380       sumOfPercentages = sumOfPercentages.add(percentages[i]); 
381      
382     }
383 
384     require(sumOfPercentages == 100);
385     emit BeneficiariesAdded();
386     return true;
387   } 
388 }
389 
390 /**
391  * @title ERA Swap Token 
392  * @dev Token representing EST.
393  */
394  contract EraSwapToken is BurnableToken, MintableToken{
395      string public name ;
396      string public symbol ;
397      uint8 public decimals = 8 ;
398      
399      /**
400      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
401      */
402      function ()public payable {
403          revert();
404      }
405      
406      /**
407      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
408      * @param initialSupply The initial supply of tokens which will be fixed through out
409      * @param tokenName The name of the token
410      * @param tokenSymbol The symboll of the token
411      */
412      constructor (
413             uint256 initialSupply,
414             string tokenName,
415             string tokenSymbol
416          ) public {
417          totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
418          name = tokenName;
419          symbol = tokenSymbol;
420          balances[msg.sender] = totalSupply;
421          
422          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
423          emit Transfer(address(0), msg.sender, totalSupply);
424      }
425      
426      /**
427      *@dev helper method to get token details, name, symbol and totalSupply in one go
428      */
429     function getTokenDetail() public view returns (string, string, uint256) {
430 	    return (name, symbol, totalSupply);
431     }
432  }