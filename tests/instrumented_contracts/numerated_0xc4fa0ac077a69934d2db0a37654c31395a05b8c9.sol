1 pragma solidity ^0.4.21;
2 
3 /*
4 *   Basic PHX-Ethereum Exchange
5 *
6 *   This contract keeps a list of buy/sell orders for PHX coins
7 *   and acts as a market-maker matching sellers to buyers.
8 *   
9 * //*** Developed By:
10 *   _____       _         _         _ ___ _         
11 *  |_   _|__ __| |_  _ _ (_)__ __ _| | _ (_)___ ___ 
12 *    | |/ -_) _| ' \| ' \| / _/ _` | |   / (_-</ -_)
13 *    |_|\___\__|_||_|_||_|_\__\__,_|_|_|_\_/__/\___|
14 *   
15 *   © 2018 TechnicalRise.  Written in March 2018.  
16 *   All rights reserved.  Do not copy, adapt, or otherwise use without permission.
17 *   https://www.reddit.com/user/TechnicalRise/
18 *  
19 *   Thanks to Ogu, TocSick, and Norsefire.
20 */
21 
22 contract ERC20Token {
23     function transfer(address to, uint tokens) public returns (bool success);
24     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
25 }
26 
27 contract SimplePHXExchange {
28     
29     // ScaleFactor
30     // It needs to be possible to make PHX cost less than 1 Wei / Rise
31     // And vice-versa, make ETH cost less than 1 Rise / Wei
32     uint public ScaleFactor = 10 ** 18;  
33     
34     // ****  Maps for the Token-Seller Side of the Contract
35     // Array of offerors
36     address[] public tknOfferors;
37 	mapping(address => uint256) public tknAddrNdx;
38 
39 	// Array between each address and their tokens offered and buy prices.
40 	mapping(address => uint256) public tknTokensOffered;
41 	mapping(address => uint256) public tknPricePerToken; // In qWeiPerRise (need to multiply by 10 ** 36 to get it to ETH / PHX)
42 
43     // ****  Maps for the Token-Buyer Side of the Contract
44     // Array of offerors
45     address[] public ethOfferors;
46 	mapping(address => uint256) public ethAddrNdx;
47 
48 	// Array between each address and their tokens offered and buy prices.
49 	mapping(address => uint256) public ethEtherOffered;
50 	mapping(address => uint256) public ethPricePerToken; // In qRisePerWei (need to multiply by 10 ** 36 to get it to PHX / ETH)
51     // ****
52 
53     ERC20Token public phxCoin;
54 
55     function SimplePHXExchange() public {
56         phxCoin = ERC20Token(0x14b759A158879B133710f4059d32565b4a66140C); // Initiates a PHX Coin !important -- Make sure this is the PHX contract!
57         tknOfferors.push(0x0); // This is because all IDs in tknAddrNdx will initialize to zero
58         ethOfferors.push(0x0); // This is because all IDs in ethAddrNdx will initialize to zero
59     }
60 
61     function offerTkn(uint _tokensOffered, uint _tokenPrice) public {
62         require(_humanSender(msg.sender));
63         require(tknAddrNdx[msg.sender] == 0); // Make sure that this offeror has cancelled all previous offers
64         require(0 < _tokensOffered); // Make sure some number of tokens are offered
65         require(phxCoin.transferFrom(msg.sender, this, _tokensOffered)); // Require that transfer can be and is made
66         tknTokensOffered[msg.sender] = _tokensOffered;
67         tknPricePerToken[msg.sender] = _tokenPrice; // in qWeiPerRise
68         tknOfferors.push(msg.sender);
69         tknAddrNdx[msg.sender] = tknOfferors.length - 1;
70     }
71     
72     function offerEth(uint _tokenPrice) public payable {
73         require(_humanSender(msg.sender));
74         require(ethAddrNdx[msg.sender] == 0); // Make sure that this offeror has cancelled all previous offers
75         require(0 < msg.value); // Make sure some amount of eth is offered
76         ethEtherOffered[msg.sender]  = msg.value;
77         ethPricePerToken[msg.sender] = _tokenPrice; // in qRisesPerWei
78         ethOfferors.push(msg.sender);
79         ethAddrNdx[msg.sender] = ethOfferors.length - 1;
80     }
81 
82     function cancelTknOffer() public {
83         if(tknAddrNdx[msg.sender] == 0) return; // No need to cancel non-existent offer
84         phxCoin.transfer(msg.sender, tknTokensOffered[msg.sender]); // Return the Tokens
85         _cancelTknOffer(msg.sender);
86     }
87 
88     function _cancelTknOffer(address _offeror) internal {
89         delete tknTokensOffered[_offeror];
90         delete tknPricePerToken[_offeror];
91 
92         uint ndx = tknAddrNdx[_offeror];
93 
94         // If this isn't the only offer, reshuffle the array
95         // Moving the last entry to the middle of the list
96         tknOfferors[ndx] = tknOfferors[tknOfferors.length - 1];
97         tknAddrNdx[tknOfferors[tknOfferors.length - 1]] = ndx;
98         tknOfferors.length = tknOfferors.length - 1;
99         delete tknAddrNdx[_offeror]; // !important
100     }
101 
102     function cancelEthOffer() public {
103         if(ethAddrNdx[msg.sender] == 0) return; // No need to cancel non-existent offer
104         msg.sender.transfer(ethEtherOffered[msg.sender]); // Return the Tokens
105         _cancelEthOffer(msg.sender);
106     }
107 
108     function _cancelEthOffer(address _offeror) internal {
109         delete ethEtherOffered[_offeror];
110         delete ethPricePerToken[_offeror];
111         
112         uint ndx = ethAddrNdx[_offeror];
113 
114         // If this isn't the only offer, reshuffle the array
115         // Moving the last entry to the middle of the list
116         ethOfferors[ndx] = ethOfferors[ethOfferors.length - 1];
117         ethAddrNdx[ethOfferors[ethOfferors.length - 1]] = ndx;
118         ethOfferors.length = ethOfferors.length - 1;
119         delete ethAddrNdx[_offeror]; // !important
120     }
121     
122     function buyTkn(uint _ndx) payable public {
123         require(_humanSender(msg.sender));
124         address _offeror = tknOfferors[_ndx];
125         uint _purchasePrice = tknTokensOffered[_offeror] * tknPricePerToken[_offeror] / ScaleFactor; // i.e. # of Wei Required = Rises * (qWei/Rise) / 10**18
126         require(msg.value >= _purchasePrice);
127         require(phxCoin.transfer(msg.sender, tknTokensOffered[_offeror])); // Successful transfer of tokens to purchaser
128         _offeror.transfer(_purchasePrice);
129         _cancelTknOffer(_offeror);
130     }
131     
132     function buyEth(uint _ndx) public {
133         require(_humanSender(msg.sender));
134         address _offeror = ethOfferors[_ndx];
135         uint _purchasePrice = ethEtherOffered[_offeror] * ethPricePerToken[_offeror] / ScaleFactor;  // i.e. # of Rises Required = Wei * (qTRs/Wei) / 10**18
136         require(phxCoin.transferFrom(msg.sender, _offeror, _purchasePrice)); // Successful transfer of tokens to offeror
137         msg.sender.transfer(ethEtherOffered[_offeror]);
138         _cancelEthOffer(_offeror);
139     }
140     
141     function updateTknPrice(uint _newPrice) public {
142         // Make sure that this offeror has an offer out there
143         require(tknTokensOffered[msg.sender] != 0); 
144         tknPricePerToken[msg.sender] = _newPrice;
145     }
146     
147     function updateEthPrice(uint _newPrice) public {
148         // Make sure that this offeror has an offer out there
149         require(ethEtherOffered[msg.sender] != 0); 
150         ethPricePerToken[msg.sender] = _newPrice;
151     }
152     
153     // Getter Functions
154     
155     function getNumTknOfferors() public constant returns (uint _numOfferors) {
156         return tknOfferors.length; // !important:  This is always 1 more than the number of actual offers
157     }
158     
159     function getTknOfferor(uint _ndx) public constant returns (address _offeror) {
160         return tknOfferors[_ndx];
161     }
162     
163     function getTknOfferPrice(uint _ndx) public constant returns (uint _tokenPrice) {
164         return tknPricePerToken[tknOfferors[_ndx]];
165     }
166     
167     function getTknOfferAmount(uint _ndx) public constant returns (uint _tokensOffered) {
168         return tknTokensOffered[tknOfferors[_ndx]];
169     }
170     
171     function getNumEthOfferors() public constant returns (uint _numOfferors) {
172         return ethOfferors.length; // !important:  This is always 1 more than the number of actual offers
173     }
174     
175     function getEthOfferor(uint _ndx) public constant returns (address _offeror) {
176         return ethOfferors[_ndx];
177     }
178     
179     function getEthOfferPrice(uint _ndx) public constant returns (uint _etherPrice) {
180         return ethPricePerToken[ethOfferors[_ndx]];
181     }
182     
183     function getEthOfferAmount(uint _ndx) public constant returns (uint _etherOffered) {
184         return ethEtherOffered[ethOfferors[_ndx]];
185     }
186     
187     // **
188     
189     // A Security Precaution -- Don't interact with contracts unless you
190     // Have a need to / desire to.
191     // Determine if the "_from" address is a contract
192     function _humanSender(address _from) private view returns (bool) {
193       uint codeLength;
194       assembly {
195           codeLength := extcodesize(_from)
196       }
197       return (codeLength == 0); // If this is "true" sender is most likely a Wallet
198     }
199 }