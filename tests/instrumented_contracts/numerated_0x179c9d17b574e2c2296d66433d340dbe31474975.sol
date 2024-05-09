1 pragma solidity 0.4.15;
2 
3 /// @title SafeMath
4 /// @dev Math operations with safety checks that throw on error.
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /// @title Ownable
32 /// @dev The Ownable contract has an owner address, and provides basic authorization control
33 /// functions, this simplifies the implementation of "user permissions".
34 contract Ownable {
35 
36   // EVENTS
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40   // PUBLIC FUNCTIONS
41 
42   /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
43   function Ownable() {
44     owner = msg.sender;
45   }
46 
47   /// @dev Allows the current owner to transfer control of the contract to a newOwner.
48   /// @param newOwner The address to transfer ownership to.
49   function transferOwnership(address newOwner) onlyOwner public {
50     require(newOwner != address(0));
51     OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55   // MODIFIERS
56 
57   /// @dev Throws if called by any account other than the owner.
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   // FIELDS
64 
65   address public owner;
66 }
67 
68 
69 contract DaoOwnable is Ownable{
70 
71     address public dao = address(0);
72 
73     event DaoOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     /**
76      * @dev Throws if called by any account other than the dao.
77      */
78     modifier onlyDao() {
79         require(msg.sender == dao);
80         _;
81     }
82 
83     modifier onlyDaoOrOwner() {
84         require(msg.sender == dao || msg.sender == owner);
85         _;
86     }
87 
88 
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newDao.
91      * @param newDao The address to transfer ownership to.
92      */
93     function transferDao(address newDao) onlyOwner {
94         require(newDao != address(0));
95         dao = newDao;
96         DaoOwnershipTransferred(owner, newDao);
97     }
98 
99 }
100 
101 contract DepositRegistry {
102     // This is the function that actually insert a record.
103     function register(address key, uint256 amount, address depositOwner);
104 
105     // Unregister a given record
106     function unregister(address key);
107 
108     function transfer(address key, address newOwner, address sender);
109 
110     function spend(address key, uint256 amount);
111 
112     function refill(address key, uint256 amount);
113 
114     // Tells whether a given key is registered.
115     function isRegistered(address key) constant returns(bool);
116 
117     function getDepositOwner(address key) constant returns(address);
118 
119     function getDeposit(address key) constant returns(uint256 amount);
120 
121     function getDepositRecord(address key) constant returns(address owner, uint time, uint256 amount, address depositOwner);
122 
123     function hasEnough(address key, uint256 amount) constant returns(bool);
124 
125     function kill();
126 }
127 
128 contract DepositRegistryImpl is DepositRegistry, DaoOwnable {
129     using SafeMath for uint256;
130 
131     uint public creationTime = now;
132 
133     // This struct keeps all data for a Deposit.
134     struct Deposit {
135         // Keeps the address of this record creator.
136         address owner;
137         // Keeps the time when this record was created.
138         uint time;
139         // Keeps the index of the keys array for fast lookup
140         uint keysIndex;
141         // Deposit left
142         uint256 amount;
143     }
144 
145     // This mapping keeps the records of this Registry.
146     mapping(address => Deposit) records;
147 
148     // Keeps the total numbers of records in this Registry.
149     uint public numDeposits;
150 
151     // Keeps a list of all keys to interate the records.
152     address[] public keys;
153 
154     // This is the function that actually insert a record.
155     function register(address key, uint256 amount, address depositOwner) onlyDaoOrOwner {
156         require(records[key].time == 0);
157         records[key].time = now;
158         records[key].owner = depositOwner;
159         records[key].keysIndex = keys.length;
160         keys.length++;
161         keys[keys.length - 1] = key;
162         records[key].amount = amount;
163         numDeposits++;
164     }
165 
166     // Unregister a given record
167     function unregister(address key) onlyDaoOrOwner {
168         uint keysIndex = records[key].keysIndex;
169         delete records[key];
170         numDeposits--;
171         keys[keysIndex] = keys[keys.length - 1];
172         records[keys[keysIndex]].keysIndex = keysIndex;
173         keys.length--;
174     }
175 
176     // Transfer ownership of a given record.
177     function transfer(address key, address newOwner, address sender) onlyDaoOrOwner {
178         require(records[key].owner == sender);
179         records[key].owner = newOwner;
180     }
181 
182     // Tells whether a given key is registered.
183     function isRegistered(address key) constant returns(bool) {
184         return records[key].time != 0;
185     }
186 
187     function getDepositOwner(address key) constant returns (address) {
188         return records[key].owner;
189     }
190 
191     function getDeposit(address key) constant returns(uint256 amount) {
192         Deposit storage record = records[key];
193         amount = record.amount;
194     }
195 
196     function getDepositRecord(address key) constant returns(address owner, uint time, uint256 amount, address depositOwner) {
197         Deposit storage record = records[key];
198         owner = record.owner;
199         time = record.time;
200         amount = record.amount;
201         depositOwner = record.owner;
202     }
203 
204     function hasEnough(address key, uint256 amount) constant returns(bool) {
205         Deposit storage deposit = records[key];
206         return deposit.amount >= amount;
207     }
208 
209     function spend(address key, uint256 amount) onlyDaoOrOwner {
210         require(isRegistered(key));
211         records[key].amount = records[key].amount.sub(amount);
212     }
213 
214     function refill(address key, uint256 amount) onlyDaoOrOwner {
215         require(isRegistered(key));
216         records[key].amount = records[key].amount.add(amount);
217     }
218 
219     function kill() onlyOwner {
220         selfdestruct(owner);
221     }
222 }
223 
224 contract SecurityDepositRegistry is DepositRegistryImpl{
225 
226 }