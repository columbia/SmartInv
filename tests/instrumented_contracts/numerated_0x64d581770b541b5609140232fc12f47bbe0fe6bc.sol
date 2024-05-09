1 pragma solidity ^0.4.17;
2 
3 /// @title Base Token contract - Functions to be implemented by token contracts.
4 contract BaseToken {
5     /*
6      * Implements ERC 20 standard.
7      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
8      * https://github.com/ethereum/EIPs/issues/20
9      *
10      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
11      *  https://github.com/ethereum/EIPs/issues/223
12      */
13 
14     /*
15      * This is a slight change to the ERC20 base standard.
16      * function totalSupply() constant returns (uint256 supply);
17      * is replaced with:
18      * uint256 public totalSupply;
19      * This automatically creates a getter function for the totalSupply.
20      * This is moved to the base contract since public getter functions are not
21      * currently recognised as an implementation of the matching abstract
22      * function by the compiler.
23      */
24     uint256 public totalSupply;
25 
26     /*
27      * ERC 20
28      */
29     function balanceOf(address _owner) public constant returns (uint256 balance);
30     function transfer(address _to, uint256 _value) public returns (bool success);
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32     function approve(address _spender, uint256 _value) public returns (bool success);
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34 
35     /*
36      * ERC 223
37      */
38     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
39 
40     /*
41      * Events
42      */
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     // There is no ERC223 compatible Transfer event, with `_data` included.
47 }
48 
49 
50  /*
51  * Contract that is working with ERC223 tokens
52  * https://github.com/ethereum/EIPs/issues/223
53  */
54 
55 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
56 contract ERC223ReceivingContract {
57 
58     /// @dev Function that is called when a user or another contract wants to transfer funds.
59     /// @param _from Transaction initiator, analogue of msg.sender
60     /// @param _value Number of tokens to transfer.
61     /// @param _data Data containig a function signature and/or parameters
62     function tokenFallback(address _from, uint256 _value, bytes _data) public;
63 }
64 
65 
66 /// @title Standard token contract - Standard token implementation.
67 contract StandardToken is BaseToken {
68 
69     /*
70      * Data structures
71      */
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 
75     /*
76      * Public functions
77      */
78     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
79     /// @dev Transfers sender's tokens to a given address. Returns success.
80     /// @param _to Address of token receiver.
81     /// @param _value Number of tokens to transfer.
82     /// @return Returns success of function call.
83     function transfer(address _to, uint256 _value) public returns (bool) {
84         require(_to != 0x0);
85         require(_to != address(this));
86         require(balances[msg.sender] >= _value);
87         require(balances[_to] + _value >= balances[_to]);
88 
89         balances[msg.sender] -= _value;
90         balances[_to] += _value;
91 
92         emit Transfer(msg.sender, _to, _value);
93 
94         return true;
95     }
96 
97     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
98     /// tokenFallback if sender is a contract.
99     /// @dev Function that is called when a user or another contract wants to transfer funds.
100     /// @param _to Address of token receiver.
101     /// @param _value Number of tokens to transfer.
102     /// @param _data Data to be sent to tokenFallback
103     /// @return Returns success of function call.
104     function transfer(
105         address _to,
106         uint256 _value,
107         bytes _data)
108         public
109         returns (bool)
110     {
111         require(transfer(_to, _value));
112 
113         uint codeLength;
114 
115         assembly {
116             // Retrieve the size of the code on target address, this needs assembly.
117             codeLength := extcodesize(_to)
118         }
119 
120         if (codeLength > 0) {
121             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
122             receiver.tokenFallback(msg.sender, _value, _data);
123         }
124 
125         return true;
126     }
127 
128     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
129     /// @dev Allows for an approved third party to transfer tokens from one
130     /// address to another. Returns success.
131     /// @param _from Address from where tokens are withdrawn.
132     /// @param _to Address to where tokens are sent.
133     /// @param _value Number of tokens to transfer.
134     /// @return Returns success of function call.
135     function transferFrom(address _from, address _to, uint256 _value)
136         public
137         returns (bool)
138     {
139         require(_from != 0x0);
140         require(_to != 0x0);
141         require(_to != address(this));
142         require(balances[_from] >= _value);
143         require(allowed[_from][msg.sender] >= _value);
144         require(balances[_to] + _value >= balances[_to]);
145 
146         balances[_to] += _value;
147         balances[_from] -= _value;
148         allowed[_from][msg.sender] -= _value;
149 
150         emit Transfer(_from, _to, _value);
151 
152         return true;
153     }
154 
155     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
156     /// @dev Sets approved amount of tokens for spender. Returns success.
157     /// @param _spender Address of allowed account.
158     /// @param _value Number of approved tokens.
159     /// @return Returns success of function call.
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         require(_spender != 0x0);
162 
163         // To change the approve amount you first have to reduce the addresses`
164         // allowance to zero by calling `approve(_spender, 0)` if it is not
165         // already 0 to mitigate the race condition described here:
166         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167         require(_value == 0 || allowed[msg.sender][_spender] == 0);
168 
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     /*
175      * Read functions
176      */
177     /// @dev Returns number of allowed tokens that a spender can transfer on
178     /// behalf of a token owner.
179     /// @param _owner Address of token owner.
180     /// @param _spender Address of token spender.
181     /// @return Returns remaining allowance for spender.
182     function allowance(address _owner, address _spender)
183         constant
184         public
185         returns (uint256)
186     {
187         return allowed[_owner][_spender];
188     }
189 
190     /// @dev Returns number of tokens owned by the given address.
191     /// @param _owner Address of token owner.
192     /// @return Returns balance of owner.
193     function balanceOf(address _owner) constant public returns (uint256) {
194         return balances[_owner];
195     }
196 }
197 
198 
199 contract Moneto is StandardToken {
200   
201   string public name = "Moneto";
202   string public symbol = "MTO";
203   uint8 public decimals = 18;
204 
205   function Moneto(address saleAddress) public {
206     require(saleAddress != 0x0);
207 
208     totalSupply = 42901786 * 10**18;
209     balances[saleAddress] = totalSupply;
210     emit Transfer(0x0, saleAddress, totalSupply);
211 
212     assert(totalSupply == balances[saleAddress]);
213   }
214 
215   function burn(uint num) public {
216     require(num > 0);
217     require(balances[msg.sender] >= num);
218     require(totalSupply >= num);
219 
220     uint preBalance = balances[msg.sender];
221 
222     balances[msg.sender] -= num;
223     totalSupply -= num;
224     emit Transfer(msg.sender, 0x0, num);
225 
226     assert(balances[msg.sender] == preBalance - num);
227   }
228 }
229 
230 
231 contract MonetoSale {
232     Moneto public token;
233 
234     address public beneficiary;
235     address public alfatokenteam;
236     uint public alfatokenFee;
237     
238     uint public amountRaised;
239     uint public tokenSold;
240     
241     uint public constant PRE_SALE_START = 1523952000; // 17 April 2018, 08:00:00 GMT
242     uint public constant PRE_SALE_END = 1526543999; // 17 May 2018, 07:59:59 GMT
243     uint public constant SALE_START = 1528617600; // 10 June 2018,08:00:00 GMT
244     uint public constant SALE_END = 1531209599; // 10 July 2018, 07:59:59 GMT
245 
246     uint public constant PRE_SALE_MAX_CAP = 2531250 * 10**18;
247     uint public constant SALE_MAX_CAP = 300312502 * 10**17;
248 
249     uint public constant SALE_MIN_CAP = 2500 ether;
250 
251     uint public constant PRE_SALE_PRICE = 1250;
252     uint public constant SALE_PRICE = 1000;
253 
254     uint public constant PRE_SALE_MIN_BUY = 10 * 10**18;
255     uint public constant SALE_MIN_BUY = 1 * 10**18;
256 
257     uint public constant PRE_SALE_1WEEK_BONUS = 35;
258     uint public constant PRE_SALE_2WEEK_BONUS = 15;
259     uint public constant PRE_SALE_3WEEK_BONUS = 5;
260     uint public constant PRE_SALE_4WEEK_BONUS = 0;
261 
262     uint public constant SALE_1WEEK_BONUS = 10;
263     uint public constant SALE_2WEEK_BONUS = 7;
264     uint public constant SALE_3WEEK_BONUS = 5;
265     uint public constant SALE_4WEEK_BONUS = 3;
266     
267     mapping (address => uint) public icoBuyers;
268 
269     Stages public stage;
270     
271     enum Stages {
272         Deployed,
273         Ready,
274         Ended,
275         Canceled
276     }
277     
278     modifier atStage(Stages _stage) {
279         require(stage == _stage);
280         _;
281     }
282 
283     modifier isOwner() {
284         require(msg.sender == beneficiary);
285         _;
286     }
287 
288     function MonetoSale(address _beneficiary, address _alfatokenteam) public {
289         beneficiary = _beneficiary;
290         alfatokenteam = _alfatokenteam;
291         alfatokenFee = 5 ether;
292 
293         stage = Stages.Deployed;
294     }
295 
296     function setup(address _token) public isOwner atStage(Stages.Deployed) {
297         require(_token != 0x0);
298         token = Moneto(_token);
299 
300         stage = Stages.Ready;
301     }
302 
303     function () payable public atStage(Stages.Ready) {
304         require((now >= PRE_SALE_START && now <= PRE_SALE_END) || (now >= SALE_START && now <= SALE_END));
305 
306         uint amount = msg.value;
307         amountRaised += amount;
308 
309         if (now >= SALE_START && now <= SALE_END) {
310             assert(icoBuyers[msg.sender] + msg.value >= msg.value);
311             icoBuyers[msg.sender] += amount;
312         }
313         
314         uint tokenAmount = amount * getPrice();
315         require(tokenAmount > getMinimumAmount());
316         uint allTokens = tokenAmount + getBonus(tokenAmount);
317         tokenSold += allTokens;
318 
319         if (now >= PRE_SALE_START && now <= PRE_SALE_END) {
320             require(tokenSold <= PRE_SALE_MAX_CAP);
321         }
322         if (now >= SALE_START && now <= SALE_END) {
323             require(tokenSold <= SALE_MAX_CAP);
324         }
325 
326         token.transfer(msg.sender, allTokens);
327     }
328 
329     function transferEther(address _to, uint _amount) public isOwner {
330         require(_amount <= address(this).balance - alfatokenFee);
331         require(now < SALE_START || stage == Stages.Ended);
332         
333         _to.transfer(_amount);
334     }
335 
336     function transferFee(address _to, uint _amount) public {
337         require(msg.sender == alfatokenteam);
338         require(_amount <= alfatokenFee);
339 
340         alfatokenFee -= _amount;
341         _to.transfer(_amount);
342     }
343 
344     function endSale(address _to) public isOwner {
345         require(amountRaised >= SALE_MIN_CAP);
346 
347         token.transfer(_to, tokenSold*3/7);
348         token.burn(token.balanceOf(address(this)));
349 
350         stage = Stages.Ended;
351     }
352 
353     function cancelSale() public {
354         require(amountRaised < SALE_MIN_CAP);
355         require(now > SALE_END);
356 
357         stage = Stages.Canceled;
358     }
359 
360     function takeEtherBack() public atStage(Stages.Canceled) returns (bool) {
361         return proxyTakeEtherBack(msg.sender);
362     }
363 
364     function proxyTakeEtherBack(address receiverAddress) public atStage(Stages.Canceled) returns (bool) {
365         require(receiverAddress != 0x0);
366         
367         if (icoBuyers[receiverAddress] == 0) {
368             return false;
369         }
370 
371         uint amount = icoBuyers[receiverAddress];
372         icoBuyers[receiverAddress] = 0;
373         receiverAddress.transfer(amount);
374 
375         assert(icoBuyers[receiverAddress] == 0);
376         return true;
377     }
378 
379     function getBonus(uint amount) public view returns (uint) {
380         if (now >= PRE_SALE_START && now <= PRE_SALE_END) {
381             uint w = now - PRE_SALE_START;
382             if (w <= 1 weeks) {
383                 return amount * PRE_SALE_1WEEK_BONUS/100;
384             }
385             if (w > 1 weeks && w <= 2 weeks) {
386                 return amount * PRE_SALE_2WEEK_BONUS/100;
387             }
388             if (w > 2 weeks && w <= 3 weeks) {
389                 return amount * PRE_SALE_3WEEK_BONUS/100;
390             }
391             if (w > 3 weeks && w <= 4 weeks) {
392                 return amount * PRE_SALE_4WEEK_BONUS/100;
393             }
394             return 0;
395         }
396         if (now >= SALE_START && now <= SALE_END) {
397             uint w2 = now - SALE_START;
398             if (w2 <= 1 weeks) {
399                 return amount * SALE_1WEEK_BONUS/100;
400             }
401             if (w2 > 1 weeks && w2 <= 2 weeks) {
402                 return amount * SALE_2WEEK_BONUS/100;
403             }
404             if (w2 > 2 weeks && w2 <= 3 weeks) {
405                 return amount * SALE_3WEEK_BONUS/100;
406             }
407             if (w2 > 3 weeks && w2 <= 4 weeks) {
408                 return amount * SALE_4WEEK_BONUS/100;
409             }
410             return 0;
411         }
412         return 0;
413     }
414 
415     function getPrice() public view returns (uint) {
416         if (now >= PRE_SALE_START && now <= PRE_SALE_END) {
417             return PRE_SALE_PRICE;
418         }
419         if (now >= SALE_START && now <= SALE_END) {
420             return SALE_PRICE;
421         }
422         return 0;
423     }
424 
425     function getMinimumAmount() public view returns (uint) {
426         if (now >= PRE_SALE_START && now <= PRE_SALE_END) {
427             return PRE_SALE_MIN_BUY;
428         }
429         if (now >= SALE_START && now <= SALE_END) {
430             return SALE_MIN_BUY;
431         }
432         return 0;
433     }
434 }