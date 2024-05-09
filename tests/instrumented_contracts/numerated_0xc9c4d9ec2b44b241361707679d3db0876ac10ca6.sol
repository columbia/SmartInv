1 pragma solidity ^0.4.22;
2 
3 contract POCToken{
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
37     string public symbol = "POC";
38     string public name = "Power Candy";
39     uint8 public decimals = 18;
40     uint public totalSupply = 1e28;//总量100亿
41 
42     uint public offline = 6e27;//用于线下兑换60亿
43     uint private retention = 3e27;//自留30亿
44 
45     uint public airdrop = 1e27;//空投10亿
46     uint public airdropLimit = 4e23;//每个地址最多领取空投限制40万
47     uint public fadd = 3e20;//添加地址得300
48     uint public fshare = 5e19;//邀请得50
49 
50     bool public allowTransfer = true;//是否允许交易
51     bool public allowAirdrop = true;//是否允许领取空投
52 
53     mapping(address => uint) private balances;
54     mapping(address => uint) public airdropTotal;
55     mapping(address => address) public airdropRecord;
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 
60     address private retentionAddress = 0x17a896C50F11a4926f97d28EC4e7B26149712e08;
61     constructor() public {
62         owner = msg.sender;
63         airdropRecord[owner] = owner;
64         airdropRecord[retentionAddress] = retentionAddress;
65 
66         balances[retentionAddress] = retention;
67         emit Transfer(address(0), retentionAddress, retention);
68     }
69     function specialAddress(address addr) private pure returns(bool spe) {//特殊地址标示POC来源，0表示自留和空投，1表示线下兑换
70         spe = (addr == address(0) || addr == address(1));
71     }
72     function balanceOf(address tokenOwner) public view returns (uint balance) {
73         require(specialAddress(tokenOwner) == false);
74         if(airdrop >= fadd && airdropRecord[tokenOwner] == address(0) && tokenOwner != retentionAddress){//如果还有足够的空投额度，没激活，不是保留地址
75             balance = balances[tokenOwner] + fadd;
76         }else{
77             balance = balances[tokenOwner];
78         }
79     }
80     function allowance(address tokenOwner, address spender) public pure returns (uint remaining) {
81         require(specialAddress(tokenOwner) == false);
82         require(specialAddress(spender) == false);
83         //------do nothing------
84         remaining = 0;
85     }
86     function activation(uint bounus, address addr) private {
87         uint airdropBounus = safeAdd(airdropTotal[addr], bounus);
88         if(airdrop >= bounus && airdropBounus <= airdropLimit && addr != retentionAddress){//如果还有足够的空投额度并且没有达到个人领取上限，不是保留地址
89             balances[addr] = safeAdd(balances[addr], bounus);
90             airdropTotal[addr] = airdropBounus;
91             airdrop = safeSub(airdrop, bounus);
92             emit Transfer(address(0), addr, bounus);
93         }
94     }
95     function transfer(address to, uint tokens) public returns (bool success) {
96         require(allowTransfer && tokens > 0);
97         require(to != msg.sender);
98         require(specialAddress(to) == false);
99 
100         if (allowAirdrop && airdropRecord[msg.sender] == address(0) && airdropRecord[to] != address(0)) {//没有激活过的，发给任意多个币给已经激活过的，视为邀请
101             activation(fadd, msg.sender);
102             activation(fshare, to);
103             airdropRecord[msg.sender] = to;//记录激活数据
104         }
105 
106         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
107         balances[to] = safeAdd(balances[to], tokens);
108         emit Transfer(msg.sender, to, tokens);
109         success = true;
110     }
111     function approve(address spender, uint tokens) public pure returns (bool success) {
112         require(tokens  > 0);
113         require(specialAddress(spender) == false);
114         //------do nothing------
115         success = false;
116     }
117     function transferFrom(address from, address to, uint tokens) public pure returns (bool success) {
118         require(tokens  > 0);
119         require(specialAddress(from) == false);
120         require(specialAddress(to) == false);
121         //------do nothing------
122         success = false;
123     }
124     //
125     // -------------------------ERC20Interface End-------------------------------------------------
126 
127     function offlineExchange(address to, uint tokens) public onlyOwner {
128         require(offline >= tokens);
129         balances[to] = safeAdd(balances[to], tokens);
130         offline = safeSub(offline, tokens);
131         emit Transfer(address(1), to, tokens);
132     }
133     function clearBalance(address addr) public onlyOwner {
134         emit Transfer(addr, address(1), balances[addr]);
135         balances[addr] = 0;
136     }
137     function chAirDropLimit(uint _airdropLimit) public onlyOwner {
138         airdropLimit = _airdropLimit;
139     }
140     function chAirDropFadd(uint _fadd) public onlyOwner {
141         fadd = _fadd;
142     }
143     function chAirDropFshare(uint _fshare) public onlyOwner {
144         fshare = _fshare;
145     }
146     function chAllowTransfer(bool _allowTransfer) public onlyOwner {
147         allowTransfer = _allowTransfer;
148     }
149     function chAllowAirdrop(bool _allowAirdrop) public onlyOwner {
150         allowAirdrop = _allowAirdrop;
151     }
152 }