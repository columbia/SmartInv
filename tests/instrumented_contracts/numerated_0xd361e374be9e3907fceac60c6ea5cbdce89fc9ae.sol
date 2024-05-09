1 contract Highlander {
2 
3   struct Contestant {
4       address etherAddress;
5   }
6 
7   Contestant[] public contestant;
8 
9   uint public PreviousTime;
10   uint public CurrentTime;
11   uint public active = 1;
12   uint public Current_balance = 0;
13   address public owner;
14 
15   modifier onlyowner { if (msg.sender == owner) _ }
16 
17 
18   function Highlander() {
19     owner = msg.sender;
20   }
21 
22   function() {
23     enter();
24   }
25   
26   function enter() {
27 
28   	if(msg.value != 5 ether){
29 		msg.sender.send(msg.value);
30 		return;
31 	}
32 	
33 	uint idx = contestant.length;
34     contestant.length += 1;
35     contestant[idx].etherAddress = msg.sender;
36 
37 	owner.send(msg.value / 10);
38 	Current_balance = this.balance;
39 	CurrentTime = now;
40  
41 	if(idx == 0){
42 	PreviousTime = now;
43 	return;
44 	}
45 	
46 	if(CurrentTime - PreviousTime > 1 days){
47 
48 	contestant[idx-1].etherAddress.send(this.balance - 5 ether);
49 	PreviousTime = CurrentTime;
50 
51 	} else
52 		{
53 		PreviousTime = CurrentTime;
54 		}
55 
56 	Current_balance = this.balance;		
57 	}
58 	
59   function kill(){
60   if(msg.sender == owner && this.balance <= 5) {
61   active = 0;
62   suicide(owner);
63   
64   }
65   }
66   function setOwner(address _owner) onlyowner {
67       owner = _owner;
68   }	
69 
70    // for website
71       function CT() constant returns (uint CurrTime) {
72         CurrTime = CurrentTime;
73     }
74       function PT() constant returns (uint PrevTime) {
75         PrevTime = PreviousTime;
76     }
77       function bal() constant returns (uint WebBal) {
78         WebBal = Current_balance;
79     }	
80 	
81 }