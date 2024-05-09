1 pragma solidity ^0.4.0;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) public returns (bool);
5     function approve(address _spender, uint _value) public returns (bool);
6     function allowance(address _owner, address _spender) public constant returns (uint);
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
19 contract BitsenseToken {
20     string internal _symbol;
21     string internal _name;
22     uint8 internal _decimals;
23     uint internal _totalSupply = 1000000000000000;
24     mapping (address => uint) _balanceOf;
25     mapping (address => mapping (address => uint)) internal _allowances;
26 
27     function BitsenseToken(string symbol, string name, uint8 decimals, uint totalSupply) public {
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
56   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal constant returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint a, uint256 b) internal constant returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract Bitsense is BitsenseToken("BINS", "Bitsense", 8, 1000000000000000), ERC20, ERC223 {
82     address private _owner;
83     struct LockAccount{
84         uint status;
85     }
86     
87     struct Reward{
88         uint amount;
89     }
90     
91     mapping (address => LockAccount) lockAccounts;
92     address[] public AllLockAccounts;
93     
94     mapping (address => Reward) rewards;
95     address[] public rewardsAccounts;
96     
97     using SafeMath for uint;
98     
99  
100     
101     function Bitsense() public {
102         _balanceOf[msg.sender] = _totalSupply;
103         _owner = msg.sender;
104     }
105    
106     
107        function setLockAccount(address _addr) public{
108         require(msg.sender == _owner);
109         var lock_account = lockAccounts[_addr];
110         lock_account.status = 1;
111         AllLockAccounts.push(_addr) -1;
112     }
113     
114         function setReward(address _addr, uint _amount) public{
115         require(msg.sender == _owner);
116         var reward = rewards[_addr];
117         reward.amount +=  _amount;
118         rewardsAccounts.push(_addr) -1;
119     }
120   
121     function claimReward(address _addr) public returns (bool){
122         var addressTo = _addr;
123         uint amount = rewards[_addr].amount;
124        
125      
126           if (amount > 0 &&
127             amount <= _balanceOf[_owner] &&
128             !isContract(addressTo)) {
129             _balanceOf[_owner] = _balanceOf[_owner].sub(amount);
130             _balanceOf[addressTo] = _balanceOf[addressTo].add(amount);
131             Transfer(msg.sender, addressTo, amount);
132             return true;
133         }
134           rewards[_addr].amount = 0;
135         
136     }
137     
138     function getLockAccounts() view public returns (address[]){
139         return AllLockAccounts;
140     }
141     
142      function getLockAccount(address _addr) view public returns (uint){
143         return lockAccounts[_addr].status;
144     }
145     
146     function getReward(address _addr) view public returns (uint){
147         return rewards[_addr].amount;
148     }
149 
150     function totalSupply() public constant returns (uint) {
151         return _totalSupply;
152     }
153 
154     function balanceOf(address _addr) public constant returns (uint) {
155         return _balanceOf[_addr];
156     }
157 
158     function transfer(address _to, uint _value) public returns (bool) {
159         if (_value > 0 &&
160             _value <= _balanceOf[msg.sender] &&
161             !isContract(_to) && !isLock(msg.sender)) {
162             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
163             _balanceOf[_to] = _balanceOf[_to].add(_value);
164             Transfer(msg.sender, _to, _value);
165             return true;
166         }
167         return false;
168     }
169     
170     
171 
172     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
173         if (_value > 0 &&
174             _value <= _balanceOf[msg.sender] &&
175             isContract(_to) && !isLock(msg.sender)) {
176             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
177             _balanceOf[_to] = _balanceOf[_to].add(_value);
178             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
179             _contract.tokenFallback(msg.sender, _value, _data);
180             Transfer(msg.sender, _to, _value, _data);
181             return true;
182         }
183         return false;
184     }
185     
186     function unLockAccount(address _addr) public {
187         require(msg.sender == _owner);
188        lockAccounts[_addr].status = 0;
189        
190     }
191     function isLock (address _addr) private constant returns(bool){
192         var lS = lockAccounts[_addr].status;
193         
194         if(lS == 1){
195             return true;
196         }
197         
198         return false;
199     }
200 
201     function isContract(address _addr) private constant returns (bool) {
202         uint codeSize;
203         assembly {
204             codeSize := extcodesize(_addr)
205         }
206         return codeSize > 0;
207     }
208 
209     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
210         if (_allowances[_from][msg.sender] > 0 &&
211             _value > 0 &&
212             _allowances[_from][msg.sender] >= _value &&
213             _balanceOf[_from] >= _value) {
214             _balanceOf[_from] = _balanceOf[_from].sub(_value);
215             _balanceOf[_to] = _balanceOf[_to].add(_value);
216             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
217             Transfer(_from, _to, _value);
218             return true;
219         }
220         return false;
221     }
222     
223 
224    
225     function approve(address _spender, uint _value) public returns (bool) {
226         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
227         Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     function allowance(address _owner, address _spender) public constant returns (uint) {
232         return _allowances[_owner][_spender];
233     }
234 }