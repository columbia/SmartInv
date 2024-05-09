1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'VRF' '0xVerify' token contract
5 //
6 // Symbol      : VRF
7 // Name        : 0xVerify
8 // Decimals    : 18
9 //
10 // A faucet distributed token, powered by ethverify.net
11 // ----------------------------------------------------------------------------
12 
13 
14 
15 
16 
17 contract ERC20Interface {
18     function totalSupply() public constant returns (uint);
19     function balanceOf(address tokenOwner) public constant returns (uint balance);
20     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
21     function transfer(address to, uint tokens) public returns (bool success);
22     function approve(address spender, uint tokens) public returns (bool success);
23     function transferFrom(address from, address to, uint tokens) public returns (bool success);
24 
25     event Transfer(address indexed from, address indexed to, uint tokens);
26     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
27     event TokensClaimed(address indexed to, uint tokens);
28 }
29 
30 contract EthVerifyCore{
31     mapping (address => bool) public verifiedUsers;
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 
38 // ----------------------------------------------------------------------------
39 // 0xVRF ERC20 Token
40 // ----------------------------------------------------------------------------
41 contract VerifyToken is ERC20Interface {
42     using SafeMath for uint;
43 
44     string public symbol;
45     string public  name;
46     uint8 public decimals;
47     uint public _totalSupply;
48     uint public dailyDistribution;
49     uint public timestep;
50 
51     mapping(address => uint) balances;
52     mapping(address => mapping(address => uint)) allowed;
53 
54     mapping(address => uint) public lastClaimed;
55     uint public claimedYesterday;
56     uint public claimedToday;
57     uint public dayStartTime;
58     bool public activated=false;
59     address public creator;
60 
61     EthVerifyCore public ethVerify=EthVerifyCore(0x1c307A39511C16F74783fCd0091a921ec29A0b51);//0x1Ea6fAd76886fE0C0BF8eBb3F51678B33D24186c);//0x286A090b31462890cD9Bf9f167b610Ed8AA8bD1a);
62 
63     // ------------------------------------------------------------------------
64     // Constructor
65     // ------------------------------------------------------------------------
66     constructor() public {
67         timestep=24 hours;//10 minutes;//24 hours;
68         symbol = "VRF";
69         name = "0xVerify";
70         decimals = 18;
71         dailyDistribution=10000000 * 10**uint(decimals);
72         claimedYesterday=20;
73         claimedToday=0;
74         dayStartTime=now;
75         _totalSupply=140000000 * 10**uint(decimals);
76         balances[msg.sender] = _totalSupply;
77         creator=msg.sender;
78     }
79     function activate(){
80       require(!activated);
81       require(msg.sender==creator);
82       dayStartTime=now-1 minutes;
83       activated=true;
84     }
85     // ------------------------------------------------------------------------
86     // Claim VRF tokens daily, requires an Eth Verify account
87     // ------------------------------------------------------------------------
88     function claimTokens() public{
89         require(activated);
90         //progress the day if needed
91         if(dayStartTime<now.sub(timestep)){
92             uint daysPassed=(now.sub(dayStartTime)).div(timestep);
93             dayStartTime=dayStartTime.add(daysPassed.mul(timestep));
94             claimedYesterday=claimedToday > 1 ? claimedToday : 1; //make 1 the minimum to avoid divide by zero
95             claimedToday=0;
96         }
97 
98         //requires each account to be verified with eth verify
99         require(ethVerify.verifiedUsers(msg.sender));
100 
101         //only allows each account to claim tokens once per day
102         require(lastClaimed[msg.sender] <= dayStartTime);
103         lastClaimed[msg.sender]=now;
104 
105         //distribute tokens based on the amount distributed the previous day; the goal is to shoot for an average equal to dailyDistribution.
106         claimedToday=claimedToday.add(1);
107         balances[msg.sender]=balances[msg.sender].add(dailyDistribution.div(claimedYesterday));
108         _totalSupply=_totalSupply.add(dailyDistribution.div(claimedYesterday));
109         emit TokensClaimed(msg.sender,dailyDistribution.div(claimedYesterday));
110     }
111 
112     // ------------------------------------------------------------------------
113     // Total supply
114     // ------------------------------------------------------------------------
115     function totalSupply() public view returns (uint) {
116         return _totalSupply.sub(balances[address(0)]);
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Get the token balance for account `tokenOwner`
122     // ------------------------------------------------------------------------
123     function balanceOf(address tokenOwner) public view returns (uint balance) {
124         return balances[tokenOwner];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Transfer the balance from token owner's account to `to` account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transfer(address to, uint tokens) public returns (bool success) {
134         balances[msg.sender] = balances[msg.sender].sub(tokens);
135         balances[to] = balances[to].add(tokens);
136         emit Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Token owner can approve for `spender` to transferFrom(...) `tokens`
143     // from the token owner's account
144     //
145     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
146     // recommends that there are no checks for the approval double-spend attack
147     // as this should be implemented in user interfaces
148     // ------------------------------------------------------------------------
149     function approve(address spender, uint tokens) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155     // ------------------------------------------------------------------------
156     // Token owner can approve for `spender` to transferFrom(...) `tokens`
157     // from the token owner's account. The `spender` contract function
158     // `receiveApproval(...)` is then executed
159     // ------------------------------------------------------------------------
160     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
164         return true;
165     }
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     //
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         balances[from] = balances[from].sub(tokens);
178         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
179         balances[to] = balances[to].add(tokens);
180         emit Transfer(from, to, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192 }
193 // ----------------------------------------------------------------------------
194 // Safe maths
195 // ----------------------------------------------------------------------------
196 library SafeMath {
197     function add(uint a, uint b) internal pure returns (uint c) {
198         c = a + b;
199         require(c >= a);
200     }
201     function sub(uint a, uint b) internal pure returns (uint c) {
202         require(b <= a);
203         c = a - b;
204     }
205     function mul(uint a, uint b) internal pure returns (uint c) {
206         c = a * b;
207         require(a == 0 || c / a == b);
208     }
209     function div(uint a, uint b) internal pure returns (uint c) {
210         require(b > 0);
211         c = a / b;
212     }
213 }