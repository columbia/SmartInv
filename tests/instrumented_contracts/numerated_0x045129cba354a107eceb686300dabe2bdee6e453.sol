1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 
42 
43 contract StandardToken is Token {
44 
45 
46     function transfer(address _to, uint256 _value) returns (bool success) {
47         //Default assumes totalSupply can't be over max (2^256 - 1).
48         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
49         //Replace the if with this one instead.
50         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51         if (balances[msg.sender] >= _value && _value > 0) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else { return false; }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         //same as above. Replace this line with the following if you want to protect against wrapping uints.
61         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
63             balances[_to] += _value;
64             balances[_from] -= _value;
65             allowed[_from][msg.sender] -= _value;
66             Transfer(_from, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87     uint256 public totalSupply;
88     uint256 public circulatingSupply;
89 }
90 
91 
92 //name this contract whatever you'd like
93 contract DestlerDoubloons is StandardToken {
94 
95     function () {
96         //if ether is sent to this address, send it back.
97         throw;
98     }
99 
100     /* Public variables of the token */
101 
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public name;                   //fancy name: eg Simon Bucks
109     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
110     string public symbol;                 //An identifier: eg SBX
111     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
112     address private owner;
113 
114     uint256 public starting_giveaway;
115     uint256 public next_giveaway;
116     uint256 private giveaway_count;
117 
118 
119     function DestlerDoubloons(
120         ) {
121         totalSupply = 1500000;                        // Update total supply (1500000 for example)
122         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens (100000 for example)
123         circulatingSupply = 0;
124         name = "Destler Doubloons";                                   // Set the name for display purposes
125         decimals = 0;                            // Amount of decimals for display purposes
126         symbol = "DEST";                               // Set the symbol for display purposes
127         starting_giveaway = 50000;
128         next_giveaway = 0;
129         owner = msg.sender;
130         giveaway_count = 0;
131     }
132 
133     function getFromFaucet(string auth) returns (bool success) {
134         uint256 giveaway_value;
135 
136         if (validUser(auth) && balances[msg.sender] == 0){
137 
138             giveaway_count++;
139             appendString(auth);
140 
141             giveaway_value = (starting_giveaway / giveaway_count) + (starting_giveaway / (giveaway_count + 2));
142             next_giveaway = (starting_giveaway / (giveaway_count + 1)) + (starting_giveaway / (giveaway_count + 3));
143 
144 
145             balances[msg.sender] += giveaway_value;
146             balances[owner] -= giveaway_value;
147             circulatingSupply += giveaway_value;
148             Transfer(owner, msg.sender, giveaway_value);
149             return true;
150         }
151         else return false;
152     }
153 
154     /* Approves and then calls the receiving contract */
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158 
159         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
160         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
161         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
162         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
163         return true;
164     }
165 
166     struct AlreadyGiven {
167         string[] given;
168     }
169 
170     mapping(address => AlreadyGiven) giveAccounts;
171 
172     function appendString(string appendThis) returns(uint length) {
173         return giveAccounts[owner].given.push(appendThis);
174     }
175 
176     function getGivenCount() constant returns(uint length) {
177         return giveAccounts[owner].given.length;
178     }
179 
180     function validUser(string checkVal) returns(bool valid) {
181         uint256 i=0;
182 
183         for(i; i<getGivenCount(); i++){
184             if (keccak256(giveAccounts[owner].given[i]) == keccak256(checkVal)) return false;
185         }
186 
187         return true;
188     }
189 }