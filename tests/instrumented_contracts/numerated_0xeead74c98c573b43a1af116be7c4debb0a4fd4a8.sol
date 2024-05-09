1 pragma solidity ^0.4.21;
2 
3 contract Line {
4     
5     address private owner;
6 
7     uint constant public jackpotNumerator = 50;
8     uint constant public winNumerator = 5;
9     uint constant public denominator = 100;
10     
11     uint public jackpot = 0;
12 
13     event Jackpot(uint line, address addr, uint date, uint prize, uint left);
14     event Win(uint line, address addr, uint date, uint prize, uint left);
15     event JackpotIncreased(uint date, uint jackpot);
16     
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function Line() public {
23         owner = msg.sender;
24     }
25 
26     function waiver() private {
27         delete owner;
28     }
29 
30     function() payable public {
31 
32         jackpot += msg.value;
33         
34         uint token = random();
35         
36         uint prizeNumerator = 0;
37         
38         if (token == 777) {
39             prizeNumerator = jackpotNumerator;
40         }
41         
42         if (token == 666 || token == 555 || token == 444 
43          || token == 333 || token == 222 || token == 111) {
44             prizeNumerator = winNumerator;
45         }
46         
47         if (prizeNumerator > 0) {
48             msg.sender.transfer(0 wei); // supposed to reject contracts
49             uint prize = this.balance / 100 * prizeNumerator;
50             if (msg.sender.send(prize)) {
51                 if (prizeNumerator == jackpotNumerator) {
52                     emit Jackpot(token, msg.sender, now, prize, this.balance);
53                 } else {
54                     emit Win(token, msg.sender, now, prize, this.balance);
55                 }
56                 owner.transfer(this.balance / 100); // owners fee
57             }
58         } else {
59             emit JackpotIncreased(now, jackpot);
60         }
61     }
62 
63     function reset() onlyOwner public {
64         owner.transfer(this.balance);
65     }
66 
67     uint nonce;
68 
69     function random() internal returns (uint) {
70         uint rand = uint(keccak256(now, msg.sender, nonce)) % 778;
71         nonce++;
72         return rand;
73     }
74 }