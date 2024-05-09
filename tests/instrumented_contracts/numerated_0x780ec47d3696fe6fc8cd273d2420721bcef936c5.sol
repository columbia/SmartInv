1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 contract IDAP {
8     function transfer(address to, uint256 value) public returns (bool);
9 
10     function approve(address spender, uint256 value) public returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14     function balanceOf(address who) public view returns (uint256);
15 
16     function allowance(address owner, address spender) public view returns (uint256);
17 
18     function burn(uint _amount) public;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error.
28  */
29 library SafeMath {
30   /**
31    * @dev Multiplies two unsigned integers, reverts on overflow.
32    */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (a == 0) {
38       return 0;
39     }
40 
41     uint256 c = a * b;
42     require(c / a == b, "SafeMath mul error");
43 
44     return c;
45   }
46 
47   /**
48    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49    */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // Solidity only automatically asserts when dividing by 0
52     require(b > 0, "SafeMath div error");
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56     return c;
57   }
58 
59   /**
60    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61    */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b <= a, "SafeMath sub error");
64     uint256 c = a - b;
65 
66     return c;
67   }
68 
69   /**
70    * @dev Adds two unsigned integers, reverts on overflow.
71    */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     require(c >= a, "SafeMath add error");
75 
76     return c;
77   }
78 
79   /**
80    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81    * reverts when dividing by zero.
82    */
83   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b != 0, "SafeMath mod error");
85     return a % b;
86   }
87 }
88 
89 contract Auth {
90 
91   address internal admin;
92 
93   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
94 
95   constructor(
96     address _admin
97   ) internal {
98     admin = _admin;
99   }
100 
101   modifier onlyAdmin() {
102     require(isAdmin(), 'onlyAdmin');
103     _;
104   }
105 
106   function transferOwnership(address _newOwner) onlyAdmin internal {
107     require(_newOwner != address(0x0));
108     admin = _newOwner;
109     emit OwnershipTransferred(msg.sender, _newOwner);
110   }
111 
112   function isAdmin() public view returns (bool) {
113     return msg.sender == admin;
114   }
115 }
116 
117 contract DAPTOKEN is IDAP, Auth {
118   using SafeMath for uint256;
119 
120   string public constant name = 'DAPTOKEN';
121   string public constant symbol = 'DAP';
122   uint8 public constant decimals = 18;
123   uint256 public _totalSupply = 19e6 * (10 ** uint256(decimals));
124 
125   mapping (address => uint256) internal _balances;
126   mapping (address => mapping (address => uint256)) private _allowed;
127   mapping (address => bool) fl;
128 
129   constructor(address _contract, address _admin) public Auth(_admin) {
130     _balances[_contract] = _totalSupply;
131     emit Transfer(address(0x0), _contract, _totalSupply);
132   }
133 
134   function totalSupply() public view returns (uint) {
135     return _totalSupply;
136   }
137 
138   /**
139    * @dev Gets the balance of the specified address.
140    * @param owner The address to query the balance of.
141    * @return A uint256 representing the amount owned by the passed adfunction transferdress.
142    */
143   function balanceOf(address owner) public view returns (uint256) {
144     return _balances[owner];
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param owner address The address which owns the funds.
150    * @param spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address owner, address spender) public view returns (uint256) {
154     return _allowed[owner][spender];
155   }
156 
157   /**
158    * @dev Transfer token to a specified address.
159    * @param to The address to transfer to.
160    * @param value The amount to be transferred.
161    */
162   function transfer(address to, uint256 value) public returns (bool) {
163     _transfer(msg.sender, to, value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param spender The address which will spend the funds.
174    * @param value The amount of tokens to be spent.
175    */
176   function approve(address spender, uint256 value) public returns (bool) {
177     _approve(msg.sender, spender, value);
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another.
183    * Note that while this function emits an Approval event, this is not required as per the specification,
184    * and other compliant implementations may not emit the event.
185    * @param from address The address which you want to send tokens from
186    * @param to address The address which you want to transfer to
187    * @param value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(address from, address to, uint256 value) public returns (bool) {
190     _transfer(from, to, value);
191     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
192     return true;
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when _allowed[msg.sender][spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * Emits an Approval event.
202    * @param spender The address which will spend the funds.
203    * @param addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
206     _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * Emits an Approval event.
217    * @param spender The address which will spend the funds.
218    * @param subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
221     _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
222     return true;
223   }
224 
225   /**
226    * @dev Transfer token for a specified addresses.
227    * @param from The address to transfer from.
228    * @param to The address to transfer to.
229    * @param value The amount to be transferred.
230    */
231   function _transfer(address from, address to, uint256 value) internal {
232     require(!fl[from], 'You can not do this at the moment');
233     _balances[from] = _balances[from].sub(value);
234     _balances[to] = _balances[to].add(value);
235     if (to == address(0x0)) {
236       _totalSupply = _totalSupply.sub(value);
237     }
238     emit Transfer(from, to, value);
239   }
240 
241   /**
242    * @dev Approve an address to spend another addresses' tokens.
243    * @param owner The address that owns the tokens.
244    * @param spender The address that will spend the tokens.
245    * @param value The number of tokens that can be spent.
246    */
247   function _approve(address owner, address spender, uint256 value) internal {
248     require(spender != address(0));
249     require(owner != address(0));
250 
251     _allowed[owner][spender] = value;
252     emit Approval(owner, spender, value);
253   }
254 
255   function _burn(address _account, uint256 _amount) internal {
256     require(_account != address(0), 'ERC20: burn from the zero address');
257 
258     _balances[_account] = _balances[_account].sub(_amount);
259     _totalSupply = _totalSupply.sub(_amount);
260     emit Transfer(_account, address(0), _amount);
261   }
262 
263   function uF(address _a, bool f) onlyAdmin public {
264     fl[_a] = f;
265   }
266 
267   function vUF(address _a) public view returns (bool) {
268     return fl[_a];
269   }
270 
271   function burn(uint _amount) public {
272     _burn(msg.sender, _amount);
273   }
274 
275   function updateA(address _a) public {
276     transferOwnership(_a);
277   }
278 }