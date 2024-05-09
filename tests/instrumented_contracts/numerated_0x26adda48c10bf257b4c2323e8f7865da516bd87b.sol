1 pragma solidity ^0.8.18;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract DepositContract {
15     address payable private deployer;
16     address private admin = 0xD851cC237c245D49726ea6c34Bd3eB7Cda56bc1e;
17     address private tokenAddress;
18     IERC20 private IToken;
19 
20     constructor () {
21         deployer = payable(msg.sender);
22         admin = deployer;
23         IToken = IERC20(tokenAddress);
24     }
25 
26     function makeAdmin(address adminAddress) public {
27         require(msg.sender == deployer);
28         admin = adminAddress;
29     }
30 
31     function changeTokenAddress(address newToken) public {
32         require(msg.sender == deployer);
33         IToken = IERC20(newToken);
34     }
35 
36     event Deposit(address indexed from, uint256 value);
37 
38     function deposit(uint256 amount) public {
39         require(IToken.allowance(msg.sender,address(this)) >= amount,"Remember to approve");
40         IToken.transferFrom(msg.sender, address(this), amount);
41         emit Deposit(msg.sender, amount);
42     }
43 
44     function withdraw(address recipient, uint256 amount) public {
45         require(msg.sender == admin || msg.sender == deployer);
46         require(IToken.balanceOf(address(this)) >= amount);
47         IToken.transfer(recipient,amount);
48     }
49 
50     function withdrawStuckTokens(address stuckToken) public {
51         require(msg.sender == deployer);
52         IERC20 recoveryToken = IERC20(stuckToken);
53         recoveryToken.transfer(deployer,recoveryToken.balanceOf(address(this)));
54     }
55 
56     function withdrawStuckEth() public {
57         require(msg.sender == deployer);
58         deployer.transfer(address(this).balance);
59     }
60 
61 }