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
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address _owner, address _spender)
22     public view returns (uint256);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     public returns (bool);
26 
27   function approve(address _spender, uint256 _value) public returns (bool);
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipRenounced(address indexed previousOwner);
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to relinquish control of the contract.
66    * @notice Renouncing to ownership will leave the contract without an owner.
67    * It will not be possible to call the functions with the `onlyOwner`
68    * modifier anymore.
69    */
70   function renounceOwnership() public onlyOwner {
71     emit OwnershipRenounced(owner);
72     owner = address(0);
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param _newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address _newOwner) public onlyOwner {
80     _transferOwnership(_newOwner);
81   }
82 
83   /**
84    * @dev Transfers control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function _transferOwnership(address _newOwner) internal {
88     require(_newOwner != address(0));
89     emit OwnershipTransferred(owner, _newOwner);
90     owner = _newOwner;
91   }
92 }
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99 
100   /**
101   * @dev Multiplies two numbers, throws on overflow.
102   */
103   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
104     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
105     // benefit is lost if 'b' is also tested.
106     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107     if (_a == 0) {
108       return 0;
109     }
110 
111     c = _a * _b;
112     assert(c / _a == _b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
120     // assert(_b > 0); // Solidity automatically throws when dividing by 0
121     // uint256 c = _a / _b;
122     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
123     return _a / _b;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
130     assert(_b <= _a);
131     return _a - _b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
138     c = _a + _b;
139     assert(c >= _a);
140     return c;
141   }
142 }
143 
144 
145 contract SecretsOfZurichToken is ERC20, Ownable {
146     using SafeMath for uint256;
147 
148     string public constant name = "Secrets of Zurich Token";
149     string public constant symbol = "SOZ";
150     uint8 public constant decimals = 18;
151 
152     mapping (address => uint256) private balances;
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155     event Mint(address indexed to, uint256 amount);
156     event MintFinished();
157 
158     bool public mintingFinished = false;
159     uint256 private totalSupply_;
160 
161     modifier canTransfer() {
162         require(mintingFinished);
163         _;
164     }
165 
166     /**
167     * @dev total number of tokens in existence
168     */
169     function totalSupply() public view returns (uint256) {
170         return totalSupply_;
171     }
172 
173     /**
174     * @dev transfer token for a specified address
175     * @param _to The address to transfer to.
176     * @param _value The amount to be transferred.
177     */
178     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
179         require(_to != address(0));
180         require(_value <= balances[msg.sender]);
181 
182         // SafeMath.sub will throw if there is not enough balance.
183         balances[msg.sender] = balances[msg.sender].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         emit Transfer(msg.sender, _to, _value);
186         return true;
187     }
188 
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param _owner The address to query the the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address _owner) public view returns (uint256 balance) {
195         return balances[_owner];
196     }
197 
198     /**
199     * @dev Transfer tokens from one address to another
200     * @param _from address The address which you want to send tokens from
201     * @param _to address The address which you want to transfer to
202     * @param _value uint256 the amount of tokens to be transferred
203     */
204     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
205         require(_to != address(0));
206         require(_value <= balances[_from]);
207         require(_value <= allowed[_from][msg.sender]);
208 
209         balances[_from] = balances[_from].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218     *
219     * Beware that changing an allowance with this method brings the risk that someone may use both the old
220     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223     * @param _spender The address which will spend the funds.
224     * @param _value The amount of tokens to be spent.
225     */
226     function approve(address _spender, uint256 _value) public returns (bool) {
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231 
232     /**
233     * @dev Function to check the amount of tokens that an owner allowed to a spender.
234     * @param _owner address The address which owns the funds.
235     * @param _spender address The address which will spend the funds.
236     * @return A uint256 specifying the amount of tokens still available for the spender.
237     */
238     function allowance(address _owner, address _spender) public view returns (uint256) {
239         return allowed[_owner][_spender];
240     }
241 
242     /**
243     * @dev Increase the amount of tokens that an owner allowed to a spender.
244     *
245     * approve should be called when allowed[_spender] == 0. To increment
246     * allowed value is better to use this function to avoid 2 calls (and wait until
247     * the first transaction is mined)
248     * From MonolithDAO Token.sol
249     * @param _spender The address which will spend the funds.
250     * @param _addedValue The amount of tokens to increase the allowance by.
251     */
252     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     /**
259     * @dev Decrease the amount of tokens that an owner allowed to a spender.
260     *
261     * approve should be called when allowed[_spender] == 0. To decrement
262     * allowed value is better to use this function to avoid 2 calls (and wait until
263     * the first transaction is mined)
264     * From MonolithDAO Token.sol
265     * @param _spender The address which will spend the funds.
266     * @param _subtractedValue The amount of tokens to decrease the allowance by.
267     */
268     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269         uint oldValue = allowed[msg.sender][_spender];
270         if (_subtractedValue > oldValue) {
271             allowed[msg.sender][_spender] = 0;
272         } else {
273             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274         }
275         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 
279     modifier canMint() {
280         require(!mintingFinished);
281         _;
282     }
283 
284     /**
285     * @dev Function to mint tokens
286     * @param _to The address that will receive the minted tokens.
287     * @param _amount The amount of tokens to mint.
288     * @return A boolean that indicates if the operation was successful.
289     */
290     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
291         totalSupply_ = totalSupply_.add(_amount);
292         balances[_to] = balances[_to].add(_amount);
293         return true;
294     }
295 
296     function mintTokens(address[] _receivers, uint256[] _amounts) onlyOwner canMint external  {
297         require(_receivers.length > 0 && _receivers.length <= 100);
298         require(_receivers.length == _amounts.length);
299         for (uint256 i = 0; i < _receivers.length; i++) {
300             address receiver = _receivers[i];
301             uint256 amount = _amounts[i];
302 
303             require(receiver != address(0));
304             require(amount > 0);
305 
306             mint(receiver, amount);
307             emit Mint(receiver, amount);
308             emit Transfer(address(0), receiver, amount);
309         }
310     }
311 
312     /**
313     * @dev Function to stop minting new tokens.
314     * @return True if the operation was successful.
315     */
316     function finishMinting() public onlyOwner canMint returns (bool) {
317         mintingFinished = true;
318         emit MintFinished();
319         return true;
320     }
321 }