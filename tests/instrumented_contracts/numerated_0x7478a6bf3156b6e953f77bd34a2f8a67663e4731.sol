1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.12;
3 
4 interface IFactory {
5     function withdraw(uint256 salt, address token, address receiver) external returns (address wallet);
6 }
7 
8 interface IERC20 {
9     function transfer(address, uint256) external;
10 }
11 
12 contract MultV5 {
13 
14     address _ADMIN;
15 
16     event IncreaseBalance(address sender, uint256 amount);
17 
18     event DecreaseBalance(address target, uint256 amount);
19 
20     mapping (address => bool) public Owners;
21 
22     function modifyOwner(address _wallet, bool _enabled) external {
23         require(_ADMIN == msg.sender, "Only for admin");
24 
25         Owners[_wallet]=_enabled;
26     }
27 
28     function contains(address _wallet) public view returns (bool) {
29         return Owners[_wallet];
30     }
31 
32     modifier ownerOnly () {
33       require(contains(msg.sender), "Only for owners");
34          _;
35     }
36 
37     constructor () {
38         _ADMIN = msg.sender;
39         Owners[msg.sender]=true;
40     }
41 
42     receive () external payable {
43         emit IncreaseBalance(msg.sender, msg.value);
44     }
45 
46     function dumpFactory(address factory, uint[] memory salt, address[] memory token, address receiver) ownerOnly external {
47         uint arrayLength = salt.length;
48 
49         for (uint i=0; i < arrayLength; i++) {
50             IFactory(factory).withdraw(salt[i], token[i], receiver);
51         }
52     }
53 
54     function transferErc20(address[] memory token, address[] memory reviever, uint256[] memory amount) ownerOnly external {
55         for (uint i=0; i < token.length; i++) {
56             IERC20(token[i]).transfer(reviever[i], amount[i]);
57         }
58     }
59 
60     function withdrawAsset(address[] memory targets, uint256[] memory amounts) ownerOnly external {
61         require(targets.length == amounts.length, "Invalid params length");
62 
63         uint256 amountSum = 0;
64 
65         for (uint i = 0; i < amounts.length; i++) {
66             amountSum += amounts[i];
67         }
68 
69         uint256 balance = address(this).balance;
70 
71         require(balance >= amountSum, "Invalid factory balance");
72 
73         for (uint i=0; i < targets.length; i++) {
74             payable(targets[i]).transfer(amounts[i]);
75             emit DecreaseBalance(targets[i], amounts[i]);
76         }
77     }
78 }