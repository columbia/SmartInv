1 pragma solidity ^0.5.3;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 
37 }
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44 
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53   * account.
54   */
55   constructor() public {
56     owner = msg.sender;
57   }
58 
59   /**
60   * @dev Throws if called by any account other than the owner.
61   */
62   modifier onlyOwner() {
63     require(msg.sender == owner, "Only the Contract owner can perform this action");
64     _;
65   }
66 
67   /**
68   * @dev Allows the current owner to transfer control of the contract to a newOwner.
69   * @param newOwner The address to transfer ownership to.
70   */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0), "New owner cannot be current owner");
73     emit OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84 
85   /// Total amount of tokens
86   uint256 public totalSupply;
87 
88   function balanceOf(address _owner) public view returns (uint256 balance);
89 
90   function transfer(address _to, uint256 _amount) public returns (bool success);
91 
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 
94 }
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101 
102   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
103 
104   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
105 
106   function approve(address _spender, uint256 _amount) public returns (bool success);
107 
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic {
116 
117   using SafeMath for uint256;
118   uint balanceOfParticipant;
119   uint lockedAmount;
120   uint allowedAmount;
121   bool lockupIsActive = false;
122   uint256 lockupStartTime;
123 
124   // balances for each address
125   mapping(address => uint256) balances;
126 
127   struct Lockup {
128     uint256 lockupAmount;
129   }
130   Lockup lockup;
131   mapping(address => Lockup) lockupParticipants;
132   event LockupStarted(uint256 indexed lockupStartTime);
133 
134   function requireWithinLockupRange(address _spender, uint256 _amount) internal {
135     if (lockupIsActive) {
136       uint timePassed = now - lockupStartTime;
137       balanceOfParticipant = balances[_spender];
138       lockedAmount = lockupParticipants[_spender].lockupAmount;
139       allowedAmount = lockedAmount;
140       if (timePassed < 92 days) {
141         allowedAmount = lockedAmount.mul(5).div(100);
142       } else if (timePassed >= 92 days && timePassed < 183 days) {
143         allowedAmount = lockedAmount.mul(30).div(100);
144       } else if (timePassed >= 183 days && timePassed < 365 days) {
145         allowedAmount = lockedAmount.mul(55).div(100);
146       }
147       require(
148         balanceOfParticipant.sub(_amount) >= lockedAmount.sub(allowedAmount),
149         "Must maintain correct % of PVC during lockup periods"
150       );
151     }
152   }
153 
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _amount The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _amount) public returns (bool success) {
160     require(_to != msg.sender, "Cannot transfer to self");
161     require(_to != address(this), "Cannot transfer to Contract");
162     require(_to != address(0), "Cannot transfer to 0x0");
163     require(
164       balances[msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to],
165       "Cannot transfer (Not enough balance)"
166     );
167 
168     requireWithinLockupRange(msg.sender, _amount);
169 
170     // SafeMath.sub will throw if there is not enough balance.
171     balances[msg.sender] = balances[msg.sender].sub(_amount);
172     balances[_to] = balances[_to].add(_amount);
173     emit Transfer(msg.sender, _to, _amount);
174     return true;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _owner The address to query the the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address _owner) public view returns (uint256 balance) {
183     return balances[_owner];
184   }
185 
186 }
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198   /**
199   * @dev Transfer tokens from one address to another
200   * @param _from address The address which you want to send tokens from
201   * @param _to address The address which you want to transfer to
202   * @param _amount uint256 the amount of tokens to be transferred
203   */
204   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
205     require(_from != msg.sender, "Cannot transfer from self, use transfer function instead");
206     require(_from != address(this) && _to != address(this), "Cannot transfer from or to Contract");
207     require(_to != address(0), "Cannot transfer to 0x0");
208     require(balances[_from] >= _amount, "Not enough balance to transfer from");
209     require(allowed[_from][msg.sender] >= _amount, "Not enough allowance to transfer from");
210     require(_amount > 0 && balances[_to].add(_amount) > balances[_to], "Amount must be > 0 to transfer from");
211 
212     requireWithinLockupRange(_from, _amount);
213 
214     balances[_from] = balances[_from].sub(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
217     emit Transfer(_from, _to, _amount);
218     return true;
219   }
220 
221   /**
222   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223   *
224   * Beware that changing an allowance with this method brings the risk that someone may use both the old
225   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228   * @param _spender The address which will spend the funds.
229   * @param _amount The amount of tokens to be spent.
230   */
231   function approve(address _spender, uint256 _amount) public returns (bool success) {
232     require(_spender != msg.sender, "Cannot approve an allowance to self");
233     require(_spender != address(this), "Cannot approve contract an allowance");
234     require(_spender != address(0), "Cannot approve 0x0 an allowance");
235     allowed[msg.sender][_spender] = _amount;
236     emit Approval(msg.sender, _spender, _amount);
237     return true;
238   }
239 
240   /**
241   * @dev Function to check the amount of tokens that an owner allowed to a spender.
242   * @param _owner address The address which owns the funds.
243   * @param _spender address The address which will spend the funds.
244   * @return A uint256 specifying the amount of tokens still available for the spender.
245   */
246   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
247     return allowed[_owner][_spender];
248   }
249 
250 }
251 
252 /**
253  * @title Burnable Token
254  * @dev Token that can be irreversibly burned (destroyed).
255  */
256 contract BurnableToken is StandardToken, Ownable {
257 
258   event Burn(address indexed burner, uint256 value);
259 
260   /**
261     * @dev Burns a specific amount of tokens.
262     * @param _value The amount of token to be burned.
263     */
264   function burn(uint256 _value) public onlyOwner {
265     require(_value <= balances[msg.sender], "Not enough balance to burn");
266     // no need to require value <= totalSupply, since that would imply the
267     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
268 
269     balances[msg.sender] = balances[msg.sender].sub(_value);
270     totalSupply = totalSupply.sub(_value);
271     emit Burn(msg.sender, _value);
272   }
273 
274 }
275 
276 /**
277  * @title PVC Token
278  * @dev Token representing PVC.
279  */
280 contract PryvateCoin is BurnableToken {
281 
282   string public name;
283   string public symbol;
284   uint8 public decimals = 18;
285   
286   /**
287   * @dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
288   */
289   function() external payable {
290     revert("Cannot send Ether to this contract");
291   }
292     
293   /**
294   * @dev Constructor function to initialize the initial supply of token to the creator of the contract
295   */
296   constructor(address wallet) public {
297     owner = wallet;
298     totalSupply = uint(50000000).mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
299     name = "PryvateCoin";
300     symbol = "PVC";
301     balances[wallet] = totalSupply;
302     
303     //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
304     emit Transfer(address(0), msg.sender, totalSupply);
305   }
306     
307   /**
308   * @dev helper method to get token details, name, symbol and totalSupply in one go
309   */
310   function getTokenDetail() public view returns (string memory, string memory, uint256) {
311     return (name, symbol, totalSupply);
312   }
313 
314   function vest(address[] memory _owners, uint[] memory _amounts) public onlyOwner {
315     require(_owners.length == _amounts.length, "Length of addresses & token amounts are not the same");
316     for (uint i = 0; i < _owners.length; i++) {
317       _amounts[i] = _amounts[i].mul(10 ** 18);
318       require(_owners[i] != address(0), "Vesting funds cannot be sent to 0x0");
319       require(_amounts[i] > 0, "Amount must be > 0");
320       require(balances[owner] > _amounts[i], "Not enough balance to vest");
321       require(balances[_owners[i]].add(_amounts[i]) > balances[_owners[i]], "Internal vesting error");
322 
323       // SafeMath.sub will throw if there is not enough balance.
324       balances[owner] = balances[owner].sub(_amounts[i]);
325       balances[_owners[i]] = balances[_owners[i]].add(_amounts[i]);
326       emit Transfer(owner, _owners[i], _amounts[i]);
327       lockup = Lockup({ lockupAmount: _amounts[i] });
328       lockupParticipants[_owners[i]] = lockup;
329     }
330   }
331 
332   function initiateLockup() public onlyOwner {
333     uint256 currentTime = now;
334     lockupIsActive = true;
335     lockupStartTime = currentTime;
336     emit LockupStarted(currentTime);
337   }
338 
339   function lockupActive() public view returns (bool) {
340     return lockupIsActive;
341   }
342 
343   function lockupAmountOf(address _owner) public view returns (uint256) {
344     return lockupParticipants[_owner].lockupAmount;
345   }
346 
347 }