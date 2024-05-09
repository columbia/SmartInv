1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // Dao.Casino Crowdsale Token Contract
5 //
6 // NOTE: This is the new Dao.Casino token contract as the old Dao.Casino
7 //       crowdsale/token contract was attached to a buggy Parity multisig that
8 //       was vulnerable to hackers
9 //
10 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd for Dao.Casino 2017
11 // The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths, borrowed from OpenZeppelin
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19 
20     // ------------------------------------------------------------------------
21     // Add a number to another number, checking for overflows
22     // ------------------------------------------------------------------------
23     function add(uint a, uint b) internal returns (uint) {
24         uint c = a + b;
25         assert(c >= a && c >= b);
26         return c;
27     }
28 
29     // ------------------------------------------------------------------------
30     // Subtract a number from another number, checking for underflows
31     // ------------------------------------------------------------------------
32     function sub(uint a, uint b) internal returns (uint) {
33         assert(b <= a);
34         return a - b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // Owned contract
41 // ----------------------------------------------------------------------------
42 contract Owned {
43     address public owner;
44     address public newOwner;
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     function Owned() {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) onlyOwner {
57         newOwner = _newOwner;
58     }
59  
60     function acceptOwnership() {
61         if (msg.sender == newOwner) {
62             OwnershipTransferred(owner, newOwner);
63             owner = newOwner;
64         }
65     }
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // ERC20 Token, with the addition of symbol, name and decimals
71 // https://github.com/ethereum/EIPs/issues/20
72 // ----------------------------------------------------------------------------
73 contract ERC20Token {
74     using SafeMath for uint;
75 
76     // ------------------------------------------------------------------------
77     // Total Supply
78     // ------------------------------------------------------------------------
79     uint256 _totalSupply = 0;
80 
81     // ------------------------------------------------------------------------
82     // Balances for each account
83     // ------------------------------------------------------------------------
84     mapping(address => uint256) balances;
85 
86     // ------------------------------------------------------------------------
87     // Owner of account approves the transfer of an amount to another account
88     // ------------------------------------------------------------------------
89     mapping(address => mapping (address => uint256)) allowed;
90 
91     // ------------------------------------------------------------------------
92     // Get the total token supply
93     // ------------------------------------------------------------------------
94     function totalSupply() constant returns (uint256 totalSupply) {
95         totalSupply = _totalSupply;
96     }
97 
98     // ------------------------------------------------------------------------
99     // Get the account balance of another account with address _owner
100     // ------------------------------------------------------------------------
101     function balanceOf(address _owner) constant returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     // ------------------------------------------------------------------------
106     // Transfer the balance from owner's account to another account
107     // ------------------------------------------------------------------------
108     function transfer(address _to, uint256 _amount) returns (bool success) {
109         if (balances[msg.sender] >= _amount                // User has balance
110             && _amount > 0                                 // Non-zero transfer
111             && balances[_to] + _amount > balances[_to]     // Overflow check
112         ) {
113             balances[msg.sender] = balances[msg.sender].sub(_amount);
114             balances[_to] = balances[_to].add(_amount);
115             Transfer(msg.sender, _to, _amount);
116             return true;
117         } else {
118             return false;
119         }
120     }
121 
122     // ------------------------------------------------------------------------
123     // Allow _spender to withdraw from your account, multiple times, up to the
124     // _value amount. If this function is called again it overwrites the
125     // current allowance with _value.
126     // ------------------------------------------------------------------------
127     function approve(
128         address _spender,
129         uint256 _amount
130     ) returns (bool success) {
131         // Borrowed from the MiniMeToken contract
132         // To change the approve amount you first have to reduce the addresses`
133         //  allowance to zero by calling `approve(_spender,0)` if it is not
134         //  already 0 to mitigate the race condition described here:
135         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
137 
138         allowed[msg.sender][_spender] = _amount;
139         Approval(msg.sender, _spender, _amount);
140         return true;
141     }
142 
143     // ------------------------------------------------------------------------
144     // Spender of tokens transfer an amount of tokens from the token owner's
145     // balance to the spender's account. The owner of the tokens must already
146     // have approve(...)-d this transfer
147     // ------------------------------------------------------------------------
148     function transferFrom(
149         address _from,
150         address _to,
151         uint256 _amount
152     ) returns (bool success) {
153         if (balances[_from] >= _amount                  // From a/c has balance
154             && allowed[_from][msg.sender] >= _amount    // Transfer approved
155             && _amount > 0                              // Non-zero transfer
156             && balances[_to] + _amount > balances[_to]  // Overflow check
157         ) {
158             balances[_from] = balances[_from].sub(_amount);
159             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
160             balances[_to] = balances[_to].add(_amount);
161             Transfer(_from, _to, _amount);
162             return true;
163         } else {
164             return false;
165         }
166     }
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(
173         address _owner, 
174         address _spender
175     ) constant returns (uint256 remaining) {
176         return allowed[_owner][_spender];
177     }
178 
179     event Transfer(address indexed _from, address indexed _to, uint256 _value);
180     event Approval(address indexed _owner, address indexed _spender,
181         uint256 _value);
182 }
183 
184 
185 contract DaoCasinoToken is ERC20Token, Owned {
186 
187     // ------------------------------------------------------------------------
188     // Token information
189     // ------------------------------------------------------------------------
190     string public constant name = "Dao.Casino";
191     string public constant symbol = "BET";
192     uint8 public constant decimals = 18;
193 
194     function DaoCasinoToken() {
195     }
196 
197     // ------------------------------------------------------------------------
198     // Fill - to populate tokens from the old token contract
199     // ------------------------------------------------------------------------
200     // From https://github.com/BitySA/whetcwithdraw/tree/master/daobalance
201     bool public sealed;
202     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
203     // The 160 LSB is the address of the balance
204     // The 96 MSB is the balance of that address.
205     function fill(uint256[] data) onlyOwner {
206         require(!sealed);
207         for (uint256 i = 0; i < data.length; i++) {
208             address account = address(data[i] & (D160-1));
209             uint256 amount = data[i] / D160;
210             // Prevent duplicates
211             if (balances[account] == 0) {
212                 balances[account] = amount;
213                 _totalSupply = _totalSupply.add(amount);
214                 Transfer(0x0, account, amount);
215             }
216         }
217     }
218 
219     // ------------------------------------------------------------------------
220     // After sealing, no more filling is possible
221     // ------------------------------------------------------------------------
222     function seal() onlyOwner {
223         require(!sealed);
224         sealed = true;
225     }
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint amount)
231       onlyOwner returns (bool success) 
232     {
233         return ERC20Token(tokenAddress).transfer(owner, amount);
234     }
235 }