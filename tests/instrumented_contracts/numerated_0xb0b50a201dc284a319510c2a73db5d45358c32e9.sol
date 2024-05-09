1 pragma solidity ^0.5.0;
2 
3 contract freedomStatement {
4     
5     string public statement = "https://ipfs.globalupload.io/QmfEnSNTHTe9ut6frhNsY16rXhiTjoGWtXozrA66y56Pbn";
6     mapping (address => bool) internal consent;
7     event wearehere(string statement);
8     
9     constructor () public {
10         emit wearehere(statement);
11     }
12         
13     function isHuman(address addr) internal view returns (bool) {
14         uint size;
15         assembly { size := extcodesize(addr) }
16         return size == 0;
17     }
18 
19     function () external {
20         require(isHuman(msg.sender),"no robot");//Don't want to use tx.origin because that will cause an interoperability problem
21         consent[msg.sender] = true;
22     }
23     
24     function check(address addr) public view returns (bool){
25         return(consent[addr]);
26     }
27 }