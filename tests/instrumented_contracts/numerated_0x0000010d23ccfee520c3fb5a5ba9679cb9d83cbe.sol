1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 contract ZFX {
8     string public name = 'ZFX';
9     string public symbol = 'ZFX';
10     uint8 public decimals = 18;
11     uint public totalSupply = 1000000 * 10 ** uint(decimals);
12     address public owner;
13 
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     
21     // This generates a public event on the blockchain that will notify clients
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24     // This notifies clients about the amount burnt
25     event Burn(address indexed from, uint256 value);
26 
27     modifier onlyOwner {
28         if (msg.sender != owner) revert();
29         _;
30     }
31 
32     /**
33      * Constructor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     constructor(address creator) public {
38         balanceOf[creator] = totalSupply;
39         owner = msg.sender;
40     }
41 
42     /**
43      * Internal transfer, only can be called by this contract
44      */
45     function _transfer(address _from, address _to, uint _value) internal {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != address(0x0));
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         // Save this for an assertion in the future
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         // Subtract from the sender
55         balanceOf[_from] -= _value;
56         // Add the same to the recipient
57         balanceOf[_to] += _value;
58         emit Transfer(_from, _to, _value);
59         // Asserts are used to use static analysis to find bugs in your code. They should never fail
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62 
63     /**
64      * Transfer tokens
65      *
66      * Send `_value` tokens to `_to` from your account
67      *
68      * @param _to The address of the recipient
69      * @param _value the amount to send
70      */
71     function transfer(address _to, uint256 _value) public returns (bool success) {
72         _transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     /**
77      * Transfer tokens from other address
78      *
79      * Send `_value` tokens to `_to` on behalf of `_from`
80      *
81      * @param _from The address of the sender
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93      * Set allowance for other address
94      *
95      * Allows `_spender` to spend no more than `_value` tokens on your behalf
96      *
97      * @param _spender The address authorized to spend
98      * @param _value the max amount they can spend
99      */
100     function approve(address _spender, uint256 _value) public
101         returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address and notify
109      *
110      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      * @param _extraData some extra information to send to the approved contract
115      */
116     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
117         public
118         returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
122             return true;
123         }
124     }
125 
126     /**
127      * Destroy tokens
128      *
129      * Remove `_value` tokens from the system irreversibly
130      *
131      * @param _value the amount of money to burn
132      */
133     function burn(uint256 _value) public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
135         balanceOf[msg.sender] -= _value;            // Subtract from the sender
136         totalSupply -= _value;                      // Updates totalSupply
137         emit Burn(msg.sender, _value);
138         return true;
139     }
140 
141     /**
142      * Destroy tokens from other account
143      *
144      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145      *
146      * @param _from the address of the sender
147      * @param _value the amount of money to burn
148      */
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
151         require(_value <= allowance[_from][msg.sender]);    // Check allowance
152         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
153         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         emit Burn(_from, _value);
156         return true;
157     }
158     
159     function mint(address _to, uint _amount) external onlyOwner {
160         balanceOf[_to] += _amount;
161         totalSupply += _amount;
162         require(totalSupply >= _amount);
163         emit Transfer(address(0), address(this), _amount);
164         emit Transfer(address(this), _to, _amount);
165     }
166 }
167 
168 contract Token {
169     function totalSupply() public constant returns (uint);
170     function balanceOf(address tokenOwner) public constant returns (uint balance);
171     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
172     function transfer(address to, uint tokens) public returns (bool success);
173     function approve(address spender, uint tokens) public returns (bool success);
174     function transferFrom(address from, address to, uint tokens) public returns (bool success);
175     
176     uint8 public decimals;
177 }
178 
179 contract Exchange {
180     struct Order {
181         address creator;
182         address token;
183         bool buy;
184         uint price;
185         uint amount;
186     }
187     
188     address public owner;
189     uint public feeDeposit = 500;
190     
191     mapping (uint => Order) orders;
192     uint currentOrderId = 0;
193     
194     ZFX public ZFXToken;
195     
196     /* Token address (0x0 - Ether) => User address => balance */
197     mapping (address => mapping (address => uint)) public balanceOf;
198     
199     event FundTransfer(address backer, uint amount, bool isContribution);
200     
201     event PlaceSell(address indexed token, address indexed user, uint price, uint amount, uint id);
202     event PlaceBuy(address indexed token, address indexed user, uint price, uint amount, uint id);
203     event FillOrder(uint indexed id, address indexed user, uint amount);
204     event CancelOrder(uint indexed id);
205     event Deposit(address indexed token, address indexed user, uint amount);
206     event Withdraw(address indexed token, address indexed user, uint amount);
207     event BalanceChanged(address indexed token, address indexed user, uint value);
208 
209     modifier onlyOwner {
210         if (msg.sender != owner) revert();
211         _;
212     }
213     
214     function transferOwnership(address newOwner) external onlyOwner {
215         owner = newOwner;
216     }
217     
218     constructor() public {
219         owner = msg.sender;
220         ZFXToken = new ZFX(msg.sender);
221     }
222     
223     function safeAdd(uint a, uint b) private pure returns (uint) {
224         uint c = a + b;
225         assert(c >= a);
226         return c;
227     }
228     
229     function safeSub(uint a, uint b) private pure returns (uint) {
230         assert(b <= a);
231         return a - b;
232     }
233     
234     function safeMul(uint a, uint b) private pure returns (uint) {
235         if (a == 0) {
236           return 0;
237         }
238         
239         uint c = a * b;
240         assert(c / a == b);
241         return c;
242     }
243     
244     function decFeeDeposit(uint delta) external onlyOwner {
245         feeDeposit = safeSub(feeDeposit, delta);
246     }
247     
248     function calcAmountEther(address tokenAddr, uint price, uint amount) private view returns (uint) {
249         uint k = 10;
250         k = k ** Token(tokenAddr).decimals();
251         return safeMul(amount, price) / k;
252     }
253     
254     function balanceAdd(address tokenAddr, address user, uint amount) private {
255         balanceOf[tokenAddr][user] =
256             safeAdd(balanceOf[tokenAddr][user], amount);
257     }
258     
259     function balanceSub(address tokenAddr, address user, uint amount) private {
260         require(balanceOf[tokenAddr][user] >= amount);
261         balanceOf[tokenAddr][user] =
262             safeSub(balanceOf[tokenAddr][user], amount);
263     }
264     
265     function placeBuy(address tokenAddr, uint price, uint amount) external {
266         require(price > 0 && amount > 0);
267         uint amountEther = calcAmountEther(tokenAddr, price, amount);
268         require(amountEther > 0);
269         balanceSub(0x0, msg.sender, amountEther);
270         emit BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
271         orders[currentOrderId] = Order({
272             creator: msg.sender,
273             token: tokenAddr,
274             buy: true,
275             price: price,
276             amount: amount
277         });
278         emit PlaceBuy(tokenAddr, msg.sender, price, amount, currentOrderId);
279         currentOrderId++;
280         
281         ZFXToken.mint(msg.sender, 1000000000000000000);
282     }
283     
284     function placeSell(address tokenAddr, uint price, uint amount) external {
285         require(price > 0 && amount > 0);
286         uint amountEther = calcAmountEther(tokenAddr, price, amount);
287         require(amountEther > 0);
288         balanceSub(tokenAddr, msg.sender, amount);
289         emit BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
290         orders[currentOrderId] = Order({
291             creator: msg.sender,
292             token: tokenAddr,
293             buy: false,
294             price: price,
295             amount: amount
296         });
297         emit PlaceSell(tokenAddr, msg.sender, price, amount, currentOrderId);
298         currentOrderId++;
299         
300         ZFXToken.mint(msg.sender, 1000000000000000000);
301     }
302     
303     function fillOrder(uint id, uint amount) external {
304         require(id < currentOrderId);
305         require(amount > 0);
306         require(orders[id].creator != msg.sender);
307         require(orders[id].amount >= amount);
308         uint amountEther = calcAmountEther(orders[id].token, orders[id].price, amount);
309         if (orders[id].buy) {
310             /* send tokens from sender to creator */
311             // sub from sender
312             balanceSub(orders[id].token, msg.sender, amount);
313             emit BalanceChanged(
314                 orders[id].token,
315                 msg.sender,
316                 balanceOf[orders[id].token][msg.sender]
317             );
318             
319             // add to creator
320             balanceAdd(orders[id].token, orders[id].creator, amount);
321             emit BalanceChanged(
322                 orders[id].token,
323                 orders[id].creator,
324                 balanceOf[orders[id].token][orders[id].creator]
325             );
326             
327             /* send Ether to sender */
328             balanceAdd(0x0, msg.sender, amountEther);
329             emit BalanceChanged(
330                 0x0,
331                 msg.sender,
332                 balanceOf[0x0][msg.sender]
333             );
334         } else {
335             /* send Ether from sender to creator */
336             // sub from sender
337             balanceSub(0x0, msg.sender, amountEther);
338             emit BalanceChanged(
339                 0x0,
340                 msg.sender,
341                 balanceOf[0x0][msg.sender]
342             );
343             
344             // add to creator
345             balanceAdd(0x0, orders[id].creator, amountEther);
346             emit BalanceChanged(
347                 0x0,
348                 orders[id].creator,
349                 balanceOf[0x0][orders[id].creator]
350             );
351             
352             /* send tokens to sender */
353             balanceAdd(orders[id].token, msg.sender, amount);
354             emit BalanceChanged(
355                 orders[id].token,
356                 msg.sender,
357                 balanceOf[orders[id].token][msg.sender]
358             );
359         }
360         orders[id].amount -= amount;
361         emit FillOrder(id, msg.sender, orders[id].amount);
362         
363         ZFXToken.mint(msg.sender, 1000000000000000000);
364     }
365     
366     function cancelOrder(uint id) external {
367         require(id < currentOrderId);
368         require(orders[id].creator == msg.sender);
369         require(orders[id].amount > 0);
370         if (orders[id].buy) {
371             uint amountEther = calcAmountEther(orders[id].token, orders[id].price, orders[id].amount);
372             balanceAdd(0x0, msg.sender, amountEther);
373             emit BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
374         } else {
375             balanceAdd(orders[id].token, msg.sender, orders[id].amount);
376             emit BalanceChanged(orders[id].token, msg.sender, balanceOf[orders[id].token][msg.sender]);
377         }
378         orders[id].amount = 0;
379         emit CancelOrder(id);
380     }
381     
382     function getFee(address user) public view returns (uint) {
383         uint fee = feeDeposit * ZFXToken.balanceOf(user) * 10 / ZFXToken.totalSupply();
384         return fee < feeDeposit ? feeDeposit - fee : 0;
385     }
386     
387     function () external payable {
388         require(msg.value > 0);
389         uint fee = msg.value * getFee(msg.sender) / 10000;
390         require(msg.value > fee);
391         balanceAdd(0x0, owner, fee);
392         
393         uint toAdd = msg.value - fee;
394         balanceAdd(0x0, msg.sender, toAdd);
395         
396         emit Deposit(0x0, msg.sender, toAdd);
397         emit BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
398         
399         emit FundTransfer(msg.sender, toAdd, true);
400     }
401     
402     function depositToken(address tokenAddr, uint amount) external {
403         require(tokenAddr != 0x0);
404         require(amount > 0);
405         Token(tokenAddr).transferFrom(msg.sender, this, amount);
406         balanceAdd(tokenAddr, msg.sender, amount);
407         
408         emit Deposit(tokenAddr, msg.sender, amount);
409         emit BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
410     }
411     
412     function withdrawEther(uint amount) external {
413         require(amount > 0);
414         balanceSub(0x0, msg.sender, amount);
415         msg.sender.transfer(amount);
416         
417         emit Withdraw(0x0, msg.sender, amount);
418         emit BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
419         
420         emit FundTransfer(msg.sender, amount, false);
421     }
422     
423     function withdrawToken(address tokenAddr, uint amount) external {
424         require(tokenAddr != 0x0);
425         require(amount > 0);
426         balanceSub(tokenAddr, msg.sender, amount);
427         Token(tokenAddr).transfer(msg.sender, amount);
428         
429         emit Withdraw(tokenAddr, msg.sender, amount);
430         emit BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
431     }
432 }