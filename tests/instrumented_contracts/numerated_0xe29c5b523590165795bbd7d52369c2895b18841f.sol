1 contract ESportsConstants {
2     uint constant TOKEN_DECIMALS = 18;
3     uint8 constant TOKEN_DECIMALS_UINT8 = uint8(TOKEN_DECIMALS);
4     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
5 
6     uint constant RATE = 240; // = 1 ETH
7 }
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal constant returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal constant returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     function Ownable() {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) onlyOwner {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 contract ESportsFreezingStorage is Ownable {
77     // Timestamp when token release is enabled
78     uint64 public releaseTime;
79 
80     // ERC20 basic token contract being held
81     // ERC20Basic token;
82     ESportsToken token;
83     
84     function ESportsFreezingStorage(ESportsToken _token, uint64 _releaseTime) { //ERC20Basic
85         require(_releaseTime > now);
86         
87         releaseTime = _releaseTime;
88         token = _token;
89     }
90 
91     function release(address _beneficiary) onlyOwner returns(uint) {
92         //require(now >= releaseTime);
93         if (now < releaseTime) return 0;
94 
95         uint amount = token.balanceOf(this);
96         //require(amount > 0);
97         if (amount == 0)  return 0;
98 
99         // token.safeTransfer(beneficiary, amount);
100         //require(token.transfer(_beneficiary, amount));
101         bool result = token.transfer(_beneficiary, amount);
102         if (!result) return 0;
103         
104         return amount;
105     }
106 }
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114     uint256 public totalSupply;
115     function balanceOf(address who) constant returns (uint256);
116     function transfer(address to, uint256 value) returns (bool);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   	function allowance(address owner, address spender) constant returns (uint256);
126   	function transferFrom(address from, address to, uint256 value) returns (bool);
127   	function approve(address spender, uint256 value) returns (bool);
128   	event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances. 
134  */
135 contract BasicToken is ERC20Basic {
136     using SafeMath for uint256;
137 
138     mapping (address => uint256) balances;
139 
140     /**
141     * @dev transfer token for a specified address
142     * @param _to The address to transfer to.
143     * @param _value The amount to be transferred.
144     */
145     function transfer(address _to, uint256 _value) returns (bool) {
146         require(_to != address(0));
147 
148         // SafeMath.sub will throw if there is not enough balance.
149         balances[msg.sender] = balances[msg.sender].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     /**
156     * @dev Gets the balance of the specified address.
157     * @param _owner The address to query the the balance of.
158     * @return An uint256 representing the amount owned by the passed address.
159     */
160     function balanceOf(address _owner) constant returns (uint256 balance) {
161         return balances[_owner];
162     }
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken {
173 
174     mapping (address => mapping (address => uint256)) allowed;
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amount of tokens to be transferred
181      */
182     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
183         require(_to != address(0));
184 
185         var _allowance = allowed[_from][msg.sender];
186 
187         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
188         // require (_value <= _allowance);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = _allowance.sub(_value);
193         Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     /**
198      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199      * @param _spender The address which will spend the funds.
200      * @param _value The amount of tokens to be spent.
201      */
202     function approve(address _spender, uint256 _value) returns (bool) {
203 
204         // To change the approve amount you first have to reduce the addresses`
205         //  allowance to zero by calling `approve(_spender, 0)` if it is not
206         //  already 0 to mitigate the race condition described here:
207         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
209 
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      * @param _owner address The address which owns the funds.
218      * @param _spender address The address which will spend the funds.
219      * @return A uint256 specifying the amount of tokens still available for the spender.
220      */
221     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
222         return allowed[_owner][_spender];
223     }
224 
225     /**
226      * approve should be called when allowed[_spender] == 0. To increment
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      */
231     function increaseApproval(address _spender, uint _addedValue) returns (bool success) {
232         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237     function decreaseApproval(address _spender, uint _subtractedValue) returns (bool success) {
238         uint oldValue = allowed[msg.sender][_spender];
239         if (_subtractedValue > oldValue) {
240             allowed[msg.sender][_spender] = 0;
241         }
242         else {
243             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244         }
245         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 }
249 
250 /**
251  * @title Mintable token
252  * @dev Simple ERC20 Token example, with mintable token creation
253  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
254  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
255  */
256 contract MintableToken is StandardToken, Ownable {
257     event Mint(address indexed to, uint256 amount);
258 
259     event MintFinished();
260 
261     bool public mintingFinished = false;
262 
263     modifier canMint() {
264         require(!mintingFinished);
265         _;
266     }
267 
268     /**
269      * @dev Function to mint tokens
270      * @param _to The address that will receive the minted tokens.
271      * @param _amount The amount of tokens to mint.
272      * @return A boolean that indicates if the operation was successful.
273      */
274     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
275         totalSupply = totalSupply.add(_amount);
276         balances[_to] = balances[_to].add(_amount);
277         Mint(_to, _amount);
278         Transfer(0x0, _to, _amount);
279         return true;
280     }
281 
282     /**
283      * @dev Function to stop minting new tokens.
284      * @return True if the operation was successful.
285      */
286     function finishMinting() onlyOwner returns (bool) {
287         mintingFinished = true;
288         MintFinished();
289         return true;
290     }
291 }
292 
293 contract ESportsToken is ESportsConstants, MintableToken {
294     using SafeMath for uint;
295 
296     event Burn(address indexed burner, uint value);
297     event MintTimelocked(address indexed beneficiary, uint amount);
298 
299     /**
300      * @dev Pause token transfer. After successfully finished crowdsale it becomes false
301      */
302     bool public paused = true;
303     /**
304      * @dev Accounts who can transfer token even if paused. Works only during crowdsale
305      */
306     mapping(address => bool) excluded;
307 
308     mapping (address => ESportsFreezingStorage[]) public frozenFunds;
309 
310     function name() constant public returns (string _name) {
311         return "ESports Token";
312     }
313 
314     function symbol() constant public returns (string _symbol) {
315         return "ERT";
316     }
317 
318     function decimals() constant public returns (uint8 _decimals) {
319         return TOKEN_DECIMALS_UINT8;
320     }
321     
322     function allowMoveTokens() onlyOwner {
323         paused = false;
324     }
325 
326     function addExcluded(address _toExclude) onlyOwner {
327         addExcludedInternal(_toExclude);
328     }
329     
330     function addExcludedInternal(address _toExclude) private {
331         excluded[_toExclude] = true;
332     }
333 
334     /**
335      * @dev Wrapper of token.transferFrom
336      */
337     function transferFrom(address _from, address _to, uint _value) returns (bool) {
338         require(!paused || excluded[_from]);
339 
340         return super.transferFrom(_from, _to, _value);
341     }
342 
343     /**
344      * @dev Wrapper of token.transfer 
345      */
346     function transfer(address _to, uint _value) returns (bool) {
347         require(!paused || excluded[msg.sender]);
348 
349         return super.transfer(_to, _value);
350     }
351 
352     /**
353      * @dev Mint timelocked tokens
354      */
355     function mintTimelocked(address _to, uint _amount, uint32 _releaseTime)
356             onlyOwner canMint returns (ESportsFreezingStorage) {
357         ESportsFreezingStorage timelock = new ESportsFreezingStorage(this, _releaseTime);
358         mint(timelock, _amount);
359 
360         frozenFunds[_to].push(timelock);
361         addExcludedInternal(timelock);
362 
363         MintTimelocked(_to, _amount);
364 
365         return timelock;
366     }
367 
368     /**
369      * @dev Release frozen tokens
370      * @return Total amount of released tokens
371      */
372     function returnFrozenFreeFunds() public returns (uint) {
373         uint total = 0;
374         ESportsFreezingStorage[] storage frozenStorages = frozenFunds[msg.sender];
375         // for (uint x = 0; x < frozenStorages.length; x++) {
376         //     uint amount = balanceOf(frozenStorages[x]);
377         //     if (frozenStorages[x].call(bytes4(sha3("release(address)")), msg.sender))
378         //         total = total.add(amount);
379         // }
380         for (uint x = 0; x < frozenStorages.length; x++) {
381             uint amount = frozenStorages[x].release(msg.sender);
382             total = total.add(amount);
383         }
384         
385         return total;
386     }
387 
388     /**
389      * @dev Burns a specific amount of tokens.
390      * @param _value The amount of token to be burned.
391      */
392     function burn(uint _value) public {
393         require(!paused || excluded[msg.sender]);
394         require(_value > 0);
395 
396         balances[msg.sender] = balances[msg.sender].sub(_value);
397         totalSupply = totalSupply.sub(_value);
398         
399         Burn(msg.sender, _value);
400     }
401 }