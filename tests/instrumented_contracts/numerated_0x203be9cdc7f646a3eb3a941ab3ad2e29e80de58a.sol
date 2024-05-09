1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 library Math {
58   function max(uint a, uint b) pure internal returns (uint) {
59     if (a > b) return a;
60     else return b;
61   }
62   function min(uint a, uint b) pure internal returns (uint) {
63     if (a < b) return a;
64     else return b;
65   }
66 }
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
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191   address public owner;
192 
193 
194   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196 
197   /**
198    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199    * account.
200    */
201   function Ownable() public {
202     owner = msg.sender;
203   }
204 
205 
206   /**
207    * @dev Throws if called by any account other than the owner.
208    */
209   modifier onlyOwner() {
210     require(msg.sender == owner);
211     _;
212   }
213 
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param newOwner The address to transfer ownership to.
218    */
219   function transferOwnership(address newOwner) public onlyOwner {
220     require(newOwner != address(0));
221     OwnershipTransferred(owner, newOwner);
222     owner = newOwner;
223   }
224 
225 }
226 
227 /**
228  * @title Mintable token
229  * @dev Simple ERC20 Token example, with mintable token creation
230  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
232  */
233 
234 contract MintableToken is StandardToken, Ownable {
235   event Mint(address indexed to, uint256 amount);
236   event MintFinished();
237 
238   bool public mintingFinished = false;
239 
240 
241   modifier canMint() {
242     require(!mintingFinished);
243     _;
244   }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
253     totalSupply = totalSupply.add(_amount);
254     balances[_to] = balances[_to].add(_amount);
255     Mint(_to, _amount);
256     Transfer(address(0), _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264   function finishMinting() onlyOwner canMint public returns (bool) {
265     mintingFinished = true;
266     MintFinished();
267     return true;
268   }
269 }
270 
271 //---------------------------------------------------------------------------------
272 
273 contract BuronCoin is MintableToken {
274     
275     string public constant name = "Buron Coin";
276     
277     string public constant symbol = "BURC";
278     
279     uint32 public constant decimals = 4;
280     
281 }
282 
283 contract Crowdsale is Ownable {
284     
285 	struct tier {
286         uint cap;
287         uint rate;
288     }
289 	
290     using SafeMath for uint;
291 	using Math for uint;
292     
293 	BuronCoin public token = new BuronCoin();
294 	
295     address multisig; 		
296 	uint restrictedAmount; 	
297     address restricted;		
298 	uint price;				
299 	bool saleOn;		
300 	uint public sold;	
301     
302 	tier[7] tiers; 
303   
304 	function bytesToAddress(bytes source) internal pure returns(address) {
305 		uint result;
306 		uint mul = 1;
307 		for(uint i = 20; i > 0; i--) {
308 		  result += uint8(source[i-1])*mul;
309 		  mul = mul*256;
310 		}
311 		return address(result);
312 	}
313   
314     function Crowdsale(address _multisig, address _restricted) public {
315         multisig = _multisig;
316         restricted = _restricted;
317 		restrictedAmount=231000000000; 		
318         price = 17700000000; 
319 		
320 		tiers[0]=tier(10000000000,50);
321 		tiers[1]=tier(30000000000,30);
322 		tiers[2]=tier(60000000000,25);
323 		tiers[3]=tier(110000000000,20);
324 		tiers[4]=tier(190000000000,15);
325 		tiers[5]=tier(320000000000,10);
326 		tiers[6]=tier(530000000000,5);
327 		
328 		sold=0;
329 		saleOn=true;
330 		
331 		token.mint(restricted, restrictedAmount);	
332     }
333 
334     modifier saleIsOn() {
335     	require(saleOn && sold<tiers[6].cap);
336     	_;
337     }
338 	
339     function buyTokens(address to, address referer) public saleIsOn payable {
340 		require(msg.value>0);
341 	
342 		if (to==address(0x0))
343 			to=msg.sender;
344 	
345         multisig.transfer(msg.value);	
346 		
347 		
348         uint tokensBase = msg.value.div(price);
349 		
350 		uint tokensForBonus=tokensBase;
351 		uint tmpSold=sold;
352 		uint currentTier=0;
353 		uint bonusTokens=0;
354 		
355 		
356 		while(tiers[currentTier].cap<tmpSold)
357 			currentTier++;
358 		
359 		uint currentTierTokens=0;
360 		while((tokensForBonus>0) && (currentTier<7))
361 		{
362 			currentTierTokens=Math.min(tiers[currentTier].cap.sub(tmpSold), tokensForBonus); 		
363 			bonusTokens=bonusTokens.add(currentTierTokens.mul(tiers[currentTier].rate).div(100));   
364 			tmpSold=tmpSold.add(currentTierTokens);									   			
365 			
366 			tokensForBonus=tokensForBonus.sub(currentTierTokens);					   			
367 			currentTier++;
368 		}
369 		
370 		
371 		token.mint(to, tokensBase.add(bonusTokens));  						   			
372 		sold=sold.add(tokensBase);											   		
373 		
374 	
375 		if (referer != address(0x0))
376 		if (referer != msg.sender)	
377 		{
378 		  uint refererTokens = tokensBase.mul(3).div(100);	
379 		  token.mint(referer, refererTokens);				
380 		}		
381 		
382 		if (sold>=tiers[6].cap)													   	  
383 		{
384 			saleOn=false;
385 			token.finishMinting();
386 		}
387     }
388 	
389     function() external payable {
390 		
391 		
392 		address referer;
393 		if(msg.data.length == 20)
394 			referer = bytesToAddress(bytes(msg.data));
395 		else
396 			referer=address(0x0);
397 			
398         buyTokens(address(0x0), referer);
399     }
400 }