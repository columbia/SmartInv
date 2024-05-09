1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     /**
8     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9     * account.
10     */
11     constructor () public {
12         owner = msg.sender;
13     }
14 
15     /**
16     * @dev Throws if called by any account other than the owner.
17     */
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23 }
24 
25 
26 contract Pausable is Ownable {
27   
28   event Pause();
29   event Unpause();
30 
31   bool public paused = false;
32 
33   /**
34    * @dev Modifier to make a function callable only when the contract is not paused.
35   */
36   modifier whenNotPaused() {
37     require(!paused);
38     _;
39   }
40 
41   /**
42    * @dev Modifier to make a function callable only when the contract is paused.
43   */
44   modifier whenPaused() {
45     require(paused);
46     _;
47   }
48 
49   /**
50    * @dev called by the owner to pause, triggers stopped state
51   */
52   function pause() onlyOwner whenNotPaused public {
53     paused = true;
54     emit Pause();
55   }
56 
57   /**
58    * @dev called by the owner to unpause, returns to normal state
59   */
60   function unpause() onlyOwner whenPaused public {
61     paused = false;
62     emit Unpause();
63   }
64 }
65  
66  
67 library SafeMath {
68     
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a); 
90     return c;
91   }
92 }
93 
94  
95 contract TokenERC20 {
96     function balanceOf(address who) public constant returns (uint);
97     function allowance(address owner, address spender) public constant returns (uint);
98     
99     function transfer(address to, uint value) public  returns (bool ok);
100     function transferFrom(address from, address to, uint value) public  returns (bool ok);
101     
102     function approve(address spender, uint value) public returns (bool ok);
103     
104     event Transfer(address indexed from, address indexed to, uint value);
105     event Approval(address indexed owner, address indexed spender, uint value);
106 } 
107 
108 contract TokenERC20Standart is TokenERC20, Pausable{
109     
110         using SafeMath for uint256;
111             
112             
113         // create array with all blances    
114         mapping(address => uint) public balances;
115         mapping(address => mapping(address => uint)) public allowed;
116         
117         /**
118         * @dev Fix for the ERC20 short address attack.
119         */
120         modifier onlyPayloadSize(uint size) {
121             require(msg.data.length >= size + 4) ;
122             _;
123         }
124             
125        
126         function balanceOf(address tokenOwner) public constant whenNotPaused  returns (uint balance) {
127              return balances[tokenOwner];
128         }
129  
130         function transfer(address to, uint256 tokens) public  whenNotPaused onlyPayloadSize(2*32) returns (bool success) {
131             _transfer(msg.sender, to, tokens);
132             return true;
133         }
134  
135 
136         function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
137             allowed[msg.sender][spender] = tokens;
138             emit Approval(msg.sender, spender, tokens);
139             return true;
140         }
141  
142         function transferFrom(address from, address to, uint tokens) public whenNotPaused onlyPayloadSize(3*32) returns (bool success) {
143             assert(tokens > 0);
144             require (to != 0x0);    
145             require(balances[from] >= tokens);
146             require(balances[to] + tokens >= balances[to]); // overflow
147             require(allowed[from][msg.sender] >= tokens);
148             balances[from] = balances[from].sub(tokens);
149             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
150             balances[to] = balances[to].add(tokens);
151             emit Transfer(from, to, tokens);
152             return true;
153         }
154 
155         function allowance(address tokenOwner, address spender) public  whenNotPaused constant returns (uint remaining) {
156             return allowed[tokenOwner][spender];
157         }
158 
159         function _transfer(address _from, address _to, uint _value) internal {
160             assert(_value > 0);
161             require (_to != 0x0);                              
162             require (balances[_from] >= _value);               
163             require (balances[_to] + _value >= balances[_to]);
164             balances[_from] = balances[_from].sub(_value);                        
165             balances[_to] = balances[_to].add(_value);                           
166             emit Transfer(_from, _to, _value);
167         }
168 
169  
170 
171 }
172 
173 
174 contract BeringiaContract is TokenERC20Standart{
175     
176     using SafeMath for uint256;
177     
178     string public name;                         // token name
179     uint256 public decimals;                    // Amount of decimals for display purposes 
180     string public symbol;                       // symbol token
181     string public version;                      // contract version 
182 
183     uint256 public _totalSupply = 0;                    // number bought tokens
184     uint256 public constant RATE = 2900;                // count tokens per 1ETH
185     uint256 public fundingEndTime  = 1538179200000;     // final date ico
186     uint256 public minContribution = 350000000000000;   // min price onr token
187     uint256 public oneTokenInWei = 1000000000000000000;
188     uint256 public tokenCreationCap;                    // count created tokens
189 
190     //discount period dates
191     uint256 private firstPeriodEND = 1532217600000;
192     uint256 private secondPeriodEND = 1534896000000;
193     uint256 private thirdPeriodEND = 1537574400000;
194    
195     //discount percentages 
196     uint256 private firstPeriodDis = 25;
197     uint256 private secondPeriodDis = 20;
198     uint256 private thirdPeriodDis = 15;  
199     
200     uint256 private foundersTokens;                     // tokens for founders
201     uint256 private depositorsTokens;                   // tokens for depositors
202     
203     constructor () public {
204         name = "Beringia";                                          // Set the name for display purposes
205         decimals = 0;                                               // Amount of decimals for display purposes
206         symbol = "BER";                                             // Set the symbol for display purposes
207         owner = 0xdc889afED1ab326966c51E58abBEdC98b4d0DF64;         // Set contract owner
208         version = "1.0";                                            // Set contract version 
209         tokenCreationCap = 510000000 * 10 ** uint256(decimals);
210         balances[owner] = tokenCreationCap;                         // Give the creator all initial tokens
211         emit Transfer(address(0x0), owner, tokenCreationCap);
212         foundersTokens = tokenCreationCap / 10;                     // 10% will be sent to the founders
213         depositorsTokens = tokenCreationCap.sub(foundersTokens);    // left 90% will be for depositors
214     }
215     
216     function transfer(address _to, uint _value) public  returns (bool) {
217         return super.transfer(_to, _value);
218     }
219 
220     function transferFounderTokens(address _to, uint _value) public onlyOwner whenNotPaused returns (bool){
221         require(foundersTokens > 0);
222         require(foundersTokens.sub(_value) >= 0);
223         foundersTokens = foundersTokens.sub(_value);
224         _totalSupply = _totalSupply.add(_value);
225         return super.transfer(_to, _value);
226     }
227     
228     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
229         return super.transferFrom(_from, _to, _value);
230     }
231     
232     function () public payable {
233         createTokens(msg.sender, msg.value);
234     }
235     
236     function createTokens(address _sender, uint256 _value) public whenNotPaused { 
237         require(_value > 0);
238         require(depositorsTokens > 0);
239         require(now <= fundingEndTime);
240         require(_value >= minContribution);
241         uint256 tokens = (_value * RATE) / oneTokenInWei;
242         require(tokens > 0);
243         if (now <= firstPeriodEND){
244             tokens =  ((tokens * 100) * (firstPeriodDis + 100))/10000;
245         }else if (now > firstPeriodEND && now <= secondPeriodEND){
246             tokens =  ((tokens * 100) *(secondPeriodDis + 100))/10000;
247         }else if (now > secondPeriodEND && now <= thirdPeriodEND){
248             tokens = ((tokens * 100) * (thirdPeriodDis + 100))/10000;
249         }
250         require(depositorsTokens.sub(tokens) >= 0);
251         depositorsTokens = depositorsTokens.sub(tokens);
252         _totalSupply = _totalSupply.add(tokens);
253         require(sell(_sender, tokens)); 
254         owner.transfer(_value);
255     }
256     
257     function totalSupply() public constant returns (uint) {
258         return _totalSupply.sub(balances[address(0)]);
259     }
260     
261     function getBalance(address _sender) public view returns (uint256) {
262         return _sender.balance;
263     }
264     
265     /**
266      * @param _value must be in wei (1ETH = 1e18 wei) 
267      */
268     function isLeftTokens(uint256 _value) public view returns (bool) { 
269         require(_value > 0);
270         uint256 tokens = (_value * RATE) / oneTokenInWei;
271         require(tokens > 0);
272         if (now <= firstPeriodEND){
273             tokens =  ((tokens * 100) * (firstPeriodDis + 100))/10000;
274         }else if (now > firstPeriodEND && now <= secondPeriodEND){
275             tokens =  ((tokens * 100) *(secondPeriodDis + 100))/10000;
276         }else if (now > secondPeriodEND && now <= thirdPeriodEND){
277             tokens = ((tokens * 100) * (thirdPeriodDis + 100))/10000;
278         }
279         return depositorsTokens.sub(tokens) >= 0;
280     }
281 
282     function sell(address _recipient, uint256 _value) internal whenNotPaused returns (bool success) {
283         _transfer (owner, _recipient, _value);
284         return true;
285     }
286     
287     function getFoundersTokens() public constant returns (uint256) {
288         return foundersTokens;
289     } 
290     
291     function getDepositorsTokens() public constant returns (uint256) {
292         return depositorsTokens;
293     }
294     
295     function increaseTotalSupply(uint256 _value) public whenNotPaused onlyOwner returns (bool success) {
296         require(_value > 0);
297         require(_totalSupply.add(_value) <= tokenCreationCap);
298         _totalSupply = _totalSupply.add(_value);
299         return true;
300     }
301 }