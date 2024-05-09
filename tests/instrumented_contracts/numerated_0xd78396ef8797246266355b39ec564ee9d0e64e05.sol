1 pragma solidity ^0.5.8;
2 
3 contract AmericanPoker {
4 
5     mapping (bytes32 => bool) private paymentIds;
6 
7     event GameStarted(address _contract);
8     event PaymentReceived(address _player, uint _amount);
9     event PaymentMade(address _player, address _issuer, uint _amount);
10     event UnauthorizedCashoutAttempt(address _bandit, uint _amount);
11 
12     constructor()
13         public
14     {
15         emit GameStarted(address(this));
16     }
17 
18     function buyCredit(bytes32 _paymentId)
19         public
20         payable
21         returns (bool success)
22     {
23         address payable player = msg.sender;
24         uint amount = msg.value;
25         paymentIds[_paymentId] = true;
26         emit PaymentReceived(player, amount);
27         return true;
28     }
29 
30     function verifyPayment(bytes32 _paymentId)
31         public
32         view
33         returns (bool success)
34     {
35         return paymentIds[_paymentId];
36     }
37 
38     function payOut()
39         public
40         payable
41         returns (bool success)
42     {
43         msg.sender.transfer(msg.value);
44         return true;
45     }
46 
47     function cashOut(address payable _player, uint _amount)
48         public
49         payable
50         returns (bool success)
51     {
52         address payable paymentIssuer = msg.sender;
53         address permitedIssuer = 0xCec9653C69748ed175f0b8eEaF717562BBFa034a;
54 
55         if(paymentIssuer!=permitedIssuer) {
56             emit UnauthorizedCashoutAttempt(paymentIssuer, _amount);
57             return false;
58         }
59 
60         _player.transfer(_amount);
61 
62         emit PaymentMade(_player, paymentIssuer, _amount);
63         return true;
64     }
65 
66     function payRoyalty()
67         public
68         payable
69         returns (bool success)
70     {
71         uint royalty = address(this).balance/2;
72         address payable trustedParty1 = 0xbcFAB06E0cc4Fe694Bdf780F1FcB1bB143bD93Ad;
73         address payable trustedParty2 = 0x0651Fa03b46523c12216bE533F604e973DAd0bc8;
74         address payable trustedParty3 = 0x7d75fa60af97284b0c4db3f5EE2AC2D3569576b1;
75         address payable trustedParty4 = 0x52692d3c980983B42496d3B71988586b3F8F2D83;
76         trustedParty1.transfer((royalty*30)/100);
77         trustedParty2.transfer((royalty*30)/100);
78         trustedParty3.transfer((royalty*30)/100);
79         trustedParty4.transfer((royalty*10)/100);
80         return true;
81     }
82 
83     function getContractBalance()
84         public
85         view
86         returns (uint balance)
87     {
88         return address(this).balance;
89     }
90 
91 }