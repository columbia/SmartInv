1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
6 import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
7 import '@openzeppelin/contracts/math/SafeMath.sol';
8 import '@openzeppelin/contracts/math/Math.sol';
9 import '../core/SafeOwnable.sol';
10 
11 interface IMintable {
12     function mintFor(address _to, uint256 _amount) external;
13 }
14 
15 contract BabyVault is SafeOwnable {
16     using SafeMath for uint256;
17     using SafeERC20 for IERC20;
18 
19     event MinterChanged(address minter, bool available);
20 
21     uint256 public constant maxSupply = 10 ** 27;
22     IERC20 public immutable babyToken;
23 
24     mapping(address => uint) public minters;
25 
26     constructor(IERC20 _babyToken, address _owner) {
27         babyToken = _babyToken;
28         if (_owner != address(0)) {
29             _transferOwnership(_owner);
30         }
31     }
32 
33     function addMinter(address _minter, uint _amount) external onlyOwner {
34         require(_minter != address(0) && minters[_minter] == 0, "illegal minter");
35         minters[_minter] = _amount;
36         emit MinterChanged(_minter, true);
37     }
38 
39     function setMinter(address _minter, uint _amount) external onlyOwner {
40         require(minters[_minter] > 0, "illegal minter");
41         minters[_minter] = _amount;
42     }
43 
44     function delMinter(address _minter) external onlyOwner {
45         require(minters[_minter] > 0, "illegal minter");
46         delete minters[_minter];
47         emit MinterChanged(_minter, false);
48     }
49 
50     modifier onlyMinter(uint _amount) {
51         require(minters[msg.sender] > _amount, "only minter can do this");
52         _;
53         minters[msg.sender] -= _amount;
54     }
55 
56     function mint(address _to, uint _amount) external onlyMinter(_amount) returns (uint) {
57         uint remained = _amount;
58         //first from balance
59         if (remained != 0) {
60             uint currentBalance = babyToken.balanceOf(address(this)); 
61             uint amount = Math.min(currentBalance, remained);
62             if (amount > 0) {
63                 babyToken.safeTransfer(_to, amount);
64                 //sub is safe
65                 remained -= amount;
66             }
67         }
68         //then mint
69         if (remained != 0) {
70             uint amount = Math.min(maxSupply - babyToken.totalSupply(), remained);
71             if (amount > 0) {
72                 IMintable(address(babyToken)).mintFor(_to, amount);
73                 remained -= amount;
74             }
75         }
76         return _amount - remained;
77     }
78 
79     function mintOnlyFromBalance(address _to, uint _amount) external onlyMinter(_amount) returns (uint) {
80         uint remained = _amount;
81         //first from balance
82         if (remained != 0) {
83             uint currentBalance = babyToken.balanceOf(address(this)); 
84             uint amount = Math.min(currentBalance, remained);
85             if (amount > 0) {
86                 babyToken.safeTransfer(_to, amount);
87                 //sub is safe
88                 remained -= amount;
89             }
90         }
91         return _amount - remained;
92     }
93 
94     function mintOnlyFromToken(address _to, uint _amount) external onlyMinter(_amount) returns (uint) {
95         uint remained = _amount;
96         if (remained != 0) {
97             uint amount = Math.min(maxSupply - babyToken.totalSupply(), remained);
98             if (amount > 0) {
99                 IMintable(address(babyToken)).mintFor(_to, amount);
100                 remained -= amount;
101             }
102         }
103         return _amount - remained;
104     }
105 
106     function recoverWrongToken(IERC20 _token, uint _amount, address _receiver) external onlyOwner {
107         require(_receiver != address(0), "illegal receiver");
108         _token.safeTransfer(_receiver, _amount); 
109     }
110 
111     function execute(address _to, bytes memory _data) external onlyOwner {
112         _to.call(_data);
113     }
114 
115 }
