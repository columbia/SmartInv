1 pragma solidity ^0.5.8;
2 
3 library SafeMath {
4     
5     /**
6     * @dev Multiplies two unsigned integers, reverts on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Solidity only automatically asserts when dividing by 0
27         require(b > 0);
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a);
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     /**
45     * @dev Adds two unsigned integers, reverts on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
56     * reverts when dividing by zero.
57     */
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0);
60         return a % b;
61     }
62 }
63 
64 interface IERC20 {
65     function transfer(address to, uint256 value) external returns (bool);
66 
67     function approve(address spender, uint256 value) external returns (bool);
68 
69     function transferFrom(address from, address to, uint256 value) external returns (bool);
70 
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address who) external view returns (uint256);
74 
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract ERC20 is IERC20 {
83     using SafeMath for uint256;
84 
85     mapping (address => uint256) private _balances;
86 
87     mapping (address => mapping (address => uint256)) private _allowed;
88 
89     uint256 private _totalSupply;
90 
91     /**
92     * @dev Total number of tokens in existence
93     */
94     function totalSupply() public view returns (uint256) {
95         return _totalSupply;
96     }
97 
98     /**
99     * @dev Gets the balance of the specified address.
100     * @param owner The address to query the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address owner) public view returns (uint256) {
104         return _balances[owner];
105     }
106     
107     function _balanceOf(address owner) view internal returns (uint256) {
108         return _balances[owner];
109     }
110 
111     /**
112      * @dev Function to check the amount of tokens that an owner allowed to a spender.
113      * @param owner address The address which owns the funds.
114      * @param spender address The address which will spend the funds.
115      * @return A uint256 specifying the amount of tokens still available for the spender.
116      */
117     function allowance(address owner, address spender) public view returns (uint256) {
118         return _allowed[owner][spender];
119     }
120 
121     /**
122     * @dev Transfer token for a specified address
123     * @param to The address to transfer to.
124     * @param value The amount to be transferred.
125     */
126     function transfer(address to, uint256 value) public returns (bool) {
127         _transfer(msg.sender, to, value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param spender The address which will spend the funds.
138      * @param value The amount of tokens to be spent.
139      */
140     function approve(address spender, uint256 value) public returns (bool) {
141         require(spender != address(0));
142 
143         _allowed[msg.sender][spender] = value;
144         emit Approval(msg.sender, spender, value);
145         return true;
146     }
147 
148     /**
149      * @dev Transfer tokens from one address to another.
150      * Note that while this function emits an Approval event, this is not required as per the specification,
151      * and other compliant implementations may not emit the event.
152      * @param from address The address which you want to send tokens from
153      * @param to address The address which you want to transfer to
154      * @param value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(address from, address to, uint256 value) public returns (bool) {
157         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
158         _transfer(from, to, value);
159         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
160         return true;
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      * approve should be called when allowed_[_spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      * Emits an Approval event.
170      * @param spender The address which will spend the funds.
171      * @param addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
174         require(spender != address(0));
175 
176         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
177         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178         return true;
179     }
180 
181     /**
182      * @dev Decrease the amount of tokens that an owner allowed to a spender.
183      * approve should be called when allowed_[_spender] == 0. To decrement
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * Emits an Approval event.
188      * @param spender The address which will spend the funds.
189      * @param subtractedValue The amount of tokens to decrease the allowance by.
190      */
191     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
192         require(spender != address(0));
193 
194         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
195         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
196         return true;
197     }
198 
199     /**
200     * @dev Transfer token for a specified addresses
201     * @param from The address to transfer from.
202     * @param to The address to transfer to.
203     * @param value The amount to be transferred.
204     */
205     function _transfer(address from, address to, uint256 value) internal {
206         // require(to != address(0));
207 
208         _balances[from] = _balances[from].sub(value);
209         _balances[to] = _balances[to].add(value);
210         emit Transfer(from, to, value);
211     }
212 
213     /**
214      * @dev Internal function that mints an amount of the token and assigns it to
215      * an account. This encapsulates the modification of balances such that the
216      * proper events are emitted.
217      * @param account The account that will receive the created tokens.
218      * @param value The amount that will be created.
219      */
220     function _mint(address account, uint256 value) internal {
221         require(account != address(0));
222 
223         _totalSupply = _totalSupply.add(value);
224         _balances[account] = _balances[account].add(value);
225         emit Transfer(address(0), account, value);
226     }
227 
228     /**
229      * @dev Internal function that burns an amount of the token of a given
230      * account.
231      * @param account The account whose tokens will be burnt.
232      * @param value The amount that will be burnt.
233      */
234     function _burn(address account, uint256 value) internal {
235         require(account != address(0));
236 
237         _totalSupply = _totalSupply.sub(value);
238         _balances[account] = _balances[account].sub(value);
239         emit Transfer(account, address(0), value);
240     }
241 
242     /**
243      * @dev Internal function that burns an amount of the token of a given
244      * account, deducting from the sender's allowance for said account. Uses the
245      * internal burn function.
246      * Emits an Approval event (reflecting the reduced allowance).
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burnFrom(address account, uint256 value) internal {
251         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
252         _burn(account, value);
253         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
254     }
255 }
256 
257 contract ContractReceiver {
258     function tokenFallback(address _from, uint _value, bytes memory _data) public returns (bool);
259 }
260 
261 contract ForeignToken {
262     function balanceOf(address _owner) public returns (uint256);
263     function transfer(address _to, uint256 _value) public returns (bool);
264 }
265 
266 contract ERC20Detailed is IERC20 {
267     string private _name;
268     string private _symbol;
269     uint8 private _decimals;
270 
271     constructor (string memory name, string memory symbol, uint8 decimals) public {
272         _name = name;
273         _symbol = symbol;
274         _decimals = decimals;
275     }
276 
277     /**
278      * @return the name of the token.
279      */
280     function name() public view returns (string memory) {
281         return _name;
282     }
283 
284     /**
285      * @return the symbol of the token.
286      */
287     function symbol() public view returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @return the number of decimals of the token.
293      */
294     function decimals() public view returns (uint8) {
295         return _decimals;
296     }
297 }
298 
299 contract WiseNetwork is ERC20, ERC20Detailed {
300     uint256 public burned; 
301 	address payable public owner;
302 
303     string private constant NAME = "Wise Network";
304     string private constant SYMBOL = "WISE";
305     uint8 private constant DECIMALS = 18;
306     uint256 private constant INITIAL_SUPPLY = 1 * 10**8 * 10**18; // init 100 million
307     
308     event Donate(address indexed account, uint256 amount);
309     event ApproveAndCall(address _sender,uint256 _value,bytes _extraData);
310     event Transfer2Contract(address indexed from, address indexed to, uint256 value, bytes indexed data);
311     
312     modifier onlyOwner() {
313         require(msg.sender == owner);
314         _;
315     }
316 
317     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
318         _mint(msg.sender, INITIAL_SUPPLY);
319         
320         owner = msg.sender;
321     }
322 
323     function burn(uint256 _value) public returns(bool) {
324         burned = burned.add(_value);
325         _burn(msg.sender, _value);
326         return true;
327     }
328     
329     function transferOwnership(address payable _account) onlyOwner public returns(bool){
330         require(_account != address(0));
331 
332         owner = _account;
333         return true;
334     }
335     
336     function getTokenBalance(address tokenAddress, address who) public returns (uint){
337         ForeignToken t = ForeignToken(tokenAddress);
338         uint bal = t.balanceOf(who);
339         return bal;
340     }
341     
342     function withdraw(uint256 _amount) onlyOwner public {
343         require(_amount <= address(this).balance);
344         
345         uint256 etherBalance = _amount;
346         owner.transfer(etherBalance);
347     }
348     
349     function withdrawForeignTokens(address _tokenContract, uint256 _amount) onlyOwner public returns (bool) {
350         ForeignToken token = ForeignToken(_tokenContract);
351         uint256 amount = token.balanceOf(address(this));
352         
353         require(_amount <= amount);
354         
355         (bool success,) = _tokenContract.call(abi.encodeWithSignature("transfer(address,uint256)", owner, _amount));
356         require(success == true);
357         
358         return true;
359     }
360     
361 	function() external payable{
362         emit Donate(msg.sender, msg.value);
363     }
364     
365     function isContract(address _addr) internal view returns (bool) {
366         uint length;
367         assembly {
368             length := extcodesize(_addr)
369         }
370         return (length>0);
371     }
372     
373     // mitigates the ERC20 short address attack
374     modifier onlyPayloadSize(uint size) {
375         assert(msg.data.length >= size + 4);
376         _;
377     }
378     
379     
380     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
381         
382         bytes memory empty;
383         
384         if(isContract(_to)) {
385             return transferToContract(_to, _amount, empty);
386         }else {
387             _transfer(msg.sender, _to, _amount);
388             return true;
389         }
390     }
391     
392     //erc223-tansfer
393     function transfer(address _to, uint256 _amount, bytes memory _data, string memory _custom_fallback) onlyPayloadSize(2 * 32) public returns (bool success) {
394         
395         require(msg.sender != _to);
396         
397         if(isContract(_to)) {
398 
399             _transfer(msg.sender, _to, _amount);
400 
401             ContractReceiver receiver = ContractReceiver(_to);
402 
403             (bool success1,) = address(receiver).call(abi.encodeWithSignature(_custom_fallback, msg.sender, _amount, _data));
404             require(success1 == true);
405             
406             emit Transfer2Contract(msg.sender, _to, _amount, _data);
407             return true;
408         }
409         else {
410             _transfer(msg.sender, _to, _amount);
411             return true;
412         }
413     }
414 
415     //erc223-transfer
416     function transfer(address _to, uint256 _amount, bytes memory _data) onlyPayloadSize(2 * 32) public returns (bool success) {
417 
418         require(msg.sender != _to);
419 
420         if(isContract(_to)) {
421             return transferToContract(_to, _amount, _data);
422         }
423         else {
424             _transfer(msg.sender, _to, _amount);
425             return true;
426         }
427     }
428     
429     
430     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) payable public returns (bool) {
431         
432         approve(_spender, _value);
433         
434         (bool success1,) = msg.sender.call(abi.encodeWithSignature("receiveApproval(address,uint256,address,bytes)", msg.sender, _value, this, _extraData));
435         require(success1 == true);
436         
437         emit ApproveAndCall(_spender, _value, _extraData);
438         
439         return true;
440     }
441     
442     function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool) {
443         
444         _transfer(msg.sender, _to, _value);
445         
446         ContractReceiver receiver = ContractReceiver(_to);
447         receiver.tokenFallback(msg.sender, _value, _data);
448         
449         emit Transfer2Contract(msg.sender, _to, _value, _data);
450         return true;
451     }
452     
453 }