1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * @dev Increase the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _addedValue The amount of tokens to increase the allowance by.
160    */
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   /**
168    * @dev Decrease the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To decrement
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
176    */
177   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 /**
191  * @title Ownable
192  * @dev The Ownable contract has an owner address, and provides basic authorization control
193  * functions, this simplifies the implementation of "user permissions".
194  */
195 contract Ownable {
196   address public owner;
197   address public admin;
198 
199 
200   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202 
203   /**
204    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
205    * account.
206    */
207   function Ownable() public {
208     owner = msg.sender;
209   }
210 
211 
212   /**
213    * @dev Throws if called by any account other than the owner.
214    */
215   modifier onlyOwner() {
216     require(msg.sender == owner || msg.sender == admin);
217     // require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) public onlyOwner {
227     require(newOwner != address(0));
228     OwnershipTransferred(owner, newOwner);
229     owner = newOwner;
230   }
231   
232   function transferAdmin(address newAdmin) public onlyOwner {
233     require(newAdmin != address(0));
234     OwnershipTransferred(admin, newAdmin);
235     admin = newAdmin;
236   }
237 
238 }
239 
240 /**
241  * @title Mintable token
242  * @dev Simple ERC20 Token example, with mintable token creation
243  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
244  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
245  */
246 contract MintableToken is StandardToken, Ownable {
247   event Mint(address indexed to, uint256 amount);
248   event MintFinished();
249 
250   bool public mintingFinished = false;
251 
252   modifier canMint() {
253     require(!mintingFinished);
254     _;
255   }
256 
257   /**
258    * @dev Function to mint tokens
259    * @param _to The address that will receive the minted tokens.
260    * @param _amount The amount of tokens to mint.
261    * @return A boolean that indicates if the operation was successful.
262    */
263   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
264     balances[_to] = balances[_to].add(_amount);
265     Mint(_to, _amount);
266     Transfer(address(0), _to, _amount);
267     return true;
268   }
269 
270   /**
271    * @dev Function to stop minting new tokens.
272    * @return True if the operation was successful.
273    */
274   function finishMinting() onlyOwner canMint public returns (bool) {
275     mintingFinished = true;
276     MintFinished();
277     return true;
278   }
279 }
280 
281 /**
282  * @title SampleCrowdsaleToken
283  * @dev Very simple ERC20 Token that can be minted.
284  * It is meant to be used in a crowdsale contract.
285  */
286 contract CarToken is MintableToken {
287   string public constant name = "car";
288   string public constant symbol = "CAR";
289   uint8 public constant decimals = 18;
290   uint256 public constant totalSupply = 1000000000 * (10 ** uint256(decimals));
291   
292   function CarToken(address _admin) {
293       admin = _admin;
294   }
295 }