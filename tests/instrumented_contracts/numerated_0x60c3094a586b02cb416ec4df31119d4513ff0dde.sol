1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 // ----------------------------------------------------------------------------
5 // ERC Token Standard #20 Interface
6 // ----------------------------------------------------------------------------
7 abstract contract IERC20 {
8     function totalSupply() external virtual view returns (uint256);
9     function balanceOf(address tokenOwner) external virtual view returns (uint256 balance);
10     function allowance(address tokenOwner, address spender) external virtual view returns (uint256 remaining);
11     function transfer(address to, uint256 tokens) external virtual returns (bool success);
12     function approve(address spender, uint256 tokens) external virtual returns (bool success);
13     function transferFrom(address from, address to, uint256 tokens) external virtual returns (bool success);
14     function burnFrom(address account, uint256 amount) public virtual;
15     
16     event Transfer(address indexed from, address indexed to, uint256 tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
18 }
19 
20 contract BreePurchase{
21 
22     address constant private SBREE_TOKEN_ADDRESS = 0x25377ddb16c79C93B0CBf46809C8dE8765f03FCd;
23     address constant private BREE_TOKEN_ADDRESS = 0x4639cd8cd52EC1CF2E496a606ce28D8AfB1C792F;
24     
25     event TOKENSPURCHASED(address indexed _purchaser, uint256 indexed _tokens);
26     
27     function purchase(address assetAddress, uint256 amountAsset) public{
28         require(assetAddress == SBREE_TOKEN_ADDRESS, "NOT ACCEPTED: Unaccepted payment asset provided");
29         require(IERC20(BREE_TOKEN_ADDRESS).balanceOf(address(this)) >= amountAsset, "Balance: Insufficient liquidity");
30         _purchase(assetAddress, amountAsset);
31     }
32     
33     function _purchase(address assetAddress, uint256 assetAmount) internal{
34         // burn the received tokens
35         IERC20(assetAddress).burnFrom(msg.sender, assetAmount);
36         
37         // send tokens to the purchaser
38         IERC20(BREE_TOKEN_ADDRESS).transfer(msg.sender, assetAmount);
39         
40         emit TOKENSPURCHASED(msg.sender, assetAmount);
41     }
42 }