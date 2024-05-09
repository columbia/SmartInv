1 //////////////////////////////////////////
2 // PROJECT HYDRO
3 // Multi Chain Token
4 //////////////////////////////////////////
5 pragma solidity ^0.6.0;
6 contract Ownable {
7     address public owner;
8 
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17    constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 interface Raindrop {
88     function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) external;
89 }
90 
91 interface tokenRecipient {
92     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
93 }
94 
95 interface IERC20 {
96   /**
97    * @dev Returns the amount of tokens in existence.
98    */
99   function totalSupply() external view returns (uint256);
100 
101   /**
102    * @dev Returns the token decimals.
103    */
104   function decimals() external view returns (uint8);
105 
106   /**
107    * @dev Returns the token symbol.
108    */
109   function symbol() external view returns (string memory);
110 
111   /**
112   * @dev Returns the token name.
113   */
114   function name() external view returns (string memory);
115 
116   /**
117    * @dev Returns the amount of tokens owned by `account`.
118    */
119   function balanceOf(address account) external view returns (uint256);
120 
121   /**
122    * @dev Moves `amount` tokens from the caller's account to `recipient`.
123    *
124    * Returns a boolean value indicating whether the operation succeeded.
125    *
126    * Emits a {Transfer} event.
127    */
128   function transfer(address recipient, uint256 amount) external returns (bool);
129 
130   /**
131    * @dev Returns the remaining number of tokens that `spender` will be
132    * allowed to spend on behalf of `owner` through {transferFrom}. This is
133    * zero by default.
134    *
135    * This value changes when {approve} or {transferFrom} are called.
136    */
137   function allowance(address _owner, address spender) external view returns (uint256);
138 
139   /**
140    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141    *
142    * Returns a boolean value indicating whether the operation succeeded.
143    *
144    * IMPORTANT: Beware that changing an allowance with this method brings the risk
145    * that someone may use both the old and the new allowance by unfortunate
146    * transaction ordering. One possible solution to mitigate this race
147    * condition is to first reduce the spender's allowance to 0 and set the
148    * desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    *
151    * Emits an {Approval} event.
152    */
153   function approve(address spender, uint256 amount) external returns (bool);
154 
155   /**
156    * @dev Moves `amount` tokens from `sender` to `recipient` using the
157    * allowance mechanism. `amount` is then deducted from the caller's
158    * allowance.
159    *
160    * Returns a boolean value indicating whether the operation succeeded.
161    *
162    * Emits a {Transfer} event.
163    */
164   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
165 
166   /**
167    * @dev Emitted when `value` tokens are moved from one account (`from`) to
168    * another (`to`).
169    *
170    * Note that `value` may be zero.
171    */
172   event Transfer(address indexed from, address indexed to, uint256 value);
173 
174   /**
175    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176    * a call to {approve}. `value` is the new allowance.
177    */
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 contract HydroToken is Ownable,IERC20 {
182     using SafeMath for uint256;
183 
184     string public _name;
185     string public _symbol;
186     uint8 public _decimals;            // Number of decimals of the smallest unit
187     uint public _totalSupply;
188     address public raindropAddress;
189     uint256 ratio;
190     uint256 public MAX_BURN= 100000000000000000; //0.1 hydro tokens
191 
192     mapping (address => uint256) public balances;
193     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
194     mapping (address => mapping (address => uint256)) public allowed;
195     mapping(address=>bool) public whitelistedDapps; //dapps that can burn tokens
196     
197     //makes sure only dappstore apps can burn tokens
198     modifier onlyFromDapps(address _dapp){
199         require(whitelistedDapps[msg.sender]==true,'Hydro: Burn error');
200         _;
201     }
202     
203     event dappBurned(address indexed _dapp, uint256 _amount );
204 
205 ////////////////
206 // Constructor
207 ////////////////
208 
209     /// @notice Constructor to create a HydroToken
210     constructor(uint256 _ratio) public {
211         _name='HYDRO TOKEN';
212         _symbol='HYDRO';
213         _decimals=18;
214         raindropAddress=address(0);
215        _totalSupply = (11111111111 * 10**18)/_ratio;
216         // Give the creator all initial tokens
217         balances[msg.sender] = _totalSupply;
218         ratio = _ratio;
219         emit Transfer(address(0), msg.sender, _totalSupply);
220     }
221     
222 
223 
224 ///////////////////
225 // ERC20 Methods
226 ///////////////////
227 
228     //transfers an amount of tokens from one account to another
229     //accepts two variables
230     function transfer(address _to, uint256 _amount) public override  returns (bool success) {
231         doTransfer(msg.sender, _to, _amount);
232         return true;
233 }
234 
235   /**
236    * @dev Returns the token symbol.
237    */
238   function symbol() public override view returns (string memory) {
239     return _symbol;
240   }
241   
242   /**
243   * @dev Returns the token name.
244   */
245   function name() public override view returns (string memory) {
246     return _name;
247   }
248   
249     //transfers an amount of tokens from one account to another
250     //accepts three variables
251     function transferFrom(address _from, address _to, uint256 _amount
252     ) public override returns (bool success) {
253         // The standard ERC 20 transferFrom functionality
254         require(allowed[_from][msg.sender] >= _amount);
255         allowed[_from][msg.sender] -= _amount;
256         doTransfer(_from, _to, _amount);
257         return true;
258     }
259     
260     //allows the owner to change the MAX_BURN amount
261     function changeMaxBurn(uint256 _newBurn) public onlyOwner returns(uint256 ) {
262         MAX_BURN=_newBurn;
263         return (_newBurn);
264     }
265 
266     //internal function to implement the transfer function and perform some safety checks
267     function doTransfer(address _from, address _to, uint _amount
268     ) internal {
269         // Do not allow transfer to 0x0 or the token contract itself
270         require((_to != address(0)) && (_to != address(this)));
271         require(_amount <= balances[_from]);
272         balances[_from] = balances[_from].sub(_amount);
273         balances[_to] = balances[_to].add(_amount);
274         emit Transfer(_from, _to, _amount);
275     }
276 
277     //returns balance of an address
278     function balanceOf(address _owner) public override view returns (uint256 balance) {
279         return balances[_owner];
280     }
281 
282     //allows an address to approve another address to spend its tokens
283     function approve(address _spender, uint256 _amount) public override returns (bool success) {
284         // To change the approve amount you first have to reduce the addresses`
285         //  allowance to zero by calling `approve(_spender,0)` if it is not
286         //  already 0 to mitigate the race condition described here:
287         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
289         allowed[msg.sender][_spender] = _amount;
290         emit Approval(msg.sender, _spender, _amount);
291         return true;
292     }
293     
294     //sends the approve function but with a data argument
295     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public  returns (bool success) {
296         tokenRecipient spender = tokenRecipient(_spender);
297         if (approve(_spender, _value)) {
298             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
299             return true;
300         }
301     }
302     
303    /**
304    * @dev Returns the token decimals.
305    */
306   function decimals() external view override returns (uint8) {
307     return _decimals;
308   }
309 
310 
311 
312     //returns the allowance an address has granted a spender
313     function allowance(address _owner, address _spender
314     ) public view override returns (uint256 remaining) {
315         return allowed[_owner][_spender];
316     }
317     
318     //allows an owner to whitelist a dapp so it can burn tokens
319     function _whiteListDapp(address _dappAddress) public onlyOwner returns(bool){
320         whitelistedDapps[_dappAddress]=true;
321         return true;
322     }
323     
324     //allows an owner to blacklist a dapp so it can stop burn tokens
325     function _blackListDapp(address _dappAddress) public onlyOwner returns(bool){
326          whitelistedDapps[_dappAddress]=false;
327          return false;
328     }
329 
330     //returns current hydro totalSupply
331     function totalSupply() public view override returns (uint) {
332         return _totalSupply;
333     }
334 
335     //allows the owner to set the Raindrop
336     function setRaindropAddress(address _raindrop) public onlyOwner {
337         raindropAddress = _raindrop;
338     }
339     
340     //the main public burn function which uses the internal burn function
341     function burn(address _from,uint256 _value) external returns(uint burnAmount) {
342     _burn(_from,_value);
343     emit dappBurned(msg.sender,_value);
344     return(burnAmount);
345     }
346 
347     function authenticate(uint _value, uint _challenge, uint _partnerId) public  {
348         Raindrop raindrop = Raindrop(raindropAddress);
349         raindrop.authenticate(msg.sender, _value, _challenge, _partnerId);
350         doTransfer(msg.sender, owner, _value);
351     }
352 
353     //internal burn function which makes sure that only whitelisted addresses can burn
354     function _burn(address account, uint256 amount) internal onlyFromDapps(msg.sender) {
355     require(account != address(0), "ERC20: burn from the zero address");
356     require(amount >= MAX_BURN,'ERC20: Exceeds maximum burn amount');
357     balances[account] = balances[account].sub(amount); 
358     _totalSupply = _totalSupply.sub(amount);
359     emit Transfer(account, address(0), amount);
360   }
361 }