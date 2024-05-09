1 pragma solidity ^0.4.4;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) public constant returns (uint);
6   function allowance(address owner, address spender) public constant returns (uint);
7 
8   function transfer(address to, uint value) public returns (bool ok);
9   function transferFrom(address from, address to, uint value) public returns (bool ok);
10   function approve(address spender, uint value) public returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract BoltToken is ERC20{
16     
17     address owner = msg.sender;
18     
19     bool public canPurchase = false;
20     
21     mapping (address => uint) balances;
22     mapping (address => uint) roundContributions;
23     address[] roundContributionsIndexes;
24     mapping (address => mapping (address => uint)) allowed;
25 
26     uint public currentSupply = 0;
27     uint public totalSupply = 32032000000000000000000000;
28     
29     uint public round = 0;
30     uint public roundFunds = 0;
31     uint public roundReward = 200200000000000000000000;
32     
33     string public name = "BOLT token";
34     string public symbol = "BOLT";
35     uint8 public decimals = 18;
36     
37     bool public isToken = true;
38     
39     string public tokenSaleAgreement = "https://bolt-project.net/tsa.pdf";
40     
41     uint contributionsDistribStep = 0;
42     
43     event Contribution(address indexed from, uint value);
44     event RoundEnd(uint roundNumber);
45     
46     function balanceOf(address _owner) public constant returns (uint balance) {
47         return balances[_owner];
48     }
49     
50     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
51         return allowed[_owner][_spender];
52     }
53     
54     function transfer(address _to, uint _value) public returns (bool success) {
55         // mitigates the ERC20 short address attack
56         if(msg.data.length < (2 * 32) + 4) { return false; }
57 
58         if (balances[msg.sender] >= _value && _value > 0) {
59             balances[msg.sender] -= _value;
60             balances[_to] += _value;
61             emit Transfer(msg.sender, _to, _value);
62             return true;
63         }
64         return false;
65     }
66     
67     function transferFrom(address _from, address _to, uint _value) public  returns (bool success){
68         // mitigates the ERC20 short address attack
69         if(msg.data.length < (3 * 32) + 4) { return false; }
70         
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             emit Transfer(_from, _to, _value);
76             return true;
77         }
78         return false;
79     }
80     
81     function approve(address _spender, uint _value) public  returns (bool success){
82         // mitigates the ERC20 spend/approval race condition
83         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
84         
85         allowed[msg.sender][_spender] = _value;
86         
87         emit Approval(msg.sender, _spender, _value);
88         
89         return true;
90     }
91     
92     function enablePurchase() public {
93         if(msg.sender != owner && currentSupply>=totalSupply){ return; }
94         
95         canPurchase = true;
96     }
97 
98     function disablePurchase() public {
99         if(msg.sender != owner){ return; }
100         
101         canPurchase = false;
102     }
103     
104     function changeTsaLink(string _link) public {
105         if(msg.sender != owner){ return; }
106         
107         tokenSaleAgreement = _link;
108     }
109     
110     function changeReward(uint _roundReward) public {
111         if(msg.sender != owner){ return; }
112         
113         roundReward = _roundReward;
114     }
115     
116     function nextRound() public {
117         if(msg.sender != owner){ return; }
118         uint i = contributionsDistribStep;
119         while(i < contributionsDistribStep+10 && i<roundContributionsIndexes.length){
120             address contributor = roundContributionsIndexes[i];
121             balances[contributor] += roundReward*roundContributions[contributor]/roundFunds;
122             roundContributions[contributor] = 0;
123             i++;
124         }
125         
126         contributionsDistribStep = i;
127         
128         if(i==roundContributionsIndexes.length){
129             delete roundContributionsIndexes;
130             
131             emit RoundEnd(round);
132             
133             roundFunds = 0;
134             currentSupply += roundReward;
135             round += 1;
136             contributionsDistribStep = 0;
137         }
138     }
139 
140     function contribute(bool _acceptConditions) payable public {
141         
142         if(msg.value == 0){ return; }
143         
144         if(!canPurchase || !_acceptConditions || msg.value < 10 finney){
145             msg.sender.transfer(msg.value);
146             return;
147         }
148         
149         owner.transfer(msg.value);
150         
151         if(roundContributions[msg.sender] == 0){
152            roundContributionsIndexes.push(msg.sender); 
153         }
154         
155         roundContributions[msg.sender] += msg.value;
156         roundFunds += msg.value;
157         
158         emit Contribution(msg.sender, msg.value);
159     }
160 }