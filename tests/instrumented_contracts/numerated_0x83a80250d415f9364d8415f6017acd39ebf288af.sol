1 pragma solidity ^0.5.0;
2 
3 
4 contract IOwnable {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnerChanged(address _oldOwner, address _newOwner);
10 
11     function changeOwner(address _newOwner) public;
12     function acceptOwnership() public;
13 }
14 
15 contract Ownable is IOwnable {
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     constructor() public {
23         owner = msg.sender;
24         emit OwnerChanged(address(0), owner);
25     }
26 
27     function changeOwner(address _newOwner) public onlyOwner {
28         newOwner = _newOwner;
29     }
30 
31     function acceptOwnership() public {
32         require(msg.sender == newOwner);
33         emit OwnerChanged(owner, newOwner);
34         owner = newOwner;
35         newOwner = address(0);
36     }
37 }
38 
39 contract ITap is IOwnable {
40 
41     uint8[12] public tapPercents = [2, 2, 3, 11, 11, 17, 11, 11, 8, 8, 8, 8];
42     uint8 public nextTapNum;
43     uint8 public nextTapPercent = tapPercents[nextTapNum];
44     uint public nextTapDate;
45     uint public remainsForTap;
46     uint public baseEther;
47 
48     function init(uint _baseEther, uint _startDate) public;
49     function changeNextTap(uint8 _newPercent) public;
50     function getNext() public returns (uint);
51     function subRemainsForTap(uint _delta) public;
52 }
53 
54 contract Tap is ITap, Ownable {
55 
56     function init(uint _baseEther, uint _startDate) public onlyOwner {
57         require(baseEther == 0);
58         baseEther = _baseEther;
59         remainsForTap = _baseEther;
60         nextTapDate = _startDate;
61     }
62 
63     function changeNextTap(uint8 _newPercent) public onlyOwner {
64         require(_newPercent <= 100);
65         nextTapPercent = _newPercent;
66     }
67 
68     function getNext() public onlyOwner returns (uint) {
69         require(nextTapNum < 12);
70         require(remainsForTap > 0);
71         require(now >= nextTapDate);
72         uint tapValue;
73         if (nextTapNum == 11) {
74             tapValue = remainsForTap;
75         } else {
76             tapValue = uint(nextTapPercent) * baseEther / 100;
77             if (tapValue > remainsForTap) {
78                 tapValue = remainsForTap;
79                 nextTapNum = 11;
80             }
81         }
82         remainsForTap -= tapValue;
83         nextTapNum += 1;
84         if (nextTapNum < 12) {
85             nextTapPercent = tapPercents[nextTapNum];
86             nextTapDate += 30 days;
87         }
88         return tapValue;
89     }
90 
91     function subRemainsForTap(uint _delta) public onlyOwner {
92         require(_delta <= remainsForTap);
93         remainsForTap -= _delta;
94     }
95 }