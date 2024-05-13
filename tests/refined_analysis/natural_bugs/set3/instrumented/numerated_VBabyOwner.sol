1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.4;
4 pragma experimental ABIEncoderV2;
5 
6 import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
7 import '@openzeppelin/contracts/access/Ownable.sol';
8 import '@openzeppelin/contracts/math/SafeMath.sol';
9 import '../interfaces/IVBabyToken.sol';
10 import '../interfaces/IBabyToken.sol';
11 import 'hardhat/console.sol';
12 
13 contract VBabyOwner is Ownable {
14     using SafeMath for uint256;
15     using SafeERC20 for IERC20;
16     using SafeERC20 for IBabyToken;
17 
18     event Borrow(address user, uint amount, uint userBorrowed, uint totalBorrowed, uint currentBalance);
19     event Repay(address user, uint repayAmount, uint donateAmount, uint userBorrowed, uint totalBorrowed, uint currentBalance);
20 
21     uint constant public PERCENT_BASE = 1e6;
22     uint constant public MAX_BORROW_PERCENT = 8e5;
23 
24     IBabyToken immutable public babyToken;
25     IVBabyToken immutable public vBabyToken;
26     mapping(address => uint) public farmers;
27     mapping(address => bool) public isFarmer;
28     uint public totalPercent;
29     mapping(address => uint) public farmerBorrow;
30     uint public totalBorrow;
31     uint public totalDonate;
32 
33     constructor(IVBabyToken _vBabyToken) {
34         vBabyToken = _vBabyToken;
35         babyToken = IBabyToken(_vBabyToken._babyToken());
36     }
37 
38     modifier onlyFarmer() {
39         require(isFarmer[msg.sender], "only farmer can do this");
40         _;
41     }
42 
43     function vBabySetCanTransfer(bool allowed) external onlyOwner {
44         vBabyToken.setCanTransfer(allowed);
45     }
46 
47     function vBabyChangePerReward(uint256 babyPerBlock) external onlyOwner {
48         vBabyToken.changePerReward(babyPerBlock);
49     }
50 
51     function vBabyUpdateBABYFeeBurnRatio(uint256 babyFeeBurnRatio) external onlyOwner {
52         vBabyToken.updateBABYFeeBurnRatio(babyFeeBurnRatio);
53     }
54 
55     function vBabyUpdateBABYFeeReserveRatio(uint256 babyFeeReserve) external onlyOwner {
56         vBabyToken.updateBABYFeeReserveRatio(babyFeeReserve);
57     }
58 
59     function vBabyUpdateTeamAddress(address team) external onlyOwner {
60         vBabyToken.updateTeamAddress(team);
61     }
62 
63     function vBabyUpdateTreasuryAddress(address treasury) external onlyOwner {
64         vBabyToken.updateTreasuryAddress(treasury);
65     }
66 
67     function vBabyUpdateReserveAddress(address newAddress) external onlyOwner {
68         vBabyToken.updateReserveAddress(newAddress);
69     }
70 
71     function vBabySetSuperiorMinBABY(uint256 val) external onlyOwner {
72         vBabyToken.setSuperiorMinBABY(val);
73     }
74 
75     function vBabySetRatioValue(uint256 ratioFee) external onlyOwner {
76         vBabyToken.setRatioValue(ratioFee);
77     }
78 
79     function vBabyEmergencyWithdraw() external onlyOwner {
80         vBabyToken.emergencyWithdraw();
81         uint currentBalance = babyToken.balanceOf(address(this));
82         if (currentBalance > 0) {
83             babyToken.safeTransfer(owner(), currentBalance);
84         }
85     }
86 
87     function vBabyTransferOwnership(address _newOwner) external onlyOwner {
88         require(_newOwner != address(0), "illegal newOwner");
89         vBabyToken.transferOwnership(_newOwner);
90     }
91 
92     function contractCall(address _contract, bytes memory _data) public onlyOwner {
93         (bool success, ) = _contract.call(_data);
94         require(success, "response error");
95         assembly {
96             let free_mem_ptr := mload(0x40)
97             returndatacopy(free_mem_ptr, 0, returndatasize())
98 
99             switch success
100             case 0 { revert(free_mem_ptr, returndatasize()) }
101             default { return(free_mem_ptr, returndatasize()) }
102         }
103     }
104 
105     function babyTokenCall(bytes memory _data) external onlyOwner {
106         contractCall(address(babyToken), _data);
107     }
108 
109     function vBabyTokenCall(bytes memory _data) external onlyOwner {
110         contractCall(address(vBabyToken), _data);
111     }
112 
113     function setFarmer(address _farmer, uint _percent) external onlyOwner {
114         require(_farmer != address(0), "illegal farmer");
115         require(_percent <= PERCENT_BASE, "illegal percent");
116         totalPercent = totalPercent.sub(farmers[_farmer]).add(_percent);
117         farmers[_farmer] = _percent;
118         require(totalPercent <= MAX_BORROW_PERCENT, "illegal percent");
119     }
120 
121     function addFarmer(address _farmer) external onlyOwner {
122         isFarmer[_farmer] = true;
123     }
124 
125     function delFarmer(address _farmer) external onlyOwner {
126         isFarmer[_farmer] = false;
127     }
128 
129     function borrow() external onlyFarmer returns (uint) {
130         uint totalBaby = babyToken.balanceOf(address(vBabyToken)).add(totalBorrow);
131         uint maxBorrow = totalBaby.mul(farmers[msg.sender]).div(PERCENT_BASE);
132         if (maxBorrow > farmerBorrow[msg.sender]) {
133             maxBorrow = maxBorrow.sub(farmerBorrow[msg.sender]);
134         } else {
135             maxBorrow = 0;
136         }
137         if (maxBorrow > 0) {
138             farmerBorrow[msg.sender] = farmerBorrow[msg.sender].add(maxBorrow);
139             vBabyToken.emergencyWithdraw();
140             uint currentBalance = babyToken.balanceOf(address(this));
141             require(currentBalance >= maxBorrow, "illegal baby balance");
142             totalBorrow = totalBorrow.add(maxBorrow);
143             babyToken.safeTransfer(msg.sender, maxBorrow);
144             babyToken.safeTransfer(address(vBabyToken), currentBalance.sub(maxBorrow));
145         }
146         emit Borrow(msg.sender, maxBorrow, farmerBorrow[msg.sender], totalBorrow, babyToken.balanceOf(address(vBabyToken)));
147         return maxBorrow;
148     }
149 
150     function repay(uint _amount) external onlyFarmer returns (uint, uint) {
151         babyToken.safeTransferFrom(msg.sender, address(this), _amount);
152         uint repayAmount; 
153         uint donateAmount;
154         if (_amount > farmerBorrow[msg.sender]) {
155             repayAmount = farmerBorrow[msg.sender];
156             donateAmount = _amount.sub(repayAmount);
157         } else {
158             repayAmount = _amount;
159         }
160         require(_amount == repayAmount.add(donateAmount), "repay error");
161         if (repayAmount > 0) {
162             totalBorrow = totalBorrow.sub(repayAmount);
163             farmerBorrow[msg.sender] = farmerBorrow[msg.sender].sub(repayAmount);
164             babyToken.safeTransfer(address(vBabyToken), repayAmount);
165         }
166         if (donateAmount > 0) {
167             babyToken.approve(address(vBabyToken), donateAmount);            
168             totalDonate = totalDonate.add(donateAmount);
169             vBabyToken.donate(donateAmount);
170         }
171         console.log(repayAmount, donateAmount);
172         emit Repay(msg.sender, repayAmount, donateAmount, farmerBorrow[msg.sender], totalBorrow, babyToken.balanceOf(address(vBabyToken)));
173         return (repayAmount, donateAmount);
174     }
175 }
