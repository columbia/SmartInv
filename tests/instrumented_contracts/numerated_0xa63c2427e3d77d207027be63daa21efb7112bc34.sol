1 pragma solidity ^0.4.24;
2 
3 /** Proxy contract to buy tokens on Zethr,
4  *  because we forgot to add the onTokenBuy event to Zethr.
5  *  So we're proxying Zethr buys through this contract so that our website
6  *  can properly track and display Zethr token buys.
7 **/
8 contract ZethrProxy {
9     ZethrInterface zethr = ZethrInterface(address(0x145bf25DC666239030934b28D34fD0dB7Cf1b583));
10     address owner = msg.sender;
11     
12     event onTokenPurchase(
13         address indexed customerAddress,
14         uint incomingEthereum,
15         uint tokensMinted,
16         address indexed referredBy
17     );
18 
19     
20     function buyTokensWithProperEvent(address _referredBy, uint8 divChoice) public payable {
21         // Query token balance before & after to see how much we bought
22         uint balanceBefore = zethr.balanceOf(msg.sender);
23         
24         // Buy tokens with selected div rate
25         zethr.buyAndTransfer.value(msg.value)(_referredBy, msg.sender, "", divChoice);
26         
27         // Query balance after
28         uint balanceAfter = zethr.balanceOf(msg.sender);
29         
30         emit onTokenPurchase(
31             msg.sender,
32             msg.value,
33             balanceAfter - balanceBefore,
34             _referredBy
35         );
36     }
37     
38     function () public payable {
39         
40     }
41     
42     // Yes there are tiny amounts of divs generated on buy,
43     // but not enough to justify transferring to msg.sender - gas price makes it not worth it.
44     function withdrawMicroDivs() public {
45         require(msg.sender == owner);
46         owner.transfer(address(this).balance);
47     }
48 }
49 
50 contract ZethrInterface {
51     function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice) public payable;
52     function balanceOf(address _owner) view public returns(uint);
53 }