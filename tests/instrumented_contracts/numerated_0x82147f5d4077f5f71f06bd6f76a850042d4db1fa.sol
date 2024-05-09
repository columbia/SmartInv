1 pragma solidity ^0.4.23;
2 
3 contract owned {
4 
5     address owner;
6 
7     /*this function is executed at initialization and sets the owner of the contract */
8     constructor() public { owner = msg.sender; }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 contract mortal is owned {
17 
18     /* Function to recover the funds on the contract */
19     function kill() public onlyOwner() {
20         selfdestruct(owner);
21     }
22 
23 }
24 
25 contract CryptoCows is owned, mortal {
26    
27     struct Cow {
28         uint32 milk;
29         uint32 readyTime;
30     }
31 
32     event GetCowEvent(uint id);
33     event GetMilkEvent(uint32 milk, uint32 timestamp);
34     
35     Cow[] public cows;
36     uint public allMilk;
37     
38     mapping(uint => address) public owners;
39     mapping(address => uint) public count;
40     mapping(address => uint) public ownerCow;
41     
42     constructor() public {
43         owner = msg.sender;
44     }
45     
46     function getCow(uint _cowId) public view returns (uint32, uint32) {
47         Cow storage _cow = cows[_cowId];
48         return (_cow.milk, _cow.readyTime);
49     }
50     
51     function countCows() public view returns(uint) {
52         return cows.length;
53     }
54     
55     function countMilk() public view returns(uint) {
56         return allMilk;
57     }
58     
59     function buyCow() public {
60         require(count[msg.sender] == 0);
61         uint id = cows.length;
62         cows.push(Cow(0, uint32(now)));
63         owners[id] = msg.sender;
64         count[msg.sender] = 1;
65         ownerCow[msg.sender] = id;
66         emit GetCowEvent(id);
67     }
68     
69     function removeCooldown() public payable {
70         require(msg.value == 0.001 ether);
71         require(count[msg.sender] == 1);
72         uint _cowId = ownerCow[msg.sender];
73         Cow storage currentCow = cows[_cowId];
74         require(_isReady(currentCow) == false);
75         currentCow.readyTime = uint32(now);
76         emit GetCowEvent(_cowId);
77     }
78     
79     function _isReady(Cow storage _cow) internal view returns (bool) {
80         return (_cow.readyTime <= now);
81     }    
82     
83     function getMilk() public {
84         require(count[msg.sender] == 1);
85         uint _cowId = ownerCow[msg.sender];
86         Cow storage currentCow = cows[_cowId];
87         require(_isReady(currentCow));
88         uint32 addMilk = uint32(random());
89         allMilk = allMilk + uint(addMilk);
90         currentCow.milk += addMilk;
91         currentCow.readyTime = uint32(now + 1 hours);
92         emit GetMilkEvent(addMilk, currentCow.readyTime);
93     }
94     
95     function random() private view returns (uint8) {
96         return uint8(uint256(keccak256(block.timestamp, block.difficulty))%221);
97     }    
98     
99     function withDraw() public onlyOwner {
100         uint amount = getBalance();
101         owner.transfer(amount);
102     }
103     
104     function getBalance() public view returns (uint){
105         return address(this).balance;
106     }    
107 }