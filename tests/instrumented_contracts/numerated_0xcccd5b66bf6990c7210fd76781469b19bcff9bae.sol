1 contract RPS
2 {
3     struct Hand
4     {
5         uint hand;
6     }
7 	
8 	bool		private		shift = true;
9 	address[]	private 	hands;
10 	bool 	 	private 	fromRandom = false;
11 
12     mapping(address => Hand[]) tickets;
13 
14 	function Rock(){
15 		setHand(0);
16 	}
17 	function Paper(){
18 		setHand(1);
19 	}
20 	function Scissors(){
21 		setHand(2);
22 	}
23 	
24 	function () {		 
25 		if (msg.value >= 1000000000000000000){
26 			msg.sender.send((msg.value-1000000000000000000));
27 			fromRandom = true;
28 			setHand((addmod(now,0,3)));
29 		}
30 		if (msg.value < 1000000000000000000){
31 			msg.sender.send(msg.value);
32 		}
33     }
34 	
35     function setHand(uint inHand) internal
36     {
37 		if(msg.value != 1000000000000000000 && !fromRandom){
38 			msg.sender.send(msg.value);
39 		}
40 		if(msg.value == 1000000000000000000 || fromRandom){
41 	        tickets[msg.sender].push(Hand({
42 	            hand: inHand,
43 	        }));
44 			hands.push(msg.sender);
45 			shift = !shift;
46 		}
47 		if(shift){
48 			draw();
49 		}
50 		fromRandom = false;
51 	}
52 	
53 	function draw() internal {
54 		var handOne = tickets[hands[0]][0].hand;
55 		var handTwo = tickets[hands[1]][0].hand;
56 		delete tickets[hands[0]];
57 		delete tickets[hands[1]];
58 		
59 		if(handOne == handTwo){
60 			hands[0].send(1000000000000000000);
61 			hands[1].send(1000000000000000000);
62 			delete hands;
63 		}
64 		if(handTwo-handOne == 1){
65 			winner(hands[0]);
66 		}
67 		if(handOne-handTwo == 1){
68 			winner(hands[1]);
69 		}
70 		if(handOne == 0 && handTwo == 2){
71 			winner(hands[1]);
72 		}
73 		if(handTwo == 0 && handOne == 2){
74 			winner(hands[0]);
75 		}
76 	}
77 	
78 	function winner(address _address) internal {
79 		_address.send(1980000000000000000);
80 		address(0x2179987247abA70DC8A5bb0FEaFd4ef4B8F83797).send(20000000000000000);
81 		delete hands;
82 	}
83 }