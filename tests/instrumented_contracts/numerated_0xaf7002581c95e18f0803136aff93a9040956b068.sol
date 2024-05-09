1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9  
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = 0x482149F62258F6202D13e5219C92A6f9611Bf82d;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 /**
81  * @title ERC20Basic
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/179
84  */
85 contract ERC20Basic {
86   function totalSupply() public view returns (uint256);
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances. 
105  */
106 contract BasicToken is ERC20Basic, Ownable {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111  uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126  function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of. 
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transfered
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184  function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196    function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199   
200   
201   /**
202    * @dev Function to prevent eth transfers to this contract
203     */
204     function() public payable {
205 	    revert();
206 	}
207 	
208 	
209    /**
210    * @dev  Owner can transfer out any accidentally sent ERC20 tokens
211    */
212  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
213         return BasicToken(tokenAddress).transfer(owner, tokens);
214     }
215 
216 	
217   /**
218     * @dev Transfer the specified amounts of tokens to the specified addresses.
219     * @dev Be aware that there is no check for duplicate recipients.
220     *
221     * @param _toAddresses Receiver addresses.
222     * @param _amounts Amounts of tokens that will be transferred.
223     */
224     function multiSend(address[] _toAddresses, uint256[] _amounts) public {
225         /* Ensures _toAddresses array is less than or equal to 255 */
226         require(_toAddresses.length <= 255);
227         /* Ensures _toAddress and _amounts have the same number of entries. */
228         require(_toAddresses.length == _amounts.length);
229 
230         for (uint8 i = 0; i < _toAddresses.length; i++) {
231             transfer(_toAddresses[i], _amounts[i]);
232         }
233     }
234 
235     /**
236     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
237     * @dev Be aware that there is no check for duplicate recipients.
238     *
239     * @param _from The address of the sender
240     * @param _toAddresses The addresses of the recipients (MAX 255)
241     * @param _amounts The amounts of tokens to be transferred
242     */
243     function multiSendFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
244         /* Ensures _toAddresses array is less than or equal to 255 */
245         require(_toAddresses.length <= 255);
246         /* Ensures _toAddress and _amounts have the same number of entries. */
247         require(_toAddresses.length == _amounts.length);
248 
249         for (uint8 i = 0; i < _toAddresses.length; i++) {
250             transferFrom(_from, _toAddresses[i], _amounts[i]);
251         }
252     }
253 	
254 }
255 
256  
257 contract DCETToken is StandardToken {
258 
259   string public constant name = "Decentralized Faucet";
260   string public constant symbol = "DCET";
261   uint8 public constant decimals = 0; 
262 
263   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
264 
265   
266   function DCETToken() public {
267     totalSupply_ = INITIAL_SUPPLY;
268     balances[0x482149F62258F6202D13e5219C92A6f9611Bf82d] = INITIAL_SUPPLY;
269     Transfer(0x0, 0x482149F62258F6202D13e5219C92A6f9611Bf82d, INITIAL_SUPPLY);
270   }
271 
272 }