1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         c = a * b;
17         require(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // require(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         require(c >= a);
45         return c;
46     }
47 }
48 
49 library Address {
50 
51     /**
52      * @dev Returns true if `account` is a contract.
53      *
54      * This test is non-exhaustive, and there may be false-negatives: during the
55      * execution of a contract's constructor, its address will be reported as
56      * not containing a contract.
57      *
58      * > It is unsafe to assume that an address for which this function returns
59      * false is an externally-owned account (EOA) and not a contract.
60      */
61     function isContract(address account) internal view returns (bool) {
62         // This method relies in extcodesize, which returns 0 for contracts in
63         // construction, since the code is only stored at the end of the
64         // constructor execution.
65 
66         uint256 size;
67         // solhint-disable-next-line no-inline-assembly
68         assembly { size := extcodesize(account) }
69         return size > 0;
70     }
71 }
72 
73 contract IERC20Receiver {
74 
75     function onERC20Received(address from, uint256 value) public returns (bytes4);
76 
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://eips.ethereum.org/EIPS/eip-20
82  */
83 interface IERC20 {
84 
85     function transfer(address to, uint256 value) public returns (bool);
86 
87     function approve(address spender, uint256 value) public returns (bool);
88 
89     function transferFrom(address from, address to, uint256 value) public returns (bool);
90 
91     function totalSupply() public view returns (uint256);
92 
93     function balanceOf(address who) public view returns (uint256);
94 
95     function allowance(address owner, address spender) public view returns (uint256);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://eips.ethereum.org/EIPS/eip-20
107  * Originally based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  *
110  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
111  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
112  * compliant implementations may not do it.
113  */
114 
115 contract ERC20 is IERC20 {
116 
117     using SafeMath for uint256;
118     using Address for address;
119 
120     mapping(address => uint256) internal _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowed;
123 
124     uint256 internal _totalSupply;
125 
126     /**
127      * @dev Total number of tokens in existence.
128      */
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     /**
134      * @dev Gets the balance of the specified address.
135      * @param owner The address to query the balance of.
136      * @return A uint256 representing the amount owned by the passed address.
137      */
138     function balanceOf(address owner) public view returns (uint256) {
139         return _balances[owner];
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param owner address The address which owns the funds.
145      * @param spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address owner, address spender) public view returns (uint256) {
149         return _allowed[owner][spender];
150     }
151 
152     /**
153      * @dev Transfer token to a specified address.
154      * @param to The address to transfer to.
155      * @param value The amount to be transferred.
156      */
157     function transfer(address to, uint256 value) public returns (bool) {
158         _transfer(msg.sender, to, value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param spender The address which will spend the funds.
169      * @param value The amount of tokens to be spent.
170      */
171     function approve(address spender, uint256 value) public returns (bool) {
172         _approve(msg.sender, spender, value);
173         return true;
174     }
175 
176     /**
177      * @dev Transfer tokens from one address to another.
178      * Note that while this function emits an Approval event, this is not required as per the specification,
179      * and other compliant implementations may not emit the event.
180      * @param from address The address which you want to send tokens from
181      * @param to address The address which you want to transfer to
182      * @param value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address from, address to, uint256 value) public returns (bool) {
185         _transfer(from, to, value);
186         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
202         return true;
203     }
204 
205     /**
206      * @dev Decrease the amount of tokens that an owner allowed to a spender.
207      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      * Emits an Approval event.
212      * @param spender The address which will spend the funds.
213      * @param subtractedValue The amount of tokens to decrease the allowance by.
214      */
215     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
216         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
217         return true;
218     }
219 
220     /**
221      * @dev Transfer token for a specified addresses.
222      * @param from The address to transfer from.
223      * @param to The address to transfer to.
224      * @param value The amount to be transferred.
225      */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228         _balances[from] = _balances[from].sub(value);
229         _balances[to] = _balances[to].add(value);
230         if (to.isContract()) {
231             IERC20Receiver(to).onERC20Received(from, value);
232         }
233         emit Transfer(from, to, value);
234     }
235 
236     /**
237      * @dev Internal function that burns an amount of the token of a given
238      * account.
239      * @param account The account whose tokens will be burnt.
240      * @param value The amount that will be burnt.
241      */
242     function _burn(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.sub(value);
246         _balances[account] = _balances[account].sub(value);
247         emit Transfer(account, address(0), value);
248     }
249 
250     function burn(uint256 value) public {
251         _burn(msg.sender, value);
252     }
253 
254     /**
255      * @dev Approve an address to spend another addresses' tokens.
256      * @param owner The address that owns the tokens.
257      * @param spender The address that will spend the tokens.
258      * @param value The number of tokens that can be spent.
259      */
260     function _approve(address owner, address spender, uint256 value) internal {
261         require(spender != address(0));
262         require(owner != address(0));
263 
264         _allowed[owner][spender] = value;
265         emit Approval(owner, spender, value);
266     }
267 
268     /**
269      * @dev Internal function that burns an amount of the token of a given
270      * account, deducting from the sender's allowance for said account. Uses the
271      * internal burn function.
272      * Emits an Approval event (reflecting the reduced allowance).
273      * @param account The account whose tokens will be burnt.
274      * @param value The amount that will be burnt.
275      */
276     function _burnFrom(address account, uint256 value) internal {
277         _burn(account, value);
278         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
279     }
280 }
281 
282 contract APT is ERC20 {
283 
284     string public name;
285     string public symbol;
286     uint8 public decimals;
287     address public owner;
288 
289     /**
290         * @dev Constructor function
291     */
292 
293     constructor (string _name, string _symbol, uint8 _decimals, uint256 totalSupply) public {
294         owner = msg.sender;
295         name = _name;
296         symbol = _symbol;
297         decimals = _decimals;
298         _totalSupply = totalSupply;
299         _balances[msg.sender] = totalSupply;
300     }
301 }