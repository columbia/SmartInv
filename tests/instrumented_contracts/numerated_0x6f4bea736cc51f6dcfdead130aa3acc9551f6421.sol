1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // LTN Burnable Fixed Supply token contract
6 //
7 // Symbol           : LTN
8 // Name             : LotanCoin
9 // Initial Supply   : 3,725,000,000
10 // Decimals         : 8
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe math
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public view returns (uint);
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 contract Owned {
55     address public owner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         require(_newOwner != address(0x0));
70         emit OwnershipTransferred(owner,_newOwner);
71         owner = _newOwner;
72     }
73     
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and an
79 // initial fixed supply
80 // ----------------------------------------------------------------------------
81 contract LotanCoin is ERC20Interface, Owned {
82     
83     using SafeMath for uint;
84 
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) public balances;
91     mapping(address => mapping(address => uint)) public allowed;
92     
93     event Burn(address indexed burner, uint256 value);
94     
95     
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99     constructor() public {
100         symbol = "LTN";
101         name = "LotanCoin";
102         decimals = 8;
103         _totalSupply = 3725000000 * 10**uint(decimals);
104         balances[owner] = _totalSupply;
105         emit Transfer(address(0), owner, _totalSupply);
106     }
107     
108     
109     // ------------------------------------------------------------------------
110     // Reject when someone sends ethers to this contract
111     // ------------------------------------------------------------------------
112     function() public payable {
113         revert();
114     }
115     
116     
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public view returns (uint) {
121         return _totalSupply;
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account `tokenOwner`
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public view returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to `to` account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         require(to != address(0));
140         require(tokens > 0);
141         require(balances[msg.sender] >= tokens);
142         
143         balances[msg.sender] = balances[msg.sender].sub(tokens);
144         balances[to] = balances[to].add(tokens);
145         emit Transfer(msg.sender, to, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Token owner can approve for `spender` to transferFrom(...) `tokens`
152     // from the token owner's account
153     //
154     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
155     // recommends that there are no checks for the approval double-spend attack
156     // as this should be implemented in user interfaces 
157     // ------------------------------------------------------------------------
158     function approve(address spender, uint tokens) public returns (bool success) {
159         require(spender != address(0));
160         require(tokens > 0);
161         
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     // 
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         require(from != address(0));
178         require(to != address(0));
179         require(tokens > 0);
180         require(balances[from] >= tokens);
181         require(allowed[from][msg.sender] >= tokens);
182         
183         balances[from] = balances[from].sub(tokens);
184         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
185         balances[to] = balances[to].add(tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198     
199     
200     // ------------------------------------------------------------------------
201     // Increase the amount of tokens that an owner allowed to a spender.
202     //
203     // approve should be called when allowed[_spender] == 0. To increment
204     // allowed value is better to use this function to avoid 2 calls (and wait until
205     // the first transaction is mined)
206     // _spender The address which will spend the funds.
207     // _addedValue The amount of tokens to increase the allowance by.
208     // ------------------------------------------------------------------------
209     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210         require(_spender != address(0));
211         
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216     
217     
218     // ------------------------------------------------------------------------
219     // Decrease the amount of tokens that an owner allowed to a spender.
220     //
221     // approve should be called when allowed[_spender] == 0. To decrement
222     // allowed value is better to use this function to avoid 2 calls (and wait until
223     // the first transaction is mined)
224     // From MonolithDAO Token.sol
225     // _spender The address which will spend the funds.
226     // _subtractedValue The amount of tokens to decrease the allowance by.
227     // ------------------------------------------------------------------------
228     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229         require(_spender != address(0));
230         
231         uint oldValue = allowed[msg.sender][_spender];
232         if (_subtractedValue > oldValue) {
233             allowed[msg.sender][_spender] = 0;
234         } else {
235             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236         }
237         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         return true;
239     }
240     
241     
242     // ------------------------------------------------------------------------
243     // Function to burn tokens
244     // _value The amount of tokens to burn.
245     // A boolean that indicates if the operation was successful.
246     // ------------------------------------------------------------------------
247     function burn(uint256 _value) onlyOwner public {
248       require(_value > 0);
249       require(_value <= balances[msg.sender]);
250       
251       balances[owner] = balances[owner].sub(_value);
252       _totalSupply = _totalSupply.sub(_value);
253       emit Burn(owner, _value);
254       emit Transfer(owner, address(0), _value);
255     }
256 
257 }