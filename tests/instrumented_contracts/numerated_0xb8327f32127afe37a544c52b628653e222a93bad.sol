1 pragma solidity ^0.4.18;
2 
3 /// @title SafeMath library
4 library SafeMath {
5 
6   function mul(uint a, uint b) internal constant returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint a, uint b) internal constant returns (uint) {
13     uint c = a / b;
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal constant returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal constant returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 /// @title Roles contract
31 contract Roles {
32   
33   /// Address of owner - All privileges
34   address public owner;
35 
36   /// Global operator address
37   address public globalOperator;
38 
39   /// Crowdsale address
40   address public crowdsale;
41   
42   function Roles() public {
43     owner = msg.sender;
44     /// Initially set to 0x0
45     globalOperator = address(0); 
46     /// Initially set to 0x0    
47     crowdsale = address(0); 
48   }
49 
50   // modifier to enforce only owner function access
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   // modifier to enforce only global operator function access
57   modifier onlyGlobalOperator() {
58     require(msg.sender == globalOperator);
59     _;
60   }
61 
62   // modifier to enforce any of 3 specified roles to access function
63   modifier anyRole() {
64     require(msg.sender == owner || msg.sender == globalOperator || msg.sender == crowdsale);
65     _;
66   }
67 
68   /// @dev Change the owner
69   /// @param newOwner Address of the new owner
70   function changeOwner(address newOwner) onlyOwner public {
71     require(newOwner != address(0));
72     OwnerChanged(owner, newOwner);
73     owner = newOwner;
74   }
75 
76   /// @dev Change global operator - initially set to 0
77   /// @param newGlobalOperator Address of the new global operator
78   function changeGlobalOperator(address newGlobalOperator) onlyOwner public {
79     require(newGlobalOperator != address(0));
80     GlobalOperatorChanged(globalOperator, newGlobalOperator);
81     globalOperator = newGlobalOperator;
82   }
83 
84   /// @dev Change crowdsale address - initially set to 0
85   /// @param newCrowdsale Address of crowdsale contract
86   function changeCrowdsale(address newCrowdsale) onlyOwner public {
87     require(newCrowdsale != address(0));
88     CrowdsaleChanged(crowdsale, newCrowdsale);
89     crowdsale = newCrowdsale;
90   }
91 
92   /// Events
93   event OwnerChanged(address indexed _previousOwner, address indexed _newOwner);
94   event GlobalOperatorChanged(address indexed _previousGlobalOperator, address indexed _newGlobalOperator);
95   event CrowdsaleChanged(address indexed _previousCrowdsale, address indexed _newCrowdsale);
96 
97 }
98 
99 /// @title ERC20 contract
100 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
101 contract ERC20 {
102   uint public totalSupply;
103   function balanceOf(address who) public constant returns (uint);
104   function transfer(address to, uint value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint value);
106   
107   function allowance(address owner, address spender) public constant returns (uint);
108   function transferFrom(address from, address to, uint value) public returns (bool);
109   function approve(address spender, uint value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint value);
111 }
112 
113 /// @title ExtendedToken contract
114 contract ExtendedToken is ERC20, Roles {
115   using SafeMath for uint;
116 
117   /// Max amount of minted tokens (6 billion tokens)
118   uint256 public constant MINT_CAP = 6 * 10**27;
119 
120   /// Minimum amount to lock (100 000 tokens)
121   uint256 public constant MINIMUM_LOCK_AMOUNT = 100000 * 10**18;
122 
123   /// Structure that describes locking of tokens
124   struct Locked {
125       //// Amount of tokens locked
126       uint256 lockedAmount; 
127       /// Time when tokens were last locked
128       uint256 lastUpdated; 
129       /// Time when bonus was last claimed
130       uint256 lastClaimed; 
131   }
132   
133   /// Used to pause the transfer
134   bool public transferPaused = false;
135 
136   /// Mapping for balances
137   mapping (address => uint) public balances;
138   /// Mapping for locked amounts
139   mapping (address => Locked) public locked;
140   /// Mapping for allowance
141   mapping (address => mapping (address => uint)) internal allowed;
142 
143   /// @dev Pause token transfer
144   function pause() public onlyOwner {
145       transferPaused = true;
146       Pause();
147   }
148 
149   /// @dev Unpause token transfer
150   function unpause() public onlyOwner {
151       transferPaused = false;
152       Unpause();
153   }
154 
155   /// @dev Mint new tokens. Owner, Global operator and Crowdsale can mint new tokens and update totalSupply
156   /// @param _to Address where the tokens will be minted
157   /// @param _amount Amount of tokens to be minted
158   /// @return True if successfully minted
159   function mint(address _to, uint _amount) public anyRole returns (bool) {
160       _mint(_to, _amount);
161       Mint(_to, _amount);
162       return true;
163   }
164   
165   /// @dev Used by mint function
166   function _mint(address _to, uint _amount) internal returns (bool) {
167       require(_to != address(0));
168 	    require(totalSupply.add(_amount) <= MINT_CAP);
169       totalSupply = totalSupply.add(_amount);
170       balances[_to] = balances[_to].add(_amount);
171       return true;
172   }
173 
174   /// @dev Burns the amount of tokens. Tokens can be only burned from Global operator
175   /// @param _amount Amount of tokens to be burned
176   /// @return True if successfully burned
177   function burn(uint _amount) public onlyGlobalOperator returns (bool) {
178 	    require(balances[msg.sender] >= _amount);
179 	    uint256 newBalance = balances[msg.sender].sub(_amount);      
180       balances[msg.sender] = newBalance;
181       totalSupply = totalSupply.sub(_amount);
182       Burn(msg.sender, _amount);
183       return true;
184   }
185 
186   /// @dev Checks the amount of locked tokens
187   /// @param _from Address that we wish to check the locked amount
188   /// @return Number of locked tokens
189   function lockedAmount(address _from) public constant returns (uint256) {
190       return locked[_from].lockedAmount;
191   }
192 
193   // token lock
194   /// @dev Locking tokens
195   /// @param _amount Amount of tokens to be locked
196   /// @return True if successfully locked
197   function lock(uint _amount) public returns (bool) {
198       require(_amount >= MINIMUM_LOCK_AMOUNT);
199       uint newLockedAmount = locked[msg.sender].lockedAmount.add(_amount);
200       require(balances[msg.sender] >= newLockedAmount);
201       _checkLock(msg.sender);
202       locked[msg.sender].lockedAmount = newLockedAmount;
203       locked[msg.sender].lastUpdated = now;
204       Lock(msg.sender, _amount);
205       return true;
206   }
207 
208   /// @dev Used by lock, claimBonus and unlock functions
209   function _checkLock(address _from) internal returns (bool) {
210     if (locked[_from].lockedAmount >= MINIMUM_LOCK_AMOUNT) {
211       return _mintBonus(_from, locked[_from].lockedAmount);
212     }
213     return false;
214   }
215 
216   /// @dev Used by lock and unlock functions
217   function _mintBonus(address _from, uint256 _amount) internal returns (bool) {
218       uint referentTime = max(locked[_from].lastUpdated, locked[_from].lastClaimed);
219       uint timeDifference = now.sub(referentTime);
220       uint amountTemp = (_amount.mul(timeDifference)).div(30 days); 
221       uint mintableAmount = amountTemp.div(100);
222 
223       locked[_from].lastClaimed = now;
224       _mint(_from, mintableAmount);
225       LockClaimed(_from, mintableAmount);
226       return true;
227   }
228 
229   /// @dev Claim bonus from locked amount
230   /// @return True if successful
231   function claimBonus() public returns (bool) {
232       require(msg.sender != address(0));
233       return _checkLock(msg.sender);
234   }
235 
236   /// @dev Unlocking the locked amount of tokens
237   /// @param _amount Amount of tokens to be unlocked
238   /// @return True if successful
239   function unlock(uint _amount) public returns (bool) {
240       require(msg.sender != address(0));
241       require(locked[msg.sender].lockedAmount >= _amount);
242       uint newLockedAmount = locked[msg.sender].lockedAmount.sub(_amount);
243       if (newLockedAmount < MINIMUM_LOCK_AMOUNT) {
244         Unlock(msg.sender, locked[msg.sender].lockedAmount);
245         _checkLock(msg.sender);
246         locked[msg.sender].lockedAmount = 0;
247       } else {
248         locked[msg.sender].lockedAmount = newLockedAmount;
249         Unlock(msg.sender, _amount);
250         _mintBonus(msg.sender, _amount);
251       }
252       return true;
253   }
254 
255   /// @dev Used by transfer function
256   function _transfer(address _from, address _to, uint _value) internal {
257     require(!transferPaused);
258     require(_to != address(0));
259     require(balances[_from] >= _value.add(locked[_from].lockedAmount));
260     balances[_from] = balances[_from].sub(_value);
261     balances[_to] = balances[_to].add(_value);
262     Transfer(_from, _to, _value);
263   }
264   
265   /// @dev Transfer tokens
266   /// @param _to Address to receive the tokens
267   /// @param _value Amount of tokens to be sent
268   /// @return True if successful
269   function transfer(address _to, uint _value) public returns (bool) {
270     _transfer(msg.sender, _to, _value);
271     return true;
272   }
273   
274   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
275     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276     _transfer(_from, _to, _value);
277     return true;
278   }
279 
280   /// @dev Check balance of an address
281   /// @param _owner Address to be checked
282   /// @return Number of tokens
283   function balanceOf(address _owner) public constant returns (uint balance) {
284     return balances[_owner];
285   }
286 
287   function approve(address _spender, uint _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
294     return allowed[_owner][_spender];
295   }
296 
297   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
298     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
299     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314   /// @dev Get max number
315   /// @param a First number
316   /// @param b Second number
317   /// @return The bigger one :)
318   function max(uint a, uint b) pure internal returns(uint) {
319     return (a > b) ? a : b;
320   }
321 
322   /// @dev Don't accept ether
323   function () public payable {
324     revert();
325   }
326 
327   /// @dev Claim tokens that have been sent to contract mistakenly
328   /// @param _token Token address that we want to claim
329   function claimTokens(address _token) public onlyOwner {
330     if (_token == address(0)) {
331          owner.transfer(this.balance);
332          return;
333     }
334 
335     ERC20 token = ERC20(_token);
336     uint balance = token.balanceOf(this);
337     token.transfer(owner, balance);
338     ClaimedTokens(_token, owner, balance);
339   }
340 
341   /// Events
342   event Mint(address _to, uint _amount);
343   event Burn(address _from, uint _amount);
344   event Lock(address _from, uint _amount);
345   event LockClaimed(address _from, uint _amount);
346   event Unlock(address _from, uint _amount);
347   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
348   event Pause();
349   event Unpause();
350 
351 }
352 
353 /// @title Wizzle Infinity Token contract
354 contract WizzleInfinityToken is ExtendedToken {
355     string public constant name = "Wizzle Infinity Token";
356     string public constant symbol = "WZI";
357     uint8 public constant decimals = 18;
358     string public constant version = "v1";
359 
360     function WizzleInfinityToken() public { 
361       totalSupply = 0;
362     }
363 
364 }