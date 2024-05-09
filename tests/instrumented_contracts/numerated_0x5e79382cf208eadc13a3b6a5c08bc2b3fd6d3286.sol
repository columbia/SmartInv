1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 
70 contract EthmoMinter {
71     address[] newContracts;
72     address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
73     address constant private addr=0x6536eF439c4507a49F54eaBEB0127a3Bca9Def89;
74     address constant private addrs=0xE80cBfDA1b8D0212C4b79D6d6162dc377C96876e;
75     address constant private Tummy=0x820090F4D39a9585a327cc39ba483f8fE7a9DA84;
76     address constant private Willy=0xA4757a60d41Ff94652104e4BCdB2936591c74d1D;
77     address constant private Nicky=0x89473CD97F49E6d991B68e880f4162e2CBaC3561;
78     address constant private Artem=0xA7e8AFa092FAa27F06942480D28edE6fE73E5F88;
79     uint FIWDeploy;
80     uint FIWMint;
81     uint mult;
82     
83     function createContract (bytes32 EthmojiName,bytes32 EthmojiNicknameOrSymbol,uint Amount) public payable{
84         if (msg.sender==Admin || msg.sender==Tummy || msg.sender==Willy || msg.sender==Nicky || msg.sender==Artem){
85         }else{
86             VIPs Mult=VIPs(addrs);
87             mult=Mult.IsVIP(msg.sender);
88             EthmoFees fee=EthmoFees(addr);
89             FIWDeploy=fee.GetFeeEthmoDeploy();
90             FIWMint=fee.GetFeeEthmoMint();
91             require(msg.value >= (FIWDeploy+FIWMint*Amount)*mult);
92         }
93         Admin.transfer(msg.value);
94         address Sender=msg.sender;
95         address newContract = new Contract(EthmojiName,EthmojiNicknameOrSymbol,Amount,Sender);
96 
97         newContracts.push(newContract);
98 
99     } 
100     
101     function MintMoreEthmojis (address EthmojiAddress,uint Amount) public payable{
102         if (msg.sender==Admin || msg.sender==Tummy || msg.sender==Willy || msg.sender==Nicky || msg.sender==Artem){
103         }else{
104             VIPs Mult=VIPs(addrs);
105             mult=Mult.IsVIP(msg.sender);
106             EthmoFees fee=EthmoFees(addr);
107             FIWMint=fee.GetFeeEthmoMint();
108             require(msg.value >= FIWMint*Amount*mult);
109         }
110         Admin.transfer(msg.value);
111         address Sender=msg.sender;
112         address Legit=address(this);
113         Contract mints=Contract(EthmojiAddress);
114         mints.MintMore(Sender,Amount,Legit);
115     }
116     
117     
118     function () public payable{
119         Admin.transfer(msg.value);
120     }
121         
122    
123 
124 }
125 
126 
127 contract VIPs {
128     function IsVIP(address Address)returns(uint Multiplier);
129 }
130     
131 
132 contract EthmoFees {
133     function GetFeeEthmoDeploy()returns(uint);
134     function GetFeeEthmoMint()returns(uint);
135 }
136 
137 
138 contract Contract is ERC20Interface, Owned, SafeMath {
139     address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
140 
141 
142     string public symbol;
143     string public  name;
144     uint8 public decimals;
145     uint public _totalSupply;
146 
147     mapping(address => uint) balances;
148     mapping(address => mapping(address => uint)) allowed;
149 
150 
151 
152     function Contract (bytes32 EthmojiName,bytes32 EthmojiNicknameOrSymbol,uint Amount,address Sender) public {
153         
154     bytes memory bytesString = new bytes(32);
155     uint charCount = 0;
156     for (uint j = 0; j < 32; j++) {
157         byte char = byte(bytes32(uint(EthmojiName) * 2 ** (8 * j)));
158         if (char != 0) {
159             bytesString[charCount] = char;
160             charCount++;
161         }
162     }
163     bytes memory bytesStringTrimmed = new bytes(charCount);
164     for (j = 0; j < charCount; j++) {
165         bytesStringTrimmed[j] = bytesString[j];
166     }
167     
168 
169     bytes memory bytesStringsw = new bytes(32);
170     uint charCountsw = 0;
171     for (uint k = 0; k < 32; k++) {
172         byte charsw = byte(bytes32(uint(EthmojiNicknameOrSymbol) * 2 ** (8 * k)));
173         if (charsw != 0) {
174             bytesStringsw[charCountsw] = charsw;
175             charCountsw++;
176         }
177     }
178     bytes memory bytesStringTrimmedsw = new bytes(charCountsw);
179     for (k = 0; k < charCountsw; k++) {
180         bytesStringTrimmedsw[k] = bytesStringsw[k];
181     }
182 
183         symbol = string(bytesStringTrimmedsw);
184         name = string(bytesStringTrimmed);
185         decimals = 0;
186         _totalSupply = Amount;
187         balances[Sender] = _totalSupply;
188         emit Transfer(address(0), Sender, _totalSupply);
189     }
190 
191 
192     function totalSupply() public constant returns (uint) {
193         return _totalSupply  - balances[address(0)];
194     }
195 
196 
197    
198     function balanceOf(address tokenOwner) public constant returns (uint balance) {
199         return balances[tokenOwner];
200     }
201 
202 
203 
204     function transfer(address to, uint tokens) public returns (bool success) {
205         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
206         balances[to] = safeAdd(balances[to], tokens);
207         emit Transfer(msg.sender, to, tokens);
208         return true;
209     }
210 
211 
212 
213     function approve(address spender, uint tokens) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         emit Approval(msg.sender, spender, tokens);
216         return true;
217     }
218 
219 
220   
221     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
222         balances[from] = safeSub(balances[from], tokens);
223         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
224         balances[to] = safeAdd(balances[to], tokens);
225         emit Transfer(from, to, tokens);
226         return true;
227     }
228 
229 
230 
231     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
232         return allowed[tokenOwner][spender];
233     }
234 
235 
236 
237     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
238         allowed[msg.sender][spender] = tokens;
239         emit Approval(msg.sender, spender, tokens);
240         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
241         return true;
242     }
243 
244 
245     function MintMore(address Sender,uint Amount,address Legit) public payable {
246         require(msg.sender==Legit);
247         uint tokens=Amount;
248         balances[Sender] = safeAdd(balances[Sender], tokens);
249         _totalSupply = safeAdd(_totalSupply, tokens);
250         Transfer(address(0), Sender, tokens);
251     }
252     
253     
254 
255     function () public payable{
256         Admin.transfer(msg.value);
257     }
258 
259 
260     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
261         return ERC20Interface(tokenAddress).transfer(owner, tokens);
262     }
263 }