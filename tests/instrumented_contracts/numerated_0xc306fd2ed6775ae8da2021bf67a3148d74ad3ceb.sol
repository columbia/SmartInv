1 pragma solidity ^0.4.0;
2 contract Bitscreen {
3     struct IPFSHash {
4     bytes32 hash;
5     uint8 hashFunction;
6     uint8 size;
7     }
8     event ImageChange(bytes32 _hash,uint8 _hashFunction,uint8 _size);
9 
10     struct ScreenData {
11     uint currLargestAmount;
12     uint256 totalRaised;
13     address currHolder;
14     uint8 heightRatio;
15     uint8 widthRatio;
16     string country;
17     }
18     
19     struct ContentRules {
20         bool sexual;
21         bool violent;
22         bool political;
23         bool controversial;
24         bool illegal;
25     }
26     event RuleChange(bool _sexual,bool _violent,bool _political,bool _controversial,bool _illegal);
27     address public owner;
28     
29     IPFSHash public currPicHash;
30     
31     ScreenData public screenstate;
32     ContentRules public rules;
33     address[] private badAddresses;
34 
35     function Bitscreen(bytes32 _ipfsHash, uint8 _ipfsHashFunc, uint8 _ipfsHashSize, uint8 _heightRatio, uint8 _widthRatio, string _country) public {
36         owner = msg.sender;
37         currPicHash = IPFSHash(_ipfsHash,_ipfsHashFunc,_ipfsHashSize);
38         screenstate = ScreenData(0,0, msg.sender,_heightRatio,_widthRatio,_country);
39         rules = ContentRules(false,false,false,false,false);
40     }
41     
42     function remove() public {
43         if(msg.sender == owner) {
44         selfdestruct(owner);
45         }
46     }
47     
48     function withdraw() external{
49         if(msg.sender == owner) {
50             uint256 withdrawAmount = screenstate.totalRaised;
51             screenstate.totalRaised=0;
52             screenstate.currLargestAmount=0;
53             msg.sender.transfer(withdrawAmount);
54         }else{
55             revert();
56         }
57     }
58 
59     function getBadAddresses() external constant returns (address[]) {
60         if(msg.sender == owner) {
61             return badAddresses;
62         }else{
63             revert();
64         }
65     }
66 
67 
68     function changeRules(bool _sexual,bool _violent, bool _political, bool _controversial, bool _illegal) public {
69                 if(msg.sender == owner) {
70                 rules.sexual=_sexual;
71                 rules.violent=_violent;
72                 rules.political=_political;
73                 rules.controversial=_controversial;
74                 rules.illegal=_illegal;
75                 
76                 RuleChange(_sexual,_violent,_political,_controversial,_illegal);
77                 
78                 }else{
79                 revert();
80                 }
81     }
82 
83 
84     function changeBid(bytes32 _ipfsHash, uint8 _ipfsHashFunc, uint8 _ipfsHashSize) payable external {
85             if(msg.value>screenstate.currLargestAmount) {
86                 screenstate.currLargestAmount=msg.value;
87                 screenstate.currHolder=msg.sender;
88                 screenstate.totalRaised+=msg.value;
89                 
90                 currPicHash.hash=_ipfsHash;
91                 currPicHash.hashFunction=_ipfsHashFunc;
92                 currPicHash.size=_ipfsHashSize;
93                 
94                 ImageChange(_ipfsHash,_ipfsHashFunc,_ipfsHashSize);
95                 
96             }else {
97                 revert();
98             }
99     }
100     
101     function emergencyOverwrite(bytes32 _ipfsHash, uint8 _ipfsHashFunc, uint8 _ipfsHashSize) external {
102         if(msg.sender == owner) { 
103             badAddresses.push(screenstate.currHolder);
104             currPicHash.hash=_ipfsHash;
105             currPicHash.hashFunction=_ipfsHashFunc;
106             currPicHash.size=_ipfsHashSize;
107             screenstate.currHolder=msg.sender;
108             ImageChange(_ipfsHash,_ipfsHashFunc,_ipfsHashSize);
109         }else{
110             revert();
111         }
112     }
113     
114     function () payable public {}
115 
116 }