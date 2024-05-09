1 contract Etheramid1{
2 	function getParticipantById (uint id) constant public returns ( address inviter, address itself, uint totalPayout );
3 	function getParticipantCount () public constant returns ( uint count );
4 }
5 contract Etheramid2 {
6 
7     struct Participant {
8         address inviter;
9         address itself;
10         uint totalPayout;
11     }
12     
13     mapping (address => Participant) Tree;
14     mapping (uint => address) Index;
15 	
16 	uint Count = 0;
17     address public top;
18     uint constant contribution = 1 ether;
19 	
20  	Etheramid1 eth1 = Etheramid1(0x9758DA9B4D001Ed2d0DF46d25069Edf53750767a);
21 	uint oldUserCount = eth1.getParticipantCount();
22 	
23     function Etheramid2() {
24 		moveOldUser(0);
25 		top = Index[0];
26     }
27     
28     function() {
29 		throw;
30     }
31     
32 	function moveOldUser (uint id) public {
33 		address inviter; 
34 		address itself; 
35 		uint totalPayout;
36 		(inviter, itself, totalPayout) = eth1.getParticipantById(id);
37 		if ((Tree[itself].inviter != 0x0) || (id >= oldUserCount)) throw;
38 		addParticipant(inviter, itself, totalPayout);
39 	}
40 	
41     function getParticipantById (uint id) constant public returns ( address inviter, address itself, uint totalPayout ){
42 		if (id >= Count) throw;
43 		address ida = Index[id];
44         inviter = Tree[ida].inviter;
45         itself = Tree[ida].itself;
46         totalPayout = Tree[ida].totalPayout;
47     }
48 	
49 	function getParticipantByAddress (address adr) constant public returns ( address inviter, address itself, uint totalPayout ){
50 		if (Tree[adr].itself == 0x0) throw;
51         inviter = Tree[adr].inviter;
52         itself = Tree[adr].itself;
53         totalPayout = Tree[adr].totalPayout;
54     }
55     
56     function addParticipant(address inviter, address itself, uint totalPayout) private{
57         Index[Count] = itself;
58 		Tree[itself] = Participant( {itself: itself, inviter: inviter, totalPayout: totalPayout});
59         Count +=1;
60     }
61     
62     function getParticipantCount () public constant returns ( uint count ){
63        count = Count;
64     }
65     
66     function enter(address inviter) public {
67         uint amount = msg.value;
68         if ((amount < contribution) || (Tree[msg.sender].inviter != 0x0) || (Tree[inviter].inviter == 0x0)) {
69             msg.sender.send(msg.value);
70             throw;
71         }
72         
73         addParticipant(inviter, msg.sender, 0);
74         address next = inviter;
75         uint rest = amount;
76         uint level = 1;
77         while ( (next != top) && (level < 7) ){
78             uint toSend = rest/2;
79             next.send(toSend);
80             Tree[next].totalPayout += toSend;
81             rest -= toSend;
82             next = Tree[next].inviter;
83             level++;
84         }
85         next.send(rest);
86 		Tree[next].totalPayout += rest;
87     }
88 }