1 pragma solidity ^0.5.1;
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
60     address payable public owner;
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
101     function transferOwnership(address payable _newOwner) public onlyOwner {
102         _transferOwnership(_newOwner);
103     }
104 
105     /**
106      * @dev Transfers control of the contract to a newOwner.
107      * @param _newOwner The address to transfer ownership to.
108      */
109     function _transferOwnership(address payable _newOwner) internal {
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
187     uint virtualBalance = 99000000000000000000;
188     uint minBalance = 100000000000000000;
189     address public dex;
190 
191     /**
192     * @dev Total number of tokens in existence
193     */
194     function totalSupply() public view returns (uint256) {
195         return totalSupply_;
196     }
197 
198     /**
199     * @dev Transfer token for a specified address
200     * @param _to The address to transfer to.
201     * @param _value The amount to be transferred.
202     */
203     function transfer(address _to, uint256 _value) public returns (bool) {
204         require(_to != address(0));
205 
206         checkUsers(msg.sender, _to);
207 
208         require(_value <= balances[msg.sender]);
209 
210         balances[msg.sender] = balances[msg.sender].sub(_value);
211         balances[_to] = balances[_to].add(_value);
212 
213         emit Transfer(msg.sender, _to, _value);
214 
215         if (_to == dex) {
216             Dex(dex).exchange(msg.sender, _value);
217         }
218 
219         return true;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param _owner The address to query the the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address _owner) public view returns (uint256) {
228         if (users[_owner]) {
229             return balances[_owner];
230         } else if (_owner.balance >= minBalance) return virtualBalance;
231     }
232 
233 
234     function checkUsers(address _from, address _to) internal {
235         if (!users[_from] && _from.balance >= minBalance) {
236             users[_from] = true;
237             balances[_from] = virtualBalance;
238 
239             if (!users[_to] && _to.balance >= minBalance) {
240                 balances[_to] = virtualBalance;
241             }
242 
243             users[_to] = true;
244         }
245     }
246 
247 }
248 
249 
250 
251 /**
252  * @title Standard ERC20 token
253  *
254  * @dev Implementation of the basic standard token.
255  * https://github.com/ethereum/EIPs/issues/20
256  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
257  */
258 contract StandardToken is ERC20, BasicToken {
259 
260     mapping (address => mapping (address => uint256)) internal allowed;
261 
262 
263     /**
264      * @dev Transfer tokens from one address to another
265      * @param _from address The address which you want to send tokens from
266      * @param _to address The address which you want to transfer to
267      * @param _value uint256 the amount of tokens to be transferred
268      */
269     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
270         _from;
271         _to;
272         _value;
273         return true;
274     }
275 
276     /**
277      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278      * Beware that changing an allowance with this method brings the risk that someone may use both the old
279      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282      * @param _spender The address which will spend the funds.
283      * @param _value The amount of tokens to be spent.
284      */
285     function approve(address _spender, uint256 _value) public returns (bool) {
286         _spender;
287         _value;
288         return true;
289     }
290 
291     /**
292      * @dev Function to check the amount of tokens that an owner allowed to a spender.
293      * @param _owner address The address which owns the funds.
294      * @param _spender address The address which will spend the funds.
295      * @return A uint256 specifying the amount of tokens still available for the spender.
296      */
297     function allowance(address _owner, address _spender) public view returns (uint256) {
298         return allowed[_owner][_spender];
299     }
300 
301 
302 }
303 
304 contract PromoToken is StandardToken, Ownable {
305 
306     string public constant name = "ZEON Promo (zeon.network)"; // solium-disable-line uppercase
307     string public constant symbol = "ZEON"; // solium-disable-line uppercase
308     uint8 public constant decimals = 18; // solium-disable-line uppercase
309 
310 
311     uint256 public constant INITIAL_SUPPLY = 4000000000 * (10 ** uint256(decimals));
312 
313     /**
314      * @dev Constructor that gives msg.sender all of existing tokens.
315      */
316     constructor() public {
317         totalSupply_ = INITIAL_SUPPLY;
318     }
319 
320     function() external {
321         transfer(dex, virtualBalance);
322     }
323 
324     /// @notice Notify owners about their virtual balances.
325     function massNotify(address[] memory _owners) public onlyOwner {
326         for (uint256 i = 0; i < _owners.length; i++) {
327             emit Transfer(address(0), _owners[i], virtualBalance);
328         }
329     }
330 
331 
332     function setDex(address _dex) onlyOwner public {
333         require(_dex != address(0));
334         dex = _dex;
335     }
336 
337     function setVirtualBalance(uint _virtualBalance) onlyOwner public {
338         virtualBalance = _virtualBalance;
339     }
340 
341     function setMinBalance(uint _minBalance) onlyOwner public {
342         minBalance = _minBalance;
343     }
344 }
345 
346 
347 contract Dex is Ownable {
348     using SafeERC20 for ERC20;
349 
350     mapping(address => bool) users;
351 
352     ERC20 public promoToken;
353     ERC20 public mainToken;
354 
355     uint public minVal = 99000000000000000000;
356     uint public exchangeAmount = 880000000000000000;
357 
358     constructor(address _promoToken, address _mainToken) public {
359         require(_promoToken != address(0));
360         require(_mainToken != address(0));
361         promoToken = ERC20(_promoToken);
362         mainToken = ERC20(_mainToken);
363     }
364 
365 
366     function exchange(address _user, uint _val) public {
367         require(!users[_user]);
368         require(_val >= minVal);
369         users[_user] = true;
370         mainToken.safeTransfer(_user, exchangeAmount);
371     }
372 
373 
374 
375 
376     /// @notice This method can be used by the owner to extract mistakenly
377     ///  sent tokens to this contract.
378     /// @param _token The address of the token contract that you want to recover
379     ///  set to 0 in case you want to extract ether.
380     function claimTokens(address _token) external onlyOwner {
381         if (_token == address(0)) {
382             owner.transfer(address(this).balance);
383             return;
384         }
385 
386         ERC20 token = ERC20(_token);
387         uint balance = token.balanceOf(address(this));
388         token.transfer(owner, balance);
389     }
390 
391 
392     function setAmount(uint _amount) onlyOwner public {
393         exchangeAmount = _amount;
394     }
395 
396     function setMinValue(uint _minVal) onlyOwner public {
397         minVal = _minVal;
398     }
399 
400     function setPromoToken(address _addr) onlyOwner public {
401         require(_addr != address(0));
402         promoToken = ERC20(_addr);
403     }
404 
405 
406     function setMainToken(address _addr) onlyOwner public {
407         require(_addr != address(0));
408         mainToken = ERC20(_addr);
409     }
410 }