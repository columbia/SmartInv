1 pragma solidity ^0.4.24;
2 
3 contract CryptoBeautyVoting {
4 
5   event Won(address indexed _winner, uint256 _value);
6   bool votingStart = false;
7   uint32 private restartTime;
8   uint32 private readyTime;
9   uint256 private votePrice;
10   address[] private arrOfVoters;
11   uint256[] private arrOfBeautyIdMatchedVoters;
12   address private owner;
13   
14   constructor() public {
15     owner = msg.sender;
16     restartTime = 7 days;
17     readyTime = uint32(now + restartTime);
18     votePrice = 0.002 ether;
19   }
20 
21   /* Modifiers */
22   modifier onlyOwner() {
23     require(owner == msg.sender);
24     _;
25   }
26 
27    /* Owner */
28   function setOwner (address _owner) onlyOwner() public {
29     owner = _owner;
30   }
31 
32   function withdrawAll () onlyOwner() public {
33     owner.transfer(address(this).balance);
34   }
35 
36   function withdrawAmount (uint256 _amount) onlyOwner() public {
37     owner.transfer(_amount);
38   }
39 
40   function getCurrentBalance() public view returns (uint256 balance) {
41       return address(this).balance;
42   }
43 
44   /* Voting */
45   function startVoting() onlyOwner() public {
46     votingStart = true;
47   }
48 
49   function stopVoting() onlyOwner() public {
50     votingStart = false;
51   }
52 
53   function changeRestarTime(uint32 _rTime) onlyOwner() public {
54     restartTime = _rTime;
55   }
56 
57   function changevotePrice(uint256 _votePrice) onlyOwner() public {
58     votePrice = _votePrice;
59   }
60 
61   function _isReady() internal view returns (bool) {
62     return (readyTime <= now);
63   }
64 
65   function _isOne(address _voter) private view returns (bool) {
66     uint256 j = 0;
67     for(uint256 i = 0; i < arrOfVoters.length; i++) {
68       if(keccak256(abi.encodePacked(arrOfVoters[i])) == keccak256(abi.encodePacked(_voter)))
69       {
70         j++;
71       }
72     }
73     if(j == 0) {
74       return true;
75     } else {
76       return false;
77     }
78   }
79 
80   function vote(uint256 _itemId) payable public {
81     require(votingStart);
82     require(msg.value >= votePrice);
83     require(!isContract(msg.sender));
84     require(msg.sender != address(0));
85     require(_isOne(msg.sender));
86 
87     arrOfVoters.push(msg.sender);
88     arrOfBeautyIdMatchedVoters.push(_itemId);
89   }
90 
91   function getVoteResult() onlyOwner() public view returns (address[], uint256[]) {
92     require(_isReady());
93     return (arrOfVoters, arrOfBeautyIdMatchedVoters);
94   }
95 
96   function voteResultPublish(address[] _winner, uint256[] _value) onlyOwner() public {
97     require(votingStart);
98     votingStart = false;
99     for (uint256 i = 0; i < _winner.length; i++) {
100      _winner[i].transfer(_value[i]);
101      emit Won(_winner[i], _value[i]);
102     }
103   }
104 
105   function clear() onlyOwner() public {
106     delete arrOfVoters;
107     delete arrOfBeautyIdMatchedVoters;
108     readyTime = uint32(now + restartTime);
109     votingStart = true;
110   }
111   function getRestarTime() public view returns (uint32) {
112     return restartTime;
113   }
114 
115   function getVotingStatus() public view returns (bool) {
116     return votingStart;
117   }
118 
119   function getVotePrice() public view returns (uint256) {
120     return votePrice;
121   }
122 
123   /* Util */
124   function isContract(address addr) internal view returns (bool) {
125     uint size;
126     assembly { size := extcodesize(addr) } // solium-disable-line
127     return size > 0;
128   }
129 }