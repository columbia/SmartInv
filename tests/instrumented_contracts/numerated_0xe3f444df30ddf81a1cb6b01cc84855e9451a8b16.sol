1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4 
5     function totalSupply() public view returns (uint);
6     function balanceOf(address tokenOwner) public view returns (uint balance);
7     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
8     function transfer(address to, uint tokens) public returns (bool success);
9     function approve(address spender, uint tokens) public returns (bool success);
10     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11 
12     event Transfer(address indexed from, address indexed to, uint tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 
15 }
16 
17 contract DepositRegistry {
18 
19     function getTokenContract() public view returns(address);
20     function getDepositAdmin() public view returns(address);
21     function getColdWallet() public view returns(address);
22 
23     function changeColdWallet(address _newWallet) public;
24 
25     event ColdWalletChanged(address previousWallet, address newWallet);
26     event TokenChanged(address previousToken, address newToken);
27 
28 }
29 
30 contract DepositWallet {
31 
32     function sweepTokens() public;
33     
34     event DepositProcessed(address indexed coldWallet, uint amount);
35 
36 }
37 
38 contract DepositWalletImpl is DepositWallet {
39 
40     DepositRegistry public depositRegistry;
41 
42     constructor(DepositRegistry _depositRegistry) public {
43         depositRegistry = _depositRegistry;
44     }
45 
46     function sweepTokens() public {
47         address tokenContractAddress = depositRegistry.getTokenContract();
48         ERC20 tokenContract = ERC20(tokenContractAddress);
49 
50         tokenContract.balanceOf(address(this));
51         uint currentBalance = tokenContract.balanceOf(address(this));
52 
53         if (currentBalance > 0) {
54             address coldWallet = depositRegistry.getColdWallet();
55             require(tokenContract.transfer(coldWallet, currentBalance), "Failed to transfer tokens");
56             emit DepositProcessed(coldWallet, currentBalance);
57         }
58     }
59 
60 }