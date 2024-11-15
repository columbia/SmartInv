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
83     /* A contract attempts to get the coins */
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
85         require(locked == false);                            // Check if smart contract is locked
86         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
87         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89 
90         balanceOf[_from] -= _value;                          // Subtract from the sender
91         balanceOf[_to] += _value;                            // Add the same to the recipient
92         allowance[_from][msg.sender] -= _value;
93         Transfer(_from, _to, _value);
94 
95         return true;
96     }
97 
98     function buy(uint256 ethers, uint256 time) internal {
99         require(locked == false);                            // Check if smart contract is locked
100         require(time >= icoSince && time <= icoTill);        // check for ico dates
101         require(ethers > 0);                                 // check if ethers is greater than zero
102 
103         uint amount = ethers / buyPrice;
104 
105         require(balanceOf[this] >= amount);                  // check if smart contract has sufficient number of tokens
106 
107         balanceOf[msg.sender] += amount;
108         balanceOf[this] -= amount;
109 
110         Transfer(this, msg.sender, amount);
111     }
112 
113     function () payable {
114         buy(msg.value, now);
115     }
116 
117     function internalIcoFinished(uint256 time) internal returns (bool) {
118         if(time > icoTill) {
119             uint256 unsoldTokens = balanceOf[this];
120 
121             balanceOf[owner] += unsoldTokens;
122             balanceOf[this] = 0;
123 
124             Transfer(this, owner, unsoldTokens);
125 
126             IcoFinished();
127 
128             return true;
129         }
130 
131         return false;
132     }
133 
134     /* 0x356e2927 */
135     function icoFinished() onlyOwner {
136         internalIcoFinished(now);
137     }
138 
139     /* 0xd271011d */
140     function transferEthers() onlyOwner {
141         owner.transfer(this.balance);
142     }
143 
144     function setBuyPrice(uint256 _buyPrice) onlyOwner {
145         buyPrice = _buyPrice;
146     }
147 
148     /*
149        locking: 0x211e28b60000000000000000000000000000000000000000000000000000000000000001
150        unlocking: 0x211e28b60000000000000000000000000000000000000000000000000000000000000000
151     */
152     function setLocked(bool _locked) onlyOwner {
153         locked = _locked;
154     }
155 }