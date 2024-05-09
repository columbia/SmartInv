1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // 'Digitize Coin - DTZ' token contract: https://digitizecoin.com 
5 //
6 // Symbol      : DTZ
7 // Name        : Digitize Coin
8 // Total supply: 200,000,000
9 // Decimals    : 18
10 //
11 //
12 // (c) Radek Ostrowski / http://startonchain.com - The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     require(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b > 0);
38     uint256 c = a / b;
39     return c;
40   }
41 
42   /**
43   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     require(c >= a);
56     return c;
57   }
58 }
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address _newOwner) public onlyOwner {
91     require(_newOwner != address(0));
92     owner = _newOwner;
93     emit OwnershipTransferred(owner, _newOwner);
94   }
95 }
96 
97 /**
98  * @title CutdownToken
99  * @dev Some ERC20 interface methods used in this contract
100  */
101 contract CutdownToken {
102   	function balanceOf(address _who) public view returns (uint256);
103   	function transfer(address _to, uint256 _value) public returns (bool);
104   	function allowance(address _owner, address _spender) public view returns (uint256);
105 }
106 
107 /**
108  * @title ApproveAndCallFallback
109  * @dev Interface function called from `approveAndCall` notifying that the approval happened
110  */
111 contract ApproveAndCallFallback {
112     function receiveApproval(address _from, uint256 _amount, address _tokenContract, bytes _data) public returns (bool);
113 }
114 
115 /**
116  * @title Digitize Coin
117  * @dev Burnable ERC20 token with initial transfers blocked
118  */
119 contract DigitizeCoin is Ownable {
120   using SafeMath for uint256;
121 
122   event Transfer(address indexed _from, address indexed _to, uint256 _value);
123   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124   
125   event Burn(address indexed _burner, uint256 _value);
126   event TransfersEnabled();
127   event TransferRightGiven(address indexed _to);
128   event TransferRightCancelled(address indexed _from);
129   event WithdrawnERC20Tokens(address indexed _tokenContract, address indexed _owner, uint256 _balance);
130   event WithdrawnEther(address indexed _owner, uint256 _balance);
131   event ApproveAndCall(address indexed _from, address indexed _to, uint256 _value, bytes _data);
132 
133   string public constant name = "Digitize Coin";
134   string public constant symbol = "DTZ";
135   uint256 public constant decimals = 18;
136   uint256 public constant initialSupply = 200000000 * (10 ** decimals);
137   uint256 public totalSupply;
138 
139   mapping(address => uint256) public balances;
140   mapping(address => mapping (address => uint256)) internal allowed;
141 
142   //This mapping is used for the token owner and crowdsale contract to 
143   //transfer tokens before they are transferable
144   mapping(address => bool) public transferGrants;
145   //This flag controls the global token transfer
146   bool public transferable;
147 
148   /**
149    * @dev Modifier to check if tokens can be transfered.
150    */
151   modifier canTransfer() {
152     require(transferable || transferGrants[msg.sender]);
153     _;
154   }
155 
156   /**
157    * @dev The constructor sets the original `owner` of the contract 
158    * to the sender account and assigns them all tokens.
159    */
160   function DigitizeCoin() public {
161     owner = msg.sender;
162     totalSupply = initialSupply;
163     balances[owner] = totalSupply;
164     transferGrants[owner] = true;
165   }
166 
167   /**
168    * @dev This contract does not accept any ether. 
169    * Any forced ether can be withdrawn with `withdrawEther()` by the owner.
170    */
171   function () payable public {
172     revert();
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256) {
181     return balances[_owner];
182   }
183 
184   /**
185   * @dev Transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
192     // SafeMath.sub will throw if there is not enough balance.
193     balances[msg.sender] = balances[msg.sender].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     emit Transfer(msg.sender, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
206     require(_to != address(0));
207     require(_value <= balances[_from]);
208     require(_value <= allowed[_from][msg.sender]);
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) canTransfer public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) canTransfer public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Function to approve the transfer of the tokens and to call another contract in one step
281    * @param _recipient The target contract for tokens and function call
282    * @param _value The amount of tokens to send
283    * @param _data Extra data to be sent to the recipient contract function
284    */
285   function approveAndCall(address _recipient, uint _value, bytes _data) canTransfer public returns (bool) {
286     allowed[msg.sender][_recipient] = _value;
287     emit ApproveAndCall(msg.sender, _recipient, _value, _data);
288     ApproveAndCallFallback(_recipient).receiveApproval(msg.sender, _value, address(this), _data);
289     return true;
290   }
291 
292   /**
293    * @dev Burns a specific amount of tokens.
294    * @param _value The amount of token to be burned.
295    */
296   function burn(uint256 _value) public {
297     require(_value <= balances[msg.sender]);
298     address burner = msg.sender;
299     balances[burner] = balances[burner].sub(_value);
300     totalSupply = totalSupply.sub(_value);
301     emit Burn(burner, _value);
302   }
303 
304   /**
305    * @dev Enables the transfer of tokens for everyone
306    */
307   function enableTransfers() onlyOwner public {
308     require(!transferable);
309     transferable = true;
310     emit TransfersEnabled();
311   }
312 
313   /**
314    * @dev Assigns the special transfer right, before transfers are enabled
315    * @param _to The address receiving the transfer grant
316    */
317   function grantTransferRight(address _to) onlyOwner public {
318     require(!transferable);
319     require(!transferGrants[_to]);
320     require(_to != address(0));
321     transferGrants[_to] = true;
322     emit TransferRightGiven(_to);
323   }
324 
325   /**
326    * @dev Removes the special transfer right, before transfers are enabled
327    * @param _from The address that the transfer grant is removed from
328    */
329   function cancelTransferRight(address _from) onlyOwner public {
330     require(!transferable);
331     require(transferGrants[_from]);
332     transferGrants[_from] = false;
333     emit TransferRightCancelled(_from);
334   }
335 
336   /**
337    * @dev Allows to transfer out the balance of arbitrary ERC20 tokens from the contract.
338    * @param _token The contract address of the ERC20 token.
339    */
340   function withdrawERC20Tokens(CutdownToken _token) onlyOwner public {
341     uint256 totalBalance = _token.balanceOf(address(this));
342     require(totalBalance > 0);
343     _token.transfer(owner, totalBalance);
344     emit WithdrawnERC20Tokens(address(_token), owner, totalBalance);
345   }
346 
347   /**
348    * @dev Allows to transfer out the ether balance that was forced into this contract, e.g with `selfdestruct`
349    */
350   function withdrawEther() onlyOwner public {
351     uint256 totalBalance = address(this).balance;
352     require(totalBalance > 0);
353     owner.transfer(totalBalance);
354     emit WithdrawnEther(owner, totalBalance);
355   }
356 }