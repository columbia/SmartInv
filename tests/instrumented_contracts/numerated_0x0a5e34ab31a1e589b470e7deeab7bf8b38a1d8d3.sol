1 pragma solidity^0.4.21;
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
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a / b;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         owner = newOwner;
43         emit OwnershipTransferred(owner, newOwner);
44     }
45 
46 }
47 
48 contract ERC20 {
49     function totalSupply() public view returns (uint256);
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public;
52     function allowance(address owner, address spender) public view returns (uint256);
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54     function approve(address spender, uint256 value) public returns (bool);
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Burn(address indexed from, uint256 value);
59 }
60 
61 contract KNBaseToken is ERC20 {
62     using SafeMath for uint256;
63     
64     string public name;
65     string public symbol;
66     uint8 public decimals;
67     uint256 totalSupply_;
68 
69     mapping(address => uint256) balances;
70     mapping (address => mapping (address => uint256)) internal allowed;
71 
72     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
73         name = _name;
74         symbol = _symbol;
75         decimals = _decimals;
76         totalSupply_ = _totalSupply;
77     }
78 
79     function totalSupply() public view returns (uint256) {
80         return totalSupply_;
81     }
82 
83     function balanceOf(address _owner) public view returns (uint256) {
84         return balances[_owner];
85     }
86 
87     function _transfer(address _from, address _to, uint256 _value) internal {
88         require(_to != address(0));
89         require(balances[_from] >= _value);
90         require(balances[_to].add(_value) > balances[_to]);
91 
92 
93         uint256 previousBalances = balances[_from].add(balances[_to]);
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         emit Transfer(_from, _to, _value);
97 
98         assert(balances[_from].add(balances[_to]) == previousBalances);
99     }
100 
101     function transfer(address _to, uint256 _value) public {
102         _transfer(msg.sender, _to, _value);
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106         require(_value <= allowed[_from][msg.sender]);     // Check allowance
107         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256) {
119         return allowed[_owner][_spender];
120     }
121 
122     function burn(uint256 _value) public returns (bool success) {
123         require(balances[msg.sender] >= _value);
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         totalSupply_ = totalSupply_.sub(_value);
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129 
130     function burnFrom(address _from, uint256 _value) public returns (bool success) {
131         require(balances[_from] >= _value);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = balances[_from].sub(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         totalSupply_ = totalSupply_.sub(_value);
137         emit Burn(msg.sender, _value);
138         return true;
139     }
140 }
141 
142 contract KnowToken is KNBaseToken, Ownable {
143 
144     address public founderAddress;
145     bool public unlockAllTokens;
146 
147     mapping (address => bool) public frozenAccount;
148 
149     event FrozenFunds(address target, bool unfrozen);
150     event UnLockAllTokens(bool unlock);
151 
152     constructor() public {
153         founderAddress = msg.sender;
154         balances[founderAddress] = totalSupply_;
155         emit Transfer(address(0), founderAddress, totalSupply_);
156     }
157 
158     function _transfer(address _from, address _to, uint _value) internal {
159         require (_to != address(0));                               
160         require (balances[_from] >= _value);               
161         require (balances[_to].add(_value) >= balances[_to]); 
162         require(!frozenAccount[_from] || unlockAllTokens);
163 
164         balances[_from] = balances[_from].sub(_value);                  
165         balances[_to] = balances[_to].add(_value);                  
166         emit Transfer(_from, _to, _value);
167     }
168 
169     function unlockAllTokens(bool _unlock) public onlyOwner {
170         unlockAllTokens = _unlock;
171         emit UnLockAllTokens(_unlock);
172     }
173 
174     function freezeAccount(address target, bool freeze) public onlyOwner {
175         frozenAccount[target] = freeze;
176         emit FrozenFunds(target, freeze);
177     }
178 }
179 
180 contract KnowTokenCrowdSale is Ownable{
181     using SafeMath for uint256;
182 
183     KnowToken public token;
184     address public wallet;
185     uint256 public currentRate;
186     uint256 public limitTokenForSale;
187 
188     event ChangeRate(address indexed who, uint256 newrate);
189     event FinishCrowdSale();
190     event GetEther(uint256 _e);
191 
192     constructor() public {
193         currentRate = 15000;
194         wallet = msg.sender; //address of founder
195         limitTokenForSale = 2338644692700000000000000000;
196         token = KnowToken(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d);// address of KN Token
197     }
198 
199     function () public payable {
200         require(msg.value > 0 ether);
201         require(currentRate.mul(msg.value) <= token.balanceOf(this));
202         
203         uint256 tokens = currentRate.mul(msg.value);
204         token.transfer(msg.sender, tokens);
205     }
206     
207     function changeRate(uint256 newrate) public onlyOwner{
208         require(newrate > 0);
209         currentRate = newrate;
210         emit ChangeRate(msg.sender, newrate);
211     }
212 
213     function remainTokens() view public returns(uint256) {
214         return token.balanceOf(this);
215     }
216 
217     function finish() public onlyOwner {
218         uint256 reTokens = remainTokens();
219         token.transfer(owner, reTokens);
220         emit FinishCrowdSale();
221     }
222     
223     function getEther(uint256 _e)public onlyOwner {
224         require(_e <= address(this).balance);
225         wallet.transfer(_e);
226         emit GetEther(_e);
227     }
228 }