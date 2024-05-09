1 pragma solidity ^0.4.23;
2 
3 contract Contract {
4     mapping (address => uint256) public balances_bonus;
5     uint256 public contract_eth_value_bonus;
6 }
7 
8 contract ERC20 {
9   function transfer(address _to, uint256 _value) public returns (bool success);
10   function balanceOf(address _owner) public constant returns (uint256 balance);
11 }
12 
13 contract EdenchainProxy {
14 
15   struct Snapshot {
16     uint256 tokens_balance;
17     uint256 eth_balance;
18   }
19 
20 
21   Contract contr;
22   uint256 public eth_balance;
23   ERC20 public token;
24   mapping (address => uint8) public contributor_rounds;
25   Snapshot[] public snapshots;
26   address owner;
27   uint8 public rounds;
28 
29   constructor(address _contract, address _token) {
30       owner = msg.sender;
31       contr = Contract(_contract);
32       token = ERC20(_token);
33       eth_balance = contr.contract_eth_value_bonus();
34   }
35 
36   //public functions
37   function withdraw()  {
38   		/* require(contract_token_balance != 0); */
39   		if (contributor_rounds[msg.sender] < rounds) {
40             uint256 balance = contr.balances_bonus(msg.sender);
41   			Snapshot storage snapshot = snapshots[contributor_rounds[msg.sender]];
42             uint256 tokens_to_withdraw = (balance * snapshot.tokens_balance) / snapshot.eth_balance;
43             /* require(tokens_to_withdraw != 0); */
44   			snapshot.tokens_balance -= tokens_to_withdraw;
45   			snapshot.eth_balance -= balance;
46             contributor_rounds[msg.sender]++;
47             require(token.transfer(msg.sender, tokens_to_withdraw));
48       }
49   }
50 
51   function emergency_withdraw(address _token) {
52       require(msg.sender == owner);
53       require(ERC20(_token).transfer(owner, ERC20(_token).balanceOf(this)));
54   }
55 
56   function set_tokens_received() {
57     require(msg.sender == owner);
58     uint256 previous_balance;
59     uint256 tokens_this_round;
60     for (uint8 i = 0; i < snapshots.length; i++) {
61       previous_balance += snapshots[i].tokens_balance;
62     }
63     tokens_this_round = token.balanceOf(address(this)) - previous_balance;
64     require(tokens_this_round != 0);
65     snapshots.push(Snapshot(tokens_this_round, eth_balance));
66     rounds++;
67   }
68 
69   function set_token_address(address _token) {
70     require(msg.sender == owner && _token != 0x0);
71     token = ERC20(_token);
72   }
73 
74   function set_contract_address(address _contract) {
75     require(msg.sender == owner);
76     contr = Contract(_contract);
77   }
78 }