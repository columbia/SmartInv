1 pragma solidity 0.4.23;
2 
3 
4 contract Owned {
5     address public contractOwner;
6 
7     constructor() public { 
8         contractOwner = msg.sender; 
9     }
10     
11     function whoIsTheOwner() public view returns(address) {
12         return contractOwner;
13     }
14 
15     function changeOwner(address newOwner) public returns(bool) {
16         require(newOwner != address(0));
17         if (contractOwner == msg.sender) {
18             contractOwner = newOwner;
19             return true;
20         }
21         return false;
22     }
23 }
24 
25 
26 contract Mortal is Owned  {
27     function kill() public {
28         if (msg.sender == contractOwner) selfdestruct(contractOwner);
29     }
30 }
31 
32 contract LivroVisitas is Mortal {
33     mapping (address=>string) livro;
34 
35     function recordVisit(address visitor, string message) public returns(bool) {
36         require(visitor != address(0));
37         livro[visitor] = message;
38         emit NewVisitor(visitor);
39         return true;
40     }
41 
42     function getMessageOfVisit(address visitor) public view returns(string) {
43         if (bytes(livro[visitor]).length > 1) {
44             return livro[visitor];
45         } else {
46             return "";
47         }
48     }
49 
50     event NewVisitor(address visitor);
51 }