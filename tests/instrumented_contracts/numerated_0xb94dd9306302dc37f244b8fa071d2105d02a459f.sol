1 pragma solidity ^0.4.15;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSub(uint256 x, uint256 y) internal returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30 }
31 
32 contract owned {
33     address public owner;
34     address[] public allowedTransferDuringICO;
35 
36     function owned() {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         assert(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner {
46         owner = newOwner;
47     }
48 
49     function isAllowedTransferDuringICO() public constant returns (bool){
50         for(uint i = 0; i < allowedTransferDuringICO.length; i++) {
51             if (allowedTransferDuringICO[i] == msg.sender) {
52                 return true;
53             }
54         }
55         return false;
56     }
57 }
58 
59 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
60 
61 contract Token is owned {
62     uint256 public totalSupply;
63     function balanceOf(address _owner) constant returns (uint256 balance);
64     function transfer(address _to, uint256 _value) returns (bool success);
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
66     function approve(address _spender, uint256 _value) returns (bool success);
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
68     
69     /* This generates a public event on the blockchain that will notify clients */
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 
75 /*  ERC 20 token */
76 contract StandardToken is SafeMath, Token {
77 
78     uint public lockBlock;
79     /* Send coins */
80     function transfer(address _to, uint256 _value) returns (bool success) {
81         require(block.number >= lockBlock || isAllowedTransferDuringICO());
82         if (balances[msg.sender] >= _value && _value > 0) {
83             balances[msg.sender] = safeSub(balances[msg.sender], _value);
84             balances[_to] = safeAdd(balances[_to], _value);
85             Transfer(msg.sender, _to, _value);
86             return true;
87         } else {
88             return false;
89         }
90     }
91 
92     /* A contract attempts to get the coins */
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         require(block.number >= lockBlock || isAllowedTransferDuringICO());
95         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
96             balances[_to] = safeAdd(balances[_to], _value);
97             balances[_from] = safeSub(balances[_from], _value);
98             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
99             Transfer(_from, _to, _value);
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     function balanceOf(address _owner) constant returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     /* Allow another contract to spend some tokens in your behalf */
111     function approve(address _spender, uint256 _value) returns (bool success) {
112         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122     /* This creates an array with all balances */
123     mapping (address => uint256) balances;
124     mapping (address => mapping (address => uint256)) allowed;
125 }
126 
127 contract EICToken is StandardToken {
128 
129     // metadata
130     string constant public name = "Entertainment Industry Coin";
131     string constant public symbol = "EIC";
132     uint256 constant public decimals = 18;
133 
134     function EICToken(
135         uint _lockBlockPeriod)
136         public
137     {
138         allowedTransferDuringICO.push(owner);
139         totalSupply = 3125000000 * (10 ** decimals);
140         balances[owner] = totalSupply;
141         lockBlock = block.number + _lockBlockPeriod;
142     }
143 
144     function distribute(address[] addr, uint256[] token) public onlyOwner {
145         // only owner can call
146         require(addr.length == token.length);
147         allowedTransferDuringICO.push(addr[0]);
148         allowedTransferDuringICO.push(addr[1]);
149         for (uint i = 0; i < addr.length; i++) {
150             transfer(addr[i], token[i] * (10 ** decimals));
151         }
152     }
153 
154 }
155 
156 contract CrowdSales {
157     address owner;
158 
159     EICToken public token;
160 
161     uint public tokenPrice;
162 
163     struct Beneficiary {
164         address addr;
165         uint256 ratio;
166     }
167 
168     Beneficiary[] public beneficiaries;
169 
170     event Bid(address indexed bider, uint256 getToken);
171 
172     modifier onlyOwner {
173         require(msg.sender == owner);
174         _;
175     }
176 
177     function CrowdSales(address _tokenAddress) public {
178         owner = msg.sender;
179         beneficiaries.push(Beneficiary(0xA5A6b44312a2fc363D78A5af22a561E9BD3151be, 10));
180         beneficiaries.push(Beneficiary(0x8Ec21f2f285545BEc0208876FAd153e0DEE581Ba, 10));
181         beneficiaries.push(Beneficiary(0x81D98B74Be1C612047fEcED3c316357c48daDc83, 5));
182         beneficiaries.push(Beneficiary(0x882Efb2c4F3B572e3A8B33eb668eeEdF1e88e7f0, 10));
183         beneficiaries.push(Beneficiary(0xe63286CCaB12E10B9AB01bd191F83d2262bde078, 15));
184         beneficiaries.push(Beneficiary(0x8a2454C1c79C23F6c801B0c2665dfB9Eab0539b1, 285));
185         beneficiaries.push(Beneficiary(0x4583408F92427C52D1E45500Ab402107972b2CA6, 665));
186         token = EICToken(_tokenAddress);
187         tokenPrice = 15000;
188     }
189 
190     function () public payable {
191     	bid();
192     }
193 
194     function bid()
195     	public
196     	payable
197     {
198     	require(block.number <= token.lockBlock());
199         require(this.balance <= 62500 * ( 10 ** 18 ));
200     	require(token.balanceOf(msg.sender) + (msg.value * tokenPrice) >= (5 * (10 ** 18)) * tokenPrice);
201     	require(token.balanceOf(msg.sender) + (msg.value * tokenPrice) <= (200 * (10 ** 18)) * tokenPrice);
202         token.transfer(msg.sender, msg.value * tokenPrice);
203         Bid(msg.sender, msg.value * tokenPrice);
204     }
205 
206     function finalize() public onlyOwner {
207         require(block.number > token.lockBlock() || this.balance == 62500 * ( 10 ** 18 ));
208         uint receiveWei = this.balance;
209         for (uint i = 0; i < beneficiaries.length; i++) {
210             Beneficiary storage beneficiary = beneficiaries[i];
211             uint256 value = (receiveWei * beneficiary.ratio)/(1000);
212             beneficiary.addr.transfer(value);
213         }
214         if (token.balanceOf(this) > 0) {
215             uint256 remainingToken = token.balanceOf(this);
216             address owner30 = 0x8a2454C1c79C23F6c801B0c2665dfB9Eab0539b1;
217             address owner70 = 0x4583408F92427C52D1E45500Ab402107972b2CA6;
218 
219             token.transfer(owner30, (remainingToken * 30)/(100));
220             token.transfer(owner70, (remainingToken * 70)/(100));
221         }
222         owner.transfer(this.balance);
223     }
224 }