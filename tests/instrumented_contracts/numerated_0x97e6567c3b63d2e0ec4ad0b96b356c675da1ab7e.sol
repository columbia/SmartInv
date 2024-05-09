1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 
5 
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 }
10 
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 }
19 
20 library Address {
21     function sendValue(address payable recipient, uint256 amount) internal {
22         require(address(this).balance >= amount, "Address: insufficient balance");
23 
24         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
25         (bool success, ) = recipient.call{ value: amount }("");
26         require(success, "Address: unable to send value, recipient may have reverted");
27     }
28 }
29 
30 
31 contract PresailDroplet {
32     using SafeMath for uint256;
33     using Address for address payable;
34 
35     function presailDistribute(address payable[] calldata recipients, uint256[] calldata values) external payable {
36         require(recipients.length == values.length, "Recipients and values must have the same length");
37         for (uint256 i = 0; i < recipients.length; i = i.add(1)) {
38             require(recipients[i] != address(0), "Recipient cannot be zero address");
39             recipients[i].sendValue(values[i]);
40         }
41         uint256 balance = address(this).balance;
42         if (balance > 0)
43             msg.sender.sendValue(balance);
44     }
45 
46     function presailDistributeToken(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {
47         require(recipients.length == values.length, "Recipients and values must have the same length");
48         uint256 total = 0;
49         for (uint256 i = 0; i < recipients.length; i = i.add(1))
50             total = total.add(values[i]);
51         require(token.transferFrom(msg.sender, address(this), total), "Token transferFrom failed");
52         for (uint256 i = 0; i < recipients.length; i = i.add(1)) {
53             require(recipients[i] != address(0), "Recipient cannot be zero address");
54             require(token.transfer(recipients[i], values[i]), "Token transfer failed");
55         }
56     }
57 
58     function presailDistributeTokenSimple(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {
59         require(recipients.length == values.length, "Recipients and values must have the same length");
60         for (uint256 i = 0; i < recipients.length; i = i.add(1)) {
61             require(recipients[i] != address(0), "Recipient cannot be zero address");
62             require(token.transferFrom(msg.sender, recipients[i], values[i]), "Token transfer failed");
63         }
64     }
65 }