1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
5     if (_a == 0) {
6     return 0;
7     }
8     uint256 c = _a * _b;
9     assert(c / _a == _b);
10     return c;
11     }
12 
13     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     uint256 c = _a / _b;
15     return c;
16     }
17     
18     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
19     assert(_b <= _a);
20     return _a - _b;
21     }
22     
23     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
24     uint256 c = _a + _b;
25     assert(c >= _a);
26     return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32     address public newOwner;
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor() public {
36     owner = msg.sender;
37     newOwner = address(0);
38     }
39 
40     modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43     }
44 
45     modifier onlyNewOwner() {
46     require(msg.sender != address(0));
47     require(msg.sender == newOwner);
48     _;
49     }
50 
51     function transferOwnership(address _newOwner) public onlyOwner {
52     require(_newOwner != address(0));
53     newOwner = _newOwner;
54     }
55     
56     function acceptOwnership() public onlyNewOwner returns(bool) {
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59     }
60 }
61 
62 contract Pausable is Ownable {
63     event Pause();
64     event Unpause();
65     bool public paused = false;
66     
67     modifier whenNotPaused() {
68     require(!paused);
69     _;
70     }
71     modifier whenPaused() {
72     require(paused);
73     _;
74     }
75 
76     function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     emit Pause();
79     }
80     
81     function unpause() onlyOwner whenPaused public {
82     paused = false;
83     emit Unpause();
84     }
85 }
86 
87 contract ERC20 {
88     function totalSupply() public view returns (uint256);
89     function balanceOf(address who) public view returns (uint256);
90     function allowance(address owner, address spender) public view returns (uint256);
91     function transfer(address to, uint256 value) public returns (bool);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 interface TokenRecipient {
99  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
100 }
101 
102 contract YoloCoin is ERC20, Ownable, Pausable {
103     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
104     using SafeMath for uint256;
105     
106     struct LockupInfo {
107     uint256 releaseTime;
108     uint256 termOfRound;
109     uint256 unlockAmountPerRound;
110     uint256 lockupBalance;
111     }
112     
113     string public name;
114     string public symbol;
115     uint8 public decimals;
116     uint256 internal initialSupply;
117     uint256 internal totalSupply_;
118     
119     mapping(address => uint256) internal balances;
120     mapping(address => bool) public frozen;
121     mapping(address => mapping(address => uint256)) internal allowed;
122     event Burn(address indexed owner, uint256 value);
123     event Mint(uint256 value);
124     event Freeze(address indexed holder);
125     event Unfreeze(address indexed holder);
126     
127     modifier notFrozen(address _holder) {
128     require(!frozen[_holder]);
129     _;
130     }
131 
132     constructor() public {
133     name = "YoloCoin";
134     symbol = "YLC";
135     decimals = 0;
136     initialSupply = 10000000000;
137     totalSupply_ = 10000000000;
138     balances[owner] = totalSupply_;
139     emit Transfer(address(0), owner, totalSupply_);
140     }
141 
142     function () public payable {
143     revert();
144     }
145 
146     function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148     }
149 
150     function _transfer(address _from, address _to, uint _value) internal {
151        
152         require(_to != address(0));
153         require(_value <= balances[_from]);
154         require(_value <= allowed[_from][msg.sender]);
155     
156        balances[_from] = balances[_from].sub(_value);
157        balances[_to] = balances[_to].add(_value);
158       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159       emit Transfer(_from, _to, _value);
160     }
161     
162     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[msg.sender]);
165     
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     emit Transfer(msg.sender, _to, _value);
169     return true;
170     }
171 
172     function balanceOf(address _holder) public view returns (uint256 balance) {
173     return balances[_holder];
174     }
175     
176     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
177 
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     _transfer(_from, _to, _value);
183     
184     return true;
185     }
186     
187     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191     }
192 
193     function allowance(address _holder, address _spender) public view returns (uint256) {
194     return allowed[_holder][_spender];
195     }
196 
197     function freezeAccount(address _holder) public onlyOwner returns (bool) {
198     require(!frozen[_holder]);
199     frozen[_holder] = true;
200     emit Freeze(_holder);
201     return true;
202     }
203 
204     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
205     require(frozen[_holder]);
206     frozen[_holder] = false;
207     emit Unfreeze(_holder);
208     return true;
209     }
210 
211    function burn(uint256 _value) public onlyOwner returns (bool success) {
212     require(_value <= balances[msg.sender]);
213     address burner = msg.sender;
214     balances[burner] = balances[burner].sub(_value);
215     totalSupply_ = totalSupply_.sub(_value);
216     emit Burn(burner, _value);
217     return true;
218     }
219     
220     function mint( uint256 _amount) onlyOwner public returns (bool) {
221     totalSupply_ = totalSupply_.add(_amount);
222     balances[owner] = balances[owner].add(_amount);
223     
224     emit Transfer(address(0), owner, _amount);
225     return true;
226     }    
227 }