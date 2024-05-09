1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     assert(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     assert(c >= _a);
53 
54     return c;
55   }
56 }
57 
58 
59 
60 
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipRenounced(address indexed previousOwner);
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88   /**
89    * @dev Allows the current owner to relinquish control of the contract.
90    * @notice Renouncing to ownership will leave the contract without an owner.
91    * It will not be possible to call the functions with the `onlyOwner`
92    * modifier anymore.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address _newOwner) public onlyOwner {
104     _transferOwnership(_newOwner);
105   }
106 
107   /**
108    * @dev Transfers control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function _transferOwnership(address _newOwner) internal {
112     require(_newOwner != address(0));
113     emit OwnershipTransferred(owner, _newOwner);
114     owner = _newOwner;
115   }
116 }
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 {
122   function totalSupply() public view returns (uint256);
123 
124   function balanceOf(address _who) public view returns (uint256);
125 
126   function allowance(address _owner, address _spender)
127     public view returns (uint256);
128 
129   function transfer(address _to, uint256 _value) public returns (bool);
130 
131   function approve(address _spender, uint256 _value)
132     public returns (bool);
133 
134   function transferFrom(address _from, address _to, uint256 _value)
135     public returns (bool);
136 
137   event Transfer(address indexed from, address indexed to, uint256 value);
138 
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/issues/20
147  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20 {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156   uint256 totalSupply_;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address _owner,
182     address _spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return allowed[_owner][_spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_value <= balances[msg.sender]);
198     require(_to != address(0));
199 
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     emit Transfer(msg.sender, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amount of tokens to be transferred
226    */
227   function transferFrom(
228     address _from,
229     address _to,
230     uint256 _value
231   )
232     public
233     returns (bool)
234   {
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237     require(_to != address(0));
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     emit Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseApproval(
256     address _spender,
257     uint256 _addedValue
258   )
259     public
260     returns (bool)
261   {
262     allowed[msg.sender][_spender] = (
263       allowed[msg.sender][_spender].add(_addedValue));
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(
278     address _spender,
279     uint256 _subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     uint256 oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue >= oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 contract AgaveCoin is Ownable, StandardToken {
297   using SafeMath for uint256;
298 
299     string public name = "AgaveCoin";
300     string public symbol = "AGVC";
301     uint public decimals = 18;
302 
303     uint public INITIAL_SUPPLY = 35000 * (10**6) * (10 ** uint256(decimals)) ; // 35 Billion
304     
305     /// The owner of this address:
306     address public PartnersAddress = 0x3Ab66540262C3a35651B532FdcCaB59805Eb6d8B;
307 
308     /// The owner of this address:
309     address public TeamAddress = 0x9CDeA5dec3082ae7b8a58eb5E99c57876484f7A1;
310     
311     /// The owner of this address:
312     address public PrivateSaleAddress = 0x6690D262AB9848e132aaa9E25995e40949A497E0;    
313     
314     /// The owner of this address:
315     address public ReserveAddress = 0x40A6B86726e4003e3e72E3e70A8c70534938881D;
316 
317     uint256 PartnersTokens = 2450 * (10**6) * (10**uint256(decimals));
318     uint256 TeamTokens = 1750 * (10**6) * (10**uint256(decimals));
319     uint256 PrivateSaleTokens = 2450 * (10**6) * (10**uint256(decimals));
320     uint256 ReserveTokens = 5250 * (10**6) * (10**uint256(decimals));
321 
322     constructor () public {
323       totalSupply_ = INITIAL_SUPPLY;
324       balances[PartnersAddress] = PartnersTokens; //Partners
325       balances[TeamAddress] = TeamTokens; //Team and Advisers
326       balances[PrivateSaleAddress] = PrivateSaleTokens; //Private Sale
327       balances[ReserveAddress] = ReserveTokens; //Reserve
328       balances[msg.sender] = INITIAL_SUPPLY - PartnersTokens - TeamTokens - PrivateSaleTokens - ReserveTokens;
329 
330     }
331     //////////////// owner only functions below
332 
333     /// @notice To transfer token contract ownership
334     /// @param _newOwner The address of the new owner of this contract
335     function transferOwnership(address _newOwner) public onlyOwner {
336         balances[_newOwner] = balances[owner];
337         balances[owner] = 0;
338         Ownable.transferOwnership(_newOwner);
339     }
340 }