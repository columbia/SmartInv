1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) view public returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) view public returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67   //время заморозки токенов для команды 2018-10-31T00:00:00+00:00 in ISO 8601
68   uint public constant timeFreezeTeamTokens = 1540944000;
69   
70   address public walletTeam = 0x7eF1ac89B028A9Bc20Ce418c1e6973F4c7977eB0;
71 
72   modifier onlyPayloadSize(uint size) {
73        assert(msg.data.length >= size + 4);
74        _;
75    }
76    
77    modifier canTransfer() {
78        if(msg.sender == walletTeam){
79           require(now > timeFreezeTeamTokens); 
80        }
81         _;
82    }
83 
84 
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value)canTransfer onlyPayloadSize(2 * 32) public returns (bool) {
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of. 
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) view public returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) allowed;
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amout of tokens to be transfered
125    */
126   function transferFrom(address _from, address _to, uint256 _value)canTransfer public returns (bool) {
127     var _allowance = allowed[_from][msg.sender];
128 
129     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
130     // require (_value <= _allowance);
131 
132     balances[_to] = balances[_to].add(_value);
133     balances[_from] = balances[_from].sub(_value);
134     allowed[_from][msg.sender] = _allowance.sub(_value);
135     Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145 
146     // To change the approve amount you first have to reduce the addresses`
147     //  allowance to zero by calling `approve(_spender, 0)` if it is not
148     //  already 0 to mitigate the race condition described here:
149     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
151 
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifing the amount of tokens still available for the spender.
162    */
163   function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
164     return allowed[_owner][_spender];
165   }
166 
167 }
168 
169 /**
170  * @title Ownable
171  * @dev The Ownable contract has an owner address, and provides basic authorization control
172  * functions, this simplifies the implementation of "user permissions".
173  */
174 contract Ownable {
175     
176   address public owner;
177 
178   /**
179    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180    * account.
181    */
182   function Ownable() public{
183     owner = msg.sender;
184   }
185 
186   /**
187    * @dev Throws if called by any account other than the owner.
188    */
189   modifier onlyOwner() {
190     require(msg.sender == owner);
191     _;
192   }
193 
194   /**
195    * @dev Allows the current owner to transfer control of the contract to a newOwner.
196    * @param newOwner The address to transfer ownership to.
197    */
198   function transferOwnership(address newOwner) onlyOwner public{
199     require(newOwner != address(0));      
200     owner = newOwner;
201   }
202 
203 }
204 
205 /**
206  * @title Burnable Token
207  * @dev Token that can be irreversibly burned (destroyed).
208  */
209 contract BurnableToken is StandardToken {
210  
211   /**
212    * @dev Burns a specific amount of tokens.
213    * @param _value The amount of token to be burned.
214    */
215   function burn(uint _value) public {
216     require(_value > 0);
217     address burner = msg.sender;
218     balances[burner] = balances[burner].sub(_value);
219     totalSupply = totalSupply.sub(_value);
220     Burn(burner, _value);
221   }
222  
223   event Burn(address indexed burner, uint indexed value);
224  
225 }
226 
227 /**
228 * @dev https://t.me/devKatAlexeeva
229 */
230 
231 contract LoanBit is BurnableToken, Ownable {
232     
233     string public constant name = "LoanBit";
234     
235     string public constant symbol = "LBT";
236     
237     uint public constant decimals = 18;
238     
239     
240     
241     //Внутренние кошельки компании
242     address public walletICO =     0x8ffF4a8c4F1bd333a215f072ef9AEF934F677bFa;
243     uint public tokenICO = 31450000*10**decimals; 
244     address public walletTeam =    0x7eF1ac89B028A9Bc20Ce418c1e6973F4c7977eB0;
245     uint public tokenTeam = 2960000*10**decimals; 
246     address public walletAdvisor = 0xB6B01233cE7794D004aF238b3A53A0FcB1c5D8BD;
247     uint public tokenAdvisor = 1480000*10**decimals; 
248     
249     //кошельки для баунти программы
250     
251     address public walletAvatar =   0x9E6bA5600cF5f4656697E3aF2A963f56f522991C;
252     uint public tokenAvatar = 444000*10**decimals;
253     address public walletFacebook = 0x43827ba49d8eBd20afD137791227d3139E5BD074;
254     uint public tokenFacebook = 155400*10**decimals;
255     address public walletTwitter =  0xeFF945E9F29eA8c7a94F84Fb9fFd711d179ab520;
256     uint public tokenTwitter = 155400*10**decimals;
257     address public walletBlogs   =  0x16Df4Dc0Dd47dDD47759d54957C021650c76aed1;
258     uint public tokenBlogs = 210900*10**decimals;
259     address public walletTranslate =  0x19A903405fDcce9b32f48882C698A3842f09253F;
260     uint public tokenTranslate = 133200*10**decimals;
261     address public walletEmail   =  0x3912AE42372ff35f56d2f7f26313da7F48Fe5248;
262     uint public tokenEmail = 11100*10**decimals;
263     
264     //кошелек разработчика
265     address public walletDev = 0xF4e16e79102B19702Cc10Cbcc02c6EC0CcAD8b1D;
266     uint public tokenDev = 6000*10**decimals;
267     
268     function LoanBit()public{
269         
270         totalSupply = 37000000*10**decimals;
271         
272         balances[walletICO] = tokenICO;
273         transferFrom(this,walletICO, 0);
274         
275         
276         balances[walletTeam] = tokenTeam;
277         transferFrom(this,walletTeam, 0);
278         
279         
280         balances[walletAdvisor] = tokenAdvisor;
281         transferFrom(this,walletAdvisor, 0);
282         
283         balances[walletDev] = tokenDev;
284         transferFrom(this,walletDev, 0);
285         
286         balances[walletAvatar] = tokenAvatar;
287         transferFrom(this,walletAvatar, 0);
288         
289         balances[walletFacebook] = tokenFacebook;
290         transferFrom(this,walletFacebook, 0);
291         
292         balances[walletTwitter] = tokenTwitter;
293         transferFrom(this,walletTwitter, 0);
294         
295         balances[walletBlogs] = tokenBlogs;
296         transferFrom(this,walletBlogs, 0);
297         
298         balances[walletTranslate] = tokenTranslate;
299         transferFrom(this,walletTranslate, 0);
300         
301         balances[walletEmail] = tokenEmail;
302         transferFrom(this,walletEmail, 0);
303         
304     }
305     
306    
307 }