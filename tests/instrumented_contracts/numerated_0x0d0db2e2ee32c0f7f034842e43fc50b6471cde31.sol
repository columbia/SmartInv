1 pragma solidity ^0.5.0;
2 
3 contract freedomStatement {
4     
5     string public statement = "https://ipfs.globalupload.io/QmeeFwpnMk9CaXHZYv4Hn1FFD2MT7kxZ7TNnT9JfZqTzUM";
6     mapping (address => bool) public checkconsent;
7     event wearehere(string statement);
8     uint public signAmounts;
9     
10     constructor () public {
11         emit wearehere(statement);
12     }
13         
14     function isHuman(address addr) internal view returns (bool) {
15         uint size;
16         assembly { size := extcodesize(addr) }
17         return size == 0;
18     }
19 
20     function () external payable {
21         require(isHuman(msg.sender),"no robot");//Don't want to use tx.origin because that will cause an interoperability problem
22         require(msg.value< 0.0000001 ether);//don't give me money, for metamask no error
23         require(checkconsent[msg.sender] == false,"You have already signed up");
24         checkconsent[msg.sender] = true;
25         signAmounts++;
26     }
27 
28 }