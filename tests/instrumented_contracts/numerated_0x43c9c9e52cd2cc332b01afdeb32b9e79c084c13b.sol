1 pragma solidity ^0.4.23;
2 
3 contract Contract {
4   struct Contributor {
5     uint256 balance;
6     uint256 balance_bonus;
7     uint256 fee;
8     bool whitelisted;
9   }
10   mapping (address => Contributor) public contributors;
11   uint256 public contract_eth_value;
12   uint256 public contract_eth_value_fee;
13 }
14 
15 contract ERC20 {
16   function transfer(address _to, uint256 _value) public returns (bool success);
17   function balanceOf(address _owner) public constant returns (uint256 balance);
18 }
19 
20 contract HybridProxy {
21 
22   struct Contributor {
23     uint256 balance;
24     uint256 balance_bonus;
25     uint256 fee;
26     bool whitelisted;
27   }
28 
29   struct Snapshot {
30     uint256 tokens_balance;
31     uint256 eth_balance;
32   }
33 
34   //FEES RELATED
35   //============================
36   address constant public DEVELOPER1 = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
37   address constant public DEVELOPER2 = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;
38   uint256 constant public FEE_DEV = 500; //0.2% fee per dev -> so 0.4% fee in total
39   //============================
40 
41   Contract contr;
42   uint256 public eth_balance;
43   uint256 public fee_balance;
44   ERC20 public token;
45   mapping (address => uint8) public contributor_rounds;
46   Snapshot[] public snapshots;
47   address owner;
48   uint8 public rounds;
49 
50   constructor(address _contract) {
51     owner = msg.sender;
52     contr = Contract(_contract);
53     eth_balance = contr.contract_eth_value();
54     require(eth_balance != 0);
55   }
56 
57   function dev_fee(uint256 tokens_this_round) internal returns (uint256) {
58     uint256 tokens_individual;
59     tokens_individual = tokens_this_round/FEE_DEV;
60     require(token.transfer(DEVELOPER1, tokens_individual));
61     require(token.transfer(DEVELOPER2, tokens_individual));
62     tokens_this_round -= (2*tokens_individual);
63     return tokens_this_round;
64   }
65 
66   //public functions
67 
68   function withdraw()  {
69     uint256 contract_token_balance = token.balanceOf(address(this));
70 		var (balance, balance_bonus, fee, whitelisted) = contr.contributors(msg.sender);
71 		if (contributor_rounds[msg.sender] < rounds) {
72 			Snapshot storage snapshot = snapshots[contributor_rounds[msg.sender]];
73       uint256 tokens_to_withdraw = (balance * snapshot.tokens_balance) / snapshot.eth_balance;
74 			snapshot.tokens_balance -= tokens_to_withdraw;
75 			snapshot.eth_balance -= balance;
76       contributor_rounds[msg.sender]++;
77       require(token.transfer(msg.sender, tokens_to_withdraw));
78     }
79   }
80 
81   function emergency_withdraw(address _token) {
82     require(msg.sender == owner);
83     require(ERC20(_token).transfer(owner, ERC20(_token).balanceOf(this)));
84   }
85 
86   function set_tokens_received() {
87     require(msg.sender == owner);
88     uint256 previous_balance;
89     uint256 tokens_this_round;
90     for (uint8 i = 0; i < snapshots.length; i++) {
91       previous_balance += snapshots[i].tokens_balance;
92     }
93     tokens_this_round = token.balanceOf(address(this)) - previous_balance;
94     require(tokens_this_round != 0);
95     tokens_this_round = dev_fee(tokens_this_round);
96     snapshots.push(Snapshot(tokens_this_round, eth_balance));
97     rounds++;
98   }
99 
100   function set_token_address(address _token) {
101     require(msg.sender == owner && _token != 0x0);
102     token = ERC20(_token);
103   }
104 }