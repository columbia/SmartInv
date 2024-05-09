1 pragma solidity ^0.4.18;
2 
3 /*
4     DonationForwarder v1.0
5     
6     When you're feeling generous, you can send ether to this contract to have
7      it forwarded to someone else.
8      
9     You can buy or override a previous redirect by paying a higher price (note:
10      there are NO refunds if your redirect is overriden!).
11      
12     You can purchase a redirect to your address by using the buyRedirect
13      function (see the code).
14      
15     If you want the contract to forward ether to another address, use
16      buyRedirectFor instead.
17      
18     Warning: the recommended gas limit for sending ether to this contract is
19      at least 40000.
20     
21     The starting price is defined below.
22     
23     Public Domain, made by SopaXorzTaker.
24 */
25 
26 contract DonationForwarder {
27     address owner;
28     address redirect;
29     uint lastPrice;
30     
31     uint startingPrice = 0.01 ether;
32 
33 
34     modifier onlyOwner {
35         require (msg.sender == owner);
36         _;
37     }
38     
39     event RedirectChanged (
40         address _newRedirect,
41         uint _lastPrice
42     );
43     
44     function DonationForwarder() public {
45         // The default redirect address will be the contract creator's.
46         owner = msg.sender;
47         redirect = owner;
48         
49         // The starting price.
50         lastPrice = startingPrice;
51     }
52     
53     function () payable public {
54         // Redirect the funds to the current redirect address.
55         redirect.transfer(msg.value);
56     }
57     
58     function buyRedirect() payable public {
59         // Buy a redirect for the current sender.
60         buyRedirectFor(msg.sender);
61     }
62     
63     function buyRedirectFor(address newRedirect) payable public {
64         // Any new redirect is going to cost more than the previous.
65         // One can pay a higher price to ensure it would be harder to change.
66         require(msg.value > lastPrice);
67         
68         // The new redirect address must be different from the previous one.
69         require(newRedirect != redirect);
70         
71         // Send the funds collected to the contract owner.
72         owner.transfer(msg.value);
73             
74         // Set the new redirect address to the one specified.
75         redirect = newRedirect;
76         
77         // Update the last price.
78         lastPrice = msg.value;
79         
80         // Create an event to indicate that.
81         RedirectChanged(newRedirect, lastPrice);
82     }
83     
84     function kill() public onlyOwner {
85         // An ability for the owner to kill the contract if necessary.
86         selfdestruct(owner);
87     }
88 }