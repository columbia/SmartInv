1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) returns (bool);
53   function approve(address spender, uint256 value) returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) returns (bool) {
72     require(_to != address(0));
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
111     require(_to != address(0));
112 
113     var _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152   
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until 
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval (address _spender, uint _addedValue) 
160     returns (bool success) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval (address _spender, uint _subtractedValue) 
167     returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186   address public owner;
187 
188 
189   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191 
192   /**
193    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194    * account.
195    */
196   function Ownable() {
197     owner = msg.sender;
198   }
199 
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner);
206     _;
207   }
208 
209 
210   /**
211    * @dev Allows the current owner to transfer control of the contract to a newOwner.
212    * @param newOwner The address to transfer ownership to.
213    */
214   function transferOwnership(address newOwner) onlyOwner {
215     require(newOwner != address(0));      
216     OwnershipTransferred(owner, newOwner);
217     owner = newOwner;
218   }
219 
220 }
221 
222 
223 /**
224  * @title Mintable token
225  * @dev Simple ERC20 Token example, with mintable token creation
226  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
227  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
228  */
229 
230 contract MintableToken is StandardToken, Ownable {
231   event Mint(address indexed to, uint256 amount);
232   event MintFinished();
233 
234   bool public mintingFinished = false;
235 
236 
237   modifier canMint() {
238     require(!mintingFinished);
239     _;
240   }
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will receive the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
249     totalSupply = totalSupply.add(_amount);
250     balances[_to] = balances[_to].add(_amount);
251     Mint(_to, _amount);
252     Transfer(0x0, _to, _amount);
253     return true;
254   }
255 
256   /**
257    * @dev Function to stop minting new tokens.
258    * @return True if the operation was successful.
259    */
260   function finishMinting() onlyOwner returns (bool) {
261     mintingFinished = true;
262     MintFinished();
263     return true;
264   }
265 }
266 
267 contract GlobCoinToken is MintableToken {
268   using SafeMath for uint256;
269   string public constant name = "GlobCoin Crypto Platform";
270   string public constant symbol = "GCP";
271   uint8 public constant decimals = 18;
272 
273   modifier onlyMintingFinished() {
274     require(mintingFinished == true);
275     _;
276   }
277   /// @dev Same ERC20 behavior, but require the token to be unlocked
278   /// @param _spender address The address which will spend the funds.
279   /// @param _value uint256 The amount of tokens to be spent.
280   function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
281       return super.approve(_spender, _value);
282   }
283 
284   /// @dev Same ERC20 behavior, but require the token to be unlocked
285   /// @param _to address The address to transfer to.
286   /// @param _value uint256 The amount to be transferred.
287   function transfer(address _to, uint256 _value) public onlyMintingFinished returns (bool) {
288       return super.transfer(_to, _value);
289   }
290 
291   /// @dev Same ERC20 behavior, but require the token to be unlocked
292   /// @param _from address The address which you want to send tokens from.
293   /// @param _to address The address which you want to transfer to.
294   /// @param _value uint256 the amount of tokens to be transferred.
295   function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
296     return super.transferFrom(_from, _to, _value);
297   }
298 
299 }