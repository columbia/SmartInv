1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20 Interface
5  */
6 contract ERC20 {
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 
12     function allowance(address owner, address spender) public view returns (uint256);
13     function transferFrom(address from, address to, uint256 value) public returns (bool);
14     function approve(address spender, uint256 value) public returns (bool);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 /**
19  * @title Lockable Token
20  * @author info@yggdrash.io
21  */
22 contract Lockable {
23     bool public tokenTransfer;
24     address public owner;
25 
26     /**
27      * @dev They can transfer even if tokenTranser flag is false.
28      */
29     mapping(address => bool) public unlockAddress;
30 
31     /**
32      * @dev They cannot transfer even if tokenTransfer flag is true.
33      */
34     mapping(address => bool) public lockAddress;
35 
36     event Locked(address lockAddress, bool status);
37     event Unlocked(address unlockedAddress, bool status);
38 
39     /**
40      * @dev check whether can tranfer tokens or not.
41      */
42     modifier isTokenTransfer {
43         if(!tokenTransfer) {
44             require(unlockAddress[msg.sender]);
45         }
46         _;
47     }
48 
49     /**
50      * @dev check whether registered in lockAddress or not
51      */
52     modifier checkLock {
53         require(!lockAddress[msg.sender]);
54         _;
55     }
56 
57     modifier isOwner
58     {
59         require(owner == msg.sender);
60         _;
61     }
62 
63     constructor()
64     public
65     {
66         tokenTransfer = false;
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev add or remove in lockAddress(blacklist)
72      */
73     function setLockAddress(address target, bool status)
74     external
75     isOwner
76     {
77         require(owner != target);
78         lockAddress[target] = status;
79         emit Locked(target, status);
80     }
81 
82     /**
83      * @dev add or remove in unlockAddress(whitelist)
84      */
85     function setUnlockAddress(address target, bool status)
86     external
87     isOwner
88     {
89         unlockAddress[target] = status;
90         emit Unlocked(target, status);
91     }
92 }
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99 
100     /**
101     * @dev Multiplies two numbers, throws on overflow.
102     */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
105     // benefit is lost if 'b' is also tested.
106     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         c = a * b;
112         assert(c / a == b);
113         return c;
114     }
115 
116     /**
117     * @dev Integer division of two numbers, truncating the quotient.
118     */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         // assert(b > 0); // Solidity automatically throws when dividing by 0
121         // uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123         return a / b;
124     }
125 
126     /**
127     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128     */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         assert(b <= a);
131         return a - b;
132     }
133 
134     /**
135     * @dev Adds two numbers, throws on overflow.
136     */
137     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
138         c = a + b;
139         assert(c >= a);
140         return c;
141     }
142 }
143 
144 /**
145  * @title YGGDRASH Token Contract.
146  * @author info@yggdrash.io
147  * @notice This contract is the updated version that fixes the unlocking bug.
148  * This source code is audited by external auditors.
149  */
150 contract YeedToken is ERC20, Lockable {
151 
152     string public constant name = "YGGDRASH";
153     string public constant symbol = "YEED";
154     uint8 public constant decimals = 18;
155 
156     /**
157      * @dev If this flag is true, admin can use enableTokenTranfer(), emergencyTransfer().
158      */
159     bool public adminMode;
160 
161     using SafeMath for uint256;
162 
163     mapping(address => uint256) internal _balances;
164     mapping(address => mapping(address => uint256)) internal _approvals;
165     uint256 internal _supply;
166 
167     event TokenBurned(address burnAddress, uint256 amountOfTokens);
168     event SetTokenTransfer(bool transfer);
169     event SetAdminMode(bool adminMode);
170     event EmergencyTransfer(address indexed from, address indexed to, uint256 value);
171 
172     modifier isAdminMode {
173         require(adminMode);
174         _;
175     }
176 
177     constructor(uint256 initial_balance)
178     public
179     {
180         require(initial_balance != 0);
181         _supply = initial_balance;
182         _balances[msg.sender] = initial_balance;
183         emit Transfer(address(0), msg.sender, initial_balance);
184     }
185 
186     function totalSupply()
187     public
188     view
189     returns (uint256) {
190         return _supply;
191     }
192 
193     function balanceOf(address who)
194     public
195     view
196     returns (uint256) {
197         return _balances[who];
198     }
199 
200     function transfer(address to, uint256 value)
201     public
202     isTokenTransfer
203     checkLock
204     returns (bool) {
205         require(to != address(0));
206         require(_balances[msg.sender] >= value);
207 
208         _balances[msg.sender] = _balances[msg.sender].sub(value);
209         _balances[to] = _balances[to].add(value);
210         emit Transfer(msg.sender, to, value);
211         return true;
212     }
213 
214     function allowance(address owner, address spender)
215     public
216     view
217     returns (uint256) {
218         return _approvals[owner][spender];
219     }
220 
221     function transferFrom(address from, address to, uint256 value)
222     public
223     isTokenTransfer
224     checkLock
225     returns (bool success) {
226         require(!lockAddress[from]);
227         require(_balances[from] >= value);
228         require(_approvals[from][msg.sender] >= value);
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
232         emit Transfer(from, to, value);
233         return true;
234     }
235 
236     /**
237      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param spender The address which will spend the funds.
243      * @param value The amount of tokens to be spent.
244      */
245     function approve(address spender, uint256 value)
246     public
247     checkLock
248     returns (bool) {
249         _approvals[msg.sender][spender] = value;
250         emit Approval(msg.sender, spender, value);
251         return true;
252     }
253 
254     /**
255      * @dev Increase the amount of tokens that an owner allowed to a spender.
256      * approve should be called when allowed[_spender] == 0. To increment
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * @param _spender The address which will spend the funds.
261      * @param _addedValue The amount of tokens to increase the allowance by.
262      */
263     function increaseApproval(address _spender, uint256 _addedValue)
264     public
265     checkLock
266     returns (bool) {
267         _approvals[msg.sender][_spender] = (
268         _approvals[msg.sender][_spender].add(_addedValue));
269         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
270         return true;
271     }
272 
273     /**
274      * @dev Decrease the amount of tokens that an owner allowed to a spender.
275      * approve should be called when allowed[_spender] == 0. To decrement
276      * allowed value is better to use this function to avoid 2 calls (and wait until
277      * the first transaction is mined)
278      * From MonolithDAO Token.sol
279      * @param _spender The address which will spend the funds.
280      * @param _subtractedValue The amount of tokens to decrease the allowance by.
281      */
282     function decreaseApproval(address _spender, uint256 _subtractedValue)
283     public
284     checkLock
285     returns (bool) {
286         uint256 oldValue = _approvals[msg.sender][_spender];
287         if (_subtractedValue > oldValue) {
288             _approvals[msg.sender][_spender] = 0;
289         } else {
290             _approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291         }
292         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
293         return true;
294     }
295 
296     /**
297      * @dev Burn tokens can only use by owner
298      */
299     function burnTokens(uint256 tokensAmount)
300     public
301     isAdminMode
302     isOwner
303     {
304         require(_balances[msg.sender] >= tokensAmount);
305 
306         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
307         _supply = _supply.sub(tokensAmount);
308         emit TokenBurned(msg.sender, tokensAmount);
309     }
310 
311     /**
312      * @dev Set the tokenTransfer flag.
313      * If true, 
314      * - unregistered lockAddress can transfer()
315      * - registered lockAddress can not transfer()
316      * If false, 
317      * - registered unlockAddress & unregistered lockAddress 
318      * - can transfer(), unregistered unlockAddress can not transfer()
319      */
320     function setTokenTransfer(bool _tokenTransfer)
321     external
322     isAdminMode
323     isOwner
324     {
325         tokenTransfer = _tokenTransfer;
326         emit SetTokenTransfer(tokenTransfer);
327     }
328 
329     function setAdminMode(bool _adminMode)
330     public
331     isOwner
332     {
333         adminMode = _adminMode;
334         emit SetAdminMode(adminMode);
335     }
336 
337     /**
338      * @dev In emergency situation, 
339      * admin can use emergencyTransfer() for protecting user's token.
340      */
341     function emergencyTransfer(address emergencyAddress)
342     public
343     isAdminMode
344     isOwner
345     returns (bool success) {
346         require(emergencyAddress != owner);
347         _balances[owner] = _balances[owner].add(_balances[emergencyAddress]);
348 
349         emit Transfer(emergencyAddress, owner, _balances[emergencyAddress]);
350         emit EmergencyTransfer(emergencyAddress, owner, _balances[emergencyAddress]);
351     
352         _balances[emergencyAddress] = 0;
353         return true;
354     }
355 }