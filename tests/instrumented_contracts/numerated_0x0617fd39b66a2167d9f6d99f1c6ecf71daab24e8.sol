1 pragma solidity 0.5.4;
2 
3 contract ProofOfFomo {
4     
5     IFomo public constant fomoLong = IFomo(0xA62142888ABa8370742bE823c1782D17A0389Da1);
6     IDivies public constant doNotPush = IDivies(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
7     uint256 public constant ROUND_THAT_NEVER_ENDS = 9;
8     
9     mapping(address => uint256) public etherPledged;
10     mapping(address => uint256) public etherSpentInRound;
11     
12     modifier isRound9
13     {
14         require(fomoLong.rID_() == ROUND_THAT_NEVER_ENDS);
15         _;
16     }
17     
18     modifier round9Ended
19     {
20         require(fomoLong.rID_() > ROUND_THAT_NEVER_ENDS);
21         _;
22     }
23     
24     function()
25         external
26         payable
27         isRound9
28     {
29         lock(msg.sender);
30     }
31     
32     function pledge()
33         external
34         payable
35         isRound9
36     {
37         lock(msg.sender);
38     }
39     
40     function gift(address _to)
41         external
42         payable
43         isRound9
44     {
45         lock(_to);
46     }
47     
48     function loot()
49         external
50         round9Ended
51     {
52         doNotPush.deposit.value(address(this).balance)();
53     }
54     
55     function lock(address _player)
56         private
57     {
58         require(msg.value > 0 ether);
59         require(etherPledged[_player] == 0);
60         
61         etherPledged[_player] = msg.value;
62         etherSpentInRound[_player] = getEtherSpentInRound(_player);
63     }
64     
65     function unlock()
66         external
67         isRound9
68     {
69         uint256 etherSpentInRoundOld = etherSpentInRound[msg.sender];
70         uint256 etherSpentInRoundNew = getEtherSpentInRound(msg.sender);
71         
72         require(etherSpentInRoundNew > etherSpentInRoundOld);
73         
74         uint256 difference = etherSpentInRoundNew - etherSpentInRoundOld;
75         uint256 etherPledgedOld = etherPledged[msg.sender];
76         
77         uint256 etherUnlocked = difference > etherPledgedOld ? etherPledgedOld : difference;
78         
79         uint256 etherPledgedNew = etherPledgedOld - etherUnlocked;
80         
81         etherPledged[msg.sender] = etherPledgedNew;
82         etherSpentInRound[msg.sender] = etherSpentInRoundNew;
83         
84         msg.sender.transfer(etherUnlocked);
85     }
86     
87     function getEtherSpentInRound(address _player)
88         private
89         returns(uint256)
90     {
91         uint256 pID = fomoLong.pIDxAddr_(_player);
92         return fomoLong.plyrRnds_(pID, ROUND_THAT_NEVER_ENDS);
93     }
94 }
95     
96 interface IFomo {
97 	function rID_() external returns(uint256);
98 	function pIDxAddr_(address player) external returns(uint256);
99 	function plyrRnds_(uint256 pID, uint256 rID) external returns(uint256);
100 }
101 
102 interface IDivies {
103     function deposit() external payable;
104 }