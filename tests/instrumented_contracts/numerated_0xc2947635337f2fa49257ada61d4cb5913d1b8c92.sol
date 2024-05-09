1 pragma solidity ^0.4.16;
2 
3 library Math {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Token {
30     /// total amount of tokens
31     uint256 public totalSupply;
32 
33     uint256 public decimals;                
34     /// @param _owner The address from which the balance will be retrieved
35     /// @return The balance
36     function balanceOf(address _owner) constant returns (uint256 balance);
37 
38     /// @notice send `_value` token to `_to` from `msg.sender`
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transfer(address _to, uint256 _value) returns (bool success);
43 
44     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
45     /// @param _from The address of the sender
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
50 
51     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @param _value The amount of tokens to be approved for transfer
54     /// @return Whether the approval was successful or not
55     function approve(address _spender, uint256 _value) returns (bool success);
56 
57     /// @param _owner The address of the account owning tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @return Amount of remaining tokens allowed to spent
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63 
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 }
66 contract Cloud is Token {
67 
68     using Math for uint256;
69 	bool trading=false;
70 
71     mapping (address => bool) public frozenAccount;
72     event FrozenFunds(address target, bool frozen);
73 
74     function transfer(address _to, uint256 _value) canTrade returns (bool success) {
75         require(_value > 0);
76         require(!frozenAccount[msg.sender]);
77         require(balances[msg.sender] >= _value);
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84 
85     function transferFrom(address _from, address _to, uint256 _value) canTrade returns (bool success) {
86         require(_value > 0);
87         require(!frozenAccount[_from]);
88         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
89         //require(balances[_from] >= _value);
90         balances[_to] = balances[_to].add(_value);
91         balances[_from] = balances[_from].sub(_value);
92         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93         Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
108       return allowed[_owner][_spender];
109     }
110 
111 	modifier canTrade {
112     	require(trading==true ||(canRelease==true && msg.sender==owner));
113     	_;
114     }
115     
116     function setTrade(bool allow) onlyOwner {
117     	trading=allow;
118     }
119 
120     mapping (address => uint256) balances;
121     mapping (address => mapping (address => uint256)) allowed;
122 
123     
124     /* Public variables of the token */
125     event Invested(address investor, uint256 tokens);
126 
127     uint256 public employeeShare=8;
128     // Wallets - 4 employee
129     address[4] employeeWallets = [0x9caeD53A6C6E91546946dD866dFD66c0aaB9f347,0xf1Df495BE71d1E5EdEbCb39D85D5F6b620aaAF47,0xa3C38bc8dD6e26eCc0D64d5B25f5ce855bb57Cd5,0x4d67a23b62399eDec07ad9c0f748D89655F0a0CB];
130 
131     string public name;                 
132     string public symbol;               
133     address public owner;				
134     uint256 public tokensReleased=0;
135     bool canRelease=false;
136 
137     /* Initializes contract with initial supply tokens to the owner of the contract */
138     function Cloud(
139         uint256 _initialAmount,
140         uint256 _decimalUnits,
141         string _tokenName,
142         string _tokenSymbol,
143         address ownerWallet
144         ) {
145         owner=ownerWallet;
146         decimals = _decimalUnits;                            // Amount of decimals for display purposes
147         totalSupply = _initialAmount*(10**decimals);         // Update total supply
148         balances[owner] = totalSupply;                       // Give the creator all initial tokens
149         name = _tokenName;                                   // Set the name for display purposes
150         symbol = _tokenSymbol;                               // Set the symbol for display purposes
151     }
152 
153     /* Freezing tokens */
154     function freezeAccount(address target, bool freeze) onlyOwner{
155         frozenAccount[target] = freeze;
156         FrozenFunds(target, freeze);
157     }
158 
159     /* Authenticating owner */
160     modifier onlyOwner {
161         require(msg.sender == owner);
162         _;
163     }
164     /* Allow and restrict of release of tokens */
165     function releaseTokens(bool allow) onlyOwner {
166         canRelease=allow;
167     }
168     /// @param receiver The address of the account which will receive the tokens
169     /// @param _value The amount of tokens to be approved for transfer
170     /// @return Whether the token transfer was successful or not was successful or not
171     function invest(address receiver, uint256 _value) onlyOwner returns (bool success) {
172         require(canRelease);
173         require(_value > 0);
174         uint256 numTokens = _value*(10**decimals);
175         uint256 employeeTokens = 0;
176         uint256 employeeTokenShare=0;
177         // divide employee tokens by 4 shares
178         employeeTokens = numTokens.mul(employeeShare).div(100);
179         employeeTokenShare = employeeTokens.div(employeeWallets.length);
180         //split tokens for different wallets of employees and company
181         approve(owner,employeeTokens.add(numTokens));
182         for(uint i = 0; i < employeeWallets.length; i++)
183         {
184             require(transferFrom(owner, employeeWallets[i], employeeTokenShare));
185         }
186         require(transferFrom(owner, receiver, numTokens));
187         tokensReleased = tokensReleased.add(numTokens).add(employeeTokens.mul(4));
188         Invested(receiver,numTokens);
189         return true;
190     }
191 }