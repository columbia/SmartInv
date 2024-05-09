1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
10     */
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a);
13         uint256 c = a - b;
14 
15         return c;
16     }
17 
18     /**
19     * @dev Adds two numbers, reverts on overflow.
20     */
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a);
24 
25         return c;
26     }
27 }
28 
29 
30 /**
31  * @title ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 interface IEIPERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address who) external view returns (uint256);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function transfer(address to, uint256 value) external returns (bool);
42 
43     function approve(address spender, uint256 value) external returns (bool);
44 
45     function transferFrom(address from, address to, uint256 value) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59 
60     address internal _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @return the address of the owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == _owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to relinquish control of the contract.
81      * @notice Renouncing to ownership will leave the contract without an owner.
82      * It will not be possible to call the functions with the `onlyOwner`
83      * modifier anymore.
84      */
85     function renounceOwnership() public onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Allows the current owner to transfer control of the contract to a newOwner.
92      * @param newOwner The address to transfer ownership to.
93      */
94     function transferOwnership(address newOwner) public onlyOwner {
95         require(newOwner != address(0));
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 
103 /**
104  * @title ExtensionToken token
105  * 
106  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
107  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
108  * compliant implementations may not do it.
109  */
110 contract ExtensionToken is IEIPERC20,Ownable  {
111     using SafeMath for uint256;
112 
113     mapping (address => uint256) private _balances;
114 
115     mapping (address => mapping (address => uint256)) private _allowed;
116 
117     uint256 private _totalSupply;
118 
119     /**
120     * @dev Total number of tokens in existence
121     */
122     function totalSupply() public view returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param owner The address to query the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address owner) public view returns (uint256) {
132         return _balances[owner];
133     }
134 
135     /**
136      * @dev Function to check the amount of tokens that an owner allowed to a spender.
137      * @param owner address The address which owns the funds.
138      * @param spender address The address which will spend the funds.
139      * @return A uint256 specifying the amount of tokens still available for the spender.
140      */
141     function allowance(address owner, address spender) public view returns (uint256) {
142         return _allowed[owner][spender];
143     }
144 
145     /**
146     * @dev Transfer token for a specified address
147     * @param to The address to transfer to.
148     * @param value The amount to be transferred.
149     */
150     function transfer(address to, uint256 value) public returns (bool) {
151         _transfer(msg.sender, to, value);
152         return true;
153     }
154 
155     /**
156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      * Beware that changing an allowance with this method brings the risk that someone may use both the old
158      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      * @param spender The address which will spend the funds.
162      * @param value The amount of tokens to be spent.
163      */
164     function approve(address spender, uint256 value) public returns (bool) {
165         require(spender != address(0));
166 
167         _allowed[msg.sender][spender] = value;
168         emit Approval(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
182         _transfer(from, to, value);
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when allowed_[_spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         require(spender != address(0));
198 
199         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
200         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
201         return true;
202     }
203 
204     /**
205      * @dev Decrease the amount of tokens that an owner allowed to a spender.
206      * approve should be called when allowed_[_spender] == 0. To decrement
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      * Emits an Approval event.
211      * @param spender The address which will spend the funds.
212      * @param subtractedValue The amount of tokens to decrease the allowance by.
213      */
214     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
215         require(spender != address(0));
216 
217         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
218         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
219         return true;
220     }
221 
222     /**
223     * @dev Transfer token for a specified addresses
224     * @param from The address to transfer from.
225     * @param to The address to transfer to.
226     * @param value The amount to be transferred.
227     */
228     function _transfer(address from, address to, uint256 value) internal {
229         require(to != address(0));
230 
231         _balances[from] = _balances[from].sub(value);
232         _balances[to] = _balances[to].add(value);
233         emit Transfer(from, to, value);
234     }
235 
236     /**
237      * @dev Internal function that mints an amount of the token and assigns it to
238      * an account. This encapsulates the modification of balances such that the
239      * proper events are emitted.
240      * @param account The account that will receive the created tokens.
241      * @param value The amount that will be created.
242      */
243     function _mint(address account, uint256 value) internal {
244         require(account != address(0));
245 
246         _totalSupply = _totalSupply.add(value);
247         _balances[account] = _balances[account].add(value);
248         emit Transfer(address(0), account, value);
249     }
250 }
251 
252 
253 contract CompassToken is ExtensionToken {
254     string public name = "CompassToken"; 
255     string public symbol = "CT";
256     uint256 public decimals = 18;
257 
258     constructor(address owner) public {
259         _owner = owner;
260         
261         uint256 totalSupply_ = 10000000000 * (10 ** decimals);
262         _mint(_owner, totalSupply_);
263     }
264 }