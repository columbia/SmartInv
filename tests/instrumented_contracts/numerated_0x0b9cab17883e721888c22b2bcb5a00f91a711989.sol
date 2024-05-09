1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
21 
22 contract PIN is owned {
23     /* Public variables of the token */
24     string public standard = 'PIN 0.1';
25     string public name;
26     string public symbol;
27     uint8 public decimals = 0;
28     uint256 public totalSupply;
29     bool public locked;
30     uint256 public icoSince;
31     uint256 public icoTill;
32 
33      /* This creates an array with all balances */
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     /* This generates a public event on the blockchain that will notify clients */
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event IcoFinished();
40     event Burn(address indexed from, uint256 value);
41 
42     uint256 public buyPrice = 0.01 ether;
43 
44     /* Initializes contract with initial supply tokens to the creator of the contract */
45     function PIN(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol,
49         uint256 _icoSince,
50         uint256 _icoTill,
51         uint durationInDays
52     ) {
53         totalSupply = initialSupply;
54 
55         balanceOf[this] = totalSupply / 100 * 22;             // Give the smart contract 22% of initial tokens
56         name = tokenName;                                     // Set the name for display purposes
57         symbol = tokenSymbol;                                 // Set the symbol for display purposes
58 
59         balanceOf[msg.sender] = totalSupply / 100 * 78;       // Give remaining total supply to contract owner, will be destroyed
60 
61         Transfer(this, msg.sender, balanceOf[msg.sender]);
62 
63         if(_icoSince == 0 && _icoTill == 0) {
64             icoSince = now;
65             icoTill = now + durationInDays * 35 days;
66         }
67         else {
68             icoSince = _icoSince;
69             icoTill = _icoTill;
70         }
71     }
72 
73     /* Send coins */
74     function transfer(address _to, uint256 _value) {
75         require(locked == false);                            // Check if smart contract is locked
76 
77         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
78         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
79 
80         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
81         balanceOf[_to] += _value;                            // Add the same to the recipient
82         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
83     }
84 
85     /* Allow another contract to spend some tokens in your behalf */
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88 
89         return true;
90     }
91 
92     /* Approve and then communicate the approved contract in a single tx */
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         tokenRecipient spender = tokenRecipient(_spender);
95 
96         if (approve(_spender, _value)) {
97             spender.receiveApproval(msg.sender, _value, this, _extraData);
98             return true;
99         }
100     }
101 
102     /* A contract attempts to get the coins */
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104         require(locked == false);                            // Check if smart contract is locked
105         require(_value > 0);
106         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
107         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
108         require(_value <= allowance[_from][msg.sender]);     // Check allowance
109 
110         balanceOf[_from] -= _value;                          // Subtract from the sender
111         balanceOf[_to] += _value;                            // Add the same to the recipient
112         allowance[_from][msg.sender] -= _value;
113         Transfer(_from, _to, _value);
114 
115         return true;
116     }
117 
118     function buy(uint256 ethers, uint256 time) internal {
119         require(locked == false);                            // Check if smart contract is locked
120         require(time >= icoSince && time <= icoTill);        // check for ico dates
121         require(ethers > 0);                             // check if ethers is greater than zero
122 
123         uint amount = ethers / buyPrice;
124 
125         require(balanceOf[this] >= amount);                  // check if smart contract has sufficient number of tokens
126 
127         balanceOf[msg.sender] += amount;
128         balanceOf[this] -= amount;
129 
130         Transfer(this, msg.sender, amount);
131     }
132 
133     function () payable {
134         buy(msg.value, now);
135     }
136 
137     function internalIcoFinished(uint256 time) internal returns (bool) {
138         if(time > icoTill) {
139             uint256 unsoldTokens = balanceOf[this];
140 
141             balanceOf[owner] += unsoldTokens;
142             balanceOf[this] = 0;
143 
144             Transfer(this, owner, unsoldTokens);
145 
146             IcoFinished();
147 
148             return true;
149         }
150 
151         return false;
152     }
153 
154     function icoFinished() onlyOwner {
155         internalIcoFinished(now);
156     }
157 
158     function transferEthers() onlyOwner {
159         owner.transfer(this.balance);
160     }
161 
162     function setBuyPrice(uint256 _buyPrice) onlyOwner {
163         buyPrice = _buyPrice;
164     }
165 
166     function setLocked(bool _locked) onlyOwner {
167         locked = _locked;
168     }
169 
170     function burn(uint256 _value) onlyOwner returns (bool success) {
171         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
172         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
173         totalSupply -= _value;                                // Updates totalSupply
174         Burn(msg.sender, _value);
175         return true;
176     }
177 }