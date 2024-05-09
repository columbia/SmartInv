1 // File: contracts/Set.sol
2 
3 pragma solidity ^0.5.0;
4 
5 library Set {
6     // We define a new struct datatype that will be used to
7     // hold its data in the calling contract.
8     struct Data { 
9         mapping(address => bool) flags;
10     }
11 
12     // Note that the first parameter is of type "storage
13     // reference" and thus only its storage address and not
14     // its contents is passed as part of the call.  This is a
15     // special feature of library functions.  It is idiomatic
16     // to call the first parameter `self`, if the function can
17     // be seen as a method of that object.
18     function insert(Data storage self, address value)
19         public
20         returns (bool)
21     {
22         if (self.flags[value])
23             return false; // already there
24         self.flags[value] = true;
25         return true;
26     }
27 
28     function remove(Data storage self, address value)
29         public
30         returns (bool)
31     {
32         if (!self.flags[value])
33             return false; // not there
34         self.flags[value] = false;
35         return true;
36     }
37 
38     function contains(Data storage self, address value)
39         public
40         view
41         returns (bool)
42     {
43         return self.flags[value];
44     }
45 }
46 
47 // File: contracts/Crowdsourcing.sol
48 
49 pragma solidity ^0.5.0;
50 
51 
52 contract Crowdsourcing {
53     address public _owner;
54     string task;
55     uint private _total;
56     uint private _amount;
57     string private _content;
58     uint private _current  = 0;
59     address[] private workersArr;
60     uint private workerCount;
61     mapping(address => bool) public paid;
62     mapping(address => string) private answers;
63     Set.Data workers;
64     
65     event toVerification (
66         address indexed id
67     );
68     
69     event rejection (
70         address indexed rejected
71     );
72     
73     constructor(address owner, uint total, string memory content, uint money) public payable{
74         require(money % total == 0);
75         _owner = owner;
76         _total = total;
77         _amount = money;
78         _content = content;
79 
80     }
81     
82     function getTotal() public view returns (uint) {
83         return _total;
84     }
85     
86     function getAmount() public view returns (uint) {
87         return _amount;
88     }
89     
90     function getContent() public view returns (string memory) {
91         return _content;
92     }
93 
94     function isPaying() public view returns (bool) {
95         return _current  < _total;
96     }
97     
98     function getAnswers(address f) public view returns (string memory) {
99         require (msg.sender == _owner);
100         return answers[f];
101     }
102     
103     function addMoney() public payable {
104         require((msg.value + _amount) % _total == 0);
105         _amount += msg.value;
106     }
107     
108     // fallback function
109     function() external payable { }
110     
111     function stop() public {
112         require (msg.sender == _owner);
113         selfdestruct(msg.sender);
114     }
115     
116     function accept(address payable target) public payable {
117         require(msg.sender == _owner);
118         require(!paid[target]);
119         require(Set.contains(workers, target));
120         require(_current  < _total);
121         paid[target] = true;
122         _current ++;
123         target.transfer(_amount / _total);
124     }
125     
126     function reject(address payable target) public payable {
127         require(msg.sender == _owner);
128         require(!paid[target]);
129         require(Set.contains(workers, target));
130         require(_current  < _total);
131         emit rejection(target);
132         answers[target] = '';
133     }
134     
135     function answer(string calldata ans) external {
136         answers[msg.sender] = ans;
137         workersArr.push(msg.sender);
138         if (Set.insert(workers, msg.sender))
139         {
140             workerCount++;
141         }
142         emit toVerification(msg.sender);
143     }
144 
145     function getWorkers(uint number) public view returns (address) {
146         require(msg.sender == _owner);
147         require(number < workerCount);
148         return workersArr[number];
149     }
150 
151     function getNumberOfWorkers() public view returns (uint) {
152         require(msg.sender == _owner);
153         return workerCount;
154     }
155 
156     function isPaid(address a) public view returns (bool) {
157         return paid[a];
158     }
159     
160     function myPay() public view returns (bool) {
161         return paid[msg.sender];
162     }
163     
164     function myAnswer() public view returns (string memory) {
165         if (bytes(answers[msg.sender]).length == 0) return "";
166         return answers[msg.sender];
167     }
168 }
169 
170 // File: contracts/CrdSet-dev.sol
171 
172 pragma solidity ^0.5.0;
173 
174 
175 contract CrdSet {
176     Crowdsourcing[] public list;
177     event newContract(Crowdsourcing indexed c);
178 
179     function createCC(uint total, string memory content) public payable returns (Crowdsourcing){
180         require(msg.value % total == 0, "Amount of money need to be dividable by the total number of answers");
181         Crowdsourcing a = new Crowdsourcing(msg.sender, total, content, msg.value);
182         list.push(a);
183         address(a).transfer(msg.value);
184         emit newContract(a);
185         return a;
186     }
187     
188     function getContracCount() public view returns (uint) {
189         return list.length;
190     }
191     
192 }