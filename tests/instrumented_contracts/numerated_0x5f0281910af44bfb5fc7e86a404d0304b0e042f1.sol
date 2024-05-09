1 //! Token Registry contract.
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
16 contract TokenReg is Owned {
17     struct Token {
18         address addr;
19         string tla;
20         uint base;
21         string name;
22         address owner;
23         mapping (bytes32 => bytes32) meta;
24     }
25 
26     modifier when_fee_paid { if (msg.value < fee) return; _ }
27     modifier when_address_free(address _addr) { if (mapFromAddress[_addr] != 0) return; _ }
28     modifier when_tla_free(string _tla) { if (mapFromTLA[_tla] != 0) return; _ }
29     modifier when_is_tla(string _tla) { if (bytes(_tla).length != 3) return; _ }
30     modifier when_has_tla(string _tla) { if (mapFromTLA[_tla] == 0) return; _ }
31     modifier only_token_owner(uint _id) { if (tokens[_id].owner != msg.sender) return; _ }
32 
33     event Registered(string indexed tla, uint indexed id, address addr, string name);
34     event Unregistered(string indexed tla, uint indexed id);
35     event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
36 
37     function register(address _addr, string _tla, uint _base, string _name) returns (bool) {
38         return registerAs(_addr, _tla, _base, _name, msg.sender);
39     }
40 
41     function registerAs(address _addr, string _tla, uint _base, string _name, address _owner) when_fee_paid when_address_free(_addr) when_is_tla(_tla) when_tla_free(_tla) returns (bool) {
42         tokens.push(Token(_addr, _tla, _base, _name, _owner));
43         mapFromAddress[_addr] = tokens.length;
44         mapFromTLA[_tla] = tokens.length;
45         Registered(_tla, tokens.length - 1, _addr, _name);
46         return true;
47     }
48 
49     function unregister(uint _id) only_owner {
50         Unregistered(tokens[_id].tla, _id);
51         delete mapFromAddress[tokens[_id].addr];
52         delete mapFromTLA[tokens[_id].tla];
53         delete tokens[_id];
54     }
55 
56     function setFee(uint _fee) only_owner {
57         fee = _fee;
58     }
59 
60     function tokenCount() constant returns (uint) { return tokens.length; }
61     function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner) {
62         var t = tokens[_id];
63         addr = t.addr;
64         tla = t.tla;
65         base = t.base;
66         name = t.name;
67         owner = t.owner;
68     }
69 
70     function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner) {
71         id = mapFromAddress[_addr] - 1;
72         var t = tokens[id];
73         tla = t.tla;
74         base = t.base;
75         name = t.name;
76         owner = t.owner;
77     }
78 
79     function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner) {
80         id = mapFromTLA[_tla] - 1;
81         var t = tokens[id];
82         addr = t.addr;
83         base = t.base;
84         name = t.name;
85         owner = t.owner;
86     }
87 
88     function meta(uint _id, bytes32 _key) constant returns (bytes32) {
89         return tokens[_id].meta[_key];
90     }
91 
92     function setMeta(uint _id, bytes32 _key, bytes32 _value) only_token_owner(_id) {
93         tokens[_id].meta[_key] = _value;
94         MetaChanged(_id, _key, _value);
95     }
96 
97     function drain() only_owner {
98         if (!msg.sender.send(this.balance))
99             throw;
100     }
101 
102     mapping (address => uint) mapFromAddress;
103     mapping (string => uint) mapFromTLA;
104     Token[] tokens;
105     uint public fee = 1 ether;
106 }