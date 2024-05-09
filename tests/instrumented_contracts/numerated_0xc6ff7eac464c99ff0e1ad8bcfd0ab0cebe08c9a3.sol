1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract Owned {
25     
26     address public owner;
27 
28     event OwnershipTransferred(address indexed _from, address indexed _to);
29 
30     constructor() public {
31         owner = 0x5411BdDf493Cc8ad4aD01da02E5e30e742076610;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     // transfer Ownership to other address
40     function transferOwnership(address _newOwner) public onlyOwner {
41         require(_newOwner != address(0x0));
42         emit OwnershipTransferred(owner,_newOwner);
43         owner = _newOwner;
44     }
45     
46 }
47 
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 contract YFCMutualfund  is ERC20Interface, Owned {
61     
62     using SafeMath for uint;
63 
64     string public symbol;
65     string public  name;
66     uint8 public decimals;
67     uint public _totalSupply;
68     uint public RATE;
69     uint public DENOMINATOR;
70     bool public isStopped = false;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74     
75     event Mint(address indexed to, uint256 amount);
76     event ChangeRate(uint256 amount);
77     
78     modifier onlyWhenRunning {
79         require(!isStopped);
80         _;
81     }
82 
83 
84     
85     constructor() public {
86         symbol = "YFC";
87         name = "YFC.Mutualfund";
88         decimals = 18;
89         _totalSupply = 20000 * 10**uint(decimals);
90         balances[owner] = _totalSupply;
91          RATE = 10000; 
92         DENOMINATOR = 10000;
93         emit Transfer(address(0), owner, _totalSupply);
94     }
95     
96     
97     
98     function() public payable {
99         
100         buyTokens();
101     }
102     
103     
104     
105     function buyTokens() onlyWhenRunning public payable {
106         require(msg.value > 0);
107         
108         uint tokens = msg.value.mul(RATE).div(DENOMINATOR);
109         require(balances[owner] >= tokens);
110         
111         balances[msg.sender] = balances[msg.sender].add(tokens);
112         balances[owner] = balances[owner].sub(tokens);
113         
114         emit Transfer(owner, msg.sender, tokens);
115         
116         owner.transfer(msg.value);
117     }
118     
119     
120     
121     function totalSupply() public view returns (uint) {
122         return _totalSupply;
123     }
124 
125 
126    
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132    
133     function transfer(address to, uint tokens) public returns (bool success) {
134         require(to != address(0));
135         require(tokens > 0);
136         require(balances[msg.sender] >= tokens);
137         
138         balances[msg.sender] = balances[msg.sender].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     
146     function approve(address spender, uint tokens) public returns (bool success) {
147         require(spender != address(0));
148         require(tokens > 0);
149         
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155 
156     
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         require(from != address(0));
159         require(to != address(0));
160         require(tokens > 0);
161         require(balances[from] >= tokens);
162         require(allowed[from][msg.sender] >= tokens);
163         
164         balances[from] = balances[from].sub(tokens);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166         balances[to] = balances[to].add(tokens);
167         emit Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172    
173     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176     
177     
178     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
179         require(_spender != address(0));
180         
181         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185     
186     
187     
188     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
189         require(_spender != address(0));
190         
191         uint oldValue = allowed[msg.sender][_spender];
192         if (_subtractedValue > oldValue) {
193             allowed[msg.sender][_spender] = 0;
194         } else {
195             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196         }
197         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200     
201    
202     function changeRate(uint256 _rate) public onlyOwner {
203         require(_rate > 0);
204         
205         RATE =_rate;
206         emit ChangeRate(_rate);
207     }
208     
209 }