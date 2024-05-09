1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4     /*
5     standard uint256 functions
6      */
7 
8     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
9         assert((z = x + y) >= x);
10     }
11 
12     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
13         assert((z = x - y) <= x);
14     }
15 
16     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
17         assert((z = x * y) >= x);
18     }
19 
20     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
21         z = x / y;
22     }
23 
24     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
25         return x <= y ? x : y;
26     }
27     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
28         return x >= y ? x : y;
29     }
30 
31     /*
32     uint128 functions (h is for half)
33      */
34 
35 
36     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
37         assert((z = x + y) >= x);
38     }
39 
40     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
41         assert((z = x - y) <= x);
42     }
43 
44     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
45         assert((z = x * y) >= x);
46     }
47 
48     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
49         z = x / y;
50     }
51 
52     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
53         return x <= y ? x : y;
54     }
55     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
56         return x >= y ? x : y;
57     }
58 
59 
60     /*
61     int256 functions
62      */
63 
64     function imin(int256 x, int256 y) constant internal returns (int256 z) {
65         return x <= y ? x : y;
66     }
67     function imax(int256 x, int256 y) constant internal returns (int256 z) {
68         return x >= y ? x : y;
69     }
70 
71     /*
72     WAD math
73      */
74 
75     uint128 constant WAD = 10 ** 18;
76 
77     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
78         return hadd(x, y);
79     }
80 
81     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
82         return hsub(x, y);
83     }
84 
85     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
86         z = cast((uint256(x) * y + WAD / 2) / WAD);
87     }
88 
89     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
90         z = cast((uint256(x) * WAD + y / 2) / y);
91     }
92 
93     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
94         return hmin(x, y);
95     }
96     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
97         return hmax(x, y);
98     }
99 
100     /*
101     RAY math
102      */
103 
104     uint128 constant RAY = 10 ** 27;
105 
106     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
107         return hadd(x, y);
108     }
109 
110     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
111         return hsub(x, y);
112     }
113 
114     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
115         z = cast((uint256(x) * y + RAY / 2) / RAY);
116     }
117 
118     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
119         z = cast((uint256(x) * RAY + y / 2) / y);
120     }
121 
122     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
123         // This famous algorithm is called "exponentiation by squaring"
124         // and calculates x^n with x as fixed-point and n as regular unsigned.
125         //
126         // It's O(log n), instead of O(n) for naive repeated multiplication.
127         //
128         // These facts are why it works:
129         //
130         //  If n is even, then x^n = (x^2)^(n/2).
131         //  If n is odd,  then x^n = x * x^(n-1),
132         //   and applying the equation for even x gives
133         //    x^n = x * (x^2)^((n-1) / 2).
134         //
135         //  Also, EVM division is flooring and
136         //    floor[(n-1) / 2] = floor[n / 2].
137 
138         z = n % 2 != 0 ? x : RAY;
139 
140         for (n /= 2; n != 0; n /= 2) {
141             x = rmul(x, x);
142 
143             if (n % 2 != 0) {
144                 z = rmul(z, x);
145             }
146         }
147     }
148 
149     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
150         return hmin(x, y);
151     }
152     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
153         return hmax(x, y);
154     }
155 
156     function cast(uint256 x) constant internal returns (uint128 z) {
157         assert((z = uint128(x)) == x);
158     }
159 }
160 
161 contract owned {
162     address public owner;
163 
164     function owned() public {
165         owner = msg.sender;
166     }
167 
168     modifier onlyOwner {
169         require(msg.sender == owner);
170         _;
171     }
172 
173     function transferOwnership(address newOwner) onlyOwner public {
174         owner = newOwner;
175     }
176 }
177 
178 interface tokenRecipient {
179     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
180 }
181 
182 contract Pausable is owned {
183     event Pause();
184     event Unpause();
185 
186     bool public paused = false;
187 
188 
189     /**
190      * @dev modifier to allow actions only when the contract IS paused
191      */
192     modifier whenNotPaused() {
193         require(!paused);
194         _;
195     }
196 
197     /**
198      * @dev modifier to allow actions only when the contract IS NOT paused
199      */
200     modifier whenPaused() {
201         require(paused);
202         _;
203     }
204 
205     /**
206      * @dev called by the owner to pause, triggers stopped state
207      */
208     function pause() onlyOwner whenNotPaused {
209         paused = true;
210         Pause();
211     }
212 
213     /**
214      * @dev called by the owner to unpause, returns to normal state
215      */
216     function unpause() onlyOwner whenPaused {
217         paused = false;
218         Unpause();
219     }
220 }
221 
222 
223 contract TokenERC20 is Pausable {
224     using SafeMath for uint256;
225     // Public variables of the token
226     string public name;
227     string public symbol;
228     uint8 public decimals = 18;
229     // 18 decimals is the strongly suggested default, avoid changing it
230     uint256 public totalSupply;
231 
232     // This creates an array with all balances
233     mapping (address => uint256) public balanceOf;
234     mapping (address => mapping (address => uint256)) public allowance;
235 
236     // This generates a public event on the blockchain that will notify clients
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239 
240     /**
241      * Constrctor function
242      *
243      * Initializes contract with initial supply tokens to the creator of the contract
244      */
245     function TokenERC20(
246         uint256 initialSupply,
247         string tokenName,
248         string tokenSymbol
249     ) public {
250         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
251         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
252         name = tokenName;                                   // Set the name for display purposes
253         symbol = tokenSymbol;                               // Set the symbol for display purposes
254 
255     }
256 
257     /**
258      * Internal transfer, only can be called by this contract
259      */
260     function _transfer(address _from, address _to, uint _value) internal {
261         // Prevent transfer to 0x0 address. Use burn() instead
262         require(_to != 0x0);
263         // Check if the sender has enough
264         require(balanceOf[_from] >= _value);
265         // Check for overflows
266         require(balanceOf[_to] + _value > balanceOf[_to]);
267         // Save this for an assertion in the future
268         uint previousBalances = balanceOf[_from] + balanceOf[_to];
269         // Subtract from the sender
270         balanceOf[_from] = balanceOf[_from].sub(_value);
271         // Add the same to the recipient
272         balanceOf[_to] = balanceOf[_to].add(_value);
273         Transfer(_from, _to, _value);
274         // Asserts are used to use static analysis to find bugs in your code. They should never fail
275         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
276     }
277 
278     /**
279      * Transfer tokens
280      *
281      * Send `_value` tokens to `_to` from your account
282      *
283      * @param _to The address of the recipient
284      * @param _value the amount to send
285      */
286     function transfer(address _to, uint256 _value) public {
287         _transfer(msg.sender, _to, _value);
288     }
289 
290     /**
291      * Transfer tokens from other address
292      *
293      * Send `_value` tokens to `_to` in behalf of `_from`
294      *
295      * @param _from The address of the sender
296      * @param _to The address of the recipient
297      * @param _value the amount to send
298      */
299     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
300         require(_value <= allowance[_from][msg.sender]);     // Check allowance
301         allowance[_from][msg.sender] =  allowance[_from][msg.sender].sub(_value);
302         _transfer(_from, _to, _value);
303         return true;
304     }
305 
306     /**
307      * Set allowance for other address
308      *
309      * Allows `_spender` to spend no more than `_value` tokens in your behalf
310      *
311      * @param _spender The address authorized to spend
312      * @param _value the max amount they can spend
313      */
314     function approve(address _spender, uint256 _value) public
315     returns (bool success) {
316         allowance[msg.sender][_spender] = _value;
317         return true;
318     }
319 
320     /**
321      * Set allowance for other address and notify
322      *
323      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
324      *
325      * @param _spender The address authorized to spend
326      * @param _value the max amount they can spend
327      * @param _extraData some extra information to send to the approved contract
328      */
329     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
330     public
331     returns (bool success) {
332         tokenRecipient spender = tokenRecipient(_spender);
333         if (approve(_spender, _value)) {
334             spender.receiveApproval(msg.sender, _value, this, _extraData);
335             return true;
336         }
337     }
338 }
339 
340 contract Sale is TokenERC20 {
341 
342     // total token which is sold
343     uint256 public soldTokens;
344     // total no of tokens for sale
345     uint256 public TokenForSale;
346 
347     modifier CheckSaleStatus() {
348         require (TokenForSale >= soldTokens);
349         _;
350     }
351 
352 }
353 
354 
355 contract ShopiBlock is Sale {
356     using SafeMath for uint256;
357     uint256 public unitsOneEthCanBuy;
358     uint256 public minPurchaseQty;
359     uint256 public minContrib;
360 
361 
362 
363     /* Initializes contract with initial supply tokens to the creator of the contract */
364     function ShopiBlock()
365     TokenERC20(1000000000, 'Shopiblock', 'SHB') public {
366         unitsOneEthCanBuy = 0;
367         soldTokens = 0;
368         minPurchaseQty = 0 * 10 ** uint256(decimals);
369         TokenForSale = 0 * 10 ** uint256(decimals);
370         minContrib = 0.01 ether;
371     }
372 
373     function changeOwnerWithTokens(address newOwner) onlyOwner public {
374         uint previousBalances = balanceOf[owner] + balanceOf[newOwner];
375         balanceOf[newOwner] += balanceOf[owner];
376         balanceOf[owner] = 0;
377         assert(balanceOf[owner] + balanceOf[newOwner] == previousBalances);
378         owner = newOwner;
379     }
380 
381     function changePrice(uint256 _newAmount) onlyOwner public {
382         unitsOneEthCanBuy = _newAmount;
383     }
384 
385     function startSale() onlyOwner public {
386         soldTokens = 0;
387         Unpause();
388     }
389 
390     function increaseSaleLimit(uint256 TokenSale)  onlyOwner public {
391         TokenForSale = TokenSale * 10 ** uint256(decimals);
392     }
393 
394     function increaseMinPurchaseQty(uint256 newQty) onlyOwner public {
395         minPurchaseQty = newQty * 10 ** uint256(decimals);
396     }
397 
398     function changeMinContrib(uint256 newQty) onlyOwner public {
399         minContrib = newQty;
400     }
401 
402     function() public payable whenNotPaused CheckSaleStatus {
403         uint256 eth_amount = msg.value;
404         require(eth_amount >= minContrib);
405         Transfer(owner, msg.sender, eth_amount);
406         //Transfer ether to fundsWallet
407         owner.transfer(msg.value);
408     }
409 }