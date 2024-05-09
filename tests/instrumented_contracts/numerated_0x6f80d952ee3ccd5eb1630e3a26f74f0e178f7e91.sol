1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     
11     function totalSupply() public view returns (uint256);
12 
13     function balanceOf(address who) public view returns (uint256);
14 
15     function transfer(address to, uint256 value) public returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26     
27     function allowance(address owner, address spender) public view returns (uint256);
28 
29     function transferFrom(address from, address to, uint256 value) public returns (bool);
30 
31     function approve(address spender, uint256 value) public returns (bool);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43     /**
44     * @dev Multiplies two numbers, throws on overflow.
45     */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         assert(c / a == b);
52         return c;
53     }
54 
55     /**
56     * @dev Integer division of two numbers, truncating the quotient.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // assert(b > 0); // Solidity automatically throws when dividing by 0
60         // uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62         return a / b;
63     }
64 
65     /**
66     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72 
73     /**
74     * @dev Adds two numbers, throws on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         assert(c >= a);
79         return c;
80     }
81 }
82 
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     
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
109         
110         require(_to != address(0));
111         require(_value <= balances[msg.sender]);
112 
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) public view returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping(address => mapping(address => uint256)) internal allowed;
141 
142 
143     /**
144      * @dev Transfer tokens from one address to another
145      * @param _from address The address which you want to send tokens from
146      * @param _to address The address which you want to transfer to
147      * @param _value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150         
151         require(_to != address(0));
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154 
155         balances[_from] = balances[_from].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158         Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) public returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address _owner, address _spender) public view returns (uint256) {
185         return allowed[_owner][_spender];
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      *
191      * approve should be called when allowed[_spender] == 0. To increment
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * @param _spender The address which will spend the funds.
196      * @param _addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 
204     /**
205      * @dev Decrease the amount of tokens that an owner allowed to a spender.
206      *
207      * approve should be called when allowed[_spender] == 0. To decrement
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      * @param _spender The address which will spend the funds.
212      * @param _subtractedValue The amount of tokens to decrease the allowance by.
213      */
214     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215         uint oldValue = allowed[msg.sender][_spender];
216         if (_subtractedValue > oldValue) {
217             allowed[msg.sender][_spender] = 0;
218         } else {
219             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220         }
221         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225 }
226 
227 
228 /**
229  * @title Ownable
230  * @dev The Ownable contract has an owner address, and provides basic authorization control
231  * functions, this simplifies the implementation of "user permissions".
232  */
233 contract Ownable {
234 
235     address public owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
241      * account.
242      */
243     function Ownable() public {
244         owner = msg.sender;
245     }
246 
247     /**
248      * @dev Throws if called by any account other than the owner.
249      */
250     modifier onlyOwner() {
251         require(msg.sender == owner);
252         _;
253     }
254 
255     /**
256      * @dev Allows the current owner to transfer control of the contract to a newOwner.
257      * @param newOwner The address to transfer ownership to.
258      */
259     function transferOwnership(address newOwner) public onlyOwner {
260         require(newOwner != address(0));
261         OwnershipTransferred(owner, newOwner);
262         owner = newOwner;
263     }
264 
265 }
266 
267 
268 /**
269  * @title Mintable token
270  * @dev Simple ERC20 Token example, with mintable token creation
271  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
272  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
273  */
274 contract MintableToken is StandardToken, Ownable {
275 
276     event Mint(address indexed to, uint256 amount);
277     event MintFinished();
278 
279     bool public mintingFinished = false;
280 
281     modifier canMint() {
282         require(!mintingFinished);
283         _;
284     }
285 
286     /**
287      * @dev Function to mint tokens
288      * @param _to The address that will receive the minted tokens.
289      * @param _amount The amount of tokens to mint.
290      * @return A boolean that indicates if the operation was successful.
291      */
292     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
293         totalSupply_ = totalSupply_.add(_amount);
294         balances[_to] = balances[_to].add(_amount);
295         Mint(_to, _amount);
296         Transfer(address(0), _to, _amount);
297         return true;
298     }
299 
300     /**
301      * @dev Function to stop minting new tokens.
302      * @return True if the operation was successful.
303      */
304     function finishMinting() onlyOwner canMint public returns (bool) {
305         mintingFinished = true;
306         MintFinished();
307         return true;
308     }
309 
310 }
311 
312 
313 /**
314  * @title Burnable Token
315  * @dev Token that can be irreversibly burned (destroyed).
316  */
317 contract BurnableToken is BasicToken {
318 
319     event Burn(address indexed burner, uint256 value);
320 
321     function _burn(address _burner, uint256 _value) internal {
322         require(_value <= balances[_burner]);
323         // no need to require value <= totalSupply, since that would imply the
324         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
325 
326         balances[_burner] = balances[_burner].sub(_value);
327         totalSupply_ = totalSupply_.sub(_value);
328         Burn(_burner, _value);
329         Transfer(_burner, address(0), _value);
330     }
331 
332 }
333 
334 
335 contract DividendPayoutToken is BurnableToken, MintableToken {
336 
337     // Dividends already claimed by investor
338     mapping(address => uint256) public dividendPayments;
339     // Total dividends claimed by all investors
340     uint256 public totalDividendPayments;
341 
342     // invoke this function after each dividend payout
343     function increaseDividendPayments(address _investor, uint256 _amount) onlyOwner public {
344         dividendPayments[_investor] = dividendPayments[_investor].add(_amount);
345         totalDividendPayments = totalDividendPayments.add(_amount);
346     }
347 
348     //When transfer tokens decrease dividendPayments for sender and increase for receiver
349     function transfer(address _to, uint256 _value) public returns (bool) {
350         // balance before transfer
351         uint256 oldBalanceFrom = balances[msg.sender];
352 
353         // invoke super function with requires
354         bool isTransferred = super.transfer(_to, _value);
355 
356         uint256 transferredClaims = dividendPayments[msg.sender].mul(_value).div(oldBalanceFrom);
357         dividendPayments[msg.sender] = dividendPayments[msg.sender].sub(transferredClaims);
358         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
359 
360         return isTransferred;
361     }
362 
363     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
364         // balance before transfer
365         uint256 oldBalanceFrom = balances[_from];
366 
367         // invoke super function with requires
368         bool isTransferred = super.transferFrom(_from, _to, _value);
369 
370         uint256 transferredClaims = dividendPayments[_from].mul(_value).div(oldBalanceFrom);
371         dividendPayments[_from] = dividendPayments[_from].sub(transferredClaims);
372         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
373 
374         return isTransferred;
375     }
376 
377     function burn() public {
378         address burner = msg.sender;
379 
380         // balance before burning tokens
381         uint256 oldBalance = balances[burner];
382 
383         super._burn(burner, oldBalance);
384 
385         uint256 burnedClaims = dividendPayments[burner];
386         dividendPayments[burner] = dividendPayments[burner].sub(burnedClaims);
387         totalDividendPayments = totalDividendPayments.sub(burnedClaims);
388 
389         SaleInterface(owner).refund(burner);
390     }
391 
392 }
393 
394 contract RicoToken is DividendPayoutToken {
395 
396     string public constant name = "CFE";
397 
398     string public constant symbol = "CFE";
399 
400     uint8 public constant decimals = 18;
401 
402 }
403 
404 
405 // Interface for PreSale and CrowdSale contracts with refund function
406 contract SaleInterface {
407 
408     function refund(address _to) public;
409 
410 }