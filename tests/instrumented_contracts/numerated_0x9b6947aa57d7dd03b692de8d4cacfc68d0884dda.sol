1 pragma solidity ^0.4.21;
2 
3 contract AbstractTRMBalances {
4     mapping(address => bool) public oldBalances;
5 }
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36     
37   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal constant returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal constant returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60   
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances. 
66  */
67 contract BasicToken is ERC20Basic {
68     
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) returns (bool) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 /**
98  * @title Burnable Token
99  * @dev Token that can be irreversibly burned (destroyed).
100  */
101 contract BurnableToken is BasicToken {
102 
103   event Burn(address indexed burner, uint256 value);
104 
105   /**
106    * @dev Burns a specific amount of tokens.
107    * @param _value The amount of token to be burned.
108    */
109   function burn(uint256 _value) public {
110     require(_value <= balances[msg.sender]);
111     // no need to require value <= totalSupply, since that would imply the
112     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
113 
114     address burner = msg.sender;
115     balances[burner] = balances[burner].sub(_value);
116     totalSupply = totalSupply.sub(_value);
117     Burn(burner, _value);
118     Transfer(burner, address(0), _value);
119   }
120 } 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BurnableToken {
130 
131   mapping (address => mapping (address => uint256)) allowed;
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amout of tokens to be transfered
138    */
139   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
140     var _allowance = allowed[_from][msg.sender];
141 
142     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143     // require (_value <= _allowance);
144 
145     balances[_to] = balances[_to].add(_value);
146     balances[_from] = balances[_from].sub(_value);
147     allowed[_from][msg.sender] = _allowance.sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) returns (bool) {
158 
159     // To change the approve amount you first have to reduce the addresses`
160     //  allowance to zero by calling `approve(_spender, 0)` if it is not
161     //  already 0 to mitigate the race condition described here:
162     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifing the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
177     return allowed[_owner][_spender];
178   }
179 
180 }
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188     
189   address public owner;
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() {
196     owner = msg.sender;
197   }
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) onlyOwner {
212     require(newOwner != address(0));      
213     owner = newOwner;
214   }
215 
216 }
217 
218 /**
219  * @title Mintable token
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 
225 contract MintableToken is StandardToken, Ownable {
226     
227   event Mint(address indexed to, uint256 amount);
228   
229   event MintFinished();
230 
231   bool public mintingFinished = false;
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will recieve the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     //Mint(_to, _amount);
248     Transfer(address(0), _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261   
262 }
263 
264 contract MonopolyCoin is MintableToken {
265     
266     string public constant name = "Monopoly";
267     
268     string public constant symbol = "MNP"; 
269     
270     uint32 public constant decimals = 18; 
271     
272 }