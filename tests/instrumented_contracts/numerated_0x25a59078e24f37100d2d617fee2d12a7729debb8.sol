1 pragma solidity ^0.5.12;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     /**
45       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46       * account.
47       */
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     /**
53       * @dev Throws if called by any account other than the owner.
54       */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20Basic {
78     uint public _totalSupply;
79     function totalSupply() public view returns (uint);
80     function balanceOf(address who) public view returns (uint);
81     function transfer(address to, uint value) public;
82     event Transfer(address indexed from, address indexed to, uint value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public view returns (uint);
91     function transferFrom(address from, address to, uint value) public;
92     function approve(address spender, uint value) public;
93     event Approval(address indexed owner, address indexed spender, uint value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is Ownable, ERC20Basic {
101     using SafeMath for uint;
102 
103     mapping(address => uint) public balances;
104 
105     // additional variables for use if transaction fees ever became necessary
106     uint public maximumFee = 0;
107 
108     /**
109     * @dev Fix for the ERC20 short address attack.
110     */
111     modifier onlyPayloadSize(uint size) {
112         require(!(msg.data.length < size + 4));
113         _;
114     }
115 
116     /**
117     * @dev transfer token for a specified address
118     * @param _to The address to transfer to.
119     * @param _value The amount to be transferred.
120     */
121     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         emit Transfer(msg.sender, _to, _value);
125     }
126 
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param _owner The address to query the the balance of.
130     * @return An uint representing the amount owned by the passed address.
131     */
132     function balanceOf(address _owner) public view returns (uint balance) {
133         return balances[_owner];
134     }
135 
136 }
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is BasicToken, ERC20 {
146 
147     mapping (address => mapping (address => uint)) public allowed;
148 
149     uint public MAX_UINT = 2**256 - 1;
150 
151     /**
152     * @dev Transfer tokens from one address to another
153     * @param _from address The address which you want to send tokens from
154     * @param _to address The address which you want to transfer to
155     * @param _value uint the amount of tokens to be transferred
156     */
157     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
158         uint256 _allowance = allowed[_from][msg.sender];
159 
160         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
161         // if (_value > _allowance) throw;
162         if (_allowance < MAX_UINT) {
163             allowed[_from][msg.sender] = _allowance.sub(_value);
164         }
165 
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168 
169         emit Transfer(_from, _to, _value);
170     }
171 
172     /**
173     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174     * @param _spender The address which will spend the funds.
175     * @param _value The amount of tokens to be spent.
176     */
177     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
178 
179         // To change the approve amount you first have to reduce the addresses`
180         //  allowance to zero by calling `approve(_spender, 0)` if it is not
181         //  already 0 to mitigate the race condition described here:
182         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
184 
185         allowed[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187     }
188 
189     /**
190     * @dev Function to check the amount of tokens than an owner allowed to a spender.
191     * @param _owner address The address which owns the funds.
192     * @param _spender address The address which will spend the funds.
193     * @return A uint specifying the amount of tokens still available for the spender.
194     */
195     function allowance(address _owner, address _spender) public view returns (uint remaining) {
196         return allowed[_owner][_spender];
197     }
198 
199 }
200 
201 
202 /**
203  * @title Pausable
204  * @dev Base contract which allows children to implement an emergency stop mechanism.
205  */
206 contract Pausable is Ownable {
207     event Pause();
208     event Unpause();
209 
210     bool public paused = false;
211 
212 
213     /**
214      * @dev Modifier to make a function callable only when the contract is not paused.
215      */
216     modifier whenNotPaused() {
217         require(!paused);
218         _;
219     }
220 
221     /**
222      * @dev Modifier to make a function callable only when the contract is paused.
223      */
224     modifier whenPaused() {
225         require(paused);
226         _;
227     }
228 
229     /**
230      * @dev called by the owner to pause, triggers stopped state
231      */
232     function pause() onlyOwner whenNotPaused public {
233         paused = true;
234         emit Pause();
235     }
236 
237     /**
238      * @dev called by the owner to unpause, returns to normal state
239      */
240     function unpause() onlyOwner whenPaused public {
241         paused = false;
242         emit Unpause();
243     }
244 }
245 
246 contract BlackList is Ownable, BasicToken {
247 
248     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded DBP) ///////
249     function getBlackListStatus(address _maker) external view returns (bool) {
250         return isBlackListed[_maker];
251     }
252 
253     function getOwner() external view returns (address) {
254         return owner;
255     }
256 
257     mapping (address => bool) public isBlackListed;
258 
259     function addBlackList (address _evilUser) public onlyOwner {
260         isBlackListed[_evilUser] = true;
261         emit AddedBlackList(_evilUser);
262     }
263 
264     function removeBlackList (address _clearedUser) public onlyOwner {
265         isBlackListed[_clearedUser] = false;
266         emit RemovedBlackList(_clearedUser);
267     }
268 
269     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
270         require(isBlackListed[_blackListedUser]);
271         uint dirtyFunds = balanceOf(_blackListedUser);
272         balances[_blackListedUser] = 0;
273         _totalSupply -= dirtyFunds;
274         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
275     }
276 
277     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
278 
279     event AddedBlackList(address _user);
280 
281     event RemovedBlackList(address _user);
282 
283 }
284 
285 contract UpgradedStandardToken is StandardToken{
286     // those methods are called by the legacy contract
287     // and they must ensure msg.sender to be the contract address
288     function transferByLegacy(address from, address to, uint value) public;
289     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
290     function approveByLegacy(address from, address spender, uint value) public;
291 }
292 
293 contract FIL6Z is Pausable, StandardToken, BlackList {
294 
295     string public name;
296     string public symbol;
297     uint public decimals;
298     address public upgradedAddress;
299     bool public deprecated;
300 
301     //  The contract can be initialized with a number of tokens
302     //  All the tokens are deposited to the owner address
303     //
304     // @param _balance Initial supply of the contract
305     // @param _name Token Name
306     // @param _symbol Token symbol
307     // @param _decimals Token decimals
308     constructor(uint _initialSupply, string memory _name, string memory _symbol, uint _decimals) public {
309         _totalSupply = _initialSupply;
310         name = _name;
311         symbol = _symbol;
312         decimals = _decimals;
313         balances[owner] = _initialSupply;
314         deprecated = false;
315     }
316 
317     // Forward ERC20 methods to upgraded contract if this one is deprecated
318     function transfer(address _to, uint _value) public whenNotPaused {
319         require(!isBlackListed[msg.sender]);
320         if (deprecated) {
321             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
322         } else {
323             return super.transfer(_to, _value);
324         }
325     }
326 
327     // Forward ERC20 methods to upgraded contract if this one is deprecated
328     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
329         require(!isBlackListed[_from]);
330         if (deprecated) {
331             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
332         } else {
333             return super.transferFrom(_from, _to, _value);
334         }
335     }
336 
337     // Forward ERC20 methods to upgraded contract if this one is deprecated
338     function balanceOf(address who) public view returns (uint) {
339         if (deprecated) {
340             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
341         } else {
342             return super.balanceOf(who);
343         }
344     }
345 
346     // Forward ERC20 methods to upgraded contract if this one is deprecated
347     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
348         if (deprecated) {
349             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
350         } else {
351             return super.approve(_spender, _value);
352         }
353     }
354 
355     // Forward ERC20 methods to upgraded contract if this one is deprecated
356     function allowance(address _owner, address _spender) public view returns (uint remaining) {
357         if (deprecated) {
358             return StandardToken(upgradedAddress).allowance(_owner, _spender);
359         } else {
360             return super.allowance(_owner, _spender);
361         }
362     }
363 
364     // deprecate current contract in favour of a new one
365     function deprecate(address _upgradedAddress) public onlyOwner {
366         deprecated = true;
367         upgradedAddress = _upgradedAddress;
368         emit Deprecate(_upgradedAddress);
369     }
370 
371     // deprecate current contract if favour of a new one
372     function totalSupply() public view returns (uint) {
373         if (deprecated) {
374             return StandardToken(upgradedAddress).totalSupply();
375         } else {
376             return _totalSupply;
377         }
378     }
379 
380     // Issue a new amount of tokens
381     // these tokens are deposited into the owner address
382     //
383     // @param _amount Number of tokens to be issued
384     function issue(uint amount) public onlyOwner {
385         require(_totalSupply + amount > _totalSupply);
386         require(balances[owner] + amount > balances[owner]);
387 
388         balances[owner] += amount;
389         _totalSupply += amount;
390         emit Issue(amount);
391     }
392 
393     // Redeem tokens.
394     // These tokens are withdrawn from the owner address
395     // if the balance must be enough to cover the redeem
396     // or the call will fail.
397     // @param _amount Number of tokens to be issued
398     function redeem(uint amount) public onlyOwner {
399         require(_totalSupply >= amount);
400         require(balances[owner] >= amount);
401 
402         _totalSupply -= amount;
403         balances[owner] -= amount;
404         emit Redeem(amount);
405     }
406 
407     // Called when new token are issued
408     event Issue(uint amount);
409 
410     // Called when tokens are redeemed
411     event Redeem(uint amount);
412 
413     // Called when contract is deprecated
414     event Deprecate(address newAddress);
415 
416 }