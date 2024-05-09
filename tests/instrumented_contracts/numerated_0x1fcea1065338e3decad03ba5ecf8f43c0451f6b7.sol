1 // SPDX-License-Identifier: none
2 pragma solidity ^0.8.12;
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint theTotalSupply);
6     function balanceOf(address _owner) external view returns (uint balance);
7     function transfer(address _to, uint _value) external returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
9     function approve(address _spender, uint _value) external returns (bool success);
10     function allowance(address _owner, address _spender) external view returns (uint remaining);
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 contract CTCFee{
16   
17   
18     
19     event OwnershipTransferred(address);
20     address public owner = msg.sender;
21     
22     address public contractAddr = address(this);
23     
24     event DepositAt(address user, uint tariff, uint amount);
25     event Withdraw(address user, uint amount);
26     
27     constructor() {
28         
29     }
30 
31 
32 
33     function transferToken(uint _amount, address tokenAddr,address _toAddress) external payable  {
34             require( _amount >= 0);
35             ERC20 tokenObj    = ERC20(tokenAddr);
36             require(tokenObj.balanceOf(msg.sender) >= _amount, "Insufficient User Token balance");
37             require(tokenObj.allowance(msg.sender,contractAddr)>=_amount,"Insufficient allowance");
38             tokenObj.transferFrom(msg.sender, _toAddress, _amount);
39              emit DepositAt(msg.sender, 0, _amount);
40     } 
41 
42 
43    
44     // Owner Token Withdraw    
45     // Only owner can withdraw token 
46     function withdrawToken(address tokenAddress, address to, uint amount) public returns(bool) {
47         require(msg.sender == owner, "Only owner");
48         require(to != address(0), "Cannot send to zero address");
49         ERC20 _token = ERC20(tokenAddress);
50         _token.transfer(to, amount);
51         return true;
52     }
53     
54     // Owner BNB Withdraw
55     // Only owner can withdraw BNB from contract
56     function withdrawBNB(address payable to, uint amount) public returns(bool) {
57         require(msg.sender == owner, "Only owner");
58         require(to != address(0), "Cannot send to zero address");
59         to.transfer(amount);
60         return true;
61     }
62      
63 
64     // Ownership Transfer
65     // Only owner can call this function
66     function transferOwnership(address to) public returns(bool) {
67         require(msg.sender == owner, "Only owner");
68         require(to != address(0), "Cannot transfer ownership to zero address");
69         owner = to;
70         emit OwnershipTransferred(to);
71         return true;
72     }
73 
74 }