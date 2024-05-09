1 pragma solidity ^0.4.18;
2 
3 contract AbstractTRMBalances {
4     mapping(address => bool) public oldBalances;
5 }
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36     
37   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal constant returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal constant returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60   
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances. 
66  */
67 contract BasicToken is ERC20Basic {
68     
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) returns (bool) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amout of tokens to be transfered
112    */
113   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
114     var _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // require (_value <= _allowance);
118 
119     balances[_to] = balances[_to].add(_value);
120     balances[_from] = balances[_from].sub(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) returns (bool) {
132 
133     // To change the approve amount you first have to reduce the addresses`
134     //  allowance to zero by calling `approve(_spender, 0)` if it is not
135     //  already 0 to mitigate the race condition described here:
136     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
138 
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifing the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
151     return allowed[_owner][_spender];
152   }
153 
154 }
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162     
163   address public owner;
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner {
186     require(newOwner != address(0));      
187     owner = newOwner;
188   }
189 
190 }
191 
192 /**
193  * @title Mintable token
194  * @dev Simple ERC20 Token example, with mintable token creation
195  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
196  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
197  */
198 
199 contract MintableToken is StandardToken, Ownable {
200     
201   event Mint(address indexed to, uint256 amount);
202   
203   event MintFinished();
204 
205   bool public mintingFinished = false;
206 
207   modifier canMint() {
208     require(!mintingFinished);
209     _;
210   }
211 
212   /**
213    * @dev Function to mint tokens
214    * @param _to The address that will recieve the minted tokens.
215    * @param _amount The amount of tokens to mint.
216    * @return A boolean that indicates if the operation was successful.
217    */
218   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
219     totalSupply = totalSupply.add(_amount);
220     balances[_to] = balances[_to].add(_amount);
221     //Mint(_to, _amount);
222     Transfer(address(0), _to, _amount);
223     return true;
224   }
225 
226   /**
227    * @dev Function to stop minting new tokens.
228    * @return True if the operation was successful.
229    */
230   function finishMinting() onlyOwner returns (bool) {
231     mintingFinished = true;
232     MintFinished();
233     return true;
234   }
235   
236 }
237 
238 contract TRM2TokenCoin is MintableToken {
239     
240     string public constant name = "TerraMiner";
241     
242     string public constant symbol = "TRM2";
243     
244     uint32 public constant decimals = 8;
245     
246 }