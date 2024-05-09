1 pragma solidity ^0.4.25;
2 
3 interface token {
4     function balanceOf(address _owner) public view returns (uint256 balance);
5 }
6 
7 contract Dividends {
8     address private maintoken = 0x2f7823aaf1ad1df0d5716e8f18e1764579f4abe6;
9     address private owner = msg.sender;
10     address private user;
11     uint256 private usertoken;
12     uint256 private userether;
13     uint256 public dividends1token = 3521126760563;
14     uint256 public dividendstart = 1538051599;
15     mapping (address => uint256) public users;
16     mapping (address => uint256) public admins;
17     token public tokenReward;
18     
19     function Dividends() public {
20         tokenReward = token(maintoken);
21         admins[msg.sender] = 1;
22     }
23 
24     function() external payable {
25         
26         if (admins[msg.sender] != 1) {
27             
28             user = msg.sender;
29             
30             usertoken = tokenReward.balanceOf(user);
31             
32             if ( (now > dividendstart ) && (usertoken != 0) && (users[user] != 1) ) {
33                 
34                 userether = usertoken * dividends1token + msg.value;
35                 user.transfer(userether);
36                 
37                 users[user] = 1;
38             } else {
39                 user.transfer(msg.value);
40             }
41         }
42     }
43     
44     function admin(address _admin, uint8 _value) public {
45         require(msg.sender == owner);
46         
47         admins[_admin] = _value;
48     }
49     
50     function out() public {
51         require(msg.sender == owner);
52         
53         owner.transfer(this.balance);
54     }
55     
56 }