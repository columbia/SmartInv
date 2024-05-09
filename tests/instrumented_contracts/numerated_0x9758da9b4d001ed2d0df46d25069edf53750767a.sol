1 contract Etheramid {
2 
3     struct Participant {
4         address inviter;
5         address itself;
6         uint totalPayout;
7     }
8     
9     mapping (address => Participant) Tree;
10     mapping (uint => address) Index;
11 	
12 	uint Count = 0;
13     address top;
14     uint constant contribution = 1 ether;
15  
16     function Etheramid() {
17         addParticipant(msg.sender,msg.sender);
18         top = msg.sender;
19     }
20     
21     function() {
22 		uint rand = uint(msg.sender) % Count;
23         enter(Index[rand]);
24     }
25     
26     function getParticipantById (uint id) constant public returns ( address inviter, address itself, uint totalPayout ){
27 		if (id >= Count) return;
28 		address ida = Index[id];
29         inviter = Tree[ida].inviter;
30         itself = Tree[ida].itself;
31         totalPayout = Tree[ida].totalPayout;
32     }
33 	function getParticipantByAddress (address adr) constant public returns ( address inviter, address itself, uint totalPayout ){
34 		if (Tree[adr].itself == 0x0) return;
35         inviter = Tree[adr].inviter;
36         itself = Tree[adr].itself;
37         totalPayout = Tree[adr].totalPayout;
38     }
39     
40     function addParticipant(address itself, address inviter) private{
41         Index[Count] = itself;
42 		Tree[itself] = Participant( {itself: itself, inviter: inviter, totalPayout: 0});
43         Count +=1;
44     }
45     
46     function getParticipantCount () public constant returns ( uint count ){
47        count = Count;
48     }
49     
50     function enter(address inviter) public {
51         uint amount = msg.value;
52         if ((amount < contribution) || (Tree[msg.sender].inviter != 0x0) || (Tree[inviter].inviter == 0x0)) {
53             msg.sender.send(msg.value);
54             return;
55         }
56         
57         addParticipant(msg.sender, inviter);
58         address next = inviter;
59         uint rest = amount;
60         uint level = 1;
61         while ( (next != top) && (level < 7) ){
62             uint toSend = rest/2;
63             next.send(toSend);
64             Tree[next].totalPayout += toSend;
65             rest -= toSend;
66             next = Tree[next].inviter;
67             level++;
68         }
69         next.send(rest);
70 		Tree[next].totalPayout += rest;
71     }
72 }