1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant public returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant public returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 
92 /**
93  * @title Burnable Token
94  * @dev Token that can be irreversibly burned (destroyed).
95  */
96 contract BurnableToken is BasicToken {
97 
98   event Burn(address indexed burner, uint256 value);
99 
100   /**
101    * @dev Burns a specific amount of tokens.
102    * @param _value The amount of token to be burned.
103    */
104   function burn(uint256 _value) public {
105     require(_value <= balances[msg.sender]);
106     // no need to require value <= totalSupply, since that would imply the
107     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
108 
109     address burner = msg.sender;
110     balances[burner] = balances[burner].sub(_value);
111     totalSupply = totalSupply.sub(_value);
112     emit Burn(burner, _value);
113     emit Transfer(burner, address(0), _value);
114   }
115 } 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BurnableToken {
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amout of tokens to be transfered
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     uint256 _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
138     // require (_value <= _allowance);
139 
140     balances[_to] = balances[_to].add(_value);
141     balances[_from] = balances[_from].sub(_value);
142     allowed[_from][msg.sender] = _allowance.sub(_value);
143     emit Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153 
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender, 0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
159 
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifing the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183     
184   address public owner;
185 
186   /**
187    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188    * account.
189    */
190   constructor() public {
191     owner = msg.sender;
192   }
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) public onlyOwner {
207     require(newOwner != address(0));      
208     owner = newOwner;
209   }
210 
211 }
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221     
222   event Mint(address indexed to, uint256 amount);
223   
224   event MintFinished();
225 
226   bool public mintingFinished = false;
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will recieve the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
240     totalSupply = totalSupply.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     emit Mint(_to, _amount);
243     emit Transfer(address(0), _to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner public returns (bool) {
252     mintingFinished = true;
253     emit MintFinished();
254     return true;
255   }
256   
257 }
258 
259 contract MonopolyCoin is MintableToken {
260     
261     string public constant name = "Monopoly";
262     
263     string public constant symbol = "MNP"; 
264     
265     uint32 public constant decimals = 8; 
266     
267 }