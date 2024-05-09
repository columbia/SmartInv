1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7         return c;
8     }
9     function sub(uint a, uint b) internal pure returns (uint) {
10         require(b <= a);
11         return a - b;
12     }
13 }
14 
15 contract AtomicSwap {
16     using SafeMath for uint;
17 
18     enum State { Empty, Initiated, Redeemed, Refunded }
19 
20     struct Swap {
21         bytes32 hashedSecret;
22         bytes32 secret;
23         address payable initiator;
24         address payable participant;
25         uint refundTimestamp;
26         uint value;
27         uint payoff;
28         State state;
29     }
30 
31     event Initiated(
32         bytes32 indexed _hashedSecret,
33         address indexed _participant,
34         address _initiator,
35         uint _refundTimestamp,
36         uint _value,
37         uint _payoff
38     );
39     
40     event Added(
41         bytes32 indexed _hashedSecret,
42         address _sender,
43         uint _value
44     );
45     
46     event Redeemed(
47         bytes32 indexed _hashedSecret,
48         bytes32 _secret
49     );
50     
51     event Refunded(
52         bytes32 indexed _hashedSecret
53     );
54     
55     mapping(bytes32 => Swap) public swaps;
56 
57     modifier isRefundable(bytes32 _hashedSecret) {
58         require(block.timestamp >= swaps[_hashedSecret].refundTimestamp);
59         _;
60     }
61     
62     modifier isRedeemable(bytes32 _hashedSecret, bytes32 _secret) {
63         require(block.timestamp < swaps[_hashedSecret].refundTimestamp);
64         require(sha256(abi.encodePacked(sha256(abi.encodePacked(_secret)))) == _hashedSecret);
65         _;
66     }
67     
68     modifier isInitiated(bytes32 _hashedSecret) {
69         require(swaps[_hashedSecret].state == State.Initiated);
70         _;
71     }
72     
73     modifier isInitiatable(bytes32 _hashedSecret, uint _refundTimestamp) {
74         require(swaps[_hashedSecret].state == State.Empty);
75         require(_refundTimestamp > block.timestamp);
76         _;
77     }
78 
79     modifier isAddable(bytes32 _hashedSecret) {
80         require(block.timestamp <= swaps[_hashedSecret].refundTimestamp);
81         _;
82     }
83 
84     function add (bytes32 _hashedSecret)
85         public payable isInitiated(_hashedSecret) isAddable(_hashedSecret)    
86     {
87         swaps[_hashedSecret].value = swaps[_hashedSecret].value.add(msg.value);
88 
89         emit Added(
90             _hashedSecret,
91             msg.sender,
92             swaps[_hashedSecret].value
93         );
94     }
95 
96     function initiate (bytes32 _hashedSecret, address payable _participant, uint _refundTimestamp, uint _payoff)
97         public payable isInitiatable(_hashedSecret, _refundTimestamp)    
98     {
99         swaps[_hashedSecret].value = msg.value.sub(_payoff);
100         swaps[_hashedSecret].hashedSecret = _hashedSecret;
101         swaps[_hashedSecret].initiator = msg.sender;
102         swaps[_hashedSecret].participant = _participant;
103         swaps[_hashedSecret].refundTimestamp = _refundTimestamp;
104         swaps[_hashedSecret].payoff = _payoff;
105         swaps[_hashedSecret].state = State.Initiated;
106 
107         emit Initiated(
108             _hashedSecret,
109             swaps[_hashedSecret].participant,
110             msg.sender,
111             swaps[_hashedSecret].refundTimestamp,
112             swaps[_hashedSecret].value,
113             swaps[_hashedSecret].payoff
114         );
115     }
116 
117     function refund(bytes32 _hashedSecret)
118         public isInitiated(_hashedSecret) isRefundable(_hashedSecret) 
119     {
120         swaps[_hashedSecret].state = State.Refunded;
121 
122         emit Refunded(
123             _hashedSecret
124         );
125 
126         swaps[_hashedSecret].initiator.transfer(swaps[_hashedSecret].value.add(swaps[_hashedSecret].payoff));
127         
128         delete swaps[_hashedSecret];
129     }
130 
131     function redeem(bytes32 _hashedSecret, bytes32 _secret) 
132         public isInitiated(_hashedSecret) isRedeemable(_hashedSecret, _secret)
133     {
134         swaps[_hashedSecret].secret = _secret;
135         swaps[_hashedSecret].state = State.Redeemed;
136         
137         emit Redeemed(
138             _hashedSecret,
139             _secret
140         );
141 
142         swaps[_hashedSecret].participant.transfer(swaps[_hashedSecret].value);
143         if (swaps[_hashedSecret].payoff > 0) {
144             msg.sender.transfer(swaps[_hashedSecret].payoff);
145         }
146         
147         delete swaps[_hashedSecret];
148     }
149 }