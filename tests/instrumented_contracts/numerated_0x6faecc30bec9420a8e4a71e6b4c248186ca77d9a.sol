1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4     function totalSupply() external returns (uint);
5     
6     function balanceOf(address who) external view returns (uint256);
7     function transfer(address to, uint256 value) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 interface IDeadTokens {
16     function bury(IERC20 token) external;
17     function buried(IERC20 token) external view returns (bool);
18     function callback(IERC20 token, bool valid) external;
19 }
20 interface IOracle {
21     function test(address token) external;
22 }
23 
24 
25 contract Cleanedapp {
26     IDeadTokens dt;
27     uint public slotsCleared;
28     
29     constructor(IDeadTokens _dt) public {
30         dt = _dt;
31     }
32     
33     modifier onlyBuried(IERC20 token) {
34         require(dt.buried(token), "bury token first!");
35         _;        
36     }
37 
38     
39     event Burned(address indexed token, address indexed user, uint amount, string message);
40     
41     function burn(IERC20 token, string calldata message) external onlyBuried(token) {
42         _burn(token, msg.sender, message);
43     }
44     function burn(IERC20 token, address user, string calldata message) external onlyBuried(token) {
45         _burn(token, user, message);
46     }
47 
48     
49     function _burn(IERC20 token, address user, string memory message) internal {
50         uint approved = token.allowance(user, address(this));
51         uint balance = token.balanceOf(user);
52         uint amount = approved < balance ? approved : balance;
53         
54         if (amount > 0) {
55             token.transferFrom(user, address(this), amount);
56             if (amount == approved) {
57                 // this guy just sent all his tokens
58                 slotsCleared += 1;
59             }
60             emit Burned(address(token), user, amount, message);
61         }
62     }
63 }