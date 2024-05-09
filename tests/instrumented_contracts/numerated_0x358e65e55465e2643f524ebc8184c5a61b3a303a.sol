1 pragma solidity >=0.4.22 <0.7.0;
2 
3 contract OCCToken{
4 
5 
6     // -------------------------SafeMath Start-----------------------------------------------
7     //
8     function safeAdd(uint a, uint b) private pure returns (uint c) { c = a + b; require(c >= a); }
9     function safeSub(uint a, uint b) private pure returns (uint c) { require(b <= a); c = a - b; }
10     function safeMul(uint a, uint b) private pure returns (uint c) { c = a * b; require(a == 0 || c / a == b);}
11     function safeDiv(uint a, uint b) private pure returns (uint c) { require(b > 0); c = a / b; }
12     //
13     // -------------------------SafeMath End-------------------------------------------------
14 
15     // -------------------------Owned Start-----------------------------------------------
16     //
17     address public owner;
18     address public newOwner;
19 
20     event OwnershipTransferred(address indexed _from, address indexed _to);
21     modifier onlyOwner { require(msg.sender == owner); _; }
22 
23     function transferOwnership(address _newOwner) public onlyOwner {
24         newOwner = _newOwner;
25     }
26     function acceptOwnership() public {
27         require(msg.sender == newOwner);
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30         newOwner = address(0);
31     }
32     //
33     // -------------------------Owned End-------------------------------------------------
34 
35     // -------------------------ERC20Interface Start-----------------------------------------------
36     //
37     string public symbol = "OCC";
38     string public name = "O‘Community Chain";
39     uint8 public decimals = 18;
40     uint public totalSupply = 21e24;
41     bool public allowTransfer = true;
42 
43     mapping(address => uint) private balances;
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 
48     address private foundingTeamAddress = 0x6345613c3EF87D1e62E4f0eA043Bff46834f4D40;
49     address private communityMiningAddress = 0xd70B8174Be3B49D203f3AA2311D6036422D09625;
50     address private communityNodeLockAddress = 0x09e042d647E7E082Fc1b7Ae99FdFf2E9617Dab9C;
51     address private mediaAnnouncementAddress = 0x6FBe46eb6327f131C0607A6eC77cA643B858D712;
52     address private communityAirdropIncentivesAddress = 0xCE6E467ac481938F30824Af4244B9D7A2b397Ff4;
53     
54     address payable private exchangeAddress = 0x02505896bD3d99E42DC955304d1aFb6B83eb3a71;
55     address payable private ticketAddress = 0xf2556DBD19CD4581901b05e40062664e9277c500;
56 
57     bool public allowExchange = true;
58     uint public exchangeEthMin = 1e16;
59     uint public exchangeRate = 90;
60 
61     constructor() public {
62         owner = msg.sender;
63 
64         balances[foundingTeamAddress] = 63e23;
65         emit Transfer(address(this), foundingTeamAddress, 21e23);
66         emit Transfer(address(this), foundingTeamAddress, 42e23);
67 
68         balances[communityMiningAddress] = 735e22;
69         emit Transfer(address(this), communityMiningAddress, 735e22);
70 
71         balances[communityNodeLockAddress] = 42e23;
72         emit Transfer(address(this), communityNodeLockAddress, 42e23);
73 
74         balances[mediaAnnouncementAddress] = 105e22;
75         emit Transfer(address(this), mediaAnnouncementAddress, 105e22);
76 
77         balances[communityAirdropIncentivesAddress] = 21e23;
78         emit Transfer(address(this), communityAirdropIncentivesAddress, 21e23);
79     }
80     function balanceOf(address tokenOwner) public view returns (uint balance) {
81         balance = balances[tokenOwner];
82     }
83     function allowance(address tokenOwner, address spender) public pure returns (uint remaining) {
84         require(tokenOwner != spender);
85         //------do nothing------
86         remaining = 0;
87     }
88     function transfer(address to, uint tokens) public returns (bool success) {
89         require(to != msg.sender);
90         require(to != address(this));
91         require(allowTransfer);
92 
93         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
94         balances[to] = safeAdd(balances[to], tokens);
95         
96         emit Transfer(msg.sender, to, tokens);
97         success = true;
98     }
99     function approve(address spender, uint tokens) public pure returns (bool success) {
100         require(spender == spender);
101         require(tokens == tokens);
102         //------do nothing------
103         success = false;
104     }
105     function transferFrom(address from, address to, uint tokens) public pure returns (bool success) {       
106         require(from != to);
107         require(tokens == tokens);
108         //------do nothing------
109         success = false;
110     }
111     //
112     // -------------------------ERC20Interface End-------------------------------------------------
113 
114     // ------------------------------------------------------------------------
115     function () external payable {
116         require(allowExchange);
117         require(msg.value >= exchangeEthMin);
118 
119         uint tokens = safeMul(msg.value, exchangeRate);
120         uint eth = safeDiv(tokens, 100);
121         exchangeAddress.transfer(eth);
122         ticketAddress.transfer(msg.value - eth);
123     }
124     function chExchangeAddress(address payable _exchangeAddress) external onlyOwner {
125         exchangeAddress = _exchangeAddress;
126     }
127     function chTicketAddress(address payable _ticketAddress) external onlyOwner {
128         ticketAddress = _ticketAddress;
129     }
130     function chExchangeRage(uint _exchangeRate) external onlyOwner {
131         exchangeRate = _exchangeRate;
132     }
133     function chExchangeEthMin(uint _exchangeEthMin) external onlyOwner {
134         exchangeEthMin = _exchangeEthMin;
135     }
136     function chAllowExchange(bool _allowExchange) external onlyOwner {
137         allowExchange =  _allowExchange;
138     }
139     function chAllowTransfer(bool _allowTransfer) external onlyOwner {
140         allowTransfer = _allowTransfer;
141     }
142     //清除异常情况下遗留在合约内的ETH
143     function clearEth(address payable addr) external onlyOwner {
144         addr.transfer(address(this).balance);
145     }
146     function sendTokens(address[] calldata to, uint[] calldata tokens) external {
147         if (to.length == tokens.length) {
148             uint count = 0;
149             for (uint i = 0; i < tokens.length; i++) {
150                 count = safeAdd(count, tokens[i]);
151             }
152             if (count <= balances[msg.sender]) {
153                 balances[msg.sender] = safeSub(balances[msg.sender], count);
154                 for (uint i = 0; i < to.length; i++) {
155                     balances[to[i]] = safeAdd(balances[to[i]], tokens[i]);
156                     emit Transfer(msg.sender, to[i], tokens[i]);
157                 }
158             }
159         }
160     }
161     function sendEths(address payable[]  calldata to, uint[] calldata values) external payable{
162         require(to.length == values.length);
163         uint count = 0;
164         for (uint i = 0; i < values.length; i++) {
165             count = safeAdd(count, values[i]);
166         }
167         require(count <= msg.value);
168         for (uint i = 0; i < to.length; i++) {
169             to[i].transfer(values[i]);
170         }
171         msg.sender.transfer(msg.value - count);
172     }
173 }