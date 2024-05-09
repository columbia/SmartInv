1 //A BurnableOpenPaymet is instantiated with a specified payer and a commitThreshold.
2 //The recipient not set when the contract is instantiated.
3 
4 //All behavior of the contract is directed by the payer, but
5 //the payer can never directly recover the payment unless he becomes the recipient.
6 
7 //Anyone can become the recipient by contributing the commitThreshold.
8 //The recipient cannot change once it's been set.
9 
10 //The payer can at any time choose to burn or release to the recipient any amount of funds.
11 
12 pragma solidity ^0.4.1;
13 
14 contract BurnableOpenPayment {
15     address public payer;
16     address public recipient;
17     address public burnAddress = 0xdead;
18     uint public commitThreshold;
19     
20     modifier onlyPayer() {
21         if (msg.sender != payer) throw;
22         _;
23     }
24     
25     modifier onlyWithRecipient() {
26         if (recipient == address(0x0)) throw;
27         _;
28     }
29     
30     //Only allowing the payer to fund the contract ensures that the contract's
31     //balance is at most as difficult to predict or interpret as the payer.
32     //If the payer is another smart contract or script-based, balance changes
33     //could reliably indicate certain intentions, judgements or states of the payer.
34     function () payable onlyPayer { }
35     
36     function BurnableOpenPayment(address _payer, uint _commitThreshold) payable {
37         payer = _payer;
38         commitThreshold = _commitThreshold;
39     }
40     
41     function getPayer() returns (address) {
42         return payer;
43     }
44     
45     function getRecipient() returns (address) {
46         return recipient;
47     }
48     
49     function getCommitThreshold() returns (uint) {
50         return commitThreshold;
51     }
52     
53     function commit()
54     payable
55     {
56         if (recipient != address(0x0)) throw;
57         if (msg.value < commitThreshold) throw;
58         recipient = msg.sender;
59     }
60     
61     function burn(uint amount)
62     onlyPayer()
63     onlyWithRecipient()
64     returns (bool)
65     {
66         return burnAddress.send(amount);
67     }
68     
69     function release(uint amount)
70     onlyPayer()
71     onlyWithRecipient()
72     returns (bool)
73     {
74         return recipient.send(amount);
75     }
76 }
77 
78 contract BurnableOpenPaymentFactory {
79     function newBurnableOpenPayment(address payer, uint commitThreshold) payable returns (address) {
80         //pass along any ether to the constructor
81         return (new BurnableOpenPayment).value(msg.value)(payer, commitThreshold);
82     }
83 }