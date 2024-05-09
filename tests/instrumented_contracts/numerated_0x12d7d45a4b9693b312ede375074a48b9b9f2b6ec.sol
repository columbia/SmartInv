1 pragma solidity >=0.4.22 <0.6.0;
2 /**
3  * @title ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/20
5  */
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address who) external view returns (uint256);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     /**
26     * @dev Multiplies two numbers, reverts on overflow.
27     */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30         // benefit is lost if 'b' is also tested.
31         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         require(c / a == b);
38 
39         return c;
40     }
41 
42     /**
43     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
44     */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51         return c;
52     }
53 
54     /**
55     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56     */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b <= a);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65     * @dev Adds two numbers, reverts on overflow.
66     */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a);
70 
71         return c;
72     }
73 
74     /**
75     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
76     * reverts when dividing by zero.
77     */
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b != 0);
80         return a % b;
81     }
82 }
83 
84 library Roles {
85     struct Role {
86         mapping (address => bool) bearer;
87     }
88 
89     /**
90      * @dev give an account access to this role
91      */
92     function add(Role storage role, address account) internal {
93         require(account != address(0));
94         require(!has(role, account));
95 
96         role.bearer[account] = true;
97     }
98 
99     /**
100      * @dev remove an account's access to this role
101      */
102     function remove(Role storage role, address account) internal {
103         require(account != address(0));
104         require(has(role, account));
105 
106         role.bearer[account] = false;
107     }
108 
109     /**
110      * @dev check if an account has this role
111      * @return bool
112      */
113     function has(Role storage role, address account) internal view returns (bool) {
114         require(account != address(0));
115         return role.bearer[account];
116     }
117 }
118 
119 contract Ownable {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
126      * account.
127      */
128     constructor () internal {
129         _owner = msg.sender;
130         emit OwnershipTransferred(address(0), _owner);
131     }
132 
133     /**
134      * @return the address of the owner.
135      */
136     function owner() public view returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(isOwner());
145         _;
146     }
147 
148     /**
149      * @return true if `msg.sender` is the owner of the contract.
150      */
151     function isOwner() public view returns (bool) {
152         return msg.sender == _owner;
153     }
154 
155     /**
156      * @dev Allows the current owner to relinquish control of the contract.
157      * @notice Renouncing to ownership will leave the contract without an owner.
158      * It will not be possible to call the functions with the `onlyOwner`
159      * modifier anymore.
160      */
161     function renounceOwnership() public onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     /**
167      * @dev Allows the current owner to transfer control of the contract to a newOwner.
168      * @param newOwner The address to transfer ownership to.
169      */
170     function transferOwnership(address newOwner) public onlyOwner {
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers control of the contract to a newOwner.
176      * @param newOwner The address to transfer ownership to.
177      */
178     function _transferOwnership(address newOwner) internal {
179         require(newOwner != address(0));
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 contract VIDERC20 is IERC20, Ownable {
186 
187     using SafeMath for uint256;
188 
189     mapping (address => uint256) private _balances;
190 
191     mapping (address => mapping (address => uint256)) private _allowed;
192 
193     uint256 public sellPrice;
194     uint256 public buyPrice;
195 
196     // Public variables of the token
197     string public name = "VID";
198     string public symbol = "VID";
199     uint8 public decimals = 5;
200     uint256 private _totalSupply;
201     uint256 public constant initialSupply = 62500000000000;
202 
203     constructor () public {
204           _totalSupply = initialSupply;
205           _balances[msg.sender] = initialSupply;
206     }
207 
208     /**
209     * @dev Total number of tokens in existence
210     */
211     function totalSupply() public view returns (uint256) {
212         return _totalSupply;
213     }
214 
215     /**
216     * @dev Gets the balance of the specified address.
217     * @param owner The address to query the balance of.
218     * @return An uint256 representing the amount owned by the passed address.
219     */
220     function balanceOf(address owner) public view returns (uint256) {
221         return _balances[owner];
222     }
223 
224     /**
225      * @dev Function to check the amount of tokens that an owner allowed to a spender.
226      * @param owner address The address which owns the funds.
227      * @param spender address The address which will spend the funds.
228      * @return A uint256 specifying the amount of tokens still available for the spender.
229      */
230     function allowance(address owner, address spender) public view returns (uint256) {
231         return _allowed[owner][spender];
232     }
233 
234     /**
235     * @dev Transfer token for a specified address
236     * @param to The address to transfer to.
237     * @param value The amount to be transferred.
238     */
239     function transfer(address to, uint256 value) public returns (bool) {
240         _transfer(msg.sender, to, value);
241         return true;
242     }
243 
244     /**
245      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246      * Beware that changing an allowance with this method brings the risk that someone may use both the old
247      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      * @param spender The address which will spend the funds.
251      * @param value The amount of tokens to be spent.
252      */
253     function approve(address spender, uint256 value) public returns (bool) {
254         require(spender != address(0));
255 
256         _allowed[msg.sender][spender] = value;
257         emit Approval(msg.sender, spender, value);
258         return true;
259     }
260 
261     /**
262      * @dev Transfer tokens from one address to another.
263      * Note that while this function emits an Approval event, this is not required as per the specification,
264      * and other compliant implementations may not emit the event.
265      * @param from address The address which you want to send tokens from
266      * @param to address The address which you want to transfer to
267      * @param value uint256 the amount of tokens to be transferred
268      */
269     function transferFrom(address from, address to, uint256 value) public returns (bool) {
270         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
271         _transfer(from, to, value);
272         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
273         return true;
274     }
275 
276     /**
277     * @dev Transfer token for a specified addresses
278     * @param from The address to transfer from.
279     * @param to The address to transfer to.
280     * @param value The amount to be transferred.
281     */
282     function _transfer(address from, address to, uint256 value) internal {
283         require(to != address(0));
284 
285         _balances[from] = _balances[from].sub(value);
286         _balances[to] = _balances[to].add(value);
287         emit Transfer(from, to, value);
288     }
289 
290 }