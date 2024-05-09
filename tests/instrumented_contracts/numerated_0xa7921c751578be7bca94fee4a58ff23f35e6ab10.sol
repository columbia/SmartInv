1 pragma solidity ^0.4.17;
2 
3 contract Marriage {
4     struct Signage {
5         string name1;
6         string vow1;
7         string name2;
8         string vow2;
9     }
10 
11     address public sealer;
12     string public sealedBy;
13     uint256 public numMarriages;
14 
15     Signage[] signages;
16 
17     function Marriage(string sealerName, address sealerAddress) public {
18         sealedBy = sealerName;
19         sealer = sealerAddress;
20     }
21 
22     function sign(string vow1, string name1, string vow2, string name2) public {
23         require(msg.sender == sealer);
24 
25         Signage memory signage = Signage(
26             vow1,
27             name1,
28             vow2,
29             name2
30         );
31         signages.push(signage);
32         numMarriages +=1 ;
33     }
34 
35     function getMarriage(uint256 index)
36         public
37         constant returns (string, string, string, string)
38     {
39         return (signages[index].vow1, signages[index].name1, signages[index].vow2, signages[index].name2);
40     }
41 }