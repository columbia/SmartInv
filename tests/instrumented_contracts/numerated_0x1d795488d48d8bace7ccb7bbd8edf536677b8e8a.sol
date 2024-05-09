1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a / b;
26         return c;
27     }
28 
29     /**
30     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38     * @dev Adds two numbers, throws on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54     address public owner;
55 
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 
86 }
87 
88 contract Miner is Ownable{
89 
90     address public miner;
91 
92 
93     event SetMiner(address indexed previousMiner, address indexed newMiner);
94 
95 
96     constructor() public {
97         miner = msg.sender;
98     }
99 
100     modifier onlyMiner() {
101         require(msg.sender == miner);
102         _;
103     }
104 
105     function setMiner(address newMiner) public onlyOwner {
106         require(newMiner != address(0));
107         SetMiner(miner, newMiner);
108         miner = newMiner;
109 
110     }
111 
112 }
113 
114 contract ERC20Basic {
115     function totalSupply() public view returns (uint256);
116 
117     function balanceOf(address who) public view returns (uint256);
118 
119     function transfer(address to, uint256 value) public returns (bool);
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 contract ERC20 is ERC20Basic {
125     function allowance(address owner, address spender) public view returns (uint256);
126 
127     function transferFrom(address from, address to, uint256 value) public returns (bool);
128 
129     function approve(address spender, uint256 value) public returns (bool);
130 
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 contract Pausable is Miner {
136     event Pause();
137     event Unpause();
138 
139     bool public paused = false;
140 
141 
142     modifier whenNotPaused() {
143         require(!paused);
144         _;
145     }
146 
147     modifier whenPaused() {
148         require(paused);
149         _;
150     }
151 
152     function pause() onlyOwner whenNotPaused public {
153         paused = true;
154         Pause();
155     }
156 
157     function unpause() onlyOwner whenPaused public {
158         paused = false;
159         Unpause();
160     }
161 }
162 
163 
164 contract BasicToken is ERC20Basic {
165     using SafeMath for uint256;
166 
167     mapping(address => uint256) balances;
168 
169     uint256 totalSupply_;
170 
171     function totalSupply() public view returns (uint256) {
172         return totalSupply_;
173     }
174 
175     function transfer(address _to, uint256 _value) public returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[msg.sender]);
178 
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         Transfer(msg.sender, _to, _value);
182         return true;
183     }
184 
185     function balanceOf(address _owner) public view returns (uint256 balance) {
186         return balances[_owner];
187     }
188 
189 
190 }
191 
192 contract StandardToken is ERC20, BasicToken {
193 
194     mapping(address => mapping(address => uint256)) internal allowed;
195 
196 
197     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198         require(_to != address(0));
199         require(_value <= balances[_from]);
200         require(_value <= allowed[_from][msg.sender]);
201 
202         balances[_from] = balances[_from].sub(_value);
203         balances[_to] = balances[_to].add(_value);
204         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205         Transfer(_from, _to, _value);
206         return true;
207     }
208 
209     function approve(address _spender, uint256 _value) public returns (bool) {
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     function allowance(address _owner, address _spender) public view returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218 
219     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226         uint oldValue = allowed[msg.sender][_spender];
227         if (_subtractedValue > oldValue) {
228             allowed[msg.sender][_spender] = 0;
229         } else {
230             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231         }
232         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
235 
236 }
237 
238 
239 contract PausableToken is StandardToken, Pausable {
240 
241     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
242         return super.transfer(_to, _value);
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
246         return super.transferFrom(_from, _to, _value);
247     }
248 
249     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
250         return super.approve(_spender, _value);
251     }
252 
253     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
254         return super.increaseApproval(_spender, _addedValue);
255     }
256 
257     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
258         return super.decreaseApproval(_spender, _subtractedValue);
259     }
260 }
261 
262 
263 
264 contract FBIT is PausableToken  {
265 
266     using SafeMath for uint256;
267     uint public lastMiningTime;
268     uint public mineral;
269     uint public lastMineralUpdateTime;
270     string public  name;
271     string public  symbol;
272     uint8 public  decimals;
273 
274     function mining() public onlyMiner returns (uint){
275         require(now - lastMiningTime > 6 days);
276 
277         if (now - lastMineralUpdateTime > 4 years) {
278             mineral = mineral.div(2);
279             lastMineralUpdateTime = now;
280         }
281         balances[msg.sender] = balances[msg.sender].add(mineral);
282         lastMiningTime = now;
283 
284         Transfer(0x0, msg.sender, mineral);
285         return mineral;
286     }
287 
288     constructor() public {
289         lastMineralUpdateTime = now;
290         mineral = 520000000 * (10 ** 18);
291         name = "FutureBit Token";
292         symbol = "FBIT";
293         decimals = 18;
294         totalSupply_ = 2100 * (10 ** 8) * (10 ** 18);
295     }
296 
297 }