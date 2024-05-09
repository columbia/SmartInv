1 //
2 // compiler: solcjs -o ./build --optimize --abi --bin <this file>
3 //  version: 0.4.18+commit.9cf6e910.Emscripten.clang
4 //
5 pragma solidity ^0.4.18;
6 
7 // ---------------------------------------------------------------------------
8 // Treasury smart contract. Owner (Treasurer) is only account that can submit
9 // proposals, yet cannot actually spend. The Treasurer appoints Trustees to
10 // approve spending proposals. Funds are released automatically once a
11 // proposal is approved by a simple majority of trustees.
12 //
13 // Trustees can be flagged as inactive by the Treasurer. An inactive Trustee
14 // cannot vote. The Treasurer may set/reset flags. The Treasurer can replace
15 // any Trustee, though any approvals already made will stand.
16 // ---------------------------------------------------------------------------
17 
18 contract owned
19 {
20   address public treasurer;
21   function owned() public { treasurer = msg.sender; }
22 
23   modifier onlyTreasurer {
24     require( msg.sender == treasurer );
25     _;
26   }
27 
28   function setTreasurer( address newTreasurer ) public onlyTreasurer
29   { treasurer = newTreasurer; }
30 
31   function closedown() public onlyTreasurer { selfdestruct( treasurer ); }
32 }
33 
34 contract Treasury is owned {
35 
36   event Added( address indexed trustee );
37   event Flagged( address indexed trustee, bool isRaised );
38   event Replaced( address indexed older, address indexed newer );
39 
40   event Proposal( address indexed payee, uint amt, string eref );
41   event Approved( address indexed approver,
42                   address indexed to,
43                   uint amount,
44                   string eref );
45   event Spent( address indexed payee, uint amt, string eref );
46 
47   struct SpendProposal {
48     address   payee;
49     uint      amount;
50     string    eref;
51     address[] approvals;
52   }
53 
54   SpendProposal[] proposals;
55   address[]       trustees;
56   bool[]          flagged; // flagging trustee disables from voting
57 
58   function Treasury() public {}
59 
60   function() public payable {}
61 
62   function add( address trustee ) public onlyTreasurer
63   {
64     require( trustee != treasurer ); // separate Treasurer and Trustees
65 
66     for (uint ix = 0; ix < trustees.length; ix++)
67       if (trustees[ix] == trustee) return;
68 
69     trustees.push(trustee);
70     flagged.push(false);
71 
72     Added( trustee );
73   }
74 
75   function flag( address trustee, bool isRaised ) public onlyTreasurer
76   {
77     for( uint ix = 0; ix < trustees.length; ix++ )
78       if (trustees[ix] == trustee)
79       {
80         flagged[ix] = isRaised;
81         Flagged( trustees[ix], flagged[ix] );
82       }
83   }
84 
85   function replace( address older, address newer ) public onlyTreasurer
86   {
87     for( uint ix = 0; ix < trustees.length; ix++ )
88       if (trustees[ix] == older)
89       {
90         Replaced( trustees[ix], newer );
91         trustees[ix] = newer;
92         flagged[ix] = false;
93       }
94   }
95 
96   function proposal( address _payee, uint _wei, string _eref )
97   public onlyTreasurer
98   {
99     bytes memory erefb = bytes(_eref);
100     require(    _payee != address(0)
101              && _wei > 0
102              && erefb.length > 0
103              && erefb.length <= 32 );
104 
105     uint ix = proposals.length++;
106     proposals[ix].payee = _payee;
107     proposals[ix].amount = _wei;
108     proposals[ix].eref = _eref;
109 
110     Proposal( _payee, _wei, _eref );
111   }
112 
113   function approve( address _payee, uint _wei, string _eref ) public
114   {
115     // ensure caller is a trustee in good standing
116     bool senderValid = false;
117     for (uint tix = 0; tix < trustees.length; tix++) {
118       if (msg.sender == trustees[tix]) {
119         if (flagged[tix])
120           revert();
121 
122         senderValid = true;
123       }
124     }
125     if (!senderValid) revert();
126 
127     // find the matching proposal not already actioned (amount would be 0)
128     for (uint pix = 0; pix < proposals.length; pix++)
129     {
130       if (    proposals[pix].payee == _payee
131            && proposals[pix].amount == _wei
132            && strcmp(proposals[pix].eref, _eref) )
133       {
134         // prevent voting twice
135         for (uint ap = 0; ap < proposals[pix].approvals.length; ap++)
136         {
137           if (msg.sender == proposals[pix].approvals[ap])
138             revert();
139         }
140 
141         proposals[pix].approvals.push( msg.sender );
142 
143         Approved( msg.sender,
144                   proposals[pix].payee,
145                   proposals[pix].amount,
146                   proposals[pix].eref );
147 
148         if ( proposals[pix].approvals.length > (trustees.length / 2) )
149         {
150           require( this.balance >= proposals[pix].amount );
151 
152           if ( proposals[pix].payee.send(proposals[pix].amount) )
153           {
154             Spent( proposals[pix].payee,
155                    proposals[pix].amount,
156                    proposals[pix].eref );
157 
158             proposals[pix].amount = 0; // prevent double spend
159           }
160         }
161       }
162     }
163   }
164 
165   function strcmp( string _a, string _b ) pure internal returns (bool)
166   {
167     return keccak256(_a) == keccak256(_b);
168   }
169 }