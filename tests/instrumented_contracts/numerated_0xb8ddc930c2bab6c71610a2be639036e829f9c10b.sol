1 pragma solidity 0.4.24;
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
152         require(balances[msg.sender] >= _value);      
153         balances[msg.sender] -= _value;
154         balances[_to] += _value;
155         emit Transfer(msg.sender, _to, _value);
156         return true;
157       
158     }
159  
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
161     	require(balances[msg.sender] >= _value); 
162     	require(allowed[_from][msg.sender] >= _value); 
163         balances[_to] += _value;
164         balances[_from] -= _value;
165         allowed[_from][msg.sender] -= _value;
166         emit Transfer(_from, _to, _value);
167         return true;
168       
169     }
170  
171     function balanceOf(address _owner) public view returns (uint256 balance) {
172         return balances[_owner];
173     }
174  
175     function approve(address _spender, uint256 _value) public returns (bool success) {
176         require(_value == 0 || allowed[msg.sender][_spender] == 0);
177         allowed[msg.sender][_spender] = _value;
178         emit Approval(msg.sender, _spender, _value);
179         return true;
180     }
181  
182     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
183       return allowed[_owner][_spender];
184     }
185  
186     mapping (address => uint256) public balances;
187     mapping (address => mapping (address => uint256)) public allowed;
188 }
189 
190 contract BurnableToken is StandardToken, Ownable {
191 
192     event Burn(address indexed burner, uint256 amount);
193 
194     /**
195     * @dev Anybody can burn a specific amount of their tokens.
196     * @param _amount The amount of token to be burned.
197     */
198     function burn(uint256 _amount) public {
199         require(_amount > 0);
200         require(_amount <= balances[msg.sender]);
201         // no need to require _amount <= totalSupply, since that would imply the
202         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
203 
204         address burner = msg.sender;
205         balances[burner] = SafeMath.sub(balances[burner],_amount);
206         totalSupply = SafeMath.sub(totalSupply,_amount);
207         emit Transfer(burner, address(0), _amount);
208         emit Burn(burner, _amount);
209     }
210 
211     /**
212     * @dev Owner can burn a specific amount of tokens of other token holders.
213     * @param _from The address of token holder whose tokens to be burned.
214     * @param _amount The amount of token to be burned.
215     */
216     function burnFrom(address _from, uint256 _amount) onlyOwner public {
217         require(_from != address(0));
218         require(_amount > 0);
219         require(_amount <= balances[_from]);
220         balances[_from] = SafeMath.sub(balances[_from],_amount);
221         totalSupply = SafeMath.sub(totalSupply,_amount);
222         emit Transfer(_from, address(0), _amount);
223         emit Burn(_from, _amount);
224     }
225 
226 }
227 
228 contract KWHPausableToken is StandardToken, Pausable,BurnableToken {
229 
230   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
231     return super.transfer(_to, _value);
232   }
233 
234   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
235     return super.transferFrom(_from, _to, _value);
236   }
237 
238   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
239     return super.approve(_spender, _value);
240   }
241 
242  
243 }
244 
245 contract KWHToken is KWHPausableToken {
246  using SafeMath for uint;
247     // metadata
248     string public constant name = "KWHCoin";
249     string public constant symbol = "KWH";
250     string public version = "2.0";
251     uint256 public constant decimals = 18;
252     
253    	address private ethFundDeposit;       
254 	address private escrowFundDeposit;
255 		    	
256 	uint256 public icoTokenExchangeRate = 715; // 715 tokens per 1 ETH
257 	uint256 public tokenCreationCap =  3000 * (10**6) * 10**decimals;  
258 	
259 	//address public ;
260 	// crowdsale parameters
261     	bool public tokenSaleActive;              // switched to true in operational state
262 	bool public haltIco;
263 	bool public dead = false;
264 
265  
266     // events 
267     event CreateToken(address indexed _to, uint256 _value);
268     event Transfer(address from, address to, uint256 value);
269     
270     // constructor
271     constructor (		
272        	address _ethFundDeposit,
273        	address _escrowFundDeposit
274 		
275 		
276         	) public {
277         	
278 		tokenSaleActive = true;                   
279 		haltIco = true;
280 		paused = true;
281 			
282 		require(_ethFundDeposit != address(0));
283 		require(_escrowFundDeposit != address(0));
284 		
285 		ethFundDeposit = _ethFundDeposit;
286 		escrowFundDeposit=_escrowFundDeposit;
287 		balances[escrowFundDeposit] = tokenCreationCap;
288 		totalSupply = tokenCreationCap;
289 		emit CreateToken(escrowFundDeposit, totalSupply);
290 		
291     }
292 	
293     /// @dev Accepts ether and creates new tge tokens.
294     function createTokens() payable external {
295       if (!tokenSaleActive) 
296         revert();
297       if (haltIco) 
298 	revert();	  
299       if (msg.value == 0) 
300         revert();
301         
302       uint256 tokens;
303       tokens = SafeMath.mul(msg.value, icoTokenExchangeRate); // check that we're not over totals
304       uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
305  
306       // return money if something goes wrong
307       if (tokenCreationCap < checkedSupply) 
308         revert();  // odd fractions won't be found
309  
310       totalSupply = checkedSupply;
311       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
312       emit CreateToken(msg.sender, tokens);  // logs token creation
313     }  
314     
315     function setIcoTokenExchangeRate (uint _icoTokenExchangeRate) onlyOwner external {		
316     	icoTokenExchangeRate = _icoTokenExchangeRate;            
317     }        
318     
319     function setHaltIco(bool _haltIco) onlyOwner external {
320 	haltIco = _haltIco;            
321     }	
322     
323      /// @dev Ends the funding period and sends the ETH home
324     function sendFundHome() onlyOwner external {  // move to operational
325       if (!ethFundDeposit.send(address(this).balance)) 
326         revert();  // send the eth to tge International
327     } 
328 	
329     function sendFundHomeAmt(uint _amt) onlyOwner external {
330       if (!ethFundDeposit.send(_amt*10**decimals)) 
331         revert();  // send the eth to tge International
332     }    
333     
334       function toggleDead()
335           external
336           onlyOwner
337           returns (bool)
338         {
339           dead = !dead;
340       }
341      
342         function endIco() onlyOwner external { // end ICO
343           // ensure that sale is active. is set to false at the end. can only be performed once.
344               require(tokenSaleActive == true);
345                tokenSaleActive=false;
346         }  
347     
348       
349 }