1 pragma solidity ^0.4.8;
2 contract CryptoPunks {
3 
4     // You can use this hash to verify the image file containing all the punks
5     string public imageHash = "ac39af4793119ee46bbff351d8cb6b5f23da60222126add4268e261199a2921b";
6 
7     address owner;
8 
9     string public standard = 'CryptoPunks';
10     string public name;
11     string public symbol;
12     uint8 public decimals;
13     uint256 public totalSupply;
14 
15     uint public nextPunkIndexToAssign = 0;
16 
17     //bool public allPunksAssigned = false;
18     uint public punksRemainingToAssign = 0;
19     uint public numberOfPunksToReserve;
20     uint public numberOfPunksReserved = 0;
21 
22     //mapping (address => uint) public addressToPunkIndex;
23     mapping (uint => address) public punkIndexToAddress;
24 
25     /* This creates an array with all balances */
26     mapping (address => uint256) public balanceOf;
27 
28     struct Offer {
29         bool isForSale;
30         uint punkIndex;
31         address seller;
32         uint minValue;          // in ether
33         address onlySellTo;     // specify to sell only to a specific person
34     }
35 
36     // A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
37     mapping (uint => Offer) public punksOfferedForSale;
38 
39     mapping (address => uint) public pendingWithdrawals;
40 
41     event Assign(address indexed to, uint256 punkIndex);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event PunkTransfer(address indexed from, address indexed to, uint256 punkIndex);
44     event PunkOffered(uint indexed punkIndex, uint minValue, address indexed toAddress);
45     event PunkBought(uint indexed punkIndex, uint value, address indexed fromAddress, address indexed toAddress);
46     event PunkNoLongerForSale(uint indexed punkIndex);
47 
48     /* Initializes contract with initial supply tokens to the creator of the contract */
49     function CryptoPunks() payable {
50         //        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
51         owner = msg.sender;
52         totalSupply = 10000;                        // Update total supply
53         punksRemainingToAssign = totalSupply;
54         numberOfPunksToReserve = 1000;
55         name = "CRYPTOPUNKS";                                   // Set the name for display purposes
56         symbol = "Ͼ";                               // Set the symbol for display purposes
57         decimals = 0;                                       // Amount of decimals for display purposes
58     }
59 
60     function reservePunksForOwner(uint maxForThisRun) {
61         if (msg.sender != owner) throw;
62         if (numberOfPunksReserved >= numberOfPunksToReserve) throw;
63         uint numberPunksReservedThisRun = 0;
64         while (numberOfPunksReserved < numberOfPunksToReserve && numberPunksReservedThisRun < maxForThisRun) {
65             punkIndexToAddress[nextPunkIndexToAssign] = msg.sender;
66             Assign(msg.sender, nextPunkIndexToAssign);
67             numberPunksReservedThisRun++;
68             nextPunkIndexToAssign++;
69         }
70         punksRemainingToAssign -= numberPunksReservedThisRun;
71         numberOfPunksReserved += numberPunksReservedThisRun;
72         balanceOf[msg.sender] += numberPunksReservedThisRun;
73     }
74 
75     function getPunk(uint punkIndex) {
76         if (punksRemainingToAssign == 0) throw;
77         if (punkIndexToAddress[punkIndex] != 0x0) throw;
78         punkIndexToAddress[punkIndex] = msg.sender;
79         balanceOf[msg.sender]++;
80         punksRemainingToAssign--;
81         Assign(msg.sender, punkIndex);
82     }
83 
84     // Transfer ownership of a punk to another user without requiring payment
85     function transferPunk(address to, uint punkIndex) {
86         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
87         punkIndexToAddress[punkIndex] = to;
88         balanceOf[msg.sender]--;
89         balanceOf[to]++;
90         Transfer(msg.sender, to, 1);
91         PunkTransfer(msg.sender, to, punkIndex);
92     }
93 
94     function punkNoLongerForSale(uint punkIndex) {
95         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
96         punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, 0x0);
97         PunkNoLongerForSale(punkIndex);
98     }
99 
100     function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) {
101         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
102         punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, 0x0);
103         PunkOffered(punkIndex, minSalePriceInWei, 0x0);
104     }
105 
106     function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) {
107         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
108         punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, toAddress);
109         PunkOffered(punkIndex, minSalePriceInWei, toAddress);
110     }
111 
112     function buyPunk(uint punkIndex) payable {
113         Offer offer = punksOfferedForSale[punkIndex];
114         if (!offer.isForSale) throw;                // punk not actually for sale
115         if (offer.onlySellTo != 0x0 && offer.onlySellTo != msg.sender) throw;  // punk not supposed to be sold to this user
116         if (msg.value < offer.minValue) throw;      // Didn't send enough ETH
117         if (offer.seller != punkIndexToAddress[punkIndex]) throw; // Seller no longer owner of punk
118 
119         punkIndexToAddress[punkIndex] = msg.sender;
120         balanceOf[offer.seller]--;
121         balanceOf[msg.sender]++;
122         Transfer(offer.seller, msg.sender, 1);
123 
124         punkNoLongerForSale(punkIndex);
125         pendingWithdrawals[offer.seller] += msg.value;
126         PunkBought(punkIndex, msg.value, offer.seller, msg.sender);
127     }
128 
129     function withdraw() {
130         uint amount = pendingWithdrawals[msg.sender];
131         // Remember to zero the pending refund before
132         // sending to prevent re-entrancy attacks
133         pendingWithdrawals[msg.sender] = 0;
134         msg.sender.transfer(amount);
135     }
136 }