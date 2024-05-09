1 /**
2  * @title ERC20 Interface
3  */
4 contract ERC20 {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21     /**
22     * @dev Multiplies two numbers, throws on overflow.
23     */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 
37     /**
38     * @dev Integer division of two numbers, truncating the quotient.
39     */
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         // uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return a / b;
45     }
46 
47     /**
48     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49     */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59         c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 /**
65  * @title Lockable Token
66  * @author info@yggdrash.io
67  */
68 contract Lockable {
69     bool public tokenTransfer;
70     address public owner;
71 
72     /**
73      * @dev They can transfer even if tokenTranser flag is false.
74      */
75     mapping(address => bool) public unlockAddress;
76 
77     /**
78      * @dev They cannot transfer even if tokenTransfer flag is true.
79      */
80     mapping(address => bool) public lockAddress;
81 
82     event Locked(address lockAddress, bool status);
83     event Unlocked(address unlockedAddress, bool status);
84 
85     /**
86      * @dev check whether can tranfer tokens or not.
87      */
88     modifier isTokenTransfer {
89         if(!tokenTransfer) {
90             require(unlockAddress[msg.sender]);
91         }
92         _;
93     }
94 
95     /**
96      * @dev check whether registered in lockAddress or not
97      */
98     modifier checkLock {
99         require(!lockAddress[msg.sender]);
100         _;
101     }
102 
103     modifier isOwner
104     {
105         require(owner == msg.sender);
106         _;
107     }
108 
109     constructor()
110     public
111     {
112         tokenTransfer = false;
113         owner = msg.sender;
114     }
115 
116     /**
117      * @dev add or remove in lockAddress(blacklist)
118      */
119     function setLockAddress(address target, bool status)
120     external
121     isOwner
122     {
123         require(owner != target);
124         lockAddress[target] = status;
125         emit Locked(target, status);
126     }
127 
128     /**
129      * @dev add or remove in unlockAddress(whitelist)
130      */
131     function setUnlockAddress(address target, bool status)
132     external
133     isOwner
134     {
135         unlockAddress[target] = status;
136         emit Unlocked(target, status);
137     }
138 }
139 /**
140  * @title YGGDRASH Token Contract.
141  * @author info@yggdrash.io
142  * @notice This contract is the updated version that fixes the unlocking bug.
143  * This source code is audited by external auditors.
144  */
145 contract SPONBToken is ERC20, Lockable {
146 
147     string public constant name = "SPONB";
148     string public constant symbol = "SPO";
149     uint8 public constant decimals = 18;
150 
151     /**
152      * @dev If this flag is true, admin can use enableTokenTranfer(), emergencyTransfer().
153      */
154     bool public adminMode;
155 
156     using SafeMath for uint256;
157 
158     mapping(address => uint256) internal _balances;
159     mapping(address => mapping(address => uint256)) internal _approvals;
160     uint256 internal _supply;
161 
162     event TokenBurned(address burnAddress, uint256 amountOfTokens);
163     event SetTokenTransfer(bool transfer);
164     event SetAdminMode(bool adminMode);
165     event EmergencyTransfer(address indexed from, address indexed to, uint256 value);
166 
167     modifier isAdminMode {
168         require(adminMode);
169         _;
170     }
171 
172     constructor(uint256 initial_balance)
173     public
174     {
175         require(initial_balance != 0);
176         _supply = initial_balance;
177         _balances[msg.sender] = initial_balance;
178         emit Transfer(address(0), msg.sender, initial_balance);
179     }
180 
181     function totalSupply()
182     public
183     view
184     returns (uint256) {
185         return _supply;
186     }
187 
188     function balanceOf(address who)
189     public
190     view
191     returns (uint256) {
192         return _balances[who];
193     }
194 
195     function transfer(address to, uint256 value)
196     public
197     isTokenTransfer
198     checkLock
199     returns (bool) {
200         require(to != address(0));
201         require(_balances[msg.sender] >= value);
202 
203         _balances[msg.sender] = _balances[msg.sender].sub(value);
204         _balances[to] = _balances[to].add(value);
205         emit Transfer(msg.sender, to, value);
206         return true;
207     }
208 
209     function allowance(address owner, address spender)
210     public
211     view
212     returns (uint256) {
213         return _approvals[owner][spender];
214     }
215 
216     function transferFrom(address from, address to, uint256 value)
217     public
218     isTokenTransfer
219     checkLock
220     returns (bool success) {
221         require(!lockAddress[from]);
222         require(_balances[from] >= value);
223         require(_approvals[from][msg.sender] >= value);
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
227         emit Transfer(from, to, value);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233      * Beware that changing an allowance with this method brings the risk that someone may use both the old
234      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      * @param spender The address which will spend the funds.
238      * @param value The amount of tokens to be spent.
239      */
240     function approve(address spender, uint256 value)
241     public
242     checkLock
243     returns (bool) {
244         _approvals[msg.sender][spender] = value;
245         emit Approval(msg.sender, spender, value);
246         return true;
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed[_spender] == 0. To increment
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * @param _spender The address which will spend the funds.
256      * @param _addedValue The amount of tokens to increase the allowance by.
257      */
258     function increaseApproval(address _spender, uint256 _addedValue)
259     public
260     checkLock
261     returns (bool) {
262         _approvals[msg.sender][_spender] = (
263         _approvals[msg.sender][_spender].add(_addedValue));
264         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
265         return true;
266     }
267 
268     /**
269      * @dev Decrease the amount of tokens that an owner allowed to a spender.
270      * approve should be called when allowed[_spender] == 0. To decrement
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * @param _spender The address which will spend the funds.
275      * @param _subtractedValue The amount of tokens to decrease the allowance by.
276      */
277     function decreaseApproval(address _spender, uint256 _subtractedValue)
278     public
279     checkLock
280     returns (bool) {
281         uint256 oldValue = _approvals[msg.sender][_spender];
282         if (_subtractedValue > oldValue) {
283             _approvals[msg.sender][_spender] = 0;
284         } else {
285             _approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286         }
287         emit Approval(msg.sender, _spender, _approvals[msg.sender][_spender]);
288         return true;
289     }
290 
291     /**
292      * @dev Burn tokens can only use by owner
293      */
294     function burnTokens(uint256 tokensAmount)
295     public
296     isAdminMode
297     isOwner
298     {
299         require(_balances[msg.sender] >= tokensAmount);
300 
301         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
302         _supply = _supply.sub(tokensAmount);
303         emit TokenBurned(msg.sender, tokensAmount);
304     }
305 
306     /**
307      * @dev Set the tokenTransfer flag.
308      * If true, 
309      * - unregistered lockAddress can transfer()
310      * - registered lockAddress can not transfer()
311      * If false, 
312      * - registered unlockAddress & unregistered lockAddress 
313      * - can transfer(), unregistered unlockAddress can not transfer()
314      */
315     function setTokenTransfer(bool _tokenTransfer)
316     external
317     isAdminMode
318     isOwner
319     {
320         tokenTransfer = _tokenTransfer;
321         emit SetTokenTransfer(tokenTransfer);
322     }
323 
324     function setAdminMode(bool _adminMode)
325     public
326     isOwner
327     {
328         adminMode = _adminMode;
329         emit SetAdminMode(adminMode);
330     }
331 
332     /**
333      * @dev In emergency situation, 
334      * admin can use emergencyTransfer() for protecting user's token.
335      */
336     function emergencyTransfer(address emergencyAddress)
337     public
338     isAdminMode
339     isOwner
340     returns (bool success) {
341         require(emergencyAddress != owner);
342         _balances[owner] = _balances[owner].add(_balances[emergencyAddress]);
343 
344         emit Transfer(emergencyAddress, owner, _balances[emergencyAddress]);
345         emit EmergencyTransfer(emergencyAddress, owner, _balances[emergencyAddress]);
346     
347         _balances[emergencyAddress] = 0;
348         return true;
349     }
350 }