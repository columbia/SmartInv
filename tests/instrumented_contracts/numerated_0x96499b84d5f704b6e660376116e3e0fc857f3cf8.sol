1 pragma solidity ^0.4.11;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract ERC20Basic {
26   uint256 public totalSupply;
27   function balanceOf(address who) constant returns (uint256);
28   function transfer(address to, uint256 value) returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 contract ERC20 is ERC20Basic {
33   function allowance(address owner, address spender) constant returns (uint256);
34   function transferFrom(address from, address to, uint256 value) returns (bool);
35   function approve(address spender, uint256 value) returns (bool);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41   mapping(address => uint256) balances;
42   //address[] public addressLUT;
43   /**
44   * @dev transfer token for a specified address
45   * @param _to The address to transfer to.
46   * @param _value The amount to be transferred.
47   */
48   function transfer(address _to, uint256 _value) returns (bool) {
49       
50     // Check to see if transfer window has been reached
51     require (now >= 1512835200); // transfers can't happen until 3mo after sale ends (1512835200)
52     
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58   /**
59   * @dev Gets the balance of the specified address.
60   * @param _owner The address to query the the balance of. 
61   * @return An uint256 representing the amount owned by the passed address.
62   */
63   function balanceOf(address _owner) constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66 }
67 
68 contract StandardToken is ERC20, BasicToken {
69   mapping (address => mapping (address => uint256)) allowed;
70   /**
71    * @dev Transfer tokens from one address to another
72    * @param _from address The address which you want to send tokens from
73    * @param _to address The address which you want to transfer to
74    * @param _value uint256 the amout of tokens to be transfered
75    */
76   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
77     var _allowance = allowed[_from][msg.sender];
78     
79     // Check to see if transfer window has been reached
80     require (now >= 1512835200); // transfers can't happen until 3mo after sale ends (1512835200)
81     balances[_to] = balances[_to].add(_value);
82     balances[_from] = balances[_from].sub(_value);
83     allowed[_from][msg.sender] = _allowance.sub(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87   /**
88    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
89    * @param _spender The address which will spend the funds.
90    * @param _value The amount of tokens to be spent.
91    */
92   function approve(address _spender, uint256 _value) returns (bool) {
93     // To change the approve amount you first have to reduce the addresses`
94     //  allowance to zero by calling `approve(_spender, 0)` if it is not
95     //  already 0 to mitigate the race condition described here:
96     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
98     allowed[msg.sender][_spender] = _value;
99     Approval(msg.sender, _spender, _value);
100     return true;
101   }
102   /**
103    * @dev Function to check the amount of tokens that an owner allowed to a spender.
104    * @param _owner address The address which owns the funds.
105    * @param _spender address The address which will spend the funds.
106    * @return A uint256 specifing the amount of tokens still available for the spender.
107    */
108   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
109     return allowed[_owner][_spender];
110   }
111 }
112 
113 /**
114  * Upgrade agent interface inspired by Lunyr.
115  *
116  * Upgrade agent transfers tokens to a new contract.
117  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
118  */
119 contract UpgradeAgent {
120   /** Interface marker */
121   function isUpgradeAgent() public constant returns (bool) {
122     return true;
123   }
124   function upgradeFrom(address _from, uint256 _value) public;
125 }
126 
127 contract PSIToken is StandardToken {
128     address public owner;
129     string public constant name = "Protostarr"; // Protostarr
130     string public constant symbol = "PSR"; // PSR
131     uint256 public constant decimals = 4;
132     
133     // Address for founder's PSI token and ETH deposits
134     address public constant founders_addr = 0xEa16ebd8Cdf5A51fa0a80bFA5665146b2AB82210;
135     
136     UpgradeAgent public upgradeAgent;
137     uint256 public totalUpgraded;
138     
139     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
140     
141     event UpgradeAgentSet(address agent);
142     function setUpgradeAgent(address agent) external {
143         if (agent == 0x0) revert();
144         // Only owner can designate the next agent
145         if (msg.sender != owner) revert();
146         upgradeAgent = UpgradeAgent(agent);
147         
148         // Bad interface
149         if(!upgradeAgent.isUpgradeAgent()) revert();
150         UpgradeAgentSet(upgradeAgent);
151     }
152     function upgrade(uint256 value) public {
153         
154         if(address(upgradeAgent) == 0x00) revert();
155         // Validate input value.
156         if (value <= 0) revert();
157         
158         balances[msg.sender] = balances[msg.sender].sub(value);
159         
160         // Take tokens out from circulation
161         totalSupply = totalSupply.sub(value);
162         totalUpgraded = totalUpgraded.add(value);
163         
164         // Upgrade agent reissues the tokens
165         upgradeAgent.upgradeFrom(msg.sender, value);
166         Upgrade(msg.sender, upgradeAgent, value);
167     }
168 
169     // Constructor
170     function PSIToken() {
171         // set owner as sender
172         owner = msg.sender;
173         
174         // add founders to address LUT
175         //addressLUT.push(founders_addr);
176     }
177     // check to see if sender is owner
178     modifier onlyOwner() {
179         require(msg.sender == owner);
180         _;
181     }
182     
183     // Allows the current owner to transfer control of the contract to a newOwner.
184     // newOwner The address to transfer ownership to.
185     function transferOwnership(address newOwner) onlyOwner {
186         require(newOwner != address(0));      
187         owner = newOwner;
188     }
189     // catch received ether
190     function () payable {
191         createTokens(msg.sender);
192     }
193     // issue tokens for received ether
194     function createTokens(address recipient) payable {
195         if(msg.value<=uint256(1 ether).div(600)) {
196             revert();
197         }
198     
199         uint multiplier = 10 ** decimals;
200     
201         // create tokens for buyer
202         uint tokens = ((msg.value.mul(getPrice())).mul(multiplier)).div(1 ether);
203         totalSupply = totalSupply.add(tokens);
204         balances[recipient] = balances[recipient].add(tokens);      
205         
206         // add buyer to address LUT
207         //addressLUT.push(founders_addr);        
208         
209         // create 10% additional tokens for founders
210         uint ftokens = tokens.div(10);
211         totalSupply = totalSupply.add(ftokens);
212         balances[founders_addr] = balances[founders_addr].add(ftokens);
213     
214         // send ETH for buy to founders
215         if(!founders_addr.send(msg.value)) {
216             revert();
217         }
218     
219     }
220   
221     // get tiered pricing based on block.timestamp, or revert transaction if before/after sale times
222     // Unix Timestamps
223     // 1502640000 power hour start (170 tokens)
224     // 1502643600 week 1 start (150 tokens)
225     // 1503244800 week 2 start (130 tokens)
226     // 1503849600 week 3 start (110 tokens)
227     // 1504454400 week 4 start (100 tokens)
228     // 1505059200 SALE ENDS
229     // 1512835200 transfer period begins
230     function getPrice() constant returns (uint result) {
231         if (now < 1502640000) { // before power hour  1502640000
232             revert(); // DISQUALIFIED!!! There's one every season!!!
233         } else {
234             if (now < 1502645400) { // before week 1 start (in power hour)  1502643600 (new 1502645400)
235                 return 170;
236             } else {
237                 if (now < 1503244800) { // before week 2 start (in week 1)  1503244800
238                     return 150;
239                 } else {
240                     if (now < 1503849600) { // before week 3 start (in week 2)  1503849600
241                         return 130;
242                     } else {
243                         if (now < 1504454400) { // before week 4 start (in week 3)  1504454400
244                             return 110;
245                         } else {
246                             if (now < 1505059200) { // before end of sale (in week 4)  1505059200
247                                 return 100;
248                             } else {
249                                 revert(); // sale has ended, kill transaction
250                             }
251                         }
252                     }
253                 }
254             }
255         }
256     }
257   
258 }