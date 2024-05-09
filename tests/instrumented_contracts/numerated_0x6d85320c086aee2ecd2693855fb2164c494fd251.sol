1 pragma solidity ^0.4.11;
2 
3 contract ATP {
4     
5     string public constant name = "ATL Presale Token";
6     string public constant symbol = "ATP";
7     uint   public constant decimals = 18;
8     
9     uint public constant PRICE = 505;
10     uint public constant TOKEN_SUPPLY_LIMIT = 2812500 * (1 ether / 1 wei);
11     
12     enum Phase {
13         Created,
14         Running,
15         Paused,
16         Migrating,
17         Migrated
18     }
19     
20     Phase public currentPhase = Phase.Created;
21     
22     address public tokenManager;
23     address public escrow;
24     address public crowdsaleManager;
25     
26     uint public totalSupply = 0;
27     mapping (address => uint256) private balances;
28     
29     event Buy(address indexed buyer, uint amount);
30     event Burn(address indexed owner, uint amount);
31     event PhaseSwitch(Phase newPhase);
32     
33     function ATP(address _tokenManager, address _escrow) {
34         tokenManager = _tokenManager;
35         escrow = _escrow;
36     }
37     
38     function() payable {
39         buyTokens(msg.sender);
40     }
41     
42     function buyTokens(address _buyer) public payable {
43         require(currentPhase == Phase.Running);
44         require(msg.value != 0);
45         
46         uint tokenAmount = msg.value * PRICE;
47         require(totalSupply + tokenAmount <= TOKEN_SUPPLY_LIMIT);
48         
49         balances[_buyer] += tokenAmount;
50         totalSupply += tokenAmount;
51         Buy(_buyer, tokenAmount);
52     }
53     
54     function balanceOf(address _owner) constant returns (uint256) {
55         return balances[_owner];
56     }
57     
58     modifier onlyTokenManager() {
59         require(msg.sender == tokenManager);
60         _;
61     }
62     
63     function setPresalePhase(Phase _nextPhase) public onlyTokenManager {
64         bool canSwitchPhase
65             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
66             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
67             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
68                 && _nextPhase == Phase.Migrating
69                 && crowdsaleManager != 0x0)
70             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
71             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
72                 && totalSupply == 0);
73         
74         require(canSwitchPhase);
75         currentPhase = _nextPhase;
76         PhaseSwitch(_nextPhase);
77     }
78     
79     function setCrowdsaleManager(address _mgr) public onlyTokenManager {
80         require(currentPhase != Phase.Migrating);
81         crowdsaleManager = _mgr;
82     }
83     
84     function withdrawEther() public onlyTokenManager {
85         if(this.balance > 0) {
86             escrow.transfer(this.balance);
87         }
88     }
89     
90     modifier onlyCrowdsaleManager() { 
91         require(msg.sender == crowdsaleManager); 
92         _;
93     }
94     
95     function burnTokens(address _owner) public onlyCrowdsaleManager {
96         require(currentPhase == Phase.Migrating);
97         
98         uint tokens = balances[_owner];
99         require(tokens > 0);
100         
101         balances[_owner] = 0;
102         totalSupply -= tokens;
103         Burn(_owner, tokens);
104         
105         if(totalSupply == 0) {
106             currentPhase = Phase.Migrated;
107             PhaseSwitch(Phase.Migrated);
108         }
109     }
110     
111 }