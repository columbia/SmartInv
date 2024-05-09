1 /**
2  *SPDX-License-Identifier: UNLICENSED
3 */
4 pragma solidity >=0.6.8 <0.8.0;
5 
6 /**
7  * @dev Contract module which provides a basic access control mechanism, where
8  * there is an account (an owner) that can be granted exclusive access to
9  * specific functions.
10  *
11  * By default, the owner account will be the one that deploys the contract. This
12  * can later be changed with {transferOwnership}.
13  *
14  * This module is used through inheritance. It will make available the modifier
15  * `onlyOwner`, which can be applied to your functions to restrict their use to
16  * the owner.
17  */
18 contract Ownable {
19     address private _owner;
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() internal {
25         _owner = msg.sender;
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(_owner == msg.sender, "Ownable: caller is not the owner");
40         _;
41     }
42 
43     /**
44      * @dev Transfers ownership of the contract to a new account (`newOwner`).
45      * Can only be called by the current owner.
46      */
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(
49             newOwner != address(0),
50             "Ownable: new owner is the zero address"
51         );
52         _owner = newOwner;
53     }
54 }
55 
56 // File: contracts/TellorProxy.sol
57 
58 interface ITellor {
59     function addTip(uint256 _requestId, uint256 _tip) external;
60 
61     function submitMiningSolution(
62         string calldata _nonce,
63         uint256[5] calldata _requestId,
64         uint256[5] calldata _value
65     ) external;
66 
67     function depositStake() external;
68 
69     function requestStakingWithdraw() external;
70 
71     function withdrawStake() external;
72 
73     function getUintVar(bytes32 _data) external view returns (uint256);
74 
75     function vote(uint256 _disputeId, bool _supportsDispute) external;
76 
77     function transfer(address _to, uint256 _amount) external returns (bool);
78 }
79 
80 contract TellorProxy is Ownable {
81     address tellorAddress; // Address of Tellor Oracle
82 
83     constructor(address _tellorAddress) public
84     {
85         tellorAddress = _tellorAddress;
86     }
87 
88     function addTip(uint256 _requestId, uint256 _tip) external onlyOwner {
89         ITellor(tellorAddress).addTip(_requestId, _tip);
90     }
91 
92     function changeTRB(address _tellorAddress) external onlyOwner {
93         tellorAddress = _tellorAddress;
94     }
95 
96     function submitMiningSolution(
97         string calldata _nonce,
98         uint256[5] calldata _requestId,
99         uint256[5] calldata _value,
100         uint256 _pass
101     ) external onlyOwner {
102         if (_pass == 0) {
103             bytes32 slotProgress =
104                 0xdfbec46864bc123768f0d134913175d9577a55bb71b9b2595fda21e21f36b082;
105             uint256 _soltNum = ITellor(tellorAddress).getUintVar(slotProgress);
106             require(_soltNum != 4, "out-ooff-gas");
107         }
108         ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
109     }
110 
111     function depositStake() external onlyOwner {
112         ITellor(tellorAddress).depositStake();
113     }
114 
115     function requestStakingWithdraw() external onlyOwner {
116         ITellor(tellorAddress).requestStakingWithdraw();
117     }
118 
119     function payment(address _to, uint256 _amount) external onlyOwner {
120         ITellor(tellorAddress).transfer(_to, _amount);
121     }
122 
123     function getSlotProgress() external view returns (uint256) {
124         bytes32 slotProgress =
125             0xdfbec46864bc123768f0d134913175d9577a55bb71b9b2595fda21e21f36b082;
126         return ITellor(tellorAddress).getUintVar(slotProgress);
127     }
128 
129     function withdrawStake() external onlyOwner {
130         ITellor(tellorAddress).withdrawStake();
131     }
132 
133     function vote(uint256 _disputeId, bool _supportsDispute) external onlyOwner
134     {
135         ITellor(tellorAddress).vote(_disputeId, _supportsDispute);
136     }
137 }