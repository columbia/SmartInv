1 // SPDX-License-Identifier: SimPL-2.0
2 pragma solidity ^0.6.7;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     address public owner;
44 
45     /**
46       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47       * account.
48       */
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     /**
54       * @dev Throws if called by any account other than the owner.
55       */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62     * @dev Allows the current owner to transfer control of the contract to a newOwner.
63     * @param newOwner The address to transfer ownership to.
64     */
65     function transferOwnership(address newOwner) public onlyOwner {
66         if (newOwner != address(0)) {
67             owner = newOwner;
68         }
69     }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 abstract contract ERC20Basic {
79     uint public _totalSupply;
80     function totalSupply() public virtual view returns (uint);
81     function balanceOf(address who) public virtual view returns (uint);
82     function transfer(address to, uint value) public virtual;
83     event Transfer(address indexed from, address indexed to, uint value);
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 abstract contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public virtual view returns (uint);
92     function transferFrom(address from, address to, uint value) public virtual;
93     function approve(address spender, uint value) public virtual;
94     event Approval(address indexed owner, address indexed spender, uint value);
95 }
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 abstract contract BasicToken is Ownable, ERC20Basic {
102     using SafeMath for uint;
103 
104     mapping(address => uint) public balances;
105 
106     // additional variables for use if transaction fees ever became necessary
107     uint public basisPointsRate = 0;
108     uint public maximumFee = 0;
109 
110     /**
111     * @dev Fix for the ERC20 short address attack.
112     */
113     modifier onlyPayloadSize(uint size) {
114         require(!(msg.data.length < size + 4));
115         _;
116     }
117 
118     /**
119     * @dev transfer token for a specified address
120     * @param _to The address to transfer to.
121     * @param _value The amount to be transferred.
122     */
123     function transfer(address _to, uint _value) public virtual override onlyPayloadSize(2 * 32) {
124         uint fee = (_value.mul(basisPointsRate)).div(10000);
125         if (fee > maximumFee) {
126             fee = maximumFee;
127         }
128         uint sendAmount = _value.sub(fee);
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(sendAmount);
131         if (fee > 0) {
132             balances[owner] = balances[owner].add(fee);
133             emit Transfer(msg.sender, owner, fee);
134         }
135         Transfer(msg.sender, _to, sendAmount);
136     }
137 
138     function balanceOf(address _owner) public virtual override view returns (uint balance) {
139         return  balances[_owner];
140     }
141 
142 }
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 abstract contract StandardToken is BasicToken, ERC20 {
152 
153     mapping (address => mapping (address => uint)) public allowed;
154 
155     uint public constant MAX_UINT = 2**256 - 1;
156 
157     /**
158     * @dev Transfer tokens from one address to another
159     * @param _from address The address which you want to send tokens from
160     * @param _to address The address which you want to transfer to
161     * @param _value uint the amount of tokens to be transferred
162     */
163     function transferFrom(address _from, address _to, uint _value) public virtual override onlyPayloadSize(3 * 32) {
164         uint256 _allowance = allowed[_from][msg.sender];
165 
166         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
167         // if (_value > _allowance) throw;
168 
169         uint fee = (_value.mul(basisPointsRate)).div(10000);
170         if (fee > maximumFee) {
171             fee = maximumFee;
172         }
173         if (_allowance < MAX_UINT) {
174             allowed[_from][msg.sender] = _allowance.sub(_value);
175         }
176         uint sendAmount = _value.sub(fee);
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(sendAmount);
179         if (fee > 0) {
180             balances[owner] = balances[owner].add(fee);
181             Transfer(_from, owner, fee);
182         }
183         Transfer(_from, _to, sendAmount);
184     }
185 
186     /**
187     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188     * @param _spender The address which will spend the funds.
189     * @param _value The amount of tokens to be spent.
190     */
191     function approve(address _spender, uint _value) public virtual override onlyPayloadSize(2 * 32) {
192 
193         // To change the approve amount you first have to reduce the addresses`
194         //  allowance to zero by calling `approve(_spender, 0)` if it is not
195         //  already 0 to mitigate the race condition described here:
196         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
198 
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201     }
202 
203     
204     function allowance(address _owner, address _spender) public virtual override view returns (uint remaining) {
205         return allowed[_owner][_spender];
206     }
207 
208 }
209 
210 
211 /**
212  * @title Pausable
213  * @dev Base contract which allows children to implement an emergency stop mechanism.
214  */
215 contract Pausable is Ownable {
216   event Pause();
217   event Unpause();
218 
219   bool public paused = false;
220 
221 
222   /**
223    * @dev Modifier to make a function callable only when the contract is not paused.
224    */
225   modifier whenNotPaused() {
226     require(!paused);
227     _;
228   }
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is paused.
232    */
233   modifier whenPaused() {
234     require(paused);
235     _;
236   }
237 
238   /**
239    * @dev called by the owner to pause, triggers stopped state
240    */
241   function pause() onlyOwner whenNotPaused public {
242     paused = true;
243     Pause();
244   }
245 
246   /**
247    * @dev called by the owner to unpause, returns to normal state
248    */
249   function unpause() onlyOwner whenPaused public {
250     paused = false;
251     Unpause();
252   }
253 }
254 
255 abstract contract BlackList is Ownable, BasicToken {
256 
257     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
258     function getBlackListStatus(address _maker) external view returns (bool) {
259         return isBlackListed[_maker];
260     }
261 
262     function getOwner() external view returns (address) {
263         return owner;
264     }
265 
266     mapping (address => bool) public isBlackListed;
267     
268     function addBlackList (address _evilUser) public onlyOwner {
269         isBlackListed[_evilUser] = true;
270         AddedBlackList(_evilUser);
271     }
272 
273     function removeBlackList (address _clearedUser) public onlyOwner {
274         isBlackListed[_clearedUser] = false;
275         RemovedBlackList(_clearedUser);
276     }
277 
278     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
279         require(isBlackListed[_blackListedUser]);
280         uint dirtyFunds = balanceOf(_blackListedUser);
281         balances[_blackListedUser] = 0;
282         _totalSupply -= dirtyFunds;
283         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
284     }
285 
286     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
287 
288     event AddedBlackList(address _user);
289 
290     event RemovedBlackList(address _user);
291 
292 }
293 
294 abstract contract UpgradedStandardToken is StandardToken{
295     // those methods are called by the legacy contract
296     // and they must ensure msg.sender to be the contract address
297     function transferByLegacy(address from, address to, uint value) public virtual;
298     function transferFromByLegacy(address sender, address from, address spender, uint value) public virtual;
299     function approveByLegacy(address from, address spender, uint value) public virtual;
300 }
301 
302 contract JHTDToken is Pausable, StandardToken, BlackList {
303 
304     string public name = "JHTD";
305     string public symbol = "JHTD";
306     uint public decimals = 6;
307     uint public _initialSupply = 5*10**14;
308     address public upgradedAddress;
309     bool public deprecated;
310 
311     //  The contract can be initialized with a number of tokens
312     //  All the tokens are deposited to the owner address
313     //
314     // @param _balance Initial supply of the contract
315     // @param _name Token Name
316     // @param _symbol Token symbol
317     // @param _decimals Token decimals
318     constructor() public payable{
319         _totalSupply = _initialSupply;
320         balances[owner] = _initialSupply;
321         deprecated = false;
322     }
323 
324     // Forward ERC20 methods to upgraded contract if this one is deprecated
325     function transfer(address _to, uint _value) public override whenNotPaused {
326         require(!isBlackListed[msg.sender]);
327         if (deprecated) {
328             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
329         } else {
330             return super.transfer(_to, _value);
331         }
332     }
333 
334     // Forward ERC20 methods to upgraded contract if this one is deprecated
335     function transferFrom(address _from, address _to, uint _value) public override whenNotPaused {
336         require(!isBlackListed[_from]);
337         if (deprecated) {
338             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
339         } else {
340             return super.transferFrom(_from, _to, _value);
341         }
342     }
343 
344     // Forward ERC20 methods to upgraded contract if this one is deprecated
345     function balanceOf(address who) public override view returns (uint) {
346         if (deprecated) {
347             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
348         } else {
349             return super.balanceOf(who);
350         }
351     }
352 
353     // Forward ERC20 methods to upgraded contract if this one is deprecated
354     function approve(address _spender, uint _value) public override onlyPayloadSize(2 * 32) {
355         if (deprecated) {
356             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
357         } else {
358             return super.approve(_spender, _value);
359         }
360     }
361 
362     // Forward ERC20 methods to upgraded contract if this one is deprecated
363     function allowance(address _owner, address _spender) public override view returns (uint remaining) {
364         if (deprecated) {
365             return StandardToken(upgradedAddress).allowance(_owner, _spender);
366         } else {
367             return super.allowance(_owner, _spender);
368         }
369     }
370 
371     // deprecate current contract in favour of a new one
372     function deprecate(address _upgradedAddress) public onlyOwner {
373         deprecated = true;
374         upgradedAddress = _upgradedAddress;
375         Deprecate(_upgradedAddress);
376     }
377 
378     // deprecate current contract if favour of a new one
379     function totalSupply() public override view returns (uint) {
380         if (deprecated) {
381             return StandardToken(upgradedAddress).totalSupply();
382         } else {
383             return _totalSupply;
384         }
385     }
386 
387     // Redeem tokens.
388     // These tokens are withdrawn from the owner address
389     // if the balance must be enough to cover the redeem
390     // or the call will fail.
391     // @param _amount Number of tokens to be issued
392     function redeem(uint amount) public onlyOwner {
393         require(_totalSupply >= amount);
394         require(balances[owner] >= amount);
395 
396         _totalSupply -= amount;
397         balances[owner] -= amount;
398         Redeem(amount);
399     }
400 
401     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
402         // Ensure transparency by hardcoding limit beyond which fees can never be added
403         require(newBasisPoints < 20);
404         require(newMaxFee < 50);
405 
406         basisPointsRate = newBasisPoints;
407         maximumFee = newMaxFee.mul(10**decimals);
408 
409         Params(basisPointsRate, maximumFee);
410     }
411 
412     // Called when new token are issued
413     event Issue(uint amount);
414 
415     // Called when tokens are redeemed
416     event Redeem(uint amount);
417 
418     // Called when contract is deprecated
419     event Deprecate(address newAddress);
420 
421     // Called if contract ever adds fees
422     event Params(uint feeBasisPoints, uint maxFee);
423 }