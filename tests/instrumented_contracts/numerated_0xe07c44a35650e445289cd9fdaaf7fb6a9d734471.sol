1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function allowance(address owner, address spender) public view returns (uint256);
8   function transferFrom(address from, address to, uint256 value) public returns (bool);
9   function approve(address spender, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 contract AElfToken is ERC20, Ownable {
78   using SafeMath for uint256;
79 
80   
81   // the controller of minting and destroying tokens
82   address public aelfDevMultisig = 0x64ABa00510FEc9a0FE4B236648879f35030B7D9b;
83   // the controller of approving of minting and withdraw tokens
84   address public aelfCommunityMultisig = 0x13828Fa672c52226071F27ea1869463bDEf2ecCB;
85 
86   struct TokensWithLock {
87     uint256 value;
88     uint256 blockNumber;
89   }
90   // Balances for each account
91   mapping(address => uint256) balances;
92   // Tokens with time lock
93   // Only when the tokens' blockNumber is less than current block number,
94   // can the tokens be minted to the owner
95   mapping(address => TokensWithLock) lockTokens;
96   
97   // Owner of account approves the transfer of an amount to another account
98   mapping(address => mapping (address => uint256)) allowed;
99   // Token Cap
100   uint256 public totalSupplyCap = 1e27;
101   // Token Info
102   string public name = "\xC3\x86\x6C\x66\x20\x54\x6F\x6B\x65\x6E";
103   string public symbol = "ELFTEST2";
104   uint8 public decimals = 18;
105 
106   bool public mintingFinished = false;
107   // the block number when deploy
108   uint256 public deployBlockNumber = getCurrentBlockNumber();
109   // the min threshold of lock time
110   uint256 public constant TIMETHRESHOLD = 7200;
111   // the time when mintTokensWithinTime can be called
112   uint256 public constant MINTTIME = 7200;
113   // the lock time of minted tokens
114   uint256 public durationOfLock = 7200;
115 
116 
117   modifier canMint() {
118     require(!mintingFinished);
119     _;
120   }
121 
122   modifier only(address _address) {
123     require(msg.sender == _address);
124     _;
125   }
126 
127   modifier nonZeroAddress(address _address) {
128     require(_address != address(0));
129     _;
130   }
131 
132   event SetDurationOfLock(address indexed _caller);
133   event ApproveMintTokens(address indexed _owner, uint256 _amount);
134   event WithdrawMintTokens(address indexed _owner, uint256 _amount);
135   event MintTokens(address indexed _owner, uint256 _amount);
136   event BurnTokens(address indexed _owner, uint256 _amount);
137   event MintFinished(address indexed _caller);
138 
139   /**
140    * @dev transfer token for a specified address
141    * @param _to The address to transfer to.
142    * @param _value The amount to be transferred.
143    */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Gets the balance of the specified address.
157    * @param _owner The address to query the the balance of.
158    * @return An uint256 representing the amount owned by the passed address.
159    */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174 
175     balances[_from] = balances[_from].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178     Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184    *
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(address _owner, address _spender) public view returns (uint256) {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    */
214   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
221     uint256 oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230   /**
231    * @dev Set the aelfMultisig
232    * @param _aelfDevMultisig The new aelfMultisig
233    */
234   function setAElfMultisig(address _aelfDevMultisig) only(aelfDevMultisig) nonZeroAddress(_aelfDevMultisig) public {
235     aelfDevMultisig = _aelfDevMultisig;
236   }
237   /**
238    * @dev Set the aelfCommunityMultisig
239    * @param _aelfCommunityMultisig The new aelfCommunityMultisig
240    */
241   function setAElfCommunityMultisig(address _aelfCommunityMultisig) only(aelfCommunityMultisig) nonZeroAddress(_aelfCommunityMultisig) public {
242     aelfCommunityMultisig = _aelfCommunityMultisig;
243   }
244   /**
245    * @dev Set the duration of lock of tokens approved of minting
246    * @param _durationOfLock the new duration of lock
247    */
248   function setDurationOfLock(uint256 _durationOfLock) canMint only(aelfCommunityMultisig) public {
249     require(_durationOfLock >= TIMETHRESHOLD);
250     durationOfLock = _durationOfLock;
251     SetDurationOfLock(msg.sender);
252   }
253   /**
254    * @dev Get the quantity of locked tokens
255    * @param _owner The address of locked tokens
256    * @return the quantity and the lock time of locked tokens
257    */
258    function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {
259      return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);
260    }
261 
262   /**
263    * @dev Approve of minting `_amount` tokens that are assigned to `_owner`
264    * @param _owner The address that will be assigned the new tokens
265    * @param _amount The quantity of tokens approved of mintting
266    * @return True if the tokens are approved of mintting correctly
267    */
268   function approveMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(aelfCommunityMultisig) public returns (bool) {
269     require(_amount > 0);
270     uint256 previousLockTokens = lockTokens[_owner].value;
271     require(previousLockTokens + _amount >= previousLockTokens);
272     uint256 curTotalSupply = totalSupply;
273     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
274     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
275     uint256 previousBalanceTo = balanceOf(_owner);
276     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
277     lockTokens[_owner].value = previousLockTokens.add(_amount);
278     uint256 curBlockNumber = getCurrentBlockNumber();
279     lockTokens[_owner].blockNumber = curBlockNumber.add(durationOfLock);
280     ApproveMintTokens(_owner, _amount);
281     return true;
282   }
283   /**
284    * @dev Withdraw approval of minting `_amount` tokens that are assigned to `_owner`
285    * @param _owner The address that will be withdrawn the tokens
286    * @param _amount The quantity of tokens withdrawn approval of mintting
287    * @return True if the tokens are withdrawn correctly
288    */
289   function withdrawMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(aelfCommunityMultisig) public returns (bool) {
290     require(_amount > 0);
291     uint256 previousLockTokens = lockTokens[_owner].value;
292     require(previousLockTokens - _amount >= 0);
293     lockTokens[_owner].value = previousLockTokens.sub(_amount);
294     if (previousLockTokens - _amount == 0) {
295       lockTokens[_owner].blockNumber = 0;
296     }
297     WithdrawMintTokens(_owner, _amount);
298     return true;
299   }
300   /**
301    * @dev Mints `_amount` tokens that are assigned to `_owner`
302    * @param _owner The address that will be assigned the new tokens
303    * @return True if the tokens are minted correctly
304    */
305   function mintTokens(address _owner) canMint only(aelfDevMultisig) nonZeroAddress(_owner) public returns (bool) {
306     require(lockTokens[_owner].blockNumber <= getCurrentBlockNumber());
307     uint256 _amount = lockTokens[_owner].value;
308     uint256 curTotalSupply = totalSupply;
309     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
310     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
311     uint256 previousBalanceTo = balanceOf(_owner);
312     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
313     
314     totalSupply = curTotalSupply.add(_amount);
315     balances[_owner] = previousBalanceTo.add(_amount);
316     lockTokens[_owner].value = 0;
317     lockTokens[_owner].blockNumber = 0;
318     MintTokens(_owner, _amount);
319     Transfer(0, _owner, _amount);
320     return true;
321   }
322   /**
323    * @dev Mints `_amount` tokens that are assigned to `_owner` within one day after deployment
324    * the tokens minted will be added to balance immediately
325    * @param _owner The address that will be assigned the new tokens
326    * @param _amount The quantity of tokens withdrawn minted
327    * @return True if the tokens are minted correctly
328    */
329   function mintTokensWithinTime(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(aelfDevMultisig) public returns (bool) {
330     require(_amount > 0);
331     require(getCurrentBlockNumber() < (deployBlockNumber + MINTTIME));
332     uint256 curTotalSupply = totalSupply;
333     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
334     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
335     uint256 previousBalanceTo = balanceOf(_owner);
336     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
337     
338     totalSupply = curTotalSupply.add(_amount);
339     balances[_owner] = previousBalanceTo.add(_amount);
340     MintTokens(_owner, _amount);
341     Transfer(0, _owner, _amount);
342     return true;
343   }
344 
345   /**
346    * @dev Burns `_amount` tokens from `_owner`
347    * @param _amount The quantity of tokens being burned
348    * @return True if the tokens are burned correctly
349    */
350   function burnTokens(uint256 _amount) public returns (bool) {
351     require(_amount > 0);
352     uint256 curTotalSupply = totalSupply;
353     require(curTotalSupply >= _amount);
354     uint256 previousBalanceTo = balanceOf(msg.sender);
355     require(previousBalanceTo >= _amount);
356     totalSupply = curTotalSupply.sub(_amount);
357     balances[msg.sender] = previousBalanceTo.sub(_amount);
358     BurnTokens(msg.sender, _amount);
359     Transfer(msg.sender, 0, _amount);
360     return true;
361   }
362   /**
363    * @dev Function to stop minting new tokens.
364    * @return True if the operation was successful.
365    */
366   function finishMinting() only(aelfDevMultisig) canMint public returns (bool) {
367     mintingFinished = true;
368     MintFinished(msg.sender);
369     return true;
370   }
371 
372   function getCurrentBlockNumber() private view returns (uint256) {
373     return block.number;
374   }
375 }