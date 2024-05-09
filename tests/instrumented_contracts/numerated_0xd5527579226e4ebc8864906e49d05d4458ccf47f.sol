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
30 contract Kubera is SafeMath {
31     /* Public variables of the token */
32     string public standard = 'ERC20';
33     string public name = 'Kubera token';
34     string public symbol = 'KBR';
35     uint8 public decimals = 0;
36     uint256 public totalSupply;
37     address public owner;
38     uint public tokensSoldToInvestors = 0;
39     uint public maxGoalInICO = 2100000000;
40     /* From this time on tokens may be transfered (after ICO 23h59 10/11/2017)*/
41     uint256 public startTime = 1510325999;
42     /* Tells if tokens have been burned already */
43     bool burned;
44     bool hasICOStarted;
45     /* This wallet will hold tokens after ICO*/
46     address tokensHolder = 0x94B4776F8331DF237E087Ed548A3c8b4932D131B;
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
58     /* Initializes contract with initial supply tokens to the creator of the contract */
59     function Kubera() {
60         owner = 0x084bf76c9ba9106d6114305fae9810fbbdb157d9;
61         // Give the owner all initial tokens
62         balanceOf[owner] = 2205000000;
63         // Update total supply
64         totalSupply      = 2205000000;
65     }
66 
67     /* Send some of your tokens to a given address */
68     function transfer(address _to, uint256 _value) returns(bool success) {
69         //check if the crowdsale is already over
70         if (now < startTime) {
71             revert();
72         }
73 
74         //prevent owner transfer all tokens immediately after ICO ended
75         if (msg.sender == owner && !burned) {
76             burn();
77             return;
78         }
79 
80         // Subtract from the sender
81         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
82         // Add the same to the recipient
83         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
84         // Notify anyone listening that this transfer took place
85         Transfer(msg.sender, _to, _value);
86 
87         return true;
88     }
89 
90 
91     /* Allow another contract or person to spend some tokens in your behalf */
92     function approve(address _spender, uint256 _value) returns(bool success) {
93         if( now < startTime && hasICOStarted) { // during ICO only allow execute this function one time
94             revert();
95         }
96         hasICOStarted = true;
97         allowance[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99 
100         return true;
101     }
102 
103     /* A contract or  person attempts to get the tokens of somebody else.
104     *  This is only allowed if the token holder approved. */
105     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
106         if (now < startTime && _from != owner) revert(); //check if the crowdsale is already over
107         //prevent the owner of spending his share of tokens so that owner has to burn the token left after ICO
108         if (_from == owner && now >= startTime && !burned) {
109             burn();
110             return;
111         }
112         if (now < startTime){
113             if(_value < maxGoalInICO ) {
114                 tokensSoldToInvestors = safeAdd(tokensSoldToInvestors, _value);
115             } else {
116                 _value = safeSub(_value, maxGoalInICO);
117             }
118         }
119         var _allowance = allowance[_from][msg.sender];
120         // Subtract from the sender
121         balanceOf[_from] = safeSub(balanceOf[_from], _value);
122         // Add the same to the recipient
123         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
124         allowance[_from][msg.sender] = safeSub(_allowance, _value);
125         Transfer(_from, _to, _value);
126 
127         return true;
128     }
129 
130     function burn(){
131         // if tokens have not been burned already and the ICO ended or Tokens have been sold out before ICO end.
132         if(!burned && ( now > startTime || tokensSoldToInvestors >= maxGoalInICO) ) {
133             // checked for overflow above
134             totalSupply = safeSub(totalSupply, balanceOf[owner]) + 900000000;
135             uint tokensLeft = balanceOf[owner];
136             balanceOf[owner] = 0;
137             balanceOf[tokensHolder] = 900000000;
138             startTime = now;
139             burned = true;
140             Burned(tokensLeft);
141         }
142     }
143 
144 }