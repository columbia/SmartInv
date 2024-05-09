1 pragma solidity ^0.5.8;
2 
3 contract ERC20Interface {
4 
5     function name() public view returns (string memory);
6 
7     function symbol() public view returns (string memory);
8 
9     function decimals() public view returns (uint8);
10 
11     function totalSupply() public view returns (uint);
12 
13     function balanceOf(address tokenOwner) public view returns (uint balance);
14 
15     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
16 
17     function transfer(address to, uint tokens) public returns (bool success);
18 
19     function approve(address spender, uint tokens) public returns (bool success);
20 
21     function transferFrom(address from, address to, uint tokens) public returns (bool success);
22 
23     function burn(uint256 amount) public;
24 
25 
26     event Transfer(address indexed from, address indexed to, uint tokens);
27 
28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
29 
30 }
31 
32 contract MerkleDrop {
33 
34     bytes32 public root;
35     ERC20Interface public droppedToken;
36     uint public decayStartTime;
37     uint public decayDurationInSeconds;
38 
39     uint public initialBalance;
40     uint public remainingValue;  // The total of not withdrawn entitlements, not considering decay
41     uint public spentTokens;  // The total tokens spent by the contract, burnt or withdrawn
42 
43     mapping (address => bool) public withdrawn;
44 
45     event Withdraw(address recipient, uint value, uint originalValue);
46     event Burn(uint value);
47 
48     constructor(ERC20Interface _droppedToken, uint _initialBalance, bytes32 _root, uint _decayStartTime, uint _decayDurationInSeconds) public {
49         // The _initialBalance should be equal to the sum of airdropped tokens
50         droppedToken = _droppedToken;
51         initialBalance = _initialBalance;
52         remainingValue = _initialBalance;
53         root = _root;
54         decayStartTime = _decayStartTime;
55         decayDurationInSeconds = _decayDurationInSeconds;
56     }
57 
58     function withdraw(uint value, bytes32[] memory proof) public {
59         require(verifyEntitled(msg.sender, value, proof), "The proof could not be verified.");
60         require(! withdrawn[msg.sender], "You have already withdrawn your entitled token.");
61 
62         burnUnusableTokens();
63 
64         uint valueToSend = decayedEntitlementAtTime(value, now, false);
65         assert(valueToSend <= value);
66         require(droppedToken.balanceOf(address(this)) >= valueToSend, "The MerkleDrop does not have tokens to drop yet / anymore.");
67         require(valueToSend != 0, "The decayed entitled value is now zero.");
68 
69         withdrawn[msg.sender] = true;
70         remainingValue -= value;
71         spentTokens += valueToSend;
72 
73         require(droppedToken.transfer(msg.sender, valueToSend));
74         emit Withdraw(msg.sender, valueToSend, value);
75     }
76 
77     function verifyEntitled(address recipient, uint value, bytes32[] memory proof) public view returns (bool) {
78         // We need to pack the 20 bytes address to the 32 bytes value
79         // to match with the proof made with the python merkle-drop package
80         bytes32 leaf = keccak256(abi.encodePacked(recipient, value));
81         return verifyProof(leaf, proof);
82     }
83 
84     function decayedEntitlementAtTime(uint value, uint time, bool roundUp) public view returns (uint) {
85         if (time <= decayStartTime) {
86             return value;
87         } else if (time >= decayStartTime + decayDurationInSeconds) {
88             return 0;
89         } else {
90             uint timeDecayed = time - decayStartTime;
91             uint valueDecay = decay(value, timeDecayed, decayDurationInSeconds, !roundUp);
92             assert(valueDecay <= value);
93             return value - valueDecay;
94         }
95     }
96 
97     function burnUnusableTokens() public {
98         if (now <= decayStartTime) {
99             return;
100         }
101 
102         // The amount of tokens that should be held within the contract after burning
103         uint targetBalance = decayedEntitlementAtTime(remainingValue, now, true);
104 
105         // toBurn = (initial balance - target balance) - what we already removed from initial balance
106         uint currentBalance = initialBalance - spentTokens;
107         assert(targetBalance <= currentBalance);
108         uint toBurn = currentBalance - targetBalance;
109 
110         spentTokens += toBurn;
111         burn(toBurn);
112     }
113 
114     function deleteContract() public {
115         require(now >= decayStartTime + decayDurationInSeconds, "The storage cannot be deleted before the end of the merkle drop.");
116         burnUnusableTokens();
117 
118         selfdestruct(address(0));
119     }
120 
121     function verifyProof(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
122         bytes32 currentHash = leaf;
123 
124         for (uint i = 0; i < proof.length; i += 1) {
125             currentHash = parentHash(currentHash, proof[i]);
126         }
127 
128         return currentHash == root;
129     }
130 
131     function parentHash(bytes32 a, bytes32 b) internal pure returns (bytes32) {
132         if (a < b) {
133             return keccak256(abi.encode(a, b));
134         } else {
135             return keccak256(abi.encode(b, a));
136         }
137     }
138 
139     function burn(uint value) internal {
140         if (value == 0) {
141             return;
142         }
143         emit Burn(value);
144         droppedToken.burn(value);
145     }
146 
147     function decay(uint value, uint timeToDecay, uint totalDecayTime, bool roundUp) internal pure returns (uint) {
148         uint decay;
149 
150         if (roundUp) {
151             decay = (value*timeToDecay+totalDecayTime-1)/totalDecayTime;
152         } else {
153             decay = value*timeToDecay/totalDecayTime;
154         }
155         return decay >= value ? value : decay;
156     }
157 }