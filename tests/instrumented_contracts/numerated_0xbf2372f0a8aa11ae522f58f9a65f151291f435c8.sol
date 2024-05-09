1 pragma solidity ^0.4.18;
2 
3  // ----------------------------------------------------------------------------
4  // Safe maths
5  // ----------------------------------------------------------------------------
6  library SafeMath {
7      function add(uint a, uint b) internal pure returns (uint c) {
8          c = a + b;
9          require(c >= a);
10      }
11      function sub(uint a, uint b) internal pure returns (uint c) {
12          require(b <= a);
13          c = a - b;
14      }
15      function mul(uint a, uint b) internal pure returns (uint c) {
16          c = a * b;
17          require(a == 0 || c / a == b);
18      }
19      function div(uint a, uint b) internal pure returns (uint c) {
20          require(b > 0);
21          c = a / b;
22      }
23  }
24  
25  
26  // ----------------------------------------------------------------------------
27  // ERC Token Standard #20 Interface
28  // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29  // ----------------------------------------------------------------------------
30  contract ERC20Interface {
31      function totalSupply() public constant returns (uint);
32      function balanceOf(address tokenOwner) public constant returns (uint balance);
33      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34      function transfer(address to, uint tokens) public returns (bool success);
35      function approve(address spender, uint tokens) public returns (bool success);
36      function transferFrom(address from, address to, uint tokens) public returns (bool success);
37  
38      event Transfer(address indexed from, address indexed to, uint tokens);
39      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40  }
41  
42  
43  // ----------------------------------------------------------------------------
44  // Contract function to receive approval and execute function in one call
45  //
46  // Borrowed from MiniMeToken
47  // ----------------------------------------------------------------------------
48  contract ApproveAndCallFallBack {
49      function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50  }
51  
52  
53  // ----------------------------------------------------------------------------
54  // Owned contract
55  // ----------------------------------------------------------------------------
56  contract Owned {
57      address public owner;
58      address public newOwner;
59  
60      event OwnershipTransferred(address indexed _from, address indexed _to);
61  
62      function Owned() public {
63          owner = msg.sender;
64      }
65  
66      modifier onlyOwner {
67          require(msg.sender == owner);
68          _;
69      }
70  
71      function transferOwnership(address _newOwner) public onlyOwner {
72          newOwner = _newOwner;
73      }
74      function acceptOwnership() public {
75          require(msg.sender == newOwner);
76          OwnershipTransferred(owner, newOwner);
77          owner = newOwner;
78          newOwner = address(0);
79      }
80  }
81  
82  
83  // ----------------------------------------------------------------------------
84  // ERC20 Token, with the addition of symbol, name and decimals and an
85  // initial fixed supply
86  // ----------------------------------------------------------------------------
87  contract Airdroster is ERC20Interface, Owned {
88      using SafeMath for uint;
89  
90      string public symbol;
91      string public  name;
92      uint8 public decimals;
93      uint public _totalSupply;
94  
95      mapping(address => uint) balances;
96      mapping(address => mapping(address => uint)) allowed;
97      mapping(address => transferInStruct[]) transferIns;
98 
99  
100     struct transferInStruct{
101     uint128 amount;
102     uint64 time;
103     }
104     
105      // ------------------------------------------------------------------------
106      // Constructor
107      // ------------------------------------------------------------------------
108      function Airdroster() public {
109          symbol = "STER";
110          name = "Airdropster";
111          decimals = 18;
112          _totalSupply = 1000000000 * 10**uint(decimals);
113          balances[owner] = _totalSupply;
114          Transfer(address(0), owner, _totalSupply);
115      }
116  
117  
118      // ------------------------------------------------------------------------
119      // Total supply
120      // ------------------------------------------------------------------------
121      function totalSupply() public constant returns (uint) {
122          return _totalSupply  - balances[address(0)];
123      }
124  
125  
126      // ------------------------------------------------------------------------
127      // Get the token balance for account `tokenOwner`
128      // ------------------------------------------------------------------------
129      function balanceOf(address tokenOwner) public constant returns (uint balance) {
130          return balances[tokenOwner];
131      }
132  
133  
134      // ------------------------------------------------------------------------
135      // Transfer the balance from token owner's account to `to` account
136      // - Owner's account must have sufficient balance to transfer
137      // - 0 value transfers are allowed
138      // ------------------------------------------------------------------------
139      function transfer(address to, uint tokens) public returns (bool success) {
140          balances[msg.sender] = balances[msg.sender].sub(tokens);
141          balances[to] = balances[to].add(tokens);
142          Transfer(msg.sender, to, tokens);
143          return true;
144      }
145  
146  
147      // ------------------------------------------------------------------------
148      // Token owner can approve for `spender` to transferFrom(...) `tokens`
149      // from the token owner's account
150      //
151      // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
152      // recommends that there are no checks for the approval double-spend attack
153      // as this should be implemented in user interfaces 
154      // ------------------------------------------------------------------------
155      function approve(address spender, uint tokens) public returns (bool success) {
156          allowed[msg.sender][spender] = tokens;
157          Approval(msg.sender, spender, tokens);
158          return true;
159      }
160  
161  
162      // ------------------------------------------------------------------------
163      // Transfer `tokens` from the `from` account to the `to` account
164      // 
165      // The calling account must already have sufficient tokens approve(...)-d
166      // for spending from the `from` account and
167      // - From account must have sufficient balance to transfer
168      // - Spender must have sufficient allowance to transfer
169      // - 0 value transfers are allowed
170      // ------------------------------------------------------------------------
171      function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172          balances[from] = balances[from].sub(tokens);
173          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
174          balances[to] = balances[to].add(tokens);
175          Transfer(from, to, tokens);
176          return true;
177      }
178  
179  
180      // ------------------------------------------------------------------------
181      // Returns the amount of tokens approved by the owner that can be
182      // transferred to the spender's account
183      // ------------------------------------------------------------------------
184      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185          return allowed[tokenOwner][spender];
186      }
187  
188  
189      // ------------------------------------------------------------------------
190      // Token owner can approve for `spender` to transferFrom(...) `tokens`
191      // from the token owner's account. The `spender` contract function
192      // `receiveApproval(...)` is then executed
193      // ------------------------------------------------------------------------
194      function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
195          allowed[msg.sender][spender] = tokens;
196          Approval(msg.sender, spender, tokens);
197          ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
198          return true;
199      }
200  
201  
202      // ------------------------------------------------------------------------
203      // Don't accept ETH
204      // ------------------------------------------------------------------------
205      function () public payable {
206          revert();
207      }
208  
209  
210      // ------------------------------------------------------------------------
211      // Owner can transfer out any accidentally sent ERC20 tokens
212      // ------------------------------------------------------------------------
213      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
214          return ERC20Interface(tokenAddress).transfer(owner, tokens);
215      }
216      
217       function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
218         require( _recipients.length > 0 && _recipients.length == _values.length);
219 
220         uint total = 0;
221         for(uint i = 0; i < _values.length; i++){
222             total = total.add(_values[i]);
223         }
224         require(total <= balances[msg.sender]);
225 
226         uint64 _now = uint64(now);
227         for(uint j = 0; j < _recipients.length; j++){
228             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
229             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
230             Transfer(msg.sender, _recipients[j], _values[j]);
231         }
232 
233         balances[msg.sender] = balances[msg.sender].sub(total);
234         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
235         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
236 
237         return true;
238     }
239     
240 }