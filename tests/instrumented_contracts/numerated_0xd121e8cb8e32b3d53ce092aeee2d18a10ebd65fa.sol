1 pragma solidity ^0.5.0;
2 
3 interface ERC20 {
4     function totalSupply() external view returns (uint supply);
5     function balanceOf(address _owner) external view returns (uint balance);
6     function transfer(address _to, uint _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
8     function approve(address _spender, uint _value) external returns (bool success);
9     function allowance(address _owner, address _spender) external view returns (uint remaining);
10     function decimals() external view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract KotowarsChallenge 
15 {
16     mapping(address => bool) admins;
17     
18     modifier adminsOnly
19     {
20         require(admins[msg.sender] == true, "Not an admin");
21         _;
22     }
23   
24     address WCKAddress;
25   
26     uint256 challenge_ttl; 
27     uint256 fee;
28     uint256 min_buy_in;
29    
30     enum ChallengeStatus { Created, Accepted, Resolved}
31   
32     struct Challenge
33     {
34         address creator;
35         address acceptor;
36         address winner;
37         uint256 buy_in;
38         ChallengeStatus status;
39         uint256 accepted_at;
40     }
41 
42     Challenge[] challenges;
43 
44     event Created(uint256 challenge_id, address creator,  uint256 buy_in);
45     event Accepted(uint256 challenge_id, address acceptor);
46     event Resolved(uint256 challenge_id, address winner, uint256 reward);
47     event Revoked(uint256 challenge_id, address revoker);
48 
49     function create_challenge(uint256 buy_in) public {
50         ERC20 WCK = ERC20(WCKAddress);
51         require(WCK.transferFrom(msg.sender, address(this), (buy_in + fee) * (10**WCK.decimals())));
52         
53         Challenge memory challenge = Challenge({
54             creator: msg.sender,
55             acceptor: address(0),
56             winner: address(0),
57             buy_in: buy_in,
58             status: ChallengeStatus.Created,
59             accepted_at: 0
60         });
61         uint256 challenge_id = challenges.push(challenge) - 1;
62         
63         emit Created(challenge_id, challenge.creator, challenge.buy_in);
64     }
65      
66     function accept_challenge(uint256 challenge_id) public
67     {
68         require(challenge_id < challenges.length);
69      
70         Challenge memory challenge = challenges[challenge_id];
71         require(challenge.status == ChallengeStatus.Created);
72      
73         ERC20 WCK = ERC20(WCKAddress);
74         require(WCK.transferFrom(msg.sender, address(this), (challenge.buy_in + fee) * (10**WCK.decimals())));
75      
76         challenge.acceptor = msg.sender;   
77         challenge.status = ChallengeStatus.Accepted;
78         challenge.accepted_at = now;
79         
80         challenges[challenge_id] = challenge;
81         
82         emit Accepted(challenge_id, challenge.acceptor);
83     }
84    
85     function resolve(uint256 challenge_id, address winner) public adminsOnly
86     {
87         require(challenge_id < challenges.length);
88         
89         Challenge memory challenge = challenges[challenge_id];
90         require(challenge.status == ChallengeStatus.Accepted);
91         
92         challenge.winner = winner;
93         challenge.status = ChallengeStatus.Resolved;
94         
95         challenges[challenge_id] = challenge;
96         
97         uint256 reward = challenge.buy_in * 2;
98         ERC20 WCK = ERC20(WCKAddress);
99         require(WCK.transferFrom(address(this), challenge.winner, reward * (10**WCK.decimals())));
100      
101         emit Resolved(challenge_id, challenge.winner, reward);
102     }
103    
104     function unlock_funds(uint256 challenge_id) public
105     {
106         require(challenge_id < challenges.length);
107         
108         Challenge memory challenge = challenges[challenge_id];
109         require(challenge.status != ChallengeStatus.Resolved);
110         require(challenge.accepted_at + challenge_ttl < now);
111         
112         ERC20 WCK = ERC20(WCKAddress);
113         
114         if (challenge.status == ChallengeStatus.Created)
115         {
116             require(WCK.transferFrom(address(this), challenge.creator, challenge.buy_in * (10**WCK.decimals())));
117         }
118         else if (challenge.status == ChallengeStatus.Accepted)
119         {
120             require(WCK.transferFrom(address(this), challenge.creator, challenge.buy_in * (10**WCK.decimals())));
121             require(WCK.transferFrom(address(this), challenge.acceptor, challenge.buy_in * (10**WCK.decimals())));
122         }
123         
124         challenge.status = ChallengeStatus.Resolved;
125         
126         emit Revoked(challenge_id, msg.sender);
127     }
128     
129     function set_challenge_ttl(uint256 value) public adminsOnly
130     {
131         challenge_ttl = value;
132     }
133     
134     function set_min_buy_in(uint256 value) public adminsOnly
135     {
136         min_buy_in = value;
137     }
138     
139     function set_fee(uint256 value) public adminsOnly
140     {
141         fee = value;
142     }
143     
144     function set_wck_address(address value) public adminsOnly
145     {
146         WCKAddress = value;
147     }
148     
149     function add_admin(address admin) public adminsOnly
150     {
151         admins[admin] = true;
152     }
153     
154     function remove_admin(address admin) public adminsOnly
155     {
156         admins[admin] = false;
157     }
158     
159     function withdraw() public adminsOnly
160     {
161         ERC20 WCK = ERC20(WCKAddress);
162         WCK.transfer(msg.sender, WCK.balanceOf(address(this)));
163     }
164     
165     constructor() public 
166     {
167         admins[msg.sender] = true;
168         
169         WCKAddress = address(0x09fE5f0236F0Ea5D930197DCE254d77B04128075);
170         
171         challenge_ttl = 60; 
172         fee = 0;
173         min_buy_in = 0;
174     }
175 }