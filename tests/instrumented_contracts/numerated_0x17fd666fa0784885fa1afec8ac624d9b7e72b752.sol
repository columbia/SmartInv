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
22 contract FLiK is owned {
23     /* Public variables of the token */
24     string public standard = 'FLiK 0.1';
25     string public name;
26     string public symbol;
27     uint8 public decimals = 14;
28     uint256 public totalSupply;
29     bool public locked;
30     uint256 public icoSince;
31     uint256 public icoTill;
32     
33     /* This creates an array with all balances */
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     /* This generates a public event on the blockchain that will notify clients */
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event IcoFinished();
40 
41     uint256 public buyPrice = 1;
42 
43     /* Initializes contract with initial supply tokens to the creator of the contract */
44     function FLiK(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol,
48         uint256 _icoSince,
49         uint256 _icoTill
50     ) {
51         totalSupply = initialSupply;
52         
53         balanceOf[this] = totalSupply / 100 * 90;           // Give the smart contract 90% of initial tokens
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
56 
57         balanceOf[msg.sender] = totalSupply / 100 * 10;     // Give 10% of total supply to contract owner
58 
59         Transfer(this, msg.sender, balanceOf[msg.sender]);
60 
61         if(_icoSince == 0 && _icoTill == 0) {
62             icoSince = 1503187200;
63             icoTill = 1505865600;
64         }
65         else {
66             icoSince = _icoSince;
67             icoTill = _icoTill;
68         }
69     }
70 
71     /* Send coins */
72     function transfer(address _to, uint256 _value) {
73         require(locked == false);                            // Check if smart contract is locked
74 
75         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
76         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
77 
78         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
79         balanceOf[_to] += _value;                            // Add the same to the recipient
80         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
81     }
82 
83     /* Allow another contract to spend some tokens in your behalf */
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86 
87         return true;
88     }
89 
90     /* Approve and then communicate the approved contract in a single tx */
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
92         tokenRecipient spender = tokenRecipient(_spender);
93 
94         if (approve(_spender, _value)) {
95             spender.receiveApproval(msg.sender, _value, this, _extraData);
96             return true;
97         }
98     }
99 
100     /* A contract attempts to get the coins */
101     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
102         require(locked == false);                            // Check if smart contract is locked
103         require(_value > 0);
104         require(balanceOf[_from] >= _value);                  // Check if the sender has enough
105         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107 
108         balanceOf[_from] -= _value;                          // Subtract from the sender
109         balanceOf[_to] += _value;                            // Add the same to the recipient
110         allowance[_from][msg.sender] -= _value;
111         Transfer(_from, _to, _value);
112 
113         return true;
114     }
115 
116     function buy(uint256 ethers, uint256 time) internal {
117         require(locked == false);                            // Check if smart contract is locked
118         require(time >= icoSince && time <= icoTill);        // check for ico dates
119         require(ethers > 0);                                 // check if ethers is greater than zero
120 
121         uint amount = ethers / buyPrice;
122 
123         require(balanceOf[this] >= amount);                  // check if smart contract has sufficient number of tokens
124 
125         balanceOf[msg.sender] += amount;
126         balanceOf[this] -= amount;
127 
128         Transfer(this, msg.sender, amount);
129     }
130 
131     function () payable {
132         buy(msg.value, now);
133     }
134 
135     function internalIcoFinished(uint256 time) internal returns (bool) {
136         if(time > icoTill) {
137             uint256 unsoldTokens = balanceOf[this];
138 
139             balanceOf[owner] += unsoldTokens;
140             balanceOf[this] = 0;
141 
142             Transfer(this, owner, unsoldTokens);
143 
144             IcoFinished();
145 
146             return true;
147         }
148 
149         return false;
150     }
151 
152     /* 0x356e2927 */
153     function icoFinished() onlyOwner {
154         internalIcoFinished(now);
155     }
156 
157     /* 0xd271011d */
158     function transferEthers() onlyOwner {
159         owner.transfer(this.balance);
160     }
161 
162     function setBuyPrice(uint256 _buyPrice) onlyOwner {
163         buyPrice = _buyPrice;
164     }
165 
166     /*
167        locking: 0x211e28b60000000000000000000000000000000000000000000000000000000000000001
168        unlocking: 0x211e28b60000000000000000000000000000000000000000000000000000000000000000
169     */
170     function setLocked(bool _locked) onlyOwner {
171         locked = _locked;
172     }
173 }