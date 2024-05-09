1 pragma solidity ^0.4.19;
2 
3 contract ERC20 {
4 
5 
6     event Transfer(address indexed _from, address indexed _to, uint256 _value);
7 
8     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
9 
10     function totalSupply() external constant returns (uint);
11 
12     function balanceOf(address _owner) external constant returns (uint256);
13 
14     function transfer(address _to, uint256 _value) external returns (bool);
15 
16     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
17 
18     function approve(address _spender, uint256 _value) external returns (bool);
19 
20     function allowance(address _owner, address _spender) external constant returns (uint256);
21 
22 }
23 
24 library SafeMath {
25 
26     /*
27         @return sum of a and b
28     */
29     function ADD (uint256 a, uint256 b) pure internal returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 
35     /*
36         @return difference of a and b
37     */
38     function SUB (uint256 a, uint256 b) pure internal returns (uint256) {
39         assert(a >= b);
40         return a - b;
41     }
42     
43 }
44 
45 contract Ownable {
46 
47 
48     address owner;
49 
50     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
51 
52     function Ownable() public {
53         owner = msg.sender;
54         OwnershipTransferred (address(0), owner);
55     }
56 
57     function transferOwnership(address _newOwner)
58         public
59         onlyOwner
60         notZeroAddress(_newOwner)
61     {
62         owner = _newOwner;
63         OwnershipTransferred(msg.sender, _newOwner);
64     }
65 
66     //Only owner can call function
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     modifier notZeroAddress(address _address) {
73         require(_address != address(0));
74         _;
75     }
76 
77 }
78 
79 /*
80 	Trustable saves trusted addresses
81 */
82 contract Trustable is Ownable {
83 
84 
85     //Only trusted addresses are able to transfer tokens during the Crowdsale
86     mapping (address => bool) trusted;
87 
88     event AddTrusted (address indexed _trustable);
89     event RemoveTrusted (address indexed _trustable);
90 
91     function Trustable() public {
92         trusted[msg.sender] = true;
93         AddTrusted(msg.sender);
94     }
95 
96     //Add new trusted address
97     function addTrusted(address _address)
98         external
99         onlyOwner
100         notZeroAddress(_address)
101     {
102         trusted[_address] = true;
103         AddTrusted(_address);
104     }
105 
106     //Remove address from a trusted list
107     function removeTrusted(address _address)
108         external
109         onlyOwner
110         notZeroAddress(_address)
111     {
112         trusted[_address] = false;
113         RemoveTrusted(_address);
114     }
115 
116 }
117 
118 contract Pausable is Trustable {
119 
120 
121     //To check if Token is paused
122     bool public paused;
123     //Block number on pause
124     uint256 public pauseBlockNumber;
125     //Block number on resume
126     uint256 public resumeBlockNumber;
127 
128     event Pause(uint256 _blockNumber);
129     event Unpause(uint256 _blockNumber);
130 
131     function pause()
132         public
133         onlyOwner
134         whenNotPaused
135     {
136         paused = true;
137         pauseBlockNumber = block.number;
138         resumeBlockNumber = 0;
139         Pause(pauseBlockNumber);
140     }
141 
142     function unpause()
143         public
144         onlyOwner
145         whenPaused
146     {
147         paused = false;
148         resumeBlockNumber = block.number;
149         pauseBlockNumber = 0;
150         Unpause(resumeBlockNumber);
151     }
152 
153     modifier whenNotPaused {
154         require(!paused);
155         _;
156     }
157 
158     modifier whenPaused {
159         require(paused);
160         _;
161     }
162 
163 }
164 
165 /*
166 	Contract determines token
167 */
168 contract Token is ERC20, Pausable{
169 
170 
171     using SafeMath for uint256;
172 
173     //Total amount of Outing
174     uint256 _totalSupply = 56000000000000000; 
175 
176     //Balances for each account
177     mapping (address => uint256)  balances;
178     //Owner of the account approves the transfer of an amount to another account
179     mapping (address => mapping (address => uint256)) allowed;
180 
181     //Notifies users about the amount burnt
182     event Burn(address indexed _from, uint256 _value);
183     //Notifies users about end block change
184     event CrowdsaleEndChanged (uint256 _crowdsaleEnd, uint256 _newCrowdsaleEnd);
185 
186     //return _totalSupply of the Token
187     function totalSupply() external constant returns (uint256 totalTokenSupply) {
188         totalTokenSupply = _totalSupply;
189     }
190 
191     //What is the balance of a particular account?
192     function balanceOf(address _owner)
193         external
194         constant
195         returns (uint256 balance)
196     {
197         return balances[_owner];
198     }
199 
200     //Transfer the balance from owner's account to another account
201     function transfer(address _to, uint256 _amount)
202         external
203         notZeroAddress(_to)
204         whenNotPaused
205         returns (bool success)
206     {
207         balances[msg.sender] = balances[msg.sender].SUB(_amount);
208         balances[_to] = balances[_to].ADD(_amount);
209         Transfer(msg.sender, _to, _amount);
210         return true;
211     }
212 
213     function transferFrom(address _from, address _to, uint256 _amount)
214         external
215         notZeroAddress(_to)
216         whenNotPaused
217         returns (bool success)
218     {
219         //Require allowance to be not too big
220         require(allowed[_from][msg.sender] >= _amount);
221         balances[_from] = balances[_from].SUB(_amount);
222         balances[_to] = balances[_to].ADD(_amount);
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB(_amount);
224         Transfer(_from, _to, _amount);
225         return true;
226     }
227 
228     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
229     // If this function is called again it overwrites the current allowance with _value.
230     function approve(address _spender, uint256 _amount)
231         external
232         whenNotPaused
233         notZeroAddress(_spender)
234         returns (bool success)
235     {
236         allowed[msg.sender][_spender] = _amount;
237         Approval(msg.sender, _spender, _amount);
238         return true;
239     }
240 
241     //Return how many tokens left that you can spend from
242     function allowance(address _owner, address _spender)
243         external
244         constant
245         returns (uint256 remaining)
246     {
247         return allowed[_owner][_spender];
248     }
249 
250     function increaseApproval(address _spender, uint256 _addedValue)
251         external
252         whenNotPaused
253         returns (bool success)
254     {
255         uint256 increased = allowed[msg.sender][_spender].ADD(_addedValue);
256         require(increased <= balances[msg.sender]);
257         //Cannot approve more coins then you have
258         allowed[msg.sender][_spender] = increased;
259         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262 
263     function decreaseApproval(address _spender, uint256 _subtractedValue)
264         external
265         whenNotPaused
266         returns (bool success)
267     {
268         uint256 oldValue = allowed[msg.sender][_spender];
269         if (_subtractedValue > oldValue) {
270             allowed[msg.sender][_spender] = 0;
271         } else {
272             allowed[msg.sender][_spender] = oldValue.SUB(_subtractedValue);
273         }
274         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275         return true;
276     }
277 
278     function burn(uint256 _value) external returns (bool success) {
279         require(trusted[msg.sender]);
280         //Subtract from the sender
281         balances[msg.sender] = balances[msg.sender].SUB(_value);
282         //Update _totalSupply
283         _totalSupply = _totalSupply.SUB(_value);
284         Burn(msg.sender, _value);
285         return true;
286     }
287 
288 }
289 
290 /*
291 	Contract defines specific token
292 */
293 contract OutingToken is Token{
294 
295     //Name of the token
296     string public constant name = "Outing";
297     //Symbol of the token
298     string public constant symbol = "OTG";
299     //Number of decimals of Outing
300     uint8 public constant decimals = 8;
301 
302     //Tokens allocation
303     //Outing Reserve wallet that will be unlocked after 0.5 year after ICO
304     address public constant OUTINGRESERVE = 0xB8E6C4Eab5BC0eAF1f3D8A9a59a8A26112a56fE2;
305     //Team wallet that will be unlocked after 1 year after ICO
306 
307     address public constant TEAM = 0x0702dd2f7DC2FF1dCc6beC2De9D1e6e0d467AfaC;
308     //0.5 year after ICO
309     uint256 public UNLOCK_OUTINGRESERVE = now + 262800 minutes;
310     //1 year after ICO
311     uint256 public UNLOCK_TEAM = now + 525600 minutes;
312     //outing reserve wallet balance
313     uint256 public outingreserveBalance;
314     //team wallet balance
315     uint256 public teamBalance;
316 
317     //56%
318     uint256 private constant OUTINGRESERVE_THOUSANDTH = 560;
319     //7%
320     uint256 private constant TEAM_THOUSANDTH = 70;
321     //37%
322     uint256 private constant ICO_THOUSANDTH = 370;
323     //100%
324     uint256 private constant DENOMINATOR = 1000;
325 
326     function OutingToken() public {
327         //36% of _totalSupply
328         balances[msg.sender] = _totalSupply * ICO_THOUSANDTH / DENOMINATOR;
329         //56% of _totalSupply
330         outingreserveBalance = _totalSupply * OUTINGRESERVE_THOUSANDTH / DENOMINATOR;
331         //8% of _totalSupply
332         teamBalance = _totalSupply * TEAM_THOUSANDTH / DENOMINATOR;
333 
334         Transfer (this, msg.sender, balances[msg.sender]);
335     }
336 
337     //Check if team wallet is unlocked
338     function unlockTokens(address _address) external {
339         if (_address == OUTINGRESERVE) {
340             require(UNLOCK_OUTINGRESERVE <= now);
341             require (outingreserveBalance > 0);
342             balances[OUTINGRESERVE] = outingreserveBalance;
343             outingreserveBalance = 0;
344             Transfer (this, OUTINGRESERVE, balances[OUTINGRESERVE]);
345         } else if (_address == TEAM) {
346             require(UNLOCK_TEAM <= now);
347             require (teamBalance > 0);
348             balances[TEAM] = teamBalance;
349             teamBalance = 0;
350             Transfer (this, TEAM, balances[TEAM]);
351         }
352     }
353 }