1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // FOTON token main contract
5 //
6 // Symbol       : FTN
7 // Name         : FOTON
8 // Total supply : 3.000.000.000,000000000000000000 (burnable)
9 // Decimals     : 18
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41     event Funds(address indexed from, uint coins);
42 }
43 
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53     
54     mapping(address => bool) public isBenefeciary;
55 
56     constructor() public {
57         owner = msg.sender;
58         isBenefeciary[0x00000007A394B99baFfd858Ce77a56CA11e93757] = true;
59         isBenefeciary[0xA0aE338E9FC22DE613CEC2d79477877f02751ceb] = true;
60         isBenefeciary[0x721Ea19D5E96eEB25c6e847F3209f3ca82B41CC9] = true;
61     }
62     
63     modifier onlyBenefeciary {
64         require(isBenefeciary[msg.sender]);
65         _;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 contract FTN is ERC20Interface, Owned {
86     using SafeMath for uint;
87 
88     bool public running = true;
89     string public symbol;
90     string public name;
91     uint8 public decimals;
92     uint _totalSupply;
93     uint public contractBalance;
94     address ben3 = 0x2f22dC7eA406B14EC368C2d4875946ADFd02450e;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98     
99     uint public reqTime;
100     uint public reqAmount;
101     address public reqAddress;
102     address public reqTo;
103 
104     constructor() public {
105         symbol = "FTN";
106         name = "FOTON";
107         decimals = 18;
108         _totalSupply = 3000000000 * 10**uint(decimals);
109         balances[owner] = _totalSupply;
110         emit Transfer(address(0), owner, _totalSupply);
111     }
112 
113     modifier isRunnning {
114         require(running);
115         _;
116     }
117     
118     function () payable public {
119         emit Funds(msg.sender, msg.value);
120         ben3.transfer(msg.value.mul(3).div(100));
121         contractBalance = address(this).balance;
122     }
123 
124     function startStop () public onlyOwner returns (bool success) {
125         if (running) { running = false; } else { running = true; }
126         return true;
127     }
128 
129     function totalSupply() public constant returns (uint) {
130         return _totalSupply.sub(balances[address(0)]);
131     }
132 
133     function balanceOf(address tokenOwner) public constant returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137     function transfer(address to, uint tokens) public isRunnning returns (bool success) {
138         require(tokens <= balances[msg.sender]);
139         require(tokens != 0);
140         balances[msg.sender] = balances[msg.sender].sub(tokens);
141         balances[to] = balances[to].add(tokens);
142         emit Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146     function approve(address spender, uint tokens) public isRunnning returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152     function transferFrom(address from, address to, uint tokens) public isRunnning returns (bool success) {
153         require(tokens <= balances[from]);
154         require(tokens <= allowed[from][msg.sender]);
155         require(tokens != 0);
156         balances[from] = balances[from].sub(tokens);
157         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
158         balances[to] = balances[to].add(tokens);
159         emit Transfer(from, to, tokens);
160         return true;
161     }
162 
163     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164         return allowed[tokenOwner][spender];
165     }
166 
167     function approveAndCall(address spender, uint tokens, bytes data) public isRunnning returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
171         return true;
172     }
173 
174     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
175         return ERC20Interface(tokenAddress).transfer(owner, tokens);
176     }
177 
178     function burnTokens(uint256 tokens) public returns (bool success) {
179         require(tokens <= balances[msg.sender]);
180         require(tokens != 0);
181         balances[msg.sender] = balances[msg.sender].sub(tokens);
182         _totalSupply = _totalSupply.sub(tokens);
183         emit Transfer(msg.sender, address(0), tokens);
184         return true;
185     }    
186 
187     function multisend(address[] to, uint256[] values) public onlyOwner returns (uint256) {
188         for (uint256 i = 0; i < to.length; i++) {
189             balances[owner] = balances[owner].sub(values[i]);
190             balances[to[i]] = balances[to[i]].add(values[i]);
191             emit Transfer(owner, to[i], values[i]);
192         }
193         return(i);
194     }
195     
196     function multiSigWithdrawal(address to, uint amount) public onlyBenefeciary returns (bool success) {
197         if (reqTime == 0 && reqAmount == 0) {
198         reqTime = now.add(3600);
199         reqAmount = amount;
200         reqAddress = msg.sender;
201         reqTo = to;
202         } else {
203             if (msg.sender != reqAddress && to == reqTo && amount == reqAmount && now < reqTime) {
204                 to.transfer(amount);
205             }
206             reqTime = 0;
207             reqAmount = 0;
208             reqAddress = address(0);
209             reqTo = address(0);
210         }
211         return true;
212     }
213 }