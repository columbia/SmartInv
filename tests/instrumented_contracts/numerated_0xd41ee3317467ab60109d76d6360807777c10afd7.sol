1 pragma solidity ^0.4.21;
2 /** ----------------------------------------------------------------------------------------------
3  * ZJLTTokenVault by ZJLT Distributed Factoring Network Limited.
4  * An ERC20 standard
5  *
6  * author: ZJLT Distributed Factoring Network Team
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error.
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract ERC20 {
43 
44     uint256 public totalSupply;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51 
52     function allowance(address owner, address spender) public view returns (uint256);
53     function approve(address spender, uint256 value) public returns (bool);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55 
56 }
57 
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     emit OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93 }
94 
95 interface TokenRecipient {
96     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
97 }
98 
99 contract TokenERC20 is ERC20, Ownable{
100     // Public variables of the token
101     string public name;
102     string public symbol;
103     uint8  public decimals = 18;
104     // 18 decimals is the strongly suggested default, avoid changing it
105     using SafeMath for uint256;
106     // Balances
107     mapping (address => uint256) balances;
108     // Allowances
109     mapping (address => mapping (address => uint256)) allowances;
110 
111 
112     // ----- Events -----
113     event Burn(address indexed from, uint256 value);
114 
115 
116     /**
117      * Constructor function
118      */
119     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
120         name = _tokenName;                                   // Set the name for display purposes
121         symbol = _tokenSymbol;                               // Set the symbol for display purposes
122         decimals = _decimals;
123 
124         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
125         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
126     }
127 
128         /**
129      * @dev Fix for the ERC20 short address attack.
130      */
131     modifier onlyPayloadSize(uint size) {
132       if(msg.data.length < size + 4) {
133         revert();
134       }
135       _;
136     }
137     
138 
139     function balanceOf(address _owner) public view returns(uint256) {
140         return balances[_owner];
141     }
142 
143     function allowance(address _owner, address _spender) public view returns (uint256) {
144         return allowances[_owner][_spender];
145     }
146 
147     /**
148      * Internal transfer, only can be called by this contract
149      */
150     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
151         // Prevent transfer to 0x0 address. Use burn() instead
152         require(_to != 0x0);
153         // Check if the sender has enough
154         require(balances[_from] >= _value);
155         // Check for overflows
156         require(balances[_to] + _value > balances[_to]);
157 
158         require(_value >= 0);
159         // Save this for an assertion in the future
160         uint previousBalances = balances[_from].add(balances[_to]);
161          // SafeMath.sub will throw if there is not enough balance.
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         emit Transfer(_from, _to, _value);
165         // Asserts are used to use static analysis to find bugs in your code. They should never fail
166         assert(balances[_from] + balances[_to] == previousBalances);
167 
168         return true;
169     }
170 
171     /**
172      * Transfer tokens
173      *
174      * Send `_value` tokens to `_to` from your account
175      *
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transfer(address _to, uint256 _value) public returns(bool) {
180         return _transfer(msg.sender, _to, _value);
181     }
182 
183     /**
184      * Transfer tokens from other address
185      *
186      * Send `_value` tokens to `_to` in behalf of `_from`
187      *
188      * @param _from The address of the sender
189      * @param _to The address of the recipient
190      * @param _value the amount to send
191      */
192     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
193         require(_to != address(0));
194         require(_value <= balances[_from]);
195         require(_value > 0);
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201         return true;
202     }
203 
204     /**
205      * Set allowance for other address
206      *
207      * Allows `_spender` to spend no more than `_value` tokens in your behalf
208      *
209      * @param _spender The address authorized to spend
210      * @param _value the max amount they can spend
211      */
212     function approve(address _spender, uint256 _value) public returns(bool) {
213         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
214         allowances[msg.sender][_spender] = _value;
215         emit Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /**
220      * Set allowance for other address and notify
221      *
222      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
223      *
224      * @param _spender The address authorized to spend
225      * @param _value the max amount they can spend
226      * @param _extraData some extra information to send to the approved contract
227      */
228     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
229         if (approve(_spender, _value)) {
230             TokenRecipient spender = TokenRecipient(_spender);
231             spender.receiveApproval(msg.sender, _value, this, _extraData);
232             return true;
233         }
234         return false;
235     }
236 
237 
238   /**
239    * @dev Transfer tokens to multiple addresses
240    * @param _addresses The addresses that will receieve tokens
241    * @param _amounts The quantity of tokens that will be transferred
242    * @return True if the tokens are transferred correctly
243    */
244   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
245     for (uint256 i = 0; i < _addresses.length; i++) {
246       require(_addresses[i] != address(0));
247       require(_amounts[i] <= balances[msg.sender]);
248       require(_amounts[i] > 0);
249 
250       // SafeMath.sub will throw if there is not enough balance.
251       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
252       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
253       emit Transfer(msg.sender, _addresses[i], _amounts[i]);
254     }
255     return true;
256   }
257 
258     /**
259      * Destroy tokens
260      *
261      * Remove `_value` tokens from the system irreversibly
262      *
263      * @param _value the amount of money to burn
264      */
265     function burn(uint256 _value) public returns(bool) {
266         require(balances[msg.sender] >= _value);   // Check if the sender has enough
267         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
268         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
269         emit Burn(msg.sender, _value);
270         return true;
271     }
272 
273         /**
274      * Destroy tokens from other account
275      *
276      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
277      *
278      * @param _from the address of the sender
279      * @param _value the amount of money to burn
280      */
281     function burnFrom(address _from, uint256 _value) public returns(bool) {
282         require(balances[_from] >= _value);                // Check if the targeted balance is enough
283         require(_value <= allowances[_from][msg.sender]);    // Check allowance
284         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
285         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
286         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
287         emit Burn(_from, _value);
288         return true;
289     }
290 
291 
292     /**
293      * approve should be called when allowances[_spender] == 0. To increment
294      * allowances value is better to use this function to avoid 2 calls (and wait until
295      * the first transaction is mined)
296      * From MonolithDAO Token.sol
297      */
298     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
299         // Check for overflows
300         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
301 
302         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
303         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
304         return true;
305     }
306 
307     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
308         uint oldValue = allowances[msg.sender][_spender];
309         if (_subtractedValue > oldValue) {
310             allowances[msg.sender][_spender] = 0;
311         } else {
312             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313         }
314         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
315         return true;
316     }
317 
318 
319 }
320 
321 contract ZJLTToken is TokenERC20 {
322 
323     function ZJLTToken() TokenERC20(2500000000, "ZJLT Distributed Factoring Network", "ZJLT", 18) public {
324 
325     }
326     
327     function () payable public {
328       //if ether is sent to this address, send it back.
329       //throw;
330       require(false);
331     }
332 }
333 
334 contract ZJLTTokenVault is Ownable {
335     using SafeMath for uint256;
336     address public teamWallet = 0x1fd4C9206715703c209651c215f506555a40b7C0;
337     uint256 public startLockTime;
338     uint256 public totalAlloc = 25 * 10 ** 18;
339     uint256 public perValue = 20833333 * 10 ** 11;
340 
341     uint256 public timeLockPeriod = 30 days;
342     uint256 public teamVestingStages = 12;
343     uint256 public latestUnlockStage = 0;
344 
345     mapping (address => uint256) public lockBalance;
346     ZJLTToken public token;
347     bool public isExec;
348     
349     // envent
350     event Alloc(address _wallet, uint256 _value);
351     event Claim(address _wallet, uint256 _value);
352     
353     modifier unLocked {
354         uint256 nextStage =  latestUnlockStage.add(1);
355         require(startLockTime > 0 && now >= startLockTime.add(nextStage.mul(timeLockPeriod)));
356         _;
357     }
358     
359     modifier unExecd {
360         require(isExec == false);
361         _;
362     }
363     
364     function ZJLTTokenVault(ERC20 _token) public {
365         owner = msg.sender;
366         token = ZJLTToken(_token);
367     }
368     
369     function isUnlocked() public constant returns (bool) {
370         uint256 nextStage =  latestUnlockStage.add(1);
371         return startLockTime > 0 && now >= startLockTime.add(nextStage.mul(timeLockPeriod)) ;
372     }
373     
374     function alloc() public onlyOwner unExecd{
375         require(token.balanceOf(address(this)) >= totalAlloc);
376         lockBalance[teamWallet] = totalAlloc;
377         startLockTime = 1494432000 seconds;
378         isExec = true;
379         emit Alloc(teamWallet, totalAlloc);
380     }
381     
382     function claim() public onlyOwner unLocked {
383         require(lockBalance[teamWallet] > 0);
384         if(latestUnlockStage == 11 && perValue != lockBalance[teamWallet] ){
385             perValue = lockBalance[teamWallet];
386         }
387         lockBalance[teamWallet] = lockBalance[teamWallet].sub(perValue);
388         require(token.transfer(teamWallet, perValue));
389         latestUnlockStage = latestUnlockStage.add(1);
390         emit Claim(teamWallet, perValue);
391     }
392 }