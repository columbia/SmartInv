1 pragma solidity >=0.4.22 <0.7.0;
2 
3 contract GNSToken{
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
20     // constructor() public {
21     //     owner = msg.sender;
22     // }
23 
24     event OwnershipTransferred(address indexed _from, address indexed _to);
25     modifier onlyOwner { require(msg.sender == owner); _; }
26 
27     function transferOwnership(address _newOwner) public onlyOwner {
28         newOwner = _newOwner;
29     }
30     function acceptOwnership() public {
31         require(msg.sender == newOwner);
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34         newOwner = address(0);
35     }
36     //
37     // -------------------------Owned End-------------------------------------------------
38 
39     // -------------------------ERC20Interface Start-----------------------------------------------
40     //
41     string public symbol = "GNS";
42     string public name = "Genesis";
43     uint8 public decimals = 18;
44     uint public totalSupply = 988e24;//总量9.88亿
45 
46     uint public exchange = 688e24;//用于兑换5.88亿（空投，离线兑换总额）
47     uint private retention = 3e26;//自留3亿
48 
49     uint public airdrop = 1e26;//空投限额1亿
50     uint public airdropLimit = 1e21;//每个地址最多领取空投限制1000
51     uint public fadd = 5e19;//添加地址得50
52     uint public fshare = 2e19;//邀请得20
53 
54     bool public allowTransfer = true;//是否允许交易
55     bool public allowAirdrop = true;//是否允许空投
56 
57     mapping(address => uint) private balances;
58     mapping(address => uint) public airdropTotal;
59     mapping(address => address) public airdropRecord;
60 
61     event Transfer(address indexed from, address indexed to, uint tokens);
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 
64     address private retentionAddress = 0x4FCf2310752A4D919C1819BdD9B155632465373e;
65     constructor() public {
66         owner = msg.sender;
67         airdropRecord[owner] = owner;
68         airdropRecord[retentionAddress] = retentionAddress;
69 
70         balances[retentionAddress] = retention;
71         emit Transfer(address(1), retentionAddress, retention);
72     }
73     function specialAddress(address addr) private pure returns(bool spe) {//特殊地址，0表示空投和销毁，1表示线下兑换
74         spe = (addr == address(0) || addr == address(1));
75     }
76     function balanceOf(address tokenOwner) public view returns (uint balance) {
77         require(specialAddress(tokenOwner) == false);
78         if(airdrop >= fadd && exchange >= fadd && airdropRecord[tokenOwner] == address(0)){//如果还有足够的空投额度，没激活
79             balance = balances[tokenOwner] + fadd;
80         }else{
81             balance = balances[tokenOwner];
82         }
83     }
84     function allowance(address tokenOwner, address spender) public pure returns (uint remaining) {
85         require(specialAddress(tokenOwner) == false);
86         require(specialAddress(spender) == false);
87         //------do nothing------
88         remaining = 0;
89     }
90     function activation(uint bounus, address addr) private {
91         if(airdrop >= bounus && exchange >= bounus && addr != retentionAddress && addr != owner){//如果还有足够的空投额度，不是保留地址
92             uint airdropBounus = safeAdd(airdropTotal[addr], bounus);
93             if (airdropBounus <= airdropLimit ) {//没有达到个人领取上限
94                 balances[addr] = safeAdd(balances[addr], bounus);
95                 airdropTotal[addr] = airdropBounus;
96                 airdrop = safeSub(airdrop, bounus);
97                 exchange = safeSub(exchange, bounus);
98                 emit Transfer(address(0), addr, bounus);
99             }
100         }
101     }
102     function transfer(address to, uint tokens) public returns (bool success) {
103         require(allowTransfer && tokens > 0);
104         require(to != msg.sender);
105         require(specialAddress(to) == false);
106 
107         if (allowAirdrop && airdropRecord[msg.sender] == address(0) && airdropRecord[to] != address(0)) {//没有激活过的，发给任意多个币给已经激活过的，视为邀请
108             activation(fadd, msg.sender);
109             activation(fshare, to);
110             airdropRecord[msg.sender] = to;//记录激活数据
111         }
112 
113         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
114         balances[to] = safeAdd(balances[to], tokens);
115         emit Transfer(msg.sender, to, tokens);
116         success = true;
117     }
118     function approve(address spender, uint tokens) public pure returns (bool success) {
119         require(tokens  > 0);
120         require(specialAddress(spender) == false);
121         //------do nothing------
122         success = false;
123     }
124     function transferFrom(address from, address to, uint tokens) public pure returns (bool success) {
125         require(tokens  > 0);
126         require(specialAddress(from) == false);
127         require(specialAddress(to) == false);
128         //------do nothing------
129         success = false;
130     }
131     //
132     // -------------------------ERC20Interface End-------------------------------------------------
133 
134     // ------------------------------------------------------------------------
135     function offlineExchange(address to, uint tokens, uint fee) public onlyOwner {
136         require(exchange >= tokens);
137         balances[to] = safeAdd(balances[to], tokens);
138         exchange = safeSub(exchange, tokens);
139         emit Transfer(address(1), to, tokens);
140 
141         balances[to] = safeSub(balances[to], fee);
142         emit Transfer(to, address(0), fee);
143 
144         totalSupply = safeSub(totalSupply, fee);
145     }
146     function sendTokens(address[] memory to, uint[] memory tokens) public {
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
161 
162     // ------------------------------------------------------------------------
163     function chAirDropLimit(uint _airdropLimit) public onlyOwner {
164         airdropLimit = _airdropLimit;
165     }
166     function chAirDropFadd(uint _fadd) public onlyOwner {
167         fadd = _fadd;
168     }
169     function chAirDropFshare(uint _fshare) public onlyOwner {
170         fshare = _fshare;
171     }
172     function chAllowTransfer(bool _allowTransfer) public onlyOwner {
173         allowTransfer = _allowTransfer;
174     }
175     function chAllowAirdrop(bool _allowAirdrop) public onlyOwner {
176         allowAirdrop = _allowAirdrop;
177     }
178 }