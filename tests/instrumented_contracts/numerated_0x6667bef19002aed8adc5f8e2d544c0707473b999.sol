1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwnership(address newOwner) onlyOwner 
16   {
17     require(newOwner != address(0));      
18     owner = newOwner;
19   }
20 
21 }
22 
23 contract Contactable is Ownable {
24 
25     string public contactInformation;
26 
27     function setContactInformation(string info) onlyOwner 
28     {
29       contactInformation = info;
30     }
31 }
32 
33 contract Destructible is Ownable {
34 
35   function Destructible() payable 
36   { 
37 
38   } 
39 
40   function destroy() onlyOwner 
41   {
42     selfdestruct(owner);
43   }
44 
45   function destroyAndSend(address _recipient) onlyOwner 
46   {
47     selfdestruct(_recipient);
48   }
49 }
50 
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   modifier whenPaused() {
63     require(paused);
64     _;
65   }
66 
67   function pause() onlyOwner whenNotPaused 
68   {
69     paused = true;
70     Pause();
71   }
72 
73   function unpause() onlyOwner whenPaused 
74   {
75     paused = false;
76     Unpause();
77   }
78 }
79 
80 
81 contract ERC20 {
82     uint256 public totalSupply;
83     function balanceOf(address who) constant returns (uint256);
84     
85     function transfer(address to, uint256 value) returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     
88     function allowance(address owner, address spender) constant returns (uint256);
89     function transferFrom(address from, address to, uint256 value) returns (bool);
90     
91     function approve(address spender, uint256 value) returns (bool);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
97     uint256 c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal constant returns (uint256) {
103     uint256 c = a / b;
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 contract StandardToken is ERC20 {
120     using SafeMath for uint256;
121     mapping(address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123 
124 
125  
126   function balanceOf(address _owner) constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 
131   function approve(address _spender, uint256 _value) returns (bool) {
132 
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144 }
145 
146 contract MintableToken is StandardToken, Ownable {
147   event Mint(address indexed to, uint256 amount);
148   event MintFinished();
149 
150   bool public mintingFinished = false;
151 
152 
153   modifier canMint() {
154     require(!mintingFinished);
155     _;
156   }
157 
158   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
159     totalSupply = totalSupply.add(_amount);
160     balances[_to] = balances[_to].add(_amount);
161     Mint(_to, _amount);
162     Transfer(0x0, _to, _amount);
163     return true;
164   }
165 
166   /**
167    * @dev Function to stop minting new tokens.
168    * @return True if the operation was successful.
169    */
170   function finishMinting() onlyOwner returns (bool) {
171     mintingFinished = true;
172     MintFinished();
173     return true;
174   }
175 }
176 
177 
178 contract BurnCoin is Ownable, Destructible, Contactable, MintableToken {
179     
180     using SafeMath for uint256;
181 
182     uint256 public startBlock;
183     uint256 public endBlock;
184 
185     address public wallet;
186 
187     uint256 public rate;
188 
189     uint256 public weiRaised;
190 
191     uint256 constant maxavailable = 10000000000000000000000;
192 
193     string public name = "BurnCoin";
194 
195     string public symbol = "BRN";
196     uint public decimals = 18;
197     uint public ownerstake = 5001000000000000000000;
198     address public owner;
199     bool public locked;
200     
201     modifier onlyUnlocked() {
202 
203       if (owner != msg.sender) {
204         require(false == locked);
205       }
206       _;
207     }
208 
209   function BurnCoin() {
210       startBlock = block.number;
211       endBlock = startBlock + 10000000;
212         
213       require(endBlock >= startBlock);
214         
215       rate = 1;
216       wallet = msg.sender;
217       locked = true;
218       owner = msg.sender;
219       totalSupply = maxavailable;
220       balances[owner] = maxavailable;
221       contactInformation = "BurnCoin (BRN) : Burn Fiat. Make Coin.";
222   }
223 
224   function unlock() onlyOwner 
225     {
226       require(locked);
227       locked = false;
228   }
229   
230   
231   function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
232     var _allowance = allowed[_from][msg.sender];
233 
234     balances[_to] = balances[_to].add(_value);
235     balances[_from] = balances[_from].sub(_value);
236     allowed[_from][msg.sender] = _allowance.sub(_value);
237     Transfer(_from, _to, _value);
238     return true;
239   }
240   
241    function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
242     balances[msg.sender] = balances[msg.sender].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     Transfer(msg.sender, _to, _value);
245     return true;
246   }
247 
248     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
249 
250     function () payable 
251     {
252         buyTokens(msg.sender);
253     }
254 
255     function buyTokens(address beneficiary) payable
256      {
257         require(beneficiary != 0x0);
258         require(validPurchase());
259         uint256 weiAmount = msg.value;
260         uint256 tokens = weiAmount.mul(rate);
261         weiRaised = weiRaised.add(weiAmount);
262         balances[owner] = balances[owner].sub(tokens);
263         balances[beneficiary] = balances[beneficiary].add(tokens);
264         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
265         forwardFunds();
266         
267     }
268 
269     function forwardFunds() internal 
270     {
271         wallet.transfer(msg.value);
272     }
273 
274     function validPurchase() internal constant returns (bool) {
275         uint256 current = block.number;
276         bool withinPeriod = current >= startBlock && current <= endBlock;
277         bool nonZeroPurchase = msg.value != 0;
278         bool nonMaxPurchase = msg.value <= 1000 ether;
279         bool maxavailableNotReached = balances[owner] > ownerstake;
280         return withinPeriod && nonZeroPurchase && nonMaxPurchase && maxavailableNotReached;
281     }
282 
283     function hasEnded() public constant returns (bool) {
284         return block.number > endBlock;
285     }
286 
287    function burn(uint _value) onlyOwner 
288    {
289         require(_value > 0);
290         address burner = msg.sender;
291         balances[burner] = balances[burner].sub(_value);
292         totalSupply = totalSupply.sub(_value);
293         Burn(burner, _value);
294     }
295 
296     event Burn(address indexed burner, uint indexed value);
297 
298 }