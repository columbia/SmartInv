1 contract SimplePrize {
2     bytes32 public constant salt = bytes32(987463829);
3     bytes32 public commitment;
4 
5     function SimplePrize(bytes32 _commitment) public payable {
6         commitment = _commitment;   
7     }
8 
9     function createCommitment(uint answer) 
10       public pure returns (bytes32) {
11         return keccak256(salt, answer);
12     }
13 
14     function guess (uint answer) public {
15         require(createCommitment(answer) == commitment);
16         msg.sender.transfer(this.balance);
17     }
18 
19     function () public payable {}
20 }