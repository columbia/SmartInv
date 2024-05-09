1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {                                                
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0));                                    // to ensure the owner's address isn't an uninitialised address, "0x0"
18         owner = newOwner;
19     }
20 }
21 
22 contract WarmWallet is Ownable {
23     
24     address defaultSweeper;
25 
26     mapping (address => address) sweepers;
27     mapping (address => bool) financeFolks;
28     mapping (address => bool) destinations;
29     mapping (address => bytes32) dstLabels;
30     mapping (address => uint256) dstIndex;
31     address[] public destKeys;
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     function sweeperOf(address asset) public view returns (address) {
38     	if (sweepers[asset] == 0x0) {
39     		return defaultSweeper;
40     	}
41     	return sweepers[asset];
42     }
43 
44     function setDefaultSweeper(address sweeper) public onlyOwner {
45     	defaultSweeper = sweeper;
46     }
47 
48     function setSweeper(address asset, address sweeper) public onlyOwner {
49     	sweepers[asset] = sweeper;
50     }
51 
52     function authorizeAddress(address actor) public onlyOwner {
53     	financeFolks[actor] = true;
54     }
55 
56     function revokeAuthorization(address actor) public onlyOwner {
57     	financeFolks[actor] = false;
58     }
59 
60     function isAuthorized(address actor) public view returns (bool) {
61     	return financeFolks[actor];
62     }
63 
64     function addDestination(address dest, bytes32 label) public onlyOwner {
65     	require(destinations[dest] == false);
66     	destinations[dest] = true;
67     	dstIndex[dest] = destKeys.length;
68     	destKeys.push(dest);
69     	dstLabels[dest] = label;
70     }
71 
72     function removeDestination(address dest) public onlyOwner {
73     	require(destinations[dest] == true);
74     	destinations[dest] = false;
75     	delete dstLabels[dest];
76     	uint256 keyindex = dstIndex[dest];
77     	delete destKeys[keyindex];
78     	delete dstIndex[dest];
79     }
80 
81     function isDestination(address dest) public view returns (bool) {
82     	return destinations[dest];
83     }
84 
85     function destinationLabel(address dest) public view returns (string) {
86     	bytes memory bytesArray = new bytes(32);
87     	for (uint256 i; i < 32; i++) {
88         	bytesArray[i] = dstLabels[dest][i];
89         }
90     	return string(bytesArray);
91     }
92 
93     function () public payable { 
94         if (msg.value == 0 && financeFolks[msg.sender] == true) {
95             address destination = addressAtIndex(msg.data, 2);
96             require(destinations[destination] == true);
97 
98             address asset = addressAtIndex(msg.data, 1);
99             address _impl = sweeperOf(asset);
100             require(_impl != 0x0);
101             bytes memory data = msg.data;
102 
103     		assembly {
104     			let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
105     			let size := returndatasize
106     			let ptr := mload(0x40)
107     			returndatacopy(ptr, 0, size)
108     			switch result
109     			case 0 { revert(ptr, size) }
110     			default { return(ptr, size) }
111     		}
112         }
113     }
114 
115     function addressAtIndex(bytes _bytes, uint256 index) internal pure returns (address asset) {
116         assembly {
117             // mul(32, index) - Each param is 32 bytes, so we use n*32
118             // add(4, ^) - 4 function sig bytes
119             // add(_bytes, ^) - set the pointer to that position in memory
120             // mload(^) - load an addresses worth of value (20 bytes) from memory into asset
121             asset := mload(add(_bytes, add(4, mul(32, index))))
122         }
123     }
124 
125 }