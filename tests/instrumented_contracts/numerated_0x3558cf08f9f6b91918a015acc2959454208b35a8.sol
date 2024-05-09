1 pragma solidity ^0.4.24;
2  // ----------------------------------------------------------------------------
3  // Safe maths
4  // ----------------------------------------------------------------------------
5  library SafeMath {
6      function add(uint a, uint b) internal pure returns (uint c) {
7          c = a + b;
8          require(c >= a);
9      }
10      function sub(uint a, uint b) internal pure returns (uint c) {
11          require(b <= a);
12          c = a - b;
13      }
14      function mul(uint a, uint b) internal pure returns (uint c) {
15          c = a * b;
16          require(a == 0 || c / a == b);
17      }
18      function div(uint a, uint b) internal pure returns (uint c) {
19          require(b > 0);
20          c = a / b;
21      }
22  }
23  
24  
25  // ----------------------------------------------------------------------------
26  // ERC Token Standard #20 Interface
27  // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
28  // ----------------------------------------------------------------------------
29  contract ERC20Interface {
30      function totalSupply() public constant returns (uint);
31      function balanceOf(address tokenOwner) public constant returns (uint balance);
32      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33      function transfer(address to, uint tokens) public returns (bool success);
34      function approve(address spender, uint tokens) public returns (bool success);
35      function transferFrom(address from, address to, uint tokens) public returns (bool success);
36  
37      event Transfer(address indexed from, address indexed to, uint tokens);
38      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39  }
40  
41  
42  // ----------------------------------------------------------------------------
43  // Contract function to receive approval and execute function in one call
44  //
45  // Borrowed from MiniMeToken
46  // ----------------------------------------------------------------------------
47  contract ApproveAndCallFallBack {
48      function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49  }
50  
51  
52  // ----------------------------------------------------------------------------
53  // Owned contract
54  // ----------------------------------------------------------------------------
55  contract Owned {
56      address public owner;
57      address public newOwner;
58  
59      event OwnershipTransferred(address indexed _from, address indexed _to);
60  
61      constructor() public {
62          owner = msg.sender;
63      }
64  
65      modifier onlyOwner {
66          require(msg.sender == owner);
67          _;
68      }
69  
70      function transferOwnership(address _newOwner) public onlyOwner {
71          newOwner = _newOwner;
72      }
73      function acceptOwnership() public {
74          require(msg.sender == newOwner);
75          emit OwnershipTransferred(owner, newOwner);
76          owner = newOwner;
77          newOwner = address(0);
78      }
79  }
80  
81  
82  // ----------------------------------------------------------------------------
83  // ERC20 Token, with the addition of symbol, name and decimals and a
84  // fixed supply
85  // ----------------------------------------------------------------------------
86  contract WFTToken is ERC20Interface, Owned {
87      using SafeMath for uint;
88  
89      string public symbol;
90      string public  name;
91      uint8 public decimals;
92      uint _totalSupply;
93  
94      mapping(address => uint) balances;
95      mapping(address => mapping(address => uint)) allowed;
96      mapping (address => uint256) public frozenAccount;
97  
98      // ------------------------------------------------------------------------
99      // Constructor
100      // ------------------------------------------------------------------------
101      constructor() public {
102          symbol = "WFT";
103          name = "Wifi Chain Token";
104          decimals = 8;
105          _totalSupply = 10000000000 * 10**uint(decimals);
106          balances[0xfd76e9d8b164f92fdd7dee579cf8ab94c7bf79c0] =  _totalSupply.mul(65).div(100);
107          balances[0x96584a6da52efbb210a0ef8e2f89056c1b41eac2] = _totalSupply.mul(35).div(100);
108          emit Transfer(address(0), owner, _totalSupply);
109      }
110 
111      // ------------------------------------------------------------------------
112      // Total supply
113      // ------------------------------------------------------------------------
114      function totalSupply() public view returns (uint) {
115          return _totalSupply.sub(balances[address(0)]);
116      }
117  
118  
119      // ------------------------------------------------------------------------
120      // Get the token balance for account `tokenOwner`
121      // ------------------------------------------------------------------------
122      function balanceOf(address tokenOwner) public view returns (uint balance) {
123          return balances[tokenOwner];
124      }
125  
126  
127      // ------------------------------------------------------------------------
128      // Transfer the balance from token owner's account to `to` account
129      // - Owner's account must have sufficient balance to transfer
130      // - 0 value transfers are allowed
131      // ------------------------------------------------------------------------
132      function transfer(address to, uint tokens) public returns (bool success) {
133          require(frozenAccount[msg.sender] < now );
134          balances[msg.sender] = balances[msg.sender].sub(tokens);
135          balances[to] = balances[to].add(tokens);
136          emit Transfer(msg.sender, to, tokens);
137          return true;
138      }
139  
140  
141      // ------------------------------------------------------------------------
142      // Token owner can approve for `spender` to transferFrom(...) `tokens`
143      // from the token owner's account
144      //
145      // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
146      // recommends that there are no checks for the approval double-spend attack
147      // as this should be implemented in user interfaces 
148      // ------------------------------------------------------------------------
149      function approve(address spender, uint tokens) public returns (bool success) {
150          allowed[msg.sender][spender] = tokens;
151          emit Approval(msg.sender, spender, tokens);
152          return true;
153      }
154  
155  
156      // ------------------------------------------------------------------------
157      // Transfer `tokens` from the `from` account to the `to` account
158      // 
159      // The calling account must already have sufficient tokens approve(...)-d
160      // for spending from the `from` account and
161      // - From account must have sufficient balance to transfer
162      // - Spender must have sufficient allowance to transfer
163      // - 0 value transfers are allowed
164      // ------------------------------------------------------------------------
165      function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166          balances[from] = balances[from].sub(tokens);
167          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
168          balances[to] = balances[to].add(tokens);
169          emit Transfer(from, to, tokens);
170          return true;
171      }
172  
173  
174      // ------------------------------------------------------------------------
175      // Returns the amount of tokens approved by the owner that can be
176      // transferred to the spender's account
177      // ------------------------------------------------------------------------
178      function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
179          return allowed[tokenOwner][spender];
180      }
181  
182  
183      // ------------------------------------------------------------------------
184      // Token owner can approve for `spender` to transferFrom(...) `tokens`
185      // from the token owner's account. The `spender` contract function
186      // `receiveApproval(...)` is then executed
187      // ------------------------------------------------------------------------
188      function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
189          allowed[msg.sender][spender] = tokens;
190          emit Approval(msg.sender, spender, tokens);
191          ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
192          return true;
193      }
194  
195  
196      // ------------------------------------------------------------------------
197      // Don't accept ETH
198      // ------------------------------------------------------------------------
199      function () public payable {
200          revert();
201      }
202  
203  
204      // ------------------------------------------------------------------------
205      // Owner can transfer out any accidentally sent ERC20 tokens
206      // ------------------------------------------------------------------------
207      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
208          return ERC20Interface(tokenAddress).transfer(owner, tokens);
209      }
210 
211     
212     //freeze account
213     function freezeWithTimestamp(address target,uint256 timestamp)public onlyOwner returns (bool) {
214         frozenAccount[target] = timestamp;
215         return true;
216     }
217     
218      //multi freeze account
219     function multiFreezeWithTimestamp(address[] targets,uint256[] timestamps)public onlyOwner returns (bool) {
220         uint256 len = targets.length;
221         require(len > 0);
222         require(len == timestamps.length);
223         for (uint256 i = 0; i < len; i = i.add(1)) {
224             frozenAccount[targets[i]] = timestamps[i];
225         }
226         return true;
227     }
228 
229  }