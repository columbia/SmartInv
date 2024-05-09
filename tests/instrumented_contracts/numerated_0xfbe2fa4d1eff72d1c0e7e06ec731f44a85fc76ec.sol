1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     uint256 public totalSupply;
5 
6     /* This creates an array with all balances */
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9 
10     /* This generates a public event on the blockchain that will notify clients */
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     /* Send coins */
14     function transfer(address _to, uint256 _value) {
15         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
16         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
17         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
18         balanceOf[_to] += _value;                            // Add the same to the recipient
19         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
20     }
21 
22     /* Allow another contract to spend some tokens in your behalf */
23     function approve(address _spender, uint256 _value) returns (bool success) {
24         allowance[msg.sender][_spender] = _value;
25         return true;
26     }
27 
28     /* A contract attempts to get the coins */
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
31         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
32         require(_value <= allowance[_from][msg.sender]);     // Check allowance
33         balanceOf[_from] -= _value;                          // Subtract from the sender
34         balanceOf[_to] += _value;                            // Add the same to the recipient
35         allowance[_from][msg.sender] -= _value;
36         Transfer(_from, _to, _value);
37         return true;
38     }
39 
40     uint public id; /* To ensure distinct contracts for different tokens owned by the same owner */
41     address public owner;
42     bool public sealed = false;
43 
44     function Token(uint _id) {
45         owner = msg.sender;
46         id = _id;
47     }
48 
49     /* Allows the owner to mint more tokens */
50     function mint(address _to, uint256 _value) returns (bool) {
51         require(msg.sender == owner);                        // Only the owner is allowed to mint
52         require(!sealed);                                    // Can only mint while unsealed
53         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
54         balanceOf[_to] += _value;
55         totalSupply += _value;
56         return true;
57     }
58 
59     function seal() {
60         require(msg.sender == owner);
61         sealed = true;
62     }
63 }
64 
65 contract Withdraw {
66     Token public token;
67 
68     function Withdraw(Token _token) {
69         token = _token;
70     }
71 
72     function () payable {}
73 
74     function withdraw() {
75         require(token.sealed());
76         require(token.balanceOf(msg.sender) > 0);
77         uint token_amount = token.balanceOf(msg.sender);
78         uint wei_amount = this.balance * token_amount / token.totalSupply();
79         if (!token.transferFrom(msg.sender, this, token_amount) || !msg.sender.send(wei_amount)) {
80             throw;
81         }
82     }
83 }
84 
85 contract TokenGame {
86     address public owner;
87     uint public cap_in_wei;
88     uint constant initial_duration = 1 hours;
89     uint constant time_extension_from_doubling = 1 hours;
90     uint constant time_of_half_decay = 1 hours;
91     Token public excess_token; /* Token contract used to receive excess after the sale */
92     Withdraw public excess_withdraw;  /* Withdraw contract distributing the excess */
93     Token public game_token;   /* Token contract used to receive prizes */
94     uint public end_time;      /* Current end time */
95     uint last_time = 0;        /* Timestamp of the latest contribution */
96     uint256 ema = 0;           /* Current value of the EMA */
97     uint public total_wei_given = 0;  /* Total amount of wei given via fallback function */
98 
99     function TokenGame(uint _cap_in_wei) {
100         owner = msg.sender;
101         cap_in_wei = _cap_in_wei;
102         excess_token = new Token(1);
103         excess_withdraw = new Withdraw(excess_token);
104         game_token = new Token(2);
105         end_time = now + initial_duration;
106     }
107 
108     function play() payable {
109         require(now <= end_time);   // Check that the sale has not ended
110         require(msg.value > 0);     // Check that something has been sent
111         total_wei_given += msg.value;
112         ema = msg.value + ema * time_of_half_decay / (time_of_half_decay + (now - last_time) );
113         last_time = now;
114         uint extended_time = now + ema * time_extension_from_doubling / total_wei_given;
115         if (extended_time > end_time) {
116             end_time = extended_time;
117         }
118         if (!excess_token.mint(msg.sender, msg.value) || !game_token.mint(msg.sender, msg.value)) {
119             throw;
120         }
121     }
122 
123     function finalise() {
124         require(now > end_time);
125         excess_token.seal();
126         game_token.seal();
127         uint to_owner = 0;
128         if (this.balance > cap_in_wei) {
129             to_owner = cap_in_wei;
130             if (!excess_withdraw.send(this.balance - cap_in_wei)) {
131                 throw;
132             }
133         } else {
134             to_owner = this.balance;
135         }
136         if (to_owner > 0) {
137             if (!owner.send(to_owner)) {
138                 throw;
139             }
140         }
141     }
142 }
143 
144 contract ZeroCap is TokenGame {
145     Withdraw public game_withdraw;
146 
147     function ZeroCap() TokenGame(0) {
148         game_withdraw = new Withdraw(game_token);
149     }
150 }