1 pragma solidity ^0.5.2;
2 /**
3 * @title ERC20 interface 
4 * @dev see https://eips.ethereum.org/EIPS/eip-20 
5 */
6 interface IERC20 { 
7     function transfer(address to, uint256 value) external returns (bool); 
8     
9     function approve(address spender, uint256 value) external returns (bool); 
10     
11     function transferFrom(address from, address to, uint256 value) external returns (bool); 
12     
13     function totalSupply() external view returns (uint256); 
14     
15     function balanceOf(address who) external view returns (uint256); 
16     
17     function allowance(address owner, address spender) external view returns (uint256); 
18     
19     event Transfer(address indexed from, address indexed to, uint256 value); 
20     
21     event Approval(address indexed owner, address indexed spender, uint256 value); 
22 }
23 
24 /**
25 * @title SafeMath 
26 * @dev Unsigned math operations with safety checks that revert on error
27 */
28 library SafeMath { 
29     /**
30     * @dev Multiplies two unsigned integers, reverts on overflow. 
31     */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) { 
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the 
34         // benefit is lost if 'b' is also tested. 
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522 
36         if (a == 0) { 
37             return 0;
38         }
39         uint256 c = a * b; 
40         require(c / a == b); 
41         return c; 
42     }
43     /**
44     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero. 
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) 
47     {
48         // Solidity only automatically asserts when dividing by 0 
49         require(b > 0); 
50         uint256 c = a / b; 
51         //assert(a == b * c + a % b); //There is no case in which this doesn't hold 
52         return c; 
53     }
54     /**
55     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend). 
56     */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
58     { 
59         require(b <= a); 
60         uint256 c = a - b; 
61         return c; 
62     }
63     /**
64     * @dev Adds two unsigned integers, reverts on overflow. 
65     */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) 
67     { 
68         uint256 c = a + b; 
69         require(c >= a); 
70         return c; 
71     }
72     /**
73     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo), 
74     * reverts when dividing by zero. 
75     */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) 
77     { 
78         require(b != 0); 
79         return a % b; 
80     }
81 }
82 
83 /**
84 * @title Standard ERC20 token *
85 * @dev Implementation of the basic standard token. 
86 * https://eips.ethereum.org/EIPS/eip-20 
87 * Originally based on code by FirstBlood: 
88 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
89 *
90 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for 
91 * all accounts just by listening to said events. Note that this isn't required by the specification, and other 
92 * compliant implementations may not do it. 
93 */
94 contract HALE is IERC20 {
95     using SafeMath for uint256;//通过这种方式应用 SafeMath 更方便
96 
97     string private _name; 
98     string private _symbol; 
99     uint8 private _decimals; 
100 
101     mapping (address => uint256) private _balances; 
102     mapping (address => mapping (address => uint256)) private _allowed; 
103     uint256 private _totalSupply;
104 
105     //使用构造函数初始化操作
106     constructor( uint256 initialSupply, string memory tokenName, uint8 decimalUnits, string memory tokenSymbol ) public 
107     { 
108         _balances[msg.sender] = initialSupply; 
109         // Give the creator all initial tokens 
110         _totalSupply = initialSupply; 
111         // Update total supply 
112         _name = tokenName; 
113         // Set the name for display purposes 
114         _symbol = tokenSymbol; 
115         // Set the symbol for display purposes 
116         _decimals = decimalUnits; 
117         // Amount of decimals for display purposes 
118     }
119 
120     /**
121     * @dev Name of tokens in existence 
122     */
123     function name() public view returns (string memory) 
124     { 
125         return _name; 
126     }
127 
128     /**
129     * @dev Symbol of tokens in existence 
130     */
131     function symbol() public view returns (string memory) 
132     { 
133         return _symbol; 
134     }
135 
136     /**
137     * @dev decimals of tokens in existence 
138     */
139     function decimals() public view returns (uint8) 
140     { 
141         return _decimals; 
142     }
143 
144     /**
145     * @dev Total number of tokens in existence 
146     */
147     function totalSupply() public view returns (uint256) 
148     { 
149         return _totalSupply; 
150     }
151 
152     /**
153     * @dev Gets the balance of the specified address. 
154     * @param owner The address to query the balance of. 
155     * @return A uint256 representing the amount owned by the passed address. 
156     */
157     function balanceOf(address owner) public view returns (uint256) 
158     { 
159         return _balances[owner]; 
160     }
161 
162     /**
163     * @dev Function to check the amount of tokens that an owner allowed to a spender. 
164     * @param owner address The address which owns the funds. 
165     * @param spender address The address which will spend the funds. 
166     * @return A uint256 specifying the amount of tokens still available for the spender. 
167     */
168     function allowance(address owner, address spender) public view returns (uint256) 
169     { 
170         return _allowed[owner][spender]; 
171     }
172 
173     /**
174     * @dev Transfer token to a specified address 
175     * @param to The address to transfer to. 
176     * @param value The amount to be transferred. 
177     */
178     function transfer(address to, uint256 value) public returns (bool) 
179     { 
180         _transfer(msg.sender, to, value); 
181         return true; 
182     }
183 
184     /**
185     * @dev Burns a specific amount of tokens. * @param value The amount of token to be burned. 
186     */
187     function burn(uint256 value) public 
188     { 
189         _burn(msg.sender, value); 
190     }
191 
192     /**
193     * @dev Burns a specific amount of tokens from the target address and decrements allowance 
194     * @param from address The account whose tokens will be burned. 
195     * @param value uint256 The amount of token to be burned. 
196     */
197     function burnFrom(address from, uint256 value) public 
198     { 
199         _burnFrom(from, value); 
200     }
201 
202     /**
203     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
204     * Beware that changing an allowance with this method brings the risk that someone may use both the old 
205     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
206     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
207     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
208     * @param spender The address which will spend the funds. 
209     * @param value The amount of tokens to be spent. 
210     */
211     function approve(address spender, uint256 value) public returns (bool) 
212     { 
213         _approve(msg.sender, spender, value); 
214         return true; 
215     }
216 
217     /**
218     * @dev Transfer tokens from one address to another. 
219     * Note that while this function emits an Approval event, this is not required as per the specification, 
220     * and other compliant implementations may not emit the event. 
221     * @param from address The address which you want to send tokens from 
222     * @param to address The address which you want to transfer to 
223     * @param value uint256 the amount of tokens to be transferred 
224     */
225     function transferFrom(address from, address to, uint256 value) public returns (bool) 
226     { 
227         _transfer(from, to, value); 
228         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value)); 
229         return true; 
230     }
231 
232     /**
233     * @dev Increase the amount of tokens that an owner allowed to a spender. 
234     * approve should be called when _allowed[msg.sender][spender] == 0. To increment 
235     * allowed value is better to use this function to avoid 2 calls (and wait until 
236     * the first transaction is mined) 
237     * From MonolithDAO Token.sol 
238     * Emits an Approval event. 
239     * @param spender The address which will spend the funds. 
240     * @param addedValue The amount of tokens to increase the allowance by. 
241     */
242     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
243     { 
244         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue)); 
245         return true; 
246     }
247 
248     /**
249     * @dev Decrease the amount of tokens that an owner allowed to a spender. 
250     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement 
251     * allowed value is better to use this function to avoid 2 calls (and wait until 
252     * the first transaction is mined) 
253     * From MonolithDAO Token.sol * Emits an Approval event.
254     * @param spender The address which will spend the funds. 
255     * @param subtractedValue The amount of tokens to decrease the allowance by. 
256     */
257     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
258     { 
259         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue)); 
260         return true; 
261     }
262 
263     /**
264     * @dev Transfer token for a specified addresses 
265     * @param from The address to transfer from. 
266     * @param to The address to transfer to. 
267     * @param value The amount to be transferred. 
268     */
269     function _transfer(address from, address to, uint256 value) internal 
270     { 
271         require(to != address(0));
272         //检查地址是否为空 
273         _balances[from] = _balances[from].sub(value);
274         //先减后加，符合推荐操作，使用 SafeMath 函数进行数值运算操作，符合规范
275         _balances[to] = _balances[to].add(value); 
276         emit Transfer(from, to, value); 
277     }
278     
279     /**
280     * @dev Internal function that burns an amount of the token of a given 
281     * account. 
282     * @param account The account whose tokens will be burnt. 
283     * @param value The amount that will be burnt. 
284     */
285     function _burn(address account, uint256 value) internal 
286     { 
287         require(account != address(0));
288         //检查地址是否为空
289         _totalSupply = _totalSupply.sub(value);
290         _balances[account] = _balances[account].sub(value);
291         emit Transfer(account, address(0), value);
292     }
293 
294     /**
295     * @dev Approve an address to spend another addresses' tokens. 
296     * @param owner The address that owns the tokens. 
297     * @param spender The address that will spend the tokens. 
298     * @param value The number of tokens that can be spent. 
299     */
300     function _approve(address owner, address spender, uint256 value) internal 
301     { 
302         require(spender != address(0));
303         //检查地址是否为空 
304         require(owner != address(0));
305         //检查地址是否为空
306         //此处存在事务顺序依赖风险，建议增加以下语句防止
307         require(value == 0 || (_allowed[owner][spender] == 0));
308         _allowed[owner][spender] = value; 
309         emit Approval(owner, spender, value); 
310     }
311     /**
312     * @dev Internal function that burns an amount of the token of a given 
313     * account, deducting from the sender's allowance for said account. Uses the 
314     * internal burn function. 
315     * Emits an Approval event (reflecting the reduced allowance). 
316     * @param account The account whose tokens will be burnt. 
317     * @param value The amount that will be burnt. 
318     */
319     function _burnFrom(address account, uint256 value) internal 
320     { 
321         _burn(account, value); 
322         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value)); 
323     }
324 }