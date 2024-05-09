1 /*
2  *  The CoinPoker Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  *  All tokens not being sold during the crowdsale but the reserved token
4  *  for tournaments future financing are burned.
5  *  Author: Justas Kregzde
6  */
7  
8 pragma solidity ^0.4.19;
9 
10 library SafeMath {
11     function mul(uint a, uint b) internal returns (uint) {
12         uint c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint a, uint b) internal returns (uint) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint a, uint b) internal returns (uint) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint a, uint b) internal returns (uint) {
30         uint c = a + b;
31         assert(c>=a && c>=b);
32         return c;
33     }
34 }
35 
36 contract CoinPokerToken {
37     using SafeMath for uint;
38     // Public variables of the token
39     string constant public standard = "ERC20";
40     string constant public name = "Poker Chips";
41     string constant public symbol = "CHP";
42     uint8 constant public decimals = 18;
43     uint _totalSupply = 500000000e18; // Total supply of 500 Million CoinPoker Tokens
44     uint constant public tokensPreICO = 100000000e18; // 20% for pre-ICO
45     uint constant public tokensICO = 275000000e18; // 55% for ICO
46     uint constant public teamReserve = 50000000e18; // 10% for team/advisors/exchanges
47     uint constant public tournamentsReserve = 75000000e18; // 15% for tournaments, released by percentage of total tokens sale
48     uint public startTime = 1516960800; // Time after ICO, when tokens may be transferred. Friday, 26 January 2018 10:00:00 GMT
49     address public ownerAddr;
50     address public preIcoAddr; // pre-ICO token holder
51     address public tournamentsAddr; // tokens for tournaments
52     address public cashierAddr; // CoinPoker main cashier/game wallet
53     bool burned;
54 
55     // Array with all balances
56     mapping (address => uint) balances;
57     mapping (address => mapping (address => uint)) allowed;
58 
59     // Public event on the blockchain that will notify clients
60     event Transfer(address indexed from, address indexed to, uint value);
61     event Approval(address indexed _owner, address indexed spender, uint value);
62     event Burned(uint amount);
63 
64     // What is the balance of a particular account?
65     function balanceOf(address _owner) constant returns (uint balance) {
66         return balances[_owner];
67     }
68 
69     // Returns the amount which _spender is still allowed to withdraw from _owner
70     function allowance(address _owner, address _spender) constant returns (uint remaining) {
71         return allowed[_owner][_spender];
72     }
73 
74     // Get the total token supply
75     function totalSupply() constant returns (uint) {
76         return _totalSupply;
77     }
78 
79     //  Initializes contract with initial supply tokens to the creator of the contract
80     function CoinPokerToken(address _ownerAddr, address _preIcoAddr, address _tournamentsAddr, address _cashierAddr) {
81         ownerAddr = _ownerAddr;
82         preIcoAddr = _preIcoAddr;
83         tournamentsAddr = _tournamentsAddr;
84         cashierAddr = _cashierAddr;
85         balances[ownerAddr] = _totalSupply; // Give the owner all initial tokens
86     }
87 
88     //  Send some of your tokens to a given address
89     function transfer(address _to, uint _value) returns(bool) {
90         if (now < startTime)  // Check if the crowdsale is already over
91             require(_to == cashierAddr); // allow only to transfer CHP (make a deposit) to game/cashier wallet
92         balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
93         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
94         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
95         return true;
96     }
97 
98     //  A contract or person attempts to get the tokens of somebody else.
99     //  This is only allowed if the token holder approved.
100     function transferFrom(address _from, address _to, uint _value) returns(bool) {
101         if (now < startTime)  // Check if the crowdsale is already over
102             require(_from == ownerAddr || _to == cashierAddr);
103         var _allowed = allowed[_from][msg.sender];
104         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
105         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
106         allowed[_from][msg.sender] = _allowed.sub(_value);
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 	
111     //   Approve the passed address to spend the specified amount of tokens
112     //   on behalf of msg.sender.
113     function approve(address _spender, uint _value) returns (bool) {
114         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function percent(uint numerator, uint denominator, uint precision) public constant returns(uint quotient) {
122         uint _numerator = numerator.mul(10 ** (precision.add(1)));
123         uint _quotient =  _numerator.div(denominator).add(5).div(10);
124         return (_quotient);
125     }
126 
127     //  Called when ICO is closed. Burns the remaining tokens except the tokens reserved:
128     //  - for tournaments (released by percentage of total token sale, max 75'000'000)
129     //  - for pre-ICO (100'000'000)
130     //  - for team/advisors/exchanges (50'000'000).
131     //  Anybody may burn the tokens after ICO ended, but only once (in case the owner holds more tokens in the future).
132     //  this ensures that the owner will not posses a majority of the tokens.
133     function burn() {
134         // If tokens have not been burned already and the crowdsale ended
135         if (!burned && now > startTime) {
136             // Calculate tournament release amount (tournament_reserve * proportion_how_many_sold)
137             uint total_sold = _totalSupply.sub(balances[ownerAddr]);
138             total_sold = total_sold.add(tokensPreICO);
139             uint total_ico_amount = tokensPreICO.add(tokensICO);
140             uint percentage = percent(total_sold, total_ico_amount, 8);
141             uint tournamentsAmount = tournamentsReserve.mul(percentage).div(100000000);
142 
143             // Calculate what's left
144             uint totalReserve = teamReserve.add(tokensPreICO);
145             totalReserve = totalReserve.add(tournamentsAmount);
146             uint difference = balances[ownerAddr].sub(totalReserve);
147 
148             // Distribute tokens
149             balances[preIcoAddr] = balances[preIcoAddr].add(tokensPreICO);
150             balances[tournamentsAddr] = balances[tournamentsAddr].add(tournamentsAmount);
151             balances[ownerAddr] = teamReserve;
152 
153             // Burn what's left
154             _totalSupply = _totalSupply.sub(difference);
155             burned = true;
156             Burned(difference);
157         }
158     }
159 }