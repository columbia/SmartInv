1 pragma solidity ^0.5.2;
2 // -----------------------------------------------------//
3 // Symbol : LAYER                                       //
4 // Name : Unilayer                                      //
5 // Total supply: 40000000                               //
6 // Decimals :18                                         //
7 //------------------------------------------------------//
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://eips.ethereum.org/EIPS/eip-20
12  */
13 interface IERC20 {
14     function transfer(address to, uint256 value) external returns (bool);
15     function approve(address spender, uint256 value) external returns (bool);
16     function transferFrom(address from, address to, uint256 value) external returns (bool);
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address who) external view returns (uint256);
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 // ----------------------------------------------------------------------------
26 // Safe maths
27 // ----------------------------------------------------------------------------
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error.
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b,"Invalid values");
46         return c;
47     }
48 
49     /**
50      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0,"Invalid values");
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a,"Invalid values");
65         uint256 c = a - b;
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a,"Invalid values");
75         return c;
76     }
77 
78     /**
79      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80      * reverts when dividing by zero.
81      */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0,"Invalid values");
84         return a % b;
85     }
86 }
87 
88 contract Unilayer is IERC20 {
89     using SafeMath for uint256;
90     address private _owner;
91     string private _name;
92     string private _symbol;
93     uint8 private _decimals;
94     uint256 private _totalSupply;
95     uint256 public airdropcount = 0;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowed;
100 
101     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address owner) public {
102         _name = name;
103         _symbol = symbol;
104         _decimals = decimals;
105         _totalSupply = totalSupply*(10**uint256(decimals));
106         _balances[owner] = _totalSupply;
107         _owner = owner;
108     }
109 
110     /*----------------------------------------------------------------------------
111      * Functions for owner
112      *----------------------------------------------------------------------------
113      */
114 
115     /**
116     * @dev get address of smart contract owner
117     * @return address of owner
118     */
119     function getowner() public view returns (address) {
120         return _owner;
121     }
122 
123     /**
124     * @dev modifier to check if the message sender is owner
125     */
126     modifier onlyOwner() {
127         require(isOwner(),"You are not authenticate to make this transfer");
128         _;
129     }
130 
131     /**
132      * @dev Internal function for modifier
133      */
134     function isOwner() internal view returns (bool) {
135         return msg.sender == _owner;
136     }
137 
138     /**
139      * @dev Transfer ownership of the smart contract. For owner only
140      * @return request status
141       */
142     function transferOwnership(address newOwner) public onlyOwner returns (bool){
143         _owner = newOwner;
144         return true;
145     }
146 
147 
148     /* ----------------------------------------------------------------------------
149      * View only functions
150      * ----------------------------------------------------------------------------
151      */
152 
153     /**
154      * @return the name of the token.
155      */
156     function name() public view returns (string memory) {
157         return _name;
158     }
159 
160     /**
161      * @return the symbol of the token.
162      */
163     function symbol() public view returns (string memory) {
164         return _symbol;
165     }
166 
167     /**
168      * @return the number of decimals of the token.
169      */
170     function decimals() public view returns (uint8) {
171         return _decimals;
172     }
173 
174     /**
175      * @dev Total number of tokens in existence.
176      */
177     function totalSupply() public view returns (uint256) {
178         return _totalSupply;
179     }
180 
181     /**
182      * @dev Gets the balance of the specified address.
183      * @param owner The address to query the balance of.
184      * @return A uint256 representing the amount owned by the passed address.
185      */
186     function balanceOf(address owner) public view returns (uint256) {
187         return _balances[owner];
188     }
189 
190     /**
191      * @dev Function to check the amount of tokens that an owner allowed to a spender.
192      * @param owner address The address which owns the funds.
193      * @param spender address The address which will spend the funds.
194      * @return A uint256 specifying the amount of tokens still available for the spender.
195      */
196     function allowance(address owner, address spender) public view returns (uint256) {
197         return _allowed[owner][spender];
198     }
199 
200     /* ----------------------------------------------------------------------------
201      * Transfer, allow and burn functions
202      * ----------------------------------------------------------------------------
203      */
204 
205     /**
206      * @dev Transfer token to a specified address.
207      * @param to The address to transfer to.
208      * @param value The amount to be transferred.
209      */
210     function transfer(address to, uint256 value) public returns (bool) {
211             _transfer(msg.sender, to, value);
212             return true;
213     }
214 
215     /**
216      * @dev Transfer tokens from one address to another.
217      * Note that while this function emits an Approval event, this is not required as per the specification,
218      * and other compliant implementations may not emit the event.
219      * @param from address The address which you want to send tokens from
220      * @param to address The address which you want to transfer to
221      * @param value uint256 the amount of tokens to be transferred
222      */
223     function transferFrom(address from, address to, uint256 value) public returns (bool) {
224              _transfer(from, to, value);
225              _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
226              return true;
227     }
228 
229 
230      /**
231       * @dev Airdrop function to airdrop tokens. Best works upto 50 addresses in one time. Maximum limit is 200 addresses in one time.
232       * @param _addresses array of address in serial order
233       * @param _amount amount in serial order with respect to address array
234       */
235       function airdropByOwner(address[] memory _addresses, uint256[] memory _amount) public onlyOwner returns (bool){
236           require(_addresses.length == _amount.length,"Invalid Array");
237           uint256 count = _addresses.length;
238           for (uint256 i = 0; i < count; i++){
239                _transfer(msg.sender, _addresses[i], _amount[i]);
240                airdropcount = airdropcount + 1;
241           }
242           return true;
243       }
244 
245     /**
246      * @dev Transfer token for a specified addresses.
247      * @param from The address to transfer from.
248      * @param to The address to transfer to.
249      * @param value The amount to be transferred.
250      */
251     function _transfer(address from, address to, uint256 value) internal {
252         require(to != address(0),"Invalid to address");
253         _balances[from] = _balances[from].sub(value);
254         _balances[to] = _balances[to].add(value);
255         emit Transfer(from, to, value);
256     }
257 
258     /**
259      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
260      * Beware that changing an allowance with this method brings the risk that someone may use both the old
261      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
262      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
263      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264      * @param spender The address which will spend the funds.
265      * @param value The amount of tokens to be spent.
266      */
267     function approve(address spender, uint256 value) public returns (bool) {
268         _approve(msg.sender, spender, value);
269         return true;
270     }
271 
272     /**
273      * @dev Approve an address to spend another addresses' tokens.
274      * @param owner The address that owns the tokens.
275      * @param spender The address that will spend the tokens.
276      * @param value The number of tokens that can be spent.
277      */
278     function _approve(address owner, address spender, uint256 value) internal {
279         require(spender != address(0),"Invalid address");
280         require(owner != address(0),"Invalid address");
281         _allowed[owner][spender] = value;
282         emit Approval(owner, spender, value);
283     }
284 
285     /**
286      * @dev Increase the amount of tokens that an owner allowed to a spender.
287      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
288      * allowed value is better to use this function to avoid 2 calls (and wait until
289      * the first transaction is mined)
290      * From MonolithDAO Token.sol
291      * Emits an Approval event.
292      * @param spender The address which will spend the funds.
293      * @param addedValue The amount of tokens to increase the allowance by.
294      */
295     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
296         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
297         return true;
298     }
299 
300     /**
301      * @dev Decrease the amount of tokens that an owner allowed to a spender.
302      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
303      * allowed value is better to use this function to avoid 2 calls (and wait until
304      * the first transaction is mined)
305      * From MonolithDAO Token.sol
306      * Emits an Approval event.
307      * @param spender The address which will spend the funds.
308      * @param subtractedValue The amount of tokens to decrease the allowance by.
309      */
310     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
311         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
312         return true;
313     }
314 
315     /**
316      * @dev Internal function that burns an amount of the token of a given
317      * account.
318      * @param account The account whose tokens will be burnt.
319      * @param value The amount that will be burnt.
320      */
321     function _burn(address account, uint256 value) internal {
322         require(account != address(0),"Invalid account");
323         _totalSupply = _totalSupply.sub(value);
324         _balances[account] = _balances[account].sub(value);
325         emit Transfer(account, address(0), value);
326     }
327 
328     /**
329      * @dev Burns a specific amount of tokens.
330      * @param value The amount of token to be burned.
331      */
332     function burn(uint256 value) public onlyOwner{
333         _burn(msg.sender, value);
334     }
335 }