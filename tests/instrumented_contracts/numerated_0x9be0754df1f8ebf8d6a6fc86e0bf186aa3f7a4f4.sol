1 pragma solidity ^0.4.17;
2 
3 /// @title Phase One of SEC Coin Crowd Sale, 9% of total supply, 1 ETH = 7,000 SEC
4 /// Our homepage: http://sectech.me/
5 /// Sale is under the protect of contract.
6 /// @author Diana Kudrow
7 
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract Ownable {
16   address public owner;
17 
18   ///@dev The Ownable constructor sets the original `owner` of the contract to the senderaccount.
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23   /// @dev Throws if called by any account other than the owner.
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 }
38 
39 contract Pausable is Ownable {
40   event Pause();
41   event Unpause();
42   bool public paused = false;
43 
44   /// @dev modifier to allow actions only when the contract IS paused
45   modifier whenNotPaused() {
46     require(!paused);_;
47   }
48 
49   /// @dev modifier to allow actions only when the contract IS NOT paused
50   modifier whenPaused {
51     require(paused);_;
52   }
53 
54   /// @dev called by the owner to pause, triggers stopped state
55   function pause() onlyOwner whenNotPaused returns (bool) {
56     paused = true;
57     Pause();
58     return true;
59   }
60 
61   /// @dev called by the owner to unpause, returns to normal state
62   function unpause() onlyOwner whenPaused returns (bool) {
63     paused = false;
64     Unpause();
65     return true;
66   }
67 }
68 
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) constant returns (uint256);
71   function transferFrom(address from, address to, uint256 value) returns (bool);
72   function approve(address spender, uint256 value) returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
78     uint256 c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal constant returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 contract BasicToken is ERC20Basic, Ownable {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) returns (bool) {
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) constant returns (uint256 balance) {
124     return balances[_owner];
125   }
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129   mapping (address => mapping (address => uint256)) allowed;
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
140     // require (_value <= _allowance);
141 
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) returns (bool) {
155 
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender, 0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
161 
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifing the amount of tokens still avaible for the spender.
172    */
173   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
174     return allowed[_owner][_spender];
175   }
176 
177 }
178 
179 contract BurnableToken is StandardToken, Pausable {
180 
181     event Burn(address indexed burner, uint256 value);
182 
183     function transfer(address _to, uint _value) whenNotPaused returns (bool) {
184     return super.transfer(_to, _value);
185     }
186 
187     function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
188     return super.transferFrom(_from, _to, _value);
189     }
190 
191     /**
192      * @dev Burns a specified amount of tokens from messager sender's account.
193      * @param _value The amount of tokens to burn.
194      */
195     function burn(uint256 _value) whenNotPaused public {
196         require(_value > 0);
197         balances[msg.sender] = balances[msg.sender].sub(_value);
198         totalSupply = totalSupply.sub(_value);  // reduce total supply after burn
199         Burn(msg.sender, _value);
200     }
201 }
202 
203 contract SECToken is BurnableToken {
204 
205     string public constant symbol = "SEC";
206     string public name = "Erised(SEC)";
207     uint8 public constant decimals = 18;
208 
209     function SECToken() {
210         uint256 _totalSupply = 567648000; // 3600sec * 24hr * 365day * 18year
211         uint256 capacity = _totalSupply.mul(1 ether);
212         totalSupply = balances[msg.sender] = capacity;
213     }
214 
215     function setName(string name_) onlyOwner {
216         name = name_;
217     }
218 
219     function burn(uint256 _value) whenNotPaused public {
220         super.burn(_value);
221     }
222 
223 }
224 
225 contract SecCrowdSale is Pausable{
226     using SafeMath for uint;
227 
228     // Total Supply of CrowdSale first period
229     uint public constant MAX_CAP = 51088320000000000000000000;  //51,088,320 SEC Coin, 9% of total supply
230     // Minimum amount to invest
231     uint public constant MIN_INVEST_ETHER = 0.1 ether;
232     // Crowdsale period
233     uint private constant CROWDSALE_PERIOD = 15 days;
234     // Number of SECCoins per Ether
235     uint public constant SEC_PER_ETHER = 7000000000000000000000; // 1ETH = 7,000 SEC Coin
236     // SEC Token main contract address
237     address public constant SEC_contract = 0x41ff967f9f8ec58abf88ca1caa623b3fd6277191;
238 
239     //SECCoin contract reference
240     SECToken public SECCoin;
241     // Number of Ether received
242     uint public etherReceived;
243     // Number of SECCoins sent to Ether contributors
244     uint public SECCoinSold;
245     // Crowdsale start time
246     uint public startTime;
247     // Crowdsale end time
248     uint public endTime;
249     // Is crowdsale still on going
250     bool public crowdSaleClosed;
251 
252     modifier respectTimeFrame() {
253         require((now >= startTime) || (now <= endTime ));_;
254     }
255 
256     event LogReceivedETH(address addr, uint value);
257     event LogCoinsEmited(address indexed from, uint amount);
258 
259     function CrowdSale() {
260         SECCoin = SECToken(SEC_contract);
261     }
262 
263     /// The fallback function corresponds to a donation in ETH
264     function() whenNotPaused respectTimeFrame payable {
265         BuyTokenSafe(msg.sender);
266     }
267 
268     /*
269      * To call to start the crowdsale
270      */
271     function start() onlyOwner external{
272         require(startTime == 0); // Crowdsale was already started
273         startTime = now ;
274         endTime =  now + CROWDSALE_PERIOD;
275     }
276 
277     /// Receives a donation in Etherose, send SEC token immediately
278     function BuyTokenSafe(address beneficiary) internal {
279         require(msg.value >= MIN_INVEST_ETHER); // Don't accept funding under a predefined threshold
280         uint SecToSend = msg.value.mul(SEC_PER_ETHER).div(1 ether); // Compute the number of SECCoin to send
281         require(SecToSend.add(SECCoinSold) <= MAX_CAP);
282         SECCoin.transfer(beneficiary, SecToSend); // Transfer SEC Coins right now
283         etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
284         SECCoinSold = SECCoinSold.add(SecToSend);
285         // Send events
286         LogCoinsEmited(msg.sender ,SecToSend);
287         LogReceivedETH(beneficiary, etherReceived);
288     }
289 
290     /// Close the crowdsale, should be called after the refund period
291     function finishSafe(address burner) onlyOwner external{
292         require(burner!=address(0));
293         require(now > endTime || SECCoinSold == MAX_CAP); // end time or sold out
294         owner.send(this.balance); // Move the remaining Ether to contract founder address
295         uint remains = SECCoin.balanceOf(this);
296         if (remains > 0) { // Burn the rest of SECCoins
297             SECCoin.transfer(burner, remains);
298         }
299         crowdSaleClosed = true;
300     }
301 }