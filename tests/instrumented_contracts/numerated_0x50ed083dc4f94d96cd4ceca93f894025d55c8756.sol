1 pragma solidity ^0.5.0;
2 
3 
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11     address public owner;
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         if (msg.sender != owner) {
19             revert();
20         }
21         _;
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         if (newOwner != address(0)) {
26             owner = newOwner;
27         }
28     }
29 
30 }
31 
32 
33 /*
34  * ERC20 interface
35  * see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38     uint public totalSupply;
39 
40     function balanceOf(address who) public view returns (uint);
41     function allowance(address owner, address spender) public view returns (uint);
42 
43     function transfer(address to, uint value) public returns (bool ok);
44     function transferFrom(address from, address to, uint value) public returns (bool ok);
45     function approve(address spender, uint value) public returns (bool ok);
46     event Transfer(address indexed from, address indexed to, uint value);
47     event Approval(address indexed owner, address indexed spender, uint value);
48 }
49 
50 
51 
52 /**
53  * Math operations with safety checks
54  */
55 contract SafeMath {
56     function safeMul(uint a, uint b) internal pure returns (uint) {
57         uint c = a * b;
58         assertThat(a == 0 || c / a == b);
59         return c;
60     }
61 
62     function safeDiv(uint a, uint b) internal pure returns (uint) {
63         assertThat(b > 0);
64         uint c = a / b;
65         assertThat(a == b * c + a % b);
66         return c;
67     }
68 
69     function safeSub(uint a, uint b) internal pure returns (uint) {
70         assertThat(b <= a);
71         return a - b;
72     }
73 
74     function safeAdd(uint a, uint b) internal pure returns (uint) {
75         uint c = a + b;
76         assertThat(c>=a && c>=b);
77         return c;
78     }
79 
80     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
81         return a >= b ? a : b;
82     }
83 
84     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
85         return a < b ? a : b;
86     }
87 
88     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a >= b ? a : b;
90     }
91 
92     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a < b ? a : b;
94     }
95 
96     function assertThat(bool assertion) internal pure {
97         if (!assertion) {
98             revert();
99         }
100     }
101 }
102 
103 
104 /**
105  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
106  *
107  * Based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, SafeMath {
111 
112     string public name;
113     string public symbol;
114     uint public decimals;
115 
116     /* Actual balances of token holders */
117     mapping(address => uint) balances;
118 
119     /* approve() allowances */
120     mapping (address => mapping (address => uint)) allowed;
121 
122     /**
123      *
124      * Fix for the ERC20 short address attack
125      *
126      * http://vessenes.com/the-erc20-short-address-attack-explained/
127      */
128     modifier onlyPayloadSize(uint size) {
129         if(msg.data.length < size + 4) {
130             revert();
131         }
132         _;
133     }
134 
135     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
136         balances[msg.sender] = safeSub(balances[msg.sender], _value);
137         balances[_to] = safeAdd(balances[_to], _value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
143         uint _allowance = allowed[_from][msg.sender];
144 
145         balances[_to] = safeAdd(balances[_to], _value);
146         balances[_from] = safeSub(balances[_from], _value);
147         allowed[_from][msg.sender] = safeSub(_allowance, _value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     function balanceOf(address _owner) public view returns (uint balance) {
153         return balances[_owner];
154     }
155 
156     function approve(address _spender, uint _value) public returns (bool success) {
157 
158         // To change the approve amount you first have to reduce the addresses`
159         //  allowance to zero by calling `approve(_spender, 0)` if it is not
160         //  already 0 to mitigate the race condition described here:
161         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
163 
164         allowed[msg.sender][_spender] = _value;
165         emit Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     function allowance(address _owner, address _spender) public view returns (uint remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
185         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      *
192      * approve should be called when allowed[_spender] == 0. To decrement
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * @param _spender The address which will spend the funds.
197      * @param _subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200         uint oldValue = allowed[msg.sender][_spender];
201         if (_subtractedValue > oldValue) {
202             allowed[msg.sender][_spender] = 0;
203         } else {
204             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
205         }
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210 }
211 
212 /**
213  * @title Pausable
214  * @dev Base contract which allows children to implement an emergency stop mechanism.
215  */
216 contract Pausable is Ownable {
217     event Pause();
218     event Unpause();
219 
220     bool public paused = false;
221 
222 
223     /**
224      * @dev Modifier to make a function callable only when the contract is not paused.
225      */
226     modifier whenNotPaused() {
227         require(!paused);
228         _;
229     }
230 
231     /**
232      * @dev Modifier to make a function callable only when the contract is paused.
233      */
234     modifier whenPaused() {
235         require(paused);
236         _;
237     }
238 
239     /**
240      * @dev called by the owner to pause, triggers stopped state
241      */
242     function pause() onlyOwner whenNotPaused public {
243         paused = true;
244         emit Pause();
245     }
246 
247     /**
248      * @dev called by the owner to unpause, returns to normal state
249      */
250     function unpause() onlyOwner whenPaused public {
251         paused = false;
252         emit Unpause();
253     }
254 }
255 
256 /**
257  * @title Pausable token
258  * @dev StandardToken modified with pausable transfers.
259  **/
260 contract PausableToken is StandardToken, Pausable {
261 
262     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
263         return super.transfer(_to, _value);
264     }
265 
266     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
267         return super.transferFrom(_from, _to, _value);
268     }
269 
270     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
271         return super.approve(_spender, _value);
272     }
273 
274     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
275         return super.increaseApproval(_spender, _addedValue);
276     }
277 
278     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
279         return super.decreaseApproval(_spender, _subtractedValue);
280     }
281 }
282 
283 /**
284  * @title Freezable
285  * @dev Base contract which allows children to freeze the operations from a certain address in case of an emergency.
286  */
287 contract Freezable is Ownable {
288 
289     mapping (address => bool) internal frozenAddresses;
290 
291     modifier ifNotFrozen() {
292         require(frozenAddresses[msg.sender] == false);
293         _;
294     }
295 
296     function freezeAddress(address addr) public onlyOwner {
297         frozenAddresses[addr] = true;
298     }
299 
300     function unfreezeAddress(address addr) public onlyOwner {
301         frozenAddresses[addr] = false;
302     }
303 }
304 
305 /**
306  * @title Freezable token
307  * @dev StandardToken modified with freezable transfers.
308  **/
309 contract FreezableToken is StandardToken, Freezable {
310 
311     function transfer(address _to, uint256 _value) public ifNotFrozen returns (bool) {
312         return super.transfer(_to, _value);
313     }
314 
315     function transferFrom(address _from, address _to, uint256 _value) public ifNotFrozen returns (bool) {
316         return super.transferFrom(_from, _to, _value);
317     }
318 
319     function approve(address _spender, uint256 _value) public ifNotFrozen returns (bool) {
320         return super.approve(_spender, _value);
321     }
322 
323     function increaseApproval(address _spender, uint _addedValue) public ifNotFrozen returns (bool success) {
324         return super.increaseApproval(_spender, _addedValue);
325     }
326 
327     function decreaseApproval(address _spender, uint _subtractedValue) public ifNotFrozen returns (bool success) {
328         return super.decreaseApproval(_spender, _subtractedValue);
329     }
330 }
331 
332 /**
333  * A a standard token with an anti-theft mechanism.
334  * Is able to restore stolen funds to a new address where the corresponding private key is safe.
335  *
336  */
337 contract AntiTheftToken is FreezableToken {
338 
339     function restoreFunds(address from, address to, uint amount) public onlyOwner {
340         //can only restore stolen funds from a frozen address
341         require(frozenAddresses[from] == true);
342         require(to != address(0));
343         require(amount <= balances[from]);
344 
345         balances[from] = safeSub(balances[from], amount);
346         balances[to] = safeAdd(balances[to], amount);
347         emit Transfer(from, to, amount);
348     }
349 }
350 
351 contract BurnableToken is StandardToken {
352 
353     /** How many tokens we burned */
354     event Burned(address burner, uint burnedAmount);
355 
356     /**
357      * Burn extra tokens from a balance.
358      *
359      */
360     function burn(uint burnAmount) public {
361         address burner = msg.sender;
362         balances[burner] = safeSub(balances[burner], burnAmount);
363         totalSupply = safeSub(totalSupply, burnAmount);
364         emit Burned(burner, burnAmount);
365     }
366 }
367 
368 contract ICOToken is BurnableToken, AntiTheftToken, PausableToken {
369 
370     constructor(string memory _name, string memory _symbol, uint _decimals, uint _max_supply) public {
371         symbol = _symbol;
372         name = _name;
373         decimals = _decimals;
374         
375         totalSupply = _max_supply * (10 ** _decimals);
376         balances[msg.sender] = totalSupply;
377         emit Transfer(address(0x0), msg.sender, totalSupply);
378     }
379 
380 }