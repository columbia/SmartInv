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
17 
18 ///This is the blockchain side of the notifier. Here so that payment, registering,etc is painless async and
19 /// most importantly *trustless* since you can exit at any time taking your funds having lost nothing
20 
21 ///@author kingcocomango@gmail.com
22 ///@title Price notifier
23 contract Tracker is Ownable{
24     // This represents a client in the simplest form
25     // Only tracks a single currency pair, hardcoded
26     struct SimpleClient{
27         uint8 ratio;// ratio trigger
28         uint dosh;// Clients dosh
29         string Hash;// phone number as a utf-8 string, or a hash of one from webservice
30         uint time;// last time client was debited. Starts as creation time
31     }
32     
33     // This is the mapping between eth addr and client structs
34     mapping(address => SimpleClient) public Clients;
35     // This is used to store the current total obligations to clients
36     uint public obligations;
37     
38     // Events for clients registering and leaving
39     // This means recognizing the set of current clients, for sending and debiting can be done off-chain
40     event ClientRegistered(address Client);
41     event ClientExited(address Client);
42     
43     // Constants used for configuration
44     uint constant Period = 1 days; // amount of time between debits ERROR set these values for release
45     uint constant Fee = 1 finney; // amount debited per period
46     uint8 constant MininumPercent = 5; // this is the minimum ratio allowed. TODO set to 5 for sms contract
47 
48     
49     // This function registers a new client, and can be used to add funds or change ratio
50     function Register(uint8 ratio, string Hash) payable external {
51         var NewClient = SimpleClient(ratio>=MininumPercent?ratio:MininumPercent, msg.value, Hash, now); // create new client
52         // note that ratio is not allowed to be smaller than MininumPercent%
53         // In case someone registers over themselves, keep their money around
54         NewClient.dosh += Clients[msg.sender].dosh; // keep their old account running
55         Clients[msg.sender] = NewClient; // register them
56         // notify the listners
57         ClientRegistered(msg.sender);
58         // and increment current total obligations
59         obligations += msg.value;
60         
61     }
62     // This function is used to stop using the service
63     function Exit() external {
64         uint tosend = Clients[msg.sender].dosh;
65         // And remove the money they withdrew from our obligations
66         obligations -= tosend;
67         // if the sending fails, all of this unwinds.
68         Clients[msg.sender].dosh= 0; // we set it here to its safe to send money
69         // Notify listners client has left
70         ClientExited(msg.sender);
71         // send to the caller the money their structure says they have
72         msg.sender.transfer(tosend);
73         
74     }
75     // This function is used to change the phone number in the service
76     function ChangeNumber(string NewHash) external { // The way this modifies state is invisible to the contract,so no problemo
77         Clients[msg.sender].Hash = NewHash;
78         ClientExited(msg.sender);
79         ClientRegistered(msg.sender); // This cheap sequence of events changes the number, and notifies the backend service
80     }
81     // Used to charge a client
82     function DebitClient(address client) external{// since owner is provable an EOC, cant abuse reentrancy
83         uint TotalFee;
84         uint timedif = now-Clients[client].time; // how long since last call on this client
85         uint periodmulti = timedif/Period; // How many periods passed
86         if(periodmulti>0){ // timedif is >= Period
87           TotalFee = Fee*periodmulti; // 1 period fee per multiple of period
88         }else{// it was smaller than period. Wasted gas
89           throw;
90         }
91         if(Clients[client].dosh < TotalFee){ // not enough
92           throw;
93         }
94         Clients[client].dosh -= TotalFee;
95         obligations -= TotalFee;
96         Clients[client].time += Period*periodmulti; // client got charged for periodmulti periods, so add that to their time paid
97     }
98     // used to charge for a single time period, in case client doesnt have enough dosh to pay all fees 
99     function DebitClientOnce(address client) external{// since owner is provable an EOC, cant abuse reentrancy
100         uint timedif = now-Clients[client].time; // how long since last call on this client
101         if(timedif<Period){ // too soon, wasted.
102           throw;
103         }
104         if(Clients[client].dosh < Fee){ // not enough
105           throw;
106         }
107         Clients[client].dosh -= Fee;
108         obligations -= Fee;
109         Clients[client].time += Period; // client got charged for 1 period, so add that to their time paid
110     }
111     
112     // This function is used to withdraw ether
113     function Withdraw(uint amount) onlyOwner external{ // since owner is provable an EOC, cant abuse reentrancy
114         if(this.balance <= obligations){ // this should probably be removed from production code. But theoretically it can never happen
115             throw; // Somehow, we cant even cover our obligations. This means something very wrong has happened
116             selfdestruct(owner);// This should be impossible, but it means I can manually reimburse if SHTF
117         }
118         if((this.balance - obligations) <= amount ){// available balance doesnt cover withdrawal
119             throw; // not allowed
120         }
121         owner.transfer(amount);// All checks passed, take the money
122     }
123 }