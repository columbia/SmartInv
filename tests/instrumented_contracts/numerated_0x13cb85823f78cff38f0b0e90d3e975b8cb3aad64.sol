1 pragma solidity 0.4.24;
2 
3 // File: contracts/Lockable.sol
4 
5 /**
6  * @title Lockable Token
7  * @author info@remiit.io
8  */
9 contract Lockable {
10     bool public tokenTransfer;
11     address public owner;
12 
13     /**
14      * @dev They can transfer even if tokenTranser flag is false.
15      */
16     mapping(address => bool) public unlockAddress;
17 
18     /**
19      * @dev They cannot transfer even if tokenTransfer flag is true.
20      */
21     mapping(address => bool) public lockAddress;
22 
23     event Locked(address lockAddress, bool status);
24     event Unlocked(address unlockedAddress, bool status);
25 
26     /**
27      * @dev check whether can tranfer tokens or not.
28      */
29     modifier isTokenTransfer {
30         if(!tokenTransfer) {
31             require(unlockAddress[msg.sender]);
32         }
33         _;
34     }
35 
36     /**
37      * @dev check whether registered in lockAddress or not
38      */
39     modifier checkLock {
40         require(!lockAddress[msg.sender]);
41         _;
42     }
43 
44     modifier isOwner
45     {
46         require(owner == msg.sender);
47         _;
48     }
49 
50     constructor()
51     public
52     {
53         tokenTransfer = false;
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev add or remove in lockAddress(blacklist)
59      */
60     function setLockAddress(address target, bool status)
61     external
62     isOwner
63     {
64         require(owner != target);
65         lockAddress[target] = status;
66         emit Locked(target, status);
67     }
68 
69     /**
70      * @dev add or remove in unlockAddress(whitelist)
71      */
72     function setUnlockAddress(address target, bool status)
73     external
74     isOwner
75     {
76         unlockAddress[target] = status;
77         emit Unlocked(target, status);
78     }
79 }
80 
81 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * See https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   function totalSupply() public view returns (uint256);
90   function balanceOf(address _who) public view returns (uint256);
91   function transfer(address _to, uint256 _value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address _owner, address _spender)
103     public view returns (uint256);
104 
105   function transferFrom(address _from, address _to, uint256 _value)
106     public returns (bool);
107 
108   function approve(address _spender, uint256 _value) public returns (bool);
109   event Approval(
110     address indexed owner,
111     address indexed spender,
112     uint256 value
113   );
114 }
115 
116 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
117 
118 /**
119  * @title SafeMath
120  * @dev Math operations with safety checks that throw on error
121  */
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
128     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
129     // benefit is lost if 'b' is also tested.
130     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
131     if (_a == 0) {
132       return 0;
133     }
134 
135     c = _a * _b;
136     assert(c / _a == _b);
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers, truncating the quotient.
142   */
143   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
144     // assert(_b > 0); // Solidity automatically throws when dividing by 0
145     // uint256 c = _a / _b;
146     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
147     return _a / _b;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
154     assert(_b <= _a);
155     return _a - _b;
156   }
157 
158   /**
159   * @dev Adds two numbers, throws on overflow.
160   */
161   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
162     c = _a + _b;
163     assert(c >= _a);
164     return c;
165   }
166 }
167 
168 // File: contracts/RemiTokenRopsten.sol
169 
170 // import "./ERC20.sol";
171 
172 // import "../util/SafeMath.sol";
173 
174 // import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
175 
176 
177 /**
178  * @title REMI Token Contract.
179  * @author info@remiit.io
180  * @notice This contract is the updated version that fixes the unlocking bug.
181  * This source code is audited by external auditors.
182  */
183 
184 
185 // contract RemiTokenRopsten is ERC20, Lockable {
186 // contract RemiTokenRopsten is MintableToken, Lockable {
187 contract RemiToken is ERC20, Lockable {
188 
189     string public constant name = "REMI Token";
190     string public constant symbol = "REMI";
191     uint8 public constant decimals = 18;
192 
193     /**
194      * @dev If this flag is true, admin can use enableTokenTranfer(), emergencyTransfer().
195      */
196     bool public adminMode;
197 
198     using SafeMath for uint256;
199 
200     mapping(address => uint256) internal _balances;
201     mapping(address => mapping(address => uint256)) internal _approvals;
202     uint256 internal _supply;
203 
204     event TokenBurned(address burnAddress, uint256 amountOfTokens);
205     event SetTokenTransfer(bool transfer);
206     event SetAdminMode(bool adminMode);
207     event EmergencyTransfer(address indexed from, address indexed to, uint256 value);
208 
209     modifier isAdminMode {
210         require(adminMode);
211         _;
212     }
213 
214     constructor(uint256 initial_balance)
215     public
216     {
217         require(initial_balance != 0);
218         _supply = initial_balance;
219         _balances[msg.sender] = initial_balance;
220         emit Transfer(address(0), msg.sender, initial_balance);
221     }
222 
223     function totalSupply()
224     public
225     view
226     returns (uint256) {
227         return _supply;
228     }
229 
230     function balanceOf(address who)
231     public
232     view
233     returns (uint256) {
234         return _balances[who];
235     }
236 
237     function transfer(address to, uint256 value)
238     public
239     isTokenTransfer
240     checkLock
241     returns (bool) {
242         require(to != address(0));
243         require(_balances[msg.sender] >= value);
244 
245         _balances[msg.sender] = _balances[msg.sender].sub(value);
246         _balances[to] = _balances[to].add(value);
247         emit Transfer(msg.sender, to, value);
248         return true;
249     }
250 
251     function allowance(address owner, address spender)
252     public
253     view
254     returns (uint256) {
255         return _approvals[owner][spender];
256     }
257 
258     function transferFrom(address from, address to, uint256 value)
259     public
260     isTokenTransfer
261     checkLock
262     returns (bool success) {
263         require(!lockAddress[from]);
264         require(_balances[from] >= value);
265         require(_approvals[from][msg.sender] >= value);
266         _balances[from] = _balances[from].sub(value);
267         _balances[to] = _balances[to].add(value);
268         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
269         emit Transfer(from, to, value);
270         return true;
271     }
272 
273     /**
274      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275      * Beware that changing an allowance with this method brings the risk that someone may use both the old
276      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279      * @param spender The address which will spend the funds.
280      * @param value The amount of tokens to be spent.
281      */
282     function approve(address spender, uint256 value)
283     public
284     checkLock
285     returns (bool) {
286         _approvals[msg.sender][spender] = value;
287         emit Approval(msg.sender, spender, value);
288         return true;
289     }
290 
291     /**
292      * @dev Increase the amount of tokens that an owner allowed to a spender.
293      * approve should be called when allowed[_spender] == 0. To increment
294      * allowed value is better to use this function to avoid 2 calls (and wait until
295      * the first transaction is mined)
296      * From MonolithDAO Token.sol
297      * @param _spender The address which will spend the funds.
298      * @param _addedValue The amount of tokens to increase the allowance by.
299      */
300     function increaseApproval(address _spender, uint256 _addedValue)
301     public
302     checkLock
303     returns (bool) {
304         _approvals[msg.sender][_spender] = (
305         _approvals[msg.sender][_spender].add(_addedValue));
306         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
307         return true;
308     }
309 
310     /**
311      * @dev Decrease the amount of tokens that an owner allowed to a spender.
312      * approve should be called when allowed[_spender] == 0. To decrement
313      * allowed value is better to use this function to avoid 2 calls (and wait until
314      * the first transaction is mined)
315      * From MonolithDAO Token.sol
316      * @param _spender The address which will spend the funds.
317      * @param _subtractedValue The amount of tokens to decrease the allowance by.
318      */
319     function decreaseApproval(address _spender, uint256 _subtractedValue)
320     public
321     checkLock
322     returns (bool) {
323         uint256 oldValue = _approvals[msg.sender][_spender];
324         if (_subtractedValue > oldValue) {
325             _approvals[msg.sender][_spender] = 0;
326         } else {
327             _approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328         }
329         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
330         return true;
331     }
332 
333     /**
334      * @dev Burn tokens can only use by owner
335      */
336     function burnTokens(uint256 tokensAmount)
337     public
338     isAdminMode
339     isOwner
340     {
341         require(_balances[msg.sender] >= tokensAmount);
342 
343         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
344         _supply = _supply.sub(tokensAmount);
345         emit TokenBurned(msg.sender, tokensAmount);
346     }
347 
348     /**
349      * @dev Set the tokenTransfer flag.
350      * If true, 
351      * - unregistered lockAddress can transfer()
352      * - registered lockAddress can not transfer()
353      * If false, 
354      * - registered unlockAddress & unregistered lockAddress 
355      * - can transfer(), unregistered unlockAddress can not transfer()
356      */
357     function setTokenTransfer(bool _tokenTransfer)
358     external
359     isAdminMode
360     isOwner
361     {
362         tokenTransfer = _tokenTransfer;
363         emit SetTokenTransfer(tokenTransfer);
364     }
365 
366     function setAdminMode(bool _adminMode)
367     public
368     isOwner
369     {
370         adminMode = _adminMode;
371         emit SetAdminMode(adminMode);
372     }
373 
374     /**
375      * @dev In emergency situation, 
376      * admin can use emergencyTransfer() for protecting user's token.
377      */
378     function emergencyTransfer(address emergencyAddress)
379     public
380     isAdminMode
381     isOwner
382     returns (bool success) {
383         require(emergencyAddress != owner);
384         _balances[owner] = _balances[owner].add(_balances[emergencyAddress]);
385 
386         emit Transfer(emergencyAddress, owner, _balances[emergencyAddress]);
387         emit EmergencyTransfer(emergencyAddress, owner, _balances[emergencyAddress]);
388     
389         _balances[emergencyAddress] = 0;
390         return true;
391     }
392 }