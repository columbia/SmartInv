1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * @dev Increase the amount of tokens that an owner allowed to a spender.
151    *
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    * @param _spender The address which will spend the funds.
157    * @param _addedValue The amount of tokens to increase the allowance by.
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   /**
166    * @dev Decrease the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To decrement
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _subtractedValue The amount of tokens to decrease the allowance by.
174    */
175   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract DetailedERC20 is ERC20 {
189   string public name;
190   string public symbol;
191   uint8 public decimals;
192 
193   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
194     name = _name;
195     symbol = _symbol;
196     decimals = _decimals;
197   }
198 }
199 
200 contract Ownable {
201   address public owner;
202 
203 
204   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206 
207   /**
208    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
209    * account.
210    */
211   function Ownable() public {
212     owner = msg.sender;
213   }
214 
215   /**
216    * @dev Throws if called by any account other than the owner.
217    */
218   modifier onlyOwner() {
219     require(msg.sender == owner);
220     _;
221   }
222 
223   /**
224    * @dev Allows the current owner to transfer control of the contract to a newOwner.
225    * @param newOwner The address to transfer ownership to.
226    */
227   function transferOwnership(address newOwner) public onlyOwner {
228     require(newOwner != address(0));
229     OwnershipTransferred(owner, newOwner);
230     owner = newOwner;
231   }
232 
233 }
234 
235 contract VideoTrusted is
236     Ownable
237   {
238 
239   /// @dev Array of trusted contracts' addresses.
240   address[] public trustedContracts;
241 
242   /// @dev Emitted when a new trusted contract is added.
243   /// @param newTrustedContract new trusted contract's address added.
244   event TrustedContractAdded(address newTrustedContract);
245 
246   /// @dev Emitted when an old trusted contract is removed.
247   /// @param oldTrustedContract old trusted contract's address removed.
248   event TrustedContractRemoved(address oldTrustedContract);
249 
250   /// @dev Access modifier for trusted contracts functionality. Owner(aka CEO)
251   ///   is also a trusted contract.
252   modifier onlyTrustedContracts() {
253     require(msg.sender == owner ||
254             findTrustedContract(msg.sender) >= 0);
255     _;
256   }
257 
258   /// @dev find the trusted contract index for an address, or -1 if not found.
259   /// @param _address the address to be searched for.
260   function findTrustedContract(address _address) public view returns (int) {
261     for (uint i = 0; i < trustedContracts.length; i++) {
262       if (_address == trustedContracts[i]) {
263         return int(i);
264       }
265     }
266     return -1;
267   }
268 
269   /// @dev Add a new address to the board.
270   /// @param _newTrustedContract the new address to be added. If it is already a
271   //    trusted contract, do nothing.
272   function addTrustedContract(address _newTrustedContract) public onlyOwner {
273     require(findTrustedContract(_newTrustedContract) < 0);
274     trustedContracts.push(_newTrustedContract);
275     TrustedContractAdded(_newTrustedContract);
276   }
277 
278   /// @dev Remove an old trusted contract address from the board.
279   /// @param _oldTrustedContract the address to be removed. If it is not a
280   //    trusted contract, do nothing.
281   function removeTrustedContract(address _oldTrustedContract) public onlyOwner {
282     int i = findTrustedContract(_oldTrustedContract);
283     require(i >= 0);
284     delete trustedContracts[uint(i)];
285     TrustedContractAdded(_oldTrustedContract);
286   }
287 
288   /// @dev Return a list of current trusted contracts.
289   function getTrustedContracts() external view onlyTrustedContracts returns (address[]) {
290     return trustedContracts;
291   }
292 
293 }
294 
295 contract BitVideoCoin is DetailedERC20, StandardToken, VideoTrusted {
296 
297   using SafeMath for uint256;
298 
299   /**
300   * @dev constructor of the token
301   */
302   function BitVideoCoin() DetailedERC20('BitVideo Coin', 'BTVC', 6) public {
303     totalSupply_ = 100000000;
304     balances[msg.sender] = totalSupply_;
305   }
306 
307   /* mint function part */
308   event Mint(address indexed to, uint256 amount);
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mintTrusted(address _to, uint256 _amount)
317       public
318       onlyTrustedContracts
319       returns (bool) {
320     // Do not allow owner to mint manually
321     require(msg.sender != owner);
322     totalSupply_ = totalSupply_.add(_amount);
323     balances[_to] = balances[_to].add(_amount);
324     Mint(_to, _amount);
325     Transfer(address(0), _to, _amount);
326     return true;
327   }
328 
329   /* burn function part */
330   event Burn(address indexed burner, uint256 value);
331 
332   /**
333    * @dev Burns a specific amount of tokens.
334    * @param _who The address that amount of token is burned.
335    * @param _value The amount of token to be burned.
336    */
337   function burnTrusted(address _who, uint256 _value) public onlyTrustedContracts {
338     require(_value <= balances[_who]);
339     // Do not allow owner to burn manually
340     require(msg.sender != owner);
341     // no need to require value <= totalSupply, since that would imply the
342     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
343 
344     balances[_who] = balances[_who].sub(_value);
345     totalSupply_ = totalSupply_.sub(_value);
346     Burn(_who, _value);
347     Transfer(_who, address(0), _value);
348   }
349 
350 }