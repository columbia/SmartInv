1 pragma solidity ^0.4.17;
2 
3 contract AirDropToken {
4 
5     event Transfer(address indexed from, address indexed to, uint256 tokens);
6     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
7 
8     string _name;
9     string _symbol;
10     uint8 _decimals;
11 
12     uint256 _totalSupply;
13 
14     bytes32 _rootHash;
15 
16     mapping (address => uint256) _balances;
17     mapping (address => mapping(address => uint256)) _allowed;
18 
19     mapping (uint256 => uint256) _redeemed;
20 
21     function AirDropToken(string name, string symbol, uint8 decimals, bytes32 rootHash, uint256 premine) public {
22         _name = name;
23         _symbol = symbol;
24         _decimals = decimals;
25         _rootHash = rootHash;
26 
27         if (premine > 0) {
28             _balances[msg.sender] = premine;
29             _totalSupply = premine;
30             Transfer(0, msg.sender, premine);
31         }
32     }
33 
34     function name() public constant returns (string name) {
35         return _name;
36     }
37 
38     function symbol() public constant returns (string symbol) {
39         return _symbol;
40     }
41 
42     function decimals() public constant returns (uint8 decimals) {
43         return _decimals;
44     }
45 
46     function totalSupply() public constant returns (uint256 totalSupply) {
47         return _totalSupply;
48     }
49 
50     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
51          return _balances[tokenOwner];
52     }
53 
54     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
55         return _allowed[tokenOwner][spender];
56     }
57 
58     function transfer(address to, uint256 amount) public returns (bool success) {
59         if (_balances[msg.sender] < amount) { return false; }
60 
61         _balances[msg.sender] -= amount;
62         _balances[to] += amount;
63 
64         Transfer(msg.sender, to, amount);
65 
66         return true;
67     }
68 
69     function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
70 
71         if (_allowed[from][msg.sender] < amount || _balances[from] < amount) {
72             return false;
73         }
74 
75         _balances[from] -= amount;
76         _allowed[from][msg.sender] -= amount;
77         _balances[to] += amount;
78 
79         Transfer(from, to, amount);
80 
81         return true;
82     }
83 
84     function approve(address spender, uint256 amount) public returns (bool success) {
85         _allowed[msg.sender][spender] = amount;
86 
87         Approval(msg.sender, spender, amount);
88 
89         return true;
90     }
91 
92     function redeemed(uint256 index) public constant returns (bool redeemed) {
93         uint256 redeemedBlock = _redeemed[index / 256];
94         uint256 redeemedMask = (uint256(1) << uint256(index % 256));
95         return ((redeemedBlock & redeemedMask) != 0);
96     }
97 
98     function redeemPackage(uint256 index, address recipient, uint256 amount, bytes32[] merkleProof) public {
99 
100         // Make sure this package has not already been claimed (and claim it)
101         uint256 redeemedBlock = _redeemed[index / 256];
102         uint256 redeemedMask = (uint256(1) << uint256(index % 256));
103         require((redeemedBlock & redeemedMask) == 0);
104         _redeemed[index / 256] = redeemedBlock | redeemedMask;
105 
106         // Compute the merkle root
107         bytes32 node = keccak256(index, recipient, amount);
108         uint256 path = index;
109         for (uint16 i = 0; i < merkleProof.length; i++) {
110             if ((path & 0x01) == 1) {
111                 node = keccak256(merkleProof[i], node);
112             } else {
113                 node = keccak256(node, merkleProof[i]);
114             }
115             path /= 2;
116         }
117 
118         // Check the merkle proof
119         require(node == _rootHash);
120 
121         // Redeem!
122         _balances[recipient] += amount;
123         _totalSupply += amount;
124 
125         Transfer(0, recipient, amount);
126     }
127 }