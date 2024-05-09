1 pragma solidity 0.4.15;
2 
3 contract DPIcoWhitelist {
4   address admin;
5   bool isOn;
6   mapping ( address => bool ) whitelist;
7   address[] users;
8 
9   modifier signUpOpen() {
10     if ( ! isOn ) revert();
11     _;
12   }
13 
14   modifier isAdmin() {
15     if ( msg.sender != admin ) revert();
16     _;
17   }
18 
19   modifier newAddr() {
20     if ( whitelist[msg.sender] ) revert();
21     _;
22   }
23 
24   function DPIcoWhitelist() {
25     admin = msg.sender;
26     isOn = false;
27   }
28 
29   function getAdmin() constant returns (address) {
30     return admin;
31   }
32 
33   function signUpOn() constant returns (bool) {
34     return isOn;
35   }
36 
37   function setSignUpOnOff(bool state) public isAdmin {
38     isOn = state;
39   }
40 
41   function signUp() public signUpOpen newAddr {
42     whitelist[msg.sender] = true;
43     users.push(msg.sender);
44   }
45 
46   function () {
47     signUp();
48   }
49 
50   function isSignedUp(address addr) constant returns (bool) {
51     return whitelist[addr];
52   }
53 
54   function getUsers() constant returns (address[]) {
55     return users;
56   }
57 
58   function numUsers() constant returns (uint) {
59     return users.length;
60   }
61 
62   function userAtIndex(uint idx) constant returns (address) {
63     return users[idx];
64   }
65 }