1 pragma solidity ^0.4.11;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract MessageToken {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     address owner;
12     address EMSAddress;
13 
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     /* This generates a public event on the blockchain that will notify clients */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /* This notifies clients about the amount burnt */
22     event Burn(address indexed from, uint256 value);
23 
24     /* Initializes contract with initial supply tokens to the creator of the contract */
25     function MessageToken() {
26         balanceOf[this] = 10000000000000000000000000000000000000;              // Give the contract all initial tokens
27         totalSupply = 10000000000000000000000000000000000000;                        // Update total supply
28         name = "Messages";                                   // Set the name for display purposes
29         symbol = "\u2709";                               // Set the symbol for display purposes
30         decimals = 0;                            // Amount of decimals for display purposes
31         owner = msg.sender;
32     }
33 
34     /* Send coins */
35     function transfer(address _to, uint256 _value) {
36         if (_to != address(this)) throw;                     // Prevent sending message tokens to other people
37         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
38         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
39         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
40         balanceOf[_to] += _value;                            // Add the same to the recipient
41         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
42     }
43 
44     /* Allow message contract to spend some tokens in your behalf */
45     function approve(address _spender, uint256 _value)
46         returns (bool success) {
47             if(msg.sender == owner){
48                 EMSAddress = _spender;
49                 allowance[this][_spender] = _value;
50                 return true;
51             }
52     }
53     
54     function register(address _address)
55         returns (bool success){
56             if(msg.sender == EMSAddress){
57                 allowance[_address][EMSAddress] = totalSupply;
58                 return true;
59             }
60         }
61 
62     /* A contract attempts to get the coins */
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
65         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
66         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
67         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
68         balanceOf[_from] -= _value;                           // Subtract from the sender
69         balanceOf[_to] += _value;                             // Add the same to the recipient
70         allowance[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74     
75     function getBalance(address _address) constant returns (uint256 balance){
76         return balanceOf[_address];
77     }
78 }
79 
80 contract EMS{
81     address messageTokenContract = 0xb535394330357396680a5542767A190193F9D2Ab;
82     MessageToken m = MessageToken(messageTokenContract);
83     struct message{
84         address sender;
85         address recipient;
86         string message;
87     }
88     
89     struct inbox{
90         string[] messages;
91         uint256 numMessages;
92         bool registered;
93     }
94     
95     mapping (address => inbox) inboxes;
96     
97     function sendMessage(address recipient, string message){
98         if(inboxes[msg.sender].registered != true){
99             m.register(msg.sender);
100         }
101         m.transferFrom(messageTokenContract, recipient, 1);
102         inboxes[recipient].messages.push(message);
103         inboxes[recipient].numMessages++;
104     }
105     
106     function markAllRead(){
107         if(inboxes[msg.sender].registered != true){
108             m.register(msg.sender);
109         }
110         m.transferFrom(msg.sender, messageTokenContract, m.getBalance(msg.sender));
111     }
112     
113     function markRead(uint numMessages){
114         if(inboxes[msg.sender].registered != true){
115             m.register(msg.sender);
116         }
117         m.transferFrom(msg.sender, messageTokenContract, numMessages);
118     }
119     
120     function deleteAllMessages(){
121         markAllRead();
122         for(uint i = 0; i < inboxes[msg.sender].numMessages; i++){
123             inboxes[msg.sender].messages[i] = "";
124         }
125     }
126     
127     function deleteMessage(uint messageNumber){
128         if(inboxes[msg.sender].registered != true){
129             m.register(msg.sender);
130         }
131         inboxes[msg.sender].messages[messageNumber] = "";
132         m.transferFrom(msg.sender, messageTokenContract, 1);
133     }
134     
135     function getInbox(address _address, uint messageNumber) constant returns (string messages){
136         return inboxes[_address].messages[messageNumber];
137     }
138 }