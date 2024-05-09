1 pragma solidity 0.4.17;
2 
3 contract Token {
4 
5     /* Total amount of tokens */
6     uint256 public totalSupply;
7 
8     /*
9      * Events
10      */
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 
14     /*
15      * Public functions
16      */
17 
18     /// @notice send `value` token to `to` from `msg.sender`
19     /// @param to The address of the recipient
20     /// @param value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address to, uint value) public returns (bool);
23 
24     /// @notice send `value` token to `to` from `from` on the condition it is approved by `from`
25     /// @param from The address of the sender
26     /// @param to The address of the recipient
27     /// @param value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address from, address to, uint value) public returns (bool);
30 
31     /// @notice `msg.sender` approves `spender` to spend `value` tokens
32     /// @param spender The address of the account able to transfer the tokens
33     /// @param value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address spender, uint value) public returns (bool);
36 
37     /// @param owner The address from which the balance will be retrieved
38     /// @return The balance
39     function balanceOf(address owner) public constant returns (uint);
40 
41     /// @param owner The address of the account owning tokens
42     /// @param spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address owner, address spender) public constant returns (uint);
45 }
46 
47 contract StandardToken is Token {
48     /*
49      *  Storage
50     */
51     mapping (address => uint) balances;
52     mapping (address => mapping (address => uint)) allowances;
53 
54     /*
55      *  Public functions
56     */
57 
58     function transfer(address to, uint value) public returns (bool) {
59         // Do not allow transfer to 0x0 or the token contract itself
60         require((to != 0x0) && (to != address(this)));
61         if (balances[msg.sender] < value)
62             revert();  // Balance too low
63         balances[msg.sender] -= value;
64         balances[to] += value;
65         Transfer(msg.sender, to, value);
66         return true;
67     }
68 
69     function transferFrom(address from, address to, uint value) public returns (bool) {
70         // Do not allow transfer to 0x0 or the token contract itself
71         require((to != 0x0) && (to != address(this)));
72         if (balances[from] < value || allowances[from][msg.sender] < value)
73             revert(); // Balance or allowance too low
74         balances[to] += value;
75         balances[from] -= value;
76         allowances[from][msg.sender] -= value;
77         Transfer(from, to, value);
78         return true;
79     }
80 
81     function approve(address spender, uint value) public returns (bool) {
82         allowances[msg.sender][spender] = value;
83         Approval(msg.sender, spender, value);
84         return true;
85     }
86 
87     function allowance(address owner, address spender) public constant returns (uint) {
88         return allowances[owner][spender];
89     }
90 
91     function balanceOf(address owner) public constant returns (uint) {
92         return balances[owner];
93     }
94 }
95 
96 contract GMTSafe {
97 
98   /*
99   *  GMTSafe parameters
100   */
101   mapping (address => uint256) allocations;
102   uint256 public unlockDate;
103   StandardToken public gmtAddress;
104 
105 
106   function GMTSafe(StandardToken _gmtAddress) public {
107     require(address(_gmtAddress) != 0x0);
108 
109     gmtAddress = _gmtAddress;
110     unlockDate = now + 6 * 30 days;
111 
112     // Add allocations (must store the token grain amount to be transferred, i.e. 7000 * 10**18)
113     allocations[0x6Ab16B4CF38548A6ca0f6666DEf0b7Fb919E2fAb] = 1500000 * 10**18;
114     allocations[0x18751880F17E2cdfbb96C2385A82694ff76C9fb4] = 8000000 * 10**18;
115     allocations[0x80e97B28f908A49887463e08005A133F7488FcCb] = 6000000 * 10**18;
116     allocations[0x68981694e0a4140Db93B1F4f29DCCbB7E63127cf] = 6000000 * 10**18;
117     allocations[0xF9a5876A076266b8362A85e26c3b7ce4a338ca6A] = 5500000 * 10**18;
118     allocations[0x6FCC6070180E25CBb08a4BF4d2d841914fE3F4D3] = 6000000 * 10**18;
119     allocations[0xa0580E8404e07415459cA8E497A9a14c0c9e674e] = 6000000 * 10**18;
120     allocations[0x41C341147f76dDe749061A7F114E60B087f5417a] = 3000000 * 10**18;
121     allocations[0x53163423D3233fCaF79F3E5b29321A9dC62F7c1b] = 6000000 * 10**18;
122     allocations[0x9D8405E32d64F163d4390D4f2128DD20C5eFd2c5] = 6500000 * 10**18;
123     allocations[0xe5070738809A16E21146D93bd1E9525539B0537F] = 6000000 * 10**18;
124     allocations[0x147c39A17883D1d5c9F95b32e97824a516F02938] = 4000000 * 10**18;
125     allocations[0x90dA392F16dBa254C8Ebb2773394A9E2a4693996] = 4000000 * 10**18;
126     allocations[0xfd965026631CD4235f7a9BebFcF9B2063A93B89d] = 4000000 * 10**18;
127     allocations[0x51d3Fa7e2c61a96C0B93737A6f866F7D92Aaaa64] = 4000000 * 10**18;
128     allocations[0x517A577e51298467780a23E3483fD69e617C417d] = 4000000 * 10**18;
129     allocations[0x4FdD9136Ccff0acE084f5798EF4973D194d5096a] = 4000000 * 10**18;
130     allocations[0x684b9935beA0B3d3FD7Dcd3805E4047E94F753Be] = 4000000 * 10**18;
131     allocations[0x753e324cfaF03515b6C3767895F4db764f940c36] = 2000000 * 10**18;
132     allocations[0xD2C3b32c3d23BE008a155eBEefF816FA30E9FD33] = 2000000 * 10**18;
133     allocations[0x5e8fE6bCdb699837d27eD8F83cD5d822261C9477] = 2000000 * 10**18;
134     allocations[0xbf17d390DFBa5543B9BD43eDa921dACf44d5B938] = 2000000 * 10**18;
135     allocations[0x13B46bEA905dC7b8BA5A0cc3384cB67af62bBD5d] = 1000000 * 10**18;
136     allocations[0xfdB892D3C0dA81F146537aBE224E92d104Ca0FCf] = 1000000 * 10**18;
137     allocations[0xc0D51078dfe76238C80b44f91053887a61eF5bC8] = 500000 * 10**18;
138     allocations[0xfe1864D700899D9d744BC8d1FC79693E7d184556] = 500000 * 10**18;
139     allocations[0xEA836E0A52423ad49c234858016d82a40C2bd103] = 500000 * 10**18;  
140     allocations[0xAA989BE25a160d4fb83b12d238133d86f9C1f388] = 450000 * 10**18;
141   }
142 
143   /// @notice transfer `allocations[msg.sender]` tokens to `msg.sender` from this contract
144   /// @dev The GMT allocations given to the msg.sender are transfered to their account if the lockup period is over
145   /// @return boolean indicating whether the transfer was successful or not
146   function unlock() external {
147     require(now >= unlockDate);
148 
149     uint256 entitled = allocations[msg.sender];
150     require(entitled > 0);
151     allocations[msg.sender] = 0;
152 
153     if (!StandardToken(gmtAddress).transfer(msg.sender, entitled)) {
154         revert();  // Revert state due to unsuccessful refund
155     }
156   }
157 }