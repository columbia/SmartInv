1 pragma solidity ^0.4.25;
2 
3 
4 contract Prosperity {
5     
6     /**
7      * Converts all incoming ethereum to tokens for the caller, and passes down the referral
8      */
9     function buy(address _referredBy) public payable returns(uint256);
10     
11     /**
12      * Converts all of caller's dividends to tokens.
13      */
14     function reinvest() public;
15     
16     /**
17      * Liquifies tokens to ethereum.
18      */
19     function sell(uint256 _amountOfTokens) public;
20     
21     /**
22      * Alias of sell() and withdraw().
23      */
24     function exit() public;
25     
26     /**
27      * Withdraws all of the callers earnings.
28      */
29     function withdraw() public;
30     
31     /**
32      * Retrieve the token balance of any single address.
33      */
34     function balanceOf(address _customerAddress) view public returns(uint256);
35     
36     /**
37      * Retrieve the dividend balance of any single address.
38      */
39     function dividendsOf(address _customerAddress) view public returns(uint256);
40 }
41 
42 contract Fertilizer {
43     
44     /*==============================
45     =            EVENTS            =
46     ==============================*/
47     event onDistribute(
48         address pusher, 
49         uint256 percent, 
50         uint256 oldBal, 
51         uint256 newBal
52     );
53     
54     
55     /*================================
56     =            DATASETS            =
57     ================================*/
58     address internal fund_;
59     Prosperity internal Exchange_;
60     
61     
62     /*=======================================
63     =            PUBLIC FUNCTIONS            =
64     =======================================*/
65     constructor() 
66         public 
67     {
68         Exchange_ = Prosperity(0xFf567f72F6BC585A3143E6852A2fF7DF26e5f455);
69         fund_ = 0x1E2F082CB8fd71890777CA55Bd0Ce1299975B25f;
70     }
71     
72     // used so the distribute function can call Prosperities withdraw function
73     function() external payable {}
74     
75     function distribute(uint256 _percent) 
76         public
77     {
78         require(_percent > 0 && _percent < 100);
79         
80         address _pusher = msg.sender;
81         uint256 _bal = address(this).balance;
82         
83         // setup _stop.  this will be used to tell the loop to stop
84         uint256 _stop = (_bal * (100 - _percent)) / 100;
85         
86         // buy & sell    
87         Exchange_.buy.value(_bal)(fund_);
88         Exchange_.sell(Exchange_.balanceOf(address(this)));
89         
90         // setup tracker.  this will be used to tell the loop to stop
91         uint256 _tracker = Exchange_.dividendsOf(address(this));
92 
93         // reinvest/sell loop
94         while (_tracker >= _stop) 
95         {
96             // lets burn some tokens to distribute dividends to THC hodlers
97             Exchange_.reinvest();
98             Exchange_.sell(Exchange_.balanceOf(address(this)));
99             
100             // update our tracker with estimates (yea. not perfect, but cheaper on gas)
101             _tracker = (_tracker * 64) / 100;
102         }
103         
104         // withdraw
105         Exchange_.withdraw();
106         
107         // fire event
108         emit onDistribute(_pusher, _percent, _bal, address(this).balance);
109     }
110 }