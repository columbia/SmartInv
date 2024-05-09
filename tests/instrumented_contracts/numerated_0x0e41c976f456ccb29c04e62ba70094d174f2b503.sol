1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       revert();
13     }
14     _;
15   }
16 }
17 
18 interface NoahToken {
19     function transfer(address to, uint tokens) public returns (bool success);
20     function balanceOf(address tokenOwner) public returns (uint256 balance);
21 }
22 
23 contract NoahDividend is Ownable {
24     NoahToken public noahToken;
25     /**
26      * Constrctor function
27      *
28      */
29     function NoahDividend(address noahTokenAddress) public {
30         noahToken = NoahToken(noahTokenAddress);
31     }
32 
33     // function checkTotalBalance(uint256[] tokenAmounts) public view returns (bool) {
34     //     uint256 total = 0;
35     //     for (uint i = 0; i < tokenAmounts.length; i++) {
36     //         total += tokenAmounts[i];
37     //     }
38     //     return total > 0 && noahToken.balanceOf(this) >= total;
39     //  }
40 
41     function balanceOfInvestor(address investor) public view returns (uint256 balance) {
42         return noahToken.balanceOf(investor);
43     }
44 
45     function multiTransfer(address[] investors, uint256[] tokenAmounts) onlyOwner public returns (address[] results) {
46         results = new address[](investors.length);
47         if (investors.length != tokenAmounts.length || investors.length == 0 || tokenAmounts.length == 0) {
48             revert();
49         }
50         
51         // if (!this.checkTotalBalance(tokenAmounts)) {
52         //     revert();
53         // }
54         
55         for (uint i = 0; i < investors.length; i++) {
56             bool result = noahToken.transfer(investors[i], tokenAmounts[i]);
57             if (result == true){
58                 results[i] = investors[i];
59             }
60         }
61         return results;
62     }
63 }