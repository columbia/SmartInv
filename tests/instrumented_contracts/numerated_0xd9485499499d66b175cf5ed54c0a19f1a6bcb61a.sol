1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipRenounced(address indexed previousOwner);
7   event OwnershipTransferred(
8                              address indexed previousOwner,
9                              address indexed newOwner
10                              );
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     emit OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 }
47 
48 contract ERC20Token {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   uint256 totalSupply_;
54 
55   /**
56    * @dev total number of tokens in existence
57    */
58   function totalSupply() public view returns (uint256) {
59     return totalSupply_;
60   }
61 
62   /**
63    * @dev transfer token for a specified address
64    * @param _to The address to transfer to.
65    * @param _value The amount to be transferred.
66    */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     emit Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78    * @dev Gets the balance of the specified address.
79    * @param _owner The address to query the the balance of.
80    * @return An uint256 representing the amount owned by the passed address.
81    */
82   function balanceOf(address _owner) public view returns (uint256) {
83     return balances[_owner];
84   }
85 
86   function allowance(address owner, address spender)
87     public view returns (uint256);
88 
89   function transferFrom(address from, address to, uint256 value)
90     public returns (bool);
91 
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender,uint256 value);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 contract StandardToken is ERC20Token {
98   string public name;
99   string public symbol;
100   uint8 public decimals;
101 
102   constructor(string _name, string _symbol, uint8 _decimals) public {
103     name = _name;
104     symbol = _symbol;
105     decimals = _decimals;
106   }
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value ) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     emit Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     emit Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance( address _owner,  address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    *
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param _spender The address which will spend the funds.
162    * @param _addedValue The amount of tokens to increase the allowance by.
163    */
164   function increaseApproval( address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
166     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   /**
171    * @dev Decrease the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval( address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 contract PausableToken is StandardToken, Ownable {
194   event Pause();
195   event Unpause();
196 
197   bool public paused = false;
198 
199 
200   /**
201    * @dev Modifier to make a function callable only when the contract is not paused.
202    */
203   modifier whenNotPaused() {
204     require(!paused);
205     _;
206   }
207 
208   /**
209    * @dev Modifier to make a function callable only when the contract is paused.
210    */
211   modifier whenPaused() {
212     require(paused);
213     _;
214   }
215 
216   /**
217    * @dev called by the owner to pause, triggers stopped state
218    */
219   function pause() onlyOwner whenNotPaused public {
220     paused = true;
221     emit Pause();
222   }
223 
224   /**
225    * @dev called by the owner to unpause, returns to normal state
226    */
227   function unpause() onlyOwner whenPaused public {
228     paused = false;
229     emit Unpause();
230   }
231 
232   function transfer( address _to, uint256 _value) public whenNotPaused returns (bool) {
233     return super.transfer(_to, _value);
234   }
235 
236   function transferFrom( address _from, address _to, uint256 _value) public whenNotPaused returns (bool)
237   {
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241   function approve( address _spender, uint256 _value) public whenNotPaused returns (bool) {
242     return super.approve(_spender, _value);
243   }
244 
245   function increaseApproval( address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
246     return super.increaseApproval(_spender, _addedValue);
247   }
248 
249   function decreaseApproval( address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
250     return super.decreaseApproval(_spender, _subtractedValue);
251   }
252 }
253 
254 contract UseChainToken is PausableToken {
255 
256   using SafeMath for uint256;
257 
258   // One time switch to enable token transferability.
259   bool public transferable = false;
260 
261   // Record usechain wallet to allow transfering.
262   address public usechainWallet;
263 
264   // 20 billion tokens, 18 decimals.
265   uint public constant INITIAL_SUPPLY = 2e28;
266 
267   modifier onlyWhenTransferEnabled() {
268     if (!transferable) {
269       require(msg.sender == owner || msg.sender == usechainWallet);
270     }
271     _;
272   }
273 
274   modifier validDestination(address to) {
275     require(to != address(this));
276     _;
277   }
278 
279   constructor(address _usechainWallet) public StandardToken("UseChain Token", "USE", 18) {
280 
281     require(_usechainWallet != address(0));
282     usechainWallet = _usechainWallet;
283     totalSupply_ = INITIAL_SUPPLY;
284     balances[_usechainWallet] = totalSupply_;
285     emit Transfer(address(0), _usechainWallet, totalSupply_);
286   }
287 
288   /// @dev Override to only allow tranfer.
289   function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) onlyWhenTransferEnabled returns (bool) {
290     return super.transferFrom(_from, _to, _value);
291   }
292 
293   /// @dev Override to only allow tranfer after being switched on.
294   function transfer(address _to, uint256 _value) public validDestination(_to) onlyWhenTransferEnabled returns (bool) {
295     return super.transfer(_to, _value);
296   }
297 
298   /**
299    * @dev One-time switch to enable transfer.
300    */
301   function enableTransfer() external onlyOwner {
302     transferable = true;
303   }
304 
305 }
306 
307 library SafeMath {
308 
309   /**
310    * @dev Multiplies two numbers, throws on overflow.
311    */
312   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
313     if (a == 0) {
314       return 0;
315     }
316     c = a * b;
317     assert(c / a == b);
318     return c;
319   }
320 
321   /**
322    * @dev Integer division of two numbers, truncating the quotient.
323    */
324   function div(uint256 a, uint256 b) internal pure returns (uint256) {
325     // assert(b > 0); // Solidity automatically throws when dividing by 0
326     // uint256 c = a / b;
327     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
328     return a / b;
329   }
330 
331   /**
332    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
333    */
334   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
335     assert(b <= a);
336     return a - b;
337   }
338 
339   /**
340    * @dev Adds two numbers, throws on overflow.
341    */
342   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
343     c = a + b;
344     assert(c >= a);
345     return c;
346   }
347 }