1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender) public view returns (uint256);
23     function transferFrom(address from, address to, uint256 value) public returns (bool);
24     function approve(address spender, uint256 value) public returns (bool);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) internal balances;
71 
72     /**
73     * @dev transfer token for a specified address
74     * @param _to The address to transfer to.
75     * @param _value The amount to be transferred.
76     */
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80 
81         // SafeMath.sub will throw if there is not enough balance.
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89     * @dev Gets the balance of the specified address.
90     * @param _owner The address to query the the balance of.
91     * @return An uint256 representing the amount owned by the passed address.
92     */
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109     mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112     /**
113      * @dev Transfer tokens from one address to another
114      * @param _from address The address which you want to send tokens from
115      * @param _to address The address which you want to transfer to
116      * @param _value uint256 the amount of tokens to be transferred
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      *
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param _owner address The address which owns the funds.
149      * @param _spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address _owner, address _spender) public view returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156     /**
157      * approve should be called when allowed[_spender] == 0. To increment
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      */
162     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
169         uint oldValue = allowed[msg.sender][_spender];
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174         }
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179 }
180 
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188     address public owner;
189 
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193 
194     /**
195      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196      * account.
197      */
198     function Ownable() public {
199         owner = msg.sender;
200     }
201 
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(msg.sender == owner);
208         _;
209     }
210 
211 
212     /**
213      * @dev Allows the current owner to transfer control of the contract to a newOwner.
214      * @param newOwner The address to transfer ownership to.
215      */
216     function transferOwnership(address newOwner) public onlyOwner {
217         require(newOwner != address(0));
218         OwnershipTransferred(owner, newOwner);
219         owner = newOwner;
220     }
221 
222 }
223 
224 
225 /**
226  * @title Burnable Token
227  * @dev Token that can be irreversibly burned (destroyed).
228  */
229 contract BurnableToken is StandardToken, Ownable {
230 
231     event Burn(address indexed burner, uint256 value);
232 
233     /**
234      * @dev Burns a specific amount of tokens.
235      * @param _value The amount of token to be burned.
236      */
237     function burn(uint256 _value) public onlyOwner {
238         require(_value > 0);
239         require(_value <= balances[msg.sender]);
240         // no need to require value <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         address burner = msg.sender;
244         balances[burner] = balances[burner].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246         Burn(burner, _value);
247     }
248 }
249 
250 
251 contract WePoolToken is BurnableToken {
252 
253     string public constant name = "WePool";
254     string public constant symbol = "WPL";
255     uint32 public constant decimals = 18;
256 
257     function WePoolToken() public {
258         totalSupply = 200000000 * 1E18; // 200 million tokens
259         balances[owner] = totalSupply;  // owner is crowdsale
260     }
261 }
262 
263 
264 contract WePoolCrowdsale is Ownable {
265     using SafeMath for uint256;
266 
267 
268     uint256 public hardCap;
269     uint256 public reserved;
270 
271     uint256 public tokensSold; // amount of bought tokens
272     uint256 public weiRaised; // total investments
273 
274     uint256 public minPurchase;
275     uint256 public preIcoRate; // how many token units a buyer gets per wei
276     uint256 public icoRate;
277 
278     address public wallet; // for withdrawal
279     address public tokenWallet; // for reserving tokens
280 
281     uint256 public icoStartTime;
282     uint256 public preIcoStartTime;
283 
284 
285     address[] public investorsArray;
286     mapping (address => uint256) public investors; //address -> amount
287 
288 
289     WePoolToken public token;
290      
291     modifier icoEnded() {
292         require(now > (icoStartTime + 30 days));
293         _;        
294     }
295 
296     /**
297      * @dev Constructor to WePoolCrowdsale contract
298      */
299     function WePoolCrowdsale(uint256 _preIcoStartTime, uint256 _icoStartTime) public {
300         require(_preIcoStartTime > now);
301         require(_icoStartTime > _preIcoStartTime + 7 days);
302         preIcoStartTime = _preIcoStartTime;
303         icoStartTime = _icoStartTime;
304 
305         minPurchase = 0.1 ether;
306         preIcoRate = 0.00008 ether;
307         icoRate = 0.0001 ether;
308 
309         hardCap = 200000000 * 1E18; // 200 million tokens * decimals
310 
311         token = new WePoolToken();
312 
313         reserved = hardCap.mul(35).div(100);
314         hardCap = hardCap.sub(reserved); // tokens left for sale (200m - 70 = 130)
315 
316         wallet = owner;
317         tokenWallet = owner;
318     }
319 
320     /**
321      * @dev Function set new wallet address. Wallet is used for withdrawal
322      * @param newWallet Address of new wallet.
323      */
324     function changeWallet(address newWallet) public onlyOwner {
325         require(newWallet != address(0));
326         wallet = newWallet;
327     }
328 
329     /**
330      * @dev Function set new token wallet address
331      * @dev Token wallet is used for reserving tokens for founders
332      * @param newAddress Address of new Token Wallet
333      */
334     function changeTokenWallet(address newAddress) public onlyOwner {
335         require(newAddress != address(0));
336         tokenWallet = newAddress;
337     }
338 
339     /**
340      @dev Function set new preIco token price
341      @param newRate New preIco price per token
342      */
343     function changePreIcoRate(uint256 newRate) public onlyOwner {
344         require(newRate > 0);
345         preIcoRate = newRate;
346     }
347 
348     /**
349      @dev Function set new Ico token price
350      @param newRate New Ico price per token
351      */
352     function changeIcoRate(uint256 newRate) public onlyOwner {
353         require(newRate > 0);
354         icoRate = newRate;
355     }
356 
357     /**
358      * @dev Function set new preIco start time
359      * @param newTime New preIco start time
360      */
361     function changePreIcoStartTime(uint256 newTime) public onlyOwner {
362         require(now < preIcoStartTime);
363         require(newTime > now);
364         require(icoStartTime > newTime + 7 days);
365         preIcoStartTime = newTime;
366     }
367 
368     /**
369      * @dev Function set new Ico start time
370      * @param newTime New Ico start time
371      */
372     function changeIcoStartTime(uint256 newTime) public onlyOwner {
373         require(now < icoStartTime);
374         require(newTime > now);
375         require(newTime > preIcoStartTime + 7 days);
376         icoStartTime = newTime;
377     }
378 
379     /**
380      * @dev Function burn all unsold Tokens (balance of crowdsale)
381      * @dev Ico should be ended
382      */
383     function burnUnsoldTokens() public onlyOwner icoEnded {
384         token.burn(token.balanceOf(this));
385     }
386 
387     /**
388      * @dev Function transfer all raised money to the founders wallet
389      * @dev Ico should be ended
390      */
391     function withdrawal() public onlyOwner icoEnded {
392         wallet.transfer(this.balance);    
393     }
394 
395     /**
396      * @dev Function reserve tokens for founders and bounty program
397      * @dev Ico should be ended
398      */
399     function getReservedTokens() public onlyOwner icoEnded {
400         require(reserved > 0);
401         uint256 amount = reserved;
402         reserved = 0;
403         token.transfer(tokenWallet, amount);
404     }
405 
406     /**
407      * @dev Fallback function
408      */
409     function() public payable {
410         buyTokens();
411     }
412 
413     /**
414      * @dev Function for investments.
415      */
416     function buyTokens() public payable {
417         address inv = msg.sender;
418         
419         uint256 weiAmount = msg.value;
420         require(weiAmount >= minPurchase);
421 
422         uint256 rate;
423         uint256 tokens;
424         uint256 cleanWei; // amount of wei to use for purchase excluding change and hardcap overflows
425         uint256 change;
426 
427         if (now > preIcoStartTime && now < (preIcoStartTime + 7 days)) {
428             rate = preIcoRate;
429         } else if (now > icoStartTime && now < (icoStartTime + 30 days)) {
430             rate = icoRate;
431         }
432         require(rate > 0);
433     
434         tokens = (weiAmount.mul(1E18)).div(rate);
435 
436         // check hardCap
437         if (tokensSold.add(tokens) > hardCap) {
438             tokens = hardCap.sub(tokensSold);
439             cleanWei = tokens.mul(rate).div(1E18);
440             change = weiAmount.sub(cleanWei);
441         } else {
442             cleanWei = weiAmount;
443         }
444 
445         // check, if this investor already included
446         if (investors[inv] == 0) {
447             investorsArray.push(inv);
448             investors[inv] = tokens;
449         } else {
450             investors[inv] = investors[inv].add(tokens);
451         }
452 
453         tokensSold = tokensSold.add(tokens);
454         weiRaised = weiRaised.add(cleanWei);
455 
456         token.transfer(inv, tokens);
457 
458         // send back change
459         if (change > 0) {
460             inv.transfer(change); 
461         }
462     }
463 
464     /**
465      * @dev Function returns the number of investors.
466      * @return uint256 Number of investors.
467      */
468     function getInvestorsLength() public view returns(uint256) {
469         return investorsArray.length;
470     }
471 }