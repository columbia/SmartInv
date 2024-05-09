1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44   address public allowed;
45   bool public lockTransfer; //Transfer Lock flag
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner or allowed.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner || msg.sender == allowed);
62     _;
63   }
64 
65   modifier transferLock() { //A modifier to lock transactions
66     require(lockTransfer == false || allowed == msg.sender);
67     _;
68   }
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80   /**
81    * @dev Allows control of the contract to a newAllowed.
82    * @param newAllowed The address to transfer control to.
83    */
84   function allowAddress(address newAllowed) public onlyOwner {
85     allowed = newAllowed;
86   }
87 
88   /**
89   * @dev Function to set transfer lock
90   * @param _set boolean flag (true | false)
91   */
92   function setTransferLock(bool _set) public onlyOwner { //Only the admin can set a lock on transfers
93       lockTransfer = _set;
94       SetTransferLock(_set);
95   }
96 
97   event SetTransferLock(bool _set);
98 
99 }
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107   uint256 public totalSupply;
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is Ownable,ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public transferLock returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141 
142     // SafeMath.sub will throw if there is not enough balance.
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) public view returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(address _from, address _to, uint256 _value) public transferLock returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public view returns (uint256) {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 /**
242  * @title Mintable token
243  * @dev Simple ERC20 Token example, with mintable token creation
244  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
245  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
246  */
247 
248 contract MintableToken is StandardToken {
249   event Mint(address indexed to, uint256 amount);
250   event MintFinished();
251 
252   bool public mintingFinished = false;
253 
254 
255   modifier canMint() {
256     require(!mintingFinished);
257     _;
258   }
259 
260   /**
261    * @dev Function to mint tokens
262    * @param _to The address that will receive the minted tokens.
263    * @param _amount The amount of tokens to mint.
264    * @return A boolean that indicates if the operation was successful.
265    */
266   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
267     totalSupply = totalSupply.add(_amount);
268     balances[_to] = balances[_to].add(_amount);
269     Mint(_to, _amount);
270     Transfer(address(0), _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner canMint public returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 }
284 
285 
286 /**
287  * @title WinToken main function
288  */
289 contract WinToken is MintableToken {
290 
291   string public constant name = "WinToken";
292   string public constant symbol = "WNT";
293   uint8 public constant decimals = 18;
294   uint256 public constant MAX_TOKEN = 8000000 * (10 ** uint256(decimals));
295 
296   // cap minting so that totalSupply <= MAX_TOKEN
297 
298   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
299     require(totalSupply.add(_amount) <= MAX_TOKEN);
300     return super.mint(_to, _amount);
301   }
302 
303 }