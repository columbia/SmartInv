1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 
12     function totalSupply() public view returns (uint256);
13     function balanceOf(address who) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function allowance(address owner, address spender) public view returns (uint256);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17     function approve(address spender, uint256 value) public returns (bool);
18 }
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  * @dev Based on https://github.com/OpenZeppelin/zeppelin-solidity
25  */
26 library SafeMath {
27 
28     /**
29     * @dev Multiplies two numbers, throws on overflow.
30     */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         assert(c / a == b);
38 
39         return c;
40     }
41 
42     /**
43     * @dev Integer division of two numbers, truncating the quotient.
44     */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // assert(b > 0); // Solidity automatically throws when dividing by 0
47         // uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49         return a / b;
50     }
51 
52     /**
53     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54     */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(b <= a);
57         return a - b;
58     }
59 
60     /**
61     * @dev Adds two numbers, throws on overflow.
62     */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         assert(c >= a);
66         return c;
67     }
68 }
69 
70 
71 /**
72  * @title Standard ERC20 token
73  *
74  * @dev Implementation of the basic standard token.
75  * @dev Based on https://github.com/OpenZeppelin/zeppelin-solidity
76  */
77 contract StandardToken is ERC20 {
78     using SafeMath for uint256;
79 
80     uint256 internal _totalSupply;
81     mapping(address => uint256) internal _balanceOf;
82     mapping (address => mapping (address => uint256)) internal _allowance;
83 
84     modifier onlyValidAddress(address addr) {
85         require(addr != address(0), "Address cannot be zero");
86         _;
87     }
88 
89     modifier onlySufficientBalance(address from, uint256 value) {
90         require(value <= _balanceOf[from], "Insufficient balance");
91         _;
92     }
93 
94     modifier onlySufficientAllowance(address owner, address spender, uint256 value) {
95         require(value <= _allowance[owner][spender], "Insufficient allowance");
96         _;
97     }
98 
99     /**
100      * @dev Transfers token to the specified address
101      * @param to The address to transfer to.
102      * @param value The amount to be transferred.
103      */
104     function transfer(address to, uint256 value)
105         public
106         onlyValidAddress(to)
107         onlySufficientBalance(msg.sender, value)
108         returns (bool)
109     {
110         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(value);
111         _balanceOf[to] = _balanceOf[to].add(value);
112 
113         emit Transfer(msg.sender, to, value);
114 
115         return true;
116     }
117 
118     /**
119      * @dev Transfers tokens from one address to another
120      * @param from address The address which you want to send tokens from
121      * @param to address The address which you want to transfer to
122      * @param value uint256 the amount of tokens to be transferred
123      */
124     function transferFrom(address from, address to, uint256 value)
125         public
126         onlyValidAddress(to)
127         onlySufficientBalance(from, value)
128         onlySufficientAllowance(from, msg.sender, value)
129         returns (bool)
130     {
131         _balanceOf[from] = _balanceOf[from].sub(value);
132         _balanceOf[to] = _balanceOf[to].add(value);
133         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);
134 
135         emit Transfer(from, to, value);
136 
137         return true;
138     }
139 
140     /**
141      * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
142      *
143      * Beware that changing an allowance with this method brings the risk that someone may use both the old
144      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      * @param spender The address which will spend the funds.
148      * @param value The amount of tokens to be spent.
149      */
150     function approve(address spender, uint256 value)
151         public
152         onlyValidAddress(spender)
153         returns (bool)
154     {
155         _allowance[msg.sender][spender] = value;
156 
157         emit Approval(msg.sender, spender, value);
158 
159         return true;
160     }
161 
162     /**
163      * @dev Increases the amount of tokens that an owner allowed to a spender.
164      *
165      * approve should be called when _allowance[spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * @param spender The address which will spend the funds.
169      * @param addedValue The amount of tokens to increase the allowance by.
170      */
171     function increaseAllowance(address spender, uint256 addedValue)
172         public
173         onlyValidAddress(spender)
174         returns (bool)
175     {
176         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(addedValue);
177 
178         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
179 
180         return true;
181     }
182 
183     /**
184      * @dev Decreases the amount of tokens that an owner allowed to a spender.
185      *
186      * approve should be called when _allowance[spender] == 0. To decrement
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * @param spender The address which will spend the funds.
190      * @param subtractedValue The amount of tokens to decrease the allowance by.
191      */
192     function decreaseAllowance(address spender, uint256 subtractedValue)
193         public
194         onlyValidAddress(spender)
195         onlySufficientAllowance(msg.sender, spender, subtractedValue)
196         returns (bool)
197     {
198         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].sub(subtractedValue);
199 
200         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
201 
202         return true;
203     }
204 
205     /**
206      * @dev Gets total number of tokens in existence
207      */
208     function totalSupply() public view returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev Gets the balance of the specified address.
214      * @param owner The address to query the the balance of.
215      * @return An uint256 representing the amount owned by the passed address.
216      */
217     function balanceOf(address owner) public view returns (uint256) {
218         return _balanceOf[owner];
219     }
220 
221     /**
222      * @dev Checks the amount of tokens that an owner allowed to a spender.
223      * @param owner address The address which owns the funds.
224      * @param spender address The address which will spend the funds.
225      * @return A uint256 specifying the amount of tokens still available for the spender.
226      */
227     function allowance(address owner, address spender) public view returns (uint256) {
228         return _allowance[owner][spender];
229     }
230 }
231 
232 
233 /**
234  * @title Ownable
235  * @dev The Ownable contract has an owner address, and provides basic authorization control
236  * functions, this simplifies the implementation of "user permissions".
237  * @dev Based on https://github.com/OpenZeppelin/zeppelin-soliditysettable
238  */
239 contract Ownable {
240     address public owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     modifier onlyOwner() {
245         require(msg.sender == owner, "Can only be called by the owner");
246         _;
247     }
248 
249     modifier onlyValidAddress(address addr) {
250         require(addr != address(0), "Address cannot be zero");
251         _;
252     }
253 
254     /**
255      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
256      * account.
257      */
258     constructor() public {
259         owner = msg.sender;
260     }
261 
262     /**
263      * @dev Allows the current owner to transfer control of the contract to a newOwner.
264      * @param newOwner The address to transfer ownership to.
265      */
266     function transferOwnership(address newOwner)
267         public
268         onlyOwner
269         onlyValidAddress(newOwner)
270     {
271         emit OwnershipTransferred(owner, newOwner);
272 
273         owner = newOwner;
274     }
275 }
276 
277 
278 /**
279  * @title Mintable token
280  * @dev Standard token with minting
281  * @dev Based on https://github.com/OpenZeppelin/zeppelin-solidity
282  */
283 contract MintableToken is StandardToken, Ownable {
284     uint256 public cap;
285 
286     modifier onlyNotExceedingCap(uint256 amount) {
287         require(_totalSupply.add(amount) <= cap, "Total supply must not exceed cap");
288         _;
289     }
290 
291     constructor(uint256 _cap) public {
292         cap = _cap;
293     }
294 
295     /**
296      * @dev Creates new tokens for the given address
297      * @param to The address that will receive the minted tokens.
298      * @param amount The amount of tokens to mint.
299      * @return A boolean that indicates if the operation was successful.
300      */
301     function mint(address to, uint256 amount)
302         public
303         onlyOwner
304         onlyValidAddress(to)
305         onlyNotExceedingCap(amount)
306         returns (bool)
307     {
308         _mint(to, amount);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Creates new tokens for the given addresses
315      * @param addresses The array of addresses that will receive the minted tokens.
316      * @param amounts The array of amounts of tokens to mint.
317      * @return A boolean that indicates if the operation was successful.
318      */
319     function mintMany(address[] addresses, uint256[] amounts)
320         public
321         onlyOwner
322         onlyNotExceedingCap(_sum(amounts))
323         returns (bool)
324     {
325         require(
326             addresses.length == amounts.length,
327             "Addresses array must be the same size as amounts array"
328         );
329 
330         for (uint256 i = 0; i < addresses.length; i++) {
331             _mint(addresses[i], amounts[i]);
332         }
333 
334         return true;
335     }
336 
337     function _mint(address to, uint256 amount)
338         internal
339         onlyValidAddress(to)
340     {
341         _totalSupply = _totalSupply.add(amount);
342         _balanceOf[to] = _balanceOf[to].add(amount);
343 
344         emit Transfer(address(0), to, amount);
345     }
346 
347     function _sum(uint256[] arr) internal pure returns (uint256) {
348         uint256 aggr = 0;
349         for (uint256 i = 0; i < arr.length; i++) {
350             aggr = aggr.add(arr[i]);
351         }
352         return aggr;
353     }
354 }
355 
356 
357 /**
358  * @title Burnable Token
359  * @dev Token that can be irreversibly burned (destroyed).
360  */
361 contract BurnableToken is StandardToken {
362     /**
363      * @dev Burns a specific amount of tokens.
364      * @param amount The amount of token to be burned.
365      */
366     function burn(uint256 amount) public {
367         _burn(msg.sender, amount);
368     }
369 
370     /**
371      * @dev Burns a specific amount of tokens from the target address and decrements allowance
372      * @param from The account whose tokens will be burnt.
373      * @param amount The amount of token that will be burnt.
374      */
375     function burnFrom(address from, uint256 amount)
376         public
377         onlyValidAddress(from)
378         onlySufficientAllowance(from, msg.sender, amount)
379     {
380         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(amount);
381 
382         _burn(from, amount);
383     }
384 
385     /**
386      * @dev Internal function that burns an amount of the token of a given
387      * account.
388      * @param from The account whose tokens will be burnt.
389      * @param amount The amount that will be burnt.
390      */
391     function _burn(address from, uint256 amount)
392         internal
393         onlySufficientBalance(from, amount)
394     {
395         _totalSupply = _totalSupply.sub(amount);
396         _balanceOf[from] = _balanceOf[from].sub(amount);
397 
398         emit Transfer(from, address(0), amount);
399     }
400 }
401 
402 
403 contract TradeTokenX is MintableToken, BurnableToken {
404     string public name = "Trade Token X";
405     string public symbol = "TIOx";
406     uint8 public decimals = 18;
407     uint256 public cap = 223534822661022743815939072;
408 
409     // solhint-disable-next-line no-empty-blocks
410     constructor() public MintableToken(cap) {}
411 }