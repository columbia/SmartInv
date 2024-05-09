1 pragma solidity ^0.4.4;
2 
3 contract InsightsNetwork1 {
4   address public owner;
5   address public successor;
6   mapping (address => uint) public balances;
7   mapping (address => uint) public unlockTimes;
8   bool public active;
9   uint256 _totalSupply;
10 
11   string public constant name = "INS";
12   string public constant symbol = "INS";
13   uint8 public constant decimals = 0;
14 
15   function InsightsNetwork1() {
16     owner = msg.sender;
17     active = true;
18   }
19 
20   function register(address newTokenHolder, uint issueAmount) {
21     require(active);
22     require(msg.sender == owner);
23     require(balances[newTokenHolder] == 0); // Accounts can only be registered once.
24 
25     _totalSupply += issueAmount;
26     Mint(newTokenHolder, issueAmount);
27 
28     require(balances[newTokenHolder] < (balances[newTokenHolder] + issueAmount));
29     balances[newTokenHolder] += issueAmount;
30     Transfer(address(0), newTokenHolder, issueAmount);
31 
32     uint currentTime = block.timestamp; // seconds since the Unix epoch
33     uint unlockTime = currentTime + 365*24*60*60; // one year out from the current time
34     assert(unlockTime > currentTime); // check for overflow
35     unlockTimes[newTokenHolder] = unlockTime;
36   }
37 
38   function totalSupply() constant returns (uint256) {
39     return _totalSupply;
40   }
41 
42   function transfer(address _to, uint256 _value) returns (bool success) {
43     return false;
44   }
45 
46   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47     return false;
48   }
49 
50   function approve(address _spender, uint256 _value) returns (bool success) {
51     return false;
52   }
53 
54   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55     return 0;
56   }
57 
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62   function getUnlockTime(address _accountHolder) constant returns (uint256) {
63     return unlockTimes[_accountHolder];
64   }
65 
66   event Mint(address indexed _to, uint256 _amount);
67   event Transfer(address indexed _from, address indexed _to, uint256 _value);
68   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70   function makeSuccessor(address successorAddr) {
71     require(active);
72     require(msg.sender == owner);
73     //require(successorAddr == address(0));
74     successor = successorAddr;
75   }
76 
77   function deactivate() {
78     require(active);
79     require(msg.sender == owner || (successor != address(0) && msg.sender == successor));
80     active = false;
81   }
82 }