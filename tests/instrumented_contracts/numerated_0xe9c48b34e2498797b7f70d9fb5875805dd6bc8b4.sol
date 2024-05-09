1 contract SafeMath {
2 
3   function safeMul(uint a, uint b) returns (uint) {
4     if (a == 0) {
5       return 0;
6     } else {
7       uint c = a * b;
8       require(c / a == b);
9       return c;
10     }
11   }
12 
13   function safeDiv(uint a, uint b) returns (uint) {
14     require(b > 0);
15     uint c = a / b;
16     require(a == b * c + a % b);
17     return c;
18   }
19 
20 }
21 
22 
23 contract token {
24     function balanceOf( address who ) constant returns (uint value);
25     function transfer( address to, uint value) returns (bool ok);
26 }
27 
28 
29 contract Exchange is SafeMath {
30 
31     uint public priceInWei;
32     address public creator;
33     token public tokenExchanged;
34     bool public exchangeState = false;
35     uint public multiplier = 1000000000000000000; //Token decimals
36 
37     event TokenTransfer(address _sender, uint _tokenAmount);
38     event TokenExchangeFailed(address _sender, uint _tokenAmount);
39     event EthFundTransfer(uint _ethAmount);
40     event TokenFundTransfer(uint _tokenAmount);
41 
42 
43     function Exchange(
44         uint tokenPriceInWei,
45         address addressOfTokenExchanged
46     ) {
47         creator = msg.sender;
48         priceInWei = tokenPriceInWei;
49         tokenExchanged = token(addressOfTokenExchanged);
50     }
51 
52 
53     modifier isCreator() {
54         require(msg.sender == creator);
55         _;
56     }
57 
58 
59     function setTokenPriceInWei(uint _price) isCreator() returns (bool result){
60       require(!exchangeState);
61       priceInWei = _price;
62       return true;
63     }
64 
65 
66     function stopExchange() isCreator() returns (bool result){
67       exchangeState = false;
68       return true;
69     }
70 
71 
72     function startExchange() isCreator() returns (bool result){
73       exchangeState = true;
74       return true;
75     }
76 
77 
78     function () payable {
79         require(exchangeState);
80         uint _etherAmountInWei = msg.value;
81         uint _tokenAmount = safeDiv(safeMul(_etherAmountInWei, multiplier), priceInWei);
82         if ( _tokenAmount <= tokenExchanged.balanceOf(this) ){
83           tokenExchanged.transfer(msg.sender, _tokenAmount);
84           TokenTransfer(msg.sender, _tokenAmount);
85         } else {
86           TokenExchangeFailed(msg.sender, _tokenAmount);
87           throw;
88         }
89     }
90 
91 
92     function drainEther() isCreator() returns (bool success){
93       require(!exchangeState);
94       if ( creator.send(this.balance) ) {
95         EthFundTransfer(this.balance);
96         return true;
97       }
98       return false;
99     }
100 
101 
102     function drainTokens() isCreator() returns (bool success){
103       require(!exchangeState);
104       if ( tokenExchanged.transfer(creator, tokenExchanged.balanceOf(this) ) ) {
105         TokenFundTransfer(this.balance);
106         return true;
107       }
108       return false;
109     }
110 
111 
112     function removeContract() public isCreator() {
113         require(!exchangeState);
114         selfdestruct(msg.sender);
115     }
116 
117 }