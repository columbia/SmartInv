1 pragma solidity ^0.4.11;
2 
3 contract ERC20_Transferable {
4     function balanceOf(address addr) public returns(uint);
5     function transfer(address to, uint value) public returns (bool);
6 }
7 
8 contract TimeLockedRewardFaucet {
9 
10     // =========== CONFIG START =========== 
11     address constant public MULTISIG_OWNER = 0xe18Af0dDA74fC4Ee90bCB37E45b4BD623dC6e099;
12     address constant public TEAM_WALLET = 0x008cdC9b89AD677CEf7F2C055efC97d3606a50Bd;
13 
14     ERC20_Transferable public token = ERC20_Transferable(0x7C5A0CE9267ED19B22F8cae653F198e3E8daf098);
15     uint constant public LOCK_RELASE_TIME = 1502661351 + 15 minutes; //block.timestamp(4011221) == 1499846591
16     uint constant public WITHDRAWAL_END_TIME = LOCK_RELASE_TIME + 10 minutes;
17     // =========== CONFIG END ===========
18 
19     address[] public team_accounts;
20     uint      public locked_since = 0;
21     uint      amount_to_distribute;
22 
23     function all_team_accounts() external constant returns(address[]) {
24         return team_accounts;
25     }
26 
27     function timeToUnlockDDHHMM() external constant returns(uint[3]) {
28         if (LOCK_RELASE_TIME > now) {
29             uint diff = LOCK_RELASE_TIME - now;
30             uint dd = diff / 1 days;
31             uint hh = diff % 1 days / 1 hours;
32             uint mm = diff % 1 hours / 1 minutes;
33             return [dd,hh,mm];
34         } else {
35             return [uint(0), uint(0), uint(0)];
36         }
37     }
38 
39     function start() external
40     only(MULTISIG_OWNER)
41     inState(State.INIT){
42         locked_since = now;
43     }
44 
45     function () payable {
46         msg.sender.transfer(msg.value); //pay back whole amount sent
47 
48         State state = _state();
49         if (state==State.INIT) {
50             //collect addresses for payout
51             require(indexOf(team_accounts,msg.sender)==-1);
52             team_accounts.push(msg.sender);
53         } else if (state==State.WITHDRAWAL) {
54             // setup amount to distribute
55             if (amount_to_distribute==0) amount_to_distribute = token.balanceOf(this);
56             //payout processing
57             require(indexOf(team_accounts, msg.sender)>=0);
58             token.transfer(msg.sender,  amount_to_distribute / team_accounts.length);
59         } else if (state==State.CLOSED) {
60             //collect unclaimed token to team wallet
61             require(msg.sender == TEAM_WALLET);
62             var balance = token.balanceOf(this);
63             token.transfer(msg.sender, balance);
64         } else {
65             revert();
66         }
67     }
68 
69 
70     enum State {INIT, LOCKED, WITHDRAWAL, CLOSED}
71     string[4] labels = ["INIT", "LOCKED", "WITHDRAWAL", "CLOSED"];
72 
73     function _state() internal returns(State) {
74         if (locked_since == 0)               return State.INIT;
75         else if (now < LOCK_RELASE_TIME)     return State.LOCKED;
76         else if (now < WITHDRAWAL_END_TIME)  return State.WITHDRAWAL;
77         else return State.CLOSED;
78     }
79 
80     function state() constant public returns(string) {
81         return labels[uint(_state())];
82     }
83 
84     function indexOf(address[] storage addrs, address addr) internal returns (int){
85          for(uint i=0; i<addrs.length; ++i) {
86             if (addr == addrs[i]) return int(i);
87         }
88         return -1;
89     }
90 
91     //fails if state dosn't match
92     modifier inState(State s) {
93         if (_state() != s) revert();
94         _;
95     }
96 
97     modifier only(address allowed) {
98         if (msg.sender != allowed) revert();
99         _;
100     }
101 
102 }