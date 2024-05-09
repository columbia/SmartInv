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
101 /**
102  * @title StandardToken
103  * 
104  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
105  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
106  * compliant implementations may not do it.
107  */
108 contract StandardToken is IEIPERC20, Ownable {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowed;
114 
115     uint256 private _totalSupply;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param owner The address to query the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param owner address The address which owns the funds.
136      * @param spender address The address which will spend the funds.
137      * @return A uint256 specifying the amount of tokens still available for the spender.
138      */
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowed[owner][spender];
141     }
142 
143     /**
144     * @dev Transfer token for a specified address
145     * @param to The address to transfer to.
146     * @param value The amount to be transferred.
147     */
148     function transfer(address to, uint256 value) public returns (bool) {
149         _transfer(msg.sender, to, value);
150         return true;
151     }
152 
153     /**
154      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param spender The address which will spend the funds.
160      * @param value The amount of tokens to be spent.
161      */
162     function approve(address spender, uint256 value) public returns (bool) {
163         require(spender != address(0));
164 
165         _allowed[msg.sender][spender] = value;
166         emit Approval(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
180         _transfer(from, to, value);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 }
249 
250 /**
251  *
252  *  VoyageToken Contract Requirement
253  *  •	Name: Voyage
254  *  •	Symbol: VOY
255  *  •	Decimal: 8
256  *  •	Total Supply: 35000000000 VOY（350亿）
257  ***/
258 contract VoyageToken is StandardToken {
259     string public name = "Voyage"; 
260     string public symbol = "VOY";
261     uint256 public decimals = 8;
262 
263     constructor(address owner) public {
264         _owner = owner;
265         uint256 totalSupply_ = 35000000000 * (10 ** decimals);
266         _mint(_owner, totalSupply_);
267     }
268 }