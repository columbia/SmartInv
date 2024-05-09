1 /**
2  * @author https://github.com/Dmitx
3  */
4 
5 pragma solidity ^0.4.23;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13     function totalSupply() public view returns (uint256);
14 
15     function balanceOf(address who) public view returns (uint256);
16 
17     function transfer(address to, uint256 value) public returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28     function allowance(address owner, address spender) public view returns (uint256);
29 
30     function transferFrom(address from, address to, uint256 value) public returns (bool);
31 
32     function approve(address spender, uint256 value) public returns (bool);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44     /**
45     * @dev Multiplies two numbers, throws on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         assert(c / a == b);
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two numbers, truncating the quotient.
58     */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         // uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return a / b;
64     }
65 
66     /**
67     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74     /**
75     * @dev Adds two numbers, throws on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 }
83 
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90     using SafeMath for uint256;
91 
92     mapping(address => uint256) balances;
93 
94     uint256 totalSupply_;
95 
96     /**
97     * @dev total number of tokens in existence
98     */
99     function totalSupply() public view returns (uint256) {
100         return totalSupply_;
101     }
102 
103     /**
104     * @dev transfer token for a specified address
105     * @param _to The address to transfer to.
106     * @param _value The amount to be transferred.
107     */
108     function transfer(address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110         require(_value <= balances[msg.sender]);
111 
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         emit Transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param _owner The address to query the the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address _owner) public view returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127 }
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139     mapping(address => mapping(address => uint256)) internal allowed;
140 
141 
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         emit Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      *
163      * Beware that changing an allowance with this method brings the risk that someone may use both the old
164      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      * @param _spender The address which will spend the funds.
168      * @param _value The amount of tokens to be spent.
169      */
170     function approve(address _spender, uint256 _value) public returns (bool) {
171         allowed[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     /**
177      * @dev Function to check the amount of tokens that an owner allowed to a spender.
178      * @param _owner address The address which owns the funds.
179      * @param _spender address The address which will spend the funds.
180      * @return A uint256 specifying the amount of tokens still available for the spender.
181      */
182     function allowance(address _owner, address _spender) public view returns (uint256) {
183         return allowed[_owner][_spender];
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      *
189      * approve should be called when allowed[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * @param _spender The address which will spend the funds.
194      * @param _addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      *
205      * approve should be called when allowed[_spender] == 0. To decrement
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * @param _spender The address which will spend the funds.
210      * @param _subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213         uint oldValue = allowed[msg.sender][_spender];
214         if (_subtractedValue > oldValue) {
215             allowed[msg.sender][_spender] = 0;
216         } else {
217             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218         }
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223 }
224 
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232   address public owner;
233 
234 
235   event OwnershipRenounced(address indexed previousOwner);
236   event OwnershipTransferred(
237     address indexed previousOwner,
238     address indexed newOwner
239   );
240 
241 
242   /**
243    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
244    * account.
245    */
246   constructor() public {
247     owner = msg.sender;
248   }
249 
250   /**
251    * @dev Throws if called by any account other than the owner.
252    */
253   modifier onlyOwner() {
254     require(msg.sender == owner);
255     _;
256   }
257 
258   /**
259    * @dev Allows the current owner to transfer control of the contract to a newOwner.
260    * @param newOwner The address to transfer ownership to.
261    */
262   function transferOwnership(address newOwner) public onlyOwner {
263     require(newOwner != address(0));
264     emit OwnershipTransferred(owner, newOwner);
265     owner = newOwner;
266   }
267 
268   /**
269    * @dev Allows the current owner to relinquish control of the contract.
270    */
271   function renounceOwnership() public onlyOwner {
272     emit OwnershipRenounced(owner);
273     owner = address(0);
274   }
275   
276 }
277 
278 
279 /**
280  * @title Mintable token
281  * @dev Simple ERC20 Token example, with mintable token creation
282  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
283  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
284  */
285 contract MintableToken is StandardToken, Ownable {
286     event Mint(address indexed to, uint256 amount);
287     event MintFinished();
288 
289     bool public mintingFinished = false;
290 
291 
292     modifier canMint() {
293         require(!mintingFinished);
294         _;
295     }
296 
297     /**
298      * @dev Function to mint tokens
299      * @param _to The address that will receive the minted tokens.
300      * @param _amount The amount of tokens to mint.
301      * @return A boolean that indicates if the operation was successful.
302      */
303     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
304         totalSupply_ = totalSupply_.add(_amount);
305         balances[_to] = balances[_to].add(_amount);
306         emit Mint(_to, _amount);
307         emit Transfer(address(0), _to, _amount);
308         return true;
309     }
310 
311     /**
312      * @dev Function to stop minting new tokens.
313      * @return True if the operation was successful.
314      */
315     function finishMinting() onlyOwner canMint public returns (bool) {
316         mintingFinished = true;
317         emit MintFinished();
318         return true;
319     }
320 
321 }
322 
323 
324 /**
325  * @title Capped token
326  * @dev Mintable token with a token cap.
327  */
328 contract CappedToken is MintableToken {
329 
330     uint256 public cap;
331 
332     constructor(uint256 _cap) public {
333         require(_cap > 0);
334         cap = _cap;
335     }
336 
337     /**
338      * @dev Function to mint tokens
339      * @param _to The address that will receive the minted tokens.
340      * @param _amount The amount of tokens to mint.
341      * @return A boolean that indicates if the operation was successful.
342      */
343     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344         require(totalSupply_.add(_amount) <= cap);
345 
346         return super.mint(_to, _amount);
347     }
348 
349 }
350 
351 
352 contract DividendPayoutToken is CappedToken {
353 
354     // Dividends already claimed by investor
355     mapping(address => uint256) public dividendPayments;
356     // Total dividends claimed by all investors
357     uint256 public totalDividendPayments;
358 
359     // invoke this function after each dividend payout
360     function increaseDividendPayments(address _investor, uint256 _amount) onlyOwner public {
361         dividendPayments[_investor] = dividendPayments[_investor].add(_amount);
362         totalDividendPayments = totalDividendPayments.add(_amount);
363     }
364 
365     //When transfer tokens decrease dividendPayments for sender and increase for receiver
366     function transfer(address _to, uint256 _value) public returns (bool) {
367         // balance before transfer
368         uint256 oldBalanceFrom = balances[msg.sender];
369 
370         // invoke super function with requires
371         bool isTransferred = super.transfer(_to, _value);
372 
373         uint256 transferredClaims = dividendPayments[msg.sender].mul(_value).div(oldBalanceFrom);
374         dividendPayments[msg.sender] = dividendPayments[msg.sender].sub(transferredClaims);
375         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
376 
377         return isTransferred;
378     }
379 
380     //When transfer tokens decrease dividendPayments for token owner and increase for receiver
381     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
382         // balance before transfer
383         uint256 oldBalanceFrom = balances[_from];
384 
385         // invoke super function with requires
386         bool isTransferred = super.transferFrom(_from, _to, _value);
387 
388         uint256 transferredClaims = dividendPayments[_from].mul(_value).div(oldBalanceFrom);
389         dividendPayments[_from] = dividendPayments[_from].sub(transferredClaims);
390         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
391 
392         return isTransferred;
393     }
394 
395 }
396 
397 contract IcsToken is DividendPayoutToken {
398 
399     string public constant name = "Interexchange Crypstock System";
400 
401     string public constant symbol = "ICS";
402 
403     uint8 public constant decimals = 18;
404 
405     // set Total Supply in 500 000 000 tokens
406     constructor() public
407     CappedToken(5e8 * 1e18) {}
408 
409 }