1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public constant returns (uint256) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public constant returns (uint256) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18         /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
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
36    
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39     
40 }
41 
42 
43 
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         //Default assumes totalSupply can't be over max (2^256 - 1).
48         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
49             if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             emit Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             emit Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66     
67     function burn(uint256 _value) public returns (bool success) {
68         require(balances[msg.sender] >= _value);   // Check if the sender has enough
69         balances[msg.sender] -= _value;            // Subtract from the sender
70         totalSupply -= _value;                      // Updates totalSupply
71         emit Burn(msg.sender, _value);
72         return true;
73     }
74     
75     /**
76      * Destroy tokens from other account
77      *
78      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
79      *
80      * @param _from the address of the sender
81      * @param _value the amount of money to burn
82      */
83     function burnFrom(address _from, uint256 _value) public returns (bool success) {
84         require(balances[_from] >= _value);                // Check if the targeted balance is enough
85         require(_value <= allowed[_from][msg.sender]);    // Check allowance
86         balances[_from] -= _value;                         // Subtract from the targeted balance
87         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
88         totalSupply -= _value;                              // Update totalSupply
89         emit Burn(_from, _value);
90         return true;
91     }
92 
93     function balanceOf(address _owner) public constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) public returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
104       return allowed[_owner][_spender];
105     }
106 
107     mapping (address => uint256) balances;
108     mapping (address => mapping (address => uint256)) allowed;
109     uint256 public totalSupply;
110     
111     // This notifies clients about the amount burnt
112     event Burn(address indexed from, uint256 value);
113 
114 }
115 
116 
117 //name this contract 
118 contract SCARABToken is StandardToken {
119 
120     function () public {
121         //if ether is sent to this address, send it back.
122         revert();
123     }
124     
125    
126 
127     /* Public variables of the token */
128 
129     /*
130     NOTE:
131     The following variables are OPTIONAL vanities. One does not have to include them.
132     They allow one to customise the token contract & in no way influences the core functionality.
133     Some wallets/interfaces might not even bother to look at this information.
134     */
135     string public name;                   //fancy name: eg Simon Bucks
136     uint8 public decimals;                //How many decimals to show. 
137     string public symbol;                 //An identifier: eg SBX
138     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
139 
140 //
141 // CHANGE THESE VALUES FOR YOUR TOKEN
142 //
143 
144  
145 
146     function SCARABToken1(
147         ) public {
148         balances[msg.sender] = 1000000000000000;               // Give the creator all initial tokens (100000 for example)
149         totalSupply = 1000000000000000;                        // Update total supply (100000 for example)
150         name = "SCARAB Token";                                   // Set the name for display purposes
151         decimals = 4;                            // Amount of decimals for display purposes
152         symbol = "SCARB";                               // Set the symbol for display purposes
153     }
154 
155     /* Approves and then calls the receiving contract */
156     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159 
160         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
161         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
162         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
163         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
164         return true;
165     }
166     
167    
168 }