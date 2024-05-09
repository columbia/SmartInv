1 contract Hashlock {
2     bytes32 internal hash;
3     constructor(bytes32 h) public payable {
4         hash = h;
5     }
6     
7     function reveal(bytes32 p) external {
8         require(keccak256(abi.encode(p)) == hash);
9         selfdestruct(msg.sender);
10     }
11 }