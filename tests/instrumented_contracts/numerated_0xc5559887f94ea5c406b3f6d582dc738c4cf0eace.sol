1 pragma solidity ^0.4.15;
2 
3 contract ETHLotteryManagerInterface {
4     function register();
5 }
6 
7 contract ETHLotteryInterface {
8     function accumulate();
9 }
10 
11 contract ETHLottery {
12     bytes32 public name = 'ETHLottery - Last 1 Byte Lottery';
13     address public manager_address;
14     address public owner;
15     bool public open;
16     uint256 public jackpot;
17     uint256 public fee;
18     uint256 public owner_fee;
19     uint256 public create_block;
20     uint256 public result_block;
21     uint256 public winners_count;
22     bytes32 public result_hash;
23     bytes1 public result;
24     address public accumulated_from;
25     address public accumulate_to;
26 
27     mapping (bytes1 => address[]) bettings;
28     mapping (address => uint256) credits;
29 
30     event Balance(uint256 _balance);
31     event Result(bytes1 _result);
32     event Open(bool _open);
33     event Play(address indexed _sender, bytes1 _byte, uint256 _time);
34     event Withdraw(address indexed _sender, uint256 _amount, uint256 _time);
35     event Destroy();
36     event Accumulate(address _accumulate_to, uint256 _amount);
37 
38     function ETHLottery(address _manager, uint256 _fee, uint256 _jackpot, uint256 _owner_fee, address _accumulated_from) {
39         owner = msg.sender;
40         open = true;
41         create_block = block.number;
42         manager_address = _manager;
43         fee = _fee;
44         jackpot = _jackpot;
45         owner_fee = _owner_fee;
46         // accumulate
47         if (_accumulated_from != owner) {
48             accumulated_from = _accumulated_from;
49             ETHLotteryInterface lottery = ETHLotteryInterface(accumulated_from);
50             lottery.accumulate();
51         }
52         // register with manager
53         ETHLotteryManagerInterface manager = ETHLotteryManagerInterface(manager_address);
54         manager.register();
55         Open(open);
56     }
57 
58     modifier isOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     modifier isOriginalOwner() {
64         // used tx.origin on purpose instead of
65         // msg.sender, as we want to get the original
66         // starter of the transaction to be owner
67         require(tx.origin == owner);
68         _;
69     }
70 
71     modifier isOpen() {
72         require(open);
73         _;
74     }
75 
76     modifier isClosed() {
77         require(!open);
78         _;
79     }
80 
81     modifier isPaid() {
82         require(msg.value >= fee);
83         _;
84     }
85 
86     modifier hasPrize() {
87         require(credits[msg.sender] > 0);
88         _;
89     }
90 
91     modifier isAccumulated() {
92         require(result_hash != 0 && winners_count == 0);
93         _;
94     }
95 
96     modifier hasResultHash() {
97         require(
98             block.number >= result_block &&
99             block.number <= result_block + 256 &&
100             block.blockhash(result_block) != result_hash
101             );
102         _;
103     }
104 
105     function play(bytes1 _byte) payable isOpen isPaid returns (bool) {
106         bettings[_byte].push(msg.sender);
107         if (this.balance >= jackpot) {
108             uint256 owner_fee_amount = (this.balance * owner_fee) / 100;
109             // this is the transaction which
110             // will generate the block used
111             // to count until the 10th in order
112             // to get the lottery result.
113             if (!owner.send(owner_fee_amount)) {
114                 return false;
115             }
116             open = false;
117             // block offset hardcoded to 10
118             result_block = block.number + 10;
119             Open(open);
120         }
121         Balance(this.balance);
122         Play(msg.sender, _byte, now);
123         return true;
124     }
125 
126     // This method is only used if we miss the 256th block
127     // containing the result hash, lottery() should be used instead
128     // this method as this is duplicated from lottery()
129     function manual_lottery(bytes32 _result_hash) isClosed isOwner {
130         result_hash = _result_hash;
131         result = result_hash[31];
132         address[] storage winners = bettings[result];
133         winners_count = winners.length;
134         if (winners_count > 0) {
135             uint256 credit = this.balance / winners_count;
136             for (uint256 i = 0; i < winners_count; i++) {
137                 credits[winners[i]] = credit;
138             }
139         }
140         Result(result);
141     }
142 
143     function lottery() isClosed hasResultHash isOwner {
144         result_hash = block.blockhash(result_block);
145         // get last byte (31st) from block hash as result
146         result = result_hash[31];
147         address[] storage winners = bettings[result];
148         winners_count = winners.length;
149         if (winners_count > 0) {
150             uint256 credit = this.balance / winners_count;
151             for (uint256 i = 0; i < winners_count; i++) {
152                 credits[winners[i]] = credit;
153             }
154         }
155         Result(result);
156     }
157 
158     function withdraw() isClosed hasPrize returns (bool) {
159         uint256 credit = credits[msg.sender];
160         // zero credit before send preventing re-entrancy
161         // as msg.sender can be a contract and call us back
162         credits[msg.sender] = 0;
163         if (!msg.sender.send(credit)) {
164             // transfer failed, return credit for withdraw
165             credits[msg.sender] = credit;
166             return false;
167         }
168         Withdraw(msg.sender, credit, now);
169         return true;
170     }
171 
172     function accumulate() isOriginalOwner isClosed isAccumulated {
173         accumulate_to = msg.sender;
174         if (msg.sender.send(this.balance)) {
175             Accumulate(msg.sender, this.balance);
176         }
177     }
178 
179     function destruct() isClosed isOwner {
180         Destroy();
181         selfdestruct(owner);
182     }
183 }