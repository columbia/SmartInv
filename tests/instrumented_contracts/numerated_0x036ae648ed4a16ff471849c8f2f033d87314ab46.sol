1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11   /** 
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner. 
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to. 
30    */
31   function transferOwnership(address newOwner) onlyOwner public {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 
37 }
38 
39 
40 /**
41  * Math operations with safety checks
42  */
43 library SafeMath {
44   function mul(uint a, uint b) internal returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint a, uint b) internal returns (uint) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint a, uint b) internal returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint a, uint b) internal returns (uint) {
63     uint c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 
68   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a >= b ? a : b;
70   }
71 
72   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
73     return a < b ? a : b;
74   }
75 
76   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a >= b ? a : b;
78   }
79 
80   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
81     return a < b ? a : b;
82   }
83 
84 }
85 
86 
87 /**
88  * @title HardCap
89  * @dev Allows updating and retrieveing of Conversion HardCap for ABLE tokens
90  *
91  * ABI
92  * [{"constant": true,"inputs": [{"name": "_symbol","type": "string"}],"name": "getCap","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_symbol","type": "string"},{"name": "_cap","type": "uint256"}],"name": "updateCap","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "data","type": "uint256[]"}],"name": "updateCaps","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "getHardCap","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "","type": "bytes32"}],"name": "caps","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": false,"name": "timestamp","type": "uint256"},{"indexed": false,"name": "symbol","type": "bytes32"},{"indexed": false,"name": "rate","type": "uint256"}],"name": "CapUpdated","type": "event"}]
93  */
94 contract HardCap is Ownable {
95   using SafeMath for uint;
96   event CapUpdated(uint timestamp, bytes32 symbol, uint rate);
97   
98   mapping(bytes32 => uint) public caps;
99   uint hardcap = 0;
100 
101   /**
102    * @dev Allows the current owner to update a single cap.
103    * @param _symbol The symbol to be updated. 
104    * @param _cap the cap for the symbol. 
105    */
106   function updateCap(string _symbol, uint _cap) public onlyOwner {
107     caps[sha3(_symbol)] = _cap;
108     hardcap = hardcap.add(_cap) ;
109     CapUpdated(now, sha3(_symbol), _cap);
110   }
111 
112   /**
113    * @dev Allows the current owner to update multiple caps.
114    * @param data an array that alternates sha3 hashes of the symbol and the corresponding cap . 
115    */
116   function updateCaps(uint[] data) public onlyOwner {
117     require(data.length % 2 == 0);
118     uint i = 0;
119     while (i < data.length / 2) {
120       bytes32 symbol = bytes32(data[i * 2]);
121       uint cap = data[i * 2 + 1];
122       caps[symbol] = cap;
123       hardcap = hardcap.add(cap);
124       CapUpdated(now, symbol, cap);
125       i++;
126     }
127   }
128 
129   /**
130    * @dev Allows the anyone to read the current cap.
131    * @param _symbol the symbol to be retrieved. 
132    */
133   function getCap(string _symbol) public constant returns(uint) {
134     return caps[sha3(_symbol)];
135   }
136   
137   /**
138    * @dev Allows the anyone to read the current hardcap.
139    */
140   function getHardCap() public constant returns(uint) {
141     return hardcap;
142   }
143 
144 }