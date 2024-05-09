1 pragma solidity ^0.4.4;
2 
3 contract Token
4 {
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
14 }
15 
16 contract StandardToken is Token
17 {
18 
19     function transfer(address _to, uint256 _value) returns (bool success)
20     {
21         if (balances[msg.sender] >= _value && _value > 0)
22         {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             Transfer(msg.sender, _to, _value);
26             return true;
27         } else { return false; }
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
31     {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0)
33         {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function balanceOf(address _owner) constant returns (uint256 balance)
43     {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success)
48     {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
55     {
56       return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     uint256 public totalSupply;
62 }
63 
64 contract Riccoin is StandardToken
65 {
66 
67     string public name;
68     uint8 public decimals;
69     string public symbol;
70     string public version = 'H1.0';
71     
72     address public beneficiary;
73     address public creator;
74     uint public fundingGoal;
75     uint public starttime;
76     uint public deadline;
77     uint public amountRaised;
78     uint256 public unitsOneEthCanBuy;
79     bool public fundingGoalReached = false;
80     bool public crowdsaleClosed = false;
81 
82     event GoalReached(address recipient, uint totalAmountRaised);
83     
84     function Riccoin(string tokenName, string tokenSymbol, uint256 initialSupply, address sendEtherTo, uint fundingGoalInEther, uint durationInMinutes, uint256 tokenInOneEther)
85     {
86         name = tokenName; 
87         symbol = tokenSymbol; 
88         decimals = 18;
89         totalSupply = initialSupply * 10 ** uint256(decimals);
90         beneficiary = sendEtherTo;
91         creator = msg.sender;
92         balances[beneficiary] = totalSupply;
93         fundingGoal = fundingGoalInEther * 1 ether;
94         starttime = now;
95         deadline = now + durationInMinutes * 1 minutes;
96         unitsOneEthCanBuy = tokenInOneEther;
97     }
98 
99     function() payable
100     {
101         require(!crowdsaleClosed);
102         uint256 amount = msg.value * unitsOneEthCanBuy;
103         
104         
105         if((now - starttime) <= (deadline - starttime) / 20)
106             amount = 23 * (amount/20);
107         else if((now - starttime) <= 9 * ((deadline - starttime) / 20) )
108             amount = 11 * (amount/10);
109 
110         require(balances[beneficiary] >= amount);
111         
112         amountRaised += msg.value;
113         balances[beneficiary] = balances[beneficiary] - amount;
114         balances[msg.sender] = balances[msg.sender] + amount;
115         beneficiary.transfer(msg.value);
116         Transfer(beneficiary, msg.sender, amount); 
117     }
118 
119     modifier afterDeadline()
120     { if (now >= deadline) _; }
121 
122     function checkGoalReached() afterDeadline
123     {
124         if (amountRaised >= fundingGoal)
125         {
126             fundingGoalReached = true;
127             GoalReached(beneficiary, amountRaised);
128         }
129         crowdsaleClosed = true;
130     }
131 
132     function updateRate(uint256 tokenInOneEther) external
133     {
134         require(msg.sender == creator);
135         require(!crowdsaleClosed);
136         unitsOneEthCanBuy = tokenInOneEther;
137     }
138 
139     function changeCreator(address _creator) external
140     {
141         require(msg.sender == creator);
142         creator = _creator;
143     }
144 
145     function updateBeneficiary(address _beneficiary) external
146     {
147         require(msg.sender == creator);
148         beneficiary = _beneficiary;
149     }
150 
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success)
152     {
153         allowed[msg.sender][_spender] = _value;
154         Approval(msg.sender, _spender, _value);
155         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData))
156             { throw; }
157         return true;
158     }
159 }