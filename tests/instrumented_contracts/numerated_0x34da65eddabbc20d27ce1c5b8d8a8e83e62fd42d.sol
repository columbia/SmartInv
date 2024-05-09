1 /*
2 Xsearch Token
3 */
4 pragma solidity ^0.4.16;
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) constant returns (uint256);
14   function transfer(address to, uint256 value) returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) constant returns (uint256);
24   function transferFrom(address from, address to, uint256 value) returns (bool);
25   function approve(address spender, uint256 value) returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34     
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58   
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances. 
64  */
65 contract BasicToken is ERC20Basic {
66     
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) returns (bool) {
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
88   function balanceOf(address _owner) constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifing the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152 }
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160     
161   address public owner;
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner {
184     require(newOwner != address(0));      
185     owner = newOwner;
186   }
187 
188 }
189 
190 /**
191  * @title Burnable Token
192  * @dev Token that can be irreversibly burned (destroyed).
193  */
194 contract BurnableToken is StandardToken {
195 
196   /**
197    * @dev Burns a specific amount of tokens.
198    * @param _value The amount of token to be burned.
199    */
200   function burn(uint _value) public {
201     require(_value > 0);
202     address burner = msg.sender;
203     balances[burner] = balances[burner].sub(_value);
204     totalSupply = totalSupply.sub(_value);
205     Burn(burner, _value);
206   }
207 
208   event Burn(address indexed burner, uint indexed value);
209 
210 }
211 
212 contract XsearchToken is BurnableToken {
213     
214   string public constant name = "XSearch Token";
215    
216   string public constant symbol = "XSE";
217     
218   uint32 public constant decimals = 18;
219 
220   uint256 public INITIAL_SUPPLY = 30000000 * 1 ether;
221 
222   function XsearchToken() {
223     totalSupply = INITIAL_SUPPLY;
224     balances[msg.sender] = INITIAL_SUPPLY;
225   }
226     
227 }
228 
229 contract Crowdsale is Ownable {
230     
231   using SafeMath for uint;
232     
233   address multisig;
234 
235   uint restrictedPercent;
236 
237   address restricted;
238 
239   XsearchToken public token = new XsearchToken();
240 
241   uint start;
242     
243   uint period;
244 
245   uint rate;
246 
247   function Crowdsale() {
248     multisig = 0xd4DB7d2086C46CDd5F21c46613B520290ABfC9D6; //escrow wallet
249     restricted = 0x25fbfaA7bB3FfEb697Fe59Bb464Fc49299ef5563; // wallet for 15%
250     restrictedPercent = 15; // 15% procent for Founders, Bounties, Distribution cost, Management costs
251     rate = 1000000000000000000000; //rate
252     start = 1522195200;  //start date
253     period = 63; // ico period
254   }
255 
256   modifier saleIsOn() {
257     require(now > start && now < start + period * 1 days);
258     _;
259   }
260 
261     /*
262     Bonus: 
263     private ico 40% (min 20 eth) 28.03-05.04
264     pre-ico 30% (min 0.5 eth) 05.04-20.04
265     main ico
266     R1(20.04-26.04): +15%min deposit 0.1ETH;    
267     R2(27.04-06.05): +10% min deposit 0.1ETH;  
268     R3(07.05-15.05): +5% bonus; min deposit 0.1ETH;  
269     R4(16.05-30.05): 0% bonus;  min deposit 0.1ETH;
270     */    
271 
272 function createTokens() saleIsOn payable {
273    multisig.transfer(msg.value);
274    uint tokens = rate.mul(msg.value).div(1 ether);
275    uint bonusTokens = 0;
276    uint saleTime = period * 1 days;
277    if(now >= start && now < start + 8 * 1 days) {
278        bonusTokens = tokens.mul(40).div(100);
279    } else if(now >= start + 8 * 1 days && now < start + 24 * 1 days) {
280        bonusTokens = tokens.mul(30).div(100);
281    } else if(now >= start + 24 * 1 days && now <= start + 30 * 1 days) {
282        bonusTokens = tokens.mul(15).div(100);
283    } else if(now >= start + 31 * 1 days && now <= start + 40 * 1 days) {
284        bonusTokens = tokens.mul(10).div(100);
285    } else if(now >= start + 41 * 1 days && now <= start + 49 * 1 days) {
286        bonusTokens = tokens.mul(5).div(100);
287    } else if(now >= start + 50 * 1 days && now <= start + 64 * 1 days) {
288        bonusTokens = 0;
289    } else {
290        bonusTokens = 0;
291    }
292    uint tokensWithBonus = tokens.add(bonusTokens);
293    token.transfer(msg.sender, tokensWithBonus);
294    uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);
295    token.transfer(restricted, restrictedTokens);
296  }
297 
298   function() external payable {
299     createTokens();
300   }
301     
302 }