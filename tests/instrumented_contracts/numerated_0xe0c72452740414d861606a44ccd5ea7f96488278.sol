1 pragma solidity ^0.4.10;
2 
3 // ----------------------------------------------------------------------------
4 // The EncryptoTel smart contract - provided by Incent - join us on slack; 
5 // http://incentinvites.herokuapp.com/
6 //
7 // A collaboration between Incent, Bok and EncryptoTel :)
8 //
9 // Enjoy. (c) Incent Loyalty Pty Ltd and Bok Consulting Pty Ltd 2017. 
10 // The MIT Licence.
11 // ----------------------------------------------------------------------------
12 
13 // ----------------------------------------------------------------------------
14 // Contract configuration
15 // ----------------------------------------------------------------------------
16 contract TokenConfig {
17     string public constant symbol = "ETT";
18     string public constant name = "EncryptoTel Token";
19     uint8 public constant decimals = 8;  // 8 decimals, same as tokens on Waves
20     uint256 public constant TOTALSUPPLY = 7766398700000000;
21 }
22 
23 
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // https://github.com/ethereum/EIPs/issues/20
27 // ----------------------------------------------------------------------------
28 contract ERC20Interface {
29     uint256 public totalSupply;
30     function balanceOf(address _owner) constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) 
33         returns (bool success);
34     function approve(address _spender, uint256 _value) returns (bool success);
35     function allowance(address _owner, address _spender) constant 
36         returns (uint256 remaining);
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, 
39         uint256 _value);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Owned contract
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address public owner;
48     address public newOwner;
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         if (msg.sender != owner) throw;
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) onlyOwner {
61         newOwner = _newOwner;
62     }
63 
64     function acceptOwnership() {
65         if (msg.sender != newOwner) throw;
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // WavesEthereumSwap functionality
74 // ----------------------------------------------------------------------------
75 contract WavesEthereumSwap is Owned, ERC20Interface {
76     event WavesTransfer(address indexed _from, string wavesAddress,
77         uint256 amount);
78 
79     function moveToWaves(string wavesAddress, uint256 amount) {
80         if (!transfer(owner, amount)) throw;
81         WavesTransfer(msg.sender, wavesAddress, amount);
82     }
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC Token Standard #20 Interface
88 // https://github.com/ethereum/EIPs/issues/20
89 // ----------------------------------------------------------------------------
90 contract EncryptoTelToken is TokenConfig, WavesEthereumSwap {
91 
92     // ------------------------------------------------------------------------
93     // Balances for each account
94     // ------------------------------------------------------------------------
95     mapping(address => uint256) balances;
96 
97     // ------------------------------------------------------------------------
98     // Owner of account approves the transfer of an amount to another account
99     // ------------------------------------------------------------------------
100     mapping(address => mapping (address => uint256)) allowed;
101 
102     // ------------------------------------------------------------------------
103     // Constructor
104     // ------------------------------------------------------------------------
105     function EncryptoTelToken() Owned() TokenConfig() {
106         totalSupply = TOTALSUPPLY;
107         balances[owner] = TOTALSUPPLY;
108     }
109 
110     // ------------------------------------------------------------------------
111     // Get the account balance of another account with address _owner
112     // ------------------------------------------------------------------------
113     function balanceOf(address _owner) constant returns (uint256 balance) {
114         return balances[_owner];
115     }
116 
117     // ------------------------------------------------------------------------
118     // Transfer the balance from owner's account to another account
119     // ------------------------------------------------------------------------
120     function transfer(
121         address _to, 
122         uint256 _amount
123     ) returns (bool success) {
124         if (balances[msg.sender] >= _amount             // User has balance
125             && _amount > 0                              // Non-zero transfer
126             && balances[_to] + _amount > balances[_to]  // Overflow check
127         ) {
128             balances[msg.sender] -= _amount;
129             balances[_to] += _amount;
130             Transfer(msg.sender, _to, _amount);
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     // ------------------------------------------------------------------------
138     // Allow _spender to withdraw from your account, multiple times, up to the
139     // _value amount. If this function is called again it overwrites the
140     // current allowance with _value.
141     // ------------------------------------------------------------------------
142     function approve(
143         address _spender,
144         uint256 _amount
145     ) returns (bool success) {
146         allowed[msg.sender][_spender] = _amount;
147         Approval(msg.sender, _spender, _amount);
148         return true;
149     }
150 
151     // ------------------------------------------------------------------------
152     // Spender of tokens transfer an amount of tokens from the token owner's
153     // balance to another account. The owner of the tokens must already
154     // have approve(...)-d this transfer
155     // ------------------------------------------------------------------------
156     function transferFrom(
157         address _from,
158         address _to,
159         uint256 _amount
160     ) returns (bool success) {
161         if (balances[_from] >= _amount                  // From a/c has balance
162             && allowed[_from][msg.sender] >= _amount    // Transfer approved
163             && _amount > 0                              // Non-zero transfer
164             && balances[_to] + _amount > balances[_to]  // Overflow check
165         ) {
166             balances[_from] -= _amount;
167             allowed[_from][msg.sender] -= _amount;
168             balances[_to] += _amount;
169             Transfer(_from, _to, _amount);
170             return true;
171         } else {
172             return false;
173         }
174     }
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(
181         address _owner, 
182         address _spender
183     ) constant returns (uint256 remaining) {
184         return allowed[_owner][_spender];
185     }
186 
187     // ------------------------------------------------------------------------
188     // Transfer out any accidentally sent ERC20 tokens
189     // ------------------------------------------------------------------------
190     function transferAnyERC20Token(
191         address tokenAddress, 
192         uint256 amount
193     ) onlyOwner returns (bool success) {
194         return ERC20Interface(tokenAddress).transfer(owner, amount);
195     }
196     
197     // ------------------------------------------------------------------------
198     // Don't accept ethers
199     // ------------------------------------------------------------------------
200     function () {
201         throw;
202     }
203 }