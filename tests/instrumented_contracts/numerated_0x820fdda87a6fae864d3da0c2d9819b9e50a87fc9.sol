1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 
89 contract Token {
90     /* This is a slight change to the ERC20 base standard.
91     function totalSupply() constant returns (uint256 supply);
92     is replaced with:
93     uint256 public totalSupply;
94     This automatically creates a getter function for the totalSupply.
95     This is moved to the base contract since public getter functions are not
96     currently recognised as an implementation of the matching abstract
97     function by the compiler.
98     */
99     /// total amount of tokens
100     uint256 public totalSupply;
101 
102     /// @param _owner The address from which the balance will be retrieved
103     /// @return The balance
104     function balanceOf(address _owner) constant returns (uint256 balance);
105 
106     /// @notice send `_value` token to `_to` from `msg.sender`
107     /// @param _to The address of the recipient
108     /// @param _value The amount of token to be transferred
109     /// @return Whether the transfer was successful or not
110     function transfer(address _to, uint256 _value) returns (bool success);
111 
112     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
113     /// @param _from The address of the sender
114     /// @param _to The address of the recipient
115     /// @param _value The amount of token to be transferred
116     /// @return Whether the transfer was successful or not
117     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
118 
119     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
120     /// @param _spender The address of the account able to transfer the tokens
121     /// @param _value The amount of tokens to be approved for transfer
122     /// @return Whether the approval was successful or not
123     function approve(address _spender, uint256 _value) returns (bool success);
124 
125     /// @param _owner The address of the account owning tokens
126     /// @param _spender The address of the account able to transfer the tokens
127     /// @return Amount of remaining tokens allowed to spent
128     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
129 
130     event Transfer(address indexed _from, address indexed _to, uint256 _value);
131     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
132 }
133 
134 
135 contract StandardToken is Token {
136 
137     function transfer(address _to, uint256 _value) returns (bool success) {
138         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
139         balances[msg.sender] -= _value;
140         balances[_to] += _value;
141         Transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
146         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
147         balances[_to] += _value;
148         balances[_from] -= _value;
149         allowed[_from][msg.sender] -= _value;
150         Transfer(_from, _to, _value);
151         return true;
152     }
153 
154     function balanceOf(address _owner) constant returns (uint256 balance) {
155         return balances[_owner];
156     }
157 
158     function approve(address _spender, uint256 _value) returns (bool success) {
159         allowed[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
165       return allowed[_owner][_spender];
166     }
167 
168     mapping (address => uint256) public balances; // *added public
169     mapping (address => mapping (address => uint256)) public allowed; // *added public
170 }
171 
172 
173 contract SUNToken is StandardToken, Pausable {
174 
175     string public constant name = "SUN Token";
176     string public constant symbol = "SUNT";
177     uint8 public constant decimals = 6;
178     uint256 public constant totalSupply = 1000000000000000;
179 
180     // Holds the amount and date of a given balance lock.
181     struct BalanceLock {
182         uint256 amount;
183         uint256 unlockDate;
184     }
185 
186     // A mapping of balance lock to a given address.
187     mapping (address => BalanceLock) public balanceLocks;
188 
189     // An event to notify that _owner has locked a balance.
190     event BalanceLocked(address indexed _owner, uint256 _oldLockedAmount,
191     uint256 _newLockedAmount, uint256 _expiry);
192 
193     /** @dev Constructor for the contract.
194       */
195     function SUNToken()
196         Pausable() {
197         balances[msg.sender] = totalSupply;
198         Transfer(0x0, msg.sender, totalSupply);
199     }
200 
201     /** @dev Sets a token balance to be locked by the sender, on the condition
202       * that the amount is equal or greater than the previous amount, or if the
203       * previous lock time has expired.
204       * @param _value The amount be locked.
205       */
206       //设置锁仓
207     function lockBalance(address addr, uint256 _value,uint256 lockingDays) onlyOwner {
208 
209         // Check if the lock on previously locked tokens is still active.
210         if (balanceLocks[addr].unlockDate > now) { // 未到可转账日期
211             // Only allow confirming the lock or adding to it.
212             require(_value >= balanceLocks[addr].amount);
213         }
214         // Ensure that no more than the balance can be locked.
215         require(balances[addr] >= _value);
216         // convert days to seconds
217         uint256 lockingPeriod = lockingDays*24*3600;
218         // Lock tokens and notify.
219         uint256 _expiry = now + lockingPeriod;
220         BalanceLocked(addr, balanceLocks[addr].amount, _value, _expiry);
221         balanceLocks[addr] = BalanceLock(_value, _expiry);
222     }
223 
224     /** @dev Returns the balance that a given address has available for transfer.
225       * @param _owner The address of the token owner.
226       */
227     // 返回用户当前可用余额
228     function availableBalance(address _owner) constant returns(uint256) {
229         if (balanceLocks[_owner].unlockDate < now) {
230             return balances[_owner];
231         } else {
232             assert(balances[_owner] >= balanceLocks[_owner].amount);
233             return balances[_owner] - balanceLocks[_owner].amount;
234         }
235     }
236 
237     /** @dev Send `_value` token to `_to` from `msg.sender`, on the condition
238       * that there are enough unlocked tokens in the `msg.sender` account.
239       * @param _to The address of the recipient.
240       * @param _value The amount of token to be transferred.
241       * @return Whether the transfer was successful or not.
242       */
243       // 
244     function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {
245         require(availableBalance(msg.sender) >= _value);
246         return super.transfer(_to, _value);
247     }
248 
249     /** @dev Send `_value` token to `_to` from `_from` on the condition
250       * that there are enough unlocked tokens in the `_from` account.
251       * @param _from The address of the sender.
252       * @param _to The address of the recipient.
253       * @param _value The amount of token to be transferred.
254       * @return Whether the transfer was successful or not.
255       */
256     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused
257         returns (bool success) {
258         require(availableBalance(_from) >= _value);
259         return super.transferFrom(_from, _to, _value);
260     }
261 }