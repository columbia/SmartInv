1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function balanceOf(address _owner) external returns (uint256);
5     function transfer(address _to, uint256 _value) external;
6 }
7 
8 contract Donations {
9     struct Project
10     {
11         uint16 Id;
12         uint256 Target;
13         uint256 Current;
14     }
15     mapping(uint16 => Project) public projects;
16     address owner;
17     uint8 public projectsCount;
18     
19     address queen;
20     address joker;
21     address knight;
22     address paladin;
23 
24     ERC20Interface horseToken;
25     address horseTokenAddress = 0x5B0751713b2527d7f002c0c4e2a37e1219610A6B;
26     
27     uint8 jokerDivs = 50;
28     uint8 knightDivs = 30;
29     uint8 paladinDivs = 10;
30     
31     uint256 private toDistribute;
32     uint256 private toDistributeHorse;
33     mapping(address => uint256) private _balances;
34     mapping(address => uint256) private _balancesHorse;
35    
36     constructor(address _queen, address _joker, address _knight, address _paladin) public {
37         owner = msg.sender;
38         queen = _queen;
39         joker = _joker;
40         knight = _knight;
41         paladin = _paladin;
42 
43         horseToken = ERC20Interface(horseTokenAddress);
44     }
45  /*   
46     function changeAddressQueen(address newAddr) external {
47         require(msg.sender == queen,"wrong role");
48         _transferCeo(newAddr);
49         queen = newAddr;
50     }
51     function changeAddressJoker(address newAddr) external {
52         require(msg.sender == joker,"wrong role");
53         _transferCeo(newAddr);
54         joker = newAddr;
55     }
56     function changeAddressKnight(address newAddr) external {
57         require(msg.sender == knight,"wrong role");
58         _transferCeo(newAddr);
59         knight = newAddr;
60     }
61     function changeAddressPaladin(address newAddr) external {
62         require(msg.sender == paladin,"wrong role");
63         _transferCeo(newAddr);
64         paladin = newAddr;
65     }
66 */    
67     function addProject(uint256 target) external
68     onlyOwner()
69     returns (uint16) {
70         uint16 newid = uint16(projectsCount);
71         projectsCount = projectsCount + 1;
72         Project storage proj = projects[newid];
73         proj.Id = newid;
74         proj.Target = target;
75         return newid;
76     }
77     
78     function donateToProject(uint16 id) external payable {
79         require(id < projectsCount,"project doesnt exist");
80         require(msg.value > 0,"non null donations only");
81         projects[id].Current = projects[id].Current + msg.value;
82         toDistribute = toDistribute + msg.value;
83     }
84     
85     function () external payable {
86        //fallback function just accept the funds
87     }
88     
89     function withdraw() external {
90         //check for pure transfer ETH and HORSe donations
91         _distributeRest();
92         if(toDistribute > 0)
93             _distribute();
94         if(toDistributeHorse > 0)
95             _distributeHorse();
96         if(_balances[msg.sender] > 0) {
97             msg.sender.transfer(_balances[msg.sender]);
98             _balances[msg.sender] = 0;
99         }
100 
101         if(_balancesHorse[msg.sender] > 0) {
102             horseToken.transfer(msg.sender,_balancesHorse[msg.sender]);
103             _balancesHorse[msg.sender] = 0;
104         }
105     }
106     
107     function checkBalance() external view
108     onlyCeo() returns (uint256,uint256) {
109         return (_balances[msg.sender],_balancesHorse[msg.sender]);
110     }
111 
112     function _distributeRest() internal {
113         int rest = int(address(this).balance)
114         - int(_balances[joker]) 
115         - int(_balances[knight]) 
116         - int(_balances[paladin]) 
117         - int(_balances[queen]) 
118         - int(toDistribute);
119         if(rest > 0) {
120             toDistribute = toDistribute + uint256(rest);
121         }
122 
123         uint256 ownedHorse = horseToken.balanceOf(address(this));
124         if(ownedHorse > 0) {
125             int restHorse = int(ownedHorse)
126             - int(_balancesHorse[joker]) 
127             - int(_balancesHorse[knight]) 
128             - int(_balancesHorse[paladin]) 
129             - int(_balancesHorse[queen]) 
130             - int(toDistributeHorse);
131 
132             if(restHorse > 0) {
133                 toDistributeHorse = toDistributeHorse + uint256(restHorse);
134             }
135         }
136     }
137     
138     function _distribute() private {
139         uint256 parts = toDistribute / 100;
140         uint256 jokerDue = parts * 50;
141         uint256 knightDue = parts * 30;
142         uint256 paladinDue = parts * 10;
143 
144         _balances[joker] = _balances[joker] + jokerDue;
145         _balances[knight] = _balances[knight] + knightDue;
146         _balances[paladin] = _balances[paladin] + paladinDue;
147         _balances[queen] = _balances[queen] + (toDistribute - jokerDue - knightDue - paladinDue);
148         
149         toDistribute = 0;
150     }
151 
152     function _distributeHorse() private {
153         uint256 parts = toDistributeHorse / 100;
154         uint256 jokerDue = parts * 50;
155         uint256 knightDue = parts * 30;
156         uint256 paladinDue = parts * 10;
157 
158         _balancesHorse[joker] = _balancesHorse[joker] + jokerDue;
159         _balancesHorse[knight] = _balancesHorse[knight] + knightDue;
160         _balancesHorse[paladin] = _balancesHorse[paladin] + paladinDue;
161         _balancesHorse[queen] = _balancesHorse[queen] + (toDistributeHorse - jokerDue - knightDue - paladinDue);
162 
163         toDistributeHorse = 0;
164     }
165  /*   
166     function _transferCeo(address newAddr) internal
167     unique(newAddr)
168     {
169         require(newAddr != address(0),"address is 0");
170 
171         _balances[newAddr] = _balances[msg.sender];
172         _balances[msg.sender] = 0;
173 
174         _balancesHorse[newAddr] = _balancesHorse[msg.sender];
175         _balancesHorse[msg.sender] = 0;
176     }
177  */   
178     function _isCeo(address addr) internal view returns (bool) {
179         return ((addr == queen) || (addr == joker) || (addr == knight) || (addr == paladin));
180     }
181     
182     modifier onlyOwner() {
183         require(msg.sender == owner, "only owner");
184         _;
185     }
186     
187     modifier onlyCeo() {
188         require(_isCeo(msg.sender), "not ceo");
189         _;
190     }
191     
192     modifier unique(address newAddr) {
193         require(!_isCeo(newAddr),"not unique");
194         _;
195     }
196 }