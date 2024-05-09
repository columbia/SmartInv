1 pragma solidity ^0.4.24;
2 
3 /**
4  * @dev Library that helps prevent integer overflows and underflows,
5  * inspired by https://github.com/OpenZeppelin/zeppelin-solidity
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a);
11 
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b <= a);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         require(c / a == b);
28 
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0);
34         uint256 c = a / b;
35 
36         return c;
37     }
38 }
39 
40 /**
41  * @title HasOwner
42  *
43  * @dev Allows for exclusive access to certain functionality.
44  */
45 contract HasOwner {
46     // Current owner.
47     address public owner;
48 
49     // Conditionally the new owner.
50     address public newOwner;
51 
52     /**
53      * @dev The constructor.
54      *
55      * @param _owner The address of the owner.
56      */
57     constructor(address _owner) internal {
58         owner = _owner;
59     }
60 
61     /**
62      * @dev Access control modifier that allows only the current owner to call the function.
63      */
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70      * @dev The event is fired when the current owner is changed.
71      *
72      * @param _oldOwner The address of the previous owner.
73      * @param _newOwner The address of the new owner.
74      */
75     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
76 
77     /**
78      * @dev Transfering the ownership is a two-step process, as we prepare
79      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
80      * the transfer. This prevents accidental lock-out if something goes wrong
81      * when passing the `newOwner` address.
82      *
83      * @param _newOwner The address of the proposed new owner.
84      */
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88 
89     /**
90      * @dev The `newOwner` finishes the ownership transfer process by accepting the
91      * ownership.
92      */
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95 
96         emit OwnershipTransfer(owner, newOwner);
97 
98         owner = newOwner;
99     }
100 }
101 
102 /**
103  * @dev The standard ERC20 Token interface.
104  */
105 contract ERC20TokenInterface {
106     uint256 public totalSupply;  /* shorthand for public function and a property */
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109     function balanceOf(address _owner) public constant returns (uint256 balance);
110     function transfer(address _to, uint256 _value) public returns (bool success);
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
112     function approve(address _spender, uint256 _value) public returns (bool success);
113     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
114 }
115 
116 /**
117  * @title ERC20Token
118  *
119  * @dev Implements the operations declared in the `ERC20TokenInterface`.
120  */
121 contract ERC20Token is ERC20TokenInterface {
122     using SafeMath for uint256;
123 
124     // Token account balances.
125     mapping (address => uint256) balances;
126 
127     // Delegated number of tokens to transfer.
128     mapping (address => mapping (address => uint256)) allowed;
129 
130     /**
131      * @dev Checks the balance of a certain address.
132      *
133      * @param _account The address which's balance will be checked.
134      *
135      * @return Returns the balance of the `_account` address.
136      */
137     function balanceOf(address _account) public constant returns (uint256 balance) {
138         return balances[_account];
139     }
140 
141     /**
142      * @dev Transfers tokens from one address to another.
143      *
144      * @param _to The target address to which the `_value` number of tokens will be sent.
145      * @param _value The number of tokens to send.
146      *
147      * @return Whether the transfer was successful or not.
148      */
149     function transfer(address _to, uint256 _value) public returns (bool success) {
150         require(_to != address(0));
151         require(_value <= balances[msg.sender]);
152         require(_value > 0);
153 
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156 
157         emit Transfer(msg.sender, _to, _value);
158 
159         return true;
160     }
161 
162     /**
163      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
164      *
165      * @param _from The address of the sender.
166      * @param _to The address of the recipient.
167      * @param _value The number of tokens to be transferred.
168      *
169      * @return Whether the transfer was successful or not.
170      */
171     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
172         require(_value <= balances[_from]);
173         require(_value <= allowed[_from][msg.sender]);
174         require(_value > 0);
175         require(_to != address(0));
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180 
181         emit Transfer(_from, _to, _value);
182 
183         return true;
184     }
185 
186     /**
187      * @dev Allows another contract to spend some tokens on your behalf.
188      *
189      * @param _spender The address of the account which will be approved for transfer of tokens.
190      * @param _value The number of tokens to be approved for transfer.
191      *
192      * @return Whether the approval was successful or not.
193      */
194     function approve(address _spender, uint256 _value) public returns (bool success) {
195         allowed[msg.sender][_spender] = _value;
196 
197         emit Approval(msg.sender, _spender, _value);
198 
199         return true;
200     }
201 
202 	/**
203 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
204 	 * approve should be called when allowed[_spender] == 0. To increment
205 	 * allowed value is better to use this function to avoid 2 calls (and wait until
206 	 * the first transaction is mined)
207 	 * From MonolithDAO Token.sol
208 	 *
209 	 * @param _spender The address which will spend the funds.
210 	 * @param _addedValue The amount of tokens to increase the allowance by.
211 	 */
212 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
213 		allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
214 
215 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216 
217 		return true;
218 	}
219 
220 	/**
221 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
222 	 * approve should be called when allowed[_spender] == 0. To decrement
223 	 * allowed value is better to use this function to avoid 2 calls (and wait until
224 	 * the first transaction is mined)
225 	 * From MonolithDAO Token.sol
226 	 *
227 	 * @param _spender The address which will spend the funds.
228 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
229 	 */
230 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
231 		uint256 oldValue = allowed[msg.sender][_spender];
232 		if (_subtractedValue >= oldValue) {
233 			allowed[msg.sender][_spender] = 0;
234 		} else {
235 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236 		}
237 
238 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239 		return true;
240 	}
241 
242     /**
243      * @dev Shows the number of tokens approved by `_owner` that are allowed to be transferred by `_spender`.
244      *
245      * @param _owner The account which allowed the transfer.
246      * @param _spender The account which will spend the tokens.
247      *
248      * @return The number of tokens to be transferred.
249      */
250     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
251         return allowed[_owner][_spender];
252     }
253 
254     /**
255      * Don't accept ETH
256      */
257     function () public payable {
258         revert();
259     }
260 }
261 
262 /**
263  * @title Freezable
264  * @dev This trait allows to freeze the transactions in a Token
265  */
266 contract Freezable is HasOwner {
267     bool public frozen = false;
268 
269     /**
270      * @dev Modifier makes methods callable only when the contract is not frozen.
271      */
272     modifier requireNotFrozen() {
273         require(!frozen);
274         _;
275     }
276 
277     /**
278      * @dev Allows the owner to "freeze" the contract.
279      */
280     function freeze() onlyOwner public {
281         frozen = true;
282     }
283 
284     /**
285      * @dev Allows the owner to "unfreeze" the contract.
286      */
287     function unfreeze() onlyOwner public {
288         frozen = false;
289     }
290 }
291 
292 /**
293  * @title FreezableERC20Token
294  *
295  * @dev Extends ERC20Token and adds ability to freeze all transfers of tokens.
296  */
297 contract FreezableERC20Token is ERC20Token, Freezable {
298     /**
299      * @dev Overrides the original ERC20Token implementation by adding whenNotFrozen modifier.
300      *
301      * @param _to The target address to which the `_value` number of tokens will be sent.
302      * @param _value The number of tokens to send.
303      *
304      * @return Whether the transfer was successful or not.
305      */
306     function transfer(address _to, uint _value) public requireNotFrozen returns (bool success) {
307         return super.transfer(_to, _value);
308     }
309 
310     /**
311      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
312      *
313      * @param _from The address of the sender.
314      * @param _to The address of the recipient.
315      * @param _value The number of tokens to be transferred.
316      *
317      * @return Whether the transfer was successful or not.
318      */
319     function transferFrom(address _from, address _to, uint _value) public requireNotFrozen returns (bool success) {
320         return super.transferFrom(_from, _to, _value);
321     }
322 
323     /**
324      * @dev Allows another contract to spend some tokens on your behalf.
325      *
326      * @param _spender The address of the account which will be approved for transfer of tokens.
327      * @param _value The number of tokens to be approved for transfer.
328      *
329      * @return Whether the approval was successful or not.
330      */
331     function approve(address _spender, uint _value) public requireNotFrozen returns (bool success) {
332         return super.approve(_spender, _value);
333     }
334 
335     function increaseApproval(address _spender, uint256 _addedValue) public requireNotFrozen returns (bool) {
336         return super.increaseApproval(_spender, _addedValue);
337     }
338 
339     function decreaseApproval(address _spender, uint256 _subtractedValue) public requireNotFrozen returns (bool) {
340         return super.decreaseApproval(_spender, _subtractedValue);
341     }
342 }
343 
344 /**
345  * @title BonusCloudTokenConfig
346  *
347  * @dev The static configuration for the Bonus Cloud Token.
348  */
349 contract BonusCloudTokenConfig {
350     // The name of the token.
351     string constant NAME = "BonusCloud Token";
352 
353     // The symbol of the token.
354     string constant SYMBOL = "BxC";
355 
356     // The number of decimals for the token.
357     uint8 constant DECIMALS = 18;
358 
359     // Decimal factor for multiplication purposes.
360     uint256 constant DECIMALS_FACTOR = 10 ** uint(DECIMALS);
361 
362     // TotalSupply
363     uint256 constant TOTAL_SUPPLY = 7000000000 * DECIMALS_FACTOR;
364 }
365 
366 /**
367  * @title Bonus Cloud Token
368  *
369  * @dev A standard token implementation of the ERC20 token standard with added
370  *      HasOwner trait and initialized using the configuration constants.
371  */
372 contract BonusCloudToken is BonusCloudTokenConfig, HasOwner, FreezableERC20Token {
373     // The name of the token.
374     string public name;
375 
376     // The symbol for the token.
377     string public symbol;
378 
379     // The decimals of the token.
380     uint8 public decimals;
381 
382     /**
383      * @dev The constructor.
384      *
385      */
386     constructor() public HasOwner(msg.sender) {
387         name = NAME;
388         symbol = SYMBOL;
389         decimals = DECIMALS;
390         totalSupply = TOTAL_SUPPLY;
391         balances[owner] = TOTAL_SUPPLY;
392     }
393 }