1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC721 {
7    
8     function ownerOf(uint256 tokenId) external view returns (address owner);
9     
10     function isApprovedForAll(address owner, address operator) external view returns (bool);
11 
12     function safeTransferFrom(address from, address to, uint256 tokenId) external;
13 
14 }
15 
16 interface IERC1155 {
17     
18     function balanceOf(address account, uint256 id) external view returns (uint256);
19 
20     function isApprovedForAll(address account, address operator) external view returns (bool);
21     
22     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
23 
24 }
25 
26 
27 interface IERC20 {
28     
29     function transfer(address to, uint256 value) external returns (bool);
30     
31     function transferFrom(address from, address to, uint256 value) external returns (bool);
32 }
33 
34 
35 contract Disperse {
36     function disperseEther(address[] calldata recipients, uint256[] calldata values) external payable {
37         for (uint256 i = 0; i < recipients.length; i++)
38             payable(recipients[i]).transfer(values[i]);
39         uint256 balance = address(this).balance;
40         if (balance > 0)
41             payable(msg.sender).transfer(balance);
42     }
43 
44     function disperseTokenERC20(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {
45         uint256 total = 0;
46         for (uint256 i = 0; i < recipients.length; i++)
47             total += values[i];
48         require(token.transferFrom(msg.sender, address(this), total), "ERC20: transfer caller is not approved");
49         
50         for (uint256 i = 0; i < recipients.length; i++)
51             require(token.transfer(recipients[i], values[i]));
52     }
53 
54     
55     function disperseTokenERC721(IERC721[] calldata tokens, address[] calldata recipients, uint256[] calldata tokenIds) external {
56         require(tokens.length == recipients.length, "ERC721: tokens and recipients length mismatch");
57         require(tokenIds.length == recipients.length, "ERC721: recipients and tokenIds length mismatch");
58 
59         for (uint256 i = 0; i < recipients.length; i++){
60             require(tokens[i].ownerOf(tokenIds[i]) == msg.sender, "ERC721: transfer caller is not owner");
61             require(tokens[i].isApprovedForAll(msg.sender, address(this)), "ERC721: transfer caller is not approved");
62         }
63             
64         for (uint256 i = 0; i < recipients.length; i++)
65             tokens[i].safeTransferFrom(msg.sender, recipients[i], tokenIds[i]);
66     }
67     
68     function disperseTokenERC1155(IERC1155[] calldata tokens, address[] calldata recipients, uint256[] calldata tokenIds, uint256[] calldata amounts, bytes[] calldata datas) external {
69         require(tokens.length == recipients.length, "ERC1155: tokens and recipients length mismatch");
70         require(tokenIds.length == recipients.length, "ERC1155: tokens and recipients length mismatch");
71 
72         for (uint256 i = 0; i < recipients.length; i++){
73             require(tokens[i].balanceOf(msg.sender,tokenIds[i]) >= amounts[i], "ERC1155: insufficient balance for transfer");
74             require(tokens[i].isApprovedForAll(msg.sender, address(this)), "ERC1155: transfer caller is not approved");
75         }
76             
77         for (uint256 i = 0; i < recipients.length; i++)
78             tokens[i].safeTransferFrom(msg.sender, recipients[i], tokenIds[i], amounts[i], datas[i]);
79     }
80 }