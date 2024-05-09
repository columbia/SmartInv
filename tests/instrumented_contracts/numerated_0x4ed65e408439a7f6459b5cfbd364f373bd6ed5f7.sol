1 contract PRNG_Challenge {
2 
3     // PRIVATE VARIABLES
4     address private admin;
5     uint256 private constant min_value = 100 finney; // 0.1 ETH
6     
7     // PUBLIC VARIABLES
8     uint256 public constant lucky_number = 108435827775939881852079940206236050880764931249577763315065068000725104274235;
9     uint256 public last_number;
10     uint256 public attempts;
11     address public winner;
12     
13     // EVENTS
14     event Attempt(address Participant, uint256 Number);
15     event Winner(address Winner_Address, uint256 Amount);
16 
17     // CONSTRUCTOR
18     function PRNG_Challenge()
19         private
20     {
21         admin = msg.sender;
22         last_number = 0;
23         attempts = 0;
24         winner = 0;
25     }
26 
27     // MODIFIERS
28     modifier only_min_value() {
29         if (msg.value < min_value) throw;
30         _
31     }
32     modifier only_no_value() {
33         if (msg.value != 0)  throw;
34         _
35     }
36     modifier only_admin() {
37         if (msg.sender != admin) throw;
38         _
39     }
40     modifier not_killed() {
41         if (winner != 0) throw;
42         _
43     }
44     
45     // CHALLENGE
46     function challenge()
47         private
48     {
49         address participant = msg.sender;
50         uint64 shift_32 = uint64(4294967296); // Shift by 32 bit
51         uint32 hash32 = uint32(sha3(msg.value,participant,participant.balance,block.blockhash(block.number-1),block.timestamp,block.number)); // Entropy
52         uint64 hash64 = uint64(hash32)*shift_32 + uint32(sha3(hash32));
53         uint96 hash96 = uint96(hash64)*shift_32 + uint32(sha3(hash64));
54         uint128 hash128 = uint128(hash96)*shift_32 + uint32(sha3(hash96));
55         uint160 hash160 = uint160(hash128)*shift_32 + uint32(sha3(hash128));
56         uint192 hash192 = uint192(hash160)*shift_32 + uint32(sha3(hash160));
57         uint224 hash224 = uint224(hash192)*shift_32 + uint32(sha3(hash192));
58         uint256 hash256 = uint256(hash224)*shift_32 + uint32(sha3(hash224));
59         if (hash256 == lucky_number) {
60             Winner(participant, this.balance);
61             if (!participant.send(this.balance)) throw;
62             winner = participant;
63         }
64         last_number = hash256;
65         attempts++;
66         Attempt(participant, last_number);
67     }
68     
69     // KILL
70     function admin_kill()
71         public
72         not_killed()
73         only_admin()
74         only_no_value()
75     {
76         if (!admin.send(this.balance)) throw;
77         winner = admin;
78     }
79     
80     // DEFAULT FUNCTION
81     function()
82         public
83         not_killed()
84         only_min_value()
85     {
86         challenge();
87     }
88 
89 }