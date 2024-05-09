1 /***
2  *     $$$$$$\            $$\       $$\        $$$$$$\            $$\       $$\ 
3  *    $$  __$$\           $$ |      $$ |      $$  __$$\           $$ |      $$ |
4  *    $$ /  \__| $$$$$$\  $$$$$$$\  $$$$$$$\  $$ /  \__| $$$$$$\  $$ | $$$$$$$ |
5  *    $$ |      $$  __$$\ $$  __$$\ $$  __$$\ $$ |$$$$\ $$  __$$\ $$ |$$  __$$ |
6  *    $$ |      $$$$$$$$ |$$ |  $$ |$$ |  $$ |$$ |\_$$ |$$ /  $$ |$$ |$$ /  $$ |
7  *    $$ |  $$\ $$   ____|$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |
8  *    \$$$$$$  |\$$$$$$$\ $$ |  $$ |$$ |  $$ |\$$$$$$  |\$$$$$$  |$$ |\$$$$$$$ |
9  *     \______/  \_______|\__|  \__|\__|  \__| \______/  \______/ \__| \_______|
10  *                                                                              
11  *                                  by Cehhiro                                                                  
12  *                                                                              
13  */
14 
15 pragma solidity ^ 0.4.24;
16 
17 library ECRecovery {
18   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
19     bytes32 r;
20     bytes32 s;
21     uint8 v;
22 
23     if (sig.length != 65) {
24       return (address(0));
25     }
26     
27     assembly {
28       r := mload(add(sig, 32))
29       s := mload(add(sig, 64))
30       v := byte(0, mload(add(sig, 96)))
31     }
32 
33     if (v < 27) {
34       v += 27;
35     }
36 
37     if (v != 27 && v != 28) {
38       return (address(0));
39     } else {
40       return ecrecover(hash, v, r, s);
41     }
42   }
43 }
44 
45 library SafeMath {
46     function add(uint a, uint b) internal pure returns (uint c) {
47         c = a + b;
48         require(c >= a);
49     }
50     function sub(uint a, uint b) internal pure returns (uint c) {
51         require(b <= a);
52         c = a - b;
53     }
54     function mul(uint a, uint b) internal pure returns (uint c) {
55         c = a * b;
56         require(a == 0 || c / a == b);
57     }
58     function div(uint a, uint b) internal pure returns (uint c) {
59         require(b > 0);
60         c = a / b;
61     }
62 }
63 
64 
65 contract ERC20Interface {
66     function totalSupply() public constant returns (uint);
67     function balanceOf(address tokenOwner) public constant returns (uint balance);
68     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
69     function transfer(address to, uint tokens) public returns (bool success);
70     function approve(address spender, uint tokens) public returns (bool success);
71     function transferFrom(address from, address to, uint tokens) public returns (bool success);
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 
77 
78 contract ApproveAndCallFallBack {
79     function receiveApproval(address from, uint tokens, address token, bytes data) public;
80 }
81 
82 contract ERC20 is ERC20Interface {
83     using SafeMath for uint;
84 
85     uint _totalSupply = 0;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     function totalSupply() public view returns (uint) {
92         return _totalSupply.sub(balances[address(0)]);
93     }
94 
95 
96     function balanceOf(address tokenOwner) public view returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100 
101     function transfer(address to, uint tokens) public returns (bool success) {
102         balances[msg.sender] = balances[msg.sender].sub(tokens);
103         balances[to] = balances[to].add(tokens);
104         emit Transfer(msg.sender, to, tokens);
105         return true;
106     }
107 
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         emit Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
115         balances[from] = balances[from].sub(tokens);
116         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
117         balances[to] = balances[to].add(tokens);
118         emit Transfer(from, to, tokens);
119         return true;
120     }
121 
122     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
123         return allowed[tokenOwner][spender];
124     }
125 
126     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
130         return true;
131     }
132 
133     function () public payable {
134         revert();
135     }
136 }
137 
138 
139 contract ERC891 is ERC20 {
140     using ECRecovery for bytes32;
141 
142     uint public constant maxReward = 50 * 10**18;
143     mapping(address => bool) internal claimed;
144 
145     function claim() public {
146         claimFor(msg.sender);
147     }
148 
149     function claimFor(address _address) public returns(uint) {
150         require(!claimed[_address]);
151         
152         uint reward = checkFind(_address);
153         require(reward > 0);
154         
155         claimed[_address]   = true;
156         balances[_address]  = balances[_address].add(reward);
157         _totalSupply        = _totalSupply.add(reward);
158         
159         emit Transfer(address(0), _address, reward);
160         
161         return reward;
162     }
163 
164     function checkFind(address _address) pure public returns(uint) {
165         uint maxBitRun  = 0;
166         uint data       = uint(bytes20(_address) & 0xffffffffffffffffff);
167         
168         while (data > 0) {
169             maxBitRun = maxBitRun + uint(data & 1);
170             data = uint(data & 1) == 1 ? data >> 1 : 0;
171         }
172         
173         return maxReward >> (18 * 4 - maxBitRun);
174     }
175 
176     function claimWithSignature(bytes _sig) public {
177         bytes32 hash = bytes32(keccak256(abi.encodePacked(
178             "\x19Ethereum Signed Message:\n32",
179             keccak256(abi.encodePacked(msg.sender))
180         )));
181         
182         address minedAddress = hash.recover(_sig);
183         uint reward          = claimFor(minedAddress);
184 
185         allowed[minedAddress][msg.sender] = reward;
186         transferFrom(minedAddress, msg.sender, reward);
187     }
188 }
189 
190 contract CehhGold is ERC891 {
191     string  public constant name        = "CehhGold";
192     string  public constant symbol      = "CEHH+";
193     uint    public constant decimals    = 18;
194     uint    public version              = 0;
195 }