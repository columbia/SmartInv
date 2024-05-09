1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 interface IERC20 {
4     function balanceOf(address account) external view returns (uint256);
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7 }
8 contract Staking {
9     address public owner;
10     IERC20 public TKN;
11 
12     uint256[5] public periods = [30 days, 60 days, 90 days, 180 days, 360 days];
13     uint8[5] public rates = [101, 102, 103, 106, 112];
14     uint256[5] public amounts = [10000e18, 20000e18, 30000e18, 50000e18, 100000e18];
15     uint256 public rewardsPool;
16     uint256 public MAX_STAKES = 100;
17 
18     struct Stake {
19         uint8 class;
20         uint8 cycle;
21         uint256 initialAmount;
22         uint256 finalAmount;
23         uint256 timestamp;
24         bool unstaked;
25     }
26 
27     Stake[] public stakes;
28     mapping(address => uint256[]) public stakesOf;
29     mapping(uint256 => address) public ownerOf;
30 
31     event Staked(address indexed sender, uint8 indexed class, uint256 amount, uint256 finalAmount);
32     event Prolonged(address indexed sender, uint8 indexed class, uint8 cycle, uint256 newAmount, uint256 newFinalAmount);
33     event Unstaked(address indexed sender, uint8 indexed class, uint8 cycle, uint256 amount);
34     event TransferOwnership(address indexed previousOwner, address indexed newOwner);
35     event IncreaseRewardsPool(address indexed adder, uint256 added, uint256 newSize);
36 
37     modifier restricted {
38         require(msg.sender == owner, 'This function is restricted to owner');
39         _;
40     }
41 
42     function stakesInfo(uint256 _from, uint256 _to) public view returns (Stake[] memory s) {
43         s = new Stake[](_to - _from);
44         for (uint256 i = _from; i <= _to; i++) s[i - _from] = stakes[i];
45     }
46 
47     function stakesInfoAll() public view returns (Stake[] memory s) {
48         s = new Stake[](stakes.length);
49         for (uint256 i = 0; i < stakes.length; i++) s[i] = stakes[i];
50     }
51 
52     function stakesLength() public view returns (uint256) {
53         return stakes.length;
54     }
55 
56     function myStakes(address _me) public view returns (Stake[] memory s, uint256[] memory indexes) {
57         s = new Stake[](stakesOf[_me].length);
58         indexes = new uint256[](stakesOf[_me].length);
59         for (uint256 i = 0; i < stakesOf[_me].length; i++) {
60             indexes[i] = stakesOf[_me][i];
61             s[i] = stakes[indexes[i]];
62         }
63     }
64 
65     function myActiveStakesCount(address _me) public view returns (uint256 l) {
66         uint256[] storage _s = stakesOf[_me];
67         for (uint256 i = 0; i < _s.length; i++) if (!stakes[_s[i]].unstaked) l++;
68     }
69 
70     function stake(uint8 _class) public {
71         require(_class < 5, "Wrong class"); // data valid
72         uint256 _amount = amounts[_class];
73         require(myActiveStakesCount(msg.sender) < MAX_STAKES, "MAX_STAKES overflow"); // has space for new active stake
74         uint256 _finalAmount = (_amount * rates[_class]) / 100;
75         require(rewardsPool >= _finalAmount - _amount, "Rewards pool is empty for now");
76         rewardsPool -= _finalAmount - _amount;
77         require(TKN.transferFrom(msg.sender, address(this), _amount));
78         uint256 _index = stakes.length;
79         stakesOf[msg.sender].push(_index);
80         stakes.push(Stake({
81             class: _class,
82             cycle: 1,
83             initialAmount: _amount,
84             finalAmount: _finalAmount,
85             timestamp: block.timestamp,
86             unstaked: false
87         }));
88         ownerOf[_index] = msg.sender;
89         emit Staked(msg.sender, _class, _amount, _finalAmount);
90     }
91 
92     function prolong(uint256 _index) public {
93         require(msg.sender == ownerOf[_index]);
94         Stake storage _s = stakes[_index];
95         require(!_s.unstaked); // not unstaked yet
96         require(block.timestamp >= _s.timestamp + periods[_s.class]); // staking period finished
97         uint256 _newFinalAmount = (_s.finalAmount * rates[_s.class]) / 100;
98         require(rewardsPool >= _newFinalAmount - _s.finalAmount, "Rewards pool is empty for now");
99         rewardsPool -= _newFinalAmount - _s.finalAmount;
100         _s.timestamp = block.timestamp;
101         _s.cycle++;
102         require(_s.cycle * periods[_s.class] <= 360 days, "total staking time exceeds 360 days");
103         emit Prolonged(msg.sender, _s.class, _s.cycle, _s.finalAmount, _newFinalAmount);
104         _s.finalAmount = _newFinalAmount;
105     }
106 
107     function unstake(uint256 _index) public {
108         require(msg.sender == ownerOf[_index]);
109         Stake storage _s = stakes[_index];
110         require(!_s.unstaked); // not unstaked yet
111         require(block.timestamp >= _s.timestamp + periods[_s.class]); // staking period finished
112         require(TKN.transfer(msg.sender, _s.finalAmount));
113         _s.unstaked = true;
114         emit Unstaked(msg.sender, _s.class, _s.cycle, _s.finalAmount);
115     }
116 
117     function transferOwnership(address _newOwner) public restricted {
118         require(_newOwner != address(0), 'Invalid address: should not be 0x0');
119         emit TransferOwnership(owner, _newOwner);
120         owner = _newOwner;
121     }
122 
123     function returnAccidentallySent(IERC20 _TKN) public restricted {
124         require(address(_TKN) != address(TKN));
125         uint256 _amount = _TKN.balanceOf(address(this));
126         require(TKN.transfer(msg.sender, _amount));
127     }
128 
129     function increaseRewardsPool(uint256 _amount) public {
130       TKN.transferFrom(msg.sender, address(this), _amount);
131       rewardsPool += _amount;
132       emit IncreaseRewardsPool(msg.sender, _amount, rewardsPool);
133     }
134 
135     function updateMax(uint256 _max) public restricted {
136         MAX_STAKES = _max;
137     }
138 
139     constructor(IERC20 _TKN) {
140         owner = msg.sender;
141         TKN = _TKN;
142     }
143 }