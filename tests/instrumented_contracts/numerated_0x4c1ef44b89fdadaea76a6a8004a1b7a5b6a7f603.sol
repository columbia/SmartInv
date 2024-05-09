1 pragma solidity ^ 0.4.19;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9     event OwnershipTransferred(
10         address indexed previousOwner,
11         address indexed newOwner
12     );
13 
14     /**
15   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16   * account.
17   */
18     function Ownable()public {
19         owner = msg.sender;
20     }
21     /**
22   * @dev Throws if called by any account other than the owner.
23   */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28     /**
29   * @dev Allows the current owner to transfer control of the contract to a newOwner.
30   * @param newOwner The address to transfer ownership to.
31   */
32     function transferOwnership(address newOwner)public onlyOwner {
33         require(newOwner != address(0));
34         emit OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36     }
37 }
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43     function mul(uint256 a, uint256 b)internal pure returns(uint256) {
44         uint256 c = a * b;
45         assert(a == 0 || c / a == b);
46         return c;
47     }
48     function div(uint256 a, uint256 b)internal pure returns(uint256) {
49         assert(b > 0); // Solidity automatically throws when dividing by 0
50         uint256 c = a / b;
51         // assert(a == b * c + a % b);  There is no case in which this doesn't hold
52         return c;
53     }
54     function sub(uint256 a, uint256 b)internal pure returns(uint256) {
55         assert(b <= a);
56         return a - b;
57     }
58     function add(uint256 a, uint256 b)internal pure returns(uint256) {
59         uint256 c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 /**
65  * @title Destructible
66  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
67  */
68 contract Destructible is Ownable {
69 
70   function Destructible() public payable { }
71 
72   /**
73    * @dev Transfers the current balance to the owner and terminates the contract.
74    */
75   function destroy() onlyOwner public {
76     selfdestruct(owner);
77   }
78 
79   function destroyAndSend(address _recipient) onlyOwner public {
80     selfdestruct(_recipient);
81   }
82 }
83 
84 /**
85  * @title Pausable
86  * @dev Base contract which allows children to implement an emergency stop mechanism.
87  */
88 contract Pausable is Destructible {
89     event Pause();
90     event Unpause();
91     bool public paused = false;
92     /**
93   * @dev Modifier to make a function callable only when the contract is not paused.
94   */
95     modifier whenNotPaused() {
96         require(!paused);
97         _;
98     }
99     /**
100   * @dev Modifier to make a function callable only when the contract is paused.
101   */
102     modifier whenPaused() {
103         require(paused);
104         _;
105     }
106     /**
107   * @dev called by the owner to pause, triggers stopped state
108   */
109     function pause()onlyOwner whenNotPaused public {
110         paused = true;
111         emit Pause();
112     }
113     /**
114   * @dev called by the owner to unpause, returns to normal state
115   */
116     function unpause()onlyOwner whenPaused public {
117         paused = false;
118         emit Unpause();
119     }
120 }
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  */
126 contract ERC20Basic {
127     uint256 public totalSupply;
128     uint256 public completeRemainingTokens;
129     function balanceOf(address who)public view returns(uint256);
130     function transfer(address to, uint256 value)public returns(bool);
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic,
138 Pausable {
139     uint256 startPreSale; uint256 endPreSale; uint256 startSale; 
140     uint256 endSale; 
141     using SafeMath for uint256; mapping(address => uint256)balances; uint256 preICOReserveTokens; uint256 icoReserveTokens; 
142     address businessReserveAddress; uint256 public timeLock = 1586217600; //7 April 2020 locked
143     uint256 public incentiveTokensLimit;
144     modifier checkAdditionalTokenLock(uint256 value) {
145 
146         if (msg.sender == businessReserveAddress) {
147             
148             if ((now<endSale) ||(now < timeLock &&value>incentiveTokensLimit)) {
149                 revert();
150             } else {
151                 _;
152             }
153         } else {
154             _;
155         }
156 
157     }
158     
159     function updateTimeLock(uint256 _timeLock) external onlyOwner {
160         timeLock = _timeLock;
161     }
162     function updateBusinessReserveAddress(address _businessAddress) external onlyOwner {
163         businessReserveAddress =_businessAddress;
164     }
165     
166     function updateIncentiveTokenLimit(uint256 _incentiveTokens) external onlyOwner {
167       incentiveTokensLimit = _incentiveTokens;
168    }    
169     /**
170  * @dev transfer token for a specified address
171  * @param _to The address to transfer to.
172  * @param _value The amount to be transferred.
173  */
174     function transfer(address _to, uint256 _value)public whenNotPaused checkAdditionalTokenLock(_value) returns(
175         bool
176     ) {
177         require(_to != address(0));
178         require(_value <= balances[msg.sender]);
179         // SafeMath.sub will throw if there is not enough balance.
180         balances[msg.sender] = balances[msg.sender].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         emit Transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     /**
187  * @dev Gets the balance of the specified address.
188  * @param _owner The address to query the the balance of.
189  * @return An uint256 representing the amount owned by the passed address.
190  */
191     function balanceOf(address _owner)public constant returns(uint256 balance) {
192         return balances[_owner];
193     }
194 }
195 /**
196  * @title ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/20
198  */
199 contract ERC20 is ERC20Basic {
200     function allowance(address owner, address spender)public view returns(uint256);
201     function transferFrom(address from, address to, uint256 value)public returns(
202         bool
203     );
204     function approve(address spender, uint256 value)public returns(bool);
205     event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 /**
208  * @title Burnable Token
209  * @dev Token that can be irreversibly burned (destroyed).
210  */
211 contract BurnableToken is BasicToken {
212 
213     event Burn(address indexed burner, uint256 value);
214 
215     /**
216    * @dev Burns a all amount of tokens of address.
217    */
218     function burn()public {
219         uint256 _value = balances[msg.sender];
220         // no need to require value <= totalSupply, since that would imply the sender's
221         // balance is greater than the totalSupply, which *should* be an assertion
222         // failure
223 
224         address burner = msg.sender;
225         balances[burner] = balances[burner].sub(_value);
226         totalSupply = totalSupply.sub(_value);
227         emit Burn(burner, _value);
228         emit Transfer(burner, address(0), _value);
229     }
230 }
231 
232 contract StandardToken is ERC20,BurnableToken {
233     mapping(address => mapping(address => uint256))internal allowed;
234 
235     /**
236   * @dev Transfer tokens from one address to another
237   * @param _from address The address which you want to send tokens from
238   * @param _to address The address which you want to transfer to
239   * @param _value uint256 the amount of tokens to be transferred
240   */
241     function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused checkAdditionalTokenLock(_value) returns(
242         bool) {
243         require(_to != address(0));
244         require(_value <= balances[_from]);
245         require(_value <= allowed[_from][msg.sender]);
246         balances[_from] = balances[_from].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
249         emit Transfer(_from, _to, _value);
250         return true;
251     }
252     /**
253   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254   *
255   * Beware that changing an allowance with this method brings the risk that someone may use both the old
256   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259   * @param _spender The address which will spend the funds.
260   * @param _value The amount of tokens to be spent.
261   */
262     function approve(address _spender, uint256 _value)public checkAdditionalTokenLock(_value) returns(
263         bool
264     ) {
265         allowed[msg.sender][_spender] = _value;
266         emit Approval(msg.sender, _spender, _value);
267         return true;
268     }
269     /**
270   * @dev Function to check the amount of tokens that an owner allowed to a spender.
271   * @param _owner address The address which owns the funds.
272   * @param _spender address The address which will spend the funds.
273   * @return A uint256 specifying the amount of tokens still available for the spender.
274   */
275     function allowance(address _owner, address _spender)public constant returns(
276         uint256 remaining
277     ) {
278         return allowed[_owner][_spender];
279     }
280     /**
281   * approve should be called when allowed[_spender] == 0. To increment
282   * allowed value is better to use this function to avoid 2 calls (and wait until
283   * the first transaction is mined)
284   * From MonolithDAO Token.sol
285   */
286     function increaseApproval(address _spender, uint _addedValue)public checkAdditionalTokenLock(_addedValue) returns(
287         bool success
288     ) {
289         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291         return true;
292     }
293     function decreaseApproval(address _spender, uint _subtractedValue)public returns(
294         bool success
295     ) {
296         uint oldValue = allowed[msg.sender][_spender];
297         if (_subtractedValue > oldValue) {
298             allowed[msg.sender][_spender] = 0;
299         } else {
300             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301         }
302         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303         return true;
304     }
305 }
306 contract SMRTCoin is StandardToken {
307     string public constant name = "SMRT";
308     uint public constant decimals = 18;
309     string public constant symbol = "SMRT";
310     using SafeMath for uint256; uint256 public weiRaised = 0; address depositWalletAddress; 
311     event Buy(address _from, uint256 _ethInWei, string userId); 
312     
313     function SMRTCoin()public {
314         owner = msg.sender;
315         totalSupply = 600000000 * (10 ** decimals);
316         preICOReserveTokens = 90000000 * (10 ** decimals);
317         icoReserveTokens = 210000000 * (10 ** decimals);
318         depositWalletAddress = 0x85a98805C17701504C252eAAB99f60C7c204A785; //TODO change
319         businessReserveAddress = 0x73FEC20272a555Af1AEA4bF27D406683632c2a8c; 
320         balances[owner] = totalSupply;
321         emit Transfer(address(0), owner, totalSupply);
322         startPreSale = now; //TODO update 1521900000 24 march 14 00 00 UTC
323         endPreSale = 1524319200; //21 April 14 00 00 utc
324         startSale = endPreSale + 1;
325         endSale = startSale + 30 days;
326     }
327     function ()public {
328         revert();
329     }
330     /**
331    * This will be called by adding data to represnet data.
332    */
333     function buy(string userId)public payable whenNotPaused {
334         require(msg.value > 0);
335         require(msg.sender != address(0));
336         weiRaised += msg.value;
337         forwardFunds();
338         emit Buy(msg.sender, msg.value, userId);
339     }
340     /**
341    * This function will called by only distributors to send tokens by calculating from offchain listners
342    */
343     function getBonustokens(uint256 tokens)internal returns(uint256 bonusTokens) {
344         require(now <= endSale);
345         uint256 bonus;
346         if (now <= endPreSale) {
347             bonus = 50;
348         } else if (now < startSale + 1 weeks) {
349             bonus = 10;
350         } else if (now < startSale + 2 weeks) {
351             bonus = 5;
352         }
353 
354         bonusTokens = ((tokens / 100) * bonus);
355     }
356     function CrowdSale(address recieverAddress, uint256 tokens)public onlyOwner {
357         tokens =  tokens.add(getBonustokens(tokens));
358         uint256 tokenLimit = (tokens.mul(20)).div(100); //as 20 becuase its 10 percnet of total
359         incentiveTokensLimit  = incentiveTokensLimit.add(tokenLimit);
360         if (now <= endPreSale && preICOReserveTokens >= tokens) {
361             preICOReserveTokens = preICOReserveTokens.sub(tokens);
362             transfer(businessReserveAddress, tokens);
363             transfer(recieverAddress, tokens);
364         } else if (now < endSale && icoReserveTokens >= tokens) {
365             icoReserveTokens = icoReserveTokens.sub(tokens);
366             transfer(businessReserveAddress, tokens);
367             transfer(recieverAddress, tokens);
368         }
369         else{ 
370             revert();
371         }
372     }
373     /**
374   * @dev Determines how ETH is stored/forwarded on purchases.
375   */
376     function forwardFunds()internal {
377         depositWalletAddress.transfer(msg.value);
378     }
379     function changeDepositWalletAddress(address newDepositWalletAddr)external onlyOwner {
380         require(newDepositWalletAddr != 0);
381         depositWalletAddress = newDepositWalletAddr;
382     }
383     function updateSaleTime(uint256 _startSale, uint256 _endSale)external onlyOwner {
384         startSale = _startSale;
385         endSale = _endSale;
386     }
387 
388  
389 
390 }