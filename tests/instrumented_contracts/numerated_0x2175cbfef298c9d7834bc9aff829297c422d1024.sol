1 pragma solidity 0.4.19;
2 
3 
4 contract InterfaceRandao {
5     function getRandom(uint256 _campaignID) external returns (uint256);
6 }
7 
8 
9 contract InterfaceWallet {
10     function changeState(uint256 _id, uint8 _state) public returns (bool);
11     function changeBranch(uint256 _id, uint8 _branch) public returns (bool);
12     function getHolder(uint256 _id) public view returns (address);
13     function getBranch(uint256 _id) public view returns (uint256);
14 }
15 
16 
17 contract EpisodeManager {
18     address public owner;
19     address public wallet;
20 
21     //max token supply
22     uint256 public cap = 50;
23 
24     InterfaceWallet public deusETH = InterfaceWallet(0x0);
25     InterfaceRandao public randao = InterfaceRandao(0x0);
26 
27     uint256 public episodesNum = 0;
28 
29     //Episode - (branch => (step => random and command))
30     struct CommandAndRandom {
31         uint256 random;
32         string command;
33         bool isSet;
34     }
35 
36     //Episode - (branches => (branch and cost))
37     struct BranchAndCost {
38         uint256 price;
39         bool isBranch;
40     }
41 
42     struct Episode {
43         //(branch => (step => random and command))
44         mapping (uint256 => mapping(uint256 => CommandAndRandom)) data;
45         //(branches => (branch and cost))
46         mapping (uint256 => BranchAndCost) branches;
47         bool isEpisode;
48     }
49 
50     mapping (uint256 => Episode) public episodes;
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function EpisodeManager(address _randao, address _wallet) public {
58         require(_randao != address(0));
59         require(_wallet != address(0));
60         owner = msg.sender;
61         wallet = _wallet;
62         randao = InterfaceRandao(_randao);
63     }
64 
65     function setLottery(address _lottery) public onlyOwner returns (bool) {
66         deusETH = InterfaceWallet(_lottery);
67         return true;
68     }
69 
70     function changeLottery(address _lottery) public onlyOwner returns (bool) {
71         deusETH = InterfaceWallet(_lottery);
72         return true;
73     }
74 
75     function changeRandao(address _randao) public onlyOwner returns (bool) {
76         randao = InterfaceRandao(_randao);
77         return true;
78     }
79 
80     function changeOwner(address _newOwner) public onlyOwner returns (bool) {
81         require(_newOwner != address(0));
82         owner = _newOwner;
83         return true;
84     }
85 
86     function changeWallet(address _wallet) public onlyOwner {
87         wallet = _wallet;
88     }
89 
90     function checkRandomFromRandao(uint256 _campaignID) public returns (uint256) {
91         return randao.getRandom(_campaignID);
92     }
93 
94     function addEpisode() public onlyOwner returns (bool) {
95         episodesNum++;
96         episodes[episodesNum].isEpisode = true;
97         return true;
98     }
99 
100     function addEpisodeData(
101         uint256 _branch,
102         uint256 _step,
103         uint256 _campaignID,
104         string _command) public onlyOwner returns (bool)
105     {
106         require(_branch > 0);
107         require(_step > 0);
108         require(_campaignID > 0);
109         require(episodes[episodesNum].isEpisode);
110         require(!episodes[episodesNum].data[_branch][_step].isSet);
111 
112         episodes[episodesNum].data[_branch][_step].random = 123;
113 
114         episodes[episodesNum].data[_branch][_step].command = _command;
115         episodes[episodesNum].data[_branch][_step].isSet = true;
116 
117         return true;
118     }
119 
120     function addBranchInEpisode(uint256 _branch, uint256 _price) public onlyOwner returns (bool) {
121         require(_branch > 0);
122         require(!episodes[episodesNum].branches[_branch].isBranch);
123         episodes[episodesNum].branches[_branch].price = _price;
124         episodes[episodesNum].branches[_branch].isBranch = true;
125         return true;
126     }
127 
128     function changeBranch(uint256 _id, uint8 _branch) public payable returns(bool) {
129         require(_branch > 0);
130         require(episodes[episodesNum].branches[_branch].isBranch);
131         require((msg.sender == deusETH.getHolder(_id)) || (msg.sender == owner));
132 
133         if (msg.sender != owner) {
134             require(deusETH.getBranch(_id) == 1);
135         }
136 
137         if (episodes[episodesNum].branches[_branch].price == 0) {
138             deusETH.changeBranch(_id, _branch);
139         } else {
140             require(msg.value == episodes[episodesNum].branches[_branch].price);
141             deusETH.changeBranch(_id, _branch);
142             forwardFunds();
143         }
144         return true;
145     }
146 
147     function changeState(uint256 _id, uint8 _state) public onlyOwner returns (bool) {
148         require(_id > 0 && _id <= cap);
149         require(_state <= 1);
150         return deusETH.changeState(_id, _state);
151     }
152 
153     function getEpisodeDataRandom(uint256 _episodeID, uint256 _branch, uint256 _step) public view returns (uint256) {
154         return episodes[_episodeID].data[_branch][_step].random;
155     }
156 
157     function getEpisodeDataCommand(uint256 _episodeID, uint256 _branch, uint256 _step) public view returns (string) {
158         return episodes[_episodeID].data[_branch][_step].command;
159     }
160 
161     function getEpisodeBranchData(uint256 _episodeID, uint256 _branch) public view returns (uint256) {
162         return episodes[_episodeID].branches[_branch].price;
163     }
164 
165     function checkBranchInEpisode(uint256 _episodesNum, uint256 _branch) public view returns (bool) {
166         return episodes[_episodesNum].branches[_branch].isBranch;
167     }
168 
169     // send ether to the fund collection wallet
170     function forwardFunds() internal {
171         wallet.transfer(msg.value);
172     }
173 }