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
110 
111     constructor() public {
112         setRate(1);
113         _totalSupply = INITIAL_SUPPLY;
114         balances[msg.sender] = INITIAL_SUPPLY;
115         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
116 
117         owner = msg.sender;
118     }
119 
120     function () public payable {
121         revert();
122     }
123 
124     function createTokens() payable public {
125         require(msg.value > 0);
126         require(whitelisted[msg.sender]);
127 
128         uint256 tokens = msg.value.mul(RATE);
129         balances[msg.sender] = balances[msg.sender].add(tokens);
130         _totalSupply = _totalSupply.add(tokens);
131 
132         owner.transfer(msg.value);
133     }
134 
135     function totalSupply() constant public returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address _owner) constant public returns (uint256 balance) {
140         return balances[_owner];
141     }
142 
143     function transfer(address _to, uint256 _value) public returns (bool success) {
144         require(
145             balances[msg.sender] >= _value
146             && _value > 0
147         );
148 
149         balances[msg.sender] = balances[msg.sender].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         emit Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
156         require(
157             balances[msg.sender] >= _value
158             && balances[_from] >= _value
159             && _value > 0
160             && whitelisted[msg.sender]
161         );
162         balances[_from] -= _value;
163         balances[_to] += _value;
164         allowed[_from][msg.sender] -= _value;
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     function approve(address _spender, uint256 _value) public returns (bool success) {
170         allowed[msg.sender][_spender] = _value;
171         whitelisted[_spender] = true;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     function allowance(address _owner, address _spender) constant public returns (uint256 remianing) {
177         return allowed[_owner][_spender];
178     }
179 
180     function getRate() public constant returns (uint256) {
181         return RATE;
182     }
183 
184     function setRate(uint256 _rate) public returns (bool success) {
185         RATE = _rate;
186         return true;
187     }
188 
189     modifier canMint() {
190         require(!mintingFinished);
191         _;
192     }
193 
194     modifier hasMintPermission() {
195         require(msg.sender == owner);
196         _;
197     }
198 
199     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
200         uint256 tokens = _amount.mul(RATE);
201         require(
202             _currentSupply.add(tokens) < MAXUM_SUPPLY
203             && whitelisted[msg.sender]
204         );
205 
206         if (_currentSupply >= INITIAL_SUPPLY) {
207             _totalSupply = _totalSupply.add(tokens);
208         }
209 
210         _currentSupply = _currentSupply.add(tokens);
211         balances[_to] = balances[_to].add(tokens);
212         emit Mint(_to, tokens);
213         emit Transfer(address(0), _to, tokens);
214         return true;
215     }
216 
217     function finishMinting() onlyOwner canMint public returns (bool) {
218         mintingFinished = true;
219         emit MintFinished();
220         return true;
221     }
222 
223     // Add a user to the whitelist
224     function addUser(address user) onlyOwner public {
225         whitelisted[user] = true;
226         emit LogUserAdded(user);
227     }
228 
229     // Remove an user from the whitelist
230     function removeUser(address user) onlyOwner public {
231         whitelisted[user] = false;
232         emit LogUserRemoved(user);
233     }
234 
235     function getCurrentOwnerBallence() constant public returns (uint256) {
236         return balances[msg.sender];
237     }
238 
239     event Transfer(address indexed _from, address indexed _to, uint256 _value);
240     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
241     event Mint(address indexed to, uint256 amount);
242     event MintFinished();
243     event LogUserAdded(address user);
244     event LogUserRemoved(address user);
245 }