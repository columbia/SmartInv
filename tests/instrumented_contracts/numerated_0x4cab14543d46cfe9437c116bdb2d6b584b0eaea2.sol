1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 
5 interface IZ3 {
6     function setFeeExempt(address _addr, bool _value) external;
7 
8     function setFeeReceivers(address _marketingReceiver, address _treasuryReceiver) external;
9 
10     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _treasuryFee) external;
11 
12     function rescueToken(address tokenAddress, uint256 tokens, address destination) external returns (bool success);
13 
14     function setNextRebase(uint256 _nextRebase) external;
15 
16     function transferOwnership(address newOwner) external;
17 
18     function manualRebase() external;
19 
20     function nextRebase() external view returns (uint256);
21 
22     function shouldRebase() external view returns (bool);
23 
24     function rewardYield() external view returns (uint256);
25 
26     function rewardYieldDenominator() external view returns (uint256);
27 
28     function getSupplyDeltaOnNextRebase() external view returns (uint256);
29 
30     function totalSupply() external view returns (uint256);
31 
32     function decimals() external view returns (uint8);
33 }
34 
35 contract Ownable {
36     address private _owner;
37 
38     event OwnershipRenounced(address indexed previousOwner);
39 
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     constructor() {
46         _owner = msg.sender;
47     }
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(msg.sender == _owner, "Not owner");
55         _;
56     }
57 
58     function renounceOwnership() public onlyOwner {
59         emit OwnershipRenounced(_owner);
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 contract Z3Owner is Ownable {
75     mapping (address => bool) public isAuthorized;
76     IZ3 public immutable z3Token;
77 
78     constructor(address _z3Token){
79         isAuthorized[msg.sender] = true;
80         isAuthorized[0x14d064f5BceA5808660Dd39868172A7031B38442] = true;
81         z3Token = IZ3(_z3Token);
82     }
83 
84     modifier onlyAuthorized() {
85         require(isAuthorized[msg.sender], "Not Authorized");
86         _;
87     }
88 
89     function setAuthorized(address _addr, bool _authorized) external onlyOwner {
90         isAuthorized[_addr] = _authorized;
91     }
92 
93     function setFeeExempt(address _addr, bool _value) external onlyOwner {
94         z3Token.setFeeExempt(_addr,_value);
95     }
96 
97     function setFeeReceivers(address _marketingReceiver, address _treasuryReceiver) external onlyOwner {
98         z3Token.setFeeReceivers(_marketingReceiver, _treasuryReceiver);
99     }
100 
101     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _treasuryFee) external onlyOwner {
102         z3Token.setFees(_liquidityFee, _marketingFee, _treasuryFee);
103     }
104 
105     function rescueToken(address tokenAddress, uint256 tokens, address destination) external onlyOwner returns (bool success) {
106         success = z3Token.rescueToken(tokenAddress, tokens, destination);
107     }
108 
109     function setNextRebase(uint256 _nextRebase) external onlyAuthorized {
110         z3Token.setNextRebase(_nextRebase);
111     }
112 
113     function manualRebase() external {
114         z3Token.manualRebase();
115     }
116 
117     function transferZ3Ownership(address newOwner) external onlyOwner {
118         z3Token.transferOwnership(newOwner);
119     }
120 
121     function nextRebase() external view returns (uint256){
122         return z3Token.nextRebase();
123     }
124 
125     function rewardYieldDenominator() external view returns (uint256){
126         return z3Token.rewardYieldDenominator();
127     }
128 
129     function rewardYield() external view returns (uint256){
130         return z3Token.rewardYield();
131     }
132 
133     function shouldRebase() external view returns (bool){
134         return z3Token.shouldRebase();
135     }
136 
137     function getSupplyDeltaOnNextRebase() external view returns (uint256){
138         return z3Token.getSupplyDeltaOnNextRebase();
139     }
140 
141     function totalSupply() external view returns (uint256) {
142         return z3Token.totalSupply();
143     }
144 
145     function decimals() external view returns (uint8) {
146         return z3Token.decimals();
147     }
148 }