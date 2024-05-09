1 pragma solidity ^0.5.11; //compiles with 0.5.0 and above
2 
3 // ----------------------------------------------------------------------------
4 // 'XQC' token contract
5 //
6 // Symbol      : XQC
7 // Name        : Quras Token
8 // Total supply: 888888888
9 // Decimals    : 8
10 //
11 // The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {	//contract --> library : compiler version up
19     function add(uint a, uint b) internal pure returns (uint c) {	//public -> internal : compiler version up
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {	//public -> internal : compiler version up
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {	//public -> internal : compiler version up
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {	//public -> internal : compiler version up
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public view returns (uint);							//constant -> view : compiler version up
44     function balanceOf(address tokenOwner) public view returns (uint balance);				//constant -> view : compiler version up
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);	//constant -> view : compiler version up
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;	//bytes -> memory : compiler version up
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     constructor() public {		//function Owned -> constructor : compiler version up
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);	//add emit : compiler version up
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals and assisted
97 // fixed supply
98 // ----------------------------------------------------------------------------
99 contract QurasToken is ERC20Interface, Owned {		//SafeMath -> using SafeMath for uint; : compiler version up
100     using SafeMath for uint;
101 
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint _totalSupply;			//unit public -> uint : compiler version up
106 
107     mapping(address => uint) balances;
108     mapping(address => mapping(address => uint)) allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     constructor() public {		//function -> constructor : compiler version up
115         symbol = "XQC";
116         name = "Quras Token";
117         decimals = 8;
118         _totalSupply = 88888888800000000;
119         balances[owner] = _totalSupply;		//direct address -> owner  : compiler version up
120         emit Transfer(address(0), owner, _totalSupply);		//add emit, direct address -> owner : compiler version up
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public view returns (uint) {		//constant -> view : compiler version up
128         return _totalSupply.sub(balances[address(0)]);
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account `tokenOwner`
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public view returns (uint balance) {		//constant -> view : compiler version up
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to `to` account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = balances[msg.sender].sub(tokens);
147         balances[to] = balances[to].add(tokens);
148         emit Transfer(msg.sender, to, tokens);		//add emit : compiler version up
149         return true;
150     }
151 
152 
153     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
154         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158     
159     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
160         uint oldValue = allowed[msg.sender][_spender];
161         if (_subtractedValue > oldValue) {
162             allowed[msg.sender][_spender] = 0;
163         } else {
164             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165         }
166         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167         return true;
168     }
169     
170     
171     // ------------------------------------------------------------------------
172     // Token owner can approve for `spender` to transferFrom(...) `tokens`
173     // from the token owner's account
174     //
175     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
176     // recommends that there are no checks for the approval double-spend attack
177     // as this should be implemented in user interfaces
178     // ------------------------------------------------------------------------
179     function approve(address spender, uint tokens) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         emit Approval(msg.sender, spender, tokens);		//add emit : compiler version up
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Transfer `tokens` from the `from` account to the `to` account
188     //
189     // The calling account must already have sufficient tokens approve(...)-d
190     // for spending from the `from` account and
191     // - From account must have sufficient balance to transfer
192     // - Spender must have sufficient allowance to transfer
193     // - 0 value transfers are allowed
194     // ------------------------------------------------------------------------
195     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
196         balances[from] = balances[from].sub(tokens);
197         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
198         balances[to] = balances[to].add(tokens);
199         emit Transfer(from, to, tokens);		//add emit : compiler version up
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Returns the amount of tokens approved by the owner that can be
206     // transferred to the spender's account
207     // ------------------------------------------------------------------------
208     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {		//constant -> view : compiler version up
209         return allowed[tokenOwner][spender];
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Token owner can approve for `spender` to transferFrom(...) `tokens`
215     // from the token owner's account. The `spender` contract function
216     // `receiveApproval(...)` is then executed
217     // ------------------------------------------------------------------------
218     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);		//add emit : compiler version up
221         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
222         return true;
223     }
224 
225 
226     // ------------------------------------------------------------------------
227     // Owner can transfer out any accidentally sent ERC20 tokens
228     // ------------------------------------------------------------------------
229     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
230         return ERC20Interface(tokenAddress).transfer(owner, tokens);
231     }
232 }