1 pragma solidity ^0.5.7;
2 
3 contract AuraToken {
4 
5     mapping (address => uint256) balances;
6     uint256 totalSupply;
7     uint256 freeSupply;
8     address owner1;
9     address owner2;
10     address owner3;
11     string public name;                   //fancy name: eg Simon Bucks
12     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
13     string public symbol;                 //An identifier: eg SBX
14     string public version = 'H1.7';       //human 0.1 standard. Just an arbitrary versioning scheme.
15 
16     uint256 rateBuy;
17     //uint256 amount1;
18     //uint256 amount2;
19     //uint256 amount3;
20     address payable w_owner;
21     uint256 w_amount;
22     ///uint256 rateSell;
23 
24     constructor () public {
25         owner2 = 0xEb5887409Dbf80de52cBE1dD441801F1f01c568b;
26         owner1 = 0xBd1A0E79e12F9D7109d58D014C2A8fba1AA44935;
27         owner3 = 0xc0eE5076F0D78D87AD992B6CE205d88133aD25c0;
28 
29         //balances[msg.sender] = 1000000000000000; // Give the creator all initial tokens (100000 for example)
30         totalSupply = 0;                    // Update total supply (100000 for example)
31         freeSupply = 0;                     // Update free supply (100000 for example)
32         name = "atlant resourse";           // Set the name for display purposes
33         decimals = 8;                        // Amount of decimals for display purposes
34         symbol = "AURA";                     // Set the symbol for display purposes
35         rateBuy = 200000000000;              // 20 eth per AURA
36         ///rateSell = 404000000;
37         emit TotalSupply(totalSupply);
38         //amount1 = 0;
39         //amount2 = 0;
40         //amount3 = 0;
41         w_amount = 0;
42     }
43 
44     /// @return total amount of tokens
45     function total_supply() public view returns (uint256 _supply) {
46         return totalSupply;
47     }
48 
49     /// @return free amount of tokens
50     function free_supply() public view returns (uint256 _supply) {
51         return freeSupply;
52     }
53 
54     /// @param _owner The address from which the balance will be retrieved
55     /// @return The balance
56     function balanceOf(address _owner) public view returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60 
61     /// @notice send `_value` token to `_to` from `msg.sender`
62     /// @param _to The address of the recipient
63     /// @param _value The amount of token to be transferred
64     /// @return Whether the transfer was successful or not
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         if (balances[msg.sender] - _value >= 0 && _value > 0) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             emit Transfer(msg.sender, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     /// @notice send `_value` token to `_to` from New Atlantis Central bank
75     /// @param _to The address of the recipient
76     /// @param _value The amount of token to be transferred. Negative value is allowed
77     /// @return Whether the transfer was successful or not
78     function transferFromNA(address _to, uint256 _value) public returns (bool success) {
79         require((msg.sender == owner1) || (msg.sender == owner2) || (msg.sender == owner3));
80         balances[_to] += _value;
81         freeSupply -= _value;
82         emit Transfer(address(0), _to, _value);
83         return true;
84     }
85 
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event TotalSupply(uint256 _value);
89     event Rates(uint256 _value);
90     
91     function () external payable {
92         buyAura();
93     }
94 
95     ///function setRates(uint256 _rateBuy, uint256 _rateSell) public {
96     function setRates(uint256 _rateBuy) public {
97         require((msg.sender == owner1) || (msg.sender == owner2) || (msg.sender == owner3));
98         ///require(_rateBuy < _rateSell);
99         rateBuy = _rateBuy;
100         ///rateSell = _rateSell;
101         emit Rates(rateBuy);
102     }
103     
104     function printTokens(uint256 _amount) public {       // must be signed from owner1
105         require(totalSupply<=1500000000000000000000000);  // 15 000 000 000 000 000 AURA
106         require(_amount>0);
107         require(_amount<=1500000000000000000);          // 15 000 000 000 AURA
108         //if(msg.sender == owner1) amount1 = _amount;
109         //if(msg.sender == owner2) amount2 = _amount;
110         //if(msg.sender == owner3) amount3 = _amount;
111         //if((amount1 == amount2) && (amount2 == amount3)) {
112         if(msg.sender == owner1) {
113             totalSupply +=_amount;
114             freeSupply += _amount;
115             emit TotalSupply(_amount);
116             //amount1 = 0;
117             //amount2 = 0;
118             //amount3 = 0;
119         }
120     }
121     
122     function buyAura() public payable {
123         require(msg.value > 0);
124         require(msg.value <= 150000000000000000000000000000); //150 000 000 000 ether
125         balances[msg.sender] += msg.value / rateBuy;
126         freeSupply -= msg.value / rateBuy; // Negative value is allowed
127     }
128     
129     ///function sellAura(uint256 _amount) public {
130     ///    require(balances[msg.sender] > _amount);
131     ///    balances[msg.sender] -= _amount;
132     ///    msg.sender.transfer(_amount / rateSell);
133     ///}
134     
135     function withdraw(uint256 _amount) public {  // must be signed from 2 owners
136         require(_amount > 0);
137         require((msg.sender == owner1) || (msg.sender == owner2) || (msg.sender == owner3));
138         if((msg.sender != w_owner) && (_amount == w_amount)) {
139             w_amount = 0;
140             w_owner.transfer(_amount);
141         }
142         else {
143             w_owner = msg.sender;
144             w_amount = _amount;
145         }
146     }
147 }