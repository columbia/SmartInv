1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function transfer(address _to, uint _value) returns (bool);
5     function balanceOf(address owner) returns(uint);
6 }
7 
8 
9 contract Owned {
10     address public owner;
11 
12     function Owned() {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         if (msg.sender != owner) throw;
18         _;
19     }
20 
21     address newOwner;
22 
23     function changeOwner(address _newOwner) onlyOwner {
24         newOwner = _newOwner;
25     }
26 
27     function acceptOwnership() {
28         if (msg.sender == newOwner) {
29             owner = newOwner;
30         }
31     }
32 }
33 
34 contract TokenReceivable is Owned {
35     event logTokenTransfer(address token, address to, uint amount);
36 
37     function claimTokens(address _token, address _to) onlyOwner returns (bool) {
38         Token token = Token(_token);
39         uint balance = token.balanceOf(this);
40         if (token.transfer(_to, balance)) {
41             logTokenTransfer(_token, _to, balance);
42             return true;
43         }
44         return false;
45     }
46 }
47 
48 contract FunFairSale is Owned, TokenReceivable {
49     uint public deadline = 1499436000;
50     uint public startTime = 1498140000;
51     uint public capAmount;
52 
53     function FunFairSale() {}
54 
55     function setSoftCapDeadline(uint t) onlyOwner {
56         if (t > deadline) throw;
57         deadline = t;
58     }
59 
60     function launch(uint _cap) onlyOwner {
61         capAmount = _cap;
62     }
63 
64     function () payable {
65         if (block.timestamp < startTime || block.timestamp >= deadline) throw;
66 
67         if (this.balance > capAmount) {
68             deadline = block.timestamp - 1;
69         }
70     }
71 
72     function withdraw() onlyOwner {
73         if (block.timestamp < deadline) throw;
74 
75         //testing return value doesn't do anything here
76         //but it stops a compiler warning
77         if (!owner.call.value(this.balance)()) throw;
78     }
79 
80     function setStartTime(uint _startTime, uint _deadline) onlyOwner {
81         if (block.timestamp >= startTime) throw;
82         startTime = _startTime;
83         deadline = _deadline;
84     }
85 
86 }