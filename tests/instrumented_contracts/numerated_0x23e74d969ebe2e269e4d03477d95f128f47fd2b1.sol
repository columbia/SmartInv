1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.2;
3 interface IERC20 {
4     function allowance(address owner, address spender) external view returns (uint256);
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7 }
8 contract BridgeAssistE {
9     address public owner;
10     IERC20 public TKN;
11 
12     modifier restricted {
13         require(msg.sender == owner, "This function is restricted to owner");
14         _;
15     }
16     
17     event Collect(address indexed sender, uint256 amount);
18     event Dispense(address indexed sender, uint256 amount);
19     event TransferOwnership(address indexed previousOwner, address indexed newOwner);
20 
21     function collect(address _sender, uint256 _amount) public restricted returns (bool success) {
22         require(TKN.allowance(_sender, address(this)) >= _amount, "Amount check failed");
23         require(TKN.transferFrom(_sender, address(this), _amount), "transferFrom() failure. Make sure that your balance is not lower than the allowance you set");
24         emit Collect(_sender, _amount);
25         return true;
26     }
27 
28     function dispense(address _sender, uint256 _amount) public restricted returns (bool success) {
29         require(TKN.transfer(_sender, _amount), "transfer() failure. Contact contract owner");
30         emit Dispense(_sender, _amount);
31         return true;
32     }
33 
34     function transferOwnership(address _newOwner) public restricted {
35         require(_newOwner != address(0), "Invalid address: should not be 0x0");
36         emit TransferOwnership(owner, _newOwner);
37         owner = _newOwner;
38     }
39 
40     constructor(IERC20 _TKN, address _owner) {
41         TKN = _TKN;
42         owner = _owner;
43     }
44 }