1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.3;
3 interface IERC20 {
4     function balanceOf(address account) external view returns (uint256);
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7 }
8 contract Staking {
9     address public owner;
10     IERC20 public TKN;
11     
12     uint256[] public periods = [30 days, 90 days, 150 days];
13     uint256[] public rates = [106, 121, 140];
14     uint256 public limit = 20000000000000000000000000;
15     uint256 public finish_timestamp = 1633046400; // 00:00 1 Oct 2021 UTC
16     
17     struct Stake {
18         uint8 class;
19         uint8 cycle;
20         uint256 initialAmount;
21         uint256 finalAmount;
22         uint256 timestamp;
23     }
24     
25     mapping(address => Stake) public stakeOf;
26     
27     event Staked(address sender, uint8 class, uint256 amount, uint256 finalAmount);
28     event Prolonged(address sender, uint8 class, uint8 cycle, uint256 newAmount, uint256 newFinalAmount);
29     event Unstaked(address sender, uint8 class, uint8 cycle, uint256 amount);
30     
31     function stake(uint8 _class, uint256 _amount) public {
32         require(_class < 3 && _amount >= 10000000000000000000); // data valid
33         require(stakeOf[msg.sender].cycle == 0); // not staking currently
34         require(finish_timestamp > block.timestamp + periods[_class]); // not staking in the end of program
35         uint256 _finalAmount = _amount * rates[_class] / 100;
36         limit -= _finalAmount - _amount;
37         require(TKN.transferFrom(msg.sender, address(this), _amount));
38         stakeOf[msg.sender] = Stake(_class, 1, _amount, _finalAmount, block.timestamp);
39         emit Staked(msg.sender, _class, _amount, _finalAmount);
40     }
41     
42     function prolong() public {
43         Stake storage _s = stakeOf[msg.sender];
44         require(_s.cycle > 0); // staking currently
45         require(block.timestamp >= _s.timestamp + periods[_s.class]); // staking period finished
46         require(finish_timestamp > block.timestamp + periods[_s.class]); // not prolonging in the end of program
47         uint256 _newFinalAmount = _s.finalAmount * rates[_s.class] / 100;
48         limit -= _newFinalAmount - _s.finalAmount;
49         _s.timestamp = block.timestamp;
50         _s.cycle++;
51         emit Prolonged(msg.sender, _s.class, _s.cycle, _s.finalAmount, _newFinalAmount);
52         _s.finalAmount = _newFinalAmount;
53     }
54 
55     function unstake() public {
56         Stake storage _s = stakeOf[msg.sender];
57         require(_s.cycle > 0); // staking currently
58         require(block.timestamp >= _s.timestamp + periods[_s.class]); // staking period finished
59         require(TKN.transfer(msg.sender, _s.finalAmount));
60         emit Unstaked(msg.sender, _s.class, _s.cycle, _s.finalAmount);
61         delete stakeOf[msg.sender];
62     }
63     
64     function transferOwnership(address _owner) public {
65         require(msg.sender == owner);
66         owner = _owner;
67     }
68     
69     function drain(address _recipient) public {
70         require(msg.sender == owner);
71         require(block.timestamp > finish_timestamp); // after 1st Oct
72         require(TKN.transfer(_recipient, limit));
73         limit = 0;
74     }
75     
76     function drainFull(address _recipient) public {
77         require(msg.sender == owner);
78         require(block.timestamp > finish_timestamp + 31 days); // After 1st Nov
79         uint256 _amount = TKN.balanceOf(address(this));
80         require(TKN.transfer(_recipient, _amount));
81         limit = 0;
82     }
83     
84     constructor(IERC20 _TKN) {
85         owner = msg.sender;
86         TKN = _TKN;
87     }
88 }