1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ForeignToken {
50     function balanceOf(address owner) constant public returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     // SafeMath.sub will throw if there is not enough balance.
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 /**
225  * TorusCoin pre-sell contract.
226  *
227  */
228 contract TorusCoin is StandardToken {
229     using SafeMath for uint256;
230 
231     string public name = "Torus";
232     string public symbol = "TORUS";
233     uint256 public decimals = 18;
234 
235     uint256 public startDatetime;
236     uint256 public endDatetime;
237 
238     // Initial founder address (set in constructor)
239     // All deposited ETH will be instantly forwarded to this address.
240     address public founder;
241 
242     // administrator address
243     address public admin;
244 
245     uint256 public coinAllocation = 700 * 10**8 * 10**decimals; //70000M tokens supply for pre-sell
246     uint256 public founderAllocation = 300 * 10**8 * 10**decimals; //30000M of token supply allocated for the team allocation
247 
248     bool public founderAllocated = false; //this will change to true when the founder fund is allocated
249 
250     uint256 public saleTokenSupply = 0; //this will keep track of the token supply created during the pre-sell
251     uint256 public salesVolume = 0; //this will keep track of the Ether raised during the pre-sell
252 
253     bool public halted = false; //the admin address can set this to true to halt the pre-sell due to emergency
254 
255     event Buy(address sender, address recipient, uint256 eth, uint256 tokens);
256     event AllocateFounderTokens(address sender, address founder, uint256 tokens);
257     event AllocateInflatedTokens(address sender, address holder, uint256 tokens);
258 
259     modifier onlyAdmin {
260         require(msg.sender == admin);
261         _;
262     }
263 
264     modifier duringCrowdSale {
265         require(block.timestamp >= startDatetime && block.timestamp < endDatetime);
266         _;
267     }
268 
269     /**
270      *
271      * Integer value representing the number of seconds since 1 January 1970 00:00:00 UTC
272      */
273     function TorusCoin(uint256 startDatetimeInSeconds, address founderWallet) public {
274 
275         admin = msg.sender;
276         founder = founderWallet;
277 
278         startDatetime = startDatetimeInSeconds;
279         endDatetime = startDatetime + 16 * 1 days;
280     }
281 
282     /**
283      * allow anyone sends funds to the contract
284      */
285     function() public payable {
286         buy(msg.sender);
287     }
288 
289     /**
290      * Main token buy function.
291      * Buy for the sender itself or buy on the behalf of somebody else (third party address).
292      */
293     function buy(address recipient) payable public duringCrowdSale  {
294 
295         require(!halted);
296         require(msg.value >= 0.01 ether);
297 
298         uint256 tokens = msg.value.mul(35e4);
299 
300         require(tokens > 0);
301 
302         require(saleTokenSupply.add(tokens)<=coinAllocation );
303 
304         balances[recipient] = balances[recipient].add(tokens);
305 
306         totalSupply_ = totalSupply_.add(tokens);
307         saleTokenSupply = saleTokenSupply.add(tokens);
308         salesVolume = salesVolume.add(msg.value);
309 
310         if (!founder.call.value(msg.value)()) revert(); //immediately send Ether to founder address
311 
312         Buy(msg.sender, recipient, msg.value, tokens);
313     }
314 
315     /**
316      * Set up founder address token balance.
317      */
318     function allocateFounderTokens() public onlyAdmin {
319         require( block.timestamp > endDatetime );
320         require(!founderAllocated);
321 
322         balances[founder] = balances[founder].add(founderAllocation);
323         totalSupply_ = totalSupply_.add(founderAllocation);
324         founderAllocated = true;
325 
326         AllocateFounderTokens(msg.sender, founder, founderAllocation);
327     }
328 
329     /**
330      * Emergency Stop crowdsale.
331      */
332     function halt() public onlyAdmin {
333         halted = true;
334     }
335 
336     function unhalt() public onlyAdmin {
337         halted = false;
338     }
339 
340     /**
341      * Change admin address.
342      */
343     function changeAdmin(address newAdmin) public onlyAdmin  {
344         admin = newAdmin;
345     }
346 
347     /**
348      * Change founder address.
349      */
350     function changeFounder(address newFounder) public onlyAdmin  {
351         founder = newFounder;
352     }
353 
354      /**
355       * Inflation
356       */
357     function inflate(address holder, uint256 tokens) public onlyAdmin {
358         require( block.timestamp > endDatetime );
359         require(saleTokenSupply.add(tokens) <= coinAllocation );
360 
361         balances[holder] = balances[holder].add(tokens);
362         saleTokenSupply = saleTokenSupply.add(tokens);
363         totalSupply_ = totalSupply_.add(tokens);
364 
365         AllocateInflatedTokens(msg.sender, holder, tokens);
366 
367      }
368 
369     /**
370      * withdraw foreign tokens
371      */
372     function withdrawForeignTokens(address tokenContract) onlyAdmin public returns (bool) {
373         ForeignToken token = ForeignToken(tokenContract);
374         uint256 amount = token.balanceOf(address(this));
375         return token.transfer(admin, amount);
376     }
377 
378 
379 }