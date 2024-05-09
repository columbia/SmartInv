1 pragma solidity ^0.4.11;
2 
3 // See the Github at github.com/airswap/contracts
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 /**
49  * @title Pausable
50  * @dev Base contract which allows children to implement an emergency stop mechanism.
51  */
52 contract Pausable is Ownable {
53   event Pause();
54   event Unpause();
55 
56   bool public paused = false;
57 
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is not paused.
61    */
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is paused.
69    */
70   modifier whenPaused() {
71     require(paused);
72     _;
73   }
74 
75   /**
76    * @dev called by the owner to pause, triggers stopped state
77    */
78   function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     Pause();
81   }
82 
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86   function unpause() onlyOwner whenPaused public {
87     paused = false;
88     Unpause();
89   }
90 }
91 
92 
93 contract Token {
94     /* This is a slight change to the ERC20 base standard.
95     function totalSupply() constant returns (uint256 supply);
96     is replaced with:
97     uint256 public totalSupply;
98     This automatically creates a getter function for the totalSupply.
99     This is moved to the base contract since public getter functions are not
100     currently recognised as an implementation of the matching abstract
101     function by the compiler.
102     */
103     /// total amount of tokens
104     uint256 public totalSupply;
105 
106     /// @param _owner The address from which the balance will be retrieved
107     /// @return The balance
108     function balanceOf(address _owner) constant returns (uint256 balance);
109 
110     /// @notice send `_value` token to `_to` from `msg.sender`
111     /// @param _to The address of the recipient
112     /// @param _value The amount of token to be transferred
113     /// @return Whether the transfer was successful or not
114     function transfer(address _to, uint256 _value) returns (bool success);
115 
116     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
117     /// @param _from The address of the sender
118     /// @param _to The address of the recipient
119     /// @param _value The amount of token to be transferred
120     /// @return Whether the transfer was successful or not
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
122 
123     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
124     /// @param _spender The address of the account able to transfer the tokens
125     /// @param _value The amount of tokens to be approved for transfer
126     /// @return Whether the approval was successful or not
127     function approve(address _spender, uint256 _value) returns (bool success);
128 
129     /// @param _owner The address of the account owning tokens
130     /// @param _spender The address of the account able to transfer the tokens
131     /// @return Amount of remaining tokens allowed to spent
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
133 
134     event Transfer(address indexed _from, address indexed _to, uint256 _value);
135     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
136 }
137 
138 
139 contract StandardToken is Token {
140 
141     function transfer(address _to, uint256 _value) returns (bool success) {
142         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
143         balances[msg.sender] -= _value;
144         balances[_to] += _value;
145         Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
150         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
151         balances[_to] += _value;
152         balances[_from] -= _value;
153         allowed[_from][msg.sender] -= _value;
154         Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     function balanceOf(address _owner) constant returns (uint256 balance) {
159         return balances[_owner];
160     }
161 
162     function approve(address _spender, uint256 _value) returns (bool success) {
163         allowed[msg.sender][_spender] = _value;
164         Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
169       return allowed[_owner][_spender];
170     }
171 
172     mapping (address => uint256) public balances; // *added public
173     mapping (address => mapping (address => uint256)) public allowed; // *added public
174 }
175 
176 
177 
178 
179 /** @title The AirSwap Token
180   * An ERC20-compliant token that is only transferable after a
181   * specified time. Holders also have the ability to lock an amount of tokens
182   * for a period of time for applications that reference this locked amount
183   * for example for licensing features.
184   */
185 contract BQCCToken is StandardToken, Pausable {
186 
187     string public constant name = "BQCC Token";
188     string public constant symbol = "BQCC";
189     uint8 public constant decimals = 6;
190     uint256 public constant totalSupply = 1000000000000000;
191 
192     // The time after which AirSwap tokens become transferable.
193     // Current value is October 17, 2019 4:11:18 Eastern Time.
194     // 可转账日期
195     uint256 becomesTransferable = 1555496448;
196 
197     // The time that tokens are to be locked before becoming unlockable.
198     // Current value is 180 days.
199     uint256 lockingPeriod = 15552000;
200 
201     // Prevents premature execution.
202     // 当前时间大于规定时间可执行
203     modifier onlyAfter(uint256 _time) {
204         require(now >= _time);
205         _;
206     }
207 
208     // Prevent premature execution for anyone but the owner.
209     // 防止除了owner的人过早执行
210     modifier onlyAfterOrOwner(uint256 _time, address _from) {
211         if (_from != owner) {
212             require(now >= _time);
213         }
214         _;
215     }
216 
217     // Holds the amount and date of a given balance lock.
218     struct BalanceLock {
219         uint256 amount;
220         uint256 unlockDate;
221     }
222 
223     // A mapping of balance lock to a given address.
224     mapping (address => BalanceLock) public balanceLocks;
225 
226     // An event to notify that _owner has locked a balance.
227     event BalanceLocked(address indexed _owner, uint256 _oldLockedAmount,
228     uint256 _newLockedAmount, uint256 _expiry);
229 
230     /** @dev Constructor for the contract.
231       */
232     function BQCCToken()
233         Pausable() {
234         balances[msg.sender] = totalSupply;
235         Transfer(0x0, msg.sender, totalSupply);
236     }
237 
238     /** @dev Sets a token balance to be locked by the sender, on the condition
239       * that the amount is equal or greater than the previous amount, or if the
240       * previous lock time has expired.
241       * @param _value The amount be locked.
242       */
243       //设置锁仓
244     function lockBalance(address addr, uint256 _value) onlyOwner {
245 
246         // Check if the lock on previously locked tokens is still active.
247         if (balanceLocks[addr].unlockDate > now) { // 未到可转账日期
248             // Only allow confirming the lock or adding to it.
249             require(_value >= balanceLocks[addr].amount);
250         }
251         // Ensure that no more than the balance can be locked.
252         require(balances[addr] >= _value);
253 
254         // Lock tokens and notify.
255         uint256 _expiry = now + lockingPeriod;
256         BalanceLocked(addr, balanceLocks[addr].amount, _value, _expiry);
257         balanceLocks[addr] = BalanceLock(_value, _expiry);
258     }
259 
260     /** @dev Returns the balance that a given address has available for transfer.
261       * @param _owner The address of the token owner.
262       */
263       // 返回用户当前可用余额
264     function availableBalance(address _owner) constant returns(uint256) {
265         if (balanceLocks[_owner].unlockDate < now) {
266             return balances[_owner];
267         } else {
268             assert(balances[_owner] >= balanceLocks[_owner].amount);
269             return balances[_owner] - balanceLocks[_owner].amount;
270         }
271     }
272 
273     /** @dev Send `_value` token to `_to` from `msg.sender`, on the condition
274       * that there are enough unlocked tokens in the `msg.sender` account.
275       * @param _to The address of the recipient.
276       * @param _value The amount of token to be transferred.
277       * @return Whether the transfer was successful or not.
278       */
279       // 
280     function transfer(address _to, uint256 _value)
281         onlyAfter(becomesTransferable) whenNotPaused
282         returns (bool success) {
283         require(availableBalance(msg.sender) >= _value);
284         return super.transfer(_to, _value);
285     }
286 
287     /** @dev Send `_value` token to `_to` from `_from` on the condition
288       * that there are enough unlocked tokens in the `_from` account.
289       * @param _from The address of the sender.
290       * @param _to The address of the recipient.
291       * @param _value The amount of token to be transferred.
292       * @return Whether the transfer was successful or not.
293       */
294     function transferFrom(address _from, address _to, uint256 _value)
295         onlyAfterOrOwner(becomesTransferable, _from) whenNotPaused
296         returns (bool success) {
297         require(availableBalance(_from) >= _value);
298         return super.transferFrom(_from, _to, _value);
299     }
300 }