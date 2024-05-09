1 contract TerraNullius {
2   struct Claim { address claimant; string message; uint block_number; }
3   Claim[] public claims;
4 
5   function claim(string message) {
6     uint index = claims.length;
7     claims.length++;
8     claims[index] = Claim(msg.sender, message, block.number);
9   }
10 
11   function number_of_claims() returns(uint result) {
12     return claims.length;
13   }
14 }