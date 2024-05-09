1 pragma solidity ^0.5;
2 
3 contract Token {
4 
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) view public returns (uint256 balance) {}
8 
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) public returns (bool success) {}
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {}
21 
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value)  public returns (bool success) {}
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 
36 }
37 
38 
39 
40 contract StandardToken is Token {
41 
42 
43     function transfer(address _to, uint256 _value) public returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             emit Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             emit Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) view public returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public circulatingSupply;
85 }
86 
87 
88 //name this contract whatever you'd like
89 contract ZuckBucks is StandardToken {
90     /* Public variables of the token */
91 
92     /*
93     NOTE:
94     The following variables are OPTIONAL vanities. One does not have to include them.
95     They allow one to customise the token contract & in no way influences the core functionality.
96     Some wallets/interfaces might not even bother to look at this information.
97     */
98     string public name;                   //fancy name: eg Simon Bucks
99     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
100     string public symbol;                 //An identifier: eg SBX
101     address payable private owner;
102     uint public totalSupply;
103 
104     uint256 public starting_giveaway;
105     uint256 public next_giveaway;
106     uint256 private giveaway_count;
107     
108     function () external payable {
109         //if ether is sent to this address, send it back.
110         uint256 eth_val = msg.value;
111         
112         uint256 giveaway_value;
113 
114         giveaway_count++;
115 
116         giveaway_value = (((starting_giveaway / giveaway_count) + (starting_giveaway / (giveaway_count + 2))) * (10**18 + eth_val)) / 10**18;
117         next_giveaway = (starting_giveaway / (giveaway_count + 1)) + (starting_giveaway / (giveaway_count + 3));
118 
119 
120         balances[msg.sender] += giveaway_value;
121         balances[owner] -= giveaway_value;
122         circulatingSupply += giveaway_value;
123         emit Transfer(owner, msg.sender, giveaway_value);
124         
125         // revert();
126         owner.transfer(eth_val);
127     }
128 
129 
130 
131     constructor() ZuckBucks (
132         ) public {
133         totalSupply = 1500000;                        // Update total supply (1500000 for example)
134         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens (100000 for example)
135         circulatingSupply = 0;
136         name = "Zuck Bucks";                                   // Set the name for display purposes
137         decimals = 0;                            // Amount of decimals for display purposes
138         symbol = "ZBUX";                               // Set the symbol for display purposes
139         starting_giveaway = 50000;
140         next_giveaway = 0;
141         owner = msg.sender;
142         giveaway_count = 0;
143     }
144 
145 
146 
147 }