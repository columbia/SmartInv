1 pragma solidity ^0.4.9;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 }
15 
16 contract BirthdayPuzzle is owned {
17     uint balance;
18     bool solved = false;
19 
20     function() onlyOwner payable {
21         balance += msg.value;
22     }
23     
24     function powerWithModulus(uint256 base, uint256 exponent, uint256 modulus) private
25         returns(uint256)
26     {
27         uint256 result = 1;
28 
29         base %= modulus;
30 
31         while (exponent > 0) {
32             if (exponent % 2 == 1) {
33                 result = (result * base) % modulus;
34             }
35 
36             base = (base * base) % modulus;
37             exponent /= 2;
38         }
39 
40         return result;
41     }
42 
43     event Solved(
44         address solver
45     );
46 
47     event UnsuccessfulAttempt(
48         address attempter
49     );
50 
51     function solvePuzzle(uint256 solution) public
52     {
53         if (solved) throw;
54 
55         uint256 a = 50540984125924;
56         uint256 b = 50540984125915;
57         uint256 c = 1981;
58         uint256 d = 2017;
59         uint256 e;
60 
61         e = powerWithModulus(1234567890, solution, 4 * a + c);
62         if (powerWithModulus(e, d, 4 * b + d) == 1234567890) {
63             Solved(msg.sender);
64             solved = true;
65             msg.sender.send(balance);
66         } else {
67             UnsuccessfulAttempt(msg.sender);
68         }
69     }
70 }