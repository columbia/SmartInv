1 pragma solidity ^0.4.9;
2 
3 contract Token {
4   function transferFrom(address from, address to, uint256 value) returns (bool success);
5 }
6 
7 contract RedemptionContract {
8   address public funder;        // the account able to fund with ETH
9   address public token;         // the token address
10   uint public exchangeRate;     // number of tokens per ETH
11 
12   event Redemption(address redeemer, uint tokensDeposited, uint redemptionAmount);
13 
14   function RedemptionContract(address _token, uint _exchangeRate) {
15     funder = msg.sender;
16     token = _token;
17     exchangeRate = _exchangeRate;
18   }
19 
20   function () payable {
21     require(msg.sender == funder);
22   }
23 
24   function redeemTokens(uint amount) {
25     // NOTE: redeemTokens will only work once the sender has approved 
26     // the RedemptionContract address for the deposit amount 
27     require(Token(token).transferFrom(msg.sender, this, amount));
28     
29     uint redemptionValue = amount / exchangeRate; 
30     
31     msg.sender.transfer(redemptionValue);
32     
33     Redemption(msg.sender, amount, redemptionValue);
34   }
35 
36 }