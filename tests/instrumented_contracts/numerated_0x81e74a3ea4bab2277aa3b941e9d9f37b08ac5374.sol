1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/20
39  */
40 contract ERC20 {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract ifoodToken is ERC20 {
52   using SafeMath for uint256;
53   
54   // the controller of minting
55   address public ifoodDev = 0x4E471f031D03E5856125993dc3D59520229141Ce;
56   // the controller of approving of minting and withdraw tokens
57   address public ifoodCommunity = 0x0d72e931932356FcCf8CFF3f83390e24BE72771d;
58 
59   struct TokensWithLock {
60     uint256 value;
61     uint256 blockNumber;
62   }
63   // Balances for each account
64   mapping(address => uint256) balances;
65   // Tokens with time lock
66   // Only when the tokens' blockNumber is less than current block number,
67   // can the tokens be minted to the owner
68   mapping(address => TokensWithLock) lockTokens;
69   // Owner of account approves the transfer of an amount to another account
70   mapping(address => mapping (address => uint256)) allowed;
71  
72   // Token Info
73   string public name = "Ifoods Token";
74   string public symbol = "IFOOD";
75   uint8 public decimals = 18;
76   
77   // Token Cap
78   uint256 public totalSupplyCap = 10**10 * 10**uint256(decimals);
79   // True if mintingFinished
80   bool public mintingFinished = false;
81   // The block number when deploy
82   uint256 public deployBlockNumber = getCurrentBlockNumber();
83   // The min threshold of lock time
84   uint256 public constant TIMETHRESHOLD = 7200;
85   // The lock time of minted tokens
86   uint256 public durationOfLock = 7200;
87   // True if transfers are allowed
88   bool public transferable = false;
89   // True if the transferable can be change
90   bool public canSetTransferable = true;
91 
92   modifier canMint() {
93     require(!mintingFinished);
94     _;
95   }
96 
97   modifier only(address _address) {
98     require(msg.sender == _address);
99     _;
100   }
101 
102   modifier nonZeroAddress(address _address) {
103     require(_address != address(0));
104     _;
105   }
106 
107   modifier canTransfer() {
108     require(transferable == true);
109     _;
110   }
111 
112   event SetDurationOfLock(address indexed _caller);
113   event ApproveMintTokens(address indexed _owner, uint256 _amount);
114   event WithdrawMintTokens(address indexed _owner, uint256 _amount);
115   event MintTokens(address indexed _owner, uint256 _amount);
116   event BurnTokens(address indexed _owner, uint256 _amount);
117   event MintFinished(address indexed _caller);
118   event SetTransferable(address indexed _address, bool _transferable);
119   event SetifoodDevAddress(address indexed _old, address indexed _new);
120   event SetifoodCommunityAddress(address indexed _old, address indexed _new);
121   event DisableSetTransferable(address indexed _address, bool _canSetTransferable);
122 
123   /**
124    * @dev transfer token for a specified address
125    * @param _to The address to transfer to.
126    * @param _value The amount to be transferred.
127    */
128   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Gets the balance of the specified address.
141    * @param _owner The address to query the the balance of.
142    * @return An uint256 representing the amount owned by the passed address.
143    */
144   function balanceOf(address _owner) public view returns (uint256 balance) {
145     return balances[_owner];
146   }
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   // Allow `_spender` to withdraw from your account, multiple times.
167   function approve(address _spender, uint _value) public returns (bool success) {
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
173         revert();
174     }
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256) {
187     return allowed[_owner][_spender];
188   }
189   
190   /**
191    * @dev Enables token holders to transfer their tokens freely if true
192    * @param _transferable True if transfers are allowed
193    */
194   function setTransferable(bool _transferable) only(ifoodDev) public {
195     require(canSetTransferable == true);
196     transferable = _transferable;
197     SetTransferable(msg.sender, _transferable);
198   }
199 
200   /**
201    * @dev disable the canSetTransferable
202    */
203   function disableSetTransferable() only(ifoodDev) public {
204     transferable = true;
205     canSetTransferable = false;
206     DisableSetTransferable(msg.sender, false);
207   }
208 
209   /**
210    * @dev Set the ifoodDev
211    * @param _ifoodDev The new ifood dev address
212    */
213   function setifoodDevAddress(address _ifoodDev) only(ifoodDev) nonZeroAddress(ifoodDev) public {
214     ifoodDev = _ifoodDev;
215     SetifoodDevAddress(msg.sender, _ifoodDev);
216   }
217 
218   /**
219    * @dev Set the ifoodCommunity
220    * @param _ifoodCommunity The new ifood community address
221    */
222   function setifoodCommunityAddress(address _ifoodCommunity) only(ifoodCommunity) nonZeroAddress(_ifoodCommunity) public {
223     ifoodCommunity = _ifoodCommunity;
224     SetifoodCommunityAddress(msg.sender, _ifoodCommunity);
225   }
226   
227   /**
228    * @dev Set the duration of lock of tokens approved of minting
229    * @param _durationOfLock the new duration of lock
230    */
231   function setDurationOfLock(uint256 _durationOfLock) canMint only(ifoodCommunity) public {
232     require(_durationOfLock >= TIMETHRESHOLD);
233     durationOfLock = _durationOfLock;
234     SetDurationOfLock(msg.sender);
235   }
236   
237   /**
238    * @dev Get the quantity of locked tokens
239    * @param _owner The address of locked tokens
240    * @return the quantity and the lock time of locked tokens
241    */
242    function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {
243      return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);
244    }
245 
246   /**
247    * @dev Approve of minting `_amount` tokens that are assigned to `_owner`
248    * @param _owner The address that will be assigned the new tokens
249    * @param _amount The quantity of tokens approved of mintting
250    * @return True if the tokens are approved of mintting correctly
251    */
252   function approveMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(ifoodCommunity) public returns (bool) {
253     require(_amount > 0);
254     uint256 previousLockTokens = lockTokens[_owner].value;
255     require(previousLockTokens + _amount >= previousLockTokens);
256     uint256 curTotalSupply = totalSupply;
257     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
258     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
259     uint256 previousBalanceTo = balanceOf(_owner);
260     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
261     lockTokens[_owner].value = previousLockTokens.add(_amount);
262     uint256 curBlockNumber = getCurrentBlockNumber();
263     lockTokens[_owner].blockNumber = curBlockNumber.add(durationOfLock);
264     ApproveMintTokens(_owner, _amount);
265     return true;
266   }
267 
268   /**
269    * @dev Withdraw approval of minting `_amount` tokens that are assigned to `_owner`
270    * @param _owner The address that will be withdrawn the tokens
271    * @param _amount The quantity of tokens withdrawn approval of mintting
272    * @return True if the tokens are withdrawn correctly
273    */
274   function withdrawMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(ifoodCommunity) public returns (bool) {
275     require(_amount > 0);
276     uint256 previousLockTokens = lockTokens[_owner].value;
277     require(previousLockTokens - _amount >= 0);
278     lockTokens[_owner].value = previousLockTokens.sub(_amount);
279     if (previousLockTokens - _amount == 0) {
280       lockTokens[_owner].blockNumber = 0;
281     }
282     WithdrawMintTokens(_owner, _amount);
283     return true;
284   }
285   
286   /**
287    * @dev Mints `_amount` tokens that are assigned to `_owner`
288    * @param _owner The address that will be assigned the new tokens
289    * @return True if the tokens are minted correctly
290    */
291   function mintTokens(address _owner) canMint only(ifoodDev) nonZeroAddress(_owner) public returns (bool) {
292     require(lockTokens[_owner].blockNumber <= getCurrentBlockNumber());
293     uint256 _amount = lockTokens[_owner].value;
294     uint256 curTotalSupply = totalSupply;
295     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
296     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
297     uint256 previousBalanceTo = balanceOf(_owner);
298     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
299     
300     totalSupply = curTotalSupply.add(_amount);
301     balances[_owner] = previousBalanceTo.add(_amount);
302     lockTokens[_owner].value = 0;
303     lockTokens[_owner].blockNumber = 0;
304     MintTokens(_owner, _amount);
305     Transfer(0, _owner, _amount);
306     return true;
307   }
308 
309   /**
310    * @dev Transfer tokens to multiple addresses
311    * @param _addresses The addresses that will receieve tokens
312    * @param _amounts The quantity of tokens that will be transferred
313    * @return True if the tokens are transferred correctly
314    */
315   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) canTransfer public returns (bool) {
316     for (uint256 i = 0; i < _addresses.length; i++) {
317       require(_addresses[i] != address(0));
318       require(_amounts[i] <= balances[msg.sender]);
319       require(_amounts[i] > 0);
320 
321       // SafeMath.sub will throw if there is not enough balance.
322       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
323       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
324       Transfer(msg.sender, _addresses[i], _amounts[i]);
325     }
326     return true;
327   }
328 
329   /**
330    * @dev Function to stop minting new tokens.
331    * @return True if the operation was successful.
332    */
333   function finishMinting() only(ifoodDev) canMint public returns (bool) {
334     mintingFinished = true;
335     MintFinished(msg.sender);
336     return true;
337   }
338 
339   function getCurrentBlockNumber() private view returns (uint256) {
340     return block.number;
341   }
342 
343   function () public payable {
344     revert();
345   }
346 
347 }