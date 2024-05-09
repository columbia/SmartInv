1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two numbers, throws on overflow.
6      **/
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     
16     /**
17      * @dev Integer division of two numbers, truncating the quotient.
18      **/
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     
30     /**
31      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      **/
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37     
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      **/
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  **/
53  
54 contract Ownable {
55     address public owner;
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
60      **/
61    constructor() public {
62       owner = msg.sender;
63     }
64     
65     /**
66      * @dev Throws if called by any account other than the owner.
67      **/
68     modifier onlyOwner() {
69       require(msg.sender == owner);
70       _;
71     }
72     
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      **/
77     function transferOwnership(address newOwner) public onlyOwner {
78       require(newOwner != address(0));
79       emit OwnershipTransferred(owner, newOwner);
80       owner = newOwner;
81     }
82 }
83 
84 contract Contactable is Ownable {
85 
86     string public contactInformation;
87 
88     /**
89      * @dev Allows the owner to set a string with their contact information.
90      * @param info The contact information to attach to the contract.
91      */
92     function setContactInformation(string info) onlyOwner
93     {
94          contactInformation = info;
95     }
96 }
97 
98 contract Destructible is Ownable {
99 
100   function Destructible() payable
101   {
102 
103   }
104 
105   /**
106    * @dev Transfers the current balance to the owner and terminates the contract.
107    */
108   function destroy() onlyOwner
109   {
110     selfdestruct(owner);
111   }
112 
113   function destroyAndSend(address _recipient) onlyOwner
114   {
115     selfdestruct(_recipient);
116   }
117 }
118 
119 contract Pausable is Ownable {
120   event Pause();
121   event Unpause();
122 
123   bool public paused = false;
124 
125 
126   /**
127    * @dev modifier to allow actions only when the contract IS paused
128    */
129   modifier whenNotPaused() {
130     require(!paused);
131     _;
132   }
133 
134   /**
135    * @dev modifier to allow actions only when the contract IS NOT paused
136    */
137   modifier whenPaused() {
138     require(paused);
139     _;
140   }
141 
142   /**
143    * @dev called by the owner to pause, triggers stopped state
144    */
145   function pause() onlyOwner whenNotPaused
146   {
147     paused = true;
148     Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused
155   {
156     paused = false;
157     Unpause();
158   }
159 }
160 
161 /**
162  * @title ERC20Basic interface
163  * @dev Basic ERC20 interface
164  **/
165 contract ERC20Basic {
166     function totalSupply() public view returns (uint256);
167     function balanceOf(address who) public view returns (uint256);
168     function transfer(address to, uint256 value) public returns (bool);
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 }
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  **/
176 contract ERC20 is ERC20Basic {
177     function allowance(address owner, address spender) public view returns (uint256);
178     function transferFrom(address from, address to, uint256 value) public returns (bool);
179     function approve(address spender, uint256 value) public returns (bool);
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 /**
184  * @title Basic token
185  * @dev Basic version of StandardToken, with no allowances.
186  **/
187 contract BasicToken is ERC20Basic {
188     using SafeMath for uint256;
189     mapping(address => uint256) balances;
190     uint256 totalSupply_;
191     
192     /**
193      * @dev total number of tokens in existence
194      **/
195     function totalSupply() public view returns (uint256) {
196         return totalSupply_;
197     }
198     
199     /**
200      * @dev transfer token for a specified address
201      * @param _to The address to transfer to.
202      * @param _value The amount to be transferred.
203      **/
204     function transfer(address _to, uint256 _value) public returns (bool) {
205         require(_to != address(0));
206         require(_value <= balances[msg.sender]);
207         
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         emit Transfer(msg.sender, _to, _value);
211         return true;
212     }
213     
214     /**
215      * @dev Gets the balance of the specified address.
216      * @param _owner The address to query the the balance of.
217      * @return An uint256 representing the amount owned by the passed address.
218      **/
219     function balanceOf(address _owner) public view returns (uint256) {
220         return balances[_owner];
221     }
222 }
223 
224 contract StandardToken is ERC20, BasicToken {
225     mapping (address => mapping (address => uint256)) internal allowed;
226     /**
227      * @dev Transfer tokens from one address to another
228      * @param _from address The address which you want to send tokens from
229      * @param _to address The address which you want to transfer to
230      * @param _value uint256 the amount of tokens to be transferred
231      **/
232     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233         require(_to != address(0));
234         require(_value <= balances[_from]);
235         require(_value <= allowed[_from][msg.sender]);
236     
237         balances[_from] = balances[_from].sub(_value);
238         balances[_to] = balances[_to].add(_value);
239         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240         
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244     
245     /**
246      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247      *
248      * Beware that changing an allowance with this method brings the risk that someone may use both the old
249      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      * @param _spender The address which will spend the funds.
253      * @param _value The amount of tokens to be spent.
254      **/
255     function approve(address _spender, uint256 _value) public returns (bool) {
256         allowed[msg.sender][_spender] = _value;
257         emit Approval(msg.sender, _spender, _value);
258         return true;
259     }
260     
261     /**
262      * @dev Function to check the amount of tokens that an owner allowed to a spender.
263      * @param _owner address The address which owns the funds.
264      * @param _spender address The address which will spend the funds.
265      * @return A uint256 specifying the amount of tokens still available for the spender.
266      **/
267     function allowance(address _owner, address _spender) public view returns (uint256) {
268         return allowed[_owner][_spender];
269     }
270     
271     /**
272      * @dev Increase the amount of tokens that an owner allowed to a spender.
273      *
274      * approve should be called when allowed[_spender] == 0. To increment
275      * allowed value is better to use this function to avoid 2 calls (and wait until
276      * the first transaction is mined)
277      * From MonolithDAO Token.sol
278      * @param _spender The address which will spend the funds.
279      * @param _addedValue The amount of tokens to increase the allowance by.
280      **/
281     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284         return true;
285     }
286     
287     /**
288      * @dev Decrease the amount of tokens that an owner allowed to a spender.
289      *
290      * approve should be called when allowed[_spender] == 0. To decrement
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From MonolithDAO Token.sol
294      * @param _spender The address which will spend the funds.
295      * @param _subtractedValue The amount of tokens to decrease the allowance by.
296      **/
297     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298         uint oldValue = allowed[msg.sender][_spender];
299         if (_subtractedValue > oldValue) {
300             allowed[msg.sender][_spender] = 0;
301         } else {
302             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303         }
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 }
308 
309 
310 /**
311  * @title Configurable
312  * @dev Configurable varriables of the contract
313  **/
314 contract Configurable {
315     uint256 public constant cap = 21000000*10**18;
316     uint256 public constant basePrice = 190*10**18; // tokens per 1 ether
317     uint256 public tokensSold = 0;
318     
319     uint256 public constant tokenReserve = 21000000*10**18;
320     uint256 public remainingTokens = 0;
321 }
322 
323 /**
324  * @title CrowdsaleToken 
325  * @dev Contract to preform crowd sale with token
326  **/
327 contract CrowdsaleToken is StandardToken, Configurable, Ownable, Pausable, Destructible, Contactable {
328     /**
329      * @dev enum of current crowd sale state
330      **/
331      enum Stages {
332         none,
333         icoStart, 
334         icoEnd
335     }
336     
337     Stages currentStage;
338   
339     /**
340      * @dev constructor of CrowdsaleToken
341      **/
342     constructor() public {
343         currentStage = Stages.none;
344         balances[owner] = balances[owner].add(tokenReserve);
345         totalSupply_ = totalSupply_.add(tokenReserve);
346         remainingTokens = cap;
347         emit Transfer(address(this), owner, tokenReserve);
348     }
349     
350     /**
351      * @dev fallback function to send ether to for Crowd sale
352      **/
353     function () public payable {
354         require(currentStage == Stages.icoStart);
355         require(msg.value > 0);
356         require(remainingTokens > 0);
357         
358         
359         uint256 weiAmount = msg.value; // Calculate tokens to sell
360         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
361         uint256 returnWei = 0;
362         
363         if(tokensSold.add(tokens) > cap){
364             uint256 newTokens = cap.sub(tokensSold);
365             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
366             returnWei = weiAmount.sub(newWei);
367             weiAmount = newWei;
368             tokens = newTokens;
369         }
370         
371         tokensSold = tokensSold.add(tokens); // Increment raised amount
372         remainingTokens = cap.sub(tokensSold);
373         if(returnWei > 0){
374             msg.sender.transfer(returnWei);
375             emit Transfer(address(this), msg.sender, returnWei);
376         }
377         
378         balances[msg.sender] = balances[msg.sender].add(tokens);
379         emit Transfer(address(this), msg.sender, tokens);
380         totalSupply_ = totalSupply_.add(tokens);
381         owner.transfer(weiAmount);// Send money to owner
382     }
383     
384 
385     /**
386      * @dev startIco starts the public ICO
387      **/
388     function startIco() public onlyOwner {
389         require(currentStage != Stages.icoEnd);
390         currentStage = Stages.icoStart;
391     }
392     
393 
394     /**
395      * @dev endIco closes down the ICO 
396      **/
397     function endIco() internal {
398         currentStage = Stages.icoEnd;
399         // Transfer any remaining tokens
400         if(remainingTokens > 0)
401             balances[owner] = balances[owner].add(remainingTokens);
402         // transfer any remaining ETH balance in the contract to the owner
403         owner.transfer(address(this).balance); 
404     }
405 
406     /**
407      * @dev finalizeIco closes down the ICO and sets needed varriables
408      **/
409     function finalizeIco() public onlyOwner {
410         require(currentStage != Stages.icoEnd);
411         endIco();
412     }
413     
414 }
415 
416 /**
417  * @title SNBTOKEN 
418  * @dev Contract to create the SNBTOKEN
419  **/
420 contract SNBTOKEN is CrowdsaleToken {
421     string public constant name = "SNBTOKEN";
422     string public constant symbol = "SNB";
423     uint32 public constant decimals = 18;
424 }