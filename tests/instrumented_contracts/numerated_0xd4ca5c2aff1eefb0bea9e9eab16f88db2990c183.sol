1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() public {
41         owner = msg.sender;
42         newOwner = address(0);
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     modifier onlyNewOwner() {
50         require(msg.sender != address(0));
51         require(msg.sender == newOwner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public onlyNewOwner returns(bool) {
61         emit OwnershipTransferred(owner, newOwner);        
62         owner = newOwner;
63         newOwner = 0x0;
64     }
65 }
66 
67 contract Pausable is Ownable {
68     event Pause();
69     event Unpause();
70 
71     bool public paused = false;
72 
73     modifier whenNotPaused() {
74         require(!paused);
75         _;
76     }
77 
78     modifier whenPaused() {
79         require(paused);
80         _;
81     }
82 
83     function pause() onlyOwner whenNotPaused public {
84         paused = true;
85         emit Pause();
86     }
87 
88     function unpause() onlyOwner whenPaused public {
89         paused = false;
90         emit Unpause();
91     }
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
112 contract XrpClassic is ERC20, Ownable, Pausable {
113 
114     using SafeMath for uint256;
115 
116     string public name;
117     string public symbol;
118     uint8 constant public decimals =8;
119     uint256 internal initialSupply;
120     uint256 internal totalSupply_;
121 
122     mapping(address => uint256) internal balances;
123     mapping(address => mapping(address => uint256)) internal allowed;
124 
125     constructor() public {
126         name = "XRP CLASSIC";
127         symbol = "XRPC";
128         initialSupply = 645354324324;
129         totalSupply_ = initialSupply * 10 ** uint(decimals);
130         balances[owner] = totalSupply_;
131         emit Transfer(address(0), owner, totalSupply_);
132     }
133 
134     function () public payable {
135         revert();
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
156         return balances[_holder];
157     }
158 
159     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
160 
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164         
165 
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         emit Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178     
179     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
180         require(isContract(_spender));
181         TokenRecipient spender = TokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, this, _extraData);
184             return true;
185         }
186     }
187 
188     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool)
189     {
190         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool)
196     {
197         uint256 oldValue = allowed[msg.sender][_spender];
198         if (_subtractedValue >= oldValue) {
199             allowed[msg.sender][_spender] = 0;
200         } else {
201             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202         }
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     function allowance(address _holder, address _spender) public view returns (uint256) {
208         return allowed[_holder][_spender];
209     }
210 
211     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
212         token.transfer(_to, _value);
213         return true;
214     }
215 
216     function isContract(address addr) internal view returns (bool) {
217         uint size;
218         assembly{size := extcodesize(addr)}
219         return size > 0;
220     }
221 
222 }