1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.4;
4 pragma experimental ABIEncoderV2;
5 
6 import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
7 import '@openzeppelin/contracts/access/Ownable.sol';
8 import '@openzeppelin/contracts/math/SafeMath.sol';
9 import '../interfaces/IVBabyOwner.sol';
10 import '../interfaces/IMasterChef.sol';
11 import '../interfaces/IBabyToken.sol';
12 
13 contract VBabyFarmer is Ownable {
14     using SafeMath for uint256;
15     using SafeERC20 for IERC20;
16     using SafeERC20 for IBabyToken;
17 
18     uint constant public PERCENT_BASE = 1e6;
19 
20     IMasterChef immutable public masterChef;
21     IBabyToken immutable public babyToken;
22     IVBabyOwner immutable public vBabyOwner;
23     mapping(address => bool) public operators;
24 
25     modifier onlyOperator() {
26         require(operators[msg.sender], "only operator can do this");
27         _;
28     }
29 
30     constructor(IMasterChef _masterChef, IVBabyOwner _vBabyOwner) {
31         masterChef = _masterChef;
32         vBabyOwner = _vBabyOwner;
33         babyToken = _vBabyOwner.babyToken();
34     }
35 
36     function addOperator(address _operator) external onlyOwner {
37         operators[_operator] = true;
38     }
39 
40     function delOperator(address _operator) external onlyOwner {
41         operators[_operator] = false;
42     }
43 
44     function _repay() internal {
45         (uint amount, ) = masterChef.userInfo(0, address(this));
46         if (amount > 0) {
47             masterChef.leaveStaking(amount);
48         }
49         uint balance = babyToken.balanceOf(address(this));
50         if (balance > 0) {
51             babyToken.approve(address(vBabyOwner), balance);
52             vBabyOwner.repay(balance);
53         }
54     }
55 
56     function repay() public onlyOwner {
57         _repay();
58     }
59 
60     function _borrow() internal {
61         vBabyOwner.borrow();
62         uint balance = babyToken.balanceOf(address(this));
63         uint pending = masterChef.pendingCake(0, address(this));
64         uint amount = balance.add(pending);
65         if (amount > 0) {
66             babyToken.approve(address(masterChef), amount);
67             masterChef.enterStaking(amount);
68         }
69     }
70 
71     function borrow() public onlyOwner {
72         _borrow();
73     }
74 
75     function doHardWork() external onlyOperator {
76         _repay();
77         _borrow();
78     }
79 
80     function contractCall(address _contract, bytes memory _data) public onlyOwner {
81         (bool success, ) = _contract.call(_data);
82         require(success, "response error");
83         assembly {
84             let free_mem_ptr := mload(0x40)
85             returndatacopy(free_mem_ptr, 0, returndatasize())
86 
87             switch success
88             case 0 { revert(free_mem_ptr, returndatasize()) }
89             default { return(free_mem_ptr, returndatasize()) }
90         }
91     }
92 
93     function masterChefCall(bytes memory _data) external onlyOwner {
94         contractCall(address(masterChef), _data);
95     }
96 
97     function babyTokenCall(bytes memory _data) external onlyOwner {
98         contractCall(address(babyToken), _data);
99     }
100 
101     function vBabyOwnerCall(bytes memory _data) external onlyOwner {
102         contractCall(address(vBabyOwner), _data);
103     }
104 
105 }
