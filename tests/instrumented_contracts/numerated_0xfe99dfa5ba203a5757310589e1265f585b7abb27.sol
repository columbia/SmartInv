1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function    transfer(address _to, uint256 _value) public returns (bool success);
5     function    burn( uint256 value ) public returns ( bool success );
6     function    balanceOf( address user ) public view returns ( uint256 );
7 }
8 
9 contract Crowdsale {
10     address     public beneficiary;
11     uint        public amountRaised;
12     uint        public price;
13     token       public tokenReward;
14     uint        public excess;
15 
16     mapping(address => uint256) public balanceOf;
17 
18     bool    public crowdsaleClosed = false;
19     bool    public crowdsaleSuccess = false;
20 
21     event   GoalReached(address recipient, uint totalAmountRaised, bool crowdsaleSuccess);
22     event   FundTransfer(address backer, uint amount, bool isContribution);
23 
24     /**
25      * Constrctor function
26      *
27      * Setup the owner
28      */
29     function    Crowdsale( ) public {
30         beneficiary = msg.sender;
31         price = 0.1 ether;
32         tokenReward = token(0x5a2dacf2D90a89B3D135c7691A74d25Afb5F7Fb7);
33     }
34 
35     /**
36     * Fallback function
37     *
38     * The function without name is the default function that is called whenever anyone sends funds to a contract
39     */
40     function () public payable {
41         require(!crowdsaleClosed);
42 
43         uint amount = msg.value;
44         tokenReward.transfer(msg.sender, amount / price);
45         excess += amount % price;
46         balanceOf[msg.sender] = balanceOf[msg.sender] + amount - excess;
47         amountRaised = amountRaised + amount - excess;
48         FundTransfer(msg.sender, amount, true);
49     }
50 
51     modifier onlyOwner() {
52         require(msg.sender == beneficiary);
53         _;
54     }
55 
56     function goalManagment(bool statement) public onlyOwner {
57         require(crowdsaleClosed == false);    
58         crowdsaleClosed = true;
59         crowdsaleSuccess = statement;
60         GoalReached(beneficiary, amountRaised, crowdsaleSuccess);
61     }
62 
63     /**
64     * Withdraw the funds
65     *
66     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
67     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
68     * the amount they contributed.
69     */
70     function    withdrawalMoneyBack() public {
71         uint    amount;
72 
73         if (crowdsaleClosed == true && crowdsaleSuccess == false) {
74             amount = balanceOf[msg.sender];
75             balanceOf[msg.sender] = 0;
76             amountRaised -= amount;
77             msg.sender.transfer(amount);
78             FundTransfer(msg.sender, amount, false);
79         }
80     }
81 
82     function    withdrawalOwner() public onlyOwner {
83         if (crowdsaleSuccess == true && crowdsaleClosed == true) {
84             beneficiary.transfer(amountRaised);
85             FundTransfer(beneficiary, amountRaised, false);
86             burnToken();
87         }
88     }
89 
90     function takeExcess () public onlyOwner {
91         require(excess > 0);
92         beneficiary.transfer(excess);
93         excess = 0;
94         FundTransfer(beneficiary, excess, false);
95     }
96 
97     function    burnToken() private {
98         uint amount;
99 
100         amount = tokenReward.balanceOf(this);
101         tokenReward.burn(amount);
102     }
103 }