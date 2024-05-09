1 contract BlockHashSaver {
2     bytes32 public currentHash;
3     bytes32 public prevHash;
4     
5     function saveHash() public {
6         currentHash = blockhash(block.number);
7         prevHash = blockhash(block.number - 1);
8     }
9 }