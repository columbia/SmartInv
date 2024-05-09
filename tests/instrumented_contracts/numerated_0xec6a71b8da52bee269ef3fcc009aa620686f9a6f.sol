1 pragma solidity ^0.4.11;
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
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66     require(newOwner != address(0));      
67     owner = newOwner;
68   }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) constant returns (uint256);
80   function transfer(address to, uint256 value) returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) returns (bool);
91   function approve(address spender, uint256 value) returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances. 
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) returns (bool) {
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of. 
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) constant returns (uint256 balance) {
122     return balances[_owner];
123   }
124 
125 }
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
146     var _allowance = allowed[_from][msg.sender];
147 
148     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
149     // require (_value <= _allowance);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = _allowance.sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) returns (bool) {
164 
165     // To change the approve amount you first have to reduce the addresses`
166     //  allowance to zero by calling `approve(_spender, 0)` if it is not
167     //  already 0 to mitigate the race condition described here:
168     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
170 
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
183     return allowed[_owner][_spender];
184   }
185   
186     /*
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until 
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    */
192   function increaseApproval (address _spender, uint _addedValue) 
193     returns (bool success) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   function decreaseApproval (address _spender, uint _subtractedValue) 
200     returns (bool success) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
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
221   event Mint(address indexed to, uint256 amount);
222   event MintFinished();
223 
224   bool public mintingFinished = false;
225 
226 
227   modifier canMint() {
228     require(!mintingFinished);
229     _;
230   }
231 
232   /**
233    * @dev Function to mint tokens
234    * @param _to The address that will receive the minted tokens.
235    * @param _amount The amount of tokens to mint.
236    * @return A boolean that indicates if the operation was successful.
237    */
238   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
239     totalSupply = totalSupply.add(_amount);
240     balances[_to] = balances[_to].add(_amount);
241     Mint(_to, _amount);
242     Transfer(0x0, _to, _amount);
243     return true;
244   }
245 
246   /**
247    * @dev Function to stop minting new tokens.
248    * @return True if the operation was successful.
249    */
250   function finishMinting() onlyOwner returns (bool) {
251     mintingFinished = true;
252     MintFinished();
253     return true;
254   }
255 }
256 
257 contract CRFtoken is StandardToken, Ownable {
258   string public constant name = "CRF Coin";
259   string public constant symbol = "CRF";
260   uint public constant decimals = 0;
261 
262   function CRFtoken() {
263       totalSupply = 500000000;
264       balances[msg.sender] = totalSupply;
265   }
266 
267   function burn(uint _value) onlyOwner returns (bool) {
268     balances[msg.sender] = balances[msg.sender].sub(_value);
269     totalSupply = totalSupply.sub(_value);
270     Transfer(msg.sender, 0x0, _value);
271     return true;
272   }
273 
274 }