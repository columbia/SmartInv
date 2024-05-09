1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5     if (_a == 0) { return 0; }
6     c = _a * _b;
7     assert(c / _a == _b);
8     return c;
9   }
10 
11   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
12     return _a / _b;
13   }
14 
15   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
16     assert(_b <= _a);
17     return _a - _b;
18   }
19 
20   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
21     c = _a + _b;
22     assert(c >= _a);
23     return c;
24   }
25 }
26 
27 library SafeERC20 {
28   function safeTransfer(ERC20 _token, address _to, uint256 _value) internal {
29     require(_token.transfer(_to, _value));
30   }
31 
32   function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
33     require(_token.transferFrom(_from, _to, _value));
34   }
35 }
36 
37 interface ERC20 {
38   function transferFrom(address from, address to, uint256 value) external returns (bool);
39   function transfer(address _to, uint256 _value) external returns (bool);
40 }
41 
42 contract Ownable {
43   address public owner;
44 
45   event OwnershipRenounced(address indexed previousOwner);
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47   modifier onlyOwner() { require(msg.sender == owner); _; }
48 
49   constructor() public { owner = msg.sender; }
50 
51   function renounceOwnership() public onlyOwner() {
52     emit OwnershipRenounced(owner);
53     owner = address(0);
54   }
55 
56   function transferOwnership(address _newOwner) public onlyOwner() {
57     _transferOwnership(_newOwner);
58   }
59 
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 contract BitSongCrowdsale is Ownable{
68   using SafeMath for uint256;
69   using SafeERC20 for ERC20;
70 
71   ERC20 public token;
72   address public wallet;
73   uint256 public rate;
74   uint256 public weiRaised;
75   address public kycAdmin;
76   uint256 public hardCap;
77   uint256 public tokensAllocated;
78   uint256 public openingTime;
79   uint256 public closingTime;
80   uint256 public duration;
81 
82   mapping(address => bool) public approvals;
83   mapping(address => uint256) public balances;
84 
85   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
86   event KycApproved(address indexed beneficiary, address indexed admin, bool status);
87   event KycRefused(address indexed beneficiary, address indexed admin, bool status);
88 
89   modifier onlyKycAdmin() { require(msg.sender == kycAdmin); _; }
90   modifier onlyWhileOpen { require(block.timestamp >= openingTime && block.timestamp <= closingTime); _; }
91 
92   constructor(uint256 _rate, address _wallet, uint256 _duration, uint256 _hardCap, ERC20 _tokenAddress) public {
93     require(_rate > 0);
94     require(_wallet != address(0));
95     require(_tokenAddress != address(0));
96 
97     rate = _rate;
98     wallet = _wallet;
99     token = _tokenAddress;
100     hardCap = _hardCap * 10**18;
101     duration = _duration * 1 days;
102   }
103 
104   function () external payable {
105     buyTokens();
106   }
107 
108   function buyTokens() public onlyWhileOpen() payable {
109     require(msg.value > 0);
110     require(approvals[msg.sender] == true);
111     uint256 weiAmount = msg.value;
112     uint256 tokenAmount = weiAmount.mul(rate);
113     tokensAllocated = tokensAllocated.add(tokenAmount);
114     assert(tokensAllocated <= hardCap);
115     weiRaised = weiRaised.add(weiAmount);
116     balances[msg.sender] = balances[msg.sender].add(tokenAmount);
117     emit TokenPurchase(msg.sender, weiAmount, tokenAmount);
118     wallet.transfer(msg.value);
119   }
120 
121   function withdrawTokens() external {
122     require(hasClosed());
123     uint256 amount = balances[msg.sender];
124     require(amount > 0);
125     balances[msg.sender] = 0;
126     token.safeTransferFrom(wallet, msg.sender, amount);
127   }
128 
129   function withdrawTokensFor(address _beneficiary) external {
130     require(hasClosed());
131     uint256 amount = balances[_beneficiary];
132     require(amount > 0);
133     balances[_beneficiary] = 0;
134     token.safeTransferFrom(wallet, _beneficiary, amount);
135   }
136 
137   function hasClosed() public view returns (bool) {
138     return block.timestamp > closingTime;
139   }
140 
141   function approveAddress(address _beneficiary) external onlyKycAdmin() {
142     approvals[_beneficiary] = true;
143     emit KycApproved(_beneficiary, kycAdmin, true);
144   }
145 
146   function refuseAddress(address _beneficiary) external onlyKycAdmin() {
147     approvals[_beneficiary] = false;
148     emit KycRefused(_beneficiary, kycAdmin, false);
149   }
150 
151   function rewardManual(address _beneficiary, uint256 _amount) external onlyOwner() {
152     require(_amount > 0);
153     require(_beneficiary != address(0));
154     tokensAllocated = tokensAllocated.add(_amount);
155     assert(tokensAllocated <= hardCap);
156     balances[_beneficiary] = balances[_beneficiary].add(_amount);
157   }
158 
159   function transfer(address _beneficiary, uint256 _amount) external onlyOwner() {
160     require(_amount > 0);
161     require(_beneficiary != address(0));
162     token.safeTransfer(_beneficiary, _amount);
163   }
164 
165   function setKycAdmin(address _newAdmin) external onlyOwner() {
166     kycAdmin = _newAdmin;
167   }
168 
169   function startDistribution() external onlyOwner() {
170     require(openingTime == 0);
171     openingTime = block.timestamp;
172     closingTime = openingTime.add(duration);
173   }
174 
175   function setRate(uint256 _newRate) external onlyOwner() {
176     rate = _newRate;
177   }
178 
179   function setClosingTime(uint256 _newTime) external onlyOwner() {
180     closingTime = _newTime;
181   }
182 }