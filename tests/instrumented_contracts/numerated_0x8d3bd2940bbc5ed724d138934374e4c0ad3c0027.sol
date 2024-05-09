1 pragma solidity 0.4.19;
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
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is Ownable {
82   event Pause();
83   event Unpause();
84 
85   bool public paused = false;
86 
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is not paused.
90    */
91   modifier whenNotPaused() {
92     require(!paused);
93     _;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is paused.
98    */
99   modifier whenPaused() {
100     require(paused);
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107   function pause() onlyOwner whenNotPaused public {
108     paused = true;
109     Pause();
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() onlyOwner whenPaused public {
116     paused = false;
117     Unpause();
118   }
119 }
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127     /// Total amount of tokens
128   uint256 public totalSupply;
129   
130   function balanceOf(address _owner) public view returns (uint256 balance);
131   
132   function transfer(address _to, uint256 _amount) public returns (bool success);
133   
134   event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
143   
144   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
145   
146   function approve(address _spender, uint256 _amount) public returns (bool success);
147   
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 /**
152  * @title Basic token
153  * @dev Basic version of StandardToken, with no allowances.
154  */
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   //balance in each address account
159   mapping(address => uint256) balances;
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _amount The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _amount) public returns (bool success) {
167     require(_to != address(0));
168     require(balances[msg.sender] >= _amount && _amount > 0
169         && balances[_to].add(_amount) > balances[_to]);
170 
171     // SafeMath.sub will throw if there is not enough balance.
172     balances[msg.sender] = balances[msg.sender].sub(_amount);
173     balances[_to] = balances[_to].add(_amount);
174     Transfer(msg.sender, _to, _amount);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256 balance) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  */
195 contract StandardToken is ERC20, BasicToken {
196   
197   
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _amount uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
208     require(_to != address(0));
209     require(balances[_from] >= _amount);
210     require(allowed[_from][msg.sender] >= _amount);
211     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
212 
213     balances[_from] = balances[_from].sub(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
216     Transfer(_from, _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _amount The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _amount) public returns (bool success) {
231     allowed[msg.sender][_spender] = _amount;
232     Approval(msg.sender, _spender, _amount);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
243     return allowed[_owner][_spender];
244   }
245 
246 }
247 
248 
249 /**
250  * @title Mintable token
251  * @dev Simple ERC20 Token example, with mintable token creation
252  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
253  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
254  */
255 contract MintableToken is StandardToken, Ownable {
256   event Mint(address indexed to, uint256 amount);
257   event MintFinished();
258 
259   bool public mintingFinished = false;
260 
261   //To keep track of minted token count
262   uint256 mintedTokens;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * Total miniting cannot be greater than 15% of initial total supply
273    * @param _to The address that will receive the minted tokens.
274    * @param _amount The amount of tokens to mint.
275    * @return A boolean that indicates if the operation was successful.
276    */
277   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
278     
279     uint256 initialTotalSupply = totalSupply.sub(mintedTokens);
280     
281     //To check miniting of tokens should not exceed 15% of initialTotalSupply
282     require(initialTotalSupply.mul(15).div(100) > mintedTokens.add(_amount));    
283    
284     totalSupply = totalSupply.add(_amount);
285     
286     balances[_to] = balances[_to].add(_amount);
287     Mint(_to, _amount);
288     Transfer(address(0), _to, _amount);
289     return true;
290   }
291 
292   /**
293    * @dev Function to stop minting new tokens.
294    * @return True if the operation was successful.
295    */
296   function finishMinting() onlyOwner canMint public returns (bool) {
297     mintingFinished = true;
298     MintFinished();
299     return true;
300   }
301 }
302 
303 /**
304  * @title TRANX Token
305  * @dev Token representing TRANX.
306  */
307  contract TRANXToken is MintableToken, Pausable {
308      string public name ;
309      string public symbol ;
310      uint8 public decimals = 18 ;
311      
312      /**
313      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
314      */
315      function ()public payable {
316          revert();
317      }
318      
319      /**
320      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
321      * @param initialSupply The initial supply of tokens which will be fixed through out
322      * @param tokenName The name of the token
323      * @param tokenSymbol The symboll of the token
324      */
325      function TRANXToken(
326             uint256 initialSupply,
327             string tokenName,
328             string tokenSymbol
329          ) public {
330          totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
331          name = tokenName;
332          symbol = tokenSymbol;
333          balances[msg.sender] = totalSupply;
334          
335          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
336          Transfer(address(0), msg.sender, totalSupply);
337      }
338      
339      /**
340      *@dev helper method to get token details, name, symbol and totalSupply in one go
341      */
342     function getTokenDetail() public view returns (string, string, uint256) {
343 	    return (name, symbol, totalSupply);
344     }
345     
346      function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
347     return super.transfer(_to, _value);
348   }
349 
350   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
351     return super.transferFrom(_from, _to, _value);
352   }
353 
354   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
355     return super.approve(_spender, _value);
356   }
357   
358     function mint(address _to, uint256 _amount)  public whenNotPaused returns (bool) {
359     return super.mint(_to, _amount);
360   }
361 
362   
363  }