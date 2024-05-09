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
32         tokenReward = token(0xe881D262acbfE8997Cfc57E9fd527b175Fb26373);
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
44         require((amount % price) == 0);
45         balanceOf[msg.sender] += amount;
46         amountRaised += amount;
47         tokenReward.transfer(msg.sender, amount / price);
48         excess += amount % price;
49         FundTransfer(msg.sender, amount, true);
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == beneficiary);
54         _;
55     }
56 
57     function goalManagment(bool statement) public onlyOwner {
58         require(crowdsaleClosed == false);    
59         crowdsaleClosed = true;
60         crowdsaleSuccess = statement;
61         GoalReached(beneficiary, amountRaised, crowdsaleSuccess);
62     }
63 
64     /**
65     * Withdraw the funds
66     *
67     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
68     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
69     * the amount they contributed.
70     */
71     function    withdrawalMoneyBack() public {
72         uint    amount;
73 
74         if (crowdsaleClosed == true && crowdsaleSuccess == false) {
75             amount = balanceOf[msg.sender] * price;
76             balanceOf[msg.sender] = 0;
77             amountRaised -= amount;
78             msg.sender.transfer(amount);
79             FundTransfer(msg.sender, amount, false);
80         }
81     }
82 
83     function    withdrawalOwner() public onlyOwner {
84         if (crowdsaleSuccess == true && crowdsaleClosed == true) {
85             beneficiary.transfer(amountRaised);
86             FundTransfer(beneficiary, amountRaised, false);
87             burnToken();
88         }
89     }
90 
91     function takeExcess () public onlyOwner {
92         beneficiary.transfer(excess);
93         FundTransfer(beneficiary, excess, false);
94     }
95 
96     function    burnToken() private {
97         uint amount;
98 
99         amount = tokenReward.balanceOf(this);
100         tokenReward.burn(amount);
101     }
102 }