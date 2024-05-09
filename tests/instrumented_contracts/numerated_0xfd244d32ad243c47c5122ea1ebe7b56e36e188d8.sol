1 pragma solidity 0.4.23;
2 
3 contract Owned {
4     address contractOwner;
5 
6     constructor() public { 
7         contractOwner = msg.sender; 
8     }
9     
10     function whoIsTheOwner() public view returns(address) {
11         return contractOwner;
12     }
13 
14     function changeOwner(address newOwner) public returns(bool) {
15         require(newOwner != address(0));
16         if (contractOwner == msg.sender) {
17             contractOwner = newOwner;
18             return true;
19         }
20         return false;
21     }
22 }
23 
24 
25 contract Mortal is Owned  {
26     function kill() public {
27         if (msg.sender == contractOwner) selfdestruct(contractOwner);
28     }
29 }
30 
31 contract LivroVisitas is Mortal {
32     mapping (address=>string) livro;
33 
34     function recordVisit(address visitor, string message) public returns(bool) {
35         require(visitor != address(0));
36         livro[visitor] = message;
37         return true;
38     }
39 
40     function getMessageOfVisit(address visitor) public view returns(string) {
41         if (bytes(livro[visitor]).length > 1) {
42             return livro[visitor];
43         } else {
44             return "";
45         }
46     }
47 }