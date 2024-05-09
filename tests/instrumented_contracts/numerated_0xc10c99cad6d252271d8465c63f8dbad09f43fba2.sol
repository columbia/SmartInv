1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24   
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 interface token {
33     function transfer(address receiver, uint amount) public;
34     function burn(uint256 _value) public returns (bool success);
35 }
36 
37 contract Ownable {
38 
39     address public owner;
40 
41     function Ownable() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     
50 }
51 
52 contract IQNCrowdsale is Ownable {
53     
54     using SafeMath for uint256;
55     
56     uint256 public constant EXCHANGE_RATE = 325;
57     uint256 public constant START = 1517313600; // Tuesday, 30-Jan-18 12:00:00 UTC in RFC 2822
58 
59 
60 
61     uint256 availableTokens;
62     address addressToSendEthereum;
63     
64     uint public amountRaised;
65     uint public deadline;
66     uint public price;
67     token public tokenReward;
68     mapping(address => uint256) public balanceOf;
69 
70     /**
71      * Constrctor function
72      *
73      * Setup the owner
74      */
75     function IQNCrowdsale (
76         address addressOfTokenUsedAsReward,
77         address _addressToSendEthereum
78     ) public {
79         availableTokens = 5700000 * 10 ** 18;
80         addressToSendEthereum = _addressToSendEthereum;
81         deadline = START + 42 days;
82         tokenReward = token(addressOfTokenUsedAsReward);
83     }
84 
85     /**
86      * Fallback function
87      *
88      * The function without name is the default function that is called whenever anyone sends funds to a contract
89      */
90     function () public payable {
91         require(now < deadline && now >= START);
92         uint256 amount = msg.value;
93         uint256 tokens = amount * EXCHANGE_RATE;
94         uint256 bonus = getBonus(tokens);
95         tokens = tokens.add(bonus);
96         balanceOf[msg.sender] += tokens;
97         amountRaised += tokens;
98         availableTokens -= tokens;
99         tokenReward.transfer(msg.sender, tokens);
100         addressToSendEthereum.transfer(amount);
101     }
102     
103     
104     function getBonus(uint256 _tokens) public constant returns (uint256) {
105 
106         require(_tokens > 0);
107         
108         if (START <= now && now < START + 1 days) {
109 
110             return _tokens.mul(30).div(100); // 30% first day
111 
112         } else if (START <= now && now < START + 1 weeks) {
113 
114             return _tokens.div(4); // 25% first week
115 
116         } else if (START + 1 weeks <= now && now < START + 2 weeks) {
117 
118             return _tokens.div(5); // 20% second week
119 
120         } else if (START + 2 weeks <= now && now < START + 3 weeks) {
121 
122             return _tokens.mul(15).div(100); // 15% third week
123 
124         } else if (START + 3 weeks <= now && now < START + 4 weeks) {
125 
126             return _tokens.div(10); // 10% fourth week
127 
128         } else if (START + 4 weeks <= now && now < START + 5 weeks) {
129 
130             return _tokens.div(20); // 5% fifth week
131 
132         } else {
133 
134             return 0;
135 
136         }
137     }
138 
139     modifier afterDeadline() { 
140         require(now >= deadline);
141         _; 
142     }
143     
144     function sellForOtherCoins(address _address,uint amount)  public payable onlyOwner
145     {
146         uint256 tokens = amount;
147         uint256 bonus = getBonus(tokens);
148         tokens = tokens.add(bonus);
149         availableTokens -= tokens;
150         tokenReward.transfer(_address, tokens);
151     }
152     
153     function burnAfterIco() public onlyOwner returns (bool success){
154         uint256 balance = availableTokens;
155         tokenReward.burn(balance);
156         availableTokens = 0;
157         return true;
158     }
159 
160     function tokensAvailable() public constant returns (uint256) {
161         return availableTokens;
162     }
163 
164 }