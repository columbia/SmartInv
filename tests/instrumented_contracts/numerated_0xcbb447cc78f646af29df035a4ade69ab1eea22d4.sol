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
16     *  The release time is set to 8640000 seconds (= 100 days)
17     *  in the future from the timestamp of the contract creation
18     */
19     address public owner = msg.sender;
20     uint releaseTime = now + 8640000;
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
61     function claim(int256 a, int256 b, int256 c, int256 n) public {
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
75     function solve(int256 a, int256 b, int256 c, int256 n) pure public returns (uint256) {
76         assert(n > 2);
77         uint256 aExp = power(a, n);
78         uint256 bExp = power(b, n);
79         uint256 cExp = power(c, n);
80 
81         uint256 sum = add(aExp, bExp);
82         uint256 difference = sub(sum, cExp);
83         return difference;
84     }
85 
86     /*
87      A safe way to handle exponentiation. Throws error on overflow.
88     */
89     function power(int256 a, int256 pow) internal pure returns (uint256) {
90         assert(a >= 0);
91         assert(pow >= 0);
92         int256 result = 1;
93         for (int256 i = 0; i < pow; i++) {
94             result = result * a;
95             assert(result >= a);
96         }
97         return uint256(result);
98     }
99 
100     /*
101      A safe way to handle addition. Throws error on overflow.
102     */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         assert(c >= a);
106         return c;
107     }
108 
109     /*
110      A safe way to handle subtraction. Throws error on underflow.
111     */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         assert(b <= a);
114         return a - b;
115     }
116 
117 
118 }