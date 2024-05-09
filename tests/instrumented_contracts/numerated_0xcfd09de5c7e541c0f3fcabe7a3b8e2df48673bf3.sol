1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36     
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // Owned contract
44 // ----------------------------------------------------------------------------
45 contract Owned {
46     address public owner;
47     
48     function Owned() public{
49         owner = msg.sender;
50     }
51     
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 }
57 
58 // ----------------------------------------------------------------------------
59 // Whitelisted contract
60 // ----------------------------------------------------------------------------
61 contract Whitelist is Owned {
62     mapping (address => WElement) public whitelist;
63     mapping (address => RWElement) public regulatorWhitelist;
64     
65     event LogAddressEnabled(address indexed who);
66     event LogAddressDisabled(address indexed who);
67     event LogRegulatorEnabled(address indexed who);
68     event LogRegulatorDisabled(address indexed who);
69     
70     struct WElement{
71         bool enable;
72         address regulator;
73     }
74     
75     struct RWElement{
76         bool enable;
77         string name;
78     }
79     
80     modifier onlyWhitelisted() {
81         whitelisted(msg.sender);
82         _;
83     }
84     
85     modifier onlyRegulator() {
86         require(regulatorWhitelist[msg.sender].enable);
87         _;
88     }
89     
90     function whitelisted(address who) view internal{
91         require(whitelist[who].enable);
92         require(regulatorWhitelist[whitelist[who].regulator].enable);
93     }
94     
95     function enableRegulator(address who, string _name) onlyOwner public returns (bool success){
96         require(who!=address(0));
97         require(who!=address(this));
98         regulatorWhitelist[who].enable = true;
99         regulatorWhitelist[who].name = _name;
100         emit LogRegulatorEnabled(who);
101         return true;
102     }
103     
104     function disableRegulator(address who) onlyOwner public returns (bool success){
105         require(who!=owner);
106         regulatorWhitelist[who].enable = false;
107         emit LogRegulatorDisabled(who);
108         return true;
109     }
110     
111     //un regulator può abilitare un address di un altro regulator? --> per noi NO
112     function enableAddress(address who) onlyRegulator public returns (bool success){
113         require(who!=address(0));
114         require(who!=address(this));
115         whitelist[who].enable = true;
116         whitelist[who].regulator = msg.sender;
117         emit LogAddressEnabled(who);
118         return true;
119     }
120     //un regulator può disabilitare un address di un altro regulator?
121     function disableAddress(address who) onlyRegulator public returns (bool success){
122         require(who!=owner);
123         require(whitelist[who].regulator != address(0));
124         whitelist[who].enable = false;
125         emit LogAddressDisabled(who);
126         return true;
127     }
128 }
129 
130 contract Marcellocoin is ERC20Interface, Whitelist{
131     using SafeMath for uint256;
132     
133     string public symbol;
134     string public name;
135     uint8 public decimals;
136     uint256 _totalSupply;
137 
138     mapping(address => uint256) balances;
139     mapping(address => mapping(address => uint256)) allowed;
140     
141     // ------------------------------------------------------------------------
142     // Constructor
143     // ------------------------------------------------------------------------
144 
145     function Marcellocoin() public {
146         symbol = "MARCI";
147         name = "Marcellocoin is the future";
148         decimals = 10;
149         _totalSupply = 500000000 * 10**uint256(decimals);
150         balances[owner] = _totalSupply;
151         
152         enableRegulator(owner, "Marcellocoin Owner");
153         enableAddress(owner);
154         emit Transfer(address(0), owner, _totalSupply);
155     }
156     
157     // ------------------------------------------------------------------------
158     // Total supply
159     // ------------------------------------------------------------------------
160     function totalSupply() public constant returns (uint256) {
161         return _totalSupply;
162     }
163     
164     // ------------------------------------------------------------------------
165     // Get the token balance for account `tokenOwner`
166     // ------------------------------------------------------------------------
167     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
168         return balances[tokenOwner];
169     }
170 
171     // ------------------------------------------------------------------------
172     // Transfer the balance from token owner's account to `to` account
173     // - Owner's account must have sufficient balance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transfer(address to, uint256 tokens) onlyWhitelisted public returns (bool success){
177         whitelisted(to);
178         balances[msg.sender] = balances[msg.sender].sub(tokens);
179         balances[to] = balances[to].add(tokens);
180         emit Transfer(msg.sender, to, tokens);
181         return true;
182     }
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for `spender` to transferFrom(...) `tokens`
186     // from the token owner's account
187     //
188     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
189     // recommends that there are no checks for the approval double-spend attack
190     // as this should be implemented in user interfaces 
191     // ------------------------------------------------------------------------
192     function approve(address spender, uint256 tokens) onlyWhitelisted public returns (bool success) {
193         whitelisted(spender);
194         allowed[msg.sender][spender] = tokens;
195         emit Approval(msg.sender, spender, tokens);
196         return true;
197     }
198 
199     // ------------------------------------------------------------------------
200     // Transfer `tokens` from the `from` account to the `to` account
201     // 
202     // The calling account must already have sufficient tokens approve(...)-d
203     // for spending from the `from` account and
204     // - From account must have sufficient balance to transfer
205     // - Spender must have sufficient allowance to transfer
206     // - 0 value transfers are allowed
207     // ------------------------------------------------------------------------
208     function transferFrom(address from, address to, uint256 tokens) onlyWhitelisted public returns (bool success) {
209         whitelisted(from);
210         whitelisted(to);
211         balances[from] = balances[from].sub(tokens);
212         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
213         balances[to] = balances[to].add(tokens);
214         emit Transfer(from, to, tokens);
215         return true;
216     }
217 
218     // ------------------------------------------------------------------------
219     // Returns the amount of tokens approved by the owner that can be
220     // transferred to the spender's account
221     // ------------------------------------------------------------------------
222     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
223         return allowed[tokenOwner][spender];
224     }
225     
226     // ------------------------------------------------------------------------
227     // Don't accept ETH
228     // ------------------------------------------------------------------------
229     function () public payable {
230         revert();
231     }
232 
233 }