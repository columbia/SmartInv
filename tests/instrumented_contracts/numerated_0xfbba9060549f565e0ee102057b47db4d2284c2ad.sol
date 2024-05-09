1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // PHN 'Phillion' token contract
5 //
6 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
7 // ----------------------------------------------------------------------------
8 
9 
10 // ----------------------------------------------------------------------------
11 // ERC Token Standard #20 Interface
12 // https://github.com/ethereum/EIPs/issues/20
13 // ----------------------------------------------------------------------------
14 contract ERC20Interface {
15     uint public totalSupply;
16     function balanceOf(address _owner) constant returns (uint balance);
17     function transfer(address _to, uint _value) returns (bool success);
18     function transferFrom(address _from, address _to, uint _value) 
19         returns (bool success);
20     function approve(address _spender, uint _value) returns (bool success);
21     function allowance(address _owner, address _spender) constant 
22         returns (uint remaining);
23     event Transfer(address indexed _from, address indexed _to, uint _value);
24     event Approval(address indexed _owner, address indexed _spender, 
25         uint _value);
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // Owned contract
31 // ----------------------------------------------------------------------------
32 contract Owned {
33 
34     // ------------------------------------------------------------------------
35     // Current owner, and proposed new owner
36     // ------------------------------------------------------------------------
37     address public owner;
38     address public newOwner;
39 
40     // ------------------------------------------------------------------------
41     // Constructor - assign creator as the owner
42     // ------------------------------------------------------------------------
43     function Owned() {
44         owner = msg.sender;
45     }
46 
47 
48     // ------------------------------------------------------------------------
49     // Modifier to mark that a function can only be executed by the owner
50     // ------------------------------------------------------------------------
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56 
57     // ------------------------------------------------------------------------
58     // Owner can initiate transfer of contract to a new owner
59     // ------------------------------------------------------------------------
60     function transferOwnership(address _newOwner) onlyOwner {
61         newOwner = _newOwner;
62     }
63 
64  
65     // ------------------------------------------------------------------------
66     // New owner has to accept transfer of contract
67     // ------------------------------------------------------------------------
68     function acceptOwnership() {
69         require(msg.sender == newOwner);
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = 0x0;
73     }
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // Safe maths, borrowed from OpenZeppelin
80 // ----------------------------------------------------------------------------
81 library SafeMath {
82 
83     // ------------------------------------------------------------------------
84     // Add a number to another number, checking for overflows
85     // ------------------------------------------------------------------------
86     function add(uint a, uint b) internal returns (uint) {
87         uint c = a + b;
88         assert(c >= a && c >= b);
89         return c;
90     }
91 
92     // ------------------------------------------------------------------------
93     // Subtract a number from another number, checking for underflows
94     // ------------------------------------------------------------------------
95     function sub(uint a, uint b) internal returns (uint) {
96         assert(b <= a);
97         return a - b;
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals
104 // ----------------------------------------------------------------------------
105 contract PhillionToken is ERC20Interface, Owned {
106     using SafeMath for uint;
107 
108     // ------------------------------------------------------------------------
109     // Token parameters
110     // ------------------------------------------------------------------------
111     string public constant symbol = "PHN";
112     string public constant name = "Phillion";
113     uint8 public decimals = 18;
114     
115     uint public constant totalSupply = 5 * 10**9 * 10**18;
116 
117     // ------------------------------------------------------------------------
118     // Balances for each account
119     // ------------------------------------------------------------------------
120     mapping(address => uint) balances;
121 
122     // ------------------------------------------------------------------------
123     // Owner of account approves the transfer of an amount to another account
124     // ------------------------------------------------------------------------
125     mapping(address => mapping (address => uint)) allowed;
126 
127 
128     // ------------------------------------------------------------------------
129     // Constructor
130     // ------------------------------------------------------------------------
131     function PhillionToken() Owned() {
132         balances[owner] = totalSupply;
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the account balance of another account with address _owner
138     // ------------------------------------------------------------------------
139     function balanceOf(address _owner) constant returns (uint balance) {
140         return balances[_owner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from owner's account to another account
146     // ------------------------------------------------------------------------
147     function transfer(address _to, uint _amount) returns (bool success) {
148         if (balances[msg.sender] >= _amount             // User has balance
149             && _amount > 0                              // Non-zero transfer
150             && balances[_to] + _amount > balances[_to]  // Overflow check
151         ) {
152             balances[msg.sender] = balances[msg.sender].sub(_amount);
153             balances[_to] = balances[_to].add(_amount);
154             Transfer(msg.sender, _to, _amount);
155             return true;
156         } else {
157             return false;
158         }
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Allow _spender to withdraw from your account, multiple times, up to the
164     // _value amount. If this function is called again it overwrites the
165     // current allowance with _value.
166     // ------------------------------------------------------------------------
167     function approve(
168         address _spender,
169         uint _amount
170     ) returns (bool success) {
171         allowed[msg.sender][_spender] = _amount;
172         Approval(msg.sender, _spender, _amount);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Spender of tokens transfer an amount of tokens from the token owner's
179     // balance to another account. The owner of the tokens must already
180     // have approve(...)-d this transfer
181     // ------------------------------------------------------------------------
182     function transferFrom(
183         address _from,
184         address _to,
185         uint _amount
186     ) returns (bool success) {
187         if (balances[_from] >= _amount                  // From a/c has balance
188             && allowed[_from][msg.sender] >= _amount    // Transfer approved
189             && _amount > 0                              // Non-zero transfer
190             && balances[_to] + _amount > balances[_to]  // Overflow check
191         ) {
192             balances[_from] = balances[_from].sub(_amount);
193             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194             balances[_to] = balances[_to].add(_amount);
195             Transfer(_from, _to, _amount);
196             return true;
197         } else {
198             return false;
199         }
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Returns the amount of tokens approved by the owner that can be
205     // transferred to the spender's account
206     // ------------------------------------------------------------------------
207     function allowance(
208         address _owner, 
209         address _spender
210     ) constant returns (uint remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Don't accept ethers - no payable modifier
217     // ------------------------------------------------------------------------
218     function () {
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint amount)
226       onlyOwner returns (bool success) 
227     {
228         return ERC20Interface(tokenAddress).transfer(owner, amount);
229     }
230 }