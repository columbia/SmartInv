1 pragma solidity 0.5.5;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 pragma solidity ^0.5.2;
26 
27 /**
28  * @title SafeMath
29  * @dev Unsigned math operations with safety checks that revert on error
30  */
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
91 pragma solidity 0.5.5;
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99     address private _owner;
100 
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     /**
104      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105      * account.
106      */
107     constructor () internal {
108         _owner = msg.sender;
109         emit OwnershipTransferred(address(0), _owner);
110     }
111 
112     /**
113      * @return the address of the owner.
114      */
115     function owner() public view returns (address) {
116         return _owner;
117     }
118 
119     /**
120      * @dev Throws if called by any account other than the owner.
121      */
122     modifier onlyOwner() {
123         require(isOwner());
124         _;
125     }
126 
127     /**
128      * @return true if `msg.sender` is the owner of the contract.
129      */
130     function isOwner() public view returns (bool) {
131         return msg.sender == _owner;
132     }
133 
134     /**
135      * @dev Allows the current owner to relinquish control of the contract.
136      * @notice Renouncing to ownership will leave the contract without an owner.
137      * It will not be possible to call the functions with the `onlyOwner`
138      * modifier anymore.
139      */
140     function renounceOwnership() public onlyOwner {
141         emit OwnershipTransferred(_owner, address(0));
142         _owner = address(0);
143     }
144 
145     /**
146      * @dev Allows the current owner to transfer control of the contract to a newOwner.
147      * @param newOwner The address to transfer ownership to.
148      */
149     function transferOwnership(address newOwner) public onlyOwner {
150         _transferOwnership(newOwner);
151     }
152 
153     /**
154      * @dev Transfers control of the contract to a newOwner.
155      * @param newOwner The address to transfer ownership to.
156      */
157     function _transferOwnership(address newOwner) internal {
158         require(newOwner != address(0));
159         emit OwnershipTransferred(_owner, newOwner);
160         _owner = newOwner;
161     }
162 }
163 
164 pragma solidity 0.5.5;
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * https://eips.ethereum.org/EIPS/eip-20
171  * Originally based on code by FirstBlood:
172  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  *
174  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
175  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
176  * compliant implementations may not do it.
177  */
178 contract CTAGToken is IERC20, Ownable {
179     using SafeMath for uint256;
180 
181     uint256 constant private DECIMALS = (10 ** uint256(decimals));
182 
183     string constant public name = "CTAGToken";
184     string constant public symbol = "CTAG";
185     uint8 constant public decimals = 8;
186     uint256 constant private _totalSupply = 4000000000 * (10 ** uint256(decimals));
187 
188     mapping (address => uint256) private _balances;
189 
190     mapping (address => mapping (address => uint256)) private _allowed;
191 
192     uint256 public feePercent;
193     uint256 public minFee;
194 
195     address public feeHolder;
196     
197 
198     constructor (address holder) public {
199         _balances[holder] = _totalSupply;
200         feeHolder = holder;
201         minFee = uint256(5).mul(DECIMALS); // Default minimum 5 CTAG
202         feePercent = uint256(5).mul(DECIMALS).div(10); // Default 0.5 percents
203     }
204 
205     function setFeeHolder(address _feeHolder) public onlyOwner {
206         feeHolder = _feeHolder;
207     }
208 
209     function setFee(uint256 _feePercent) public onlyOwner {
210         feePercent = _feePercent;
211     }
212 
213     function getFee(uint256 _amount) public view returns(uint256 fee) {
214         fee = _amount.mul(feePercent).div(uint256(100).mul(DECIMALS));
215         if (fee < minFee) {
216             fee = minFee;
217         }
218     }
219 
220     function setMinFee(uint256 _minFee) public onlyOwner {
221         minFee = _minFee;
222     }
223 
224     /**
225      * @dev Total number of tokens in existence
226      */
227     function totalSupply() public view returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev Gets the balance of the specified address.
233      * @param owner The address to query the balance of.
234      * @return A uint256 representing the amount owned by the passed address.
235      */
236     function balanceOf(address owner) public view returns (uint256) {
237         return _balances[owner];
238     }
239 
240     /**
241      * @dev Function to check the amount of tokens that an owner allowed to a spender.
242      * @param owner address The address which owns the funds.
243      * @param spender address The address which will spend the funds.
244      * @return A uint256 specifying the amount of tokens still available for the spender.
245      */
246     function allowance(address owner, address spender) public view returns (uint256) {
247         return _allowed[owner][spender];
248     }
249 
250     /**
251      * @dev Transfer token to a specified address
252      * @param to The address to transfer to.
253      * @param value The amount to be transferred.
254      */
255     function transfer(address to, uint256 value) public returns (bool) {
256         _transfer(msg.sender, to, value);
257         return true;
258     }
259 
260     /**
261      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262      * Beware that changing an allowance with this method brings the risk that someone may use both the old
263      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      * @param spender The address which will spend the funds.
267      * @param value The amount of tokens to be spent.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev Transfer tokens from one address to another.
276      * Note that while this function emits an Approval event, this is not required as per the specification,
277      * and other compliant implementations may not emit the event.
278      * @param from address The address which you want to send tokens from
279      * @param to address The address which you want to transfer to
280      * @param value uint256 the amount of tokens to be transferred
281      */
282     function transferFrom(address from, address to, uint256 value) public returns (bool) {
283         _transfer(from, to, value);
284         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
285         return true;
286     }
287 
288     /**
289      * @dev Increase the amount of tokens that an owner allowed to a spender.
290      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From MonolithDAO Token.sol
294      * Emits an Approval event.
295      * @param spender The address which will spend the funds.
296      * @param addedValue The amount of tokens to increase the allowance by.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
299         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
300         return true;
301     }
302 
303     /**
304      * @dev Decrease the amount of tokens that an owner allowed to a spender.
305      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * Emits an Approval event.
310      * @param spender The address which will spend the funds.
311      * @param subtractedValue The amount of tokens to decrease the allowance by.
312      */
313     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
314         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
315         return true;
316     }
317 
318     /**
319      * @dev Transfer token for a specified addresses
320      * @param from The address to transfer from.
321      * @param to The address to transfer to.
322      * @param value The amount to be transferred.
323      */
324     function _transfer(address from, address to, uint256 value) internal {
325         require(to != address(0));
326 
327         uint256 fee = getFee(value);
328         require(fee < value);
329         _balances[from] = _balances[from].sub(value);
330         _balances[to] = _balances[to].add(value.sub(fee));
331         _balances[feeHolder] = _balances[feeHolder].add(fee);
332         emit Transfer(from, to, value);
333     }
334 
335     /**
336      * @dev Approve an address to spend another addresses' tokens.
337      * @param owner The address that owns the tokens.
338      * @param spender The address that will spend the tokens.
339      * @param value The number of tokens that can be spent.
340      */
341     function _approve(address owner, address spender, uint256 value) internal {
342         require(spender != address(0));
343         require(owner != address(0));
344 
345         _allowed[owner][spender] = value;
346         emit Approval(owner, spender, value);
347     }
348 }