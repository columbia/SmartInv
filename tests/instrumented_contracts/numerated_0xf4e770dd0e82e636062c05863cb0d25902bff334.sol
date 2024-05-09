1 pragma solidity ^ 0.4.24;
2 
3 library ECRecovery {
4   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
5     bytes32 r;
6     bytes32 s;
7     uint8 v;
8 
9     if (sig.length != 65) {
10       return (address(0));
11     }
12     
13     assembly {
14       r := mload(add(sig, 32))
15       s := mload(add(sig, 64))
16       v := byte(0, mload(add(sig, 96)))
17     }
18 
19     if (v < 27) {
20       v += 27;
21     }
22 
23     if (v != 27 && v != 28) {
24       return (address(0));
25     } else {
26       return ecrecover(hash, v, r, s);
27     }
28   }
29 }
30 
31 library SafeMath {
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function sub(uint a, uint b) internal pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     function mul(uint a, uint b) internal pure returns (uint c) {
41         c = a * b;
42         require(a == 0 || c / a == b);
43     }
44     function div(uint a, uint b) internal pure returns (uint c) {
45         require(b > 0);
46         c = a / b;
47     }
48 }
49 
50 
51 contract ERC20Interface {
52     function totalSupply() public constant returns (uint);
53     function balanceOf(address tokenOwner) public constant returns (uint balance);
54     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
55     function transfer(address to, uint tokens) public returns (bool success);
56     function approve(address spender, uint tokens) public returns (bool success);
57     function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint tokens, address token, bytes data) public;
66 }
67 
68 contract ERC20 is ERC20Interface {
69     using SafeMath for uint;
70 
71     uint _totalSupply = 0;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76 
77     function totalSupply() public view returns (uint) {
78         return _totalSupply.sub(balances[address(0)]);
79     }
80 
81 
82     function balanceOf(address tokenOwner) public view returns (uint balance) {
83         return balances[tokenOwner];
84     }
85 
86 
87     function transfer(address to, uint tokens) public returns (bool success) {
88         balances[msg.sender] = balances[msg.sender].sub(tokens);
89         balances[to] = balances[to].add(tokens);
90         emit Transfer(msg.sender, to, tokens);
91         return true;
92     }
93 
94     function approve(address spender, uint tokens) public returns (bool success) {
95         allowed[msg.sender][spender] = tokens;
96         emit Approval(msg.sender, spender, tokens);
97         return true;
98     }
99 
100     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
101         balances[from] = balances[from].sub(tokens);
102         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
103         balances[to] = balances[to].add(tokens);
104         emit Transfer(from, to, tokens);
105         return true;
106     }
107 
108     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
109         return allowed[tokenOwner][spender];
110     }
111 
112     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         emit Approval(msg.sender, spender, tokens);
115         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
116         return true;
117     }
118 
119     function () public payable {
120         revert();
121     }
122 }
123 
124 
125 contract ERC891 is ERC20 {
126     using ECRecovery for bytes32;
127 
128     uint public constant maxReward = 50 * 10**18;
129     mapping(address => bool) internal claimed;
130 
131     function claim() public {
132         claimFor(msg.sender);
133     }
134 
135     function claimFor(address _address) public returns(uint) {
136         require(!claimed[_address]);
137         
138         uint reward = checkFind(_address);
139         require(reward > 0);
140         
141         claimed[_address]   = true;
142         balances[_address]  = balances[_address].add(reward);
143         _totalSupply        = _totalSupply.add(reward);
144         
145         emit Transfer(address(0), _address, reward);
146         
147         return reward;
148     }
149 
150     function checkFind(address _address) pure public returns(uint) {
151         uint maxBitRun  = 0;
152         uint data       = uint(bytes10(_address) & 0x3ffff);
153         
154         while (data > 0) {
155             maxBitRun = maxBitRun + uint(data & 1);
156             data = uint(data & 1) == 1 ? data >> 1 : 0;
157         }
158         
159         return maxReward >> (18 - maxBitRun);
160     }
161 
162     function claimWithSignature(bytes _sig) public {
163         bytes32 hash = bytes32(keccak256(abi.encodePacked(
164             "\x19Ethereum Signed Message:\n32",
165             keccak256(abi.encodePacked(msg.sender))
166         )));
167         
168         address minedAddress = hash.recover(_sig);
169         uint reward          = claimFor(minedAddress);
170 
171         allowed[minedAddress][msg.sender] = reward;
172         transferFrom(minedAddress, msg.sender, reward);
173     }
174 }
175 
176 contract DigitalCarat is ERC891 {
177     string  public constant name        = "Digital Carat";
178     string  public constant symbol      = "DCD";
179     uint    public constant decimals    = 18;
180     uint    public version              = 0;
181 }