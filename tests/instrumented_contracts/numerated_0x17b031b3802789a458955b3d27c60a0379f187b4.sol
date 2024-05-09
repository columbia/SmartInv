1 pragma solidity ^0.4.0;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) external returns (bool);
5     function approve(address _spender, uint _value) external returns (bool);
6     function allowance(address _owner, address _spender) external pure returns (uint);
7     event Approval(address indexed _owner, address indexed _spender, uint _value);
8 }
9 
10 interface ERC223 {
11     function transfer(address _to, uint _value, bytes _data) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
13 }
14 
15 contract ERC223ReceivingContract {
16     function tokenFallback(address _from, uint _value, bytes _data) public;
17 }
18 
19 contract BitbeginToken {
20     string internal _symbol;
21     string internal _name;
22     uint8 internal _decimals;
23     uint internal _totalSupply = 20000000000000000;
24     mapping (address => uint) _balanceOf;
25     mapping (address => mapping (address => uint)) internal _allowances;
26 
27     constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {
28         _symbol = symbol;
29         _name = name;
30         _decimals = decimals;
31         _totalSupply = totalSupply;
32     }
33 
34     function name() public constant returns (string) {
35         return _name;
36     }
37 
38     function symbol() public constant returns (string) {
39         return _symbol;
40     }
41 
42     function decimals() public constant returns (uint8) {
43         return _decimals;
44     }
45 
46     function totalSupply() public constant returns (uint) {
47         return _totalSupply;
48     }
49 
50     function balanceOf(address _addr) public constant returns (uint);
51     function transfer(address _to, uint _value) public returns (bool);
52     event Transfer(address indexed _from, address indexed _to, uint _value);
53 }
54 
55 library SafeMath {
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 
82 contract Bitbegin is BitbeginToken("BIB", "Bitbegin Coin", 8, 20000000000000000), ERC20, ERC223 {
83     address private _owner;
84     struct LockAccount{
85         uint status;
86     }
87     
88     struct Reward{
89         uint amount;
90     }
91     
92     mapping (address => LockAccount) lockAccounts;
93     address[] public AllLockAccounts;
94     
95     mapping (address => Reward) rewards;
96     address[] public rewardsAccounts;
97     
98     using SafeMath for uint;
99     
100  
101     
102     function Bitbegin() public {
103         _balanceOf[msg.sender] = _totalSupply;
104         _owner = msg.sender;
105     }
106    
107     
108        function setLockAccount(address _addr) public{
109         require(msg.sender == _owner);
110         var lock_account = lockAccounts[_addr];
111         lock_account.status = 1;
112         AllLockAccounts.push(_addr) -1;
113     }
114     
115         function setReward(address _addr, uint _amount) public{
116         require(msg.sender == _owner);
117         var reward = rewards[_addr];
118         reward.amount +=  _amount;
119         rewardsAccounts.push(_addr) -1;
120     }
121 
122     function claimReward(address _addr) public returns (bool){
123         address addressTo = _addr;
124         uint amount = rewards[_addr].amount;
125        
126      
127           if (amount > 0 &&
128             amount <= _balanceOf[_owner] &&
129             !isContract(addressTo)) {
130             _balanceOf[_owner] = _balanceOf[_owner].sub(amount);
131             _balanceOf[addressTo] = _balanceOf[addressTo].add(amount);
132             emit Transfer(msg.sender, addressTo, amount);
133             return true;
134         }
135           rewards[_addr].amount = 0;
136         
137     }
138     
139     function getLockAccounts() view public returns (address[]){
140         return AllLockAccounts;
141     }
142     
143      function getLockAccount(address _addr) view public returns (uint){
144         return lockAccounts[_addr].status;
145     }
146     
147     function getReward(address _addr) view public returns (uint){
148         return rewards[_addr].amount;
149     }
150 
151     function totalSupply() public constant returns (uint) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address _addr) public constant returns (uint) {
156         return _balanceOf[_addr];
157     }
158 
159     function transfer(address _to, uint _value) public returns (bool) {
160         if (_value > 0 &&
161             _value <= _balanceOf[msg.sender] &&
162             !isContract(_to) && !isLock(msg.sender)) {
163             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
164             _balanceOf[_to] = _balanceOf[_to].add(_value);
165             emit Transfer(msg.sender, _to, _value);
166             return true;
167         }
168         return false;
169     }
170     
171     
172 
173     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
174         if (_value > 0 &&
175             _value <= _balanceOf[msg.sender] &&
176             isContract(_to) && !isLock(msg.sender)) {
177             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
178             _balanceOf[_to] = _balanceOf[_to].add(_value);
179             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
180             _contract.tokenFallback(msg.sender, _value, _data);
181             emit Transfer(msg.sender, _to, _value, _data);
182             return true;
183         }
184         return false;
185     }
186     
187     function unLockAccount(address _addr) public {
188         require(msg.sender == _owner);
189        lockAccounts[_addr].status = 0;
190        
191     }
192     function isLock (address _addr) private constant returns(bool){
193         uint lS = lockAccounts[_addr].status;
194         
195         if(lS == 1){
196             return true;
197         }
198         
199         return false;
200     }
201 
202     function isContract(address _addr) private constant returns (bool) {
203         uint codeSize;
204         assembly {
205             codeSize := extcodesize(_addr)
206         }
207         return codeSize > 0;
208     }
209 
210     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
211         if (_allowances[_from][msg.sender] > 0 &&
212             _value > 0 &&
213             _allowances[_from][msg.sender] >= _value &&
214             _balanceOf[_from] >= _value) {
215             _balanceOf[_from] = _balanceOf[_from].sub(_value);
216             _balanceOf[_to] = _balanceOf[_to].add(_value);
217             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
218             emit Transfer(_from, _to, _value);
219             return true;
220         }
221         return false;
222     }
223     
224 
225    
226     function approve(address _spender, uint _value) public returns (bool) {
227         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231 
232     function allowance(address _owner, address _spender) public constant returns (uint) {
233         return _allowances[_owner][_spender];
234     }
235 }