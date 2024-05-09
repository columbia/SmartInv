1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53   address public owner;
54 
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 /**
89  * @title Claimable
90  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
91  * This allows the new owner to accept the transfer.
92  */
93 contract Claimable is Ownable {
94   address public pendingOwner;
95 
96   /**
97    * @dev Modifier throws if called by any account other than the pendingOwner.
98    */
99   modifier onlyPendingOwner() {
100     require(msg.sender == pendingOwner);
101     _;
102   }
103 
104   /**
105    * @dev Allows the current owner to set the pendingOwner address.
106    * @param newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address newOwner) onlyOwner public {
109     pendingOwner = newOwner;
110   }
111 
112   /**
113    * @dev Allows the pendingOwner address to finalize the transfer.
114    */
115   function claimOwnership() onlyPendingOwner public {
116     OwnershipTransferred(owner, pendingOwner);
117     owner = pendingOwner;
118     pendingOwner = address(0);
119   }
120 }
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 /**
261  * @title ILMTToken
262  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
263  * Note they can later distribute these tokens as they wish using `transfer` and other
264  * `StandardToken` functions.
265  */
266 contract ILMTToken is StandardToken {
267 
268   string public constant name = "The Illuminati Token";
269   string public constant symbol = "ILMT";
270   uint8 public constant decimals = 18;
271 
272   uint256 public constant INITIAL_SUPPLY = 33000000 * (10 ** uint256(decimals));
273 
274   /**
275    * @dev Constructor that gives msg.sender all of existing tokens.
276    */
277   function ILMTToken() public {
278     totalSupply = INITIAL_SUPPLY;
279     balances[msg.sender] = INITIAL_SUPPLY;
280   }
281 
282 }