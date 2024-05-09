1 pragma solidity 0.5.3;
2 interface erc20token {
3     function transfer(address _to, uint256 _amount) external returns (bool);
4     function balanceOf(address _p) external returns (uint256);
5     function decimals() external returns (uint256);
6 }
7 contract dapMerkle {
8     
9     /* variables */
10     bytes32 public root;
11     erc20token public token;
12     address payable owner;
13     uint256 public amountSent;
14     
15     /* storage */
16     mapping (address => bool) public sent;
17     
18     /* events */
19     event tokensSent(address to, uint256 amount);
20     event rootChanged(bytes32 root);
21     
22     /* modifiers */
23     modifier onlyOwner(){
24         if (msg.sender == owner){
25             _;
26         }
27     }
28     constructor (address _token, bytes32 _merkleRoot) public{
29         owner = msg.sender;
30         root = _merkleRoot;
31         token = erc20token(_token);
32     }
33     function setRoot(bytes32 _root) external onlyOwner {
34         root = _root;
35         emit rootChanged(_root);
36     }
37     
38     function getTokenBalance() external returns (uint256){
39         return token.balanceOf(address(this));
40     }
41     
42     function abortAirdrop() onlyOwner external{
43         require(token.balanceOf(address(this)) > 0);
44         assert( token.transfer(owner, token.balanceOf( address(this) ) ) );
45         selfdestruct(owner);
46     }
47     function getTokens(bytes32[] calldata _proof, address _receiver, uint256 _amount) external returns (bool){
48         require (!sent[_receiver]);
49         require (_amount > 0);
50         require( verify(_proof, makeLeaf(_receiver, _amount)) );
51         uint256 decimals = token.decimals();
52         uint256 amount = _amount*(10**decimals);
53         sent[_receiver] = true;
54         assert(token.transfer(_receiver, amount));
55         amountSent += _amount;
56         emit tokensSent(_receiver, _amount);
57         return true;
58         
59     }
60 
61      function addressToAsciiString(address x) internal pure returns (string memory) {
62         bytes memory s = new bytes(40);
63         for (uint i = 0; i < 20; i++) {
64             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
65             byte hi = byte(uint8(b) / 16);
66             byte lo = byte(uint8(b) - 16 * uint8(hi));
67             s[2*i] = char(hi);
68             s[2*i+1] = char(lo);
69         }
70         return string(s);
71     }
72 
73     function char(byte b) internal pure returns (byte c) {
74         if (b < byte(uint8(10))) return byte(uint8(b) + 0x30);
75         else return byte(uint8(b) + 0x57);
76     }
77     
78     function uintToStr(uint i) internal pure returns (string memory){
79         if (i == 0) return "0";
80         uint j = i;
81         uint length;
82         while (j != 0){
83             length++;
84             j /= 10;
85         }
86         bytes memory bstr = new bytes(length);
87         uint k = length - 1;
88         while (i != 0){
89             bstr[k--] = byte(uint8(48 + i % 10));
90             i /= 10;
91         }
92         return string(bstr);
93     }
94     
95      function makeLeaf(address _a, uint256 _n) internal pure returns(bytes32) {
96         string memory prefix = "0x";
97         string memory space = " ";
98 
99         
100         bytes memory _ba = bytes(prefix);
101         bytes memory _bb = bytes(addressToAsciiString(_a));
102         bytes memory _bc = bytes(space);
103         bytes memory _bd = bytes(uintToStr(_n));
104         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length);
105         bytes memory babcde = bytes(abcde);
106         uint k = 0;
107         for (uint8 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
108         for (uint8 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
109         for (uint8 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
110         for (uint8 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
111 
112         return keccak256(babcde);
113     }
114     function verify(bytes32[] memory proof, bytes32 leaf) internal view returns (bool) {
115         bytes32 computedHash = leaf;
116 
117         for (uint256 i = 0; i < proof.length; i++) {
118             bytes32 proofElement = proof[i];
119 
120             if (computedHash < proofElement) {
121                 // Hash(current computed hash + current element of the proof)
122                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
123             } else {
124                 // Hash(current element of the proof + current computed hash)
125                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
126             }
127         }
128 
129         // Check if the computed hash (root) is equal to the provided root
130         return computedHash == root;
131     }
132     function makeString(address _a, uint256 _n) external pure returns(bytes memory){
133         string memory prefix = "0x";
134         string memory space = " ";
135 
136         
137         bytes memory _ba = bytes(prefix);
138         bytes memory _bb = bytes(addressToAsciiString(_a));
139         bytes memory _bc = bytes(space);
140         bytes memory _bd = bytes(uintToStr(_n));
141         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length);
142         bytes memory babcde = bytes(abcde);
143         uint k = 0;
144         for (uint8 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
145         for (uint8 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
146         for (uint8 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
147         for (uint8 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
148 
149         return babcde;
150     }
151 }