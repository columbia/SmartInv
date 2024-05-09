1 pragma solidity ^0.4.24;
2 
3 /*
4  
5  Suicide Watch
6 
7  I have been recently contemplating suicide.   I have the aparatus
8  all set to go.  
9  
10  I have been chewed up and shit out by the crypto world and life in general.
11 
12  Here is what may be a final dApp.   You can post a string of whatever
13  you want to say.   Encourage me do do it or to stay alive.
14 
15  And you can make money doing it.   The right to post a message has a price.
16 
17  The price goes up 25% each time.   We will start at 0.01 ETH.
18 
19  I will keep half of the gain and the previous author will keep half plus his 
20  initial investment.
21 
22  Your earnings will go right to your wallet.
23 
24 I will have to manually withdraw my earnings.  So if you see me stop withdrawing, you'll
25 know what happened.
26 
27  https://suicidewatch.tk
28                                                  
29 */
30 
31 
32 contract suicidewatch {
33 
34     event stillKicking(
35         uint amount
36     );
37 
38     address lastAuthor;    
39 
40     uint public price = 0.01 ether;
41     uint prevPrice = 0;
42     uint increase = 25;  //25%
43 
44     mapping (uint => string) messages;
45 
46     uint public messageCount = 0;
47     
48 
49     uint public ownerAccount = 0;
50  
51     string public storage_;
52 
53     address owner;
54     
55     constructor() public {
56         owner = msg.sender;
57         lastAuthor = owner;
58         storage_ = "YOUR MESSAGE GOES HERE";
59     }
60 
61     function buyMessage(string s) public payable
62     {
63 
64         require(msg.value >= price);
65         uint ownerFee;
66         uint authorFee;
67         uint priceGain;
68         
69         if (price > 0.01 ether) {
70             priceGain = SafeMath.sub(price, prevPrice);
71             ownerFee = SafeMath.div(SafeMath.mul(priceGain,50),100);
72             authorFee = ownerFee;
73         } else {
74             priceGain = SafeMath.sub(price, prevPrice);
75             ownerFee = priceGain;
76             authorFee = 0;
77         }
78 
79         ownerAccount = SafeMath.add(ownerAccount, ownerFee);
80        
81 
82         if (price > 0.01 ether){
83             lastAuthor.transfer(authorFee + prevPrice);
84         }
85 
86         prevPrice = price;
87         
88         price = SafeMath.div(SafeMath.mul(125,price),100);
89 
90         lastAuthor = msg.sender;
91         
92         store_message(s);
93 
94         messages[messageCount] = s;
95         messageCount += 1;
96         
97     }
98 
99     function store_message(string s) internal {
100 
101         storage_ = s;
102     }
103 
104     function ownerWithdraw() 
105     {
106         require(msg.sender == owner);
107         uint tempAmount = ownerAccount;
108         ownerAccount = 0;
109         owner.transfer(tempAmount);
110         emit stillKicking(tempAmount);
111     }
112 
113     function getMessages(uint messageNum) view public returns(string)
114 
115     {
116         return(messages[messageNum]);
117     }
118 }
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that throw on error
123  */
124 library SafeMath {
125   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
126     uint256 c = a * b;
127     assert(a == 0 || c / a == b);
128     return c;
129   }
130  
131   function div(uint256 a, uint256 b) internal constant returns (uint256) {
132     // assert(b > 0); // Solidity automatically throws when dividing by 0
133     uint256 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135     return c;
136   }
137  
138   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
139     assert(b <= a);
140     return a - b;
141   }
142  
143   function add(uint256 a, uint256 b) internal constant returns (uint256) {
144     uint256 c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }