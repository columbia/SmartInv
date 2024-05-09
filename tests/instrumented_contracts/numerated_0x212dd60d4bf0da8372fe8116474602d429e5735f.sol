1 library SafeMath {
2 
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30 }
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37 
38   address public owner;
39 
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44   /**
45   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46   * account.
47   */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53   * @dev Throws if called by any account other than the owner.
54   */
55   modifier onlyOwner() {
56     require(msg.sender == owner, "Only the Contract owner can perform this action");
57     _;
58   }
59 
60   /**
61   * @dev Allows the current owner to transfer control of the contract to a newOwner.
62   * @param newOwner The address to transfer ownership to.
63   */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0), "New owner cannot be current owner");
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77 
78   /// Total amount of tokens
79   uint256 public totalSupply;
80 
81   function balanceOf(address _owner) public view returns (uint256 balance);
82 
83   function transfer(address _to, uint256 _amount) public returns (bool success);
84 
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94 
95   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
96 
97   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
98 
99   function approve(address _spender, uint256 _amount) public returns (bool success);
100 
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109 
110   using SafeMath for uint256;
111   uint balanceOfParticipant;
112   uint lockedAmount;
113   uint allowedAmount;
114   bool lockupIsActive = false;
115   uint256 lockupStartTime;
116 
117   // balances for each address
118   mapping(address => uint256) balances;
119 
120   struct Lockup {
121     uint256 lockupAmount;
122   }
123   Lockup lockup;
124   mapping(address => Lockup) lockupParticipants;
125   event LockupStarted(uint256 indexed lockupStartTime);
126 
127   function requireWithinLockupRange(address _spender, uint256 _amount) internal {
128     if (lockupIsActive) {
129       uint timePassed = now - lockupStartTime;
130       balanceOfParticipant = balances[_spender];
131       lockedAmount = lockupParticipants[_spender].lockupAmount;
132       allowedAmount = lockedAmount;
133       if (timePassed < 92 days) {
134         allowedAmount = lockedAmount.mul(5).div(100);
135       } else if (timePassed >= 92 days && timePassed < 183 days) {
136         allowedAmount = lockedAmount.mul(30).div(100);
137       } else if (timePassed >= 183 days && timePassed < 365 days) {
138         allowedAmount = lockedAmount.mul(55).div(100);
139       }
140       require(
141         balanceOfParticipant.sub(_amount) >= lockedAmount.sub(allowedAmount),
142         "Must maintain correct % of PVC during lockup periods"
143       );
144     }
145   }
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _amount The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _amount) public returns (bool success) {
153     require(_to != msg.sender, "Cannot transfer to self");
154     require(_to != address(this), "Cannot transfer to Contract");
155     require(_to != address(0), "Cannot transfer to 0x0");
156     require(
157       balances[msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to],
158       "Cannot transfer (Not enough balance)"
159     );
160 
161     requireWithinLockupRange(msg.sender, _amount);
162 
163     // SafeMath.sub will throw if there is not enough balance.
164     balances[msg.sender] = balances[msg.sender].sub(_amount);
165     balances[_to] = balances[_to].add(_amount);
166     emit Transfer(msg.sender, _to, _amount);
167     return true;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param _owner The address to query the the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address _owner) public view returns (uint256 balance) {
176     return balances[_owner];
177   }
178 
179 }
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191   /**
192   * @dev Transfer tokens from one address to another
193   * @param _from address The address which you want to send tokens from
194   * @param _to address The address which you want to transfer to
195   * @param _amount uint256 the amount of tokens to be transferred
196   */
197   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
198     require(_from != msg.sender, "Cannot transfer from self, use transfer function instead");
199     require(_from != address(this) && _to != address(this), "Cannot transfer from or to Contract");
200     require(_to != address(0), "Cannot transfer to 0x0");
201     require(balances[_from] >= _amount, "Not enough balance to transfer from");
202     require(allowed[_from][msg.sender] >= _amount, "Not enough allowance to transfer from");
203     require(_amount > 0 && balances[_to].add(_amount) > balances[_to], "Amount must be > 0 to transfer from");
204 
205     requireWithinLockupRange(_from, _amount);
206 
207     balances[_from] = balances[_from].sub(_amount);
208     balances[_to] = balances[_to].add(_amount);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
210     emit Transfer(_from, _to, _amount);
211     return true;
212   }
213 
214   /**
215   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216   *
217   * Beware that changing an allowance with this method brings the risk that someone may use both the old
218   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221   * @param _spender The address which will spend the funds.
222   * @param _amount The amount of tokens to be spent.
223   */
224   function approve(address _spender, uint256 _amount) public returns (bool success) {
225     require(_spender != msg.sender, "Cannot approve an allowance to self");
226     require(_spender != address(this), "Cannot approve contract an allowance");
227     require(_spender != address(0), "Cannot approve 0x0 an allowance");
228     allowed[msg.sender][_spender] = _amount;
229     emit Approval(msg.sender, _spender, _amount);
230     return true;
231   }
232 
233   /**
234   * @dev Function to check the amount of tokens that an owner allowed to a spender.
235   * @param _owner address The address which owns the funds.
236   * @param _spender address The address which will spend the funds.
237   * @return A uint256 specifying the amount of tokens still available for the spender.
238   */
239   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
240     return allowed[_owner][_spender];
241   }
242 
243 }
244 
245 /**
246  * @title Burnable Token
247  * @dev Token that can be irreversibly burned (destroyed).
248  */
249 contract BurnableToken is StandardToken, Ownable {
250 
251   event Burn(address indexed burner, uint256 value);
252 
253   /**
254     * @dev Burns a specific amount of tokens.
255     * @param _value The amount of token to be burned.
256     */
257   function burn(uint256 _value) public onlyOwner {
258     require(_value <= balances[msg.sender], "Not enough balance to burn");
259     // no need to require value <= totalSupply, since that would imply the
260     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
261 
262     balances[msg.sender] = balances[msg.sender].sub(_value);
263     totalSupply = totalSupply.sub(_value);
264     emit Burn(msg.sender, _value);
265   }
266 
267 }
268 
269 /**
270  * @title Brainz
271  * @dev Token representing Brainz.
272  */
273 contract StoboxToken is BurnableToken {
274 
275   string public name;
276   string public symbol;
277   uint8 public decimals = 18;
278   
279   /**
280   * @dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
281   */
282   function() external payable {
283     revert("Cannot send Ether to this contract");
284   }
285     
286   /**
287   * @dev Constructor function to initialize the initial supply of token to the creator of the contract
288   */
289   constructor(address wallet) public {
290     owner = wallet;
291     totalSupply = uint(1000000000).mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
292     name = "Stobox Token";
293     symbol = "STBU";
294     balances[wallet] = totalSupply;
295     
296     //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
297     emit Transfer(address(0), msg.sender, totalSupply);
298   }
299     
300   /**
301   * @dev helper method to get token details, name, symbol and totalSupply in one go
302   */
303   function getTokenDetail() public view returns (string memory, string memory, uint256) {
304     return (name, symbol, totalSupply);
305   }
306 
307   function vest(address[] memory _owners, uint[] memory _amounts) public onlyOwner {
308     require(_owners.length == _amounts.length, "Length of addresses & token amounts are not the same");
309     for (uint i = 0; i < _owners.length; i++) {
310       _amounts[i] = _amounts[i].mul(10 ** 18);
311       require(_owners[i] != address(0), "Vesting funds cannot be sent to 0x0");
312       require(_amounts[i] > 0, "Amount must be > 0");
313       require(balances[owner] > _amounts[i], "Not enough balance to vest");
314       require(balances[_owners[i]].add(_amounts[i]) > balances[_owners[i]], "Internal vesting error");
315 
316       // SafeMath.sub will throw if there is not enough balance.
317       balances[owner] = balances[owner].sub(_amounts[i]);
318       balances[_owners[i]] = balances[_owners[i]].add(_amounts[i]);
319       emit Transfer(owner, _owners[i], _amounts[i]);
320       lockup = Lockup({ lockupAmount: _amounts[i] });
321       lockupParticipants[_owners[i]] = lockup;
322     }
323   }
324 
325   function initiateLockup() public onlyOwner {
326     uint256 currentTime = now;
327     lockupIsActive = true;
328     lockupStartTime = currentTime;
329     emit LockupStarted(currentTime);
330   }
331 
332   function lockupActive() public view returns (bool) {
333     return lockupIsActive;
334   }
335 
336   function lockupAmountOf(address _owner) public view returns (uint256) {
337     return lockupParticipants[_owner].lockupAmount;
338   }
339 
340 }