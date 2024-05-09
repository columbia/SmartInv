1 pragma solidity ^0.4.21;
2 
3 contract IERC20 {
4     function totalSupply() constant public returns (uint256);
5     function balanceOf(address _owner) constant public returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) constant public returns (uint256 remianing);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract Ownable {
15     address public owner;
16 
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21     /**
22     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23     * account.
24     */
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29     /**
30     * @dev Throws if called by any account other than the owner.
31     */
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     /**
38     * @dev Allows the current owner to transfer control of the contract to a newOwner.
39     * @param newOwner The address to transfer ownership to.
40     */
41     function transferOwnership(address newOwner) public onlyOwner {
42         require(newOwner != address(0));
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45     }
46 }
47 
48 library SafeMath {
49     
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a * b;
52         assert(a == 0 || c / a == b);
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a / b;
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 
72     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
73         return a >= b ? a : b;
74     }
75 
76     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
77         return a < b ? a : b;
78     }
79 
80     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a >= b ? a : b;
82     }
83 
84     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a < b ? a : b;
86     }
87 }
88 
89 contract JAAGCoin is IERC20, Ownable {
90 
91     using SafeMath for uint256;
92 
93     uint public _totalSupply = 0;
94     uint public constant INITIAL_SUPPLY = 160000000000000000000000000;
95     uint public MAXUM_SUPPLY = 250000000000000000000000000;
96     uint256 public _currentSupply = 0;
97 
98     string public constant symbol = "JAAG";
99     string public constant name = "JAAGCoin";
100     uint8 public constant decimals = 18;
101 
102     // 1 ether = 500 BC
103     uint256 public RATE;
104 
105     bool public mintingFinished = false;
106 
107     mapping(address => uint256)balances;
108     mapping(address => mapping(address => uint256)) allowed;
109     mapping(address => bool) whitelisted;
110     mapping(address => bool) blockListed;
111 
112     constructor() public {
113         setRate(1);
114         _totalSupply = INITIAL_SUPPLY;
115         balances[msg.sender] = INITIAL_SUPPLY;
116         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
117 
118         owner = msg.sender;
119     }
120 
121     function () public payable {
122         revert();
123     }
124 
125     function createTokens() payable public {
126         require(msg.value > 0);
127         require(whitelisted[msg.sender]);
128 
129         uint256 tokens = msg.value.mul(RATE);
130         balances[msg.sender] = balances[msg.sender].add(tokens);
131         _totalSupply = _totalSupply.add(tokens);
132 
133         owner.transfer(msg.value);
134     }
135 
136     function totalSupply() constant public returns (uint256) {
137         return _totalSupply;
138     }
139 
140     function balanceOf(address _owner) constant public returns (uint256 balance) {
141         return balances[_owner];
142     }
143 
144     function transfer(address _to, uint256 _value) public returns (bool success) {
145         require(
146             balances[msg.sender] >= _value
147             && _value > 0
148             && !blockListed[_to]
149             && !blockListed[msg.sender]
150         );
151 
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         emit Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
159         require(
160             balances[msg.sender] >= _value
161             && balances[_from] >= _value
162             && _value > 0
163             && whitelisted[msg.sender]
164             && !blockListed[_to]
165             && !blockListed[msg.sender]
166         );
167         balances[_from] -= _value;
168         balances[_to] += _value;
169         allowed[_from][msg.sender] -= _value;
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     function approve(address _spender, uint256 _value) public returns (bool success) {
175         allowed[msg.sender][_spender] = _value;
176         whitelisted[_spender] = true;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     function allowance(address _owner, address _spender) constant public returns (uint256 remianing) {
182         return allowed[_owner][_spender];
183     }
184 
185     function getRate() public constant returns (uint256) {
186         return RATE;
187     }
188 
189     function setRate(uint256 _rate) public returns (bool success) {
190         RATE = _rate;
191         return true;
192     }
193 
194     modifier canMint() {
195         require(!mintingFinished);
196         _;
197     }
198 
199     modifier hasMintPermission() {
200         require(msg.sender == owner);
201         _;
202     }
203 
204     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
205         uint256 tokens = _amount.mul(RATE);
206         require(
207             _currentSupply.add(tokens) < MAXUM_SUPPLY
208             && whitelisted[msg.sender]
209             && !blockListed[_to]
210         );
211 
212         if (_currentSupply >= INITIAL_SUPPLY) {
213             _totalSupply = _totalSupply.add(tokens);
214         }
215 
216         _currentSupply = _currentSupply.add(tokens);
217         balances[_to] = balances[_to].add(tokens);
218         emit Mint(_to, tokens);
219         emit Transfer(address(0), _to, tokens);
220         return true;
221     }
222 
223     function finishMinting() onlyOwner canMint public returns (bool) {
224         mintingFinished = true;
225         emit MintFinished();
226         return true;
227     }
228 
229     // Add a user to the whitelist
230     function addUser(address user) onlyOwner public {
231         whitelisted[user] = true;
232         emit LogUserAdded(user);
233     }
234 
235     // Remove an user from the whitelist
236     function removeUser(address user) onlyOwner public {
237         whitelisted[user] = false;
238         emit LogUserRemoved(user);
239     }
240 
241     function getCurrentOwnerBallence() constant public returns (uint256) {
242         return balances[msg.sender];
243     }
244 
245     function addBlockList(address wallet) onlyOwner public {
246         blockListed[wallet] = true;
247     }
248 
249     function removeBlockList(address wallet) onlyOwner public {
250         blockListed[wallet] = false;
251     }
252 
253     event Transfer(address indexed _from, address indexed _to, uint256 _value);
254     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
255     event Mint(address indexed to, uint256 amount);
256     event MintFinished();
257     event LogUserAdded(address user);
258     event LogUserRemoved(address user);
259 }