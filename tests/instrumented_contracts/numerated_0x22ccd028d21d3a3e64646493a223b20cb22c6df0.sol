1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 
11     function mint(address to, uint256 amount) external returns (bool);
12     function burn(uint256 amount) external returns (bool);
13     function burnFrom(address from, uint256 amount) external returns (bool);
14 }
15 contract BridgeAssist {
16     address public owner;
17     IERC20 public TKN;
18 
19     modifier restricted {
20         require(msg.sender == owner, "This function is restricted to owner");
21         _;
22     }
23     
24     event Collect(address indexed sender, uint256 amount);
25     event Dispense(address indexed sender, uint256 amount);
26     event TransferOwnership(address indexed previousOwner, address indexed newOwner);
27 
28     function collect(address _sender) public restricted returns (uint256 amount) {
29         amount = TKN.allowance(_sender, address(this));
30         require(amount > 0, "No amount approved");
31         require(
32             TKN.burnFrom(_sender, amount),
33             "Transfer failure. Make sure that your balance is not lower than the allowance you set"
34         );
35         emit Collect(_sender, amount);
36     }
37 
38     function dispense(address _sender, uint256 _amount) public restricted returns (bool success) {
39         require(TKN.mint(_sender, _amount), "Dispense failure. Contact contract owner");
40         emit Dispense(_sender, _amount);
41         return true;
42     }
43 
44     function transferOwnership(address _newOwner) public restricted {
45         require(_newOwner != address(0), "Invalid address: should not be 0x0");
46         emit TransferOwnership(owner, _newOwner);
47         owner = _newOwner;
48     }
49 
50     constructor(IERC20 _TKN) {
51         TKN = _TKN;
52         owner = msg.sender;
53     }
54 }