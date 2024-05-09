1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control 
36  * functions, this simplifies the implementation of "user permissions". 
37  */
38 contract Ownable {
39     address public owner;
40 
41     /** 
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     function Ownable() {
46         owner = msg.sender;
47     }
48 
49     /**
50     * @dev Throws if called by any account other than the owner. 
51     */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58     * @dev Allows the current owner to transfer control of the contract to a newOwner.
59     * @param newOwner The address to transfer ownership to. 
60     */
61     function transferOwnership(address newOwner) onlyOwner {
62         if (newOwner != address(0)) {
63             owner = newOwner;
64         }
65     }
66 }
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20Basic {
74     uint256 public totalSupply;
75     function balanceOf(address who) constant returns (uint256);
76     function transfer(address to, uint256 value);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85     function allowance(address owner, address spender) constant returns (uint256);
86     function transferFrom(address from, address to, uint256 value);
87     function approve(address spender, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances. 
94  */
95 contract BasicToken is ERC20Basic, Ownable {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) balances;
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) {
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of. 
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129     mapping (address => mapping (address => uint256)) allowed;
130 
131     /**
132     * @dev Transfer tokens from one address to another
133     * @param _from address The address which you want to send tokens from
134     * @param _to address The address which you want to transfer to
135     * @param _value uint256 the amout of tokens to be transfered
136     */
137     function transferFrom(address _from, address _to, uint256 _value) {
138         var _allowance = allowed[_from][msg.sender];
139 
140         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141         // if (_value > _allowance) throw;
142 
143         balances[_to] = balances[_to].add(_value);
144         balances[_from] = balances[_from].sub(_value);
145         allowed[_from][msg.sender] = _allowance.sub(_value);
146         Transfer(_from, _to, _value);
147     }
148 
149     /**
150     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
151     * @param _spender The address which will spend the funds.
152     * @param _value The amount of tokens to be spent.
153     */
154     function approve(address _spender, uint256 _value) {
155 
156         // To change the approve amount you first have to reduce the addresses`
157         //  allowance to zero by calling `approve(_spender, 0)` if it is not
158         //  already 0 to mitigate the race condition described here:
159         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163     }
164 
165     /**
166     * @dev Function to check the amount of tokens that an owner allowed to a spender.
167     * @param _owner address The address which owns the funds.
168     * @param _spender address The address which will spend the funds.
169     * @return A uint256 specifing the amount of tokens still avaible for the spender.
170     */
171     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 }
175 
176 /**
177  * @title TKRPToken
178  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
179  * Note they can later distribute these tokens as they wish using `transfer` and other
180  * `StandardToken` functions.
181  */
182 contract TKRPToken is StandardToken {
183     event Destroy(address indexed _from);
184 
185     string public name = "TKRPToken";
186     string public symbol = "TKRP";
187     uint256 public decimals = 18;
188     uint256 public initialSupply = 500000;
189 
190     /**
191     * @dev Contructor that gives the sender all tokens
192     */
193     function TKRPToken() {
194         totalSupply = initialSupply;
195         balances[msg.sender] = initialSupply;
196     }
197 
198     /**
199     * @dev Destroys tokens from an address, this process is irrecoverable.
200     * @param _from The address to destroy the tokens from.
201     */
202     function destroyFrom(address _from) onlyOwner returns (bool) {
203         uint256 balance = balanceOf(_from);
204         require(balance > 0);
205 
206         balances[_from] = 0;
207         totalSupply = totalSupply.sub(balance);
208 
209         Destroy(_from);
210     }
211 }
212 
213 /**
214  * @title TKRToken
215  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
216  * Note they can later distribute these tokens as they wish using `transfer` and other
217  * `StandardToken` functions.
218  */
219 contract TKRToken is StandardToken {
220     event Destroy(address indexed _from, address indexed _to, uint256 _value);
221 
222     string public name = "TKRToken";
223     string public symbol = "TKR";
224     uint256 public decimals = 18;
225     uint256 public initialSupply = 65500000 * 10 ** 18;
226 
227     /**
228     * @dev Contructor that gives the sender all tokens
229     */
230     function TKRToken() {
231         totalSupply = initialSupply;
232         balances[msg.sender] = initialSupply;
233     }
234 
235     /**
236     * @dev Destroys tokens, this process is irrecoverable.
237     * @param _value The amount to destroy.
238     */
239     function destroy(uint256 _value) onlyOwner returns (bool) {
240         balances[msg.sender] = balances[msg.sender].sub(_value);
241         totalSupply = totalSupply.sub(_value);
242         Destroy(msg.sender, 0x0, _value);
243     }
244 }
245 
246 /**
247  * @title Crowdsale
248  * @dev Smart contract which collects ETH and in return transfers the TKRToken to the contributors
249  * Log events are emitted for each transaction 
250  */
251 contract Crowdsale is Ownable {
252     using SafeMath for uint256;
253 
254     /* 
255     * Stores the contribution in wei
256     * Stores the amount received in TKR
257     */
258     struct Contributor {
259         uint256 contributed;
260         uint256 received;
261     }
262 
263     /* Backers are keyed by their address containing a Contributor struct */
264     mapping(address => Contributor) public contributors;
265 
266     /* Events to emit when a contribution has successfully processed */
267     event TokensSent(address indexed to, uint256 value);
268     event ContributionReceived(address indexed to, uint256 value);
269     event MigratedTokens(address indexed _address, uint256 value);
270 
271     /* Constants */
272     uint256 public constant TOKEN_CAP = 58500000 * 10 ** 18;
273     uint256 public constant MINIMUM_CONTRIBUTION = 10 finney;
274     uint256 public constant TOKENS_PER_ETHER = 5000 * 10 ** 18;
275     uint256 public constant CROWDSALE_DURATION = 30 days;
276 
277     /* Public Variables */
278     TKRToken public token;
279     TKRPToken public preToken;
280     address public crowdsaleOwner;
281     uint256 public etherReceived;
282     uint256 public tokensSent;
283     uint256 public crowdsaleStartTime;
284     uint256 public crowdsaleEndTime;
285 
286     /* Modifier to check whether the crowdsale is running */
287     modifier crowdsaleRunning() {
288         require(now < crowdsaleEndTime && crowdsaleStartTime != 0);
289         _;
290     }
291 
292     /**
293     * @dev Fallback function which invokes the processContribution function
294     * @param _tokenAddress TKR Token address
295     * @param _to crowdsale owner address
296     */
297     function Crowdsale(address _tokenAddress, address _preTokenAddress, address _to) {
298         token = TKRToken(_tokenAddress);
299         preToken = TKRPToken(_preTokenAddress);
300         crowdsaleOwner = _to;
301     }
302 
303     /**
304     * @dev Fallback function which invokes the processContribution function
305     */
306     function() crowdsaleRunning payable {
307         processContribution(msg.sender);
308     }
309 
310     /**
311     * @dev Starts the crowdsale
312     */
313     function start() onlyOwner {
314         require(crowdsaleStartTime == 0);
315 
316         crowdsaleStartTime = now;            
317         crowdsaleEndTime = now + CROWDSALE_DURATION;    
318     }
319 
320     /**
321     * @dev A backup fail-safe drain if required
322     */
323     function drain() onlyOwner {
324         assert(crowdsaleOwner.send(this.balance));
325     }
326 
327     /**
328     * @dev Finalizes the crowdsale and sends funds
329     */
330     function finalize() onlyOwner {
331         require((crowdsaleStartTime != 0 && now > crowdsaleEndTime) || tokensSent == TOKEN_CAP);
332 
333         uint256 remainingBalance = token.balanceOf(this);
334         if (remainingBalance > 0) token.destroy(remainingBalance);
335 
336         assert(crowdsaleOwner.send(this.balance));
337     }
338 
339     /**
340     * @dev Migrates TKRP tokens to TKR token at a rate of 1:1 during the Crowdsale.
341     */
342     function migrate() crowdsaleRunning {
343         uint256 preTokenBalance = preToken.balanceOf(msg.sender);
344         require(preTokenBalance != 0);
345         uint256 tokenBalance = preTokenBalance * 10 ** 18;
346 
347         preToken.destroyFrom(msg.sender);
348         token.transfer(msg.sender, tokenBalance);
349         MigratedTokens(msg.sender, tokenBalance);
350     }
351 
352     /**
353     * @dev Processes the contribution given, sends the tokens and emits events
354     * @param sender The address of the contributor
355     */
356     function processContribution(address sender) internal {
357         require(msg.value >= MINIMUM_CONTRIBUTION);
358 
359         // // /* Calculate total (+bonus) amount to send, throw if it exceeds cap*/
360         uint256 contributionInTokens = bonus(msg.value.mul(TOKENS_PER_ETHER).div(1 ether));
361         require(contributionInTokens.add(tokensSent) <= TOKEN_CAP);
362 
363         /* Send the tokens */
364         token.transfer(sender, contributionInTokens);
365 
366         /* Create a contributor struct and store the contributed/received values */
367         Contributor storage contributor = contributors[sender];
368         contributor.received = contributor.received.add(contributionInTokens);
369         contributor.contributed = contributor.contributed.add(msg.value);
370 
371         // /* Update the total amount of tokens sent and ether received */
372         etherReceived = etherReceived.add(msg.value);
373         tokensSent = tokensSent.add(contributionInTokens);
374 
375         // /* Emit log events */
376         TokensSent(sender, contributionInTokens);
377         ContributionReceived(sender, msg.value);
378     }
379 
380     /**
381     * @dev Calculates the bonus amount based on the contribution date
382     * @param amount The contribution amount given
383     */
384     function bonus(uint256 amount) internal constant returns (uint256) {
385         /* This adds a bonus 20% such as 100 + 100/5 = 120 */
386         if (now < crowdsaleStartTime.add(2 days)) return amount.add(amount.div(5));
387 
388         /* This adds a bonus 10% such as 100 + 100/10 = 110 */
389         if (now < crowdsaleStartTime.add(14 days)) return amount.add(amount.div(10));
390 
391         /* This adds a bonus 5% such as 100 + 100/20 = 105 */
392         if (now < crowdsaleStartTime.add(21 days)) return amount.add(amount.div(20));
393 
394         /* No bonus is given */
395         return amount;
396     }
397 }