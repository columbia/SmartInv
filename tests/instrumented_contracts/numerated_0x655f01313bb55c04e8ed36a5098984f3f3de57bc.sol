1 contract RNG {
2     mapping (address => uint) nonces;
3     uint public last;
4     function RNG() { }
5     function RandomNumber() returns(uint) {
6         return RandomNumberFromSeed(uint(sha3(block.number))^uint(sha3(now))^uint(msg.sender)^uint(tx.origin));
7     }
8     function RandomNumberFromSeed(uint seed) returns(uint) {
9         nonces[msg.sender]++;
10         last = seed^(uint(sha3(block.blockhash(block.number),nonces[msg.sender]))*0x000b0007000500030001);
11         GeneratedNumber(last);
12         return last;
13     }
14     event GeneratedNumber(uint random_number);
15 }