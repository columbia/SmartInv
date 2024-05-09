1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5     * @dev Math operations with safety checks that throw on error
6        */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function add(uint256 a, uint256 b) internal returns (uint256) {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19   
20   function div(uint256 a, uint256 b) internal returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 }
32 
33 /**
34  * @title Ownable
35     * @dev The Ownable contract has an owner address, and provides basic authorization control 
36        * functions, this simplifies the implementation of "user permissions". 
37           */
38 contract Ownable {
39   address public owner;
40 
41 
42   /** 
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44         * account.
45              */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner. 
53         */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62         * @param newOwner The address to transfer ownership to. 
63              */
64   function transferOwnership(address newOwner) public onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 }
70 
71 /**
72  * @title Token
73    * @dev interface for interacting with droneshowcoin token
74              */
75 interface  Token {
76  function transfer(address _to, uint256 _value) public returns (bool);
77  function balanceOf(address _owner) public constant returns(uint256 balance);
78 }
79 
80 contract DroneShowCoinICOContract is Ownable {
81     
82     using SafeMath for uint256;
83     
84     Token token;
85     
86     uint256 public constant RATE = 650; //tokens per ether
87     uint256 public constant CAP = 15000; //cap in ether
88     uint256 public constant START = 1510754400; //GMT: Wednesday, November 15, 2017 2:00:00 PM
89     uint256 public constant DAYS = 30; //
90     
91     bool public initialized = false;
92     uint256 public raisedAmount = 0;
93     uint256 public bonusesGiven = 0;
94     uint256 public numberOfTransactions = 0;
95     
96     event BoughtTokens(address indexed to, uint256 value);
97     
98     modifier whenSaleIsActive() {
99         assert (isActive());
100         _;
101     }
102     
103     function DroneShowCoinICOContract(address _tokenAddr) public {
104         require(_tokenAddr != 0);
105         token = Token(_tokenAddr);
106     }
107     
108     function initialize(uint256 numTokens) public onlyOwner {
109         require (initialized == false);
110         require (tokensAvailable() == numTokens);
111         initialized = true;
112     }
113     
114     function isActive() public constant returns (bool) {
115         return (
116             initialized == true &&  //check if initialized
117             now >= START && //check if after start date
118             now <= START.add(DAYS * 1 days) && //check if before end date
119             goalReached() == false //check if goal was not reached
120         ); // if all of the above are true we are active, else we are not
121     }
122     
123     function goalReached() public constant returns (bool) {
124         return (raisedAmount >= CAP * 1 ether);
125     }
126     
127     function () public payable {
128         buyTokens();
129     }
130     
131     function buyTokens() public payable whenSaleIsActive {
132         uint256 weiAmount = msg.value;
133         uint256 tokens = weiAmount.mul(RATE);
134         
135         uint256 secondspassed = now - START;
136         uint256 dayspassed = secondspassed/(60*60*24);
137         uint256 bonusPrcnt = 0;
138         if (dayspassed < 7) {
139             //first 7 days 20% bonus
140             bonusPrcnt = 20;
141         } else if (dayspassed < 14) {
142             //second week 10% bonus
143             bonusPrcnt = 10;
144         } else {
145             //no bonus
146             bonusPrcnt = 0;
147         }
148         uint256 bonusAmount = (tokens * bonusPrcnt) / 100;
149         tokens = tokens.add(bonusAmount);
150         BoughtTokens(msg.sender, tokens);
151         
152         raisedAmount = raisedAmount.add(msg.value);
153         bonusesGiven = bonusesGiven.add(bonusAmount);
154         numberOfTransactions = numberOfTransactions.add(1);
155         token.transfer(msg.sender, tokens);
156         
157         owner.transfer(msg.value);
158         
159     }
160     
161     function tokensAvailable() public constant returns (uint256) {
162         return token.balanceOf(this);
163     }
164     
165     function destroy() public onlyOwner {
166         uint256 balance = token.balanceOf(this);
167         assert (balance > 0);
168         token.transfer(owner,balance);
169         selfdestruct(owner);
170         
171     }
172 }