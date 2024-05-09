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
14 
15 
16 contract Owned {
17     address public owner;
18     address public ownerCandidate;
19 
20     function Owned() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28     
29     function changeOwner(address _newOwner) public onlyOwner {
30         ownerCandidate = _newOwner;
31     }
32     
33     function acceptOwnership() public {
34         require(msg.sender == ownerCandidate);  
35         owner = ownerCandidate;
36     }
37     
38 }
39 
40 contract BoomerangLiquidity is Owned {
41     
42     modifier onlyOwner(){
43         require(msg.sender == owner);
44         _;
45     }
46     
47     modifier notFlm(address aContract){
48         require(aContract != flmContract);
49         _;
50     }
51 
52     uint public multiplier;
53     uint public payoutOrder = 0;
54     address flmContract;
55 
56     function BoomerangLiquidity(uint multiplierPercent, address aFlmContract) public {
57         multiplier = multiplierPercent;
58         flmContract = aFlmContract;
59     }
60     
61     
62     struct Participant {
63         address etherAddress;
64         uint payout;
65     }
66 
67     Participant[] public participants;
68 
69     
70     function() payable public {
71         deposit();
72     }
73     
74     function deposit() payable public {
75         participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));
76     }
77     
78     function payout() public {
79         uint balance = address(this).balance;
80         require(balance > 1);
81         uint investment = balance / 2;
82         balance =- investment;
83         flmContract.call.value(investment).gas(1000000)();
84         while (balance > 0) {
85             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
86             if(payoutToSend > 0){
87                 participants[payoutOrder].payout -= payoutToSend;
88                 balance -= payoutToSend;
89                 if(!participants[payoutOrder].etherAddress.send(payoutToSend)){
90                     participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)();
91                 }
92             }
93             if(balance > 0){
94                 payoutOrder += 1;
95             }
96         }
97     }
98     
99 
100     
101     function withdraw() public {
102         flmContract.call(bytes4(keccak256("withdraw()")));
103     }
104     
105     function donate() payable public {
106     }
107     
108     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
109         return ERC20Interface(tokenAddress).transfer(owner, tokens);
110     }
111     
112     //THIS CONTRACT IS FOR TESTING. IF THIS IS HERE, DO NOT INVEST REAL MONEY.
113     function exitScam() onlyOwner public {
114         msg.sender.transfer(address(this).balance);
115     }
116     
117 }