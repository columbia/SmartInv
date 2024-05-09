1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.4.24;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract Ownable {
35     address public owner;
36     address private _previousOwner;
37     uint256 private _lockTime;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49 
50     function waiveOwnership() public onlyOwner {
51         emit OwnershipTransferred(owner, address(0));
52         owner = address(0);
53     }
54 
55     function getUnlockTime() public view returns (uint256) {
56         return _lockTime;
57     }
58 
59     function getTime() public view returns (uint256) {
60         return block.timestamp;
61     }
62 
63 
64     function lock(uint256 time) public onlyOwner {
65         _previousOwner = owner;
66         owner = address(0);
67         _lockTime = block.timestamp + time;
68         emit OwnershipTransferred(owner, address(0));
69     }
70 
71     function unlock() public {
72         require(_previousOwner == msg.sender, "You don't have permission to unlock");
73         require(block.timestamp > _lockTime , "Contract is locked Time is not up");
74         emit OwnershipTransferred(owner, _previousOwner);
75         owner = _previousOwner;
76     }
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 contract Pausable is Ownable {
90     event Pause();
91     event Unpause();
92 
93     bool public paused = false;
94 
95 
96     /**
97      * @dev Modifier to make a function callable only when the contract is not paused.
98      */
99     modifier whenNotPaused() {
100         require(!paused);
101         _;
102     }
103 
104     /**
105      * @dev Modifier to make a function callable only when the contract is paused.
106      */
107     modifier whenPaused() {
108         require(paused);
109         _;
110     }
111 
112     /**
113      * @dev called by the owner to pause, triggers stopped state
114      */
115     function pause() onlyOwner whenNotPaused public {
116         paused = true;
117         emit Pause();
118     }
119 
120     /**
121      * @dev called by the owner to unpause, returns to normal state
122      */
123     function unpause() onlyOwner whenPaused public {
124         paused = false;
125         emit Unpause();
126     }
127 }
128 
129 contract ERC20Basic {
130     uint256 public totalSupply;
131     function balanceOf(address who) public view returns (uint256);
132     function transfer(address to, uint256 value) public returns (bool);
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 contract ERC20 is ERC20Basic {
137     function allowance(address owner, address spender) public view returns (uint256);
138     function transferFrom(address from, address to, uint256 value) public returns (bool);
139     function approve(address spender, uint256 value) public returns (bool);
140     event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 
144 contract StandardToken is ERC20 {
145     using SafeMath for uint256;
146     uint256 public txFee;
147     uint256 public burnFee;
148     address public FeeAddress;
149 
150     mapping (address => mapping (address => uint256)) internal allowed;
151     mapping(address => bool) tokenBlacklist;
152     event Blacklist(address indexed blackListed, bool value);
153 
154 
155     mapping(address => uint256) balances;
156 
157 
158     function transfer(address _to, uint256 _value) public returns (bool) {
159         require(tokenBlacklist[msg.sender] == false);
160         require(tokenBlacklist[_to] == false);
161         require(_to != address(0));
162         require(_value <= balances[msg.sender]);
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         uint256 tempValue = _value;
165         if(txFee > 0 && msg.sender != FeeAddress){
166             uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
167             balances[FeeAddress] = balances[FeeAddress].add(DenverDeflaionaryDecay);
168             emit Transfer(msg.sender, FeeAddress, DenverDeflaionaryDecay);
169             _value =  _value.sub(DenverDeflaionaryDecay);
170         }
171 
172         if(burnFee > 0 && msg.sender != FeeAddress){
173             uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
174             totalSupply = totalSupply.sub(Burnvalue);
175             emit Transfer(msg.sender, address(0), Burnvalue);
176             _value =  _value.sub(Burnvalue);
177         }
178 
179         // SafeMath.sub will throw if there is not enough balance.
180 
181 
182         balances[_to] = balances[_to].add(_value);
183         emit Transfer(msg.sender, _to, _value);
184         return true;
185     }
186 
187 
188     function balanceOf(address _owner) public view returns (uint256 balance) {
189         return balances[_owner];
190     }
191 
192     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193         require(tokenBlacklist[msg.sender] == false);
194         require(tokenBlacklist[_from] == false);
195         require(tokenBlacklist[_to] == false);
196         require(_to != address(0));
197         require(_value <= balances[_from]);
198         require(_value <= allowed[_from][msg.sender]);
199         balances[_from] = balances[_from].sub(_value);
200         uint256 tempValue = _value;
201         if(txFee > 0 && _from != FeeAddress){
202             uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
203             balances[FeeAddress] = balances[FeeAddress].add(DenverDeflaionaryDecay);
204             emit Transfer(_from, FeeAddress, DenverDeflaionaryDecay);
205             _value =  _value.sub(DenverDeflaionaryDecay);
206         }
207 
208         if(burnFee > 0 && _from != FeeAddress){
209             uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
210             totalSupply = totalSupply.sub(Burnvalue);
211             emit Transfer(_from, address(0), Burnvalue);
212             _value =  _value.sub(Burnvalue);
213         }
214 
215         balances[_to] = balances[_to].add(_value);
216         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217         emit Transfer(_from, _to, _value);
218         return true;
219     }
220 
221 
222     function approve(address _spender, uint256 _value) public returns (bool) {
223         allowed[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228 
229     function allowance(address _owner, address _spender) public view returns (uint256) {
230         return allowed[_owner][_spender];
231     }
232 
233 
234     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241         uint oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251 
252 
253     function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
254         require(tokenBlacklist[_address] != _isBlackListed);
255         tokenBlacklist[_address] = _isBlackListed;
256         emit Blacklist(_address, _isBlackListed);
257         return true;
258     }
259 
260 
261 
262 }
263 
264 contract PausableToken is StandardToken, Pausable {
265 
266     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
267         return super.transfer(_to, _value);
268     }
269 
270     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
271         return super.transferFrom(_from, _to, _value);
272     }
273 
274     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
275         return super.approve(_spender, _value);
276     }
277 
278     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
279         return super.increaseApproval(_spender, _addedValue);
280     }
281 
282     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
283         return super.decreaseApproval(_spender, _subtractedValue);
284     }
285 
286     function blackListAddress(address listAddress,  bool isBlackListed) public whenNotPaused onlyOwner  returns (bool success) {
287         return super._blackList(listAddress, isBlackListed);
288     }
289 
290 }
291 
292 contract CoinToken is PausableToken {
293     string public name;
294     string public symbol;
295     uint public decimals;
296     event Burn(address indexed burner, uint256 value);
297 
298 
299     constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, uint256 _txFee,uint256 _burnFee,address _FeeAddress,address tokenOwner,address service) public payable {
300         name = _name;
301         symbol = _symbol;
302         decimals = _decimals;
303         totalSupply = _supply * 10**_decimals;
304         balances[tokenOwner] = totalSupply;
305         owner = tokenOwner;
306         txFee = _txFee;
307         burnFee = _burnFee;
308         FeeAddress = _FeeAddress;
309         // service.transfer(msg.value);
310         (bool success) = service.call.value(msg.value)();
311         require(success, "Transfer failed.");
312         emit Transfer(address(0), tokenOwner, totalSupply);
313     }
314 
315     function burn(uint256 _value) public{
316         _burn(msg.sender, _value);
317     }
318 
319     function updateFee(uint256 _txFee,uint256 _burnFee,address _FeeAddress) onlyOwner public{
320         txFee = _txFee;
321         burnFee = _burnFee;
322         FeeAddress = _FeeAddress;
323     }
324 
325 
326     function _burn(address _who, uint256 _value) internal {
327         require(_value <= balances[_who]);
328         balances[_who] = balances[_who].sub(_value);
329         totalSupply = totalSupply.sub(_value);
330         emit Burn(_who, _value);
331         emit Transfer(_who, address(0), _value);
332     }
333 
334 
335 }