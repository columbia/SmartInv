1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10     * @dev Multiplies two unsigned integers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0);
28         uint256 c = a / b;
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 interface ERC20 {
69     function transfer(address to, uint256 value) external returns (bool);
70 
71     function approve(address spender, uint256 value) external returns (bool);
72 
73     function transferFrom(address from, address to, uint256 value) external returns (bool);
74 
75     function totalSupply() external view returns (uint256);
76 
77     function balanceOf(address who) external view returns (uint256);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 /**
88  * @title XPN ERC20 token
89  */
90 contract XPN is ERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowed;
96 
97     string public name = "PANTHEON X TOKEN";
98 
99     string public symbol = "XPN";
100 
101     uint public decimals = 18;
102 
103     uint256 private _totalSupply = 800000000 * 10 ** decimals;
104 
105     constructor() public {
106         _balances[msg.sender] = _totalSupply;
107     }
108 
109     /**
110     * @dev Total number of tokens in existence
111     */
112     function totalSupply() public view returns (uint256) {
113         return _totalSupply;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param owner The address to query the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address owner) public view returns (uint256) {
122         return _balances[owner];
123     }
124 
125     /**
126      * @dev Function to check the amount of tokens that an owner allowed to a spender.
127      * @param owner address The address which owns the funds.
128      * @param spender address The address which will spend the funds.
129      * @return A uint256 specifying the amount of tokens still available for the spender.
130      */
131     function allowance(address owner, address spender) public view returns (uint256) {
132         return _allowed[owner][spender];
133     }
134 
135     /**
136     * @dev Transfer token for a specified address
137     * @param to The address to transfer to.
138     * @param value The amount to be transferred.
139     */
140     function transfer(address to, uint256 value) public returns (bool) {
141         _transfer(msg.sender, to, value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      * Beware that changing an allowance with this method brings the risk that someone may use both the old
148      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      * @param spender The address which will spend the funds.
152      * @param value The amount of tokens to be spent.
153      */
154     function approve(address spender, uint256 value) public returns (bool) {
155         require(spender != address(0));
156 
157         _allowed[msg.sender][spender] = value;
158         emit Approval(msg.sender, spender, value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another.
164      * Note that while this function emits an Approval event, this is not required as per the specification,
165      * and other compliant implementations may not emit the event.
166      * @param from address The address which you want to send tokens from
167      * @param to address The address which you want to transfer to
168      * @param value uint256 the amount of tokens to be transferred
169      */
170     function transferFrom(address from, address to, uint256 value) public returns (bool) {
171         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
172         _transfer(from, to, value);
173         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when allowed_[_spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         require(spender != address(0));
189 
190         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
191         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
192         return true;
193     }
194 
195     /**
196      * @dev Decrease the amount of tokens that an owner allowed to a spender.
197      * approve should be called when allowed_[_spender] == 0. To decrement
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * Emits an Approval event.
202      * @param spender The address which will spend the funds.
203      * @param subtractedValue The amount of tokens to decrease the allowance by.
204      */
205     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
206         require(spender != address(0));
207 
208         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
209         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
210         return true;
211     }
212 
213     /**
214      * @dev Burns a specific amount of tokens.
215      * @param value The amount of token to be burned.
216      */
217     function burn(uint256 value) public {
218         _burn(msg.sender, value);
219     }
220 
221     /**
222      * @dev Burns a specific amount of tokens from the target address and decrements allowance
223      * @param from address The address which you want to send tokens from
224      * @param value uint256 The amount of token to be burned
225      */
226     function burnFrom(address from, uint256 value) public {
227         _burnFrom(from, value);
228     }
229 
230     /**
231     * @dev Transfer token for a specified addresses
232     * @param from The address to transfer from.
233     * @param to The address to transfer to.
234     * @param value The amount to be transferred.
235     */
236     function _transfer(address from, address to, uint256 value) internal {
237         require(to != address(0));
238 
239         _balances[from] = _balances[from].sub(value);
240         _balances[to] = _balances[to].add(value);
241         emit Transfer(from, to, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * Emits an Approval event (reflecting the reduced allowance).
263      * @param account The account whose tokens will be burnt.
264      * @param value The amount that will be burnt.
265      */
266     function _burnFrom(address account, uint256 value) internal {
267         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
268         _burn(account, value);
269         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
270     }
271 }