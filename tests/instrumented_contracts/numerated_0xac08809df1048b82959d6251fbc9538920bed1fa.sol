1 pragma solidity ^0.5.13;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) public onlyOwner {
43         if (newOwner != address(0)) {
44             owner = newOwner;
45         }
46     }
47 
48 }
49 
50 contract ERC20Basic {
51     uint public _totalSupply;
52     function totalSupply() public view returns (uint);
53     function balanceOf(address who) public view returns (uint);
54     function transfer(address to, uint value) public;
55     event Transfer(address indexed from, address indexed to, uint value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public view returns (uint);
60     function transferFrom(address from, address to, uint value) public;
61     function approve(address spender, uint value) public;
62     event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 contract BasicToken is Ownable, ERC20Basic {
66     using SafeMath for uint;
67 
68     mapping(address => uint) public balances;
69 
70     uint public basisPointsRate = 0;
71     uint public maximumFee = 0;
72 
73     modifier onlyPayloadSize(uint size) {
74         require(!(msg.data.length < size + 4));
75         _;
76     }
77 
78     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
79         uint fee = (_value.mul(basisPointsRate)).div(10000);
80         if (fee > maximumFee) {
81             fee = maximumFee;
82         }
83         uint sendAmount = _value.sub(fee);
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(sendAmount);
86         if (fee > 0) {
87             balances[owner] = balances[owner].add(fee);
88             emit Transfer(msg.sender, owner, fee);
89         }
90         emit Transfer(msg.sender, _to, sendAmount);
91     }
92 
93     function balanceOf(address _owner) public view returns (uint balance) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 contract StandardToken is BasicToken, ERC20 {
100 
101     mapping (address => mapping (address => uint)) public allowed;
102 
103     uint public constant MAX_UINT = 2**256 - 1;
104 
105     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
106         uint256 _allowance = allowed[_from][msg.sender];
107 
108         uint fee = (_value.mul(basisPointsRate)).div(10000);
109         if (fee > maximumFee) {
110             fee = maximumFee;
111         }
112         if (_allowance < MAX_UINT) {
113             allowed[_from][msg.sender] = _allowance.sub(_value);
114         }
115         uint sendAmount = _value.sub(fee);
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(sendAmount);
118         if (fee > 0) {
119             balances[owner] = balances[owner].add(fee);
120             emit Transfer(_from, owner, fee);
121         }
122         emit Transfer(_from, _to, sendAmount);
123     }
124 
125     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
126         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
127 
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130     }
131 
132     function allowance(address _owner, address _spender) public view returns (uint remaining) {
133         return allowed[_owner][_spender];
134     }
135 
136 }
137 
138 
139 contract Pausable is Ownable {
140   event Pause();
141   event Unpause();
142 
143   bool public paused = false;
144 
145 
146   modifier whenNotPaused() {
147     require(!paused);
148     _;
149   }
150 
151   modifier whenPaused() {
152     require(paused);
153     _;
154   }
155 
156   function pause() onlyOwner whenNotPaused public {
157     paused = true;
158     emit Pause();
159   }
160 
161   function unpause() onlyOwner whenPaused public {
162     paused = false;
163     emit Unpause();
164   }
165 }
166 
167 contract BlackList is Ownable, BasicToken {
168     function getBlackListStatus(address _maker) external view returns (bool) {
169         return isBlackListed[_maker];
170     }
171 
172     function getOwner() external view returns (address) {
173         return owner;
174     }
175 
176     mapping (address => bool) public isBlackListed;
177     
178     function addBlackList (address _evilUser) public onlyOwner {
179         isBlackListed[_evilUser] = true;
180         emit AddedBlackList(_evilUser);
181     }
182 
183     function removeBlackList (address _clearedUser) public onlyOwner {
184         isBlackListed[_clearedUser] = false;
185         emit RemovedBlackList(_clearedUser);
186     }
187 
188     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
189         require(isBlackListed[_blackListedUser]);
190         uint dirtyFunds = balanceOf(_blackListedUser);
191         balances[_blackListedUser] = 0;
192         _totalSupply -= dirtyFunds;
193         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
194     }
195 
196     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
197 
198     event AddedBlackList(address _user);
199 
200     event RemovedBlackList(address _user);
201 
202 }
203 
204 contract UpgradedStandardToken is StandardToken{
205     function transferByLegacy(address from, address to, uint value) public;
206     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
207     function approveByLegacy(address from, address spender, uint value) public;
208 }
209 
210 contract MSDToken is Pausable, StandardToken, BlackList {
211 
212     string public name;
213     string public symbol;
214     uint public decimals;
215     address public upgradedAddress;
216     bool public deprecated;
217 
218     constructor(uint _initialSupply, string memory _name, string memory _symbol, uint _decimals) public {
219         _totalSupply = _initialSupply;
220         name = _name;
221         symbol = _symbol;
222         decimals = _decimals;
223         balances[owner] = _initialSupply;
224         deprecated = false;
225     }
226 
227     function transfer(address _to, uint _value) public whenNotPaused {
228         require(!isBlackListed[msg.sender]);
229         if (deprecated) {
230             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
231         } else {
232             return super.transfer(_to, _value);
233         }
234     }
235 
236     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
237         require(!isBlackListed[_from]);
238         if (deprecated) {
239             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
240         } else {
241             return super.transferFrom(_from, _to, _value);
242         }
243     }
244 
245     function balanceOf(address who) public view returns (uint) {
246         if (deprecated) {
247             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
248         } else {
249             return super.balanceOf(who);
250         }
251     }
252 
253     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
254         if (deprecated) {
255             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
256         } else {
257             return super.approve(_spender, _value);
258         }
259     }
260 
261     function allowance(address _owner, address _spender) public view returns (uint remaining) {
262         if (deprecated) {
263             return StandardToken(upgradedAddress).allowance(_owner, _spender);
264         } else {
265             return super.allowance(_owner, _spender);
266         }
267     }
268 
269     function deprecate(address _upgradedAddress) public onlyOwner {
270         deprecated = true;
271         upgradedAddress = _upgradedAddress;
272         emit Deprecate(_upgradedAddress);
273     }
274 
275     function totalSupply() public view returns (uint) {
276         if (deprecated) {
277             return StandardToken(upgradedAddress).totalSupply();
278         } else {
279             return _totalSupply;
280         }
281     }
282 
283     function issue(uint amount) public onlyOwner {
284         require(_totalSupply + amount > _totalSupply);
285         require(balances[owner] + amount > balances[owner]);
286 
287         balances[owner] += amount;
288         _totalSupply += amount;
289         emit Issue(amount);
290     }
291 
292     function redeem(uint amount) public onlyOwner {
293         require(_totalSupply >= amount);
294         require(balances[owner] >= amount);
295 
296         _totalSupply -= amount;
297         balances[owner] -= amount;
298         emit Redeem(amount);
299     }
300 
301     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
302         require(newBasisPoints < 20);
303         require(newMaxFee < 50);
304 
305         basisPointsRate = newBasisPoints;
306         maximumFee = newMaxFee.mul(10**decimals);
307 
308         emit Params(basisPointsRate, maximumFee);
309     }
310 
311     event Issue(uint amount);
312 
313     event Redeem(uint amount);
314 
315     event Deprecate(address newAddress);
316 
317     event Params(uint feeBasisPoints, uint maxFee);
318 }