1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;       
20     }       
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Ownable {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor() public {
42         owner = msg.sender;
43         newOwner = address(0);
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50     modifier onlyNewOwner() {
51         require(msg.sender != address(0));
52         require(msg.sender == newOwner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(_newOwner != address(0));
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public onlyNewOwner returns(bool) {
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 }
66 
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   modifier whenPaused() {
79     require(paused);
80     _;
81   }
82 
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   function unpause() onlyOwner whenPaused public {
89     paused = false;
90     emit Unpause();
91   }
92 }
93 
94 contract ERC20 {
95     function totalSupply() public view returns (uint256);
96     function balanceOf(address who) public view returns (uint256);
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 interface TokenRecipient {
108     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
109 }
110 
111 
112 contract TBIZToken is ERC20, Ownable, Pausable {
113     
114     using SafeMath for uint256;
115 
116     string public name;
117     string public symbol;
118     uint8 public decimals;
119     uint256 internal initialSupply;
120     uint256 internal totalSupply_;
121 
122     mapping(address => uint256) internal balances;
123     mapping(address => bool) public frozen;
124     mapping(address => mapping(address => uint256)) internal allowed;
125 
126     event Burn(address indexed owner, uint256 value);
127     event Mint(uint256 value);
128     event Freeze(address indexed holder);
129     event Unfreeze(address indexed holder);
130 
131     modifier notFrozen(address _holder) {
132         require(!frozen[_holder]);
133         _;
134     }
135 
136     constructor() public {
137         name = "TBIZ Token";
138         symbol = "TBIZ";
139         decimals = 18;
140         initialSupply = 2900008000;
141         totalSupply_ = initialSupply * 10 ** uint(decimals);
142         balances[owner] = totalSupply_;
143         emit Transfer(address(0), owner, totalSupply_);
144     }
145 
146     function () public payable {
147         revert();
148     }
149 
150     function totalSupply() public view returns (uint256) {
151         return totalSupply_;
152     }
153 
154     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
155         require(_to != address(0));
156         require(_value <= balances[msg.sender]);
157         
158         // SafeMath.sub will throw if there is not enough balance.
159         balances[msg.sender] = balances[msg.sender].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         emit Transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     function balanceOf(address _holder) public view returns (uint balance) {
166         return balances[_holder];
167     }
168     
169     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
170         require(_to != address(0));
171         require(_value <= balances[_from]);
172         require(_value <= allowed[_from][msg.sender]);
173         
174 
175         balances[_from] = balances[_from].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178         emit Transfer(_from, _to, _value);
179         return true;
180     }
181 
182     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
183         allowed[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187     
188     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
189         require(isContract(_spender));
190         TokenRecipient spender = TokenRecipient(_spender);
191         if (approve(_spender, _value)) {
192             spender.receiveApproval(msg.sender, _value, this, _extraData);
193             return true;
194         }
195     }
196 
197     function allowance(address _holder, address _spender) public view returns (uint256) {
198         return allowed[_holder][_spender];
199     }
200 
201     function freezeAccount(address _holder) public onlyOwner returns (bool) {
202         require(!frozen[_holder]);
203         frozen[_holder] = true;
204         emit Freeze(_holder);
205         return true;
206     }
207 
208     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
209         require(frozen[_holder]);
210         frozen[_holder] = false;
211         emit Unfreeze(_holder);
212         return true;
213     }
214 
215     function getNowTime() public view returns(uint256) {
216       return now;
217     }
218 
219     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
220         token.transfer(_to, _value);
221         return true;
222     }
223 
224     function burn(uint256 _value) public onlyOwner returns (bool success) {
225         require(_value <= balances[msg.sender]);
226         address burner = msg.sender;
227         balances[burner] = balances[burner].sub(_value);
228         totalSupply_ = totalSupply_.sub(_value);
229         emit Burn(burner, _value);
230         return true;
231     }
232 
233     function mint( uint256 _amount) onlyOwner public returns (bool) {
234         totalSupply_ = totalSupply_.add(_amount);
235         balances[owner] = balances[owner].add(_amount);
236 
237         emit Transfer(address(0), owner, _amount);
238         return true;
239     }
240 
241     function isContract(address addr) internal view returns (bool) {
242         uint size;
243         assembly{size := extcodesize(addr)}
244         return size > 0;
245     }
246 }