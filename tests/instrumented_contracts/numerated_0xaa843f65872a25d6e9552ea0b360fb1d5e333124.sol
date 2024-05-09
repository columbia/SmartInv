1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     require(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b > 0);
26     uint256 c = a / b;
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     require(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     owner = newOwner;
81     OwnershipTransferred(owner, newOwner);
82   }
83 }
84 
85 contract CutdownTokenInterface {
86 	//ERC20
87   	function balanceOf(address who) public view returns (uint256);
88   	function transfer(address to, uint256 value) public returns (bool);
89 
90   	//ERC677
91   	function tokenFallback(address from, uint256 amount, bytes data) public returns (bool);
92 }
93 
94 /**
95  * @title Eco Value Coin
96  * @dev Burnable ERC20 + ERC677 token with initial transfers blocked
97  */
98 contract EcoValueCoin is Ownable {
99   using SafeMath for uint256;
100 
101   event Transfer(address indexed _from, address indexed _to, uint256 _value);
102   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
103   
104   event Burn(address indexed _burner, uint256 _value);
105   event TransfersEnabled();
106   event TransferRightGiven(address indexed _to);
107   event TransferRightCancelled(address indexed _from);
108   event WithdrawnERC20Tokens(address indexed _tokenContract, address indexed _owner, uint256 _balance);
109   event WithdrawnEther(address indexed _owner, uint256 _balance);
110 
111   string public constant name = "Eco Value Coin";
112   string public constant symbol = "EVC";
113   uint256 public constant decimals = 18;
114   uint256 public constant initialSupply = 3300000000 * (10 ** decimals);
115   uint256 public totalSupply;
116 
117   mapping(address => uint256) public balances;
118   mapping(address => mapping (address => uint256)) internal allowed;
119 
120   //This mapping is used for the token owner and crowdsale contract to 
121   //transfer tokens before they are transferable
122   mapping(address => bool) public transferGrants;
123   //This flag controls the global token transfer
124   bool public transferable;
125 
126   /**
127    * @dev Modifier to check if tokens can be transfered.
128    */
129   modifier canTransfer() {
130     require(transferable || transferGrants[msg.sender]);
131     _;
132   }
133 
134   /**
135    * @dev The constructor sets the original `owner` of the contract 
136    * to the sender account and assigns them all tokens.
137    */
138   function EcoValueCoin() public {
139     owner = msg.sender;
140     totalSupply = initialSupply;
141     balances[owner] = totalSupply;
142     transferGrants[owner] = true;
143   }
144 
145   /**
146    * @dev This contract does not accept any ether. 
147    * Any forced ether can be withdrawn with `withdrawEther()` by the owner.
148    */
149   function () payable public {
150     revert();
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162   /**
163   * @dev Transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170     // SafeMath.sub will throw if there is not enough balance.
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     Transfer(msg.sender, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) canTransfer public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) canTransfer public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) canTransfer public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Burns a specific amount of tokens.
259    * @param _value The amount of token to be burned.
260    */
261   function burn(uint256 _value) public {
262     require(_value <= balances[msg.sender]);
263     address burner = msg.sender;
264     balances[burner] = balances[burner].sub(_value);
265     totalSupply = totalSupply.sub(_value);
266     Burn(burner, _value);
267   }
268 
269   /**
270    * @dev Enables the transfer of tokens for everyone
271    */
272   function enableTransfers() onlyOwner public {
273     require(!transferable);
274     transferable = true;
275     TransfersEnabled();
276   }
277 
278   /**
279    * @dev Assigns the special transfer right, before transfers are enabled
280    * @param _to The address receiving the transfer grant
281    */
282   function grantTransferRight(address _to) onlyOwner public {
283     require(!transferable);
284     require(!transferGrants[_to]);
285     require(_to != address(0));
286     transferGrants[_to] = true;
287     TransferRightGiven(_to);
288   }
289 
290   /**
291    * @dev Removes the special transfer right, before transfers are enabled
292    * @param _from The address that the transfer grant is removed from
293    */
294   function cancelTransferRight(address _from) onlyOwner public {
295     require(!transferable);
296     require(transferGrants[_from]);
297     transferGrants[_from] = false;
298     TransferRightCancelled(_from);
299   }
300 
301   /**
302    * @dev Allows to transfer out the balance of arbitrary ERC20 tokens from the contract.
303    * @param _tokenContract The contract address of the ERC20 token.
304    */
305   function withdrawERC20Tokens(address _tokenContract) onlyOwner public {
306     CutdownTokenInterface token = CutdownTokenInterface(_tokenContract);
307     uint256 totalBalance = token.balanceOf(address(this));
308     token.transfer(owner, totalBalance);
309     WithdrawnERC20Tokens(_tokenContract, owner, totalBalance);
310   }
311 
312   /**
313    * @dev Allows to transfer out the ether balance that was forced into this contract, e.g with `selfdestruct`
314    */
315   function withdrawEther() public onlyOwner {
316     uint256 totalBalance = this.balance;
317     require(totalBalance > 0);
318     owner.transfer(totalBalance);
319     WithdrawnEther(owner, totalBalance);
320   }
321 }