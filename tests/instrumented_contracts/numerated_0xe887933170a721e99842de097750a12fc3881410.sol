1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) revert();
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner private {
16         owner = newOwner;
17     }
18 }
19 
20 // ----------------------------------------------------------------------------------------------
21 // Original from:
22 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
23 // (c) BokkyPooBah 2017. The MIT Licence.
24 // ----------------------------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // https://github.com/ethereum/EIPs/issues/20
27 contract ERC20Interface {
28     // Get the total token supply     function totalSupply() constant returns (uint256 totalSupply);
29 
30     // Get the account balance of another account with address _owner
31     function balanceOf(address _owner) constant public returns (uint256 balance);
32 
33     // Send _value amount of tokens to address _to
34     function transfer(address _to, uint256 _value) public returns (bool success);
35 
36     // Send _value amount of token from address _from to address _to
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 
39     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
40     // If this function is called again it overwrites the current allowance with _value.
41     // this function is required for some DEX functionality
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     // Returns the amount which _spender is still allowed to withdraw from _owner
45     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
46 
47    // Triggered when tokens are transferred.
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49 
50     // Triggered whenever approve(address _spender, uint256 _value) is called.
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 
55 /// @title Yoyo Ark Coin (YAC)
56 contract YoyoArkCoin is owned, ERC20Interface {
57     // Public variables of the token
58     string public constant standard = 'ERC20';
59     string public constant name = 'Yoyo Ark Coin';
60     string public constant symbol = 'YAC';
61     uint8  public constant decimals = 18;
62     uint public registrationTime = 0;
63     bool public registered = false;
64 
65     uint256 totalTokens = 960 * 1000 * 1000 * 10**18;
66 
67 
68     // This creates an array with all balances
69     mapping (address => uint256) balances;
70 
71     // Owner of account approves the transfer of an amount to another account
72     mapping(address => mapping (address => uint256)) allowed;
73 
74     // These are related to YAC team members
75     mapping (address => bool) public frozenAccount;
76     mapping (address => uint[3]) public frozenTokens;
77 
78     // Variable of token frozen rules for YAC team members.
79     uint public unlockat;
80 
81     // Constructor
82     constructor() public
83     {
84     }
85 
86     // This unnamed function is called whenever someone tries to send ether to it
87     function () private
88     {
89         revert(); // Prevents accidental sending of ether
90     }
91 
92     function totalSupply()
93         constant
94         public
95         returns (uint256)
96     {
97         return totalTokens;
98     }
99 
100     // What is the balance of a particular account?
101     function balanceOf(address _owner)
102         constant
103         public
104         returns (uint256)
105     {
106         return balances[_owner];
107     }
108 
109     // Transfer the balance from owner's account to another account
110     function transfer(address _to, uint256 _amount)
111         public
112         returns (bool success)
113     {
114         if (!registered) return false;
115         if (_amount <= 0) return false;
116         if (frozenRules(msg.sender, _amount)) return false;
117 
118         if (balances[msg.sender] >= _amount
119             && balances[_to] + _amount > balances[_to]) {
120 
121             balances[msg.sender] -= _amount;
122             balances[_to] += _amount;
123             emit Transfer(msg.sender, _to, _amount);
124             return true;
125         } else {
126             return false;
127         }
128     }
129 
130     // Send _value amount of tokens from address _from to address _to
131     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
132     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
133     // fees in sub-currencies; the command should fail unless the _from account has
134     // deliberately authorized the sender of the message via some mechanism; we propose
135     // these standardized APIs for approval:
136     function transferFrom(address _from, address _to, uint256 _amount) public
137         returns (bool success)
138     {
139         if (!registered) return false;
140         if (_amount <= 0) return false;
141         if (frozenRules(_from, _amount)) return false;
142 
143         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && balances[_to] + _amount > balances[_to]) {
144 
145             balances[_from] -= _amount;
146             allowed[_from][msg.sender] -= _amount;
147             balances[_to] += _amount;
148             emit Transfer(_from, _to, _amount);
149             return true;
150         } else {
151             return false;
152         }
153     }
154 
155     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
156     // If this function is called again it overwrites the current allowance with _value.
157     function approve(address _spender, uint256 _amount) public
158         returns (bool success)
159     {
160         allowed[msg.sender][_spender] = _amount;
161         emit Approval(msg.sender, _spender, _amount);
162         return true;
163     }
164 
165     function allowance(address _owner, address _spender)
166         constant
167         public
168         returns (uint256 remaining)
169     {
170         return allowed[_owner][_spender];
171     }
172 
173     /// @dev Register for Token Initialize,
174     /// 100% of total Token will initialize to dev Account.
175     function initRegister()
176         public
177     {
178         // (85%) of total supply to sender contract
179         balances[msg.sender] = 960 * 1000 * 1000 * 10**18;
180         // Frozen 15% of total supply for team members.
181         registered = true;
182         registrationTime = now;
183 
184         unlockat = registrationTime + 6 * 30 days;
185 
186         // Frozen rest (15%) of total supply for development team and contributors
187         // 144,000,000 * 10**18;
188         frozenForTeam();
189     }
190 
191     /// @dev Frozen for the team members.
192     function frozenForTeam()
193         internal
194     {
195         uint totalFrozeNumber = 144 * 1000 * 1000 * 10**18;
196         freeze(msg.sender, totalFrozeNumber);
197     }
198 
199     /// @dev Frozen 15% of total supply for team members.
200     /// @param _account The address of account to be frozen.
201     /// @param _totalAmount The amount of tokens to be frozen.
202     function freeze(address _account, uint _totalAmount)
203         public
204         onlyOwner
205     {
206         frozenAccount[_account] = true;
207         frozenTokens[_account][0] = _totalAmount;            // 100% of locked token within 6 months
208     }
209 
210     /// @dev Token frozen rules for token holders.
211     /// @param _from The token sender.
212     /// @param _value The token amount.
213     function frozenRules(address _from, uint256 _value)
214         internal
215         returns (bool success)
216     {
217         if (frozenAccount[_from]) {
218             if (now < unlockat) {
219                // 100% locked within the first 6 months.
220                if (balances[_from] - _value < frozenTokens[_from][0])
221                     return true;
222             } else {
223                // 100% unlocked after 6 months.
224                frozenAccount[_from] = false;
225             }
226         }
227         return false;
228     }
229 }