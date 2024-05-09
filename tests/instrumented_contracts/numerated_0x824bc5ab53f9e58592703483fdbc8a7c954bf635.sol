1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
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
74     require(_to != address(0));
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116 
117     uint256 _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161   function increaseApproval (address _spender, uint _addedValue)
162     returns (bool success) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   function decreaseApproval (address _spender, uint _subtractedValue)
169     returns (bool success) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180 }
181 
182 
183 /**
184  * @title Ownable
185  * @dev The Ownable contract has an owner address, and provides basic authorization control
186  * functions, this simplifies the implementation of "user permissions".
187  */
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() {
200     owner = msg.sender;
201   }
202 
203 
204   /**
205    * @dev Throws if called by any account other than the owner.
206    */
207   modifier onlyOwner() {
208     require(msg.sender == owner);
209     _;
210   }
211 
212 
213   /**
214    * @dev Allows the current owner to transfer control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function transferOwnership(address newOwner) onlyOwner public {
218     require(newOwner != address(0));
219     OwnershipTransferred(owner, newOwner);
220     owner = newOwner;
221   }
222 
223 }
224 
225 /**
226  * @title Mintable token
227  * @dev Simple ERC20 Token example, with mintable token creation
228  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
229  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
230  */
231 
232 contract MintableToken is StandardToken, Ownable {
233   event Mint(address indexed to, uint256 amount);
234   event MintFinished();
235 
236   bool public mintingFinished = false;
237 
238 
239   modifier canMint() {
240     require(!mintingFinished);
241     _;
242   }
243 
244   /**
245    * @dev Function to mint tokens
246    * @param _to The address that will receive the minted tokens.
247    * @param _amount The amount of tokens to mint.
248    * @return A boolean that indicates if the operation was successful.
249    */
250   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
251     totalSupply = totalSupply.add(_amount);
252     balances[_to] = balances[_to].add(_amount);
253     Mint(_to, _amount);
254     Transfer(0x0, _to, _amount);
255     return true;
256   }
257 
258   /**
259    * @dev Function to stop minting new tokens.
260    * @return True if the operation was successful.
261    */
262   function finishMinting() onlyOwner public returns (bool) {
263     mintingFinished = true;
264     MintFinished();
265     return true;
266   }
267 }
268 
269 
270 contract YobCoin is MintableToken {
271   string public name = "YOBANK";
272   string public symbol = "YOB";
273   uint256 public decimals = 18;
274 }