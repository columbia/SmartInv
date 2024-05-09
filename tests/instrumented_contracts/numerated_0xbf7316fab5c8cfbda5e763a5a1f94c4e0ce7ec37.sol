1 // A name registry in Ethereum
2 
3 // "Real" attempts to a name registry with Ethereum:
4 // <http://etherid.org/> <https://github.com/sinking-point/dns2/>
5 
6 // TODO: use the registry interface described in
7 // <https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs>?
8 
9 // Standard strings are poor, we need an extension library,
10 // github.com/Arachnid/solidity-stringutils/strings.sol TODO: use it as soon as https://github.com/Arachnid/solidity-stringutils/issues/1 is solved.
11 // import "strings.sol";
12 
13 contract Registry {
14 
15   // using strings for *; // TODO see above
16 
17   address public nic; // The Network Information Center
18   
19   struct Record {
20     string value; // IP addresses, emails, etc TODO accept an array
21 		     // as soon as we have a strings library to
22 		     // serialize/deserialize. TODO type the values with an Enum
23     address holder;
24     bool exists; // Or a more detailed state, with an enum?
25     uint idx;
26   }
27   mapping (string => Record) records;
28   mapping (uint => string) index;
29   
30   // TODO define accessors instead
31   uint public maxRecords;
32   uint public currentRecords;
33 
34   event debug(string indexed label, string msg);
35   event created(string indexed label, string indexed name, address holder, uint block);
36   event deleted(string indexed label, string indexed name, address holder, uint block);
37   
38   // "value" should be a comma-separated list of values. Solidity
39   // public functions cannot use arrays of strings :-( TODO: solve it
40   // when we'll have strings.
41   function register(string name, string value) {
42     /* TODO: pay the price */
43     uint i;
44     if (records[name].exists) {
45       if (msg.sender != records[name].holder) { // TODO: use modifiers instead
46 	throw;
47       }
48       else {
49 	i = records[name].idx;
50       }
51     }
52     else {
53       records[name].idx = maxRecords;
54       i = maxRecords;
55       maxRecords++;
56     }
57     records[name].value = value;
58     records[name].holder = msg.sender;
59     records[name].exists = true;
60     currentRecords++;
61     index[i] = name;
62     created("CREATION", name, msg.sender, block.number);	  
63   }
64 
65   function transfer(string name, address to) {
66     if (records[name].exists) {
67       if (msg.sender != records[name].holder) {
68 	throw;
69       }
70       records[name].holder = to;
71     }
72     else {
73       throw;
74     }
75   }
76   
77   function get(string name) constant returns(bool exists, string value) {
78     if (records[name].exists) {
79       exists = true;
80       value = records[name].value;
81     } else {
82       exists = false;
83     }
84   }
85 
86   // Constructor
87   function Registry() {
88     nic = msg.sender;
89     currentRecords = 0;
90     maxRecords = 0;
91     register("NIC", "Automatically created by for the registry"); // TODO may fail if not
92     // enough gas in the creating transaction?
93   }
94   
95 
96   function whois(string name) constant returns(bool exists, string value, address holder) {
97     if (records[name].exists) {
98       exists = true;
99       value = records[name].value;
100       holder = records[name].holder;
101     } else {
102       exists = false;
103     }
104   }
105 
106   function remove(string name) {
107     uint i;
108     if (records[name].exists) {
109       if (msg.sender != records[name].holder) {
110 	throw;
111       }
112       else {
113 	i = records[name].idx;
114       }
115     }
116     else {
117       throw; // 404. Too bad we cannot add content to throw.
118     }
119     records[name].exists = false;
120     currentRecords--;
121     deleted("DELETION", name, msg.sender, block.number);	  
122   }
123 
124   function download() returns(string all) {
125     if (msg.sender != nic) {
126 	throw;
127       }
128     all = "NOT YET IMPLEMENTED";
129     // Looping over all the records is easy:
130     //for uint (i = 0; i < maxRecords; i++) {
131     //	if (records[index[i]].exists) {
132     
133     // Or we could use an iterable mapping may
134     // be this library
135     // <https://github.com/ethereum/dapp-bin/blob/master/library/iterable_mapping.sol>
136 
137     // The difficult part is to construct an answer, since Solidity
138     // does not provide string concatenation, or the ability to return
139     // arrays.
140 
141 	// TODO: provide a function to access one item, using its index,
142 	// and to let the caller loops from 0 to maxRecords
143 	// http://stackoverflow.com/questions/37606839/how-to-return-mapping-list-in-solidity-ethereum-contract/37643972#37643972
144   }
145   
146 }