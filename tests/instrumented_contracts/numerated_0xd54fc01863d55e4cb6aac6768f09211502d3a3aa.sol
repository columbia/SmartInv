1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     emit Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     emit Unpause();
130   }
131 }
132 
133 
134 
135 contract Token {
136     uint256 public totalSupply;
137     function balanceOf(address _owner) public view returns (uint256 balance);
138     function transfer(address _to, uint256 _value) public returns (bool success);
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
140     function approve(address _spender, uint256 _value) public returns (bool success);
141     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
142     event Transfer(address indexed _from, address indexed _to, uint256 _value);
143     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
144 }
145 
146 /**
147  * @title Reference implementation of the ERC220 standard token.
148  */
149 contract StandardToken is Token {
150  
151     function transfer(address _to, uint256 _value) public returns (bool success) {
152       if (balances[msg.sender] >= _value && _value > 0) {
153         balances[msg.sender] -= _value;
154         balances[_to] += _value;
155         emit Transfer(msg.sender, _to, _value);
156         return true;
157       } else {
158         return false;
159       }
160     }
161  
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
163       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
164         balances[_to] += _value;
165         balances[_from] -= _value;
166         allowed[_from][msg.sender] -= _value;
167         emit Transfer(_from, _to, _value);
168         return true;
169       } else {
170         return false;
171       }
172     }
173  
174     function balanceOf(address _owner) public view returns (uint256 balance) {
175         return balances[_owner];
176     }
177  
178     function approve(address _spender, uint256 _value) public returns (bool success) {
179         require(_value == 0 || allowed[msg.sender][_spender] == 0);
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184  
185     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
186       return allowed[_owner][_spender];
187     }
188  
189     mapping (address => uint256) balances;
190     mapping (address => mapping (address => uint256)) allowed;
191 }
192 
193 contract BurnableToken is StandardToken, Ownable {
194 
195     event Burn(address indexed burner, uint256 amount);
196 
197     /**
198     * @dev Anybody can burn a specific amount of their tokens.
199     * @param _amount The amount of token to be burned.
200     */
201     function burn(uint256 _amount) public {
202         require(_amount > 0);
203         require(_amount <= balances[msg.sender]);
204         // no need to require _amount <= totalSupply, since that would imply the
205         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
206 
207         address burner = msg.sender;
208         balances[burner] = SafeMath.sub(balances[burner],_amount);
209         totalSupply = SafeMath.sub(totalSupply,_amount);
210         emit Transfer(burner, address(0), _amount);
211         emit Burn(burner, _amount);
212     }
213 
214     /**
215     * @dev Owner can burn a specific amount of tokens of other token holders.
216     * @param _from The address of token holder whose tokens to be burned.
217     * @param _amount The amount of token to be burned.
218     */
219     function burnFrom(address _from, uint256 _amount) onlyOwner public {
220         require(_from != address(0));
221         require(_amount > 0);
222         require(_amount <= balances[_from]);
223         balances[_from] = SafeMath.sub(balances[_from],_amount);
224         totalSupply = SafeMath.sub(totalSupply,_amount);
225         emit Transfer(_from, address(0), _amount);
226         emit Burn(_from, _amount);
227     }
228 
229 }
230 
231 contract BCWPausableToken is StandardToken, Pausable,BurnableToken {
232 
233   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transfer(_to, _value);
235   }
236 
237   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
242     return super.approve(_spender, _value);
243   }
244 
245  
246 }
247 
248 contract BCWToken is BCWPausableToken {
249  using SafeMath for uint;
250     // metadata
251     string public constant name = "BcwWolfCoin";
252     string public constant symbol = "BCW";
253     uint256 public constant decimals = 18;
254     
255    	address private ethFundDeposit;       
256 		
257 		    	
258 	uint256 public icoTokenExchangeRate = 715; // 715 b66 tokens per 1 ETH
259 	uint256 public tokenCreationCap =  350 * (10**6) * 10**decimals;  
260 	
261 	//address public ;
262 	// crowdsale parameters
263     	bool public tokenSaleActive;              // switched to true in operational state
264 		bool public airdropActive;
265 	bool public haltIco;
266 	bool public dead = false;
267 
268  
269     // events 
270     event CreateToken(address indexed _to, uint256 _value);
271     event Transfer(address from, address to, uint256 value);
272     
273     // constructor
274     constructor (		
275        	address _ethFundDeposit
276 		
277 		
278         	) public {
279         	
280 		tokenSaleActive = true;                   
281 		haltIco = true;
282 		paused = true;
283 		airdropActive = true;	
284 		require(_ethFundDeposit != address(0));
285 		
286 		uint256  _tokenCreationCap =tokenCreationCap-150 * (10**6) * 10**decimals;
287 		ethFundDeposit = _ethFundDeposit;
288 		balances[ethFundDeposit] = _tokenCreationCap;
289 		totalSupply = _tokenCreationCap;
290 		emit CreateToken(ethFundDeposit, totalSupply);
291 		
292 		
293     }
294 	
295     /// @dev Accepts ether and creates new tge tokens.
296     function createTokens() payable external {
297       if (!tokenSaleActive) 
298         revert();
299       if (haltIco) 
300 	revert();	  
301       if (msg.value == 0) 
302         revert();
303         
304       uint256 tokens;
305       tokens = SafeMath.mul(msg.value, icoTokenExchangeRate); // check that we're not over totals
306       uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
307  
308       // return money if something goes wrong
309       if (tokenCreationCap < checkedSupply) 
310         revert();  // odd fractions won't be found
311  
312       totalSupply = checkedSupply;
313       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
314       emit CreateToken(msg.sender, tokens);  // logs token creation
315     }  
316 	 
317 	
318     function mint(address _privSaleAddr,uint _privFundAmt) onlyOwner external {
319          require(airdropActive == true);
320 	  uint256 privToken = _privFundAmt*10**decimals;
321           uint256 checkedSupply = SafeMath.add(totalSupply, privToken);     
322           // return money if something goes wrong
323           if (tokenCreationCap < checkedSupply) 
324             revert();  // odd fractions won't be found     
325           totalSupply = checkedSupply;
326           balances[_privSaleAddr] += privToken;  // safeAdd not needed; bad semantics to use here		  
327           emit CreateToken (_privSaleAddr, privToken);  // logs token creation
328     }  
329     
330     function setIcoTokenExchangeRate (uint _icoTokenExchangeRate) onlyOwner external {		
331     	icoTokenExchangeRate = _icoTokenExchangeRate;            
332     }        
333     
334     function setHaltIco(bool _haltIco) onlyOwner external {
335 	haltIco = _haltIco;            
336     }	
337     
338      /// @dev Ends the funding period and sends the ETH home
339     function sendFundHome() onlyOwner external {  // move to operational
340       if (!ethFundDeposit.send(address(this).balance)) 
341         revert();  // send the eth to tge International
342     } 
343 	
344     function sendFundHomeAmt(uint _amt) onlyOwner external {
345       if (!ethFundDeposit.send(_amt*10**decimals)) 
346         revert();  // send the eth to tge International
347     }    
348     
349       function toggleDead()
350           external
351           onlyOwner
352           returns (bool)
353         {
354           dead = !dead;
355       }
356      
357         function endIco() onlyOwner external { // end ICO
358           // ensure that sale is active. is set to false at the end. can only be performed once.
359               require(tokenSaleActive == true);
360                tokenSaleActive=false;
361         }  
362 		
363 		function endAirdrop() onlyOwner external { // end ICO
364           // ensure that sale is active. is set to false at the end. can only be performed once.
365               require(airdropActive == true);
366                airdropActive=false;
367         }  
368     
369       
370 }