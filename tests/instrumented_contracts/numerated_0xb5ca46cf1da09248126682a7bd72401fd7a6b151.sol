1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address _owner, address _spender)
21     public view returns (uint256);
22 
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25 
26   function approve(address _spender, uint256 _value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipRenounced(address indexed previousOwner);
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    * @notice Renouncing to ownership will leave the contract without an owner.
66    * It will not be possible to call the functions with the `onlyOwner`
67    * modifier anymore.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (_a == 0) {
107       return 0;
108     }
109 
110     c = _a * _b;
111     assert(c / _a == _b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     // assert(_b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = _a / _b;
121     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
122     return _a / _b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     assert(_b <= _a);
130     return _a - _b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
137     c = _a + _b;
138     assert(c >= _a);
139     return c;
140   }
141 }
142 
143 
144 contract ProvocoToken is ERC20, Ownable {
145     using SafeMath for uint256;
146 
147     string public constant name = "Provoco Token";
148     string public constant symbol = "VOCO";
149     uint8 public constant decimals = 18;
150 
151     mapping (address => uint256) private balances;
152     mapping (address => mapping (address => uint256)) internal allowed;
153 
154     event Mint(address indexed to, uint256 amount);
155     event MintFinished();
156 
157     bool public mintingFinished = false;
158     uint256 private totalSupply_;
159 
160     modifier canTransfer() {
161         require(mintingFinished);
162         _;
163     }
164 
165     /**
166     * @dev total number of tokens in existence
167     */
168     function totalSupply() public view returns (uint256) {
169         return totalSupply_;
170     }
171 
172     /**
173     * @dev transfer token for a specified address
174     * @param _to The address to transfer to.
175     * @param _value The amount to be transferred.
176     */
177     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
178         require(_to != address(0));
179         require(_value <= balances[msg.sender]);
180 
181         // SafeMath.sub will throw if there is not enough balance.
182         balances[msg.sender] = balances[msg.sender].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         emit Transfer(msg.sender, _to, _value);
185         return true;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address.
190     * @param _owner The address to query the the balance of.
191     * @return An uint256 representing the amount owned by the passed address.
192     */
193     function balanceOf(address _owner) public view returns (uint256 balance) {
194         return balances[_owner];
195     }
196 
197     /**
198     * @dev Transfer tokens from one address to another
199     * @param _from address The address which you want to send tokens from
200     * @param _to address The address which you want to transfer to
201     * @param _value uint256 the amount of tokens to be transferred
202     */
203     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207 
208         balances[_from] = balances[_from].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211         emit Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217     *
218     * Beware that changing an allowance with this method brings the risk that someone may use both the old
219     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222     * @param _spender The address which will spend the funds.
223     * @param _value The amount of tokens to be spent.
224     */
225     function approve(address _spender, uint256 _value) public returns (bool) {
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     /**
232     * @dev Function to check the amount of tokens that an owner allowed to a spender.
233     * @param _owner address The address which owns the funds.
234     * @param _spender address The address which will spend the funds.
235     * @return A uint256 specifying the amount of tokens still available for the spender.
236     */
237     function allowance(address _owner, address _spender) public view returns (uint256) {
238         return allowed[_owner][_spender];
239     }
240 
241     /**
242     * @dev Increase the amount of tokens that an owner allowed to a spender.
243     *
244     * approve should be called when allowed[_spender] == 0. To increment
245     * allowed value is better to use this function to avoid 2 calls (and wait until
246     * the first transaction is mined)
247     * From MonolithDAO Token.sol
248     * @param _spender The address which will spend the funds.
249     * @param _addedValue The amount of tokens to increase the allowance by.
250     */
251     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
252         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257     /**
258     * @dev Decrease the amount of tokens that an owner allowed to a spender.
259     *
260     * approve should be called when allowed[_spender] == 0. To decrement
261     * allowed value is better to use this function to avoid 2 calls (and wait until
262     * the first transaction is mined)
263     * From MonolithDAO Token.sol
264     * @param _spender The address which will spend the funds.
265     * @param _subtractedValue The amount of tokens to decrease the allowance by.
266     */
267     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
268         uint oldValue = allowed[msg.sender][_spender];
269         if (_subtractedValue > oldValue) {
270             allowed[msg.sender][_spender] = 0;
271         } else {
272             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273         }
274         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275         return true;
276     }
277 
278     modifier canMint() {
279         require(!mintingFinished);
280         _;
281     }
282 
283     /**
284     * @dev Function to mint tokens
285     * @param _to The address that will receive the minted tokens.
286     * @param _amount The amount of tokens to mint.
287     * @return A boolean that indicates if the operation was successful.
288     */
289     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
290         totalSupply_ = totalSupply_.add(_amount);
291         balances[_to] = balances[_to].add(_amount);
292         return true;
293     }
294 
295     function mintTokens(address[] _receivers, uint256[] _amounts) onlyOwner canMint external  {
296         require(_receivers.length > 0 && _receivers.length <= 100);
297         require(_receivers.length == _amounts.length);
298         for (uint256 i = 0; i < _receivers.length; i++) {
299             address receiver = _receivers[i];
300             uint256 amount = _amounts[i];
301 
302             require(receiver != address(0));
303             require(amount > 0);
304 
305             mint(receiver, amount);
306             emit Mint(receiver, amount);
307             emit Transfer(address(0), receiver, amount);
308         }
309     }
310 
311     /**
312     * @dev Function to stop minting new tokens.
313     * @return True if the operation was successful.
314     */
315     function finishMinting() public onlyOwner canMint returns (bool) {
316         mintingFinished = true;
317         emit MintFinished();
318         return true;
319     }
320 }