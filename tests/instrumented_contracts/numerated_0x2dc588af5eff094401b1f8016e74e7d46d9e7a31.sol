1 pragma solidity ^0.4.11;
2 
3 contract CardboardUnicorns {
4   address public owner;
5   function mint(address who, uint value);
6   function changeOwner(address _newOwner);
7   function withdraw();
8   function withdrawForeignTokens(address _tokenContract);
9 }
10 contract RealUnicornCongress {
11   uint public priceOfAUnicornInFinney;
12 }
13 contract ForeignToken {
14   function balanceOf(address _owner) constant returns (uint256);
15   function transfer(address _to, uint256 _value) returns (bool);
16 }
17 
18 contract CardboardUnicornAssembler {
19   address public cardboardUnicornTokenAddress;
20   address public realUnicornAddress = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;
21   address public owner = msg.sender;
22   uint public pricePerUnicorn = 1 finney;
23   uint public lastPriceSetDate = 0;
24   
25   event PriceUpdate(uint newPrice, address updater);
26 
27   modifier onlyOwner {
28     require(msg.sender == owner);
29     _;
30   }
31   
32   /**
33    * Change ownership of the assembler
34    */
35   function changeOwner(address _newOwner) onlyOwner {
36     owner = _newOwner;
37   }
38   function changeTokenOwner(address _newOwner) onlyOwner {
39     CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);
40     cu.changeOwner(_newOwner);
41   }
42   
43   /**
44    * Change the CardboardUnicorns token contract managed by this contract
45    */
46   function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {
47     CardboardUnicorns cu = CardboardUnicorns(_newTokenAddress);
48     require(cu.owner() == address(this)); // We must be the owner of the token
49     cardboardUnicornTokenAddress = _newTokenAddress;
50   }
51   
52   /**
53    * Change the real unicorn contract location.
54    * This contract is used as a price reference; should the Ethereum Foundation
55    * re-deploy their contract, this should be called to update the reference.
56    */
57   function changeRealUnicornAddress(address _newUnicornAddress) onlyOwner {
58     realUnicornAddress = _newUnicornAddress;
59   }
60   
61   function withdraw(bool _includeToken) onlyOwner {
62     if (_includeToken) {
63       // First have the token contract send all its funds to its owner (which is us)
64       CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);
65       cu.withdraw();
66     }
67 
68     // Then send that whole total to our owner
69     owner.transfer(this.balance);
70   }
71   function withdrawForeignTokens(address _tokenContract, bool _includeToken) onlyOwner {
72     ForeignToken token = ForeignToken(_tokenContract);
73 
74     if (_includeToken) {
75       // First have the token contract send its tokens to its owner (which is us)
76       CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);
77       cu.withdrawForeignTokens(_tokenContract);
78     }
79 
80     // Then send that whole total to our owner
81     uint256 amount = token.balanceOf(address(this));
82     token.transfer(owner, amount);
83   }
84 
85   /**
86    * Update the price of a CardboardUnicorn to be 1/1000 a real Unicorn's price
87    */
88   function updatePriceFromRealUnicornPrice() {
89     require(block.timestamp > lastPriceSetDate + 7 days); // If owner set the price, cannot sync right after
90     RealUnicornCongress congress = RealUnicornCongress(realUnicornAddress);
91     pricePerUnicorn = (congress.priceOfAUnicornInFinney() * 1 finney) / 1000;
92     PriceUpdate(pricePerUnicorn, msg.sender);
93   }
94   
95   /**
96    * Set a specific price for a CardboardUnicorn
97    */
98   function setPrice(uint _newPrice) onlyOwner {
99     pricePerUnicorn = _newPrice;
100     lastPriceSetDate = block.timestamp;
101     PriceUpdate(pricePerUnicorn, msg.sender);
102   }
103   
104   /**
105    * Strap a horn to a horse!
106    */
107   function assembleUnicorn() payable {
108     if (msg.value >= pricePerUnicorn) {
109         CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);
110         cu.mint(msg.sender, msg.value / pricePerUnicorn);
111         owner.transfer(msg.value);
112     }
113   }
114   
115   function() payable {
116       assembleUnicorn();
117   }
118 
119 }