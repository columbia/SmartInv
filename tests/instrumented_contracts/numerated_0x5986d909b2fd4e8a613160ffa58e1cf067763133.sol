1 pragma solidity ^0.4.24;
2 
3 /** Proxy contract to buy tokens on Zethr,
4  *  because we forgot to add the onTokenBuy event to Zethr.
5  *  So we're proxying Zethr buys through this contract so that our website
6  *  can properly track and display Zethr token buys.
7 **/
8 contract ZethrProxy {
9     ZethrInterface zethr = ZethrInterface(address(0xD48B633045af65fF636F3c6edd744748351E020D));
10     address owner = msg.sender;
11     
12     event onTokenPurchase(
13         address indexed customerAddress,
14         uint incomingEthereum,
15         uint tokensMinted,
16         address indexed referredBy
17     );
18     
19     function buyTokensWithProperEvent(address _referredBy, uint8 divChoice) public payable {
20         // Query token balance before & after to see how much we bought
21         uint balanceBefore = zethr.balanceOf(msg.sender);
22         
23         // Buy tokens with selected div rate
24         zethr.buyAndTransfer.value(msg.value)(_referredBy, msg.sender, "", divChoice);
25         
26         // Query balance after
27         uint balanceAfter = zethr.balanceOf(msg.sender);
28         
29         emit onTokenPurchase(
30             msg.sender,
31             msg.value,
32             balanceAfter - balanceBefore,
33             _referredBy
34         );
35     }
36     
37     function () public payable {
38         
39     }
40     
41     // Yes there are tiny amounts of divs generated on buy,
42     // but not enough to justify transferring to msg.sender - gas price makes it not worth it.
43     function withdrawMicroDivs() public {
44         require(msg.sender == owner);
45         owner.transfer(address(this).balance);
46     }
47 }
48 
49 contract ZethrInterface {
50     function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice) public payable;
51     function balanceOf(address _owner) view public returns(uint);
52 }