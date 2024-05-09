1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   /**
38   * @dev transfer token for a specified address
39   * @param _to The address to transfer to.
40   * @param _value The amount to be transferred.
41   */
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(_to != address(0));
44 
45     // SafeMath.sub will throw if there is not enough balance.
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   /**
53   * @dev Gets the balance of the specified address.
54   * @param _owner The address to query the the balance of.
55   * @return An uint256 representing the amount owned by the passed address.
56   */
57   function balanceOf(address _owner) public constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 
64 
65 
66 /**
67  * @title Standard ERC20 token
68  *
69  * @dev Implementation of the basic standard token.
70  * @dev https://github.com/ethereum/EIPs/issues/20
71  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
72  */
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86 
87     uint256 _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    *
102    * Beware that changing an allowance with this method brings the risk that someone may use both the old
103    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106    * @param _spender The address which will spend the funds.
107    * @param _value The amount of tokens to be spent.
108    */
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifying the amount of tokens still available for the spender.
120    */
121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125   /**
126    * approve should be called when allowed[_spender] == 0. To increment
127    * allowed value is better to use this function to avoid 2 calls (and wait until
128    * the first transaction is mined)
129    * From MonolithDAO Token.sol
130    */
131   function increaseApproval (address _spender, uint _addedValue)
132     returns (bool success) {
133     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135     return true;
136   }
137 
138   function decreaseApproval (address _spender, uint _subtractedValue)
139     returns (bool success) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 
150 }
151 
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner public {
188     require(newOwner != address(0));
189     OwnershipTransferred(owner, newOwner);
190     owner = newOwner;
191   }
192 
193 }
194 
195 
196 
197 /**
198  * @title Mintable token
199  * @dev Simple ERC20 Token example, with mintable token creation
200  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
201  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
202  */
203 
204 contract MintableToken is StandardToken, Ownable {
205   event Mint(address indexed to, uint256 amount);
206   event MintFinished();
207 
208   bool public mintingFinished = false;
209 
210 
211   modifier canMint() {
212     require(!mintingFinished);
213     _;
214   }
215 
216   /**
217    * @dev Function to mint tokens
218    * @param _to The address that will receive the minted tokens.
219    * @param _amount The amount of tokens to mint.
220    * @return A boolean that indicates if the operation was successful.
221    */
222   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
223     totalSupply = totalSupply.add(_amount);
224     balances[_to] = balances[_to].add(_amount);
225     Mint(_to, _amount);
226     Transfer(0x0, _to, _amount);
227     return true;
228   }
229 
230   /**
231    * @dev Function to stop minting new tokens.
232    * @return True if the operation was successful.
233    */
234   function finishMinting() onlyOwner public returns (bool) {
235     mintingFinished = true;
236     MintFinished();
237     return true;
238   }
239 }
240 
241 
242 /**
243  * @title SafeMath
244  * @dev Math operations with safety checks that throw on error
245  */
246 library SafeMath {
247   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
248     uint256 c = a * b;
249     assert(a == 0 || c / a == b);
250     return c;
251   }
252 
253   function div(uint256 a, uint256 b) internal constant returns (uint256) {
254     // assert(b > 0); // Solidity automatically throws when dividing by 0
255     uint256 c = a / b;
256     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257     return c;
258   }
259 
260   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
261     assert(b <= a);
262     return a - b;
263   }
264 
265   function add(uint256 a, uint256 b) internal constant returns (uint256) {
266     uint256 c = a + b;
267     assert(c >= a);
268     return c;
269   }
270 }
271 
272 contract DekzCoin is MintableToken {
273   string public name = "DEKZ COIN";
274   string public symbol = "DKZ";
275   uint256 public decimals = 18;
276 }