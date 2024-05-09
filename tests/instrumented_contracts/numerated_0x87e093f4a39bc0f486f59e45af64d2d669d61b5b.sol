1 contract TokenReg {
2     modifier only_owner { if (msg.sender != owner) return; _ }
3     event NewOwner(address indexed old, address indexed current);
4     function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
5     address public owner = msg.sender;
6     struct Token {
7         address addr;
8         string tla;
9         uint base;
10         string name;
11         address owner;
12         mapping (bytes32 => bytes32) meta;
13     }
14 
15     modifier when_fee_paid { if (msg.value < fee) return; _ }
16     modifier when_address_free(address _addr) { if (mapFromAddress[_addr] != 0) return; _ }
17     modifier when_tla_free(string _tla) { if (mapFromTLA[_tla] != 0) return; _ }
18     modifier when_is_tla(string _tla) { if (bytes(_tla).length != 3) return; _ }
19     modifier when_has_tla(string _tla) { if (mapFromTLA[_tla] == 0) return; _ }
20     modifier only_token_owner(uint _id) { if (tokens[_id].owner != msg.sender) return; _ }
21 
22     event Registered(string indexed tla, uint indexed id, address addr, string name);
23     event Unregistered(string indexed tla, uint indexed id);
24     event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
25 
26     function register(address _addr, string _tla, uint _base, string _name) returns (bool) {
27         return registerAs(_addr, _tla, _base, _name, msg.sender);
28     }
29 
30     function registerAs(address _addr, string _tla, uint _base, string _name, address _owner) when_fee_paid when_address_free(_addr) when_is_tla(_tla) when_tla_free(_tla) returns (bool) {
31         tokens.push(Token(_addr, _tla, _base, _name, _owner));
32         mapFromAddress[_addr] = tokens.length;
33         mapFromTLA[_tla] = tokens.length;
34         Registered(_tla, tokens.length - 1, _addr, _name);
35         return true;
36     }
37 
38     function unregister(uint _id) only_owner {
39         Unregistered(tokens[_id].tla, _id);
40         delete mapFromAddress[tokens[_id].addr];
41         delete mapFromTLA[tokens[_id].tla];
42         delete tokens[_id];
43     }
44 
45     function setFee(uint _fee) only_owner {
46         fee = _fee;
47     }
48 
49     function tokenCount() constant returns (uint) { return tokens.length; }
50     function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner) {
51         var t = tokens[_id];
52         addr = t.addr;
53         tla = t.tla;
54         base = t.base;
55         name = t.name;
56         owner = t.owner;
57     }
58 
59     function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner) {
60         id = mapFromAddress[_addr] - 1;
61         var t = tokens[id];
62         tla = t.tla;
63         base = t.base;
64         name = t.name;
65         owner = t.owner;
66     }
67 
68     function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner) {
69         id = mapFromTLA[_tla] - 1;
70         var t = tokens[id];
71         addr = t.addr;
72         base = t.base;
73         name = t.name;
74         owner = t.owner;
75     }
76 
77     function meta(uint _id, bytes32 _key) constant returns (bytes32) {
78         return tokens[_id].meta[_key];
79     }
80 
81     function setMeta(uint _id, bytes32 _key, bytes32 _value) only_token_owner(_id) {
82         tokens[_id].meta[_key] = _value;
83         MetaChanged(_id, _key, _value);
84     }
85 
86     function drain() only_owner {
87         if (!msg.sender.send(this.balance))
88             throw;
89     }
90 
91     mapping (address => uint) mapFromAddress;
92     mapping (string => uint) mapFromTLA;
93     Token[] tokens;
94     uint public fee = 1 ether;
95 }