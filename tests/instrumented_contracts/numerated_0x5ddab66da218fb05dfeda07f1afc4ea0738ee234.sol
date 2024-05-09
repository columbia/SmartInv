1 pragma solidity ^0.4.9;
2 
3 // ----------------------------------------------------------------------------------------------
4 // The new RARE token contract
5 //
6 // https://github.com/bokkypoobah/RAREPeperiumToken
7 //
8 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017 for Michael C. The MIT Licence.
9 // ----------------------------------------------------------------------------------------------
10 
11 contract Owned {
12     address public owner;
13     address public newOwner;
14     event OwnershipTransferred(address indexed _from, address indexed _to);
15 
16     function Owned() {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         if (msg.sender != owner) throw;
22         _;
23     }
24 
25     function transferOwnership(address _newOwner) onlyOwner {
26         newOwner = _newOwner;
27     }
28 
29     function acceptOwnership() {
30         if (msg.sender == newOwner) {
31             OwnershipTransferred(owner, newOwner);
32             owner = newOwner;
33         }
34     }
35 }
36 
37 
38 contract ERC20Token is Owned {
39     string public symbol;
40     string public name;
41     uint8 public decimals;
42     uint256 public totalSupply;
43 
44     // ------------------------------------------------------------------------
45     // Balances for each account
46     // ------------------------------------------------------------------------
47     mapping (address => uint256) balances;
48 
49     // ------------------------------------------------------------------------
50     // Owner of account approves the transfer of an amount to another account
51     // ------------------------------------------------------------------------
52     mapping (address => mapping (address => uint256)) allowed;
53 
54     // ------------------------------------------------------------------------
55     // Events
56     // ------------------------------------------------------------------------
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60     // ------------------------------------------------------------------------
61     // Constructor
62     // ------------------------------------------------------------------------
63     function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) {
64         symbol = _symbol;
65         name = _name;
66         decimals = _decimals;
67         totalSupply = _totalSupply;
68         balances[msg.sender] = _totalSupply;
69     }
70 
71     // ------------------------------------------------------------------------
72     // Get the account balance of another account with address _owner
73     // ------------------------------------------------------------------------
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     // ------------------------------------------------------------------------
79     // Transfer the balance from owner's account to another account
80     // ------------------------------------------------------------------------
81     function transfer(address _to, uint256 _amount) returns (bool success) {
82         if (balances[msg.sender] >= _amount             // User has balance
83             && _amount > 0                              // Non-zero transfer
84             && balances[_to] + _amount > balances[_to]  // Overflow check
85         ) {
86             balances[msg.sender] -= _amount;
87             balances[_to] += _amount;
88             Transfer(msg.sender, _to, _amount);
89             return true;
90         } else {
91             return false;
92         }
93     }
94 
95     // ------------------------------------------------------------------------
96     // Allow _spender to withdraw from your account, multiple times, up to the
97     // _value amount. If this function is called again it overwrites the
98     // current allowance with _value.
99     // ------------------------------------------------------------------------
100     function approve(address _spender, uint256 _amount) returns (bool success) {
101         allowed[msg.sender][_spender] = _amount;
102         Approval(msg.sender, _spender, _amount);
103         return true;
104     }
105 
106     // ------------------------------------------------------------------------
107     // Spender of tokens transfer an amount of tokens from the token owner's
108     // balance to another account. The owner of the tokens must already
109     // have approve(...)-d this transfer
110     // ------------------------------------------------------------------------
111     function transferFrom(
112         address _from,
113         address _to,
114         uint256 _amount
115     ) returns (bool success) {
116         if (balances[_from] >= _amount                  // From a/c has balance
117             && allowed[_from][msg.sender] >= _amount    // Transfer approved
118             && _amount > 0                              // Non-zero transfer
119             && balances[_to] + _amount > balances[_to]  // Overflow check
120         ) {
121             balances[_from] -= _amount;
122             allowed[_from][msg.sender] -= _amount;
123             balances[_to] += _amount;
124             Transfer(_from, _to, _amount);
125             return true;
126         } else {
127             return false;
128         }
129     }
130 
131     // ------------------------------------------------------------------------
132     // Returns the amount of tokens approved by the owner that can be
133     // transferred to the spender's account
134     // ------------------------------------------------------------------------
135     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138 
139     // ------------------------------------------------------------------------
140     // Don't accept ethers
141     // ------------------------------------------------------------------------
142     function () {
143         throw;
144     }
145 }
146 
147 
148 contract RareToken is ERC20Token {
149     // ------------------------------------------------------------------------
150     // 100,000,000 tokens that will be populated by the fill, 8 decimal places
151     // ------------------------------------------------------------------------
152     function RareToken() ERC20Token ("RARE", "RARE", 8, 0) {
153     }
154 
155     function burnTokens(uint256 value) onlyOwner {
156         if (balances[owner] < value) throw;
157         balances[owner] -= value;
158         totalSupply -= value;
159         Transfer(owner, 0, value);
160     }
161 
162     // ------------------------------------------------------------------------
163     // Fill - to populate tokens from the old token contract
164     // ------------------------------------------------------------------------
165     // From https://github.com/BitySA/whetcwithdraw/tree/master/daobalance
166     bool public sealed;
167     // The compiler will warn that this constant does not match the address checksum
168     uint256 constant D160 = 0x010000000000000000000000000000000000000000;
169     // The 160 LSB is the address of the balance
170     // The 96 MSB is the balance of that address.
171     function fill(uint256[] data) onlyOwner {
172         if (sealed) throw;
173         for (uint256 i = 0; i < data.length; i++) {
174             address account = address(data[i] & (D160-1));
175             uint256 amount = data[i] / D160;
176             // Prevent duplicates
177             if (balances[account] == 0) {
178                 balances[account] = amount;
179                 totalSupply += amount;
180                 Transfer(0x0, account, amount);
181             }
182         }
183     }
184 
185     // ------------------------------------------------------------------------
186     // After sealing, no more filling is possible
187     // ------------------------------------------------------------------------
188     function seal() onlyOwner {
189         if (sealed) throw;
190         sealed = true;
191     }
192 }