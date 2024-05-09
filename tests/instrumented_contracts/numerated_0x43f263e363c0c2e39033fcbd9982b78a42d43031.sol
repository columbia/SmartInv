1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-23
3 */
4 
5 pragma solidity ^0.5.2;
6 /**
7 * @title ERC20 interface 
8 * @dev see https://eips.ethereum.org/EIPS/eip-20 
9 */
10 interface IERC20 { 
11     function transfer(address to, uint256 value) external returns (bool); 
12     
13     function approve(address spender, uint256 value) external returns (bool); 
14     
15     function transferFrom(address from, address to, uint256 value) external returns (bool); 
16     
17     function totalSupply() external view returns (uint256); 
18     
19     function balanceOf(address who) external view returns (uint256); 
20     
21     function allowance(address owner, address spender) external view returns (uint256); 
22     
23     event Transfer(address indexed from, address indexed to, uint256 value); 
24     
25     event Approval(address indexed owner, address indexed spender, uint256 value); 
26 }
27 
28 /**
29 * @title SafeMath 
30 * @dev Unsigned math operations with safety checks that revert on error
31 */
32 library SafeMath { 
33     /**
34     * @dev Multiplies two unsigned integers, reverts on overflow. 
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) { 
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the 
38         // benefit is lost if 'b' is also tested. 
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522 
40         if (a == 0) { 
41             return 0;
42         }
43         uint256 c = a * b; 
44         require(c / a == b); 
45         return c; 
46     }
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero. 
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) 
51     {
52         // Solidity only automatically asserts when dividing by 0 
53         require(b > 0); 
54         uint256 c = a / b; 
55         //assert(a == b * c + a % b); //There is no case in which this doesn't hold 
56         return c; 
57     }
58     /**
59     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend). 
60     */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
62     { 
63         require(b <= a); 
64         uint256 c = a - b; 
65         return c; 
66     }
67     /**
68     * @dev Adds two unsigned integers, reverts on overflow. 
69     */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) 
71     { 
72         uint256 c = a + b; 
73         require(c >= a); 
74         return c; 
75     }
76     /**
77     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo), 
78     * reverts when dividing by zero. 
79     */
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) 
81     { 
82         require(b != 0); 
83         return a % b; 
84     }
85 }
86 
87 /**
88 * @title Standard ERC20 token *
89 * @dev Implementation of the basic standard token. 
90 * https://eips.ethereum.org/EIPS/eip-20 
91 * Originally based on code by FirstBlood: 
92 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
93 *
94 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for 
95 * all accounts just by listening to said events. Note that this isn't required by the specification, and other 
96 * compliant implementations may not do it. 
97 */
98 contract HALE is IERC20 {
99     using SafeMath for uint256;
100 
101     string private _name; 
102     string private _symbol; 
103     uint8 private _decimals; 
104 
105     mapping (address => uint256) private _balances; 
106     mapping (address => mapping (address => uint256)) private _allowed; 
107     uint256 private _totalSupply;
108 
109     constructor( uint256 initialSupply, string memory tokenName, uint8 decimalUnits, string memory tokenSymbol ) public 
110     { 
111         _balances[msg.sender] = initialSupply; 
112         // Give the creator all initial tokens 
113         _totalSupply = initialSupply; 
114         // Update total supply 
115         _name = tokenName; 
116         // Set the name for display purposes 
117         _symbol = tokenSymbol; 
118         // Set the symbol for display purposes 
119         _decimals = decimalUnits; 
120         // Amount of decimals for display purposes 
121     }
122 
123     /**
124     * @dev Name of tokens in existence 
125     */
126     function name() public view returns (string memory) 
127     { 
128         return _name; 
129     }
130 
131     /**
132     * @dev Symbol of tokens in existence 
133     */
134     function symbol() public view returns (string memory) 
135     { 
136         return _symbol; 
137     }
138 
139     /**
140     * @dev decimals of tokens in existence 
141     */
142     function decimals() public view returns (uint8) 
143     { 
144         return _decimals; 
145     }
146 
147     /**
148     * @dev Total number of tokens in existence 
149     */
150     function totalSupply() public view returns (uint256) 
151     { 
152         return _totalSupply; 
153     }
154 
155     /**
156     * @dev Gets the balance of the specified address. 
157     * @param owner The address to query the balance of. 
158     * @return A uint256 representing the amount owned by the passed address. 
159     */
160     function balanceOf(address owner) public view returns (uint256) 
161     { 
162         return _balances[owner]; 
163     }
164 
165     /**
166     * @dev Function to check the amount of tokens that an owner allowed to a spender. 
167     * @param owner address The address which owns the funds. 
168     * @param spender address The address which will spend the funds. 
169     * @return A uint256 specifying the amount of tokens still available for the spender. 
170     */
171     function allowance(address owner, address spender) public view returns (uint256) 
172     { 
173         return _allowed[owner][spender]; 
174     }
175 
176     /**
177     * @dev Transfer token to a specified address 
178     * @param to The address to transfer to. 
179     * @param value The amount to be transferred. 
180     */
181     function transfer(address to, uint256 value) public returns (bool) 
182     { 
183         _transfer(msg.sender, to, value); 
184         return true; 
185     }
186 
187     /**
188     * @dev Burns a specific amount of tokens. * @param value The amount of token to be burned. 
189     */
190     function burn(uint256 value) public 
191     { 
192         _burn(msg.sender, value); 
193     }
194 
195     /**
196     * @dev Burns a specific amount of tokens from the target address and decrements allowance 
197     * @param from address The account whose tokens will be burned. 
198     * @param value uint256 The amount of token to be burned. 
199     */
200     function burnFrom(address from, uint256 value) public 
201     { 
202         _burnFrom(from, value); 
203     }
204 
205     /**
206     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
207     * Beware that changing an allowance with this method brings the risk that someone may use both the old 
208     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
209     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
210     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
211     * @param spender The address which will spend the funds. 
212     * @param value The amount of tokens to be spent. 
213     */
214     function approve(address spender, uint256 value) public returns (bool) 
215     { 
216         require(value == 0 || (_allowed[msg.sender][spender] == 0));
217         _approve(msg.sender, spender, value); 
218         return true; 
219     }
220 
221     /**
222     * @dev Transfer tokens from one address to another. 
223     * Note that while this function emits an Approval event, this is not required as per the specification, 
224     * and other compliant implementations may not emit the event. 
225     * @param from address The address which you want to send tokens from 
226     * @param to address The address which you want to transfer to 
227     * @param value uint256 the amount of tokens to be transferred 
228     */
229     function transferFrom(address from, address to, uint256 value) public returns (bool) 
230     { 
231         _transfer(from, to, value); 
232         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value)); 
233         return true; 
234     }
235 
236     /**
237     * @dev Increase the amount of tokens that an owner allowed to a spender. 
238     * approve should be called when _allowed[msg.sender][spender] == 0. To increment 
239     * allowed value is better to use this function to avoid 2 calls (and wait until 
240     * the first transaction is mined) 
241     * From MonolithDAO Token.sol 
242     * Emits an Approval event. 
243     * @param spender The address which will spend the funds. 
244     * @param addedValue The amount of tokens to increase the allowance by. 
245     */
246     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
247     { 
248         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue)); 
249         return true; 
250     }
251 
252     /**
253     * @dev Decrease the amount of tokens that an owner allowed to a spender. 
254     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement 
255     * allowed value is better to use this function to avoid 2 calls (and wait until 
256     * the first transaction is mined) 
257     * From MonolithDAO Token.sol * Emits an Approval event.
258     * @param spender The address which will spend the funds. 
259     * @param subtractedValue The amount of tokens to decrease the allowance by. 
260     */
261     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
262     { 
263         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue)); 
264         return true; 
265     }
266 
267     /**
268     * @dev Transfer token for a specified addresses 
269     * @param from The address to transfer from. 
270     * @param to The address to transfer to. 
271     * @param value The amount to be transferred. 
272     */
273     function _transfer(address from, address to, uint256 value) internal 
274     { 
275         require(to != address(0));
276         _balances[from] = _balances[from].sub(value);
277         _balances[to] = _balances[to].add(value); 
278         emit Transfer(from, to, value); 
279     }
280     
281     /**
282     * @dev Internal function that burns an amount of the token of a given 
283     * account. 
284     * @param account The account whose tokens will be burnt. 
285     * @param value The amount that will be burnt. 
286     */
287     function _burn(address account, uint256 value) internal 
288     { 
289         require(account != address(0));
290         _totalSupply = _totalSupply.sub(value);
291         _balances[account] = _balances[account].sub(value);
292         emit Transfer(account, address(0), value);
293     }
294 
295     /**
296     * @dev Approve an address to spend another addresses' tokens. 
297     * @param owner The address that owns the tokens. 
298     * @param spender The address that will spend the tokens. 
299     * @param value The number of tokens that can be spent. 
300     */
301     function _approve(address owner, address spender, uint256 value) internal 
302     { 
303         require(spender != address(0));
304         require(owner != address(0));
305         _allowed[owner][spender] = value; 
306         emit Approval(owner, spender, value); 
307     }
308     /**
309     * @dev Internal function that burns an amount of the token of a given 
310     * account, deducting from the sender's allowance for said account. Uses the 
311     * internal burn function. 
312     * Emits an Approval event (reflecting the reduced allowance). 
313     * @param account The account whose tokens will be burnt. 
314     * @param value The amount that will be burnt. 
315     */
316     function _burnFrom(address account, uint256 value) internal 
317     { 
318         _burn(account, value); 
319         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value)); 
320     }
321 }