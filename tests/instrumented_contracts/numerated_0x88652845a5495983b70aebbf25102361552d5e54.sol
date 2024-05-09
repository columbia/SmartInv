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
100       * @dev Transfers token to the specified address
101       * @param to The address to transfer to.
102       * @param value The amount to be transferred.
103       */
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
284     bool public mintingFinished;
285     uint256 public cap;
286 
287     event Mint(address indexed to, uint256 amount);
288     event MintFinished();
289 
290     modifier onlyMinting() {
291         require(!mintingFinished, "Minting is already finished");
292         _;
293     }
294 
295     modifier onlyNotExceedingCap(uint256 amount) {
296         require(_totalSupply.add(amount) <= cap, "Total supply must not exceed cap");
297         _;
298     }
299 
300     constructor(uint256 _cap) public {
301         cap = _cap;
302     }
303 
304     /**
305      * @dev Creates new tokens for the given address
306      * @param to The address that will receive the minted tokens.
307      * @param amount The amount of tokens to mint.
308      * @return A boolean that indicates if the operation was successful.
309      */
310     function mint(address to, uint256 amount)
311         public
312         onlyOwner
313         onlyMinting
314         onlyValidAddress(to)
315         onlyNotExceedingCap(amount)
316         returns (bool)
317     {
318         mintImpl(to, amount);
319 
320         return true;
321     }
322 
323     /**
324      * @dev Creates new tokens for the given addresses
325      * @param addresses The array of addresses that will receive the minted tokens.
326      * @param amounts The array of amounts of tokens to mint.
327      * @return A boolean that indicates if the operation was successful.
328      */
329     function mintMany(address[] addresses, uint256[] amounts)
330         public
331         onlyOwner
332         onlyMinting
333         onlyNotExceedingCap(sum(amounts))
334         returns (bool)
335     {
336         require(
337             addresses.length == amounts.length,
338             "Addresses array must be the same size as amounts array"
339         );
340 
341         for (uint256 i = 0; i < addresses.length; i++) {
342             require(addresses[i] != address(0), "Address cannot be zero");
343             mintImpl(addresses[i], amounts[i]);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Stops minting new tokens.
351      * @return True if the operation was successful.
352      */
353     function finishMinting()
354         public
355         onlyOwner
356         onlyMinting
357         returns (bool)
358     {
359         mintingFinished = true;
360 
361         emit MintFinished();
362 
363         return true;
364     }
365 
366     function mintImpl(address to, uint256 amount) private {
367         _totalSupply = _totalSupply.add(amount);
368         _balanceOf[to] = _balanceOf[to].add(amount);
369 
370         emit Mint(to, amount);
371         emit Transfer(address(0), to, amount);
372     }
373 
374     function sum(uint256[] arr) private pure returns (uint256) {
375         uint256 aggr = 0;
376         for (uint256 i = 0; i < arr.length; i++) {
377             aggr = aggr.add(arr[i]);
378         }
379         return aggr;
380     }
381 }
382 
383 
384 contract PhotochainToken is MintableToken {
385     string public name = "PhotochainToken";
386     string public symbol = "PHT";
387     uint256 public decimals = 18;
388     uint256 public cap = 120 * 10**6 * 10**decimals;
389 
390     // solhint-disable-next-line no-empty-blocks
391     constructor() public MintableToken(cap) {}
392 }