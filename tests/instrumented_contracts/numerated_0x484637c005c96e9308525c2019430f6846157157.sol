1 pragma solidity ^0.4.24;
2 
3 contract Subscribers {
4 
5     address public owner;
6 
7     uint256 public monthlyPrice = 0.01 ether;
8     uint256 public annualPrice = 0.1 ether;
9 
10     struct Subscriber {
11         uint256 expires;
12         address addy;
13     }
14 
15     mapping (bytes32 => Subscriber) public subs;
16 
17     event Subscribed(bytes32 emailHash, uint8 mode, address subber);
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function changeOwner(address _owner) onlyOwner external {
29         withdraw();
30         owner = _owner;
31     }
32 
33     function setMonthlyPrice(uint256 _price) onlyOwner external {
34         monthlyPrice = _price;
35     }
36 
37     function setAnnualPrice(uint256 _price) onlyOwner external {
38         annualPrice = _price;
39     }
40 
41     function subscribeMe(uint8 _monthOrYear, bytes32 _email) external payable {
42         subscribe(msg.sender, _monthOrYear, _email);
43     }
44 
45     function subscribe(address _subscriber, uint8 _monthOrYear, bytes32 _email) public payable {
46         
47         // Extend sub if already subbed
48         uint256 from = subs[_email].expires;
49         if (from == 0) {
50             from = now;
51         }
52 
53         uint256 requiredPrice = (_monthOrYear == 1) ? monthlyPrice : annualPrice;
54         require(msg.value >= requiredPrice);
55         
56         uint256 requiredDuration = (_monthOrYear == 1) ? 2629746 : 31556952;
57         subs[_email] = Subscriber(from + requiredDuration, _subscriber);
58 
59         emit Subscribed(_email, _monthOrYear, _subscriber);
60     }
61 
62     function withdraw() onlyOwner public {
63         address(owner).transfer(address(this).balance);
64     }
65 
66     function freeSub(address _subscriber, uint8 _monthOrYear, bytes32 _email) onlyOwner external {
67         uint256 requiredDuration = (_monthOrYear == 1) ? 2629746 : 31556952;
68         subs[_email] = Subscriber(now + requiredDuration, _subscriber);
69 
70         emit Subscribed(_email, _monthOrYear, _subscriber);
71     }
72 
73     function checkExpires(bytes32 _email) public view returns (uint256) {
74         return subs[_email].expires;
75     }
76 
77 }