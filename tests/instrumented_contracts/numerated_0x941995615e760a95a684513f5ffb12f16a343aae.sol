1 pragma solidity ^0.4.13;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MyToken {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     string public votingDescription;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     mapping (address => uint256) public voted;  
17     mapping (address => string) public votedFor;  
18 
19 
20     /* This generates a public event on the blockchain that will notify clients */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /* This notifies clients about the amount burnt */
24     event Burn(address indexed from, uint256 value);
25 
26     /* This notifies clients about the voting */
27     event voting(address target, uint256 voteType, string votedDesc);
28     
29     
30     /* Initializes contract with initial supply tokens to the creator of the contract */
31     function MyToken() {
32         balanceOf[msg.sender] = 500000;              // Give the creator all initial tokens
33         totalSupply = 500000;                        // Update total supply
34         name = 'GamityTest';                                   // Set the name for display purposes
35         symbol = 'GMTEST';                                     // Set the symbol for display purposes
36         decimals = 1;                                       // Amount of decimals for display purposes
37     }
38 
39     /* Internal transfer, only can be called by this contract */
40     function _transfer(address _from, address _to, uint _value) internal {
41         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
42         require (balanceOf[_from] > _value);                // Check if the sender has enough
43         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
44         balanceOf[_from] -= _value;                         // Subtract from the sender
45         balanceOf[_to] += _value;                            // Add the same to the recipient
46         Transfer(_from, _to, _value);
47     }
48 
49     /// @notice Send `_value` tokens to `_to` from your account
50     /// @param _to The address of the recipient
51     /// @param _value the amount to send
52     function transfer(address _to, uint256 _value) {
53         _transfer(msg.sender, _to, _value);
54     }
55 
56     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
57     /// @param _from The address of the sender
58     /// @param _to The address of the recipient
59     /// @param _value the amount to send
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         require (_value < allowance[_from][msg.sender]);     // Check allowance
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
68     /// @param _spender The address authorized to spend
69     /// @param _value the max amount they can spend
70     function approve(address _spender, uint256 _value)
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         return true;
74     }
75 
76     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
77     /// @param _spender The address authorized to spend
78     /// @param _value the max amount they can spend
79     /// @param _extraData some extra information to send to the approved contract
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         returns (bool success) {
82         tokenRecipient spender = tokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(msg.sender, _value, this, _extraData);
85             return true;
86         }
87     }        
88 
89     /// @notice Remove `_value` tokens from the system irreversibly
90     /// @param _value the amount of money to burn
91     function burn(uint256 _value) returns (bool success) {
92         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
93         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
94         totalSupply -= _value;                                // Updates totalSupply
95         Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) returns (bool success) {
100         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
101         require(_value <= allowance[_from][msg.sender]);    // Check allowance
102         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
103         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
104         totalSupply -= _value;                              // Update totalSupply
105         Burn(_from, _value);
106         return true;
107     }
108     
109     
110     
111     
112     
113     function voteFor()  returns (bool success){   
114         voted[msg.sender] = 1;    
115         votedFor[msg.sender] = votingDescription;    
116         voting (msg.sender, 1, votingDescription);          
117         return true;                                  // ends function and returns
118     }
119     
120     function voteAgainst()  returns (bool success){   
121         voted[msg.sender] = 2;
122         votedFor[msg.sender] = votingDescription;   
123         voting (msg.sender, 2, votingDescription);          
124         return true;                                  // ends function and returns
125     }
126     
127     
128     
129    function newVoting(string description)  returns (bool success){    
130         require(msg.sender == 0x02A97eD35Ba18D2F3C351a1bB5bBA12f95Eb1181);
131         votingDescription=description;
132         return true; 
133     }
134     
135     
136     
137     
138     
139     
140     
141     
142     
143 }