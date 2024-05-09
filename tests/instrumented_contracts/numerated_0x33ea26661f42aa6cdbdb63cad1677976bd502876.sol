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
32 
33 contract Ownable {
34     address public owner;
35     address public newOwner;
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor() public {
39     owner = msg.sender;
40     newOwner = address(0);
41     }
42 
43     modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46     }
47 
48     modifier onlyNewOwner() {
49     require(msg.sender != address(0));
50     require(msg.sender == newOwner);
51     _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55     require(_newOwner != address(0));
56     newOwner = _newOwner;
57     }
58     
59     function acceptOwnership() public onlyNewOwner returns(bool) {
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62     }
63 }
64 
65 
66 contract Pausable is Ownable {
67     event Pause();
68     event Unpause();
69     bool public paused = false;
70     
71     modifier whenNotPaused() {
72     require(!paused);
73     _;
74     }
75     modifier whenPaused() {
76     require(paused);
77     _;
78     }
79 
80     
81     function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     emit Pause();
84     }
85     
86     
87     function unpause() onlyOwner whenPaused public {
88     paused = false;
89     emit Unpause();
90     }
91 
92 }
93 
94  
95 
96 contract ERC20 {
97     function totalSupply() public view returns (uint256);
98     function balanceOf(address who) public view returns (uint256);
99     function allowance(address owner, address spender) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     function transferFrom(address from, address to, uint256 value) public returns (bool);
102     function approve(address spender, uint256 value) public returns (bool);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107  
108 
109 interface TokenRecipient {
110  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
111 }
112 
113  
114 
115 contract DeeptonCoin is ERC20, Ownable, Pausable {
116     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
117     using SafeMath for uint256;
118     
119     
120     struct LockupInfo {
121     uint256 releaseTime;
122     uint256 termOfRound;
123     uint256 unlockAmountPerRound;
124     uint256 lockupBalance;
125     }
126     
127     string public name;
128     string public symbol;
129     uint8 public decimals;
130     uint256 internal initialSupply;
131     uint256 internal totalSupply_;
132     
133     mapping(address => uint256) internal balances;
134     mapping(address => bool) public frozen;
135     mapping(address => mapping(address => uint256)) internal allowed;
136     event Burn(address indexed owner, uint256 value);
137     event Mint(uint256 value);
138     event Freeze(address indexed holder);
139     event Unfreeze(address indexed holder);
140     
141     modifier notFrozen(address _holder) {
142     require(!frozen[_holder]);
143     _;
144     }
145 
146     constructor() public {
147     name = "DeeptonCoin";
148     symbol = "DTC";
149     decimals = 6;
150     initialSupply = 10000000000;
151     totalSupply_ = initialSupply * 10 ** uint(decimals);
152     balances[owner] = totalSupply_;
153     emit Transfer(address(0), owner, totalSupply_);
154     }
155 
156     function () public payable {
157     revert();
158     }
159 
160     function totalSupply() public view returns (uint256) {
161     return totalSupply_;
162     }
163 
164     function _transfer(address _from, address _to, uint _value) internal {
165        
166         require(_to != address(0));
167         require(_value <= balances[_from]);
168         require(_value <= allowed[_from][msg.sender]);
169     
170        balances[_from] = balances[_from].sub(_value);
171        balances[_to] = balances[_to].add(_value);
172       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173       emit Transfer(_from, _to, _value);
174     }
175     
176     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[msg.sender]);
179     
180     // SafeMath.sub will throw if there is not enough balance.
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     emit Transfer(msg.sender, _to, _value);
184     return true;
185     }
186 
187 
188     function balanceOf(address _holder) public view returns (uint256 balance) {
189     return balances[_holder];
190     }
191     
192      
193     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
194 
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     _transfer(_from, _to, _value);
200     
201     return true;
202     }
203     
204     
205 
206     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210     }
211 
212 
213  
214     function allowance(address _holder, address _spender) public view returns (uint256) {
215     return allowed[_holder][_spender];
216     }
217 
218  
219  
220     function freezeAccount(address _holder) public onlyOwner returns (bool) {
221     require(!frozen[_holder]);
222     frozen[_holder] = true;
223     emit Freeze(_holder);
224     return true;
225     }
226 
227  
228 
229     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
230     require(frozen[_holder]);
231     frozen[_holder] = false;
232     emit Unfreeze(_holder);
233     return true;
234     }
235 
236  
237    function burn(uint256 _value) public onlyOwner returns (bool success) {
238     require(_value <= balances[msg.sender]);
239     address burner = msg.sender;
240     balances[burner] = balances[burner].sub(_value);
241     totalSupply_ = totalSupply_.sub(_value);
242     emit Burn(burner, _value);
243     return true;
244     }
245 
246  
247     function mint( uint256 _amount) onlyOwner public returns (bool) {
248     totalSupply_ = totalSupply_.add(_amount);
249     balances[owner] = balances[owner].add(_amount);
250     
251     emit Transfer(address(0), owner, _amount);
252     return true;
253     }
254 
255     
256 }