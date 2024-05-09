1 pragma solidity ^0.4.18;
2 // Abstract contract for the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*
51 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
52 
53 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
54 Imagine coins, currencies, shares, voting weight, etc.
55 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
56 
57 1) Initial Finite Supply (upon creation one specifies how much is minted).
58 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
59 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
60 
61 .*/
62 
63 
64 
65 contract StandardToken is Token {
66 
67     function transfer(address _to, uint256 _value) returns (bool success) {
68         //Default assumes totalSupply can't be over max (2^256 - 1).
69         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
70         //Replace the if with this one instead.
71         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
72         require(balances[msg.sender] >= _value);
73         balances[msg.sender] -= _value;
74         balances[_to] += _value;
75         Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         //same as above. Replace this line with the following if you want to protect against wrapping uints.
81         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
82         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
83         balances[_to] += _value;
84         balances[_from] -= _value;
85         allowed[_from][msg.sender] -= _value;
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function balanceOf(address _owner) constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102     }
103 
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106 }
107 
108 
109 contract HumanStandardToken is StandardToken {
110 
111     /* Public variables of the token */
112      //human 0.1 standard. Just an arbitrary versioning scheme.
113 
114     /*
115     NOTE:
116     The following variables are OPTIONAL vanities. One does not have to include them.
117     They allow one to customise the token contract & in no way influences the core functionality.
118     Some wallets/interfaces might not even bother to look at this information.
119     */
120     string public name;                   //fancy name: eg Simon Bucks
121     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
122     string public symbol;                 //An identifier: eg SBX
123     string public version = 'H0.1';  
124     function HumanStandardToken(
125         uint256 _initialAmount,
126         string _tokenName,
127         uint8 _decimalUnits,
128         string _tokenSymbol
129         ) {
130         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
131         totalSupply = _initialAmount;                        // Update total supply
132         name = _tokenName;                                   // Set the name for display purposes
133         decimals = _decimalUnits;                            // Amount of decimals for display purposes
134         symbol = _tokenSymbol;                               // Set the symbol for display purposes
135     }
136 
137     /* Approves and then calls the receiving contract */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141 
142         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
143         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
144         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
145         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
146         return true;
147     }
148 }
149 
150 contract NashvilleBeerToken is HumanStandardToken {
151     address public constant RECIPIENT = 0xB1384DfE8ac77a700F460C94352bdD47Dc0327eF;
152     bytes32[] public claimedList;
153     mapping(address => bytes32) names;
154     uint256 public maxSupply;
155 
156     event LogBeerBought(uint date, address owner);
157 
158     function NashvilleBeerToken(
159         uint256 _initialAmount,
160         string _tokenName,
161         uint8 _decimalUnits,
162         string _tokenSymbol,
163         uint256 _maxSupply
164         ) 
165         HumanStandardToken(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol) 
166         {
167             maxSupply = _maxSupply;
168         }
169     
170     /*
171     * @note instead of burning the tokens we can identity each users address with a name
172     * Or just transfer to the Nashville Ethereum Meetup Address
173     */
174     function registerName(bytes32 _name) {
175         names[msg.sender] = _name;
176     }
177 
178 
179     function nameOf(address _owner) constant public returns (bytes32) {
180         return names[_owner];    
181     }
182     
183     function claimBeer() payable {
184         require(msg.value == .015 ether);
185         balances[msg.sender] += 1;
186         totalSupply += 1;
187         require(totalSupply <= maxSupply);
188         RECIPIENT.transfer(msg.value);
189         Transfer(address(0), msg.sender, 1);
190         LogBeerBought(now, msg.sender);
191     }
192 
193     function() payable {
194         claimBeer();
195     }
196 }