1 pragma solidity ^0.4.20;
2 
3 /*
4 *   Basic PHX-Ethereum PHX Sales Contract
5 *
6 *   This contract keeps a list of offers to sell PHX coins
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
19 */
20 
21 contract ERC20Token {
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
28 }
29 
30 contract SimplePHXSalesContract {
31     
32     // ScaleFactor
33     // It needs to be possible to make PHX cost less than 1 Wei / Rise
34     uint public ScaleFactor = 10 ** 18;  
35     
36     // Array of offerors
37     mapping(uint256 => address) public offerors;
38 	mapping(address => uint256) public AddrNdx;
39     uint public nxtAddr;
40     
41 	// Array between each address and their tokens offered and buy prices.
42 	mapping(address => uint256) public tokensOffered;
43 	mapping(address => uint256) public pricePerToken; // In qWeiPerRise (need to multiply by 10 ** 36 to get it to ETH / PHX)
44 
45     ERC20Token public phxCoin;
46 
47     address public owner;
48 
49     function SimplePHXSalesContract() public {
50         phxCoin = ERC20Token(0x14b759A158879B133710f4059d32565b4a66140C); // Initiates a PHX Coin !important -- Make sure this is the existing contract!
51         owner = msg.sender;
52         nxtAddr = 1; // This is because all IDs in AddrNdx will initialize to zero
53     }
54 
55     function offer(uint _tokensOffered, uint _tokenPrice) public {
56         require(_humanSender(msg.sender));
57         require(AddrNdx[msg.sender] == 0); // Make sure that this offeror has cancelled all previous offers
58         require(phxCoin.transferFrom(msg.sender, this, _tokensOffered));
59         tokensOffered[msg.sender] = _tokensOffered;
60         pricePerToken[msg.sender] = _tokenPrice; // in qWeiPerRise
61         offerors[nxtAddr] = msg.sender;
62         AddrNdx[msg.sender] = nxtAddr;
63         nxtAddr++;
64     }
65 
66     function _canceloffer(address _offeror) internal {
67         delete tokensOffered[_offeror];
68         delete pricePerToken[_offeror];
69         
70         uint Ndx = AddrNdx[_offeror];
71         nxtAddr--;
72 
73         // If this isn't the only offer, reshuffle the array
74         // Moving the last entry to the middle of the list
75         if (nxtAddr > 1) {
76             offerors[Ndx] = offerors[nxtAddr];
77             AddrNdx[offerors[nxtAddr]] = Ndx;
78             delete offerors[nxtAddr];
79         } else {
80             delete offerors[Ndx];
81         }
82         
83         delete AddrNdx[_offeror]; // !important
84     }
85 
86     function canceloffer() public {
87         if(AddrNdx[msg.sender] == 0) return; // No need to cancel non-existent offer
88         phxCoin.transfer(msg.sender, tokensOffered[msg.sender]); // Return the Tokens
89         _canceloffer(msg.sender);
90     }
91     
92     function buy(uint _ndx) payable public {
93         require(_humanSender(msg.sender));
94         address _offeror = offerors[_ndx];
95         uint _purchasePrice = tokensOffered[_offeror] * pricePerToken[_offeror] * ScaleFactor;
96         require(msg.value >= _purchasePrice);
97         phxCoin.transfer(msg.sender, tokensOffered[_offeror]);
98         _offeror.transfer(_purchasePrice);
99         _canceloffer(_offeror);
100     }
101     
102     function updatePrice(uint _newPrice) public {
103         // Make sure that this offeror has an offer out there
104         require(tokensOffered[msg.sender] != 0); 
105         pricePerToken[msg.sender] = _newPrice;
106     }
107     
108     function getOfferor(uint _ndx) public constant returns (address _offeror) {
109         return offerors[_ndx];
110     }
111     
112     function getOfferPrice(uint _ndx) public constant returns (uint _tokenPrice) {
113         return pricePerToken[offerors[_ndx]];
114     }
115     
116     function getOfferAmount(uint _ndx) public constant returns (uint _tokensOffered) {
117         return tokensOffered[offerors[_ndx]];
118     }
119     
120     function withdrawEth() public {
121         owner.transfer(address(this).balance);
122     }
123     
124     function () payable public {
125     }
126     
127     // Determine if the "_from" address is a contract
128     function _humanSender(address _from) private view returns (bool) {
129       uint codeLength;
130       assembly {
131           codeLength := extcodesize(_from)
132       }
133       return (codeLength == 0); // If this is "true" sender is most likely a Wallet
134     }
135 }