1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25     function allowance(address owner, address spender) public view returns (uint256);
26 
27     function transferFrom(address from, address to, uint256 value) public returns (bool);
28 
29     function approve(address spender, uint256 value) public returns (bool);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40 
41     /**
42     * @dev Multiplies two numbers, throws on overflow.
43     */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         assert(c / a == b);
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers, truncating the quotient.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         // uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return a / b;
61     }
62 
63     /**
64     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     /**
72     * @dev Adds two numbers, throws on overflow.
73     */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78     }
79 }
80 
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87     using SafeMath for uint256;
88 
89     mapping(address => uint256) balances;
90 
91     uint256 totalSupply_;
92 
93     /**
94     * @dev total number of tokens in existence
95     */
96     function totalSupply() public view returns (uint256) {
97         return totalSupply_;
98     }
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108 
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116     * @dev Gets the balance of the specified address.
117     * @param _owner The address to query the the balance of.
118     * @return An uint256 representing the amount owned by the passed address.
119     */
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124 }
125 
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136     mapping(address => mapping(address => uint256)) internal allowed;
137 
138 
139     /**
140      * @dev Transfer tokens from one address to another
141      * @param _from address The address which you want to send tokens from
142      * @param _to address The address which you want to transfer to
143      * @param _value uint256 the amount of tokens to be transferred
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[_from]);
148         require(_value <= allowed[_from][msg.sender]);
149 
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159      *
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param _spender The address which will spend the funds.
165      * @param _value The amount of tokens to be spent.
166      */
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param _owner address The address which owns the funds.
176      * @param _spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address _owner, address _spender) public view returns (uint256) {
180         return allowed[_owner][_spender];
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      *
186      * approve should be called when allowed[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      *
202      * approve should be called when allowed[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * @param _spender The address which will spend the funds.
207      * @param _subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210         uint oldValue = allowed[msg.sender][_spender];
211         if (_subtractedValue > oldValue) {
212             allowed[msg.sender][_spender] = 0;
213         } else {
214             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215         }
216         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 
220 }
221 
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229 
230     address public owner;
231 
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234     /**
235      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
236      * account.
237      */
238     function Ownable() public {
239         owner = msg.sender;
240     }
241 
242     /**
243      * @dev Throws if called by any account other than the owner.
244      */
245     modifier onlyOwner() {
246         require(msg.sender == owner);
247         _;
248     }
249 
250     /**
251      * @dev Allows the current owner to transfer control of the contract to a newOwner.
252      * @param newOwner The address to transfer ownership to.
253      */
254     function transferOwnership(address newOwner) public onlyOwner {
255         require(newOwner != address(0));
256         OwnershipTransferred(owner, newOwner);
257         owner = newOwner;
258     }
259 
260 }
261 
262 
263 /**
264  * @title Mintable token
265  * @dev Simple ERC20 Token example, with mintable token creation
266  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
267  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
268  */
269 contract MintableToken is StandardToken, Ownable {
270 
271     event Mint(address indexed to, uint256 amount);
272     event MintFinished();
273 
274     bool public mintingFinished = false;
275 
276     modifier canMint() {
277         require(!mintingFinished);
278         _;
279     }
280 
281     /**
282      * @dev Function to mint tokens
283      * @param _to The address that will receive the minted tokens.
284      * @param _amount The amount of tokens to mint.
285      * @return A boolean that indicates if the operation was successful.
286      */
287     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
288         totalSupply_ = totalSupply_.add(_amount);
289         balances[_to] = balances[_to].add(_amount);
290         Mint(_to, _amount);
291         Transfer(address(0), _to, _amount);
292         return true;
293     }
294 
295     /**
296      * @dev Function to stop minting new tokens.
297      * @return True if the operation was successful.
298      */
299     function finishMinting() onlyOwner canMint public returns (bool) {
300         mintingFinished = true;
301         MintFinished();
302         return true;
303     }
304 
305 }
306 
307 
308 /**
309  * @title Burnable Token
310  * @dev Token that can be irreversibly burned (destroyed).
311  */
312 contract BurnableToken is BasicToken {
313 
314     event Burn(address indexed burner, uint256 value);
315 
316     function _burn(address _burner, uint256 _value) internal {
317         require(_value <= balances[_burner]);
318         // no need to require value <= totalSupply, since that would imply the
319         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321         balances[_burner] = balances[_burner].sub(_value);
322         totalSupply_ = totalSupply_.sub(_value);
323         Burn(_burner, _value);
324         Transfer(_burner, address(0), _value);
325     }
326 
327 }
328 
329 
330 contract DividendPayoutToken is BurnableToken, MintableToken {
331 
332     // Dividends already claimed by investor
333     mapping(address => uint256) public dividendPayments;
334     // Total dividends claimed by all investors
335     uint256 public totalDividendPayments;
336 
337     // invoke this function after each dividend payout
338     function increaseDividendPayments(address _investor, uint256 _amount) onlyOwner public {
339         dividendPayments[_investor] = dividendPayments[_investor].add(_amount);
340         totalDividendPayments = totalDividendPayments.add(_amount);
341     }
342 
343     //When transfer tokens decrease dividendPayments for sender and increase for receiver
344     function transfer(address _to, uint256 _value) public returns (bool) {
345         // balance before transfer
346         uint256 oldBalanceFrom = balances[msg.sender];
347 
348         // invoke super function with requires
349         bool isTransferred = super.transfer(_to, _value);
350 
351         uint256 transferredClaims = dividendPayments[msg.sender].mul(_value).div(oldBalanceFrom);
352         dividendPayments[msg.sender] = dividendPayments[msg.sender].sub(transferredClaims);
353         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
354 
355         return isTransferred;
356     }
357 
358     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
359         // balance before transfer
360         uint256 oldBalanceFrom = balances[_from];
361 
362         // invoke super function with requires
363         bool isTransferred = super.transferFrom(_from, _to, _value);
364 
365         uint256 transferredClaims = dividendPayments[_from].mul(_value).div(oldBalanceFrom);
366         dividendPayments[_from] = dividendPayments[_from].sub(transferredClaims);
367         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
368 
369         return isTransferred;
370     }
371 
372     function burn() public {
373         address burner = msg.sender;
374 
375         // balance before burning tokens
376         uint256 oldBalance = balances[burner];
377 
378         super._burn(burner, oldBalance);
379 
380         uint256 burnedClaims = dividendPayments[burner];
381         dividendPayments[burner] = dividendPayments[burner].sub(burnedClaims);
382         totalDividendPayments = totalDividendPayments.sub(burnedClaims);
383 
384         SaleInterface(owner).refund(burner);
385     }
386 
387 }
388 
389 contract RicoToken is DividendPayoutToken {
390 
391     string public constant name = "Rico";
392 
393     string public constant symbol = "Rico";
394 
395     uint8 public constant decimals = 18;
396 
397 }
398 
399 
400 // Interface for PreSale and CrowdSale contracts with refund function
401 contract SaleInterface {
402 
403     function refund(address _to) public;
404 
405 }