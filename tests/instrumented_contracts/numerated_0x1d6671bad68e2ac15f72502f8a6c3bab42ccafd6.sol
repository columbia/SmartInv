1 contract ProofOfExistence {
2 
3   mapping (string => uint) private proofs;
4 
5   function notarize(string sha256) {
6 
7     bytes memory b_hash = bytes(sha256);
8     
9     if ( b_hash.length == 64 ){
10       if ( proofs[sha256] != 0 ){
11         proofs[sha256] = block.timestamp;
12       }
13     }
14   }
15   
16   function verify(string sha256) constant returns (uint) {
17     return proofs[sha256];
18   }
19   
20 }