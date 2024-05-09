1 pragma solidity ^0.4.24;
2 /*
3  * @title -Jekyll Island- CORP BANK FORWARDER v0.4.6
4  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
5  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
6  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
7  *                                  _____                      _____
8  *                                 (, /     /)       /) /)    (, /      /)          /)
9  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
10  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
11  *          ┴ ┴                /   /          .-/ _____   (__ /                               
12  *                            (__ /          (_/ (, /                                      /)™ 
13  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
14  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
15  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
16  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
17  *====/$$$$$===========/$$=================/$$ /$$====/$$$$$$===========/$$===========================/$$=*
18  *   |__  $$          | $$                | $$| $$   |_  $$_/          | $$                          | $$
19  *      | $$  /$$$$$$ | $$   /$$ /$$   /$$| $$| $$     | $$    /$$$$$$$| $$  /$$$$$$  /$$$$$$$   /$$$$$$$
20  *      | $$ /$$__  $$| $$  /$$/| $$  | $$| $$| $$     | $$   /$$_____/| $$ |____  $$| $$__  $$ /$$__  $$
21  * /$$  | $$| $$$$$$$$| $$$$$$/ | $$  | $$| $$| $$     | $$  |  $$$$$$ | $$  /$$$$$$$| $$  \ $$| $$  | $$
22  *| $$  | $$| $$_____/| $$_  $$ | $$  | $$| $$| $$     | $$   \____  $$| $$ /$$__  $$| $$  | $$| $$  | $$
23  *|  $$$$$$/|  $$$$$$$| $$ \  $$|  $$$$$$$| $$| $$    /$$$$$$ /$$$$$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$
24  * \______/  \_______/|__/  \__/ \____  $$|__/|__/   |______/|_______/ |__/ \_______/|__/  |__/ \_______/
25  *===============================/$$  | $$ Inc.  ╔═╗╔═╗╦═╗╔═╗  ╔╗ ╔═╗╔╗╔╦╔═  ┌─┐┌─┐┬─┐┬ ┬┌─┐┬─┐┌┬┐┌─┐┬─┐                                 
26  *                              |  $$$$$$/=======║  ║ ║╠╦╝╠═╝  ╠╩╗╠═╣║║║╠╩╗  ├┤ │ │├┬┘│││├─┤├┬┘ ││├┤ ├┬┘  
27  *                               \______/        ╚═╝╚═╝╩╚═╩    ╚═╝╩ ╩╝╚╝╩ ╩  └  └─┘┴└─└┴┘┴ ┴┴└──┴┘└─┘┴└─==*
28  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐                       
29  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │                      
30  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘                      
31  *===========================================================================================*
32  *                                ┌────────────────────┐
33  *                                │ Setup Instructions │
34  *                                └────────────────────┘
35  * (Step 1) import the Jekyll Island Inc Forwarder Interface into your contract
36  * 
37  *    import "./JIincForwarderInterface.sol";
38  *
39  * (Step 2) set it to point to the forwarder
40  * 
41  *    JIincForwarderInterface private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
42  *                                ┌────────────────────┐
43  *                                │ Usage Instructions │
44  *                                └────────────────────┘
45  * whenever your contract needs to send eth to the corp bank, simply use the 
46  * the following command:
47  *
48  *    Jekyll_Island_Inc.deposit.value(amount)()
49  * 
50  * OPTIONAL:
51  * if you need to be checking wither the transaction was successful, the deposit function returns 
52  * a bool indicating wither or not it was successful.  so another way to call this function 
53  * would be:
54  * 
55  *    require(Jekyll_Island_Inc.deposit.value(amount)() == true, "Jekyll Island deposit failed");
56  * 
57  */
58 
59 interface JIincInterfaceForForwarder {
60     function deposit(address _addr) external payable returns (bool);
61     function migrationReceiver_setup() external returns (bool);
62 }
63 
64 contract JIincForwarder {
65     string public name = "JIincForwarder";
66     JIincInterfaceForForwarder private currentCorpBank_;
67     address private newCorpBank_;
68     bool needsBank_ = true;
69     
70     constructor() 
71         public
72     {
73         //constructor does nothing.
74     }
75     
76     function()
77         public
78         payable
79     {
80         // done so that if any one tries to dump eth into this contract, we can
81         // just forward it to corp bank.
82         currentCorpBank_.deposit.value(address(this).balance)(address(currentCorpBank_));
83     }
84     
85     function deposit()
86         public 
87         payable
88         returns(bool)
89     {
90         require(msg.value > 0, "Forwarder Deposit failed - zero deposits not allowed");
91         require(needsBank_ == false, "Forwarder Deposit failed - no registered bank");
92         if (currentCorpBank_.deposit.value(msg.value)(msg.sender) == true)
93             return(true);
94         else
95             return(false);
96     }
97 //==============================================================================
98 //     _ _ . _  _ _ _|_. _  _   .
99 //    | | ||(_|| (_| | |(_)| |  .
100 //===========_|=================================================================    
101     function status()
102         public
103         view
104         returns(address, address, bool)
105     {
106         return(address(currentCorpBank_), address(newCorpBank_), needsBank_);
107     }
108 
109     function startMigration(address _newCorpBank)
110         external
111         returns(bool)
112     {
113         // make sure this is coming from current corp bank
114         require(msg.sender == address(currentCorpBank_), "Forwarder startMigration failed - msg.sender must be current corp bank");
115         
116         // communicate with the new corp bank and make sure it has the forwarder 
117         // registered 
118         if(JIincInterfaceForForwarder(_newCorpBank).migrationReceiver_setup() == true)
119         {
120             // save our new corp bank address
121             newCorpBank_ = _newCorpBank;
122             return (true);
123         } else 
124             return (false);
125     }
126     
127     function cancelMigration()
128         external
129         returns(bool)
130     {
131         // make sure this is coming from the current corp bank (also lets us know 
132         // that current corp bank has not been killed)
133         require(msg.sender == address(currentCorpBank_), "Forwarder cancelMigration failed - msg.sender must be current corp bank");
134         
135         // erase stored new corp bank address;
136         newCorpBank_ = address(0x0);
137         
138         return (true);
139     }
140     
141     function finishMigration()
142         external
143         returns(bool)
144     {
145         // make sure its coming from new corp bank
146         require(msg.sender == newCorpBank_, "Forwarder finishMigration failed - msg.sender must be new corp bank");
147 
148         // update corp bank address        
149         currentCorpBank_ = (JIincInterfaceForForwarder(newCorpBank_));
150         
151         // erase new corp bank address
152         newCorpBank_ = address(0x0);
153         
154         return (true);
155     }
156 //==============================================================================
157 //    . _ ._|_. _ |   _ _ _|_    _   .
158 //    || || | |(_||  _\(/_ | |_||_)  .  (this only runs once ever)
159 //==============================|===============================================
160     function setup(address _firstCorpBank)
161         external
162     {
163         require(needsBank_ == true, "Forwarder setup failed - corp bank already registered");
164         currentCorpBank_ = JIincInterfaceForForwarder(_firstCorpBank);
165         needsBank_ = false;
166     }
167 }