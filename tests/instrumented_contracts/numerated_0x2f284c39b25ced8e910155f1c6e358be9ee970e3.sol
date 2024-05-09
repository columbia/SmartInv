1 pragma solidity ^ 0.4 .9;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal constant returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal constant returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 
27 contract Token {
28 
29     /// @return total amount of tokens
30     function totalSupply() constant returns (uint256 supply) {}
31 
32     /// @param _owner The address from which the balance will be retrieved
33     /// @return The balance
34     function balanceOf(address _owner) constant returns (uint256 balance) {}
35 
36     /// @notice send `_value` token to `_to` from `msg.sender`
37     /// @param _to The address of the recipient
38     /// @param _value The amount of token to be transferred
39     /// @return Whether the transfer was successful or not
40     function transfer(address _to, uint256 _value) returns (bool success) {}
41 
42     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
43     /// @param _from The address of the sender
44     /// @param _to The address of the recipient
45     /// @param _value The amount of token to be transferred
46     /// @return Whether the transfer was successful or not
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
48 
49     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @param _value The amount of wei to be approved for transfer
52     /// @return Whether the approval was successful or not
53     function approve(address _spender, uint256 _value) returns (bool success) {}
54 
55     /// @param _owner The address of the account owning tokens
56     /// @param _spender The address of the account able to transfer the tokens
57     /// @return Amount of remaining tokens allowed to spent
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62     
63 }
64 
65 
66 
67 contract StandardToken is Token {
68 
69     function transfer(address _to, uint256 _value) returns (bool success) {
70         //Default assumes totalSupply can't be over max (2^256 - 1).
71         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
72         //Replace the if with this one instead.
73         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74         if (balances[msg.sender] >= _value && _value > 0) {
75             balances[msg.sender] -= _value;
76             balances[_to] += _value;
77             Transfer(msg.sender, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
83         //same as above. Replace this line with the following if you want to protect against wrapping uints.
84         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
85         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
86             balances[_to] += _value;
87             balances[_from] -= _value;
88             allowed[_from][msg.sender] -= _value;
89             Transfer(_from, _to, _value);
90             return true;
91         } else { return false; }
92     }
93 
94     function balanceOf(address _owner) constant returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     function approve(address _spender, uint256 _value) returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
105       return allowed[_owner][_spender];
106     }
107 
108     mapping (address => uint256) balances;
109     mapping (address => mapping (address => uint256)) allowed;
110     uint256 public totalSupply;
111 }
112 
113 
114 //name this contract whatever you'd like
115 contract MonkeyMan is StandardToken {
116         using SafeMath
117     for uint256;
118 
119     function () {
120         //if ether is sent to this address, send it back.
121         throw;
122     }
123 
124     /* Public variables of the token */
125 
126     /*
127     NOTE:
128     The following variables are OPTIONAL vanities. One does not have to include them.
129     They allow one to customise the token contract & in no way influences the core functionality.
130     Some wallets/interfaces might not even bother to look at this information.
131     */
132     string public name;                   //fancy name: eg Simon Bucks
133     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
134     string public symbol;                 //An identifier: eg SBX
135     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
136 
137 
138 
139 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
140 
141     function MonkeyMan(
142         ) {
143         balances[msg.sender] = 1000000000000000;               // Give the creator all initial tokens (100000 for example)
144         totalSupply = 1000000000000000;                        // Update total supply (100000 for example)
145         name = "ManMonkey";                                   // Set the name for display purposes
146         decimals = 10;                            // Amount of decimals for display purposes
147         symbol = "MANM";                               // Set the symbol for display purposes
148     }
149 
150     /* Approves and then calls the receiving contract */
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154 
155         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
156         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
157         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
158         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
159         return true;
160     }
161 }