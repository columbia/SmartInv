1 contract NameRegister {
2   function addr(bytes32 _name) constant returns (address o_owner) {}
3   function name(address _owner) constant returns (bytes32 o_name) {}
4 }
5 contract Registrar is NameRegister {
6   event Changed(bytes32 indexed name);
7   event PrimaryChanged(bytes32 indexed name, address indexed addr);
8   function owner(bytes32 _name) constant returns (address o_owner) {}
9   function addr(bytes32 _name) constant returns (address o_address) {}
10   function subRegistrar(bytes32 _name) constant returns (address o_subRegistrar) {}
11   function content(bytes32 _name) constant returns (bytes32 o_content) {}
12   function name(address _owner) constant returns (bytes32 o_name) {}
13 }
14 
15 contract GlobalRegistrar is Registrar {
16   struct Record {
17     address owner;
18     address primary;
19     address subRegistrar;
20     bytes32 content;
21     uint value;
22     uint renewalDate;
23   }
24   function Registrar() {
25     // TODO: Populate with hall-of-fame.
26   }
27   function reserve(bytes32 _name) {
28     // Don't allow the same name to be overwritten.
29     // TODO: bidding mechanism
30     if (m_toRecord[_name].owner == 0) {
31       m_toRecord[_name].owner = msg.sender;
32       Changed(_name);
33     }
34   }
35   /*
36   TODO
37   > 12 chars: free
38   <= 12 chars: auction:
39   1. new names are auctioned
40   - 7 day period to collect all bid bytes32es + deposits
41   - 1 day period to collect all bids to be considered (validity requires associated deposit to be >10% of bid)
42   - all valid bids are burnt except highest - difference between that and second highest is returned to winner
43   2. remember when last auctioned/renewed
44   3. anyone can force renewal process:
45   - 7 day period to collect all bid bytes32es + deposits
46   - 1 day period to collect all bids & full amounts - bids only uncovered if sufficiently high.
47   - 1% of winner burnt; original owner paid rest.
48   */
49   modifier onlyrecordowner(bytes32 _name) { if (m_toRecord[_name].owner == msg.sender) _ }
50   function transfer(bytes32 _name, address _newOwner) onlyrecordowner(_name) {
51     m_toRecord[_name].owner = _newOwner;
52     Changed(_name);
53   }
54   function disown(bytes32 _name) onlyrecordowner(_name) {
55     if (m_toName[m_toRecord[_name].primary] == _name)
56     {
57       PrimaryChanged(_name, m_toRecord[_name].primary);
58       m_toName[m_toRecord[_name].primary] = "";
59     }
60     delete m_toRecord[_name];
61     Changed(_name);
62   }
63   function setAddress(bytes32 _name, address _a, bool _primary) onlyrecordowner(_name) {
64     m_toRecord[_name].primary = _a;
65     if (_primary)
66     {
67       PrimaryChanged(_name, _a);
68       m_toName[_a] = _name;
69     }
70     Changed(_name);
71   }
72   function setSubRegistrar(bytes32 _name, address _registrar) onlyrecordowner(_name) {
73     m_toRecord[_name].subRegistrar = _registrar;
74     Changed(_name);
75   }
76   function setContent(bytes32 _name, bytes32 _content) onlyrecordowner(_name) {
77     m_toRecord[_name].content = _content;
78     Changed(_name);
79   }
80   function owner(bytes32 _name) constant returns (address) { return m_toRecord[_name].owner; }
81   function addr(bytes32 _name) constant returns (address) { return m_toRecord[_name].primary; }
82 //  function subRegistrar(bytes32 _name) constant returns (address) { return m_toRecord[_name].subRegistrar; } // TODO: bring in on next iteration.
83   function register(bytes32 _name) constant returns (address) { return m_toRecord[_name].subRegistrar; }  // only possible for now
84   function content(bytes32 _name) constant returns (bytes32) { return m_toRecord[_name].content; }
85   function name(address _owner) constant returns (bytes32 o_name) { return m_toName[_owner]; }
86   mapping (address => bytes32) m_toName;
87   mapping (bytes32 => Record) m_toRecord;
88 }