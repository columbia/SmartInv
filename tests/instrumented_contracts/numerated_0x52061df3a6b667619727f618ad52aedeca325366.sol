1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) constant returns (uint256);
9   function transfer(address to, uint256 value) returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
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
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still available for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155     
156   address public owner;
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner {
179     require(newOwner != address(0));      
180     owner = newOwner;
181   }
182 
183 }
184 
185 /**
186  * @title Mintable token
187  * @dev Simple ERC20 Token example, with mintable token creation
188  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
189  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
190  */
191 
192 contract MintableToken is StandardToken, Ownable {
193     
194   event Mint(address indexed to, uint256 amount);
195   
196   event MintFinished();
197 
198   bool public mintingFinished = false;
199 
200   modifier canMint() {
201     require(!mintingFinished);
202     _;
203   }
204 
205   /**
206    * @dev Function to mint tokens
207    * @param _to The address that will recieve the minted tokens.
208    * @param _amount The amount of tokens to mint.
209    * @return A boolean that indicates if the operation was successful.
210    */
211   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
212     totalSupply = totalSupply.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     //Mint(_to, _amount);
215     Transfer(address(0), _to, _amount);
216     return true;
217   }
218 
219   /**
220    * @dev Function to stop minting new tokens.
221    * @return True if the operation was successful.
222    */
223   function finishMinting() onlyOwner returns (bool) {
224     mintingFinished = true;
225     MintFinished();
226     return true;
227   }
228   
229 }
230 
231 contract ANWTokenCoin is MintableToken {
232     
233     string public constant name = "Animal Walfare Token Contract";
234     
235     string public constant symbol = "ANW";
236     
237     uint32 public constant decimals = 18;
238     
239 }
240 
241 
242 contract ANWCrowdsale is Ownable {
243     using SafeMath for uint;
244     
245     address public multisig = 0x99FDbd0d52ba6fcd49b4B5c149D37E4e1326BE7d; 
246     ANWTokenCoin public token =  ANWTokenCoin(0x48abb37EE5a6BCf220f046acA6F6F3217ae60eCc);
247     uint public tokenDec = 1000000000000000000;
248     uint public tokenPrice = 10000000000000000;
249     
250     
251     function ANWCrowdsale(){
252         owner = msg.sender; 
253     }
254     
255 
256     
257     function tokenBalance() constant returns (uint256) {
258         return token.balanceOf(address(this));
259     }        
260     
261 
262     
263     function transferToken(address _to, uint _value) onlyOwner returns (bool) {
264         return token.transfer(_to,  _value);
265     }
266     
267     function() payable {
268         doPurchase();
269     }
270 
271     function doPurchase() payable {
272 
273         require(msg.value > 0); 
274         
275         uint tokensAmount = msg.value.mul(tokenDec).div(tokenPrice);
276         
277         require(token.transfer(msg.sender, tokensAmount));
278         multisig.transfer(msg.value);
279         
280         
281     }
282     
283 }