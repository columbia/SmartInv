1 pragma solidity 0.5.1;
2 
3 
4 contract Ownable {
5     address public owner;
6     address public pendingOwner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /**
11     * @dev Throws if called by any account other than the owner.
12     */
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /**
19      * @dev Modifier throws if called by any account other than the pendingOwner.
20      */
21     modifier onlyPendingOwner() {
22         require(msg.sender == pendingOwner);
23         _;
24     }
25 
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     /**
31      * @dev Allows the current owner to set the pendingOwner address.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner public {
35         pendingOwner = newOwner;
36     }
37 
38     /**
39      * @dev Allows the pendingOwner address to finalize the transfer.
40      */
41     function claimOwnership() onlyPendingOwner public {
42         emit OwnershipTransferred(owner, pendingOwner);
43         owner = pendingOwner;
44         pendingOwner = address(0);
45     }
46 }
47 
48 
49 contract Manageable is Ownable {
50     mapping(address => bool) public listOfManagers;
51 
52     modifier onlyManager() {
53         require(listOfManagers[msg.sender], "");
54         _;
55     }
56 
57     function addManager(address _manager) public onlyOwner returns (bool success) {
58         if (!listOfManagers[_manager]) {
59             require(_manager != address(0), "");
60             listOfManagers[_manager] = true;
61             success = true;
62         }
63     }
64 
65     function removeManager(address _manager) public onlyOwner returns (bool success) {
66         if (listOfManagers[_manager]) {
67             listOfManagers[_manager] = false;
68             success = true;
69         }
70     }
71 
72     function getInfo(address _manager) public view returns (bool) {
73         return listOfManagers[_manager];
74     }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82     function totalSupply() external view returns (uint256);
83     function balanceOf(address who) external view returns (uint256);
84     function allowance(address owner, address spender) external view returns (uint256);
85     function transfer(address to, uint256 value) external returns (bool);
86     function approve(address spender, uint256 value) external returns (bool);
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 contract LuckyBucks is IERC20, Manageable {
94     using SafeMath for uint256;
95 
96     mapping (address => uint256) private _balances;
97     mapping (address => mapping (address => uint256)) private _allowed;
98 
99     uint256 private _totalSupply;
100 
101     string private _name;
102     string private _symbol;
103     uint8 private _decimals;
104 
105     constructor() public {
106         _name = "Lucky Bucks";
107         _symbol = "LBT";
108         _decimals = 18;
109         _totalSupply = 1000000000 * (uint(10) ** _decimals);
110 
111         _balances[0x3C5459BCDE2D5c1eDc4Cc6C6547d6cb360Ce5aE9] = _totalSupply;
112         emit Transfer(address(0), 0x3C5459BCDE2D5c1eDc4Cc6C6547d6cb360Ce5aE9, _totalSupply);
113     }
114 
115     /**
116      * @return the name of the token.
117      */
118     function name() public view returns (string memory) {
119         return _name;
120     }
121 
122     /**
123      * @return the symbol of the token.
124      */
125     function symbol() public view returns (string memory) {
126         return _symbol;
127     }
128 
129     /**
130      * @return the number of decimals of the token.
131      */
132     function decimals() public view returns (uint8) {
133         return _decimals;
134     }
135 
136     /**
137     * @dev Total number of tokens in existence
138     */
139     function totalSupply() public view returns (uint256) {
140         return _totalSupply;
141     }
142 
143     /**
144     * @dev Gets the balance of the specified address.
145     * @param owner The address to query the balance of.
146     * @return An uint256 representing the amount owned by the passed address.
147     */
148     function balanceOf(address owner) public view returns (uint256) {
149         return _balances[owner];
150     }
151 
152     /**
153      * @dev Function to check the amount of tokens that an owner allowed to a spender.
154      * @param owner address The address which owns the funds.
155      * @param spender address The address which will spend the funds.
156      * @return A uint256 specifying the amount of tokens still available for the spender.
157      */
158     function allowance(address owner, address spender) public view returns (uint256) {
159         return _allowed[owner][spender];
160     }
161 
162     /**
163     * @dev Transfer token for a specified address
164     * @param to The address to transfer to.
165     * @param value The amount to be transferred.
166     */
167     function transfer(address to, uint256 value) public returns (bool) {
168         _transfer(msg.sender, to, value);
169         return true;
170     }
171 
172     /**
173      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174      * Beware that changing an allowance with this method brings the risk that someone may use both the old
175      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      * @param spender The address which will spend the funds.
179      * @param value The amount of tokens to be spent.
180      */
181     function approve(address spender, uint256 value) public returns (bool) {
182         require(spender != address(0));
183 
184         _allowed[msg.sender][spender] = value;
185         emit Approval(msg.sender, spender, value);
186         return true;
187     }
188 
189     /**
190      * @dev Transfer tokens from one address to another.
191      * Note that while this function emits an Approval event, this is not required as per the specification,
192      * and other compliant implementations may not emit the event.
193      * @param from address The address which you want to send tokens from
194      * @param to address The address which you want to transfer to
195      * @param value uint256 the amount of tokens to be transferred
196      */
197     function transferFrom(address from, address to, uint256 value) public returns (bool) {
198         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199         _transfer(from, to, value);
200         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
201         return true;
202     }
203 
204     /**
205      * @dev Increase the amount of tokens that an owner allowed to a spender.
206      * approve should be called when allowed_[_spender] == 0. To increment
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO LuckyBucks.sol
210      * Emits an Approval event.
211      * @param spender The address which will spend the funds.
212      * @param addedValue The amount of tokens to increase the allowance by.
213      */
214     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
215         require(spender != address(0));
216 
217         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
218         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
219         return true;
220     }
221 
222     /**
223      * @dev Decrease the amount of tokens that an owner allowed to a spender.
224      * approve should be called when allowed_[_spender] == 0. To decrement
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO LuckyBucks.sol
228      * Emits an Approval event.
229      * @param spender The address which will spend the funds.
230      * @param subtractedValue The amount of tokens to decrease the allowance by.
231      */
232     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
233         require(spender != address(0));
234 
235         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
236         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Function to mint tokens
242      * @param to The address that will receive the minted tokens.
243      * @param value The amount of tokens to mint.
244      * @return A boolean that indicates if the operation was successful.
245      */
246     function mint(address to, uint256 value) public onlyManager returns (bool) {
247         _mint(to, value);
248         return true;
249     }
250 
251     /**
252     * @dev Transfer token for a specified addresses
253     * @param from The address to transfer from.
254     * @param to The address to transfer to.
255     * @param value The amount to be transferred.
256     */
257     function _transfer(address from, address to, uint256 value) internal {
258         require(to != address(0));
259 
260         _balances[from] = _balances[from].sub(value);
261         _balances[to] = _balances[to].add(value);
262         emit Transfer(from, to, value);
263     }
264 
265     /**
266      * @dev Internal function that mints an amount of the token and assigns it to
267      * an account. This encapsulates the modification of balances such that the
268      * proper events are emitted.
269      * @param account The account that will receive the created tokens.
270      * @param value The amount that will be created.
271      */
272     function _mint(address account, uint256 value) internal {
273         require(account != address(0));
274 
275         _totalSupply = _totalSupply.add(value);
276         _balances[account] = _balances[account].add(value);
277         emit Transfer(address(0), account, value);
278     }
279 
280     /**
281      * @dev Reclaim all ERC20Basic compatible tokens
282      * @param _token ERC20B The address of the token contract
283      */
284     function reclaimToken(IERC20 _token) external onlyOwner {
285         uint256 balance = _token.balanceOf(address(this));
286         _token.transfer(owner, balance);
287     }
288 }
289 
290 
291 /**
292  * @title SafeMath
293  * @dev Math operations with safety checks that throw on error
294  */
295 library SafeMath {
296 
297     /**
298     * @dev Multiplies two numbers, throws on overflow.
299     */
300     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
301         if (a == 0) {
302             return 0;
303         }
304         uint256 c = a * b;
305         assert(c / a == b);
306         return c;
307     }
308 
309     /**
310     * @dev Integer division of two numbers, truncating the quotient.
311     */
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         // assert(b > 0); // Solidity automatically throws when dividing by 0
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316         return c;
317     }
318 
319     /**
320     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
321     */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         assert(b <= a);
324         return a - b;
325     }
326 
327     /**
328     * @dev Adds two numbers, throws on overflow.
329     */
330     function add(uint256 a, uint256 b) internal pure returns (uint256) {
331         uint256 c = a + b;
332         assert(c >= a);
333         return c;
334     }
335 }