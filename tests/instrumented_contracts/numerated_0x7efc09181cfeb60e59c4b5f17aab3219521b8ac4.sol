1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.6;
3 
4 // iRUNE Interface
5 interface iRUNE {
6     function transfer(address, uint) external returns (bool);
7     function transferTo(address, uint) external returns (bool);
8 }
9 
10 contract RUNE_Bridge {
11 
12     address public owner;
13     address public server;
14     address public RUNE;
15 
16     event Deposit(address indexed from, uint value, string memo);
17     event Outbound(address indexed to, uint value, string memo);
18 
19     constructor() {
20         owner = msg.sender;
21     }
22 
23     // Only Owner can execute
24     modifier onlyOwner() {
25         require(msg.sender == owner, "Must be Owner");
26         _;
27     }
28 
29     // Only Owner/Server can execute
30     modifier onlyAdmin() {
31         require(msg.sender == server || msg.sender == owner, "Must be Admin");
32         _;
33     }
34 
35     // Owner calls to set server
36     function setServer(address _server) public onlyOwner {
37         server = _server;
38     }
39 
40     // Owner calls to set RUNE
41     function setRune(address _rune) public onlyOwner {
42         RUNE = _rune;
43     }
44 
45     // User to deposit RUNE with a memo.
46     function deposit(uint value, string memory memo) public {
47         require(value > 0, "user must send assets");
48         iRUNE(RUNE).transferTo(address(this), value);
49         emit Deposit(msg.sender, value, memo);
50     }
51 
52     // Admin to transfer to recipient
53     function transferOut(address to, uint value, string memory memo) public onlyAdmin {
54         iRUNE(RUNE).transfer(to, value);
55         emit Outbound(to, value, memo);
56     }
57 
58 }