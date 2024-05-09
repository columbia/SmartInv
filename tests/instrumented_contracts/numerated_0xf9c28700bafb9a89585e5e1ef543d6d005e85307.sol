1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) view public returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) view public returns (uint256);
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
67   mapping(address => uint256) public hold;  
68 
69   modifier onlyPayloadSize(uint size) {
70        assert(msg.data.length >= size + 4);
71        _;
72    }
73 
74    modifier canTransfer() {
75        if(hold[msg.sender] > 0){
76           require(now > hold[msg.sender]);
77        }
78         _;
79    }
80 
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value)canTransfer onlyPayloadSize(2 * 32) public returns (bool) {
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) view public returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) allowed;
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amout of tokens to be transfered
121    */
122   function transferFrom(address _from, address _to, uint256 _value)canTransfer public returns (bool) {
123     var _allowance = allowed[_from][msg.sender];
124 
125     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126     // require (_value <= _allowance);
127 
128     balances[_to] = balances[_to].add(_value);
129     balances[_from] = balances[_from].sub(_value);
130     allowed[_from][msg.sender] = _allowance.sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141 
142     // To change the approve amount you first have to reduce the addresses`
143     //  allowance to zero by calling `approve(_spender, 0)` if it is not
144     //  already 0 to mitigate the race condition described here:
145     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147 
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifing the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163 }
164 
165 /**
166  * @title Ownable
167  * @dev The Ownable contract has an owner address, and provides basic authorization control
168  * functions, this simplifies the implementation of "user permissions".
169  */
170 contract Ownable {
171 
172   address public owner;
173 
174   /**
175    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
176    * account.
177    */
178   function Ownable() public{
179     owner = msg.sender;
180   }
181 
182   /**
183    * @dev Throws if called by any account other than the owner.
184    */
185   modifier onlyOwner() {
186     require(msg.sender == owner);
187     _;
188   }
189 
190   /**
191    * @dev Allows the current owner to transfer control of the contract to a newOwner.
192    * @param newOwner The address to transfer ownership to.
193    */
194   function transferOwnership(address newOwner) onlyOwner public{
195     require(newOwner != address(0));
196     owner = newOwner;
197   }
198 
199 }
200 
201 /**
202  * @title Burnable Token
203  * @dev Token that can be irreversibly burned (destroyed).
204  */
205 contract BurnableToken is StandardToken {
206 
207   /**
208    * @dev Burns a specific amount of tokens.
209    * @param _value The amount of token to be burned.
210    */
211   function burn(uint _value) public {
212     require(_value > 0);
213     address burner = msg.sender;
214     balances[burner] = balances[burner].sub(_value);
215     totalSupply = totalSupply.sub(_value);
216     Burn(burner, _value);
217   }
218 
219   event Burn(address indexed burner, uint indexed value);
220 
221 }
222 
223 /**
224 * @dev https://t.me/contractDev
225 */
226 
227 contract Bettium is BurnableToken, Ownable {
228 
229     string public constant name = "BETTIUM";
230 
231     string public constant symbol = "BETT";
232 
233     uint public constant decimals = 18;
234 
235     //External company wallets
236     address public walletICO =     0x7B4609b29b308Fd168a044A4993789391AB08703;   
237 
238 
239     function Bettium()public{
240 
241         totalSupply = 1000000000*10**decimals;
242 
243         balances[walletICO] = totalSupply;
244         transferFrom(this,walletICO, 0);
245         
246     }
247 
248     /**
249     * @dev Set hold for investing address
250     */
251     function setHold(address _address, uint _timeHold) onlyOwner public{
252 
253         hold[_address] = _timeHold;
254 
255 
256     }
257 
258 
259 
260 
261 
262 }