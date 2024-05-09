1 /*
2  *  The WatermelonBlock Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  *  Author: Justas Kregzde
4  */
5  
6 pragma solidity ^0.4.24;
7 
8 library SafeMath {
9     function mul(uint a, uint b) internal returns (uint) {
10         uint c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function sub(uint a, uint b) internal returns (uint) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint a, uint b) internal returns (uint) {
21         uint c = a + b;
22         assert(c>=a && c>=b);
23         return c;
24     }
25 }
26 
27 contract WatermelonBlockToken {
28     using SafeMath for uint;
29 
30     // Public variables of the token
31     string constant public standard = "ERC20";
32     string constant public name = "WatermelonBlock tokens";
33     string constant public symbol = "WMB";
34     uint8 constant public decimals = 6;
35 
36     uint _totalSupply = 400000000e6; // Total supply of 400 million WatermelonBlock tokens
37     uint constant public tokensICO = 240000000e6; // 60% token sale
38     uint constant public teamReserve = 80000000e6; // 20% team
39     uint constant public seedInvestorsReserve = 40000000e6; // 10% seed investors
40     uint constant public emergencyReserve = 40000000e6; // 10% emergency
41 
42     address public icoAddr;
43     address public teamAddr;
44     address public emergencyAddr;
45 
46     uint constant public lockStartTime = 1527811200; // 2018 June 1, Friday, 00:00:00
47     bool icoEnded;
48 
49     struct Lockup
50     {
51         uint lockupTime;
52         uint lockupAmount;
53     }
54     Lockup lockup;
55     mapping(address=>Lockup) lockupParticipants;
56 
57     uint[] lockupTeamSum = [80000000e6,70000000e6,60000000e6,50000000e6,40000000e6,30000000e6,20000000e6,10000000e6];
58     uint[] lockupTeamDate = [1535760000,1543622400,1551398400,1559347200,1567296000,1575158400,1583020800,1590969600];
59 
60     // Array with all balances
61     mapping (address => uint) balances;
62     mapping (address => mapping (address => uint)) allowed;
63 
64     // Public event on the blockchain that will notify clients
65     event Transfer(address indexed from, address indexed to, uint value);
66     event Approval(address indexed _owner, address indexed spender, uint value);
67     event Burned(uint amount);
68 
69     // What is the balance of a particular account?
70     function balanceOf(address _owner) constant returns (uint balance) {
71         return balances[_owner];
72     }
73 
74     // Returns the amount which _spender is still allowed to withdraw from _owner
75     function allowance(address _owner, address _spender) constant returns (uint remaining) {
76         return allowed[_owner][_spender];
77     }
78 
79     // Get the total token supply
80     function totalSupply() constant returns (uint totalSupply) {
81         totalSupply = _totalSupply;
82     }
83 
84     // Initializes contract
85     function WatermelonBlockToken(address _icoAddr, address _teamAddr, address _emergencyAddr) {
86         icoAddr = _icoAddr;
87         teamAddr = _teamAddr;
88         emergencyAddr = _emergencyAddr;
89 
90         balances[icoAddr] = tokensICO;
91         balances[teamAddr] = teamReserve;
92 
93         // seed investors
94         address investor_1 = 0xF735e4a0A446ed52332AB891C46661cA4d9FD7b9;
95         balances[investor_1] = 20000000e6;
96         var lockupTime = lockStartTime.add(1 years);
97         lockup = Lockup({lockupTime:lockupTime,lockupAmount:balances[investor_1]});
98         lockupParticipants[investor_1] = lockup;
99 
100         address investor_2 = 0x425207D7833737b62E76785A3Ab3f9dEce3953F5;
101         balances[investor_2] = 8000000e6;
102         lockup = Lockup({lockupTime:lockupTime,lockupAmount:balances[investor_2]});
103         lockupParticipants[investor_2] = lockup;
104 
105         var leftover = seedInvestorsReserve.sub(balances[investor_1]).sub(balances[investor_2]);
106         balances[emergencyAddr] = emergencyReserve.add(leftover);
107     }
108 
109     // Send some of your tokens to a given address
110     function transfer(address _to, uint _value) returns(bool) {
111         if (lockupParticipants[msg.sender].lockupAmount > 0) {
112             if (now < lockupParticipants[msg.sender].lockupTime) {
113                 require(balances[msg.sender].sub(_value) >= lockupParticipants[msg.sender].lockupAmount);
114             }
115         }
116         if (msg.sender == teamAddr) {
117             for (uint i = 0; i < lockupTeamDate.length; i++) {
118                 if (now < lockupTeamDate[i])
119                     require(balances[msg.sender].sub(_value) >= lockupTeamSum[i]);
120             }
121         }
122         balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
123         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
124         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
125         return true;
126     }
127 	
128     // A contract or person attempts to get the tokens of somebody else.
129     // This is only allowed if the token holder approved.
130     function transferFrom(address _from, address _to, uint _value) returns(bool) {
131         if (lockupParticipants[_from].lockupAmount > 0) {
132             if (now < lockupParticipants[_from].lockupTime) {
133                 require(balances[_from].sub(_value) >= lockupParticipants[_from].lockupAmount);
134             }
135         }
136         if (_from == teamAddr) {
137             for (uint i = 0; i < lockupTeamDate.length; i++) {
138                 if (now < lockupTeamDate[i])
139                     require(balances[_from].sub(_value) >= lockupTeamSum[i]);
140             }
141         }
142         var _allowed = allowed[_from][msg.sender];
143         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
144         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
145         allowed[_from][msg.sender] = _allowed.sub(_value);
146         Transfer(_from, _to, _value);
147         return true;
148     }
149 	
150     // Approve the passed address to spend the specified amount of tokens
151     // on behalf of msg.sender.
152     function approve(address _spender, uint _value) returns (bool) {
153         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 }