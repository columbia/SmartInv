1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  *
96  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
97  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
98  * compliant implementations may not do it.
99  */
100 contract ERC20 is IERC20 {
101     using SafeMath for uint256;
102 
103     mapping (address => uint256) private _balances;
104 
105     mapping (address => mapping (address => uint256)) private _allowed;
106 
107     uint256 private _totalSupply;
108     
109     string public constant name = "AlexCoin";
110     
111     string public constant symbol = "ABC";
112     
113     uint8 public constant decimals = 0;
114 
115     /**
116      * @dev distribute initial tokens
117      */
118     constructor() public {
119         _balances[msg.sender] = 128;
120         _totalSupply = 128;
121         emit Transfer(address(0), msg.sender, _totalSupply);
122     }
123 
124     /**
125     * @dev Total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return _totalSupply;
129     }
130 
131     /**
132     * @dev Gets the balance of the specified address.
133     * @param owner The address to query the balance of.
134     * @return An uint256 representing the amount owned by the passed address.
135     */
136     function balanceOf(address owner) public view returns (uint256) {
137         return _balances[owner];
138     }
139 
140     /**
141      * @dev Function to check the amount of tokens that an owner allowed to a spender.
142      * @param owner address The address which owns the funds.
143      * @param spender address The address which will spend the funds.
144      * @return A uint256 specifying the amount of tokens still available for the spender.
145      */
146     function allowance(address owner, address spender) public view returns (uint256) {
147         return _allowed[owner][spender];
148     }
149 
150     /**
151     * @dev Transfer token for a specified address
152     * @param to The address to transfer to.
153     * @param value The amount to be transferred.
154     */
155     function transfer(address to, uint256 value) public returns (bool) {
156         _transfer(msg.sender, to, value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      * Beware that changing an allowance with this method brings the risk that someone may use both the old
163      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      * @param spender The address which will spend the funds.
167      * @param value The amount of tokens to be spent.
168      */
169     function approve(address spender, uint256 value) public returns (bool) {
170         require(spender != address(0));
171 
172         _allowed[msg.sender][spender] = value;
173         emit Approval(msg.sender, spender, value);
174         return true;
175     }
176 
177     /**
178      * @dev Transfer tokens from one address to another.
179      * Note that while this function emits an Approval event, this is not required as per the specification,
180      * and other compliant implementations may not emit the event.
181      * @param from address The address which you want to send tokens from
182      * @param to address The address which you want to transfer to
183      * @param value uint256 the amount of tokens to be transferred
184      */
185     function transferFrom(address from, address to, uint256 value) public returns (bool) {
186         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
187         _transfer(from, to, value);
188         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
189         return true;
190     }
191 
192     /**
193      * @dev Increase the amount of tokens that an owner allowed to a spender.
194      * approve should be called when allowed_[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * Emits an Approval event.
199      * @param spender The address which will spend the funds.
200      * @param addedValue The amount of tokens to increase the allowance by.
201      */
202     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
203         require(spender != address(0));
204 
205         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
206         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
207         return true;
208     }
209 
210     /**
211      * @dev Decrease the amount of tokens that an owner allowed to a spender.
212      * approve should be called when allowed_[_spender] == 0. To decrement
213      * allowed value is better to use this function to avoid 2 calls (and wait until
214      * the first transaction is mined)
215      * From MonolithDAO Token.sol
216      * Emits an Approval event.
217      * @param spender The address which will spend the funds.
218      * @param subtractedValue The amount of tokens to decrease the allowance by.
219      */
220     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
221         require(spender != address(0));
222 
223         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
224         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
225         return true;
226     }
227 
228     /**
229     * @dev Transfer token for a specified addresses
230     * @param from The address to transfer from.
231     * @param to The address to transfer to.
232     * @param value The amount to be transferred.
233     */
234     function _transfer(address from, address to, uint256 value) internal {
235         require(to != address(0));
236 
237         _balances[from] = _balances[from].sub(value);
238         _balances[to] = _balances[to].add(value);
239         emit Transfer(from, to, value);
240     }
241 
242     /**
243      * @dev Internal function that burns an amount of the token of a given
244      * account.
245      * @param account The account whose tokens will be burnt.
246      * @param value The amount that will be burnt.
247      */
248     function _burn(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.sub(value);
252         _balances[account] = _balances[account].sub(value);
253         emit Transfer(account, address(0), value);
254     }
255 
256     /**
257      * @dev Internal function that burns an amount of the token of a given
258      * account, deducting from the sender's allowance for said account. Uses the
259      * internal burn function.
260      * Emits an Approval event (reflecting the reduced allowance).
261      * @param account The account whose tokens will be burnt.
262      * @param value The amount that will be burnt.
263      */
264     function _burnFrom(address account, uint256 value) internal {
265         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
266         _burn(account, value);
267         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
268     }
269 }