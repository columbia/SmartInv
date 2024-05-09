1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 contract POWH {
15     
16     function buy(address) public payable returns(uint256){}
17     function withdraw() public {}
18 }
19 
20 contract Owned {
21     address public owner;
22     address public ownerCandidate;
23 
24     function Owned() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32     
33     function changeOwner(address _newOwner) public onlyOwner {
34         ownerCandidate = _newOwner;
35     }
36     
37     function acceptOwnership() public {
38         require(msg.sender == ownerCandidate);  
39         owner = ownerCandidate;
40     }
41     
42 }
43 
44 contract BoomerangLiquidity is Owned {
45     
46     modifier onlyOwner(){
47         require(msg.sender == owner);
48         _;
49     }
50     
51     modifier notPowh(address aContract){
52         require(aContract != powh_address);
53         _;
54     }
55 
56     uint public multiplier;
57     uint public payoutOrder = 0;
58     address powh_address;
59     POWH weak_hands;
60 
61     function BoomerangLiquidity(uint multiplierPercent, address powh) public {
62         multiplier = multiplierPercent;
63         powh_address = powh;
64         weak_hands = POWH(powh_address);
65     }
66     
67     
68     struct Participant {
69         address etherAddress;
70         uint payout;
71     }
72 
73     Participant[] public participants;
74 
75     
76     function() payable public {
77     }
78     
79     function deposit() payable public {
80         participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));
81         payout();
82     }
83     
84     function payout() public {
85         uint balance = address(this).balance;
86         require(balance > 1);
87         uint investment = balance / 2;
88         balance -= investment;
89         weak_hands.buy.value(investment).gas(1000000)(msg.sender);
90         while (balance > 0) {
91             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
92             if(payoutToSend > 0){
93                 participants[payoutOrder].payout -= payoutToSend;
94                 balance -= payoutToSend;
95                 if(!participants[payoutOrder].etherAddress.send(payoutToSend)){
96                     participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)();
97                 }
98             }
99             if(balance > 0){
100                 payoutOrder += 1;
101             }
102             if(payoutOrder >= participants.length){
103                 return;
104             }
105         }
106     }
107     
108     
109     function withdraw() public {
110         weak_hands.withdraw.gas(1000000)();
111     }
112     
113     function donate() payable public {
114     }
115     
116     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner notPowh(tokenAddress) returns (bool success) {
117         return ERC20Interface(tokenAddress).transfer(owner, tokens);
118     }
119     
120 
121     
122 }