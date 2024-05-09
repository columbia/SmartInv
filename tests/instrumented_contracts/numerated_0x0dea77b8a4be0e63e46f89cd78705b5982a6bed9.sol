1 pragma solidity ^0.4.18;
2  
3 /* 
4     PIONEER SOCIAL is Registered in United Kingdom. 
5     Pioneer Classic is first social coin who have big Social Media Platform 
6     where you upload videos and Create community, groups, pages, and earn handsome income.
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14  
15 /*
16    ERC20 interface
17   see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25  
26 /*  SafeMath - the lowest gas library
27   Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30     
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36  
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43  
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48  
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54   
55 }
56  
57 /*
58 Basic token
59  Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62     
63   using SafeMath for uint256;
64  
65   mapping(address => uint256) balances;
66  
67  function transfer(address _to, uint256 _value) returns (bool) {
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73  
74   /*
75   Gets the balance of the specified address.
76    param _owner The address to query the the balance of. 
77    return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82  
83 }
84  
85 /* Implementation of the basic standard token.
86   https://github.com/ethereum/EIPs/issues/20
87  */
88 contract StandardToken is ERC20, BasicToken {
89  
90   mapping (address => mapping (address => uint256)) allowed;
91  
92   /*
93     Transfer tokens from one address to another
94     param _from address The address which you want to send tokens from
95     param _to address The address which you want to transfer to
96     param _value uint256 the amout of tokens to be transfered
97    */
98   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
99     var _allowance = allowed[_from][msg.sender];
100  
101     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102     // require (_value <= _allowance);
103  
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110  
111   /*
112   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    param _spender The address which will spend the funds.
114    param _value The amount of Roman Lanskoj's tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) returns (bool) {
117  
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition described here:
121     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
123  
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128  
129   /*
130   Function to check the amount of tokens that an owner allowed to a spender.
131   param _owner address The address which owns the funds.
132   param _spender address The address which will spend the funds.
133   return A uint256 specifing the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137 }
138 }
139  
140 /*
141 The Ownable contract has an owner address, and provides basic authorization control
142  functions, this simplifies the implementation of "user permissions".
143  */
144 contract Ownable {
145     
146   address public owner;
147  
148  
149   function Ownable() {
150     owner = msg.sender;
151   }
152  
153   /*
154   Throws if called by any account other than the owner.
155    */
156   modifier onlyOwner() {
157     require(msg.sender == owner);
158     _;
159   }
160  
161   /*
162   Allows the current owner to transfer control of the contract to a newOwner.
163   param newOwner The address to transfer ownership to.
164    */
165   function transferOwnership(address newOwner) onlyOwner {
166     require(newOwner != address(0));      
167     owner = newOwner;
168   }
169  
170 }
171  
172 contract TheLiquidToken is StandardToken, Ownable {
173     // mint can be finished and token become fixed for forever
174   event Mint(address indexed to, uint256 amount);
175   event MintFinished();
176   bool mintingFinished = false;
177   modifier canMint() {
178     require(!mintingFinished);
179     _;
180   }
181  
182  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
183     totalSupply = totalSupply.add(_amount);
184     balances[_to] = balances[_to].add(_amount);
185     Mint(_to, _amount);
186     return true;
187   }
188  
189   /*
190   Function to stop minting new tokens.
191   return True if the operation was successful.
192    */
193   
194   function burn(uint _value)
195         public
196     {
197         require(_value > 0);
198 
199         address burner = msg.sender;
200         balances[burner] = balances[burner].sub(_value);
201         totalSupply = totalSupply.sub(_value);
202         Burn(burner, _value);
203     }
204 
205     event Burn(address indexed burner, uint indexed value);
206 }
207 
208 contract PIONEER is TheLiquidToken {
209   string public constant name = "PIONEER COIN CLASSIC";
210   string public constant symbol = "PCC";
211   uint public constant decimals = 8;
212   uint256 public initialSupply;
213     
214   function PIONEER () { 
215      totalSupply = 15000000 * 10 ** decimals;
216       balances[msg.sender] = totalSupply;
217       initialSupply = totalSupply; 
218         Transfer(0, this, totalSupply);
219         Transfer(this, msg.sender, totalSupply);
220   }
221 }
222 
223 contract Crowdsale is PIONEER {
224     
225     using SafeMath for uint;
226     
227     address multisig;
228  
229     uint restrictedPercent;
230  
231     address restricted;
232  
233     PIONEER public token = new PIONEER();
234  
235     uint start;
236     
237     uint period;
238  
239     uint hardcap;
240  
241     uint rate;
242  
243     function Crowdsale() {
244 	multisig = 0x0C12c4a7A690663813612924377262b7A957Eb23;
245 	restricted = 0x0C12c4a7A690663813612924377262b7A957Eb23;
246 	restrictedPercent = 50;
247 	rate = 550 * (10 ** 8);
248 	start = 1508743500; //23rd October 2017 07:25:00 AM (UTC)
249 
250 	period = 28;
251         hardcap = 100000 * (10 ** 18);
252     }
253  
254     modifier saleIsOn() {
255     	require(now > start && now < start + period * 1 days);
256     	_;
257     }
258 	
259     modifier isUnderHardCap() {
260         require(multisig.balance <= hardcap);
261         _;
262     }
263  
264     function finishMinting() public onlyOwner {
265 	uint issuedTokenSupply = token.totalSupply();
266 	uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
267 	token.mint(restricted, restrictedTokens);
268     }
269  
270    function createTokens() isUnderHardCap saleIsOn payable {
271      multisig.transfer(msg.value);
272         uint tokens = rate.mul(msg.value).div(1 ether);
273         uint bonusTokens = 0;
274         if(now < (start + 1 days)) {
275           bonusTokens = 200;
276         } else if(now < (start + 1 days) + (period * 1 days).div(4)) {
277           bonusTokens = 150;
278         } else if(now >= (start + 1 days) + (period * 1 days).div(4) && now < (start + 1 days) + (period * 1 days).div(4).mul(2)) {
279           bonusTokens = 100;
280         } else if(now >= (start + 1 days) + (period * 1 days).div(4).mul(2) && now < (start + 1 days) + (period * 1 days).div(4).mul(3)) {
281           bonusTokens = 50;
282         }
283         tokens += bonusTokens;
284         token.mint(msg.sender, tokens);
285     }
286   
287  
288     function() external payable {
289         createTokens();
290     }
291     
292 }