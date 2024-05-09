1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * Math operations with safety checks
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33         return a >= b ? a : b;
34     }
35 
36     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37         return a < b ? a : b;
38     }
39 
40     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41         return a >= b ? a : b;
42     }
43 
44     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45         return a < b ? a : b;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * Base contract with an owner.
52  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
53  */
54 contract Ownable {
55     address public owner;
56 
57     function Ownable() {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address newOwner) onlyOwner {
67         if (newOwner != address(0)) {
68             owner = newOwner;
69         }
70     }
71 }
72 
73 /**
74  * @title Haltable
75  * Abstract contract that allows children to implement an
76  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
77  */
78 contract Haltable is Ownable {
79     bool public halted;
80 
81     modifier stopInEmergency {
82         require(!halted);
83         _;
84     }
85 
86     modifier onlyInEmergency {
87         require(halted);
88         _;
89     }
90 
91     // called by the owner on emergency, triggers stopped state
92     function halt() external onlyOwner {
93         halted = true;
94     }
95 
96     // called by the owner on end of emergency, returns to normal state
97     function unhalt() external onlyOwner onlyInEmergency {
98         halted = false;
99     }
100 }
101 
102 /**
103  * @title ERC20
104  * ERC20 interface
105  */
106 contract ERC20 {
107     uint256 public totalSupply;
108 
109     function balanceOf(address _owner) constant returns (uint balance);
110     function transfer(address _to, uint _value);
111     function transferFrom(address _from, address _to, uint _value);
112     function approve(address _spender, uint _value);
113     function allowance(address _owner, address _spender) constant returns (uint remaining);
114     event Transfer(address indexed _from, address indexed _to, uint _value);
115     event Approval(address indexed _owner, address indexed _spender, uint _value);
116 }
117 
118 /**
119  * @title StandardToken
120  * Standard ERC20-compliant token
121  * https://github.com/ethereum/EIPs/issues/20
122  */
123 contract StandardToken is ERC20 {
124     using SafeMath for uint256;
125 
126     mapping(address => uint256) balances;
127     mapping(address => mapping(address => uint256)) allowed;
128 
129     function balanceOf(address _owner) constant returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     /**
134      * fix for ERC20 short address attack
135      */
136     modifier onlyPayloadSize(uint256 size) {
137         require(msg.data.length >= size + 4);
138         _;
139     }
140 
141     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         Transfer(msg.sender, _to, _value);
145     }
146 
147     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
148         var _allowance = allowed[_from][msg.sender];
149 
150         balances[_to] = balances[_to].add(_value);
151         balances[_from] = balances[_from].sub(_value);
152         allowed[_from][msg.sender] = _allowance.sub(_value);
153         Transfer(_from, _to, _value);
154     }
155 
156     function approve(address _spender, uint _value) {
157         /**
158          * Allowed amount should be first set to 0
159          * by calling approve(_spender, 0) in order to avoid this:
160          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161          */
162         require(_value == 0 || allowed[msg.sender][_spender] == 0);
163 
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166     }
167 
168     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 }
172 
173 contract LiveStarsToken is StandardToken {
174     string public name = "Live Stars Token";
175     string public symbol = "LIVE";
176     uint256 public decimals = 18;
177     uint256 public INITIAL_SUPPLY = 200000000 * 1 ether;
178 
179     /**
180      * All tokens are allocated to creator.
181      */
182     function LiveStarsToken() {
183         totalSupply = INITIAL_SUPPLY;
184         balances[msg.sender] = INITIAL_SUPPLY;
185     }
186 }
187 
188 contract LiveStarsTokenPresale is Haltable {
189     using SafeMath for uint;
190 
191     string public name = "Live Stars Token Presale";
192 
193     LiveStarsToken public token;
194     address public beneficiary;
195 
196     uint public hardCap;
197     uint public collected;
198     uint public price;
199     uint public purchaseLimit;
200 
201     uint public currentBalance;
202 
203     uint public tokensSold = 0;
204     uint public investorCount = 0;
205 
206     uint public startTime;
207     uint public endTime;
208 
209     event GoalReached(uint amountRaised);
210     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
211 
212     modifier onlyAfter(uint time) {
213         require(now >= time);
214         _;
215     }
216 
217     modifier onlyBefore(uint time) {
218         require(now <= time);
219         _;
220     }
221 
222     function LiveStarsTokenPresale(
223         uint _hardCapUSD,
224         address _token,
225         address _beneficiary,
226         uint _totalTokens,
227         uint _priceETH,
228         uint _purchaseLimitUSD,
229 
230         uint _startTime,
231         uint _duration
232     ) {
233         hardCap = _hardCapUSD  * 1 ether / _priceETH;
234         price = _totalTokens * 1 ether / hardCap;
235 
236         purchaseLimit = _purchaseLimitUSD * 1 ether / _priceETH * price;
237         token = LiveStarsToken(_token);
238         beneficiary = _beneficiary;
239 
240         startTime = _startTime;
241         endTime = _startTime + _duration * 1 hours;
242     }
243 
244     function () payable stopInEmergency{
245         require(msg.value >= 0.01 * 1 ether);
246         doPurchase(msg.sender);
247     }
248 
249     function withdraw() onlyOwner {
250         require(beneficiary.send(currentBalance));
251         currentBalance = 0;
252     }
253 
254     function finalWithdraw() onlyOwner onlyAfter(endTime) {
255         if (currentBalance > 0) {
256             require(beneficiary.send(currentBalance));
257         }
258 
259         token.transfer(beneficiary, token.balanceOf(this));
260     }
261 
262     function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {
263         assert(collected.add(msg.value) <= hardCap);
264 
265         uint tokens = msg.value * price;
266         assert(token.balanceOf(msg.sender) + tokens <= purchaseLimit);
267 
268         if (token.balanceOf(msg.sender) == 0) investorCount++;
269 
270         collected = collected.add(msg.value);
271         currentBalance = currentBalance.add(msg.value);
272         token.transfer(msg.sender, tokens);
273         tokensSold = tokensSold.add(tokens);
274 
275         NewContribution(_owner, tokens, msg.value);
276 
277         if (collected == hardCap) {
278             GoalReached(hardCap);
279         }
280     }
281 }