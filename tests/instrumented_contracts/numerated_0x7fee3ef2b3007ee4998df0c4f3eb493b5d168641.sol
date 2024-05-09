1 pragma solidity ^0.4.13;
2 
3 contract GCCExchangeAccessControl {
4     address public owner;
5     address public operator;
6 
7     modifier onlyOwner() {require(msg.sender == owner);_;}
8     modifier onlyOperator() {require(msg.sender == operator);_;}
9     modifier onlyOwnerOrOperator() {require(msg.sender == owner || msg.sender == operator);_;}
10 
11     function transferOwnership(address newOwner) public onlyOwner {
12         require(newOwner != address(0));
13         owner = newOwner;
14     }
15 
16     function transferOperator(address newOperator) public onlyOwner {
17         require(newOperator != address(0));
18         operator = newOperator;
19     }
20 
21     function withdrawBalance(address _recipient, uint256 amount) external onlyOwnerOrOperator {
22         require(amount > 0);
23         require(amount <= this.balance);
24         require(_recipient != address(0));
25         _recipient.transfer(amount);
26     }
27 
28     function depositBalance() external payable {}
29 }
30 
31 contract GCCExchangePausable is GCCExchangeAccessControl {
32     bool public paused;
33 
34     modifier whenPaused() {require(paused);_;}
35     modifier whenNotPaused() {require(!paused);_;}
36 
37     function pause() public onlyOwnerOrOperator whenNotPaused {
38         paused = true;
39     }
40 
41     function unpause() public onlyOwner whenPaused {
42         paused = false;
43     }
44 }
45 
46 contract GCCExchangeCoinOperation is GCCExchangePausable {
47     GoCryptobotCoinERC827 internal coin;
48 
49     function setCoinContract(address _address) external onlyOwnerOrOperator {
50         GoCryptobotCoinERC827 _contract = GoCryptobotCoinERC827(_address);
51         // FIXME: Check coin.isGCC();
52         coin = _contract;
53     }
54 
55     function unpause() public {
56         require(coin != address(0));
57         super.unpause();
58     }
59 
60     function operate(bytes data) external onlyOwnerOrOperator {
61         require(coin.call(data));
62     }
63 }
64 
65 contract GCCExchangeCore is GCCExchangeCoinOperation {
66     uint8 constant FEE_RATE = 5;
67     uint256 public exchangeRate;
68     address internal coinStorage;
69 
70     event ExchangeRateChange(uint256 from, uint256 to);
71     event Withdrawal(address claimant, uint256 mgccAmount, uint256 weiAmount);
72 
73     function GCCExchangeCore() public {
74         coinStorage = this;
75         // 1 mGCC = 0.000001 ETH;
76         exchangeRate = 1000000000000 wei;
77 
78         paused = true;
79 
80         owner = msg.sender;
81         operator = msg.sender;
82     }
83 
84     function setCoinStorage(address _address) public onlyOwnerOrOperator {
85         coinStorage = _address;
86     }
87 
88     function setExchangeRate(uint256 rate) external onlyOwnerOrOperator {
89         ExchangeRateChange(exchangeRate, rate);
90         exchangeRate = rate;
91     }
92 
93     function withdraw(address _claimant, uint256 _mgcc) public whenNotPaused {
94         // FIXME: Check withdrawal limits here
95         require(coin.allowance(_claimant, this) >= _mgcc);
96         require(coin.transferFrom(_claimant, coinStorage, _mgcc));
97         uint256 exchange = (_convertToWei(_mgcc) / 100) * (100 - FEE_RATE);
98         _claimant.transfer(exchange);
99         Withdrawal(_claimant, _mgcc, exchange);
100     }
101 
102     function _convertToWei(uint256 mgcc) internal view returns (uint256) {
103         return mgcc * exchangeRate;
104     }
105 
106     function () external payable {
107         revert();
108     }
109 }
110 
111 contract GoCryptobotCoinERC20 {
112     using SafeMath for uint256;
113 
114     string public constant name = "GoCryptobotCoin";
115     string public constant symbol = "GCC";
116     uint8 public constant decimals = 3;
117 
118     mapping(address => uint256) balances;
119     mapping (address => mapping (address => uint256)) internal allowed;
120 
121     uint256 totalSupply_;
122 
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 
126     /**
127        @dev total number of tokens in existence
128      */
129     function totalSupply() public view returns (uint256) {
130         return totalSupply_;
131     }
132 
133     /**
134        @dev Gets the balance of the specified address.
135        @param _owner The address to query the the balance of.
136        @return An uint256 representing the amount owned by the passed address.
137      */
138     function balanceOf(address _owner) public view returns (uint256 balance) {
139         return balances[_owner];
140     }
141 
142     /**
143        @dev transfer token for a specified address
144        @param _to The address to transfer to.
145        @param _value The amount to be transferred.
146      */
147     function transfer(address _to, uint256 _value) public returns (bool) {
148         require(_to != address(0));
149         require(_value <= balances[msg.sender]);
150 
151         // SafeMath.sub will throw if there is not enough balance.
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     /**
159        @dev Function to check the amount of tokens that an owner allowed to a spender.
160        @param _owner address The address which owns the funds.
161        @param _spender address The address which will spend the funds.
162        @return A uint256 specifying the amount of tokens still available for the spender.
163      */
164     function allowance(address _owner, address _spender) public view returns (uint256) {
165         return allowed[_owner][_spender];
166     }
167 
168     /**
169        @dev Transfer tokens from one address to another
170        @param _from address The address which you want to send tokens from
171        @param _to address The address which you want to transfer to
172        @param _value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187        @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188       
189        Beware that changing an allowance with this method brings the risk that someone may use both the old
190        and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191        race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193        @param _spender The address which will spend the funds.
194        @param _value The amount of tokens to be spent.
195      */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203        @dev Increase the amount of tokens that an owner allowed to a spender.
204       
205        approve should be called when allowed[_spender] == 0. To increment
206        allowed value is better to use this function to avoid 2 calls (and wait until
207        the first transaction is mined)
208        From MonolithDAO Token.sol
209        @param _spender The address which will spend the funds.
210        @param _addedValue The amount of tokens to increase the allowance by.
211      */
212     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
213         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     /**
219        @dev Decrease the amount of tokens that an owner allowed to a spender.
220       
221        approve should be called when allowed[_spender] == 0. To decrement
222        allowed value is better to use this function to avoid 2 calls (and wait until
223        the first transaction is mined)
224        From MonolithDAO Token.sol
225        @param _spender The address which will spend the funds.
226        @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 }
239 
240 contract GoCryptobotCoinERC827 is GoCryptobotCoinERC20 {
241     /**
242        @dev Addition to ERC20 token methods. It allows to
243        approve the transfer of value and execute a call with the sent data.
244 
245        Beware that changing an allowance with this method brings the risk that
246        someone may use both the old and the new allowance by unfortunate
247        transaction ordering. One possible solution to mitigate this race condition
248        is to first reduce the spender's allowance to 0 and set the desired value
249        afterwards:
250        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251 
252        @param _spender The address that will spend the funds.
253        @param _value The amount of tokens to be spent.
254        @param _data ABI-encoded contract call to call `_to` address.
255 
256        @return true if the call function was executed successfully
257      */
258     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool) {
259         require(_spender != address(this));
260         super.approve(_spender, _value);
261         require(_spender.call(_data));
262         return true;
263     }
264 
265     /**
266        @dev Addition to ERC20 token methods. Transfer tokens to a specified
267        address and execute a call with the sent data on the same transaction
268 
269        @param _to address The address which you want to transfer to
270        @param _value uint256 the amout of tokens to be transfered
271        @param _data ABI-encoded contract call to call `_to` address.
272 
273        @return true if the call function was executed successfully
274      */
275     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool) {
276         require(_to != address(this));
277         super.transfer(_to, _value);
278         require(_to.call(_data));
279         return true;
280     }
281 
282     /**
283        @dev Addition to ERC20 token methods. Transfer tokens from one address to
284        another and make a contract call on the same transaction
285 
286        @param _from The address which you want to send tokens from
287        @param _to The address which you want to transfer to
288        @param _value The amout of tokens to be transferred
289        @param _data ABI-encoded contract call to call `_to` address.
290 
291        @return true if the call function was executed successfully
292      */
293     function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool) {
294         require(_to != address(this));
295         super.transferFrom(_from, _to, _value);
296         require(_to.call(_data));
297         return true;
298     }
299 
300     /**
301        @dev Addition to StandardToken methods. Increase the amount of tokens that
302        an owner allowed to a spender and execute a call with the sent data.
303 
304        approve should be called when allowed[_spender] == 0. To increment
305        allowed value is better to use this function to avoid 2 calls (and wait until
306        the first transaction is mined)
307        From MonolithDAO Token.sol
308        @param _spender The address which will spend the funds.
309        @param _addedValue The amount of tokens to increase the allowance by.
310        @param _data ABI-encoded contract call to call `_spender` address.
311      */
312     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
313         require(_spender != address(this));
314         super.increaseApproval(_spender, _addedValue);
315         require(_spender.call(_data));
316         return true;
317     }
318 
319     /**
320        @dev Addition to StandardToken methods. Decrease the amount of tokens that
321        an owner allowed to a spender and execute a call with the sent data.
322 
323        approve should be called when allowed[_spender] == 0. To decrement
324        allowed value is better to use this function to avoid 2 calls (and wait until
325        the first transaction is mined)
326        From MonolithDAO Token.sol
327        @param _spender The address which will spend the funds.
328        @param _subtractedValue The amount of tokens to decrease the allowance by.
329        @param _data ABI-encoded contract call to call `_spender` address.
330      */
331     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
332         require(_spender != address(this));
333         super.decreaseApproval(_spender, _subtractedValue);
334         require(_spender.call(_data));
335         return true;
336     }
337 }
338 
339 library SafeMath {
340 
341     /**
342     * @dev Multiplies two numbers, throws on overflow.
343     */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         if (a == 0) {
346             return 0;
347         }
348         uint256 c = a * b;
349         assert(c / a == b);
350         return c;
351     }
352 
353     /**
354     * @dev Integer division of two numbers, truncating the quotient.
355     */
356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
357         // assert(b > 0); // Solidity automatically throws when dividing by 0
358         uint256 c = a / b;
359         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
360         return c;
361     }
362 
363     /**
364     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
365     */
366     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
367         assert(b <= a);
368         return a - b;
369     }
370 
371     /**
372     * @dev Adds two numbers, throws on overflow.
373     */
374     function add(uint256 a, uint256 b) internal pure returns (uint256) {
375         uint256 c = a + b;
376         assert(c >= a);
377         return c;
378     }
379 }