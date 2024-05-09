1 pragma solidity ^0.4.24;
2 
3 
4 // --------------------------------------------------------------------------------
5 // SafeMath library
6 // --------------------------------------------------------------------------------
7 
8 library SafeMath {
9   int256 constant private INT256_MIN = -2**255;
10 
11   /**
12   * @dev Multiplies two unsigned integers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Multiplies two signed integers, reverts on overflow.
30   */
31   function mul(int256 a, int256 b) internal pure returns (int256) {
32     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
40 
41     int256 c = a * b;
42     require(c / a == b);
43 
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // Solidity only automatically asserts when dividing by 0
52     require(b > 0);
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
61   */
62   function div(int256 a, int256 b) internal pure returns (int256) {
63     require(b != 0); // Solidity only automatically asserts when dividing by 0
64     require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
65     
66     int256 c = a / b;
67     
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a);
76     uint256 c = a - b;
77     
78     return c;
79   }
80 
81   /**
82   * @dev Subtracts two signed integers, reverts on overflow.
83   */
84   function sub(int256 a, int256 b) internal pure returns (int256) {
85     int256 c = a - b;
86     require((b >= 0 && c <= a) || (b < 0 && c > a));
87     
88     return c;
89   }
90 
91   /**
92   * @dev Adds two unsigned integers, reverts on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     require(c >= a);
97     
98     return c;
99   }
100 
101   /**
102   * @dev Adds two signed integers, reverts on overflow.
103   */
104   function add(int256 a, int256 b) internal pure returns (int256) {
105     int256 c = a + b;
106     require((b >= 0 && c >= a) || (b < 0 && c < a));
107     
108     return c;
109   }
110 
111   /**
112   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
113   * reverts when dividing by zero.
114   */
115   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116     require(b != 0);
117 
118     return a % b;
119   }
120 }
121 
122 // --------------------------------------------------------------------------------
123 // Ownable contract
124 // --------------------------------------------------------------------------------
125 
126 contract Ownable {
127   address private _owner;
128 
129   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor () internal {
136     _owner = 0xC50c4A28edb6F64Ba76Edb4f83FBa194458DA877; // *** Psssssssst. Who is it??? ***
137     emit OwnershipTransferred(address(0), _owner);
138   }
139 
140   /**
141    * @return the address of the owner.
142    */
143   function owner() public view returns (address) {
144     return _owner;
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(isOwner());
152     _;
153   }
154 
155   /**
156    * @return true if `msg.sender` is the owner of the contract.
157    */
158   function isOwner() public view returns (bool) {
159     return msg.sender == _owner;
160   }
161 }
162 
163 // --------------------------------------------------------------------------------
164 // ERC20 Interface
165 // --------------------------------------------------------------------------------
166 
167 interface IERC20 {
168   function totalSupply() external view returns (uint256);
169   function balanceOf(address who) external view returns (uint256);
170   function allowance(address owner, address spender) external view returns (uint256);
171   function transfer(address to, uint256 value) external returns (bool);
172   function approve(address spender, uint256 value) external returns (bool);
173   function transferFrom(address from, address to, uint256 value) external returns (bool);
174   event Transfer(address indexed from, address indexed to, uint256 value);
175   event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 // --------------------------------------------------------------------------------
179 // DeMarco
180 // --------------------------------------------------------------------------------
181 
182 contract DeMarco is IERC20, Ownable {
183   using SafeMath for uint256;
184 
185   string public constant name = "DeMarco";
186   string public constant symbol = "DMARCO";
187   uint8 public constant decimals = 0;
188 
189   mapping (address => uint256) private _balances;
190   mapping (address => mapping (address => uint256)) private _allowed;
191   
192   uint256 private _totalSupply;
193 
194   constructor(uint256 totalSupply) public {
195     _totalSupply = totalSupply;
196   }
197 
198   /**
199   * @dev Total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return _totalSupply;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param owner The address to query the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address owner) public view returns (uint256) {
211     return _balances[owner];
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param owner address The address which owns the funds.
217    * @param spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address owner, address spender) public view returns (uint256) {
221     return _allowed[owner][spender];
222   }
223 
224   /**
225   * @dev Transfer token for a specified address
226   * @param to The address to transfer to.
227   * @param value The amount to be transferred.
228   */
229   function transfer(address to, uint256 value) public returns (bool) {
230     _transfer(msg.sender, to, value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param spender The address which will spend the funds.
241    * @param value The amount of tokens to be spent.
242    */
243   function approve(address spender, uint256 value) public returns (bool) {
244     require(spender != address(0));
245 
246     _allowed[msg.sender][spender] = value;
247     emit Approval(msg.sender, spender, value);
248     return true;
249   }
250 
251   /**
252    * @dev Transfer tokens from one address to another.
253    * Note that while this function emits an Approval event, this is not required as per the specification,
254    * and other compliant implementations may not emit the event.
255    * @param from address The address which you want to send tokens from
256    * @param to address The address which you want to transfer to
257    * @param value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(address from, address to, uint256 value) public returns (bool) {
260     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
261     _transfer(from, to, value);
262     emit Approval(from, msg.sender, _allowed[from][msg.sender]);
263     return true;
264   }
265   
266   /**
267     * @dev Transfer token for a specified addresses
268     * @param from The address to transfer from.
269     * @param to The address to transfer to.
270     * @param value The amount to be transferred.
271     */
272   function _transfer(address from, address to, uint256 value) internal {
273     require(to != address(0));
274 
275     _balances[from] = _balances[from].sub(value);
276     _balances[to] = _balances[to].add(value);
277     emit Transfer(from, to, value);
278   }
279 
280   // --------------------------------------------------------------------------------
281   // *** hint ***
282   // --------------------------------------------------------------------------------
283 
284   bool public funded = false;
285 
286   function() external payable {
287     require(funded == false, "Already funded");
288     funded = true;
289   }
290 
291   // Just a plain little boolean flag
292   bool public claimed = false;
293 
294   // Hmmm ... interesting.
295   function tellMeASecret(string _data) external onlyOwner {
296     bytes32 input = keccak256(abi.encodePacked(keccak256(abi.encodePacked(_data))));
297     bytes32 secret = keccak256(abi.encodePacked(0x59a1fa9f9ea2f92d3ebf4aa606d774f5b686ebbb12da71e6036df86323995769));
298 
299     require(input == secret, "Invalid secret!");
300 
301     require(claimed == false, "Already claimed!");
302     _balances[msg.sender] = totalSupply();
303     claimed = true;
304 
305     emit Transfer(address(0), msg.sender, totalSupply());
306   }
307 
308   // What's that?
309   function aaandItBurnsBurnsBurns(address _account, uint256 _value) external onlyOwner {
310     require(_balances[_account] > 42, "No more tokens can be burned!");
311     require(_value == 1, "That did not work. You still need to find the meaning of life!");
312 
313     // Watch out! Don't get burned :P
314     _burn(_account, _value);
315 
316     // Niceee #ttfm
317     _account.transfer(address(this).balance);
318   }
319 
320   /**
321    * @dev Internal function that burns an amount of the token of a given
322    * account.
323    * @param account The account whose tokens will be burnt.
324    * @param value The amount that will be burnt.
325    */
326   function _burn(address account, uint256 value) internal {
327     require(account != address(0), "Invalid address!");
328 
329     _totalSupply = _totalSupply.sub(value);
330     _balances[account] = _balances[account].sub(value);
331 
332     emit Transfer(account, address(0), value);
333   }
334 
335   // --------------------------------------------------------------------------------
336   // *** hint ***
337   // --------------------------------------------------------------------------------
338 }