1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     
51   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     uint256 c = a / b;
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72   
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) constant returns (uint256);
83   function transfer(address to, uint256 value) returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) returns (bool);
94   function approve(address spender, uint256 value) returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances. 
101  */
102 contract BasicToken is ERC20Basic {
103     
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) returns (bool) {
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of. 
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) constant returns (uint256 balance) {
126     return balances[_owner];
127   }
128 
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) allowed;
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // require (_value <= _allowance);
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) returns (bool) {
167 
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifing the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
186     return allowed[_owner][_spender];
187   }
188 
189 }
190 
191 /**
192  * @title Mintable token
193  * @dev Simple ERC20 Token example, with mintable token creation
194  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
195  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
196  */
197 
198 contract MintableToken is StandardToken, Ownable {
199     
200   event Mint(address indexed to, uint256 amount);
201   
202   event MintFinished();
203 
204   bool public mintingFinished = false;
205 
206   modifier canMint() {
207     require(!mintingFinished);
208     _;
209   }
210 
211   /**
212    * @dev Function to mint tokens
213    * @param _to The address that will recieve the minted tokens.
214    * @param _amount The amount of tokens to mint.
215    * @return A boolean that indicates if the operation was successful.
216    */
217   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
218     totalSupply = totalSupply.add(_amount);
219     balances[_to] = balances[_to].add(_amount);
220     Mint(_to, _amount);
221     return true;
222   }
223 
224   /**
225    * @dev Function to stop minting new tokens.
226    * @return True if the operation was successful.
227    */
228   function finishMinting() onlyOwner returns (bool) {
229     mintingFinished = true;
230     MintFinished();
231     return true;
232   }
233   
234 }
235 
236 contract EstateCoin is MintableToken {
237     
238     string public constant name = "EstateCoin";
239     
240     string public constant symbol = "ESC";
241     
242     uint32 public constant decimals = 2;
243     
244     uint256 public maxTokens = 12100000000000000000000000;
245 
246   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
247     if (totalSupply.add(_amount) > maxTokens) {
248         throw;
249     }
250 
251     return super.mint(_to, _amount);
252   }
253 }