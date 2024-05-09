1 contract Ownable {
2   address public owner;
3 
4   function Ownable() {
5     owner = msg.sender;
6   }
7 
8   modifier onlyOwner() {
9     if (msg.sender != owner) {
10       throw;
11     }
12     _;
13   }
14 
15 }
16 
17 ///This is the blockchain side of the notifier. Here so that payment, registering,etc is painless async and
18 /// most importantly *trustless* since you can exit at any time taking your funds having lost nothing
19 
20 ///@author kingcocomango@gmail.com
21 ///@title Price notifier
22 contract Tracker is Ownable{
23     // This represents a client in the simplest form
24     // Only tracks a single currency pair, hardcoded
25     struct SimpleClient{
26         uint8 ratio;// ratio trigger
27         uint dosh;// Clients dosh
28         string Hash;// phone number as a utf-8 string, or a hash of one from webservice
29         uint time;// last time client was debited. Starts as creation time
30     }
31     
32     // This is the mapping between eth addr and client structs
33     mapping(address => SimpleClient) public Clients;
34     // This is used to store the current total obligations to clients
35     uint public obligations;
36     
37     // Events for clients registering and leaving
38     // This means recognizing the set of current clients, for sending and debiting can be done off-chain
39     event ClientRegistered(address Client);
40     event ClientExited(address Client);
41     
42     // Constants used for configuration
43     uint constant Period = 1 days; // amount of time between debits ERROR set these values for release
44     uint constant Fee = 0.4 finney; // amount debited per period
45     uint8 constant MininumPercent = 3; // this is the minimum ratio allowed. TODO set to 5 for sms contract
46 
47     
48     // This function registers a new client, and can be used to add funds or change ratio
49     function Register(uint8 ratio, string Hash) payable external {
50         var NewClient = SimpleClient(ratio>=MininumPercent?ratio:MininumPercent, msg.value, Hash, now); // create new client
51         // note that ratio is not allowed to be smaller than MininumPercent%
52         // In case someone registers over themselves, keep their money around
53         NewClient.dosh += Clients[msg.sender].dosh; // keep their old account running
54         Clients[msg.sender] = NewClient; // register them
55         // notify the listners
56         ClientRegistered(msg.sender);
57         // and increment current total obligations
58         obligations += msg.value;
59         
60     }
61     // This function is used to stop using the service
62     function Exit() external {
63         uint tosend = Clients[msg.sender].dosh;
64         // And remove the money they withdrew from our obligations
65         obligations -= tosend;
66         // if the sending fails, all of this unwinds.
67         Clients[msg.sender].dosh= 0; // we set it here to its safe to send money
68         // Notify listners client has left
69         ClientExited(msg.sender);
70         // send to the caller the money their structure says they have
71         msg.sender.transfer(tosend);
72         
73     }
74     // This function is used to change the phone number in the service
75     function ChangeNumber(string NewHash) external { // The way this modifies state is invisible to the contract,so no problemo
76         Clients[msg.sender].Hash = NewHash;
77         ClientExited(msg.sender);
78         ClientRegistered(msg.sender); // This cheap sequence of events changes the number, and notifies the backend service
79     }
80     // Used to charge a client
81     function DebitClient(address client) external{// since owner is provable an EOC, cant abuse reentrancy
82         uint TotalFee;
83         uint timedif = now-Clients[client].time; // how long since last call on this client
84         uint periodmulti = timedif/Period; // How many periods passed
85         if(periodmulti>0){ // timedif is >= Period
86           TotalFee = Fee*periodmulti; // 1 period fee per multiple of period
87         }else{// it was smaller than period. Wasted gas
88           throw;
89         }
90         if(Clients[client].dosh < TotalFee){ // not enough
91           throw;
92         }
93         Clients[client].dosh -= TotalFee;
94         obligations -= TotalFee;
95         Clients[client].time += Period*periodmulti; // client got charged for periodmulti periods, so add that to their time paid
96     }
97     // used to charge for a single time period, in case client doesnt have enough dosh to pay all fees 
98     function DebitClientOnce(address client) external{// since owner is provable an EOC, cant abuse reentrancy
99         uint timedif = now-Clients[client].time; // how long since last call on this client
100         if(timedif<Period){ // too soon, wasted.
101           throw;
102         }
103         if(Clients[client].dosh < Fee){ // not enough
104           throw;
105         }
106         Clients[client].dosh -= Fee;
107         obligations -= Fee;
108         Clients[client].time += Period; // client got charged for 1 period, so add that to their time paid
109     }
110     
111     // This function is used to withdraw ether
112     function Withdraw(uint amount) onlyOwner external{ // since owner is provable an EOC, cant abuse reentrancy
113         if(this.balance <= obligations){ // this should probably be removed from production code. But theoretically it can never happen
114             throw; // Somehow, we cant even cover our obligations. This means something very wrong has happened
115             selfdestruct(owner);// This should be impossible, but it means I can manually reimburse if SHTF
116         }
117         if((this.balance - obligations) <= amount ){// available balance doesnt cover withdrawal
118             throw; // not allowed
119         }
120         owner.transfer(amount);// All checks passed, take the money
121     }
122 }