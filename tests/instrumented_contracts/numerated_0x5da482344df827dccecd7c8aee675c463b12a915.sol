1 pragma solidity ^0.4.18;
2 
3 //Standart full ECR20 contract interface
4 contract ERC20
5 {
6     string public name;
7     string public symbol;
8     uint8 public constant decimals = 18;
9     
10     constructor(string _name, string _symbol) public 
11     {
12         name = _name;
13         symbol = _symbol;
14     }
15     
16     function totalSupply() public view returns (uint256);
17     function balanceOf(address who) public view returns (uint256);
18     function transfer(address to, uint256 value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     
21     function allowance(address owner, address spender) public view returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     
26 }
27 
28 //Contract for check ownership
29 contract Ownable
30 {
31     address internal owner;
32         
33     constructor() public 
34     {
35         owner = msg.sender;
36     }
37     
38     modifier onlyOwner() 
39     {
40         require(msg.sender == owner);
41         _;
42     }
43     
44     modifier onlyNotOwner()
45     {
46         require(msg.sender != owner);
47         _;
48     }
49 }
50 
51 //Contract for check Issuers
52 contract Issuable is Ownable
53 {
54     mapping (address => bool) internal issuers;
55     
56     event IssuerAdd(address who);
57     event IssuerRemoved(address who);
58     
59     function addIssuer(address who) onlyOwner public
60     {
61         require(who != owner); // do not allow add owner to issuers list
62         require(!issuers[who]);
63         issuers[who] = true;
64         emit IssuerAdd(who);
65     }
66     
67     function removeIssuer(address who) onlyOwner public
68     {
69         require(issuers[who]);
70         issuers[who] = false;
71         emit IssuerRemoved(who);
72     }
73     
74     modifier onlyIssuer()
75     {
76         require(issuers[msg.sender]);
77         _;
78     }
79     
80     function IsIssuer(address who) public view onlyOwner returns(bool)
81     {
82         return issuers[who];
83     }
84 }
85 
86 //Contract for check time limits of ICO
87 contract TimeLimit
88 {
89     uint256 public ICOStart;// = 1521198000; //UnixTime gmt
90     uint256 public ICOEnd;// = 1521208800; //UnixTime gmt
91     uint256 public TransferStart;// = 1521212400; //UnixTime gmt
92     
93     bool internal ICOEnable;
94     bool internal TransferEnable;
95     
96     event ICOStarted();
97     event ICOEnded();
98     event TrasferEnabled();
99     
100     modifier onlyInIssueTime()
101     {
102         require(IsIssueTime());
103         //require(now > ICOStart);
104         //require(now <= TransferStart); //We need time to issue last transactions in other money
105         if (!ICOEnable && now <= ICOEnd)
106         {
107             emit ICOStarted();
108             ICOEnable = true;
109         }
110         if (ICOEnable && now > ICOEnd)
111         {
112             emit ICOEnded();
113             ICOEnable = false;
114         }
115         _;
116     }
117     
118     modifier transferEnable()
119     {
120         require(now > TransferStart);
121         if (!TransferEnable)
122         {
123             emit TrasferEnabled();
124             TransferEnable = true;
125         }
126         _;
127     }
128     
129     modifier closeCheckICO()
130     {
131         if (now > TransferStart) 
132         {
133             closeICO();
134             return;
135         }
136         _;
137     }
138     
139     function IsIssueTime() public view returns(bool)
140     {
141         return (now > ICOStart && now <= TransferStart);
142     }
143     
144     function IsIcoTime() public view returns(bool)
145     {
146         return (now > ICOStart && now <= ICOEnd);
147     }
148     
149     function IsTransferEnable() public view returns(bool)
150     {
151         return (now > TransferStart);
152     }
153     
154     function closeICO() internal;
155 }
156 
157 //Main contract
158 contract OurContract is ERC20, Issuable, TimeLimit
159 {
160     event Cause(address to, uint256 val, uint8 _type, string message);
161     
162     //Public token user functions
163     function transfer(
164         address to, uint256 value
165         ) transferEnable public returns (bool)
166     {
167         return _transfer(msg.sender, to, value);
168     }
169     
170     function transferFrom(
171         address from, address to, uint256 value
172         ) transferEnable public returns (bool) 
173     {
174         require(value <= allowances[from][msg.sender]);
175         _transfer(from, to, value);
176         allowances[from][msg.sender] = allowances[from][msg.sender] - value;
177         return true;
178     }
179     
180     function approve(
181         address spender, uint256 value
182         ) public onlyNotOwner returns (bool)
183     {
184         allowances[msg.sender][spender] = value;
185         emit Approval(msg.sender, spender, value);
186         return true;
187     }
188     
189     //Public views
190     function totalSupply() public view returns (uint256) 
191     {
192         return totalSupply_;
193     }
194     
195     function balanceOf(address owner_) public view returns (uint256 balance) 
196     {
197         return balances[owner_];
198     }
199     
200     function allowance(
201         address owner_, address spender
202         ) public view returns (uint256) 
203     {
204         return allowances[owner_][spender];
205     }
206     
207     //Public issuers function
208     function issue(
209         address to, uint256 value, uint8 _type, string message
210         ) onlyIssuer onlyInIssueTime closeCheckICO public
211     {
212         require(to != owner);
213         require(!issuers[to]);
214         _transfer(owner, to, value);
215         emit Cause(to, value, _type, message);
216     }
217     
218     //Public owner functions
219     //Constructor
220     constructor(
221         string _name, string _symbol
222         ) public 
223         ERC20(_name, _symbol)
224     {
225         totalSupply_ = 300000000000000000000000000; //With 18 zeros at end //1 000 000 000 000000000000000000;
226         ICOStart = 1537747200; //UnixTime gmt
227         ICOEnd = 1564531200; //UnixTime gmt
228         TransferStart = 1565308800; //UnixTime gmt
229         balances[msg.sender] = totalSupply_;
230     }
231     
232     function endICO() onlyOwner closeCheckICO public returns(bool)
233     {
234         return (now > ICOEnd);
235     }
236     
237     //addIssuer from Issuable
238     //removeIssuer from Issuable
239     
240     //Internal variables
241     uint256 internal totalSupply_;
242     mapping (address => uint256) internal balances;
243     mapping (address => mapping (address => uint256)) internal allowances;
244     
245     //Internal functions
246     function _transfer(
247         address from, address to, uint256 value
248         ) onlyNotOwner internal returns (bool) 
249     {
250         require(to != address(0));
251         require(value <= balances[from]);
252         require(value + balances[to] > balances[to]);
253 
254         balances[from] = balances[from] - value;
255         balances[to] = balances[to] + value;
256         emit Transfer(from, to, value);
257         return true;
258     }
259     
260     function closeICO() internal
261     {
262         totalSupply_ -= balances[owner];
263         balances[owner] = 0;
264         owner = 0;
265     }
266 }