1 /**
2  * @title ERC20 interface
3  * @dev see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6     function totalSupply() public view returns (uint256);
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10 
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Lockable {
18     bool public tokenTransfer;
19     address public owner;
20 
21     /**
22      * @dev They can transfer even if tokenTranser flag is false.
23      */
24     mapping(address => bool) public unlockAddress;
25 
26     /**
27      * @dev They cannot transfer even if tokenTransfer flag is true.
28      */
29     mapping(address => bool) public lockAddress;
30 
31     event Locked(address lockAddress, bool status);
32     event Unlocked(address unlockedAddress, bool status);
33 
34     /**
35      * @dev check whether can tranfer tokens or not.
36      */
37     modifier isTokenTransfer {
38         if(!tokenTransfer) {
39             require(unlockAddress[msg.sender]);
40         }
41         _;
42     }
43 
44     /**
45      * @dev check whether registered in lockAddress or not
46      */
47     modifier checkLock {
48         require(!lockAddress[msg.sender]);
49         _;
50     }
51 
52     modifier isOwner
53     {
54         require(owner == msg.sender);
55         _;
56     }
57 
58     constructor()
59     public
60     {
61         tokenTransfer = false;
62         owner = msg.sender;
63     }
64 
65     /**
66      * @dev add or remove in lockAddress(blacklist)
67      */
68     function setLockAddress(address target, bool status)
69     external
70     isOwner
71     {
72         require(owner != target);
73         lockAddress[target] = status;
74         emit Locked(target, status);
75     }
76 
77     /**
78      * @dev add or remove in unlockAddress(whitelist)
79      */
80     function setUnlockAddress(address target, bool status)
81     external
82     isOwner
83     {
84         unlockAddress[target] = status;
85         emit Unlocked(target, status);
86     }
87 }
88 
89 
90 /**
91  * @title TrabitCoin Token Contract.
92  */
93 contract TrabitCoin is ERC20, Lockable {
94 
95     string public constant name = "TrabitCoin";
96     string public constant symbol = "TRB";
97     uint8 public constant decimals = 18;
98 
99     /**
100      * @dev If this flag is true, admin can use enableTokenTranfer(), emergencyTransfer().
101      */
102     bool public adminMode;
103 
104     using SafeMath for uint256;
105 
106     mapping(address => uint256) internal _balances;
107     mapping(address => mapping(address => uint256)) internal _approvals;
108     uint256 internal _supply;
109 
110     event TokenBurned(address burnAddress, uint256 amountOfTokens);
111     event SetTokenTransfer(bool transfer);
112     event SetAdminMode(bool adminMode);
113     event EmergencyTransfer(address indexed from, address indexed to, uint256 value);
114 
115     modifier isAdminMode {
116         require(adminMode);
117         _;
118     }
119 
120     constructor(uint256 initial_balance)
121     public
122     {
123         require(initial_balance != 0);
124         _supply = initial_balance;
125         _balances[msg.sender] = initial_balance;
126         emit Transfer(address(0), msg.sender, initial_balance);
127     }
128 
129     function totalSupply()
130     public
131     view
132     returns (uint256) {
133         return _supply;
134     }
135 
136     function balanceOf(address who)
137     public
138     view
139     returns (uint256) {
140         return _balances[who];
141     }
142 
143     function transfer(address to, uint256 value)
144     public
145     isTokenTransfer
146     checkLock
147     returns (bool) {
148         require(to != address(0));
149         require(_balances[msg.sender] >= value);
150 
151         _balances[msg.sender] = _balances[msg.sender].sub(value);
152         _balances[to] = _balances[to].add(value);
153         emit Transfer(msg.sender, to, value);
154         return true;
155     }
156 
157     function allowance(address owner, address spender)
158     public
159     view
160     returns (uint256) {
161         return _approvals[owner][spender];
162     }
163 
164     function transferFrom(address from, address to, uint256 value)
165     public
166     isTokenTransfer
167     checkLock
168     returns (bool success) {
169         require(!lockAddress[from]);
170         require(_balances[from] >= value);
171         require(_approvals[from][msg.sender] >= value);
172         _balances[from] = _balances[from].sub(value);
173         _balances[to] = _balances[to].add(value);
174         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
175         emit Transfer(from, to, value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param spender The address which will spend the funds.
186      * @param value The amount of tokens to be spent.
187      */
188     function approve(address spender, uint256 value)
189     public
190     checkLock
191     returns (bool) {
192         _approvals[msg.sender][spender] = value;
193         emit Approval(msg.sender, spender, value);
194         return true;
195     }
196 
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * @param _spender The address which will spend the funds.
204      * @param _addedValue The amount of tokens to increase the allowance by.
205      */
206     function increaseApproval(address _spender, uint256 _addedValue)
207     public
208     checkLock
209     returns (bool) {
210         _approvals[msg.sender][_spender] = (
211         _approvals[msg.sender][_spender].add(_addedValue));
212         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
213         return true;
214     }
215 
216     /**
217      * @dev Decrease the amount of tokens that an owner allowed to a spender.
218      * approve should be called when allowed[_spender] == 0. To decrement
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * @param _spender The address which will spend the funds.
223      * @param _subtractedValue The amount of tokens to decrease the allowance by.
224      */
225     function decreaseApproval(address _spender, uint256 _subtractedValue)
226     public
227     checkLock
228     returns (bool) {
229         uint256 oldValue = _approvals[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231             _approvals[msg.sender][_spender] = 0;
232         } else {
233             _approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
236         return true;
237     }
238 
239     /**
240      * @dev Burn tokens can only use by owner
241      */
242     function burnTokens(uint256 tokensAmount)
243     public
244     isAdminMode
245     isOwner
246     {
247         require(_balances[msg.sender] >= tokensAmount);
248 
249         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
250         _supply = _supply.sub(tokensAmount);
251         emit TokenBurned(msg.sender, tokensAmount);
252     }
253 
254     /**
255      * @dev Set the tokenTransfer flag.
256      * If true,
257      * - unregistered lockAddress can transfer()
258      * - registered lockAddress can not transfer()
259      * If false,
260      * - registered unlockAddress & unregistered lockAddress
261      * - can transfer(), unregistered unlockAddress can not transfer()
262      */
263     function setTokenTransfer(bool _tokenTransfer)
264     external
265     isAdminMode
266     isOwner
267     {
268         tokenTransfer = _tokenTransfer;
269         emit SetTokenTransfer(tokenTransfer);
270     }
271 
272     function setAdminMode(bool _adminMode)
273     public
274     isOwner
275     {
276         adminMode = _adminMode;
277         emit SetAdminMode(adminMode);
278     }
279 
280     /**
281      * @dev In emergency situation,
282      * admin can use emergencyTransfer() for protecting user's token.
283      */
284     function emergencyTransfer(address emergencyAddress)
285     public
286     isAdminMode
287     isOwner
288     returns (bool success) {
289         require(emergencyAddress != owner);
290         _balances[owner] = _balances[owner].add(_balances[emergencyAddress]);
291 
292         emit Transfer(emergencyAddress, owner, _balances[emergencyAddress]);
293         emit EmergencyTransfer(emergencyAddress, owner, _balances[emergencyAddress]);
294 
295         _balances[emergencyAddress] = 0;
296         return true;
297     }
298 }
299 
300 /**
301  * @title SafeMath
302  * @dev Math operations with safety checks that throw on error
303  */
304 library SafeMath {
305 
306     /**
307     * @dev Multiplies two numbers, throws on overflow.
308     */
309     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
310     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
311     // benefit is lost if 'b' is also tested.
312     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
313         if (a == 0) {
314             return 0;
315         }
316 
317         c = a * b;
318         assert(c / a == b);
319         return c;
320     }
321 
322     /**
323     * @dev Integer division of two numbers, truncating the quotient.
324     */
325     function div(uint256 a, uint256 b) internal pure returns (uint256) {
326         // assert(b > 0); // Solidity automatically throws when dividing by 0
327         // uint256 c = a / b;
328         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
329         return a / b;
330     }
331 
332     /**
333     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
334     */
335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
336         assert(b <= a);
337         return a - b;
338     }
339 
340     /**
341     * @dev Adds two numbers, throws on overflow.
342     */
343     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
344         c = a + b;
345         assert(c >= a);
346         return c;
347     }
348 }