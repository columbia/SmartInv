1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     //internals
5 
6     function safeMul(uint a, uint b) internal returns(uint) {
7         uint c = a * b;
8         Assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function safeSub(uint a, uint b) internal returns(uint) {
13         Assert(b <= a);
14         return a - b;
15     }
16 
17     function safeAdd(uint a, uint b) internal returns(uint) {
18         uint c = a + b;
19         Assert(c >= a && c >= b);
20         return c;
21     }
22 
23     function Assert(bool assertion) internal {
24         if (!assertion) {
25             revert();
26         }
27     }
28 }
29 
30 contract BAP is SafeMath {
31     /* Public variables of the token */
32     string public standard = 'ERC20';
33     string public name = 'BAP token';
34     string public symbol = 'BAP';
35     uint8 public decimals = 0;
36     uint256 public totalSupply;
37     address public owner;
38     uint public tokensSoldToInvestors = 0;
39     uint public maxGoalInICO = 2100000000;
40     /* From this time on tokens may be transfered (after ICO 23h59 10/11/2017)*/
41     uint256 public startTime = 1508936400;
42     /* Tells if tokens have been burned already */
43     bool burned;
44     bool hasICOStarted;
45     /* This wallet will hold tokens after ICO*/
46     address tokensHolder = 0x12bF8E198A6474FC65cEe0e1C6f1C7f23324C8D5;
47     /* This creates an array with all balances */
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51 
52     /* This generates a public event on the blockchain that will notify clients */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event TransferToReferral(address indexed referralAddress, uint256 value);
55     event Approval(address indexed Owner, address indexed spender, uint256 value);
56     event Burned(uint amount);
57 
58     function changeTimeAndMax(uint _start, uint _max){
59         startTime = _start;
60         maxGoalInICO = _max;
61     }
62 
63     /* Initializes contract with initial supply tokens to the creator of the contract */
64     function BAP() {
65         owner = 0xB27590b9d328bA0396271303e24db44132531411;
66         // Give the owner all initial tokens
67         balanceOf[owner] = 2205000000;
68         // Update total supply
69         totalSupply      = 2205000000;
70     }
71 
72     /* Send some of your tokens to a given address */
73     function transfer(address _to, uint256 _value) returns(bool success) {
74         //check if the crowdsale is already over
75         if (now < startTime) {
76             revert();
77         }
78 
79         //prevent owner transfer all tokens immediately after ICO ended
80         if (msg.sender == owner && !burned) {
81             burn();
82             return;
83         }
84 
85         // Subtract from the sender
86         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
87         // Add the same to the recipient
88         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
89         // Notify anyone listening that this transfer took place
90         Transfer(msg.sender, _to, _value);
91 
92         return true;
93     }
94 
95 
96     /* Allow another contract or person to spend some tokens in your behalf */
97     function approve(address _spender, uint256 _value) returns(bool success) {
98         if( now < startTime && hasICOStarted) { // during ICO only allow execute this function one time
99             revert();
100         }
101         hasICOStarted = true;
102         allowance[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105         return true;
106     }
107 
108     /* A contract or  person attempts to get the tokens of somebody else.
109     *  This is only allowed if the token holder approved. */
110     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
111         if (now < startTime && _from != owner) revert(); //check if the crowdsale is already over
112         //prevent the owner of spending his share of tokens so that owner has to burn the token left after ICO
113         if (_from == owner && now >= startTime && !burned) {
114             burn();
115             return;
116         }
117         if (now < startTime){
118             if(_value < maxGoalInICO ) {
119                 tokensSoldToInvestors = safeAdd(tokensSoldToInvestors, _value);
120             } else {
121                 _value = safeSub(_value, maxGoalInICO);
122             }
123         }
124         var _allowance = allowance[_from][msg.sender];
125         // Subtract from the sender
126         balanceOf[_from] = safeSub(balanceOf[_from], _value);
127         // Add the same to the recipient
128         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
129         allowance[_from][msg.sender] = safeSub(_allowance, _value);
130         Transfer(_from, _to, _value);
131 
132         return true;
133     }
134 
135     function burn(){
136         // if tokens have not been burned already and the ICO ended or Tokens have been sold out before ICO end.
137         if(!burned && ( now > startTime || tokensSoldToInvestors >= maxGoalInICO) ) {
138             // checked for overflow above
139             totalSupply = safeSub(totalSupply, balanceOf[owner]) + 900000000;
140             uint tokensLeft = balanceOf[owner];
141             balanceOf[owner] = 0;
142             balanceOf[tokensHolder] = 900000000;
143             startTime = now;
144             burned = true;
145             Burned(tokensLeft);
146         }
147     }
148 
149 }