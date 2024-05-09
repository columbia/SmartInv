1 pragma solidity ^0.4.24;
2 
3 
4 contract owned {
5     constructor() public { owner = msg.sender; }
6 
7     address owner;
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 }
14 
15 
16 contract ERC20 {
17     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
18     function transfer(address to, uint256 tokens) public returns (bool success);
19 }
20 
21 
22 contract Tank is owned {
23 
24     function () payable public {}
25 
26     function withdrawEther(address toAddress, uint256 amount) public onlyOwner {
27         toAddress.transfer(amount);
28     }
29 
30     function withdrawToken(address token, address toAddress, uint256 amount) public onlyOwner {
31         ERC20(token).transfer(toAddress, amount);
32     }
33 
34     function withdrawInBatch(address[] tokenList, address[] toAddressList, uint256[] amountList) public onlyOwner {
35         require(tokenList.length == toAddressList.length);
36         require(toAddressList.length == amountList.length);
37 
38         for (uint i = 0; i < toAddressList.length; i++) {
39             if (tokenList[i] == 0) {
40                 this.withdrawEther(toAddressList[i], amountList[i]);
41             } else {
42                 this.withdrawToken(tokenList[i], toAddressList[i], amountList[i]);
43             }
44         }
45     }
46 
47     function withdrawEtherInBatch(address[] toAddressList, uint256[] amountList) public onlyOwner {
48         require(toAddressList.length == amountList.length);
49 
50         for (uint i = 0; i < toAddressList.length; i++) {
51             this.withdrawEther(toAddressList[i], amountList[i]);
52         }
53     }
54 }