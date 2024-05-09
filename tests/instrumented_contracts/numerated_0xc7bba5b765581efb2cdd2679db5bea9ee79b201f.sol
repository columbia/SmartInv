1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   /**
65   * @dev total number of tokens in existence
66   */
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public view returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    *
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param _spender The address which will spend the funds.
162    * @param _addedValue The amount of tokens to increase the allowance by.
163    */
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   /**
171    * @dev Decrease the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 contract Ownable {
193   address public owner;
194 
195 
196   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203   function Ownable() public {
204     owner = msg.sender;
205   }
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210   modifier onlyOwner() {
211     require(msg.sender == owner);
212     _;
213   }
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param newOwner The address to transfer ownership to.
218    */
219   function transferOwnership(address newOwner) public onlyOwner {
220     require(newOwner != address(0));
221     OwnershipTransferred(owner, newOwner);
222     owner = newOwner;
223   }
224 
225 }
226 contract HasNoContracts is Ownable {
227 
228   /**
229    * @dev Reclaim ownership of Ownable contracts
230    * @param contractAddr The address of the Ownable to be reclaimed.
231    */
232   function reclaimContract(address contractAddr) external onlyOwner {
233     Ownable contractInst = Ownable(contractAddr);
234     contractInst.transferOwnership(owner);
235   }
236 }
237 contract HasNoEther is Ownable {
238 
239   /**
240   * @dev Constructor that rejects incoming Ether
241   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
242   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
243   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
244   * we could use assembly to access msg.value.
245   */
246   function HasNoEther() public payable {
247     require(msg.value == 0);
248   }
249 
250   /**
251    * @dev Disallows direct send by settings a default function without the `payable` flag.
252    */
253   function() external {
254   }
255 
256   /**
257    * @dev Transfer all Ether held by the contract to the owner.
258    */
259   function reclaimEther() external onlyOwner {
260     assert(owner.send(this.balance));
261   }
262 }
263 library SafeERC20 {
264   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
265     assert(token.transfer(to, value));
266   }
267 
268   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
269     assert(token.transferFrom(from, to, value));
270   }
271 
272   function safeApprove(ERC20 token, address spender, uint256 value) internal {
273     assert(token.approve(spender, value));
274   }
275 }
276 contract CanReclaimToken is Ownable {
277   using SafeERC20 for ERC20Basic;
278 
279   /**
280    * @dev Reclaim all ERC20Basic compatible tokens
281    * @param token ERC20Basic The address of the token contract
282    */
283   function reclaimToken(ERC20Basic token) external onlyOwner {
284     uint256 balance = token.balanceOf(this);
285     token.safeTransfer(owner, balance);
286   }
287 
288 }
289 contract HasNoTokens is CanReclaimToken {
290 
291  /**
292   * @dev Reject all ERC223 compatible tokens
293   * @param from_ address The address that is transferring the tokens
294   * @param value_ uint256 the amount of the specified token
295   * @param data_ Bytes The data passed from the caller.
296   */
297   function tokenFallback(address from_, uint256 value_, bytes data_) external {
298     from_;
299     value_;
300     data_;
301     revert();
302   }
303 
304 }
305 
306 contract GemsToken is HasNoContracts, HasNoEther, HasNoTokens, StandardToken {
307     string public constant name = "Gems Token";
308     string public constant symbol = "GEM";
309     uint8 public constant decimals = 18;
310     uint public constant TOTAL_SUPPLY = (8*10**9)*10**uint(decimals);
311 
312     function GemsToken() public {
313         totalSupply_ = TOTAL_SUPPLY;
314         balances[msg.sender] = totalSupply_;
315     }
316 }