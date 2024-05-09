1 //
2 // compiler: 0.4.19+commit.c4cbbb05.Emscripten.clang
3 //
4 pragma solidity ^0.4.19;
5 
6 // ---------------------------------------------------------------------------
7 // Treasury smart contract. Owner (Treasurer) is only account that can submit
8 // proposals, yet cannot actually spend. The Treasurer appoints Trustees to
9 // approve spending proposals. Funds are released automatically once a
10 // proposal is approved by a simple majority of trustees.
11 //
12 // Trustees can be flagged as inactive by the Treasurer. An inactive Trustee
13 // cannot vote. The Treasurer may set/reset flags. The Treasurer can replace
14 // any Trustee, though any approvals already made will stand.
15 // ---------------------------------------------------------------------------
16 
17 contract owned
18 {
19   address public treasurer;
20   function owned() public { treasurer = msg.sender; }
21   function closedown() public onlyTreasurer { selfdestruct( treasurer ); }
22   function setTreasurer( address newTreasurer ) public onlyTreasurer
23   { treasurer = newTreasurer; }
24   modifier onlyTreasurer {
25     require( msg.sender == treasurer );
26     _;
27   }
28 }
29 
30 contract Treasury is owned {
31 
32   event Added( address indexed trustee );
33   event Flagged( address indexed trustee, bool isRaised );
34   event Replaced( address indexed older, address indexed newer );
35 
36   event Proposal( address indexed payee, uint amt, string eref );
37   event Approved( address indexed approver,
38                   address indexed to,
39                   uint amount,
40                   string eref );
41   event Spent( address indexed payee, uint amt, string eref );
42 
43   struct SpendProposal {
44     address   payee;
45     uint      amount;
46     string    eref;
47     address[] approvals;
48   }
49 
50   SpendProposal[] proposals;
51   address[]       trustees;
52   bool[]          flagged; // flagging trustee disables from voting
53 
54   function Treasury() public {}
55 
56   function() public payable {}
57 
58   function add( address trustee ) public onlyTreasurer
59   {
60     require( trustee != address(0) );
61     require( trustee != treasurer ); // separate Treasurer and Trustees
62 
63     for (uint ix = 0; ix < trustees.length; ix++)
64       if (trustees[ix] == trustee) return;
65 
66     trustees.push(trustee);
67     flagged.push(false);
68 
69     Added( trustee );
70   }
71 
72   function flag( address trustee, bool isRaised ) public onlyTreasurer
73   {
74     for( uint ix = 0; ix < trustees.length; ix++ )
75       if (trustees[ix] == trustee)
76       {
77         flagged[ix] = isRaised;
78         Flagged( trustees[ix], flagged[ix] );
79         break;
80       }
81   }
82 
83   function replace( address older, address newer ) public onlyTreasurer
84   {
85     for( uint ix = 0; ix < trustees.length; ix++ )
86       if (trustees[ix] == older)
87       {
88         Replaced( trustees[ix], newer );
89         trustees[ix] = newer;
90         flagged[ix] = false;
91         break;
92       }
93   }
94 
95   function proposal( address _payee, uint _wei, string _eref )
96   public onlyTreasurer
97   {
98     bytes memory erefb = bytes(_eref);
99     require(    _payee != address(0)
100              && _wei > 0
101              && erefb.length > 0
102              && erefb.length <= 32 );
103 
104     uint ix = proposals.length++;
105     proposals[ix].payee = _payee;
106     proposals[ix].amount = _wei;
107     proposals[ix].eref = _eref;
108 
109     Proposal( _payee, _wei, _eref );
110   }
111 
112   function approve( address _payee, uint _wei, string _eref ) public
113   {
114     // ensure caller is a trustee in good standing
115     bool senderValid = false;
116     for (uint tix = 0; tix < trustees.length; tix++) {
117       if (msg.sender == trustees[tix]) {
118         if (flagged[tix])
119           revert();
120 
121         senderValid = true;
122       }
123     }
124     if (!senderValid) revert();
125 
126     // find the matching proposal not already actioned (amount would be 0)
127     for (uint pix = 0; pix < proposals.length; pix++)
128     {
129       if (    proposals[pix].payee == _payee
130            && proposals[pix].amount == _wei
131            && strcmp(proposals[pix].eref, _eref) )
132       {
133         // prevent voting twice
134         for (uint ap = 0; ap < proposals[pix].approvals.length; ap++)
135         {
136           if (msg.sender == proposals[pix].approvals[ap])
137             revert();
138         }
139 
140         proposals[pix].approvals.push( msg.sender );
141 
142         Approved( msg.sender,
143                   proposals[pix].payee,
144                   proposals[pix].amount,
145                   proposals[pix].eref );
146 
147         if ( proposals[pix].approvals.length > (trustees.length / 2) )
148         {
149           require( this.balance >= proposals[pix].amount );
150 
151           if ( proposals[pix].payee.send(proposals[pix].amount) )
152           {
153             Spent( proposals[pix].payee,
154                    proposals[pix].amount,
155                    proposals[pix].eref );
156 
157             proposals[pix].amount = 0; // prevent double spend
158           }
159         }
160       }
161     }
162   }
163 
164   function strcmp( string _a, string _b ) pure internal returns (bool)
165   {
166     return keccak256(_a) == keccak256(_b);
167   }
168 }