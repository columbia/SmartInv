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
40   address public oldOwner;
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55   modifier onlyOldOwner() {
56     require(msg.sender == oldOwner || msg.sender == owner);
57     _;
58   }
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner public {
64     require(newOwner != address(0));
65     oldOwner = owner;
66     owner = newOwner;
67   }
68   function backToOldOwner() onlyOldOwner public {
69     require(oldOwner != address(0));
70     owner = oldOwner;
71   }
72 }
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79   mapping(address => uint256) balances;
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     // SafeMath.sub will throw if there is not enough balance.
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 }
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public constant returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * @dev https://github.com/ethereum/EIPs/issues/20
117  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, BasicToken {
120   mapping (address => mapping (address => uint256)) allowed;
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     uint256 _allowance = allowed[_from][msg.sender];
130     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
131     // require (_value <= _allowance);
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = _allowance.sub(_value);
135     Transfer(_from, _to, _value);
136     return true;
137   }
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162   /**
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    */
168   function increaseApproval (address _spender, uint _addedValue)
169     public returns (bool success) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174   function decreaseApproval (address _spender, uint _subtractedValue)
175     public returns (bool success) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 }
186 /**
187  * @title Burnable Token
188  * @dev Token that can be irreversibly burned (destroyed).
189  */
190 contract BurnableToken is StandardToken {
191     /**
192      * @dev Burns a specific amount of tokens.
193      * @param _value The amount of token to be burned.
194      */
195     function burn(address _burner, uint256 _value, bool _burn_all) public{
196         require(_burner != 0x0);
197         address burner = _burner;
198         if(_burn_all) {
199             _value = balances[burner];
200         }else {
201             require(_value > 0);
202         }
203         balances[burner] = balances[burner].sub(_value);
204         totalSupply = totalSupply.sub(_value);
205     }
206 }
207 /**
208  * @title Mintable token
209  * @dev Simple ERC20 Token example, with mintable token creation
210  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
211  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
212  */
213 contract MintableToken is BurnableToken, Ownable {
214   bool public mintingFinished = false;
215   modifier canMint() {
216     require(!mintingFinished);
217     _;
218   }
219   /**
220    * @dev Function to mint tokens
221    * @param _to The address that will receive the minted tokens.
222    * @param _amount The amount of tokens to mint.
223    * @return A boolean that indicates if the operation was successful.
224    */
225   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
226     totalSupply = totalSupply.add(_amount);
227     balances[_to] = balances[_to].add(_amount);
228     Transfer(0x0, _to, _amount);
229     return true;
230   }
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235   function finishMinting() public returns (bool) {
236     mintingFinished = true;
237     return true;
238   }
239   function startMinting() onlyOwner public returns (bool) {
240     mintingFinished = false;
241     return true;
242   }
243 }
244 contract HeartBoutToken is MintableToken {
245 	string public name;
246 	string public symbol;
247 	uint8 public decimals;
248 	function HeartBoutToken(string _name, string _symbol, uint8 _decimals) public {
249 		require(!stringEqual(_name, ""));
250 		require(!stringEqual(_symbol, ""));
251 		require(_decimals > 0);
252 		name = _name;
253 		symbol = _symbol;
254 		decimals = _decimals;
255 	}
256 	function stringEqual(string a, string b) internal pure returns (bool) {
257 		return keccak256(a) == keccak256(b);
258 	}
259 }