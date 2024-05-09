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
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0));
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88 }
89 
90 contract Miner is Ownable{
91 
92     address public miner;
93 
94 
95     event SetMiner(address indexed previousMiner, address indexed newMiner);
96 
97 
98     constructor() public {
99         miner = msg.sender;
100     }
101 
102     modifier onlyMiner() {
103         require(msg.sender == miner);
104         _;
105     }
106 
107     function setMiner(address newMiner) public onlyOwner {
108         require(newMiner != address(0));
109         SetMiner(miner, newMiner);
110         miner = newMiner;
111 
112     }
113 
114 }
115 
116 
117 contract ERC20Basic {
118     function totalSupply() public view returns (uint256);
119 
120     function balanceOf(address who) public view returns (uint256);
121 
122     function transfer(address to, uint256 value) public returns (bool);
123 
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 contract ERC20 is ERC20Basic {
128     function allowance(address owner, address spender) public view returns (uint256);
129 
130     function transferFrom(address from, address to, uint256 value) public returns (bool);
131 
132     function approve(address spender, uint256 value) public returns (bool);
133 
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 contract Pausable is Miner {
139     event Pause();
140     event Unpause();
141 
142     bool public paused = false;
143 
144 
145     modifier whenNotPaused() {
146         require(!paused);
147         _;
148     }
149 
150     modifier whenPaused() {
151         require(paused);
152         _;
153     }
154 
155     function pause() onlyOwner whenNotPaused public {
156         paused = true;
157         Pause();
158     }
159 
160     function unpause() onlyOwner whenPaused public {
161         paused = false;
162         Unpause();
163     }
164 }
165 
166 
167 contract BasicToken is ERC20Basic {
168     using SafeMath for uint256;
169 
170     mapping(address => uint256) balances;
171 
172     uint256 totalSupply_;
173 
174     function totalSupply() public view returns (uint256) {
175         return totalSupply_;
176     }
177 
178     function transfer(address _to, uint256 _value) public returns (bool) {
179         require(_to != address(0));
180         require(_value <= balances[msg.sender]);
181 
182         balances[msg.sender] = balances[msg.sender].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         Transfer(msg.sender, _to, _value);
185         return true;
186     }
187 
188     function balanceOf(address _owner) public view returns (uint256 balance) {
189         return balances[_owner];
190     }
191 
192 
193 }
194 
195 contract StandardToken is ERC20, BasicToken {
196 
197     mapping(address => mapping(address => uint256)) internal allowed;
198 
199 
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         require(_value <= balances[_from]);
203         require(_value <= allowed[_from][msg.sender]);
204 
205         balances[_from] = balances[_from].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208         Transfer(_from, _to, _value);
209         return true;
210     }
211 
212     function approve(address _spender, uint256 _value) public returns (bool) {
213         allowed[msg.sender][_spender] = _value;
214         Approval(msg.sender, _spender, _value);
215         return true;
216     }
217 
218     function allowance(address _owner, address _spender) public view returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221 
222     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 
239 }
240 
241 
242 contract PausableToken is StandardToken, Pausable {
243 
244     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
245         return super.transfer(_to, _value);
246     }
247 
248     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
249         return super.transferFrom(_from, _to, _value);
250     }
251 
252     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
253         return super.approve(_spender, _value);
254     }
255 
256     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
257         return super.increaseApproval(_spender, _addedValue);
258     }
259 
260     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
261         return super.decreaseApproval(_spender, _subtractedValue);
262     }
263 }
264 
265 
266 contract FBT is PausableToken  {
267 
268     using SafeMath for uint256;
269     uint public lastMiningTime;
270     uint public mineral;
271     uint public lastMineralUpdateTime;
272     string public  name;
273     string public  symbol;
274     uint8 public  decimals;
275 
276     function mining() public onlyMiner returns (uint){
277         require(now - lastMiningTime > 6 days);
278 
279         if (now - lastMineralUpdateTime > 4 years) {
280             mineral = mineral.div(2);
281             lastMineralUpdateTime = now;
282         }
283         balances[msg.sender] = balances[msg.sender].add(mineral);
284         lastMiningTime = now;
285 
286         Transfer(0x0, msg.sender, mineral);
287         return mineral;
288     }
289 
290     constructor() public {
291         lastMineralUpdateTime = now;
292         mineral = 520000000 * (10 ** 18);
293         name = "FutureBit Token";
294         symbol = "FBT";
295         decimals = 18;
296         totalSupply_ = 2100 * (10 ** 8) * (10 ** 18);
297     }
298 
299 }