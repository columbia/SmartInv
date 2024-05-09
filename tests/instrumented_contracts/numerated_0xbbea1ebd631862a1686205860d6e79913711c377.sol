1 pragma solidity >=0.7.0 <0.9.0;
2 pragma experimental ABIEncoderV2;
3 
4 //SPDX-License-Identifier: MIT
5 
6 interface IERC20 {
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 }
11   
12 contract Ownable {
13   address public owner;
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() {
22     owner = msg.sender;
23   }
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner, "Only for owner");
29     _;
30   }
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 
43 contract TransferExclusive is Ownable {
44     IERC20 public _tokenContract;
45     address public _tokenAddress;
46     address public _ownerAddress;
47     
48     mapping (address => uint256) claims;
49     
50     bytes32 _merkleRoot;
51     
52     struct inputModel {
53         address addr;
54         uint64 val;
55     }
56 
57     constructor (address contractAddress, address ownerAddress) {
58         _tokenContract = IERC20(contractAddress);
59         _ownerAddress = ownerAddress;
60         _tokenAddress = contractAddress;
61     }
62     
63     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
64         if (_i == 0) {
65             return "0";
66         }
67         uint j = _i;
68         uint len;
69         while (j != 0) {
70             len++;
71             j /= 10;
72         }
73         bytes memory bstr = new bytes(len);
74         uint k = len;
75         while (_i != 0) {
76             k = k-1;
77             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
78             bytes1 b1 = bytes1(temp);
79             bstr[k] = b1;
80             _i /= 10;
81         }
82         return string(bstr);
83     }
84     
85     function toAsciiString(address x) internal pure returns (string memory) {
86         bytes memory s = new bytes(40);
87         for (uint i = 0; i < 20; i++) {
88             bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
89             bytes1 hi = bytes1(uint8(b) / 16);
90             bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
91             s[2*i] = char(hi);
92             s[2*i+1] = char(lo);            
93         }
94         return string(s);
95     }
96 
97     function char(bytes1 b) internal pure returns (bytes1 c) {
98         if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
99         else return bytes1(uint8(b) + 0x57);
100     }
101     
102     function verify(bytes32 root, bytes32 leaf, bytes32[] memory proof) private pure returns (bool)
103     {
104         bytes32 computedHash = leaf;
105     
106         for (uint256 i = 0; i < proof.length; i++) {
107           bytes32 proofElement = proof[i];
108     
109           if (computedHash < proofElement) {
110             computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
111           } else {
112             computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
113           }
114         }
115     
116         return computedHash == root;
117     }
118  
119     function setMerkleRoot(bytes32 merkleRoot) public onlyOwner  {
120         _merkleRoot = merkleRoot;
121     }
122 
123     function setPrimaryContract(address contractAddress, address ownerAddress) public onlyOwner returns (uint256){
124         _tokenContract = IERC20(contractAddress);
125         _ownerAddress = ownerAddress;
126         _tokenAddress = contractAddress;
127         
128         return 1;
129     }
130     
131     function getPrimaryAllowance() public onlyOwner view returns (uint256){
132         return _tokenContract.allowance(_ownerAddress, address(this));
133     }
134     
135     function getClaimedValue(address _address) public view returns (uint256){
136         return claims[_address];
137     }
138         
139     function transferExclusive(uint256 amount, uint256 max, bytes32[] memory proof) public returns (uint256){
140         require(_tokenContract.allowance(_ownerAddress, address(this)) >= amount, "Allowance too low");
141         
142         bytes32 leaf=keccak256(abi.encode(abi.encodePacked("0x",toAsciiString(msg.sender), uint2str(max))));
143         
144         require(verify(_merkleRoot, leaf, proof), "Verify failed");
145         
146         require(claims[msg.sender]+amount <= max, "Amount not allowed");
147         
148        _internalTransferFrom(_tokenContract, _ownerAddress, msg.sender, amount);
149        
150        return 1;
151     }
152     
153     function _internalTransferFrom(IERC20 token, address sender, address recipient, uint256 amount) private {
154         bool sent = token.transferFrom(sender, recipient, amount*100000000000000);
155         
156         require(sent, "Token transfer failed");
157         
158         claims[recipient]+=amount;
159     }
160 }