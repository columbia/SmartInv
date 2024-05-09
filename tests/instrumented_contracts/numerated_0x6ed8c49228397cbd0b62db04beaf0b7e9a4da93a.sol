1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     function Ownable() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 }
49 
50 contract ERC20Interface {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     function allowance(address owner, address spender) public view returns (uint256);
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract StandardToken is ERC20Interface {
63     using SafeMath for uint256;
64 
65     mapping(address => uint256) balances;
66     mapping (address => mapping (address => uint256)) internal allowed;
67 
68     uint256 totalSupply_;
69 
70     function totalSupply() public view returns (uint256) {
71         return totalSupply_;
72     }
73 
74     function balanceOf(address _owner) public view returns (uint256) {
75         return balances[_owner];
76     }
77 
78     function transfer(address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80         require(_value > 0 && _value <= balances[msg.sender]);
81 
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         emit Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90         require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);
91 
92         balances[_from] = balances[_from].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool) {
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public view returns (uint256) {
106         return allowed[_owner][_spender];
107     }
108 
109     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
110         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114 
115     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
116         uint oldValue = allowed[msg.sender][_spender];
117         if (_subtractedValue > oldValue) {
118             allowed[msg.sender][_spender] = 0;
119         } else {
120             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
121         }
122         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123         return true;
124     }
125 }
126 
127 contract Pausable is Ownable {
128     event Pause();
129     event Unpause();
130 
131     bool public paused = false;
132 
133     modifier whenNotPaused() {
134         require(!paused);
135         _;
136     }
137 
138     modifier whenPaused() {
139         require(paused);
140         _;
141     }
142 
143     function pause() onlyOwner whenNotPaused public {
144         paused = true;
145         emit Pause();
146     }
147 
148     function unpause() onlyOwner whenPaused public {
149         paused = false;
150         emit Unpause();
151     }
152 }
153 
154 contract PausableToken is StandardToken, Pausable {
155     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
156         return super.transfer(_to, _value);
157     }
158 
159     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
160         return super.transferFrom(_from, _to, _value);
161     }
162 
163     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
164         return super.approve(_spender, _value);
165     }
166 
167     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
168         return super.increaseApproval(_spender, _addedValue);
169     }
170 
171     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
172         return super.decreaseApproval(_spender, _subtractedValue);
173     }
174 }
175 
176 contract BurnableToken is StandardToken {
177     event Burn(address indexed burner, uint256 value);
178 
179     function burn(uint256 _value) public {
180         _burn(msg.sender, _value);
181     }
182 
183     function _burn(address _who, uint256 _value) internal {
184         require(_value <= balances[_who]);
185 
186         balances[_who] = balances[_who].sub(_value);
187         totalSupply_ = totalSupply_.sub(_value);
188         emit Burn(_who, _value);
189         emit Transfer(_who, address(0), _value);
190     }
191 
192     function burnFrom(address _from, uint256 _value) public {
193         require(_value <= allowed[_from][msg.sender]);
194 
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         _burn(_from, _value);
197     }
198 }
199 
200 contract MintableToken is StandardToken, Ownable {
201     event Mint(address indexed to, uint256 amount);
202     event MintFinished();
203 
204     bool public mintingFinished = false;
205 
206     modifier canMint() {
207         require(!mintingFinished);
208         _;
209     }
210 
211     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
212         totalSupply_ = totalSupply_.add(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         emit Mint(_to, _amount);
215         emit Transfer(address(0), _to, _amount);
216         return true;
217     }
218 
219     function finishMinting() onlyOwner canMint public returns (bool) {
220         mintingFinished = true;
221         emit MintFinished();
222         return true;
223     }
224 }
225 
226 library SafeERC20 {
227     function safeTransfer(ERC20Interface token, address to, uint256 value) internal {
228         assert(token.transfer(to, value));
229     }
230 
231     function safeTransferFrom(ERC20Interface token, address from, address to, uint256 value ) internal {
232         assert(token.transferFrom(from, to, value));
233     }
234 
235     function safeApprove(ERC20Interface token, address spender, uint256 value) internal {
236         assert(token.approve(spender, value));
237     }
238 }
239 
240 contract TokenVesting is Ownable {
241     using SafeMath for uint256;
242     using SafeERC20 for ERC20Interface;
243 
244     event Released(uint256 amount);
245     event Revoked();
246 
247     address public beneficiary;
248 
249     uint256 public cliff;
250     uint256 public start;
251     uint256 public duration;
252 
253     bool public revocable;
254 
255     mapping (address => uint256) public released;
256     mapping (address => bool) public revoked;
257 
258     function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
259         require(_beneficiary != address(0));
260         require(_cliff <= _duration);
261 
262         beneficiary = _beneficiary;
263         revocable = _revocable;
264         duration = _duration;
265         cliff = _start.add(_cliff);
266         start = _start;
267     }
268 
269     function release(ERC20Interface token) public {
270         uint256 unreleased = releasableAmount(token);
271 
272         require(unreleased > 0);
273 
274         released[token] = released[token].add(unreleased);
275 
276         token.safeTransfer(beneficiary, unreleased);
277 
278         emit Released(unreleased);
279     }
280 
281     function revoke(ERC20Interface token) public onlyOwner {
282         require(revocable);
283         require(!revoked[token]);
284 
285         uint256 balance = token.balanceOf(this);
286 
287         uint256 unreleased = releasableAmount(token);
288         uint256 refund = balance.sub(unreleased);
289 
290         revoked[token] = true;
291 
292         token.safeTransfer(owner, refund);
293 
294         emit Revoked();
295     }
296 
297     function releasableAmount(ERC20Interface token) public view returns (uint256) {
298         return vestedAmount(token).sub(released[token]);
299     }
300 
301     function vestedAmount(ERC20Interface token) public view returns (uint256) {
302         uint256 currentBalance = token.balanceOf(this);
303         uint256 totalBalance = currentBalance.add(released[token]);
304 
305         if (block.timestamp < cliff) {
306             return 0;
307         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
308             return totalBalance;
309         } else {
310             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
311         }
312     }
313 }
314 
315 contract ETVRToken is PausableToken, BurnableToken, MintableToken {
316     string public constant name     = "ETVR TOKEN";
317     string public constant symbol   = "ETVR";
318     uint8  public constant decimals = 18;
319 
320     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
321 
322     function ETVRToken() public {
323         totalSupply_ = INITIAL_SUPPLY;
324         balances[msg.sender] = INITIAL_SUPPLY;
325         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
326     }
327 }