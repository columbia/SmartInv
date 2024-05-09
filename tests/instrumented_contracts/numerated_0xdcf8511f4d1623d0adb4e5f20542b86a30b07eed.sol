1 pragma solidity ^0.4.22;
2 //Optimize X ,  version:0.4.25+commit.59dbf8f1.Emscripten.clang
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
64         newOwner = 0x0;
65     }
66 }
67 
68 contract Pausable is Ownable {
69     event Pause();
70     event Unpause();
71 
72     bool public paused = false;
73 
74     modifier whenNotPaused() {
75         require(!paused);
76         _;
77     }
78 
79     modifier whenPaused() {
80         require(paused);
81         _;
82     }
83 
84     function pause() onlyOwner whenNotPaused public {
85         paused = true;
86         emit Pause();
87     }
88 
89     function unpause() onlyOwner whenPaused public {
90         paused = false;
91         emit Unpause();
92     }
93 }
94 
95 contract ERC20 {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function allowance(address owner, address spender) public view returns (uint256);
99     function transfer(address to, uint256 value) public returns (bool);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function approve(address spender, uint256 value) public returns (bool);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 
108 interface TokenRecipient {
109     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
110 }
111 
112 
113 contract RIC is ERC20, Ownable, Pausable {
114 
115     using SafeMath for uint256;
116 
117     string public name;
118     string public symbol;
119     uint8 constant public decimals =18;
120     uint256 internal initialSupply;
121     uint256 internal totalSupply_;
122 
123     mapping(address => uint256) internal balances;
124     mapping(address => mapping(address => uint256)) internal allowed;
125 
126     event Burn(address indexed owner, uint256 value);
127 
128    
129     constructor() public {
130         name = "Resource Investment Coin";
131         symbol = "RIC";
132         initialSupply = 300000000;
133         totalSupply_ = initialSupply * 10 ** uint(decimals);
134         balances[owner] = totalSupply_;
135         emit Transfer(address(0), owner, totalSupply_);
136     }
137 
138     function totalSupply() public view returns (uint256) {
139         return totalSupply_;
140     }
141 
142     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
143 
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146         
147 
148         // SafeMath.sub will throw if there is not enough balance.
149         balances[msg.sender] = balances[msg.sender].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         emit Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     function balanceOf(address _holder) public view returns (uint256 balance) {
156   
157         return balances[_holder];
158     }
159 
160     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
161 
162         require(_to != address(0));
163         require(_value <= balances[_from]);
164         require(_value <= allowed[_from][msg.sender]);
165         
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179     
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
181         require(isContract(_spender));
182         TokenRecipient spender = TokenRecipient(_spender);
183         if (approve(_spender, _value)) {
184             spender.receiveApproval(msg.sender, _value, this, _extraData);
185             return true;
186         }
187     }
188 
189     function allowance(address _holder, address _spender) public view returns (uint256) {
190         return allowed[_holder][_spender];
191     }
192     
193     function burn(uint256 _value) public onlyOwner returns (bool success) {
194         require(_value <= balances[msg.sender]);
195         address burner = msg.sender;
196         balances[burner] = balances[burner].sub(_value);
197         totalSupply_ = totalSupply_.sub(_value);
198         emit Burn(burner, _value);
199         emit Transfer(burner,address(0),_value);
200         return true;
201     }
202     
203     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[owner]);
206 
207         balances[owner] = balances[owner].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         emit Transfer(owner, _to, _value);
210         return true;
211     }
212 
213     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
214         token.transfer(_to, _value);
215         return true;
216     }
217 
218     function isContract(address addr) internal view returns (bool) {
219         uint size;
220         assembly{size := extcodesize(addr)}
221         return size > 0;
222     }
223 
224 }