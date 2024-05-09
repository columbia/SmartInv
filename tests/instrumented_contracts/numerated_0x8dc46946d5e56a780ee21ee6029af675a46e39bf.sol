1 pragma solidity ^0.4.13;
2 
3 contract EthereumLottery {
4     function admin() constant returns (address);
5     function needsInitialization() constant returns (bool);
6     function initLottery(uint _jackpot, uint _numTickets,
7                          uint _ticketPrice, int _durationInBlocks) payable;
8     function needsFinalization() constant returns (bool);
9     function finalizeLottery(uint _steps);
10 }
11 
12 contract LotteryAdmin {
13     address public owner;
14     address public admin;
15     address public proposedOwner;
16 
17     address public ethereumLottery;
18 
19     event Deposit(address indexed _from, uint _value);
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     modifier onlyAdminOrOwner {
27         require(msg.sender == owner || msg.sender == admin);
28         _;
29     }
30 
31     function LotteryAdmin(address _ethereumLottery) {
32         owner = msg.sender;
33         admin = msg.sender;
34         ethereumLottery = _ethereumLottery;
35     }
36 
37     function () payable {
38         Deposit(msg.sender, msg.value);
39     }
40 
41     function needsAdministration() constant returns (bool) {
42         if (EthereumLottery(ethereumLottery).admin() != address(this)) {
43             return false;
44         }
45 
46         return EthereumLottery(ethereumLottery).needsFinalization();
47     }
48 
49     function administrate(uint _steps) {
50         EthereumLottery(ethereumLottery).finalizeLottery(_steps);
51     }
52 
53     function initLottery(uint _jackpot, uint _numTickets,
54                          uint _ticketPrice, int _durationInBlocks)
55              onlyAdminOrOwner {
56         EthereumLottery(ethereumLottery).initLottery.value(_jackpot)(
57             _jackpot, _numTickets, _ticketPrice, _durationInBlocks);
58     }
59 
60     function withdraw(uint _value) onlyOwner {
61         owner.transfer(_value);
62     }
63 
64     function setLottery(address _ethereumLottery) onlyOwner {
65         ethereumLottery = _ethereumLottery;
66     }
67 
68     function setAdmin(address _admin) onlyOwner {
69         admin = _admin;
70     }
71 
72     function proposeOwner(address _owner) onlyOwner {
73         proposedOwner = _owner;
74     }
75 
76     function acceptOwnership() {
77         require(proposedOwner != 0);
78         require(msg.sender == proposedOwner);
79         owner = proposedOwner;
80     }
81 
82     function destruct() onlyOwner {
83         selfdestruct(owner);
84     }
85 }