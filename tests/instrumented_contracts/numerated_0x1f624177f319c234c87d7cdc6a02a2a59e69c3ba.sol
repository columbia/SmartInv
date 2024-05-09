1 pragma solidity ^0.4.19;
2 
3 
4 contract Owned
5 {
6     address public owner;
7 
8     modifier onlyOwner
9 	{
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) public onlyOwner()
15 	{
16         owner = newOwner;
17     }
18 }
19 
20 contract EIP20Interface {
21     /* This is a slight change to the ERC20 base standard.
22     function totalSupply() constant returns (uint256 supply);
23     is replaced with:
24     uint256 public totalSupply;
25     This automatically creates a getter function for the totalSupply.
26     This is moved to the base contract since public getter functions are not
27     currently recognised as an implementation of the matching abstract
28     function by the compiler.
29     */
30     /// total amount of tokens
31     uint256 public totalSupply;
32 
33     /// @param _owner The address from which the balance will be retrieved
34     /// @return The balance
35     function balanceOf(address _owner) public view returns (uint256 balance);
36 
37     /// @notice send `_value` token to `_to` from `msg.sender`
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transfer(address _to, uint256 _value) public returns (bool success);
42 
43     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
44     /// @param _from The address of the sender
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
49 
50     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @param _value The amount of tokens to be approved for transfer
53     /// @return Whether the approval was successful or not
54     function approve(address _spender, uint256 _value) public returns (bool success);
55 
56     /// @param _owner The address of the account owning tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @return Amount of remaining tokens allowed to spent
59     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 contract EIP20 is EIP20Interface {
66 
67     uint256 constant MAX_UINT256 = 2**256 - 1;
68 
69     /*
70     NOTE:
71     The following variables are OPTIONAL vanities. One does not have to include them.
72     They allow one to customise the token contract & in no way influences the core functionality.
73     Some wallets/interfaces might not even bother to look at this information.
74     */
75     string public name;                   //fancy name: eg Simon Bucks
76     uint8 public decimals;                //How many decimals to show.
77     string public symbol;                 //An identifier: eg SBX
78 
79      function EIP20(
80         uint256 _initialAmount,
81         string _tokenName,
82         uint8 _decimalUnits,
83         string _tokenSymbol
84         ) public {
85         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
86         totalSupply = _initialAmount;                        // Update total supply
87         name = _tokenName;                                   // Set the name for display purposes
88         decimals = _decimalUnits;                            // Amount of decimals for display purposes
89         symbol = _tokenSymbol;                               // Set the symbol for display purposes
90     }
91 
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         //Default assumes totalSupply can't be over max (2^256 - 1).
94         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
95         //Replace the if with this one instead.
96         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
97         require(balances[msg.sender] >= _value);
98         balances[msg.sender] -= _value;
99         balances[_to] += _value;
100         Transfer(msg.sender, _to, _value);
101         return true;
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         //same as above. Replace this line with the following if you want to protect against wrapping uints.
106         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
107         uint256 allowance = allowed[_from][msg.sender];
108         require(balances[_from] >= _value && allowance >= _value);
109         balances[_to] += _value;
110         balances[_from] -= _value;
111         if (allowance < MAX_UINT256) {
112             allowed[_from][msg.sender] -= _value;
113         }
114         Transfer(_from, _to, _value);
115         return true;
116     }
117 
118     function balanceOf(address _owner) view public returns (uint256 balance) {
119         return balances[_owner];
120     }
121 
122     function approve(address _spender, uint256 _value) public returns (bool success) {
123         allowed[msg.sender][_spender] = _value;
124         Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     function allowance(address _owner, address _spender)
129     view public returns (uint256 remaining) {
130       return allowed[_owner][_spender];
131     }
132 
133     mapping (address => uint256) balances;
134     mapping (address => mapping (address => uint256)) allowed;
135 }
136 
137 contract Gabicoin is Owned, EIP20
138 {
139     // Struct for ico minting.
140     struct IcoBalance
141     {
142         bool hasTransformed;// Has transformed ico balances to real balance for this user?
143         uint[3] balances;// Balances.
144     }
145 
146     // Mint event.
147     event Mint(address indexed to, uint value, uint phaseNumber);
148 
149     // Activate event.
150     event Activate();
151 
152     // Constructor.
153     function Gabicoin() EIP20(0, "Gabicoin", 2, "GCO") public
154     {
155         owner = msg.sender;
156     }
157 
158     // Mint function for ICO.
159     function mint(address to, uint value, uint phase) onlyOwner() external
160     {
161         require(!isActive);
162 
163         icoBalances[to].balances[phase] += value;// Increase ICO balance.
164 
165         Mint(to, value, phase);
166     }
167 
168     // Activation function after successful ICO.
169     function activate(bool i0, bool i1, bool i2) onlyOwner() external
170     {
171         require(!isActive);// Only for not yet activated token.
172 
173         activatedPhases[0] = i0;
174         activatedPhases[1] = i1;
175         activatedPhases[2] = i2;
176 
177         Activate();
178         
179         isActive = true;// Activate token.
180     }
181 
182     // Transform ico balance to standard balance.
183     function transform(address addr) public
184     {
185         require(isActive);// Only after activation.
186         require(!icoBalances[addr].hasTransformed);// Only for not transfromed structs.
187 
188         for (uint i = 0; i < 3; i++)
189         {
190             if (activatedPhases[i])// Check phase activation.
191             {
192                 balances[addr] += icoBalances[addr].balances[i];// Increase balance.
193                 Transfer(0x00, addr, icoBalances[addr].balances[i]);
194                 icoBalances[addr].balances[i] = 0;// Set ico balance to zero.
195             }
196         }
197 
198         icoBalances[addr].hasTransformed = true;// Set struct to transformed status.
199     }
200 
201     // For simple call transform().
202     function () payable external
203     {
204         transform(msg.sender);
205         msg.sender.transfer(msg.value);
206     }
207 
208     // Activated on ICO phases.
209     bool[3] public activatedPhases;
210 
211     // Token activation status.
212     bool public isActive;
213 
214     // Ico balances.
215     mapping (address => IcoBalance) public icoBalances;
216 }