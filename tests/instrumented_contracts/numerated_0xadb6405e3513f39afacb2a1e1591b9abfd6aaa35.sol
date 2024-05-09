1 pragma solidity ^0.5.7;
2 
3 /**
4  * 
5  * ERC-20 Source: https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts/token/ERC20
6  * 
7  * @title ERC20 interface
8  * @dev see https://eips.ethereum.org/EIPS/eip-20
9  *
10  */
11 interface IERC20 {
12     function transfer(address to, uint256 value) external returns (bool);
13 
14     function approve(address spender, uint256 value) external returns (bool);
15 
16     function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address who) external view returns (uint256);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27     
28     event Burn(address indexed from, uint256 value);
29 }
30 
31 library SafeMath {
32     /**
33      * @dev Multiplies two unsigned integers, reverts on overflow.
34      */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     /**
62      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Adds two unsigned integers, reverts on overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a);
77 
78         return c;
79     }
80 
81     /**
82      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
83      * reverts when dividing by zero.
84      */
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0);
87         return a % b;
88     }
89 }
90 
91 contract TestAK is IERC20 {
92     using SafeMath for uint256;
93 
94     mapping (address => uint256) private _balances;
95 
96     mapping (address => mapping (address => uint256)) private _allowed;
97 
98     string public name;
99     string public symbol;
100     uint8 public decimals;
101     uint256 private _totalSupply;
102     
103     constructor() public {
104         name = "Test Akoya";
105         symbol = "TESTAK";
106         decimals = 18;
107         _totalSupply = 10000000 * 10 ** uint256(decimals);
108         
109         // Assign entire AKYE supply to the contract creator
110         _balances[msg.sender] = _totalSupply;
111     }
112 
113     /**
114      * @dev Total number of tokens in existence.
115      */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121      * @dev Gets the balance of the specified address.
122      * @param owner The address to query the balance of.
123      * @return A uint256 representing the amount owned by the passed address.
124      */
125     function balanceOf(address owner) public view returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner address The address which owns the funds.
132      * @param spender address The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139     /**
140      * @dev Transfer token to a specified address.
141      * @param to The address to transfer to.
142      * @param value The amount to be transferred.
143      */
144     function transfer(address to, uint256 value) public returns (bool) {
145         _transfer(msg.sender, to, value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         _approve(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _transfer(from, to, value);
173         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
189         return true;
190     }
191 
192     /**
193      * @dev Decrease the amount of tokens that an owner allowed to a spender.
194      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * Emits an Approval event.
199      * @param spender The address which will spend the funds.
200      * @param subtractedValue The amount of tokens to decrease the allowance by.
201      */
202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
204         return true;
205     }
206     
207      /**
208      * @dev Burns a specific amount of tokens.
209      * @param value The amount of token to be burned.
210      */
211     function burn(uint256 value) public {
212         _burn(msg.sender, value);
213     }
214 
215     /**
216      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
217      * @param from address The account whose tokens will be burned.
218      * @param value uint256 The amount of token to be burned.
219      */
220     function burnFrom(address from, uint256 value) public {
221         _burnFrom(from, value);
222     }
223 
224     /**
225      * @dev Transfer token for a specified addresses.
226      * @param from The address to transfer from.
227      * @param to The address to transfer to.
228      * @param value The amount to be transferred.
229      */
230     function _transfer(address from, address to, uint256 value) internal {
231         require(to != address(0));
232 
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         emit Transfer(from, to, value);
236     }
237 
238     /**
239      * @dev Internal function that burns an amount of the token of a given
240      * account.
241      * @param account The account whose tokens will be burnt.
242      * @param value The amount that will be burnt.
243      */
244     function _burn(address account, uint256 value) internal {
245         require(account != address(0));
246 
247         _totalSupply = _totalSupply.sub(value);
248         _balances[account] = _balances[account].sub(value);
249         emit Transfer(account, address(0), value);
250         emit Burn(account, value);
251     }
252 
253     /**
254      * @dev Approve an address to spend another addresses' tokens.
255      * @param owner The address that owns the tokens.
256      * @param spender The address that will spend the tokens.
257      * @param value The number of tokens that can be spent.
258      */
259     function _approve(address owner, address spender, uint256 value) internal {
260         require(spender != address(0));
261         require(owner != address(0));
262 
263         _allowed[owner][spender] = value;
264         emit Approval(owner, spender, value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _burn(account, value);
277         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
278     }
279     
280     // Rejects ETH deposits
281     function () external payable {
282         revert();
283     }
284 }