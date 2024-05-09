1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 /**
15  * @title ERC20 interface
16  */
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) returns (bool);
20   function approve(address spender, uint256 value) returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29     
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal constant returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53   
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61     
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
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  */
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) allowed;
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amout of tokens to be transfered
103    */
104   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
105     var _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
108     // require (_value <= _allowance);
109 
110     balances[_to] = balances[_to].add(_value);
111     balances[_from] = balances[_from].sub(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    * @param _spender The address which will spend the funds.
120    * @param _value The amount of tokens to be spent.
121    */
122   function approve(address _spender, uint256 _value) returns (bool) {
123 
124     // To change the approve amount you first have to reduce the addresses`
125     //  allowance to zero by calling `approve(_spender, 0)` if it is not
126     //  already 0 to mitigate the race condition described here:
127     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128 
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifing the amount of tokens still available for the spender.
139    */
140   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144 }
145 
146 /**
147  * @title Ownable
148  * @dev The Ownable contract has an owner address, and provides basic authorization control
149  * functions, this simplifies the implementation of "user permissions".
150  */
151 contract Ownable {
152     
153   address public owner;
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() {
160     owner = msg.sender;
161   }
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) onlyOwner {
176     require(newOwner != address(0));      
177     owner = newOwner;
178   }
179 
180 }
181 
182 /**
183  * @title Mintable token
184  * @dev Simple ERC20 Token example, with mintable token creation
185  */
186 
187 contract MintableToken is StandardToken, Ownable {
188     
189   event Mint(address indexed to, uint256 amount);
190   
191   event MintFinished();
192 
193   bool public mintingFinished = false;
194 
195   modifier canMint() {
196     require(!mintingFinished);
197     _;
198   }
199 
200   /**
201    * @dev Function to mint tokens
202    * @param _to The address that will recieve the minted tokens.
203    * @param _amount The amount of tokens to mint.
204    * @return A boolean that indicates if the operation was successful.
205    */
206   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
207     totalSupply = totalSupply.add(_amount);
208     balances[_to] = balances[_to].add(_amount);
209     Mint(_to, _amount);
210     return true;
211   }
212 
213   /**
214    * @dev Function to stop minting new tokens.
215    * @return True if the operation was successful.
216    */
217   function finishMinting() onlyOwner returns (bool) {
218     mintingFinished = true;
219     MintFinished();
220     return true;
221   }
222   
223 }
224 
225 contract SoyCoinToken is MintableToken {
226     
227     string public constant name = "SoyCoin";
228     
229     string public constant symbol = "SYC";
230     
231     uint32 public constant decimals = 18;
232     
233 }