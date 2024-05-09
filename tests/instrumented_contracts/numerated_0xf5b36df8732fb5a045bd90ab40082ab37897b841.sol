1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40   address public admin;
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47     admin = msg.sender;
48   }
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner || msg.sender == admin);
54     _;
55   }
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) onlyOwner public {
61     require(newOwner != address(0));
62     owner = newOwner;
63   }
64 }
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71   mapping(address => uint256) balances;
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 }
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112   mapping (address => mapping (address => uint256)) allowed;
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     uint256 _allowance = allowed[_from][msg.sender];
122     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123     // require (_value <= _allowance);
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = _allowance.sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154   /**
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    * From MonolithDAO Token.sol
159    */
160   function increaseApproval (address _spender, uint _addedValue)
161     public returns (bool success) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166   function decreaseApproval (address _spender, uint _subtractedValue)
167     public returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 }
178 /**
179  * @title Burnable Token
180  * @dev Token that can be irreversibly burned (destroyed).
181  */
182 contract BurnableToken is StandardToken, Ownable {
183     /**
184      * @dev Burns a specific amount of tokens.
185      * @param _value The amount of token to be burned.
186      */
187     function burnValue(address _burner, uint256 _value) onlyOwner public {
188         require(_value > 0);
189         burn(_burner, _value);
190     }
191     function burnAll(address _burner) onlyOwner public {
192         uint256 value = balances[_burner];
193         burn(_burner, value);
194     }
195     function burn(address _burner, uint256 _value) internal {
196         require(_burner != 0x0);
197         balances[_burner] = balances[_burner].sub(_value);
198         totalSupply = totalSupply.sub(_value);
199     }
200 }
201 /**
202  * @title Mintable token
203  * @dev Simple ERC20 Token example, with mintable token creation
204  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
205  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
206  */
207 contract MintableToken is BurnableToken {
208   bool public mintingFinished = false;
209   // Bind User Account and Address Wallet
210   mapping(string => address) bindAccountsAddress;
211   mapping(address => string) bindAddressAccounts;
212   modifier canMint() {
213     require(!mintingFinished);
214     _;
215   }
216   /**
217    * @dev Function to mint tokens
218    * @param _to The address that will receive the minted tokens.
219    * @param _amount The amount of tokens to mint.
220    * @return A boolean that indicates if the operation was successful.
221    */
222   function mint(address _to, uint256 _amount, string _account) onlyOwner canMint public returns (bool) {
223     // throw if address was bind with another account
224     if(!stringEqual(bindAddressAccounts[_to], "")) {
225       require(stringEqual(bindAddressAccounts[_to], _account));
226     }
227     // only one bind address account
228     if(bindAccountsAddress[_account] != 0x0) {
229       require(bindAccountsAddress[_account] == _to);      
230     }
231     // bind account with address
232     bindAccountsAddress[_account] = _to;
233     bindAddressAccounts[_to] = _account;
234     // mint tokens
235     totalSupply = totalSupply.add(_amount);
236     balances[_to] = balances[_to].add(_amount);
237     Transfer(0x0, _to, _amount);
238     return true;
239   }
240   function getBindAccountAddress(string _account) public constant returns (address) {
241       return bindAccountsAddress[_account];
242   }
243   function getBindAddressAccount(address _accountAddress) public constant returns (string) {
244       return bindAddressAccounts[_accountAddress];
245   }
246   function stringEqual(string a, string b) internal pure returns (bool) {
247     return keccak256(a) == keccak256(b);
248   }
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner public returns (bool) {
254     mintingFinished = true;
255     return true;
256   }
257   function startMinting() onlyOwner public returns (bool) {
258     mintingFinished = false;
259     return true;
260   }
261 }
262 contract HeartBoutToken is MintableToken {
263 	string public name;
264 	string public symbol;
265 	uint8 public decimals;
266 	function HeartBoutToken(string _name, string _symbol, uint8 _decimals) public {
267 		require(!stringEqual(_name, ""));
268 		require(!stringEqual(_symbol, ""));
269 		require(_decimals > 0);
270 		name = _name;
271 		symbol = _symbol;
272 		decimals = _decimals;
273 	}
274 }