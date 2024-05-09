1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 // DLE 'Daleone' token contract
5 //
6 // Potential buyers of this token are encouraged to perform their due diligence
7 // on the business proposition and individuals behind this token
8 //
9 // Deployed to : 0xCDcaB3C098870fd305BB415259240A3a3E480D91
10 // Symbol      : DLE
11 // Name        : Daleone
12 // Total supply: 10 million
13 // Decimals    : 18
14 //
15 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // ERC Token Standard #20 Interface
21 // https://github.com/ethereum/EIPs/issues/20
22 // ----------------------------------------------------------------------------
23 contract ERC20Interface {
24     uint public totalSupply;
25     function balanceOf(address _owner) constant returns (uint balance);
26     function transfer(address _to, uint _value) returns (bool success);
27     function transferFrom(address _from, address _to, uint _value)
28         returns (bool success);
29     function approve(address _spender, uint _value) returns (bool success);
30     function allowance(address _owner, address _spender) constant
31         returns (uint remaining);
32     event Transfer(address indexed _from, address indexed _to, uint _value);
33     event Approval(address indexed _owner, address indexed _spender,
34         uint _value);
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // Owned contract
40 // ----------------------------------------------------------------------------
41 contract Owned {
42 
43     // ------------------------------------------------------------------------
44     // Current owner, and proposed new owner
45     // ------------------------------------------------------------------------
46     address public owner;
47     address public newOwner;
48 
49     // ------------------------------------------------------------------------
50     // Constructor - assign creator as the owner
51     // ------------------------------------------------------------------------
52     function Owned() {
53         owner = msg.sender;
54     }
55 
56 
57     // ------------------------------------------------------------------------
58     // Modifier to mark that a function can only be executed by the owner
59     // ------------------------------------------------------------------------
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65 
66     // ------------------------------------------------------------------------
67     // Owner can initiate transfer of contract to a new owner
68     // ------------------------------------------------------------------------
69     function transferOwnership(address _newOwner) onlyOwner {
70         newOwner = _newOwner;
71     }
72 
73 
74     // ------------------------------------------------------------------------
75     // New owner has to accept transfer of contract
76     // ------------------------------------------------------------------------
77     function acceptOwnership() {
78         require(msg.sender == newOwner);
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = 0x0;
82     }
83     event OwnershipTransferred(address indexed _from, address indexed _to);
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // Safe maths, borrowed from OpenZeppelin
89 // ----------------------------------------------------------------------------
90 library SafeMath {
91 
92     // ------------------------------------------------------------------------
93     // Add a number to another number, checking for overflows
94     // ------------------------------------------------------------------------
95     function add(uint a, uint b) internal returns (uint) {
96         uint c = a + b;
97         assert(c >= a && c >= b);
98         return c;
99     }
100 
101     // ------------------------------------------------------------------------
102     // Subtract a number from another number, checking for underflows
103     // ------------------------------------------------------------------------
104     function sub(uint a, uint b) internal returns (uint) {
105         assert(b <= a);
106         return a - b;
107     }
108 }
109 
110 
111 // ----------------------------------------------------------------------------
112 // ERC20 Token, with the addition of symbol, name and decimals
113 // ----------------------------------------------------------------------------
114 contract DaleoneToken is ERC20Interface, Owned {
115     using SafeMath for uint;
116 
117     // ------------------------------------------------------------------------
118     // Token parameters
119     // ------------------------------------------------------------------------
120     string public constant symbol = "DLE";
121     string public constant name = "Daleone";
122     uint8 public constant decimals = 18;
123 
124     uint public constant totalSupply = 10 * 10**6 * 10**18;
125 
126     // ------------------------------------------------------------------------
127     // Balances for each account
128     // ------------------------------------------------------------------------
129     mapping(address => uint) balances;
130 
131     // ------------------------------------------------------------------------
132     // Owner of account approves the transfer of an amount to another account
133     // ------------------------------------------------------------------------
134     mapping(address => mapping (address => uint)) allowed;
135 
136 
137     // ------------------------------------------------------------------------
138     // Constructor
139     // ------------------------------------------------------------------------
140     function DaleoneToken() Owned() {
141         balances[owner] = totalSupply;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Get the account balance of another account with address _owner
147     // ------------------------------------------------------------------------
148     function balanceOf(address _owner) constant returns (uint balance) {
149         return balances[_owner];
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer the balance from owner's account to another account
155     // ------------------------------------------------------------------------
156     function transfer(address _to, uint _amount) returns (bool success) {
157         if (balances[msg.sender] >= _amount             // User has balance
158             && _amount > 0                              // Non-zero transfer
159             && balances[_to] + _amount > balances[_to]  // Overflow check
160         ) {
161             balances[msg.sender] = balances[msg.sender].sub(_amount);
162             balances[_to] = balances[_to].add(_amount);
163             Transfer(msg.sender, _to, _amount);
164             return true;
165         } else {
166             return false;
167         }
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Allow _spender to withdraw from your account, multiple times, up to the
173     // _value amount. If this function is called again it overwrites the
174     // current allowance with _value.
175     // ------------------------------------------------------------------------
176     function approve(
177         address _spender,
178         uint _amount
179     ) returns (bool success) {
180         allowed[msg.sender][_spender] = _amount;
181         Approval(msg.sender, _spender, _amount);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Spender of tokens transfer an amount of tokens from the token owner's
188     // balance to another account. The owner of the tokens must already
189     // have approve(...)-d this transfer
190     // ------------------------------------------------------------------------
191     function transferFrom(
192         address _from,
193         address _to,
194         uint _amount
195     ) returns (bool success) {
196         if (balances[_from] >= _amount                  // From a/c has balance
197             && allowed[_from][msg.sender] >= _amount    // Transfer approved
198             && _amount > 0                              // Non-zero transfer
199             && balances[_to] + _amount > balances[_to]  // Overflow check
200         ) {
201             balances[_from] = balances[_from].sub(_amount);
202             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
203             balances[_to] = balances[_to].add(_amount);
204             Transfer(_from, _to, _amount);
205             return true;
206         } else {
207             return false;
208         }
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Returns the amount of tokens approved by the owner that can be
214     // transferred to the spender's account
215     // ------------------------------------------------------------------------
216     function allowance(
217         address _owner,
218         address _spender
219     ) constant returns (uint remaining) {
220         return allowed[_owner][_spender];
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Don't accept ethers - no payable modifier
226     // ------------------------------------------------------------------------
227     function () {
228     }
229 
230 
231     // ------------------------------------------------------------------------
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ------------------------------------------------------------------------
234     function transferAnyERC20Token(address tokenAddress, uint amount)
235       onlyOwner returns (bool success)
236     {
237         return ERC20Interface(tokenAddress).transfer(owner, amount);
238     }
239 }