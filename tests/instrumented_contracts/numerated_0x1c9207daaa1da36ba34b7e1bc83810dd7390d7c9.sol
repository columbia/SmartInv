1 contract ProofOfExistence {
2   mapping (string => uint) private proofs;
3 
4   function storeProof(string sha256) {
5     proofs[sha256] = block.timestamp;
6   }
7 
8   function notarize(string sha256) {
9     storeProof(sha256);
10   }
11   
12 
13   function checkDocument(string sha256) constant returns (uint) {
14     return proofs[sha256];
15   }
16   
17 }