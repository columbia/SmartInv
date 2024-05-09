1 pragma solidity ^0.4.25;
2 
3 contract GMBCToken {
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6 }
7 
8 contract GamblicaEarlyAccess {
9 
10     enum State { CREATED, DEPOSIT, CLAIM }
11 
12     uint constant PRIZE_FUND_GMBC = 100000000 * (10 ** 18); // 100 000 000 GMBC
13 
14     event DepositRegistered(address _player, uint _amount);    
15 
16     GMBCToken public gmbcToken;    
17     address public gamblica;
18 
19     State public state;    
20     uint public gmbcTotal;
21     mapping (address => uint) public deposit;
22     
23     modifier onlyGamblica() {
24         require(msg.sender == gamblica, "Method can be called only by gamblica");
25         _;
26     }
27 
28     constructor(address _gamblica, address _gmbcTokenAddress) public {
29       state = State.CREATED;
30 
31       gamblica = _gamblica;
32       gmbcToken = GMBCToken(_gmbcTokenAddress);            
33     }
34 
35     function () external payable {
36       require(msg.value == 0, "This contract does not accept ether");
37 
38       claim();
39     }
40 
41     function start() public onlyGamblica {
42       require(gmbcToken.balanceOf(address(this)) >= PRIZE_FUND_GMBC, "Contract can only be activated with a prize fund");
43       require(state == State.CREATED, "Invalid contract state");
44 
45       gmbcTotal = PRIZE_FUND_GMBC;
46       state = State.DEPOSIT;
47     }
48 
49     function registerDeposit(address player, uint amount) public onlyGamblica {
50       require(state == State.DEPOSIT, "Invalid contract state");
51       require(gmbcTotal + amount <= gmbcToken.balanceOf(address(this)), "Cant register that deposit");
52 
53       gmbcTotal += amount;      
54       deposit[player] += amount;
55 
56       emit DepositRegistered(player, amount);
57     }
58 
59 
60     function addWinnigs(address[] memory winners, uint[] memory amounts) public onlyGamblica {
61       require(winners.length == amounts.length, "Invalid arguments");
62       require(state == State.DEPOSIT, "Invalid contract state");
63       
64       uint length = winners.length;
65       for (uint i = 0; i < length; i++) {
66         deposit[winners[i]] += amounts[i];
67       }
68     }
69     
70     function end() public onlyGamblica {      
71       require(state == State.DEPOSIT, "Invalid contract state");
72 
73       state = State.CLAIM;
74     }
75 
76     function claim() public {
77       require(state == State.CLAIM, "Contract should be deactivated first");
78       
79       uint amount = deposit[msg.sender];
80       deposit[msg.sender] = 0;
81       gmbcToken.transfer(msg.sender, amount);      
82     }
83 
84     function die() public onlyGamblica {
85       uint amount = gmbcToken.balanceOf(address(this));
86       gmbcToken.transfer(msg.sender, amount);
87       selfdestruct(msg.sender);
88     }
89 }