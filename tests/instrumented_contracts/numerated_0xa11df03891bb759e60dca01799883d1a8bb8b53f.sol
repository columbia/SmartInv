1 /**
2  *Submitted for verification at Etherscan.io on 2017-11-28
3 */
4 
5 pragma solidity ^0.5.12;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46     address public owner;
47 
48     /**
49       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50       * account.
51       */
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     /**
57       * @dev Throws if called by any account other than the owner.
58       */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) public onlyOwner {
69         if (newOwner != address(0)) {
70             owner = newOwner;
71         }
72     }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20Basic {
82     uint public _totalSupply;
83     function totalSupply() public view returns (uint);
84     function balanceOf(address who) public view returns (uint);
85     function transfer(address to, uint value) public;
86     event Transfer(address indexed from, address indexed to, uint value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public view returns (uint);
95     function transferFrom(address from, address to, uint value) public;
96     function approve(address spender, uint value) public;
97     event Approval(address indexed owner, address indexed spender, uint value);
98 }
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is Ownable, ERC20Basic {
105     using SafeMath for uint;
106 
107     mapping(address => uint) public balances;
108 
109     // additional variables for use if transaction fees ever became necessary
110     uint public maximumFee = 0;
111 
112     /**
113     * @dev Fix for the ERC20 short address attack.
114     */
115     modifier onlyPayloadSize(uint size) {
116         require(!(msg.data.length < size + 4));
117         _;
118     }
119 
120     /**
121     * @dev transfer token for a specified address
122     * @param _to The address to transfer to.
123     * @param _value The amount to be transferred.
124     */
125     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         emit Transfer(msg.sender, _to, _value);
129     }
130 
131     /**
132     * @dev Gets the balance of the specified address.
133     * @param _owner The address to query the the balance of.
134     * @return An uint representing the amount owned by the passed address.
135     */
136     function balanceOf(address _owner) public view returns (uint balance) {
137         return balances[_owner];
138     }
139 
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is BasicToken, ERC20 {
150 
151     mapping (address => mapping (address => uint)) public allowed;
152 
153     uint public MAX_UINT = 2**256 - 1;
154 
155     /**
156     * @dev Transfer tokens from one address to another
157     * @param _from address The address which you want to send tokens from
158     * @param _to address The address which you want to transfer to
159     * @param _value uint the amount of tokens to be transferred
160     */
161     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
162         uint256 _allowance = allowed[_from][msg.sender];
163 
164         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
165         // if (_value > _allowance) throw;
166         if (_allowance < MAX_UINT) {
167             allowed[_from][msg.sender] = _allowance.sub(_value);
168         }
169 
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172 
173         emit Transfer(_from, _to, _value);
174     }
175 
176     /**
177     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178     * @param _spender The address which will spend the funds.
179     * @param _value The amount of tokens to be spent.
180     */
181     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
182 
183         // To change the approve amount you first have to reduce the addresses`
184         //  allowance to zero by calling `approve(_spender, 0)` if it is not
185         //  already 0 to mitigate the race condition described here:
186         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
188 
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191     }
192 
193     /**
194     * @dev Function to check the amount of tokens than an owner allowed to a spender.
195     * @param _owner address The address which owns the funds.
196     * @param _spender address The address which will spend the funds.
197     * @return A uint specifying the amount of tokens still available for the spender.
198     */
199     function allowance(address _owner, address _spender) public view returns (uint remaining) {
200         return allowed[_owner][_spender];
201     }
202 
203 }
204 
205 
206 /**
207  * @title Pausable
208  * @dev Base contract which allows children to implement an emergency stop mechanism.
209  */
210 contract Pausable is Ownable {
211     event Pause();
212     event Unpause();
213 
214     bool public paused = false;
215 
216 
217     /**
218      * @dev Modifier to make a function callable only when the contract is not paused.
219      */
220     modifier whenNotPaused() {
221         require(!paused);
222         _;
223     }
224 
225     /**
226      * @dev Modifier to make a function callable only when the contract is paused.
227      */
228     modifier whenPaused() {
229         require(paused);
230         _;
231     }
232 
233     /**
234      * @dev called by the owner to pause, triggers stopped state
235      */
236     function pause() onlyOwner whenNotPaused public {
237         paused = true;
238         emit Pause();
239     }
240 
241     /**
242      * @dev called by the owner to unpause, returns to normal state
243      */
244     function unpause() onlyOwner whenPaused public {
245         paused = false;
246         emit Unpause();
247     }
248 }
249 
250 contract BlackList is Ownable, BasicToken {
251 
252     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded DBP) ///////
253     function getBlackListStatus(address _maker) external view returns (bool) {
254         return isBlackListed[_maker];
255     }
256 
257     function getOwner() external view returns (address) {
258         return owner;
259     }
260 
261     mapping (address => bool) public isBlackListed;
262 
263     function addBlackList (address _evilUser) public onlyOwner {
264         isBlackListed[_evilUser] = true;
265         emit AddedBlackList(_evilUser);
266     }
267 
268     function removeBlackList (address _clearedUser) public onlyOwner {
269         isBlackListed[_clearedUser] = false;
270         emit RemovedBlackList(_clearedUser);
271     }
272 
273     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
274         require(isBlackListed[_blackListedUser]);
275         uint dirtyFunds = balanceOf(_blackListedUser);
276         balances[_blackListedUser] = 0;
277         _totalSupply -= dirtyFunds;
278         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
279     }
280 
281     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
282 
283     event AddedBlackList(address _user);
284 
285     event RemovedBlackList(address _user);
286 
287 }
288 
289 contract UpgradedStandardToken is StandardToken{
290     // those methods are called by the legacy contract
291     // and they must ensure msg.sender to be the contract address
292     function transferByLegacy(address from, address to, uint value) public;
293     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
294     function approveByLegacy(address from, address spender, uint value) public;
295 }
296 
297 contract ERCToken is Pausable, StandardToken, BlackList {
298 
299     string public name;
300     string public symbol;
301     uint public decimals;
302     address public upgradedAddress;
303     bool public deprecated;
304 
305     //  The contract can be initialized with a number of tokens
306     //  All the tokens are deposited to the owner address
307     //
308     // @param _balance Initial supply of the contract
309     // @param _name Token Name
310     // @param _symbol Token symbol
311     // @param _decimals Token decimals
312     constructor(uint _initialSupply, string memory _name, string memory _symbol, uint _decimals) public {
313         _totalSupply = _initialSupply;
314         name = _name;
315         symbol = _symbol;
316         decimals = _decimals;
317         balances[owner] = _initialSupply;
318         deprecated = false;
319     }
320 
321     // Forward ERC20 methods to upgraded contract if this one is deprecated
322     function transfer(address _to, uint _value) public whenNotPaused {
323         require(!isBlackListed[msg.sender]);
324         if (deprecated) {
325             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
326         } else {
327             return super.transfer(_to, _value);
328         }
329     }
330 
331     // Forward ERC20 methods to upgraded contract if this one is deprecated
332     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
333         require(!isBlackListed[_from]);
334         if (deprecated) {
335             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
336         } else {
337             return super.transferFrom(_from, _to, _value);
338         }
339     }
340 
341     // Forward ERC20 methods to upgraded contract if this one is deprecated
342     function balanceOf(address who) public view returns (uint) {
343         if (deprecated) {
344             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
345         } else {
346             return super.balanceOf(who);
347         }
348     }
349 
350     // Forward ERC20 methods to upgraded contract if this one is deprecated
351     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
352         if (deprecated) {
353             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
354         } else {
355             return super.approve(_spender, _value);
356         }
357     }
358 
359     // Forward ERC20 methods to upgraded contract if this one is deprecated
360     function allowance(address _owner, address _spender) public view returns (uint remaining) {
361         if (deprecated) {
362             return StandardToken(upgradedAddress).allowance(_owner, _spender);
363         } else {
364             return super.allowance(_owner, _spender);
365         }
366     }
367 
368     // deprecate current contract in favour of a new one
369     function deprecate(address _upgradedAddress) public onlyOwner {
370         deprecated = true;
371         upgradedAddress = _upgradedAddress;
372         emit Deprecate(_upgradedAddress);
373     }
374 
375     // deprecate current contract if favour of a new one
376     function totalSupply() public view returns (uint) {
377         if (deprecated) {
378             return StandardToken(upgradedAddress).totalSupply();
379         } else {
380             return _totalSupply;
381         }
382     }
383 
384     // Called when contract is deprecated
385     event Deprecate(address newAddress);
386 
387 }