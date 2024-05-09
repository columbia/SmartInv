1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) constant returns (uint256);
16   function transferFrom(address from, address to, uint256 value) returns (bool);
17   function approve(address spender, uint256 value) returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26     
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50   
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances. 
56  */
57 contract BasicToken is ERC20Basic {
58     
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) returns (bool) {
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of. 
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 /**
87  * @title Standard ERC20 token
88  *
89  * @dev Implementation of the basic standard token.
90  * @dev https://github.com/ethereum/EIPs/issues/20
91  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
92  */
93 contract StandardToken is ERC20, BasicToken {
94 
95   mapping (address => mapping (address => uint256)) allowed;
96 
97   /**
98    * @dev Transfer tokens from one address to another
99    * @param _from address The address which you want to send tokens from
100    * @param _to address The address which you want to transfer to
101    * @param _value uint256 the amout of tokens to be transfered
102    */
103   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
104     var _allowance = allowed[_from][msg.sender];
105 
106     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
107     // require (_value <= _allowance);
108 
109     balances[_to] = balances[_to].add(_value);
110     balances[_from] = balances[_from].sub(_value);
111     allowed[_from][msg.sender] = _allowance.sub(_value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
118    * @param _spender The address which will spend the funds.
119    * @param _value The amount of tokens to be spent.
120    */
121   function approve(address _spender, uint256 _value) returns (bool) {
122 
123     // To change the approve amount you first have to reduce the addresses`
124     //  allowance to zero by calling `approve(_spender, 0)` if it is not
125     //  already 0 to mitigate the race condition described here:
126     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
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
185  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
186  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
187  */
188 
189 contract MintableToken is StandardToken, Ownable {
190     
191   event Mint(address indexed to, uint256 amount);
192   
193   event MintFinished();
194 
195   bool public mintingFinished = false;
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will recieve the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(address(0), _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225   
226 }
227 
228 contract CBMTokenCoin is MintableToken {
229     
230     string public constant name = "Crypto Bonus Miles Token";
231     
232     string public constant symbol = "CBM";
233     
234     uint32 public constant decimals = 18;
235     
236 }