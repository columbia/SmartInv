1 pragma solidity ^0.4.24;
2 
3 // Based on https://github.com/OpenZeppelin/zeppelin-solidity
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
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
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * approve should be called when allowed[_spender] == 0. To increment
151    * allowed value is better to use this function to avoid 2 calls (and wait until
152    * the first transaction is mined)
153    * From MonolithDAO Token.sol
154    */
155   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 /////////////////
216 // YourTOKEN   //
217 /////////////////
218 
219 contract ROBUtilityToken is StandardToken, Ownable {
220     
221     using SafeMath for uint256;
222     
223     // Descriptive properties
224     string public constant name = "RobertMiller";
225     string public constant symbol = "ROB";
226     uint256 public constant decimals = 18;
227     string public version = "7.0";
228     bool public hasBeenConstructed = false;
229 
230     // Account for ether proceed.
231     address public etherProceedsAccount = 0x220A2D1E8872b74Ce2214B0B734882b6168564dc ;
232 
233     // Reserve account for 90% of ROB creation cap.
234     address public ReserveAccount = 0x220A2D1E8872b74Ce2214B0B734882b6168564dc ;
235     uint256 public constant ROBReserveAllocation = 90 * (10**5) * 10**decimals;
236 
237     // These params specify the start, end, min, and max of the sale.
238     uint256 public fundingStartBlock = 5859014;
239     uint256 public fundingEndBlock = 6100000;
240     uint256 public constant tokenCreationCap =  10 * (10**6) * 10**decimals;
241     
242     // Setting the exchange rate for the ROB utility token sale.
243     uint256 public constant ROBEthExchangeRate = 400;
244 
245     // Event for token creation.
246     event CreateROB(address indexed _to, uint256 _value);
247 
248     // constructor
249     function ROB() public
250     {
251       if (hasBeenConstructed) revert();
252       totalSupply                 = ROBReserveAllocation;
253       balances[ReserveAccount] = ROBReserveAllocation;
254       CreateROB(ReserveAccount, ROBReserveAllocation);
255       hasBeenConstructed = true;
256     }
257 
258     function createTokens() payable external {
259       if (block.number < fundingStartBlock) revert();
260       if (block.number > fundingEndBlock) revert();
261       if (msg.value == 0) revert();
262 
263       uint256 tokens = ROBEthExchangeRate.mul(msg.value);
264       uint256 checkedSupply = totalSupply.add(tokens);
265 
266       if (tokenCreationCap < checkedSupply) revert();
267 
268       totalSupply = checkedSupply;
269       balances[msg.sender] += tokens;
270       CreateROB(msg.sender, tokens);
271       etherProceedsAccount.transfer(this.balance);
272     }
273 
274 }