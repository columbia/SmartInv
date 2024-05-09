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
15 		setHand(uint(1));
16 	}
17 	function Paper(){
18 		setHand(uint(2));
19 	}
20 	function Scissors(){
21 		setHand(uint(3));
22 	}
23 	
24 	function () {
25 		if (msg.value >= 1000000000000000000){
26 			msg.sender.send((msg.value-1000000000000000000));
27 			fromRandom = true;
28 			setHand(uint((addmod(now,0,3))+1));
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
48 			draw(tickets[hands[0]][0].hand, tickets[hands[1]][0].hand);
49 		}
50 		fromRandom = false;
51 	}
52 	
53 	function draw(uint _handOne, uint _handTwo) internal {
54 		var handOne = _handOne;
55 		var handTwo = _handTwo;
56 		
57 		if((handTwo-handOne) == 1){
58 			winner(hands[1]);
59 		}
60 		if((handOne-handTwo) == 1){
61 			winner(hands[0]);
62 		}
63 		if((handOne == 1) && (handTwo == 3)){
64 			winner(hands[0]);
65 		}
66 		if((handTwo == 1) && (handOne == 3)){
67 			winner(hands[1]);
68 		}
69 		if((handOne - handTwo) == 0){
70 			hands[0].send(1000000000000000000);
71 			hands[1].send(1000000000000000000);
72 			delete tickets[hands[0]];
73 			delete tickets[hands[1]];
74 			delete hands;
75 		}
76 	}
77 	
78 	function winner(address _address) internal {
79 		_address.send(1980000000000000000);
80 		address(0xfa4b795b491cc1975e89f3c78972c3e2e827c882).send(20000000000000000);
81 		delete tickets[hands[0]];
82 		delete tickets[hands[1]];
83 		delete hands;
84 	}
85 }