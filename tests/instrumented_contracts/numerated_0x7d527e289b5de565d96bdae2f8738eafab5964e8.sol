1 pragma solidity ^0.5.0;
2 
3 contract Payment {
4 
5     event Paid(string indexed invoiceId);
6 
7     function makePayment(
8         uint amount,
9         address payable payee,
10         uint fee,
11         address payable provider,
12         string memory invoiceId
13         )
14         public payable returns(bool) {
15         require(msg.value == amount + fee, "Value of the payment is incorrect");
16         payee.transfer(amount);
17         provider.transfer(fee);
18         emit Paid(invoiceId);
19     }
20 
21     function() external payable {
22         require(false, "No message data -- fallback function failed");
23     }
24 }