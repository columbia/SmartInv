1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6     if (_a == 0) {
7     return 0;
8     }
9     uint256 c = _a * _b;
10     assert(c / _a == _b);
11     return c;
12     }
13 
14     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     uint256 c = _a / _b;
16     return c;
17     }
18     
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     assert(_b <= _a);
21     return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     uint256 c = _a + _b;
26     assert(c >= _a);
27     return c;
28     }
29 }
30 
31 
32 contract Ownable {
33     address public owner;
34     address public newOwner;
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() public {
38     owner = msg.sender;
39     newOwner = address(0);
40     }
41 
42     modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45     }
46 
47     modifier onlyNewOwner() {
48     require(msg.sender != address(0));
49     require(msg.sender == newOwner);
50     _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54     require(_newOwner != address(0));
55     newOwner = _newOwner;
56     }
57     
58     function acceptOwnership() public onlyNewOwner returns(bool) {
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61     }
62 }
63 
64 contract ERC20 {
65     function totalSupply() public view returns (uint256);
66     function balanceOf(address who) public view returns (uint256);
67     function allowance(address owner, address spender) public view returns (uint256);
68     function transfer(address to, uint256 value) public returns (bool);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75  
76 
77 interface TokenRecipient {
78  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
79 }
80 
81  
82 
83 contract GoGoCoin is ERC20, Ownable {
84     using SafeMath for uint256;
85     
86     struct LockupInfo {
87     uint256 releaseTime;
88     uint256 termOfRound;
89     uint256 unlockAmountPerRound;
90     uint256 lockupBalance;
91     }
92     
93     string public name;
94     string public symbol;
95     uint8 public decimals;
96     uint256 internal initialSupply;
97     uint256 internal totalSupply_;
98     
99     mapping(address => uint256) internal balances;
100     mapping(address => bool) internal locks;
101     mapping(address => bool) public frozen;
102     mapping(address => mapping(address => uint256)) internal allowed;
103     mapping(address => LockupInfo) internal lockupInfo;
104     
105     event Unlock(address indexed holder, uint256 value);
106     event Lock(address indexed holder, uint256 value);
107     event Burn(address indexed owner, uint256 value);
108     event Mint(uint256 value);
109     event Freeze(address indexed holder);
110     event Unfreeze(address indexed holder);
111     
112     modifier notFrozen(address _holder) {
113     require(!frozen[_holder]);
114     _;
115     }
116 
117     constructor() public {
118     name = "GoGoCoin";
119     symbol = "GGC";
120     decimals = 0;
121     initialSupply = 10000000000;
122     totalSupply_ = 10000000000;
123     balances[owner] = totalSupply_;
124     emit Transfer(address(0), owner, totalSupply_);
125     }
126 
127     function () public payable {
128     revert();
129     }
130 
131     function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133     }
134 
135     function _transfer(address _from, address _to, uint _value) internal {
136        
137         require(_to != address(0));
138         require(_value <= balances[_from]);
139         require(_value <= allowed[_from][msg.sender]);
140     
141        balances[_from] = balances[_from].sub(_value);
142        balances[_to] = balances[_to].add(_value);
143       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144       emit Transfer(_from, _to, _value);
145     }
146     
147     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
148     
149     if (locks[msg.sender]) {
150     }
151     
152     require(_to != address(0));
153     require(_value <= balances[msg.sender]);
154     
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     emit Transfer(msg.sender, _to, _value);
158     return true;
159     }
160 
161     function balanceOf(address _holder) public view returns (uint256 balance) {
162     return balances[_holder] + lockupInfo[_holder].lockupBalance;
163     }
164     
165     function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {
166         if(locks[_from]){
167         }
168         require(_to != address(0));
169         require(_value + _fee <= balances[_from]);
170         balances[msg.sender] = balances[msg.sender].add(_fee);
171         balances[_from] = balances[_from].sub(_value + _fee);
172         balances[_to] = balances[_to].add(_value);
173         emit Transfer(_from, _to, _value);
174         emit Transfer(_from, msg.sender, _value);
175         
176         return true;
177     }
178      
179     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
180 
181         if (locks[_from]) {
182         }
183     
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     _transfer(_from, _to, _value);
189     
190     return true;
191     }
192     
193     
194 
195     function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199     }
200 
201     function allowance(address _holder, address _spender) public view returns (uint256) {
202     return allowed[_holder][_spender];
203     }
204 
205     function freezeAccount(address _holder) public onlyOwner returns (bool) {
206     require(!frozen[_holder]);
207     frozen[_holder] = true;
208     emit Freeze(_holder);
209     return true;
210     }
211 
212     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
213     require(frozen[_holder]);
214     frozen[_holder] = false;
215     emit Unfreeze(_holder);
216     return true;
217     }
218     
219    function burn(uint256 _value) public onlyOwner returns (bool success) {
220     require(_value <= balances[msg.sender]);
221     address burner = msg.sender;
222     balances[burner] = balances[burner].sub(_value);
223     totalSupply_ = totalSupply_.sub(_value);
224     emit Burn(burner, _value);
225     return true;
226     }
227 
228     function mint( uint256 _amount) onlyOwner public returns (bool) {
229     totalSupply_ = totalSupply_.add(_amount);
230     balances[owner] = balances[owner].add(_amount);
231     
232     emit Transfer(address(0), owner, _amount);
233     return true;
234     }
235 
236     function isContract(address addr) internal view returns (bool) {
237     uint size;
238     assembly{size := extcodesize(addr)}
239     return size > 0;
240     }
241 }