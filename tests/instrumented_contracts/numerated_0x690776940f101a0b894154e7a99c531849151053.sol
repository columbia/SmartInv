1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract WhiteListed{
35     mapping(address => bool)whitelist;
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
67 }
68 
69 contract IziCoin is ERC20Interface, Owned, WhiteListed {
70         
71     using SafeMath for uint;
72     
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75     uint _totalSupply;
76     
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     
81     constructor () public {
82         symbol = "IZI";
83         name = "IziCoin";
84         decimals = 8;
85         _totalSupply = 24606905043426990;
86         balances[owner] = _totalSupply;
87         whitelist[owner] = true;
88         emit Transfer(address(0), owner, _totalSupply);
89     }
90     
91     //ERC20
92     function totalSupply() public view returns (uint){
93         return _totalSupply.sub(balances[address(0)]);
94     }
95     
96     function balanceOf(address tokenOwner) public view returns (uint balance){
97         return balances[tokenOwner];
98     }
99     
100     function allowance(address tokenOwner, address spender) public view returns (uint remaining){
101         return allowed[tokenOwner][spender];        
102     }
103     
104     function transfer(address to, uint tokens) public returns (bool success){
105         require(balances[msg.sender] >= tokens &&
106         tokens > 0 && 
107         to != address(0x0) &&
108         whitelist[msg.sender] &&
109         whitelist[to]);
110         executeTransfer(msg.sender,to, tokens);
111         emit Transfer(msg.sender, to, tokens);
112         return true;
113     }
114     
115     function approve(address spender, uint tokens) public returns (bool success){
116         require(balances[msg.sender] >= tokens &&
117         whitelist[msg.sender] &&
118         whitelist[spender]);
119         allowed[msg.sender][spender] = tokens;
120         emit Approval(msg.sender, spender, tokens);
121         return true;
122         
123     }
124     
125     function transferFrom(address from, address to, uint tokens) public returns (bool success){
126         require(balances[from] >= tokens &&
127         allowed[from][msg.sender] >= tokens &&
128         tokens > 0 && 
129         to != address(0x0) &&
130         whitelist[msg.sender] &&
131         whitelist[to]);
132         executeTransfer(from, to, tokens);
133         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
134         emit Transfer(msg.sender, to, tokens);
135         return true;
136     }
137     
138     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
139         allowed[msg.sender][spender] = tokens;
140         emit Approval(msg.sender, spender, tokens);
141         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
142         return true;
143     }
144     
145     //IziCoin
146     function executeTransfer(address from,address to, uint tokens) private{
147         uint previousBalances = balances[from] + balances[to];
148         balances[from] = balances[from].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         assert((balances[from] + balances[to] == previousBalances) && (whitelist[from] && whitelist[to]));
151     }
152     
153     function executeTransferWithTax(address from,address to, uint tokens, uint taxFee) private{
154         uint previousBalances = balances[from] + balances[to];
155         uint taxedTokens = tokens.sub(taxFee);
156         balances[from] = balances[from].sub(tokens);
157         balances[to] = balances[to].add(taxedTokens);
158         if(from != owner){
159            balances[owner] = balances[owner].add(taxFee); 
160         }
161         emit Transfer(from, to, taxedTokens);
162         emit Transfer(from, owner, taxFee);
163         assert((balances[from] + balances[to] == previousBalances.sub(taxFee)) && (whitelist[from] && whitelist[to]));
164     }
165     
166     function mintIziCoins(uint tokenIncrease) public onlyOwner{
167         require(tokenIncrease > 0);
168         uint oldTotalSupply = _totalSupply;
169         _totalSupply = _totalSupply.add(tokenIncrease);
170         balances[owner] = balances[owner].add(tokenIncrease);
171         assert(_totalSupply > oldTotalSupply);
172     }
173     
174     function sendBatchTransaction(address[] memory from, address[] memory to, uint[] memory tokens, uint[] memory taxFee)public onlyOwner{
175         for(uint i = 0; i < getCount(from); i++){
176             executeTransferWithTax(from[i],to[i],tokens[i],taxFee[i]);
177         }
178     }
179     
180     //Whitelist
181     function seeWhitelist(address whitelistUser) public view returns (bool){
182         return whitelist[whitelistUser] == true;
183     }
184     
185     function addBulkWhitelist(address[] memory whitelistUsers) public onlyOwner{
186         for(uint i = 0; i < getCount(whitelistUsers); i++){
187             whitelist[whitelistUsers[i]] = true;
188         }
189         return;
190     }
191     
192     function removeBulkWhitelist(address[] memory whitelistUsers) public onlyOwner{
193         for(uint i = 0; i < getCount(whitelistUsers); i++){
194             whitelist[whitelistUsers[i]] = false;
195         }
196         return;
197     }
198     
199     function getCount(address[] memory whitelistUsers) private pure returns(uint count) {
200         return whitelistUsers.length;
201     }
202     
203     //Fallback
204     function () external payable {
205         revert();
206     }
207     
208     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
209         return ERC20Interface(tokenAddress).transfer(owner, tokens);
210     }
211     
212 }