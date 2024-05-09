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
70 contract NameTagMinter {
71     address[] newContracts;
72     address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
73     uint FIW;
74     uint mult;
75     
76     function createContract (bytes32 YourName,bytes32 YourInitialsOrSymbol) public payable{
77         address addr=0x6096B8D46E1e4E00FA1BEADFc071bBE500ED397B;
78         address addrs=0xE80cBfDA1b8D0212C4b79D6d6162dc377C96876e;
79         address Tummy=0x820090F4D39a9585a327cc39ba483f8fE7a9DA84;
80         address Willy=0xA4757a60d41Ff94652104e4BCdB2936591c74d1D;
81         address Nicky=0x89473CD97F49E6d991B68e880f4162e2CBaC3561;
82         address Artem=0xA7e8AFa092FAa27F06942480D28edE6fE73E5F88;
83         if (msg.sender==Admin || msg.sender==Tummy || msg.sender==Willy || msg.sender==Nicky || msg.sender==Artem){
84         }else{
85             VIPs Mult=VIPs(addrs);
86             mult=Mult.IsVIP(msg.sender);
87             Fees fee=Fees(addr);
88             FIW=fee.GetFeeNTM();
89             require(msg.value >= FIW*mult);
90         }
91         Admin.transfer(msg.value);
92         address Sender=msg.sender;
93         address newContract = new Contract(YourName,YourInitialsOrSymbol,Sender);
94 
95         newContracts.push(newContract);
96 
97     } 
98    
99 
100 }
101 
102 
103 contract VIPs {
104     function IsVIP(address Address)returns(uint Multiplier);
105 }
106     
107 
108 contract Fees {
109     function GetFeeNTM()returns(uint);
110 }
111 
112 
113 contract Contract is ERC20Interface, Owned, SafeMath {
114 
115 
116     string public symbol;
117     string public  name;
118     uint8 public decimals;
119     uint public _totalSupply;
120 
121     mapping(address => uint) balances;
122     mapping(address => mapping(address => uint)) allowed;
123 
124 
125 
126     function Contract (bytes32 YourName,bytes32 YourInitialsOrSymbol,address Sender) public {
127         
128     bytes memory bytesString = new bytes(32);
129     uint charCount = 0;
130     for (uint j = 0; j < 32; j++) {
131         byte char = byte(bytes32(uint(YourName) * 2 ** (8 * j)));
132         if (char != 0) {
133             bytesString[charCount] = char;
134             charCount++;
135         }
136     }
137     bytes memory bytesStringTrimmed = new bytes(charCount);
138     for (j = 0; j < charCount; j++) {
139         bytesStringTrimmed[j] = bytesString[j];
140     }
141     
142 
143     bytes memory bytesStringsw = new bytes(32);
144     uint charCountsw = 0;
145     for (uint k = 0; k < 32; k++) {
146         byte charsw = byte(bytes32(uint(YourInitialsOrSymbol) * 2 ** (8 * k)));
147         if (charsw != 0) {
148             bytesStringsw[charCountsw] = charsw;
149             charCountsw++;
150         }
151     }
152     bytes memory bytesStringTrimmedsw = new bytes(charCountsw);
153     for (k = 0; k < charCountsw; k++) {
154         bytesStringTrimmedsw[k] = bytesStringsw[k];
155     }
156 
157         symbol = string(bytesStringTrimmedsw);
158         name = string(bytesStringTrimmed);
159         decimals = 0;
160         _totalSupply = 1;
161         balances[Sender] = _totalSupply;
162         emit Transfer(address(0), Sender, _totalSupply);
163     }
164 
165 
166     function totalSupply() public constant returns (uint) {
167         return _totalSupply  - balances[address(0)];
168     }
169 
170 
171    
172     function balanceOf(address tokenOwner) public constant returns (uint balance) {
173         return balances[tokenOwner];
174     }
175 
176 
177 
178     function transfer(address to, uint tokens) public returns (bool success) {
179         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens);
181         emit Transfer(msg.sender, to, tokens);
182         return true;
183     }
184 
185 
186 
187     function approve(address spender, uint tokens) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         return true;
191     }
192 
193 
194   
195     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
196         balances[from] = safeSub(balances[from], tokens);
197         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
198         balances[to] = safeAdd(balances[to], tokens);
199         emit Transfer(from, to, tokens);
200         return true;
201     }
202 
203 
204 
205     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
206         return allowed[tokenOwner][spender];
207     }
208 
209 
210 
211     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         emit Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
215         return true;
216     }
217 
218 
219 
220     function () public payable {
221         revert();
222     }
223 
224 
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 }