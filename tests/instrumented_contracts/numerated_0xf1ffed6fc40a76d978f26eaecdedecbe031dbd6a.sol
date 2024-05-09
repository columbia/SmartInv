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
27     mapping (uint256 => address) public owner;
28     address[] public allOwner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     constructor() public {
33         owner[0] = msg.sender;
34         allOwner.push(msg.sender);
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner[0] || msg.sender == owner[1] || msg.sender == owner[2]);
39         _;
40     }
41     
42     function addnewOwner(address newOwner) public onlyOwner {
43         require(newOwner != address(0));
44         uint256 len = allOwner.length;
45         owner[len] = newOwner;
46         allOwner.push(newOwner);
47     }
48 
49     function setNewOwner(address newOwner, uint position) public onlyOwner {
50         require(newOwner != address(0));
51         require(position == 1 || position == 2);
52         owner[position] = newOwner;
53     }
54 
55     function transferOwnership(address newOwner) public onlyOwner {
56         require(newOwner != address(0));
57         emit OwnershipTransferred(owner[0], newOwner);
58         owner[0] = newOwner;
59     }
60 
61 }
62 
63 contract ERC20 {
64     function totalSupply() public view returns (uint256);
65     function balanceOf(address who) public view returns (uint256);
66     function transfer(address to, uint256 value) public;
67     function allowance(address owner, address spender) public view returns (uint256);
68     function transferFrom(address from, address to, uint256 value) public returns (bool);
69     function approve(address spender, uint256 value) public returns (bool);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Burn(address indexed from, uint256 value);
74 }
75 
76 contract KNBaseToken is ERC20 {
77     using SafeMath for uint256;
78     
79     string public name;
80     string public symbol;
81     uint8 public decimals;
82     uint256 totalSupply_;
83 
84     mapping(address => uint256) balances;
85     mapping (address => mapping (address => uint256)) internal allowed;
86 
87     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
88         name = _name;
89         symbol = _symbol;
90         decimals = _decimals;
91         totalSupply_ = _totalSupply;
92     }
93 
94     function totalSupply() public view returns (uint256) {
95         return totalSupply_;
96     }
97 
98     function balanceOf(address _owner) public view returns (uint256) {
99         return balances[_owner];
100     }
101 
102     function _transfer(address _from, address _to, uint256 _value) internal {
103         require(_to != address(0));
104         require(balances[_from] >= _value);
105         require(balances[_to].add(_value) > balances[_to]);
106 
107 
108         uint256 previousBalances = balances[_from].add(balances[_to]);
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(_from, _to, _value);
112 
113         assert(balances[_from].add(balances[_to]) == previousBalances);
114     }
115 
116     function transfer(address _to, uint256 _value) public {
117         _transfer(msg.sender, _to, _value);
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_value <= allowed[_from][msg.sender]);     // Check allowance
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         _transfer(_from, _to, _value);
124         return true;
125     }
126 
127     function approve(address _spender, uint256 _value) public returns (bool) {
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) public view returns (uint256) {
134         return allowed[_owner][_spender];
135     }
136 
137     function burn(uint256 _value) public returns (bool success) {
138         require(balances[msg.sender] >= _value);
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         totalSupply_ = totalSupply_.sub(_value);
141         emit Burn(msg.sender, _value);
142         return true;
143     }
144 
145     function burnFrom(address _from, uint256 _value) public returns (bool success) {
146         require(balances[_from] >= _value);
147         require(_value <= allowed[_from][msg.sender]);
148 
149         balances[_from] = balances[_from].sub(_value);
150         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151         totalSupply_ = totalSupply_.sub(_value);
152         emit Burn(msg.sender, _value);
153         return true;
154     }
155 }
156 
157 contract KnowToken is KNBaseToken("Know Token", "KN", 18, 7795482309000000000000000000), Ownable {
158 
159     uint256 internal privateToken = 389774115000000000000000000;
160     uint256 internal preSaleToken = 1169322346000000000000000000;
161     uint256 internal crowdSaleToken = 3897741155000000000000000000;
162     uint256 internal bountyToken;
163     uint256 internal foundationToken;
164     address public founderAddress;
165     bool public unlockAllTokens;
166 
167     mapping (address => bool) public frozenAccount;
168 
169     event FrozenFunds(address target, bool unfrozen);
170     event UnLockAllTokens(bool unlock);
171 
172     constructor() public {
173         founderAddress = msg.sender;
174         balances[founderAddress] = totalSupply_;
175         emit Transfer(address(0), founderAddress, totalSupply_);
176     }
177 
178     function _transfer(address _from, address _to, uint _value) internal {
179         require (_to != address(0));                               
180         require (balances[_from] >= _value);               
181         require (balances[_to].add(_value) >= balances[_to]); 
182         require(!frozenAccount[_from] || unlockAllTokens);
183 
184         balances[_from] = balances[_from].sub(_value);                  
185         balances[_to] = balances[_to].add(_value);                  
186         emit Transfer(_from, _to, _value);
187     }
188 
189     function unlockAllTokens(bool _unlock) public onlyOwner {
190         unlockAllTokens = _unlock;
191         emit UnLockAllTokens(_unlock);
192     }
193 
194     function freezeAccount(address target, bool freeze) public onlyOwner {
195         frozenAccount[target] = freeze;
196         emit FrozenFunds(target, freeze);
197     }
198 }
199 
200 contract KnowTokenPreSale is Ownable{
201     using SafeMath for uint256;
202 
203     KnowToken public token;
204     address public wallet;
205     uint256 public currentRate;
206     uint256 public limitTokenForSale;
207 
208     event ChangeRate(address indexed who, uint256 newrate);
209     event FinishPreSale();
210 
211     constructor() public {
212         currentRate = 26667;
213         wallet = msg.sender; //address of founder
214         limitTokenForSale = 389774115000000000000000000;
215         token = KnowToken(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d);// address of KN Token
216     }
217 
218     function changeRate(uint256 newrate) public onlyOwner{
219         require(newrate > 0);
220         currentRate = newrate;
221 
222         emit ChangeRate(msg.sender, newrate);
223     }
224 
225     function remainTokens() view public returns(uint256) {
226         return token.balanceOf(this);
227     }
228 
229     function finish() public onlyOwner {
230         uint256 reTokens = remainTokens();
231         token.transfer(owner[0], reTokens);
232         
233         emit FinishPreSale();
234     }
235 
236     function () public payable {
237         assert(msg.value > 0 ether);
238         
239         uint256 tokens = currentRate.mul(msg.value);
240         token.transfer(msg.sender, tokens);
241         token.freezeAccount(msg.sender, true);        
242         wallet.transfer(msg.value);       
243     }  
244 }