1 pragma solidity ^0.5.2;
2 // ----------------------------------------------------------------------------
3 // 'SYNCHRONIUMLLC' token contract
4 //
5 // Deployed to : 0x25541AcB8D91eD09267378E4d690dBf2bA7E0e41
6 // Symbol : SNB
7 // Name : SynchroBitCoin
8 // Total supply: 1000000000
9 // Decimals :18
10 //
11 // Enjoy.
12 //
13 // SynchroBit Digital Assets Trading Platform.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 /**
21  * @title ERC20 interface
22  * @dev see https://eips.ethereum.org/EIPS/eip-20
23  */
24 interface IERC20 {
25     function transfer(address to, uint256 value) external returns (bool);
26 
27     function approve(address spender, uint256 value) external returns (bool);
28 
29     function transferFrom(address from, address to, uint256 value) external returns (bool);
30 
31     function totalSupply() external view returns (uint256);
32   
33     function balanceOf(address who) external view returns (uint256);
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Unsigned math operations with safety checks that revert on error.
45  */
46 library SafeMath {
47     /**
48      * @dev Multiplies two unsigned integers, reverts on overflow.
49      */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52         // benefit is lost if 'b' is also tested.
53         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54         if (a == 0) {
55             return 0;
56         }
57 
58         uint256 c = a * b;
59         require(c / a == b);
60 
61         return c;
62     }
63 
64     /**
65      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
66      */
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Solidity only automatically asserts when dividing by 0
69         require(b > 0);
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73         return c;
74     }
75 
76     /**
77      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78      */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Adds two unsigned integers, reverts on overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a);
92 
93         return c;
94     }
95 
96     /**
97      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
98      * reverts when dividing by zero.
99      */
100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b != 0);
102         return a % b;
103     }
104 }
105 
106 contract SynchroBitCoin is IERC20 {
107     using SafeMath for uint256;
108     string private _name;
109     string private _symbol;
110     uint8 private _decimals;
111 
112     mapping (address => uint256) private _balances;
113 
114     mapping (address => mapping (address => uint256)) private _allowed;
115 
116     uint256 private _totalSupply;
117     
118      constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address owner) public {
119         _name = name;
120         _symbol = symbol;
121         _decimals = decimals;
122         _totalSupply = totalSupply*(10**uint256(decimals));
123         _balances[owner] = _totalSupply;
124     }
125 
126     /**
127      * @return the name of the token.
128      */
129     function name() public view returns (string memory) {
130         return _name;
131     }
132 
133     /**
134      * @return the symbol of the token.
135      */
136     function symbol() public view returns (string memory) {
137         return _symbol;
138     }
139 
140     /**
141      * @return the number of decimals of the token.
142      */
143     function decimals() public view returns (uint8) {
144         return _decimals;
145     }
146     
147 
148     /**
149      * @dev Total number of tokens in existence.
150      */
151     function totalSupply() public view returns (uint256) {
152         return _totalSupply;
153     }
154 
155     /**
156      * @dev Gets the balance of the specified address.
157      * @param owner The address to query the balance of.
158      * @return A uint256 representing the amount owned by the passed address.
159      */
160     function balanceOf(address owner) public view returns (uint256) {
161         return _balances[owner];
162     }
163 
164     /**
165      * @dev Function to check the amount of tokens that an owner allowed to a spender.
166      * @param owner address The address which owns the funds.
167      * @param spender address The address which will spend the funds.
168      * @return A uint256 specifying the amount of tokens still available for the spender.
169      */
170     function allowance(address owner, address spender) public view returns (uint256) {
171         return _allowed[owner][spender];
172     }
173 
174     /**
175      * @dev Transfer token to a specified address.
176      * @param to The address to transfer to.
177      * @param value The amount to be transferred.
178      */
179     function transfer(address to, uint256 value) public returns (bool) {
180         _transfer(msg.sender, to, value);
181         return true;
182     }
183 
184     /**
185      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186      * Beware that changing an allowance with this method brings the risk that someone may use both the old
187      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      * @param spender The address which will spend the funds.
191      * @param value The amount of tokens to be spent.
192      */
193     function approve(address spender, uint256 value) public returns (bool) {
194         _approve(msg.sender, spender, value);
195         return true;
196     }
197 
198     /**
199      * @dev Transfer tokens from one address to another.
200      * Note that while this function emits an Approval event, this is not required as per the specification,
201      * and other compliant implementations may not emit the event.
202      * @param from address The address which you want to send tokens from
203      * @param to address The address which you want to transfer to
204      * @param value uint256 the amount of tokens to be transferred
205      */
206     function transferFrom(address from, address to, uint256 value) public returns (bool) {
207         _transfer(from, to, value);
208         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
209         return true;
210     }
211 
212     /**
213      * @dev Increase the amount of tokens that an owner allowed to a spender.
214      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * Emits an Approval event.
219      * @param spender The address which will spend the funds.
220      * @param addedValue The amount of tokens to increase the allowance by.
221      */
222     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
223         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
224         return true;
225     }
226 
227     /**
228      * @dev Decrease the amount of tokens that an owner allowed to a spender.
229      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      * From MonolithDAO Token.sol
233      * Emits an Approval event.
234      * @param spender The address which will spend the funds.
235      * @param subtractedValue The amount of tokens to decrease the allowance by.
236      */
237     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
238         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
239         return true;
240     }
241 
242     /**
243      * @dev Transfer token for a specified addresses.
244      * @param from The address to transfer from.
245      * @param to The address to transfer to.
246      * @param value The amount to be transferred.
247      */
248     function _transfer(address from, address to, uint256 value) internal {
249         require(to != address(0));
250 
251         _balances[from] = _balances[from].sub(value);
252         _balances[to] = _balances[to].add(value);
253         emit Transfer(from, to, value);
254     }
255 
256     /**
257      * @dev Internal function that mints an amount of the token and assigns it to
258      * an account. This encapsulates the modification of balances such that the
259      * proper events are emitted.
260      * @param account The account that will receive the created tokens.
261      * @param value The amount that will be created.
262      */
263     function _mint(address account, uint256 value) internal {
264         require(account != address(0));
265 
266         _totalSupply = _totalSupply.add(value);
267         _balances[account] = _balances[account].add(value);
268         emit Transfer(address(0), account, value);
269     }
270 
271     /**
272      * @dev Internal function that burns an amount of the token of a given
273      * account.
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burn(address account, uint256 value) internal {
278         require(account != address(0));
279 
280         _totalSupply = _totalSupply.sub(value);
281         _balances[account] = _balances[account].sub(value);
282         emit Transfer(account, address(0), value);
283     }
284 
285     /**
286      * @dev Approve an address to spend another addresses' tokens.
287      * @param owner The address that owns the tokens.
288      * @param spender The address that will spend the tokens.
289      * @param value The number of tokens that can be spent.
290      */
291     function _approve(address owner, address spender, uint256 value) internal {
292         require(spender != address(0));
293         require(owner != address(0));
294 
295         _allowed[owner][spender] = value;
296         emit Approval(owner, spender, value);
297     }
298 
299     /**
300      * @dev Internal function that burns an amount of the token of a given
301      * account, deducting from the sender's allowance for said account. Uses the
302      * internal burn function.
303      * Emits an Approval event (reflecting the reduced allowance).
304      * @param account The account whose tokens will be burnt.
305      * @param value The amount that will be burnt.
306      */
307     function _burnFrom(address account, uint256 value) internal {
308         _burn(account, value);
309         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
310     }
311     /**
312      * @dev Burns a specific amount of tokens.
313      * @param value The amount of token to be burned.
314      */
315     function burn(uint256 value) public {
316         _burn(msg.sender, value);
317     }
318 
319     /**
320      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
321      * @param from address The account whose tokens will be burned.
322      * @param value uint256 The amount of token to be burned.
323      */
324     function burnFrom(address from, uint256 value) public {
325         _burnFrom(from, value);
326     }
327 }