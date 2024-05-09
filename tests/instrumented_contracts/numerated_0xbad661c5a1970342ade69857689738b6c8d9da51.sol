1 contract AddressReg{
2 
3     address public owner;
4 
5     function setOwner(address _owner){
6         if(msg.sender==owner)
7             owner = _owner;
8     }
9 
10     function AddressReg(){
11         owner = msg.sender;
12     }
13 
14     mapping (address=>bool) isVerifiedMap;
15 
16     function verify(address addr){
17         if(msg.sender==owner)
18             isVerifiedMap[addr] = true;
19     }
20 
21     function deverify(address addr){
22         if(msg.sender==owner)
23             isVerifiedMap[addr] = false;
24     }
25 
26     function hasPhysicalAddress(address addr) constant returns(bool){
27         return isVerifiedMap[addr];
28     }
29 
30 }