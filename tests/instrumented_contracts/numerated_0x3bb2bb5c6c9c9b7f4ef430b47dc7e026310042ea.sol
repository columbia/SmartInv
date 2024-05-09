1 //! Registry contract.
2 //! By Gav Wood (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 // From Owned.sol
6 contract Owned {
7     modifier only_owner { if (msg.sender != owner) return; _ }
8     
9     event NewOwner(address indexed old, address indexed current);
10     
11     function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
12     
13     address public owner = msg.sender;
14 }
15 
16 contract Registry is Owned {
17     struct Entry {
18         address owner;
19         address reverse;
20         mapping (string => bytes32) data;
21     }
22     
23     event Drained(uint amount);
24     event FeeChanged(uint amount);
25     event Reserved(bytes32 indexed name, address indexed owner);
26     event Transferred(bytes32 indexed name, address indexed oldOwner, address indexed newOwner);
27     event Dropped(bytes32 indexed name, address indexed owner);
28     event DataChanged(bytes32 indexed name, address indexed owner, string indexed key, string plainKey);
29     event ReverseProposed(string indexed name, address indexed reverse);
30     event ReverseConfirmed(string indexed name, address indexed reverse);
31     event ReverseRemoved(string indexed name, address indexed reverse);
32 
33     modifier when_unreserved(bytes32 _name) { if (entries[_name].owner != 0) return; _ }
34     modifier only_owner_of(bytes32 _name) { if (entries[_name].owner != msg.sender) return; _ }
35     modifier when_proposed(string _name) { if (entries[sha3(_name)].reverse != msg.sender) return; _ }
36     modifier when_fee_paid { if (msg.value < fee) return; _ }
37 
38     function reserve(bytes32 _name) when_unreserved(_name) when_fee_paid returns (bool success) {
39         entries[_name].owner = msg.sender;
40         Reserved(_name, msg.sender);
41         return true;
42     }
43     function transfer(bytes32 _name, address _to) only_owner_of(_name) returns (bool success) {
44         entries[_name].owner = _to;
45         Transferred(_name, msg.sender, _to);
46         return true;
47     }
48     function drop(bytes32 _name) only_owner_of(_name) returns (bool success) {
49         delete entries[_name];
50         Dropped(_name, msg.sender);
51         return true;
52     }
53     
54     function set(bytes32 _name, string _key, bytes32 _value) only_owner_of(_name) returns (bool success) {
55         entries[_name].data[_key] = _value;
56         DataChanged(_name, msg.sender, _key, _key);
57         return true;
58     }
59     function setAddress(bytes32 _name, string _key, address _value) only_owner_of(_name) returns (bool success) {
60         entries[_name].data[_key] = bytes32(_value);
61         DataChanged(_name, msg.sender, _key, _key);
62         return true;
63     }
64     function setUint(bytes32 _name, string _key, uint _value) only_owner_of(_name) returns (bool success) {
65         entries[_name].data[_key] = bytes32(_value);
66         DataChanged(_name, msg.sender, _key, _key);
67         return true;
68     }
69     
70     function reserved(bytes32 _name) constant returns (bool reserved) {
71         return entries[_name].owner != 0;
72     } 
73     function get
74     (bytes32 _name, string _key) constant returns (bytes32) {
75         return entries[_name].data[_key];
76     }
77     function getAddress(bytes32 _name, string _key) constant returns (address) {
78         return address(entries[_name].data[_key]);
79     }
80     function getUint(bytes32 _name, string _key) constant returns (uint) {
81         return uint(entries[_name].data[_key]);
82     }
83     
84     function proposeReverse(string _name, address _who) only_owner_of(sha3(_name)) returns (bool success) {
85         var sha3Name = sha3(_name);
86         if (entries[sha3Name].reverse != 0 && sha3(reverse[entries[sha3Name].reverse]) == sha3Name) {
87             delete reverse[entries[sha3Name].reverse];
88             ReverseRemoved(_name, entries[sha3Name].reverse);
89         }
90         entries[sha3Name].reverse = _who;
91         ReverseProposed(_name, _who);
92         return true;
93     }
94     
95     function confirmReverse(string _name) when_proposed(_name) returns (bool success) {
96         reverse[msg.sender] = _name;
97         ReverseConfirmed(_name, msg.sender);
98         return true;
99     }
100     
101     function removeReverse() {
102         ReverseRemoved(reverse[msg.sender], msg.sender);
103         delete entries[sha3(reverse[msg.sender])].reverse;
104         delete reverse[msg.sender];
105     }
106     
107     function setFee(uint _amount) only_owner {
108         fee = _amount;
109         FeeChanged(_amount);
110     }
111     
112     function drain() only_owner {
113         Drained(this.balance);
114         if (!msg.sender.send(this.balance)) throw;
115     }
116     
117     mapping (bytes32 => Entry) entries;
118     mapping (address => string) public reverse;
119     
120     uint public fee = 1 ether;
121 }