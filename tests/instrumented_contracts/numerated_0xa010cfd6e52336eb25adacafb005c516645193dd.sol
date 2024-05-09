1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract Destructible is Ownable {
70 
71   function Destructible() public payable { }
72 
73   /**
74    * @dev Transfers the current balance to the owner and terminates the contract.
75    */
76   function destroy() onlyOwner public {
77     selfdestruct(owner);
78   }
79 
80   function destroyAndSend(address _recipient) onlyOwner public {
81     selfdestruct(_recipient);
82   }
83 }
84 
85 contract CanReclaimToken is Ownable {
86   using SafeERC20 for ERC20Basic;
87 
88   /**
89    * @dev Reclaim all ERC20Basic compatible tokens
90    * @param token ERC20Basic The address of the token contract
91    */
92   function reclaimToken(ERC20Basic token) external onlyOwner {
93     uint256 balance = token.balanceOf(this);
94     token.safeTransfer(owner, balance);
95   }
96 
97 }
98 
99 contract HasNoEther is Ownable {
100 
101   /**
102   * @dev Constructor that rejects incoming Ether
103   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
104   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
105   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
106   * we could use assembly to access msg.value.
107   */
108   function HasNoEther() public payable {
109     require(msg.value == 0);
110   }
111 
112   /**
113    * @dev Disallows direct send by settings a default function without the `payable` flag.
114    */
115   function() external {
116   }
117 
118   /**
119    * @dev Transfer all Ether held by the contract to the owner.
120    */
121   function reclaimEther() external onlyOwner {
122     assert(owner.send(this.balance));
123   }
124 }
125 
126 contract HasNoTokens is CanReclaimToken {
127 
128  /**
129   * @dev Reject all ERC23 compatible tokens
130   * @param from_ address The address that is transferring the tokens
131   * @param value_ uint256 the amount of the specified token
132   * @param data_ Bytes The data passed from the caller.
133   */
134   function tokenFallback(address from_, uint256 value_, bytes data_) external {
135     from_;
136     value_;
137     data_;
138     revert();
139   }
140 
141 }
142 
143 contract ERC20Basic {
144   uint256 public totalSupply;
145   function balanceOf(address who) public view returns (uint256);
146   function transfer(address to, uint256 value) public returns (bool);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   /**
156   * @dev transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[msg.sender]);
163 
164     // SafeMath.sub will throw if there is not enough balance.
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public view returns (uint256 balance) {
177     return balances[_owner];
178   }
179 
180 }
181 
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender) public view returns (uint256);
184   function transferFrom(address from, address to, uint256 value) public returns (bool);
185   function approve(address spender, uint256 value) public returns (bool);
186   event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 library SafeERC20 {
190   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
191     assert(token.transfer(to, value));
192   }
193 
194   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
195     assert(token.transferFrom(from, to, value));
196   }
197 
198   function safeApprove(ERC20 token, address spender, uint256 value) internal {
199     assert(token.approve(spender, value));
200   }
201 }
202 
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(address _owner, address _spender) public view returns (uint256) {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    */
258   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
259     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 contract WIZE is StandardToken, Destructible, HasNoEther, HasNoTokens  {
278 
279 	string public name = "WIZE";
280 	string public symbol = "WIZE";
281 	uint256 public decimals = 8;
282 
283 	function WIZE() public
284 	{
285 		address master = 0x14010814F3d6fBDe4970E4f7B36CdfFB23B5FA4A;
286 		balances[master] = 210e6 * 10**8;
287 		Transfer(0x0, master, balances[master]);
288 	}
289 }