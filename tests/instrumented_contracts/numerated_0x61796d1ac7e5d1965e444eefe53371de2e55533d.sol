1 pragma solidity ^0.4.25;
2 
3 contract Promise{
4     string public vow;
5     address public promisor;
6     address public beneficiary;
7     uint public deposit;
8     uint public endDate;
9     address[3] public judges;
10 
11     uint[3] public signedByJudge;
12     bool public signedByPromisor;
13 
14     uint[3] public votedFoul;
15     uint public foulVotes = 0;
16     uint[3] public votedShy;
17     uint public shyVotes = 0;
18     uint[3] public votedSuccess;
19     uint public successVotes = 0;
20 
21     bool public sentMoney = false;
22 
23     constructor(address _promisor, string _vow, uint _deposit, uint _endDate, address[3] _judges, address _beneficiary) public{
24         promisor = _promisor;
25         vow = _vow;
26         deposit = _deposit;
27         endDate = _endDate;
28         judges = _judges;
29         beneficiary = _beneficiary;
30     }
31 
32     function judgeSigns(uint _number) public{
33         require(msg.sender == judges[_number]);
34         signedByJudge[_number] = 1;
35     }
36 
37     function promisorSigns() payable public{
38         require(msg.sender == promisor);
39         require(signedByJudge[0] == 1);
40         require(signedByJudge[1] == 1);
41         require(signedByJudge[2] == 1);
42         require(!signedByPromisor);
43         require(msg.value == deposit);
44 
45         signedByPromisor = true;
46     }
47 
48     function voteFoul(uint _number) public{
49         require(signedByPromisor);
50         require(msg.sender == judges[_number]);
51         require(votedFoul[_number] != 1);
52         require(votedShy[_number] != 1);
53         require(votedSuccess[_number] != 1);
54 
55         foulVotes = foulVotes + 1;
56         votedFoul[_number] = 1;
57         if((foulVotes >= 2) && !sentMoney){
58           beneficiary.transfer(deposit);
59           sentMoney = true;
60         }
61     }
62 
63     function voteShyOfCondition(uint _number) public{
64         require(signedByPromisor);
65         require(msg.sender == judges[_number]);
66         require(votedShy[_number] != 1);
67         require(votedFoul[_number] != 1);
68 
69         shyVotes = shyVotes + 1;
70         votedShy[_number] = 1;
71         if((shyVotes >= 2) && !sentMoney){
72           promisor.transfer(deposit);
73           sentMoney = true;
74         }
75     }
76 
77     function voteSuccess(uint _number) public{
78         require(signedByPromisor);
79         require(msg.sender == judges[_number]);
80         require(votedSuccess[_number] != 1);
81         require(votedFoul[_number] != 1);
82 
83         successVotes = successVotes + 1;
84         votedSuccess[_number] = 1;
85         if((successVotes >= 2) && !sentMoney){
86           promisor.transfer(deposit);
87           sentMoney = true;
88         }
89     }
90 
91     function selfDestruct() public{
92       require(sentMoney);
93       require(now >= (endDate+432000));
94 
95       selfdestruct(msg.sender);
96     }
97 }