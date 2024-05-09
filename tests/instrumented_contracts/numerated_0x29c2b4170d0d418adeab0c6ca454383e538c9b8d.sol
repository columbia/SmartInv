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
13 }
14 
15 
16 contract EpisodeManager {
17     address public owner;
18     address public wallet;
19 
20     //max token supply
21     uint256 public cap = 50;
22 
23     address public randaoAddress;
24     address public lotteryAddress;
25     InterfaceWallet public lottery = InterfaceWallet(0x0);
26     InterfaceRandao public randao = InterfaceRandao(0x0);
27 
28     bool public started = false;
29 
30     uint256 public episodesNum = 0;
31 
32     //Episode - (branch => (step => random and command))
33     struct CommandAndRandom {
34         uint256 random;
35         string command;
36         bool isSet;
37     }
38 
39     //Episode - (branches => (branch and cost))
40     struct BranchAndCost {
41         uint256 price;
42         bool isBranch;
43     }
44 
45     struct Episode {
46         //(branch => (step => random and command))
47         mapping (uint256 => mapping(uint256 => CommandAndRandom)) data;
48         //(branches => (branch and cost))
49         mapping (uint256 => BranchAndCost) branches;
50         bool isEpisode;
51     }
52 
53     mapping (uint256 => Episode) public episodes;
54 
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function EpisodeManager(address _randao, address _wallet) public {
61         require(_randao != address(0));
62         require(_wallet != address(0));
63         owner = msg.sender;
64         wallet = _wallet;
65         randaoAddress = _randao;
66         randao = InterfaceRandao(_randao);
67     }
68 
69     function setLottery(address _lottery) public {
70         require(!started);
71         lotteryAddress = _lottery;
72         lottery = InterfaceWallet(_lottery);
73         started = true;
74     }
75 
76     function changeRandao(address _randao) public onlyOwner {
77         randaoAddress = _randao;
78         randao = InterfaceRandao(_randao);
79     }
80 
81     function addEpisode() public onlyOwner returns (bool) {
82         episodesNum++;
83         episodes[episodesNum].isEpisode = true;
84 
85         return true;
86     }
87 
88     function addEpisodeData(
89         uint256 _branch,
90         uint256 _step,
91         uint256 _campaignID,
92         string _command) public onlyOwner returns (bool)
93     {
94         require(_branch > 0);
95         require(_step > 0);
96         require(_campaignID > 0);
97         require(episodes[episodesNum].isEpisode);
98         require(!episodes[episodesNum].data[_branch][_step].isSet);
99 
100         episodes[episodesNum].data[_branch][_step].random = randao.getRandom(_campaignID);
101 
102         episodes[episodesNum].data[_branch][_step].command = _command;
103         episodes[episodesNum].data[_branch][_step].isSet = true;
104 
105         return true;
106     }
107 
108     function addNewBranchInEpisode(uint256 _branch, uint256 _price) public onlyOwner returns (bool) {
109         require(_branch > 0);
110         require(!episodes[episodesNum].branches[_branch].isBranch);
111         episodes[episodesNum].branches[_branch].price = _price;
112         episodes[episodesNum].branches[_branch].isBranch = true;
113         return true;
114     }
115 
116     function changeBranch(uint256 _id, uint8 _branch) public payable returns(bool) {
117         require(_branch > 0);
118         require(episodes[episodesNum].branches[_branch].isBranch);
119         require((msg.sender == lottery.getHolder(_id)) || (msg.sender == owner));
120 
121         if (episodes[episodesNum].branches[_branch].price == 0) {
122             lottery.changeBranch(_id, _branch);
123         } else {
124             require(msg.value == episodes[episodesNum].branches[_branch].price);
125             lottery.changeBranch(_id, _branch);
126             forwardFunds();
127         }
128         return true;
129     }
130 
131     function changeState(uint256 _id, uint8 _state) public onlyOwner returns (bool) {
132         require(_id > 0 && _id <= cap);
133         require(_state <= 1);
134         return lottery.changeState(_id, _state);
135     }
136 
137     function getEpisodeDataRandom(uint256 _episodeID, uint256 _branch, uint256 _step) public view returns (uint256) {
138         return episodes[_episodeID].data[_branch][_step].random;
139     }
140 
141     function getEpisodeDataCommand(uint256 _episodeID, uint256 _branch, uint256 _step) public view returns (string) {
142         return episodes[_episodeID].data[_branch][_step].command;
143     }
144 
145     function getEpisodeBranchData(uint256 _episodeID, uint256 _branch) public view returns (uint256) {
146         return episodes[_episodeID].branches[_branch].price;
147     }
148 
149     // send ether to the fund collection wallet
150     // override to create custom fund forwarding mechanisms
151     function forwardFunds() internal {
152         wallet.transfer(msg.value);
153     }
154 }