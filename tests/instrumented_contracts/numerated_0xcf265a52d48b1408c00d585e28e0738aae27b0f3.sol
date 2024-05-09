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
18     function myTokens() public view returns(uint256){}
19 }
20 
21 contract Owned {
22     address public owner;
23     address public ownerCandidate;
24 
25     function Owned() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33     
34     function changeOwner(address _newOwner) public onlyOwner {
35         ownerCandidate = _newOwner;
36     }
37     
38     function acceptOwnership() public {
39         require(msg.sender == ownerCandidate);  
40         owner = ownerCandidate;
41     }
42     
43 }
44 
45 contract BoomerangLiquidity is Owned {
46     
47     modifier onlyOwner(){
48         require(msg.sender == owner);
49         _;
50     }
51     
52     modifier notPowh(address aContract){
53         require(aContract != powh_address);
54         _;
55     }
56 
57     uint public multiplier;
58     uint public payoutOrder = 0;
59     address powh_address;
60     POWH weak_hands;
61 
62     function BoomerangLiquidity(uint multiplierPercent, address powh) public {
63         multiplier = multiplierPercent;
64         powh_address = powh;
65         weak_hands = POWH(powh_address);
66     }
67     
68     
69     struct Participant {
70         address etherAddress;
71         uint payout;
72     }
73 
74     Participant[] public participants;
75 
76     
77     function() payable public {
78     }
79     
80     function deposit() payable public {
81         participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));
82         if(myTokens() > 0){
83             withdraw();
84         }
85         payout();
86     }
87     
88     function payout() public {
89         uint balance = address(this).balance;
90         require(balance > 1);
91         uint investment = balance / 2;
92         balance -= investment;
93         weak_hands.buy.value(investment).gas(1000000)(msg.sender);
94         while (balance > 0) {
95             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
96             if(payoutToSend > 0){
97                 participants[payoutOrder].payout -= payoutToSend;
98                 balance -= payoutToSend;
99                 if(!participants[payoutOrder].etherAddress.send(payoutToSend)){
100                     participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)();
101                 }
102             }
103             if(balance > 0){
104                 payoutOrder += 1;
105             }
106             if(payoutOrder >= participants.length){
107                 return;
108             }
109         }
110     }
111     
112     function myTokens() public view returns(uint256){
113         weak_hands.myTokens();
114     }
115     
116     function withdraw() public {
117         weak_hands.withdraw.gas(1000000)();
118     }
119     
120     function donate() payable public {
121     }
122     
123     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner notPowh(tokenAddress) returns (bool success) {
124         return ERC20Interface(tokenAddress).transfer(owner, tokens);
125     }
126     
127 
128     
129 }