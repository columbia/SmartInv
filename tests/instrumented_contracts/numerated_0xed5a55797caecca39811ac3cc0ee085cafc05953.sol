1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // BSN 'Bastone' token contract
5 //
6 // Deployed to 0xed5a55797caecca39811ac3cc0ee085cafc05953#code
7 //
8 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // ERC Token Standard #20 Interface
14 // https://github.com/ethereum/EIPs/issues/20
15 // ----------------------------------------------------------------------------
16 contract ERC20Interface {
17     uint public totalSupply;
18     function balanceOf(address _owner) constant returns (uint balance);
19     function transfer(address _to, uint _value) returns (bool success);
20     function transferFrom(address _from, address _to, uint _value)
21         returns (bool success);
22     function approve(address _spender, uint _value) returns (bool success);
23     function allowance(address _owner, address _spender) constant
24         returns (uint remaining);
25     event Transfer(address indexed _from, address indexed _to, uint _value);
26     event Approval(address indexed _owner, address indexed _spender,
27         uint _value);
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // Owned contract
33 // ----------------------------------------------------------------------------
34 contract Owned {
35 
36     // ------------------------------------------------------------------------
37     // Current owner, and proposed new owner
38     // ------------------------------------------------------------------------
39     address public owner;
40     address public newOwner;
41 
42     // ------------------------------------------------------------------------
43     // Constructor - assign creator as the owner
44     // ------------------------------------------------------------------------
45     function Owned() {
46         owner = msg.sender;
47     }
48 
49 
50     // ------------------------------------------------------------------------
51     // Modifier to mark that a function can only be executed by the owner
52     // ------------------------------------------------------------------------
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58 
59     // ------------------------------------------------------------------------
60     // Owner can initiate transfer of contract to a new owner
61     // ------------------------------------------------------------------------
62     function transferOwnership(address _newOwner) onlyOwner {
63         newOwner = _newOwner;
64     }
65 
66 
67     // ------------------------------------------------------------------------
68     // New owner has to accept transfer of contract
69     // ------------------------------------------------------------------------
70     function acceptOwnership() {
71         require(msg.sender == newOwner);
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = 0x0;
75     }
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // Safe maths, borrowed from OpenZeppelin
82 // ----------------------------------------------------------------------------
83 library SafeMath {
84 
85     // ------------------------------------------------------------------------
86     // Add a number to another number, checking for overflows
87     // ------------------------------------------------------------------------
88     function add(uint a, uint b) internal returns (uint) {
89         uint c = a + b;
90         assert(c >= a && c >= b);
91         return c;
92     }
93 
94     // ------------------------------------------------------------------------
95     // Subtract a number from another number, checking for underflows
96     // ------------------------------------------------------------------------
97     function sub(uint a, uint b) internal returns (uint) {
98         assert(b <= a);
99         return a - b;
100     }
101 }
102 
103 
104 // ----------------------------------------------------------------------------
105 // ERC20 Token, with the addition of symbol, name and decimals
106 // ----------------------------------------------------------------------------
107 contract BastoneToken is ERC20Interface, Owned {
108     using SafeMath for uint;
109 
110     // ------------------------------------------------------------------------
111     // Token parameters
112     // ------------------------------------------------------------------------
113     string public constant symbol = "BSN";
114     string public constant name = "Bastone";
115     uint8 public constant decimals = 18;
116 
117     uint public constant totalSupply = 50 * 10**6 * 10**18;
118 
119     // ------------------------------------------------------------------------
120     // Balances for each account
121     // ------------------------------------------------------------------------
122     mapping(address => uint) balances;
123 
124     // ------------------------------------------------------------------------
125     // Owner of account approves the transfer of an amount to another account
126     // ------------------------------------------------------------------------
127     mapping(address => mapping (address => uint)) allowed;
128 
129 
130     // ------------------------------------------------------------------------
131     // Constructor
132     // ------------------------------------------------------------------------
133     function BastoneToken() Owned() {
134         balances[owner] = totalSupply;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the account balance of another account with address _owner
140     // ------------------------------------------------------------------------
141     function balanceOf(address _owner) constant returns (uint balance) {
142         return balances[_owner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from owner's account to another account
148     // ------------------------------------------------------------------------
149     function transfer(address _to, uint _amount) returns (bool success) {
150         if (balances[msg.sender] >= _amount             // User has balance
151             && _amount > 0                              // Non-zero transfer
152             && balances[_to] + _amount > balances[_to]  // Overflow check
153         ) {
154             balances[msg.sender] = balances[msg.sender].sub(_amount);
155             balances[_to] = balances[_to].add(_amount);
156             Transfer(msg.sender, _to, _amount);
157             return true;
158         } else {
159             return false;
160         }
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Allow _spender to withdraw from your account, multiple times, up to the
166     // _value amount. If this function is called again it overwrites the
167     // current allowance with _value.
168     // ------------------------------------------------------------------------
169     function approve(
170         address _spender,
171         uint _amount
172     ) returns (bool success) {
173         allowed[msg.sender][_spender] = _amount;
174         Approval(msg.sender, _spender, _amount);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Spender of tokens transfer an amount of tokens from the token owner's
181     // balance to another account. The owner of the tokens must already
182     // have approve(...)-d this transfer
183     // ------------------------------------------------------------------------
184     function transferFrom(
185         address _from,
186         address _to,
187         uint _amount
188     ) returns (bool success) {
189         if (balances[_from] >= _amount                  // From a/c has balance
190             && allowed[_from][msg.sender] >= _amount    // Transfer approved
191             && _amount > 0                              // Non-zero transfer
192             && balances[_to] + _amount > balances[_to]  // Overflow check
193         ) {
194             balances[_from] = balances[_from].sub(_amount);
195             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
196             balances[_to] = balances[_to].add(_amount);
197             Transfer(_from, _to, _amount);
198             return true;
199         } else {
200             return false;
201         }
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Returns the amount of tokens approved by the owner that can be
207     // transferred to the spender's account
208     // ------------------------------------------------------------------------
209     function allowance(
210         address _owner,
211         address _spender
212     ) constant returns (uint remaining) {
213         return allowed[_owner][_spender];
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Don't accept ethers - no payable modifier
219     // ------------------------------------------------------------------------
220     function () {
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint amount)
228       onlyOwner returns (bool success)
229     {
230         return ERC20Interface(tokenAddress).transfer(owner, amount);
231     }
232 }