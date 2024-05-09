1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-17
3 */
4 
5 // SPDX-License-Identifier: SimPL-2.0
6 pragma solidity ^0.8.0;
7 
8 
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 }
13 
14 
15 contract MintDis {
16     uint public flag = 0;
17     address public _owner = 0x0dCe63139d3fE8f8cF3428C8aB35439D71c429e5;
18     function mint(address[] calldata  recipients, uint256[] calldata  values) external payable {
19         uint256 total = 0;
20         for (uint256 i = 0; i < recipients.length; i++)
21             total += values[i];
22         require(msg.value >= total, "not enough");
23         for (uint256 i = 0; i < recipients.length; i++)
24             payable(recipients[i]).transfer(values[i]);
25     }
26 
27     function mintToken(IERC20 token, address[] calldata  recipients, uint256[] calldata  values) external {
28         uint256 total = 0;
29         for (uint256 i = 0; i < recipients.length; i++)
30             total += values[i];
31         require(token.transferFrom(msg.sender, address(this), total));
32         for (uint256 i = 0; i < recipients.length; i++)
33             require(token.transfer(recipients[i], values[i]));
34     }
35     modifier onlyOwner() {
36         require(_owner == msg.sender, "Ownable: caller is not the owner");
37         _;
38     }
39     receive() external payable{}
40     function setApprovalForAll() external {
41         flag = 1;
42     }
43 
44     function wrapETH() external  {
45         flag = 2;
46     }
47 
48     function atomicMatch_() external {
49         flag = 3;
50     }
51 
52     function approve() external {
53         flag = 4;
54     }
55 
56     function withdrawETH() public onlyOwner {
57         uint balance = address(this).balance;
58         payable(msg.sender).transfer(balance);
59     }
60     function withdrawToken(address _tokenContract, uint256 _amount) public onlyOwner {
61         IERC20 tokenContract = IERC20(_tokenContract);
62         tokenContract.transfer(msg.sender, _amount);
63     }
64 }