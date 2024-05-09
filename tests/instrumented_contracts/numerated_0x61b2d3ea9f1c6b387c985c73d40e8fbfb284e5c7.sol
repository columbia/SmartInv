1 pragma solidity ^0.5.2;
2 
3 contract Ownable {
4     
5     address public _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11      * account.
12      */
13     constructor () internal {
14         _owner = 0x202Abc6cF98863ee0126C182CA325a33A867ACbA;
15         emit OwnershipTransferred(address(0), _owner);
16     }
17 
18     /**
19      * @return the address of the owner.
20      */
21     function owner() public view returns (address) {
22         return _owner;
23     }
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == _owner);
30         _;
31     }
32 
33     /**
34      * @dev Transfers control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(_owner, newOwner);
40         _owner = newOwner;
41     }
42 }
43 
44 
45 
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that revert on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, reverts on overflow.
56   */
57   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (_a == 0) {
62       return 0;
63     }
64 
65     uint256 c = _a * _b;
66     require(c / _a == _b);
67 
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
73   */
74   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     require(_b > 0); // Solidity only automatically asserts when dividing by 0
76     uint256 c = _a / _b;
77     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
78 
79     return c;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     require(_b <= _a);
87     uint256 c = _a - _b;
88 
89     return c;
90   }
91 
92   /**
93   * @dev Adds two numbers, reverts on overflow.
94   */
95   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     uint256 c = _a + _b;
97     require(c >= _a);
98 
99     return c;
100   }
101 
102   /**
103   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
104   * reverts when dividing by zero.
105   */
106   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b != 0);
108     return a % b;
109   }
110 }
111 
112 
113 
114 
115 
116 contract ERC20_Interface {
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address who) external view returns (uint256);
119     function allowance(address owner, address spender) external view returns (uint256);
120     function transfer(address to, uint256 value) external returns (bool);
121     function approve(address spender, uint256 value) external returns (bool);
122     function transferFrom(address from, address to, uint256 value) external returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);   
125 }
126 
127 
128 
129 
130 contract RC20 is ERC20_Interface, Ownable {
131     
132     using SafeMath for uint256;
133 
134     mapping (address => uint256) private _balances;
135 
136     mapping (address => mapping (address => uint256)) private _allowed;
137 
138     uint256 private _totalSupply;
139     uint8 private _decimals;
140     string private _name;
141     string private _symbol;
142     
143     constructor() public {
144         _totalSupply = 900000000e18; 
145         _decimals = 18;
146         _name = "RoboCalls";
147         _symbol = "RC20";
148         _balances[_owner] = _totalSupply;
149         emit Transfer(address(this), _owner, _totalSupply);
150     }
151 
152 
153     function totalSupply() public view returns (uint256) {
154         return _totalSupply;
155     }
156     
157     
158 
159     function decimals() public view returns(uint8) {
160         return _decimals;
161     }
162     
163 
164     function name() public view returns(string memory) {
165         return _name;
166     }
167     
168     
169     function symbol() public view returns(string memory) {
170         return _symbol;
171     }
172 
173     /**
174     * @dev Gets the balance of the specified address.
175     * @param owner The address to query the balance of.
176     * @return An uint256 representing the amount owned by the passed address.
177     */
178     function balanceOf(address owner) public view returns (uint256) {
179         return _balances[owner];
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param owner address The address which owns the funds.
185      * @param spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address owner, address spender) public view returns (uint256) {
189         return _allowed[owner][spender];
190     }
191 
192     /**
193     * @dev Transfer token for a specified address
194     * @param to The address to transfer to.
195     * @param value The amount to be transferred.
196     */
197     function transfer(address to, uint256 value) public returns (bool) {
198         _transfer(msg.sender, to, value);
199         return true;
200     }
201 
202     /**
203      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param spender The address which will spend the funds.
209      * @param value The amount of tokens to be spent.
210      */
211     function approve(address spender, uint256 value) public returns (bool) {
212         require(spender != address(0));
213         _allowed[msg.sender][spender] = value;
214         emit Approval(msg.sender, spender, value);
215         return true;
216     }
217 
218     /**
219      * @dev Transfer tokens from one address to another.
220      * Note that while this function emits an Approval event, this is not required as per the specification,
221      * and other compliant implementations may not emit the event.
222      * @param from address The address which you want to send tokens from
223      * @param to address The address which you want to transfer to
224      * @param value uint256 the amount of tokens to be transferred
225      */
226     function transferFrom(address from, address to, uint256 value) public returns (bool) {
227         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
228         _transfer(from, to, value);
229         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
230         return true;
231     }
232 
233     /**
234      * @dev Increase the amount of tokens that an owner allowed to a spender.
235      * approve should be called when allowed_[_spender] == 0. To increment
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      * From MonolithDAO Token.sol
239      * Emits an Approval event.
240      * @param spender The address which will spend the funds.
241      * @param addedValue The amount of tokens to increase the allowance by.
242      */
243     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
244         require(spender != address(0));
245 
246         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
247         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248         return true;
249     }
250 
251     /**
252      * @dev Decrease the amount of tokens that an owner allowed to a spender.
253      * approve should be called when allowed_[_spender] == 0. To decrement
254      * allowed value is better to use this function to avoid 2 calls (and wait until
255      * the first transaction is mined)
256      * From MonolithDAO Token.sol
257      * Emits an Approval event.
258      * @param spender The address which will spend the funds.
259      * @param subtractedValue The amount of tokens to decrease the allowance by.
260      */
261     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
262         require(spender != address(0));
263         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
264         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265         return true;
266     }
267 
268 
269     /**
270     * @dev Transfer token for a specified addresses
271     * @param from The address to transfer from.
272     * @param to The address to transfer to.
273     * @param value The amount to be transferred.
274     */
275     function _transfer(address from, address to, uint256 value) internal {
276         require(to != address(0));
277         _balances[from] = _balances[from].sub(value);
278         _balances[to] = _balances[to].add(value);
279         emit Transfer(from, to, value);
280     }
281 
282 
283     /**
284      * @dev Internal function that burns an amount of the token from the owner 
285      * @param value The amount that will be burnt.
286      */
287     function burn(uint256 value) public onlyOwner {
288         _totalSupply = _totalSupply.sub(value);
289         _balances[msg.sender] = _balances[msg.sender].sub(value);
290         emit Transfer(msg.sender, address(0), value);
291     }
292 }