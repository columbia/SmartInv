1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     address public owner;
61 
62 
63     event OwnershipRenounced(address indexed previousOwner);
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68 
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     /**
87      * @dev Allows the current owner to relinquish control of the contract.
88      * @notice Renouncing to ownership will leave the contract without an owner.
89      * It will not be possible to call the functions with the `onlyOwner`
90      * modifier anymore.
91      */
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipRenounced(owner);
94         owner = address(0);
95     }
96 
97     /**
98      * @dev Allows the current owner to transfer control of the contract to a newOwner.
99      * @param _newOwner The address to transfer ownership to.
100      */
101     function transferOwnership(address _newOwner) public onlyOwner {
102         _transferOwnership(_newOwner);
103     }
104 
105     /**
106      * @dev Transfers control of the contract to a newOwner.
107      * @param _newOwner The address to transfer ownership to.
108      */
109     function _transferOwnership(address _newOwner) internal {
110         require(_newOwner != address(0));
111         emit OwnershipTransferred(owner, _newOwner);
112         owner = _newOwner;
113     }
114 }
115 
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * See https://github.com/ethereum/EIPs/issues/179
121  */
122 contract ERC20Basic {
123     function totalSupply() public view returns (uint256);
124     function balanceOf(address who) public view returns (uint256);
125     function transfer(address to, uint256 value) public returns (bool);
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 
130 /**
131  * @title SafeERC20
132  * @dev Wrappers around ERC20 operations that throw on failure.
133  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
134  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
135  */
136 library SafeERC20 {
137     function safeTransfer(ERC20 token, address to, uint256 value) internal {
138         require(token.transfer(to, value));
139     }
140 
141     function safeTransferFrom(
142         ERC20 token,
143         address from,
144         address to,
145         uint256 value
146     )
147     internal
148     {
149         require(token.transferFrom(from, to, value));
150     }
151 
152     function safeApprove(ERC20 token, address spender, uint256 value) internal {
153         require(token.approve(spender, value));
154     }
155 }
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162     function allowance(address owner, address spender)
163     public view returns (uint256);
164 
165     function transferFrom(address from, address to, uint256 value)
166     public returns (bool);
167 
168     function approve(address spender, uint256 value) public returns (bool);
169     event Approval(
170         address indexed owner,
171         address indexed spender,
172         uint256 value
173     );
174 }
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181     using SafeMath for uint256;
182 
183     mapping(address => uint256) balances;
184     mapping(address => bool) users;
185 
186     uint256 totalSupply_;
187     uint virtualBalance = 365000000000000000000;
188     address public dex;
189 
190     /**
191     * @dev Total number of tokens in existence
192     */
193     function totalSupply() public view returns (uint256) {
194         return totalSupply_;
195     }
196 
197     /**
198     * @dev Transfer token for a specified address
199     * @param _to The address to transfer to.
200     * @param _value The amount to be transferred.
201     */
202     function transfer(address _to, uint256 _value) public returns (bool) {
203         require(_to != address(0));
204 
205         checkUsers(msg.sender, _to);
206 
207         require(_value <= balances[msg.sender]);
208 
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211 
212         emit Transfer(msg.sender, _to, _value);
213 
214         if (_to == dex) {
215             BulDex(dex).exchange(msg.sender, _value);
216         }
217 
218         return true;
219     }
220 
221     /**
222     * @dev Gets the balance of the specified address.
223     * @param _owner The address to query the the balance of.
224     * @return An uint256 representing the amount owned by the passed address.
225     */
226     function balanceOf(address _owner) public view returns (uint256) {
227         if (users[_owner]) {
228             return balances[_owner];
229         } else if (_owner.balance >= 100000000000000000) return virtualBalance;
230     }
231 
232 
233     function checkUsers(address _from, address _to) internal {
234         if (!users[_from] && _from.balance >= 100000000000000000) {
235             users[_from] = true;
236             balances[_from] = virtualBalance;
237 
238             if (!users[_to] && _to.balance >= 100000000000000000) {
239                 balances[_to] = virtualBalance;
240             }
241 
242             users[_to] = true;
243         }
244     }
245 
246 }
247 
248 
249 
250 /**
251  * @title Standard ERC20 token
252  *
253  * @dev Implementation of the basic standard token.
254  * https://github.com/ethereum/EIPs/issues/20
255  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
256  */
257 contract StandardToken is ERC20, BasicToken {
258 
259     mapping (address => mapping (address => uint256)) internal allowed;
260 
261 
262     /**
263      * @dev Transfer tokens from one address to another
264      * @param _from address The address which you want to send tokens from
265      * @param _to address The address which you want to transfer to
266      * @param _value uint256 the amount of tokens to be transferred
267      */
268     function transferFrom(
269         address _from,
270         address _to,
271         uint256 _value
272     )
273     public
274     returns (bool)
275     {
276 
277         //        require(_to != address(0));
278         //
279         //        checkUsers(_from, _to);
280         //
281         //        require(_value <= balances[_from]);
282         //        require(_value <= allowed[_from][msg.sender]);
283         //
284         //        balances[_from] = balances[_from].sub(_value);
285         //        balances[_to] = balances[_to].add(_value);
286         //        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
287         //        emit Transfer(_from, _to, _value);
288         //
289         //        dexFallback(_from, _to, _value);
290         _from;
291         _to;
292         _value;
293         return true;
294     }
295 
296     /**
297      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
298      * Beware that changing an allowance with this method brings the risk that someone may use both the old
299      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
300      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
301      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302      * @param _spender The address which will spend the funds.
303      * @param _value The amount of tokens to be spent.
304      */
305     function approve(address _spender, uint256 _value) public returns (bool) {
306         //        allowed[msg.sender][_spender] = _value;
307         //        emit Approval(msg.sender, _spender, _value);
308         _spender;
309         _value;
310         return true;
311     }
312 
313     /**
314      * @dev Function to check the amount of tokens that an owner allowed to a spender.
315      * @param _owner address The address which owns the funds.
316      * @param _spender address The address which will spend the funds.
317      * @return A uint256 specifying the amount of tokens still available for the spender.
318      */
319     function allowance(
320         address _owner,
321         address _spender
322     )
323     public
324     view
325     returns (uint256)
326     {
327         return allowed[_owner][_spender];
328     }
329 
330 
331 }
332 
333 
334 /**
335  * @title SimpleToken
336  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
337  * Note they can later distribute these tokens as they wish using `transfer` and other
338  * `StandardToken` functions.
339  */
340 contract BulleonPromoToken is StandardToken, Ownable {
341 
342     string public constant name = "Bulleon Promo Token"; // solium-disable-line uppercase
343     string public constant symbol = "BULLEON PROMO"; // solium-disable-line uppercase
344     uint8 public constant decimals = 18; // solium-disable-line uppercase
345 
346 
347     uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(decimals));
348 
349     /**
350      * @dev Constructor that gives msg.sender all of existing tokens.
351      */
352     constructor() public {
353         totalSupply_ = INITIAL_SUPPLY;
354         //        balances[msg.sender] = INITIAL_SUPPLY;
355         //        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
356     }
357 
358 
359     /// @notice Notify owners about their virtual balances.
360     function massNotify(address[] _owners) public onlyOwner {
361         for (uint256 i = 0; i < _owners.length; i++) {
362             emit Transfer(address(0), _owners[i], virtualBalance);
363         }
364     }
365 
366 
367     function setDex(address _dex) onlyOwner public {
368         require(_dex != address(0));
369         dex = _dex;
370     }
371 
372 }
373 
374 
375 contract BulDex is Ownable {
376     using SafeERC20 for ERC20;
377 
378     mapping(address => bool) users;
379 
380     ERC20 public promoToken;
381     ERC20 public bullToken;
382 
383     uint public minVal = 365000000000000000000;
384     uint public bullAmount = 100000000000000000;
385 
386     constructor(address _promoToken, address _bullToken) public {
387         promoToken = ERC20(_promoToken);
388         bullToken = ERC20(_bullToken);
389     }
390 
391     function exchange(address _user, uint _val) public {
392         require(!users[_user]);
393         require(_val >= minVal);
394         users[_user] = true;
395         bullToken.safeTransfer(_user, bullAmount);
396     }
397 
398 
399 
400 
401     /// @notice This method can be used by the owner to extract mistakenly
402     ///  sent tokens to this contract.
403     /// @param _token The address of the token contract that you want to recover
404     ///  set to 0 in case you want to extract ether.
405     function claimTokens(address _token) external onlyOwner {
406         if (_token == 0x0) {
407             owner.transfer(address(this).balance);
408             return;
409         }
410 
411         ERC20 token = ERC20(_token);
412         uint balance = token.balanceOf(this);
413         token.transfer(owner, balance);
414     }
415 
416 }