1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) constant returns (uint256);
33   function transfer(address to, uint256 value) returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   /**
44   * @dev transfer token for a specified address
45   * @param _to The address to transfer to.
46   * @param _value The amount to be transferred.
47   */
48   function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   /**
56   * @dev Gets the balance of the specified address.
57   * @param _owner The address to query the the balance of. 
58   * @return An uint256 representing the amount owned by the passed address.
59   */
60   function balanceOf(address _owner) constant returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64 }
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) constant returns (uint256);
68   function transferFrom(address from, address to, uint256 value) returns (bool);
69   function approve(address spender, uint256 value) returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78 
79   /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amout of tokens to be transfered
84    */
85   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
86     var _allowance = allowed[_from][msg.sender];
87 
88     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
89     // require (_value <= _allowance);
90 
91     balances[_to] = balances[_to].add(_value);
92     balances[_from] = balances[_from].sub(_value);
93     allowed[_from][msg.sender] = _allowance.sub(_value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
100    * @param _spender The address which will spend the funds.
101    * @param _value The amount of tokens to be spent.
102    */
103   function approve(address _spender, uint256 _value) returns (bool) {
104 
105     // To change the approve amount you first have to reduce the addresses`
106     //  allowance to zero by calling `approve(_spender, 0)` if it is not
107     //  already 0 to mitigate the race condition described here:
108     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110 
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifing the amount of tokens still avaible for the spender.
121    */
122   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123     return allowed[_owner][_spender];
124   }
125 
126 }
127 
128 contract Ownable {
129   address public owner;
130 
131 
132   /**
133    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134    * account.
135    */
136   function Ownable() {
137     owner = msg.sender;
138   }
139 
140 
141   /**
142    * @dev Throws if called by any account other than the owner.
143    */
144   modifier onlyOwner() {
145     require(msg.sender == owner);
146     _;
147   }
148 
149 
150   /**
151    * @dev Allows the current owner to transfer control of the contract to a newOwner.
152    * @param newOwner The address to transfer ownership to.
153    */
154   function transferOwnership(address newOwner) onlyOwner {
155     if (newOwner != address(0)) {
156       owner = newOwner;
157     }
158   }
159 
160 }
161 
162 contract MintableToken is StandardToken, Ownable {
163   event Mint(address indexed to, uint256 amount);
164   event MintFinished();
165 
166   bool public mintingFinished = false;
167 
168 
169   modifier canMint() {
170     require(!mintingFinished);
171     _;
172   }
173 
174   /**
175    * @dev Function to mint tokens
176    * @param _to The address that will recieve the minted tokens.
177    * @param _amount The amount of tokens to mint.
178    * @return A boolean that indicates if the operation was successful.
179    */
180   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
181     totalSupply = totalSupply.add(_amount);
182     balances[_to] = balances[_to].add(_amount);
183     Mint(_to, _amount);
184     return true;
185   }
186 
187   /**
188    * @dev Function to stop minting new tokens.
189    * @return True if the operation was successful.
190    */
191   function finishMinting() onlyOwner returns (bool) {
192     mintingFinished = true;
193     MintFinished();
194     return true;
195   }
196 }
197 
198 contract PauseInfrastructure is Ownable {
199     event triggerUnpauseEvent();
200     event triggerPauseEvent();
201 
202     bool public paused;
203 
204     /**
205      * constructor assigns initial paused state
206      * @param _paused selects the initial pause state.
207      */
208     function PauseInfrastructure(bool _paused){
209         paused = _paused;
210     }
211 
212     /**
213      * @dev modifier to allow actions only when the contract IS paused
214      */
215     modifier whenNotPaused() {
216         if (paused) revert();
217         _;
218     }
219 
220     /**
221      * @dev modifier to allow actions only when the contract IS NOT paused
222      */
223     modifier whenPaused {
224         require (paused);
225         _;
226     }
227 }
228 
229 
230 contract Startable is PauseInfrastructure {
231   function Startable () PauseInfrastructure(true){
232   }
233 
234   // called by the owner to start
235   function start() onlyOwner whenPaused returns (bool) {
236     paused = false;
237     triggerUnpauseEvent();
238     return true;
239   }
240 }
241 
242 contract StartableMintableToken is Startable, MintableToken {
243 
244     function transfer(address _to, uint _value) whenNotPaused returns (bool){
245         return super.transfer(_to, _value);
246     }
247 
248     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
249         return super.transferFrom(_from, _to, _value);
250     }
251 }
252 
253 contract SeratioCoin is StartableMintableToken {
254     // Name of the token
255     string constant public name = "SeratioCoin";
256     // Token abbreviation
257     string constant public symbol = "SER";
258     // Decimal places
259     uint8 constant public decimals = 7;
260     // Zeros after the point
261     uint32 constant public DECIMAL_ZEROS = 10000000;
262 }