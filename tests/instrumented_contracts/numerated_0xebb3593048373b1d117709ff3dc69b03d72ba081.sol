1 pragma solidity ^0.4.20;
2 
3 /*
4  * @FadyAro 15 Aug 2018
5  *
6  * Private Personal Bet
7  */
8 contract PrivateBet {
9 
10     /*
11      * subscription event
12      */ 
13     event NewBet(address indexed _address);
14     
15     /*
16      * subscription status
17      */ 
18     uint8 private paused = 0;
19 
20     /*
21      * subscription price
22      */ 
23     uint private price;
24     
25     /*
26      * subscription code
27      */ 
28     bytes16 private name;
29     
30     /*
31      * contract owner
32      */ 
33     address private owner;
34 
35     /*
36      * subscribed users
37      */ 
38     address[] public users;
39     
40     /*
41      * bet parameters
42      */
43     constructor(bytes16 _name, uint _price) public {
44         owner = msg.sender;
45         name = _name;
46         price = _price;
47     }
48     
49     /*
50      * fallback subscription logic
51      */
52     function() public payable {
53         
54         /*
55          * only when contract is active
56          */
57         require(paused == 0, 'paused');
58         
59         /*
60          * smart contracts are not allowed to participate
61          */
62         require(tx.origin == msg.sender, 'not allowed');
63         
64         /*
65          * only when contract is active
66          */
67         require(msg.value >= price, 'low amount');
68 
69         /*
70          * subscribe the user
71          */
72         users.push(msg.sender);
73         
74         /*
75          * log the event
76          */
77         emit NewBet(msg.sender);
78          
79          /*
80           * collect the ETH
81           */
82         owner.transfer(msg.value);
83     }
84     
85     /*
86      * bet details
87      */
88     function details() public view returns (
89         address _owner
90         , bytes16 _name 
91         , uint _price 
92         , uint _total
93         , uint _paused
94         ) {
95         return (
96             owner
97             , name
98             , price
99             , users.length
100             , paused
101         );
102     }
103     
104     /*
105      * pause the subscriptions
106      */
107     function pause() public {
108         
109         require(msg.sender == owner, 'not allowed');
110         
111         paused = 1;
112     }
113 }