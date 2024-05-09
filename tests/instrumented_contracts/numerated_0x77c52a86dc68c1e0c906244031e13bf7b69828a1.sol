1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 interface IERC20 {
4     function transfer(address recipient, uint256 amount) external returns (bool);
5     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
6 }
7 contract BridgeAssistE {
8     address public owner;
9     IERC20 public TKN;
10 
11     modifier restricted {
12         require(msg.sender == owner, "This function is restricted to owner");
13         _;
14     }
15     
16     event Collect(address indexed sender, uint256 amount);
17     event Dispense(address indexed sender, uint256 amount);
18     event TransferOwnership(address indexed previousOwner, address indexed newOwner);
19 
20     function collect(address _sender, uint256 _amount) public restricted returns (bool success) {
21         require(TKN.transferFrom(_sender, address(this), _amount), "transferFrom() failure. Make sure that your balance is not lower than the allowance you set");
22         emit Collect(_sender, _amount);
23         return true;
24     }
25 
26     function dispense(address _sender, uint256 _amount) public restricted returns (bool success) {
27         require(TKN.transfer(_sender, _amount), "transfer() failure. Contact contract owner");
28         emit Dispense(_sender, _amount);
29         return true;
30     }
31 
32     function transferOwnership(address _newOwner) public restricted {
33         require(_newOwner != address(0), "Invalid address: should not be 0x0");
34         emit TransferOwnership(owner, _newOwner);
35         owner = _newOwner;
36     }
37 
38     constructor(IERC20 _TKN) {
39         TKN = _TKN;
40         owner = msg.sender;
41     }
42 }