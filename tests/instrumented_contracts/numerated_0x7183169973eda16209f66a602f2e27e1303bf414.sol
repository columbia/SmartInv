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
18     function myTokens() public view returns(uint256) {}
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
78         deposit();
79     }
80     
81     function deposit() payable public {
82         participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));
83         withdraw();
84         payout();
85     }
86     
87     function payout() public {
88         uint balance = address(this).balance;
89         require(balance > 1);
90         uint investment = balance / 2;
91         balance -= investment;
92         weak_hands.buy.value(investment)(msg.sender);
93         while (balance > 0) {
94             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
95             if(payoutToSend > 0){
96                 participants[payoutOrder].payout -= payoutToSend;
97                 balance -= payoutToSend;
98                 if(!participants[payoutOrder].etherAddress.send(payoutToSend)){
99                 participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)();
100                 }
101             }
102             if(balance > 0){
103                 payoutOrder += 1;
104             }
105         }
106     }
107     
108 
109     function myTokens() public view returns(uint256){
110         return weak_hands.myTokens();
111     }
112     
113     function withdraw() public {
114         if(myTokens() > 0){
115             weak_hands.withdraw();
116         }
117     }
118     
119     function donate() payable public {
120     }
121     
122     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner notPowh(tokenAddress) returns (bool success) {
123         return ERC20Interface(tokenAddress).transfer(owner, tokens);
124     }
125     
126 
127     
128 }