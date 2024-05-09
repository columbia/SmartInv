1 
2 // File: test/contracts/TransferValue.sol
3 
4 pragma solidity ^0.5.0;
5 
6 
7 interface ERC20Transfer {
8   function transferFrom(address from, address to, uint256 value) external returns (bool);
9 }
10 
11 
12 contract TransferValue {
13     modifier notZero (uint256 value) {
14         require(value != 0, "no value can be zero");
15         _;
16     }
17 
18     function transferETH (
19         address payable[] calldata accounts
20       ) external payable
21       notZero(accounts.length)
22       returns(bool)
23     {
24         // if (amount == 0)
25         //   return false;
26         uint arrayLength = accounts.length;
27 
28         // if (arrayLength == 0)
29         //   return false;
30 
31         uint amountPerAccount = msg.value / arrayLength;
32 
33         for (uint i = 0; i < arrayLength; ++i ) {
34             accounts[i].transfer(amountPerAccount);
35         }
36 
37         return true;
38     }
39 
40     function transferToken(
41         address token,
42         address[] calldata accounts,
43         uint256 amount
44       ) external
45       notZero(uint256(token))
46       notZero(accounts.length)
47       notZero(amount)
48       returns(bool)
49     {
50         uint arrayLength = accounts.length;
51 
52         uint amountPerAccount = amount / arrayLength;
53 
54         ERC20Transfer tokenContract = ERC20Transfer(token);
55 
56         for (uint i = 0; i < arrayLength; ++i ) {
57             tokenContract.transferFrom(msg.sender, accounts[i], amountPerAccount);
58         }
59 
60         return true;
61     }
62 }
