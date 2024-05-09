1 contract tablet_factory {
2     
3     address private tablet_factory_owner;
4     
5     address[] public creators;
6     
7     struct tablet_struct {
8         bytes32 tablet_name;
9         address tablet_address;
10     }
11     
12     mapping(address => tablet_struct[]) public tablets;
13     
14     
15     function tablet_factory() public {
16         tablet_factory_owner = msg.sender;
17     }
18 
19     function create_tablet(bytes32 new_tablet_name) public payable returns (address) {
20         if (!is_creator(msg.sender)) {creators.push(msg.sender);}
21         address new_tablet_address = new tablet(new_tablet_name, msg.sender);
22         tablets[msg.sender].push(tablet_struct(new_tablet_name, new_tablet_address));
23         return new_tablet_address;
24     }
25     
26     function withdraw(uint amount) external {
27         require(msg.sender == tablet_factory_owner);
28         msg.sender.transfer(amount);
29     }
30     
31     
32     function is_creator(address creator_address) public constant returns(bool) {
33         return tablets[creator_address].length > 0;
34     }
35     
36     function creator_tablets_count(address creator_address) public constant returns(uint) {
37         return tablets[creator_address].length;
38     }
39     
40     function creators_count() public constant returns(uint) {
41         return creators.length;
42     }
43     
44 }
45 
46 contract tablet {
47     
48     bytes32 public this_tablet_name;
49     address public tablet_owner;
50     
51     string[] public records;
52     
53     mapping(address => bool) public scribes;
54     address[] public scribes_hisory;
55     
56     event new_tablet_created(address indexed tablet_creator, bytes32 tablet_name, address tablet_address);
57     event new_record(address indexed tablet_address, address indexed scribe, uint record_nubmer);
58     
59     function tablet(bytes32 tablet_name, address tablet_creator) public {
60         if (tablet_creator == 0) {tablet_creator = msg.sender;}
61         tablet_owner = tablet_creator;
62         this_tablet_name = tablet_name;
63         scribes[tablet_owner] = true;
64         scribes_hisory.push(tablet_owner);
65         new_tablet_created(tablet_creator, tablet_name, this);
66     }
67 
68     function add_scribe(address scribe) public {
69         require(tablet_owner == msg.sender);
70         require(scribes[scribe] = false);
71         scribes[scribe] = true;
72         scribes_hisory.push(scribe);
73     }
74     
75     function remove_scribe(address scribe) public {
76         require(tablet_owner == msg.sender);
77         scribes[scribe] = false;
78     }
79     
80     function change_owner(address new_owner) public {
81         require(tablet_owner == msg.sender);
82         tablet_owner = new_owner;
83     }
84         
85     function add_record(string record) public {
86         require(scribes[msg.sender]);
87         // require(bytes(record).length <= 2048); Lets decide this on the client side, limit could be higher later
88         new_record(this, msg.sender, records.push(record));
89     }
90     
91     function tablet_length() public constant returns (uint256) {
92         return records.length;
93     }
94     
95     function scribes_hisory_length() public constant returns (uint256) {
96         return scribes_hisory.length;
97     }
98 }