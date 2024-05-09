1 pragma solidity ^0.5.8;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) { return 0; }
7         uint256 c = a * b;
8         require(c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b > 0);
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         uint256 c = a - b;
21         return c;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a);
27         return c;
28     }
29 
30     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b != 0);
32         return a % b;
33     }
34 
35 }
36 
37 contract Validity {
38 
39     // Author ::: Samuel JJ Gosling
40     // Usage ::: Governance
41     // Entity ::: Validity
42 
43     using SafeMath for uint;
44 
45     bytes32 constant POS = 0x506f736974697665000000000000000000000000000000000000000000000000;
46     bytes32 constant NEU = 0x4e65757472616c00000000000000000000000000000000000000000000000000;
47     bytes32 constant NEG = 0x4e65676174697665000000000000000000000000000000000000000000000000;
48 
49     struct userObject {
50         bytes32 _validationIdentifier;
51         bool _validationStatus;
52         bool _stakingStatus;
53     }
54 
55     struct delegateObject {
56         address _delegateAddress;
57         bytes32 _delegateIdentity;
58         bytes32 _viabilityLimit;
59         bytes32 _viabilityRank;
60         bytes32 _positiveVotes;
61         bytes32 _negativeVotes;
62         bytes32 _neutralVotes;
63         bytes32 _totalEvents;
64         bytes32 _totalVotes;
65         bool _votingStatus;
66     }
67 
68     mapping (address => mapping (address => uint)) private _allowed;
69     mapping (address => uint) private _balances;
70 
71     mapping (bytes32 => delegateObject) private validationData;
72     mapping (address => userObject) private validationUser;
73 
74     address private _founder = msg.sender;
75     address private _admin = address(0x0);
76 
77     uint private _totalSupply;
78     uint private _maxSupply;
79     uint private _decimals;
80 
81     string private _name;
82     string private _symbol;
83 
84     modifier _viabilityLimit(bytes32 _id) {
85         require(uint(validationData[_id]._viabilityLimit) <= block.number);
86         _;
87     }
88 
89     modifier _stakeCheck(address _from, address _to) {
90         require(!isStaking(_from) && !isStaking(_to));
91         _;
92     }
93 
94     modifier _onlyAdmin() {
95         require(msg.sender == _admin);
96         _;
97     }
98 
99     modifier _onlyFounder() {
100         require(msg.sender == _founder);
101         _;
102     }
103 
104     constructor() public {
105         //  Max supply (100%) ::: 50,600,000,000 VLDY
106         //  Genesis supply (92.5%) ::: 46,805,000,000 VLDY
107         //  Validation supply (7.5%) ::: 3,795,000,000 VLDY
108         uint genesis = uint(46805000000).mul(10**uint(18));
109         _maxSupply = uint(50600000000).mul(10**uint(18));
110         _mint(_founder, genesis);
111         _name = "Validity";
112         _symbol = "VLDY";
113         _decimals = 18;
114     }
115 
116     function toggleStake() public {
117         require(!isVoted(validityId(msg.sender)));
118         require(isActive(msg.sender));
119 
120         bool currentState = validationUser[msg.sender]._stakingStatus;
121         validationUser[msg.sender]._stakingStatus = !currentState;
122         emit Stake(msg.sender);
123     }
124 
125     function setIdentity(bytes32 _identity) public {
126         require(isActive(msg.sender));
127 
128         validationData[validityId(msg.sender)]._delegateIdentity = _identity;
129     }
130 
131     function name() public view returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view returns (uint) {
140         return _decimals;
141     }
142 
143     function maxSupply() public view returns (uint) {
144         return _maxSupply;
145     }
146 
147     function totalSupply() public view returns (uint) {
148         return _totalSupply;
149     }
150 
151     function isVoted(bytes32 _id) public view returns (bool) {
152         return validationData[_id]._votingStatus;
153     }
154 
155     function isActive(address _account) public view returns (bool) {
156         return validationUser[_account]._validationStatus;
157     }
158 
159     function isStaking(address _account) public view returns (bool) {
160         return validationUser[_account]._stakingStatus;
161     }
162 
163     function balanceOf(address _owner) public view returns (uint) {
164         return _balances[_owner];
165     }
166 
167     function validityId(address _account) public view returns (bytes32) {
168         return validationUser[_account]._validationIdentifier;
169     }
170 
171     function getIdentity(bytes32 _id) public view returns (bytes32) {
172         return validationData[_id]._delegateIdentity;
173     }
174 
175     function getAddress(bytes32 _id) public view returns (address) {
176         return validationData[_id]._delegateAddress;
177     }
178 
179     function viability(bytes32 _id) public view returns (uint) {
180         return uint(validationData[_id]._viabilityRank);
181     }
182 
183     function totalEvents(bytes32 _id) public view returns (uint) {
184         return uint(validationData[_id]._totalEvents);
185     }
186 
187     function totalVotes(bytes32 _id) public view returns (uint) {
188         return uint(validationData[_id]._totalVotes);
189     }
190 
191     function positiveVotes(bytes32 _id) public view returns (uint) {
192         return uint(validationData[_id]._positiveVotes);
193     }
194 
195     function negativeVotes(bytes32 _id) public view returns (uint) {
196         return uint(validationData[_id]._negativeVotes);
197     }
198 
199     function neutralVotes(bytes32 _id) public view returns (uint) {
200         return uint(validationData[_id]._neutralVotes);
201     }
202 
203     function allowance(address _owner, address _spender) public view returns (uint) {
204         return _allowed[_owner][_spender];
205     }
206 
207     function transfer(address _to, uint _value) public returns (bool) {
208         _transfer(msg.sender, _to, _value);
209         return true;
210     }
211 
212     function approve(address _spender, uint _value) public returns (bool) {
213         _approve(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
218         _approve(_from, msg.sender, _allowed[_from][msg.sender].sub(_value));
219         _transfer(_from, _to, _value);
220         return true;
221     }
222 
223     function increaseAllowance(address _spender, uint _addedValue) public returns (bool) {
224         _approve(msg.sender, _spender, _allowed[msg.sender][_spender].add(_addedValue));
225         return true;
226     }
227 
228     function decreaseAllowance(address _spender, uint _subtractedValue) public returns (bool) {
229         _approve(msg.sender, _spender, _allowed[msg.sender][_spender].sub(_subtractedValue));
230         return true;
231     }
232 
233     function _transfer(address _from, address _to, uint _value) internal _stakeCheck(_from, _to) {
234         require(_from != address(0x0));
235         require(_to != address(0x0));
236 
237         _balances[_from] = _balances[_from].sub(_value);
238         _balances[_to] = _balances[_to].add(_value);
239         emit Transfer(_from, _to, _value);
240     }
241 
242     function _approve(address _owner, address _spender, uint _value) internal {
243         require(_spender != address(0x0));
244         require(_owner != address(0x0));
245 
246         _allowed[_owner][_spender] = _value;
247         emit Approval(_owner, _spender, _value);
248     }
249 
250     function _mint(address _account, uint _value) private {
251         require(_totalSupply.add(_value) <= _maxSupply);
252         require(_account != address(0x0));
253 
254         _totalSupply = _totalSupply.add(_value);
255         _balances[_account] = _balances[_account].add(_value);
256         emit Transfer(address(0x0), _account, _value);
257     }
258 
259     function validationReward(bytes32 _id, address _account, uint _reward) public _onlyAdmin {
260         require(isStaking(_account));
261         require(isVoted(_id));
262 
263         validationUser[_account]._stakingStatus = false;
264         validationData[_id]._votingStatus = false;
265         _mint(_account, _reward);
266         emit Reward(_id, _reward);
267     }
268 
269     function validationEvent(bytes32 _id, bytes32 _subject, bytes32 _choice, uint _weight) public _onlyAdmin {
270         require(_choice == POS || _choice == NEU || _choice == NEG);
271         require(isStaking(getAddress(_id)));
272         require(!isVoted(_id));
273 
274         validationData[_id]._votingStatus = true;
275         delegateObject storage x = validationData[_id];
276         if(_choice == POS) {
277             x._positiveVotes = bytes32(positiveVotes(_id).add(_weight));
278         } else if(_choice == NEU) {
279             x._neutralVotes = bytes32(neutralVotes(_id).add(_weight));
280         } else if(_choice == NEG) {
281             x._negativeVotes = bytes32(negativeVotes(_id).add(_weight));
282         }
283         x._totalVotes = bytes32(totalVotes(_id).add(_weight));
284         x._totalEvents = bytes32(totalEvents(_id).add(1));
285         emit Vote(_id, _subject, _choice, _weight);
286     }
287 
288     function validationGeneration(address _account) internal view returns (bytes32) {
289         bytes32 id = 0xffcc000000000000000000000000000000000000000000000000000000000000;
290         assembly {
291             let product := mul(or(_account, shl(0xa0, and(number, 0xffffffff))), 0x7dee20b84b88)
292             id := or(id, xor(product, shl(0x78, and(product, 0xffffffffffffffffffffffffffffff))))
293         }
294         return id;
295     }
296 
297     function increaseViability(bytes32 _id) public _onlyAdmin  _viabilityLimit(_id) {
298         validationData[_id]._viabilityLimit = bytes32(block.number.add(1000));
299         validationData[_id]._viabilityRank = bytes32(viability(_id).add(1));
300         emit Trust(_id, POS);
301     }
302 
303     function decreaseViability(bytes32 _id) public _onlyAdmin _viabilityLimit(_id) {
304         validationData[_id]._viabilityLimit = bytes32(block.number.add(1000));
305         validationData[_id]._viabilityRank = bytes32(viability(_id).sub(1));
306         emit Trust(_id, NEG);
307     }
308 
309     function conformIdentity() public {
310         require(!isActive(msg.sender));
311 
312         bytes32 neophyteDelegate = validationGeneration(msg.sender);
313         validationUser[msg.sender]._validationIdentifier = neophyteDelegate;
314         validationData[neophyteDelegate]._delegateAddress = msg.sender;
315         validationUser[msg.sender]._validationStatus = true;
316         emit Neo(msg.sender, neophyteDelegate, block.number);
317     }
318 
319     function adminControl(address _entity) public _onlyFounder {
320         _admin = _entity;
321     }
322 
323     event Approval(address indexed owner, address indexed spender, uint value);
324     event Transfer(address indexed from, address indexed to, uint value);
325     event Vote(bytes32 id, bytes32 subject, bytes32 choice, uint weight);
326     event Neo(address indexed delegate, bytes32 id, uint block);
327     event Trust(bytes32 id, bytes32 change);
328     event Reward(bytes32 id, uint reward);
329     event Stake(address indexed delegate);
330 
331 }