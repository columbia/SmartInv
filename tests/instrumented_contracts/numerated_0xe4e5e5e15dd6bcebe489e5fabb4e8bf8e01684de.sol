1 pragma solidity 0.4.19;
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
69 contract HasNoContracts is Ownable {
70 
71   /**
72    * @dev Reclaim ownership of Ownable contracts
73    * @param contractAddr The address of the Ownable to be reclaimed.
74    */
75   function reclaimContract(address contractAddr) external onlyOwner {
76     Ownable contractInst = Ownable(contractAddr);
77     contractInst.transferOwnership(owner);
78   }
79 }
80 
81 contract HasNoEther is Ownable {
82 
83   /**
84   * @dev Constructor that rejects incoming Ether
85   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
86   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
87   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
88   * we could use assembly to access msg.value.
89   */
90   function HasNoEther() public payable {
91     require(msg.value == 0);
92   }
93 
94   /**
95    * @dev Disallows direct send by settings a default function without the `payable` flag.
96    */
97   function() external {
98   }
99 
100   /**
101    * @dev Transfer all Ether held by the contract to the owner.
102    */
103   function reclaimEther() external onlyOwner {
104     assert(owner.send(this.balance));
105   }
106 }
107 
108 contract ERC20Basic {
109   uint256 public totalSupply;
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 contract BasicToken is ERC20Basic {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 library SafeERC20 {
155   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
156     assert(token.transfer(to, value));
157   }
158 
159   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
160     assert(token.transferFrom(from, to, value));
161   }
162 
163   function safeApprove(ERC20 token, address spender, uint256 value) internal {
164     assert(token.approve(spender, value));
165   }
166 }
167 
168 contract CanReclaimToken is Ownable {
169   using SafeERC20 for ERC20Basic;
170 
171   /**
172    * @dev Reclaim all ERC20Basic compatible tokens
173    * @param token ERC20Basic The address of the token contract
174    */
175   function reclaimToken(ERC20Basic token) external onlyOwner {
176     uint256 balance = token.balanceOf(this);
177     token.safeTransfer(owner, balance);
178   }
179 
180 }
181 
182 contract HasNoTokens is CanReclaimToken {
183 
184  /**
185   * @dev Reject all ERC23 compatible tokens
186   * @param from_ address The address that is transferring the tokens
187   * @param value_ uint256 the amount of the specified token
188   * @param data_ Bytes The data passed from the caller.
189   */
190   function tokenFallback(address from_, uint256 value_, bytes data_) external {
191     from_;
192     value_;
193     data_;
194     revert();
195   }
196 
197 }
198 
199 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
200 }
201 
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 contract Intelion is StandardToken, NoOwner {
277     string public constant name = "Intelion";
278     string public constant symbol = "INT";
279     uint8 public constant decimals = 8;
280 
281     function Intelion()
282     public
283     {
284         address _account = 0x3fc427f200D3F44c25c6dC0804f5Fe63B87bA351;
285         uint256 _amount = 2000000000 * 100000000;
286 
287         totalSupply = _amount;
288         balances[_account] = _amount;
289 
290         Transfer(address(0), _account, _amount);
291     }
292 }