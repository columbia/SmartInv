1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Basic token
28  * @dev Basic version of StandardToken, with no allowances.
29  */
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32 
33   mapping(address => uint256) balances;
34 
35   /**
36   * @dev transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) returns (bool) {
41     balances[msg.sender] = balances[msg.sender].sub(_value);
42     balances[_to] = balances[_to].add(_value);
43     Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 
47   /**
48   * @dev Gets the balance of the specified address.
49   * @param _owner The address to query the the balance of.
50   * @return An uint256 representing the amount owned by the passed address.
51   */
52   function balanceOf(address _owner) constant returns (uint256 balance) {
53     return balances[_owner];
54   }
55 
56 }
57 
58 
59 /**
60  * @title Standard ERC20 token
61  *
62  * @dev Implementation of the basic standard token.
63  * @dev https://github.com/ethereum/EIPs/issues/20
64  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
65  */
66 contract StandardToken is ERC20, BasicToken {
67 
68   mapping (address => mapping (address => uint256)) allowed;
69 
70 
71   /**
72    * @dev Transfer tokens from one address to another
73    * @param _from address The address which you want to send tokens from
74    * @param _to address The address which you want to transfer to
75    * @param _value uint256 the amout of tokens to be transfered
76    */
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
78     var _allowance = allowed[_from][msg.sender];
79 
80     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
81     // require (_value <= _allowance);
82 
83     balances[_to] = balances[_to].add(_value);
84     balances[_from] = balances[_from].sub(_value);
85     allowed[_from][msg.sender] = _allowance.sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   /**
91    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
92    * @param _spender The address which will spend the funds.
93    * @param _value The amount of tokens to be spent.
94    */
95   function approve(address _spender, uint256 _value) returns (bool) {
96 
97     // To change the approve amount you first have to reduce the addresses`
98     //  allowance to zero by calling `approve(_spender, 0)` if it is not
99     //  already 0 to mitigate the race condition described here:
100     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
102 
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   /**
109    * @dev Function to check the amount of tokens that an owner allowed to a spender.
110    * @param _owner address The address which owns the funds.
111    * @param _spender address The address which will spend the funds.
112    * @return A uint256 specifing the amount of tokens still avaible for the spender.
113    */
114   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115     return allowed[_owner][_spender];
116   }
117 
118 }
119 
120 
121 /**
122  * @title SafeMath
123  * @dev Math operations with safety checks that throw on error
124  */
125 library SafeMath {
126   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
127     uint256 c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130   }
131 
132   function div(uint256 a, uint256 b) internal constant returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return c;
137   }
138 
139   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   function add(uint256 a, uint256 b) internal constant returns (uint256) {
145     uint256 c = a + b;
146     assert(c >= a);
147     return c;
148   }
149 }
150 
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158   address public owner;
159 
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() {
166     owner = msg.sender;
167   }
168 
169 
170   /**
171    * @dev Throws if called by any account other than the owner.
172    */
173   modifier onlyOwner() {
174     require(msg.sender == owner);
175     _;
176   }
177 
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner {
184     if (newOwner != address(0)) {
185       owner = newOwner;
186     }
187   }
188 
189 }
190 
191 /**
192  * @title Burnable Token
193  * @dev Token that can be irreversibly burned (destroyed).
194  */
195 contract BurnableToken is StandardToken {
196 
197     /**
198      * @dev Burns a specific amount of tokens.
199      * @param _value The amount of token to be burned.
200      */
201     function burn(uint _value)
202         public
203     {
204         require(_value > 0);
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         Burn(burner, _value);
210     }
211 
212     event Burn(address indexed burner, uint indexed value);
213 }
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 contract MintableToken is StandardToken, Ownable {
222   event Mint(address indexed to, uint256 amount);
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226 
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will recieve the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
240     totalSupply = totalSupply.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     Mint(_to, _amount);
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
257 contract AlisToken is MintableToken, BurnableToken {
258 
259   string public constant name = 'AlisToken';
260 
261   string public constant symbol = 'ALIS';
262 
263   // same as ether. (1ether=1wei * (10 ** 18))
264   uint public constant decimals = 18;
265 }