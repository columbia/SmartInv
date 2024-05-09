1 pragma solidity ^0.5.8;
2 
3 
4 /// @title ERC20 Token Interface
5 /// @author Hoard Team
6 /// @notice See https://github.com/ethereum/EIPs/issues/20
7 contract ERC20Token {
8 
9     // PUBLIC INTERFACE
10 
11     // /// @dev Returns total amount of tokens
12     // /// @notice params -> (uint256 totalSupply)
13     // It's implamented as a variable which doesn't override this method. Commented to prevent compilation error.
14     // function totalSupply    () constant public returns (uint256);
15 
16     /// @dev Returns balance of specified account
17     /// @notice params -> (address _owner)
18     function balanceOf      (address) view public returns (uint256);
19 
20     /// @dev  Transfers tokens from msg.sender to a specified address
21     /// @notice params -> (address _to, uint256 _value)
22     function transfer       (address, uint256) public returns (bool);
23 
24     /// @dev  Allowance mechanism - delegated transfer
25     /// @notice params -> (address _from, address _to, uint256 _value)
26     function transferFrom   (address, address, uint256) public returns (bool);
27 
28     /// @dev  Allowance mechanism - approve delegated transfer
29     /// @notice params -> (address _spender, uint256 _value)
30     function approve        (address, uint256) public returns (bool);
31 
32     /// @dev  Allowance mechanism - set allowance for specified address
33     /// @notice params -> (address _owner, address _spender)
34     function allowance      (address, address) public view returns (uint256);
35 
36 
37     // EVENTS
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42 }
43 
44 
45 /// @title Safe Math
46 /// @author Open Zeppelin
47 /// @notice implementation from - https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
48 library SafeMath {
49   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72   
73   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
74     return a >= b ? a : b;
75   }
76 
77   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
78     return a < b ? a : b;
79   }
80 
81 }
82 
83 
84 
85 /// @title Standard ERC20 compliant token
86 /// @author Hoard Team
87 /// @notice Original taken from https://github.com/ethereum/EIPs/issues/20
88 /// @notice SafeMath used as specified by OpenZeppelin
89 /// @notice Comments and additional approval code from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token
90 contract StandardToken is ERC20Token {
91 
92     using SafeMath for uint256;
93 
94     mapping (address => uint256) balances;
95 
96     mapping (address => mapping (address => uint256)) allowed;
97 
98     uint256 public totalSupply;
99 
100    /// @dev transfer token for a specified address
101    /// @param _to The address to transfer to.
102    /// @param _value The amount to be transferred.
103    function transfer(address _to, uint256 _value) public returns (bool) {
104         balances[msg.sender] = balances[msg.sender].safeSub(_value);
105         balances[_to] = balances[_to].safeAdd(_value);
106 
107         emit Transfer(msg.sender, _to, _value);            
108 
109         return true;
110     }
111 
112     /// @dev Transfer tokens from one address to another
113     /// @param _from address The address which you want to send tokens from
114     /// @param _to address The address which you want to transfer to
115     /// @param _value uint256 the amount of tokens to be transferred
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117         uint256 _allowance = allowed[_from][msg.sender];
118 
119         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120         // require (_value <= _allowance);        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
121 
122         balances[_to] = balances[_to].safeAdd(_value);
123         balances[_from] = balances[_from].safeSub(_value);
124         allowed[_from][msg.sender] = _allowance.safeSub(_value);
125 
126         emit Transfer(_from, _to, _value);
127             
128         return true;
129     }
130 
131     /// @dev Gets the balance of the specified address.
132     /// @param _owner The address to query the the balance of. 
133     /// @return An uint256 representing the amount owned by the passed address.
134     function balanceOf(address _owner) view public returns (uint256) {
135         return balances[_owner];
136     }
137 
138    /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    /// @param _spender The address which will spend the funds.
140    /// @param _value The amount of tokens to be spent.
141    function approve(address _spender, uint256 _value) public returns (bool) {
142         // To change the approve amount you first have to reduce the addresses`
143         //  allowance to zero by calling `approve(_spender, 0)` if it is not
144         //  already 0 to mitigate the race condition described here:
145         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147         
148         allowed[msg.sender][_spender] = _value;
149 
150         emit Approval(msg.sender, _spender, _value);
151 
152         return true;
153     }
154 
155    /// @dev Function to check the amount of tokens that an owner allowed to a spender.
156    /// @param _owner address The address which owns the funds.
157    /// @param _spender address The address which will spend the funds.
158    /// @return A uint256 specifying the amount of tokens still available for the spender.
159    function allowance(address _owner, address _spender) view public returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162 
163     /// @notice approve should be called when allowed[_spender] == 0. To increment
164     /// allowed value it is better to use this function to avoid 2 calls (and wait until 
165     /// the first transaction is mined)
166     function increaseApproval (address _spender, uint256 _addedValue) public returns (bool) {
167         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].safeAdd(_addedValue);
168 
169         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170 
171         return true;
172     }
173 
174     /// @notice approve should be called when allowed[_spender] == 0. To decrement
175     /// allowed value it is better to use this function to avoid 2 calls (and wait until 
176     /// the first transaction is mined)
177     function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool) {
178         uint256 oldValue = allowed[msg.sender][_spender];
179         
180         if (_subtractedValue > oldValue) {
181             allowed[msg.sender][_spender] = 0;
182         } else {
183             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
184         }
185 
186         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187 
188         return true;
189     }
190 
191 }
192 
193 
194 /// @title Migration Agent interface
195 /// @author Hoard Team
196 /// @notice Based on GNT implementation - https://github.com/golemfactory/golem-crowdfunding/blob/master/contracts/Token.sol
197 contract MigrationAgent {
198 
199     /// @dev migrates tokens or other "assets" from one contract to another (not yet specified)
200     /// @notice parameters -> (address _from, uint _value)
201     function migrateFrom(address, uint256) public;
202 }
203 
204 
205 /// @title Mintable token interface
206 /// @author Hoard Team
207 contract Mintable {
208 
209     /// @dev Mint new tokens  
210     /// @notice params -> (address _recipient, uint256 _amount)
211     function mintTokens         (address, uint256) public;
212 }
213 
214 
215 /// @title Migratable entity interface
216 /// @author Hoard Team
217 contract Migratable {
218 
219     /// @dev Migrates tokens for msg.sender  
220     /// @notice params -> (uint256 _value)
221     function migrate            (uint256) public;
222 
223 
224     // EVENTS
225 
226     event Migrate               (address indexed _from, address indexed _to, uint256 _value);
227 }
228 
229 
230 /// @title Standard ERC20 compliant token
231 /// @author Hoard Team
232 contract ExtendedStandardToken is StandardToken, Migratable, Mintable {
233 
234     address public migrationAgent;
235     uint256 public totalMigrated;
236 
237 
238     // MODIFIERS
239 
240     modifier migrationAgentSet {
241         require(migrationAgent != address(0));
242         _;
243     }
244 
245     modifier migrationAgentNotSet {
246         require(migrationAgent == address(0));
247         _;
248     }
249 
250     /// @dev Internal constructor to prevent bare instances of this contract
251     constructor () internal {
252     }
253 
254     // MIGRATION LOGIC
255 
256     /// @dev Migrates tokens for msg.sender and burns them
257     /// @param _value amount of tokens to migrate
258     function migrate            (uint256 _value) public {
259 
260         // Validate input value
261         require(_value > 0);
262     
263         //require(_value <= balances[msg.sender]);
264         //not necessary as safeSub throws in case the above condition does not hold
265     
266         balances[msg.sender] = balances[msg.sender].safeSub(_value);
267         totalSupply = totalSupply.safeSub(_value);
268         totalMigrated = totalMigrated.safeAdd(_value);
269 
270         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
271 
272         emit Migrate(msg.sender, migrationAgent, _value);
273     }
274 
275 
276     // MINTING LOGIC
277 
278     /// @dev Mints additional tokens
279     /// @param _recipient owner of new tokens 
280     /// @param _amount amount of tokens to mint
281     function mintTokens         (address _recipient, uint256 _amount) public {
282         require(_amount > 0);
283 
284         balances[_recipient] = balances[_recipient].safeAdd(_amount);
285         totalSupply = totalSupply.safeAdd(_amount);
286 
287         // Log token creation event
288         emit Transfer(address(0), msg.sender, _amount);
289     }
290 
291 
292     // CONTROL LOGIC
293 
294     /// @dev Sets address of a new migration agent
295     /// @param _address address of new migration agent 
296     function setMigrationAgent  (address _address) public {
297         migrationAgent = _address; 
298     }
299 
300 }
301 
302 
303 
304 /// @title Hoard Token (HRD) - crowdfunding code for Hoard token
305 /// @author Hoard Team
306 /// @notice Based on MLN implementation - https://github.com/melonproject/melon/blob/master/contracts/tokens/MelonToken.sol
307 /// @notice Based on GNT implementation - https://github.com/golemfactory/golem-crowdfunding/blob/master/contracts/Token.sol
308 contract HoardToken is ExtendedStandardToken {
309 
310     // Token description fields
311     string public constant name = "Hoard Token";
312     string public constant symbol = "HRD";
313     uint256 public constant decimals = 18;  // 18 decimal places, the same as ETH
314 
315     // contract supervision variables
316     address public creator;
317     address public hoard;
318     address public migrationMaster;
319 
320 
321     // MODIFIERS
322 
323     modifier onlyCreator {
324         require(msg.sender == creator);
325         _;
326     }
327 
328     modifier onlyHoard {
329         require(msg.sender == hoard);
330         _;
331     }
332 
333     modifier onlyMigrationMaster {
334         require(msg.sender == migrationMaster);
335         _;
336     }
337 
338     // CONSTRUCTION
339 
340     /// @param _hoard Hoard multisig contract
341     /// @param _migrationMaster migration master
342     constructor (address _hoard, address _migrationMaster) public {
343         require(_hoard != address(0));
344         require(_migrationMaster != address(0));
345 
346         creator = msg.sender;
347         hoard = _hoard;
348         migrationMaster = _migrationMaster;
349     }
350 
351 
352     // BASE CLASS IMPLEMENTATION
353 
354     /// @notice ExtendedStandardToken is StandardToken
355     function transfer               (address _to, uint256 _value) public
356         returns (bool) 
357     {
358         return super.transfer(_to, _value);
359     }
360 
361 
362     /// @notice ExtendedStandardToken is StandardToken
363     function transferFrom           (address _from, address _to, uint256 _value) public 
364         returns (bool)
365     {
366         return super.transferFrom(_from, _to, _value);
367     }
368 
369 
370     /// @notice ExtendedStandardToken is Migratable
371     function migrate                (uint256 _value) public migrationAgentSet {
372         super.migrate(_value);    
373     }
374 
375     /// @notice ExtendedStandardToken
376     function setMigrationAgent      (address _address) public onlyMigrationMaster migrationAgentNotSet {
377         require(_address != address(0));
378 
379         super.setMigrationAgent(_address);
380     }
381 
382     /// @notice ExtendedStandardToken is Mintable
383     function mintTokens             (address _recipient, uint256 _amount) public onlyCreator {
384         super.mintTokens(_recipient, _amount);
385     }
386 
387     // CONTROL LOGIC
388 
389     /// @dev changes Hoard multisig address to another one
390     function changeHoardAddress     (address _address) onlyHoard external { hoard = _address; }
391 
392     /// @dev changes migration master address to another one
393     function changeMigrationMaster  (address _address) onlyHoard external { migrationMaster = _address; }
394 
395 }