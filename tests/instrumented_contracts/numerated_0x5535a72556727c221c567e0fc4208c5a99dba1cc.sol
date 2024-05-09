1 pragma solidity 0.4.14;
2 
3 // -----------------------------------------------------------------------------
4 // PembiCoin crowdsale contract.
5 // Copyright (c) 2017 Pembient, Inc.
6 // The MIT License.
7 // -----------------------------------------------------------------------------
8 
9 contract PembiCoinICO {
10 
11     enum State {Active, Idle, Successful, Failed}
12 
13     State public currentState = State.Idle;
14     uint256 public contributorCount = 0;
15 
16     address public owner;
17 
18     mapping(uint256 => address) private contributors;
19     mapping(address => uint256) private amounts;
20 
21     event Transferred(
22         address indexed _from,
23         address indexed _to,
24         uint256 _amount
25     );
26 
27     event Transitioned(
28         address indexed _subject,
29         address indexed _object,
30         State _oldState,
31         State _newState
32     );
33 
34     function PembiCoinICO() public {
35         owner = msg.sender;
36     }
37 
38     function() external payable inState(State.Active) {
39         require(msg.value > 0);
40         if (amounts[msg.sender] == 0) {
41             contributors[contributorCount] = msg.sender;
42             contributorCount = safeAdd(contributorCount, 1);
43         }
44         amounts[msg.sender] = safeAdd(amounts[msg.sender], msg.value);
45         Transferred(msg.sender, address(this), msg.value);
46     }
47 
48     function refund() external inState(State.Failed) {
49         uint256 amount = amounts[msg.sender];
50         assert(amount > 0 && amount <= this.balance);
51         amounts[msg.sender] = 0;
52         msg.sender.transfer(amount);
53         Transferred(address(this), msg.sender, amount);
54     }
55 
56     function payout() external inState(State.Successful) onlyOwner {
57         uint256 amount = this.balance;
58         owner.transfer(amount);
59         Transferred(address(this), owner, amount);
60     }
61 
62     function setActive() external inState(State.Idle) onlyOwner {
63         State oldState = currentState;
64         currentState = State.Active;
65         Transitioned(msg.sender, address(this), oldState, currentState);
66     }
67 
68     function setIdle() external inState(State.Active) onlyOwner {
69         State oldState = currentState;
70         currentState = State.Idle;
71         Transitioned(msg.sender, address(this), oldState, currentState);
72     }
73 
74     function setSuccessful() external inState(State.Idle) onlyOwner {
75         State oldState = currentState;
76         currentState = State.Successful;
77         Transitioned(msg.sender, address(this), oldState, currentState);
78     }
79 
80     function setFailed() external inState(State.Idle) onlyOwner {
81         State oldState = currentState;
82         currentState = State.Failed;
83         Transitioned(msg.sender, address(this), oldState, currentState);
84     }
85 
86     function getContribution(uint256 _i)
87         external
88         constant
89         returns (address o_contributor, uint256 o_amount)
90     {
91         require(_i >= 0 && _i < contributorCount);
92         o_contributor = contributors[_i];
93         o_amount = amounts[o_contributor];
94     }
95 
96     function safeAdd(uint256 a, uint256 b)
97         private
98         constant
99         returns (uint256 o_sum)
100     {
101         o_sum = a + b;
102         assert(o_sum >= a && o_sum >= b);
103     }
104 
105     modifier inState(State _state) {
106         require(_state == currentState);
107         _;
108     }
109 
110     modifier onlyOwner {
111         require(msg.sender == owner);
112         _;
113     }
114 }