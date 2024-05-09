1 pragma solidity ^0.4.18;
2 
3 /**
4 * A contract that pays off, if a user is able to produce a valid solution
5 * for the Fermat's last theorem
6 */
7 
8 contract Fermat {
9 
10     /**
11     *  The owner is the creator of the contract.
12 
13     *  The owner will be able to withdraw the
14     *  bounty after the releaseTime has passed.
15 
16     *  The release time is set to 17280000 seconds (= 200 days)
17     *  in the future from the timestamp of the contract creation
18     */
19     address public owner = msg.sender;
20     uint releaseTime = now + 17280000;
21 
22     /**
23     * This function is used to increase the bounty
24     */
25     function addBalance() public payable {
26 
27     }
28 
29     function getOwner() view public returns (address)  {
30         return owner;
31     }
32 
33     /*
34     * Returns the time when it is possible for the owner
35     * to withdraw the deposited funds from the contract.
36     */
37     function getReleaseTime() view public returns (uint)  {
38         return releaseTime;
39     }
40 
41     /**
42      * Allow the owner of the contract to
43      * withdraw the bounty after the release time has passed
44      */
45     function withdraw() public {
46         require(msg.sender == owner);
47         require(now >= releaseTime);
48 
49         msg.sender.transfer(this.balance);
50     }
51 
52     function getBalance() view public returns (uint256) {
53         return this.balance;
54     }
55 
56     /**
57      * The function that is used to claim the bounty.
58      * If the caller is able to provide satisfying values for a,b,c and n
59      * the balance of the contract (the bounty) is transferred to the caller
60     */
61     function claim(uint256 a, uint256 b, uint256 c, uint256 n) public {
62         uint256 value = solve(a, b, c, n);
63         if (value == 0) {
64             msg.sender.transfer(this.balance);
65         }
66     }
67 
68 
69 
70     /*
71      * The "core" logic of the smart contract.
72      * Calculates the equation with provided values for Fermat's last theorem.
73      * Returns the value of a^n + b^n - c^n, n > 2
74      */
75     function solve(uint256 a, uint256 b, uint256 c, uint256 n) pure public returns (uint256) {
76         assert(n > 2);
77         assert(a > 0);
78         assert(b > 0);
79         assert(c > 0);
80         uint256 aExp = power(a, n);
81         uint256 bExp = power(b, n);
82         uint256 cExp = power(c, n);
83 
84         uint256 sum = add(aExp, bExp);
85         uint256 difference = sub(sum, cExp);
86         return difference;
87     }
88 
89     /*
90      A safe way to handle exponentiation. Throws error on overflow.
91     */
92     function power(uint256 a, uint256 pow) pure public returns (uint256) {
93         assert(a > 0);
94         assert(pow > 0);
95         uint256 result = 1;
96         if (a == 0) {
97             return 1;
98         }
99         uint256 temp;
100         for (uint256 i = 0; i < pow; i++) {
101             temp = result * a;
102             assert((temp / a) == result);
103             result = temp;
104         }
105         return uint256(result);
106     }
107 
108     /*
109      A safe way to handle addition. Throws error on overflow.
110     */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         assert(c >= a);
114         return c;
115     }
116 
117     /*
118      A safe way to handle subtraction. Throws error on underflow.
119     */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         assert(b <= a);
122         return a - b;
123     }
124 
125 
126 }