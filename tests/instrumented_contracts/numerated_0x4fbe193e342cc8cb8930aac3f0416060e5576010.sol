1 pragma solidity ^0.5.1;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 library SafeMath {
12 
13 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 		uint256 c = a * b;
15 		assert(a == 0 || c / a == b);
16 		return c;
17 	}
18 
19 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
20 		uint256 c = a / b;
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 
29 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30 		c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34 }
35 
36 contract BasicToken is ERC20Basic {
37 
38     using SafeMath for uint256;
39 
40     mapping(address => uint256) _balances;
41 
42     uint256 _totalSupply;
43 
44     function totalSupply() public view returns (uint256) {
45         return _totalSupply;
46     }
47 
48     function transfer(address _to, uint256 _value) public returns (bool) {
49         require(_to != address(0));
50         require(_value <= _balances[msg.sender]);
51 
52         _balances[msg.sender] = _balances[msg.sender].sub(_value);
53         _balances[_to] = _balances[_to].add(_value);
54         emit Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function balanceOf(address _owner) public view returns (uint256) {
59         return _balances[_owner];
60     }
61 
62 }
63 
64 contract ERC20 {
65     function allowance(address owner, address spender) public view returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71 
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79     mapping (address => mapping (address => uint256)) internal allowed;
80     
81 
82     
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84         require(_to != address(0));
85         require(_value <= _balances[_from]);
86         require(_value <= allowed[_from][msg.sender]);
87 
88         _balances[_from] = _balances[_from].sub(_value);
89         _balances[_to] = _balances[_to].add(_value);
90         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         emit Transfer(_from, _to, _value);
92 
93         return true;
94     }
95 
96     function approve(address _spender, uint256 _value) public returns (bool) {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) public view returns (uint256) {
103         return allowed[_owner][_spender];
104     }
105 
106     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
107         allowed[msg.sender][_spender] = (
108         allowed[msg.sender][_spender].add(_addedValue));
109         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110         return true;
111     }
112 
113     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
114         uint oldValue = allowed[msg.sender][_spender];
115         
116         if (_subtractedValue > oldValue) {
117         allowed[msg.sender][_spender] = 0;
118         } else {
119         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120         }
121         
122         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123         return true;
124     }
125 }
126 
127 contract Ownable {
128 
129     address public owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     constructor() public {
134         owner = msg.sender;
135     }
136 
137     modifier onlyOwner() {
138         require(msg.sender == owner, "only owner is able to call this function");
139         _;
140     }
141 
142     function transferOwnership(address _newOwner) public onlyOwner {
143         _transferOwnership(_newOwner);
144      }
145 
146 
147     function _transferOwnership(address newOwner) internal{
148         require(newOwner != address(0));
149         emit OwnershipTransferred(owner, newOwner);
150         owner = newOwner;
151     }
152     
153 
154 }
155 
156 contract Pausable is Ownable {
157 
158     event Pause();
159     event Unpause();
160 
161     bool public paused = false;
162 
163     modifier whenNotPaused() {
164         require(!paused || msg.sender == owner);
165         _;
166     }
167 
168     modifier whenPaused() {
169         require(paused);
170         _;
171     }
172 
173     function pause() onlyOwner whenNotPaused public {
174         paused = true;
175         emit Pause();
176     }
177 
178     function unpause() onlyOwner whenPaused public {
179         paused = false;
180         emit Unpause();
181     }
182   
183 }
184 
185 
186 contract BlackListable is Ownable {
187 
188     mapping (address => bool) public blacklist;
189 
190     event BlackListAdded(address _address);
191     event BlackListRemoved(address _address);
192 
193     function isBlacklisted(address _address)  external view returns (bool) {
194         return blacklist[_address];
195     }
196 
197     function getOwner() external view returns (address) {
198         return owner;
199     }
200 
201 
202     function addBlackList (address _address) public onlyOwner {
203         blacklist[_address] = true;
204         emit BlackListAdded(_address);
205     }
206 
207     function removeBlackList (address _address) public onlyOwner {
208         blacklist[_address] = false;
209         emit BlackListRemoved(_address);
210     }
211 
212 
213 }
214 
215 
216 contract Freezeable is Ownable, StandardToken, Pausable, BlackListable{
217 
218     event AccountFrozen(address indexed _address, uint256 amount);
219     event AccountUnfrozen(address indexed _address);
220 
221     mapping(address => uint256) public freezeAccounts;
222     
223     function transfer(address _to, uint256 _value) public whenNotPaused  returns (bool) {
224         require(_to != address(0));
225         require(!blacklist[_to]);
226         require(!blacklist[msg.sender]);
227         require(balanceOf(msg.sender) >= freezeOf(msg.sender).add(_value));
228         
229         return super.transfer(_to, _value);
230     }
231 
232     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused  returns (bool) {
233         require(_to != address(0));
234         require(!blacklist[msg.sender]);
235         require(!blacklist[_from]);
236         require(!blacklist[_to]);
237         require(balanceOf(_from) >= freezeOf(_from).add(_value));
238 
239         return super.transferFrom(_from, _to, _value);
240     }
241 
242     function approve(address _spender, uint256 _value) public whenNotPaused  returns (bool) {
243         require(_spender != address(0));
244         require(!blacklist[_spender]);
245         require(!blacklist[msg.sender]);
246 
247         return super.approve(_spender, _value);
248     }
249 
250     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused  returns (bool success) {
251         require(_spender != address(0));
252         require(!blacklist[_spender]);
253         require(!blacklist[msg.sender]);
254 
255         return super.increaseApproval(_spender, _addedValue);
256     }
257 
258     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused  returns (bool success) {
259         require(_spender != address(0));
260         require(!blacklist[msg.sender]);
261         
262         return super.decreaseApproval(_spender, _subtractedValue);
263     }
264     
265     function freezeOf(address _address) public view returns (uint256 _value) {
266         require(!blacklist[msg.sender]);
267 
268 		return freezeAccounts[_address];
269 	}
270 
271 	function freezeAmount() public view returns (uint256 _value) {
272         require(!blacklist[msg.sender]);
273 		return freezeAccounts[msg.sender];
274 	}
275 	
276     function freeze(address _address, uint256 _value) public onlyOwner {
277 		require(_value <= _totalSupply);
278 		require(_address != address(0));
279 
280 		freezeAccounts[_address] = _value;
281 		emit AccountFrozen(_address, _value);
282 	}
283 	
284 
285     function unfreeze(address _address) public onlyOwner {
286 		require(_address != address(0));
287 
288 		freezeAccounts[_address] = 0;
289 		emit AccountUnfrozen(_address);
290 	}
291 
292 }
293 
294 
295 contract GrameToken is Freezeable{
296    
297     string  public  name;
298     string  public  symbol;
299     uint256 public  decimals;
300  
301     constructor(uint  _initialSupply, string  memory _name, string memory _symbol, uint  _decimals) public {
302 		name = _name;
303 		symbol = _symbol;
304 		decimals = _decimals;
305 		
306         _totalSupply = _initialSupply;
307 		_balances[owner] = _initialSupply;
308 		emit Transfer(address(0x0), owner, _totalSupply);
309     }
310     
311 
312     event Burn( address indexed to, uint256 value);
313 
314     function burn( uint256 value) public  onlyOwner{
315         require(value <= _balances[owner]);
316 
317         _totalSupply = _totalSupply.sub(value);
318         _balances[owner] = _balances[owner].sub(value);
319         emit Burn(address(0), value);
320     }
321     
322     function() external payable {
323  	   revert();
324 	}
325 
326 }