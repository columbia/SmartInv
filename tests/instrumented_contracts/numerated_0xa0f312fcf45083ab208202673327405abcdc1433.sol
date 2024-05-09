1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Ownable {
46     address public owner;
47     
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(address newOwner) public onlyOwner {
73         require(newOwner != address(0));
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78     
79     
80 }
81 
82 
83 
84 contract ERC20Basic {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     function transferByInternal(address from, address to, uint256 value) internal returns (bool);
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     event MintedToken(address indexed target, uint256 value);
91 }
92 
93 contract BasicToken is ERC20Basic, Ownable {
94     using SafeMath for uint256;
95 
96     mapping(address => uint256) balances;
97 
98     uint256 maxSupply_;
99     uint256 totalSupply_;
100 
101     modifier onlyPayloadSize(uint numwords) {
102         assert(msg.data.length == numwords * 32 + 4);
103         _;
104     } 
105 
106     /**
107     * @dev total number of tokens in existence
108     */
109     function totalSupply() public view returns (uint256) {
110         return totalSupply_;
111     }
112 
113     function maxSupply() public view returns (uint256) {
114         return maxSupply_;
115     }
116 
117     /**
118     * @dev transfer token for a specified address
119     * @param _to The address to transfer to.
120     * @param _value The amount to be transferred.
121     */
122     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[msg.sender]);
125 
126         // SafeMath.sub will throw if there is not enough balance.
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133 
134     function transferByInternal(address _from, address _to, uint256 _value) internal returns (bool) {
135         // Prevent transfer to 0x0 address. Use burn() instead
136         require(_to != address(0));
137         // Check value more than 0
138         require(_value > 0);
139         // Check if the sender has enough
140         require(balances[_from] >= _value);
141         // Check for overflows
142         require(balances[_to] + _value > balances[_to]);
143         // Save this for an assertion in the future
144         uint256 previousBalances = balances[_from] + balances[_to];
145         // Subtract from the sender
146         balances[_from] = balances[_from].sub(_value);
147         // Add the same to the recipient
148         balances[_to] = balances[_to].add(_value);
149         Transfer(_from, _to, _value);
150         // Asserts are used to use static analysis to find bugs in your code. They should never fail
151         assert(balances[_from] + balances[_to] == previousBalances);
152         return true;
153     }
154 
155     /**
156     * @dev Gets the balance of the specified address.
157     * @param _owner The address to query the the balance of.
158     * @return An uint256 representing the amount owned by the passed address.
159     */
160     function balanceOf(address _owner) public view returns (uint256 balance) {
161         return balances[_owner];
162     }
163 
164     function mintToken(address _target, uint256 _mintedAmount) onlyOwner public {
165         require(_target != address(0));
166         require(_mintedAmount > 0);
167         require(maxSupply_ > 0 && totalSupply_.add(_mintedAmount) <= maxSupply_);
168         balances[_target] = balances[_target].add(_mintedAmount);
169         totalSupply_ = totalSupply_.add(_mintedAmount);
170         Transfer(0, _target, _mintedAmount);
171         MintedToken(_target, _mintedAmount);
172     }
173 }
174 
175 contract CanReclaimToken is Ownable {
176     using SafeERC20 for ERC20Basic;
177 
178   /**
179    * @dev Reclaim all ERC20Basic compatible tokens
180    * @param token ERC20Basic The address of the token contract
181    */
182   function reclaimToken(ERC20Basic token) external onlyOwner {
183     uint256 balance = token.balanceOf(this);
184     token.transfer(owner, balance);
185   }
186 }
187 
188 
189 
190 contract ERC20 is ERC20Basic {
191     function allowance(address owner, address spender) public view returns (uint256);
192     function transferFrom(address from, address to, uint256 value) public returns (bool);
193     function approve(address spender, uint256 value) public returns (bool);
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 library SafeERC20 {
198     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
199         assert(token.transfer(to, value));
200     }
201 
202     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
203         assert(token.transferFrom(from, to, value));
204     }
205 
206     function safeApprove(ERC20 token, address spender, uint256 value) internal {
207         assert(token.approve(spender, value));
208     }
209 }
210 
211 contract StandardToken is ERC20, BasicToken {
212 
213     mapping (address => mapping (address => uint256)) internal allowed;
214 
215 
216     /**
217      * @dev Transfer tokens from one address to another
218      * @param _from address The address which you want to send tokens from
219      * @param _to address The address which you want to transfer to
220      * @param _value uint256 the amount of tokens to be transferred
221      */
222     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
223         require(_to != address(0));
224         require(_value <= balances[_from]);
225         require(_value <= allowed[_from][msg.sender]);
226 
227         balances[_from] = balances[_from].sub(_value);
228         balances[_to] = balances[_to].add(_value);
229         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230         Transfer(_from, _to, _value);
231         return true;
232     }
233 
234     /**
235      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236      *
237      * Beware that changing an allowance with this method brings the risk that someone may use both the old
238      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      * @param _spender The address which will spend the funds.
242      * @param _value The amount of tokens to be spent.
243      */
244     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
245         allowed[msg.sender][_spender] = _value;
246         Approval(msg.sender, _spender, _value);
247         return true;
248     }
249 
250     /**
251      * @dev Function to check the amount of tokens that an owner allowed to a spender.
252      * @param _owner address The address which owns the funds.
253      * @param _spender address The address which will spend the funds.
254      * @return A uint256 specifying the amount of tokens still available for the spender.
255      */
256     function allowance(address _owner, address _spender) public view returns (uint256) {
257         return allowed[_owner][_spender];
258     }
259 
260     /**
261      * @dev Increase the amount of tokens that an owner allowed to a spender.
262      *
263      * approve should be called when allowed[_spender] == 0. To increment
264      * allowed value is better to use this function to avoid 2 calls (and wait until
265      * the first transaction is mined)
266      * From MonolithDAO Token.sol
267      * @param _spender The address which will spend the funds.
268      * @param _addedValue The amount of tokens to increase the allowance by.
269      */
270     function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
271         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
272         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273         return true;
274     }
275 
276     /**
277      * @dev Decrease the amount of tokens that an owner allowed to a spender.
278      *
279      * approve should be called when allowed[_spender] == 0. To decrement
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * @param _spender The address which will spend the funds.
284      * @param _subtractedValue The amount of tokens to decrease the allowance by.
285      */
286     function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
287         uint oldValue = allowed[msg.sender][_spender];
288         if (_subtractedValue > oldValue) {
289             allowed[msg.sender][_spender] = 0;
290         } else {
291             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292         }
293         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294         return true;
295     }
296 
297 }
298 
299 contract CBSToken is StandardToken, CanReclaimToken {
300     using SafeMath for uint;
301 
302     event BuyToken(address indexed from, uint256 value);
303     event SellToken(address indexed from, uint256 value, uint256 sellEth);
304     event TransferContractEth(address indexed to, uint256 value);
305 
306 
307     string public symbol;
308     string public name;
309     string public version = "1.0";
310 
311     uint8 public decimals;
312     uint256 INITIAL_SUPPLY;
313     uint256 tokens;
314 
315     uint256 public buyPrice;
316     uint256 public sellPrice;
317     uint256 public contractEth;
318     bool public allowBuy;
319     bool public allowSell;
320 
321     // constructor
322     function CBSToken(
323         string _symbol,
324         string _name,
325         uint8 _decimals, 
326         uint256 _INITIAL_SUPPLY,
327         uint256 _buyPrice,
328         uint256 _sellPrice,
329         bool _allowBuy,
330         bool _allowSell
331     ) public {
332         symbol = _symbol;
333         name = _name;
334         decimals = _decimals;
335         INITIAL_SUPPLY = _INITIAL_SUPPLY * 10 ** uint256(decimals);
336         setBuyPrices(_buyPrice);
337         setSellPrices(_sellPrice);
338 
339         totalSupply_ = INITIAL_SUPPLY;
340         maxSupply_ = INITIAL_SUPPLY;
341         balances[owner] = totalSupply_;
342         allowBuy = _allowBuy;
343         allowSell = _allowSell;
344     }
345 
346     function setAllowBuy(bool _allowBuy) public onlyOwner {
347         allowBuy = _allowBuy;
348     }
349 
350     function setBuyPrices(uint256 _newBuyPrice) public onlyOwner {
351         buyPrice = _newBuyPrice;
352     }
353 
354     function setAllowSell(bool _allowSell) public onlyOwner {
355         allowSell = _allowSell;
356     }
357 
358     function setSellPrices(uint256 _newSellPrice) public onlyOwner {
359         sellPrice = _newSellPrice;
360     }
361 
362     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
363         super.transfer(_to, _value);
364     }
365 
366     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
367         super.transferFrom(_from, _to, _value);
368     }
369 
370     function () public payable {
371         BuyTokens(msg.value);
372     }
373 
374     function BuyTokens(uint256 _value)  internal {
375         tokens = _value.div(buyPrice).mul(100);
376         require(allowBuy);
377         require(_value > 0 && _value >= buyPrice && tokens > 0);
378         require(balances[owner] >= tokens);
379 
380         super.transferByInternal(owner, msg.sender, tokens);
381         contractEth = contractEth.add(_value);
382         BuyToken(msg.sender, _value);
383     }
384 
385     function transferEther(address _to, uint256 _value) onlyOwner public returns (bool) {
386         require(_value <= contractEth);
387         _to.transfer(_value);
388         contractEth = contractEth.sub(_value);
389         TransferContractEth(_to, _value);
390         return true;
391     }
392 
393     
394 
395     function sellTokens(uint256 _value) public returns (bool) {
396         uint256 sellEth;
397         require(allowSell);
398         require(_value > 0);
399         require(balances[msg.sender] >= _value);
400         if (sellPrice == 0){
401             sellEth = 0;
402         }
403         else
404         {
405             sellEth = _value.mul(sellPrice).div(100);
406         }
407 
408         super.transferByInternal(msg.sender, owner, _value);
409         SellToken(msg.sender, _value, sellEth);
410         msg.sender.transfer(sellEth);
411         contractEth = contractEth.sub(sellEth);
412     }
413 
414 }