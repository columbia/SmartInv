1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function transfer(address _to, uint _value) returns (bool);
5     function balanceOf(address owner) returns(uint);
6 }
7 
8 contract Owned {
9     address public owner;
10 
11     function Owned() {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         if (msg.sender != owner) throw;
17         _;
18     }
19 
20     address newOwner;
21 
22     function changeOwner(address _newOwner) onlyOwner {
23         newOwner = _newOwner;
24     }
25 
26     function acceptOwnership() {
27         if (msg.sender == newOwner) {
28             owner = newOwner;
29         }
30     }
31 }
32 
33 contract TokenReceivable is Owned {
34     event logTokenTransfer(address token, address to, uint amount);
35 
36     function claimTokens(address _token, address _to) onlyOwner returns (bool) {
37         Token token = Token(_token);
38         uint balance = token.balanceOf(this);
39         if (token.transfer(_to, balance)) {
40             logTokenTransfer(_token, _to, balance);
41             return true;
42         }
43         return false;
44     }
45 }
46 
47 contract FunFairSale is Owned, TokenReceivable {
48     uint public deadline;
49     uint public startTime = 123123; //set actual time here
50     uint public saleTime = 14 days;
51     uint public capAmount;
52 
53     function FunFairSale() {
54         deadline = startTime + saleTime;
55     }
56 
57     function setSoftCapDeadline(uint t) onlyOwner {
58         if (t > deadline) throw;
59         deadline = t;
60     }
61 
62     function launch(uint _cap) onlyOwner {
63         // cap is immutable once the sale starts
64         if (this.balance > 0) throw;
65         capAmount = _cap;
66     }
67 
68     function () payable {
69         if (block.timestamp < startTime || block.timestamp >= deadline) throw;
70         if (this.balance >= capAmount) throw;
71         if (this.balance + msg.value >= capAmount) {
72             deadline = block.timestamp;
73         }
74     }
75 
76     function withdraw() onlyOwner {
77         if (block.timestamp < deadline) throw;
78         if (!owner.call.value(this.balance)()) throw;
79     }
80 
81     // for testing
82     function setStartTime(uint _startTime, uint _deadline) onlyOwner {
83     	if (_deadline < _startTime) throw;
84         startTime = _startTime;
85         deadline = _deadline;
86     }
87 
88 }