1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title oyster.org | Bandwidth Bound Consensus
5  * @dev https://github.com/brunoblock/oystermesh
6  * @dev bruno@oyster.org
7  * 
8  * 1 AKYE == 1 AKY
9  * 
10  * ERC-20 Source: https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts/token/ERC20
11  * 
12  * @dev see https://eips.ethereum.org/EIPS/eip-20
13  *
14  */
15 interface IERC20 {
16     function transfer(address to, uint256 value) external returns (bool);
17 
18     function approve(address spender, uint256 value) external returns (bool);
19 
20     function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address who) external view returns (uint256);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31     
32     event Burn(address indexed from, uint256 value);
33 }
34 
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 contract Akoya is IERC20 {
96     using SafeMath for uint256;
97 
98     mapping (address => uint256) private _balances;
99 
100     mapping (address => mapping (address => uint256)) private _allowed;
101 
102     string public name;
103     string public symbol;
104     uint8 public decimals;
105     uint256 private _totalSupply;
106     
107     constructor() public {
108         name = "Oyster Akoya";
109         symbol = "AKYE";
110         decimals = 18;
111         _totalSupply = 10000000 * 10 ** uint256(decimals);
112         
113         // Assign entire AKYE supply to the contract creator
114         _balances[msg.sender] = _totalSupply;
115     }
116 
117     /**
118      * @dev Total number of tokens in existence.
119      */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125      * @dev Gets the balance of the specified address.
126      * @param owner The address to query the balance of.
127      * @return A uint256 representing the amount owned by the passed address.
128      */
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
144      * @dev Transfer token to a specified address.
145      * @param to The address to transfer to.
146      * @param value The amount to be transferred.
147      */
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
163         _approve(msg.sender, spender, value);
164         return true;
165     }
166 
167     /**
168      * @dev Transfer tokens from one address to another.
169      * Note that while this function emits an Approval event, this is not required as per the specification,
170      * and other compliant implementations may not emit the event.
171      * @param from address The address which you want to send tokens from
172      * @param to address The address which you want to transfer to
173      * @param value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address from, address to, uint256 value) public returns (bool) {
176         _transfer(from, to, value);
177         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
178         return true;
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * Emits an Approval event.
188      * @param spender The address which will spend the funds.
189      * @param addedValue The amount of tokens to increase the allowance by.
190      */
191     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
192         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
193         return true;
194     }
195 
196     /**
197      * @dev Decrease the amount of tokens that an owner allowed to a spender.
198      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param subtractedValue The amount of tokens to decrease the allowance by.
205      */
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
208         return true;
209     }
210     
211      /**
212      * @dev Burns a specific amount of tokens.
213      * @param value The amount of token to be burned.
214      */
215     function burn(uint256 value) public {
216         _burn(msg.sender, value);
217     }
218 
219     /**
220      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
221      * @param from address The account whose tokens will be burned.
222      * @param value uint256 The amount of token to be burned.
223      */
224     function burnFrom(address from, uint256 value) public {
225         _burnFrom(from, value);
226     }
227 
228     /**
229      * @dev Transfer token for a specified addresses.
230      * @param from The address to transfer from.
231      * @param to The address to transfer to.
232      * @param value The amount to be transferred.
233      */
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
254         emit Burn(account, value);
255     }
256 
257     /**
258      * @dev Approve an address to spend another addresses' tokens.
259      * @param owner The address that owns the tokens.
260      * @param spender The address that will spend the tokens.
261      * @param value The number of tokens that can be spent.
262      */
263     function _approve(address owner, address spender, uint256 value) internal {
264         require(spender != address(0));
265         require(owner != address(0));
266 
267         _allowed[owner][spender] = value;
268         emit Approval(owner, spender, value);
269     }
270 
271     /**
272      * @dev Internal function that burns an amount of the token of a given
273      * account, deducting from the sender's allowance for said account. Uses the
274      * internal burn function.
275      * Emits an Approval event (reflecting the reduced allowance).
276      * @param account The account whose tokens will be burnt.
277      * @param value The amount that will be burnt.
278      */
279     function _burnFrom(address account, uint256 value) internal {
280         _burn(account, value);
281         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
282     }
283     
284     // Rejects ETH deposits
285     function () external payable {
286         revert();
287     }
288 }