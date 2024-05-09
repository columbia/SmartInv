1 pragma solidity ^0.4.13;
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
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public constant returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
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
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) allowed;
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
115 
116     uint256 _allowance = allowed[_from][msg.sender];
117 
118     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
119     // require (_value <= _allowance);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = _allowance.sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    * From MonolithDAO Token.sol
159    */
160   function increaseApproval (address _spender, uint _addedValue)
161     returns (bool success) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval (address _spender, uint _subtractedValue)
168     returns (bool success) {
169     uint oldValue = allowed[msg.sender][_spender];
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174     }
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179 }
180 
181 
182 /**
183  * @title SafeERC20
184  * @dev Wrappers around ERC20 operations that throw on failure.
185  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
186  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
187  */
188 library SafeERC20 {
189   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
190     assert(token.transfer(to, value));
191   }
192 
193   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
194     assert(token.transferFrom(from, to, value));
195   }
196 
197   function safeApprove(ERC20 token, address spender, uint256 value) internal {
198     assert(token.approve(spender, value));
199   }
200 }
201 
202 
203 /**
204  * @title Ownable
205  * @dev The Ownable contract has an owner address, and provides basic authorization control
206  * functions, this simplifies the implementation of "user permissions".
207  */
208 contract Ownable {
209   address public owner;
210 
211 
212   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214 
215   /**
216    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
217    * account.
218    */
219   function Ownable() {
220     owner = msg.sender;
221   }
222 
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232 
233   /**
234    * @dev Allows the current owner to transfer control of the contract to a newOwner.
235    * @param newOwner The address to transfer ownership to.
236    */
237   function transferOwnership(address newOwner) onlyOwner public {
238     require(newOwner != address(0));
239     OwnershipTransferred(owner, newOwner);
240     owner = newOwner;
241   }
242 
243 }
244 
245 
246 /**
247  * @title Contracts that should be able to recover tokens
248  * @author SylTi
249  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
250  * This will prevent any accidental loss of tokens.
251  */
252 contract CanReclaimToken is Ownable {
253   using SafeERC20 for ERC20Basic;
254 
255   /**
256    * @dev Reclaim all ERC20Basic compatible tokens
257    * @param token ERC20Basic The address of the token contract
258    */
259   function reclaimToken(ERC20Basic token) external onlyOwner {
260     uint256 balance = token.balanceOf(this);
261     token.safeTransfer(owner, balance);
262   }
263 
264 }
265 
266 /**
267  * @title EestyCoinToken contract
268  * @author Anatollix
269  */
270 contract EestyCoinToken is StandardToken, CanReclaimToken {
271     using SafeMath for uint256;
272 
273     string public name = "EESTYCOIN";
274     string public symbol = "EEC";
275     uint256 public decimals = 18;
276 
277     uint8 public emissionStage;
278     uint256[3] public emissionStages;
279 
280     modifier canDoEmission() {
281         require(emissionStage < 3);
282         _;
283     }
284 
285     event Emission(uint8 stage, uint256 amount);
286 
287     function EestyCoinToken() {
288         emissionStages[0] = 10000000000000000000000000; // totalSupply 10 000 000
289         emissionStages[1] = 990000000000000000000000000; // totalSupply 1 000 000 000
290         emissionStages[2] = 7000000000000000000000000000; // totalSupply 8 000 000 000
291     }
292 
293     function nextStageEmission() canDoEmission onlyOwner public {
294         uint256 emission = emissionStages[emissionStage];
295 
296         totalSupply = totalSupply.add(emission);
297         balances[owner] = balances[owner].add(emission);
298         emissionStage = emissionStage + 1;
299 
300         Emission(emissionStage, emission);
301         Transfer(0x0, owner, emission);
302     }
303 }