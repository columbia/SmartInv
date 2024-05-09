1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
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
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     // uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return a / b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Ownable
119  * @dev The Ownable contract has an owner address, and provides basic authorization control
120  * functions, this simplifies the implementation of "user permissions".
121  */
122 contract Ownable {
123   address public owner;
124 
125   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127 
128   /**
129    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
130    * account.
131    */
132   function Ownable() public {
133     owner = msg.sender;
134   }
135 
136   /**
137    * @dev Throws if called by any account other than the owner.
138    */
139   modifier onlyOwner() {
140     require(msg.sender == owner);
141     _;
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) public onlyOwner {
149     require(newOwner != address(0));
150     OwnershipTransferred(owner, newOwner);
151     owner = newOwner;
152   }
153 
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(address _owner, address _spender) public view returns (uint256) {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Ownable {
259     
260   event Mint(address indexed to, uint256 amount);
261   event MintFinished();
262   event Burn(address indexed burner, uint indexed value);
263 
264   bool public mintingFinished = false;
265 
266 
267   modifier canMint() {
268     require(!mintingFinished);
269     _;
270   }
271   
272   /**
273    * @dev Burns a specific amount of tokens.
274    * @param _value The amount of token to be burned.
275    */
276   function burn(uint _value) public {
277     require(_value > 0);
278     address burner = msg.sender;
279     balances[burner] = balances[burner].sub(_value);
280     totalSupply_ = totalSupply_.sub(_value);
281     Burn(burner, _value);
282   }
283  
284 
285   /**
286    * @dev Function to mint tokens
287    * @param _to The address that will receive the minted tokens.
288    * @param _amount The amount of tokens to mint.
289    * @return A boolean that indicates if the operation was successful.
290    */
291   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
292     totalSupply_ = totalSupply_.add(_amount);
293     balances[_to] = balances[_to].add(_amount);
294     Mint(_to, _amount);
295     Transfer(address(0), _to, _amount);
296     return true;
297   }
298 
299   /**
300    * @dev Function to stop minting new tokens.
301    * @return True if the operation was successful.
302    */
303   function finishMinting() onlyOwner canMint public returns (bool) {
304     mintingFinished = true;
305     MintFinished();
306     return true;
307   }
308 }
309 
310 contract GeniusEther is MintableToken {
311     
312     string public constant name = "Bar Coin2";
313     
314     string public constant symbol = "BarCoin2";
315     
316     uint32 public constant decimals = 18;
317     
318 }
319 
320 contract bar is GeniusEther {
321     
322     using SafeMath for uint;
323     
324     address multisig;
325 
326     GeniusEther public token = new GeniusEther();
327 
328     uint start;
329     uint stop;
330     uint period;
331     uint hardcap;
332     uint softcap;
333     bool breco;
334 
335     function bar() {
336 	multisig = 0x2c9660f30B65dbBfd6540d252f6Fa07B5854a40f;
337 	start = 1523185200;
338 	stop =  1523186700;
339     hardcap = 0.1 ether;
340     softcap = 0.005 ether; 
341     breco =false;
342     }
343 
344     modifier saleIsOn() {
345     	require(now >= start && now < stop);
346     	_;
347     }
348 	
349     modifier isUnderHardCap() {
350         require(this.balance <= hardcap);
351         _;
352     }
353 
354     function finish() public onlyOwner {
355 	uint issuedTokenSupply = token.totalSupply();
356 	uint restrictedTokens = issuedTokenSupply.mul(30).div(70);
357 	if (now >= stop && this.balance>softcap) {
358 	    token.mint(multisig, restrictedTokens);
359         token.finishMinting();
360         multisig.transfer(this.balance); }
361     if (now >= stop && this.balance<=softcap) {
362 	    breco=true; }
363 	}
364 	
365    function Reco() {
366        uint256 bal;
367        if (breco=true) {
368         bal= token.balanceOf(msg.sender);
369         token.burn(bal);
370         msg.sender.transfer(bal);    
371        }
372     }	
373 
374    function createTokens() isUnderHardCap saleIsOn payable {
375        
376        if (msg.value< 0.0001 ether) {
377         msg.sender.transfer(msg.value);    
378        }
379        else {
380         token.mint(msg.sender, msg.value);
381         }
382     }
383 
384     function() external payable {
385         if (now >= start && now <= stop) {createTokens(); }
386         if (now < start) {msg.sender.transfer(msg.value);}
387         if (now > stop && breco==true) {Reco();}
388     }
389     
390 }