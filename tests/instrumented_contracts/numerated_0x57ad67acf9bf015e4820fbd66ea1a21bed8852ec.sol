1 /*
2  *  The Lympo Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
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
17     function sub(uint a, uint b) internal returns (uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         assert(c>=a && c>=b);
25         return c;
26     }
27 }
28 
29 contract LympoToken {
30     using SafeMath for uint;
31     // Public variables of the token
32     string constant public standard = "ERC20";
33     string constant public name = "Lympo tokens";
34     string constant public symbol = "LYM";
35     uint8 constant public decimals = 18;
36     uint _totalSupply = 1000000000e18; // Total supply of 1 billion Lympo Tokens
37     uint constant public tokensPreICO = 265000000e18; // 26.5%
38     uint constant public tokensICO = 385000000e18; // 38.5%
39     uint constant public teamReserve = 100000000e18; // 10%
40     uint constant public advisersReserve = 30000000e18; // 3%
41     uint constant public ecosystemReserve = 220000000e18; // 22%
42     uint constant public ecoLock23 = 146652000e18; // 2/3 of ecosystem reserve
43     uint constant public ecoLock13 = 73326000e18; // 1/3 of ecosystem reserve
44     uint constant public startTime = 1519815600; // Time after ICO, when tokens became transferable. Wednesday, 28 February 2018 11:00:00 GMT
45     uint public lockReleaseDate1year;
46     uint public lockReleaseDate2year;
47     address public ownerAddr;
48     address public ecosystemAddr;
49     address public advisersAddr;
50     bool burned;
51 
52     // Array with all balances
53     mapping (address => uint) balances;
54     mapping (address => mapping (address => uint)) allowed;
55 
56     // Public event on the blockchain that will notify clients
57     event Transfer(address indexed from, address indexed to, uint value);
58     event Approval(address indexed _owner, address indexed spender, uint value);
59     event Burned(uint amount);
60 
61     // What is the balance of a particular account?
62     function balanceOf(address _owner) constant returns (uint balance) {
63         return balances[_owner];
64     }
65 
66     // Returns the amount which _spender is still allowed to withdraw from _owner
67     function allowance(address _owner, address _spender) constant returns (uint remaining) {
68         return allowed[_owner][_spender];
69     }
70 
71     // Get the total token supply
72     function totalSupply() constant returns (uint totalSupply) {
73         totalSupply = _totalSupply;
74     }
75 
76     // Initializes contract with initial supply tokens to the creator of the contract
77     function LympoToken(address _ownerAddr, address _advisersAddr, address _ecosystemAddr) {
78         ownerAddr = _ownerAddr;
79         advisersAddr = _advisersAddr;
80         ecosystemAddr = _ecosystemAddr;
81         lockReleaseDate1year = startTime + 1 years; // 2019
82         lockReleaseDate2year = startTime + 2 years; // 2020
83         balances[ownerAddr] = _totalSupply; // Give the owner all initial tokens
84     }
85 	
86     // Send some of your tokens to a given address
87     function transfer(address _to, uint _value) returns(bool) {
88         require(now >= startTime); // Check if the crowdsale is already over
89 
90         // prevent the owner of spending his share of tokens for team within first the two year
91         if (msg.sender == ownerAddr && now < lockReleaseDate2year)
92             require(balances[msg.sender].sub(_value) >= teamReserve);
93 
94         // prevent the ecosystem owner of spending 2/3 share of tokens for the first year, 1/3 for the next year
95         if (msg.sender == ecosystemAddr && now < lockReleaseDate1year)
96             require(balances[msg.sender].sub(_value) >= ecoLock23);
97         else if (msg.sender == ecosystemAddr && now < lockReleaseDate2year)
98             require(balances[msg.sender].sub(_value) >= ecoLock13);
99 
100         balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
101         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
102         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
103         return true;
104     }
105 	
106     // A contract or person attempts to get the tokens of somebody else.
107     // This is only allowed if the token holder approved.
108     function transferFrom(address _from, address _to, uint _value) returns(bool) {
109         if (now < startTime)  // Check if the crowdsale is already over
110             require(_from == ownerAddr);
111 
112         // prevent the owner of spending his share of tokens for team within the first two year
113         if (_from == ownerAddr && now < lockReleaseDate2year)
114             require(balances[_from].sub(_value) >= teamReserve);
115 
116         // prevent the ecosystem owner of spending 2/3 share of tokens for the first year, 1/3 for the next year
117         if (_from == ecosystemAddr && now < lockReleaseDate1year)
118             require(balances[_from].sub(_value) >= ecoLock23);
119         else if (_from == ecosystemAddr && now < lockReleaseDate2year)
120             require(balances[_from].sub(_value) >= ecoLock13);
121 
122         var _allowed = allowed[_from][msg.sender];
123         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
124         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
125         allowed[_from][msg.sender] = _allowed.sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 	
130     // Approve the passed address to spend the specified amount of tokens
131     // on behalf of msg.sender.
132     function approve(address _spender, uint _value) returns (bool) {
133         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     // Called when ICO is closed. Burns the remaining tokens except the tokens reserved:
141     // Anybody may burn the tokens after ICO ended, but only once (in case the owner holds more tokens in the future).
142     // this ensures that the owner will not posses a majority of the tokens.
143     function burn() {
144         // If tokens have not been burned already and the crowdsale ended
145         if (!burned && now > startTime) {
146             uint totalReserve = ecosystemReserve.add(teamReserve);
147             totalReserve = totalReserve.add(advisersReserve);
148             uint difference = balances[ownerAddr].sub(totalReserve);
149             balances[ownerAddr] = teamReserve;
150             balances[advisersAddr] = advisersReserve;
151             balances[ecosystemAddr] = ecosystemReserve;
152             _totalSupply = _totalSupply.sub(difference);
153             burned = true;
154             Burned(difference);
155         }
156     }
157 }