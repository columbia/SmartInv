1 pragma solidity 0.5.4;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 }
32 
33 contract ERC20 {
34     function totalSupply() public view returns (uint256);
35     function balanceOf(address who) public view returns (uint256);
36     function allowance(address owner, address spender) public view returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40 
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract Ownable {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor() public {
52         owner = msg.sender;
53         newOwner = address(0);
54     }
55 
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60     modifier onlyNewOwner() {
61         require(msg.sender == newOwner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         require(_newOwner != address(0));
67         newOwner = _newOwner;
68     }
69 
70     function acceptOwnership() public onlyNewOwner returns(bool) {
71         emit OwnershipTransferred(owner, newOwner);        
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 contract Whitelist is Ownable {
78     using SafeMath for uint256;
79 
80     mapping (address => bool) public whitelist;
81     
82     event AddWhiteListAddress(address indexed _address);
83     event RemoveWhiteListAddress(address indexed _address);
84 
85 
86     constructor() public {
87         whitelist[owner] = true;
88     }
89     
90     function AddWhitelist(address account) public onlyOwner returns(bool) {
91         require(account != address(0));
92         require(whitelist[account] == false);
93         require(account != address(this));
94         whitelist[account] = true;
95         emit AddWhiteListAddress(account);
96         return true;
97     }
98 
99     function RemoveWhiltelist(address account) public onlyOwner returns(bool) {
100         require(account != address(0));
101         require(whitelist[account] == true);
102         require(account != owner);
103         whitelist[account] = false;
104         emit RemoveWhiteListAddress(account);
105         return true;
106     }
107 }
108 
109 contract Pausable is Ownable, Whitelist {
110     event Pause();
111     event Unpause();
112 
113     bool public paused = false;
114 
115     modifier whenNotPaused() {
116         require(whitelist[msg.sender] == true || !paused);
117         _;
118     }
119 
120     modifier whenPaused() {
121         require(paused);
122         _;
123     }
124 
125     function pause() onlyOwner whenNotPaused public {
126         paused = true;
127         emit Pause();
128     }
129 
130     function unpause() onlyOwner whenPaused public {
131         paused = false;
132         emit Unpause();
133     }
134 }
135 
136 contract Blacklist is Ownable {
137     using SafeMath for uint256;
138 
139     mapping (address => bool) public blacklist;
140     
141     event AddBlackListAddress(address indexed _address);
142     event RemoveBlackListAddress(address indexed _address);
143 
144 
145     constructor() public {
146         
147     }
148     
149     function AddBlacklist(address account) public onlyOwner returns(bool) {
150         require(account != address(0));
151         require(blacklist[account] == false);
152         require(account != address(this));
153         require(account != owner);
154 
155         blacklist[account] = true;
156         emit AddBlackListAddress(account);
157         return true;
158     }
159 
160     function RemoveBlacklist(address account) public onlyOwner returns(bool) {
161         require(account != address(0));
162         require(blacklist[account] == true);
163         blacklist[account] = false;
164         emit RemoveBlackListAddress(account);
165         return true;
166     }
167 }
168 
169 contract CosmoCoin is ERC20, Ownable, Pausable, Blacklist{
170     mapping(address => uint256) balances;
171     mapping(address => mapping(address => uint256)) internal allowed;
172     
173     string private _name = "CosmoCoin";
174     string private _symbol = "COSM";
175     uint8 private _decimals = 18;
176     uint256 private totalTokenSupply;
177     
178     event Mint(address indexed to, uint256 value);
179     event Burn(address indexed from, address indexed at, uint256 value);
180     
181     function name() public view returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public view returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public view returns (uint8) {
190         return _decimals;
191     }
192 
193     constructor(uint256 _totalSupply) public {
194         require(_totalSupply > 0);
195         totalTokenSupply = _totalSupply.mul(10 ** uint(_decimals));
196         balances[msg.sender] = totalTokenSupply;
197         emit Transfer(address(0), msg.sender, totalTokenSupply);
198     }
199     
200     function totalSupply() public view returns (uint256) {
201         return totalTokenSupply;
202     }
203     
204     function balanceOf(address _who) public view returns(uint256) {
205         return balances[_who];
206     }
207     
208     function transfer(address _to, uint256 _amount) public whenNotPaused returns(bool) {
209         require(_to != address(0));
210         require(_to != address(this));
211         require(_amount > 0);
212         require(_amount <= balances[msg.sender]);
213         require(blacklist[msg.sender] == false);
214         require(blacklist[_to] == false);
215 
216         balances[msg.sender] = balances[msg.sender].sub(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(msg.sender, _to, _amount);
219         return true;
220     }
221     
222     function transferFrom(address _from, address _to, uint256 _amount) public whenNotPaused returns(bool) {
223         require(_to != address(0));
224         require(_to != address(this));
225         require(_amount <= balances[_from]);
226         require(_amount <= allowed[_from][msg.sender]);
227         require(blacklist[_from] == false);
228         require(blacklist[_to] == false);
229         require(blacklist[msg.sender] == false);
230 
231         balances[_from] = balances[_from].sub(_amount);
232         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
233         balances[_to] = balances[_to].add(_amount);
234         emit Transfer(_from, _to, _amount);
235         return true;
236     }
237 
238     function approve(address _spender, uint256 _amount) public returns(bool) {
239         // reduce spender's allowance to 0 then set desired value after to avoid race condition
240         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
241         allowed[msg.sender][_spender] = _amount;
242         emit Approval(msg.sender, _spender, _amount);
243         return true;
244     }
245 
246     function allowance(address _owner, address _spender) public view returns(uint256) {
247         return allowed[_owner][_spender];
248     }
249     
250     function () payable external{
251         revert();
252     }
253     
254     function burn(address _address, uint256 _value) external whenNotPaused {
255         require(_value <= balances[_address]);
256         require((whitelist[msg.sender] == true && _address == msg.sender) || (msg.sender == owner));
257         balances[_address] = balances[_address].sub(_value);
258         totalTokenSupply = totalTokenSupply.sub(_value);
259         emit Burn(msg.sender, _address, _value);
260         emit Transfer(_address, address(0), _value);
261     }
262     
263     function mintTokens(address _beneficiary, uint256 _value) external onlyOwner {
264         require(_beneficiary != address(0));
265         require(blacklist[_beneficiary] == false);
266         require(_value > 0);
267         balances[_beneficiary] = balances[_beneficiary].add(_value);
268         totalTokenSupply = totalTokenSupply.add(_value);
269         emit Mint(_beneficiary, _value);
270         emit Transfer(address(0), _beneficiary, _value);
271     }
272 }