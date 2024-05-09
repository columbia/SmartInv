1 pragma solidity^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract Ownable {
29     address public owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     constructor() public {
34         owner = address(0x072F140DcCCE18F9966Aeb6D71ffcD0b42748683);
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) public onlyOwner {
43         require(newOwner != address(0));
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46     }
47 
48 }
49 
50 contract ERC20 {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public;
54     function allowance(address owner, address spender) public view returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57 
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 contract PO8BaseToken is ERC20 {
63     using SafeMath for uint256;
64     
65     string public name;
66     string public symbol;
67     uint8 public decimals;
68     uint256 totalSupply_;
69 
70     mapping(address => uint256) balances;
71     mapping (address => mapping (address => uint256)) internal allowed;
72 
73     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
74         name = _name;
75         symbol = _symbol;
76         decimals = _decimals;
77         totalSupply_ = _totalSupply;
78     }
79 
80     function totalSupply() public view returns (uint256) {
81         return totalSupply_;
82     }
83 
84     function balanceOf(address _owner) public view returns (uint256) {
85         return balances[_owner];
86     }
87 
88     function _transfer(address _from, address _to, uint256 _value) internal {
89         require(_to != address(0));
90         require(balances[_from] >= _value);
91         require(balances[_to].add(_value) > balances[_to]);
92 
93 
94         uint256 previousBalances = balances[_from].add(balances[_to]);
95         balances[_from] = balances[_from].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         emit Transfer(_from, _to, _value);
98 
99         assert(balances[_from].add(balances[_to]) == previousBalances);
100     }
101 
102     function transfer(address _to, uint256 _value) public {
103         _transfer(msg.sender, _to, _value);
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107         require(_value <= allowed[_from][msg.sender]);     // Check allowance
108         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function approve(address _spender, uint256 _value) public returns (bool) {
114         allowed[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) public view returns (uint256) {
120         return allowed[_owner][_spender];
121     }
122 
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
132         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
133         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134         return true;
135     }
136 
137     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
138         uint oldValue = allowed[msg.sender][_spender];
139         if (_subtractedValue > oldValue) {
140             allowed[msg.sender][_spender] = 0;
141         } else {
142             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143         }
144         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }
147 
148 }
149 
150 contract PO8Token is PO8BaseToken("PO8 Token", "PO8", 18, 10000000000000000000000000000), Ownable {
151 
152     uint256 internal privateToken;
153     uint256 internal preSaleToken;
154     uint256 internal crowdSaleToken;
155     uint256 internal bountyToken;
156     uint256 internal foundationToken;
157     address public founderAddress;
158     bool public unlockAllTokens;
159 
160     mapping (address => bool) public approvedAccount;
161 
162     event UnFrozenFunds(address target, bool unfrozen);
163     event UnLockAllTokens(bool unlock);
164 
165     constructor() public {
166         founderAddress = address(0x072F140DcCCE18F9966Aeb6D71ffcD0b42748683);
167         balances[founderAddress] = totalSupply_;
168         emit Transfer(address(0), founderAddress, totalSupply_);
169     }
170 
171     function _transfer(address _from, address _to, uint _value) internal {
172         require (_to != address(0));                               
173         require (balances[_from] >= _value);               
174         require (balances[_to].add(_value) >= balances[_to]); 
175         require(approvedAccount[_from] || unlockAllTokens);
176 
177         balances[_from] = balances[_from].sub(_value);                  
178         balances[_to] = balances[_to].add(_value);                  
179         emit Transfer(_from, _to, _value);
180     }
181 
182     function unlockAllTokens(bool _unlock) public onlyOwner {
183         unlockAllTokens = _unlock;
184         emit UnLockAllTokens(_unlock);
185     }
186 
187     function approvedAccount(address target, bool approval) public onlyOwner {
188         approvedAccount[target] = approval;
189         emit UnFrozenFunds(target, approval);
190     }
191 }
192 
193 contract PO8InDependenceDaySale is Ownable{
194     using SafeMath for uint256;
195 
196     PO8Token public token;
197     address public wallet;
198     uint256 public currentRate;
199 
200     event ChangeRate(address indexed who, uint256 newrate);
201     event FinishPreSale();
202 
203     constructor() public {
204         currentRate = 48000;
205         wallet = address(0x072F140DcCCE18F9966Aeb6D71ffcD0b42748683); //address of founder
206         token = PO8Token(0x8744a672D5a2df51Da92B4BAb608CE7ff4Ddd804);// address of PO8 Token
207     }
208 
209     function changeRate(uint256 newrate) public onlyOwner{
210         require(newrate > 0);
211         currentRate = newrate;
212 
213         emit ChangeRate(msg.sender, newrate);
214     }
215 
216     function remainTokens() view public returns(uint256) {
217         return token.balanceOf(this);
218     }
219 
220     function finish() public onlyOwner {
221         uint256 reTokens = remainTokens();
222         token.transfer(owner, reTokens);
223         
224         emit FinishPreSale();
225     }
226 
227     function () public payable {
228         assert(msg.value >= 0.1 ether);
229         
230         uint256 tokens = currentRate.mul(msg.value);
231         token.transfer(msg.sender, tokens);        
232         wallet.transfer(msg.value);       
233     }  
234 }